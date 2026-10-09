# Firebase personal del asistente

Cada asistente reemplazará el Firebase `[DEFAULT]` de prueba por su propio
proyecto. El Firebase secundario `community` no se modifica.

## Requisitos

- Flutter
- Firebase CLI
- FlutterFire CLI
- cuenta Google

## Pasos

1. Crea un proyecto nuevo en Firebase Console.
2. Conserva el plan Spark y no registres una tarjeta.
3. Habilita Authentication → Sign-in method → Anonymous.
4. Crea la base Cloud Firestore predeterminada.
5. Desde `full_day_community_node`, ejecuta:

```bash
firebase login
flutterfire configure
```

Selecciona solamente tu proyecto personal. FlutterFire actualizará:

- `lib/firebase_options.dart`;
- `android/app/google-services.json`;
- `ios/Runner/GoogleService-Info.plist`;
- la sección `flutter` de `firebase.json`.

No edites ni elimines:

```text
lib/core/firebase/community_firebase_options.dart
```

Ese archivo pertenece al Hub del evento y debe seguir siendo común para todos
los asistentes.

## Reglas e índices personales

Reemplaza `TU_PROJECT_ID` por el ID de tu proyecto Firebase personal. Usar
`--project` evita desplegar accidentalmente en el Community Hub.

```bash
firebase deploy --only firestore:rules --project TU_PROJECT_ID
firebase deploy --only firestore:indexes --project TU_PROJECT_ID
```

También puedes desplegar reglas e índices juntos:

```bash
firebase deploy --only firestore --project TU_PROJECT_ID
```

Las reglas de este repositorio permiten a cada sesión acceder únicamente a
`profiles/{uid}` cuando `request.auth.uid == uid`.

## Verificación

Ejecuta:

```bash
flutter run -d chrome
```

Crea tu perfil y comprueba en Firebase Console que el documento tenga la ruta:

```text
profiles/{tuPersonalUid}
```

## Seguridad

`apiKey`, `projectId` y `appId` identifican el proyecto, pero no sustituyen las
reglas. La seguridad se construye con Authentication + Firestore Security
Rules.
