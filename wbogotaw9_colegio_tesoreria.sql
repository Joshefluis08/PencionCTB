-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 04-05-2026 a las 15:51:07
-- Versión del servidor: 8.0.45-cll-lve
-- Versión de PHP: 8.4.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `wbogotaw9_colegio_tesoreria`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ajustes_historicos`
--

CREATE TABLE `ajustes_historicos` (
  `id` int NOT NULL,
  `tipo` enum('pago_atrasado','correccion_fecha','ajuste_valor','anulacion_historica') NOT NULL,
  `referencia_tabla` varchar(50) NOT NULL,
  `referencia_id` int NOT NULL,
  `fecha_real` datetime NOT NULL,
  `fecha_registro` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_registro` int NOT NULL,
  `valor` decimal(12,2) DEFAULT NULL,
  `descripcion` text NOT NULL,
  `observaciones` text,
  `datos_adicionales` json DEFAULT NULL,
  `estado` enum('activo','revertido') DEFAULT 'activo',
  `fecha_reversion` timestamp NULL DEFAULT NULL,
  `usuario_reversion` int DEFAULT NULL,
  `motivo_reversion` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `archivos_sistema`
--

CREATE TABLE `archivos_sistema` (
  `id` int NOT NULL,
  `nombre_original` varchar(255) NOT NULL,
  `nombre_archivo` varchar(255) NOT NULL,
  `ruta_archivo` varchar(500) NOT NULL,
  `tipo_mime` varchar(100) NOT NULL,
  `tamaño_bytes` bigint NOT NULL,
  `categoria` enum('recibo','factura','documento_estudiante','reporte','comprobante','otro') DEFAULT 'otro',
  `estudiante_id` int DEFAULT NULL,
  `pago_id` int DEFAULT NULL,
  `factura_id` int DEFAULT NULL,
  `publico` tinyint(1) DEFAULT '0',
  `usuario_subida` int NOT NULL,
  `fecha_subida` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria_acciones`
--

CREATE TABLE `auditoria_acciones` (
  `id` int NOT NULL,
  `usuario_id` int DEFAULT NULL,
  `accion` varchar(100) NOT NULL,
  `modulo` varchar(50) NOT NULL,
  `tabla_afectada` varchar(50) DEFAULT NULL,
  `registro_id` int DEFAULT NULL,
  `datos_anteriores` text,
  `datos_nuevos` text,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text,
  `timestamp_accion` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria_cambios`
--

CREATE TABLE `auditoria_cambios` (
  `id` int NOT NULL,
  `tabla` varchar(50) NOT NULL,
  `registro_id` int NOT NULL,
  `campo_modificado` varchar(50) NOT NULL,
  `valor_anterior` varchar(255) DEFAULT NULL,
  `valor_nuevo` varchar(255) DEFAULT NULL,
  `usuario_id` int NOT NULL,
  `motivo` text,
  `fecha_cambio` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `becas_descuentos`
--

CREATE TABLE `becas_descuentos` (
  `id` int NOT NULL,
  `estudiante_id` int NOT NULL,
  `tipo` enum('beca','descuento') NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text,
  `tipo_descuento` enum('porcentaje','valor_fijo') NOT NULL,
  `valor_descuento` decimal(12,2) NOT NULL,
  `conceptos_aplicables` text,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date DEFAULT NULL,
  `año_academico` year NOT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `requiere_renovacion` tinyint(1) DEFAULT '1',
  `motivo` text,
  `documento_soporte` varchar(255) DEFAULT NULL,
  `usuario_creacion` int NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `caja_diaria`
--

CREATE TABLE `caja_diaria` (
  `id` int NOT NULL,
  `fecha` date NOT NULL,
  `saldo_inicial` decimal(15,2) DEFAULT '0.00',
  `total_ingresos` decimal(15,2) DEFAULT '0.00',
  `total_egresos` decimal(15,2) DEFAULT '0.00',
  `saldo_real` decimal(15,2) DEFAULT NULL,
  `saldo_final` decimal(15,2) DEFAULT '0.00',
  `hora_apertura` time DEFAULT NULL,
  `fecha_apertura` timestamp NULL DEFAULT NULL,
  `hora_cierre` time DEFAULT NULL,
  `fecha_cierre` timestamp NULL DEFAULT NULL,
  `usuario_apertura` int DEFAULT NULL,
  `usuario_cierre` int DEFAULT NULL,
  `estado` enum('pendiente','abierta','cerrada','cuadrada') DEFAULT 'pendiente',
  `observaciones_apertura` text,
  `observaciones_cierre` text,
  `observaciones_arqueo` text,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `conceptos_historico`
--

CREATE TABLE `conceptos_historico` (
  `id` int NOT NULL,
  `concepto_id` int NOT NULL,
  `anio_academico` year NOT NULL,
  `codigo` varchar(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text,
  `tipo` enum('matricula','pension','carnet','seguro','plataforma','reglamento','papeleria','alimentacion','transporte','uniforme','actividad','certificado','otro') NOT NULL,
  `valor_base` decimal(12,2) DEFAULT '0.00',
  `valor_por_grado` tinyint(1) DEFAULT '0',
  `obligatorio` tinyint(1) DEFAULT '1',
  `generar_automatico` tinyint(1) DEFAULT '0',
  `periodicidad` enum('unico','mensual','bimestral','trimestral','semestral','anual') DEFAULT 'unico',
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `visible_recibo` tinyint(1) DEFAULT '1',
  `estado_historico` enum('activo','cerrado','migrado') DEFAULT 'activo',
  `usuario_creacion` int NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_cierre` timestamp NULL DEFAULT NULL,
  `observaciones_cierre` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Historial de conceptos por año académico';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `conceptos_pago`
--

CREATE TABLE `conceptos_pago` (
  `id` int NOT NULL,
  `codigo` varchar(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text,
  `tipo` enum('matricula','pension','carnet','seguro','plataforma','reglamento','papeleria','alimentacion','transporte','uniforme','actividad','certificado','otro') NOT NULL,
  `valor_base` decimal(12,2) DEFAULT '0.00',
  `valor_por_grado` tinyint(1) DEFAULT '0',
  `obligatorio` tinyint(1) DEFAULT '1',
  `generar_automatico` tinyint(1) DEFAULT '0',
  `periodicidad` enum('unico','mensual','bimestral','trimestral','semestral','anual') DEFAULT 'unico',
  `anio_academico` year DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `visible_recibo` tinyint(1) DEFAULT '1',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `configuraciones`
--

CREATE TABLE `configuraciones` (
  `id` int NOT NULL,
  `clave` varchar(100) NOT NULL,
  `valor` text NOT NULL,
  `descripcion` text,
  `tipo` enum('texto','numero','booleano','fecha','json') DEFAULT 'texto',
  `categoria` varchar(50) DEFAULT 'general',
  `editable` tinyint(1) DEFAULT '1',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `emails_enviados`
--

CREATE TABLE `emails_enviados` (
  `id` int NOT NULL,
  `plantilla_id` int DEFAULT NULL,
  `tipo_envio` enum('individual','masivo','programado') DEFAULT 'individual',
  `email_destinatario` varchar(100) NOT NULL,
  `nombre_destinatario` varchar(200) DEFAULT NULL,
  `asunto` varchar(200) NOT NULL,
  `cuerpo_email` longtext,
  `estudiante_id` int DEFAULT NULL,
  `datos_estudiante` json DEFAULT NULL,
  `estado_cuenta` enum('al_dia','en_mora','sin_datos') DEFAULT 'sin_datos',
  `total_mora` decimal(12,2) DEFAULT '0.00',
  `facturas_mora` json DEFAULT NULL,
  `factura_id` int DEFAULT NULL,
  `estado` enum('pendiente','enviado','error','cancelado') DEFAULT 'pendiente',
  `fecha_envio` timestamp NULL DEFAULT NULL,
  `error_mensaje` text,
  `intentos_envio` int DEFAULT '0',
  `usuario_solicita` int NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `email_logs`
--

CREATE TABLE `email_logs` (
  `id` int NOT NULL,
  `tipo` enum('success','error','warning','info') NOT NULL,
  `mensaje` text NOT NULL,
  `email_id` int DEFAULT NULL,
  `usuario_id` int DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estudiantes`
--

CREATE TABLE `estudiantes` (
  `id` int NOT NULL,
  `codigo_estudiante` varchar(20) NOT NULL,
  `nombres` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `documento` varchar(20) NOT NULL,
  `tipo_documento` enum('TI','CC','CE','PA','RC') DEFAULT 'TI',
  `fecha_nacimiento` date NOT NULL,
  `lugar_nacimiento` varchar(100) DEFAULT NULL,
  `genero` enum('masculino','femenino') NOT NULL,
  `grupo_sanguineo` enum('A+','A-','B+','B-','AB+','AB-','O+','O-') DEFAULT NULL,
  `eps` varchar(100) DEFAULT NULL,
  `grado_actual_id` int NOT NULL,
  `curso` varchar(10) DEFAULT NULL,
  `jornada` enum('mañana','tarde','completa') DEFAULT 'mañana',
  `año_academico` year NOT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `direccion` text,
  `barrio` varchar(100) DEFAULT NULL,
  `ciudad` varchar(100) DEFAULT 'Honda',
  `departamento` varchar(100) DEFAULT 'Tolima',
  `responsable_id` int NOT NULL,
  `vive_con` enum('ambos_padres','solo_madre','solo_padre','abuelos','otros_familiares','acudiente') DEFAULT NULL,
  `hermanos_colegio` int DEFAULT '0',
  `estado` enum('activo','inactivo','retirado','trasladado','graduado') DEFAULT 'activo',
  `fecha_ingreso` date DEFAULT (curdate()),
  `fecha_retiro` date DEFAULT NULL,
  `motivo_retiro` text,
  `observaciones` text,
  `necesidades_especiales` text,
  `alergias` text,
  `medicamentos` text,
  `descuento_porcentaje` decimal(5,2) DEFAULT '0.00',
  `motivo_descuento` varchar(200) DEFAULT NULL,
  `usa_tabla_becas` tinyint(1) DEFAULT '0' COMMENT 'Si=1, el descuento se gestiona en becas_descuentos',
  `beca` tinyint(1) DEFAULT '0',
  `tipo_beca` enum('completa','parcial','deportiva','academica','socioeconomica') DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `eventos_calendario`
--

CREATE TABLE `eventos_calendario` (
  `id` int NOT NULL,
  `titulo` varchar(200) NOT NULL,
  `descripcion` text,
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime DEFAULT NULL,
  `todo_el_dia` tinyint(1) DEFAULT '0',
  `tipo` enum('pago_vencimiento','reunion','evento_colegio','cierre_caja','otro') DEFAULT 'otro',
  `color` varchar(7) DEFAULT '#3498db',
  `estudiante_id` int DEFAULT NULL,
  `grado_id` int DEFAULT NULL,
  `usuario_creacion` int NOT NULL,
  `recordatorio_minutos` int DEFAULT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `facturas`
--

CREATE TABLE `facturas` (
  `id` int NOT NULL,
  `numero_factura` varchar(20) NOT NULL,
  `prefijo` varchar(5) DEFAULT 'FACT',
  `estudiante_id` int NOT NULL,
  `fecha_factura` date NOT NULL,
  `fecha_vencimiento` date NOT NULL,
  `subtotal` decimal(12,2) NOT NULL DEFAULT '0.00',
  `descuentos_totales` decimal(12,2) DEFAULT '0.00',
  `impuestos_totales` decimal(12,2) DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL,
  `estado` enum('pendiente','pagado','vencida','anulado','cruce','devuelto','abono') NOT NULL DEFAULT 'pendiente',
  `metodo_pago_id` int DEFAULT NULL,
  `fecha_pago` timestamp NULL DEFAULT NULL,
  `observaciones` text,
  `archivo_pdf` varchar(255) DEFAULT NULL,
  `usuario_creacion` int NOT NULL,
  `usuario_pago` int DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `facturas_detalle`
--

CREATE TABLE `facturas_detalle` (
  `id` int NOT NULL,
  `factura_id` int NOT NULL,
  `concepto_id` int NOT NULL,
  `descripcion` varchar(255) NOT NULL,
  `cantidad` int NOT NULL DEFAULT '1',
  `valor_unitario` decimal(12,2) NOT NULL,
  `descuento` decimal(12,2) DEFAULT '0.00',
  `subtotal` decimal(12,2) NOT NULL,
  `periodo` varchar(20) DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `grados`
--

CREATE TABLE `grados` (
  `id` int NOT NULL,
  `codigo` varchar(10) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `nivel` enum('preescolar','primaria','secundaria','media') NOT NULL,
  `orden_grado` int NOT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_grados`
--

CREATE TABLE `historial_grados` (
  `id` int NOT NULL,
  `estudiante_id` int NOT NULL,
  `grado_id` int NOT NULL,
  `año_academico` year NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date DEFAULT NULL,
  `promocionado` tinyint(1) DEFAULT NULL,
  `observaciones` text,
  `promedio_academico` decimal(4,2) DEFAULT NULL,
  `comportamiento` enum('excelente','bueno','regular','deficiente') DEFAULT NULL,
  `asistencia_porcentaje` decimal(5,2) DEFAULT NULL,
  `estado_anio` enum('aprobado','reprobado','pendiente','retirado','trasladado') DEFAULT 'pendiente',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `usuario_registro` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `info_sistema`
--

CREATE TABLE `info_sistema` (
  `id` int NOT NULL,
  `nombre_colegio` varchar(200) NOT NULL COMMENT 'Nombre completo. Ej: COLEGIO TÉCNICO BILINGÜE COREDUCACIÓN',
  `nombre_corto` varchar(100) DEFAULT NULL COMMENT 'Nombre abreviado para encabezados compactos. Ej: COREDUCACIÓN',
  `nit` varchar(25) DEFAULT NULL COMMENT 'NIT con dígito verificador. Ej: 900.123.456-7',
  `dane` varchar(20) DEFAULT NULL COMMENT 'Código DANE del establecimiento educativo',
  `resolucion_aprobacion` varchar(150) DEFAULT NULL COMMENT 'Ej: Resolución 001234 del 15/03/2018',
  `direccion` text,
  `barrio` varchar(100) DEFAULT NULL,
  `ciudad` varchar(100) DEFAULT 'Honda',
  `departamento` varchar(100) DEFAULT 'Tolima',
  `pais` varchar(60) DEFAULT 'Colombia',
  `codigo_postal` varchar(10) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL COMMENT 'Teléfono principal. Ej: +57 321 643 6466',
  `telefono_alt` varchar(20) DEFAULT NULL COMMENT 'Teléfono alternativo (celular, whatsapp, etc.)',
  `fax` varchar(20) DEFAULT NULL,
  `email_principal` varchar(150) DEFAULT NULL COMMENT 'Correo general del colegio',
  `email_tesoreria` varchar(150) DEFAULT NULL COMMENT 'Correo de tesorería. Usado en footer y recibos',
  `email_rector` varchar(150) DEFAULT NULL,
  `sitio_web` varchar(255) DEFAULT NULL COMMENT 'URL completa. Ej: https://www.coreducacion.edu.co',
  `horario_atencion` text COMMENT 'Texto libre. Ej: Lun–Vie: 8:00–12:00 y 14:00–18:00',
  `horario_tesoreria` text COMMENT 'Horario específico de tesorería',
  `facebook_url` varchar(255) DEFAULT NULL,
  `instagram_url` varchar(255) DEFAULT NULL,
  `whatsapp_numero` varchar(20) DEFAULT NULL COMMENT 'Número para enlace wa.me. Solo dígitos con código país',
  `logo_url` varchar(500) DEFAULT NULL COMMENT 'Ruta relativa o absoluta al logo principal',
  `logo_icono_url` varchar(500) DEFAULT NULL COMMENT 'Versión cuadrada/ícono del logo (para favicons, recibos)',
  `color_primario` varchar(7) DEFAULT '#a32260' COMMENT 'Color principal en HEX. Ej: #a32260',
  `color_secundario` varchar(7) DEFAULT '#e75330' COMMENT 'Color secundario en HEX. Ej: #e75330',
  `slogan` varchar(255) DEFAULT NULL COMMENT 'Texto bajo el nombre en el header o portada',
  `pie_pagina_texto` text COMMENT 'Texto HTML permitido para el footer. Ej: ©2025 ...',
  `texto_recibo` text COMMENT 'Párrafo legal o institucional que aparece en los recibos',
  `texto_factura` text COMMENT 'Texto adicional en facturas (resolución DIAN, etc.)',
  `smtp_host` varchar(150) DEFAULT NULL,
  `smtp_port` smallint DEFAULT '587',
  `smtp_usuario` varchar(150) DEFAULT NULL,
  `smtp_password_enc` text COMMENT 'Contraseña cifrada (no en texto plano)',
  `smtp_encriptacion` enum('tls','ssl','none') DEFAULT 'tls',
  `smtp_nombre_remitente` varchar(150) DEFAULT NULL COMMENT 'Nombre que verá el destinatario. Ej: Tesorería Coreducación',
  `moneda` varchar(10) DEFAULT 'COP',
  `simbolo_moneda` varchar(5) DEFAULT '$',
  `año_academico_actual` year DEFAULT NULL COMMENT 'Año académico en curso. Se puede sincronizar con periodos_academicos',
  `activo` tinyint(1) DEFAULT '1',
  `usuario_modificacion` int DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Información institucional del colegio. Solo debe existir 1 registro.';

--
-- Volcado de datos para la tabla `info_sistema`
--

INSERT INTO `info_sistema` (`id`, `nombre_colegio`, `nombre_corto`, `nit`, `dane`, `resolucion_aprobacion`, `direccion`, `barrio`, `ciudad`, `departamento`, `pais`, `codigo_postal`, `telefono`, `telefono_alt`, `fax`, `email_principal`, `email_tesoreria`, `email_rector`, `sitio_web`, `horario_atencion`, `horario_tesoreria`, `facebook_url`, `instagram_url`, `whatsapp_numero`, `logo_url`, `logo_icono_url`, `color_primario`, `color_secundario`, `slogan`, `pie_pagina_texto`, `texto_recibo`, `texto_factura`, `smtp_host`, `smtp_port`, `smtp_usuario`, `smtp_password_enc`, `smtp_encriptacion`, `smtp_nombre_remitente`, `moneda`, `simbolo_moneda`, `año_academico_actual`, `activo`, `usuario_modificacion`, `fecha_creacion`, `fecha_actualizacion`) VALUES
(1, 'COLEGIO TÉCNICO BILINGÜE COREDUCACIÓN', 'CTB', '890704562-9', NULL, NULL, NULL, NULL, 'Honda', 'Tolima', 'Colombia', NULL, '+57 3216436450', '2513266', NULL, 'info@colegiotecnicobilingue.edu.co', 'tesoreria@colegiotecnicobilingue.edu.co', NULL, 'https://colegiotecnicobilingue.colegiosonline.com/', 'Lunes a Viernes: 7:00 AM - 3:00 PM', 'Lunes a Viernes: 8:00 AM - 12:00 PM', NULL, NULL, '573216436450', 'assets/img/logo.png', 'assets/img/logo-icon.png', '#c94a4a', '#9b2c6b', 'Formando líderes bilingües con excelencia académica', '© 2026 Colegio Técnico Bilingüe Coreducación - Todos los derechos reservados.', 'Este recibo es un documento válido como soporte de pago en la institución.', 'Documento generado conforme a las normas educativas vigentes en Colombia.', NULL, 587, NULL, NULL, 'tls', 'Colegio Técnico Bilingüe Coreducación', 'COP', '$', '2026', 1, NULL, '2026-05-02 17:07:48', '2026-05-04 16:24:31');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `log_accesos_portal`
--

CREATE TABLE `log_accesos_portal` (
  `id` int NOT NULL,
  `responsable_id` int NOT NULL,
  `usuario_id` int DEFAULT NULL,
  `accion` varchar(100) NOT NULL,
  `modulo` varchar(50) NOT NULL,
  `referencia_id` int DEFAULT NULL,
  `referencia_tabla` varchar(50) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text,
  `datos_adicionales` json DEFAULT NULL,
  `fecha_acceso` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Trazabilidad de acciones de responsables en el portal';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mensajes`
--

CREATE TABLE `mensajes` (
  `id` int NOT NULL,
  `remitente_id` int NOT NULL,
  `destinatario_id` int NOT NULL,
  `asunto` varchar(200) NOT NULL,
  `mensaje` text NOT NULL,
  `fecha_envio` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_lectura` timestamp NULL DEFAULT NULL,
  `leido` tinyint(1) DEFAULT '0',
  `importante` tinyint(1) DEFAULT '0',
  `eliminado_remitente` tinyint(1) DEFAULT '0',
  `eliminado_destinatario` tinyint(1) DEFAULT '0',
  `tipo_mensaje` enum('mensaje','notificacion','alerta','sistema') DEFAULT 'mensaje',
  `adjunto_url` varchar(255) DEFAULT NULL,
  `respuesta_a` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `metodos_pago`
--

CREATE TABLE `metodos_pago` (
  `id` int NOT NULL,
  `codigo` varchar(20) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text,
  `requiere_referencia` tinyint(1) DEFAULT '0',
  `requiere_banco` tinyint(1) DEFAULT '0',
  `comision_porcentaje` decimal(5,2) DEFAULT '0.00',
  `comision_fija` decimal(12,2) DEFAULT '0.00',
  `activo` tinyint(1) DEFAULT '1',
  `orden_visualizacion` int DEFAULT '0',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modulos_sistema`
--

CREATE TABLE `modulos_sistema` (
  `id` int NOT NULL,
  `codigo` varchar(50) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text,
  `icono` varchar(50) DEFAULT NULL,
  `url_base` varchar(100) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `orden` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Catálogo de módulos del sistema';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `movimientos_caja`
--

CREATE TABLE `movimientos_caja` (
  `id` int NOT NULL,
  `caja_id` int NOT NULL,
  `tipo` enum('ingreso','egreso') NOT NULL,
  `concepto` varchar(200) NOT NULL,
  `valor` decimal(12,2) NOT NULL,
  `pago_id` int DEFAULT NULL,
  `factura_id` int DEFAULT NULL,
  `descripcion` text,
  `comprobante` varchar(100) DEFAULT NULL,
  `autorizado_por` int DEFAULT NULL,
  `fecha_movimiento` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_registro` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificaciones`
--

CREATE TABLE `notificaciones` (
  `id` int NOT NULL,
  `tipo` enum('pago_vencido','pago_proximo','beca_vencida','caja_abierta','reporte_generado','sistema') DEFAULT 'sistema',
  `titulo` varchar(200) NOT NULL,
  `mensaje` text NOT NULL,
  `usuario_destino` int DEFAULT NULL,
  `estudiante_id` int DEFAULT NULL,
  `pago_id` int DEFAULT NULL,
  `prioridad` enum('baja','media','alta','critica') DEFAULT 'media',
  `leida` tinyint(1) DEFAULT '0',
  `fecha_lectura` timestamp NULL DEFAULT NULL,
  `url_accion` varchar(255) DEFAULT NULL,
  `activa` tinyint(1) DEFAULT '1',
  `fecha_expiracion` timestamp NULL DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos`
--

CREATE TABLE `pagos` (
  `id` int NOT NULL,
  `numero_recibo` varchar(20) NOT NULL,
  `estudiante_id` int NOT NULL,
  `concepto_id` int NOT NULL,
  `caja_id` int DEFAULT NULL,
  `usuario_id` int NOT NULL,
  `ip_registro` varchar(45) DEFAULT NULL,
  `factura_id` int DEFAULT NULL,
  `factura_electronica` varchar(50) DEFAULT NULL,
  `cufe` varchar(96) DEFAULT NULL,
  `pension_programada_id` int DEFAULT NULL,
  `pago_padre_id` int DEFAULT NULL COMMENT 'ID del pago principal si este es un abono',
  `valor_concepto` decimal(12,2) NOT NULL,
  `descuento` decimal(12,2) DEFAULT '0.00',
  `beca_id` int DEFAULT NULL,
  `descuento_porcentaje` decimal(5,2) DEFAULT '0.00',
  `descuento_motivo` varchar(200) DEFAULT NULL,
  `recargo` decimal(12,2) DEFAULT '0.00',
  `valor_fijo_adicional` decimal(12,2) NOT NULL DEFAULT '0.00',
  `valor_total` decimal(12,2) NOT NULL,
  `valor_pagado` decimal(12,2) NOT NULL,
  `valor_cambio` decimal(12,2) DEFAULT '0.00',
  `es_abono` tinyint(1) DEFAULT '0',
  `saldo_pendiente` decimal(12,2) DEFAULT '0.00',
  `metodo_pago` enum('efectivo','transferencia','cheque','tarjeta_debito','tarjeta_credito','consignacion','cruce') DEFAULT 'efectivo',
  `origen_pago` enum('ventanilla','portal_web','app_movil','banco','transferencia_externa') DEFAULT 'ventanilla',
  `referencia_pago` varchar(100) DEFAULT NULL,
  `banco` varchar(100) DEFAULT NULL,
  `pagador_nombre` varchar(150) DEFAULT NULL,
  `pagador_documento` varchar(20) DEFAULT NULL,
  `pagador_parentesco` varchar(50) DEFAULT NULL,
  `responsable_id` int DEFAULT NULL,
  `fecha_pago` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `periodo` varchar(7) DEFAULT NULL,
  `anio_academico` year DEFAULT NULL,
  `grado_estudiante` varchar(50) DEFAULT NULL,
  `grado_id` int DEFAULT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  `dias_mora` int DEFAULT '0',
  `interes_mora` decimal(12,2) DEFAULT '0.00',
  `porcentaje_mora` decimal(5,2) DEFAULT '0.00',
  `estado` enum('pagado','anulado','devuelto','pendiente','abono','cruce') NOT NULL DEFAULT 'pagado',
  `conciliado` tinyint(1) DEFAULT '0',
  `fecha_conciliacion` timestamp NULL DEFAULT NULL,
  `usuario_conciliacion` int DEFAULT NULL,
  `motivo_anulacion` text,
  `fecha_anulacion` timestamp NULL DEFAULT NULL,
  `usuario_anulacion` int DEFAULT NULL,
  `observaciones` text,
  `datos_adicionales` json DEFAULT NULL,
  `comprobante_url` varchar(255) DEFAULT NULL,
  `impreso` tinyint(1) DEFAULT '0',
  `fecha_impresion` timestamp NULL DEFAULT NULL,
  `veces_impreso` int DEFAULT '0',
  `usuario_impresion` int DEFAULT NULL,
  `valor_sin_redondeo` decimal(12,2) DEFAULT NULL,
  `valor_redondeo` decimal(12,2) DEFAULT '0.00',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `usuario_modificacion` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Disparadores `pagos`
--
DELIMITER $$
CREATE TRIGGER `trg_validar_valor_total_pago` BEFORE INSERT ON `pagos` FOR EACH ROW BEGIN
  DECLARE calculado DECIMAL(12,2);
  SET calculado = NEW.valor_concepto - NEW.descuento + NEW.recargo + NEW.valor_fijo_adicional;
  SET NEW.valor_sin_redondeo = calculado;
  SET NEW.valor_redondeo = NEW.valor_total - calculado;
  IF ABS(NEW.valor_total - calculado) > 1 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'valor_total no coincide: valor_concepto - descuento + recargo + valor_fijo_adicional';
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `password_resets`
--

CREATE TABLE `password_resets` (
  `id` int NOT NULL,
  `usuario_id` int NOT NULL,
  `token` varchar(64) NOT NULL,
  `expiracion` datetime NOT NULL,
  `usado` tinyint(1) NOT NULL DEFAULT '0',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_uso` datetime DEFAULT NULL,
  `ip_solicitud` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pensiones_programadas`
--

CREATE TABLE `pensiones_programadas` (
  `id` int NOT NULL,
  `estudiante_id` int NOT NULL,
  `concepto_id` int NOT NULL,
  `periodo` varchar(7) NOT NULL COMMENT 'Formato: YYYY-MM',
  `año_academico` year NOT NULL,
  `mes` int NOT NULL COMMENT 'Número del mes (1-12)',
  `valor_pension` decimal(12,2) NOT NULL,
  `descuento_aplicado` decimal(12,2) DEFAULT '0.00',
  `valor_fijo_adicional` decimal(12,2) DEFAULT '0.00',
  `valor_final` decimal(12,2) NOT NULL,
  `saldo_pendiente` decimal(12,2) DEFAULT '0.00',
  `fecha_generacion` date NOT NULL,
  `fecha_vencimiento` date NOT NULL,
  `fecha_limite` date DEFAULT NULL,
  `valor_recargo` decimal(12,2) DEFAULT '0.00',
  `estado` enum('pendiente','pagado','vencido','anulado','cruce','abono','devuelto') NOT NULL DEFAULT 'pendiente',
  `fecha_pago` timestamp NULL DEFAULT NULL,
  `pago_id` int DEFAULT NULL,
  `factura_id` int DEFAULT NULL,
  `generado_automatico` tinyint(1) DEFAULT '1',
  `observaciones` text,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Tabla de pensiones programadas con descuentos y valores adicionales';

--
-- Disparadores `pensiones_programadas`
--
DELIMITER $$
CREATE TRIGGER `trg_calcular_valor_final_insert` BEFORE INSERT ON `pensiones_programadas` FOR EACH ROW BEGIN
  SET NEW.valor_final = NEW.valor_pension - NEW.descuento_aplicado + NEW.valor_fijo_adicional;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_calcular_valor_final_update` BEFORE UPDATE ON `pensiones_programadas` FOR EACH ROW BEGIN
  SET NEW.valor_final = NEW.valor_pension - NEW.descuento_aplicado + NEW.valor_fijo_adicional;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `periodos_academicos`
--

CREATE TABLE `periodos_academicos` (
  `id` int NOT NULL,
  `año` year NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `estado` enum('planificado','activo','cerrado','archivado') NOT NULL DEFAULT 'planificado',
  `pensiones_generadas` tinyint(1) DEFAULT '0',
  `matriculas_generadas` tinyint(1) DEFAULT '0',
  `fecha_inicio_matriculas` date DEFAULT NULL,
  `fecha_fin_matriculas` date DEFAULT NULL,
  `fecha_apertura` timestamp NULL DEFAULT NULL,
  `fecha_cierre` timestamp NULL DEFAULT NULL,
  `usuario_apertura` int DEFAULT NULL,
  `usuario_cierre` int DEFAULT NULL,
  `observaciones` text,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Control formal de años académicos';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos_rol`
--

CREATE TABLE `permisos_rol` (
  `id` int NOT NULL,
  `rol` enum('administrador','tesorero','rector','secretario','responsable','secrecole') NOT NULL,
  `modulo_id` int NOT NULL,
  `puede_ver` tinyint(1) DEFAULT '0',
  `puede_crear` tinyint(1) DEFAULT '0',
  `puede_editar` tinyint(1) DEFAULT '0',
  `puede_eliminar` tinyint(1) DEFAULT '0',
  `puede_exportar` tinyint(1) DEFAULT '0',
  `puede_anular` tinyint(1) DEFAULT '0',
  `restricciones_json` json DEFAULT NULL,
  `usuario_modificacion` int DEFAULT NULL,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Control de accesos por rol y módulo';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `plantillas_email`
--

CREATE TABLE `plantillas_email` (
  `id` int NOT NULL,
  `codigo` varchar(50) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `asunto` varchar(200) NOT NULL,
  `cuerpo_html` longtext NOT NULL,
  `diseño_html` longtext,
  `cuerpo_texto` text,
  `variables_disponibles` text,
  `tipo` enum('pago_recordatorio','mora_alerta','factura_generada','beca_notificacion','general') DEFAULT 'general',
  `tipo_envio` enum('individual','masivo','ambos') DEFAULT 'ambos',
  `incluye_estado_cuenta` tinyint(1) DEFAULT '0',
  `activa` tinyint(1) DEFAULT '1',
  `usuario_creacion` int NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `programacion_cobros`
--

CREATE TABLE `programacion_cobros` (
  `id` int NOT NULL,
  `concepto_id` int NOT NULL,
  `grado_id` int DEFAULT NULL,
  `fecha_cobro` date NOT NULL,
  `fecha_recordatorio` date DEFAULT NULL,
  `dias_recordatorio` int DEFAULT '3',
  `enviar_recordatorio` tinyint(1) DEFAULT '1',
  `estado` enum('activo','inactivo','completado','eliminado') DEFAULT 'activo',
  `usuario_id` int DEFAULT NULL,
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reglas_mora`
--

CREATE TABLE `reglas_mora` (
  `id` int NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text,
  `tipo_calculo` enum('porcentaje_diario','porcentaje_mensual','valor_fijo_diario','valor_fijo_mensual') NOT NULL DEFAULT 'porcentaje_mensual',
  `valor` decimal(8,4) NOT NULL,
  `dias_gracia` int NOT NULL DEFAULT '0',
  `aplica_a` enum('todos','pension','matricula','concepto_especifico') NOT NULL DEFAULT 'todos',
  `concepto_id` int DEFAULT NULL,
  `grado_id` int DEFAULT NULL,
  `periodo_academico_id` int DEFAULT NULL,
  `tope_maximo_porcentaje` decimal(5,2) DEFAULT NULL,
  `tope_maximo_valor` decimal(12,2) DEFAULT NULL,
  `activa` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_vigencia_inicio` date NOT NULL,
  `fecha_vigencia_fin` date DEFAULT NULL,
  `usuario_creacion` int NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Reglas configurables para cálculo de mora';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `responsables`
--

CREATE TABLE `responsables` (
  `id` int NOT NULL,
  `usuario_id` int DEFAULT NULL,
  `nombres` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `documento` varchar(20) NOT NULL,
  `tipo_documento` enum('CC','CE','PA') DEFAULT 'CC',
  `telefono` varchar(15) DEFAULT NULL,
  `telefono_alternativo` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `direccion` text,
  `barrio` varchar(100) DEFAULT NULL,
  `ciudad` varchar(100) DEFAULT 'Honda',
  `departamento` varchar(100) DEFAULT 'Tolima',
  `parentesco` enum('padre','madre','abuelo','abuela','tio','tia','hermano','hermana','acudiente','otro') NOT NULL,
  `ocupacion` varchar(100) DEFAULT NULL,
  `empresa` varchar(100) DEFAULT NULL,
  `ingresos_mensuales` decimal(12,2) DEFAULT NULL,
  `estado_civil` enum('soltero','casado','casada','divorciado','viudo','viuda','union_libre') DEFAULT NULL,
  `observaciones` text,
  `activo` tinyint(1) DEFAULT '1',
  `estado` enum('activo','inactivo') NOT NULL DEFAULT 'activo',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sesiones_usuarios`
--

CREATE TABLE `sesiones_usuarios` (
  `id` varchar(128) NOT NULL,
  `usuario_id` int NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `user_agent` text,
  `datos_sesion` longtext,
  `activa` tinyint(1) DEFAULT '1',
  `fecha_inicio` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actividad` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `fecha_expiracion` timestamp NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `solicitudes_acceso`
--

CREATE TABLE `solicitudes_acceso` (
  `id` int NOT NULL,
  `responsable_id` int NOT NULL,
  `nombre_completo` varchar(200) NOT NULL,
  `documento` varchar(20) NOT NULL,
  `tipo_documento` enum('CC','CE','PA') DEFAULT 'CC',
  `email` varchar(100) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `parentesco` varchar(50) DEFAULT NULL,
  `nombre_estudiante` varchar(200) DEFAULT NULL,
  `codigo_estudiante` varchar(30) DEFAULT NULL,
  `grado` varchar(80) DEFAULT NULL,
  `nota_solicitante` text COMMENT 'Mensaje libre que escribe el solicitante',
  `estado` enum('pendiente','aprobado','rechazado') NOT NULL DEFAULT 'pendiente',
  `nota_admin` text COMMENT 'Nota o motivo del administrador al revisar',
  `usuario_revision` int DEFAULT NULL COMMENT 'FK al usuario admin que revisó',
  `usuario_creado` int DEFAULT NULL COMMENT 'FK al usuario creado al aprobar',
  `ip_solicitud` varchar(45) DEFAULT NULL,
  `user_agent` text,
  `fecha_solicitud` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_revision` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Solicitudes de acceso al portal enviadas por responsables, pendientes de aprobación del administrador';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `solicitudes_pago_portal`
--

CREATE TABLE `solicitudes_pago_portal` (
  `id` int NOT NULL,
  `responsable_id` int NOT NULL,
  `estudiante_id` int NOT NULL,
  `pension_programada_id` int DEFAULT NULL,
  `factura_id` int DEFAULT NULL,
  `monto_solicitado` decimal(12,2) NOT NULL,
  `metodo_pago` enum('transferencia','consignacion','pse','otro') NOT NULL,
  `banco` varchar(100) DEFAULT NULL,
  `numero_referencia` varchar(100) DEFAULT NULL,
  `comprobante_url` varchar(255) DEFAULT NULL,
  `estado` enum('pendiente','en_revision','aprobado','rechazado','vencido') NOT NULL DEFAULT 'pendiente',
  `pago_id` int DEFAULT NULL,
  `motivo_rechazo` text,
  `notas_responsable` text,
  `notas_tesorero` text,
  `ip_solicitud` varchar(45) DEFAULT NULL,
  `fecha_solicitud` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_revision` timestamp NULL DEFAULT NULL,
  `usuario_revision` int DEFAULT NULL,
  `fecha_vencimiento_solicitud` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Solicitudes de pago desde el portal de acudientes';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `rol` enum('administrador','tesorero','rector','secretario','responsable','secrecole') DEFAULT 'tesorero',
  `activo` tinyint(1) DEFAULT '1',
  `ultimo_acceso` timestamp NULL DEFAULT NULL,
  `intentos_login` int DEFAULT '0',
  `bloqueado_hasta` timestamp NULL DEFAULT NULL,
  `foto_perfil` varchar(255) DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `valores_concepto_grado`
--

CREATE TABLE `valores_concepto_grado` (
  `id` int NOT NULL,
  `concepto_id` int NOT NULL,
  `grado_id` int NOT NULL,
  `valor` decimal(12,2) NOT NULL,
  `anio_academico` int DEFAULT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `valores_concepto_grado_historico`
--

CREATE TABLE `valores_concepto_grado_historico` (
  `id` int NOT NULL,
  `concepto_historico_id` int NOT NULL,
  `grado_id` int NOT NULL,
  `valor` decimal(12,2) NOT NULL,
  `anio_academico` year NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Valores históricos por grado y año';

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_cartera_estudiantes`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_cartera_estudiantes` (
`año_academico` year
,`clasificacion_mora` varchar(13)
,`codigo_estudiante` varchar(20)
,`email_responsable` varchar(100)
,`estudiante_id` int
,`grado` varchar(50)
,`max_dias_mora` bigint
,`nivel` enum('preescolar','primaria','secundaria','media')
,`nombre_completo` varchar(201)
,`pensiones_pendientes` decimal(23,0)
,`pensiones_vencidas` decimal(23,0)
,`responsable` varchar(201)
,`saldo_en_mora` decimal(34,2)
,`saldo_total_pendiente` decimal(34,2)
,`telefono_responsable` varchar(15)
,`total_pensiones` bigint
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_estado_financiero_estudiante`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_estado_financiero_estudiante` (
`año_academico` year
,`becas_activas` bigint
,`codigo_estudiante` varchar(20)
,`estudiante_id` int
,`grado` varchar(50)
,`nombre_completo` varchar(201)
,`total_pagado` decimal(34,2)
,`total_pagos_realizados` bigint
,`total_pendiente` decimal(34,2)
,`total_pensiones_generadas` bigint
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_resumen_caja_mensual`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_resumen_caja_mensual` (
`año` int
,`cajas_cuadradas` decimal(23,0)
,`cajas_sin_cuadrar` decimal(23,0)
,`dias_operados` bigint
,`mes` int
,`nombre_mes` varchar(9)
,`total_egresos` decimal(37,2)
,`total_ingresos` decimal(37,2)
,`utilidad_neta` decimal(38,2)
);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `ajustes_historicos`
--
ALTER TABLE `ajustes_historicos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_referencia` (`referencia_tabla`,`referencia_id`),
  ADD KEY `idx_fecha_real` (`fecha_real`),
  ADD KEY `idx_tipo` (`tipo`),
  ADD KEY `idx_usuario_registro` (`usuario_registro`),
  ADD KEY `fk_ajustes_usuario_reversion` (`usuario_reversion`);

--
-- Indices de la tabla `archivos_sistema`
--
ALTER TABLE `archivos_sistema`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_archivo_categoria` (`categoria`),
  ADD KEY `idx_archivo_estudiante` (`estudiante_id`),
  ADD KEY `idx_archivo_pago` (`pago_id`),
  ADD KEY `fk_archivos_factura` (`factura_id`),
  ADD KEY `fk_archivos_usuario` (`usuario_subida`);

--
-- Indices de la tabla `auditoria_acciones`
--
ALTER TABLE `auditoria_acciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_auditoria_usuario` (`usuario_id`),
  ADD KEY `idx_auditoria_accion` (`accion`),
  ADD KEY `idx_auditoria_modulo` (`modulo`),
  ADD KEY `idx_auditoria_timestamp` (`timestamp_accion`);

--
-- Indices de la tabla `auditoria_cambios`
--
ALTER TABLE `auditoria_cambios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_tabla_registro` (`tabla`,`registro_id`),
  ADD KEY `idx_usuario` (`usuario_id`),
  ADD KEY `idx_fecha` (`fecha_cambio`);

--
-- Indices de la tabla `becas_descuentos`
--
ALTER TABLE `becas_descuentos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_becas_estudiante` (`estudiante_id`),
  ADD KEY `idx_becas_tipo` (`tipo`),
  ADD KEY `idx_becas_activo` (`activo`),
  ADD KEY `idx_becas_año` (`año_academico`),
  ADD KEY `fk_becas_usuario` (`usuario_creacion`);

--
-- Indices de la tabla `caja_diaria`
--
ALTER TABLE `caja_diaria`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `fecha` (`fecha`),
  ADD KEY `idx_caja_fecha` (`fecha`),
  ADD KEY `idx_caja_estado` (`estado`),
  ADD KEY `idx_caja_fecha_estado` (`fecha`,`estado`),
  ADD KEY `fk_caja_usuario_apertura` (`usuario_apertura`),
  ADD KEY `fk_caja_usuario_cierre` (`usuario_cierre`);

--
-- Indices de la tabla `conceptos_historico`
--
ALTER TABLE `conceptos_historico`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_concepto_anio` (`concepto_id`,`anio_academico`),
  ADD KEY `idx_anio_estado` (`anio_academico`,`estado_historico`),
  ADD KEY `fk_historico_usuario` (`usuario_creacion`);

--
-- Indices de la tabla `conceptos_pago`
--
ALTER TABLE `conceptos_pago`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo` (`codigo`),
  ADD KEY `idx_conceptos_codigo` (`codigo`),
  ADD KEY `idx_conceptos_tipo` (`tipo`),
  ADD KEY `idx_conceptos_activo` (`activo`),
  ADD KEY `idx_conceptos_anio` (`anio_academico`);

--
-- Indices de la tabla `configuraciones`
--
ALTER TABLE `configuraciones`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `clave` (`clave`),
  ADD KEY `idx_configuraciones_clave` (`clave`),
  ADD KEY `idx_configuraciones_categoria` (`categoria`);

--
-- Indices de la tabla `emails_enviados`
--
ALTER TABLE `emails_enviados`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_email_destinatario` (`email_destinatario`),
  ADD KEY `idx_email_estado` (`estado`),
  ADD KEY `idx_email_fecha` (`fecha_creacion`),
  ADD KEY `idx_email_estudiante` (`estudiante_id`),
  ADD KEY `fk_email_plantilla` (`plantilla_id`),
  ADD KEY `fk_email_factura` (`factura_id`),
  ADD KEY `fk_email_usuario` (`usuario_solicita`);

--
-- Indices de la tabla `email_logs`
--
ALTER TABLE `email_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_email_log_fecha` (`fecha_creacion`),
  ADD KEY `idx_email_log_tipo` (`tipo`),
  ADD KEY `idx_email_log_id` (`email_id`),
  ADD KEY `fk_email_log_usuario` (`usuario_id`);

--
-- Indices de la tabla `estudiantes`
--
ALTER TABLE `estudiantes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo_estudiante` (`codigo_estudiante`),
  ADD UNIQUE KEY `documento` (`documento`),
  ADD KEY `idx_estudiantes_codigo` (`codigo_estudiante`),
  ADD KEY `idx_estudiantes_documento` (`documento`),
  ADD KEY `idx_estudiantes_nombres` (`nombres`,`apellidos`),
  ADD KEY `idx_estudiantes_grado` (`grado_actual_id`),
  ADD KEY `idx_estudiantes_estado` (`estado`),
  ADD KEY `idx_estudiantes_responsable` (`responsable_id`),
  ADD KEY `idx_estudiantes_año` (`año_academico`),
  ADD KEY `idx_estudiante_año_estado` (`año_academico`,`estado`),
  ADD KEY `idx_estudiantes_estado_grado` (`estado`,`grado_actual_id`);

--
-- Indices de la tabla `eventos_calendario`
--
ALTER TABLE `eventos_calendario`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_evento_fecha_inicio` (`fecha_inicio`),
  ADD KEY `idx_evento_tipo` (`tipo`),
  ADD KEY `idx_evento_estudiante` (`estudiante_id`),
  ADD KEY `idx_evento_grado` (`grado_id`),
  ADD KEY `fk_evento_usuario` (`usuario_creacion`);

--
-- Indices de la tabla `facturas`
--
ALTER TABLE `facturas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `numero_factura` (`numero_factura`),
  ADD KEY `idx_facturas_estudiante` (`estudiante_id`),
  ADD KEY `idx_facturas_fecha` (`fecha_factura`),
  ADD KEY `idx_facturas_estado` (`estado`),
  ADD KEY `idx_facturas_vencimiento` (`fecha_vencimiento`),
  ADD KEY `fk_facturas_metodo_pago` (`metodo_pago_id`),
  ADD KEY `fk_facturas_usuario_creacion` (`usuario_creacion`),
  ADD KEY `fk_facturas_usuario_pago` (`usuario_pago`);

--
-- Indices de la tabla `facturas_detalle`
--
ALTER TABLE `facturas_detalle`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_facturas_detalle_factura` (`factura_id`),
  ADD KEY `idx_facturas_detalle_concepto` (`concepto_id`);

--
-- Indices de la tabla `grados`
--
ALTER TABLE `grados`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo` (`codigo`),
  ADD KEY `idx_grados_nivel` (`nivel`),
  ADD KEY `idx_grados_orden` (`orden_grado`);

--
-- Indices de la tabla `historial_grados`
--
ALTER TABLE `historial_grados`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_historial_unico` (`estudiante_id`,`año_academico`),
  ADD KEY `idx_historial_estudiante` (`estudiante_id`),
  ADD KEY `idx_historial_año` (`año_academico`),
  ADD KEY `idx_historial_estado` (`estado_anio`),
  ADD KEY `fk_historial_grado` (`grado_id`),
  ADD KEY `fk_historial_usuario` (`usuario_registro`);

--
-- Indices de la tabla `info_sistema`
--
ALTER TABLE `info_sistema`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_info_usuario_mod` (`usuario_modificacion`);

--
-- Indices de la tabla `log_accesos_portal`
--
ALTER TABLE `log_accesos_portal`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_log_responsable` (`responsable_id`),
  ADD KEY `idx_log_accion` (`accion`),
  ADD KEY `idx_log_fecha` (`fecha_acceso`),
  ADD KEY `fk_log_usuario` (`usuario_id`);

--
-- Indices de la tabla `mensajes`
--
ALTER TABLE `mensajes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_remitente` (`remitente_id`),
  ADD KEY `idx_destinatario` (`destinatario_id`),
  ADD KEY `idx_fecha_envio` (`fecha_envio`),
  ADD KEY `idx_leido` (`leido`),
  ADD KEY `idx_respuesta` (`respuesta_a`),
  ADD KEY `idx_bandeja_entrada` (`destinatario_id`,`eliminado_destinatario`,`fecha_envio`),
  ADD KEY `idx_bandeja_salida` (`remitente_id`,`eliminado_remitente`,`fecha_envio`);

--
-- Indices de la tabla `metodos_pago`
--
ALTER TABLE `metodos_pago`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo` (`codigo`),
  ADD KEY `idx_metodo_activo` (`activo`);

--
-- Indices de la tabla `modulos_sistema`
--
ALTER TABLE `modulos_sistema`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_modulo_codigo` (`codigo`);

--
-- Indices de la tabla `movimientos_caja`
--
ALTER TABLE `movimientos_caja`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_movimientos_caja_id` (`caja_id`),
  ADD KEY `idx_movimientos_tipo` (`tipo`),
  ADD KEY `idx_movimientos_fecha` (`fecha_movimiento`),
  ADD KEY `idx_movimiento_caja_fecha` (`caja_id`,`fecha_movimiento`),
  ADD KEY `idx_movimientos_factura` (`factura_id`),
  ADD KEY `fk_movimientos_pago` (`pago_id`),
  ADD KEY `fk_movimientos_autorizado` (`autorizado_por`),
  ADD KEY `fk_movimientos_usuario` (`usuario_registro`);

--
-- Indices de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_notif_usuario` (`usuario_destino`),
  ADD KEY `idx_notif_tipo` (`tipo`),
  ADD KEY `idx_notif_leida` (`leida`),
  ADD KEY `idx_notif_fecha` (`fecha_creacion`),
  ADD KEY `fk_notif_estudiante` (`estudiante_id`),
  ADD KEY `fk_notif_pago` (`pago_id`);

--
-- Indices de la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `numero_recibo` (`numero_recibo`),
  ADD KEY `idx_pagos_recibo` (`numero_recibo`),
  ADD KEY `idx_pagos_estudiante` (`estudiante_id`),
  ADD KEY `idx_pagos_concepto` (`concepto_id`),
  ADD KEY `idx_pagos_fecha` (`fecha_pago`),
  ADD KEY `idx_pagos_periodo` (`periodo`),
  ADD KEY `idx_pagos_estado` (`estado`),
  ADD KEY `idx_pagos_metodo` (`metodo_pago`),
  ADD KEY `idx_pago_fecha_estado` (`fecha_pago`,`estado`),
  ADD KEY `idx_pago_estudiante_concepto` (`estudiante_id`,`concepto_id`),
  ADD KEY `idx_pagos_estudiante_fecha` (`estudiante_id`,`fecha_pago`),
  ADD KEY `idx_pagos_factura` (`factura_id`),
  ADD KEY `idx_pagos_pension` (`pension_programada_id`),
  ADD KEY `idx_pago_padre` (`pago_padre_id`),
  ADD KEY `idx_pagos_responsable` (`responsable_id`),
  ADD KEY `idx_pagos_grado` (`grado_id`),
  ADD KEY `idx_pagos_origen` (`origen_pago`),
  ADD KEY `idx_estudiante_periodo` (`estudiante_id`,`periodo`),
  ADD KEY `idx_estudiante_anio` (`estudiante_id`,`anio_academico`),
  ADD KEY `idx_pagos_responsable_año` (`responsable_id`,`anio_academico`),
  ADD KEY `idx_pagos_beca` (`beca_id`),
  ADD KEY `fk_pagos_caja` (`caja_id`),
  ADD KEY `fk_pagos_usuario` (`usuario_id`),
  ADD KEY `fk_pagos_usuario_anulacion` (`usuario_anulacion`),
  ADD KEY `fk_pagos_usuario_conciliacion` (`usuario_conciliacion`),
  ADD KEY `fk_pagos_usuario_modificacion` (`usuario_modificacion`);

--
-- Indices de la tabla `password_resets`
--
ALTER TABLE `password_resets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token` (`token`),
  ADD KEY `usuario_id` (`usuario_id`),
  ADD KEY `idx_token_expiracion` (`token`,`expiracion`,`usado`);

--
-- Indices de la tabla `pensiones_programadas`
--
ALTER TABLE `pensiones_programadas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_estudiante` (`estudiante_id`),
  ADD KEY `idx_concepto` (`concepto_id`),
  ADD KEY `idx_periodo` (`periodo`),
  ADD KEY `idx_estado` (`estado`),
  ADD KEY `idx_fecha_vencimiento` (`fecha_vencimiento`),
  ADD KEY `idx_pp_estado_vencimiento` (`estado`,`fecha_vencimiento`),
  ADD KEY `idx_pp_año_estado` (`año_academico`,`estado`),
  ADD KEY `fk_pension_factura` (`factura_id`);

--
-- Indices de la tabla `periodos_academicos`
--
ALTER TABLE `periodos_academicos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_año` (`año`),
  ADD KEY `fk_periodo_usuario_apertura` (`usuario_apertura`),
  ADD KEY `fk_periodo_usuario_cierre` (`usuario_cierre`);

--
-- Indices de la tabla `permisos_rol`
--
ALTER TABLE `permisos_rol`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_rol_modulo` (`rol`,`modulo_id`),
  ADD KEY `idx_permisos_rol` (`rol`),
  ADD KEY `fk_permisos_modulo` (`modulo_id`),
  ADD KEY `fk_permisos_usuario` (`usuario_modificacion`);

--
-- Indices de la tabla `plantillas_email`
--
ALTER TABLE `plantillas_email`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo` (`codigo`),
  ADD KEY `idx_plantilla_tipo` (`tipo`),
  ADD KEY `fk_plantilla_usuario` (`usuario_creacion`);

--
-- Indices de la tabla `programacion_cobros`
--
ALTER TABLE `programacion_cobros`
  ADD PRIMARY KEY (`id`),
  ADD KEY `concepto_id` (`concepto_id`),
  ADD KEY `grado_id` (`grado_id`),
  ADD KEY `fecha_cobro` (`fecha_cobro`),
  ADD KEY `estado` (`estado`),
  ADD KEY `fk_programacion_usuario` (`usuario_id`);

--
-- Indices de la tabla `reglas_mora`
--
ALTER TABLE `reglas_mora`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_mora_activa` (`activa`),
  ADD KEY `idx_mora_vigencia` (`fecha_vigencia_inicio`,`fecha_vigencia_fin`),
  ADD KEY `fk_mora_concepto` (`concepto_id`),
  ADD KEY `fk_mora_grado` (`grado_id`),
  ADD KEY `fk_mora_periodo` (`periodo_academico_id`),
  ADD KEY `fk_mora_usuario` (`usuario_creacion`);

--
-- Indices de la tabla `responsables`
--
ALTER TABLE `responsables`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `documento` (`documento`),
  ADD KEY `idx_responsables_documento` (`documento`),
  ADD KEY `idx_responsables_nombres` (`nombres`,`apellidos`),
  ADD KEY `idx_responsables_activo` (`activo`),
  ADD KEY `idx_responsables_usuario` (`usuario_id`);

--
-- Indices de la tabla `sesiones_usuarios`
--
ALTER TABLE `sesiones_usuarios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_sesion_usuario` (`usuario_id`),
  ADD KEY `idx_sesion_activa` (`activa`),
  ADD KEY `idx_sesion_expiracion` (`fecha_expiracion`);

--
-- Indices de la tabla `solicitudes_acceso`
--
ALTER TABLE `solicitudes_acceso`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_sol_responsable` (`responsable_id`),
  ADD KEY `idx_sol_estado` (`estado`),
  ADD KEY `idx_sol_fecha` (`fecha_solicitud`),
  ADD KEY `idx_sol_documento` (`documento`),
  ADD KEY `fk_sol_usr_revision` (`usuario_revision`),
  ADD KEY `fk_sol_usr_creado` (`usuario_creado`);

--
-- Indices de la tabla `solicitudes_pago_portal`
--
ALTER TABLE `solicitudes_pago_portal`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_solicitud_responsable` (`responsable_id`),
  ADD KEY `idx_solicitud_estudiante` (`estudiante_id`),
  ADD KEY `idx_solicitud_estado` (`estado`),
  ADD KEY `idx_solicitud_fecha` (`fecha_solicitud`),
  ADD KEY `fk_solicitud_pension` (`pension_programada_id`),
  ADD KEY `fk_solicitud_factura` (`factura_id`),
  ADD KEY `fk_solicitud_pago` (`pago_id`),
  ADD KEY `fk_solicitud_usuario_revision` (`usuario_revision`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_usuarios_email` (`email`),
  ADD KEY `idx_usuarios_rol` (`rol`),
  ADD KEY `idx_usuarios_activo` (`activo`);

--
-- Indices de la tabla `valores_concepto_grado`
--
ALTER TABLE `valores_concepto_grado`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_valores_unique` (`concepto_id`,`grado_id`,`anio_academico`),
  ADD KEY `idx_valores_concepto` (`concepto_id`),
  ADD KEY `idx_valores_grado_año` (`grado_id`,`anio_academico`);

--
-- Indices de la tabla `valores_concepto_grado_historico`
--
ALTER TABLE `valores_concepto_grado_historico`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_valores_historico_unique` (`concepto_historico_id`,`grado_id`,`anio_academico`),
  ADD KEY `fk_valores_hist_grado` (`grado_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `ajustes_historicos`
--
ALTER TABLE `ajustes_historicos`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `archivos_sistema`
--
ALTER TABLE `archivos_sistema`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `auditoria_acciones`
--
ALTER TABLE `auditoria_acciones`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `auditoria_cambios`
--
ALTER TABLE `auditoria_cambios`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `becas_descuentos`
--
ALTER TABLE `becas_descuentos`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `caja_diaria`
--
ALTER TABLE `caja_diaria`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `conceptos_historico`
--
ALTER TABLE `conceptos_historico`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `conceptos_pago`
--
ALTER TABLE `conceptos_pago`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `configuraciones`
--
ALTER TABLE `configuraciones`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `emails_enviados`
--
ALTER TABLE `emails_enviados`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `email_logs`
--
ALTER TABLE `email_logs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `estudiantes`
--
ALTER TABLE `estudiantes`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `eventos_calendario`
--
ALTER TABLE `eventos_calendario`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `facturas`
--
ALTER TABLE `facturas`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `facturas_detalle`
--
ALTER TABLE `facturas_detalle`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `grados`
--
ALTER TABLE `grados`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `historial_grados`
--
ALTER TABLE `historial_grados`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `info_sistema`
--
ALTER TABLE `info_sistema`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `log_accesos_portal`
--
ALTER TABLE `log_accesos_portal`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `mensajes`
--
ALTER TABLE `mensajes`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `metodos_pago`
--
ALTER TABLE `metodos_pago`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `modulos_sistema`
--
ALTER TABLE `modulos_sistema`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `movimientos_caja`
--
ALTER TABLE `movimientos_caja`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pagos`
--
ALTER TABLE `pagos`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `password_resets`
--
ALTER TABLE `password_resets`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pensiones_programadas`
--
ALTER TABLE `pensiones_programadas`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `periodos_academicos`
--
ALTER TABLE `periodos_academicos`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `permisos_rol`
--
ALTER TABLE `permisos_rol`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `plantillas_email`
--
ALTER TABLE `plantillas_email`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `programacion_cobros`
--
ALTER TABLE `programacion_cobros`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `reglas_mora`
--
ALTER TABLE `reglas_mora`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `responsables`
--
ALTER TABLE `responsables`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `solicitudes_acceso`
--
ALTER TABLE `solicitudes_acceso`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `solicitudes_pago_portal`
--
ALTER TABLE `solicitudes_pago_portal`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `valores_concepto_grado`
--
ALTER TABLE `valores_concepto_grado`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `valores_concepto_grado_historico`
--
ALTER TABLE `valores_concepto_grado_historico`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_cartera_estudiantes`
--
DROP TABLE IF EXISTS `vista_cartera_estudiantes`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_cartera_estudiantes`  AS SELECT `e`.`id` AS `estudiante_id`, concat(`e`.`nombres`,' ',`e`.`apellidos`) AS `nombre_completo`, `e`.`codigo_estudiante` AS `codigo_estudiante`, `g`.`nombre` AS `grado`, `g`.`nivel` AS `nivel`, `e`.`año_academico` AS `año_academico`, count(`pp`.`id`) AS `total_pensiones`, sum((case when (`pp`.`estado` = 'pendiente') then 1 else 0 end)) AS `pensiones_pendientes`, sum((case when (`pp`.`estado` = 'vencido') then 1 else 0 end)) AS `pensiones_vencidas`, coalesce(sum((case when (`pp`.`estado` in ('pendiente','vencido')) then `pp`.`saldo_pendiente` else 0 end)),0) AS `saldo_total_pendiente`, coalesce(sum((case when (`pp`.`estado` = 'vencido') then `pp`.`saldo_pendiente` else 0 end)),0) AS `saldo_en_mora`, max((case when (`pp`.`estado` = 'vencido') then (to_days(curdate()) - to_days(`pp`.`fecha_vencimiento`)) else 0 end)) AS `max_dias_mora`, (case when (max((case when (`pp`.`estado` = 'vencido') then (to_days(curdate()) - to_days(`pp`.`fecha_vencimiento`)) else 0 end)) = 0) then 'al_dia' when (max((case when (`pp`.`estado` = 'vencido') then (to_days(curdate()) - to_days(`pp`.`fecha_vencimiento`)) else 0 end)) <= 30) then 'mora_leve' when (max((case when (`pp`.`estado` = 'vencido') then (to_days(curdate()) - to_days(`pp`.`fecha_vencimiento`)) else 0 end)) <= 90) then 'mora_moderada' else 'mora_grave' end) AS `clasificacion_mora`, concat(`r`.`nombres`,' ',`r`.`apellidos`) AS `responsable`, `r`.`email` AS `email_responsable`, `r`.`telefono` AS `telefono_responsable` FROM (((`estudiantes` `e` join `grados` `g` on((`e`.`grado_actual_id` = `g`.`id`))) join `responsables` `r` on((`e`.`responsable_id` = `r`.`id`))) left join `pensiones_programadas` `pp` on((`pp`.`estudiante_id` = `e`.`id`))) WHERE (`e`.`estado` = 'activo') GROUP BY `e`.`id`, `e`.`nombres`, `e`.`apellidos`, `e`.`codigo_estudiante`, `g`.`nombre`, `g`.`nivel`, `e`.`año_academico`, `r`.`nombres`, `r`.`apellidos`, `r`.`email`, `r`.`telefono` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_estado_financiero_estudiante`
--
DROP TABLE IF EXISTS `vista_estado_financiero_estudiante`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_estado_financiero_estudiante`  AS SELECT `e`.`id` AS `estudiante_id`, concat(`e`.`nombres`,' ',`e`.`apellidos`) AS `nombre_completo`, `e`.`codigo_estudiante` AS `codigo_estudiante`, `g`.`nombre` AS `grado`, `e`.`año_academico` AS `año_academico`, count(distinct `p`.`id`) AS `total_pagos_realizados`, coalesce(sum((case when (`p`.`estado` = 'pagado') then `p`.`valor_total` else 0 end)),0) AS `total_pagado`, count(distinct `pp`.`id`) AS `total_pensiones_generadas`, coalesce(sum((case when (`pp`.`estado` in ('pendiente','vencido')) then `pp`.`valor_final` else 0 end)),0) AS `total_pendiente`, count(distinct `bd`.`id`) AS `becas_activas` FROM ((((`estudiantes` `e` join `grados` `g` on((`e`.`grado_actual_id` = `g`.`id`))) left join `pagos` `p` on(((`p`.`estudiante_id` = `e`.`id`) and (`p`.`anio_academico` = `e`.`año_academico`)))) left join `pensiones_programadas` `pp` on(((`pp`.`estudiante_id` = `e`.`id`) and (`pp`.`año_academico` = `e`.`año_academico`)))) left join `becas_descuentos` `bd` on(((`bd`.`estudiante_id` = `e`.`id`) and (`bd`.`activo` = 1) and (`bd`.`año_academico` = `e`.`año_academico`)))) WHERE (`e`.`estado` = 'activo') GROUP BY `e`.`id`, `e`.`nombres`, `e`.`apellidos`, `e`.`codigo_estudiante`, `g`.`nombre`, `e`.`año_academico` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_resumen_caja_mensual`
--
DROP TABLE IF EXISTS `vista_resumen_caja_mensual`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_resumen_caja_mensual`  AS SELECT year(`cd`.`fecha`) AS `año`, month(`cd`.`fecha`) AS `mes`, monthname(`cd`.`fecha`) AS `nombre_mes`, count(`cd`.`id`) AS `dias_operados`, sum(`cd`.`total_ingresos`) AS `total_ingresos`, sum(`cd`.`total_egresos`) AS `total_egresos`, sum((`cd`.`total_ingresos` - `cd`.`total_egresos`)) AS `utilidad_neta`, sum((case when (`cd`.`estado` = 'cuadrada') then 1 else 0 end)) AS `cajas_cuadradas`, sum((case when (`cd`.`estado` = 'cerrada') then 1 else 0 end)) AS `cajas_sin_cuadrar` FROM `caja_diaria` AS `cd` GROUP BY year(`cd`.`fecha`), month(`cd`.`fecha`), monthname(`cd`.`fecha`) ORDER BY `año` DESC, `mes` DESC ;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `ajustes_historicos`
--
ALTER TABLE `ajustes_historicos`
  ADD CONSTRAINT `fk_ajustes_usuario_registro` FOREIGN KEY (`usuario_registro`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `fk_ajustes_usuario_reversion` FOREIGN KEY (`usuario_reversion`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `archivos_sistema`
--
ALTER TABLE `archivos_sistema`
  ADD CONSTRAINT `fk_archivos_estudiante` FOREIGN KEY (`estudiante_id`) REFERENCES `estudiantes` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_archivos_factura` FOREIGN KEY (`factura_id`) REFERENCES `facturas` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_archivos_pago` FOREIGN KEY (`pago_id`) REFERENCES `pagos` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_archivos_usuario` FOREIGN KEY (`usuario_subida`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `auditoria_acciones`
--
ALTER TABLE `auditoria_acciones`
  ADD CONSTRAINT `fk_auditoria_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `auditoria_cambios`
--
ALTER TABLE `auditoria_cambios`
  ADD CONSTRAINT `fk_auditoria_cambios_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `becas_descuentos`
--
ALTER TABLE `becas_descuentos`
  ADD CONSTRAINT `fk_becas_estudiante` FOREIGN KEY (`estudiante_id`) REFERENCES `estudiantes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_becas_usuario` FOREIGN KEY (`usuario_creacion`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `caja_diaria`
--
ALTER TABLE `caja_diaria`
  ADD CONSTRAINT `fk_caja_usuario_apertura` FOREIGN KEY (`usuario_apertura`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_caja_usuario_cierre` FOREIGN KEY (`usuario_cierre`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `conceptos_historico`
--
ALTER TABLE `conceptos_historico`
  ADD CONSTRAINT `fk_historico_concepto` FOREIGN KEY (`concepto_id`) REFERENCES `conceptos_pago` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `fk_historico_usuario` FOREIGN KEY (`usuario_creacion`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `emails_enviados`
--
ALTER TABLE `emails_enviados`
  ADD CONSTRAINT `fk_email_estudiante` FOREIGN KEY (`estudiante_id`) REFERENCES `estudiantes` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_email_factura` FOREIGN KEY (`factura_id`) REFERENCES `facturas` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_email_plantilla` FOREIGN KEY (`plantilla_id`) REFERENCES `plantillas_email` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_email_usuario` FOREIGN KEY (`usuario_solicita`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `email_logs`
--
ALTER TABLE `email_logs`
  ADD CONSTRAINT `fk_email_log_email` FOREIGN KEY (`email_id`) REFERENCES `emails_enviados` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_email_log_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `estudiantes`
--
ALTER TABLE `estudiantes`
  ADD CONSTRAINT `fk_estudiantes_grado` FOREIGN KEY (`grado_actual_id`) REFERENCES `grados` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `fk_estudiantes_responsable` FOREIGN KEY (`responsable_id`) REFERENCES `responsables` (`id`) ON DELETE RESTRICT;

--
-- Filtros para la tabla `eventos_calendario`
--
ALTER TABLE `eventos_calendario`
  ADD CONSTRAINT `fk_evento_estudiante` FOREIGN KEY (`estudiante_id`) REFERENCES `estudiantes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_evento_grado` FOREIGN KEY (`grado_id`) REFERENCES `grados` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_evento_usuario` FOREIGN KEY (`usuario_creacion`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `facturas`
--
ALTER TABLE `facturas`
  ADD CONSTRAINT `fk_facturas_estudiante` FOREIGN KEY (`estudiante_id`) REFERENCES `estudiantes` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `fk_facturas_metodo_pago` FOREIGN KEY (`metodo_pago_id`) REFERENCES `metodos_pago` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_facturas_usuario_creacion` FOREIGN KEY (`usuario_creacion`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `fk_facturas_usuario_pago` FOREIGN KEY (`usuario_pago`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `facturas_detalle`
--
ALTER TABLE `facturas_detalle`
  ADD CONSTRAINT `fk_detalle_concepto` FOREIGN KEY (`concepto_id`) REFERENCES `conceptos_pago` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `fk_detalle_factura` FOREIGN KEY (`factura_id`) REFERENCES `facturas` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `historial_grados`
--
ALTER TABLE `historial_grados`
  ADD CONSTRAINT `fk_historial_estudiante` FOREIGN KEY (`estudiante_id`) REFERENCES `estudiantes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_historial_grado` FOREIGN KEY (`grado_id`) REFERENCES `grados` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `fk_historial_usuario` FOREIGN KEY (`usuario_registro`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `info_sistema`
--
ALTER TABLE `info_sistema`
  ADD CONSTRAINT `fk_info_usuario_modificacion` FOREIGN KEY (`usuario_modificacion`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `log_accesos_portal`
--
ALTER TABLE `log_accesos_portal`
  ADD CONSTRAINT `fk_log_responsable` FOREIGN KEY (`responsable_id`) REFERENCES `responsables` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_log_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `mensajes`
--
ALTER TABLE `mensajes`
  ADD CONSTRAINT `fk_mensajes_destinatario` FOREIGN KEY (`destinatario_id`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `fk_mensajes_remitente` FOREIGN KEY (`remitente_id`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `fk_mensajes_respuesta` FOREIGN KEY (`respuesta_a`) REFERENCES `mensajes` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `movimientos_caja`
--
ALTER TABLE `movimientos_caja`
  ADD CONSTRAINT `fk_movimientos_autorizado` FOREIGN KEY (`autorizado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_movimientos_caja` FOREIGN KEY (`caja_id`) REFERENCES `caja_diaria` (`id`),
  ADD CONSTRAINT `fk_movimientos_factura` FOREIGN KEY (`factura_id`) REFERENCES `facturas` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_movimientos_pago` FOREIGN KEY (`pago_id`) REFERENCES `pagos` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_movimientos_usuario` FOREIGN KEY (`usuario_registro`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD CONSTRAINT `fk_notif_estudiante` FOREIGN KEY (`estudiante_id`) REFERENCES `estudiantes` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_notif_pago` FOREIGN KEY (`pago_id`) REFERENCES `pagos` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_notif_usuario` FOREIGN KEY (`usuario_destino`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD CONSTRAINT `fk_pagos_beca` FOREIGN KEY (`beca_id`) REFERENCES `becas_descuentos` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_pagos_caja` FOREIGN KEY (`caja_id`) REFERENCES `caja_diaria` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_pagos_concepto` FOREIGN KEY (`concepto_id`) REFERENCES `conceptos_pago` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `fk_pagos_estudiante` FOREIGN KEY (`estudiante_id`) REFERENCES `estudiantes` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `fk_pagos_factura` FOREIGN KEY (`factura_id`) REFERENCES `facturas` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_pagos_grado` FOREIGN KEY (`grado_id`) REFERENCES `grados` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_pagos_pension` FOREIGN KEY (`pension_programada_id`) REFERENCES `pensiones_programadas` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_pagos_responsable` FOREIGN KEY (`responsable_id`) REFERENCES `responsables` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_pagos_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `fk_pagos_usuario_anulacion` FOREIGN KEY (`usuario_anulacion`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_pagos_usuario_conciliacion` FOREIGN KEY (`usuario_conciliacion`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_pagos_usuario_modificacion` FOREIGN KEY (`usuario_modificacion`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `password_resets`
--
ALTER TABLE `password_resets`
  ADD CONSTRAINT `fk_password_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `pensiones_programadas`
--
ALTER TABLE `pensiones_programadas`
  ADD CONSTRAINT `fk_pension_concepto` FOREIGN KEY (`concepto_id`) REFERENCES `conceptos_pago` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `fk_pension_estudiante` FOREIGN KEY (`estudiante_id`) REFERENCES `estudiantes` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `fk_pension_factura` FOREIGN KEY (`factura_id`) REFERENCES `facturas` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `periodos_academicos`
--
ALTER TABLE `periodos_academicos`
  ADD CONSTRAINT `fk_periodo_usuario_apertura` FOREIGN KEY (`usuario_apertura`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_periodo_usuario_cierre` FOREIGN KEY (`usuario_cierre`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `permisos_rol`
--
ALTER TABLE `permisos_rol`
  ADD CONSTRAINT `fk_permisos_modulo` FOREIGN KEY (`modulo_id`) REFERENCES `modulos_sistema` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_permisos_usuario` FOREIGN KEY (`usuario_modificacion`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `plantillas_email`
--
ALTER TABLE `plantillas_email`
  ADD CONSTRAINT `fk_plantilla_usuario` FOREIGN KEY (`usuario_creacion`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `programacion_cobros`
--
ALTER TABLE `programacion_cobros`
  ADD CONSTRAINT `fk_programacion_concepto` FOREIGN KEY (`concepto_id`) REFERENCES `conceptos_pago` (`id`),
  ADD CONSTRAINT `fk_programacion_grado` FOREIGN KEY (`grado_id`) REFERENCES `grados` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_programacion_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `reglas_mora`
--
ALTER TABLE `reglas_mora`
  ADD CONSTRAINT `fk_mora_concepto` FOREIGN KEY (`concepto_id`) REFERENCES `conceptos_pago` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_mora_grado` FOREIGN KEY (`grado_id`) REFERENCES `grados` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_mora_periodo` FOREIGN KEY (`periodo_academico_id`) REFERENCES `periodos_academicos` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_mora_usuario` FOREIGN KEY (`usuario_creacion`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `responsables`
--
ALTER TABLE `responsables`
  ADD CONSTRAINT `fk_responsables_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `sesiones_usuarios`
--
ALTER TABLE `sesiones_usuarios`
  ADD CONSTRAINT `fk_sesiones_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `solicitudes_acceso`
--
ALTER TABLE `solicitudes_acceso`
  ADD CONSTRAINT `fk_sol_responsable` FOREIGN KEY (`responsable_id`) REFERENCES `responsables` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_sol_usr_creado` FOREIGN KEY (`usuario_creado`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_sol_usr_revision` FOREIGN KEY (`usuario_revision`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `solicitudes_pago_portal`
--
ALTER TABLE `solicitudes_pago_portal`
  ADD CONSTRAINT `fk_solicitud_estudiante` FOREIGN KEY (`estudiante_id`) REFERENCES `estudiantes` (`id`),
  ADD CONSTRAINT `fk_solicitud_factura` FOREIGN KEY (`factura_id`) REFERENCES `facturas` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_solicitud_pago` FOREIGN KEY (`pago_id`) REFERENCES `pagos` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_solicitud_pension` FOREIGN KEY (`pension_programada_id`) REFERENCES `pensiones_programadas` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_solicitud_responsable` FOREIGN KEY (`responsable_id`) REFERENCES `responsables` (`id`),
  ADD CONSTRAINT `fk_solicitud_usuario_revision` FOREIGN KEY (`usuario_revision`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `valores_concepto_grado`
--
ALTER TABLE `valores_concepto_grado`
  ADD CONSTRAINT `fk_vcg_concepto` FOREIGN KEY (`concepto_id`) REFERENCES `conceptos_pago` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_vcg_grado` FOREIGN KEY (`grado_id`) REFERENCES `grados` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `valores_concepto_grado_historico`
--
ALTER TABLE `valores_concepto_grado_historico`
  ADD CONSTRAINT `fk_valores_hist_concepto` FOREIGN KEY (`concepto_historico_id`) REFERENCES `conceptos_historico` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_valores_hist_grado` FOREIGN KEY (`grado_id`) REFERENCES `grados` (`id`) ON DELETE RESTRICT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
