enum SoundEnum {
  none(label: 'none', value: 'none');

  const SoundEnum({required this.value, required this.label});

  final String value;
  final String label;
}
