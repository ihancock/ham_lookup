class AmRecord {
  final String fccId;
  final String callSign;
  final String operatorClass;
  final String groupCode;
  final String regionCode;
  final String trusteeCallSign;
  final String trusteeIndicator;
  final String physicianCertification;
  final String veSignature;
  final String systemicCallSignChange;
  final String vanityCallSignChange;
  final String vanityRelationShip;
  final String previousCallSign;
  final String previousOperatorClass;
  final String trusteeName;

  AmRecord(
      {required this.fccId,
      required this.callSign,
      required this.operatorClass,
      required this.groupCode,
      required this.regionCode,
      required this.trusteeCallSign,
      required this.trusteeIndicator,
      required this.physicianCertification,
      required this.veSignature,
      required this.systemicCallSignChange,
      required this.vanityCallSignChange,
      required this.vanityRelationShip,
      required this.previousCallSign,
      required this.previousOperatorClass,
      required this.trusteeName});

  @override
  String toString() {
    return '{'
        'fccId: $fccId, '
        'callsign: $callSign, '
        'operatorClass: $operatorClass, '
        'groupCode: $groupCode, '
        'regionCode: $regionCode, '
        'trusteeCallSign: $trusteeCallSign, '
        'trusteeIndicator: $trusteeIndicator, '
        'physicianCertification: $physicianCertification, '
        'veSignature: $veSignature, '
        'systemicCallSignChane: $systemicCallSignChange, '
        'vanityCallSignChange: $vanityCallSignChange, '
        'vanityRelationShip: $vanityRelationShip, '
        'previousCallSign: $previousCallSign, '
        'previousOperatorClass: $previousOperatorClass, '
        'trusteeName: $trusteeName'
        '}';
  }
}
