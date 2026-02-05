# Buscador BancoSol - Prueba Técnica Fullstack

Reto técnico - gestión de catálogo de productos. Aplicación móvil desarrollada en **Flutter** con backend en **.NET**, implementando una arquitectura escalable y características avanzadas de UX/UI a criterio propio.

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![.NET](https://img.shields.io/badge/.NET-8.0-purple?logo=dotnet)
![Architecture](https://img.shields.io/badge/Architecture-Clean-green)

---

## BAJO EL DOCUMENTO REMITIDO MEDIANTE CORREO SE DETALLA LO SIGUIENTE SEGÚN LOS PUNTOS DESCRITOS EN EL MISMO:

## Objetivo

**Listado de Productos** (Cumplido), se visualiza nombre, SKU, precio, moneda y stock entre otros parametros.
**Búsqueda** (Cumplido) Búsqueda en tiempo real (por Nombre o SKU) optimizada con *Debounce* como se lo pidió.
**Actualización de Precio** (Cumplido) Endpoint `PATCH` específico validando precios > 0.
**Validaciones:** (Cumplido) Manejo de errores 404 y reglas de negocio.

## Alcance Funcional

---

### Backend (.NET - API)
- El **Framework** que se utilizó para la creación del backend es .NET 8 (Debido a que es la versión más estable y con soporte, se toma nota que la versión acutal de .NET es "10").
- Se creo una API REST con endpoints solicitados (GET: Devolución de productos y productos filtrados por name o sku)
- La actualización SOLO del precio esta validad para mayores de 0 Bs. y si no existe mandará la correspondiente respuesta de 404 (Producto no encontrado).
- La persitencia sugerida es (Listas, SQLite o EF Core); se utilizó EF Core (In-Memory Database) para una ejecución rápida y sin dependencias externas ("ProductDb").
- Swagger / OpenAPI integrado.
- Consistente y bien estructurado creando la arquitectura con un MODELO, DTO y la correspondiente inyección de dependencias para pasar el AppDbContext a los endpoints correspondientes, manejando códigos de estado HTTP (400, 200, 404).
- Se configuró el CORS para permitir conexiones desde flutter.

---

### Frontend (Flutter)
- El Framework que se utilizó para la creación del frontend es Flutter en su versión STABLE a la fecha 5/2/2026 (3.38.9).
- Se completó las pantalla solicitada del LISTADO DE PRODUCTOS con los widgets de BÚSQUEDA y la interacción para EDITAR PRECIO.
### Reglas y validaciones
- El precio se actualiza SOLO con el ENDPOINT de PRECIO (PATCH).
- Se validó que el precio sea mayor a 0 (price > 0) y que el campo no esté vacío.
- Se realizó la visualización de mensajes de error y respuestas limpias en el FRONT.
### Liberías
- Para la gestión de estados usé RIVERPOD debido al tamaño de la aplicación y su fácil testeo y verificación por parte de QA o Arquitectos; (NotifierProvider & StateNotifier) para una gestión reactiva y desacoplada.
- Se usó Dio para el tema de conexión HTTP (con interceptores y configuración de Timeouts).
- Se usó go_router para la navegación en toda la aplicación (con la visión de implementar más pantallas o sea escalable).
- intl para formatear fechas, horas, monedas, precios, etc...
- google_fonts para la fuente a utilizar descrita abajo (ROBOTO y POPPINS)
**Arquitectura:** La arquitecura utilizada es **Clean Architecture** (Separación estricta en capas: *Domain, Data, Presentation*).

---

## Criterios de Evaluación
Los criterios de evaluación fueron tomados en cuenta y fueron realizados exitosamente de forma limpia y escalable.

---

### Features "Plus" Implementados
**Paginación Infinita (Infinite Scroll):** Carga eficiente de datos en bloques de 15 elementos para optimizar rendimiento (es infinito, solo para pruebas visuales).
**Filtros y Ordenamiento:** Filtrado por disponibilidad (Stock) y ordenamiento por precio (Asc/Desc) gestionado desde el backend.
**Tema Dinámico (Light/Dark):** Interfaz adaptativa que respeta la configuración del sistema (Claro/Oscuro).
**Tests Unitarios:** Pruebas unitarias en el parseo de datos (Modelos) por parte del front.
**UI/UX Cuidada:** Feedback visual, estados de carga (spinners/loadings), manejo de errores amigable y diseño tipo "Fintech".

---

## Guía de Ejecución

Sigue estos pasos para levantar el entorno de desarrollo completo.

*UNA VEZ CLONADO EL PROYECTO REALIZAR LOS SIGUIENTES PASOS DENTRO DE LA CARPETA:*

### 1. Backend (.NET 8)
El backend actúa como servidor central. Es vital iniciarlo primero.

**Requisitos:** .NET 8 SDK instalado.

1.  **Navegar al directorio:**
    ```bash
    cd backend
    ```
2.  **Restaura los paquetes:**
    ```bash
    dotnet restore
    ```
3.  **Ejecuta el Servidor:**
    **Importante:** Usamos el flag `--urls` para permitir conexiones externas (desde el celular), no solo localhost, en caso de que se requiera hacer pruebas desde un dispositivo físico y no desde un emulador de android.
    Se dejó indicaciones también en el archivo ...\prueba_fs_bancosol\frontend\lib\core\api_client.dart como comentario
    ```bash
    dotnet run --urls "[http://0.0.0.0:5080](http://0.0.0.0:5080)"
    ```
    El puerto utilizado es **5080**, tomar nota.

Abre tu navegador en `http://localhost:5080/swagger`. Deberías ver la documentación de la API.

---

### 2. Frontend (Flutter)
La app móvil requiere configurar la dirección IP para saber dónde encontrar al backend.

**Requisitos:** Flutter SDK versión 3.38.9, Android Studio/VS Code.

#### Paso A: Configurar la IP (Crucial)
Abre el archivo `lib/core/api_client.dart` y modifica la constante `_baseUrl` según dónde ejecutarás la app:
Se dejó indicaciones también dentro del archivo como comentario en los *ToDo's*.

**Opción 1: Emulador de Android**
El emulador usa una IP mágica para ver el localhost de tu PC.
```dart
const String _baseUrl = '[http://10.0.2.2:5080](http://10.0.2.2:5080)';
```
**Opción 2: Dispostivo Físico**
Se debe copiar la dirección de IPv4 dentro de la variable `_baseUrl` y recien ejecutar la aplicación para que no haya detalles o roturas de la apicación.
```dart
# Ejemplo 192.168.1.11
const String _baseUrl = 'http://192.168.1.11:5080';
```
