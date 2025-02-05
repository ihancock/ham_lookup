import 'package:ham_lookup/controllers/ffc_database_controller.dart';
import 'package:ham_lookup/controllers/sort_details_controller.dart';
import 'package:ham_lookup/model_provider/model_provider.dart';

class HomeViewController extends AggregateModelController {
  late FccDatabaseController fccDatabaseController;
  late SortDetailsController sortDetailsController;

  HomeViewController() {
    fccDatabaseController=registerController(FccDatabaseController());
    sortDetailsController=registerController(SortDetailsController());
  }
}