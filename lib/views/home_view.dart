import 'package:flutter/material.dart';
import 'package:ham_lookup/controllers/aggregate/home_view_controller.dart';
import 'package:ham_lookup/model_provider/model_provider.dart';
import 'package:ham_lookup/models/fcc_database.dart';
import 'package:ham_lookup/models/sort_details.dart';
import 'package:ham_lookup/types/ham.dart';
import 'package:ham_lookup/views/subviews/search_view.dart';
import 'package:ham_lookup/widgets/app_bar_generator.dart';
import 'package:ham_lookup/widgets/ham_entry_row.dart';
import 'package:ham_lookup/widgets/ham_header_row.dart';
import 'package:ham_lookup/widgets/loading_indicator.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ModelState<HomeView, HomeViewController> {
  _HomeViewState() : super(controller: HomeViewController());

  List<Ham> results = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeData();
  }

  Future<void> initializeData() async {
    await controller.fccDatabaseController.downloadDatabase();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.fccDatabaseController.model.tab == SearchTab.callSign) {
      results = controller.fccDatabaseController.searchByCallSign(
          controller.fccDatabaseController.model.searchTerm ?? '--');
    } else if (controller.fccDatabaseController.model.tab ==
        SearchTab.address) {
      results = controller.fccDatabaseController.searchByAddress(
          controller.fccDatabaseController.model.searchTerm ?? '--');
    } else if (controller.fccDatabaseController.model.tab == SearchTab.city) {
      results = controller.fccDatabaseController.searchByCity(
          controller.fccDatabaseController.model.searchTerm ?? '--');
    } else if (controller.fccDatabaseController.model.tab == SearchTab.city) {
      results = controller.fccDatabaseController.searchByState(
          controller.fccDatabaseController.model.searchTerm ?? '--');
    }

    switch (controller.sortDetailsController.model.column) {
      case 0:
        if (controller.sortDetailsController.model.direction ==
            SortDirection.asc) {
          results.sort(
              (a, b) => (int.parse(a.fccId)).compareTo(int.parse(b.fccId)));
        } else {
          results.sort(
              (b, a) => (int.parse(a.fccId)).compareTo(int.parse(b.fccId)));
        }
        break;
      case 1:
        if (controller.sortDetailsController.model.direction ==
            SortDirection.asc) {
          results.sort((a, b) => (a.callSign).compareTo(b.callSign));
        } else {
          results.sort((b, a) => (a.callSign).compareTo(b.callSign));
        }
        break;
      case 2:
        if (controller.sortDetailsController.model.direction ==
            SortDirection.asc) {
          results
              .sort((a, b) => (a.fullName ?? '').compareTo(b.fullName ?? ''));
        } else {
          results
              .sort((b, a) => (a.fullName ?? '').compareTo(b.fullName ?? ''));
        }
        break;
      case 3:
        if (controller.sortDetailsController.model.direction ==
            SortDirection.asc) {
          results
              .sort((a, b) => (a.address1 ?? '').compareTo(b.address1 ?? ''));
        } else {
          results
              .sort((b, a) => (a.address1 ?? '').compareTo(b.address1 ?? ''));
        }
        break;
      case 4:
        if (controller.sortDetailsController.model.direction ==
            SortDirection.asc) {
          results.sort((a, b) => (a.city ?? '').compareTo(b.city ?? ''));
        } else {
          results.sort((b, a) => (a.city ?? '').compareTo(b.city ?? ''));
        }
        break;
      case 5:
        if (controller.sortDetailsController.model.direction ==
            SortDirection.asc) {
          results.sort((a, b) => (a.state ?? '').compareTo(b.state ?? ''));
        } else {
          results.sort((b, a) => (a.state ?? '').compareTo(b.state ?? ''));
        }
        break;
      case 6:
        if (controller.sortDetailsController.model.direction ==
            SortDirection.asc) {
          results.sort((a, b) => (int.tryParse(a.zip ?? '0') ?? 0)
              .compareTo(int.tryParse(b.zip ?? '0') ?? 0));
        } else {
          results.sort((b, a) => (int.tryParse(a.zip ?? '0') ?? 0)
              .compareTo(int.tryParse(b.zip ?? '0') ?? 0));
        }
        break;
      default:
    }
    return LoadingIndicator(
      isLoading: controller.isLoading,
      child: Scaffold(
        appBar: AppBarGenerator.of(context).generateAppBar(
            title: 'Home',
            syncStatus: controller.fccDatabaseController.model.syncStatus,
            recordCount: controller.fccDatabaseController.model.hams.length,
            onSyncTapped: () async {
              print('Sync Tapped');
              await controller.fccDatabaseController.downloadDatabase();
            }),
        drawer: AppBarGenerator.of(context).generateDrawer(),
        body: Column(
          children: [
            SearchView(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
            ),
            HamHeaderRow(),
            Container(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
              height: MediaQuery.of(context).size.height - 246,
              child: ListView.builder(
                  prototypeItem:
                      HamEntryRow(ham: Ham(fccId: '--', callSign: '--')),
                  itemCount: results.length,
                  itemBuilder: (context, idx) {
                    final ham = results[idx];
                    return HamEntryRow(ham: ham);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
