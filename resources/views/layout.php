<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><?= isset($titulo) ? $titulo : 'PensionCTB' ?></title>
  <link rel="stylesheet" href="/assets/css/main.css?v=1">
</head>
<body>
  <header class="header">PensionCTB<br><small style="color: #e75330;font-size:1rem;font-weight:lighter;">Sistema de Tesorería Educativa</small></header>
  <main style="min-height:60vh">
    <?php if (isset($contenido)) echo $contenido; ?>
  </main>
  <footer class="footer">&copy; <?= date('Y') ?> Colegio Técnico Bilingüe Coreducación</footer>
</body>
</html>