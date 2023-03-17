@isTest
public class ACET_TOPSEncryptionAlgorithmTest {
    @testSetup static void setup(){
        List<Tops_Encryption_Mappings__c> testTopsMappings = new List<Tops_Encryption_Mappings__c>();
        testTopsMappings.add(new Tops_Encryption_Mappings__c(EBCDIC__c='A',Char_1__c='65',Char_2__c='1B',Char_3__c='08',Char_4__c='35',Char_5__c='08',Char_6__c='53',Char_7__c='46',Char_8__c='1B'));
        testTopsMappings.add(new Tops_Encryption_Mappings__c(EBCDIC__c='B',Char_1__c='24',Char_2__c='1F',Char_3__c='0F',Char_4__c='3D',Char_5__c='2C',Char_6__c='FE',Char_7__c='19',Char_8__c='2B'));
        insert testTopsMappings;
    }
    
    @isTest static void testEncAndDec(){
        Test.startTest();
        String decrStr = ACET_TOPSEncryptionAlgorithm.getDecryptedString(ACET_TOPSEncryptionAlgorithm.getEncryptedString('ABABABAB'));
        System.assertEquals(decrStr,'ABABABAB');
        System.assertEquals(ACET_TOPSEncryptionAlgorithm.getEncryptedString('AB'), null);
        Test.stopTest();
    }
    
    @isTest static void testCreateAppErrorLog_ORS(){
        Test.startTest();
        ACET_ReadConsumerEligibilityService constructorTest = new ACET_ReadConsumerEligibilityService();
        ACET_ReadConsumerEligibilityService.createAppErrorLog_ORS('AppName', 'servName', 'endPoint', 'respStatus', 0, 'reqBody', 'resBody', 'urlParameters');
        Test.stopTest();
    }
}