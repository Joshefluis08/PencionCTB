<?php
namespace App\Core;

class Router
{
    protected $routes = [];

    public function __construct()
    {
        $this->loadRoutes();
    }

    protected function loadRoutes()
    {
        $webRoutes = dirname(__DIR__, 2) . '/routes/web.php';
        if (file_exists($webRoutes)) {
            require $webRoutes;
        }
    }

    public function dispatch()
    {
        $uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
        if ($uri === '/') {
            echo 'Bienvenido a PensionCTB';
        } elseif (isset($this->routes[$uri])) {
            call_user_func($this->routes[$uri]);
        } else {
            http_response_code(404);
            echo '404 Página no encontrada';
        }
    }
    // Métodos para agregar rutas
    public function get($uri, $callback)
    {
        $this->routes[$uri] = $callback;
    }
}
