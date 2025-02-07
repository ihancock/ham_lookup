
import 'package:flutter/material.dart';
import 'package:ham_lookup/controllers/ffc_database_controller.dart';
import 'package:ham_lookup/model_provider/model_provider.dart';
import 'package:ham_lookup/types/en_record.dart';
import 'package:ham_lookup/types/ham.dart';

class HamDetails extends StatefulWidget {
  final EnRecord enRecord;

  const HamDetails({super.key, required this.enRecord});

  @override
  State<HamDetails> createState() => _HamDetailsState();
}

class _HamDetailsState extends ModelState<HamDetails, FccDatabaseController> {
  _HamDetailsState() : super(controller: FccDatabaseController());

  late Ham ham;

  @override
  void didChangeDependencies() {
    ham = controller.hamFromEnRecord(widget.enRecord);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant HamDetails oldWidget) {
    if (oldWidget.enRecord.fccId != widget.enRecord.fccId) {
      ham = controller.hamFromEnRecord(widget.enRecord);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 16,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              'Related Records',
              Wrap(
                children: ham.relatedRecords
                    .map((e) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          ham = controller.hamFromEnRecord(e);
                        });
                      },
                      child: Text(
                        e.callSign,
                        style: TextStyle(color: Colors.blueAccent),
                      )),
                ))
                    .toList(),
              ),
            ),
            _buildSection(
              context,
              'Entity Details',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow('FCC ID:', ham.enRecord.fccId),
                  _buildRow('Call Sign:', ham.enRecord.callSign),
                  _buildRow('Entity Name:', ham.enRecord.entityName),
                  _buildRow('FRN:', ham.enRecord.frn),
                  _buildRow('Entity Type:', ham.enRecord.entityType?.description ?? '--'),
                  _buildRow('Attention Of:', ham.enRecord.attentionLine),
                  _buildRow('Address:', ham.enRecord.streetAddress),
                  _buildRow('City:', ham.enRecord.city),
                  _buildRow('State:', ham.enRecord.state),
                  _buildRow('Zip:', (ham.enRecord.zip.length) > 5
                      ? '${ham.enRecord.zip.substring(0, 5)}-${ham.enRecord.zip.substring(5)}'
                      : ham.enRecord.zip,),
                  _buildRow('Phone:', ham.enRecord.phone),
                  _buildRow('Email:', ham.enRecord.email),
                  _buildRow('Status:', ham.enRecord.statusCode?.description ?? ''),
                  _buildRow('Status Date:', ham.enRecord.statusDate),
                ],
              ),
            ),
            _buildSection(
              context,
              'Amateur Details',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow('Operator Class:', ham.amRecord.operatorClass?.description??''),
                  _buildRow('Group Code:', ham.amRecord.groupCode),
                  _buildRow('Region Code:', ham.amRecord.regionCode),
                  _buildRow('Trustee Call Sign:', ham.amRecord.trusteeCallSign),
                  _buildRow('Trustee Indicator:', ham.amRecord.trusteeIndicator),
                  _buildRow('Physician Certification:', ham.amRecord.physicianCertification),
                  _buildRow('VE Signature:', ham.amRecord.veSignature),
                  _buildRow('Systemic Call Sign Change:', ham.amRecord.systemicCallSignChange),
                  _buildRow('Vanity Call Sign Change:', ham.amRecord.vanityCallSignChange),
                  _buildRow('Vanity Relation Ship:', ham.amRecord.vanityRelationShip),
                  _buildRow('Previous CallSign:', ham.amRecord.previousCallSign),
                  _buildRow('Previous Operator Class:', ham.amRecord.previousOperatorClass),
                  _buildRow('Trustee Name:', ham.amRecord.trusteeName),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget content) {
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8),
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
          Container(
            width: MediaQuery.of(context).size.width - 32,
            color: Colors.black12,
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          content,
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom:8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}