<?php

namespace App\Http\Controllers;

use App\Http\Helpers\helper;
use App\Models\Conversation;
use App\Models\Job;
use GuzzleHttp\Client;
use GuzzleHttp\Exception\RequestException;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

class BaseController extends Controller
{
    public function testEnd()
    {
        $tokens = DB::connection('mysql')->select('select * from module_cdamp.tokens');

        return response()->json([
            'tokens' => $tokens
        ]);
    }

    public function startConversation(Request $request)
    {
        if (!helper::checkToken($request->header('x-api-token'))) {
            return helper::getErrorResponseByStatus('401');
        }

        $validator = Validator::make($request->all(), [
            'prompt' => 'required'
        ]);

        if ($validator->fails()) {
            return helper::getErrorResponseByStatus('400');
        }

        $new_conversation = new Conversation;
        $new_conversation->conversation_id = Str::random(30);
        $new_conversation->save();


        $client = new Client();
        $prompt = $request->get('prompt');

        try {
            $response1 = $client->post('http://localhost:8001/api/conversation',
                [
                    'json' => [
                        'conversationId' => $new_conversation->conversation_id
                    ]
                ]);
        } catch (RequestException $requestException) {
            if ($requestException->hasResponse()) {
                return helper::getErrorResponse($requestException);
            }
        }

        try {
            $response2 = $client->post('http://localhost:8001/api/conversation/' . $new_conversation->conversation_id,
                [
                    'form_params' => [
                        'text' => $prompt,
                    ]
                ]);
        } catch (RequestException $requestException) {
            if ($requestException->hasResponse()) {
                return helper::getErrorResponse($requestException);
            }
        }

        $data = json_decode($response2->getBody()->getContents());


        return response()->json([
            'conversation_id' => $new_conversation->conversation_id,
            'response' => $data->response,
            'is_final' => $data->is_final
        ]);
    }

    public function continueConversation(Request $request, Conversation $conversation)
    {
        if (!helper::checkToken($request->header('x-api-token'))) {
            return helper::getErrorResponseByStatus('401');
        }

        $validator = Validator::make($request->all(), [
            'prompt' => 'required',
        ]);
        if ($validator->fails()) {
            return helper::getErrorResponseByStatus('400');
        }

        $client = new Client();

        if (!$conversation->is_final) {
            try {
                $response1 = $client->get('http://localhost:8001/api/conversation/' . $conversation->conversation_id);
            } catch (RequestException $requestException) {
                if ($requestException->hasResponse()) {
                    return helper::getErrorResponse($requestException);
                }
            }
            $data = json_decode($response1->getBody()->getContents());
            if (str_contains($data, '<EOF>')) {
                $conversation->is_final = true;
                $conversation->save();
            } else {
                return helper::getErrorResponseByStatus('503');
            }
        }

        try {
            $response2 = $client->post('http://localhost:8001/api/conversation/' . $conversation->conversation_id,
                [
                    'form_params' => [
                        'text' => $request->get('prompt')
                    ]
                ]);
        } catch (RequestException $requestException) {
            if ($requestException->hasResponse()) {
                return helper::getErrorResponse($requestException);
            }
        }
        $conversation->is_final = false;
        $conversation->save();

        $data = json_decode($response2->getBody()->getContents());

        return \response()->json([
            'conversation_id' => $conversation->conversation_id,
            'response' => $data->response,
            'is_final' => $data->is_final
        ]);
    }

    public function getPartConversation(Request $request, Conversation $conversation)
    {
        if (!helper::checkToken($request->header('x-api-token'))) {
            return helper::getErrorResponseByStatus('401');
        }

        $client = new Client();

        try {
            $response = $client->get('http://localhost:8001/api/conversation/' . $conversation->conversation_id,
                [
                    'json' => [
                        'prompt' => $request->get('prompt')
                    ]
                ]);

        } catch (RequestException $requestException) {
            if ($requestException->hasResponse()) {
                return helper::getErrorResponse($requestException);
            }
        }

        $data = $response->getBody()->getContents();
        $final = false;

        if (preg_match(helper::$patternOfEOF, $data, $matches)) {
            if ($matches[1]) {
                $millis = ((int)$matches[1]);
                $final = true;
                helper::addUsage($millis, $request->header('x-api-token'), 1);
            }
        }

        if ($final) {
            $data = substr($data, 0, -15);
            $conversation->is_final = true;
            $conversation->save();
        }

        return \response()->json([
            'conversation_id' => $conversation->conversation_id,
            'response' => $data,
            'is_final' => $final,
        ]);
    }

