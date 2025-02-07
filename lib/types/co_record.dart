import 'package:ham_lookup/types/status_code.dart';

class CoRecord {
  final int fccId;
  final String ulsFileNumber;
  final String callSign;
  final String commentDate;
  final String description;
  final StatusCode? statusCode;
  final String statusDate;

  CoRecord(
      {required this.fccId,
      required this.ulsFileNumber,
      required this.callSign,
      required this.commentDate,
      required this.description,
      this.statusCode,
      required this.statusDate});

  @override
  String toString() =>
      '{fccId: $fccId, ulsFileNumber: $ulsFileNumber, callSign: $callSign, commentDate: $commentDate, description: $description, statusCode: $statusCode, statusDate: $statusDate}';
}
