@isTest
public class ACETProviderSearchResultTest{
    
 static testmethod void testdata(){
    Test.startTest();
    ACETProviderSearchResult objAcetProviderResult = new ACETProviderSearchResult();
    objAcetProviderResult.TaxId  = '1234';
    ACETProviderSearchResult.SortBy = 'TaxID';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 
 static testmethod void testdata1(){
    Test.startTest();
    ACETProviderSearchResult objAcetProviderResult = new ACETProviderSearchResult();
    objAcetProviderResult.NPI = '56456';
    ACETProviderSearchResult.SortBy = 'NPI';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 
 static testmethod void testdata2(){
    Test.startTest();
    ACETProviderSearchResult objAcetProviderResult = new ACETProviderSearchResult();
    objAcetProviderResult.PlatinumProvider = 'testprovider';
    ACETProviderSearchResult.SortBy = 'PlatinumProvider';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 
 static testmethod void testdat3(){
    Test.startTest();
    ACETProviderSearchResult objAcetProviderResult = new ACETProviderSearchResult();
    objAcetProviderResult.GroupName = 'ACETGroup';
    ACETProviderSearchResult.SortBy = 'GroupName';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 
 static testmethod void testdat4(){
    Test.startTest();
    ACETProviderSearchResult objAcetProviderResult = new ACETProviderSearchResult();
    objAcetProviderResult.StreetAddress = 'New york';
    ACETProviderSearchResult.SortBy = 'StreetAddress';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 
 static testmethod void testdat5(){
    Test.startTest();
    ACETProviderSearchResult objAcetProviderResult = new ACETProviderSearchResult();
    objAcetProviderResult.City = 'New Jersy';
    ACETProviderSearchResult.SortBy = 'City';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 
 static testmethod void testdat6(){
    Test.startTest();
    ACETProviderSearchResult objAcetProviderResult = new ACETProviderSearchResult();
    objAcetProviderResult.State = 'South Carlonia';
    ACETProviderSearchResult.SortBy = 'state';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 
 static testmethod void testdat7(){
    Test.startTest();
    ACETProviderSearchResult objAcetProviderResult = new ACETProviderSearchResult();
    objAcetProviderResult.Zip = '123456';
    ACETProviderSearchResult.SortBy = 'Zip';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 
 static testmethod void testdat8(){
    Test.startTest();
    ACETProviderSearchResult objAcetProviderResult = new ACETProviderSearchResult();
    objAcetProviderResult.State = '123456';
    ACETProviderSearchResult.SortBy = 'State';
    ACETProviderSearchResult.SortOrder  = 'Desc';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 
 static testmethod void testdat9(){
    Test.startTest();
    ACETProviderSearchResult objAcetProviderResult = new ACETProviderSearchResult();
    objAcetProviderResult.PhoneNumber = '123456';
    ACETProviderSearchResult.SortBy = 'PhoneNumber';
    ACETProviderSearchResult.SortOrder  = 'Desc';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 
 static testmethod void testdat10(){
    Test.startTest();
    ACETProviderSearchResult objAcetProviderResult = new ACETProviderSearchResult();
    objAcetProviderResult.Facility = '12ertert3456';
    ACETProviderSearchResult.SortBy = 'Facility';
    ACETProviderSearchResult.SortOrder  = 'Desc';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 
 static testmethod void testdat11(){
    Test.startTest();
    ACETProviderSearchResult objAcetProviderResult = new ACETProviderSearchResult();
    objAcetProviderResult.ProviderId = '657576';
    ACETProviderSearchResult.SortBy = 'ProviderId';
    ACETProviderSearchResult.SortOrder  = 'Desc';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 
 static testmethod void testdat12(){
    Test.startTest();
    ACETProviderSearchResult objAcetProviderResult = new ACETProviderSearchResult();
    objAcetProviderResult.AddressId = '1234565435';
    ACETProviderSearchResult.SortBy = 'AddressId';
    ACETProviderSearchResult.SortOrder  = 'Desc';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 

 
 static testmethod void testdat13(){
    Test.startTest();
    ACETProviderSearchResult objAcetProviderResult = new ACETProviderSearchResult();
    objAcetProviderResult.PrimaryAddress = 'United States';
    ACETProviderSearchResult.SortBy = 'PrimaryAddress';
    ACETProviderSearchResult.SortOrder  = 'Desc';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 
 static testmethod void testdat14(){
    Test.startTest();
    ACETProviderSearchResult objAcetProviderResult = new ACETProviderSearchResult();
    objAcetProviderResult.providerTINStatusCode = '123898456';
    ACETProviderSearchResult.SortBy = 'providerTINStatusCode';
    ACETProviderSearchResult.SortOrder  = 'Desc';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 
 static testmethod void testdat15(){
    Test.startTest();
    ACETProviderSearchResult objAcetProviderResult = new ACETProviderSearchResult();
    objAcetProviderResult.ProvideraddressTypeCode = '123456766';
    ACETProviderSearchResult.SortBy = 'ProvideraddressTypeCode';
    ACETProviderSearchResult.SortOrder  = 'Desc';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 
 static testmethod void testdat16(){
    Test.startTest();
    ACETProviderSearchResult objAcetProviderResult = new ACETProviderSearchResult();
    objAcetProviderResult.County = '123456345345';
    ACETProviderSearchResult.SortBy = 'County';
    ACETProviderSearchResult.SortOrder  = 'Desc';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 
 static testmethod void testdat17(){
    Test.startTest();
    ACETProviderSearchResult objAcetProviderResult = new ACETProviderSearchResult();
    objAcetProviderResult.Fax = '987878';
    ACETProviderSearchResult.SortBy = 'Fax';
    ACETProviderSearchResult.SortOrder  = 'Desc';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 
 static testmethod void testdat18(){
    Test.startTest();
    ACETProviderSearchResult objAcetProviderResult = new ACETProviderSearchResult();
    objAcetProviderResult.providerTINOwner = 'vinay';
    ACETProviderSearchResult.SortBy = 'providerTINOwner';
    ACETProviderSearchResult.SortOrder  = 'Desc';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 
  static testmethod void testdat19(){
    Test.startTest();
    ACETProviderSearchResult objAcetProviderResult = new ACETProviderSearchResult();
    objAcetProviderResult.ProviderTypeCode = '12334456';
    ACETProviderSearchResult.SortBy = 'ProviderTypeCode';
    ACETProviderSearchResult.SortOrder  = 'Desc';
    objAcetProviderResult.compareTo((object)objAcetProviderResult);
    Test.stopTest();
 }
 
 
}