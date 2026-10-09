> **Documento específico del Node**
>
> La relación entre el Hub, el Node, el Firebase personal de prueba y los
> Firebase personales de los asistentes está unificada en
> [`../../docs/system-overview.md`](../../docs/system-overview.md).
> Ese documento es la fuente principal para decisiones que afecten a ambos
> proyectos. Este archivo conserva la especificación detallada del Node.
>
> Estado actual: GO de implementación recibido. El deploy sigue requiriendo
> autorización explícita.

Quiero que construyas una aplicación Flutter que servirá como **plantilla oficial del workshop Full Day Communities — Flutter + Firebase**.

Esta aplicación será clonada por cada asistente desde GitHub.

Cada participante tendrá:

- Su propia aplicación Flutter.
- Su propio Firebase Project.
- Su propio Firebase Authentication.
- Su propio Cloud Firestore.
- Su propio Firebase Hosting.
- Su propia URL pública.
- Y adicionalmente se conectará al **Full Day Community Hub** como segundo proyecto Firebase.

La intención NO es entregarles una aplicación completamente terminada.

Quiero una plantilla pedagógica, limpia y profesional, preparada para que durante el workshop yo pueda ir explicando, descomentando y construyendo los widgets junto con los asistentes.

La audiencia son desarrolladores, así que no quiero una plantilla excesivamente simplificada.

Quiero que aprendan realmente:

```text
Flutter
↓
Widgets
↓
Estado
↓
Repository
↓
Firebase
↓
Firestore Streams
↓
Multiple Firebase Apps
↓
Firebase Hosting
```

---

# 1. OBJETIVO FINAL DE LA APP

Cada asistente debe terminar con una aplicación llamada:

# My Community Node

Conceptualmente:

```text
MY COMMUNITY NODE
│
├── Mi espacio
│   │
│   ├── Mi Firebase
│   ├── Mi Authentication
│   ├── Mi Firestore
│   └── Mi perfil
│
└── Community
    │
    ├── Firebase Hub compartido
    ├── Anonymous Authentication
    ├── Participantes
    ├── Mensajes
    └── Realtime
```

Arquitectura final:

```text
                    FLUTTER APP

                         UI
                          │
              ┌───────────┴───────────┐
              │                       │
          MY SPACE                COMMUNITY
              │                       │
      ProfileRepository      CommunityRepository
              │                       │
        Firebase #1             Firebase #2
       [DEFAULT APP]          [community APP]
              │                       │
        Personal Auth          Anonymous Auth
        Personal DB           Shared Firestore
```

---

# 2. RESTRICCIÓN DE COSTOS

TODO debe funcionar en:

# Firebase Spark Plan

Nadie debe necesitar:

- tarjeta de crédito
- Blaze Plan
- Cloud Functions
- Cloud Run
- App Hosting
- servicios pagos

Utilizar únicamente lo necesario:

- Firebase Core
- Firebase Authentication
- Anonymous Authentication
- Cloud Firestore
- Firebase Hosting clásico

El proyecto debe poder desplegarse con:

```bash
flutter build web
firebase deploy --only hosting
```

No usar Firebase App Hosting.

---

# 3. STACK

Utilizar:

- Flutter estable actual
- Dart correspondiente
- Material 3
- firebase_core
- firebase_auth
- cloud_firestore

Para manejo de estado, utiliza Riverpod solamente si realmente mejora la experiencia pedagógica.

Si Riverpod genera demasiada complejidad para el tamaño de este proyecto, utiliza una solución más simple.

No quiero sobrearquitectura.

Antes de instalar dependencias o generar comandos, revisa las versiones disponibles en el entorno y evita hardcodear versiones antiguas.

---

# 4. FILOSOFÍA DEL PROYECTO

Este proyecto debe seguir:

- Feature First
- Screaming Architecture
- Repository Pattern
- Dependency inversion donde aporte valor
- separación clara entre UI e infraestructura

