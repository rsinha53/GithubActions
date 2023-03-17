@isTest
public class ValidateDataTest {
    
    
    static testMethod void testgetinputswrapperStr(){
    	test.startTest();
        
        Validation_Rule__c vrule = new Validation_Rule__c();
        vrule.type__C = 'test';
        vrule.Active__c = true;
        vrule.Required_Fields__c = 'test3';
        vrule.Max_Length__c = 9;
        vrule.Min_Length__c = 4;
        vrule.Dependent_Fields__c = 'test5';
        vrule.No_Dependency__c = true; 
        vrule.Parent_Field__c = 'test';
        vrule.Restriction__c = 'Numbers Only';
        vrule.Min_Char_for_wild_card__c = 3;
        vrule.Field_Not_Contains_Value__c = 'test3';
        insert vrule;
        
        Validation_Rule__c vrule1 = new Validation_Rule__c();
        vrule1.Type__c = 'test1';
        vrule1.Active__c = true;
        vrule1.Required_Fields__c = 'test4';
        vrule1.Parent_Field__c = 'test1';
        vrule1.Max_Length__c = 9;
        vrule1.Min_Length__c = 4;
        vrule1.Dependent_Fields__c = 'test6';
        vrule1.No_Dependency__c = true; 
        vrule1.Restriction__c = 'Alphabets Only';
        vrule1.Min_Char_for_wild_card__c = 3;
        vrule1.Field_Not_Contains_Value__c = 'test4';
        insert vrule1;

    	ValidateData.getinputswrapperStr('test;test1');        
        string stringval = 'test;test1';
        ValidateData vd = new ValidateData();
        vd.typeValue = stringval;
    	test.stopTest();
        
    }
    
    static testmethod void testdata(){
        test.startTest();
        
        Validation_Rule__c vrule2 = new Validation_Rule__c();
        vrule2.Type__c = 'taxid';
        vrule2.Active__c = true;
        vrule2.Required_Fields__c = 'taxid';
        vrule2.Parent_Field__c = 'ClaimNumber';
        vrule2.Max_Length__c = 9;
        vrule2.Min_Length__c = 4;
        vrule2.Dependent_Fields__c = 'ClaimNumber';
        vrule2.No_Dependency__c = true; 
        vrule2.Restriction__c = 'Alphabets and Wildcard characters only';
        vrule2.Min_Char_for_wild_card__c = 3;
        vrule2.Field_Not_Contains_Value__c = 'ClaimNumber';
        insert vrule2;
        
        
        ValidateData.getinputswrapperStr('taxid');
        test.stopTest();
    }
    
    static testmethod void testdata1(){
        test.startTest();
        
        Validation_Rule__c vrule3 = new Validation_Rule__c();
        vrule3.Type__c = 'ReferralNumber';
        vrule3.Active__c = true;
        vrule3.Required_Fields__c = 'ReferralNumber';
        vrule3.Parent_Field__c = 'taxid';
        vrule3.Max_Length__c = 9;
        vrule3.Min_Length__c = 4;
        vrule3.Dependent_Fields__c = 'taxid';
        vrule3.No_Dependency__c = true; 
        vrule3.Restriction__c = 'Alphanumeric and Wildcard characters';
        vrule3.Min_Char_for_wild_card__c = 3;
        vrule3.Field_Not_Contains_Value__c = 'taxid';
        insert vrule3;
        
        ValidateData.getinputswrapperStr('ReferralNumber');
        test.stopTest();
    }
    
    static testmethod void testdata2(){
        test.startTest();
        
        Validation_Rule__c vrule4 = new Validation_Rule__c();
        vrule4.Type__c = 'startdate';
        vrule4.Active__c = true;
        vrule4.Required_Fields__c = 'startdate';
        vrule4.Parent_Field__c = 'enddate';
        vrule4.Max_Length__c = null;
        vrule4.Min_Length__c = null;
        vrule4.Dependent_Fields__c = 'endate';
        vrule4.No_Dependency__c = true; 
        vrule4.Restriction__c = 'Date Only';
        vrule4.Min_Char_for_wild_card__c = 3;
        vrule4.Field_Not_Contains_Value__c = 'endate';
        insert vrule4;
        
        ValidateData.getinputswrapperStr('startdate');
        test.stopTest();
    }
    
    static testmethod void testdata3(){
        test.startTest();
        
        Validation_Rule__c vrule4 = new Validation_Rule__c();
        vrule4.Type__c = 'ReferralNumber';
        vrule4.Active__c = true;
        vrule4.Required_Fields__c = 'ReferralNumber';
        vrule4.Parent_Field__c = 'taxid';
        vrule4.Max_Length__c = null;
        vrule4.Min_Length__c = null;
        vrule4.Dependent_Fields__c = 'taxid';
        vrule4.No_Dependency__c = true; 
        vrule4.Min_Char_for_wild_card__c = 3;
        vrule4.Field_Not_Contains_Value__c = 'taxid';
        vrule4.Fields_Contains_Value__c = 'taxid';
        vrule4.Regex_To_Follow__c = 'Name'; 
        insert vrule4;
        
        Validation_Rule__c vrule5 = new Validation_Rule__c();
        vrule5.Type__c = 'ClaimNumber';
        vrule5.Active__c = true;
        vrule5.Required_Fields__c = 'ClaimNumber';
        vrule5.Parent_Field__c = 'CliamNumber';
        vrule5.Max_Length__c = null;
        vrule5.Min_Length__c = null;
        vrule5.Dependent_Fields__c = 'ReferralNumber';
        vrule5.No_Dependency__c = true; 
        vrule5.Min_Char_for_wild_card__c = 3;
        vrule5.Field_Not_Contains_Value__c = 'ReferralNumber';
        vrule5.Fields_Contains_Value__c = 'ReferralNumber';
        vrule4.Regex_To_Follow__c = 'Name1'; 
        insert vrule5;
        
        ValidateData.getinputswrapperStr('ReferralNumber');
        ValidateData.getinputswrapperStr('ClaimNumber');
        test.stopTest();
    }
    
    
    
}