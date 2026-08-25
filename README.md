# Talent App

Talent App es una aplicación social deportiva desarrollada con Flutter. Su objetivo es conectar deportistas, scouts y managers en un mismo espacio para crear un perfil deportivo, compartir contenido, descubrir talento y conversar con otros usuarios.

El flujo principal está orientado a Android e iOS y utiliza Firebase como backend.

## Funcionalidades

- Registro e inicio de sesión con correo y contraseña.
- Alta diferenciada para perfiles de deportista, scout y manager.
- Perfil deportivo con información personal, deporte, modalidad, biografía y foto.
- Sistema de seguidores y seguidos.
- Feed con las publicaciones de las cuentas seguidas.
- Explorador de publicaciones de otros usuarios.
- Creación de posts con varias imágenes o vídeos seleccionados desde la galería.
- Chat individual en tiempo real con estados de envío y lectura.
- Interfaz con tema claro y oscuro.
- Textos localizados en español e inglés, con inglés como idioma de respaldo.

También existen pantallas y código preliminar para retos, ubicaciones, búsqueda y algunas opciones de configuración, pero estos flujos todavía no están integrados por completo en la navegación principal.

## Tecnologías principales

- **Flutter y Dart** para la aplicación multiplataforma.
- **Provider / ChangeNotifier** para la gestión de estado.
- **Firebase Authentication** para las cuentas de usuario.
- **Cloud Firestore** para usuarios, publicaciones, chats, deportes y modalidades.
- **Firebase Storage** para fotos de perfil y archivos multimedia.
- **Firebase Cloud Messaging** para registrar el token de notificaciones del usuario.
- **Flutter Secure Storage** para conservar el token de autenticación en el dispositivo.
- `photo_manager`, `image_picker` y `video_player` para trabajar con contenido multimedia.

La aplicación accede directamente a los servicios de Firebase; no incluye un servidor propio dentro de este repositorio.

## Estructura del proyecto

```text
lib/
├── main.dart          # Inicialización de Firebase, providers, tema y rutas
├── models/            # Entidades de dominio: usuario, post, chat, mensaje...
├── providers/         # Estado específico de edición de perfil
├── screens/           # Pantallas agrupadas por funcionalidad
├── services/          # Acceso a Authentication, Firestore y Storage
├── style/             # Colores y temas de la aplicación
├── templates/         # Estructuras reutilizables de registro y subida
├── utils/             # Localización, configuración y utilidades responsive
└── widgets/           # Componentes visuales reutilizables

assets/
├── images/            # Iconos, fondos e imágenes de la interfaz
└── strings/           # Traducciones en español e inglés
```

El flujo de arranque se inicia en `SplashScreen`: comprueba si existe una sesión, carga el usuario desde Firestore y dirige al onboarding, a la edición del perfil incompleto o al feed principal.

## Modelo de datos

Las colecciones de Firestore utilizadas por la aplicación son:

| Colección    | Contenido                                                         |
| ------------ | ----------------------------------------------------------------- |
| `users`      | Perfil, tipo de usuario, deporte, modalidad y relaciones sociales |
| `posts`      | Autor, descripción, referencias a archivos y fecha de publicación |
| `chats`      | Participantes y mensajes de las conversaciones                    |
| `sports`     | Catálogo de deportes                                              |
| `modalities` | Modalidades asociadas a cada deporte                              |

En Firebase Storage, las fotos de perfil se guardan como `<uid>/profile.png` y los archivos de cada publicación bajo `<uid>/posts/<post-id>/`.

## Requisitos

- Flutter compatible con **Dart >= 2.18.2 y < 3.0.0**.
- Flutter **>= 3.7.0**, según el archivo de dependencias bloqueadas.
- Android Studio y el SDK de Android para ejecutar la versión Android.
- Xcode y CocoaPods para ejecutar la versión iOS en macOS.
- Acceso a un proyecto Firebase con Authentication, Firestore y Storage configurados.
- Un emulador, simulador o dispositivo físico disponible.

Las restricciones actuales de Dart corresponden a una versión antigua del proyecto. Una instalación moderna de Flutter con Dart 3 no podrá resolver las dependencias sin actualizar antes el SDK declarado y los paquetes.

## Puesta en marcha

1. Clona el repositorio y entra en su directorio:

   ```bash
   git clone <url-del-repositorio>
   cd talent_app
   ```

2. Comprueba que estás usando una versión compatible de Flutter y descarga las dependencias:

   ```bash
   flutter --version
   flutter pub get
   ```

3. Lista los dispositivos disponibles y ejecuta la aplicación:

   ```bash
   flutter devices
   flutter run
   ```

   También puedes indicar el destino de forma explícita:

   ```bash
   flutter run -d <device-id>
   ```

Para iOS, si CocoaPods no se instala automáticamente durante la compilación:

```bash
cd ios
pod install
cd ..
flutter run
```

## Configuración de Firebase

El repositorio contiene la configuración generada para el proyecto Firebase original en:

- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `macos/Runner/GoogleService-Info.plist`

Para usar otro proyecto Firebase, vuelve a generar estos archivos con FlutterFire CLI y revisa `lib/utils/network_endpoints.dart`, donde se definen el bucket de Storage y la clave usada por la integración de Google Places.

Además de la configuración cliente, el entorno Firebase debe disponer de:

- proveedor de correo/contraseña habilitado en Authentication;
- colecciones `sports` y `modalities` con datos iniciales;
- reglas e índices de Firestore adecuados para las consultas de la aplicación;
- reglas de Storage que permitan acceder a perfiles y publicaciones.

Las claves cliente incluidas en una aplicación Flutter no sustituyen las reglas de seguridad. Deben restringirse en las consolas de Firebase y Google Cloud según las plataformas autorizadas.

## Calidad y comprobaciones

Los comandos habituales de desarrollo son:

```bash
flutter analyze
flutter test
```

Actualmente, `test/widget_test.dart` conserva el smoke test del contador creado por la plantilla de Flutter y no corresponde a Talent App. Debe reemplazarse por pruebas que inicialicen o simulen Firebase antes de considerar fiable el resultado de `flutter test`.

## Plataformas

Android e iOS son los destinos principales del código actual. Existen archivos generados para Web, macOS, Windows y Linux, pero eso no implica soporte completo:

- Firebase dispone de opciones para Web y macOS, aunque estos destinos no están validados y el flujo multimedia contiene supuestos propios de móvil.
- Windows y Linux lanzan una excepción durante la inicialización porque no tienen opciones de Firebase configuradas.

## Estado actual

Talent App debe considerarse un prototipo funcional, no una versión preparada para producción. Antes de publicar conviene actualizar Flutter y sus dependencias, completar permisos nativos, revisar las reglas e índices de Firebase, sustituir secretos o claves sin restricciones y crear una suite de pruebas específica para los flujos principales.
