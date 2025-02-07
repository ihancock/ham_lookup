import 'package:ham_lookup/types/am_record.dart';
import 'package:ham_lookup/types/applicant_type.dart';
import 'package:ham_lookup/types/entity_type.dart';
import 'package:ham_lookup/types/status_code.dart';

class Ham {
  final String fccId;
  final String ulsFileNumber;
  final String ebfNumber;
  final String callSign;
  final EntityType? entityType;
  final String licenseId;
  final String entityName;
  final String firstName;
  final String middleInitial;
  final String lastName;
  final String suffix;
  final String phone;
  final String fax;
  final String email;
  final String streetAddress;
  final String city;
  final String state;
  final String zip;
  final String poBox;
  final String attentionLine;
  final String sgin;
  final String frn;
  final ApplicantType? applicantType;
  final String applicantTypeOther;
  final StatusCode? statusCode;
  final String statusDate;

  AmRecord? amRecord;

  Ham(
      {required this.fccId,
      required this.ulsFileNumber,
      required this.ebfNumber,
      required this.callSign,
      this.entityType,
      required this.licenseId,
      required this.entityName,
      required this.firstName,
      required this.middleInitial,
      required this.lastName,
      required this.suffix,
      required this.phone,
      required this.fax,
      required this.email,
      required this.streetAddress,
      required this.city,
      required this.state,
      required this.zip,
      required this.poBox,
      required this.attentionLine,
      required this.sgin,
      required this.frn,
      this.applicantType,
      required this.applicantTypeOther,
      this.statusCode,
      required this.statusDate});

  Ham.empty()
      : fccId = '',
        ulsFileNumber = '',
        ebfNumber = '',
        callSign = '',
        entityType = null,
        licenseId = '',
        entityName = '',
        firstName = '',
        middleInitial = '',
        lastName = '',
        suffix = '',
        phone = '',
        fax = '',
        email = '',
        streetAddress = '',
        city = '',
        state = '',
        zip = '',
        poBox = '',
        attentionLine = '',
        sgin = '',
        frn = '',
        applicantType = null,
        applicantTypeOther = '',
        statusCode = null,
        statusDate = '';

  operator ==(o) => o is Ham && o.fccId == fccId && o.callSign == callSign;

  int get hashCode => fccId.hashCode ^ callSign.hashCode;

  @override
  String toString() {
    return '{'
        'fccId: $fccId, '
        'ulsFileNumber: $ulsFileNumber, '
        'ebfNumber: $ebfNumber, '
        'callSign: $callSign, '
        'entityType: $entityType, '
        'licenseId: $licenseId, '
        'entityName: $entityName, '
        'firstName: $firstName, '
        'middleInitial: $middleInitial, '
        'lastName: $lastName, '
        'suffix: $suffix, '
        'phone: $phone, '
        'fax: $fax, '
        'email: $email, '
        'streetAddress: $streetAddress, '
        'city: $city, '
        'state: $state, '
        'zip: $zip, '
        'poBox: $poBox, '
        'attentionLine: $attentionLine, '
        'sgin: $sgin, '
        'frn: $frn, '
        'applicantType: $applicantType, '
        'applicantTypeOther: $applicantTypeOther, '
        'statusCode: $statusCode, '
        'statusDate: $statusDate'
        '}';
  }
}
