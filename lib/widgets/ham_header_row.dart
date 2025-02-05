import 'package:flutter/material.dart';
import 'package:ham_lookup/controllers/sort_details_controller.dart';
import 'package:ham_lookup/model_provider/model_provider.dart';
import 'package:ham_lookup/models/sort_details.dart';
import 'package:ham_lookup/widgets/sort_control.dart';

class HamHeaderRow extends StatefulWidget {
  const HamHeaderRow({super.key});

  @override
  State<HamHeaderRow> createState() => _HamHeaderRowState();
}

class _HamHeaderRowState
    extends ModelState<HamHeaderRow, SortDetailsController> {
  _HamHeaderRowState() : super(controller: SortDetailsController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 40,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.black26, width: 1)),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4), topRight: Radius.circular(4))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('FCC Id'),
                  SortControl(
                      direction: controller.model.column == 0
                          ? controller.model.direction
                          : SortDirection.none,
                      onChange: (direction) {
                        controller.setSortColumnAndDirection(
                            column: 0, direction: direction);
                      })
                ],
              )),
          SizedBox(
              width: 101,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Call Sign'),
                  SortControl(
                      direction: controller.model.column == 1
                          ? controller.model.direction
                          : SortDirection.none,
                      onChange: (direction) {
                        controller.setSortColumnAndDirection(
                            column: 1, direction: direction);
                      })
                ],
              )),
          SizedBox(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Full name'),
                  SortControl(
                      direction: controller.model.column == 2
                          ? controller.model.direction
                          : SortDirection.none,
                      onChange: (direction) {
                        controller.setSortColumnAndDirection(
                            column: 2, direction: direction);
                      })
                ],
              )),
          SizedBox(width: 220, child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Address'),
              SortControl(
                  direction: controller.model.column == 3
                      ? controller.model.direction
                      : SortDirection.none,
                  onChange: (direction) {
                    controller.setSortColumnAndDirection(
                        column: 3, direction: direction);
                  })
            ],
          )),
          SizedBox(width: 180, child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('City'),
              SortControl(
                  direction: controller.model.column == 4
                      ? controller.model.direction
                      : SortDirection.none,
                  onChange: (direction) {
                    controller.setSortColumnAndDirection(
                        column: 4, direction: direction);
                  })
            ],
          )),
          SizedBox(width: 100, child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('State'),
              SortControl(
                  direction: controller.model.column == 5
                      ? controller.model.direction
                      : SortDirection.none,
                  onChange: (direction) {
                    controller.setSortColumnAndDirection(
                        column: 5, direction: direction);
                  })
            ],
          )),
          SizedBox(width: 120, child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Zip'),
              SortControl(
                  direction: controller.model.column == 6
                      ? controller.model.direction
                      : SortDirection.none,
                  onChange: (direction) {
                    controller.setSortColumnAndDirection(
                        column: 6, direction: direction);
                  })
            ],
          )),
        ],
      ),
    );
  }
}
