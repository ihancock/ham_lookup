import 'package:ham_lookup/types/ham.dart';
import 'package:ham_lookup/model_provider/model_provider.dart';

enum SearchTab { address, callSign, city, state }

enum SyncStatus { none, inProgress, complete }

class FccDatabase extends Model {
  Set<Ham> hams = {};
  SyncStatus syncStatus = SyncStatus.none;
  SearchTab tab = SearchTab.callSign;
  SearchTab sortColumn = SearchTab.callSign;
  String? searchTerm;
}