Pero debe seguir siendo entendible durante una charla presencial.

Evita:

```text
50 archivos
10 interfaces
7 use cases
4 factories
```

para una operación simple.

Quiero arquitectura pragmática.

Una estructura aproximada:

```text
lib/
│
├── app/
│   ├── app.dart
│   ├── router/
│   └── theme/
│
├── core/
│   ├── firebase/
│   ├── constants/
│   └── errors/
│
├── features/
│   │
│   ├── onboarding/
│   │
│   ├── profile/
│   │   ├── domain/
│   │   ├── data/
│   │   └── presentation/
│   │
│   └── community/
│       ├── domain/
│       ├── data/
│       └── presentation/
│
└── main.dart
```

Puedes mejorarla si existe una opción más clara.

---

# 5. EXPERIENCIA DEL USUARIO

La aplicación debe tener tres momentos principales:

```text
01
Configura tu nodo

02
Construye tu espacio

03
Únete a la comunidad
```

Pantallas principales:

```text
Splash
↓
Setup / Welcome
↓
Home
   ├── My Space
   └── Community
```

---

# 6. SPLASH

Crear una pantalla sencilla:

```text
MY COMMUNITY NODE

Flutter + Firebase

Build your node.
Join the network.
```

Diseño:

- dark
- moderno
- azul Flutter
- acentos cyan
- ligero toque Firebase
- Material 3

No exagerar con animaciones.

---

# 7. HOME

La pantalla principal debe utilizar:

```text
NavigationBar
```

o una navegación Material 3 equivalente.

Dos secciones:

```text
👤 My Space

🌎 Community
```

La navegación debe ser extremadamente sencilla.

---

# 8. MY SPACE

Esta sección utiliza exclusivamente el Firebase personal del asistente.

Ese Firebase será:

```dart
Firebase.app()
```

es decir:

```text
[DEFAULT]
```

Aquí el participante aprenderá:

- configurar Firebase
- autenticarse
- guardar datos
- leer datos
- escuchar datos
- editar información

---

# 9. AUTENTICACIÓN PERSONAL

Para mantener el workshop pequeño, quiero utilizar:

## Anonymous Authentication

también para el Firebase personal.

No quiero obligar a implementar email/password durante el workshop.

La intención es enseñar:

```text
App
↓
Firebase Authentication
↓
UID
↓
Firestore
```

Cuando la aplicación inicia:

```text
si no existe sesión
↓
signInAnonymously()
```

Luego usar:

```text
FirebaseAuth.instance.currentUser.uid
```

para asociar el perfil.

---

# 10. PERFIL PERSONAL

Crear colección:

```text
profiles
```

Documento:

```text
profiles/{uid}
```

Campos:

```text
uid
name
role
community
bio
createdAt
updatedAt
```

Ejemplo:

```text
Gian Sandoval
Mobile Architect
Flutter Piura
Construyendo software y comunidad 🚀
```

---

# 11. FUNCIONALIDAD MY SPACE

Debe poder:

```text
Crear perfil
Leer perfil
Editar perfil
Escuchar cambios
```

No necesito Delete.

Quiero que el participante entienda claramente:

```text
Widget
↓
Repository
↓
Cloud Firestore
```

---

# 12. REPOSITORY PERSONAL

Crear algo equivalente a:

```dart
abstract interface class ProfileRepository {
  Stream<Profile?> watchProfile();

  Future<void> saveProfile(Profile profile);
}
```

Implementación:

```text
FirebaseProfileRepository
```

No quiero que los Widgets llamen directamente a:

```dart
FirebaseFirestore.instance
```

Quiero poder explicar durante el workshop:

> La UI conoce una capacidad.
> La infraestructura conoce Firebase.

---

# 13. COMMUNITY

Esta pestaña debe conectarse al proyecto:

# Full Day Community Hub

Este será un segundo proyecto Firebase.

NO debe reemplazar al Firebase del participante.

