public with sharing class ACETViewMemberListingPDFControllerJob{

    public List<ACETViewMemberListingResultsWrapper> searchMemberListingResults {get;set;}
    public List<ACETViewMemberListingResultsWrapper> filteredList{get;set;} 
    public list<ACETViewMemberListingResultsWrapper> finalList{get;set;}   
    //public List<MemberListingWrapper> membListWrap {get; set;}
    public String statusPDF {get; set;}
    public String groupName {get; set;}
    public String groupId {get; set;}
    public String request {get; set;}
    public String bundleID {get; set;}
    public String selectedPopulation{get;set;}
    public Boolean hasPop{get;set;}
    public String dateValues {get; set;}
    public String inquiryDate {get; set;}
    public String renderAs {get; set;}
    public List<SelectOption> options{get;set;}
    public String bundles{get;set;}
    public String allpops{get;set;}
    public List<String> listbundles{get;set;}
    public List<String> listpops{get;set;}
    public Integer startRecord {get; set;}
    public String groupNameId{get;set;}
    public ACETDatatableWrapper DTWrapper {get; set;}
    public ACETWSCalloutResult searchResults {get; set;}
    public String baseURL{get;set;}
    public String contractId{get;set;}
    public String continuationType{get;set;}
    public Integer cobraCount{get;set;}
    public string attachmentidstring{get;set;}
transient  Public List<ACETViewMemberListingResultsWrapper> SearchMemberListingResultsResp1{get;set;}
    public void initaction(){
    
string hasPopstr = apexpages.currentpage().getparameters().get('hasPop');
    system.debug('hasPop==>'+hasPopstr );


groupName= apexpages.currentpage().getparameters().get('groupName');
groupId = apexpages.currentpage().getparameters().get('groupId');
contractId= apexpages.currentpage().getparameters().get('contractId');
request = apexpages.currentpage().getparameters().get('request');
statusPDF = apexpages.currentpage().getparameters().get('statusPDF');
bundleID = apexpages.currentpage().getparameters().get('bundleID');
inquiryDate = apexpages.currentpage().getparameters().get('inquiryDate');
bundleID = apexpages.currentpage().getparameters().get('bundleID');
cobraCount = integer.valueof(apexpages.currentpage().getparameters().get('cobraCount'));
continuationType= apexpages.currentpage().getparameters().get('continuationType');
contractId = apexpages.currentpage().getparameters().get('contractId');
selectedPopulation = apexpages.currentpage().getparameters().get('selectedPopulation');
inquiryDate = apexpages.currentpage().getparameters().get('inquiryDate');
system.debug('hasPopstr ====');

system.debug(hasPopstr );
system.debug(groupName);
system.debug(groupId );
system.debug(contractId);
system.debug(request );
system.debug(statusPDF );
system.debug(bundleID );
system.debug(inquiryDate );
system.debug(bundleID );
system.debug(cobraCount );
system.debug(selectedPopulation );
system.debug(inquiryDate );
if(hasPopstr =='no'){
hasPop = false;

}else{
hasPop = true;

}

            attachmentidstring = apexpages.currentpage().getparameters().get('attachmentid');
 
            if(!String.isEmpty(attachmentidstring )){

           Attachment  att =  [SELECT Id,Body FROM Attachment where id =:attachmentidstring limit 1];
 Blob body = att.Body; 
String content = body.toString(); 
 SearchMemberListingResultsResp1 = (List<ACETViewMemberListingResultsWrapper>)JSON.deserialize(content, List<ACETViewMemberListingResultsWrapper>.class);
          }
    
}
   
   
   
  

  
}