<?php
$titulo = 'Error del sistema';
ob_start(); ?>
<div class="card" style="text-align:center">
  <h2 style="color: var(--secondary);">500</h2>
  <p>Ha ocurrido un error inesperado. Intenta recargar la página o contacta al soporte técnico.</p>
  <a href="/" class="btn-primary">Volver al inicio</a>
</div>
<?php
$contenido = ob_get_clean();
include __DIR__ . '/layout.php';
