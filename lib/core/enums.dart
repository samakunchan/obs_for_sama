enum SettingsEnum {
  ip(label: 'IP'),
  port(label: 'Port'),
  password(label: 'Password');

  const SettingsEnum({required this.label});

  final String label;
}
