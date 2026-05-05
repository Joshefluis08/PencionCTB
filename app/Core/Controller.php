<?php
namespace App\Core;

class Controller
{
    // Métodos comunes para controladores pueden ir aquí
    protected function view($view, $data = [])
    {
        extract($data);
        $viewPath = dirname(__DIR__, 2).'/resources/views/'.str_replace('.', '/', $view).'.php';
        if (file_exists($viewPath)) {
            require $viewPath;
        } else {
            echo 'Vista no encontrada: ' . htmlspecialchars($viewPath);
        }
    }
}
