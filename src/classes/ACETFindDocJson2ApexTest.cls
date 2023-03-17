@isTest
private class ACETFindDocJson2ApexTest{
public static testMethod void test1(){
//////////////////////////
ACETFindDocJson2Apex ap=new ACETFindDocJson2Apex();

ACETFindDocJson2Apex.FindDocumentsResponseType type=new ACETFindDocJson2Apex.FindDocumentsResponseType();

ACETFindDocJson2Apex.FindDocumentsResponse find=new ACETFindDocJson2Apex.FindDocumentsResponse();
find = ap.FindDocumentsResponse;

ACETFindDocJson2Apex.DocumentList doc=new ACETFindDocJson2Apex.DocumentList();

ACETFindDocJson2Apex.Pagination pg=new ACETFindDocJson2Apex.Pagination();

ACETFindDocJson2Apex.DocumentKey keys=new ACETFindDocJson2Apex.DocumentKey();

 ACETFindDocJson2Apex.DocumentKeys doc1=new ACETFindDocJson2Apex.DocumentKeys();
 
 ACETFindDocJson2Apex.Document doc2=new  ACETFindDocJson2Apex.Document();  
}
}