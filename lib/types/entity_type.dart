enum EntityType implements Comparable<EntityType> {
  ce(description: 'Transferee contact'),
  cl(description: 'Licensee Contact'),
  cr(description: 'Assignor or Transferor Contact'),
  cs(description: 'Lessee Contact'),
  e(description: 'Transferee'),
  l(description: 'Licensee or Assignee'),
  o(description: 'Owner'),
  r(description: 'Transferee contact'),
  s(description: 'Lessee');

  const EntityType({
    required this.description,
  });

  final String description;

  @override
  int compareTo(EntityType other) => name.compareTo(other.name);

  @override
  String toString() => description;
}
