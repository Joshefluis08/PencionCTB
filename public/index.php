<?php

// Cargar autoloader de Composer
require_once __DIR__ . '/../vendor/autoload.php';

use App\Core\App;

// Arranca la aplicación principal
$app = new App();
$app->run();
