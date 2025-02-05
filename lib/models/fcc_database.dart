import 'package:ham_lookup/types/ham.dart';
import 'package:ham_lookup/model_provider/model_provider.dart';

enum SearchTab { address, callSign, city, state }

class FccDatabase extends Model {
  List<Ham> hams = [];
  SearchTab tab = SearchTab.callSign;
  SearchTab sortColumn = SearchTab.callSign;
  String? searchTerm;
}
