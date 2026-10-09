# Firebase Hosting clásico

Cada asistente desplegará su propia aplicación Web en su proyecto personal.

## Compilar

```bash
flutter build web
```

## Revisar el proyecto activo

```bash
firebase use
```

Si no hay uno seleccionado:

```bash
firebase use --add
```

Selecciona tu proyecto personal, nunca el Community Hub.

## Desplegar

```bash
firebase deploy --only hosting
```

`firebase.json` ya utiliza `build/web` y una rewrite SPA hacia `index.html`.
Este flujo usa Firebase Hosting clásico y funciona con Spark Plan.
