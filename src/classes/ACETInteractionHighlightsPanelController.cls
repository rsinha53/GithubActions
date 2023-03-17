public with sharing class ACETInteractionHighlightsPanelController extends ACETErrorHandler
{
    public Interaction__c Interaction { get; set; }
    public Contact Subject { get; set; }
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo{get;set;}
    public list<Alert__c> lstMemAlert { get; set; } //added by Vishakha on 11/03/2016 for User Story - US:405397,405471
    public list<Alert__c> lstProviderAlert { get; set; }
    public list<Alert__c> lstproducerAlert { get; set; } //added by harish on 3/22/2017 for User story -US554987
    public list<Alert__c> lstMemAlertOtherPage { get; set; }
    public list<Alert__c> lstProviderAlertDetailPage { get; set; }
    public list<Alert__c> lstProducerAlertDetailPage { get; set; }
    public list<Alert__c> lstGroupAlert { get; set; } //added by Krishna on 3/23/2017for User Story - US537355
    public list<Alert__c> lstGroupAlertDetailPage { get; set; } 
    public boolean isALertModal { get; set; } //added by Vishakha on 11/03/2016 for User Story - US:405397,405471
    public boolean isProviderALertModal { get; set; } //added by Vishakha on 11/15/2016 for User Story-US405472
    public boolean isProviderDetailALertModal { get; set; }
    public boolean isProducerALertModal { get; set; } //added by harish on 3/22/2017 for User story -US554987
    public boolean isGroupALertModal { get; set; }
    public Integer HoldRestStatus;
    public Boolean holdCodeAlertHLP{get; set;} 
    public ACETGroupDetail groupDetails { get; set; }
    public String groupName{get;set;}
    public boolean isShowGroupALert { get; set; } 
    public boolean IsMember { get; set; } 
    public integer memberAlertCount { get; set; }
    public integer providerAlertCount { get; set; }
    public integer producerAlertCount { get; set; }
    public integer groupAlertCount { get; set; }
    public boolean isShowALert { get; set; }
    public ACETDynatrace ACETDynatraceDetails { get; set; }
    public string CIRRUSURL{get;set;}
    public string topicName{get;set;}
    public string isViewBilling{get;set;}
    public String sniEligibility{get;set;}
    
    public ACETInteractionHighlightsPanelController()
    {
        system.debug(LoggingLevel.INFO, 'Subject: ' + Subject + ', Interaction: ' + Interaction);
        isShowGroupALert = false;
        isProducerALertModal = false;
        String Membertype = ApexPages.currentPage().getParameters().get('IsMember');
        isViewBilling = ApexPages.currentPage().getParameters().get('isViewBilling');
        sniEligibility = ApexPages.currentPage().getParameters().get('sniEligibility');
        
        IsMember = Membertype == 'true';
        system.debug(LoggingLevel.INFO, 'isALertModal: ' + isALertModal + ', isProviderALertModal: ' + isProviderALertModal + ', lstMemAlertOtherPage: ' + lstMemAlertOtherPage);
        ACETDynatraceDetails = ACETUtility.GetDynatraceJSURL();   
        system.debug('AdditionalInfo :: ' + AdditionalInfo); 
        getAllAlerts();
    }
    
    public void getAllAlerts()
    {
        memberAlertCount = 0;
        providerAlertCount = 0;
        producerAlertCount = 0;
        groupAlertCount = 0;
        User currentUser = [SELECT Profile.Name FROM USER WHERE Id =:UserInfo.getUserId()];
        List<Alert_Business_Segment__mdt> alertBusinessSegment = [
            SELECT 
            Business_Segment__c 
            FROM Alert_Business_Segment__mdt 
            WHERE MasterLabel =:currentUser.Profile.Name
        ];
        string type = 'Member';
        String query = '';
        List<List <sObject>> searchList = new List<List<SObject>>();
        List<Alert__c> tempListAlert = new List<Alert__c>();
        if(AdditionalInfo != null){
          if(AdditionalInfo.AllGroupBenefitBundleOptionId != null && AdditionalInfo.AllGroupBenefitBundleOptionId != ''){
            if(AdditionalInfo.AllGroupBenefitBundleOptionId.contains(',')){
              List<String> bundleList = AdditionalInfo.AllGroupBenefitBundleOptionId.split(', ');
              for(Integer i = 0; i < bundleList.size(); i++){
                query = 'FIND  \'' + bundleList[i] + '\' IN ALL Fields Returning Alert__c';
                  query += ' (Id,SharePoint_ID__c,Type__c,Group_Number__c,ID_Number__c,Benefit_Bundle_Option_ID__c,Alert_Title__c,Effective_Date__c,Alert_Comments__c,End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c >= TODAY '+(alertBusinessSegment!=null && alertBusinessSegment.size()>0?'AND Business_Segment__c=\''+alertBusinessSegment[0].Business_Segment__c+'\'':'')+' ORDER BY Type__c,Effective_Date__c DESC)';
                  searchList = search.query(query);
                  tempListAlert.addAll(((List<Alert__c>)searchList[0]));
              }
            } else {
              query = 'FIND  \'' + AdditionalInfo.AllGroupBenefitBundleOptionId + '\' IN ALL Fields Returning Alert__c';
                query += ' (Id,SharePoint_ID__c,Type__c,Group_Number__c,ID_Number__c,Benefit_Bundle_Option_ID__c,Alert_Title__c,Effective_Date__c,Alert_Comments__c,End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c >= TODAY '+(alertBusinessSegment!=null && alertBusinessSegment.size()>0?'AND Business_Segment__c=\''+alertBusinessSegment[0].Business_Segment__c+'\'':'')+' ORDER BY Type__c,Effective_Date__c DESC)';
                searchList = search.query(query);
                tempListAlert.addAll(((List<Alert__c>)searchList[0]));
            }
          } else if(AdditionalInfo.BenefitBundleOptionId != null && AdditionalInfo.BenefitBundleOptionId != '') {
            
            query = 'FIND  \'' + AdditionalInfo.BenefitBundleOptionId + '\' IN ALL Fields Returning Alert__c';
              query += ' (Id,SharePoint_ID__c,Type__c,Group_Number__c,ID_Number__c,Benefit_Bundle_Option_ID__c,Alert_Title__c,Effective_Date__c,Alert_Comments__c,End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c >= TODAY '+(alertBusinessSegment!=null && alertBusinessSegment.size()>0?'AND Business_Segment__c=\''+alertBusinessSegment[0].Business_Segment__c+'\'':'')+' ORDER BY Type__c,Effective_Date__c DESC)';
              searchList = search.query(query);
              tempListAlert.addAll(((List<Alert__c>)searchList[0]));
          }
        }
        if (AdditionalInfo != Null && AdditionalInfo.MemberId != Null && lstMemAlertOtherPage == null && AdditionalInfo.MemberId != '')
        {           
            query = 'FIND  \'' + AdditionalInfo.MemberId + '\' IN ALL Fields Returning Alert__c';
            query += ' (Id, SharePoint_ID__c, Type__c, Group_Number__c, ID_Number__c, Benefit_Bundle_Option_ID__c, Alert_Title__c, Effective_Date__c, Alert_Comments__c, End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c >= TODAY '+(alertBusinessSegment!=null && alertBusinessSegment.size()>0?'AND Business_Segment__c=\''+alertBusinessSegment[0].Business_Segment__c+'\'':'')+' ORDER BY Type__c,Effective_Date__c DESC)';
            searchList = search.query(query);
            tempListAlert.addAll(((List<Alert__c>)searchList[0]));
            if(AdditionalInfo.GroupNumber != null && AdditionalInfo.GroupNumber != ''){
              query = 'FIND  \'' + AdditionalInfo.GroupNumber + '\' IN ALL Fields Returning Alert__c';
              query += ' (Id, SharePoint_ID__c, Type__c, Group_Number__c, ID_Number__c, Benefit_Bundle_Option_ID__c, Alert_Title__c, Effective_Date__c, Alert_Comments__c, End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c >= TODAY '+(alertBusinessSegment!=null && alertBusinessSegment.size()>0?'AND Business_Segment__c=\''+alertBusinessSegment[0].Business_Segment__c+'\'':'')+' ORDER BY Type__c,Effective_Date__c DESC)';
              searchList = search.query(query);
              tempListAlert.addAll(((List<Alert__c>)searchList[0]));
            }
            memberAlertCount = tempListAlert.size();
        }
        ////For Provider Alert
        if(Interaction != null && Interaction.Originator_Type__c == 'Provider' && lstProviderAlertDetailPage == null){
            tempListAlert.clear();
            searchList = new List<List<SObject>>();
            type = Interaction.Originator_Type__c;
            query = 'FIND  \'' + Interaction.Originator__r.EID__c + '\' IN ALL Fields Returning Alert__c';
            query += ' (Id, SharePoint_ID__c, Type__c, Group_Number__c, ID_Number__c, Benefit_Bundle_Option_ID__c, Alert_Title__c, Effective_Date__c, Alert_Comments__c, End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c >= TODAY '+(alertBusinessSegment!=null && alertBusinessSegment.size()>0?'AND Business_Segment__c=\''+alertBusinessSegment[0].Business_Segment__c+'\'':'')+' AND Type__c = \''+ Interaction.Originator_Type__c +'\' ORDER BY Type__c,Effective_Date__c DESC)';
            searchList = search.query(query);
            system.debug(LoggingLevel.INFO, 'searchList1: ' + searchList);
            tempListAlert.addAll(((List<Alert__c>)searchList[0]));
            
            if(subject != null && AdditionalInfo != null && AdditionalInfo.MemberId != null ){
                type += ' Group';
                query = 'FIND  \'' + Interaction.Originator__r.EID__c + '\' IN ALL Fields Returning Alert__c';
                query += ' (Id, SharePoint_ID__c, Type__c, Group_Number__c, ID_Number__c, Benefit_Bundle_Option_ID__c, Alert_Title__c, Effective_Date__c, Alert_Comments__c, End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c >= TODAY '+(alertBusinessSegment!=null && alertBusinessSegment.size()>0?'AND Business_Segment__c=\''+alertBusinessSegment[0].Business_Segment__c+'\'':'')+' AND Type__c = \''+ type +'\' ORDER BY Type__c,Effective_Date__c DESC)';
                searchList = search.query(query);
                system.debug(LoggingLevel.INFO, 'searchList2: ' + searchList);
                tempListAlert.addAll(((List<Alert__c>)searchList[0]));
            }
            providerAlertCount = tempListAlert.size();
        } 
        ///For Producer Alerts
        system.debug(LoggingLevel.INFO, 'lstproducerDetailPage: '+lstProducerAlertDetailPage);
        if(Interaction != null && Interaction.Originator_Type__c == 'Producer' && lstProducerAlertDetailPage == null){
           tempListAlert.clear();
            searchList = new List<List<SObject>>();
            query = 'FIND  \'' + Interaction.Originator__r.EID__c + '\' IN ALL Fields Returning Alert__c';
            query += ' (Id, SharePoint_ID__c, Type__c, Group_Number__c, ID_Number__c, Benefit_Bundle_Option_ID__c, Alert_Title__c, Effective_Date__c, Alert_Comments__c, End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c >= TODAY '+(alertBusinessSegment!=null && alertBusinessSegment.size()>0?'AND Business_Segment__c=\''+alertBusinessSegment[0].Business_Segment__c+'\'':'')+' AND Type__c = \''+ Interaction.Originator_Type__c +'\' ORDER BY Type__c,Effective_Date__c DESC)';
            searchList = search.query(query);
            system.debug(LoggingLevel.INFO, 'searchList3: ' + searchList);
            tempListAlert.addAll(((List<Alert__c>)searchList[0]));
            if(tempListAlert.size() > 0)         
            producerAlertCount = tempListAlert.size();          
        }
        ///For group alerts
        system.debug(LoggingLevel.INFO, 'AdditionalInfo: ' + AdditionalInfo);
        system.debug(LoggingLevel.INFO, 'lstGroupAlertDetailPage: ' + lstGroupAlertDetailPage);
        if(AdditionalInfo != null && AdditionalInfo.GroupN!=null && lstGroupAlertDetailPage == null && AdditionalInfo.GroupN!='' ){
            tempListAlert.clear();
            searchList = new List<List<SObject>>();
            string groupId=getGroupId(AdditionalInfo.GroupN);
            query = 'FIND  \'' + groupId + '\' IN ALL Fields Returning Alert__c';
            query += ' (Id, SharePoint_ID__c, Type__c, Group_Number__c, ID_Number__c, Benefit_Bundle_Option_ID__c, Alert_Title__c, Effective_Date__c, Alert_Comments__c, End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c >= TODAY '+(alertBusinessSegment!=null && alertBusinessSegment.size()>0?'AND Business_Segment__c=\''+alertBusinessSegment[0].Business_Segment__c+'\'':'')+' ORDER BY Type__c,Effective_Date__c DESC)';
            searchList = search.query(query);
            system.debug(LoggingLevel.INFO, 'searchList4: ' + searchList);
            tempListAlert.addAll(((List<Alert__c>)searchList[0]));
            groupAlertCount = tempListAlert.size();             
        }
    }
    
   /****added by Vishakha on 11/03/2016 for User Story - US:405397,405471***/
    public Void getMemberAlert(){
        system.debug(LoggingLevel.INFO, 'inside the MemberAlert'+ Subject + AdditionalInfo);
       if((Interaction != null && Interaction.Originator_Type__c == 'Member') || (subject != null && AdditionalInfo != null)){
           lstMemAlert = getNoAlert('Member',Subject.Eid__c,AdditionalInfo.PolicyNumber,null);
           system.debug(LoggingLevel.INFO, 'lstMemAlert: ' + lstMemAlert );
           
       }
   }
   
   public Void getProviderAlert(){
       system.debug(LoggingLevel.INFO, 'inside the Provider alert window');
       if(Interaction != null && Interaction.Originator_Type__c == 'Provider'){
           lstProviderAlert = getNoAlert(Interaction.Originator_Type__c,Interaction.Originator__r.EID__c,Interaction.Originator__r.Tax_ID__c,null);
           if(subject != null && AdditionalInfo != null){
               getMemberAlert();
           }
       }  
    }
    /****added by Harish on 03/22/2017 for User Story - US:US554987***/
    public void getProducerAlert(){
         system.debug(LoggingLevel.INFO, 'producer window');
         if(Interaction != null && Interaction.Originator_Type__c == 'Producer'){
          lstproducerAlert = getNoAlert(Interaction.Originator_Type__c,Interaction.Originator__r.EID__c,Interaction.Originator__r.Tax_ID__c,null);
          system.debug(LoggingLevel.INFO, 'lstproducerAlert: '+ lstproducerAlert);
         }
    }
    
     public void clickProducerAlert(){
         system.debug('inside clickProducerAlert');
       if(Interaction.Originator_Type__c == 'Producer'){
           isProducerALertModal = True;
           isShowALert = false;
          lstproducerAlert = getNoAlert(Interaction.Originator_Type__c,Interaction.Originator__r.EID__c,Interaction.Originator__r.Tax_ID__c,null);
          system.debug(LoggingLevel.INFO, 'lstproducerAlert: '+ lstproducerAlert);
       } 
    }
    /****added by Krishna on 03/23/2017 for User Story - US537355 ***/
    public void getGroupAlert(){
           if(AdditionalInfo != null && AdditionalInfo.GroupN!=null){
            string groupId=getGroupId(AdditionalInfo.GroupN);
            lstGroupAlert = getNoAlert(null,null,groupId,null);
               system.debug(LoggingLevel.INFO, 'lstGroupAlert: '+ lstGroupAlert );
           }  
                   
       }
       
     public void clickGroupAlert(){
         
         if(AdditionalInfo != null && AdditionalInfo.GroupN!=null){
            string groupId=getGroupId(AdditionalInfo.GroupN);
            lstGroupAlert = getNoAlert(null,null,groupId,AdditionalInfo.AllGroupBenefitBundleOptionId);
            isGroupALertModal=true;
            isShowALert = false;
               //system.debug(LoggingLevel.INFO, 'lstGroupAlert: ' + lstGroupAlert+isshowGroupALert);
           }   
         }
      /***********************
        Method Name :   get group Id from Group Name
        Purpose     :   To get the group id.
        Develper    :    Krishna
    ************************/
     public string getGroupId(String GroupName){
          String groupId;
             if(GroupName!=null){
               String Name=GroupName;
               String[] finalName= GroupName.split('\\-'); 
               groupId=finalName[0];
             }        
             return groupId;
     }
   
     /***********************
        Method Name :   getNoAlert
        Purpose     :   This method calls when the agent click on the Member Link.
        Develper    :    Vishakha Sikarwar
    ************************/
    public void clickMemberAlert(){
       if((Interaction.Originator_Type__c == 'Member') || (subject != null && AdditionalInfo != null && AdditionalInfo.MemberId != null)){
           isALertModal = True;
           isShowALert = false;
           //lstMemAlert = getNoAlert('Member',AdditionalInfo.MemberId,AdditionalInfo.PolicyNumber,AdditionalInfo.BenefitBundleOptionId);
           lstMemAlert = getNoAlert('Member',AdditionalInfo.MemberId,AdditionalInfo.GroupNumber,AdditionalInfo.BenefitBundleOptionId);
           
       } 
    }
     /***********************
        Method Name :   getNoAlert
        Purpose     :   This method calls when the agent click on the Provider Link.
        Develper    :    Vishakha Sikarwar
    ************************/
    public void clickProviderAlert(){
        system.debug(LoggingLevel.INFO, 'insert the check function' + Interaction.Originator_Type__c);
       if(Interaction.Originator_Type__c == 'Provider'){
           isShowALert = false;
           lstProviderAlert = getNoAlert(Interaction.Originator_Type__c,Interaction.Originator__r.EID__c,Interaction.Originator__r.Tax_ID__c,null);
           isProviderALertModal= True;
       } 
    }
     /***********************
        Method Name :   getNoAlert
        Purpose     :   This method get all the alert realated to the Member or Provider.
        Develper    :    Vishakha Sikarwar
    ************************/
    public List<Alert__c> getNoAlert(String type, String memProId, String groupNo, String bundleOptionId){
        String groupType = type + ' Group';
        List<Alert__c> tempListAlert = new List<Alert__c>();
        
        User currentUser = [SELECT Profile.Name FROM USER WHERE Id =:UserInfo.getUserId()];
        List<Alert_Business_Segment__mdt> alertBusinessSegment = [
            SELECT 
            Business_Segment__c 
            FROM Alert_Business_Segment__mdt 
            WHERE MasterLabel =:currentUser.Profile.Name
        ];
        //@Rama: SOQL replaced with SOSL to make the group Number and group ID fields compatable for shield encryption
        String query = '';
        List<List <sObject>> searchList = new List<List<SObject>>();
        if(String.isBlank(groupNo) && String.isBlank(memProId)){
            return tempListAlert;
        }
        if(bundleOptionId != null && bundleOptionId != ''){
          if(bundleOptionId.contains(',')){
            List<String> bundleList = bundleOptionId.split(', ');
            for(Integer i = 0; i < bundleList.size(); i++){
              query = 'FIND  \'' + bundleList[i] + '\' IN ALL Fields Returning Alert__c';
                query += ' (Id,SharePoint_ID__c,Type__c,Group_Number__c,ID_Number__c,Benefit_Bundle_Option_ID__c,Alert_Title__c,Effective_Date__c,Alert_Comments__c,End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c >= TODAY '+(alertBusinessSegment!=null && alertBusinessSegment.size()>0?'AND Business_Segment__c=\''+alertBusinessSegment[0].Business_Segment__c+'\'':'')+' ORDER BY Type__c,Effective_Date__c DESC)';
                searchList = search.query(query);
                tempListAlert.addAll(((List<Alert__c>)searchList[0]));
            }
          } else {
            query = 'FIND  \'' + bundleOptionId + '\' IN ALL Fields Returning Alert__c';
              query += ' (Id,SharePoint_ID__c,Type__c,Group_Number__c,ID_Number__c,Benefit_Bundle_Option_ID__c,Alert_Title__c,Effective_Date__c,Alert_Comments__c,End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c >= TODAY '+(alertBusinessSegment!=null && alertBusinessSegment.size()>0?'AND Business_Segment__c=\''+alertBusinessSegment[0].Business_Segment__c+'\'':'')+' ORDER BY Type__c,Effective_Date__c DESC)';
              searchList = search.query(query);
              tempListAlert.addAll(((List<Alert__c>)searchList[0]));
          }
        }
        if(String.isNotBlank(memProId) && memProId.length() > 1){
            if(type=='Member'){
                query = 'FIND  \'' + memProId + '\' IN ALL Fields Returning Alert__c';
                query += ' (Id,SharePoint_ID__c,Type__c,Group_Number__c,ID_Number__c,Benefit_Bundle_Option_ID__c,Alert_Title__c,Effective_Date__c,Alert_Comments__c,End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c >= TODAY '+(alertBusinessSegment!=null && alertBusinessSegment.size()>0?'AND Business_Segment__c=\''+alertBusinessSegment[0].Business_Segment__c+'\'':'')+' ORDER BY Type__c,Effective_Date__c DESC)';
                //searchList = search.query(query);
                //tempListAlert.addAll(((List<Alert__c>)searchList[0]));
            }
            else{
                query = 'FIND  \'' + memProId + '\' IN ALL Fields Returning Alert__c';
                query += ' (Id,SharePoint_ID__c,Type__c,Group_Number__c,ID_Number__c,Benefit_Bundle_Option_ID__c,Alert_Title__c,Effective_Date__c,Alert_Comments__c,End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c >= TODAY '+(alertBusinessSegment!=null && alertBusinessSegment.size()>0?'AND Business_Segment__c=\''+alertBusinessSegment[0].Business_Segment__c+'\'':'')+' AND Type__c = \''+ type +'\'  ORDER BY Type__c,Effective_Date__c DESC)';
                //searchList = search.query(query);
                //tempListAlert.addAll(((List<Alert__c>)searchList[0]));
                
            }
            searchList = search.query(query);
            tempListAlert.addAll(((List<Alert__c>)searchList[0]));
        }
        if(String.isNotBlank(groupNo) && groupNo.length() > 1){
              /**** IF condition is added by Krishna on 03/27/2017 for User Story - US537355 ***/
            if(type==null){  
              query = 'FIND  \'' + groupNo + '\' IN ALL Fields Returning Alert__c';
              query += ' (Id,SharePoint_ID__c,Type__c,Group_Number__c,ID_Number__c,Benefit_Bundle_Option_ID__c,Alert_Title__c,Effective_Date__c,Alert_Comments__c,End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c >= TODAY '+(alertBusinessSegment!=null && alertBusinessSegment.size()>0?'AND Business_Segment__c=\''+alertBusinessSegment[0].Business_Segment__c+'\'':'')+' ORDER BY Type__c,Effective_Date__c DESC)';
              searchList = search.query(query);
              tempListAlert.addAll(((List<Alert__c>)searchList[0]));
            }else{
                if(type == 'Member'){
                    type += ' Group';
                    query = 'FIND  \'' + groupNo + '\' IN ALL Fields Returning Alert__c';
                    query += ' (Id,SharePoint_ID__c,Type__c,Group_Number__c,ID_Number__c,Benefit_Bundle_Option_ID__c,Alert_Title__c,Effective_Date__c,Alert_Comments__c,End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c >= TODAY '+(alertBusinessSegment!=null && alertBusinessSegment.size()>0?'AND Business_Segment__c=\''+alertBusinessSegment[0].Business_Segment__c+'\'':'')+' AND Type__c = \''+ type +'\' ORDER BY Type__c,Effective_Date__c DESC)';
                    searchList = search.query(query);
                    tempListAlert.addAll(((List<Alert__c>)searchList[0]));
                }
            }

        }
        return tempListAlert;  
    }
    public List<Alert__c> getNoAlert(String type, String memProId, String groupNo){
        String groupType = type + ' Group';
        List<Alert__c> tempListAlert = new List<Alert__c>();
        //@Rama: SOQL replaced with SOSL to make the group Number and group ID fields compatable for shield encryption
        String query = '';
        List<List <sObject>> searchList = new List<List<SObject>>();
        if(String.isBlank(groupNo) && String.isBlank(memProId)){
            return tempListAlert;
        }
        User currentUser = [SELECT Profile.Name FROM USER WHERE Id =:UserInfo.getUserId()];
        List<Alert_Business_Segment__mdt> alertBusinessSegment = [
            SELECT 
            Business_Segment__c 
            FROM Alert_Business_Segment__mdt 
            WHERE MasterLabel =:currentUser.Profile.Name
        ];
        if(String.isNotBlank(memProId) && memProId.length() > 1){
            if(type=='Member'){
                query = 'FIND  \'' + memProId + '\' IN ALL Fields Returning Alert__c';
                query += ' (Id,SharePoint_ID__c,Type__c,Group_Number__c,ID_Number__c,Benefit_Bundle_Option_ID__c,Alert_Title__c,Effective_Date__c,Alert_Comments__c,End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c >= TODAY '+(alertBusinessSegment!=null && alertBusinessSegment.size()>0?'AND Business_Segment__c=\''+alertBusinessSegment[0].Business_Segment__c+'\'':'')+' ORDER BY Type__c,Effective_Date__c DESC)';
                //searchList = search.query(query);
                //tempListAlert.addAll(((List<Alert__c>)searchList[0]));
            }
            else{
                query = 'FIND  \'' + memProId + '\' IN ALL Fields Returning Alert__c';
                query += ' (Id,SharePoint_ID__c,Type__c,Group_Number__c,ID_Number__c,Benefit_Bundle_Option_ID__c,Alert_Title__c,Effective_Date__c,Alert_Comments__c,End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c >= TODAY '+(alertBusinessSegment!=null && alertBusinessSegment.size()>0?'AND Business_Segment__c=\''+alertBusinessSegment[0].Business_Segment__c+'\'':'')+' AND Type__c = \''+ type +'\'  ORDER BY Type__c,Effective_Date__c DESC)';
                //searchList = search.query(query);
                //tempListAlert.addAll(((List<Alert__c>)searchList[0]));
                
            }
            searchList = search.query(query);
            tempListAlert.addAll(((List<Alert__c>)searchList[0]));
        }
        if(String.isNotBlank(groupNo) && groupNo.length() > 1){
              /**** IF condition is added by Krishna on 03/27/2017 for User Story - US537355 ***/
            if(type==null){  
              query = 'FIND  \'' + groupNo + '\' IN ALL Fields Returning Alert__c';
              query += ' (Id,SharePoint_ID__c,Type__c,Group_Number__c,ID_Number__c,Benefit_Bundle_Option_ID__c,Alert_Title__c,Effective_Date__c,Alert_Comments__c,End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c >= TODAY '+(alertBusinessSegment!=null && alertBusinessSegment.size()>0?'AND Business_Segment__c=\''+alertBusinessSegment[0].Business_Segment__c+'\'':'')+' ORDER BY Type__c,Effective_Date__c DESC)';
              searchList = search.query(query);
              tempListAlert.addAll(((List<Alert__c>)searchList[0]));
            }else{
                if(type == 'Member'){
                    type += ' Group';
                    query = 'FIND  \'' + groupNo + '\' IN ALL Fields Returning Alert__c';
                    query += ' (Id,SharePoint_ID__c,Type__c,Group_Number__c,ID_Number__c,Benefit_Bundle_Option_ID__c,Alert_Title__c,Effective_Date__c,Alert_Comments__c,End_Date__c WHERE Effective_Date__c <= TODAY AND End_Date__c >= TODAY '+(alertBusinessSegment!=null && alertBusinessSegment.size()>0?'AND Business_Segment__c=\''+alertBusinessSegment[0].Business_Segment__c+'\'':'')+' AND Type__c = \''+ type +'\' ORDER BY Type__c,Effective_Date__c DESC)';
                    searchList = search.query(query);
                    tempListAlert.addAll(((List<Alert__c>)searchList[0]));
                }
            }

        }
        return tempListAlert;  
    }
    /***********************
        Method Name :   btnHideWindowAlertWinodw
        Purpose     :   This method hide the Modal box
        Develper    :    Vishakha Sikarwar
    ************************/
    public void btnHideWindowAlertWinodw(){
        isALertModal = false;
        isProviderALertModal = false;
        isGroupALertModal=false;
        isProducerALertModal = false;
                
        if(lstMemAlertOtherPage != null){
            lstMemAlertOtherPage.clear();
        }
        if(lstProviderAlertDetailPage != null){
            lstProviderAlertDetailPage.clear();
        }
        if(lstGroupAlertDetailPage!= null){
            lstGroupAlertDetailPage.clear();
        }
        if(lstProducerAlertDetailPage != null){
            lstProducerAlertDetailPage.clear();
        }
        system.debug(LoggingLevel.INFO, 'isProviderALertModal: ' + isProviderALertModal + ', isGroupALertModal: ' + isGroupALertModal);
    }
    
    public void fetchCirrusSSOURL(){
            String MemberId = ApexPages.currentPage().getParameters().get('memId');
            String GroupId = ApexPages.currentPage().getParameters().get('grpId');
            String SubjType = ApexPages.currentPage().getParameters().get('subjType');
            system.debug('>>>>fetch'+MemberId+'SUbjType'+SubjType+'topic' +topicName+'groupId'+GroupId );
            String landingPage = 'memberDetail';
            
            // Parameters(MemberId, LandingPage, Subject Type, Topic,GroupId)
            CIRRUSURL = ACETCirrusLandingPageCtrl.GenerateCIRRUSURL(MemberId,landingPage,SubjType,topicName,GroupId);
    }
    
    public void showHoldCodeHLP(){
        callHoldRestrictions();
        holdCodeAlertHLP = true;
    }   
    public void hideHoldCodeHLP(){
      holdCodeAlertHLP = false;
    }
    public void callHoldRestrictions(){
        try{
            ACETHoldRestrictionsWebservice holdRestWS = new ACETHoldRestrictionsWebservice();
            ACETWSCalloutResult WSResponse = holdRestWS.holdRestriction(AdditionalInfo.MemberId, AdditionalInfo.GroupNumber, '', 'All', 'All');
            if(!WSResponse.success){
              if(WSResponse.statusCode!=null){
               HoldRestStatus = WSResponse.statusCode;
               }
            }
            ACETMemberDetail tempMem = (ACETMemberDetail)WSResponse.response;
            if(tempMem!=null){
              List<ACETHighlightsPanelAdditionalInfo.holdCodeInfo> holdsList = new List<ACETHighlightsPanelAdditionalInfo.holdCodeInfo>();  
              for(ACETMemberDetail.holdCodeInfo holds: tempMem.holdCodeList) {
                ACETHighlightsPanelAdditionalInfo.holdCodeInfo hold = new ACETHighlightsPanelAdditionalInfo.holdCodeInfo();
                hold.holdCode = holds.holdCode;
                hold.holdDescription = holds.holdDescription;
                hold.effectiveDate = holds.effectiveDate;
                hold.expirationDate = holds.expirationDate;
                hold.holdNote = holds.holdNote;
                hold.holdRestriction = holds.holdRestriction;
                hold.holdLevel = holds.holdLevel;
                holdsList.add(hold);
              }
              AdditionalInfo.holdCodeList = holdsList;
              System.debug('MemberDetail.holdCodeList:   ' + tempMem.holdCodeList);
              System.debug('AdditionalInfo.holdCodeList: ' + AdditionalInfo.holdCodeList);

//             AdditionalInfo.holdCodeList = (List<ACETHighlightsPanelAdditionalInfo.holdCodeInfo>)tempMem.holdCodeList;
            }
        }catch(Exception e){
             system.debug(LoggingLevel.INFO, e.getMessage() +' :: '+e.getStackTraceString());
             setErrorMsg('MGD997',e);
        }
    }
    public void showHoldErrorMsgsHLP(){
         system.debug('----HoldRestStatus----------'+HoldRestStatus);
          if(HoldRestStatus!=null){
            if(HoldRestStatus==400){
               setErrorMsg('GN'+'400B');
               HoldRestStatus=null;
            }else{
               setErrorMsg('GN'+HoldRestStatus);
               HoldRestStatus=null;
             }
          }   
      }
}