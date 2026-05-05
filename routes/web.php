<?php
// routes/web.php
// Ejemplo de ruta principal usando el Router del sistema

$router = isset($this) ? $this : null;
if ($router) {
    $router->get('/hola', function() {
        echo '¡Sistema PensionCTB funcional!';
    });
}
