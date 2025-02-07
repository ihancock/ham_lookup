class HdRecord {
  final int fccId;
  final String ulsFileNumber;
  final String ebfNumber;
  final String callSign;
  final String licenseStatus;
  final String radioServiceCode;
  final String grantDate;
  final String expiredDate;
  final String cancellationDate;
  final String eligibilityRuleNum;
  final String alien;
  final String alienGovernment;
  final String alienCorporation;
  final String alienOfficer;
  final String alienControl;
  final String revoked;
  final String convicted;
  final String adjudged;
  final String commonCarrier;
  final String nonCommonCarrier;
  final String privateComm;
  final String fixed;
  final String mobile;
  final String radioLocation;
  final String satellite;
  final String developmentalOrStaOrDemonstration;
  final String interconnectedService;
  final String certifierFirstName;
  final String certifierMi;
  final String certifierLastName;
  final String certifierSuffix;
  final String certifierTitle;
  final String female;
  final String blackOrAfricanAmerican;
  final String nativeAmerican;
  final String hawaiian;
  final String asian;
  final String white;
  final String hispanic;
  final String effectiveDate;
  final String lastActionDate;
  final String auctionId;
  final String broadcastServicesRegulatoryStatus;
  final String bandManagerRegulatoryStatus;
  final String broadcastServicesTypeOfRadioService;
  final String alienRuling;
  final String licenseeNameChange;
  final String whitespaceIndicator;
  final String operationPerformanceRequirementChoice;
  final String operationPerformanceRequirementAnswer;
  final String discontinuationOfService;
  final String regulatoryCompliance;
  final String freq900MhzEligibilityCertification;
  final String freq900MhzTransitionPlanCertification;
  final String freq900MhzReturnSpectrumCertification;
  final String freq900MhzPaymentCertification;

  HdRecord(
      {required this.fccId,
      required this.ulsFileNumber,
      required this.ebfNumber,
      required this.callSign,
      required this.licenseStatus,
      required this.radioServiceCode,
      required this.grantDate,
      required this.expiredDate,
      required this.cancellationDate,
      required this.eligibilityRuleNum,
      required this.alien,
      required this.alienGovernment,
      required this.alienCorporation,
      required this.alienOfficer,
      required this.alienControl,
      required this.revoked,
      required this.convicted,
      required this.adjudged,
      required this.commonCarrier,
      required this.nonCommonCarrier,
      required this.privateComm,
      required this.fixed,
      required this.mobile,
      required this.radioLocation,
      required this.satellite,
      required this.developmentalOrStaOrDemonstration,
      required this.interconnectedService,
      required this.certifierFirstName,
      required this.certifierMi,
      required this.certifierLastName,
      required this.certifierSuffix,
      required this.certifierTitle,
      required this.female,
      required this.blackOrAfricanAmerican,
      required this.nativeAmerican,
      required this.hawaiian,
      required this.asian,
      required this.white,
      required this.hispanic,
      required this.effectiveDate,
      required this.lastActionDate,
      required this.auctionId,
      required this.broadcastServicesRegulatoryStatus,
      required this.bandManagerRegulatoryStatus,
      required this.broadcastServicesTypeOfRadioService,
      required this.alienRuling,
      required this.licenseeNameChange,
      required this.whitespaceIndicator,
      required this.operationPerformanceRequirementChoice,
      required this.operationPerformanceRequirementAnswer,
      required this.discontinuationOfService,
      required this.regulatoryCompliance,
      required this.freq900MhzEligibilityCertification,
      required this.freq900MhzTransitionPlanCertification,
      required this.freq900MhzReturnSpectrumCertification,
      required this.freq900MhzPaymentCertification});

  @override
  String toString() {
    return '{'
        'fccId: $fccId, '
        'ulsFileNumber: $ulsFileNumber, '
        'ebfNumber: $ebfNumber, '
        'callSign: $callSign, '
        'licenseStatus: $licenseStatus, '
        'radioServiceCode: $radioServiceCode, '
        'grantDate: $grantDate, '
        'expiredDate: $expiredDate, '
        'cancellationDate: $cancellationDate, '
        'eligibilityRuleNum: $eligibilityRuleNum, '
        'alien: $alien, '
        'alienGovernment: $alienGovernment, '
        'alienCorporation: $alienCorporation, '
        'alienOfficer: $alienOfficer, '
        'alienControl: $alienControl, '
        'revoked: $revoked, '
        'convicted: $convicted, '
        'adjudged: $adjudged, '
        'commonCarrier: $commonCarrier, '
        'nonCommonCarrier: $nonCommonCarrier, '
        'privateComm: $privateComm, '
        'fixed: $fixed, '
        'mobile: $mobile, '
        'radioLocation: $radioLocation, '
        'satellite: $satellite, '
        'developmentalOrStaOrDemonstration: $developmentalOrStaOrDemonstration, '
        'interconnectedService: $interconnectedService, '
        'certifierFirstName: $certifierFirstName, '
        'certifierMi: $certifierMi, '
        'certifierLastName: $certifierLastName, '
        'certifierSuffix: $certifierSuffix, '
        'certifierTitle: $certifierTitle, '
        'female: $female, '
        'blackOrAfricanAmerican: $blackOrAfricanAmerican, '
        'nativeAmerican: $nativeAmerican, '
        'hawaiian: $hawaiian, '
        'asian: $asian, '
        'white: $white, '
        'hispanic: $hispanic, '
        'effectiveDate: $effectiveDate, '
        'lastActionDate: $lastActionDate, '
        'auctionId: $auctionId, '
        'broadcastServicesRegulatoryStatus: $broadcastServicesRegulatoryStatus, '
        'bandManagerRegulatoryStatus: $bandManagerRegulatoryStatus, '
        'broadcastServicesTypeOfRadioService: $broadcastServicesTypeOfRadioService, '
        'alienRuling: $alienRuling, '
        'licenseeNameChange: $licenseeNameChange, '
        'whitespaceIndicator: $whitespaceIndicator, '
        'operationPerformanceRequirementChoice: $operationPerformanceRequirementChoice, '
        'operationPerformanceRequirementAnswer: $operationPerformanceRequirementAnswer, '
        'discontinuationOfService: $discontinuationOfService, '
        'regulatoryCompliance: $regulatoryCompliance, '
        'freq900MhzEligibilityCertification: $freq900MhzEligibilityCertification, '
        'freq900MhzTransitionPlanCertification: $freq900MhzTransitionPlanCertification, '
        'freq900MhzReturnSpectrumCertification: $freq900MhzReturnSpectrumCertification, '
        'freq900MhzPaymentCertification: $freq900MhzPaymentCertification'
        '}';
  }
}
