import 'package:ham_lookup/types/am_record.dart';
import 'package:ham_lookup/types/co_record.dart';
import 'package:ham_lookup/types/en_record.dart';
import 'package:ham_lookup/model_provider/model_provider.dart';
import 'package:ham_lookup/types/hd_record.dart';

enum SearchTab { address, callSign, name, city, state }

enum SyncStatus { none, inProgress, complete }

class FccDatabase extends Model {
  Set<EnRecord> enRecords = {};
  Set<AmRecord> amRecords = {};
  Set<HdRecord> hdRecords = {};
  Set<CoRecord> coRecords = {};
  SyncStatus syncStatus = SyncStatus.none;
  SearchTab tab = SearchTab.callSign;
  SearchTab sortColumn = SearchTab.callSign;
  String? searchTerm;
}
