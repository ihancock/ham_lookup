enum ApplicantType implements Comparable<ApplicantType> {
  b(description: 'Amateur Club'),
  c(description: 'Corporation'),
  d(description: 'General Partnership'),
  e(description: 'Limited Partnership'),
  f(description: 'Limited Liability Partnership'),
  g(description: 'Governmental Entity'),
  h(description: 'Other'),
  i(description: 'Individual'),
  j(description: 'Joint Venture'),
  l(description: 'Limited Liability Company'),
  m(description: 'Military Recreation'),
  n(description: 'Tribal Entity'),
  o(description: 'Consortium'),
  p(description: 'Partnership'),
  r(description: 'RACES'),
  t(description: 'Trust'),
  u(description: 'Unincorporated Association'),
  z(description: 'Tribal Entity Controlled by a Business');

  const ApplicantType({
    required this.description,
  });

  final String description;

  @override
  int compareTo(ApplicantType other) => name.compareTo(other.name);

  @override
  String toString() => description;
}
