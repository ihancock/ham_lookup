enum OperatorClass implements Comparable<OperatorClass> {
  a(description: 'Advanced'),
  e(description: 'Amateur Extra'),
  g(description: 'General'),
  n(description: 'Novice'),
  p(description: 'Technician Plus'),
  t(description: 'Technician');

  const OperatorClass({
    required this.description,
  });

  final String description;

  @override
  int compareTo(OperatorClass other) => name.compareTo(other.name);

  @override
  String toString() => description;
}
