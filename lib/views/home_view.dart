import 'package:flutter/material.dart';
import 'package:ham_lookup/controllers/aggregate/home_view_controller.dart';
import 'package:ham_lookup/model_provider/model_provider.dart';
import 'package:ham_lookup/types/en_record.dart';
import 'package:ham_lookup/views/subviews/search_view.dart';
import 'package:ham_lookup/widgets/app_bar_generator.dart';
import 'package:ham_lookup/views/subviews/ham_details.dart';
import 'package:ham_lookup/widgets/ham_entry_row.dart';
import 'package:ham_lookup/widgets/ham_header_row.dart';
import 'package:ham_lookup/widgets/loading_indicator.dart';
import 'package:ham_lookup/views/subviews/sync_status_footer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ModelState<HomeView, HomeViewController> {
  _HomeViewState() : super(controller: HomeViewController());

  List<EnRecord> results = [];

  @override
  Widget build(BuildContext context) {
    results = controller.fccDatabaseController.sortedList(
        controller.sortDetailsController.model.column,
        controller.sortDetailsController.model.direction);
    return LoadingIndicator(
      isLoading: controller.isLoading,
      child: Scaffold(
        appBar: AppBarGenerator.of(context).generateAppBar(
          title: 'FCC Search',
        ),
        drawer: AppBarGenerator.of(context).generateDrawer(),
        bottomNavigationBar: SyncStatusFooter(),
        body: Column(
          children: [
            SearchView(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: MediaQuery.of(context).size.width > 1100
                    ? MediaQuery.of(context).size.width - 16
                    : 1100,
                child: Column(
                  children: [
                    HamHeaderRow(),
                    Container(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                      height: MediaQuery.of(context).size.height - 358,
                      child: ListView.builder(
                          prototypeItem: HamEntryRow(
                            enRecord: EnRecord.empty(),
                            onTap: () => HamDetails(enRecord: EnRecord.empty()),
                          ),
                          itemCount: results.length,
                          itemBuilder: (context, idx) {
                            final enRecord = results[idx];
                            return HamEntryRow(
                              enRecord: enRecord,
                              onTap: () {
                                return HamDetails(enRecord: enRecord);
                              },
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
