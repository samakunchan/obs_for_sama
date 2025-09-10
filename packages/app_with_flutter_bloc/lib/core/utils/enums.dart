enum SettingsEnum {
  ip(label: 'IP'),
  port(label: 'Port'),
  password(label: 'Password');

  const SettingsEnum({required this.label});

  final String label;
}

enum AppText {
  mainTitle(label: 'OBS MANAGER'),
  mainSettingsTitle(label: 'SETTINGS'),
  title(label: 'PLAY WITH OBS'),
  obsServerForm(label: 'SERVER PARAMETERS'),
  connectToOBS(label: 'CONNECT OBS'),
  start(label: 'START STREAM'),
  isStarting(label: 'STARTING'),
  stop(label: 'STOP STREAM'),
  isStopping(label: 'STOPPING'),
  undefined(label: 'UNDEFINED'),
  scenes(label: 'SCENES'),
  sources(label: 'SOURCES');

  const AppText({required this.label});

  final String label;
}

enum StatusStream {
  isStarting,
  isStopping,
  started,
  stopped,
}

enum RouteName {
  home(label: 'home', path: '/home'),
  settings(label: 'settings', path: '/settings');

  const RouteName({required this.label, required this.path});

  final String label;
  final String path;
}

/// Contient les clés pour l'affichage des messages provenant de Google
enum GoogleMessagesEnum {
  /// Valeur : GOOGLE_INSTANCE_CANCELED
  cancel(key: 'GOOGLE_INSTANCE_CANCELED'),

  /// Valeur : GOOGLE_INSTANCE_INTERUPT
  interupt(key: 'GOOGLE_INSTANCE_INTERUPT');

  const GoogleMessagesEnum({
    required this.key,
  });
  final String key;
}

/// Contient les clés pour l'affichage des messages de l'application
enum AppMessagesEnum {
  /// Valeur : UNKNOWN_ERROR
  unknownError(key: 'UNKNOWN_ERROR'),

  /// Valeur : SERVER_DENIED_REQUEST
  serverRequestDenied(key: 'SERVER_DENIED_REQUEST'),

  /// Valeur : SERVER_ERROR
  serverError(key: 'SERVER_ERROR'),

  /// Valeur : WIFI_REQUIRED
  wifiError(key: 'WIFI_REQUIRED'),

  /// Valeur : CACHE_EMPTY_ERROR
  cacheEmpty(key: 'CACHE_EMPTY_ERROR'),

  /// Valeur : TIME_OUT_ERROR
  timeOutError(key: 'TIME_OUT_ERROR'),

  /// Valeur : REQUIRED_AUTHENTICATION
  requiredAuth(key: 'REQUIRED_AUTHENTICATION'),

  /// Valeur : START_ERROR
  startError(key: 'START_ERROR'),

  /// Valeur : STOP_ERROR
  stopError(key: 'STOP_ERROR'),

  /// Valeur : CONNECTION_REFUSED
  connectionRefused(key: 'CONNECTION_REFUSED');

  const AppMessagesEnum({
    required this.key,
  });
  final String key;
}
