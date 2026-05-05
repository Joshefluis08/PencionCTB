<?php
return [
    'name' => 'PensionCTB',
    'env' => getenv('APP_ENV') ?: 'local',
    'debug' => getenv('APP_DEBUG') === 'true',
    'url' => getenv('APP_URL') ?: 'http://localhost',
    'timezone' => 'America/Bogota',
];
