@Deprecated('sert à rien')
enum ServerEnum {
  none(label: 'none', value: 'none'),
  isOnline(label: 'isOnline', value: 'ONLINE'),
  isOffline(label: 'isOffline', value: 'OFFLINE');

  const ServerEnum({required this.value, required this.label});

  final String value;
  final String label;
}
