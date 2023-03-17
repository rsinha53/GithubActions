public with sharing class ECMAutoRouteCaseController {

         public Case cas  {get;set;}
         public String topic  {get;set;}
         ApexPages.StandardController controller = null; 
         public boolean isSucess  {get{
                                        if(isSucess == null){
                                                isSucess = false;
                                        }
                                        return isSucess;
                                        }set;}
                                        
        public Boolean isEditable{get;set;}
        public String accessMessage{get;set;}                               
        private string caseOwner;
    private Boolean isLightningVersion;
    private static LightningReturnValue lrv = new LightningReturnValue();
        
                                        
        /*
         Constructor for standard controller
        */                               
        public ECMAutoRouteCaseController(ApexPages.StandardController controller){
                this.controller = controller;
                Id caseId =ApexPages.currentPage().getParameters().get('id');
                if(caseId != null){
                List<Case> cases = ECMCaseRoutingHelper.fetchCase(new List<id>{caseId});
                cas = cases[0];
                caseOwner = cas.ownerId;
                    if(cas != null) {
                        topic = cas.Topic__c;
                        isEditable= validateCasePermission();
                    }      
                }
            isLightningVersion = false;
                
        }
    public ECMAutoRouteCaseController(String caseId){
        if(caseId != null){
            List<Case> cases = ECMCaseRoutingHelper.fetchCase(new List<id>{caseId});
            cas = cases[0];
            caseOwner = cas.ownerId;
            if(cas != null) {
                topic = cas.Topic__c;
                isEditable= validateCasePermission();
            }      
        }
        isLightningVersion = true;
    }
        
        /*
          TO BE USED IN FUTURE - Invoke route case using bulk method 
         */
        public PageReference invokeRoute() {
                            System.debug('Vishal'+isLightningVersion);
            ECMCaseTriggerHandler.createRouteLog = false;
                 PageReference redirectPage = null;
                 String queString= null;
                if(cas != null){
                    list<Case>caseList= new List<Case>();                    
                    Map<id, String> mapOfCaseAndCurrentQueue;
                    Map<Id, User> MapOfCaseIdandOwner;
                    
                    caselist.add(cas);
                    
                    //US2556096: SNI Core Support Request - Comments required before route
                     Id supportCsRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support Request').getRecordTypeId();
                     if(cas.recordtypeId == supportCsRecordTypeID){
                        List<CaseComment> csComment = [select id from casecomment where parentid =: cas.Id];
                        if(csComment.size() == 0){
                            if(!isLightningVersion){
                              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Comments are required before routing a Support Request');
                              ApexPages.addMessage(myMsg); 
                              isSucess = false;
                            }
                            else {
                                lrv.message = 'Comments are required before routing a Support Request';
                                lrv.isSuccess = false;
                            }
                            
                            return redirectPage;
                         }
                        }
                        //code end validation for support request cases to have comments before routing
                    //check if Case is owned by queue or user
                    if(String.ValueOf(cas.OwnerId).startswith('005')){
                        List<User> owners = [Select Department,userRoleId,UserRole.Name,userRole.parentRoleId,Profile.Name from User where id = : cas.OwnerId limit 1 ];
                        if(owners.size()>0){
                            MapOfCaseIdandOwner = new Map<Id, User>();
                            MapOfCaseIdandOwner.put(cas.Id, owners[0]);
                        }
                    }
                    else{
                         mapOfCaseAndCurrentQueue = new Map<id, String>();
                         
                         mapOfCaseAndCurrentQueue.put(cas.Id, cas.owner.name);
                    
                    }
                    //Below for loop will process only one case record. Hence SOQL is allowed inside for loop
                    Savepoint sp = Database.setSavepoint();
                    string assignedQueue;
                    for(Case cs : caselist){
                        
                        if(cs.Priority_routing__c != null && cs.Priority_Routing__c == 'Yes' && string.ValueOf(cs.OwnerId).startswith('005')){
                            Map<id, string> caseNQueue = ECMCaseRoutingHelper.getQueueName(caselist,mapOfCaseAndCurrentQueue,MapOfCaseIdandOwner); 
                            
                            if(caseNQueue != null && caseNQueue.get(cs.id)!= null){
                                queString = caseNQueue.get(cs.id);
                            }
                            if(queString != null){
                                assignedQueue = queString; // To Avoid SOQL query in next macthig logic, if queue not found in next iteration
                               
                                List<Group> groups = [Select Id, Name, DeveloperName, Type from Group where Type = 'Queue' and name  = :queString];
                                system.debug('***groups--'+groups);
                                if(groups.size() >0) {
                                    cs.ownerId = groups[0].id;
                                }
                                mapOfCaseAndCurrentQueue = new Map<id, String>();
                                mapOfCaseAndCurrentQueue.put(cs.Id, queString);
                            }
                            break;
                        }
                    }
                    //Map<id, string> caseNQueue = CaseRoutingHelper.getQueueName(caselist);
                    Map<id, string> caseNQueue = ECMCaseRoutingHelper.getQueueName(caselist,mapOfCaseAndCurrentQueue,MapOfCaseIdandOwner); 
                        system.debug('caseNQueue::'+caseNQueue);
                        if(caseNQueue != null && caseNQueue.get(cas.id)!= null){
                            queString = caseNQueue.get(cas.id);
                        }
                        system.debug('queString :: '+queString);
                        if(queString == null && !isLightningVersion) {
                                cas.addError('Based on the criteria, this case cannot be automatically routed. Verify the routing criteria or route manually using the change owner link.');
                        }
                        else if(queString == null && isLightningVersion ) {
                            if(isLightningVersion){
                                lrv.message = 'Based on the criteria, this case cannot be automatically routed. Verify the routing criteria or route manually using the change owner link.';
                                lrv.isSuccess = false;
                            }
                        	
                        }
                        else {
                            System.debug('@@@assignedQueue--- '+assignedQueue+' @@@queString---'+queString);
                               if(assignedQueue == null || (assignedQueue != null && assignedQueue != queString)){
                                   List<Group> groups = [Select Id, Name, DeveloperName, Type from Group where Type = 'Queue' and name  = :queString];
                                   system.debug('@@@groups---'+groups);
                                   if(groups.size() >0) {
                                       cas.ownerId = groups[0].id;
                                   }                                   
                               }
                        try{
                              if(case.sObjectType.getDescribe().isCreateable()){  //// code added as per checkmarx improvement -- Srinivasa
                                   upsert cas;
                               }
                            if(!isLightningVersion){
                              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Case routed successfully to  ' +queString + '.');
                              ApexPages.addMessage(myMsg);
                              isSucess = true;
                            }
                            else {
                               //Added by Dimpy US2904957: Automatic Routing of Case
                            if(!(queString=='No Route')){
                                lrv.message = 'Case routed successfully to  ' +queString + '.';
                                lrv.isSuccess = true;
                                }else {
                                   lrv.message = 'Case not Routed.Check with your administator';
                                lrv.isSuccess = false; 
                                }
                            }
                       
                        }catch( DMLException dmlex) {
                            Database.rollback(sp);
                            cas.ownerId = caseOwner; // After roll back setting back to original owner  
                            if(isLightningVersion){
                                lrv.message = dmlex.getdmlMessage(0);
                                lrv.isSuccess = false;
                            }
                            else{
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,dmlex.getdmlMessage(0));
                            ApexPages.addMessage(myMsg);
                            }
                        }
                        catch( Exception ex) {
                            if(isLightningVersion){
                                lrv.message = ex.getdmlMessage(0);
                                lrv.isSuccess = false;
                            }
                            else{
                             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,ex.getMessage());
                            ApexPages.addMessage(myMsg);
                            }
                     }
     }
     }
        return redirectPage;
   }
    
    @AuraEnabled
    public static LightningReturnValue invokeRoute(String caseId,String type,String subtype,String priority) {
        ECMAutoRouteCaseController earc = new ECMAutoRouteCaseController(caseId);
        earc.cas.Type__c = type!=''&& type!=null?type : earc.cas.Type__c;
        earc.cas.Subtype__c = subtype!=''&& subtype!=null?subtype :earc.cas.Subtype__c;
        earc.cas.Priority = priority!=''&& priority!=null?priority:earc.cas.Priority;
        System.debug('Type'+earc.cas.Type__c);
        System.debug('SubType'+earc.cas.Subtype__c);
        System.debug('Priority'+earc.cas.Priority);
        lrv = new LightningReturnValue();
        earc.invokeRoute();

    //    ACET_Refresh_Tab__e event = new ACET_Refresh_Tab__e();
    //    Eventbus.publish(event);

        return lrv;
    }
    @AuraEnabled
    public static InitLoadData validateCasePermission(String caseId) {
        ECMAutoRouteCaseController earc = new ECMAutoRouteCaseController(caseId);
        InitLoadData ildObj = new InitLoadData();
        ildObj.isEditable = earc.isEditable;
        ildObj.typeSubTypeDependency = ACETCallTopicsPicklistUtility.getTTSFilter(earc.topic);
        ildObj.caseObj = earc.cas;
        return ildObj;
    }

        ///method to chec if the logged in user has access to modify the case
        public Boolean validateCasePermission(){
           Boolean result = false;
           List<UserRecordAccess > loggedInUserAccessDetails= [SELECT RecordId,HasEditAccess, HasReadAccess, HasTransferAccess, MaxAccessLevel FROM UserRecordAccess WHERE UserId = : Userinfo.getUserId()
            AND RecordId = :cas.id];
            
            
            if(loggedInUserAccessDetails != Null && !loggedInUserAccessDetails.isEmpty()){
                for(UserRecordAccess  accessDetails :loggedInUserAccessDetails){
                     if(accessDetails.HasEditAccess ){
                        result = True;
                        break;
                     }                     
                }                    
            }
            
            return result ;
        
        }
    
        //get limited type and subtype based on profile and role, so these values will be filtered out on route page    
        public String getTTSFilterStr(){
            return ACETCallTopicsPicklistUtility.getTTSFilter(Cas.Topic__c);
        } 
    public class LightningReturnValue{
        @AuraEnabled
        public String message;
        @AuraEnabled
        public Boolean isSuccess;
    }
    public class InitLoadData{
        @AuraEnabled
        public Boolean isEditable;
        @AuraEnabled
        public String typeSubTypeDependency;
        @AuraEnabled
        public Case caseObj;
    }
}