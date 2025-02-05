import 'package:ham_lookup/model_provider/model_provider.dart';

enum SortDirection { none, asc, desc }

class SortDetails extends Model {
  SortDirection direction = SortDirection.none;
  int column=0;

}