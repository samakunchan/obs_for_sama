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
  sources(label: 'SOURCES'),
  ;

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
  home(label: 'home', path: '/'),
  settings(label: 'settings', path: '/settings'),
  ;

  const RouteName({required this.label, required this.path});

  final String label;
  final String path;
}
