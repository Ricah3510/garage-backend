<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Client extends Model
{
    protected $table = 't_client';
    protected $primaryKey = 'id_client';
    public $timestamps = false;

    protected $fillable = [
        'nom',
        'email',
        'firebase_uid',
        'fcm_token',
        'date_creation'
    ];

    protected $hidden = [
        'fcm_token'
    ];

    protected $casts = [
        'date_creation' => 'datetime'
    ];
}