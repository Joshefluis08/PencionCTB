<?php
$titulo = 'Iniciar sesión';
ob_start(); ?>
<div class="card">
  <h2 style="color: var(--primary);margin-bottom:1.5rem">Inicia sesión</h2>
  <form method="post" action="/login">
    <input type="email" name="email" placeholder="Correo institucional" required autofocus>
    <input type="password" name="password" placeholder="Contraseña" required>
    <button type="submit" class="btn-primary">Acceder</button>
  </form>
</div>
<?php
$contenido = ob_get_clean();
include __DIR__ . '/layout.php';
