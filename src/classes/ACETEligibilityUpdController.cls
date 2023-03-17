/* Class Name:ACETEligibilityUpdController
 * Author:Chandan
 * Created Date: 11/05/2020
 * Description: Logic to call Create/Update Eligibity Hub API
**/
public class ACETEligibilityUpdController {
    
    public class SearchResultWrapper{
        @AuraEnabled public ACETWSCalloutResult resultWrapper {get;set;} 
        @AuraEnabled public string message {get;set;}
        @AuraEnabled public integer statusCode {get;set;}
        @AuraEnabled public boolean elligHubCheck {get;set;}
    }
      
    @AuraEnabled
    public static SearchResultWrapper updateEHub(ID recordId,String objectType){
      System.debug('calling update ehub method'+recordId+'object name-'+objectType);
      SearchResultWrapper returnData = new SearchResultWrapper();
      returnData.elligHubCheck=false;
      system.debug('***objectType***'+objectType);
      Switch on objectType {
        When 'Family_Overview__c'
        {
        returnData = ACETEligibilityUpdController.updateEHubFamilyOverview(recordId,objectType,returnData);
        }
        when 'Member_Information__c'
        {
        returnData = ACETEligibilityUpdController.updateEHubMemberInformation(recordId,objectType,returnData);  
        }
        when 'Account'
        {
        returnData = ACETEligibilityUpdController.updateEHubAccount(recordId,objectType,returnData);
        }
        when else{
              
          }
      }
       return returnData;
    }


public static SearchResultWrapper updateEHubFamilyOverview(ID recordId,String objectType,SearchResultWrapper returnData){
        system.debug('****inside main method***');
        List<AccountContactRelation> actCntList = new List<AccountContactRelation>();

        ACETWSCalloutResult calloutResult=new ACETWSCalloutResult();
        List<Family_Overview__c> fOverviewList = [SELECT Id, CHN_Qualified__c,Family_Status__c, First_Family_Contact_Into_Center__c,
                                                  Designation_Changed_Date__c,Designation__c,Account__r.Family_ID__c,EHub_Update_Check__c,
                                                  Account__r.Policy_ID__c,Account__r.Member_ID__c,
                                                  Account__r.Owner.name,Account__r.Owner.FederationIdentifier
                                                  FROM Family_Overview__c WHERE id=:recordId and EHub_Update_Check__c=true];
        
        if(fOverviewList!=null && fOverviewList.size()>0){
            returnData.elligHubCheck=true;
            Family_Overview__c fam=fOverviewList.get(0);
            String famAccountID = '';
            famAccountID = fam.Account__c;
            if(famAccountID != '' && famAccountID != null){
                actCntList = [SELECT ID,AccountId, ContactId, Complex_Indicator_Text__c, Contact.Account.CHN_Qualified__c,
                              Contact.Account.Source_Code__c, Contact.Account.PersonMailingState, 
                              Contact.AccountId, Relationship__c, Contact.Account.CreatedDate,
                              Contact.Account.FirstName,Contact.Account.LastName, Contact.Account.PersonBirthdate, 
                              Contact.Account.CHN_Referral_Identifier__c,Contact.Account.EID__c
                              FROM AccountContactRelation WHERE AccountId =: famAccountID ];
            }
            String designation='';
            if(String.isNotblank(fam.Designation__c)){
                designation=fam.Designation__c;
            }
            String adviserMsId=String.isBlank(fam.Account__r.Owner.FederationIdentifier)?'Unassigned':fam.Account__r.Owner.FederationIdentifier; 
            if(String.isNotBlank(designation) && String.isNotBlank(fam.Account__r.Family_ID__c)){
                system.debug('***inside if***');
                List<SENS_Publish__c> lstOfSNIPublish = new List<SENS_Publish__c>();
                if(actCntList.size()>0){
                    for(AccountContactRelation ac:actCntList){
                        SENS_Publish__c sensP = new SENS_Publish__c();
                        sensP.Advisor_MSID__c = adviserMsId;
                        sensP.Advisor_Name__c = fam.Account__r.Owner.name;
                        sensP.Family_Overview__c = recordId;
                        sensP.Member_ID__c = fam.Account__r.Member_ID__c;
                        sensP.Policy_ID__c = fam.Account__r.Policy_ID__c;
                        sensP.Designation__c = fam.Designation__c;
                        sensP.First_Family_Contact_Into_Center__c = fam.First_Family_Contact_Into_Center__c;
                        sensP.Family_Status__c = fam.Family_Status__c;
                        sensP.Account__c = ac.Contact.AccountId;
                        sensP.SENS_Unique_ID__c = ac.Contact.AccountId;
                        sensP.Relationship__c = ac.Relationship__c;
                        sensP.First_Name__c = ac.Contact.Account.FirstName;
                        sensP.Last_Name__c = ac.Contact.Account.LastName;
                        sensP.Enrollment_Date__c = ac.Contact.Account.CreatedDate;
                        sensP.Designation_Changed_Date__c = fam.Designation_Changed_Date__c;
                        sensP.CHN_Qualified__c = ac.Contact.Account.CHN_Qualified__c;
                        sensP.Source_Code__c = ac.Contact.Account.Source_Code__c;
                        sensP.State_Code__c = ac.Contact.Account.PersonMailingState;
                        sensP.DOB__c = ac.Contact.Account.PersonBirthdate;
                        sensP.CHN_Referral_Identifier__c = ac.Contact.Account.CHN_Referral_Identifier__c;
                        sensP.EID__c = ac.Contact.Account.EID__c;
                        sensP.Complex_Indicator__c = ac.Complex_Indicator_Text__c;
                        lstOfSNIPublish.add(sensP);
                    }
                }
                Schema.SObjectField pKey = SENS_Publish__c.Fields.SENS_Unique_ID__c;
                if(lstOfSNIPublish.size()>0){
                    database.upsert(lstOfSNIPublish,pKey,false);
                }
                /*SENS_Publish__c sensP = new SENS_Publish__c();
                sensP.Advisor_MSID__c = adviserMsId;
                sensP.Advisor_Name__c = fam.Account__r.Owner.name;
                sensP.Family_Overview__c = recordId;
                sensP.Member_ID__c = fam.Account__r.Member_ID__c;
                sensP.Policy_ID__c = fam.Account__r.Policy_ID__c;
                sensP.Designation__c = fam.Designation__c;
                sensP.First_Family_Contact_Into_Center__c = fam.First_Family_Contact_Into_Center__c;
                sensP.Family_Status__c = fam.Family_Status__c; */
                //upsert sensP Member_ID__c;
                /* commented below code for CHN
                ACETDesignationUpdAPI eHubUpd=new ACETDesignationUpdAPI();
                calloutResult=eHubUpd.updateDetail(fam.Account__r.Family_ID__c,adviserMsId,fam.Account__r.Owner.name,designation);
                commented code ends */
            }
            returndata.elligHubCheck = true;
            returndata.statusCode = 200;
            returnData.message = 'Success';
            //returndata =ACETEligibilityUpdController.updateEHubFamilyOverviewup(fam,calloutResult,returnData);
                
        }
    return returndata;  
      }
public static SearchResultWrapper updateEHubFamilyOverviewup(Family_Overview__c fam,ACETWSCalloutResult calloutResult,SearchResultWrapper returnData){
   if(calloutResult!=null){
                returnData.resultWrapper=calloutResult;
                returnData.message=calloutResult.Message;
                returnData.statusCode=calloutResult.StatusCode;
                System.debug('result1' + calloutResult);
                if((calloutResult.Success && (calloutResult.StatusCode ==200 || calloutResult.StatusCode ==201))||test.isRunningTest()){
                    fam.EHub_Update_Check__c=false;
                    System.debug('result' + calloutResult);
                    update fam;
                    ACETEligFamOverviewQCallout queACET = new ACETEligFamOverviewQCallout(fam.Account__c, fam.Id, fam.Account__r.Policy_ID__c, fam.Account__r.Member_ID__c);
                    Id jobId = System.enqueueJob(queACET);
                }
            }
return returnData;
}

 
public static SearchResultWrapper updateEHubMemberInformation(ID recordId,String objectType,SearchResultWrapper returnData){
      
       list<Member_Information__c> lstMemInfo = [select id,EHub_Update_Check__c,Account__r.Family_ID__c,Account__r.personcontactid,Account__r.id,Newly_Diagnosed_Date__c,Medical_Condition__c,Behavioral_Condition__c,Primary__c from Member_Information__c where id =: recordId and EHub_Update_Check__c = true];
           if(lstMemInfo!=null && lstMemInfo.size()>0){
               returnData.elligHubCheck=true;
               if(lstMemInfo[0].Account__r.personcontactid != null){
                  list<AccountContactRelation> lstACRInfo =[ SELECT Account.Family_ID__c FROM AccountContactRelation WHERE Contactid =: lstMemInfo[0].Account__r.personcontactid]; 
                   if(lstACRInfo != null && lstACRInfo.size()>0 && lstACRInfo[0].Account.Family_ID__c != null){
                       string famFamilyId = lstACRInfo[0].Account.Family_ID__c;
                       
                       string personFamilyId = lstMemInfo[0].Account__r.Family_ID__c !=null?lstMemInfo[0].Account__r.Family_ID__c:lstMemInfo[0].Account__r.id;
                       ACETSNIEligibilityUpdAPIRequest.Family famObj = new ACETSNIEligibilityUpdAPIRequest.Family();
                       famObj.acetFamilyId = famFamilyId;
                       famObj.initialCallDate = ' ';
                       famObj.policyID = ' ';
                       famObj.memberID= ' ';
                       famObj.adviserMsId = ' ';
                       famObj.advisorFullName = ' ';
                       famObj.designation = ' ';
                       ACETSNIEligibilityUpdAPIRequest.member memObj = new ACETSNIEligibilityUpdAPIRequest.member();
                       memObj.acetIndividualId = personFamilyId;
                       memObj.firstName = ' ';
                       memObj.lastName = ' ';
                       memObj.dob = ' ';
                       memObj.relationship = ' ';
                       
                       returnData = ACETEligibilityUpdController.updateEHubMemberInformationup(lstMemInfo,famObj,memObj,returnData);
                   }
               }
               
           }    
 return returnData;
}
public static SearchResultWrapper updateEHubMemberInformationup(list<Member_Information__c> lstMemInfo,ACETSNIEligibilityUpdAPIRequest.Family famObj,ACETSNIEligibilityUpdAPIRequest.member memObj,SearchResultWrapper returnData){
  if(lstMemInfo[0].Newly_Diagnosed_Date__c == null)
                         memObj.newlyDiagnosed = 0;
  else
  memObj.newlyDiagnosed = 1;
  memObj.medicalCondition = lstMemInfo[0].Medical_Condition__c;
  memObj.behavioralCondition = lstMemInfo[0].Behavioral_Condition__c;
  if(lstMemInfo[0].Primary__c) 
  memObj.isPrimary = 1 ;
  else
  memObj.isPrimary = 0;
  ACETSNIEligibilityUpdAPI sniEliHubApi=new ACETSNIEligibilityUpdAPI();
                       ACETWSCalloutResult calloutResult = sniEliHubApi.callEligibilityService(famObj, new list<ACETSNIEligibilityUpdAPIRequest.member>{memObj});
                       if(calloutResult != null){
                            returnData.resultWrapper=calloutResult;
                            returnData.message=calloutResult.Message;
                            returnData.statusCode=calloutResult.StatusCode;
                            if(calloutResult.Success && (calloutResult.StatusCode ==200 || calloutResult.StatusCode ==201)){
                                lstMemInfo[0].EHub_Update_Check__c=false;
                                update lstMemInfo;
                                /*
                                Account accRec = new Account(
                                    Id= recordId,
                                    EHub_Update_Check__c = false
                                );
                                update accRec;
                                */
                           }
                       }
return returnData;
}
        
public static SearchResultWrapper updateEHubAccount(ID recordId,String objectType,SearchResultWrapper returnData){
      
    list<Account> lstAccInfo = [select Id,Firstname,LastName,PersonBirthdate,EHub_Update_Check__c,Line_of_Business__c,Product_Type__c,CreatedDate,Family_ID__c , Member_ID__c , Policy_ID__c ,OwnerId, Owner.FederationIdentifier , Owner.Name,PersonContactId,(select id,EHub_Update_Check__c,Newly_Diagnosed_Date__c,Medical_Condition__c,Behavioral_Condition__c,Primary__c from Members_Information__r WHERE Primary__c = true),(Select Id,Designation__c from Family_Overview__r) from Account where id =: recordId and EHub_Update_Check__c = true];
          
          if(lstAccInfo!=null && lstAccInfo.size()>0){
               returnData.elligHubCheck=true;
          
              if(lstAccInfo[0].personcontactid == null){
                   returnData = ACETEligibilityUpdController.updateEHubAccountNoPer(recordId,objectType,lstAccInfo,returnData);   
                   
               }
               else if(lstAccInfo[0].Family_ID__c != null && lstAccInfo[0].personcontactid != null){
                   returnData = ACETEligibilityUpdController.updateEHubAccountPer(recordId,objectType,lstAccInfo,returnData);
               }
          }
    return returnData;
}
public static SearchResultWrapper updateEHubAccountNoPer(ID recordId,String objectType,List<account> lstAccInfo,SearchResultWrapper returnData){
                    Account famRec = lstAccInfo[0];
                   list<AccountContactRelation> lstACRInfo =[ SELECT AccountId, ContactId, Relationship__c FROM AccountContactRelation WHERE AccountId IN:lstAccInfo];
                   set<Id> conItSet =  new set<Id>();
                   Map<string, string> relationMap = new Map<string, string>();
                   for(AccountContactRelation acr:lstACRInfo){
                       conItSet.add(acr.ContactId);
                       string mapKey = acr.AccountId +'_'+acr.ContactId;
                       relationMap.put(mapKey, acr.Relationship__c);
                   }
                   list<Account> lstMemConInfo = [select id,Family_ID__c,PersonContactId,Firstname,LastName,PersonBirthdate, Relationship__pc,(select id,EHub_Update_Check__c,Newly_Diagnosed_Date__c,Medical_Condition__c,Behavioral_Condition__c,Primary__c from Members_Information__r WHERE Primary__c = true) from Account where PersonContactId IN:conItSet]; 
                   if(famRec.Family_ID__c != null){
                       List<Member_Information__c> memInfoList = new List<Member_Information__c>();
                       string famFamilyId = famRec.Family_ID__c;
                       ACETSNIEligibilityUpdAPIRequest.Family famObj = new ACETSNIEligibilityUpdAPIRequest.Family();
                       famObj.acetFamilyId = famFamilyId;
                       
                       famObj.initialCallDate = string.valueOf(famRec.CreatedDate);
                       famObj.policyID = famRec.Policy_ID__c;
                       famObj.memberID= famRec.Member_ID__c;
                       famObj.adviserMsId = famRec.Owner.FederationIdentifier;
                       famObj.advisorFullName = famRec.Owner.Name;
                       //famObj.designation = famRec.Designation__c ; //Commented to resolve the defect-DE389067
                       //Added to resolve the defect-DE389067 -Begin
                       famObj.designation=' ';
                       if(famRec.Family_Overview__r!=null && famRec.Family_Overview__r.size()>0 && String.isNotBlank(famRec.Family_Overview__r.get(0).Designation__c)){
                           famObj.designation= famRec.Family_Overview__r.get(0).Designation__c;
                        }
                       //Added to resolve the defect-DE389067 -End
                       famObj.accountType=famRec.Product_Type__c;//Added -US3044661: Update API for EHUB
                       famObj.lob=famRec.Line_of_Business__c;//Added -US3044661: Update API for EHUB
                       
                       list<ACETSNIEligibilityUpdAPIRequest.member> memList = new List<ACETSNIEligibilityUpdAPIRequest.member>();
                       updateEHubAccountNoPermembcl rt = new updateEHubAccountNoPermembcl();
                       rt = ACETEligibilityUpdController.updateEHubAccountNoPermemb(recordId,objectType,famRec,lstMemConInfo,relationMap,memInfoList);
                       memList = rt.memList;
                       memInfoList = rt.memInfoList;
                       returnData = ACETEligibilityUpdController.updateEHubAccountNoPermembup(recordId,memInfoList,famObj,memList,returnData);
                   }   
 return returnData;       
}
public static updateEHubAccountNoPermembcl updateEHubAccountNoPermemb(ID recordId,String objectType,account famRec,List<account> lstMemConInfo,Map<string, string> relationMap,List<Member_Information__c> memInfoList){
list<ACETSNIEligibilityUpdAPIRequest.member> memList = new List<ACETSNIEligibilityUpdAPIRequest.member>();
                         for(Account mem:lstMemConInfo){
                           string personFamilyId = mem.Family_ID__c !=null?mem.Family_ID__c:mem.id;
                           ACETSNIEligibilityUpdAPIRequest.member memObj = new ACETSNIEligibilityUpdAPIRequest.member();
                           memObj.acetIndividualId = personFamilyId;
                           memObj.firstName = mem.Firstname;
                           memObj.lastName = mem.LastName;
                           memObj.dob = string.valueOf(mem.PersonBirthdate);
                           string relMapKey = famRec.Id+'_'+mem.PersonContactId;
                           memObj.relationship = relationMap.get(relMapKey);
                           if(mem.Members_Information__r != null && mem.Members_Information__r.size()>0){
                               Member_Information__c  memInfo = mem.Members_Information__r[0];
                               memInfo.EHub_Update_Check__c=false;
                               memInfoList.add(memInfo);
                               if(memInfo.Newly_Diagnosed_Date__c == null)
                                 memObj.newlyDiagnosed = 0;
                               else
                                 memObj.newlyDiagnosed = 1;
                               memObj.medicalCondition = memInfo.Medical_Condition__c;
                               memObj.behavioralCondition = memInfo.Behavioral_Condition__c;
                               if(memInfo.Primary__c) 
                                   memObj.isPrimary = 1 ;
                                else
                                   memObj.isPrimary = 0;
                           }
                           memList.add(memObj);
                       }
    updateEHubAccountNoPermembcl rt = new updateEHubAccountNoPermembcl();
    rt.memInfoList = memInfoList;   
    rt.memList = memList;                  
    return rt;
}

public static SearchResultWrapper updateEHubAccountNoPermembup(ID recordId,List<Member_Information__c> memInfoList,ACETSNIEligibilityUpdAPIRequest.Family famObj, list<ACETSNIEligibilityUpdAPIRequest.member> memList,SearchResultWrapper returnData){
  ACETSNIEligibilityUpdAPI sniEliHubApi=new ACETSNIEligibilityUpdAPI();
                       ACETWSCalloutResult calloutResult = sniEliHubApi.callEligibilityService(famObj, memList);
                       if(calloutResult != null){
                            returnData.resultWrapper=calloutResult;
                            returnData.message=calloutResult.Message;
                            returnData.statusCode=calloutResult.StatusCode;
                            if(calloutResult.Success && (calloutResult.StatusCode ==200 || calloutResult.StatusCode ==201)){
                                
                                update memInfoList;
                                Account accRec = new Account(
                                    Id= recordId,
                                    EHub_Update_Check__c = false
                                );
                                update accRec;
                            }
                       } 
                       
return returnData;
}

public static SearchResultWrapper updateEHubAccountPer(ID recordId,String objectType,List<Account> lstAccInfo,SearchResultWrapper returnData){
                  list<Id> personConIdList = new list<Id>();
                   for(Account acc: lstAccInfo){
                       personConIdList.add(acc.PersonContactId);
                   }
                   //list<Account> lstMemConInfo = [select id,Family_ID__c,PersonContactId,Firstname,LastName,PersonBirthdate, Relationship__pc,(select id,EHub_Update_Check__c,Newly_Diagnosed_Date__c,Medical_Condition__c,Behavioral_Condition__c,Primary__c from Members_Information__r WHERE Primary__c = true) from Account where PersonContactId IN:conItSet];     
                   list<AccountContactRelation> lstACRInfo =[ SELECT AccountId, ContactId, Relationship__c  FROM AccountContactRelation WHERE ContactId IN:personConIdList];
                   set<Id> AccIdSet =  new set<Id>();
                   Map<string, string> relationMap = new Map<string, string>();
                   for(AccountContactRelation acr:lstACRInfo){
                       AccIdSet.add(acr.AccountId);
                       string mapKey = acr.AccountId +'_'+acr.ContactId;
                       relationMap.put(mapKey, acr.Relationship__c);
                   }
                   list<Account> lstFamInfo = [select id,Family_ID__c,Firstname,LastName,PersonBirthdate, EHub_Update_Check__c,Product_Type__c,Line_of_Business__c,CreatedDate , Member_ID__c , Policy_ID__c ,OwnerId, Owner.FederationIdentifier , Owner.Name,PersonContactId,(Select Id,Designation__c from Family_Overview__r) from Account where Id IN:AccIdSet]; 
                   
          
                   Account famRec = lstFamInfo[0];
                   if(famRec.Family_ID__c != null)
                   {
                  
                       List<Member_Information__c> memInfoList = new List<Member_Information__c>();
                       string famFamilyId = famRec.Family_ID__c;
                     //  string famFamilyId = famRec.Family_ID__c !=null?famRec.Family_ID__c:famRec.id;

                       
                       ACETSNIEligibilityUpdAPIRequest.Family famObj = new ACETSNIEligibilityUpdAPIRequest.Family();
                       famObj.acetFamilyId = famFamilyId;
                       
                       famObj.initialCallDate = string.valueOf(famRec.CreatedDate);
                       famObj.policyID = famRec.Policy_ID__c;
                       famObj.memberID= famRec.Member_ID__c;
                       famObj.adviserMsId = famRec.Owner.FederationIdentifier;
                       famObj.advisorFullName = famRec.Owner.Name;
                       //famObj.designation = famRec.Designation__c ; //Commented to resolve the defect-DE389067
                       //Added to resolve the defect-DE389067 -Begin
                       famObj.designation=' ';
                       if(famRec.Family_Overview__r!=null && famRec.Family_Overview__r.size()>0 && String.isNotBlank(famRec.Family_Overview__r.get(0).Designation__c)){
                           famObj.designation= famRec.Family_Overview__r.get(0).Designation__c;
                        }
                       //Added to resolve the defect-DE389067 -End
                       
                       famObj.accountType=famRec.Product_Type__c;//Added -US3044661: Update API for EHUB
                       famObj.lob=famRec.Line_of_Business__c;//Added -US3044661: Update API for EHUB
                       
                       list<ACETSNIEligibilityUpdAPIRequest.member> memList = new List<ACETSNIEligibilityUpdAPIRequest.member>();
                       updateEHubAccountNoPermembcl rt = new updateEHubAccountNoPermembcl();
                       rt = ACETEligibilityUpdController.updateEHubAccountPermemb(recordId,objectType,famRec,lstFamInfo,relationMap,memInfoList);
                       memList = rt.memList;
                       memInfoList = rt.memInfoList;
                       
                       returnData = ACETEligibilityUpdController.updateEHubAccountPermembup(recordId,memInfoList,famObj,memList,returnData);

                   }      
              return returnData; 
}
public static updateEHubAccountNoPermembcl updateEHubAccountPermemb(ID recordId,String objectType,account famRec,List<account> lstAccInfo,Map<string, string> relationMap,List<Member_Information__c> memInfoList){
 list<ACETSNIEligibilityUpdAPIRequest.member> memList = new List<ACETSNIEligibilityUpdAPIRequest.member>();
                       for(Account mem:lstAccInfo){
                           string personFamilyId = mem.Family_ID__c !=null?mem.Family_ID__c:mem.id; 
                           ACETSNIEligibilityUpdAPIRequest.member memObj = new ACETSNIEligibilityUpdAPIRequest.member();
                           memObj.acetIndividualId = personFamilyId;
                           memObj.firstName = mem.Firstname;
                           memObj.lastName = mem.LastName;
                           memObj.dob = string.valueOf(mem.PersonBirthdate);
                           string relMapKey = famRec.Id+'_'+mem.PersonContactId;
                           memObj.relationship = relationMap.get(relMapKey);
                           if(mem.Members_Information__r != null && mem.Members_Information__r.size()>0){
                               Member_Information__c  memInfo = mem.Members_Information__r[0];
                               memInfo.EHub_Update_Check__c=false;
                               memInfoList.add(memInfo);
                               if(memInfo.Newly_Diagnosed_Date__c == null)
                                 memObj.newlyDiagnosed = 0;
                               else
                                 memObj.newlyDiagnosed = 1;
                               memObj.medicalCondition = memInfo.Medical_Condition__c;
                               memObj.behavioralCondition = memInfo.Behavioral_Condition__c;
                               if(memInfo.Primary__c) 
                                   memObj.isPrimary = 1 ;
                                else
                                   memObj.isPrimary = 0;
                           }
                           memList.add(memObj);
                       }  

    updateEHubAccountNoPermembcl rt = new updateEHubAccountNoPermembcl();
    rt.memInfoList = memInfoList;   
    rt.memList = memList;                  
    return rt;
}

public static SearchResultWrapper updateEHubAccountPermembup(ID recordId,List<Member_Information__c> memInfoList,ACETSNIEligibilityUpdAPIRequest.Family famObj, list<ACETSNIEligibilityUpdAPIRequest.member> memList,SearchResultWrapper returnData){
ACETSNIEligibilityUpdAPI sniEliHubApi=new ACETSNIEligibilityUpdAPI();
ACETWSCalloutResult calloutResult = sniEliHubApi.callEligibilityService(famObj, memList);
if(calloutResult != null){
      returnData.resultWrapper=calloutResult;
      returnData.message=calloutResult.Message;
      returnData.statusCode=calloutResult.StatusCode;
      if(calloutResult.Success && (calloutResult.StatusCode ==200 || calloutResult.StatusCode ==201)){
                                
         update memInfoList;
         Account accRec = new Account(
            Id= recordId,
            EHub_Update_Check__c = false
            );
            update accRec;
                                
      }
}
return returnData;
}

    
    @AuraEnabled
    public static String getErrorMessage(String errorCode){
        return ACETUtility.getErrorMessage(errorCode);
    }
    public class updateEHubAccountNoPermembcl{
    List<ACETSNIEligibilityUpdAPIRequest.member> memList;
    List<Member_Information__c> memInfoList;
    }

}