Arquitectura:

```text
Firebase [DEFAULT]
      │
      └── Firebase personal


Firebase [community]
      │
      └── Full Day Community Hub
```

---

# 14. COMMUNITY FIREBASE CONFIG

Crear:

```text
lib/core/firebase/community_firebase_options.dart
```

Pero NO colocar todavía configuración real.

Crear algo claramente marcado:

```dart
class CommunityFirebaseOptions {
  // WORKSHOP:
  // These values will be provided by the speaker.
}
```

Quiero poder pegar posteriormente mi configuración del Hub.

Documentar dónde colocar:

```text
apiKey
appId
messagingSenderId
projectId
```

No usar credenciales privadas.

---

# 15. INICIALIZACIÓN MULTI FIREBASE

Crear un servicio simple:

```text
CommunityFirebase
```

responsable de:

```dart
Firebase.initializeApp(
  name: 'community',
  options: ...
)
```

Debe evitar inicialización duplicada.

Ejemplo conceptual:

```dart
final communityApp = await Firebase.initializeApp(
  name: 'community',
  options: CommunityFirebaseOptions.currentPlatform,
);
```

Después:

```dart
FirebaseAuth.instanceFor(
  app: communityApp,
);
```

y:

```dart
FirebaseFirestore.instanceFor(
  app: communityApp,
);
```

---

# 16. AUTH DEL COMMUNITY HUB

Cuando el usuario entra a Community:

```text
CommunityFirebase
↓
Anonymous Authentication
↓
Community UID
```

Utilizar:

```dart
communityAuth.signInAnonymously();
```

si todavía no existe sesión.

IMPORTANTE:

El UID del Firebase personal y el UID del Community Hub NO tienen por qué ser iguales.

Quiero que esto quede claramente documentado porque será uno de los conceptos que explicaré.

---

# 17. REGISTRO EN EL COMMUNITY HUB

Después de autenticarse anónimamente en el Community Hub:

crear:

```text
participants/{communityUid}
```

Campos:

```text
uid
name
role
community
joinedAt
lastSeenAt
```

Los datos:

```text
name
role
community
```

deben venir del perfil personal del usuario.

Esto permite explicar:

```text
Firebase Personal
      │
      │ Profile
      ▼
Flutter App
      │
      │ Synchronize identity
      ▼
Community Firebase
```

NO sincronizar automáticamente cambios complejos.

Para el workshop basta con registrar esos campos al ingresar.

---

# 18. COMMUNITY REPOSITORY

Crear:

```dart
abstract interface class CommunityRepository {
  Stream<List<CommunityMessage>> watchMessages();

  Future<void> join(Profile profile);

  Future<void> sendMessage(String text);
}
```

Opcional:

```dart
Stream<int> watchParticipantsCount();
```

La implementación será:

```text
FirebaseCommunityRepository
```

---

# 19. MENSAJES

Colección:

```text
messages
```

Modelo:

```text
id
authorId
authorName
authorRole
authorCommunity
text
createdAt
```

Restricciones cliente:

```text
texto obligatorio
máximo 280 caracteres
trim
```

Usar server timestamp donde resulte apropiado.

---

# 20. COMMUNITY FEED

La UI debe mostrar:

```text
COMMUNITY LIVE
```

Y debajo:

```text
Gian Sandoval
Mobile Architect · Flutter Piura

Hola Full Day 🚀
```

Otro:

```text
María
Flutter Developer · GDG

Firebase funcionando 🔥
```

Los mensajes deben actualizarse mediante:

```text
Firestore snapshots
```

NO polling.

Quiero poder explicar:

```text
Stream<List<Message>>
↓
UI
↓
actualización automática
```

---

# 21. COMPOSER

Abajo del Community Feed:

```text
┌───────────────────────────┐
│ Escribe un mensaje...     │
└───────────────────────────┘

              [ SEND 🚀 ]
```

Máximo:

