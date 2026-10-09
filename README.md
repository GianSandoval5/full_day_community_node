# Full Day Community Workshop

## Flutter + Firebase

```text
Build your node.
Join the network.
Ship it.
```

Plantilla oficial para construir **My Community Node**. Cada asistente conecta
la app con su propio Firebase y, al mismo tiempo, participa en el Community Hub
compartido.

## Arquitectura Firebase

```text
MY SPACE                         COMMUNITY
│                                │
Firebase [DEFAULT]               Firebase [community]
│                                │
Firebase personal                Hub del speaker
├── Anonymous Auth               ├── Anonymous Auth #2
└── profiles/{personalUid}       ├── participants/{communityUid}
                                 └── messages/{messageId}
```

Los dos UIDs son independientes.

## Estado inicial de la plantilla

`[DEFAULT]` está conectado al Firebase personal de prueba
`full-day-community-node`. Durante el workshop cada asistente lo reemplazará
con su propio proyecto ejecutando `flutterfire configure`.

La configuración del Hub vive por separado en:

```text
lib/core/firebase/community_firebase_options.dart
```

Ese archivo no debe ser reemplazado al configurar el Firebase personal.

La integración Community ya está configurada para Web y iOS. Para ejecutarla
en Android, el speaker debe registrar adicionalmente en el proyecto del Hub la
app con el identificador real del Node y añadir sus opciones al mismo archivo:

```text
Android: com.example.full_day_community_node
```

## Requisitos

- Flutter
- Chrome
- VS Code o Android Studio
- Git
- cuenta Google
- Firebase CLI y FlutterFire CLI para la configuración personal

## Clonar y ejecutar

```bash
git clone <REPOSITORY_URL>
cd full_day_community_node
flutter pub get
flutter run -d chrome
```

El Firebase de prueba necesita Anonymous Authentication y Cloud Firestore
habilitados para que My Space funcione.

## Crear tu Firebase

Sigue [Firebase personal del asistente](docs/firebase-personal-setup.md).

Resumen:

```bash
flutterfire configure
flutter run -d chrome
```

Después de configurar tu proyecto, `[DEFAULT]` será tu Firebase; `community`
seguirá apuntando al Hub.

## Probar Community

1. Guarda nombre, rol y comunidad en My Space.
2. Abre la pestaña Community.
3. La app inicia una segunda sesión anónima.
4. Publica `Hola Full Day 🚀`.
5. El mensaje aparecerá en tu app y en el Wall del speaker.

## Seguridad

- El Firebase personal protege `profiles/{uid}`.
- El Hub exige usuario autenticado.
- Un mensaje solo puede declarar como autor a `request.auth.uid`.
- No se usa `allow read, write: if true`.
- Firebase config no equivale a un secreto ni reemplaza las reglas.

## Despliegues Firebase personales

Ejecuta estos comandos desde `full_day_community_node` y reemplaza
`TU_PROJECT_ID` por el ID de tu proyecto Firebase personal. Nunca uses aquí el
ID del Community Hub.

Solo reglas:

```bash
firebase deploy --only firestore:rules --project TU_PROJECT_ID
```

Solo índices:

```bash
firebase deploy --only firestore:indexes --project TU_PROJECT_ID
```

Reglas e índices juntos:

```bash
firebase deploy --only firestore --project TU_PROJECT_ID
```

Hosting clásico es **opcional**. No lo necesitas para participar si ejecutas
el Node localmente con `flutter run -d chrome`. Para publicar una URL propia:

```bash
flutter build web --release
firebase deploy --only hosting --project TU_PROJECT_ID
```

## Calidad

```bash
dart format .
flutter analyze
flutter test
flutter build web
```

## Hosting opcional

Consulta [Firebase Hosting clásico](docs/firebase-hosting.md). No se usa App
Hosting ni se requiere Blaze.

## Documentación del workshop

- [Pasos del workshop](docs/workshop-steps.md)
- [Plan de commits](docs/git-workshop-plan.md)
- [Firebase personal](docs/firebase-personal-setup.md)
- [Hosting](docs/firebase-hosting.md)
- [Definición general](../docs/system-overview.md)
