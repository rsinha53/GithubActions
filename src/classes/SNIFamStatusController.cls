public without sharing class  SNIFamStatusController {
    @AuraEnabled
    public static boolean getRestrictionData(Id accId){
        //system.debug('getRestrictionData ------1----'+accId);
        string uId = userInfo.getUserId();
        list<user> lstUser = [select UHG_Access__c,Agent_Type__c from user where id =: uId];
        if(lstUser != null && ! lstUser.isEMpty()){
           
            string uAccess = lstUser[0].UHG_Access__c;
            string uAgtType = lstUser[0].Agent_Type__c;
            list<Family_Overview__c> lFamOv = [select Onshore_Restriction__c,UHG_Restriction__c from Family_Overview__c where Account__c =: accId];
            if(lFamOv != null && ! lFamOv.isEmpty()){
              
                if(  (lFamOv[0].Onshore_Restriction__c == 'No' && lFamOv[0].UHG_Restriction__c == 'No' && uAccess == 'Yes' && uAgtType == 'Onshore') || 
                     (lFamOv[0].Onshore_Restriction__c == 'No' && lFamOv[0].UHG_Restriction__c == 'No' && uAccess == 'No' && uAgtType == 'Onshore') || 
                     (lFamOv[0].Onshore_Restriction__c == 'No' && lFamOv[0].UHG_Restriction__c == 'No' && uAccess == 'Yes' && uAgtType == 'Offshore') || 
                     (lFamOv[0].Onshore_Restriction__c == 'No' && lFamOv[0].UHG_Restriction__c == 'Yes' && uAccess == 'Yes' && uAgtType == 'Onshore') || 
                     (lFamOv[0].Onshore_Restriction__c == 'No' && lFamOv[0].UHG_Restriction__c == 'Yes' && uAccess == 'Yes' && uAgtType == 'Offshore') || 
                     (lFamOv[0].Onshore_Restriction__c == 'Yes' && lFamOv[0].UHG_Restriction__c == 'No' && uAccess == 'Yes' && uAgtType == 'Onshore') || 
                     (lFamOv[0].Onshore_Restriction__c == 'Yes' && lFamOv[0].UHG_Restriction__c == 'No' && uAccess == 'No' && uAgtType == 'Onshore') || 
                     (lFamOv[0].Onshore_Restriction__c == 'Yes' && lFamOv[0].UHG_Restriction__c == 'Yes' && uAccess == 'Yes' && uAgtType == 'Onshore')
                  )
                { 
                           return true;            
                }       
            }
            
         }  
        return false;
    }
    @AuraEnabled
     public static boolean getAtccountDtl(Id accId){
     // query current user information  
      system.debug('accId='+accId); 
      Account acc = [select id,Family_Story__c FROM Account Where id =: accId];
      if(String.isNotblank(acc.Family_Story__c)){
            return true; 
      }
      return false;
    }
    @AuraEnabled
     public static boolean getAccountProgramAssociation(Id accId){
     // query current user information  
      Account acc = [select id,Program_Associations_RichText__c FROM Account Where id =: accId];
      if(String.isNotblank(acc.Program_Associations_RichText__c )){
            return true; 
      }
      return false;
    }
    
     @AuraEnabled
     public static string getAccountFamilyOverview(Id accId){
         //system.debug('getAccountFamilyOverview----------******');
         string famOvrVwId = '';
        // string appName=getAppName();
        // system.debug('getAccountFamilyOverview---appName-------'+appName);
         //if(appName == 'Service Console'){
             list<account> acc = [select id,Name,Policy_ID__c FROM Account Where id =: accId];
             if(acc != null && ! acc.isempty()){
                 Boolean isUhhgPolicy = ACETUtility.checkUHGPolicy(acc[0].Policy_ID__c);  
                 Boolean isUserUhgAcc = ACETUtility.checkUserUhgAccess();
                // Boolean isUsrProfUhgAcc = ACETUtility.checkUserUhgAccessProfile();
                Boolean isSNIRole = isSNIRole();
                system.debug('isUhhgPolicy-----'+isUhhgPolicy);
                 system.debug('isUserUhgAcc-----'+isUserUhgAcc);
                // system.debug('isUsrProfUhgAcc-----'+isUsrProfUhgAcc);
                  system.debug('isSNIRole-----'+isSNIRole);
				  boolean profCheck = profileCheck();
                 system.debug('profCheck-----'+profCheck);
                 //if( (! isUhhgPolicy && isUsrProfUhgAcc ) || (isUhhgPolicy && isUserUhgAcc && isUsrProfUhgAcc)){
                 if( (! isUhhgPolicy && isSNIRole && profCheck) || (isUhhgPolicy && isUserUhgAcc && isSNIRole && profCheck)){
                         list<Family_Overview__c> lstFamOvrVw = new list<Family_Overview__c>();
                         lstFamOvrVw = [select id,Designation__c,Family_Needs__c,First_Family_Contact_Into_Center__c,Account__r.ownerId from Family_Overview__c where account__c =: accId order by lastmodifieddate desc limit 1];
                         system.debug('lstFamOvrVw------'+lstFamOvrVw.size());
                         if(lstFamOvrVw.isEmpty() ){
                             
                             Family_Overview__c famover = new Family_Overview__c(); // added by Ravi
                             famover.Name = acc[0].Name+' Family Overview';
                             famover.Account__c = acc[0].id;
                             famover.Exception__c = 'No';
                             famover.Designation_Changed_Date__c = Date.today();
                             famover.Last_Active_Date__c  = Date.today();
                             if(isUhhgPolicy){
                                 famover.UHG_Restriction__c	 = 'Yes';
                             }
                             else{
                                 famover.UHG_Restriction__c	 = 'No';
                             }
                             insert famover;
                             famOvrVwId =  famover.id;
                         }else if(lstFamOvrVw[0].Designation__c == null || lstFamOvrVw[0].Family_Needs__c == null || lstFamOvrVw[0].First_Family_Contact_Into_Center__c == null){
                             famOvrVwId = lstFamOvrVw[0].id;
                         }
                         
                 }
                 
             }
         //}
         return famOvrVwId;
     }
   public static Boolean profileCheck() {
      Id profileId=userinfo.getProfileId();
      String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
       system.debug('profileName---'+profileName);
       if( profileName == 'System Administrator' || profileName == 'Center for Health Navigation'){
           return true;
       }
       else{
           return false;
       }
   }
   public static Boolean isSNIRole() {
       system.debug('isSNIRole--------------------');
       Id userId = userinfo.getUserId();
       Boolean isSNI = false;
       User userDetails =[SELECT UserRole.Name FROM User where Id=:userId ];
       if(userDetails != null){
           string loginRole = userDetails.UserRole.Name.trim();
           ACETSNIRoles__mdt[] sniRoles = [SELECT MasterLabel FROM ACETSNIRoles__mdt];
           system.debug('current user role is--------'+userDetails.UserRole.Name);
           for (ACETSNIRoles__mdt curRole : sniRoles) {
               system.debug('sni roles--------'+curRole.MasterLabel);
             //  if(curRole.MasterLabel == userDetails.UserRole.Name){
               if( curRole.MasterLabel.trim().equals(loginRole)){
                   system.debug('role matched with configuaration---');
                   isSNI =  true;
               }
           } 
       }
       system.debug('isSNIRole------------isSNI--------'+isSNI);
       return isSNI;
      // return true;
   }
   /*
    @AuraEnabled
    public static String getAppName() {
        Boolean isCommunity=isCommunity();
        System.debug('isCommunity='+isCommunity);
        if(!isCommunity){//If community-skip this
         list<UserAppInfo> userAppInfo = [SELECT Id, AppDefinitionId FROM UserAppInfo WHERE UserId = :UserInfo.getUserId() LIMIT 1];
         String appLabel='';
         if(userAppInfo!=null && userAppInfo.size()>0 && userAppInfo[0].AppDefinitionId != null){
           list<AppDefinition> appDefinition = [SELECT DurableId, Label FROM AppDefinition Where DurableId = :userAppInfo[0].AppDefinitionId LIMIT 1];
           if(appDefinition!=null && appDefinition.size()>0)
             appLabel=appDefinition[0].Label;
         }
         system.debug('appDefinition.Label='+appLabel); //Gives last login App name
         return appLabel;
        }
        else
          return 'ITE';
    }
     @AuraEnabled
    public static boolean isCommunity(){
        Id siteId = Site.getSiteId(); // take a look at the apex class Site, you may find more useful method concerning site/community
        system.debug('siteId....'+siteId);
        if (siteId != null) {
            return true;
        }
        return false;
    }
	*/
}