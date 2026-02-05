import 'package:dio/dio.dart';

// ToDo: Si se necesita ejecutar en un dispositivo físico, cambiar la IP anterior por la IP local del equipo donde se ejecuta el backend.
// ToDo: Ejemplo: const String _baseUrl = 'http://192.168.0.1 (IP local):5080';
// ToDo: Para sacar la ip local en Windows, ejecutar el comando `ipconfig` en la terminal y buscar la dirección IPv4 correspondiente a la conexión activa.
// ToDo: El puerto :5080 es el puerto donde se ejecuta el backend. Este valor no debe modificarse.
// ToDo: El valor localhost no es válido para emuladores de Android ni dispositivos físicos debido a que se refiere al propio dispositivo.
// ToDo: NOTA, EL CELULAR FÍSICO DEBE ESTAR CONECTADO A LA MISMA RED WIFI QUE LA COMPUTADORA DONDE SE EJECUTA EL BACKEND.!!!!. EN CASO DE UN EMULADOR ANDROID NO ES NECESARIO.
const String _baseUrl = 'http://10.0.2.2:5080';

final dioClient = Dio(
  BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),
);