    public function generateImage(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'text_prompt' => 'required'
        ]);

        if ($validator->fails()) {
            return helper::getErrorResponseByStatus('400');
        }

        if (!helper::checkToken($request->header('x-api-token'))) {
            return helper::getErrorResponseByStatus('401');
        }

        $client = new Client();

        try {
            $response = $client->post('http://localhost:8001/api/generate', [
                'form_params' => [
                    'text_prompt' => $request->get('text_prompt')
                ]
            ]);
        } catch (RequestException $requestException) {
            if ($requestException->hasResponse()) {
                return helper::getErrorResponse($requestException);
            }
        }

        $data = json_decode($response->getBody()->getContents());


        $job = Job::create([
            'job_id' => $data->job_id,
            'created_at' => Carbon::parse($data->started_at),
        ]);


        return \response()->json([
            'job_id' => $job->id,
            'started_at' => $job->created_at
        ]);
    }

    public function getStatusJob(Request $request, Job $job)
    {
        if (!helper::checkToken($request->header('x-api-token'))) {
            return helper::getErrorResponseByStatus('401');
        }

        $client = new Client();

        try {
            $response1 = $client->get("http://localhost:8001/api/status/$job->job_id");
        } catch (RequestException $requestException) {
            if ($requestException->hasResponse()) {
                return helper::getErrorResponse($requestException);
            }
        }

        $data = json_decode($response1->getBody()->getContents());

        $job->preview_url = $data->image_url;

        if (!$job->preview_local_url) {
            $path = 'uploads/' . Str::random(10) . '_img.jpg';
            $img = file_get_contents($data->image_url);
            Storage::disk('public')->put($path, $img);
            $job->preview_local_url = $path;
        }

        if ($data->progress == 100) {
            $job->is_final = true;
        }

        $job->save();

        return \response()->json([
            'status' => $data->status,
            'progress' => $data->progress,
            'image_url' => $data->image_url
        ]);

    }

    public function getResultJob(Request $request, Job $job)
    {
        if (!helper::checkToken($request->header('x-api-token'))) {
            return helper::getErrorResponseByStatus('401');
        }

        $client = new Client();

        try {
            $response = $client->get("http://localhost:8001/api/result/" . $job->job_id);
        } catch (RequestException $requestException) {
            if ($requestException->hasResponse()) {
                helper::getErrorResponse($requestException);
            }
        }
        $data = json_decode($response->getBody()->getContents());

        $job->is_final = true;
        $job->resource_id = $data->resource_id;
        $job->image_url = $data->image_url;
        $job->save();

        if (!$job->image_local_url) {
            $path = 'uploads' . Str::random(10) . '_img.jpg';
            $img = file_get_contents($data->image_url);
            Storage::disk('public')->put($path, $img);
            $job->image_local_url = $path;
            $job->save();
        }

        if ($data->finished_at) {
            $finished_at = Carbon::parse($data->finished_at);
            $seconds = $finished_at->diff($job->created_at)->s;
            $ms = ((int)$seconds * 1000);

            helper::addUsage($ms, $request->header('x-api-token'), 2);
        }

        return \response()->json([
            'resourse_id' => $data->resource_id,
            'image_url' => $data->image_url
        ]);
    }


    public function upscaleImage(Request $request)
    {
        if (!helper::checkToken($request->header('x-api-token'))) {
            return helper::getErrorResponseByStatus('400');
        }
        $validator = Validator::make($request->all(), [
            'resource_id' => 'required'
        ]);

        if ($validator->fails()) {
            return helper::getErrorResponseByStatus('400');
        }

        $client = new Client();

        try {
            $response = $client->post("http://localhost:8001/api/upscale", [

                'form_params' => [
                    'resource_id' => $request->get('resource_id')
                ]

            ]);
        } catch (RequestException $requestException) {
            if ($requestException->hasResponse()) {
                return helper::getErrorResponse($requestException);
            }
        }

        $data = json_decode($response->getBody()->getContents());

        Job::create([
            'job_id' => $data->job_id,
            'created_at' => $data->started_at,
        ]);

        return \response()->json([
            'job_id' => $data->job_id
        ]);
    }

    public function zoomIn(Request $request)
    {
        if (!helper::checkToken($request->header('x-api-token'))) {
            helper::getErrorResponseByStatus('401');
        }

        $validator = Validator::make($request->all(), [
            'resource_id' => 'required'
        ]);

        if ($validator->fails()) {
            return helper::getErrorResponseByStatus('400');
        }

        $client = new Client();

        try {
            $response = $client->post('http://localhost:8001/api/zoom/in', [
                'form_params' => [
                    'resource_id' => $request->get('resource_id')
                ]
            ]);
        } catch (RequestException $requestException) {
            if ($requestException->hasResponse()) {
                helper::getErrorResponse($requestException);
            }
        }

        $data = json_decode($response->getBody()->getContents());

        Job::create([
            'job_id' => $data->job_id,
            'created_at' => Carbon::parse($data->started_at),
        ]);

        return \response()->json([
            'job_id' => $data->job_id
        ]);
    }

    public function zoomOut(Request $request)
    {
        if (!helper::checkToken($request->header('x-api-token'))) {
            helper::getErrorResponseByStatus('401');
        }

        $validator = Validator::make($request->all(), [
            'resource_id' => 'required'
        ]);

        if ($validator->fails()) {
            return helper::getErrorResponseDataByStatus('400');
        }
        $client = new Client();

        try {
            $response = $client->post('http://localhost:8001/api/zoom/out', [
                'form_params' => [
                    'resource_id' => $request->get('resource_id')
                ]
            ]);

        } catch (RequestException $requestException) {
            if ($requestException->hasResponse()) {
                helper::getErrorResponse($requestException);
            }
        }

        $data = json_decode($response->getBody()->getContents());

        Job::create([
            'job_id' => $data->job_id,
            'created_at' => $data->started_at
        ]);

        return \response()->json([
            'job_id' => $data->job_id
        ]);
    }

    public function recognizeImage(Request $request)
    {
        if (!helper::checkToken($request->header('x-api-token'))) {
            return helper::getErrorResponseByStatus('401');
        }

        $validator = Validator::make($request->all(), [
            'image' => 'required|file'
        ]);

        if ($validator->fails()) {
            return helper::getErrorResponseByStatus('400');
        }

        $client = new Client();
        $image = $request->file('image');
        $multipart = [];
        $multipart[] = [
            'name' => 'image',
            'contents' => fopen($image->getRealPath(), 'r')
        ];

        $started = microtime(true);
        try {
            $response = $client->post('http://localhost:8001/api/recognize',
                [
                    'multipart' => $multipart
                ]
            );
        } catch (RequestException $requestException) {
            if ($requestException->hasResponse()) {
                return helper::getErrorResponse($requestException);
            }
        }
        $endtime = microtime(true);

        $seconds = round($endtime - $started, 3);
        $token = $request->header('x-api-token');
        $total = $seconds * 0.5;
        helper::addBills($seconds, $token, $total);

        $data = json_decode($response->getBody()->getContents());

        $custom_objects = [];
        $imagedata = getimagesize($image->path());
        $width = $imagedata[0];
        $height = $imagedata[1];


        foreach ($data->objects as $object) {
            $custom_objects[] = [
                'name' => $object->label,
                'probability' => $object->probability,
                'bounding_box' => [
                    'x' => $object->bounding_box->left,
                    'y' => $object->bounding_box->top,
                    'width' => ((int)$width) - $object->bounding_box->left - $object->bounding_box->right,
                    'height' => ((int)$height) - $object->bounding_box->top - $object->bounding_box->bottom,
                ]
            ];
        }
        return \response()->json([
            'objects' => $custom_objects
        ]);


    }
}
