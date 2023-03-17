public class AcetGetProfessionalJSON2Apex {
    public static void consumeObject(JSONParser parser) {
        Integer depth = 0;
        do {
            JSONToken curr = parser.getCurrentToken();
            if (curr == JSONToken.START_OBJECT || 
                curr == JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == JSONToken.END_OBJECT ||
                curr == JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }

    public class ServiceLineOtherPayer_Z {
        public String patientResponsibilityAmount {get;set;} 

        public ServiceLineOtherPayer_Z(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'patientResponsibilityAmount') {
                            patientResponsibilityAmount = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'ServiceLineOtherPayer_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Susbcriber {
        public String memberGroupNumber {get;set;} 
        public String memberGroupName {get;set;} 
        public List<Identifiers_Z> identifiers {get;set;} 
        public Name name {get;set;} 
        public String birthDate {get;set;} 

        public Susbcriber(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'memberGroupNumber') {
                            memberGroupNumber = parser.getText();
                        } else if (text == 'memberGroupName') {
                            memberGroupName = parser.getText();
                        } else if (text == 'identifiers') {
                            identifiers = new List<Identifiers_Z>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                identifiers.add(new Identifiers_Z(parser));
                            }
                        } else if (text == 'name') {
                            name = new Name(parser);
                        } else if (text == 'birthDate') {
                            birthDate = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Susbcriber consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Address {
        public String addressLine1 {get;set;} 
        public String addressLine2 {get;set;} 
        public String city {get;set;} 
        public String state {get;set;} 
        public String postalCode {get;set;} 

        public Address(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'addressLine1') {
                            addressLine1 = parser.getText();
                        } else if (text == 'addressLine2') {
                            addressLine2 = parser.getText();
                        } else if (text == 'city') {
                            city = parser.getText();
                        } else if (text == 'state') {
                            state = parser.getText();
                        } else if (text == 'postalCode') {
                            postalCode = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Address consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class ClaimAccumulator {
        public AdjudicatedCOBLevel tierTypeCode {get;set;} 
        public String coverageLevel {get;set;} 
        public String costShareType {get;set;} 
        public String claimAccumAppliedAmount {get;set;} 
        public String accumSnapshotAppliedAmount {get;set;} 

        public ClaimAccumulator(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'tierTypeCode') {
                            tierTypeCode = new AdjudicatedCOBLevel(parser);
                        } else if (text == 'coverageLevel') {
                            coverageLevel = parser.getText();
                        } else if (text == 'costShareType') {
                            costShareType = parser.getText();
                        } else if (text == 'claimAccumAppliedAmount') {
                            claimAccumAppliedAmount = parser.getText();
                        } else if (text == 'accumSnapshotAppliedAmount') {
                            accumSnapshotAppliedAmount = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'ClaimAccumulator consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class ProcedureCode {
        public AdjudicatedCOBLevel code {get;set;} 
        public AdjudicatedCOBLevel type_Z {get;set;} // in json: type
        public List<AdjudicatedCOBLevel> hpcscptModifierCode {get;set;} 

        public ProcedureCode(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'code') {
                            code = new AdjudicatedCOBLevel(parser);
                        } else if (text == 'type') {
                            type_Z = new AdjudicatedCOBLevel(parser);
                        } else if (text == 'hpcscptModifierCode') {
                            hpcscptModifierCode = new List<AdjudicatedCOBLevel>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                hpcscptModifierCode.add(new AdjudicatedCOBLevel(parser));
                            }
                        } else {
                            System.debug(LoggingLevel.WARN, 'ProcedureCode consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class DocReferenceValues {
        public String name {get;set;} 
        public String value {get;set;} 

        public DocReferenceValues(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'value') {
                            value = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'DocReferenceValues consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class ClaimDocument {
        public String documentId {get;set;}
        
        public ClaimDocument(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'documentId') {
                            documentId = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'ClaimDocument consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class ClaimEvent {
        public String claimEventAdjudicationDateTime {get;set;} 
        public AdjudicatedCOBLevel claimEventType {get;set;} 
        public String claimEventSeqNum {get;set;} 
        public List<ClaimDocument> claimDocument {get;set;}
        public String claimEventId {get;set;} 

        public ClaimEvent(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'claimEventAdjudicationDateTime') {
                            claimEventAdjudicationDateTime = parser.getText();
                        } else if (text == 'claimEventType') {
                            claimEventType = new AdjudicatedCOBLevel(parser);
                        } else if (text == 'claimEventSeqNum') {
                            claimEventSeqNum = parser.getText();
                        } else if (text == 'claimDocument') {
                            claimDocument = new List<ClaimDocument>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                claimDocument.add(new ClaimDocument(parser));
                            }
                        } else if (text == 'claimEventId') {
                            claimEventId = parser.getText();
                        }else {
                            System.debug(LoggingLevel.WARN, 'ClaimEvent consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Adjustments {
        public AdjudicatedCOBLevel code {get;set;} 
        public AdjudicatedCOBLevel remarkGroupCode {get;set;} 
        public String amount {get;set;} 

        public Adjustments(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'code') {
                            code = new AdjudicatedCOBLevel(parser);
                        } else if (text == 'remarkGroupCode') {
                            remarkGroupCode = new AdjudicatedCOBLevel(parser);
                        } else if (text == 'amount') {
                            amount = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Adjustments consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class ClaimSubmissionType {
        public String code {get;set;}
        public String description {get;set;}
        
        public ClaimSubmissionType(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'code') {
                            code = parser.getText();
                        } else if (text == 'description') {
                            description = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'ClaimSubmissionType consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class ProfessionalClaim {
        public ClaimType claimType {get;set;} 
        public ClaimSubmissionType claimSubmissionType {get;set;}
        public String claimFirstDateofService {get;set;} 
        public String claimLastDateofService {get;set;} 
        public String claimFLNNumber {get;set;} 
        public String claimID {get;set;} 
        public list<String> referenceClaimID {get;set;} 
        public AdjudicatedCOBLevel adjudicatedCOBLevel {get;set;} 
        public String claimSourceSystemCode {get;set;} 
        public String claimSplitIndicator {get;set;} 
        public AdjudicatedCOBLevel claimStatusCode {get;set;} 
        public AdjudicatedCOBLevel claimNetworkIndicator {get;set;} 
        public AdjudicatedCOBLevel claimCauseCode {get;set;} 
        public List<AdjudicatedCOBLevel> pendReasonCode {get;set;} 
        public String encounterIndicator {get;set;} 
        public String timelyFilingLimitDays {get;set;} 
        public List<DocumentKeys> documentKeys {get;set;} 
        public String claimReceiptDate {get;set;} 
        public List<ClaimEvent> claimEvent {get;set;} 
        public List<CesMnemonic> cesMnemonic {get;set;} 
        public CarcAdjustments carcAdjustments {get;set;} 
        public List<ClaimRemarks> claimRemarks {get;set;} 
        public List<DiagnosisCode> diagnosisCode {get;set;} 
        public Patient patient {get;set;} 
        public String patientAccountNumber {get;set;} 
        public String privacyIndicator {get;set;} 
        public List<Provider> provider {get;set;} 
        public Susbcriber susbcriber {get;set;} 
        public String payerType {get;set;} 
        public List<OtherPayer> otherPayer {get;set;} 
        public ClaimUHCTotals claimUHCTotals {get;set;} 
        public List<ClaimNotes> claimNotes {get;set;} 
        public List<ServiceLine> serviceLine {get;set;} 
        public List<String> relatedIcns {get;set;}


        public ProfessionalClaim(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'claimType') {
                            claimType = new ClaimType(parser);
                        } else if (text == 'claimSubmissionType') {
                            claimSubmissionType = new ClaimSubmissionType(parser);
                        } else if (text == 'claimFirstDateofService') {
                            claimFirstDateofService = parser.getText();
                        } else if (text == 'claimLastDateofService') {
                            claimLastDateofService = parser.getText();
                        } else if (text == 'claimFLNNumber') {
                            claimFLNNumber = parser.getText();
                        } else if (text == 'claimID') {
                            claimID = parser.getText();
                        } else if (text == 'referenceClaimID') {
                            referenceClaimID = new List<String>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                referenceClaimID.add(parser.getText());
                            }
                        } else if (text == 'adjudicatedCOBLevel') {
                            adjudicatedCOBLevel = new AdjudicatedCOBLevel(parser);
                        } else if (text == 'claimSourceSystemCode') {
                            claimSourceSystemCode = parser.getText();
                        } else if (text == 'claimSplitIndicator') {
                            claimSplitIndicator = parser.getText();
                        } else if (text == 'claimStatusCode') {
                            claimStatusCode = new AdjudicatedCOBLevel(parser);
                        } else if (text == 'claimNetworkIndicator') {
                            claimNetworkIndicator = new AdjudicatedCOBLevel(parser);
                        } else if (text == 'claimCauseCode') {
                            claimCauseCode = new AdjudicatedCOBLevel(parser);
                        } else if (text == 'pendReasonCode') {
                            pendReasonCode = new List<AdjudicatedCOBLevel>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                pendReasonCode.add(new AdjudicatedCOBLevel(parser));
                            }
                        } else if (text == 'encounterIndicator') {
                            encounterIndicator = parser.getText();
                        } else if (text == 'timelyFilingLimitDays') {
                            timelyFilingLimitDays = parser.getText();
                        } else if (text == 'documentKeys') {
                            documentKeys = new List<DocumentKeys>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                documentKeys.add(new DocumentKeys(parser));
                            }
                        } else if (text == 'claimReceiptDate') {
                            claimReceiptDate = parser.getText();
                        } else if (text == 'claimEvent') {
                            claimEvent = new List<ClaimEvent>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                claimEvent.add(new ClaimEvent(parser));
                            }
                        } else if (text == 'cesMnemonic') {
                            cesMnemonic = new List<CesMnemonic>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                cesMnemonic.add(new CesMnemonic(parser));
                            }
                        } else if (text == 'carcAdjustments') {
                            carcAdjustments = new CarcAdjustments(parser);
                        } else if (text == 'claimRemarks') {
                            claimRemarks = new List<ClaimRemarks>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                claimRemarks.add(new ClaimRemarks(parser));
                            }
                        } else if (text == 'diagnosisCode') {
                            diagnosisCode = new List<DiagnosisCode>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                diagnosisCode.add(new DiagnosisCode(parser));
                            }
                        } else if (text == 'patient') {
                            patient = new Patient(parser);
                        } else if (text == 'patientAccountNumber') {
                            patientAccountNumber = parser.getText();
                        } else if (text == 'privacyIndicator') {
                            privacyIndicator = parser.getText();
                        } else if (text == 'provider') {
                            provider = new List<Provider>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                provider.add(new Provider(parser));
                            }
                        } else if (text == 'susbcriber') {
                            susbcriber = new Susbcriber(parser);
                        } else if (text == 'payerType') {
                            payerType = parser.getText();
                        } else if (text == 'otherPayer') {
                            otherPayer = new List<OtherPayer>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                otherPayer.add(new OtherPayer(parser));
                            }
                        } else if (text == 'claimUHCTotals') {
                            claimUHCTotals = new ClaimUHCTotals(parser);
                        } else if (text == 'claimNotes') {
                            claimNotes = new List<ClaimNotes>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                claimNotes.add(new ClaimNotes(parser));
                            }
                        } else if (text == 'serviceLine') {
                            serviceLine = new List<ServiceLine>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                serviceLine.add(new ServiceLine(parser));
                            }
                        }  else if (text == 'relatedIcns') {
                            relatedIcns = new List<String>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                relatedIcns.add(parser.getText());
                            }
                        } else {
                            System.debug(LoggingLevel.WARN, 'ProfessionalClaim consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class GetProfessionalClaimResponse {
        public ProfessionalClaim professionalClaim {get;set;} 

        public GetProfessionalClaimResponse(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'professionalClaim') {
                            professionalClaim = new ProfessionalClaim(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'GetProfessionalClaimResponse consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class ClaimType {
        public String code {get;set;} 
        public String description {get;set;}
        
        public ClaimType(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'code') {
                            code = parser.getText();
                        }else if(text == 'description'){
                            description = parser.getText(); 
                        } else {
                            System.debug(LoggingLevel.WARN, 'ClaimType consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Name {
        public String firstName {get;set;} 
        public String lastName {get;set;} 

        public Name(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'firstName') {
                            firstName = parser.getText();
                        } else if (text == 'lastName') {
                            lastName = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Name consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    

        public GetProfessionalClaimResponse getProfessionalClaimResponse {get;set;} 

        public AcetGetProfessionalJSON2Apex(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'getProfessionalClaimResponse') {
                            getProfessionalClaimResponse = new GetProfessionalClaimResponse(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'AcetGetProfessionalJSON2Apex consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    
    
    public class ClaimNotes {
        public String noteTypeCode {get;set;} 
        public String noteTypeText {get;set;} 
        public String notesCreatedBy {get;set;} 
        public String notesCreatedDate {get;set;} 

        public ClaimNotes(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'noteTypeCode') {
                            noteTypeCode = parser.getText();
                        } else if (text == 'noteTypeText') {
                            noteTypeText = parser.getText();
                        } else if (text == 'notesCreatedBy') {
                            notesCreatedBy = parser.getText();
                        } else if (text == 'notesCreatedDate') {
                            notesCreatedDate = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'ClaimNotes consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class CesMnemonic {
        public AdjudicatedCOBLevel cesMnemonicCode {get;set;} 
        public String cesRemarkCode {get;set;} 
        public String cesRemarkText {get;set;} 

        public CesMnemonic(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        system.debug('<<<cesmnemonicTEXT>>>'+text);
                        if (text == 'cesMnemonicCode') {
                            cesMnemonicCode = new AdjudicatedCOBLevel(parser);
                        } else if (text == 'cesRemarkCode') {
                            cesRemarkCode = parser.getText();
                        } else if (text == 'cesRemarkText') {
                            cesRemarkText = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'CesMnemonic consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class CarcAdjustments_Z {
        public List<Adjustments_Z> adjustments {get;set;} 
        public String adjustmentTotal {get;set;} 

        public CarcAdjustments_Z(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'adjustments') {
                            adjustments = new List<Adjustments_Z>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                adjustments.add(new Adjustments_Z(parser));
                            }
                        } else if (text == 'adjustmentTotal') {
                            adjustmentTotal = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'CarcAdjustments_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class OtherPayer {
        public OtherInsuranceSubscriberID otherInsuranceSubscriberID {get;set;} 
        public OtherInsuranceSubscriberName otherInsuranceSubscriberName {get;set;} 
        public AdjudicatedCOBLevel payerResponsibilitySequenceCode {get;set;} 
        public String otherInsurancePayerID {get;set;} 
        public String otherInsurancePayerName {get;set;} 
        public AdjudicatedCOBLevel insuranceTypeCode {get;set;} 
        public String claimTotalOtherPayerPaidAmount {get;set;} 
        public String claimTotalOtherPayerPatientResponsibilityAmount {get;set;} 
        public String claimTotalOtherPayerNotCoveredAmount {get;set;} 

        public OtherPayer(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'otherInsuranceSubscriberID') {
                            otherInsuranceSubscriberID = new OtherInsuranceSubscriberID(parser);
                        } else if (text == 'otherInsuranceSubscriberName') {
                            otherInsuranceSubscriberName = new OtherInsuranceSubscriberName(parser);
                        } else if (text == 'payerResponsibilitySequenceCode') {
                            payerResponsibilitySequenceCode = new AdjudicatedCOBLevel(parser);
                        } else if (text == 'otherInsurancePayerID') {
                            otherInsurancePayerID = parser.getText();
                        } else if (text == 'otherInsurancePayerName') {
                            otherInsurancePayerName = parser.getText();
                        } else if (text == 'insuranceTypeCode') {
                            insuranceTypeCode = new AdjudicatedCOBLevel(parser);
                        } else if (text == 'claimTotalOtherPayerPaidAmount') {
                            claimTotalOtherPayerPaidAmount = parser.getText();
                        } else if (text == 'claimTotalOtherPayerPatientResponsibilityAmount') {
                            claimTotalOtherPayerPatientResponsibilityAmount = parser.getText();
                        } else if (text == 'claimTotalOtherPayerNotCoveredAmount') {
                            claimTotalOtherPayerNotCoveredAmount = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'OtherPayer consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class ServiceLine {
        public String claimServiceLineID {get;set;} 
        public String serviceFirstDateofService {get;set;} 
        public String serviceLastDateofService {get;set;} 
        public ClaimType serviceNetworkIndicator {get;set;} 
        public AdjudicatedCOBLevel serviceLineStatusCode {get;set;} 
        public ClaimType healthCoverageType {get;set;} 
        public String unitOfMeasure {get;set;} 
        public ClaimType revenueCode {get;set;} 
        public String serviceUnitCount {get;set;} 
        public String placeofServiceCode {get;set;} 
        public String overrideIndicator {get;set;} 
        public AdjudicatedCOBLevel cobMethod {get;set;} 
        public List<CesMnemonic> cesMnemonic {get;set;} 
        public String claimLineAdjudicationDate {get;set;} 
        public CarcAdjustments_Z carcAdjustments {get;set;} 
        public String authorizationNumber {get;set;} 
        public List<BenefitClaimAccumulator> benefitClaimAccumulator {get;set;} 
        public BenefitPlan benefitPlan {get;set;} 
        public ProcedureCode procedureCode {get;set;} 
        public List<String> diagnosisCodePointer {get;set;} 
        public ServiceLineUHCAmounts serviceLineUHCAmounts {get;set;} 
        public List<ServiceLineOtherPayer> serviceLineOtherPayer {get;set;} 
        public List<Provider_Z> provider {get;set;} 
        public List<ClaimRemarks> serviceRemarks {get;set;} 
        public List<ClaimNotes> serviceNotes {get;set;} 
        public String referralNumber {get;set;} 
        public List<String> pendReasonCode {get;set;} 
        public List<String> alphaParentLineNum {get;set;} 
        Public String qualityTierValue{get;set;}

        
        public ServiceLine(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'claimServiceLineID') {
                            claimServiceLineID = parser.getText();
                        }
                         else if (text == 'qualityTierValue') {
                            qualityTierValue = parser.getText();
                        }else if (text == 'serviceFirstDateofService') {
                            serviceFirstDateofService = parser.getText();
                        } else if (text == 'serviceLastDateofService') {
                            serviceLastDateofService = parser.getText();
                        } else if (text == 'serviceNetworkIndicator') {
                            serviceNetworkIndicator = new ClaimType(parser);
                        } else if (text == 'serviceLineStatusCode') {
                            serviceLineStatusCode = new AdjudicatedCOBLevel(parser);
                        } else if (text == 'healthCoverageType') {
                            healthCoverageType = new ClaimType(parser);
                        } else if (text == 'unitOfMeasure') {
                            unitOfMeasure = parser.getText();
                        } else if (text == 'pendReasonCode') {
                            pendReasonCode = new List<String>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                pendReasonCode.add(parser.getText());
                            }
                        }  else if (text == 'revenueCode') {
                            revenueCode = new ClaimType(parser);
                        } else if (text == 'serviceUnitCount') {
                            serviceUnitCount = parser.getText();
                        } else if (text == 'placeofServiceCode') {
                            placeofServiceCode = parser.getText();
                        } else if (text == 'overrideIndicator') {
                            overrideIndicator = parser.getText();
                        } else if (text == 'cobMethod') {
                            cobMethod = new AdjudicatedCOBLevel(parser);
                        } else if (text == 'cesMnemonic') {
                            cesMnemonic = new List<CesMnemonic>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                cesMnemonic.add(new CesMnemonic(parser));
                            }
                        } else if (text == 'claimLineAdjudicationDate') {
                            claimLineAdjudicationDate = parser.getText();
                        } else if (text == 'carcAdjustments') {
                            carcAdjustments = new CarcAdjustments_Z(parser);
                        } else if (text == 'authorizationNumber') {
                            authorizationNumber = parser.getText();
                        } else if (text == 'benefitClaimAccumulator') {
                            benefitClaimAccumulator = new List<BenefitClaimAccumulator>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                benefitClaimAccumulator.add(new BenefitClaimAccumulator(parser));
                            }
                        } else if (text == 'benefitPlan') {
                            benefitPlan = new BenefitPlan(parser);
                        } else if (text == 'procedureCode') {
                            procedureCode = new ProcedureCode(parser);
                        } else if (text == 'diagnosisCodePointer') {
                            diagnosisCodePointer = new List<String>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                diagnosisCodePointer.add(parser.getText());
                            }
                        } else if (text == 'serviceLineUHCAmounts') {
                            serviceLineUHCAmounts = new ServiceLineUHCAmounts(parser);
                        } else if (text == 'serviceLineOtherPayer') {
                            serviceLineOtherPayer = new List<ServiceLineOtherPayer>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                serviceLineOtherPayer.add(new ServiceLineOtherPayer(parser));
                            }
                        } else if (text == 'provider') {
                            provider = new List<Provider_Z>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                provider.add(new Provider_Z(parser));
                            }
                        } else if (text == 'serviceRemarks') {
                            serviceRemarks = new List<ClaimRemarks>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                serviceRemarks.add(new ClaimRemarks(parser));
                            }
                        } else if (text == 'serviceNotes') {
                            serviceNotes = new List<ClaimNotes>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                serviceNotes.add(new ClaimNotes(parser));
                            }
                        }else if (text == 'alphaParentLineNum') {
                            alphaParentLineNum = new List<String>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                alphaParentLineNum.add(parser.getText());
                            }
                        }else if (text == 'referralNumber') {
                            referralNumber = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'ServiceLine consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class ServiceLineOtherPayer {
        public String paidAmount {get;set;} 

        public ServiceLineOtherPayer(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'paidAmount') {
                            paidAmount = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'ServiceLineOtherPayer consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class BenefitClaimAccumulator {
        public String benefitPlanId {get;set;}
        public String benefitBundleOptionId {get;set;} 
        public AdjudicatedCOBLevel benefitCode {get;set;} 
        public ClaimAccumulator claimAccumulator {get;set;} 
        
        public BenefitClaimAccumulator(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'benefitPlanId') {
                            benefitPlanId = parser.getText();
                        } else if (text == 'benefitBundleOptionId') {
                            benefitBundleOptionId = parser.getText();
                        } else if (text == 'benefitCode') {
                            benefitCode = new AdjudicatedCOBLevel(parser);
                        } else if (text == 'claimAccumulator') {
                            claimAccumulator = new ClaimAccumulator(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'BenefitClaimAccumulator consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class BenefitPlan {
        public String benefitPlanID {get;set;} 
        public String benefitBundleOptionID {get;set;} 
        public AdjudicatedCOBLevel benefitCode {get;set;} 
        public String planCoinsurancePercent {get;set;} 
        public String memberCoinsurancePercent {get;set;} 

        public BenefitPlan(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'benefitPlanID') {
                            benefitPlanID = parser.getText();
                        } else if (text == 'benefitBundleOptionID') {
                            benefitBundleOptionID = parser.getText();
                        } else if (text == 'benefitCode') {
                            benefitCode = new AdjudicatedCOBLevel(parser);
                        } else if (text == 'planCoinsurancePercent') {
                            planCoinsurancePercent = parser.getText();
                        } else if (text == 'memberCoinsurancePercent') {
                            memberCoinsurancePercent = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'BenefitPlan consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Provider_Z {
        public String providerType {get;set;} 
        public Name_Z name {get;set;} 
        public String organizationName {get;set;} 

        public Provider_Z(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'providerType') {
                            providerType = parser.getText();
                        } else if (text == 'name') {
                            name = new Name_Z(parser);
                        } else if (text == 'organizationName') {
                            organizationName = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Provider_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Name_Z {
        public String firstName {get;set;} 
        public String middleName {get;set;} 
        public String lastName {get;set;} 

        public Name_Z(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'firstName') {
                            firstName = parser.getText();
                        } else if (text == 'middleName') {
                            middleName = parser.getText();
                        } else if (text == 'lastName') {
                            lastName = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Name_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class BenefitClaimAccumulator_Z {
        public String benefitPlanId {get;set;} 
        public String benefitBundleOptionId {get;set;} 
        public AdjudicatedCOBLevel benefitCode {get;set;} 
        public ClaimAccumulator claimAccumulator {get;set;} 

        public BenefitClaimAccumulator_Z(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'benefitPlanId') {
                            benefitPlanId = parser.getText();
                        } else if (text == 'benefitBundleOptionId') {
                            benefitBundleOptionId = parser.getText();
                        } else if (text == 'benefitCode') {
                            benefitCode = new AdjudicatedCOBLevel(parser);
                        } else if (text == 'claimAccumulator') {
                            claimAccumulator = new ClaimAccumulator(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'BenefitClaimAccumulator_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class CarcAdjustments {
        public List<Adjustments> adjustments {get;set;} 
        public String adjustmentTotal {get;set;} 

        public CarcAdjustments(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'adjustments') {
                            adjustments = new List<Adjustments>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                adjustments.add(new Adjustments(parser));
                            }
                        } else if (text == 'adjustmentTotal') {
                            adjustmentTotal = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'CarcAdjustments consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Name_Y {
        public String firstName {get;set;} 
        public String middleName {get;set;} 

        public Name_Y(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'firstName') {
                            firstName = parser.getText();
                        } else if (text == 'middleName') {
                            middleName = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Name_Y consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class ServiceLineUHCAmounts {
        public String serviceBilledChargeAmount {get;set;} 
        public String serviceDeductibleAmount {get;set;} 
        public String servicePaidAmount {get;set;} 
        public String serviceCopayAmount {get;set;} 
        public String serviceNotCoveredAmount {get;set;} 
        public String servicePatientResponsibilityAmount {get;set;} 
        public String serviceReimbursementReductionAmount {get;set;} 
        public String serviceAllowedAmount {get;set;} 
        public String serviceCoinsuranceAmount {get;set;} 
        public String serviceUHCProvWriteOffAmount {get;set;} 
        public String servicePenaltyAmount {get;set;} 

        public ServiceLineUHCAmounts(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'serviceBilledChargeAmount') {
                            serviceBilledChargeAmount = parser.getText();
                        } else if (text == 'serviceDeductibleAmount') {
                            serviceDeductibleAmount = parser.getText();
                        } else if (text == 'servicePaidAmount') {
                            servicePaidAmount = parser.getText();
                        } else if (text == 'serviceCopayAmount') {
                            serviceCopayAmount = parser.getText();
                        } else if (text == 'serviceNotCoveredAmount') {
                            serviceNotCoveredAmount = parser.getText();
                        } else if (text == 'servicePatientResponsibilityAmount') {
                            servicePatientResponsibilityAmount = parser.getText();
                        } else if (text == 'serviceReimbursementReductionAmount') {
                            serviceReimbursementReductionAmount = parser.getText();
                        } else if (text == 'serviceAllowedAmount') {
                            serviceAllowedAmount = parser.getText();
                        } else if (text == 'serviceCoinsuranceAmount') {
                            serviceCoinsuranceAmount = parser.getText();
                        } else if (text == 'serviceUHCProvWriteOffAmount') {
                            serviceUHCProvWriteOffAmount = parser.getText();
                        } else if (text == 'servicePenaltyAmount') {
                            servicePenaltyAmount = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'ServiceLineUHCAmounts consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class AdjudicatedCOBLevel {
        public String code {get;set;} 
        public String description {get;set;} 
        public AdjudicatedCOBLevel(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'code') {
                            code = parser.getText();
                        } else if (text == 'description') {
                            description = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'AdjudicatedCOBLevel consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class DiagnosisCode {
        public String sequenceNumber {get;set;} 
        public AdjudicatedCOBLevel code {get;set;} 
        public String claimPresentOnAdmissionsIndicator {get;set;}
        public String levelType {get;set;} 

        public DiagnosisCode(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'sequenceNumber') {
                            sequenceNumber = parser.getText();
                        } else if (text == 'claimPresentOnAdmissionsIndicator') {
                            claimPresentOnAdmissionsIndicator = parser.getText();
                        } else if (text == 'code') {
                            code = new AdjudicatedCOBLevel(parser);
                        } else if (text == 'levelType') {
                            levelType = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'DiagnosisCode consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Patient {
        public Name name {get;set;} 
        public List<Identifiers> identifiers {get;set;} 
        public String birthDate {get;set;} 

        public Patient(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'name') {
                            name = new Name(parser);
                        } else if (text == 'identifiers') {
                            identifiers = new List<Identifiers>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                identifiers.add(new Identifiers(parser));
                            }
                        } else if (text == 'birthDate') {
                            birthDate = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Patient consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class OtherInsuranceSubscriberName {
        public String firstName {get;set;} 
        public String middleName {get;set;} 
        public String lastName {get;set;} 
        public String suffix {get;set;} 

        public OtherInsuranceSubscriberName(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'firstName') {
                            firstName = parser.getText();
                        } else if (text == 'middleName') {
                            middleName = parser.getText();
                        } else if (text == 'lastName') {
                            lastName = parser.getText();
                        } else if (text == 'suffix') {
                            suffix = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'OtherInsuranceSubscriberName consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class ClaimUHCTotals {
        public String claimTotalBilledChargeAmount {get;set;} 
        public String claimTotalDeductibleAmount {get;set;} 
        public String claimTotalInterestAmount {get;set;} 
        public String claimTotalPaidAmount {get;set;} 
        public String totalCopayAmount {get;set;} 
        public String totalNotCoveredAmount {get;set;} 
        public String totalPatientResponsibilityAmount {get;set;} 
        public String claimTotalUHCProvWriteOffAmount {get;set;} 
        public String claimTotalReimbursementReductionAmount {get;set;} 
        public String claimTotalPenaltyAmount {get;set;} 
        public String claimTotalStateSurchargeAmount {get;set;} 
        public String claimTotalAllowedAmount {get;set;} 
        public String claimTotalCoinsuranceAmount {get;set;} 

        public String claimTotalMemberReimbursementReductionAmount {get;set;} 
        public String claimTotalProviderReimbursementReductionAmount {get;set;} 
        public String claimTotalMemberPenaltyAmount {get;set;}
        public String claimTotaProviderPenaltyAmount {get;set;}
        public ClaimUHCTotals(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'claimTotalBilledChargeAmount') {
                            claimTotalBilledChargeAmount = parser.getText();
                        } else if (text == 'claimTotalDeductibleAmount') {
                            claimTotalDeductibleAmount = parser.getText();
                        } else if (text == 'claimTotalInterestAmount') {
                            claimTotalInterestAmount = parser.getText();
                        } else if (text == 'claimTotalPaidAmount') {
                            claimTotalPaidAmount = parser.getText();
                        } else if (text == 'totalCopayAmount') {
                            totalCopayAmount = parser.getText();
                        } else if (text == 'totalNotCoveredAmount') {
                            totalNotCoveredAmount = parser.getText();
                        } else if (text == 'totalPatientResponsibilityAmount') {
                            totalPatientResponsibilityAmount = parser.getText();
                        } else if (text == 'claimTotalUHCProvWriteOffAmount') {
                            claimTotalUHCProvWriteOffAmount = parser.getText();
                        } else if (text == 'claimTotalReimbursementReductionAmount') {
                            claimTotalReimbursementReductionAmount = parser.getText();
                        } else if (text == 'claimTotalPenaltyAmount') {
                            claimTotalPenaltyAmount = parser.getText();
                        } else if (text == 'claimTotalStateSurchargeAmount') {
                            claimTotalStateSurchargeAmount = parser.getText();
                        } else if (text == 'claimTotalAllowedAmount') {
                            claimTotalAllowedAmount = parser.getText();
                        } else if (text == 'claimTotalCoinsuranceAmount') {
                            claimTotalCoinsuranceAmount = parser.getText();
                         } else if (text == 'claimTotalMemberReimbursementReductionAmount') {
                            claimTotalMemberReimbursementReductionAmount = parser.getText();
                        } else if (text == 'claimTotalProviderReimbursementReductionAmount') {
                            claimTotalProviderReimbursementReductionAmount = parser.getText();
                        } else if (text == 'claimTotalMemberPenaltyAmount') {
                            claimTotalMemberPenaltyAmount = parser.getText();
                        } else if (text == 'claimTotaProviderPenaltyAmount') {
                            claimTotaProviderPenaltyAmount = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'ClaimUHCTotals consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Provider {
        public String providerType {get;set;} 
        public String providerID {get;set;} 
        public String providerTIN {get;set;} 
        public String providerTINTypeCode {get;set;} 
        public String providerNPI {get;set;} 
        public Name_Z name {get;set;} 
        public Address address {get;set;} 

        public Provider(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'providerType') {
                            providerType = parser.getText();
                        } else if (text == 'providerID') {
                            providerID = parser.getText();
                        } else if (text == 'providerTIN') {
                            providerTIN = parser.getText();
                        } else if (text == 'providerTINTypeCode') {
                            providerTINTypeCode = parser.getText();
                        } else if (text == 'providerNPI') {
                            providerNPI = parser.getText();
                        } else if (text == 'name') {
                            name = new Name_Z(parser);
                        } else if (text == 'address') {
                            address = new Address(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Provider consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Identifiers_Z {
        public String type_Z {get;set;} // in json: type
        public String id {get;set;} 
        public String sourceSystemCode {get;set;} 

        public Identifiers_Z(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'type') {
                            type_Z = parser.getText();
                        } else if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'sourceSystemCode') {
                            sourceSystemCode = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Identifiers_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class ClaimRemarks {
        public AdjudicatedCOBLevel remarkCode {get;set;} 
        public AdjudicatedCOBLevel rarcCode {get;set;} 
        
        public String remarkCodeRecipientType {get;set;} 
        public String remarkCodeMemberProviderDesc {get;set;} 
        public String remarkCodeMemberDesc {get;set;} 
        public String remarkCodeProviderDesc {get;set;}
        
        public ClaimRemarks(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'remarkCode') {
                            remarkCode = new AdjudicatedCOBLevel(parser);
                        } else if (text == 'rarcCode') {
                            rarcCode = new AdjudicatedCOBLevel(parser);
                        } else if (text == 'remarkCodeRecipientType') {
                            remarkCodeRecipientType = parser.getText();
                        } else if (text == 'remarkCodeMemberProviderDesc') {
                            remarkCodeMemberProviderDesc = parser.getText();
                        } else if (text == 'remarkCodeMemberDesc') {
                            remarkCodeMemberDesc = parser.getText();
                        } else if (text == 'remarkCodeProviderDesc') {
                            remarkCodeProviderDesc = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'ClaimRemarks consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Adjustments_Z {
        public AdjudicatedCOBLevel code {get;set;} 
        public String amount {get;set;} 
        public String quantity {get;set;} 

        public Adjustments_Z(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'code') {
                            code = new AdjudicatedCOBLevel(parser);
                        } else if (text == 'amount') {
                            amount = parser.getText();
                        } else if (text == 'quantity') {
                            quantity = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Adjustments_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class DocumentKeys {
        public List<DocReferenceValues> docReferenceValues {get;set;} 

        public DocumentKeys(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'docReferenceValues') {
                            docReferenceValues = new List<DocReferenceValues>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                docReferenceValues.add(new DocReferenceValues(parser));
                            }
                        } else {
                            System.debug(LoggingLevel.WARN, 'DocumentKeys consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Identifiers {
        public String type_Z {get;set;} // in json: type
        public String id {get;set;} 
        public String sourceSystemCode {get;set;} 

        public Identifiers(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'type') {
                            type_Z = parser.getText();
                        } else if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'sourceSystemCode') {
                            sourceSystemCode = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Identifiers consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class OtherInsuranceSubscriberID {
        public String type_Z {get;set;} // in json: type
        public String id {get;set;} 

        public OtherInsuranceSubscriberID(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'type') {
                            type_Z = parser.getText();
                        } else if (text == 'id') {
                            id = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'OtherInsuranceSubscriberID consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    public static AcetGetProfessionalJSON2Apex parse(String json) {
        return new AcetGetProfessionalJSON2Apex(System.JSON.createParser(json));
    }
}