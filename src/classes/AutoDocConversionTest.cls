@isTest
public class AutoDocConversionTest {
	static testMethod void testConversion(){
        Case cs = new Case( Status='New', subject='subject', description='Test description',AutoDoc__c = '<body></body>');
        insert cs;
        Test.startTest(); 
        database.executeBatch(new AutoDocConversion());
        Test.stopTest();
    }
}