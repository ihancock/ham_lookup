import 'package:ham_lookup/types/am_record.dart';
import 'package:ham_lookup/types/co_record.dart';
import 'package:ham_lookup/types/en_record.dart';
import 'package:ham_lookup/types/hd_record.dart';

class Ham {
  final EnRecord enRecord;
  final AmRecord amRecord;
  final HdRecord hdRecord;
  final List<CoRecord> coRecords;
  final List<EnRecord> relatedRecords;

  Ham({
    required this.enRecord,
    required this.amRecord,
    required this.hdRecord,
    required this.coRecords,
    required this.relatedRecords,
  });

  @override
  String toString() =>
      '{enRecord: $enRecord, amRecord $amRecord, hdRecord: $hdRecord, coRecords: $coRecords, relatedRecords: $relatedRecords}';
}
