public with sharing class ACETEnrollMemberController {

    public String comments { get; set; }
    public String memberID { get; set; }
    public  list<Alert__c> lstProviderAlert { get; set; }
    public Contact Subject { get; set; }
    public Interaction__c Interaction { get; set; }    
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public string redirectUrl {get; set;}
    public boolean isSubscriberEnrolled{get;set;}
    public boolean notResearchUser {get;set;}
    public String AutoDoc {get;set;}
    public String ErrorMessage {get;set;} 
    public List<ACETMemberSearchResult> Results{get;set;}
    public boolean panelType{get; set;}
    public boolean isMemberEnrollment;
    public ACETMemberDetail MemberDetail {get;set;}
    public string swivelcirrus_URL{get;set;}
    public list<Alert__c> lstMemAlert{get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
     public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;}
    
    public boolean isEnrollSubscriber {get; set;}
    public boolean isEnrollMember {get; set;}
    public string groupId;
    public String callTopic {get; set;}
    
    // US585186 
    public List<WrapperEnrollList> enrollList {get;set;}
    public Integer rowToRemove {get;set;}
    public Integer rowNum {get;set;}
    public boolean isClikedAddRow{get;set;}
    
    public ACETEnrollMemberController(){
        String InteractionId = apexpages.currentpage().getparameters().get('InteractionId');
        groupId = apexpages.currentpage().getparameters().get('groupId');
        callTopic = apexpages.currentpage().getparameters().get('callTopic');
        wrapper = new ACETCallTopicsDataWrapper();
        system.debug('Test=='+ apexpages.currentpage().getparameters().get('SRK'));
        String strSurrogateKey = apexpages.currentpage().getparameters().get('SRK');
         wrapper.SurrogateKey = strSurrogateKey;
        if(callTopic == label.ACETCallTopicEnrollSubscriber) {
            isEnrollSubscriber = true;
            isEnrollMember = false;
            wrapper.CaseObj.Topic__c = label.ACETCallTopicEnrollSubscriber;
        }
        else if(callTopic == label.ACETCallTopicEnrollMember) {
            isEnrollMember = true;
            isEnrollSubscriber = false;
            wrapper.CaseObj.Topic__c = label.ACETCallTopicEnrollMember;
        }
        if(groupId != Null)
            wrapper.caseObj.ID__c =groupId;

        wrapper.updategroupinfoSave = true;
        Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
        getNumberOfProviderAlert();
        getloggedinProfileName();
        initHighlightPanelAdditionalInfo();
        
        panelType = false;
        String memId = apexpages.currentpage().getparameters().get('Id');
        if(memId != null)
        {
            panelType = true;                    
        }
        redirectUrl = '/apex/ACETViewEmployerGroup?Originator='+Interaction.Originator__r.Name+'&OriginatorType='+Interaction.Originator_Type__c+'&InteractionId='+InteractionId+'&contactid='+Interaction.Originator__c;
        
        enrollList = new List<WrapperEnrollList>();
        addNewRowToEnrollList();
               
    }
    
    public void removeRowFromEnrollList(){
        rowToRemove = Integer.ValueOf(apexpages.currentpage().getparameters().get('rowToRemove'));
        enrollList.remove(rowToRemove);
    }

    public void addNewRowToEnrollList(){        
        WrapperEnrollList enrollRecord = new WrapperEnrollList();        
        System.debug('@@@@enrollList1::'+enrollList);
        enrollRecord.index = enrollList.size();
        enrollRecord.memberFName = '';
        enrollRecord.memberFName = '';
        enrollRecord.effectiveDate = ''; 
        enrollRecord.memberId = '';
        enrollRecord.isResolved = false;
        enrollList.add(enrollRecord);
        System.debug('@@@@enrollList2::'+enrollList);
            
    }
    
    public class WrapperEnrollList{
        public Integer index {get;set;}
        public String memberFName {get;set;}        
        public String memberLName {get;set;}        
        public String effectiveDate{get;set;}
        public String memberID {get;set;}
        public Boolean isResolved {get;set;}
    } 
    
    private void initHighlightPanelAdditionalInfo(){
        if(wrapper.AdditionalInfo == null){
            wrapper.AdditionalInfo = new ACETHighlightsPanelAdditionalInfo(); 
        }        
        string additionalInfoStr = apexpages.currentpage().getparameters().get('additionalInfo');
        if(additionalInfoStr != Null && additionalInfoStr != '')
        {
            wrapper.AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(additionalInfoStr, ACETHighlightsPanelAdditionalInfo.class); 
        }
        
        /******added by sourabh ****/
        

          
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
    }
    
    public void getNumberOfProviderAlert(){
        ACETInteractionHighlightsPanelController alertNumber = new ACETInteractionHighlightsPanelController();
        if(Interaction != null){
            lstProviderAlert = alertNumber.getNoAlert('Provider',Interaction.Originator__r.EID__c,Interaction.Originator__r.Tax_ID__c, null);
        }
    }
       
    private void getloggedinProfileName(){ 
       try{
            notResearchUser = true;
            List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
            String loggedinProfileName = PROFILE[0].Name;
        
            //Check if the logged-in User has profile 'Research' type
               if(loggedinProfileName.contains('Research'))
                { notResearchUser = false;}
        }catch(exception ex){
            System.debug('The exception is'+ ex.getmessage());
        }
       
    }  
  
}