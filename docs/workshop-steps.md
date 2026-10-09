# Workshop steps

## 01 — Entender la aplicación

`MaterialApp`, `Scaffold`, navegación Material 3 y composición de Widgets.

## 02 — Construir My Space

Revisar `ProfileHeader` y el estado vacío del nodo.

## 03 — Crear el formulario

Explicar `Form`, `TextEditingController`, validación y estado local.

## 04 — Firebase personal

Crear el proyecto del asistente y ejecutar `flutterfire configure`.

## 05 — Inicializar `[DEFAULT]`

Revisar `PersonalFirebase` y `DefaultFirebaseOptions.currentPlatform`.

## 06 — Authentication

Habilitar Anonymous Auth y observar el `personalUid`.

## 07 — Firestore

Guardar el perfil en `profiles/{personalUid}`.

## 08 — Stream

Seguir `snapshots()` → `Stream<Profile?>` → `StreamBuilder`.

## 09 — Repository Pattern

Comparar la capacidad `ProfileRepository` con la implementación Firebase.

## 10 — Segundo Firebase

Revisar `CommunityFirebase`, `[DEFAULT]` y `[community]`.

## 11 — Segunda autenticación

Comparar `personalUid` con `communityUid`.

## 12 — Join Network

Copiar nombre, rol y comunidad a `participants/{communityUid}`.

## 13 — Feed realtime

Construir `MessageCard` y escuchar los últimos 50 mensajes.

## 14 — Composer

Validar y publicar un mensaje de hasta 280 caracteres.

## 15 — Community Wall

Observar el mismo mensaje en otros Nodes y en el Wall del speaker.

## 16 — Build Web

```bash
flutter build web
```

## 17 — Hosting

Desplegar en el Firebase personal con Hosting clásico.

## 18 — Cierre

Cada asistente termina con su app, Firebase, Firestore, URL y conexión al Hub.

## Bloques pedagógicos

Los mejores archivos para reconstruir durante la sesión son:

```text
lib/features/profile/presentation/widgets/profile_header.dart
lib/features/profile/presentation/widgets/profile_form.dart
lib/core/firebase/personal_firebase.dart
lib/core/firebase/community_firebase.dart
lib/features/community/presentation/widgets/message_card.dart
lib/features/community/presentation/widgets/message_composer.dart
```

La rama `main` debe conservar la referencia funcional. La rama `workshop` debe
reemplazar bloques concretos por TODOs pedagógicos sin dejar una app que no
compile.
