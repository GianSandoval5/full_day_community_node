# Firebase Hosting clásico

Cada asistente puede desplegar opcionalmente su aplicación Web en su proyecto
personal. Para participar en el workshop basta con ejecutarla localmente usando
`flutter run -d chrome`.

## Compilar

```bash
flutter build web
```

## Desplegar

Reemplaza `TU_PROJECT_ID` por el ID de tu proyecto personal, nunca por el ID
del Community Hub.

```bash
firebase deploy --only hosting --project TU_PROJECT_ID
```

`firebase.json` ya utiliza `build/web` y una rewrite SPA hacia `index.html`.
Este flujo usa Firebase Hosting clásico y funciona con Spark Plan.
