enum StatusCode implements Comparable<StatusCode> {
  x(description: 'Termination Pending'),
  t(description: 'Terminated');

  const StatusCode({
    required this.description,
  });

  final String description;

  @override
  int compareTo(StatusCode other) => name.compareTo(other.name);

  @override
  String toString() => description;
}
