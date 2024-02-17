<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\BaseController;

Route::post('test', [BaseController::class, 'testEnd']);


Route::prefix('/chat')->group(function () {
    Route::post('/conversation', [BaseController::class, 'startConversation']);
    Route::post('/conversation/{conversation}', [BaseController::class, 'continueConversation']);
    Route::get('/conversation/{conversation}', [BaseController::class, 'getPartConversation']);
    Route::get('/conversation/{conversation}', [BaseController::class, 'getPartConversation']);
});


Route::prefix('/imagegeneration')->group(function () {
    Route::post('/generate', [BaseController::class, 'generateImage']);
    Route::post('/upscale', [BaseController::class, 'upscaleImage']);
    Route::post('/zoomin', [BaseController::class, 'zoomIn']);
    Route::post('/zoomOut', [BaseController::class, 'zoomOut']);
    Route::get('/getStatusJob/{job}', [BaseController::class, 'getStatusJob']);
    Route::get('/getResultJob/{job}', [BaseController::class, 'getResultJob']);
});


Route::post('/imageRecognition', [BaseController::class, 'recognizeImage']);
