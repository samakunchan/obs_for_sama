enum SettingsEnum {
  ip(label: 'IP'),
  port(label: 'Port'),
  password(label: 'Password');

  const SettingsEnum({required this.label});

  final String label;
}

enum AppText {
  mainTitle(label: 'OBS MANAGER'),
  title(label: 'PLAY WITH OBS'),
  obsServerForm(label: 'SERVER PARAMETERS'),
  connectToOBS(label: 'CONNECT OBS'),
  start(label: 'START STREAM'),
  stop(label: 'STOP STREAM'),
  scenes(label: 'SCENES'),
  sources(label: 'SOURCES'),
  ;

  const AppText({required this.label});

  final String label;
}
