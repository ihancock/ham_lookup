import 'package:flutter/material.dart';
import 'package:ham_lookup/types/ham.dart';

class HamDetails extends StatelessWidget {
  final Ham ham;

  const HamDetails({super.key, required this.ham});

  @override
  Widget build(BuildContext context) {
    print(ham);
    return Container(
      padding: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width - 32,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 32,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 4))
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Entity Details',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text('FCC ID: ${ham.enRecord.fccId}'),
                  Text('Call Sign: ${ham.enRecord.callSign}'),
                  Text('Entity Name: ${ham.enRecord.entityName}'),
                  Text('FRN: ${ham.enRecord.frn}'),
                  Text(
                      'Entity Type: ${ham.enRecord.entityType?.description ?? '--'}'),
                  Text('Attention Of: ${ham.enRecord.attentionLine}'),
                  Text('Address: ${ham.enRecord.streetAddress}'),
                  Text('City: ${ham.enRecord.city}'),
                  Text('State: ${ham.enRecord.state}'),
                  Text('Zip: ${ham.enRecord.zip}'),
                  Text('Phone: ${ham.enRecord.phone}'),
                  Text('Email: ${ham.enRecord.email}'),
                  Text('Status: ${ham.enRecord.statusCode?.description ?? ''}'),
                  Text('Status Date: ${ham.enRecord.statusDate}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