```text
280 caracteres
```

Deshabilitar Send:

```text
si está vacío
```

Mostrar contador:

```text
137 / 280
```

---

# 22. EMPTY STATE

Antes de recibir mensajes:

```text
The network is ready.

Be the first node to say hello.
```

---

# 23. PARTICIPANTES

En Community mostrar un pequeño indicador:

```text
37 nodes connected
```

Realmente puede representar:

```text
participants registrados
```

No necesito presencia online exacta.

No utilizar Realtime Database.

No complicar el workshop.

---

# 24. UX

Diseño general:

```text
Dark
Material 3
Flutter Blue
Cyan
Firebase accents
```

Debe sentirse:

```text
Developer Conference
Mobile Architect
Open Source
Modern
```

NO:

```text
dashboard empresarial genérico
template infantil
demasiados gradients
demasiados íconos
```

---

# 25. WORKSHOP MODE

Esta parte es MUY IMPORTANTE.

Quiero que el código esté preparado para enseñar.

Agregar comentarios claramente identificables:

```dart
// WORKSHOP STEP 01
```

```dart
// WORKSHOP STEP 02
```

etc.

Pero no llenar todo de comentarios.

Marcar únicamente los puntos pedagógicos importantes.

---

# 26. WIDGETS QUE QUIERO PODER CONSTRUIR DURANTE EL WORKSHOP

Crear inicialmente los Widgets completos, pero organizados de forma que yo pueda posteriormente comentarlos antes de subir la plantilla final.

Los principales deben ser:

```text
ProfileHeader
ProfileForm
CommunityHeader
MessageCard
MessageComposer
EmptyCommunityState
NodeCounter
```

Cada uno debe ser pequeño y fácil de explicar.

---

# 27. IMPORTANTE: GENERAR TAMBIÉN VERSIÓN WORKSHOP

Además del proyecto funcional completo, quiero preparar una rama lógica dentro del repositorio mediante documentación.

Crear:

```text
docs/workshop-steps.md
```

con pasos como:

# STEP 01 — Entender la aplicación

Explicar:

```text
MaterialApp
Scaffold
NavigationBar
```

---

# STEP 02 — Construir My Space

Construiremos:

```text
ProfileHeader
```

---

# STEP 03 — Crear formulario

Construiremos:

```text
ProfileForm
```

Explicar:

```text
TextEditingController
Form
TextFormField
validation
```

---

# STEP 04 — Firebase personal

Ejecutar:

```bash
firebase login
```

```bash
dart pub global activate flutterfire_cli
```

```bash
flutterfire configure
```

No asumir que esos comandos están instalados.

Explicar cada comando.

---

# STEP 05 — Firebase initialize

Explicar:

```dart
Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

---

# STEP 06 — Authentication

Explicar:

```text
FirebaseAuth
Anonymous Auth
UID
```

---

# STEP 07 — Firestore

Explicar:

```text
Collection
Document
Field
```

Guardar:

```text
profiles/{uid}
```

---

# STEP 08 — Stream

Explicar:

```text
Firestore snapshot
↓
Dart Stream
↓
Flutter UI
```

---

# STEP 09 — Repository

Mostrar por qué pasamos de:

```dart
FirebaseFirestore.instance...
```

dentro del Widget

a:

```dart
profileRepository.saveProfile(...)
```

---

# STEP 10 — Community Firebase

Introducir:

```text
Multiple Firebase Apps
```

Mostrar:

```text
[DEFAULT]
```

versus:

```text
[community]
```

---

# STEP 11 — Community Auth

Explicar:

```text
otro Firebase
↓
otra sesión
↓
otro UID
```

---

# STEP 12 — Join Network

Tomar:

```text
Profile
```

del proyecto personal y registrar:

```text
Participant
```

en el Hub.

---

# STEP 13 — Community Feed

Construir:

```text
MessageCard
```

---

# STEP 14 — Realtime

Escuchar:

```text
messages
```

con snapshots.

---

# STEP 15 — Send Message

Construir:

```text
MessageComposer
```

---

# STEP 16 — Build Web

Ejecutar:

```bash
flutter build web
```

---

# STEP 17 — Firebase Hosting

Configurar Hosting clásico.

Luego:

```bash
firebase deploy --only hosting
```

---

# STEP 18 — Final

Cada participante debe terminar con:

```text
su Flutter App
+
su Firebase
+
su Firestore
+
su Hosting
+
Community Hub
```

---

# 28. CÓDIGO COMENTABLE

Quiero que me indiques después cuáles bloques puedo comentar antes del workshop.

Por ejemplo:

```text
lib/features/profile/presentation/widgets/profile_header.dart

