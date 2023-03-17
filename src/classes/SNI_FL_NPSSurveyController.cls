public without sharing class SNI_FL_NPSSurveyController {
    
    @auraEnabled
    Public Static Accountwrapper getUserDetail(){
        Accountwrapper wrap =new Accountwrapper();
        boolean ErrorOccuredValue = false;
        try{
            list<user> lstUser = [select id, contact.accountid from user where id =:UserInfo.getUserId()];     
            id personAccountId = lstUser[0].contact!=null?lstUser[0].contact.accountId:'';
            
            
            if(String.isnotblank(personAccountId)){
                list<Account> lstAcc = [select id,FamilyLink_Registration_Date__c,name,Assigned_Advisor__c from account where id =: personAccountId];
                if(lstAcc !=null && lstAcc.size()>0){
                    wrap.FamilyLink_Registration_Date=lstAcc[0].FamilyLink_Registration_Date__c;
                    String memberName = lstAcc[0].name;
                    String agentName = lstAcc[0].Assigned_Advisor__c;
                    Datetime twoWeeksDateObj = DateTime.Now().AddDays(-14);
                    
                    if(lstAcc[0].FamilyLink_Registration_Date__c <= twoWeeksDateObj){
                       list<NPS_Data__c> lstnps = [select id,Member_Name__c,Agent_Name__c from NPS_Data__c where Member_Name__c =:memberName and Agent_Name__c=:agentName  limit 1];    
                    
                       if(!lstnps.isEmpty()){
                           wrap.NPSrecordId = lstnps[0].id;
                       }else{
                           NPS_Data__c npsdata = new NPS_Data__c(
                              Member_Name__c= memberName,
                              Agent_Name__c= agentName
                           );
                
                           insert npsdata;
                           wrap.NPSrecordId = npsdata.id;
                       }
                     
                    }
            
                }
            }
        }
        catch(Exception e){
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_NPSSurveyController',e); 
            ErrorOccuredValue = true;
        }
        wrap.ErrorOccured = ErrorOccuredValue;
        return wrap;
    }
    
        public class Accountwrapper {
        @AuraEnabled public Date FamilyLink_Registration_Date;
        @AuraEnabled public boolean ErrorOccured;
        @AuraEnabled public String NPSrecordId;
    }
}