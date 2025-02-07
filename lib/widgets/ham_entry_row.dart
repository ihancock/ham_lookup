import 'package:flutter/material.dart';
import 'package:ham_lookup/types/ham.dart';
import 'package:ham_lookup/widgets/ham_details.dart';

class HamEntryRow extends StatefulWidget {
  final Ham ham;

  const HamEntryRow({super.key, required this.ham});

  @override
  State<HamEntryRow> createState() => _HamEntryRowState();
}

class _HamEntryRowState extends State<HamEntryRow> {
  bool highlight = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) => setState(() {
        highlight = true;
      }),
      onExit: (e) => setState(() {
        highlight = false;
      }),
      onHover: (e) => setState(() {
        highlight = true;
      }),
      child: GestureDetector(
        onTap: () {
          print('${widget.ham}');
          showGeneralDialog(
              context: context,
              pageBuilder: (context, animation, secondaryAnimation) {
                return AlertDialog(
                  title: Text('Details'),
                  content: HamDetails(ham: widget.ham),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'))
                  ],
                );
              });
        },
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black12)),
              color: highlight ? Colors.white24 : Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 100, child: Text(widget.ham.fccId)),
              SizedBox(width: 101, child: Text(widget.ham.callSign)),
              SizedBox(
                  width: 200,
                  child: Text(
                    widget.ham.entityName,
                    overflow: TextOverflow.ellipsis,
                  )),
              SizedBox(
                  width: 220,
                  child: Text(
                    widget.ham.streetAddress,
                  )),
              SizedBox(
                  width: 180,
                  child: Text(
                    widget.ham.city,
                  )),
              SizedBox(
                  width: 100,
                  child: Text(
                    widget.ham.state,
                  )),
              SizedBox(
                  width: 120,
                  child: Text(
                    (widget.ham.zip.length) > 5
                        ? '${widget.ham.zip.substring(0, 5)}-${widget.ham.zip.substring(5)}'
                        : widget.ham.zip,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
