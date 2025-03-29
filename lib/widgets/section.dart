import 'package:flutter/material.dart';
import 'package:ham_lookup/theme/ux_colors.dart';

class Section extends StatelessWidget {
  const Section({super.key, required this.child, this.width, this.title});

  final double? width;
  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        decoration: BoxDecoration(
            border: Border.all(
              color: UxColors.borderActive,
            ),
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 4, offset: Offset(0, 4))
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width,
              color: UxColors.mutedGrey,
              height:28,
              alignment: Alignment.center,
              child: Text(
                title!,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Container(
              color: UxColors.white,
              padding: const EdgeInsets.all(8),
              child: child,
            ),
          ],
        ));
  }
}
