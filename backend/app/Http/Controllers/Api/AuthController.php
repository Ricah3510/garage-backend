<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Kreait\Firebase\Auth as FirebaseAuth;
use App\Models\Client;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    protected $firebaseAuth;

    public function __construct(FirebaseAuth $firebaseAuth)
    {
        $this->firebaseAuth = $firebaseAuth;
    }

    /**
     * Login avec Firebase Token
     */
    public function login(Request $request)
    {
        // Validation
        $validator = Validator::make($request->all(), [
            'firebase_token' => 'required|string',
            'fcm_token' => 'nullable|string'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            // Vérifier le token Firebase
            $verifiedIdToken = $this->firebaseAuth->verifyIdToken($request->firebase_token);
            $firebaseUid = $verifiedIdToken->claims()->get('sub');
            
            // Récupérer les informations de l'utilisateur depuis Firebase
            $firebaseUser = $this->firebaseAuth->getUser($firebaseUid);
            
            // Chercher ou créer le client dans PostgreSQL
            $client = Client::where('firebase_uid', $firebaseUid)->first();

            if (!$client) {
                return response()->json([
                    'success' => false,
                    'message' => 'Client not found. Please contact administrator.',
                    'firebase_uid' => $firebaseUid
                ], 404);
            }

            // Mettre à jour le FCM token si fourni
            if ($request->has('fcm_token') && $request->fcm_token) {
                $client->fcm_token = $request->fcm_token;
                $client->save();
            }

            return response()->json([
                'success' => true,
                'message' => 'Login successful',
                'data' => [
                    'client' => $client,
                    'firebase_email' => $firebaseUser->email,
                    'firebase_uid' => $firebaseUid
                ]
            ], 200);

        } catch (\Kreait\Firebase\Exception\Auth\FailedToVerifyToken $e) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid Firebase token',
                'error' => $e->getMessage()
            ], 401);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Authentication failed',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Mettre à jour le FCM token
     */
    public function updateFcmToken(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'firebase_uid' => 'required|string',
            'fcm_token' => 'required|string'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $client = Client::where('firebase_uid', $request->firebase_uid)->first();

            if (!$client) {
                return response()->json([
                    'success' => false,
                    'message' => 'Client not found'
                ], 404);
            }

            $client->fcm_token = $request->fcm_token;
            $client->save();

            return response()->json([
                'success' => true,
                'message' => 'FCM token updated successfully',
                'data' => $client
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to update FCM token',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}