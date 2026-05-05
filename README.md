# PensionCTB 2.5 — Sistema de Tesorería Educativa

Sistema integral de gestión financiera para el **Colegio Técnico Bilingüe Coreducación**.  
Desarrollado en PHP 8.1+ con arquitectura MVC propia (sin frameworks externos de alto nivel).

---

## 📋 Requisitos

| Componente | Versión mínima |
|------------|---------------|
| PHP        | 8.1           |
| MySQL      | 8.0           |
| Apache     | 2.4 (mod_rewrite activo) |
| Composer   | 2.x           |

**Extensiones PHP requeridas:** `pdo`, `pdo_mysql`, `mbstring`, `json`, `openssl`, `curl`, `gd`

---

## ⚡ Instalación

### 1. Subir / clonar el proyecto

```bash
# Opción A — Git
git clone https://github.com/pensionctb/pensionctb.git PensionCTB_2.5

# Opción B — Subir el ZIP al servidor y descomprimir
unzip PensionCTB_2.5.zip
```

> **El `DocumentRoot` de Apache/Nginx debe apuntar a `/ruta/proyecto/public/`**

### 2. Instalar dependencias

```bash
composer install --no-dev --optimize-autoloader
```

### 3. Configurar variables de entorno

```bash
cp .env.example .env
nano .env   # Ajusta DB_*, MAIL_*, APP_URL y APP_KEY
```

### 4. Importar la base de datos

```bash
mysql -u root -p wbogotaw9_colegio_tesoreria < database/migrations/schema.sql
```

### 5. Crear usuario administrador inicial

```sql
INSERT INTO usuarios (nombre, apellidos, email, password_hash, rol, activo)
VALUES (
  'Admin', 'Sistema',
  'admin@colegio.edu.co',
  '$2y$12$...hash_bcrypt...',
  'administrador', 1
);
```

> Genera el hash con: `php -r "echo password_hash('TuPassword123', PASSWORD_BCRYPT);"`

### 6. Permisos de carpetas (Linux)

```bash
chmod -R 755 public/
chmod -R 775 storage/
chown -R www-data:www-data storage/ public/uploads/
```

---

## 🗂 Estructura del proyecto

```
PensionCTB_2.5/
├── .env                  ← Variables de entorno locales (NO subir a git)
├── .env.example          ← Plantilla de variables de entorno
├── .htaccess             ← Protección de archivos sensibles (raíz)
├── .gitignore
├── composer.json
├── composer.lock
├── app/
│   ├── Controllers/      ← Un controlador por módulo
│   ├── Core/             ← App.php, Router.php, Database.php, Controller.php
│   ├── Middleware/       ← AuthMiddleware
│   ├── Models/           ← User.php y futuros modelos
│   ├── Repositories/     ← UserRepository
│   └── Services/         ← AuthService
├── config/
│   ├── app.php           ← Configuración general
│   └── database.php      ← Conexión a BD (lee desde .env)
├── database/
│   ├── migrations/       ← Archivos SQL del esquema
│   └── seeds/            ← Datos iniciales
├── public/               ← ⚠ DocumentRoot aquí
│   ├── index.php         ← Front controller (único punto de entrada)
│   ├── .htaccess         ← Rewrite rules
│   └── assets/           ← CSS, JS, imágenes
├── resources/
│   └── views/            ← Vistas PHP organizadas por módulo
├── routes/
│   ├── web.php           ← Rutas web
│   └── api.php           ← Rutas API
├── storage/
│   ├── cache/
│   ├── logs/
│   └── uploads/
├── tests/
│   ├── Feature/
│   └── Unit/
└── vendor/               ← Dependencias Composer (no subir a git)
```

---

## 🔐 Roles y permisos

| Rol | Descripción |
|-----|-------------|
| `administrador` | Acceso total al sistema |
| `tesorero` | Pagos, pensiones, caja, reportes |
| `rector` | Reportes, cartera, vista ejecutiva |
| `secretario` | Consultas, facturas, comunicaciones |
| `secrecole` | Estudiantes, consultas académicas |
| `responsable` | Portal acudiente: mis hijos y mis pagos |

---

## 🛣 Rutas principales

| Ruta | Descripción |
|------|-------------|
| `/` | Redirige a `/dashboard` o `/login` |
| `/login` | Inicio de sesión |
| `/logout` | Cerrar sesión |
| `/dashboard` | Panel principal según rol |
| `/portal` | Portal del acudiente |
| `/estudiantes` | Gestión de estudiantes |
| `/responsables` | Gestión de acudientes |
| `/pagos` | Registro y consulta de pagos |
| `/pensiones` | Pensiones programadas |
| `/caja` | Caja diaria y arqueo |
| `/cartera` | Cartera y morosidad |
| `/facturas` | Facturación |
| `/conceptos` | Conceptos de pago |
| `/becas` | Becas y descuentos |
| `/reportes` | Reportes financieros |
| `/calendario` | Calendario de vencimientos |
| `/configuracion` | Configuración del sistema |
| `/api/*` | Endpoints REST internos |

---

## 🗄 Base de datos

**Nombre:** `wbogotaw9_colegio_tesoreria`

Tablas principales:

- `usuarios` — Cuentas del sistema con roles
- `responsables` — Acudientes / padres de familia
- `estudiantes` — Alumnos matriculados
- `grados` — Grados académicos
- `conceptos_pago` — Tipos de cobro (matrícula, pensión, etc.)
- `pensiones_programadas` — Cuotas mensuales generadas
- `pagos` — Pagos registrados en caja
- `facturas` / `facturas_detalle` — Facturación
- `caja_diaria` / `movimientos_caja` — Control de caja
- `becas_descuentos` — Descuentos por estudiante
- `configuraciones` — Parámetros del sistema
- `info_sistema` — Datos institucionales del colegio

Vistas útiles:

- `vista_cartera_estudiantes` — Estado de mora por estudiante
- `vista_estado_financiero_estudiante` — Resumen financiero
- `vista_resumen_caja_mensual` — Cierre mensual de caja

---

## 🔧 Configuración SMTP

Edita las siguientes variables en `.env`:

```env
MAIL_HOST=smtp.tudominio.edu.co
MAIL_PORT=587
MAIL_USERNAME=tesoreria@tudominio.edu.co
MAIL_PASSWORD=tu_contraseña
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=tesoreria@tudominio.edu.co
MAIL_FROM_NAME="Tesorería Colegio"
```

---

## 🚀 Configuración Apache (VirtualHost recomendado)

```apache
<VirtualHost *:80>
    ServerName tesoreria.tudominio.edu.co
    DocumentRoot /var/www/PensionCTB_2.5/public

    <Directory /var/www/PensionCTB_2.5/public>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/pensionctb_error.log
    CustomLog ${APACHE_LOG_DIR}/pensionctb_access.log combined
</VirtualHost>
```

---

## 🧪 Tests

```bash
composer test
```

---

## 📝 Changelog

### v2.5 (2026)
- Portal de acudientes con solicitudes de pago
- Módulo de emails masivos con plantillas
- Reglas de mora configurables
- Auditoría completa de acciones
- Historial de grados académicos
- Soporte multi-año académico

### v2.0
- Caja diaria con arqueo
- Becas y descuentos por estudiante
- Generación automática de pensiones
- Reportes financieros exportables

---

Desarrollado por **José Luis Castro Piraquive** · PensionCTB v2.5