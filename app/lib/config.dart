// Production APK: flutter build apk --dart-define=BACKEND_URL=https://your-domain.example.com/api
// Production Web: flutter build web --dart-define=BACKEND_URL=/api
const backendUrl = String.fromEnvironment(
  'BACKEND_URL',
  defaultValue: 'http://localhost:8080',
);
