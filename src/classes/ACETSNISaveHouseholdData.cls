/*  Class: ACETSNISaveHouseholdData
 *  @author: Chandan
 *  Description: Replica of ACETSaveHouseholdData for SNI
 *  Date:24/01/2020
 */

public class ACETSNISaveHouseholdData {
    @AuraEnabled
    public static String getAppName() {
       return 'Service Console';//Code Hardcoded so that it would work only for SNI
    }
    @AuraEnabled
    public static Boolean isSNIRole() {
        /*system.debug('isSNIRole--------------------');
        Id userId = userinfo.getUserId();
        Boolean isSNI = true; 
        User userDetails =[SELECT UserRole.Name, Profile_Name__c FROM User where Id=:userId ];
        if (userDetails.Profile_Name__c == 'FamilyLink Profile'){
            isSNI = true;
        }
        else if(userDetails != null && userDetails.UserRole.Name != null){
            string loginRole = userDetails.UserRole.Name.trim();
            ACETSNIRoles__mdt[] sniRoles = [SELECT MasterLabel FROM ACETSNIRoles__mdt];
            system.debug('current user role is--------'+userDetails.UserRole.Name);
            for (ACETSNIRoles__mdt curRole : sniRoles) {
                system.debug('sni roles--------'+curRole.MasterLabel);
                //  if(curRole.MasterLabel == userDetails.UserRole.Name){
                if( curRole.MasterLabel.trim().equals(loginRole)){
                    // system.debug('role matched with configuaration---');
                    isSNI =  true;
                }
            }
        }
        system.debug('isSNIRole------------isSNI--------'+isSNI);
        return isSNI;*/
        return true; //Cherry - changed it to true, since we do not need to check SNI role
    }

    /* US:US2159219
* @author: Chandan
* Description: To get the last app name for the current user
* Date:14/11/2019
*/
    @AuraEnabled
    public static ACETHouseHoldWrapper.memberDetails getSaveHouseHoldData(ACETHouseHoldWrapper.HouseHold[] houseHoldData,String dob,String WoId,String memberId,string advFullName,String sniEligibleStatus,String policyId,String policyIdOrignal,String assignTo,String lob,String productTypes,String serviceGroup, String groupNumber){
        //Getting WoId to bind Person Account--Adding new Arrgument in getSaveHouseHoldData: WoId
        String appName=getAppName();
        ACETHouseHoldWrapper.memberDetails memberWrapper = new ACETHouseHoldWrapper.memberDetails();
         if(appName=='Service Console')
    	// accountId=ACETSNISaveHouseholdData.getSNISaveHouseholdData(houseHoldData,dob,memberId,advFullName,sniEligibleStatus,policyId,policyIdOrignal,assignTo);
    	memberWrapper=ACETSNISaveHouseholdData.getSNISaveHouseholdData(houseHoldData,dob,WoId,memberId,advFullName,sniEligibleStatus,policyId,policyIdOrignal,assignTo,lob,productTypes,serviceGroup, groupNumber);
        return memberWrapper;
    }

    //Multiple POlicy COde

    /* US:US2159219
* @author: Chandan
* Description: To get the last app name for the current user
* Date:14/11/2019
*/

