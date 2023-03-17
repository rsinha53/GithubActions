public with sharing class ACETClaimHistoryWindowController extends ACETErrorHandler{

    public String ClaimId {get;set;}
    public String ClaimType {get;set;}
    public String ClaimEventId {get;set;}
    public string ClaimeventSequenceNumber {get;set;}
    public string ClaimeventeventType {get;set;}
   // public Contact Subject {get;set;}
   // public ACETCallTopicsDataWrapper wrapper {get;set;}
    public ACETClaimDetail ClaimDetail {get;set;}
    private static ACETWSCalloutResult institutionalResult;
    //Public String CheckImageUrl{get;set;}
   // Public boolean isMemberEOB{get;set;}
   // Public boolean isProviderRA{get;set;}
    //Public boolean isClaimLetter{get;set;}
    //Public boolean isPhysicalhealth{get;set;}
    Public String claimStatus {get; set;}
    Public Integer resultStatusCode{get;set;}

    public ACETClaimHistoryWindowController()
    {
    
        ClaimId = ApexPages.currentPage().getParameters().get('claimId');
        ClaimType = ApexPages.currentPage().getParameters().get('claimType');
        ClaimEventId = ApexPages.currentPage().getParameters().get('eventID');
        ClaimeventSequenceNumber = ApexPages.currentPage().getParameters().get('eventSequenceNumber');
        ClaimeventeventType = ApexPages.currentPage().getParameters().get('eventType');
        
        String ClaimDetailJSON = ApexPages.currentPage().getParameters().get('claimDetailJSON');
        system.debug('ClaimDetailJson>>>'+ClaimDetailJSON);
        if(ClaimDetailJSON!=null){
            //ClaimDetail = (ACETClaimDetail)JSON.deserialize(ClaimDetailJSON, ACETClaimDetail.class);
        }
        else
        {
            ClaimDetail = new ACETClaimDetail();
        }
        claimStatus = 'Claim Finalized - Paid or Denied';      
        if(claimStatus == 'In Process') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'This claim is in process.  Do not communicate claim adjudication details until it is finalized.'));
        }
        
        System.debug('claim status:::'+claimStatus);
    }
    public void addStdErrorMsg() {
        if(resultStatusCode!=null && resultStatusCode !=200 &&(resultStatusCode == 400 || resultStatusCode == 404 || resultStatusCode == 500)) {
            setErrorMsg('GN'+resultStatusCode);
        }
    }

    @RemoteAction
    public static ACETWSCalloutResult queryGetProfessionalClaimHistory(String claimType, String claimId, String claimEventId){       
        ACETProfessionalClaimHistoryWebservice ws = new ACETProfessionalClaimHistoryWebservice();
        return ws.ProfessionalClaimHistoryWS(claimType, claimId, claimEventId);                             
    }    

    @RemoteAction
    public static ACETWSCalloutResult queryGetInstitutionalClaimHistory(String claimType, String claimId, String claimEventId){       
        ACETInstitutionalClaimHistoryWebservice ws = new ACETInstitutionalClaimHistoryWebservice();
        return ws.InstitutionalClaimHistoryWS(claimType, claimId, claimEventId);
    }
    
    @RemoteAction
    public static ACETWSCalloutResult getEncoderProDescription(String data){
        
        Map<String,List<String>> codesMap = (Map<String,List<String>>)JSON.deserialize(data , Map<String,List<String>>.class);
        ACETWSCalloutResult result = new ACETWSCalloutResult();
        Set<String> codeToProcessSet = new Set<String>();//bring it from ui
        List<String> codeToProcessLst = new  List<String>();
        for(String section : codesMap.keySet() ){
            for(String code : codesMap.get(section)){
                codeToProcessSet.add(code);
            }
        }
        codeToProcessLst.addAll(codeToProcessSet);//This will make the list with unique codes
        return queryEncoderProDescription(codeToProcessLst);
    }
   public static ACETWSCalloutResult queryEncoderProDescription(List<String> codeToProcessLst){
        ACETEncoderProWebservice encoderWS = new ACETEncoderProWebservice();
        return encoderWS.getCodeDescriptions(codeToProcessLst);
    }
 

}