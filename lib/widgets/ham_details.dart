import 'package:flutter/material.dart';
import 'package:ham_lookup/types/ham.dart';

class HamDetails extends StatelessWidget {
  final Ham ham;
  const HamDetails({super.key, required this.ham});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width - 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('FCC ID: ${ham.fccId}'),
          Text('Call Sign: ${ham.callSign}'),
          Text('Full Name: ${ham.entityName}'),
          Text('Address: ${ham.streetAddress}'),
          Text('City: ${ham.city}'),
          Text('State: ${ham.state}'),
        ],
      ),
    );
  }
}
