<?php
$titulo = 'Página no encontrada';
ob_start(); ?>
<div class="card" style="text-align:center">
  <h2 style="color: var(--primary);">404</h2>
  <p>No se pudo encontrar la página solicitada.</p>
  <a href="/" class="btn-primary">Volver al inicio</a>
</div>
<?php
$contenido = ob_get_clean();
include __DIR__ . '/layout.php';
