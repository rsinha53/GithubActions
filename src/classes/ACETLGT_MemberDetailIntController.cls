public class ACETLGT_MemberDetailIntController{
     @AuraEnabled public Interaction__c Interaction  { get; set; }
    @AuraEnabled public String interactionId {get; set;}
    
    
 
	
 
    
    @AuraEnabled
     public static Interaction__c queryInteraction(String InteractionId){        
       system.debug('query>>>'+InteractionId);
       Interaction__c Interaction = new Interaction__c();
       List<Interaction__c> InteractionList = new List<Interaction__c>();
        if (InteractionId != null && InteractionId !='')
        {
        InteractionList = [SELECT Id, Name, Interaction_Type__c, Provider_ID__c, Group_ID__c, Originator_Type__c, Originator_Name__c,Contact_Name__c, Caller_Type__c, Highlight_Panel_GroupInfo__c,Originator__c, Originator__r.EID__c, Originator__r.Tax_ID__c, Originator__r.NPI__c, 
            Originator__r.Name,Id__c, Originator__r.LastName, Originator__r.FirstName, Originator__r.AccountId,Originator__r.Account.Name,Originator__r.Birthdate,Originator__r.mailingState,Originator__r.mailingPostalCode,Originator__r.Phone, Third_Party__c, Third_Party__r.Tax_ID__c, Third_Party__r.NPI__c, 
            Third_Party__r.FullName__c, Provider_Address_Id__c , Provider_Address_Type__c, Third_Party__r.LastName__C,Third_Party__r.Producer_Name__C, Third_Party__r.First_Name__c,Third_Party__r.Employer_Name__c, Third_Party__r.Phone_Number__c, Third_Party__r.Email__c
            FROM Interaction__c WHERE Id =:InteractionId];
        }  
       system.debug('queryresult>>>'+InteractionList);
              
        if(InteractionList.size() > 0){
            Interaction = InteractionList[0];
            ACETVCCDUtility.populateVCCDInfo(Interaction);
            return Interaction;
        }else{
            return null;
        }
        
 
    }
    @AuraEnabled
     public static Interaction__c queryInteraction(String InteractionId, String vccdParams){        
       
       system.debug('query>>>'+InteractionId);
       Interaction__c Interaction = new Interaction__c();
       List<Interaction__c> InteractionList = new List<Interaction__c>();
        if (InteractionId != null && InteractionId !='')
        {
        
        InteractionList = [SELECT Id, Name, Interaction_Type__c, Provider_ID__c, Group_ID__c, Originator_Type__c, Originator_Name__c,Contact_Name__c, Caller_Type__c, Highlight_Panel_GroupInfo__c,Originator__c, Originator__r.EID__c, Originator__r.Tax_ID__c, Originator__r.NPI__c, 
            Originator__r.Name,Id__c, Originator__r.LastName, Originator__r.FirstName, Originator__r.AccountId,Originator__r.Account.Name,Originator__r.Birthdate,Originator__r.mailingState,Originator__r.mailingPostalCode,Originator__r.Phone, Third_Party__c, Third_Party__r.Tax_ID__c, Third_Party__r.NPI__c, 
            Third_Party__r.FullName__c, Provider_Address_Id__c , Provider_Address_Type__c, Third_Party__r.LastName__C,Third_Party__r.Producer_Name__C, Third_Party__r.First_Name__c,Third_Party__r.Employer_Name__c, Third_Party__r.Phone_Number__c, Third_Party__r.Email__c
            FROM Interaction__c WHERE Id =:InteractionId];
        }  
       system.debug('queryresult>>>'+InteractionList);
              
        if(InteractionList.size() > 0){
            Interaction = InteractionList[0];
            ACETVCCDUtility.populateVCCDInfo(Interaction, vccdParams);
            return Interaction;
        }else{
            return null;
        }
        

    }

     
    //public static ACETLGT_HighlightPanelInfo prepareHighlightPanelWrapper(String highlightPanelDetails){
    @AuraEnabled 
    public static ACETLGT_HighlightPanelInfo prepareHighlightPanelWrapper(String highlightPanelDetails, string intId){ //, string memDOB
        system.debug('highlightPanelDetails in class:: '+highlightPanelDetails);
        
        
        String dataOfBirth;
        Map<String,Object> hisData;
        Integer memAge;

        List<Object> hList = (List<Object>)JSON.deserializeUntyped('['+highlightPanelDetails+']');
        String originatorName;
        String subjectName;
        String subjectFName, subjectLName, subjectDOB;

        String serviceGrp;
        String accTypes;
        for(Object fld : hList){
            
            hisData = (Map<String,Object>)fld;
            System.debug('-----hisData----->'+hisData);
            if (hisData != null){
               
                 if (hisData.get('serviceGrp') != null && hisData.get('serviceGrp') != ''){
                     serviceGrp = (String)hisData.get('serviceGrp');   
                      }
                 if (hisData.get('accTypes') != null && hisData.get('accTypes') != ''){
                     accTypes = (String)hisData.get('accTypes');   
                      }
                   
                if (hisData.get('MemberDOB') != null && hisData.get('MemberDOB') != ''){
              String   memDOB = String.valueOf(hisData.get('MemberDOB'));
                    memAge = Integer.valueOf(Date.parse(memDOB).daysBetween(Date.Today())/365); 
                    
                    /*if(memDOB != ''){
                        Integer birthdateYear = Integer.valueof(memDOB.split('-')[0]);
                        Integer birthdateMonth = Integer.valueof(memDOB.split('-')[1]);
                        Integer birthdateDay = Integer.valueof(memDOB.split('-')[2]);
                        Integer currentYear = Date.Today().year();
                        Integer currentMonth = Date.Today().month();
                        Integer currentDay = Date.Today().day();
                        if(currentMonth < birthdateMonth){
                            memAge = currentYear - birthdateYear - 1;
                        } else if(currentMonth > birthdateMonth){
                            memAge =currentYear - birthdateYear;
                        } else if(currentMonth == birthdateMonth){
                            if(currentDay < birthdateDay){
                                memAge = currentYear - birthdateYear - 1;
                            } else if(currentDay >= birthdateDay){
                                memAge = currentYear - birthdateYear;
                            }
                        }
                    }*/
                }
                if (hisData.get('subjectID') != null && hisData.get('subjectID') != ''){
                    Id subId = String.valueOf(hisData.get('subjectID')) ;
                    System.debug('-----subId----->'+subId);
                    List<Contact> sub = [SELECT Name, FirstName, LastName, Birthdate FROM Contact WHERE id =:subId  LIMIT 1];
                    if(!sub.isEmpty()){
                        Contact con = sub.get(0);
                        subjectName = con.Name;
                        subjectFName = con.FirstName;
                        subjectLName = con.LastName;
                        subjectDOB = (con.Birthdate != null) ? ACETUtility.format(con.Birthdate) : '';
                    }
      
       
                    //  US2265866 : subject relationship to highlight panel
                    if(hisData.get('subjectRelation') != null && hisData.get('subjectRelation') != '') {
                        String relationShip = String.valueOf(hisData.get('subjectRelation'));
                        subjectName += String.isNotBlank(relationShip) ? ' (' + relationShip + ')' : '';
                    }
                    System.debug('-----subjectName----->'+subjectName);
                    hisData.put('subjectName', subjectName);
                }
                if (hisData.get('originatorID') != null && hisData.get('originatorID') != ''){
                    if (hisData.get('originatorID') != 'Third Party'){
                        
                        //Id orgiId = String.valueOf(hisData.get('originatorID')) ;
                        string orgiId = String.valueOf(hisData.get('originatorID')) ;
                        System.debug('=========orgiId=======>>'+orgiId);                        
                        /*
                        if(intId != null){
                            System.debug('=========intId=======>>'+intId);
                            Interaction__c Intrec = new Interaction__c(id=intId,Originator__c=orgiId);
                            update Intrec;	
                        }
						*/
                        if (orgiId.startsWith('003'))
                        	originatorName = [SELECT id,Name FROM Contact WHERE id =:orgiId  LIMIT 1].Name;
                        else
                            originatorName = String.valueOf(hisData.get('originatorID'));
                        System.debug('-----originatorName----->'+originatorName);
                        hisData.put('originatorName', originatorName);
                    }    
                }
            }                               
        }
      
   
        if (hisData != null){
            if (hisData.get('MemberDOB') != null && hisData.get('MemberDOB') != ''){
                if (memAge >= 1)
                    hisData.put('MemberDOB', hisData.get('MemberDOB') + ' ('+memAge+' Yrs)');
                else
                    hisData.put('MemberDOB', hisData.get('MemberDOB') + ' (0 Yrs)');
            }
        } 
        /**if (hisData.get('subjectName') != null && hisData.get('subjectName') != ''){
            Id subId = JSON.serialize(hisData.get('subjectName')) ;
            subjectName = [SELECT Name FROM Contact WHERE id =:subId  LIMIT 1].Name;
            System.debug('-----subjectName----->'+subjectName);
            
        }
        if (hisData.get('originatorName') != null && hisData.get('originatorName') != ''){
            Id origid = JSON.serialize(hisData.get('originatorName'));
            originatorName = [SELECT Name FROM Contact WHERE id =:origid  LIMIT 1].Name;
            System.debug('-----originatorName----->'+originatorName);
            
        }
        if (hisData != null){
            if (hisData.get('subjectName') != null && hisData.get('subjectName') != ''){
                    System.debug('-----subjectName----->'+subjectName);
                    hisData.put('subjectName', subjectName);
            }
            if (hisData.get('originatorName') != null && hisData.get('originatorName') != ''){
                    System.debug('-----originatorName----->'+originatorName);
                    hisData.put('originatorName', originatorName);
            }
        }**/
        
        /*if(String.isNotBlank(memDOB) ){
            Integer birthdateYear = Integer.valueof(memDOB.split('-')[0]);
            Integer birthdateMonth = Integer.valueof(memDOB.split('-')[1]);
            Integer birthdateDay = Integer.valueof(memDOB.split('-')[2]);
            Integer currentYear = Date.Today().year();
            Integer currentMonth = Date.Today().month();
            Integer currentDay = Date.Today().day();
            if(currentMonth < birthdateMonth){
                memAge = currentYear - birthdateYear - 1;
            } else if(currentMonth > birthdateMonth){
                memAge =currentYear - birthdateYear;
            } else if(currentMonth == birthdateMonth){
                if(currentDay < birthdateDay){
                    memAge = currentYear - birthdateYear - 1;
                } else if(currentDay >= birthdateDay){
                    memAge = currentYear - birthdateYear;
                }
            }
            if (memAge >= 1)
                    hisData.put('MemberDOB', memDOB + ' ('+memAge+' Yrs)');
                else
                    hisData.put('MemberDOB', memDOB + ' (0 Yrs)');
        }*/

        system.debug('hisData ::: '+hisData);
        if (hisData == null){
            hisData = new Map<String, Object>();
            hisData.put('MemberId', '');
            hisData.put('SubscriberId', '');
            hisData.put('memberStatus', '');
            hisData.put('MemberDOB', '');
            hisData.put('subjectName', '');
            hisData.put('originatorName', '');
            hisData.put('GroupNumber', '');
            hisData.put('Network', '');
            hisData.put('EffectiveDate', '');
            hisData.put('EndDate', '');
            hisData.put('benefitBundleOptionId', '');
            hisData.put('image', '');
            hisData.put('accumAsOfDate', '');
            hisData.put('onshoreValue', '');
            hisData.put('onshoreCode', '');
            hisData.put('Name', '');
            hisData.put('EmployerName', '');
            hisData.put('State', '');
            hisData.put('ZIP', '');
            hisData.put('PhoneNumber', '');
            hisData.put('IsMemberNotfound', '');
            hisData.put('SpecialNeedsStatus', ''); 
            hisData.put('accTypes', '');  
            hisData.put('SitusState', '');  
        }


        system.debug('hisData After ::: '+hisData);
        ACETLGT_HighlightPanelInfo hpInfo = new ACETLGT_HighlightPanelInfo();

        system.debug((ACETLGT_HighlightPanelInfo) System.JSON.deserialize(JSON.serialize(hisData), ACETLGT_HighlightPanelInfo.class));
        hpInfo = (ACETLGT_HighlightPanelInfo) System.JSON.deserialize(JSON.serialize(hisData), ACETLGT_HighlightPanelInfo.class);
        system.debug('hpInfo :: '+hpInfo);
		  //Added below code by Abhinav for US3416165 for adding COVID-19 vaccinations details to the Highlights panel
         
        if(hpInfo.MemberId != null && !String.isBlank(hpInfo.MemberId)){
            List<String> doseStr = new List<String>();
            //subjectFName = 'ELIZABETH';
            //subjectLName = 'YENO';
            //subjectDOB = '12/07/1979';
            doseStr = ACETLGT_CovidVaccineAPIService.getCovidVaccineIndicatorDetails(subjectFName,subjectLName,subjectDOB);
            system.debug('doseStr in controller '+doseStr);
            hpInfo.immunizations = doseStr;
        }
        return hpInfo;

    }
     @AuraEnabled
    public static ACETLGT_EligibilityService.Eligibilitywrap getEligibility(String memberId,String policyId,String firstName,String lastName,String dob){  
        //Note Policyid is groupid 
        

        ACETLGT_EligibilityService es = new ACETLGT_EligibilityService();
        ACETLGT_EligibilityService.Eligibilitywrap ew = new ACETLGT_EligibilityService.Eligibilitywrap();
        ACETWSCalloutResult CalloutResult = null;
     CalloutResult = es.getEligibility(memberId.substring(0, 9),policyId,firstName,lastName,dob);
    String sniEligibility  ;
     if (CalloutResult != null && CalloutResult.Success == true)
        {   

            
            return (ACETLGT_EligibilityService.Eligibilitywrap)CalloutResult.Response;
        }else{
          return null;  
        }
     }





     @AuraEnabled
    Public Static String createFamilyaccountstree(String FamilyMembersList){
        system.debug('FamilyMembersList--->'+FamilyMembersList);
        List<Object> fmList = (List<Object>)JSON.deserializeUntyped(FamilyMembersList);
        Map<String,String>  relationshipmap = ACETUtility.getHouseholdRelationshipMap();
        Map<String,Object> famdata;        
        list<AccountContactRelation> accrel = new  list<AccountContactRelation>();
               //US3075995 : CHS Start
        List<String> eligibilityStatus = new List<String>();
        User[] unassignedUser = [select id from User where Name ='Unassigned'];
        String familyaccrecordtype = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        Schema.DescribeFieldResult statusResult = Account.Special_Needs_Status__c.getDescribe();
        List<Schema.PicklistEntry> res = statusResult.getPicklistValues();
        for( Schema.PicklistEntry statusVal : res){
            eligibilityStatus.add(statusVal.getValue());
        }
            //CHS End
           Boolean isPolicyUhg;
           string familyaccid;
           string selectaccountid;
           for(Object fm : fmList){
           famdata = (Map<String,Object>)fm;
           if((string)famdata.get('Relationship') =='Self'){
            selectaccountid = (string)famdata.get('SFrecId');
            break;
            }
           }
        system.debug('familyaccid--->'+familyaccid);
        system.debug('selectaccountid--->'+selectaccountid);
        if(selectaccountid != null){
          isPolicyUhg = ACETUtility.checkUHGPolicy((string)famdata.get('groupNumber'));
          accrel =   [Select id,AccountId from AccountContactRelation where ContactId =: selectaccountid]; 
        system.debug('accrel--->'+accrel);
                if(accrel.isempty()){
                    Account a = new Account();
                    a.Name = (string)famdata.get('FirstName')+' '+(string)famdata.get('LastName');
                    string memberid = (string)famdata.get('subscriberIndividualId');
                    a.Member_ID__c =memberid;//memberid.substring(0,9);
                    string groupNumber = (string)famdata.get('groupNumber');
                    string zero = '0';
                    if(groupNumber.length()<7){
                        for(integer i=0;i<7;i++){
                            if(groupNumber.length()<7){
                             groupNumber =  zero+groupNumber;
                            }

                        }
                    }
                    a.Policy_ID__c = groupNumber;
                    a.SRK_KeyChain__c=(string)famdata.get('ESRK');
                    a.RecordTypeId = familyaccrecordtype;
                    a.OwnerId = unassignedUser[0].Id;
                   System.debug('isPolicyUhg!!!='+isPolicyUhg);
                 if(isPolicyUhg){
                        a.UHG_Restriction__c     = 'Yes';
                    }
                    else{
                      a.UHG_Restriction__c   = 'No';
                     }
                insert a;
                familyaccid = a.id;
                            system.debug('familyacc---->'+a);

                }else{
                   familyaccid =  accrel[0].AccountId;
                }  
        }
        system.debug('familyaccid---->'+familyaccid);
      List<Sobject>  accConRelationList = new List<Sobject>();
             for(Object fm : fmList){
                 famdata = (Map<String,Object>)fm;
             if(familyaccid != null && String.isNotBlank((string)famdata.get('SFrecId')) && String.isNotEmpty((string)famdata.get('SFrecId'))){ 
                  AccountContactRelation accConRelation = new AccountContactRelation();
                    accConRelation.AccountId = familyaccid;
                    accConRelation.ContactId = (string)famdata.get('SFrecId');
                    accConRelation.Relationship__c =  relationshipmap.get((string)famdata.get('Relationship'));   
                    accConRelation.Member_ID__c = (string)famdata.get('subscriberIndividualId');
                    string groupNumber = (string)famdata.get('groupNumber');
                    string zero = '0';
                    if(groupNumber.length()<7){
                        for(integer i=0;i<7;i++){
                            if(groupNumber.length()<7){
                             groupNumber =  zero+groupNumber;
                            }

                        }
                    }
                    accConRelation.Policy_ID__c  = groupNumber;
                    accConRelationList.add(accConRelation);         
             }
             }
        if(accConRelationList.size()>0 && !accConRelationList.isEmpty()){
            Database.insert(accConRelationList, false);
        }
        system.debug('accConRelationList--->'+accConRelationList);
        return null;
    }


}