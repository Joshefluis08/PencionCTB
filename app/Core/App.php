<?php
namespace App\Core;

use App\Core\Router;

class App
{
    /** @var Router */
    protected $router;

    public function __construct()
    {
        // Configuración (env, config, etc)
        $this->loadEnv();
        $this->router = new Router();
    }

    public function run()
    {
        $this->router->dispatch();
    }

    protected function loadEnv()
    {
        $dotenvPath = dirname(__DIR__, 2) . '/.env';
        if (file_exists($dotenvPath)) {
            $dotenv = \Dotenv\Dotenv::createImmutable(dirname($dotenvPath));
            $dotenv->load();
        }
    }
}
