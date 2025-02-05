import 'package:flutter/material.dart';
import 'package:ham_lookup/models/sort_details.dart';

class SortControl extends StatelessWidget {
  final SortDirection direction;
  final Function(SortDirection direction) onChange;

  const SortControl(
      {super.key, required this.direction, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          switch (direction) {
            case SortDirection.none:
            case SortDirection.desc:
              onChange(SortDirection.asc);
              break;
            case SortDirection.asc:
              onChange(SortDirection.desc);
          }
        },
        icon: Icon(direction == SortDirection.none
            ? Icons.sort
            : direction == SortDirection.asc
                ? Icons.arrow_downward
                : Icons.arrow_upward));
  }
}