    @AuraEnabled
    public static ACETHouseHoldWrapper.memberDetails getSNISaveHouseholdData(ACETHouseHoldWrapper.HouseHold[] houseHoldData,String dob,String WoId,String memberId,string advFullName,String sniEligibleStatus,String policyId,String policyIdOrignal,String assignTo,String lob,String productTypes,String serviceGroup, String groupNumber){
        system.debug('houseHoldData****'+houseHoldData);
        system.debug('houseHoldData****'+houseHoldData);
        system.debug('sniEligibleStatus****'+sniEligibleStatus);
        System.debug('WorkorderId'+WoId);
        system.debug('policyId******'+policyId);
        system.debug('memberId******'+memberId);
        system.debug('policyIdOrignal******'+policyIdOrignal);
        system.debug('assignTo******'+assignTo);
        system.debug('lob******'+lob);
        system.debug('productTypes******'+productTypes);
        system.debug('serviceGroup******'+serviceGroup);
        if(lob==null || lob.equalsIgnoreCase('null')) lob='';
        if(productTypes==null || productTypes.equalsIgnoreCase('null')) productTypes='';
        if(serviceGroup==null || serviceGroup.equalsIgnoreCase('null')) serviceGroup='';
        String accountId;
        List<String> relationshipStatus = new List<String>();
        List<String> eligibilityStatus = new List<String>();
        ACETHouseHoldWrapper.memberDetails memDetails = new ACETHouseHoldWrapper.memberDetails();
        memDetails.accountId = '';
        memDetails.memberName = new List<String>();
        memDetails.isSniUser = false;
        memDetails.isSniEligible = false;
        memDetails.memberId = memberId;
        memDetails.policyId = policyIdOrignal;
        memDetails.assignTo = assignTo;
        memDetails.newMemberMatch = new Map<String,List<AccountContactRelation>>();
        memDetails.nameRelationMap = new Map<string,string>();
        memDetails.existingMemDetails = new List<AccountContactRelation>();
        memDetails.isAcetSearch = '';
        List<AccountContactRelation> existingMemDetails = new List<AccountContactRelation>();
        List<String> memberName = new List<String>();
        Schema.DescribeFieldResult statusResult = Account.Special_Needs_Status__c.getDescribe();
        List<Schema.PicklistEntry> res = statusResult.getPicklistValues();
        Account a = new Account();
        for( Schema.PicklistEntry statusVal : res){
            eligibilityStatus.add(statusVal.getValue());
        }
        System.debug('eligibilityStatus....'+eligibilityStatus);

        Map<String,String>  relationshipMetaData = ACETUtility.getHouseholdRelationshipMap();
       // Need to write the logic if a household exist in the system but later on became ineligible so need to update the same in the current system. In order to do
        // that we need to bind the policy separately and not in household.

        system.debug('policyIdOrignal--222------'+policyIdOrignal);
        system.debug('memberId---222-----'+memberId);
        if(memberId!=null && memberId.startsWith('00Q')){
        	memberId = memberId.substring(2,memberId.length());
        }
        Account[] acc = [select id, Name, Member_ID__c,Policy_ID__c, Special_Needs_Status__c from account where  Member_ID__c =: memberId and Policy_ID__c  =: policyIdOrignal];// ravi
        //Boolean isPolicyUhg = ACETUtility.checkUHGPolicy(policyIdOrignal);//US2350839-Code Added By Chandan
       // System.debug('isPolicyUhg='+isPolicyUhg);
		system.debug('acc--->'+acc);
	//Boolean onshoreRestricted = checkOnshoreRestriction(houseHoldData, groupNumber);
	   // system.debug('acc value---222------'+acc);

        if( ! isSNIRole() && (acc == null || acc.size() == 0)){  // ravi - use this block if the family not exist and role is not Family Advisor, Nurse Advisor Research Advisor or Quick Assist Team
            // accountId  = 'not SNI user';
            memDetails.isSniUser = true ;
            system.debug('the value is not SNI user');
        }
         else
         {
        system.debug('acetSaveHoluseholdData-----------'+sniEligibleStatus);
        if(sniEligibleStatus == 'not eligible' && (acc == null || acc.size() == 0)){
           /*  system.debug('acetSaveHoluseholdData--------inn--11---');
            system.debug('acetSaveHoluseholdData--------inn--22---');
            Account a = new Account(); */
                memDetails.isSniEligible = true;
            /*
			if(acc != null && acc.size() > 0){
                 system.debug('acetSaveHoluseholdData--------inn--33---');
                for(String stats:eligibilityStatus){
                    if(stats.contains(sniEligibleStatus)){
                        a.Special_Needs_Status__c = stats;
                    }
                }
				string oldStatus = acc[0].Special_Needs_Status__c;
				a.id = acc[0].Id;
                //US2350839-Code Added By Chandan-Start
                System.debug('isPolicyUhg@@@='+isPolicyUhg);
                if(isPolicyUhg){
                    a.UHG_Restriction__c	 = 'Yes';
                }
                else{
                    a.UHG_Restriction__c	 = 'No';
                }
                //US2350839-Code End By Chandan
                update a;
               	 }
			*/
        }
        else
        {
            ACETHouseHoldWrapper.HouseHold houseDataTemp = new ACETHouseHoldWrapper.HouseHold();
            List<ACETHouseHoldWrapper.HouseHold> houseDataTempList = new List<ACETHouseHoldWrapper.HouseHold>();
            Boolean newRelationval = true ;
            String relationFromService = '';
            Map<String,String> relationShipMap = new Map<String,String>();
            List<String> newServiceRelation = new List<String>();
            system.debug('sni eligible or engaged 1----');
            if(houseHoldData != null && dob != null && memberId != null){
                system.debug('sni eligible or engaged  2----');
                for(ACETHouseHoldWrapper.HouseHold h:houseHoldData){
                    if(relationshipMetaData!=null && relationshipMetaData.get(h.relationship)!=null && relationshipMetaData.get(h.relationship)=='Subscriber/Recipient'){
                        houseDataTempList.add(h);
                    }
                }
                system.debug('houseDataTempList--'+houseDataTempList);
                if (houseDataTempList.size()>0) {
                        houseDataTemp.dob = houseDataTempList[0].dob;
                        houseDataTemp.firstName = houseDataTempList[0].firstName;
                        houseDataTemp.memberId = memberId;
                        houseDataTemp.fullName = houseDataTempList[0].fullName;
                        houseDataTemp.lastName = houseDataTempList[0].lastName;
                        houseDataTemp.relationship = houseDataTempList[0].relationship;
                        houseDataTemp.policyId = policyIdOrignal;
                        houseDataTemp.CHNEligibile = houseDataTempList[0].CHNEligibile==null?false:houseDataTempList[0].CHNEligibile;
                        houseDataTemp.CHNQualified = houseDataTempList[0].CHNQualified==null?false:houseDataTempList[0].CHNQualified;
                        houseDataTemp.CHNReferralIdentifier = houseDataTempList[0].CHNReferralIdentifier==null?'':houseDataTempList[0].CHNReferralIdentifier;
                    	houseDataTemp.complexIndicator = houseDataTempList[0].complexIndicator==null?'':houseDataTempList[0].complexIndicator;
                    	houseDataTemp.alternateId = houseDataTempList[0].alternateId==null?'':houseDataTempList[0].alternateId;
                    	houseDataTemp.enterpriseId = houseDataTempList[0].enterpriseId==null?'':houseDataTempList[0].enterpriseId;
                } else {
                    	houseDataTemp.dob = houseHoldData[0].dob;
                        houseDataTemp.firstName = houseHoldData[0].firstName;
                        houseDataTemp.memberId = memberId;
                        houseDataTemp.fullName = houseHoldData[0].fullName;
                        houseDataTemp.lastName = houseHoldData[0].lastName;
                        houseDataTemp.relationship = houseHoldData[0].relationship;
                        houseDataTemp.policyId = policyIdOrignal;
                        houseDataTemp.CHNEligibile = houseHoldData[0].CHNEligibile==null?false:houseHoldData[0].CHNEligibile;
                        houseDataTemp.CHNQualified = houseHoldData[0].CHNQualified==null?false:houseHoldData[0].CHNQualified;
                        houseDataTemp.CHNReferralIdentifier = houseHoldData[0].CHNReferralIdentifier==null?'':houseHoldData[0].CHNReferralIdentifier;
                    	houseDataTemp.complexIndicator = houseHoldData[0].complexIndicator==null?'':houseHoldData[0].complexIndicator;
                    	houseDataTemp.alternateId = houseHoldData[0].alternateId==null?'':houseHoldData[0].alternateId;
                    	houseDataTemp.enterpriseId = houseHoldData[0].enterpriseId==null?'':houseHoldData[0].enterpriseId;
                }

                Id familyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
                Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                 //commented below line by Ravi
             //   Account[] acc = [select id, Name, FirstName, LastName, Member_ID__c from account where  Member_ID__c =: houseDataTemp.memberId and Policy_ID__c  =: houseDataTemp.policyId]; // Also add the logic to put policy number for query
                system.debug('account acc size is-----'+acc.size());
                User[] unassignedUser = [select id from User where Name ='Unassigned'];
                User[] advisor;
                if(String.isEmpty(assignTo)){
                    advisor = unassignedUser;
                }
                // US2216710 :Below Code commented By Chandan - as we need to create SNI Not elligible family also under confirmation
                //if((sniEligibleStatus == 'engaged' || sniEligibleStatus == 'eligible') && !String.isEmpty(assignTo)){
                System.debug('sniEligibleStatus='+sniEligibleStatus);
                if(sniEligibleStatus=='false')sniEligibleStatus='not eligible';// US2216710 :Code Added By Chandan to create records for not eligible too upon confirmation by agent
                if(!String.isEmpty(assignTo)){
                    advisor = [select id, Name from User where FederationIdentifier =:assignTo];
                    if(advisor.size() == 0 || advisor == null){
                        advisor = unassignedUser;
                    }
                }

                system.debug('houseDataTemp.memberId.......'+houseDataTemp.memberId);
                if(acc.size() == 0){
                    //Family account Creation Code starts here-Chandan
                   // Account a = new Account();
                    a.Name = houseDataTemp.fullName;
                    a.Member_ID__c = houseDataTemp.memberId;
                    a.Policy_ID__c = policyIdOrignal;
                    a.Line_of_Business__c=lob;
                    a.Product_Type__c=productTypes;
                    a.Service_Group__c=serviceGroup;
                    //Bypass_LOB_Validation__c Logic Added by Chandan - to bypass the validation if its coming from service 
                    a.Bypass_LOB_Validation__c=true;//US3044661: Update API for EHUB 
                    for(String stats:eligibilityStatus){
                        if(stats.equals(sniEligibleStatus)){
                            a.Special_Needs_Status__c = stats;
                        }
                    }
                    a.RecordTypeId = familyAccRecordTypeId;
                    a.OwnerId = advisor[0].Id;
                    system.debug('houseDataTemp.CHNQualified--'+houseDataTemp.CHNQualified);
                    system.debug('houseDataTemp.CHNEligibile--'+houseDataTemp.CHNEligibile);
                    a.CHN_Eligible__c = houseDataTemp.CHNEligibile==null?false:houseDataTemp.CHNEligibile;
                   	a.CHN_Qualified__c = houseDataTemp.CHNQualified==null?false:houseDataTemp.CHNQualified;
                    a.Alternate_Id__c = houseDataTemp.alternateId==null?'':houseDataTemp.alternateId; //added by Cherry
                    //US2350839-Code Added By Chandan-Start
                    /*System.debug('isPolicyUhg!!!='+isPolicyUhg);
                    if(isPolicyUhg){
                    	a.UHG_Restriction__c	 = 'Yes';
                    }
                    else{*/
                      a.UHG_Restriction__c	 = 'No';
                     /*}
                    if(onshoreRestricted){
                        a.Onshore_Restriction__c = 'Yes';
                    } else {*/
                        a.Onshore_Restriction__c = 'No';
                    //}
                    //US2350839-Code End By Chandan
                    insert a;
                    //Family account Creation Code End here-Chandan
                     system.debug('family overview---------------');
                   	 /* create family overview */
				    Family_Overview__c famover = new Family_Overview__c(); // added by Ravi
					famover.Name = houseDataTemp.fullName+' Family Overview';
					famover.Account__c = a.id;
                    famover.Exception__c = 'No';
                    famover.Designation_Changed_Date__c = Date.today();
                    famover.Last_Active_Date__c  = Date.today();
                    //Boolean isPolicyUhg = ACETUtility.checkUHGPolicy(policyIdOrignal);
                    /*if(isPolicyUhg){
                        famover.UHG_Restriction__c	 = 'Yes';
                    }
                    else{*/
                        famover.UHG_Restriction__c	 = 'No';
                    /*}
                    if(onshoreRestricted){
                        famover.Onshore_Restriction__c = 'Yes';
                    } else {*/
                        famover.Onshore_Restriction__c = 'No';
                    //}
					insert famover;
                        /* create family overview */
                     /*create Family Story Guide **/
                    Family_Story_Guide__c fsg = new Family_Story_Guide__c();
                    fsg.Account__c = a.Id;
                    fsg.Status__c = 'Not Offered';
                    insert fsg;
                    system.debug('family overview id---------------'+famover.id);
                    /*Check in ACET*/
                    list<string> detailToSearch = new List<String>();
                    Map<String,String> serviceRelationShipMap = new Map<String,String>();
                    String familyAccId = 'SNI@'+a.Id;
                    for(ACETHouseHoldWrapper.HouseHold h:houseHoldData){
                        system.debug('check household--- '+h.firstName+'~'+h.lastName+'~-~'+h.dob+'~'+h.relationship);                       
                        newRelationval = true;
                        //Date dobirth = Date.parse(h.dob);
                        Date dobirth = ACETUtility.parseDate(h.dob);
                        detailToSearch.add(h.firstName+'~'+h.lastName+'~-~'+ACETUtility.format(dobirth)); // US3705586 : Vishal : ICU Date Format Changes.
                        relationFromService = h.relationship;
                        for(String s:relationshipMetaData.keyset()){
                            system.debug('relationship metadata---'+ s);
                            if(s != null && s.equalsIgnoreCase(h.relationship)){
                                newRelationval = false;
                                serviceRelationShipMap.put(h.firstName+'~'+h.lastName+'~-~'+ACETUtility.format(dobirth),relationshipMetaData.get(s)); // US3705586 : Vishal : ICU Date Format Changes.
                                system.debug('serviceRelationShipMap---'+serviceRelationShipMap);
                                //newServiceRelation.add(h.relationship);
                                //personAccount.Relationship__pc = s;
                            }
                            else{
                                if(!newServiceRelation.contains(relationFromService))
                                    newServiceRelation.add(relationFromService);
                            }
                            }
                            //If a new value is received in relationship then insert into the ACETServiceRelationshipMap__c Object
                            //And The ACET value will be Unknown
                            if(newRelationval){
                                ACETUtility.insertHouseholdRelationshipData(newServiceRelation);
                                serviceRelationShipMap.put(h.firstName+'~'+h.lastName+'~-~'+ACETUtility.format(dobirth),'Unknown'); // US3705586 : Vishal : ICU Date Format Changes.
                            }

                        }
                        memDetails =  memberSearchACET(detailToSearch,houseDataTemp.memberId,policyIdOrignal,familyAccId,serviceRelationShipMap,assignTo,houseHoldData,false,WoId);
                        /*Check in ACET*/
                    }else{

                        //Account a = new Account();
                        a.Id = acc[0].Id;
                        a.Line_of_Business__c=lob;
                        a.Service_Group__c=serviceGroup;
                        a.Product_Type__c=productTypes;
                        //Bypass_LOB_Validation__c Logic Added by Chandan - to bypass the validation if its coming from service 
                        a.Bypass_LOB_Validation__c=true;//US3044661: Update API for EHUB 
                        //a.OwnerId = advisor[0].Id;//US2451008:Commented by Chandan to make SNI Source of Truth
                        RecursiveTriggerHandler.nameChangeEnabled = true;//Enabling this static variable so we can bipass the name change validation on account
                        a.Name = houseDataTemp.fullName;
                        for(String stats:eligibilityStatus){
                            System.debug('stats='+stats);
                            if(stats.equals(sniEligibleStatus)){
                                a.Special_Needs_Status__c = stats;
                                System.debug('Special_Needs_Status__c='+a.Special_Needs_Status__c);
                            }
                        }
                        system.debug('houseDataTemp.CHNQualified- '+ houseDataTemp.CHNQualified);
                        a.CHN_Eligible__c = houseDataTemp.CHNEligibile==null?false:houseDataTemp.CHNEligibile;
                        a.CHN_Qualified__c = houseDataTemp.CHNQualified==null?false:houseDataTemp.CHNQualified;//added by Cherry
                        a.Alternate_Id__c = houseDataTemp.alternateId==null?'':houseDataTemp.alternateId;
                        //US2350839-Code Added By Chandan-Start
                        /*System.debug('isPolicyUhg$$$='+isPolicyUhg);
							if(isPolicyUhg){
								a.UHG_Restriction__c	 = 'Yes';
							}
                    else{*/
                        a.UHG_Restriction__c	 = 'No';
                    /*}
                    if(onshoreRestricted){
                        a.Onshore_Restriction__c = 'Yes';
                    } else {*/
                        a.Onshore_Restriction__c = 'No';
                    //}
                    //US2350839-Code End By Chandan
                    update a;
                    //Restriction Updation on Family Overview 
                     List<Family_Overview__c> familyOvervw = [SELECT ID,UHG_Restriction__c,Onshore_Restriction__c FROM Family_Overview__c Where account__c =: a.Id];
                     if(familyOvervw.size()>0 && familyOvervw[0].UHG_Restriction__c != a.UHG_Restriction__c){
                         familyOvervw[0].UHG_Restriction__c = a.UHG_Restriction__c ;
                         update familyOvervw;
                     }else if(familyOvervw.size()==0 ){
                         Family_Overview__c famover = new Family_Overview__c(); // added by Ravi
                         famover.Name = houseDataTemp.fullName+' Family Overview';
                         famover.Account__c = a.id;
                         famover.Exception__c = 'No';
                    	 famover.Designation_Changed_Date__c = Date.today();
                    	 famover.Last_Active_Date__c  = Date.today();
                         //Boolean isPolicyUhg = ACETUtility.checkUHGPolicy(policyIdOrignal);
                         /*if(isPolicyUhg){
                             famover.UHG_Restriction__c	 = 'Yes';
                         }
                         else{*/
                             famover.UHG_Restriction__c	 = 'No';
                         //}
                         if(famover != null)
                         insert famover;
                     }
		     if(familyOvervw.size()>0 && familyOvervw[0].Onshore_Restriction__c != a.Onshore_Restriction__c){
                            familyOvervw[0].Onshore_Restriction__c = a.Onshore_Restriction__c ;
                     	    update familyOvervw;
                     }
                    //
	       	 /*create Family Story Guide **/
                    List<Family_Story_Guide__c> fsgRec = [SELECT ID FROM Family_Story_Guide__c Where account__c =: a.Id];
                    if(fsgRec.size() == 0){
                    Family_Story_Guide__c fsg = new Family_Story_Guide__c();
                    fsg.Account__c = a.Id;
                    fsg.Status__c = 'Not Offered';
                    insert fsg;
                    }
                    /*create Family Story Guide **/
                        List<AccountContactRelation> accountContactList = new List<AccountContactRelation>();
                        List<AccountContactRelation> existingPolicyDetails = new List<AccountContactRelation>();
                        List<Id> conId = new List<Id>();
                        List<Account> personAccounts = new List<Account>();
                        Map<String,Account> personAccountInsertMap = new Map<String,Account>();
                        Map<String,Account> personAccountInsertDOBMap = new Map<String,Account>();
                        Map<String,AccountContactRelation> acrRelationVal =  new Map<String,AccountContactRelation>();
                        List<AccountContactRelation> insertAcrList = new List<AccountContactRelation>();
                        Map<Id,AccountContactRelation> updateAcrList = new Map <Id,AccountContactRelation>();
                        Map<Id,Account> personAccountList = new Map <Id,Account>();

                        accountContactList = [Select ContactId,accountId,Relationship__c,contact.FirstName,contact.LastName,contact.BirthDate,contact.Name,Member_ID__c,Policy_ID__c,account.Assigned_Advisor__c from AccountContactRelation where accountId =:acc[0].Id];

                        for(AccountContactRelation i:accountContactList){
                            conId.add(i.ContactId);
                            acrRelationVal.put(i.ContactId,i);
                        }
                        //To get Uhg Restriction value from the Account level to set in the memberInformation
                        existingPolicyDetails = [select id, Policy_ID__c,ContactId,Contact.AccountId,Account.UHG_Restriction__c from AccountContactRelation where ContactId in :conId ];
                        Map<Id,List<String>> mapExistingPolicyDetails = new Map<Id,List<String>>();
                        for(AccountContactRelation acr :existingPolicyDetails){
                            if(mapExistingPolicyDetails.containsKey(acr.Contact.AccountId)){
                                List<String> restictionLst = mapExistingPolicyDetails.get(acr.Contact.AccountId);
                                restictionLst.add(acr.Account.UHG_Restriction__c);
                                mapExistingPolicyDetails.put(acr.Contact.AccountId, restictionLst);
                            } else {
                                mapExistingPolicyDetails.put(acr.Contact.AccountId,new List<String>{acr.Account.UHG_Restriction__c});
                            }
                        SYstem.debug('mapExistingPolicyDetails=='+mapExistingPolicyDetails);
                        }
                        //
                        personAccounts = [Select Id,PersonContactId, FirstName, LastName, PersonBirthdate,Relationship__pc from account where PersonContactId IN :conId];
                        existingMemDetails.addAll(accountContactList);
                        if(personAccounts.size() > 0){
                            for(Account acnt: personAccounts){
                                system.debug('check---'+acnt.FirstName+acnt.LastName+acnt.Relationship__pc);
                                String rel=acrRelationVal.get(acnt.PersonContactId)!=null?acrRelationVal.get(acnt.PersonContactId).Relationship__c:'';
                                if(String.isNotBlank(rel) && acnt.PersonBirthdate!=null){
                                    personAccountInsertMap.put(acnt.FirstName.touppercase()+acnt.LastName.touppercase()+rel+acnt.PersonBirthdate,acnt);//name case conversion if the case of the name is not same as the existing member in dual policy
                                }
                                System.debug('====='+acnt.FirstName+acnt.LastName+rel+acnt.PersonBirthdate);
                                //if(acnt.PersonBirthdate!=null)
                                 //   personAccountInsertDOBMap.put(acnt.FirstName+acnt.LastName+acnt.PersonBirthdate,acnt);
                            }
                            for(ACETHouseHoldWrapper.HouseHold h:houseHoldData){
                                system.debug('houseHoldData1---'+(!String.isEmpty(h.firstName)));
                                system.debug('houseHoldData2---'+(!String.isEmpty(h.lastName)));
                                system.debug('houseHoldData3---'+(!String.isEmpty(h.relationship)));
                                system.debug('houseHoldData4---'+(date.valueOf(h.dob)!=null));
                                system.debug('houseHoldData5---'+(h.CHNReferralIdentifier));

                                newRelationval = true;
                                if(!String.isEmpty(h.firstName) && !String.isEmpty(h.lastName) && !String.isEmpty(h.relationship) && date.valueOf(h.dob)!=null){
                                    SYstem.debug('relationfromservice'+h.relationship);
                                    //Get the ACET Relationship Mapping from the ACETServiceRelationshipMap__c
                                    relationFromService = h.relationship;
                                    for(String s:relationshipMetaData.keyset()){
                                        if( s != null && s.equalsIgnoreCase(h.relationship)){
                                            newRelationval = false;
                                            h.relationship =relationshipMetaData.get(s);
                                            //newServiceRelation.add(h.relationship);
                                        }
                                        else {
                                         System.debug('existingrelation2'+h.relationship);
                                         if(!newServiceRelation.contains(relationFromService))
                                           newServiceRelation.add(relationFromService);
                                        }
                                    }
                                    //If a new value is received in relationship then insert into the ACETServiceRelationshipMap__c Object
                                    //And The ACET value will be Unknown
                                    if(newRelationval){
                                        ACETUtility.insertHouseholdRelationshipData(newServiceRelation);
                                        h.relationship = 'Unknown';
                                    }
                                    System.debug('Key='+h.firstName+h.lastName+h.relationship+date.valueOf(h.dob));
                                    system.debug(personAccountInsertMap.get(h.firstName+h.lastName+h.relationship+date.valueOf(h.dob)));
                                    System.debug('personAccountInsertMap---'+personAccountInsertMap.get(h.firstName.touppercase()+h.lastName.touppercase()+h.relationship+date.valueOf(h.dob)));
                                    accountId = 'SNI@'+a.Id;
                                    system.debug('memDetails.newMemberMatch---477--'+memDetails.newMemberMatch);
                                    if(personAccountInsertMap.get(h.firstName.touppercase()+h.lastName.touppercase()+h.relationship+date.valueOf(h.dob)) == null){

                                            Date dobirth = Date.valueOf(h.dob);
                                            memberName.add(h.firstName+'~'+h.lastName+'~-~'+ACETUtility.format(dobirth)); // US3705586 : Vishal : ICU Date Format Changes.
                                            memDetails.existingMemDetails = existingMemDetails;
                                            memDetails.memberName = memberName;
                                            memDetails.accountId = accountId;
                                            memDetails.newMemberMatch.put(h.firstName+'~'+h.lastName+'~-~'+ACETUtility.format(dobirth),existingMemDetails); // US3705586 : Vishal : ICU Date Format Changes.
                                        system.debug('memDetails.newMemberMatch---477--'+memDetails.newMemberMatch);    
                                        memDetails.nameRelationMap.put(h.firstName+'~'+h.lastName+'~-~'+ACETUtility.format(dobirth),h.relationship); // US3705586 : Vishal : ICU Date Format Changes.
                                            memDetails.isAcetSearch = 'SearchFamily';
                                            memDetails.houseHoldList = houseHoldData;

                                    }else{
										system.debug('person account matched------');
                                        Account personAccountRecord =personAccountInsertMap.get(h.firstName.touppercase()+h.lastName.touppercase()+h.relationship+date.valueOf(h.dob));
                                        personAccountRecord.PersonBirthdate = date.valueOf(H.dob);
                                        RecursiveTriggerHandler.nameChangeEnabled = true;//Enabling this static variable so we can bipass the name change validation on account
                                        personAccountRecord.firstName = h.firstName; //updated for the name change personAccountInsertMap.get(houseDataTempUpdate.firstName+houseDataTempUpdate.lastName).firstName;
                                        personAccountRecord.lastName = h.lastName; //updated for the name change personAccountInsertMap.get(houseDataTempUpdate.firstName+houseDataTempUpdate.lastName).lastName;
                                        personAccountRecord.Gender__pc = h.gender == 'F'?'Female':(h.gender == 'M'?'Male':'');
                                        personAccountRecord.PersonMailingState =h.address!=null?h.address.state:'';
                                        personAccountRecord.PersonMailingCity = h.address!=null?h.address.city:'' ;
                                        personAccountRecord.PersonMailingCountry=  h.address!=null?h.address.country:'';
                                        personAccountRecord.PersonMailingStreet =  h.address!=null?h.address.street:'';
                                        personAccountRecord.PersonMailingPostalCode = h.address!=null?h.address.zip:'';
                                        
                                        // added by Cherry - start
										personAccountRecord.CHN_Eligible__c = h.CHNEligibile==null?false:h.CHNEligibile; 
                                        personAccountRecord.CHN_Referral_Identifier__c = h.CHNReferralIdentifier==null?'':h.CHNReferralIdentifier;
                                        personAccountRecord.Complex_Indicator__c = h.complexIndicator==null?'':h.complexIndicator;
                                        personAccountRecord.CHN_Qualified__c = h.CHNQualified==null?false:h.CHNQualified;
                                        personAccountRecord.Source_Code__c = h.sourceCode!=null?h.sourceCode:'';
                                        personAccountRecord.EID__c = h.enterpriseId!=null?h.enterpriseId:'';
                                        system.debug('personAccountRecord.Source_Code__c ='+personAccountRecord.Source_Code__c);
                                        // added by Cherry - end
                                        AccountContactRelation personRelation = acrRelationVal.get(personAccountInsertMap.get(h.firstName.touppercase()+h.lastName.touppercase()+h.relationship+date.valueOf(h.dob)).PersonContactId);
                                        personRelation.Relationship__c = h.relationship ;
                                        updateAcrList.put(personRelation.id,personRelation);

                                        personAccountList.put(personAccountRecord.Id,personAccountRecord);
                                    }
                                }
                            }

                        }else if(personAccounts.size() == 0){
                            /*Check in ACET*/
                            list<string> detailToSearch = new List<String>();
                            Map<String,String> serviceRelationShipMap = new Map<String,String>();
                            String familyAccId = 'SNI@'+a.Id;
                            for(ACETHouseHoldWrapper.HouseHold h:houseHoldData){
                                newRelationval = true;
                                //Date dobirth = Date.parse(h.dob);
                                Date dobirth = ACETUtility.parseDate(h.dob);
                                /*string dobirth;
                                List<String> dateParts = h.dob.split('-');
                                Datetime dateWithTime = Datetime.newInstance(Integer.valueOf(dateParts[0]), Integer.valueOf(dateParts[1]), Integer.valueOf(dateParts[2]));
                                dobirth = dateWithTime.format('yyyy-MM-dd');*/
                                System.debug(dobirth);
                                system.debug('ACETUtility.format(dobirth)--'+ACETUtility.format(dobirth));
                                detailToSearch.add(h.firstName+'~'+h.lastName+'~-~'+ACETUtility.format(dobirth)); // US3705586 : Vishal : ICU Date Format Changes.
                                relationFromService = h.relationship;
                                for(String s:relationshipMetaData.keyset()){
                                    if(s != null && s.equalsIgnoreCase(h.relationship)){
                                        newRelationval = false;
                                        serviceRelationShipMap.put(h.firstName+'~'+h.lastName+'~-~'+ACETUtility.format(dobirth),relationshipMetaData.get(s)); // US3705586 : Vishal : ICU Date Format Changes.
                                        //newServiceRelation.add(h.relationship);
                                    }
                                    else{
                                     if(!newServiceRelation.contains(relationFromService))
                                           newServiceRelation.add(relationFromService);
                                    }
                                }
                                //If a new value is received in relationship then insert into the ACETServiceRelationshipMap__c Object
                                //And The ACET value will be Unknown
                                if(newRelationval){
                                    ACETUtility.insertHouseholdRelationshipData(newServiceRelation);
                                    serviceRelationShipMap.put(h.firstName+'~'+h.lastName+'~-~'+ACETUtility.format(dobirth),'Unknown'); // US3705586 : Vishal : ICU Date Format Changes.
                                }
                            }
                            memDetails =  memberSearchACET(detailToSearch,houseDataTemp.memberId,policyIdOrignal,familyAccId,serviceRelationShipMap,assignTo,houseHoldData,false,WoId);
                            /*Check in ACET End*/
                        }
                        if(personAccountList.size() > 0){
							system.debug('personAccountList----'+personAccountList);
                            upsert personAccountList.values();
							ACETSNIMemberInformation.createMemberInformation(personAccountList.values(),policyIdOrignal,'update',mapExistingPolicyDetails,false);
                            set<ID> pids=new set<ID>();
                            for(Account act:personAccountList.values()){
                                pids.add(act.ID);
                            }
                            memDetails.accountId = 'SNI@'+a.Id;
                            Map<String,AccountContactRelation> aConMap=new map<String,AccountContactRelation>();
                            for(AccountContactRelation acon:[Select AccountId,ContactId from AccountContactRelation
                                                             where AccountId=: a.Id]){
                                                                 aConMap.put(acon.ContactId,acon);
                                                             }

                            List<AccountContactRelation> accConRelationList=new List<AccountContactRelation>();
                            for(Account act:[select PersonContactId,FirstName,ID from account where Id in :pids]){
                                //String conId = [select PersonContactId from account where Id =:personAccount.Id].PersonContactId;
                                memDetails.accountId += '@'+act.PersonContactId;
                                If(aConMap.get(act.PersonContactId)==null){
                                    AccountContactRelation accConRelation = new AccountContactRelation();
                                    accConRelation.AccountId = a.Id;
                                    accConRelation.ContactId = act.PersonContactId;
                                    accConRelation.Relationship__c = relationShipMap.get(act.FirstName);
                                    accConRelation.Member_ID__c =houseDataTemp.memberId;
                                    accConRelation.Policy_ID__c = policyIdOrignal;
                                    accConRelationList.add(accConRelation);
                                }

                            }
                            if(accConRelationList.size()>0)
                                insert accConRelationList;
                        }
                        if(updateAcrList.size()>0){
                            update updateAcrList.values();
                        }
                    }
                }
            }
        }
        // Logic for WorkOrder comes in Related list of Person Account-- Start
        system.debug('WoId'+ WoId);
        ACETSNISaveHouseholdData.updateworkorder(WoId,a);
        system.debug('check1234');
        
        
        // Logic for WorkOrder comes in Related list of Person Account-- End
        system.debug('memdetails acetsave household data is ------'+memDetails);
        return memDetails;
    }
    public static void updateworkorder(String WoId,Account a){
        String famId;
        String pId;
        if(WoId !=null && WoId != ''){
            System.debug('workOrder Id'+ WoId);
        WorkOrder wo = [select Id,AccountId,Policy_ID__c,Member_ID__c,Date_of_Birth__c,First_Name__c,Last_Name__c from WorkOrder where id=:WoId];
        Id familyAccRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
            System.debug('Account--------'+ a);
            System.debug('Workorder--------'+ wo);
            List<Account> lstAcc = [Select id from Account where id =:a.id and Policy_ID__c=:wo.Policy_ID__c and Member_ID__c=:wo.Member_ID__c and recordtypeId=:familyAccRecordType LIMIT 1];
                
                if(!lstAcc.isEmpty())
                    famId=lstAcc[0].id;
        
        if(String.isNotBlank(famId)){
                System.debug('Family Id'+ famId);
                for(AccountContactRelation acr: [Select ContactId,accountId,Relationship__c,contact.FirstName,contact.LastName,
                                                 contact.BirthDate,contact.Name,
                                                 Member_ID__c,Policy_ID__c,Contact.AccountId from AccountContactRelation
                                                 where accountId =:famId]){
                                                     System.debug('Acrs ,'+ acr);
                                                     System.debug('Acrs ,'+ acr.contact.FirstName);
                                                     System.debug('Acrs ,'+ acr.contact.LastName);
                                                     System.debug('Acrs ,'+ acr.Contact.BirthDate);
                                                     System.debug('wo ,'+ wo.First_Name__c);
                                                     System.debug('wo ,'+ wo.Last_Name__c);
                                                     System.debug('wo ,'+ wo.Date_of_Birth__c);
                                                     if(wo.First_Name__c.equalsIgnoreCase(acr.contact.FirstName) && wo.Last_Name__c.equalsIgnoreCase(acr.contact.LastName) && wo.Date_of_Birth__c==acr.contact.BirthDate)
                                                         pId=acr.Contact.AccountId;  
                                                     
                                                 }
                System.debug('Pid'+pId);
                if(String.isNotBlank(pId)){ 
                    system.debug('work order binding');
                    wo.AccountId=pId;
                    wo.Add_Member__c = false;
                    update wo;
                }}
        }
        
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

    @AuraEnabled
    public static Boolean checkOnshoreRestriction(ACETHouseHoldWrapper.HouseHold[] houseHoldData, String groupNumber){
        //onshore restriction
		String sourceCode = '';
        String cosmosDivision = '';
        String policyId = '';
		for(Integer i=0; i< houseHoldData.size();i++){
            if(houseHoldData[i].isMainMember == true) {
                sourceCode = houseHoldData[i].sourceCode;
                cosmosDivision = houseHoldData[i].cosmosDivision;
                policyId = houseHoldData[i].policyId;
            }
        }
		List<String> restrictionLevel = new List<String>();
        String srcCode = '';
        String param = '';
        if(sourceCode == 'CO'){
            srcCode = 'MR';
            if(cosmosDivision != null && String.isNotBlank(cosmosDivision) && groupNumber != null && groupNumber != '--'){
                param = groupNumber + '_' + cosmosDivision;
            }
        } else if(sourceCode == 'CS'){
            srcCode = 'EI';
            if(policyId != null && String.isNotBlank(policyId) && groupNumber != null && groupNumber != '--'){
                String polNum = policyId;
                String grpNum = groupNumber;
                if(policyId.startsWith('0')){
                    polNum = policyId.substring(1, policyId.length());
                }
                if(groupNumber.startsWith('0')){
                    grpNum = groupNumber.substring(1, groupNumber.length());
                }
                param = polNum + '_' + grpNum;
            }
        }
        restrictionLevel = ACETUtility.getPolicyRestrictionLevel(srcCode,param); 
        if((restrictionLevel == null || restrictionLevel.size() == 0) && policyId != null && String.isNotBlank(policyId)){
            String polNum = policyId;
            if(policyId.startsWith('0')){
                polNum = policyId.substring(1, policyId.length());
            }
            param = polNum;
        	restrictionLevel = ACETUtility.getPolicyRestrictionLevel(srcCode,param); 
        }
        Boolean onshoreRestricted = false;
        if(restrictionLevel != null && restrictionLevel.size() > 0 && (restrictionLevel.contains('L7') || restrictionLevel.contains('L5') || restrictionLevel.contains('L3'))){
            onshoreRestricted = true;
        }
        return onshoreRestricted;
    }
    @AuraEnabled
    public static string SaveUpdateAcetMember(Map<String,sObject> memberDetails,String memberId, String policyId,string accountId,Map<String,string> exisRelationShip,string assignTo,ACETHouseHoldWrapper.HouseHold[] houseHoldData, String groupNumber,String WoId){
        system.debug('SaveUpdateAcetMember-------------');
		string famAccId ;
        try{
            list<string> setKeys = new list<string>();
            Map<String,string> mapRelatioshp = new Map<String,string>();
            map<string,AccountContactRelation> mapAcrs = new map<string,AccountContactRelation>();

            for(String key  : memberDetails.keySet()){
                AccountContactRelation ac = (AccountContactRelation)memberDetails.get(key);
                if(ac.Id != null){ // create new ACR records for the selected member
                    mapAcrs.put(key, ac);
                    mapRelatioshp.put(key,exisRelationShip.get(key));
                }
                else{  // Create new member and Create ACR
                    setKeys.add(key);
                }
            }
            Boolean onshoreRestricted = checkOnshoreRestriction(houseHoldData, groupNumber);
            if(setKeys.size()>0){
                ACETSNISaveHouseholdData.createNewMemACR(setKeys,memberId,policyId,accountId,exisRelationShip,assignTo,houseHoldData,onshoreRestricted,WoId,null);
            }
            if(mapAcrs.size()>0){ // Create ACR, verify meber information for existing member.
                ACETSNISaveHouseholdData.careteAcrnMembInfo(accountId,mapAcrs,mapRelatioshp,policyId,memberId,onshoreRestricted,WoId);
            }

            famAccId = accountId;

        }
        catch(exception ex){
            famAccId = 'error';
            return famAccId;
        }
        return famAccId;
    }
    @AuraEnabled
    Public Static void careteAcrnMembInfo(string famAccId,map<string,AccountContactRelation> mapAcrs,map<string,string> mapRelationshp,string policyId,String memberId, Boolean onshoreRestricted, String WoId){
      // system.debug('mapRelationshp'+mapRelationshp);
	   system.debug('careteAcrnMembInfo---');
        list<AccountContactRelation> lstAcrUpdRel = new list<AccountContactRelation>();
        set<string> setConIds = new set<string>();
        string famAid = '';
        if(famAccId != null ){
            if(famAccId.indexOf('@') > -1){
                string[] str = famAccId.split('@');
                famAid = str[1];
            }
        }
        // --Ankit---
        Account familyAcc = new Account();
            if(famAid != ''){
               familyAcc = [SELECT UHG_Restriction__c ,Id FROM Account where Id =: famAid ];
            }
        for(String key : mapAcrs.keyset()){
            AccountContactRelation acr = new AccountContactRelation();
            acr.Accountid = famAid;
            acr.contactid = mapAcrs.get(key).ContactId;
            acr.Relationship__c = mapRelationshp.get(key);
            acr.Member_ID__c=memberId;
            acr.Policy_ID__c = policyId;
            lstAcrUpdRel.add(acr);
            setConIds.add(mapAcrs.get(key).ContactId);
        }
        if(lstAcrUpdRel.size()>0){
            insert lstAcrUpdRel;
        }
        list<AccountContactRelation> existingPolicyDetails = [select id, Policy_ID__c,ContactId,Contact.AccountId,Account.UHG_Restriction__c from AccountContactRelation where ContactId in :setConIds];
        Map<Id,List<String>> mapExistingPolicyDetails = new Map<Id,List<String>>();
        for(AccountContactRelation acr :existingPolicyDetails){
            if(mapExistingPolicyDetails.containsKey(acr.Contact.AccountId)){
                List<String> restictionLst = mapExistingPolicyDetails.get(acr.Contact.AccountId);
                restictionLst.add(acr.Account.UHG_Restriction__c);
                mapExistingPolicyDetails.put(acr.Contact.AccountId, restictionLst);
            } else {
                mapExistingPolicyDetails.put(acr.Contact.AccountId,new List<String> {acr.Account.UHG_Restriction__c});
            }
        }
        if(setConIds.size() > 0 ){
            /*map<string,Account> mapPersonAccnts = new map<string,Account>();
            for(Account pAcc : [select id, firstname , lastname from Account where PersonContactid in :setConIds]){
                mapPersonAccnts.put(pAcc.id,pAcc);
            }
            if(mapPersonAccnts.size()>0){*/
			list<Account> lstPAcc = [select id, firstname , lastname,Gender__pc,PersonContactId from Account where PersonContactid in :setConIds];

			if(lstPAcc != null && lstPAcc.size()>0){
                // create member information for each person account
                //ACETSNISaveHouseholdData.verifyAndCreateMemberInformation(mapPersonAccnts,policyId,'update');
                ACETSNIMemberInformation.createMemberInformation(lstPAcc,policyId,'update',mapExistingPolicyDetails,onshoreRestricted);
            }
        }
        // --Ankit--
        ACETSNISaveHouseholdData.updateworkorder(WoId,familyAcc);

    }
    @AuraEnabled
    public static ACETHouseHoldWrapper.memberDetails SaveSearchInACET(Map<String,sObject> memberDetails,String memberId, String policyId,string accountId,Map<String,string> exisRelationShip,string assignTo,ACETHouseHoldWrapper.HouseHold[] houseHoldData, String groupNumber,String WoId){
      // System.debug('insavesearch');
        System.debug('SaveSearchInACET--------'+ WoId);
        Type idArrType = Type.forName('AccountContactRelation');
        ACETHouseHoldWrapper.memberDetails memDetailsWrapper ; //= new ACETHouseHoldWrapper.memberDetails();
        list<string> setKeys = new list<string>();
        Map<String,string> mapRelatioshp = new Map<String,string>();
        map<string,AccountContactRelation> mapAcrs = new map<string,AccountContactRelation>();
        map<string,Contact> mapMebers = new map<string,Contact>();
        for(String key  : memberDetails.keySet()){

            AccountContactRelation ac = (AccountContactRelation)memberDetails.get(key);
           System.debug('SaveSearchInACET-----ac id---'+ac.Id);
            if(ac.Id != null){ // update the existing member
                // update the existing members.. update firstnmae, lastname , dob and relationship
                mapMebers.put(key, ac.contact);
                mapAcrs.put(key, ac);
                mapRelatioshp.put(key,exisRelationShip.get(key));
               System.debug('SaveSearchInACET-----ac id---'+ac.Id);
            }
            else{
                //ACETSearch and save or return to front end

                setKeys.add(key);
                System.debug('SaveSearchInACET-----ac id---'+setKeys);
            }
        }
        Boolean onshoreRestricted = checkOnshoreRestriction(houseHoldData, groupNumber);
        if(mapMebers.size()>0){
            System.debug('SaveSearchInACET-----ac id--550-');
            memDetailsWrapper =ACETSNISaveHouseholdData.updateMembers(mapMebers,mapAcrs,mapRelatioshp,policyId,accountId,assignTo,memberId, onshoreRestricted,WoId);
            // updated the members redirect to family page. action required..
        }
        if(setKeys.size()>0){ // save or return the ACET serach results to front end. action required..
           // System.debug('SaveSearchInACET-----ac id--551-');
            memDetailsWrapper = ACETSNISaveHouseholdData.memberSearchACET(setKeys,memberId,policyId,accountId,exisRelationShip,assignTo,houseHoldData,onshoreRestricted,WoId);
        }
        return memDetailsWrapper;
    }

    @AuraEnabled
    Public Static ACETHouseHoldWrapper.memberDetails  updateMembers(map<string,Contact> mapMebers,map<string,AccountContactRelation> mapAcrs,map<string,string> mapRelationshp,string policyId,String accountId,string assignTo,String memberId, Boolean onshoreRestricted,String WoId) {
        ACETHouseHoldWrapper.memberDetails memDetailsWrapper ;
        list<contact> lstCOntact = new list<contact>();
        set<string> setConIds = new set<string>();
		// system.debug('updateMembers---------');

        for(String key : mapMebers.keyset()){
			// system.debug('updateMembers-------121--');
            string[] newMemArrt = key.split('~');
            if(newMemArrt.size() >0){
				system.debug('updateMembers-------122--');
                contact con =  mapMebers.get(key);
                con.Firstname = newMemArrt[0];
                con.Lastname = newMemArrt[1];
				system.debug('ACETUtility.formatDateFutureDate(newMemArrt[3])--'+ACETUtility.formatDateFutureDate(newMemArrt[3]));
				con.BirthDate = date.valueOf(ACETUtility.formatDateFutureDate(newMemArrt[3])) ; //date.valueOf(newMemArrt[3]);
                lstCOntact.add(con);
                setConIds.add(con.id);
            }
        }
		// system.debug('updateMembers-------123--');
        if(lstCOntact.size()>0) {
            // system.debug('updateMembers-------124--');
            RecursiveTriggerHandler.nameChangeEnabled = true;//Enabling this static variable so we can bipass the name change validation on account
            update lstCOntact;
           /* map<string,Account> mapPersonAccnts = new map<string,Account>();
            for(Account pAcc : [select id, firstname , lastname from Account where PersonContactid in :setConIds]){
                mapPersonAccnts.put(pAcc.id,pAcc);
            }
            if(mapPersonAccnts.size()>0){*/
			list<Account> lstPAcc = [select id, firstname , lastname,Gender__pc,PersonContactid from Account where PersonContactid in :setConIds];
            //To get Uhg Restriction value from the Account level to set in the memberInformation
            List<AccountContactRelation> existingPolicyDetails = [select id, Policy_ID__c,ContactId,Contact.AccountId,Account.UHG_Restriction__c from AccountContactRelation where ContactId in :setConIds ];
            Map<Id,List<String>> mapExistingPolicyDetails = new Map<Id,List<String>>();
            for(AccountContactRelation acr :existingPolicyDetails){
                if(mapExistingPolicyDetails.containsKey(acr.Contact.AccountId)){
                    List<String> restictionLst = mapExistingPolicyDetails.get(acr.Contact.AccountId);
                    restictionLst.add(acr.Account.UHG_Restriction__c);
                    mapExistingPolicyDetails.put(acr.Contact.AccountId, restictionLst);
                } else {
                    mapExistingPolicyDetails.put(acr.Contact.AccountId,new List<String> {acr.Account.UHG_Restriction__c});
                }
                SYstem.debug('mapExistingPolicyDetails=='+mapExistingPolicyDetails);
            }
            //
			if(lstPAcc != null && lstPAcc.size()>0){
                // create member information for each person account
                ACETSNIMemberInformation.createMemberInformation(lstPAcc,policyId,'update',mapExistingPolicyDetails,onshoreRestricted);
            }
        }
		// system.debug('updateMembers-------126--');
        list<AccountContactRelation> lstAcrUpdRel = new list<AccountContactRelation>();
        for(String key : mapAcrs.keyset()){
			// system.debug('updateMembers-------127--');
            AccountContactRelation acr = new AccountContactRelation();
            acr.id = mapAcrs.get(key).Id;
            acr.Relationship__c = mapRelationshp.get(key);
            acr.Member_ID__c =memberId;
            acr.Policy_ID__c = policyId;
            lstAcrUpdRel.add(acr);
        }
		// system.debug('updateMembers-------128--');
        if(lstAcrUpdRel.size()>0){
			// system.debug('updateMembers-------129--');
            update lstAcrUpdRel;
        }
        memDetailsWrapper = new ACETHouseHoldWrapper.memberDetails();
        memDetailsWrapper.accountId = accountId;
        memDetailsWrapper.assignTo = assignTo;
        system.debug('accountId-----'+accountId);
        //code added by Ankit start--
        string famiAccId = '';
            if(accountId != null ){
                if(accountId.indexOf('@') > -1){
                    string[] str = accountId.split('@');
                    famiAccId = str[1];
                }
            }
            
            Account familyAcc = new Account();
            if(famiAccId != ''){
                familyAcc = [SELECT UHG_Restriction__c ,Id FROM Account where Id =: famiAccId ];}
                ACETSNISaveHouseholdData.updateworkorder(WoId,familyAcc);
                return memDetailsWrapper;
        
                
    }
    public static ACETHouseHoldWrapper.memberDetails memberSearchACET(list<string> detailToSearch,string memberId,string policyId,string accountId,Map<String,string> exisRelationShip,string assignTo,ACETHouseHoldWrapper.HouseHold[] houseHoldData, Boolean onshoreRestricted,String WoId){
        system.debug('memberSearchACET -- 11---' + detailToSearch);
        ACETHouseHoldWrapper.memberDetails detailsFound = new ACETHouseHoldWrapper.memberDetails();
        set<string> conIds = new set<string>();
        map<string,string> conAcrIds = new map<string,string>();
        map<string,string> actKeyConvrtdKey = new map<string,string>();
        Map<String,String> householdaddress = new Map<String,String>();
        for(ACETHouseHoldWrapper.HouseHold h:houseHoldData){
            //h.dob = h.dob.replace('/0', '/');
            
            //Date dobdate = date.valueOf(h.dob);
            //String contactDob = (dobdate).format();
            Date dobirth = ACETUtility.parseDate(h.dob);
	
            householdaddress.put(h.firstName+'~'+h.lastName+'~'+ACETUtility.formatStrict(dobirth),h.address.street+'~'+h.address.city+'~'+h.address.state+'~'+h.address.zip);
        }
        for(string acr : detailToSearch){
            string[] strKeys = acr.split('~');
            actKeyConvrtdKey.put(acr, strKeys[0].touppercase()+'~'+strKeys[1].touppercase()+'~-~'+strKeys[3]);
            if(strKeys.size() > 0 ){
                 system.debug('memberSearchACET -- 122---');
                // All the punctuations excluded for the SOSL as it doesnot allow them ~!@#$%^*()_+|}{":?><`=;/.,][-\'\\
                String frstName = strKeys[0].replaceAll('\\p{Punct}','');
                String lstName = strKeys[1].replaceAll('\\p{Punct}','');
                String searchName = frstName+' '+lstName;
                String searchQuery = 'FIND \'' + searchName + '\' IN NAME FIELDS RETURNING Contact(Id,FirstName,LastName )';
                List<List<SObject>> searchList =search.query(searchQuery);
                system.debug('searchList---948--'+searchList);
                Contact [] contacts = ((List<Contact>)searchList[0]);
                for(Contact cc : contacts){
                    conIds.add(cc.id);
                    conAcrIds.put(cc.id,acr);
                }
            }
        }
        system.debug('conIds--956'+conIds);
        system.debug('conAcrIds--957--'+conAcrIds);
        system.debug('memberSearchACET -- 123---');
        list<AccountContactRelation> accountContactList = [Select ContactId,accountId,Relationship__c,contact.FirstName,contact.LastName,contact.BirthDate,contact.Name,Member_ID__c,Policy_ID__c,account.Assigned_Advisor__c from AccountContactRelation where contactId IN : conIds ];
        system.debug('accountContactList---960--'+accountContactList);
        set<id> contid =new set<id>();
        for(AccountContactRelation con: accountContactList){
         contid.add(con.ContactId);
        }
        list<contact> contactlist = [Select id,FirstName,LastName,BirthDate,account.PersonMailingState,account.PersonMailingCity,account.PersonMailingCountry,account.PersonMailingStreet,account.PersonMailingPostalCode from contact where id IN : contid];
        system.debug('contactlist---966--'+contactlist);
        list<AccountContactRelation> tempAcrList;
        list<AccountContactRelation> PersonMatchAcrList;
        Map<String,List<AccountContactRelation>> newMemberMatchLocal = new Map<String,List<AccountContactRelation>>();
        Map<String,String> PersonMatchAcrMap = new Map<String,String>();
        Map<String,String> peraddress = new Map<String,String>();
        for(contact h:contactlist){
            datetime dt = h.BirthDate;
            String sampleDate = dt.formatGMT('MM/dd/yyyy');
            system.debug('sampleDate'+sampleDate);
            //String contactDob = h.BirthDate.month()+'/'+h.BirthDate.day()+'/'+h.BirthDate.year();
            
            peraddress.put(h.firstName+'~'+h.lastName+'~'+sampleDate,h.account.PersonMailingStreet+'~'+h.account.PersonMailingCity+'~'+h.account.PersonMailingState+'~'+h.account.PersonMailingPostalCode);
        }

        if(accountContactList != null && accountContactList.size()>0){
           system.debug('memberSearchACET -- 125---');
            for(AccountContactRelation curAcr : accountContactList){
                String contactDob = ACETUtility.format(curAcr.contact.BirthDate); // US3705586 : Vishal : ICU Date Format Changes.
                
                string keyStr =  (curAcr.contact.FirstName).toUppercase()+'~'+(curAcr.contact.LastName).toUppercase()  +'~-~'+contactDob;
                if(conAcrIds.containskey(curAcr.ContactId)){
                    if(conAcrIds.get(curAcr.ContactId) != null){
                       // string[] curKeySplt = conAcrIds.get(curAcr.ContactId).split(' ');
                       // string curKey = curKeySplt[0].toUppercase()+' '+curKeySplt[1].toUppercase()   +' - '+curKeySplt[3];
                       system.debug('actKeyConvrtdKey---991--'+actKeyConvrtdKey);
                       if(actKeyConvrtdKey.get(conAcrIds.get(curAcr.ContactId)) == keyStr){
                       // if(curKey == keyStr){
                            //string actKey =  curAcr.contact.FirstName+' '+curAcr.contact.LastName +' - '+contactDob;
                            if(newMemberMatchLocal.containsKey(conAcrIds.get(curAcr.ContactId))){
                                system.debug('newMemberMatchLocal---'+newMemberMatchLocal);
                                newMemberMatchLocal.get(conAcrIds.get(curAcr.ContactId)).add(curAcr);
                            }
                            else{
                                datetime dt1 = curAcr.contact.BirthDate;
                                String sampleDate1 = dt1.formatGMT('MM/dd/yyyy');
                                //householdaddress
                                //curAcr
                                //String addressper = curAcr.account.PersonMailingStreet+'~'+curAcr.account.PersonMailingCity+'~'+curAcr.account.PersonMailingState+'~'+curAcr.account.PersonMailingPostalCode;
                                String namedobper = curAcr.contact.FirstName+'~'+curAcr.contact.LastName+'~'+sampleDate1;
                                
                                system.debug('peraddress'+peraddress);
                                system.debug('householdaddress'+householdaddress);
                                //system.debug('addressper1'+addressper);
                                system.debug('namedobper1'+namedobper);

                                if(householdaddress.containsKey(namedobper) && peraddress.containsKey(namedobper)){
                                    system.debug('householdaddress1'+householdaddress.get(namedobper));
                                    system.debug('peraddress1'+peraddress.get(namedobper));
                                    //system.debug('addressper'+addressper);
                                    if(householdaddress.get(namedobper) == peraddress.get(namedobper)){
                                         system.debug('test111:'+curAcr.ContactId);
                                     PersonMatchAcrMap.put(conAcrIds.get(curAcr.ContactId),curAcr.ContactId); 
                                    }
                                newMemberMatchLocal.put(conAcrIds.get(curAcr.ContactId), new list<AccountContactRelation>{curAcr});
                                system.debug('test1');
                                }
                                
                          }
                        }
                    }
                }
            }

        }
        system.debug('PersonMatchAcrMap-->'+PersonMatchAcrMap);
        system.debug('newMemberMatchLocal-->'+newMemberMatchLocal);
     if(newMemberMatchLocal.size() >0){
                list<string> lstMemKey = new list<string>();
                for(string key : detailToSearch){
                   
                   /* if(PersonMatchAcrMap.containsKey(key)){
                        
                        newMemberMatchLocal.remove(key);
                    }*/
                    if(!newMemberMatchLocal.containsKey(key) || PersonMatchAcrMap.containsKey(key)){
                        lstMemKey.add(key);
                    }
                }
              system.debug('createNewMemACR -- 55---'+lstMemKey);
             if(lstMemKey.size()>0){
                 system.debug('createNewMemACR -- 55---');
                ACETSNISaveHouseholdData.createNewMemACR(lstMemKey,memberId,policyId,accountId,exisRelationShip,assignTo,houseHoldData,onshoreRestricted,WoId,PersonMatchAcrMap);
             }
            
            }else{
               system.debug('createNewMemACR -- 66---');
                ACETSNISaveHouseholdData.createNewMemACR(detailToSearch,memberId,policyId,accountId,exisRelationShip,assignTo,houseHoldData,onshoreRestricted,WoId,null);
            }
        
        for(String addressmatch : PersonMatchAcrMap.keySet()){
         newMemberMatchLocal.remove(addressmatch);   
        }
        detailsFound.newMemberMatch = newMemberMatchLocal;
        detailsFound.nameRelationMap = exisRelationShip;
        detailsFound.accountId = accountId;
        detailsFound.memberId = memberId;
        detailsFound.policyId = policyId;
        detailsFound.assignTo = assignTo;
        detailsFound.houseHoldList = houseHoldData;
        //boolean Addr = addressSearchACET(memberId,accountContactList,houseHoldData);
        //system.debug('Addr'+Addr);
        if(newMemberMatchLocal.size()>0)
            detailsFound.isAcetSearch = 'SearchACET';
        return detailsFound;
    }

    Public Static void createNewMemACR(list<string> detailToSearch,string memberId,string policyId,string accountId,Map<String,string> exisRelationShip,string assignTo,ACETHouseHoldWrapper.HouseHold[] houseHoldData, Boolean onshoreRestricted,String WoId,Map<String,String> addressMatch) {
        Map<Id,List<String>> mapExistingPolicyDetails = new Map<Id,List<String>>();
        User[] unassignedUser = [select id from User where Name ='Unassigned'];
        User[] advisor;
        if(String.isEmpty(assignTo)){
            advisor = unassignedUser;
        }
        if(!String.isEmpty(assignTo)){
            advisor = [select id, Name from User where FederationIdentifier =:assignTo];
            if(advisor.size() == 0 || advisor == null){
                advisor = unassignedUser;
            }
        }
        //system.debug('createNewMemACR--advisor--'+advisor[0]);

        /*Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        List<Account> personAccountList = new List<Account>();
        List<String> addressMatchList = new List<String>();
        for(string key : detailToSearch){
            Boolean addressnotMached = false;
            if (addressMatch != null) {
                if (addressMatch.containsKey(key)){
                    addressMatchList.add(addressMatch.get(key));
                }else{
                    addressnotMached = true;
                    
                }   
            }else{
             addressnotMached = true;
            }
            if(addressnotMached){
            string[] strKeys = key.split('~');
            Account personAccount = new Account();
            personAccount.firstName = strKeys[0];
            personAccount.lastName = strKeys[1];
            personAccount.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate(strKeys[3]));
            personAccount.RecordTypeId = personAccRecordTypeId;
            for(ACETHouseHoldWrapper.HouseHold h:houseHoldData){
                if(h.firstName.equals(strKeys[0])){
                    personAccount.PersonMailingState = h.address!=null?h.address.state:'';
                    personAccount.PersonMailingCity = h.address!=null?h.address.city:'' ;
                    personAccount.PersonMailingCountry=  h.address!=null?h.address.country:'';
                    personAccount.PersonMailingStreet =  h.address!=null?h.address.street:'';
                    personAccount.PersonMailingPostalCode = h.address!=null?h.address.zip:'';
                    personAccount.Gender__pc = h.gender == 'F'?'Female':(h.gender == 'M'?'Male':'');
                }
            }
            personAccountList.add(personAccount);
            }
        }
        */
        //system.debug('createNewMemACR--advisor- 111-');
        
        Personacc Personacc = ACETSNISaveHouseholdData.createNewMemACR1(detailToSearch,memberId,policyId,accountId,exisRelationShip,assignTo,houseHoldData,onshoreRestricted, WoId,addressMatch);
        List<Account> personAccountList = new List<Account>();
        List<String> addressMatchList = new List<String>();
        personAccountList = Personacc.personAccountList;
        addressMatchList =  Personacc.addressMatchList;
        map<string,account> mapPersonAccnts = new map<string,account>();
        if(personAccountList.size()>0){
           // system.debug('createNewMemACR--advisor- 222-');
           system.debug('personAccountList'+personAccountList);
            insert personAccountList;
            for(Account act:personAccountList){
                mapPersonAccnts.put(act.id,act);
            }
        }
            //List<AccountContactRelation> accConRelationList=new List<AccountContactRelation>();
            string famiAccId = '';
            system.debug('accountId'+accountId);
            if(accountId != null ){
                if(accountId.indexOf('@') > -1){
                    string[] str = accountId.split('@');
                    famiAccId = str[1];
                }
            }
            system.debug('famiAccIdfamiAccId'+famiAccId);
            // system.debug('createNewMemACR--advisor- 333---famiAccId----'+famiAccId);
            //  Ankit
            /*Account familyAcc = new Account();
            if(famiAccId != ''){
               familyAcc = [SELECT UHG_Restriction__c ,Id FROM Account where Id =: famiAccId ];
                // system.debug('createNewMemACR--advisor- 444------');
               if(personAccountList.size()>0){
                for(Account act:[select PersonContactId,FirstName,ID,LastName,PersonBirthDate from account where Id in :mapPersonAccnts.keyset()]){
                    String pDob = ACETUtility.format(act.PersonBirthDate);
                    string keyStr =  act.FirstName+'~'+act.LastName   +'~-~'+pDob;

                    AccountContactRelation accConRelation = new AccountContactRelation();
                    accConRelation.AccountId = famiAccId;
                    accConRelation.ContactId = act.PersonContactId;
                    accConRelation.Relationship__c =  exisRelationShip.get(keyStr);   //relationShipMap.get(act.FirstName); need to fix this.
                    accConRelation.Member_ID__c = memberId;
                    accConRelation.Policy_ID__c = policyId;
                    accConRelationList.add(accConRelation);
                    //To get Uhg Restriction value from the Account level to set in the memberInformation
                    mapExistingPolicyDetails.put(act.Id,new List<String> {familyAcc.UHG_Restriction__c});
                    System.debug('mapExistingPolicyDetails=='+mapExistingPolicyDetails);
                }
               }
                if(addressMatchList.size()>0){
                for(contact act:[ Select id,FirstName,LastName,BirthDate from contact where Id in :addressMatchList]){
                    
                    String pDob = ACETUtility.format(act.BirthDate);
                    string keyStr =  act.FirstName+'~'+act.LastName   +'~-~'+pDob;
                    system.debug('keyStrkeyStr'+keyStr);
                    AccountContactRelation accConRelation = new AccountContactRelation();
                    accConRelation.AccountId = famiAccId;
                    accConRelation.ContactId = act.id;
                    accConRelation.Relationship__c =  exisRelationShip.get(keyStr);   //relationShipMap.get(act.FirstName); need to fix this.
                    accConRelation.Member_ID__c = memberId;
                    accConRelation.Policy_ID__c = policyId;
                    accConRelationList.add(accConRelation);
                    //To get Uhg Restriction value from the Account level to set in the memberInformation
                    mapExistingPolicyDetails.put(act.Id,new List<String> {familyAcc.UHG_Restriction__c});
                    //System.debug('mapExistingPolicyDetails=='+mapExistingPolicyDetails);
                }
                }
            }
            //system.debug('createNewMemACR--advisor- 555------');
            if(accConRelationList.size()>0){
               // system.debug('createNewMemACR--advisor- 666------');
                insert accConRelationList;

            }*/
            
            Account familyAcc = ACETSNISaveHouseholdData.createNewMemACRupd(detailToSearch,memberId,policyId,accountId,exisRelationShip,assignTo,houseHoldData,onshoreRestricted, WoId,addressMatch,famiAccId,mapPersonAccnts,mapExistingPolicyDetails,personAccountList,addressMatchList);           
            //(list<string> detailToSearch,string memberId,string policyId,string accountId,Map<String,string> exisRelationShip,string assignTo,ACETHouseHoldWrapper.HouseHold[] houseHoldData, Boolean onshoreRestricted,String WoId,Map<String,String> addressMatch,String famiAccId,map<string,account> mapPersonAccnts,Map<Id,List<String>> mapExistingPolicyDetails)
            if(personAccountList.size()>0){
                //system.debug('createNewMemACR--advisor- 7777------');
                ACETSNIMemberInformation.createMemberInformation(personAccountList,policyId,'insert', mapExistingPolicyDetails,onshoreRestricted); // create member information for each person account
            
            //--Ankit-- This should be executed at last
            ACETSNISaveHouseholdData.updateworkorder(WoId,familyAcc);
            }
        
    }
    
    Public Static Personacc createNewMemACR1(list<string> detailToSearch,string memberId,string policyId,string accountId,Map<String,string> exisRelationShip,string assignTo,ACETHouseHoldWrapper.HouseHold[] houseHoldData, Boolean onshoreRestricted,String WoId,Map<String,String> addressMatch) {
        
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        List<Account> personAccountList = new List<Account>();
        List<String> addressMatchList = new List<String>();
        
        //Cherry - creating a map to avoid nested for
        Map<String, ACETHouseHoldWrapper.HouseHold> mapMemberAndDetails = new Map<String, ACETHouseHoldWrapper.HouseHold>();
        for(ACETHouseHoldWrapper.HouseHold h:houseHoldData){
            if(!mapMemberAndDetails.containsKey(h.UniqueIdentifier)) {
                mapMemberAndDetails.put(h.UniqueIdentifier, h);
            }
        }
        
        for(string key : detailToSearch){
            system.debug('keyyy--'+key);
            Boolean addressnotMached = false;
            if (addressMatch != null) {
                if (addressMatch.containsKey(key)){
                    addressMatchList.add(addressMatch.get(key));
                }else{
                    addressnotMached = true;
                    
                }   
            }else{
                addressnotMached = true;
            }
            if(addressnotMached){
                ACETHouseHoldWrapper.HouseHold HH = mapMemberAndDetails.get(key);
                system.debug('HH---'+HH);
                string[] strKeys = key.split('~');
                Account personAccount = new Account();
                //personAccount = ACETSNISaveHouseholdData.createNewMemACRHouse(houseHoldData,strKeys[0]); //Cherry - commented because this was unnecessary nested for loop
                personAccount.firstName = strKeys[0];
                personAccount.lastName = strKeys[1];
                personAccount.PersonBirthdate = date.valueOf(ACETUtility.formatDateFutureDate(strKeys[3]));
                personAccount.RecordTypeId = personAccRecordTypeId;
                personAccount.CHN_Eligible__c = (HH.CHNEligibile) == null? false: HH.CHNEligibile;
                personAccount.CHN_Referral_Identifier__c =  (HH.CHNReferralIdentifier) == null? '': HH.CHNReferralIdentifier;
                personAccount.Complex_Indicator__c =  (HH.complexIndicator) == null? '': HH.complexIndicator;
                personAccount.CHN_Qualified__c = (HH.CHNQualified) == null? false: HH.CHNQualified;
                personAccount.Gender__pc = (HH.gender) == 'F'?'Female':((HH.gender) == 'M'?'Male':'');
                personAccount.Source_Code__c = HH.sourceCode;
                personAccount.EID__c = HH.enterpriseId;
                system.debug('personAccount.CHN_Referral_Identifier__c--'+personAccount.CHN_Referral_Identifier__c);
                
                switch on HH.address.zip {
                    when null {
                        personAccount.PersonMailingState = '';
                        personAccount.PersonMailingCity = '';
                        personAccount.PersonMailingCountry=  '';
                        personAccount.PersonMailingStreet =  '';
                        personAccount.PersonMailingPostalCode = '';   
                    }
                    when else {
                        personAccount.PersonMailingState = HH.address.state;
                        personAccount.PersonMailingCity = HH.address.city;
                        personAccount.PersonMailingCountry=  HH.address.country;
                        personAccount.PersonMailingStreet =  HH.address.street;
                        personAccount.PersonMailingPostalCode = HH.address.zip;
                        
                    }
                }  
                personAccountList.add(personAccount);
            }
        }
        Personacc Personacc = new Personacc();
        Personacc.addressMatchList =addressMatchList;
        Personacc.personAccountList =personAccountList;
        return Personacc;
    }
    
   /* Public Static account createNewMemACRHouse(ACETHouseHoldWrapper.HouseHold[] houseHoldData,String strKeys) {
        Account personAccount = new Account();
        for(ACETHouseHoldWrapper.HouseHold h:houseHoldData){
            if(h.firstName.equals(strKeys)){
                switch on h.address.zip {
                    when null {
                        personAccount.PersonMailingState = '';
                        personAccount.PersonMailingCity = '';
                        personAccount.PersonMailingCountry=  '';
                        personAccount.PersonMailingStreet =  '';
                        personAccount.PersonMailingPostalCode = '';   
                    }
                    when else {
                        personAccount.PersonMailingState = h.address.state;
                        personAccount.PersonMailingCity = h.address.city;
                        personAccount.PersonMailingCountry=  h.address.country;
                        personAccount.PersonMailingStreet =  h.address.street;
                        personAccount.PersonMailingPostalCode = h.address.zip;
                        
                    }
                }
                personAccount.CHN_Eligible__c = h.CHNEligibile==null?false:h.CHNEligibile;
personAccount.CHN_Referral_Identifier__c = h.CHNReferralIdentifier==null?'':h.CHNReferralIdentifier;
system.debug('personAccount.CHN_Referral_Identifier__c--'+personAccount.CHN_Referral_Identifier__c);
personAccount.CHN_Qualified__c = h.CHNQualified==null?false:h.CHNQualified;

            }
            
            //personAccount.Gender__pc = h.gender == 'F'?'Female':(h.gender == 'M'?'Male':'');
            personAccount.Source_Code__c = h.sourceCode;
            
        }
        return personAccount;
    }*/
    
    public static Account createNewMemACRupd(list<string> detailToSearch,string memberId,string policyId,string accountId,Map<String,string> exisRelationShip,string assignTo,ACETHouseHoldWrapper.HouseHold[] houseHoldData, Boolean onshoreRestricted,String WoId,Map<String,String> addressMatch,String famiAccId,map<string,account> mapPersonAccnts,Map<Id,List<String>> mapExistingPolicyDetails,List<Account> personAccountList,List<String> addressMatchList){ 
        
        //List<Account> personAccountList = new List<Account>();
        //List<String> addressMatchList = new List<String>();
        //map<string,account> mapPersonAccnts = new map<string,account>();
        
        Account familyAcc = new Account();
        List<AccountContactRelation> accConRelationList=new List<AccountContactRelation>();
        if(famiAccId != ''){
            familyAcc = [SELECT UHG_Restriction__c ,Id FROM Account where Id =: famiAccId ];
            
            if(personAccountList.size()>0){
                for(Account act:[select PersonContactId,FirstName,ID,LastName,PersonBirthDate from account where Id in :mapPersonAccnts.keyset()]){
                    String pDob = ACETUtility.format(act.PersonBirthDate); // US3705586 : Vishal : ICU Date Format Changes.
                    string keyStr =  act.FirstName+'~'+act.LastName   +'~-~'+pDob;
                    
                    AccountContactRelation accConRelation = new AccountContactRelation();
                    accConRelation.AccountId = famiAccId;
                    accConRelation.ContactId = act.PersonContactId;
                    accConRelation.Relationship__c =  exisRelationShip.get(keyStr);   //relationShipMap.get(act.FirstName); need to fix this.
                    accConRelation.Member_ID__c = memberId;
                    accConRelation.Policy_ID__c = policyId;
                    accConRelationList.add(accConRelation);
                    //To get Uhg Restriction value from the Account level to set in the memberInformation
                    mapExistingPolicyDetails.put(act.Id,new List<String> {familyAcc.UHG_Restriction__c});
                    System.debug('mapExistingPolicyDetails=='+mapExistingPolicyDetails);
                }
            }
            
            
            
            
            if(addressMatchList.size()>0){
                for(contact act:[ Select id,FirstName,LastName,BirthDate from contact where Id in :addressMatchList]){
                    
                    String pDob = ACETUtility.format(act.BirthDate);// US3705586 : Vishal : ICU Date Format Changes.
                    string keyStr =  act.FirstName+'~'+act.LastName   +'~-~'+pDob;
                    system.debug('keyStrkeyStr'+keyStr);
                    AccountContactRelation accConRelation = new AccountContactRelation();
                    accConRelation.AccountId = famiAccId;
                    accConRelation.ContactId = act.id;
                    accConRelation.Relationship__c =  exisRelationShip.get(keyStr);   //relationShipMap.get(act.FirstName); need to fix this.
                    accConRelation.Member_ID__c = memberId;
                    accConRelation.Policy_ID__c = policyId;
                    accConRelationList.add(accConRelation);
                    //To get Uhg Restriction value from the Account level to set in the memberInformation
                    mapExistingPolicyDetails.put(act.Id,new List<String> {familyAcc.UHG_Restriction__c});
                    //System.debug('mapExistingPolicyDetails=='+mapExistingPolicyDetails);
                }
            }
        }
        if(accConRelationList.size()>0){
            // system.debug('createNewMemACR--advisor- 666------');
            insert accConRelationList;
            
        }
        return familyAcc;
    }
    
    public class Personacc{
        List<String> addressMatchList;
        List<Account> personAccountList;
    }
    
}