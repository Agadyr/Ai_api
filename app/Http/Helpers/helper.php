<?php

namespace App\Http\Helpers;

use Illuminate\Support\Facades\DB;

class helper
{
    public static $patternOfEOF = '/<EOF> Заняло (\d+) мс/';


    public static function checkToken($tokenHeader)
    {
        $tokens = DB::connection('mysql')->select('select * from module_cdamp.tokens');
        $isValid = false;
        foreach ($tokens as $token) {
            if ($token->token == $tokenHeader) {
                $isValid = true;
            }
        }
        return $isValid;
    }

    public static function addUsage($ms, $tokenHeader,$serviceId)
    {
        $tokens = DB::connection('mysql')->select('select * from module_cdamp.tokens');
        $tokenTarget = null;
        foreach ($tokens as $token) {
            if ($token->token == $tokenHeader) {
                $tokenTarget = $token;
            }
        }
        $data = [
            'duration_in_ms' => $ms,
            'api_token_id' => $tokenTarget->id,
            'service_id' => $serviceId,
            'usage_started_at' => now(),
        ];

        DB::connection('mysql')->table('module_cdamp.service_usages')->insert($data);
    }

    public static function addBills($s, $tokenHeader, $total)
    {
        $tokens = DB::connection('mysql')->select('select * from module_cdamp.tokens');
        $tokenTarget = null;
        foreach ($tokens as $token){
            if ($token->token == $tokenHeader) {
                $tokenTarget = $token;
            }
        }
        $data = [
            'time' => $s,
            'total' => $total,
            'token' => $tokenTarget->id
        ];

        DB::connection('mysql')->table('module_cdamp.billings')->insert($data);
    }

    public static function getErrorResponseByStatus($status)
    {
        return response()->json(
            helper::getErrorResponseDataByStatus($status),$status);
    }
    public static function getErrorResponse($request)
    {
        $status = $request->getResponse()->getStatusCode();
        return response()->json(
            helper::getErrorResponseDataByStatus($status),$status,);
    }


    public static function getErrorResponseDataByStatus($status)
    {
        if ($status == '400') {
            return [
                "type" => "/problem/types/400",
                "title" => "Bad Request",
                "status" => 400,
                "detail" => "The request is invalid."
            ];
        } else if ($status == '401') {
            return [
                "type" => "/problem/types/401",
                "title" => "Unauthorized",
                "status" => 401,
                "detail" => "The header X-API-TOKEN is missing or invalid."
            ];
        } else if ($status == '403') {
            return [
                "type" => "/problem/types/403",
                "title" => "Quota Exceeded",
                "status" => 403,
                "detail" => "You have exceeded your quota."
            ];
        } else if ($status == '503') {
            return [
                "type" => "/problem/types/503",
                "title" => "Service Unavailable",
                "status" => 503,
                "detail" => "The service is currently unavailable."
            ];
        }
    }
}

