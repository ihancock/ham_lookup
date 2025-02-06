import 'package:flutter/material.dart';
import 'package:ham_lookup/controllers/aggregate/home_view_controller.dart';
import 'package:ham_lookup/model_provider/model_provider.dart';
import 'package:ham_lookup/models/fcc_database.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ModelState<SearchView, HomeViewController> {
  _SearchViewState() : super(controller: HomeViewController());

  @override
  Widget build(BuildContext context) {
    final tabs = [
      Tab(icon: Icon(Icons.radio), text: 'Call Sign'),
      Tab(icon: Icon(Icons.person), text: 'Name'),
      Tab(icon: Icon(Icons.house), text: 'Address'),
      Tab(icon: Icon(Icons.location_city), text: 'City'),
      Tab(icon: Icon(Icons.map), text: 'State')
    ];
    return DefaultTabController(
        length: tabs.length,
        child: Column(
          children: [
            TabBar(tabs: tabs),
            Container(
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: TabBarView(children: [
                SearchBar(
                  leading: const Icon(Icons.search),
                  hintText: 'Call sign',
                  elevation: WidgetStatePropertyAll<double>(0.0),
                  onChanged: (value) {
                    if (value.length > 1) {
                      controller.fccDatabaseController.setTabAndSearchTerm(
                          tab: SearchTab.callSign, searchTerm: value);
                    }
                  },
                ),
                SearchBar(
                  leading: const Icon(Icons.search),
                  hintText: 'Name',
                  elevation: WidgetStatePropertyAll<double>(0.0),
                  onChanged: (value) {
                    if (value.length > 1) {
                      controller.fccDatabaseController.setTabAndSearchTerm(
                          tab: SearchTab.name, searchTerm: value);
                    }
                  },
                ),
                SearchBar(
                    leading: const Icon(Icons.search),
                    hintText: 'Address',
                    elevation: WidgetStatePropertyAll<double>(0.0),
                    onChanged: (value) {
                      if (value.length > 1) {
                        controller.fccDatabaseController.setTabAndSearchTerm(
                            tab: SearchTab.address, searchTerm: value);
                      }
                    }),
                SearchBar(
                    leading: const Icon(Icons.search),
                    hintText: 'City',
                    elevation: WidgetStatePropertyAll<double>(0.0),
                    onChanged: (value) {
                      if (value.length > 1) {
                        controller.fccDatabaseController.setTabAndSearchTerm(
                            tab: SearchTab.city, searchTerm: value);
                      }
                    }),
                SearchBar(
                    leading: const Icon(Icons.search),
                    hintText: 'State',
                    elevation: WidgetStatePropertyAll<double>(0.0),
                    onChanged: (value) {
                      if (value.length > 1) {
                        controller.fccDatabaseController.setTabAndSearchTerm(
                            tab: SearchTab.state, searchTerm: value);
                      }
                    })
              ]),
            )
          ],
        ));
  }
}
