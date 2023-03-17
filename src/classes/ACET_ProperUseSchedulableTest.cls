@IsTest
public with sharing class ACET_ProperUseSchedulableTest {

    @testSetup static void setup() {

        ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        //webConfig.Name = 'dev_SAE_ProperUseAPI';
        webConfig.Name = 'dev_properUseAPI';
        //webConfig.Value__c = 'https://gateway-core.optum.com/api/cdm/dg/properuses/v2.0/proper-uses?group-name=ACET_DRTS_NONPRD';
        webConfig.Value__c = 'https://gateway-stage.optum.com/api/dev/cdm/dg/jwt-properuses/v2.0/proper-uses?group-name=PAT_DABA';
        INSERT webConfig;
    
    }

    static testMethod void callProperUseWSTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.SAEProperUseWSMock());
        // ACET_ProperUseWebService.callProperUseService();
        new ACET_ProperUseSchedulable().execute(null);
        ACET_ProperUseDTO dt = new ACET_ProperUseDTO();
        
        
        
        Test.stopTest();
    }
    
    static testMethod void callProperUseDTO() {
        Test.startTest();

        ACET_ProperUseDTO DTO = new ACET_ProperUseDTO();
        DTO.properUse = null;

        ACET_ProperUseDTO.cls_DataUseObligations cls_DataUseObligations = new  ACET_ProperUseDTO.cls_DataUseObligations();
        cls_DataUseObligations.Level0 = '0';
        cls_DataUseObligations.Level1 = '1';
        cls_DataUseObligations.Level2 = '2';
        cls_DataUseObligations.Level3 = '3';
        cls_DataUseObligations.Level4 = '4';
        cls_DataUseObligations.Level5 = '5';
        cls_DataUseObligations.Level6 = '6';
        cls_DataUseObligations.Level7 = '7';

        ACET_ProperUseDTO.cls_AdditionalInformation cls_AdditionalInformation = new ACET_ProperUseDTO.cls_AdditionalInformation();
        cls_AdditionalInformation.CustomerName = 'Test';

        ACET_ProperUseDTO.cls_RecordIdentifiers cls_RecordIdentifiers = new ACET_ProperUseDTO.cls_RecordIdentifiers();
        cls_RecordIdentifiers.cMDM_EID = '12345';
        cls_RecordIdentifiers.PolicyNumbers = new List<String>{'a', 'b', 'c'};
        cls_RecordIdentifiers.GroupNumbers = new List<String>{'a', 'b', 'c'};
        cls_RecordIdentifiers.DivisionNumbers = new List<String>{'a', 'b', 'c'};

        ACET_ProperUseDTO.obligationRecords obligationRecords = new ACET_ProperUseDTO.obligationRecords();
        obligationRecords.ObligationID = '12345';
        obligationRecords.DataUseObligations = cls_DataUseObligations;
        obligationRecords.AdditionalInformation = cls_AdditionalInformation;
        obligationRecords.RecordIdentifiers = cls_RecordIdentifiers;

        ACET_ProperUseDTO.controlGroup controlGroup = new ACET_ProperUseDTO.controlGroup();
        controlGroup.GroupName = null;
        controlGroup.ControlLevel = null;
        controlGroup.Volume = null;
        controlGroup.AttachedDatasets = null;
        controlGroup.Business = null;
        controlGroup.AllowedUses = null;
        controlGroup.AllowedJustifications = null;

        ACET_ProperUseDTO.cls_Volume cls_Volume = new ACET_ProperUseDTO.cls_Volume();
        cls_Volume.ID = '1';
        cls_Volume.Name = '2';
        cls_Volume.Description = '3';
        cls_Volume.PublishedOn = '4';

        ACET_ProperUseDTO.cls_AttachedDatasets cls_AttachedDatasets = new ACET_ProperUseDTO.cls_AttachedDatasets();
        cls_AttachedDatasets.ID = '1';
        cls_AttachedDatasets.Name = '2';
        cls_AttachedDatasets.Description = '3';
        cls_AttachedDatasets.DataClassification = '4';
        cls_AttachedDatasets.PublishedOn = '5';

        ACET_ProperUseDTO.cls_Markets cls_Markets = new ACET_ProperUseDTO.cls_Markets();
        cls_Markets.MarketID = null;
        cls_Markets.MarketName = null;
        cls_Markets.MappedGLCode = null;
        cls_Markets.BusinessSegments = null;

        ACET_ProperUseDTO.cls_BusinessSegments cls_BusinessSegments = new ACET_ProperUseDTO.cls_BusinessSegments();
        cls_BusinessSegments.BusinessSegmentID = 1;
        cls_BusinessSegments.BusinessSegmentName = 'a';
        cls_BusinessSegments.MappedGLCode = 'b';

        ACET_ProperUseDTO.cls_AllowedUses cls_AllowedUses = new ACET_ProperUseDTO.cls_AllowedUses();
        cls_AllowedUses.DataUseID = 1;
        cls_AllowedUses.DataUseName = 'a';

        ACET_ProperUseDTO.cls_AllowedJustifications cls_AllowedJustifications = new ACET_ProperUseDTO.cls_AllowedJustifications();
        cls_AllowedJustifications.JustificationID = 1;
        cls_AllowedJustifications.JustificationName = 'a';

        ACET_ProperUseDTO.cls_Business cls_Business = new ACET_ProperUseDTO.cls_Business();
        cls_Business.Markets = null;

        ACET_ProperUseDTO.properUse properUse = new ACET_ProperUseDTO.properUse();
        properUse.definedObligations = null;
        properUse.controlGroup = null;

        ACET_ProperUseDTO.definedObligations definedObligations = new ACET_ProperUseDTO.definedObligations();
        definedObligations.ObligationSource = null;
        definedObligations.ObligationRecords = null;

        Test.stopTest();

    }



}