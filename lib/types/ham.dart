import 'package:ham_lookup/types/am_record.dart';
import 'package:ham_lookup/types/en_record.dart';

class Ham {
  final EnRecord enRecord;
  final AmRecord amRecord;

  Ham({required this.enRecord, required this.amRecord});

  @override
  String toString() => '{enRecord: $enRecord, amRecord $amRecord}';
}