lib/features/profile/presentation/widgets/profile_form.dart

lib/features/community/presentation/widgets/message_card.dart

lib/features/community/presentation/widgets/message_composer.dart
```

Y preparar alternativas con:

```dart
// TODO WORKSHOP:
```

en lugares concretos.

Pero MUY IMPORTANTE:

No quiero subir al repositorio una aplicación rota.

Propón una estrategia para tener:

```text
main
```

con la aplicación completa

y:

```text
workshop
```

como versión inicial para los asistentes.

Si no vas a ejecutar Git branches directamente, documenta exactamente qué archivos o commits debo usar.

---

# 29. ESTRATEGIA GIT PARA EL WORKSHOP

Quiero poder preparar commits progresivos.

Ejemplo:

```text
00 - starter
01 - flutter UI
02 - profile form
03 - firebase setup
04 - auth
05 - firestore
06 - repository
07 - community firebase
08 - community auth
09 - realtime messages
10 - hosting
```

Crear:

```text
docs/git-workshop-plan.md
```

explicando qué debería contener cada commit.

Esto me permitirá volver a cualquier punto si algo falla durante el workshop.

---

# 30. README PARA LOS ASISTENTES

Crear README muy claro.

Título:

```text
Full Day Community Workshop
Flutter + Firebase
```

Debe incluir:

```text
Build your node.
Join the network.
Ship it.
```

---

## Requisitos

```text
Flutter
Chrome
VS Code / Android Studio
Cuenta Google
Git
```

---

## Clone

```bash
git clone ...
```

NO inventar todavía la URL.

Dejar:

```text
<REPOSITORY_URL>
```

---

## Install

```bash
flutter pub get
```

---

## Run

```bash
flutter run -d chrome
```

---

# 31. FIREBASE SETUP DOCUMENTATION

Crear:

```text
docs/firebase-personal-setup.md
```

Explicar detalladamente:

1. Entrar a Firebase Console.
2. Crear proyecto nuevo.
3. No habilitar servicios pagos.
4. Mantener Spark Plan.
5. Activar Authentication.
6. Activar Anonymous.
7. Crear Firestore.
8. Ejecutar FlutterFire CLI.
9. Ejecutar proyecto.
10. Verificar conexión.

---

# 32. FIRESTORE RULES PERSONAL

Crear:

```text
firestore.rules
```

para el Firebase personal.

No usar:

```text
allow read, write: if true
```

Protección:

```text
profiles/{uid}
```

solo accesible por:

```text
request.auth.uid == uid
```

Validar campos razonables.

---

# 33. SECURITY LESSON

Crear sección en docs:

```text
Firebase Config != Firebase Secret
```

Explicar:

```text
apiKey
projectId
appId
```

no deben tratarse como el mecanismo de seguridad.

La seguridad se construye mediante:

```text
Authentication
+
Security Rules
```

---

# 34. FIREBASE HOSTING

Crear documentación específica:

```text
docs/firebase-hosting.md
```

Mantener:

```text
Firebase Hosting clásico
```

NO App Hosting.

Explicar cómo configurar:

```text
build/web
```

como directorio público.

SPA:

```text
rewrite
→ index.html
```

cuando corresponda.

---

# 35. RESPONSIVE

La aplicación debe funcionar correctamente en:

```text
Mobile
Tablet
Desktop
Web
```

Pero NO invertir demasiado tiempo en diseños radicalmente diferentes.

Usar layout responsive sencillo.

---

# 36. TESTS

Agregar tests útiles para:

```text
Profile model
CommunityMessage model
validators
repositories con mocks si aporta valor
```

No necesito cobertura artificial.

---

# 37. LINT

Ejecutar:

```bash
dart format .
```

```bash
flutter analyze
```

Corregir todos los warnings razonables.

Ejecutar:

```bash
flutter test
```

---

# 38. NO HACER

No:

```text
Cloud Functions
Realtime Database
FCM
Analytics
Crashlytics
Storage
Remote Config
App Check
```

para esta primera versión.

El foco es:

```text
Flutter
Firebase Core
Authentication
Firestore
Hosting
Realtime Streams
Multi Firebase
```

---

# 39. ENTREGABLE FINAL

Quiero que al terminar me indiques:

## Arquitectura

Muéstrame:

```text
lib/
```

completo.

---

## Firebase personal

Indícame cómo crear y conectar:

```text
Firebase [DEFAULT]
```

---

## Firebase community

Indícame exactamente dónde colocar la configuración que yo proporcionaré.

---

## Workshop

Indícame:

```text
qué archivos comentar
qué Widgets eliminar
qué TODO dejar
```

para convertir el proyecto terminado en la plantilla inicial.

---

## Git

Propón commits progresivos.

---

## Demo

Explica cómo probar:

```text
Chrome normal
+
Chrome incógnito
```

o dos perfiles diferentes.

---

# 40. CRITERIO FINAL DE ÉXITO

El participante debe poder hacer:

```text
git clone
↓
flutter pub get
↓
flutter run -d chrome
```

y obtener una plantilla.

Después durante el workshop:

```text
Construye UI
↓
Crea Firebase personal
↓
flutterfire configure
↓
Anonymous Auth
↓
Guarda perfil
↓
Firestore Stream
↓
Inicializa Community Firebase
↓
Anonymous Auth #2
↓
Join Community
↓
Escucha mensajes
↓
Envía mensaje
↓
flutter build web
↓
firebase deploy
```

Al finalizar:

```text
Cada asistente tiene:

