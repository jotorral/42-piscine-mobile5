# piscine_mobile_4

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

***********************************************************
************************ TUTORIAL *************************
***********************************************************

Das de alta la base de datos en la web de Firebase.
Después selecciones Firestore Data base, que es la nueva buena. Eliges un país cercano y creas la base de datos
En terminal VS Code añades dependencias en pubspec.yaml con el comando: flutter pub add firebase_core
En terminal VS Code añades la configuración y las plataformas (El comando lo hace tanto en el proyecto añadiendo firebase_options.dart, como en la web): flutterfire configure

Para athentication Google, en el navegador: console.cloud.google.com
Pinchar arriba en un sitio con 3 puntos gordos para seleccionar el proyecto que hemos creado en Firebase (nos aparecerá ahí seleccionando la pestaña TODOS). Ahora junto a los 3 puntos aparecerá el nombre del proyecto
A la derecha de la casilla con los 3 puntos está buscar. Escribir en buscar oauth. Seleccionar API Pantalla de consentimiento de OAuth. Seleccionar Usuarios Externos y Crear
Poner nombre de la aplicación que se mostrará en la pantalla del móvil para indicar que quieres acceder, poner le email y si quieres un logo que saldrá en la pantalla del móvil, y el email del desarrolador. Guardar y continuar.


***********************************************************
****************   AUTENTICAR CON AUTH0   *****************
***********************************************************

Ir a la web pub.dev para descargar:
http -                      incluirlo en dev_dependencies: flutter_test: de pubspec.yaml
flutter_appauth -           incluirlo en dev_dependencies: flutter_test: de pubspec.yaml
flutter_secure_storage -    incluirlo en dev_dependencies: flutter_test: de pubspec.yaml

En android/app/build.gradle poner en defaultConfig minSdkVersion 18
En android/app/build.gradle en defaultConfig abajo del todo poner
    manifestPlaceholders = [
        'appAthRedirectScheme': 'com.ath0.flutterdemo'
    ]

Ejecutar flutter run
