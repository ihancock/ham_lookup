import 'package:ham_lookup/model_provider/model_provider.dart';
import 'package:ham_lookup/models/sort_details.dart';

class SortDetailsController extends ModelController<SortDetails> {
  static final SortDetailsController _instance = SortDetailsController._();

  SortDetailsController._() : super(modelCreator: () => SortDetails());

  factory SortDetailsController() => _instance;

  void setSortColumnAndDirection(
      {required int column, required SortDirection direction}) {
    updateModel(() {
      model.column = column;
      model.direction = direction;
    });
  }
}