1 Flutter App
1 Firebase personal
1 Hosting personal
1 URL pública
1 conexión al Community Hub
```

Y cuando envía:

```text
Hola Full Day 🚀
```

el mensaje debe aparecer en tiempo real tanto en:

```text
su propia app
```

como en:

```text
FULL DAY COMMUNITY WALL
```

proyectado por el speaker.

---

# 41. ENFOQUE PEDAGÓGICO

El proyecto debe estar escrito pensando en que yo voy a explicar el código línea por línea.

Prefiere:

```dart
final profile = ...
```

sobre abstracciones extremadamente inteligentes.

Prefiere código explícito.

Evita magia.

Quiero poder preguntar durante la charla:

```text
¿Quién crea este Widget?
¿Quién guarda esto?
¿Quién conoce Firebase?
¿De dónde viene este Stream?
¿Por qué Repository?
¿Por qué tenemos dos FirebaseApp?
```

y que el código permita responder visualmente esas preguntas.

---

# 42. FILOSOFÍA FINAL

El proyecto debe transmitir esta idea:

```text
Flutter construye la experiencia.

Firebase conecta los datos.

La arquitectura mantiene el control.

La comunidad conecta las aplicaciones.
```

Construye primero una versión completamente funcional.

Después prepara la documentación y estrategia para convertirla en la plantilla inicial del workshop.

No hagas deploy automáticamente.

No configures servicios pagos.

No cambies el proyecto a Blaze.

Al finalizar, explícame exactamente qué pasos debo hacer yo antes de subir la plantilla a GitHub.
