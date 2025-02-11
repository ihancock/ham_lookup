import 'package:ham_lookup/types/history_codes.dart';

class HsRecord {
  final int fccId;
  final String ulsFileNumber;
  final String callSign;
  final DateTime logDate;
  final String code;


  HsRecord({
    required this.fccId,
    required this.ulsFileNumber,
    required this.callSign,
    required this.logDate,
    required this.code,
  });

  String? get description => historyCodes[code.trim()];

@override
String toString() =>
    '{fccId: $fccId, ulsFileNumber: $ulsFileNumber, callSign: $callSign, logDate: $logDate, code: $code, description: $description}';}