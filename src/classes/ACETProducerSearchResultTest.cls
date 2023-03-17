@isTest
public class ACETProducerSearchResultTest{
 
 
 static testmethod void testdata(){
    Test.startTest();
    ACETProducerSearchResult objAcetProviderResult = new ACETProducerSearchResult();
    objAcetProviderResult.CompanyName  = 'TCS';
    ACETProducerSearchResult.SortBy = 'CompanyName';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 
 static testmethod void testdata1(){
    Test.startTest();
    ACETProducerSearchResult objAcetProviderResult = new ACETProducerSearchResult();
    objAcetProviderResult.LastName = 'TCS';
    ACETProducerSearchResult.SortBy = 'LastName';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 
 static testmethod void testdata2(){
    Test.startTest();
    ACETProducerSearchResult objAcetProviderResult = new ACETProducerSearchResult();
    objAcetProviderResult.FirstName = 'TCS';
    ACETProducerSearchResult.SortBy = 'FirstName';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 
 static testmethod void testdat3(){
    Test.startTest();
    ACETProducerSearchResult objAcetProviderResult = new ACETProducerSearchResult();
    objAcetProviderResult.MiddleInitial = 'TCS';
    ACETProducerSearchResult.SortBy = 'MiddleInitial';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 
 static testmethod void testdat4(){
    Test.startTest();
    ACETProducerSearchResult objAcetProviderResult = new ACETProducerSearchResult();
    objAcetProviderResult.ProducerID = '123456';
    ACETProducerSearchResult.SortBy = 'ProducerID';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 
 static testmethod void testdat5(){
    Test.startTest();
    ACETProducerSearchResult objAcetProviderResult = new ACETProducerSearchResult();
    objAcetProviderResult.ProducerTIN = '123456';
    ACETProducerSearchResult.SortBy = 'ProducerTIN';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 
 static testmethod void testdat6(){
    Test.startTest();
    ACETProducerSearchResult objAcetProviderResult = new ACETProducerSearchResult();
   // objAcetProviderResult.ProducerType = '123456';
    ACETProducerSearchResult.SortBy = 'ProducerType';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 
 static testmethod void testdat7(){
    Test.startTest();
    ACETProducerSearchResult objAcetProviderResult = new ACETProducerSearchResult();
    objAcetProviderResult.State = '123456';
    ACETProducerSearchResult.SortBy = 'State';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 
 static testmethod void testdat8(){
    Test.startTest();
    ACETProducerSearchResult objAcetProviderResult = new ACETProducerSearchResult();
    objAcetProviderResult.State = '123456';
    ACETProducerSearchResult.SortBy = 'State';
    ACETProducerSearchResult.SortOrder  = 'Desc';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
  
 static testmethod void testdat9(){
    Test.startTest();
    ACETProducerSearchResult objAcetProviderResult = new ACETProducerSearchResult();
    objAcetProviderResult.ProducerType = 'I';
    objAcetProviderResult.producerMemberGrpStartDate = '01/01/2018';
    objAcetProviderResult.producerMemberGrpEndDate = '01/01/2019';
    objAcetProviderResult.producerContact = '';
    objAcetProviderResult.producerState = 'MN';
    objAcetProviderResult.producerCity = 'Test';
    objAcetProviderResult.producerEffectiveAsOfDate = '01/01/2018';
    objAcetProviderResult.producerSSN = '123456789';
    objAcetProviderResult.producerPhoneNumber = '1234567890';
    
    Test.stopTest();
 }
 
}