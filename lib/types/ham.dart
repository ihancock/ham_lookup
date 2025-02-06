class Ham {
  final String fccId;
  final String callSign;
  final String? fullName;
  final String? address1;
  final String? city;
  final String? state;
  final String? zip;

  Ham(
      {required this.fccId,
      required this.callSign,
      this.fullName,
      this.address1,
      this.city,
      this.state,
      this.zip});

  operator ==(o) => o is Ham && o.fccId == fccId && o.callSign == callSign;

  int get hashCode => fccId.hashCode ^ callSign.hashCode;
}
