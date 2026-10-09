# Plan de commits para el workshop

Cada commit debe compilar y permitir regresar a un punto conocido.

```text
00 - starter ejecutable
01 - shell Material 3 y navegación
02 - profile header y formulario
03 - Firebase [DEFAULT] configurado
04 - Anonymous Authentication personal
05 - profiles en Firestore
06 - ProfileRepository y realtime stream
07 - FirebaseApp [community]
08 - Anonymous Authentication Community
09 - participants y join network
10 - realtime messages y composer
11 - seguridad y reglas
12 - build web y Hosting clásico
```

## Ramas

- `main`: referencia completa y estable del speaker.
- `workshop`: starter que los asistentes clonan.

La rama `workshop` debe crearse desde un commit estable. No debe contener
credenciales privadas ni una `.firebaserc` que apunte al proyecto del speaker.

## Estrategia para TODOs

Mantén la estructura y contratos, pero sustituye implementaciones pedagógicas
por estados visuales o TODOs que sigan compilando. No comentes imports o clases
de forma que la aplicación quede rota.
