import 'package:ham_lookup/types/am_record.dart';
import 'package:ham_lookup/types/en_record.dart';

class Ham {
  final EnRecord enRecord;
  final AmRecord amRecord;
  final List<EnRecord> relatedRecords;

  Ham( {required this.enRecord, required this.amRecord, required this.relatedRecords,});

  @override
  String toString() => '{enRecord: $enRecord, amRecord $amRecord, relatedRecords: $relatedRecords}';
}
