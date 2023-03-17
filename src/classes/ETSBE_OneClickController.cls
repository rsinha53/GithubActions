public with sharing class ETSBE_OneClickController {
    @AuraEnabled
    public static SAEHouseHoldController.SearchResultWrapper getHouseHoldData(String transactionId){
        SAEHouseHoldController.SearchResultWrapper response = (SAEHouseHoldController.SearchResultWrapper)SAEHouseHoldController.SearchResultWrapper.getHouseHoldMembers(transactionId);
         
        return response;
    }
	private static Map <String, String> getRequestParamMap(ACET_ProviderSearchCtrl.ProviderDetails providerDetails,SAEMemberProviderDetail.MemberDetails memberDetails){
        Map < String, String > requestParamsMap = new Map < String, String > ();
      system.debug('////////////'+providerDetails);        
        if(providerDetails == null|| providerDetails.isProviderNotFound || providerDetails.isNoProviderToSearch || providerDetails.isOther) {
            
            requestParamsMap.put('providerLastName', System.Label.SAEProviderLastName);
            requestParamsMap.put('providerFirstName', '');
            requestParamsMap.put('providerNameID', System.Label.SAEProviderNameID);
            requestParamsMap.put('taxIdNumber', System.Label.SAEProviderTaxIdNumber);
            
        } else {
            
            requestParamsMap.put('providerLastName', String.isNotBlank(providerDetails.lastName) ? providerDetails.lastName : '');
            requestParamsMap.put('providerFirstName', String.isNotBlank(providerDetails.firstName) ? providerDetails.firstName : '');
            requestParamsMap.put('providerNameID', String.isNotBlank(providerDetails.providerId) ? providerDetails.providerId : '');
            requestParamsMap.put('taxIdNumber', String.isNotBlank(providerDetails.taxId) ? providerDetails.taxId : '');
        }               
        
        requestParamsMap.put('searchOption', String.isNotBlank(memberDetails.searchOption) ? memberDetails.searchOption : '');
        
         requestParamsMap.put('memberId',memberDetails.memberId);
        requestParamsMap.put('firstName', String.isNotBlank(memberDetails.firstName) ? memberDetails.firstName : '');
        requestParamsMap.put('lastName', String.isNotBlank(memberDetails.lastName) ? memberDetails.lastName : '');
        requestParamsMap.put('dateOfBirth', String.isNotBlank(memberDetails.memberDOB) ? memberDetails.memberDOB : '');
        requestParamsMap.put('groupNumber', String.isNotBlank(memberDetails.groupNumber) ? memberDetails.groupNumber : '');
        requestParamsMap.put('payerID', String.isNotBlank(memberDetails.payerId) ? memberDetails.payerId : '');
        requestParamsMap.put('serviceStart', String.isNotBlank(memberDetails.serviceStart) ? memberDetails.serviceStart : '');
        requestParamsMap.put('serviceEnd', String.isNotBlank(memberDetails.serviceEnd) ? memberDetails.serviceEnd : '');     
        
        
        return requestParamsMap;
    }
    @AuraEnabled
      public static SubjectCardSearchResultWrapper getElibilityMockData(String memberId, String memberDOB,String firstName, String lastName, String groupNumber,String searchOption, String payerID, String providerLastName, String providerFirstName, String npi, String providerFlow, String taxId, String providerId){
      SAEMemberProviderDetail.MemberDetails md = new SAEMemberProviderDetail.MemberDetails();
        md.memberId = memberId;
        md.memberDOB = memberDOB;
        md.firstName = firstName;
        md.lastName = lastName;
        md.searchOption = searchOption;
        md.payerID= payerID;
        md.isFourthCallout = false;
        ACET_ProviderSearchCtrl.ProviderDetails providerDetails =new ACET_ProviderSearchCtrl.ProviderDetails ();
        providerDetails.isNoProviderToSearch =true;
        providerDetails.isProviderNotFound =true;
        providerDetails.isOther=true;
          Map < String, String > requestParamsMap = new Map < String, String > ();
        
        requestParamsMap = getRequestParamMap(providerDetails, md); 
        
        md.memberDOB = SAEUtils.formatDateRequest(md.memberDOB);
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = 'LinkEligibilityMemberSearch';
        wsCallOutFW.requestParamsMap = requestParamsMap;
        wsCallOutFW.encodeURLParameters = true;        
        HttpResponse response = wsCallOutFW.getResponse();
        
        //US3076045 - Ends
        
        ACETWSCalloutResult calloutResult = SAEGetMemberProviderWebService.processResponse(response);
        //ACETWSCalloutResult CalloutResult =   (ACETWSCalloutResult) SAEMemberProviderDetail.getElibilityMockData(md,providerDetails);
          SubjectCardSearchResultWrapper dataWrap = new SubjectCardSearchResultWrapper();
        dataWrap.resultWrapper = null;
        dataWrap.message = CalloutResult.Message;
        dataWrap.statusCode = CalloutResult.statusCode;
        return dataWrap;
      }
    @AuraEnabled
    public static List<String> getOtherOriginatorDropdown(){
    	List<String> dropdownResults = new List<String>();
		Schema.DescribeFieldResult F = One_Click_Originator__c.Other_Originator_Type__c.getDescribe();
		Schema.sObjectField T = F.getSObjectField();
		List<PicklistEntry> entries = T.getDescribe().getPicklistValues();
		for(Integer i = 0; i < entries.size(); i++){
			dropdownResults.add(entries[i].Label);
		}
		return dropdownResults;
    }
    
    @AuraEnabled 
    public static user getUser(){
       system.debug('inside getuser');
      User oUser = [select id,Name,Agent_Type__c,Profile_Name__c,ProfileId,Role_Name__c, BEO_Specialty__c,UHG_Access__c FROM User Where id =: userInfo.getUserId()];
        system.debug('oUser:: '+oUser);
        
        return oUser;
    }    
    
    @AuraEnabled
    public static String correctTimezone(String eventDate){
    	String correctedDate = '';
    	System.debug('RECEIVED DATETIME: ' + eventDate);
    	String evtDate = '';
    	String evtTime = '';
    	if(eventDate.contains('T')){
	    	evtDate = eventDate.split('T')[0];
	    	evtTime = eventDate.split('T')[1];
    	}
    	System.debug('RECEIVED DATE: ' + evtDate);
    	System.debug('RECEIVED TIME: ' + evtTime);
    	Date targetDate = Date.newInstance(integer.valueof(evtDate.split('-')[0]),integer.valueof(evtDate.split('-')[1]),integer.valueof(evtDate.split('-')[2]));
    	Time targetTime = Time.newInstance(integer.valueof(evtTime.split(':')[0]),integer.valueof(evtTime.split(':')[1]),0,0);
		Datetime targetDatetime = Datetime.newInstanceGmt(targetDate, targetTime);
    	correctedDate = targetDatetime.format('yyyy-MM-dd\'T\'HH:mm:ss');
    	System.debug('RETURNED DATE: ' + correctedDate);
    	return correctedDate;
    }
   @AuraEnabled(cacheable=true) 
    // String payerID - US1944108
    public static SAEMemberProviderDetail.SubjectCardSearchResultWrapper subjectCardPopulation(String memberId,String memberDOB,String memberFN, String memberLN, String memberGrpN, String searchOption, String payerID) {
      ACET_ProviderSearchCtrl.ProviderDetails providerDetails =new ACET_ProviderSearchCtrl.ProviderDetails ();
        providerDetails.isNoProviderToSearch =true;
        providerDetails.isProviderNotFound =true;
        providerDetails.isOther=true;
        SAEMemberProviderDetail.MemberDetails md = new SAEMemberProviderDetail.MemberDetails();
        md.memberId = memberId;
        md.memberDOB = memberDOB;
        md.firstName = memberFN;
        md.lastName = memberLN;
        md.searchOption = searchOption;
        md.payerID= payerID;
        md.isFourthCallout = false;
        SAEMemberProviderDetail.SubjectCardSearchResultWrapper wrapper = SAEMemberProviderDetail.subjectCardPopulation(md, providerDetails);
		return      wrapper;   
    }
    @AuraEnabled
    public static List<One_Click_Originator__c> findOriginator(String searchField){
        List<One_Click_Originator__c> results = new List<One_Click_Originator__c>();
        String query = '';
        System.debug('HERE IS THE SEARCH FIELD: ' + searchField);
        searchField = searchField.trim();
        if(searchField != ''){
        	System.debug('HERE IS THE SEARCH FIELD1: ' + searchField);
            if(searchField.contains('-')){
            	System.debug('HERE IS THE SEARCH FIELD2: ' + searchField);
                String numericText = searchField.substring(0, 3);
                System.debug('HERE IS THE SEARCH FIELD3: ' + numericText);
                if(numericText.isNumeric()){
                	System.debug('HERE IS THE SEARCH FIELD4: ' + searchField);
                    searchField = searchField.replaceAll('-', '');
                    System.debug('HERE IS THE SEARCH FIELD5: ' + searchField);
                }
            }
            if(searchField.contains(',')){
                List<String> nameSplit = searchField.split(',');
                System.debug('HERE IS THE NAMESPLIT1: ' + nameSplit);
                if(nameSplit.size() >= 2){
                    query = 'SELECT Id,First_Name__c,Last_Name__c,Phone_Number__c,Email__c,Phone_Ext__c,Originator_Type__c,Agency_Broker_Name__c,Reward_Account_Number__c,General_Agency__c,Franchise_Code__c,Group_Name__c,Group_Number__c,Policy_Number__c,Other_Originator_Type__c,Originator_Role__c FROM One_Click_Originator__c WHERE First_Name__c LIKE \'%' + String.escapeSingleQuotes(nameSplit[1].trim()) + '%\' AND Last_Name__c LIKE \'%' + String.escapeSingleQuotes(nameSplit[0].trim()) + '%\'';
                } else {
                    query = 'SELECT Id,First_Name__c,Last_Name__c,Phone_Number__c,Email__c,Phone_Ext__c,Originator_Type__c,Agency_Broker_Name__c,Reward_Account_Number__c,General_Agency__c,Franchise_Code__c,Group_Name__c,Group_Number__c,Policy_Number__c,Other_Originator_Type__c,Originator_Role__c FROM One_Click_Originator__c WHERE Last_Name__c LIKE \'%' + String.escapeSingleQuotes(nameSplit[0].trim()) + '%\'';
                }
            } else{
                query = 'SELECT Id,First_Name__c,Last_Name__c,Phone_Number__c,Email__c,Phone_Ext__c,Originator_Type__c,Agency_Broker_Name__c,Reward_Account_Number__c,General_Agency__c,Franchise_Code__c,Group_Name__c,Group_Number__c,Policy_Number__c,Other_Originator_Type__c,Originator_Role__c FROM One_Click_Originator__c WHERE Last_Name__c LIKE \'%' + String.escapeSingleQuotes(searchField) + '%\' OR Phone_Number__c LIKE \'%' + String.escapeSingleQuotes(searchField) + '%\' OR Email__c LIKE \'%' + String.escapeSingleQuotes(searchField) + '%\'';
            }
            query = query + ' ORDER BY Last_Name__c ASC LIMIT 30';
            System.debug('HERE IS THE QUERY: ' + query);
            results = Database.query(query);
            System.debug('HERE ARE THE SEARCH RESULTS: ' + results);
            for(Integer i = 0; i < results.size(); i++){
                if(results[i].First_Name__c == null || results[i].First_Name__c == 'undefined'){
                    results[i].First_Name__c = '';
                }
                if(results[i].Last_Name__c == null || results[i].Last_Name__c == 'undefined'){
                    results[i].Last_Name__c = '';
                }
                if(results[i].Phone_Number__c == null || results[i].Phone_Number__c == 'undefined'){
                    results[i].Phone_Number__c = '';
                }
                results[i].Phone_Number__c = (results[i].Phone_Number__c != null)?((results[i].Phone_Number__c.length() == 10)?results[i].Phone_Number__c.substring(0,3) + '-' + results[i].Phone_Number__c.substring(3,6) + '-' + results[i].Phone_Number__c.substring(6,results[i].Phone_Number__c.length()):results[i].Phone_Number__c):'';
                if(results[i].Email__c == null || results[i].Email__c == 'undefined'){
                    results[i].Email__c = '';
                }
            }
        }
        System.debug('HERE ARE THE RESULTS: ' + results);
        return results;
    }
    
    @AuraEnabled
    public static List<One_Click_Originator__c> findOriginatorUpdate(String origName,String origType,String origPhone,String origEmail, String origSFID){
    	List<One_Click_Originator__c> results = new List<One_Click_Originator__c>();
    	List<String> originatorName = origName.split(' ');
    	String lastName = originatorName[originatorName.size() - 1];
    	String firstName = originatorName[0];
    	if(originatorName.size() > 2){
    		for(Integer i = 1; i < (originatorName.size() - 2); i++){
    			firstName = firstName + ' ' + originatorName[i];
    		}
    	}
    	String query = '';
		query = 'SELECT Id,First_Name__c,Last_Name__c,Phone_Number__c,Email__c,Phone_Ext__c,Originator_Type__c,Agency_Broker_Name__c,Reward_Account_Number__c,General_Agency__c,Franchise_Code__c,Group_Name__c,Group_Number__c,Policy_Number__c,Other_Originator_Type__c FROM One_Click_Originator__c WHERE Id = \'' + origSFID + '\'';
    	query = query + ' ORDER BY Last_Name__c ASC LIMIT 30';
    	System.debug('HERE IS THE QUERY: ' + query);
    	results = Database.query(query);
    	for(Integer i = 0; i < results.size(); i++){
            if(results[i].First_Name__c == null || results[i].First_Name__c == 'undefined'){
                results[i].First_Name__c = '';
            }
            if(results[i].Last_Name__c == null || results[i].Last_Name__c == 'undefined'){
                results[i].Last_Name__c = '';
            }
            if(results[i].Phone_Number__c == null || results[i].Phone_Number__c == 'undefined'){
                results[i].Phone_Number__c = '';
            }
            results[i].Phone_Number__c = (results[i].Phone_Number__c != null)?((results[i].Phone_Number__c.length() == 10)?results[i].Phone_Number__c.substring(0,3) + '-' + results[i].Phone_Number__c.substring(3,6) + '-' + results[i].Phone_Number__c.substring(6,results[i].Phone_Number__c.length()):results[i].Phone_Number__c):'';
            if(results[i].Email__c == null || results[i].Email__c == 'undefined'){
                results[i].Email__c = '';
            }
        }
        System.debug('HERE ARE THE RESULTS: ' + results);
        return results;
    }
    
    
    @AuraEnabled
    public static String submitEdit(String editSfId,String editFirstName,String editLastName,String editPhone, String editPhoneExt,String editEmail, String editOriginatorType, String editAgencyBroker, String editRewardAccount,
                                    String editGeneralAgency, String editFranchiseCode, String editGroupName, String editGroupNum, String editPolicyNum, String editOtherOrigType,String editOtherOrigRole){
                                        System.debug('MADE IT TO CONTROLLER0');
                                        System.debug('MADE IT TO CONTROLLER1 ' + editSfId + ',' + editFirstName + ',' + editLastName + ',' + editPhone + ',' + editEmail);
                                        String query1 = 'SELECT Id,First_Name__c,Last_Name__c,Phone_Number__c,Email__c,Phone_Ext__c,Originator_Type__c,Agency_Broker_Name__c,Reward_Account_Number__c,General_Agency__c,Franchise_Code__c,Group_Name__c,Group_Number__c,Policy_Number__c,Other_Originator_Type__c FROM One_Click_Originator__c WHERE Id = \'' + editSfId + '\'';
                                        List<One_Click_Originator__c> result = Database.query(query1);
                                        One_Click_Originator__c editOrig = result[0];
                                        editOrig.Id = (editSfId != null)?editSfId:'';
                                        editOrig.First_Name__c = (editFirstName != null)?editFirstName:'';
                                        editOrig.Last_Name__c = (editLastName != null)?editLastName:'';
                                        editOrig.Phone_Number__c = (editPhone != null)?editPhone.replace('-',''):'';
                                        editOrig.Phone_Ext__c = (editPhone != null)?editPhoneExt:'';
                                        editOrig.Email__c = (editEmail != null)?editEmail:'';
                                        editOrig.Originator_Type__c = (editOriginatorType != null)?editOriginatorType:'';
                                        editOrig.Agency_Broker_Name__c = (editAgencyBroker != null)?editAgencyBroker:'';
                                        editOrig.Reward_Account_Number__c = (editRewardAccount != null)?editRewardAccount:'';
                                        editOrig.General_Agency__c = (editGeneralAgency != null)?editGeneralAgency:'';
                                        editOrig.Franchise_Code__c = (editFranchiseCode != null)?editFranchiseCode:'';
                                        editOrig.Group_Name__c = (editGroupName != null)?editGroupName:'';
                                        editOrig.Group_Number__c = (editGroupNum != null)?editGroupNum:'';
                                        editOrig.Policy_Number__c = (editPolicyNum != null)?editPolicyNum:'';
                                        editOrig.Other_Originator_Type__c = (editOtherOrigType != null && editOtherOrigType != 'None')?editOtherOrigType:'';
                                        One_Click_Originator__c originatorRole = getOriginatorRole(editOrig,editOtherOrigRole);
                                        System.debug('MADE IT TO CONTROLLER2 ' + editOrig);
                                        upsert editOrig;
                                        String query = 'SELECT Id,First_Name__c,Last_Name__c,Phone_Number__c,Email__c,Phone_Ext__c,Originator_Type__c,Agency_Broker_Name__c,Reward_Account_Number__c,General_Agency__c,Franchise_Code__c,Group_Name__c,Group_Number__c,Policy_Number__c,Other_Originator_Type__c,Originator_Role__c FROM One_Click_Originator__c WHERE Id = \'' + editSfId + '\'';
                                        List<One_Click_Originator__c> results = Database.query(query);
                                        results = Database.query(query);
                                        System.debug('MADE IT TO CONTROLLER4 ' + results);
                                        return 'Edit Successful';
                                    }
    
    @AuraEnabled
    public static One_Click_Originator__c submitAdd(String editSfId,String editFirstName,String editLastName,String editPhone, String editPhoneExt,String editEmail, String editOriginatorType, String editAgencyBroker, String editRewardAccount,
                                                    String editGeneralAgency, String editFranchiseCode, String editGroupName, String editGroupNum, String editPolicyNum, String editOtherOrigType,String editOtherOrigRole){
                                                        System.debug('MADE IT TO CONTROLLER0');
                                                        System.debug('MADE IT TO CONTROLLER1 '  + editFirstName + ',' + editLastName + ',' + editPhone + ',' + editEmail + ',' + editOtherOrigRole);
                                                        One_Click_Originator__c editOrig = new One_Click_Originator__c();
                                                        editOrig.First_Name__c = (editFirstName != null)?editFirstName:'';
                                                        editOrig.Last_Name__c = (editLastName != null)?editLastName:'';
                                                        editOrig.Phone_Number__c = (editPhone != null)?editPhone.replace('-',''):'';
                                                        editOrig.Phone_Ext__c = (editPhone != null)?editPhoneExt:'';
                                                        editOrig.Email__c = (editEmail != null)?editEmail:'';
                                                        editOrig.Originator_Type__c = (editOriginatorType != null)?editOriginatorType:'';
                                                        editOrig.Agency_Broker_Name__c = (editAgencyBroker != null)?editAgencyBroker:'';
                                                        editOrig.Reward_Account_Number__c = (editRewardAccount != null)?editRewardAccount:'';
                                                        editOrig.General_Agency__c = (editGeneralAgency != null)?editGeneralAgency:'';
                                                        editOrig.Franchise_Code__c = (editFranchiseCode != null)?editFranchiseCode:'';
                                                        editOrig.Group_Name__c = (editGroupName != null)?editGroupName:'';
                                                        editOrig.Group_Number__c = (editGroupNum != null)?editGroupNum:'';
                                                        editOrig.Policy_Number__c = (editPolicyNum != null)?editPolicyNum:'';
                                                        editOrig.Other_Originator_Type__c = (editOtherOrigType != null && editOtherOrigType != 'None')?editOtherOrigType:'';
                                                        One_Click_Originator__c originatorRole = getOriginatorRole(editOrig,editOtherOrigRole);
                                                        System.debug('MADE IT TO CONTROLLER2 ' + editOrig);
                                                        insert editOrig;
                                                        String query = 'SELECT Id,First_Name__c,Last_Name__c,Phone_Number__c,Email__c,Phone_Ext__c,Originator_Type__c,Agency_Broker_Name__c,Reward_Account_Number__c,General_Agency__c,Franchise_Code__c,Group_Name__c,Group_Number__c,Policy_Number__c,Other_Originator_Type__c,Originator_Role__c  FROM One_Click_Originator__c WHERE Id = \'' + editOrig.Id + '\'';
                                                        List<One_Click_Originator__c> results = Database.query(query);
                                                        System.debug('MADE IT TO CONTROLLER3 ' + results);
                                                        return results[0];
                                                    }
    
    @AuraEnabled
    public static List<String> populateBusinessDropdown(String searchType, String searchBusinessUnit, String searchTopic, String searchTypeSel, String searchUser, String searchProfile){
    	String query = '';
    	List<String> dropdownResults = new List<String>();
    	List<Special_Instructions__c> results = new List<Special_Instructions__c>();
    	String searchNoRegion = '';
    	if(searchUser.contains(' - ')){
    		searchNoRegion = searchUser.split(' - ')[0];
    	}
    	String curr = Date.today().format();
        String month = curr.split('/')[0];
        String day = curr.split('/')[1];
        String year = curr.split('/')[2];
        if(integer.valueof(month) < 10){
        	month = '0' + month;
        }
        if(integer.valueof(day) < 10){
        	day = '0' + day;
        }
        curr = year + '-' + month + '-' + day;
    	if(searchType == 'Business Unit'){
    		if(searchUser == 'System Administrator'){
    			Schema.DescribeFieldResult F = All_Business_Units__c.Business_Unit_Full_List__c.getDescribe();
				Schema.sObjectField T = F.getSObjectField();
				List<PicklistEntry> entries = T.getDescribe().getPicklistValues();
				for(Integer i = 0; i < entries.size(); i++){
					dropdownResults.add(entries[i].Label);
				}
    		} else {
	    		query = 'SELECT Business_Unit__c FROM Special_Instructions__c WHERE';
	    		if(searchUser != 'System Administrator' && !searchProfile.contains('Research User')){
	    			if(searchNoRegion != ''){
	    				query = query + ' (ACET_Role__c = \'' + searchUser + '\' OR ACET_Role__c = \'' + searchNoRegion + '\') AND';
	    			} else {
	    				query = query + ' ACET_Role__c = \'' + searchUser + '\' AND';
	    			}
	    		}
	    		query = query + ' Effective_Date__c <= ' + curr + ' AND (End_Date__c > ' + curr + ' OR End_Date__c = null) GROUP BY Business_Unit__c LIMIT 40000';
	    		list<AggregateResult> AggregateResultList1 = Database.query(query);
                if(AggregateResultList1!= null && AggregateResultList1.size() > 0){ 
                    for(AggregateResult agg:AggregateResultList1){ 
                        dropdownResults.add((String)agg.get('Business_Unit__c')); 
                    } 
                }
	    		/*for(Integer i = 0; i < results.size(); i++){
	    			if(results[i].Business_Unit__c != null && results[i].Business_Unit__c != '' && dropdownResults.contains(results[i].Business_Unit__c) == false){
	    				dropdownResults.add((String) results[i].Business_Unit__c);
	    			}
	    		}*/
    		}
    	} else if(searchType == 'Topic'){
    		query = 'SELECT Topic__c FROM Special_Instructions__c WHERE Business_Unit__c = \''+String.escapeSingleQuotes(searchBusinessUnit)+'\''; 
    		if(searchUser != 'System Administrator' && !searchProfile.contains('Research User')){
    			if(searchNoRegion != ''){
    				query = query + ' AND (ACET_Role__c = \'' + searchUser + '\' OR ACET_Role__c = \'' + searchNoRegion + '\')';
    			} else {
    				query = query + ' AND ACET_Role__c = \'' + searchUser + '\'';
    			}
    		}
    		query = query + ' AND Effective_Date__c <= ' + curr + ' AND (End_Date__c > ' + curr + ' OR End_Date__c = null) GROUP BY Topic__c';
    		list<AggregateResult> AggregateResultList1 = Database.query(query);
    		if(AggregateResultList1!= null && AggregateResultList1.size() > 0){ 
                for(AggregateResult agg:AggregateResultList1){ 
                    dropdownResults.add((String)agg.get('Topic__c')); 
                } 
            }
            /*for(Integer i = 0; i < results.size(); i++){
    			if(results[i].Topic__c != null && results[i].Topic__c != '' && dropdownResults.contains(results[i].Topic__c) == false){
    				dropdownResults.add((String) results[i].Topic__c);
    			}
    		}*/
    	} else if(searchType == 'Type'){
    		query = 'SELECT Type__c FROM Special_Instructions__c WHERE Business_Unit__c = \''+String.escapeSingleQuotes(searchBusinessUnit)+'\' AND Topic__c = \''+String.escapeSingleQuotes(searchTopic)+'\''; 
    		if(searchUser != 'System Administrator' && !searchProfile.contains('Research User')){
    			if(searchNoRegion != ''){
    				query = query + ' AND (ACET_Role__c = \'' + searchUser + '\' OR ACET_Role__c = \'' + searchNoRegion + '\')';
    			} else {
    				query = query + ' AND ACET_Role__c = \'' + searchUser + '\'';
    			}
    		}
    		query = query + ' AND Effective_Date__c <= ' + curr + ' AND (End_Date__c > ' + curr + ' OR End_Date__c = null) GROUP BY Type__c';
    		list<AggregateResult> AggregateResultList1 = Database.query(query);
    		if(AggregateResultList1!= null && AggregateResultList1.size() > 0){ 
                for(AggregateResult agg:AggregateResultList1){ 
                    dropdownResults.add((String)agg.get('Type__c')); 
                } 
            }
    		/*for(Integer i = 0; i < results.size(); i++){
    			if(results[i].Type__c != null && results[i].Type__c != '' && dropdownResults.contains(results[i].Type__c) == false){
    				dropdownResults.add((String) results[i].Type__c);
    			}
    		}*/
    	} else if(searchType == 'Subtype'){
    		query = 'SELECT Subtype__c FROM Special_Instructions__c WHERE Business_Unit__c = \''+String.escapeSingleQuotes(searchBusinessUnit)+'\' AND Topic__c = \''+String.escapeSingleQuotes(searchTopic)+'\' AND Type__c = \''+String.escapeSingleQuotes(searchTypeSel)+'\'';
    		if(searchUser != 'System Administrator' && !searchProfile.contains('Research User')){
    			if(searchNoRegion != ''){
    				query = query + ' AND (ACET_Role__c = \'' + searchUser + '\' OR ACET_Role__c = \'' + searchNoRegion + '\')';
    			} else {
    				query = query + ' AND ACET_Role__c = \'' + searchUser + '\'';
    			}
    		} 
    		query = query + ' AND Effective_Date__c <= ' + curr + ' AND (End_Date__c > ' + curr + ' OR End_Date__c = null) GROUP BY Subtype__c';
    		list<AggregateResult> AggregateResultList1 = Database.query(query);
    		if(AggregateResultList1!= null && AggregateResultList1.size() > 0){ 
                for(AggregateResult agg:AggregateResultList1){ 
                    dropdownResults.add((String)agg.get('Subtype__c')); 
                } 
            }
    		/*for(Integer i = 0; i < results.size(); i++){
    			if(results[i].Subtype__c != null && results[i].Subtype__c != '' && dropdownResults.contains(results[i].Subtype__c) == false){
    				dropdownResults.add((String) results[i].Subtype__c);
    			}
    		}*/
    	}
    	
    	dropdownResults.sort();
    	return dropdownResults;
    }
    @AuraEnabled
    public static string searchGroup(String groupId){
        String resultstring;
         List<ETSBE_SolarisGroupDetailResult> solarisGroupID = new List<ETSBE_SolarisGroupDetailResult>();
        List<ETSBE_SolarisGroupDetailResult> meritsbamgroupId = new List<ETSBE_SolarisGroupDetailResult>();
         set<ETSBE_SolarisGroupDetailResult> merituniqResults = new set<ETSBE_SolarisGroupDetailResult>();
            set<ETSBE_SolarisGroupDetailResult> sbamuniqResults = new set<ETSBE_SolarisGroupDetailResult>();
        List<ETSBE_SolarisGroupDetailResult> solarisSearchResults= new List<ETSBE_SolarisGroupDetailResult>();
        set<ETSBE_SolarisGroupDetailResult> newResultsset = new set<ETSBE_SolarisGroupDetailResult>();
            // set<String>groupnames=new set<string>();
            set<String>SBAMgroupnames=new set<string>();
            set<String> MERITgroupnames=new set<string>();
        
            ETSBE_GetSolarisWebservice getSolaris = new ETSBE_GetSolarisWebservice();
            ACETWSCalloutResult CalloutResult = getSolaris.findGroupContact(groupId);
            
            List<ETSBE_SolarisGroupDetailResult> finalResultWrapper = new List<ETSBE_SolarisGroupDetailResult>();
            if(CalloutResult.Success != null && CalloutResult.Success){
                
                solarisGroupID = (List<ETSBE_SolarisGroupDetailResult>)CalloutResult.Response;
                set<string> groupnames= new set<String>();
                if(solarisGroupID != null){
                    
                    for(ETSBE_SolarisGroupDetailResult wrap : solarisGroupID){
                        String str = wrap.groupname;
                        integer index = str.indexOf( ' ', str.indexOf( ' ' ) + 1 );
                        
                        if(index != -1 ){
                            string firstChunk = str.substring( 0, index );
                            string secondChunk = str.substring( index + 1 );

                            //firstChunk = firstChunk.replaceAll('[^a-zA-Z0-9]', ' ');  
                            //firstChunk=   firstChunk.replace(' ', '%');
                            groupnames.add('%'+firstChunk+'%');
                        }else{
                            //str = str.replaceAll('[^a-zA-Z0-9]', ' ');  
                            groupnames.add('%'+str+'%');
                        }
                    }
                    
                    String solarisSearchname = searchGroupSBamMeritName(groupnames,groupnames);
                    
                    if(solarisSearchname != null&& solarisSearchname!=''){
                         solarisSearchResults= (List<ETSBE_SolarisGroupDetailResult>)json.deserialize(solarisSearchname, List<ETSBE_SolarisGroupDetailResult>.class);
                        
                    }
                    
                }
            }
            String namedata = searchGroupSBamMerit(groupId);
        if(namedata != null) {
            meritsbamgroupId = (List<ETSBE_SolarisGroupDetailResult>)json.deserialize(namedata, List<ETSBE_SolarisGroupDetailResult>.class);
               
            List<Merit_Group__c> meritResults = searchMeritResults(groupId);
            List<SBam_Group__c> sbamResults = searchSBAMResults(groupId);
            for(Merit_Group__c gr : meritResults ){
                String str = gr.Group_Name__c;
                integer index = str.indexOf( ' ', str.indexOf( ' ' ) + 1 );
                
                if(index != -1 ){
                    string firstChunk = str.substring( 0, index );
                    string secondChunk = str.substring( index + 1 );

                    //firstChunk = firstChunk.replaceAll('[^a-zA-Z0-9]', ' ');  
                    //firstChunk=   firstChunk.replace(' ', '%');
                    //groupnames.add('%'+firstChunk+'%');
                    MERITgroupnames.add('%'+firstChunk+'%');
                }else{
                    //str = str.replaceAll('[^a-zA-Z0-9]', ' ');  
                    //groupnames.add('%'+str+'%');
                    MERITgroupnames.add('%'+str+'%');
                }
            }
            
            String meritResultsSearchname = searchGroupSBamMeritName(MERITgroupnames,null);
            
            if(meritResultsSearchname != null&& meritResultsSearchname!=''){
                List<ETSBE_SolarisGroupDetailResult> meritData= (List<ETSBE_SolarisGroupDetailResult>)json.deserialize(meritResultsSearchname, List<ETSBE_SolarisGroupDetailResult>.class);
                merituniqResults.addall(meritData);
            }
            for(SBam_Group__c gr : sbamResults ){
                String str = gr.Group_Name__c;
                integer index = str.indexOf( ' ', str.indexOf( ' ' ) + 1 );
                
                if(index != -1 ){
                    string firstChunk = str.substring( 0, index );
                    string secondChunk = str.substring( index + 1 );

                    //firstChunk = firstChunk.replaceAll('[^a-zA-Z0-9]', ' ');  
                    //firstChunk=   firstChunk.replace(' ', '%');
                    // groupnames.add('%'+firstChunk+'%');
                    SBAMgroupnames.add('%'+firstChunk+'%');
                }else{
                    //str = str.replaceAll('[^a-zA-Z0-9]', ' ');  
                    // groupnames.add('%'+str+'%');
                    SBAMgroupnames.add('%'+str+'%'); 
                }
            }
            
            String SBAMSearchname = searchGroupSBamMeritName(null,SBAMgroupnames);
           // List<ETSBE_SolarisGroupDetailResult> SBAMData= (List<ETSBE_SolarisGroupDetailResult>)json.deserialize(sbammeritGroupIdResults, List<ETSBE_SolarisGroupDetailResult>.class);
            if(SBAMSearchname != null&& SBAMSearchname!=''){
                List<ETSBE_SolarisGroupDetailResult> SBAMData= (List<ETSBE_SolarisGroupDetailResult>)json.deserialize(SBAMSearchname, List<ETSBE_SolarisGroupDetailResult>.class);
                sbamuniqResults.addall(SBAMData);
            }
        }
            if(solarisGroupID.size()>0){
                newResultsset.addall(solarisGroupID);
                resultstring = JSON.serialize(newResultsset);
            }
            if(meritsbamgroupId.size()>0){
                newResultsset.addall(meritsbamgroupId);
                resultstring = JSON.serialize(newResultsset);
            }
            if(sbamuniqResults.size()>0){
            newResultsset.addall(sbamuniqResults);
            resultstring = JSON.serialize(newResultsset);
            
            }
            
             if(solarisSearchResults.size()>0){
                newResultsset.addall(solarisSearchResults);
                resultstring = JSON.serialize(newResultsset);
            }
             if(merituniqResults.size()>0){
            newResultsset.addall(merituniqResults);
            resultstring = JSON.serialize(newResultsset);
            }
             
        
        
        return resultstring;
    }
    
    public static string searchGroupSBamMeritName(set<String> meritgroupnames,set<String> sbamgroupnames){
        List<Merit_Group__c> results = new List<Merit_Group__c>();
        List<SBam_Group__c> results1 = new List<SBam_Group__c>();
        String resultstring;
         String renewalDate;
        if(meritgroupnames == null){
        meritgroupnames =new set<String>();
        }
        if(sbamgroupnames == null){
        sbamgroupnames =new set<String>();
        }
      
        
        String query = 'Select Group_Name__c, Group_Number__c, Policy_Renewal_Date__c, Policy_Number__c, Situs_State__c, Funding_Type__c, Line_of_Business__c, Sales_Office__c, Health_Plan_Major__c, Health_Plan_Minor__c, Region__c, Platform__c, Assigned_Broker__c,CM_First_Name__c,CM_Last_Name__c,CM_Email__c,CM_Phone__c,SCE_First_Name__c,SCE_Last_Name__c,SCE_Email__c,SCE_Phone__c FROM Merit_Group__c  WHERE Group_Name__c like : sbamgroupnames limit 50';
        
        results = Database.query(query);
        
        String query1 = 'Select Group_Name__c, Group_Number__c, Policy_Renewal_Date__c, Policy_Number__c, Situs_State__c, Funding_Type__c, Line_of_Business__c, Sales_Office__c, Health_Plan_Major__c, Health_Plan_Minor__c, Region__c, Platform__c, Assigned_Broker__c FROM SBam_Group__c  WHERE Group_Name__c like : meritgroupnames limit 50';
        
        results1 = Database.query(query1);
        
        List<ETSBE_SolarisGroupDetailResult> newResults = new List<ETSBE_SolarisGroupDetailResult>();
                if(results1 != null && results1.size() > 0){
            for(SBam_Group__c result: results1){
                ETSBE_SolarisGroupDetailResult newResult = new ETSBE_SolarisGroupDetailResult();
                newResult.groupName = (result.Group_Name__c != null)?result.Group_Name__c:'';
                newResult.groupId =  (result.Group_Number__c != null)?result.Group_Number__c:'';
                newResult.renewalEffectiveDate = '';
                if(result.Policy_Renewal_Date__c != null){
                     renewalDate = result.Policy_Renewal_Date__c.format();
                    
                    newResult.renewalEffectiveDate = renewalDate;   
                }
                newResult.policyNumber = (result.Policy_Number__c != null)?result.Policy_Number__c:'';
                newResult.situsState = (result.Situs_State__c != null)?result.Situs_State__c:'';
                newResult.fundingType = (result.Funding_Type__c != null)?result.Funding_Type__c:'';
                newResult.lineOfBusiness = (result.Line_of_Business__c != null)?result.Line_of_Business__c:'';
                newResult.salesOffice = (result.Sales_Office__c != null)?result.Sales_Office__c:'';
                newResult.businessMajorMarket = (result.Health_Plan_Major__c != null)?result.Health_Plan_Major__c:'';
                if(newResult.businessMajorMarket.contains('Major')){
                    newResult.businessMajorMarket = newResult.businessMajorMarket.remove('Major');
                } else if(newResult.businessMajorMarket.contains('major')){
                    newResult.businessMajorMarket = newResult.businessMajorMarket.remove('major');
                } else if(newResult.businessMajorMarket.contains('MAJOR')){
                    newResult.businessMajorMarket = newResult.businessMajorMarket.remove('MAJOR');
                }
                newResult.businessMinorMarket = (result.Health_Plan_Minor__c != null)?result.Health_Plan_Minor__c:'';
                if(newResult.businessMinorMarket.contains('Minor')){
                    newResult.businessMinorMarket = newResult.businessMinorMarket.remove('Minor');
                } else if(newResult.businessMinorMarket.contains('minor')){
                    newResult.businessMinorMarket = newResult.businessMinorMarket.remove('minor');
                } else if(newResult.businessMinorMarket.contains('MINOR')){
                    newResult.businessMinorMarket = newResult.businessMinorMarket.remove('MINOR');
                }
                newResult.businessMarketRegion = (result.Region__c != null)?result.Region__c:'';
                if(newResult.businessMarketRegion.contains('Region')){
                    newResult.businessMarketRegion = newResult.businessMarketRegion.remove('Region');
                } else if(newResult.businessMarketRegion.contains('region')){
                    newResult.businessMarketRegion = newResult.businessMarketRegion.remove('region');
                } else if(newResult.businessMarketRegion.contains('REGION')){
                    newResult.businessMarketRegion = newResult.businessMarketRegion.remove('REGION');
                }
                newResult.platform = (result.Platform__c != null)?result.Platform__c:'';
                newResult.brokerName = (result.Assigned_Broker__c != null)?result.Assigned_Broker__c:'';
                newResult.sourceCode = 'SO';
                newResult.contacts = new List<ETSBE_SolarisGroupDetailResult.Contact>();

                newResults.add(newResult);
            }
        }
        //newResults.addall(resultData);
            if(results != null && results.size() > 0){
                for(Merit_Group__c result: results){
                    ETSBE_SolarisGroupDetailResult newResult = new ETSBE_SolarisGroupDetailResult();
                    newResult.groupName = (result.Group_Name__c != null)?result.Group_Name__c:'';
                    newResult.groupId =  (result.Group_Number__c != null)?result.Group_Number__c:'';
                    newResult.renewalEffectiveDate = '';
                    if(result.Policy_Renewal_Date__c != null){
                     renewalDate = result.Policy_Renewal_Date__c.format();
                    newResult.renewalEffectiveDate = renewalDate;   
                    }
                    newResult.policyNumber = (result.Policy_Number__c != null)?result.Policy_Number__c:'';
                    newResult.situsState = (result.Situs_State__c != null)?result.Situs_State__c:'';
                    newResult.fundingType = (result.Funding_Type__c != null)?result.Funding_Type__c:'';
                    newResult.lineOfBusiness = (result.Line_of_Business__c != null)?result.Line_of_Business__c:'';
                    newResult.salesOffice = (result.Sales_Office__c != null)?result.Sales_Office__c:'';
                    newResult.businessMajorMarket = (result.Health_Plan_Major__c != null)?result.Health_Plan_Major__c:'';
                    if(newResult.businessMajorMarket.contains('Major')){
                        newResult.businessMajorMarket = newResult.businessMajorMarket.remove('Major');
                    } else if(newResult.businessMajorMarket.contains('major')){
                        newResult.businessMajorMarket = newResult.businessMajorMarket.remove('major');
                    } else if(newResult.businessMajorMarket.contains('MAJOR')){
                        newResult.businessMajorMarket = newResult.businessMajorMarket.remove('MAJOR');
                    }
                    newResult.businessMinorMarket = (result.Health_Plan_Minor__c != null)?result.Health_Plan_Minor__c:'';
                    if(newResult.businessMinorMarket.contains('Minor')){
                        newResult.businessMinorMarket = newResult.businessMinorMarket.remove('Minor');
                    } else if(newResult.businessMinorMarket.contains('minor')){
                        newResult.businessMinorMarket = newResult.businessMinorMarket.remove('minor');
                    } else if(newResult.businessMinorMarket.contains('MINOR')){
                        newResult.businessMinorMarket = newResult.businessMinorMarket.remove('MINOR');
                    }
                    newResult.businessMarketRegion = (result.Region__c != null)?result.Region__c:'';
                    if(newResult.businessMarketRegion.contains('Region')){
                        newResult.businessMarketRegion = newResult.businessMarketRegion.remove('Region');
                    } else if(newResult.businessMarketRegion.contains('region')){
                        newResult.businessMarketRegion = newResult.businessMarketRegion.remove('region');
                    } else if(newResult.businessMarketRegion.contains('REGION')){
                        newResult.businessMarketRegion = newResult.businessMarketRegion.remove('REGION');
                    }
                    newResult.platform = (result.Platform__c != null)?result.Platform__c:'';
                    newResult.brokerName = (result.Assigned_Broker__c != null)?result.Assigned_Broker__c:'';
                    newResult.sourceCode = 'NA';
                    newResult.contacts = new List<ETSBE_SolarisGroupDetailResult.Contact>();
                    if(result.CM_First_Name__c != null && result.CM_First_Name__c != '' && result.CM_Last_Name__c != null && result.CM_Last_Name__c != ''){
                        ETSBE_SolarisGroupDetailResult.Contact newContact = new ETSBE_SolarisGroupDetailResult.Contact();
                        newContact.firstName = (result.CM_First_Name__c != null)?result.CM_First_Name__c:'';
                        newContact.lastName = (result.CM_Last_Name__c != null)?result.CM_Last_Name__c:'';
                        newContact.name = newContact.firstName + ' ' + newContact.lastName;
                        newContact.email = (result.CM_Email__c != null)?result.CM_Email__c:'';
                        newContact.workPhone = (result.CM_Phone__c != null)?result.CM_Phone__c:'';
                        newContact.title = 'Client Manager';
                        newResult.contacts.add(newContact);
                    }
                    if(result.SCE_First_Name__c != null && result.SCE_First_Name__c != '' && result.SCE_Last_Name__c != null && result.SCE_Last_Name__c != ''){
                        ETSBE_SolarisGroupDetailResult.Contact newContact1 = new ETSBE_SolarisGroupDetailResult.Contact();
                        newContact1.firstName = (result.SCE_First_Name__c != null)?result.SCE_First_Name__c:'';
                        newContact1.lastName = (result.SCE_Last_Name__c != null)?result.SCE_Last_Name__c:'';
                        newContact1.name = newContact1.firstName + ' ' + newContact1.lastName;
                        newContact1.email = (result.SCE_Email__c != null)?result.SCE_Email__c:'';
                        newContact1.workPhone = (result.SCE_Phone__c != null)?result.SCE_Phone__c:'';
                        newContact1.title = 'Strategic Client Executive';
                        newResult.contacts.add(newContact1);
                    }
                    newResults.add(newResult);
                }
                
            }

        if(newResults.size() > 0){
            resultstring = JSON.serialize(newResults);
        }
        
        //}catch(exception e){resultstring='';}
        
        return resultstring;
    }
    
    @AuraEnabled
    public static List<Merit_Group__c> searchMeritResults(String groupId){
         List<Merit_Group__c> results = new List<Merit_Group__c>();
        String query = 'Select Group_Name__c, Group_Number__c, Policy_Renewal_Date__c, Policy_Number__c, Situs_State__c, Funding_Type__c, Line_of_Business__c, Sales_Office__c, Health_Plan_Major__c, Health_Plan_Minor__c, Region__c, Platform__c, Assigned_Broker__c, CM_First_Name__c,CM_Last_Name__c,CM_Email__c,CM_Phone__c,SCE_First_Name__c,SCE_Last_Name__c,SCE_Email__c,SCE_Phone__c FROM Merit_Group__c WHERE Group_Number__c = \'' + groupId + '\' OR Policy_Number__c = \'' + groupId + '\' limit 50';
            
            results = Database.query(query);
        return (List<Merit_Group__c>)results;
    }
     @AuraEnabled
    public static List<SBam_Group__c> searchSBAMResults(String groupId){
         List<SBam_Group__c> results = new List<SBam_Group__c>();
        String query = 'Select Group_Name__c, Group_Number__c, Policy_Renewal_Date__c, Policy_Number__c, Situs_State__c, Funding_Type__c, Line_of_Business__c, Sales_Office__c, Health_Plan_Major__c, Health_Plan_Minor__c, Region__c, Platform__c, Assigned_Broker__c FROM SBam_Group__c  WHERE Group_Number__c = \'' + groupId + '\' OR Policy_Number__c = \'' + groupId + '\' limit 50';
            
            results= Database.query(query);
        return (List<SBam_Group__c>)results;
    }
    @AuraEnabled
    public static string searchGroupSBamMerit(String groupId){
        List<Merit_Group__c> results = new List<Merit_Group__c>();
        List<SBam_Group__c> results1 = new List<SBam_Group__c>();
        String resultstring;
        String renewalDate;
        try{
            String query = 'Select Group_Name__c, Group_Number__c, Policy_Renewal_Date__c, Policy_Number__c, Situs_State__c, Funding_Type__c, Line_of_Business__c, Sales_Office__c, Health_Plan_Major__c, Health_Plan_Minor__c, Region__c, Platform__c, Assigned_Broker__c, CM_First_Name__c,CM_Last_Name__c,CM_Email__c,CM_Phone__c,SCE_First_Name__c,SCE_Last_Name__c,SCE_Email__c,SCE_Phone__c FROM Merit_Group__c WHERE Group_Number__c = \'' + groupId + '\' OR Policy_Number__c = \'' + groupId + '\' limit 50';
            
            results = Database.query(query);
            
            String query1 = 'Select Group_Name__c, Group_Number__c, Policy_Renewal_Date__c, Policy_Number__c, Situs_State__c, Funding_Type__c, Line_of_Business__c, Sales_Office__c, Health_Plan_Major__c, Health_Plan_Minor__c, Region__c, Platform__c, Assigned_Broker__c FROM SBam_Group__c  WHERE Group_Number__c = \'' + groupId + '\' OR Policy_Number__c = \'' + groupId + '\' limit 50';
           
            results1 = Database.query(query1);
            
            List<ETSBE_SolarisGroupDetailResult> newResults = new List<ETSBE_SolarisGroupDetailResult>();
            set<ETSBE_SolarisGroupDetailResult> newResultsset = new set<ETSBE_SolarisGroupDetailResult>();
            
            set<ETSBE_SolarisGroupDetailResult> merituniqResults = new set<ETSBE_SolarisGroupDetailResult>();
            set<ETSBE_SolarisGroupDetailResult> sbamuniqResults = new set<ETSBE_SolarisGroupDetailResult>();
            // set<String>groupnames=new set<string>();
            set<String>SBAMgroupnames=new set<string>();
            set<String> MERITgroupnames=new set<string>();
            
            
            
            
            
            if(results != null && results.size() > 0){
                for(Merit_Group__c result: results){
                    ETSBE_SolarisGroupDetailResult newResult = new ETSBE_SolarisGroupDetailResult();
                    newResult.groupName = (result.Group_Name__c != null)?result.Group_Name__c:'';
                    newResult.groupId =  (result.Group_Number__c != null)?result.Group_Number__c:'';
                    newResult.renewalEffectiveDate = '';
                    if(result.Policy_Renewal_Date__c != null){
                        renewalDate = result.Policy_Renewal_Date__c.format();
                        
                        newResult.renewalEffectiveDate = renewalDate;   
                    }
                    newResult.policyNumber = (result.Policy_Number__c != null)?result.Policy_Number__c:'';
                    newResult.situsState = (result.Situs_State__c != null)?result.Situs_State__c:'';
                    newResult.fundingType = (result.Funding_Type__c != null)?result.Funding_Type__c:'';
                    newResult.lineOfBusiness = (result.Line_of_Business__c != null)?result.Line_of_Business__c:'';
                    newResult.salesOffice = (result.Sales_Office__c != null)?result.Sales_Office__c:'';
                    newResult.businessMajorMarket = (result.Health_Plan_Major__c != null)?result.Health_Plan_Major__c:'';
                    if(newResult.businessMajorMarket.contains('Major')){
                        newResult.businessMajorMarket = newResult.businessMajorMarket.remove('Major');
                    } else if(newResult.businessMajorMarket.contains('major')){
                        newResult.businessMajorMarket = newResult.businessMajorMarket.remove('major');
                    } else if(newResult.businessMajorMarket.contains('MAJOR')){
                        newResult.businessMajorMarket = newResult.businessMajorMarket.remove('MAJOR');
                    }
                    newResult.businessMinorMarket = (result.Health_Plan_Minor__c != null)?result.Health_Plan_Minor__c:'';
                    if(newResult.businessMinorMarket.contains('Minor')){
                        newResult.businessMinorMarket = newResult.businessMinorMarket.remove('Minor');
                    } else if(newResult.businessMinorMarket.contains('minor')){
                        newResult.businessMinorMarket = newResult.businessMinorMarket.remove('minor');
                    } else if(newResult.businessMinorMarket.contains('MINOR')){
                        newResult.businessMinorMarket = newResult.businessMinorMarket.remove('MINOR');
                    }
                    newResult.businessMarketRegion = (result.Region__c != null)?result.Region__c:'';
                    if(newResult.businessMarketRegion.contains('Region')){
                        newResult.businessMarketRegion = newResult.businessMarketRegion.remove('Region');
                    } else if(newResult.businessMarketRegion.contains('region')){
                        newResult.businessMarketRegion = newResult.businessMarketRegion.remove('region');
                    } else if(newResult.businessMarketRegion.contains('REGION')){
                        newResult.businessMarketRegion = newResult.businessMarketRegion.remove('REGION');
                    }
                    newResult.platform = (result.Platform__c != null)?result.Platform__c:'';
                    newResult.brokerName = (result.Assigned_Broker__c != null)?result.Assigned_Broker__c:'';
                    newResult.sourceCode = 'NA';
                    newResult.contacts = new List<ETSBE_SolarisGroupDetailResult.Contact>();
                    if(result.CM_First_Name__c != null && result.CM_First_Name__c != '' && result.CM_Last_Name__c != null && result.CM_Last_Name__c != ''){
                        ETSBE_SolarisGroupDetailResult.Contact newContact = new ETSBE_SolarisGroupDetailResult.Contact();
                        newContact.firstName = (result.CM_First_Name__c != null)?result.CM_First_Name__c:'';
                        newContact.lastName = (result.CM_Last_Name__c != null)?result.CM_Last_Name__c:'';
                        newContact.name = newContact.firstName + ' ' + newContact.lastName;
                        newContact.email = (result.CM_Email__c != null)?result.CM_Email__c:'';
                        newContact.workPhone = (result.CM_Phone__c != null)?result.CM_Phone__c:'';
                        newContact.title = 'Client Manager';
                        newResult.contacts.add(newContact);
                    }
                    if(result.SCE_First_Name__c != null && result.SCE_First_Name__c != '' && result.SCE_Last_Name__c != null && result.SCE_Last_Name__c != ''){
                        ETSBE_SolarisGroupDetailResult.Contact newContact1 = new ETSBE_SolarisGroupDetailResult.Contact();
                        newContact1.firstName = (result.SCE_First_Name__c != null)?result.SCE_First_Name__c:'';
                        newContact1.lastName = (result.SCE_Last_Name__c != null)?result.SCE_Last_Name__c:'';
                        newContact1.name = newContact1.firstName + ' ' + newContact1.lastName;
                        newContact1.email = (result.SCE_Email__c != null)?result.SCE_Email__c:'';
                        newContact1.workPhone = (result.SCE_Phone__c != null)?result.SCE_Phone__c:'';
                        newContact1.title = 'Strategic Client Executive';
                        newResult.contacts.add(newContact1);
                    }
                    //newResults.add(newResult);
                    newResultsset.add(newResult);
                }
                
            }             
            
            
            
            
           
            
            if(results1 != null && results1.size() > 0){
                for(SBam_Group__c result: results1){
                    ETSBE_SolarisGroupDetailResult newResult = new ETSBE_SolarisGroupDetailResult();
                    newResult.groupName = (result.Group_Name__c != null)?result.Group_Name__c:'';
                    newResult.groupId =  (result.Group_Number__c != null)?result.Group_Number__c:'';
                    newResult.renewalEffectiveDate = '';
                    if(result.Policy_Renewal_Date__c != null){
                         renewalDate = result.Policy_Renewal_Date__c.format();
                        
                        newResult.renewalEffectiveDate = renewalDate;   
                    }
                    newResult.policyNumber = (result.Policy_Number__c != null)?result.Policy_Number__c:'';
                    newResult.situsState = (result.Situs_State__c != null)?result.Situs_State__c:'';
                    newResult.fundingType = (result.Funding_Type__c != null)?result.Funding_Type__c:'';
                    newResult.lineOfBusiness = (result.Line_of_Business__c != null)?result.Line_of_Business__c:'';
                    newResult.salesOffice = (result.Sales_Office__c != null)?result.Sales_Office__c:'';
                    newResult.businessMajorMarket = (result.Health_Plan_Major__c != null)?result.Health_Plan_Major__c:'';
                    if(newResult.businessMajorMarket.contains('Major')){
                        newResult.businessMajorMarket = newResult.businessMajorMarket.remove('Major');
                    } else if(newResult.businessMajorMarket.contains('major')){
                        newResult.businessMajorMarket = newResult.businessMajorMarket.remove('major');
                    } else if(newResult.businessMajorMarket.contains('MAJOR')){
                        newResult.businessMajorMarket = newResult.businessMajorMarket.remove('MAJOR');
                    }
                    newResult.businessMinorMarket = (result.Health_Plan_Minor__c != null)?result.Health_Plan_Minor__c:'';
                    if(newResult.businessMinorMarket.contains('Minor')){
                        newResult.businessMinorMarket = newResult.businessMinorMarket.remove('Minor');
                    } else if(newResult.businessMinorMarket.contains('minor')){
                        newResult.businessMinorMarket = newResult.businessMinorMarket.remove('minor');
                    } else if(newResult.businessMinorMarket.contains('MINOR')){
                        newResult.businessMinorMarket = newResult.businessMinorMarket.remove('MINOR');
                    }
                    newResult.businessMarketRegion = (result.Region__c != null)?result.Region__c:'';
                    if(newResult.businessMarketRegion.contains('Region')){
                        newResult.businessMarketRegion = newResult.businessMarketRegion.remove('Region');
                    } else if(newResult.businessMarketRegion.contains('region')){
                        newResult.businessMarketRegion = newResult.businessMarketRegion.remove('region');
                    } else if(newResult.businessMarketRegion.contains('REGION')){
                        newResult.businessMarketRegion = newResult.businessMarketRegion.remove('REGION');
                    }
                    newResult.platform = (result.Platform__c != null)?result.Platform__c:'';
                    newResult.brokerName = (result.Assigned_Broker__c != null)?result.Assigned_Broker__c:'';
                    newResult.sourceCode = 'SO';
                    newResult.contacts = new List<ETSBE_SolarisGroupDetailResult.Contact>();

                    //newResults.add(newResult);
                    newResultsset.add(newResult);
                }
                
            }
            if(newResultsset.size() > 0){
                resultstring = JSON.serialize(newResultsset);
            }
            
        }catch(exception e){resultstring='';}
        System.debug('GROUP SEARCH CONT 6 ' + resultstring);
        return resultstring;
    }
    
    @AuraEnabled
    public static String searchBroker(String producerId){
    	String resultstring;
    	try{
    		ETSBE_BrokerSearchWebservice findBroker = new ETSBE_BrokerSearchWebservice();
    		ACETWSCalloutResult CalloutResult = findBroker.findProducer(producerId);
    		if(CalloutResult.Success != null && CalloutResult.Success){
    			List<ETSBE_ProducerResults> resultWrapper = (List<ETSBE_ProducerResults>)CalloutResult.Response;
    			System.debug('RETURNED RESULTWRAPPER: ' + resultWrapper);
    			if(resultWrapper != null){
                    resultstring = JSON.serialize(resultWrapper);
                }
    		}
    	}catch(exception e){
    		resultstring='';
    	}
    	System.debug('PRODUCER RESULT PASSED: ' + resultstring);
    	return resultstring;
    }
    
    public class SearchResultWrapper{
        @AuraEnabled public SAEProviderMemberSearchInteractionResult resultWrapper {get;set;}
        @AuraEnabled public string message {get;set;}
        @AuraEnabled public integer statusCode {get;set;}
    }
    
    
    @AuraEnabled  
    public static SearchResultWrapper searchMembers(String memberDetails){
        SAEProviderSearch.MemberDetails md = (SAEProviderSearch.MemberDetails) System.JSON.deserialize(memberDetails, SAEProviderSearch.MemberDetails.class);
        System.debug('@@ SAEProviderSearch: md: ' + md);
        SAEProviderMemberSearchInteractionResult resultwrap = new SAEProviderMemberSearchInteractionResult();                 
        SAEMemberProviderWS MemberProviderService = new SAEMemberProviderWS();
        SAEMemberStandaloneSearchWebService findIndividualWS = new SAEMemberStandaloneSearchWebService();
        ACETWSCalloutResult CalloutResult = null;
        if(String.isNotBlank(md.memberId) && !String.isNotBlank(md.memberDOB) && !String.isNotBlank(md.firstName) && !String.isNotBlank(md.lastName) &&
           !String.isNotBlank(md.groupNumber)){
               system.debug('findIndividual');
               CalloutResult = findIndividualWS.findIndividual(md.memberId);
               system.debug('CalloutResult>>> ' + CalloutResult);
               if (CalloutResult.Success != null && CalloutResult.Success){
                   resultwrap= (SAEProviderMemberSearchInteractionResult)CalloutResult.Response;
                   System.debug('resultwrap.memberProviderResultlst@@@ ' + resultwrap.lstSAEMemberStandaloneSearch);
                   System.debug('resultwrap ' + resultwrap);
               }
        }else{
            //CalloutResult = MemberProviderService.getMemberWS(md.memberId,md.memberDOB,md.firstName,md.lastName,md.groupNumber,md.searchOption,'87726','LOTSOFF','DAVID','1205807328');
            CalloutResult = MemberProviderService.getMemberWS(md.memberId,md.memberDOB,md.firstName,md.lastName,md.groupNumber,md.searchOption,md.payerID,md.providerLastName,md.providerFirstName,md.npi,md.providerFlow);
            if (CalloutResult.Success){   
                resultwrap= (SAEProviderMemberSearchInteractionResult)CalloutResult.Response;
                System.debug('resultwrap.memberProviderResultlst@@@ ' + resultwrap.memberProviderResultlst);
                System.debug('resultwrap.@@@ ' + resultwrap);
            } 
        }
        System.debug('>>>resultwrap------'+resultwrap); 
        SearchResultWrapper dataWrap = new SearchResultWrapper();
        dataWrap.resultWrapper = resultwrap;
        dataWrap.message = CalloutResult.Message;
        dataWrap.statusCode = CalloutResult.statusCode;
        System.debug('dataWrap ->' + JSON.serialize(dataWrap));
        return dataWrap;
    }
    @AuraEnabled
    public static Interaction__c createInteractionBot(String origSfId, String interactionType, Date eventDate, String eventTime, String memberFirstName, String memberLastName, String memberDOB, String memberId,boolean priority){
        System.debug('HERE IS THE CREATE INTERACTION');
        System.debug('DATE AND TIME: ' + interactionType);
        System.debug('DATE AND TIME: ' + eventDate);
        System.debug('DATE AND TIME: ' + eventTime);
        Interaction__c interaction = new Interaction__c();
         Id intrecid = Schema.SObjectType.Interaction__c.getRecordTypeInfosByDeveloperName().get('BEO_Interaction').getRecordTypeId();
        interaction.recordtypeid = intrecid;
        System.debug('EVENTRECDATE: ' + eventDate);
        System.debug('EVENTRECTIME: ' + eventTime);
        interaction.Current_Status__c = 'BOT';
        interaction.Priority__c=priority;
        Third_Party__c thirdParty = new Third_Party__c();
        String foundThirdPartyId = '';
        if(eventDate != null && eventTime != null && eventTime != '' && eventTime.contains(':')){
            Integer hours = Integer.valueOf(eventTime.split(':')[0]);
            Integer mins = Integer.valueOf(eventTime.split(':')[1]);
            Time newTime = Time.newInstance(hours,mins,0,0);
            DateTime dt = DateTime.newInstance(eventDate,newTime);
            interaction.Evt_Recvd_Dt_Time__c = dt;	
            System.debug('FINAL DATETIME: ' + interaction.Evt_Recvd_Dt_Time__c);
        } else {
            DateTime dates = DateTime.now();
            Time newTime = Time.newInstance(dates.hour(),dates.minute(),0,0);
            DateTime dt = DateTime.newInstance(date.today(),newTime);
            interaction.Evt_Recvd_Dt_Time__c = dt;
            System.debug('FINAL DEFAULT DATETIME: ' + interaction.Evt_Recvd_Dt_Time__c);
        }
        interaction.Interaction_Type__c = (interactionType != null && interactionType != '')?interactionType:'Phone Call';
        if(memberFirstName != null && memberFirstName != '' && memberLastName != null && memberLastName != '' && memberDOB != null && memberDOB != '' && memberId != null && memberId != ''){
            Account acc = new Account();
            Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
            acc.RecordTypeId = personAccountRecordTypeId;
            acc.FirstName = (memberFirstName != null)?memberFirstName:'';
	        acc.LastName = (memberLastName != null)?memberLastName:'';
	        acc.PersonBirthdate = Date.parse(memberDOB);
            System.debug('HERE IS THE EID: ' + memberFirstName + memberLastName + memberDOB.remove('/') + memberId);
            acc.EID__c = memberFirstName + memberLastName + memberDOB.remove('/') + memberId;
            acc.EID__pc = memberFirstName + memberLastName + memberDOB.remove('/') + memberId;
            Database.upsert(acc, Account.Fields.EID__c);
            System.debug('HERE IS THE PERSON ACCT1: ' + acc);
            Account personContact = [SELECT id, PersonContactId FROM Account where id=: acc.id];
            System.debug('HERE IS THE PERSON ACCT2: ' + acc);
            interaction.Originator__c = personContact.PersonContactId;
            interaction.Originator_Type__c = 'Member';
            interaction.Contact_Name__c = (memberFirstName != null && memberLastName != null)?memberFirstName + ' ' + memberLastName:'';
        } else if(origSfId != null && origSfId != ''){
			String query = 'SELECT Id,First_Name__c,Last_Name__c,Phone_Number__c,Email__c,Phone_Ext__c,Originator_Type__c,Agency_Broker_Name__c,Reward_Account_Number__c,General_Agency__c,Franchise_Code__c,Group_Name__c,Group_Number__c,Policy_Number__c,Other_Originator_Type__c FROM One_Click_Originator__c WHERE Id = \'' + origSfId + '\'';
	        List<One_Click_Originator__c> results = Database.query(query);
	        One_Click_Originator__c originator = new One_Click_Originator__c();
	        if(results.size() > 0){
	            originator = results[0];
                if(originator.Phone_Number__c != null && originator.Phone_Number__c.length() == 10){
                    originator.Phone_Number__c = originator.Phone_Number__c.substring(0,3) + '-' + originator.Phone_Number__c.substring(3,6) + '-' + originator.Phone_Number__c.substring(6,10);
                }
            	if(originator.Originator_Type__c != 'Internal UHG Employee'){
            		query = 'SELECT Id, Get_Encrypted_Fields__c From Third_Party__c WHERE Customer_Admin_Type__c = \'' + originator.Originator_Type__c + '\'';
	                if(originator.Originator_Type__c == 'Agency/Broker'){
		                	if(originator.Agency_Broker_Name__c != null && originator.Agency_Broker_Name__c != ''){
								query = query + ' AND Agency_Broker_Name__c = \'' + String.escapeSingleQuotes(originator.Agency_Broker_Name__c) + '\'';
							}
							if(originator.Reward_Account_Number__c != null && originator.Reward_Account_Number__c != ''){
								query = query + ' AND Reward_Account_Number__c = \'' + originator.Reward_Account_Number__c + '\'';
							}
		                } else if(originator.Originator_Type__c == 'General Agent'){
		                	if(originator.General_Agency__c != null && originator.General_Agency__c != ''){
								query = query + ' AND General_Agency__c = \'' + String.escapeSingleQuotes(originator.General_Agency__c) + '\'';
							}
							if(originator.Franchise_Code__c != null && originator.Franchise_Code__c != ''){
								query = query + ' AND Franchise_Code__c = \'' + originator.Franchise_Code__c + '\'';
							}
		                } else if(originator.Originator_Type__c == 'Group Contact'){
		                	if(originator.Policy_Number__c != null && originator.Policy_Number__c != ''){
								query = query + ' AND Policy_Number__c = \'' + originator.Policy_Number__c + '\'';
							}
		                } else if(originator.Originator_Type__c == 'Other Originator'){
		                	if(originator.Policy_Number__c != null && originator.Policy_Number__c != ''){
								query = query + ' AND Other_Admin_Type__c = \'' + originator.Other_Originator_Type__c + '\'';
							}
			            }
	                System.debug('HERE IS THE QUERY: ' + query);
	                List<Third_Party__c> tpResults = Database.query(query);
	                System.debug('HERE IS THE RESULT: ' + tpResults);
	                String grpName = (originator.Group_Name__c != null)?originator.Group_Name__c:'';
	                String grpNum = (originator.Group_Number__c != null)?originator.Group_Number__c:'';
               		String encryptedFieldsText = originator.First_Name__c + '|||||' + originator.Last_Name__c + '|||||' + originator.Email__c + '|||||' + originator.Phone_Number__c + '|||||' + grpName + '|||||' + grpNum; 
	                for(Integer i = 0; i < tpResults.size(); i++){
	                    System.debug('CHECKING ENCRYPTED KEY: ' + encryptedFieldsText);
	                    System.debug('CHECKING ENCRYPTED RES: ' + tpResults[i].Get_Encrypted_Fields__c);
	                    if(tpResults[i].Get_Encrypted_Fields__c == encryptedFieldsText){
	                        foundThirdPartyId = tpResults[i].Id;
	                        System.debug('FOUND THIRD PARTY: ' + foundThirdPartyId);
	                    }
	                }
	                System.debug('HERE IS THE TPID: ' + foundThirdPartyId);
            	}
            	if(originator.Originator_Type__c == 'Agency/Broker'){
	                interaction.Agency_Broker_Name__c = (originator.Agency_Broker_Name__c != null)?originator.Agency_Broker_Name__c:'';
	                interaction.Reward_Account_Number__c = (originator.Reward_Account_Number__c != null)?originator.Reward_Account_Number__c:'';
                    interaction.Originator_Type__c = 'Agency/Broker';                    
	                if(foundThirdPartyId == ''){
	                    thirdParty.Agency_Broker_Name__c = (originator.Agency_Broker_Name__c != null)?originator.Agency_Broker_Name__c:'';
	                    thirdParty.Reward_Account_Number__c = (originator.Reward_Account_Number__c != null)?originator.Reward_Account_Number__c:'';
	                }
	            } else if(originator.Originator_Type__c == 'General Agent'){
	                interaction.General_Agency__c = (originator.General_Agency__c != null)?originator.General_Agency__c:''; 
	                interaction.Franchise_Code__c = (originator.Franchise_Code__c != null)?originator.Franchise_Code__c:'';
                    interaction.Originator_Type__c = 'General Agent';
	                if(foundThirdPartyId == ''){
	                    thirdParty.General_Agency__c = (originator.General_Agency__c != null)?originator.General_Agency__c:''; 
	                    thirdParty.Franchise_Code__c = (originator.Franchise_Code__c != null)?originator.Franchise_Code__c:'';
	                }
	            } else if(originator.Originator_Type__c == 'Group Contact'){
	                interaction.Group_Name__c = (originator.Group_Name__c != null)?originator.Group_Name__c:''; 
	                interaction.Group_Number__c = (originator.Group_Number__c != null)?originator.Group_Number__c:'';
	                interaction.Policy_Number__c = (originator.Policy_Number__c != null)?originator.Policy_Number__c:'';
	                interaction.Originator_Type__c='Group Contact';
	                if(foundThirdPartyId == ''){ 
	                    thirdParty.Group_Name__c = (originator.Group_Name__c != null)?originator.Group_Name__c:''; 
	                    thirdParty.Group_Number__c = (originator.Group_Number__c != null)?originator.Group_Number__c:'';
	                    thirdParty.Policy_Number__c = (originator.Policy_Number__c != null)?originator.Policy_Number__c:'';
	                }
	            } else if(originator.Originator_Type__c == 'Other Originator'){
	                interaction.Other_Admin_Type__c = (originator.Other_Originator_Type__c != null)?originator.Other_Originator_Type__c:''; 
                    interaction.Originator_Type__c = 'Other Originator';
	                if(foundThirdPartyId == ''){ 
	                    thirdParty.Other_Admin_Type__c = (originator.Other_Originator_Type__c != null)?originator.Other_Originator_Type__c:''; 
	                }
	            } else if(originator.Originator_Type__c == 'Internal UHG Employee'){
	                //interaction.Originator_Name__c = (custAdmin.firstName != null && custAdmin.lastName != null)?custAdmin.firstName + ' ' + custAdmin.lastName:'';
	                Account acc = new Account();
	                Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
	                acc.RecordTypeId = personAccountRecordTypeId;
	                acc.FirstName = (originator.First_Name__c != null)?originator.First_Name__c:'';
	                acc.LastName = (originator.Last_Name__c != null)?originator.Last_Name__c:'';
	                acc.Phone = (originator.Phone_Number__c != null)?originator.Phone_Number__c:'000-000-0000';
	                acc.PersonEmail = (originator.Email__c != null)?originator.Email__c:'';
	                acc.EID__c = (originator.Email__c != null)?originator.Email__c:'';
	                acc.EID__pc = (originator.Email__c != null)?originator.Email__c:'';
	                Database.upsert(acc, Account.Fields.EID__c);
	                System.debug('HERE IS THE PERSON ACCT1: ' + acc);
	                Account personContact = [SELECT id, PersonContactId FROM Account where id=: acc.id];
	                System.debug('HERE IS THE PERSON ACCT2: ' + acc);
	                interaction.Originator__c = personContact.PersonContactId;
	                interaction.Originator_Type__c = 'Internal UHG Employee';
	                 
	            }
	            if(originator.Originator_Type__c != 'Internal UHG Employee'){
	                if(foundThirdPartyId == ''){
	                    thirdParty.First_Name__c = (originator.First_Name__c != null)?originator.First_Name__c:'';
	                    thirdParty.LastName__c = (originator.Last_Name__c != null)?originator.Last_Name__c:'';
	                    thirdParty.Email__c = (originator.Email__c != null)?originator.Email__c:'';
	                    thirdParty.Phone_Number__c = (originator.Phone_Number__c != null)?originator.Phone_Number__c:'000-000-0000';
	                    thirdParty.Customer_Admin_Type__c = (originator.Originator_Type__c != null)?originator.Originator_Type__c:'';
	                    insert thirdParty;
	                    interaction.Third_Party__c = (thirdParty.Id != null)?thirdParty.Id:'';
	                } else if(foundThirdPartyId != ''){
	                    interaction.Third_Party__c = foundThirdPartyId;
	                }
	            }
	            interaction.Contact_Name__c = (originator.First_Name__c != null && originator.Last_Name__c != null)?originator.First_Name__c + ' ' + originator.Last_Name__c:'';
	            Interaction.Customer_Admin_Type__c = (originator.Originator_Type__c != null)?originator.Originator_Type__c:'';
	            interaction.Originator_Phone__c = (originator.Phone_Number__c != null)?originator.Phone_Number__c:'000-000-0000';
	            interaction.Originator_Extension__c = (originator.Phone_Ext__c != null)?originator.Phone_Ext__c:'';
	            interaction.Originator_Email__c = (originator.Email__c != null)?originator.Email__c:'';
                interaction.Originator_SFID__c = (originator.Id != null)?originator.Id:'';
                String otherAdminTypeVal = originator.Other_Originator_Type__c;
                otherAdminTypeVal = (otherAdminTypeVal != null) ? otherAdminTypeVal : '';
                interaction.Originator_Relationship__c = otherAdminTypeVal;
	            System.debug('HERE IS THE INTERACTION: ' + interaction);

            }
        }
        insert interaction;
        Interaction__c newInteraction = new Interaction__c();
        newInteraction = (Interaction__c) Database.query('SELECT Id, Interaction_Type__c, Name, Originator_Name__c FROM Interaction__c WHERE Id = \'' + interaction.Id + '\'');
        return newInteraction;
    }
    @AuraEnabled
    public static Interaction__c createInteractionOneNDone(String origSfId, String interactionType, Date eventDate, String eventTime, String memberFirstName, String memberLastName, String memberDOB, String memberId){
        System.debug('HERE IS THE CREATE INTERACTION');
        System.debug('DATE AND TIME: ' + interactionType);
        System.debug('DATE AND TIME: ' + eventDate);
        System.debug('DATE AND TIME: ' + eventTime);
        Id intrecid = Schema.SObjectType.Interaction__c.getRecordTypeInfosByDeveloperName().get('BEO_Interaction').getRecordTypeId();
        Interaction__c interaction = new Interaction__c();
        interaction.recordtypeid = intrecid;
        System.debug('EVENTRECDATE: ' + eventDate);
        System.debug('EVENTRECTIME: ' + eventTime);
        Third_Party__c thirdParty = new Third_Party__c();
        String foundThirdPartyId = '';
        if(eventDate != null && eventTime != null && eventTime != '' && eventTime.contains(':')){
            Integer hours = Integer.valueOf(eventTime.split(':')[0]);
            Integer mins = Integer.valueOf(eventTime.split(':')[1]);
            Time newTime = Time.newInstance(hours,mins,0,0);
            DateTime dt = DateTime.newInstance(eventDate,newTime);
            interaction.Evt_Recvd_Dt_Time__c = dt;	
            System.debug('FINAL DATETIME: ' + interaction.Evt_Recvd_Dt_Time__c);
        } else {
            DateTime dates = DateTime.now();
            Time newTime = Time.newInstance(dates.hour(),dates.minute(),0,0);
            DateTime dt = DateTime.newInstance(date.today(),newTime);
            interaction.Evt_Recvd_Dt_Time__c = dt;
            System.debug('FINAL DEFAULT DATETIME: ' + interaction.Evt_Recvd_Dt_Time__c);
        }
        interaction.Interaction_Type__c = (interactionType != null && interactionType != '')?interactionType:'Phone Call';
        if(memberFirstName != null && memberFirstName != '' && memberLastName != null && memberLastName != '' && memberDOB != null && memberDOB != '' && memberId != null && memberId != ''){
            Account acc = new Account();
            Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
            acc.RecordTypeId = personAccountRecordTypeId;
            acc.FirstName = (memberFirstName != null)?memberFirstName:'';
	        acc.LastName = (memberLastName != null)?memberLastName:'';
	        acc.PersonBirthdate = Date.parse(memberDOB);
            acc.Phone = '000-000-0000';
            System.debug('HERE IS THE EID: ' + memberFirstName + memberLastName + memberDOB.remove('/') + memberId);
            acc.EID__c = memberFirstName + memberLastName + memberDOB.remove('/') + memberId;
            acc.EID__pc = memberFirstName + memberLastName + memberDOB.remove('/') + memberId;
            Database.upsert(acc, Account.Fields.EID__c);
            System.debug('HERE IS THE PERSON ACCT1: ' + acc);
            Account personContact = [SELECT id, PersonContactId FROM Account where id=: acc.id];
            System.debug('HERE IS THE PERSON ACCT2: ' + acc);
            interaction.Originator__c = personContact.PersonContactId;
            interaction.Originator_Type__c = 'Member';
            interaction.Contact_Name__c = (memberFirstName != null && memberLastName != null)?memberFirstName + ' ' + memberLastName:'';
        } else if(origSfId != null && origSfId != ''){
			String query = 'SELECT Id,First_Name__c,Last_Name__c,Phone_Number__c,Email__c,Phone_Ext__c,Originator_Type__c,Agency_Broker_Name__c,Reward_Account_Number__c,General_Agency__c,Franchise_Code__c,Group_Name__c,Group_Number__c,Policy_Number__c,Other_Originator_Type__c FROM One_Click_Originator__c WHERE Id = \'' + origSfId + '\'';
	        List<One_Click_Originator__c> results = Database.query(query);
	        One_Click_Originator__c originator = new One_Click_Originator__c();
	        if(results.size() > 0){
	            originator = results[0];
                if(originator.Phone_Number__c != null && originator.Phone_Number__c.length() == 10){
                    originator.Phone_Number__c = originator.Phone_Number__c.substring(0,3) + '-' + originator.Phone_Number__c.substring(3,6) + '-' + originator.Phone_Number__c.substring(6,10);
                }
            	if(originator.Originator_Type__c != 'Internal UHG Employee'){
            		query = 'SELECT Id, Get_Encrypted_Fields__c From Third_Party__c WHERE Customer_Admin_Type__c = \'' + originator.Originator_Type__c + '\'';
	                if(originator.Originator_Type__c == 'Agency/Broker'){
		                	if(originator.Agency_Broker_Name__c != null && originator.Agency_Broker_Name__c != ''){
								query = query + ' AND Agency_Broker_Name__c = \'' + String.escapeSingleQuotes(originator.Agency_Broker_Name__c) + '\'';
							}
							if(originator.Reward_Account_Number__c != null && originator.Reward_Account_Number__c != ''){
								query = query + ' AND Reward_Account_Number__c = \'' + originator.Reward_Account_Number__c + '\'';
							}
		                } else if(originator.Originator_Type__c == 'General Agent'){
		                	if(originator.General_Agency__c != null && originator.General_Agency__c != ''){
								query = query + ' AND General_Agency__c = \'' + String.escapeSingleQuotes(originator.General_Agency__c) + '\'';
							}
							if(originator.Franchise_Code__c != null && originator.Franchise_Code__c != ''){
								query = query + ' AND Franchise_Code__c = \'' + originator.Franchise_Code__c + '\'';
							}
		                } else if(originator.Originator_Type__c == 'Group Contact'){
		                	if(originator.Policy_Number__c != null && originator.Policy_Number__c != ''){
								query = query + ' AND Policy_Number__c = \'' + originator.Policy_Number__c + '\'';
							}
		                } else if(originator.Originator_Type__c == 'Other Originator'){
		                	if(originator.Policy_Number__c != null && originator.Policy_Number__c != ''){
								query = query + ' AND Other_Admin_Type__c = \'' + originator.Other_Originator_Type__c + '\'';
							}
			            }
	                System.debug('HERE IS THE QUERY: ' + query);
	                List<Third_Party__c> tpResults = Database.query(query);
	                System.debug('HERE IS THE RESULT: ' + tpResults);
	                String grpName = (originator.Group_Name__c != null)?originator.Group_Name__c:'';
	                String grpNum = (originator.Group_Number__c != null)?originator.Group_Number__c:'';
               		String encryptedFieldsText = originator.First_Name__c + '|||||' + originator.Last_Name__c + '|||||' + originator.Email__c + '|||||' + originator.Phone_Number__c + '|||||' + grpName + '|||||' + grpNum; 
	                for(Integer i = 0; i < tpResults.size(); i++){
	                    System.debug('CHECKING ENCRYPTED KEY: ' + encryptedFieldsText);
	                    System.debug('CHECKING ENCRYPTED RES: ' + tpResults[i].Get_Encrypted_Fields__c);
	                    if(tpResults[i].Get_Encrypted_Fields__c == encryptedFieldsText){
	                        foundThirdPartyId = tpResults[i].Id;
	                        System.debug('FOUND THIRD PARTY: ' + foundThirdPartyId);
	                    }
	                }
	                System.debug('HERE IS THE TPID: ' + foundThirdPartyId);
            	}
            	if(originator.Originator_Type__c == 'Agency/Broker'){
	                interaction.Agency_Broker_Name__c = (originator.Agency_Broker_Name__c != null)?originator.Agency_Broker_Name__c:'';
	                interaction.Reward_Account_Number__c = (originator.Reward_Account_Number__c != null)?originator.Reward_Account_Number__c:'';
                    interaction.Originator_Type__c = 'Agency/Broker';                    
	                if(foundThirdPartyId == ''){
	                    thirdParty.Agency_Broker_Name__c = (originator.Agency_Broker_Name__c != null)?originator.Agency_Broker_Name__c:'';
	                    thirdParty.Reward_Account_Number__c = (originator.Reward_Account_Number__c != null)?originator.Reward_Account_Number__c:'';
	                }
	            } else if(originator.Originator_Type__c == 'General Agent'){
	                interaction.General_Agency__c = (originator.General_Agency__c != null)?originator.General_Agency__c:''; 
	                interaction.Franchise_Code__c = (originator.Franchise_Code__c != null)?originator.Franchise_Code__c:'';
                    interaction.Originator_Type__c = 'General Agent';
	                if(foundThirdPartyId == ''){
	                    thirdParty.General_Agency__c = (originator.General_Agency__c != null)?originator.General_Agency__c:''; 
	                    thirdParty.Franchise_Code__c = (originator.Franchise_Code__c != null)?originator.Franchise_Code__c:'';
	                }
	            } else if(originator.Originator_Type__c == 'Group Contact'){
	                interaction.Group_Name__c = (originator.Group_Name__c != null)?originator.Group_Name__c:''; 
	                interaction.Group_Number__c = (originator.Group_Number__c != null)?originator.Group_Number__c:'';
	                interaction.Policy_Number__c = (originator.Policy_Number__c != null)?originator.Policy_Number__c:'';
	                interaction.Originator_Type__c='Group Contact';
	                if(foundThirdPartyId == ''){ 
	                    thirdParty.Group_Name__c = (originator.Group_Name__c != null)?originator.Group_Name__c:''; 
	                    thirdParty.Group_Number__c = (originator.Group_Number__c != null)?originator.Group_Number__c:'';
	                    thirdParty.Policy_Number__c = (originator.Policy_Number__c != null)?originator.Policy_Number__c:'';
	                }
	            } else if(originator.Originator_Type__c == 'Other Originator'){
	                interaction.Other_Admin_Type__c = (originator.Other_Originator_Type__c != null)?originator.Other_Originator_Type__c:''; 
                    interaction.Originator_Type__c = 'Other Originator';
	                if(foundThirdPartyId == ''){ 
	                    thirdParty.Other_Admin_Type__c = (originator.Other_Originator_Type__c != null)?originator.Other_Originator_Type__c:''; 
	                }
	            } else if(originator.Originator_Type__c == 'Internal UHG Employee'){
	                //interaction.Originator_Name__c = (custAdmin.firstName != null && custAdmin.lastName != null)?custAdmin.firstName + ' ' + custAdmin.lastName:'';
	                Account acc = new Account();
	                Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
	                acc.RecordTypeId = personAccountRecordTypeId;
	                acc.FirstName = (originator.First_Name__c != null)?originator.First_Name__c:'';
	                acc.LastName = (originator.Last_Name__c != null)?originator.Last_Name__c:'';
	                acc.Phone = (originator.Phone_Number__c != null)?originator.Phone_Number__c:'000-000-0000';
	                acc.PersonEmail = (originator.Email__c != null)?originator.Email__c:'';
	                acc.EID__c = (originator.Email__c != null)?originator.Email__c:'';
	                acc.EID__pc = (originator.Email__c != null)?originator.Email__c:'';
	                Database.upsert(acc, Account.Fields.EID__c);
	                System.debug('HERE IS THE PERSON ACCT1: ' + acc);
	                Account personContact = [SELECT id, PersonContactId FROM Account where id=: acc.id];
	                System.debug('HERE IS THE PERSON ACCT2: ' + acc);
	                interaction.Originator__c = personContact.PersonContactId;
	                interaction.Originator_Type__c = 'Internal UHG Employee';
	                 
	            }
	            if(originator.Originator_Type__c != 'Internal UHG Employee'){
	                if(foundThirdPartyId == ''){
	                    thirdParty.First_Name__c = (originator.First_Name__c != null)?originator.First_Name__c:'';
	                    thirdParty.LastName__c = (originator.Last_Name__c != null)?originator.Last_Name__c:'';
	                    thirdParty.Email__c = (originator.Email__c != null)?originator.Email__c:'';
	                    thirdParty.Phone_Number__c = (originator.Phone_Number__c != null)?originator.Phone_Number__c:'000-000-0000';
	                    thirdParty.Customer_Admin_Type__c = (originator.Originator_Type__c != null)?originator.Originator_Type__c:'';
	                    insert thirdParty;
	                    interaction.Third_Party__c = (thirdParty.Id != null)?thirdParty.Id:'';
	                } else if(foundThirdPartyId != ''){
	                    interaction.Third_Party__c = foundThirdPartyId;
	                }
	            }
	            interaction.Contact_Name__c = (originator.First_Name__c != null && originator.Last_Name__c != null)?originator.First_Name__c + ' ' + originator.Last_Name__c:'';
	            Interaction.Customer_Admin_Type__c = (originator.Originator_Type__c != null)?originator.Originator_Type__c:'';
	            interaction.Originator_Phone__c = (originator.Phone_Number__c != null)?originator.Phone_Number__c:'000-000-0000';
	            interaction.Originator_Extension__c = (originator.Phone_Ext__c != null)?originator.Phone_Ext__c:'';
	            interaction.Originator_Email__c = (originator.Email__c != null)?originator.Email__c:'';
                interaction.Originator_SFID__c = (originator.Id != null)?originator.Id:'';
                String otherAdminTypeVal = originator.Other_Originator_Type__c;
                otherAdminTypeVal = (otherAdminTypeVal != null) ? otherAdminTypeVal : '';
                interaction.Originator_Relationship__c = otherAdminTypeVal;
	            System.debug('HERE IS THE INTERACTION: ' + interaction);

            }
        }
        insert interaction;
        Interaction__c newInteraction = new Interaction__c();
        newInteraction = (Interaction__c) Database.query('SELECT Id, Interaction_Type__c, Name, Originator_Name__c FROM Interaction__c WHERE Id = \'' + interaction.Id + '\'');
        return newInteraction;
    }
    @AuraEnabled
    public static Interaction__c updateInteractionOneNDone(String origSfId, String interactionType, Date eventDate, String eventTime, String memberFirstName, String memberLastName, String memberDOB, String memberId, String updateIntId){
        System.debug('HERE IS THE CREATE INTERACTION');
        System.debug('DATE AND TIME: ' + interactionType);
        System.debug('DATE AND TIME: ' + eventDate);
        System.debug('DATE AND TIME: ' + eventTime);
        Interaction__c interaction = new Interaction__c();
        System.debug('EVENTRECDATE: ' + eventDate);
        System.debug('EVENTRECTIME: ' + eventTime);
        Third_Party__c thirdParty = new Third_Party__c();
        String foundThirdPartyId = '';
        if(updateIntId != ''){
    		interaction.Id = updateIntId;
    		
	        if(eventDate != null && eventTime != null && eventTime != '' && eventTime.contains(':')){
	            Integer hours = Integer.valueOf(eventTime.split(':')[0]);
	            Integer mins = Integer.valueOf(eventTime.split(':')[1]);
	            Time newTime = Time.newInstance(hours,mins,0,0);
	            DateTime dt = DateTime.newInstance(eventDate,newTime);
	            interaction.Evt_Recvd_Dt_Time__c = dt;	
	            System.debug('FINAL DATETIME: ' + interaction.Evt_Recvd_Dt_Time__c);
	        } 
	        interaction.Interaction_Type__c = (interactionType != null && interactionType != '')?interactionType:'Phone Call';
	        if(memberFirstName != null && memberFirstName != '' && memberLastName != null && memberLastName != '' && memberDOB != null && memberDOB != '' && memberId != null && memberId != ''){
	            Account acc = new Account();
	            Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
	            acc.RecordTypeId = personAccountRecordTypeId;
	            acc.FirstName = (memberFirstName != null)?memberFirstName:'';
		        acc.LastName = (memberLastName != null)?memberLastName:'';
		        acc.PersonBirthdate = Date.parse(memberDOB);
	            System.debug('HERE IS THE EID: ' + memberFirstName + memberLastName + memberDOB.remove('/') + memberId);
	            acc.EID__c = memberFirstName + memberLastName + memberDOB.remove('/') + memberId;
	            acc.EID__pc = memberFirstName + memberLastName + memberDOB.remove('/') + memberId;
                acc.Phone = '000-000-0000';
	            Database.upsert(acc, Account.Fields.EID__c);
	            System.debug('HERE IS THE PERSON ACCT1: ' + acc);
	            Account personContact = [SELECT id, PersonContactId FROM Account where id=: acc.id];
	            System.debug('HERE IS THE PERSON ACCT2: ' + acc);
	            interaction.Originator__c = personContact.PersonContactId;
	            interaction.Originator_Type__c = 'Member';
	            interaction.Contact_Name__c = (memberFirstName != null && memberLastName != null)?memberFirstName + ' ' + memberLastName:'';
	            User userDetails =[SELECT Id, UserRole.Name FROM User where Id =: UserInfo.getUserId()];
                interaction.OwnerId = userDetails.Id;
	            update interaction;
	        } else if(origSfId != null && origSfId != ''){
				String query = 'SELECT Id,First_Name__c,Last_Name__c,Phone_Number__c,Email__c,Phone_Ext__c,Originator_Type__c,Agency_Broker_Name__c,Reward_Account_Number__c,General_Agency__c,Franchise_Code__c,Group_Name__c,Group_Number__c,Policy_Number__c,Other_Originator_Type__c FROM One_Click_Originator__c WHERE Id = \'' + origSfId + '\'';
		        List<One_Click_Originator__c> results = Database.query(query);
		        One_Click_Originator__c originator = new One_Click_Originator__c();
		        if(results.size() > 0){
		            originator = results[0];
	                if(originator.Phone_Number__c != null && originator.Phone_Number__c.length() == 10){
	                    originator.Phone_Number__c = originator.Phone_Number__c.substring(0,3) + '-' + originator.Phone_Number__c.substring(3,6) + '-' + originator.Phone_Number__c.substring(6,10);
	                }
	            	if(originator.Originator_Type__c != 'Internal UHG Employee'){
	            		query = 'SELECT Id, Get_Encrypted_Fields__c From Third_Party__c WHERE Customer_Admin_Type__c = \'' + originator.Originator_Type__c + '\'';
		                if(originator.Originator_Type__c == 'Agency/Broker'){
			                	if(originator.Agency_Broker_Name__c != null && originator.Agency_Broker_Name__c != ''){
									query = query + ' AND Agency_Broker_Name__c = \'' + String.escapeSingleQuotes(originator.Agency_Broker_Name__c) + '\'';
								}
								if(originator.Reward_Account_Number__c != null && originator.Reward_Account_Number__c != ''){
									query = query + ' AND Reward_Account_Number__c = \'' + originator.Reward_Account_Number__c + '\'';
								}
			                } else if(originator.Originator_Type__c == 'General Agent'){
			                	if(originator.General_Agency__c != null && originator.General_Agency__c != ''){
									query = query + ' AND General_Agency__c = \'' + String.escapeSingleQuotes(originator.General_Agency__c) + '\'';
								}
								if(originator.Franchise_Code__c != null && originator.Franchise_Code__c != ''){
									query = query + ' AND Franchise_Code__c = \'' + originator.Franchise_Code__c + '\'';
								}
			                } else if(originator.Originator_Type__c == 'Group Contact'){
			                	if(originator.Policy_Number__c != null && originator.Policy_Number__c != ''){
									query = query + ' AND Policy_Number__c = \'' + originator.Policy_Number__c + '\'';
								}
			                } else if(originator.Originator_Type__c == 'Other Originator'){
			                	if(originator.Policy_Number__c != null && originator.Policy_Number__c != ''){
									query = query + ' AND Other_Admin_Type__c = \'' + originator.Other_Originator_Type__c + '\'';
								}
				            }
		                System.debug('HERE IS THE QUERY: ' + query);
		                List<Third_Party__c> tpResults = Database.query(query);
		                System.debug('HERE IS THE RESULT: ' + tpResults);
		                String grpName = (originator.Group_Name__c != null)?originator.Group_Name__c:'';
		                String grpNum = (originator.Group_Number__c != null)?originator.Group_Number__c:'';
	               		String encryptedFieldsText = originator.First_Name__c + '|||||' + originator.Last_Name__c + '|||||' + originator.Email__c + '|||||' + originator.Phone_Number__c + '|||||' + grpName + '|||||' + grpNum; 
		                for(Integer i = 0; i < tpResults.size(); i++){
		                    System.debug('CHECKING ENCRYPTED KEY: ' + encryptedFieldsText);
		                    System.debug('CHECKING ENCRYPTED RES: ' + tpResults[i].Get_Encrypted_Fields__c);
		                    if(tpResults[i].Get_Encrypted_Fields__c == encryptedFieldsText){
		                        foundThirdPartyId = tpResults[i].Id;
		                        System.debug('FOUND THIRD PARTY: ' + foundThirdPartyId);
		                    }
		                }
		                System.debug('HERE IS THE TPID: ' + foundThirdPartyId);
	            	}
	            	if(originator.Originator_Type__c == 'Agency/Broker'){
		                interaction.Agency_Broker_Name__c = (originator.Agency_Broker_Name__c != null)?originator.Agency_Broker_Name__c:'';
		                interaction.Reward_Account_Number__c = (originator.Reward_Account_Number__c != null)?originator.Reward_Account_Number__c:'';
	                    interaction.Originator_Type__c = 'Agency/Broker';                    
		                if(foundThirdPartyId == ''){
		                    thirdParty.Agency_Broker_Name__c = (originator.Agency_Broker_Name__c != null)?originator.Agency_Broker_Name__c:'';
		                    thirdParty.Reward_Account_Number__c = (originator.Reward_Account_Number__c != null)?originator.Reward_Account_Number__c:'';
		                }
		            } else if(originator.Originator_Type__c == 'General Agent'){
		                interaction.General_Agency__c = (originator.General_Agency__c != null)?originator.General_Agency__c:''; 
		                interaction.Franchise_Code__c = (originator.Franchise_Code__c != null)?originator.Franchise_Code__c:'';
	                    interaction.Originator_Type__c = 'General Agent';
		                if(foundThirdPartyId == ''){
		                    thirdParty.General_Agency__c = (originator.General_Agency__c != null)?originator.General_Agency__c:''; 
		                    thirdParty.Franchise_Code__c = (originator.Franchise_Code__c != null)?originator.Franchise_Code__c:'';
		                }
		            } else if(originator.Originator_Type__c == 'Group Contact'){
		                interaction.Group_Name__c = (originator.Group_Name__c != null)?originator.Group_Name__c:''; 
		                interaction.Group_Number__c = (originator.Group_Number__c != null)?originator.Group_Number__c:'';
		                interaction.Policy_Number__c = (originator.Policy_Number__c != null)?originator.Policy_Number__c:'';
		                interaction.Originator_Type__c='Group Contact';
		                if(foundThirdPartyId == ''){ 
		                    thirdParty.Group_Name__c = (originator.Group_Name__c != null)?originator.Group_Name__c:''; 
		                    thirdParty.Group_Number__c = (originator.Group_Number__c != null)?originator.Group_Number__c:'';
		                    thirdParty.Policy_Number__c = (originator.Policy_Number__c != null)?originator.Policy_Number__c:'';
		                }
		            } else if(originator.Originator_Type__c == 'Other Originator'){
		                interaction.Other_Admin_Type__c = (originator.Other_Originator_Type__c != null)?originator.Other_Originator_Type__c:''; 
	                    interaction.Originator_Type__c = 'Other Originator';
		                if(foundThirdPartyId == ''){ 
		                    thirdParty.Other_Admin_Type__c = (originator.Other_Originator_Type__c != null)?originator.Other_Originator_Type__c:''; 
		                }
		            } else if(originator.Originator_Type__c == 'Internal UHG Employee'){
		                //interaction.Originator_Name__c = (custAdmin.firstName != null && custAdmin.lastName != null)?custAdmin.firstName + ' ' + custAdmin.lastName:'';
		                Account acc = new Account();
		                Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
		                acc.RecordTypeId = personAccountRecordTypeId;
		                acc.FirstName = (originator.First_Name__c != null)?originator.First_Name__c:'';
		                acc.LastName = (originator.Last_Name__c != null)?originator.Last_Name__c:'';
		                acc.Phone = (originator.Phone_Number__c != null)?originator.Phone_Number__c:'000-000-0000';
		                acc.PersonEmail = (originator.Email__c != null)?originator.Email__c:'';
		                acc.EID__c = (originator.Email__c != null)?originator.Email__c:'';
		                acc.EID__pc = (originator.Email__c != null)?originator.Email__c:'';
		                Database.upsert(acc, Account.Fields.EID__c);
		                System.debug('HERE IS THE PERSON ACCT1: ' + acc);
		                Account personContact = [SELECT id, PersonContactId FROM Account where id=: acc.id];
		                System.debug('HERE IS THE PERSON ACCT2: ' + acc);
		                interaction.Originator__c = personContact.PersonContactId;
		                interaction.Originator_Type__c = 'Internal UHG Employee';
		                 
		            }
		            if(originator.Originator_Type__c != 'Internal UHG Employee'){
		                if(foundThirdPartyId == ''){
		                    thirdParty.First_Name__c = (originator.First_Name__c != null)?originator.First_Name__c:'';
		                    thirdParty.LastName__c = (originator.Last_Name__c != null)?originator.Last_Name__c:'';
		                    thirdParty.Email__c = (originator.Email__c != null)?originator.Email__c:'';
		                    thirdParty.Phone_Number__c = (originator.Phone_Number__c != null)?originator.Phone_Number__c:'000-000-0000';
		                    thirdParty.Customer_Admin_Type__c = (originator.Originator_Type__c != null)?originator.Originator_Type__c:'';
		                    insert thirdParty;
		                    interaction.Third_Party__c = (thirdParty.Id != null)?thirdParty.Id:'';
		                } else if(foundThirdPartyId != ''){
		                    interaction.Third_Party__c = foundThirdPartyId;
		                }
		            }
		            interaction.Contact_Name__c = (originator.First_Name__c != null && originator.Last_Name__c != null)?originator.First_Name__c + ' ' + originator.Last_Name__c:'';
		            Interaction.Customer_Admin_Type__c = (originator.Originator_Type__c != null)?originator.Originator_Type__c:'';
		            interaction.Originator_Phone__c = (originator.Phone_Number__c != null)?originator.Phone_Number__c:'000-000-0000';
		            interaction.Originator_Extension__c = (originator.Phone_Ext__c != null)?originator.Phone_Ext__c:'';
		            interaction.Originator_Email__c = (originator.Email__c != null)?originator.Email__c:'';
                    interaction.Originator_SFID__c = (originator.Id != null)?originator.Id:'';
	                String otherAdminTypeVal = originator.Other_Originator_Type__c;
	                otherAdminTypeVal = (otherAdminTypeVal != null) ? otherAdminTypeVal : '';
	                interaction.Originator_Relationship__c = otherAdminTypeVal;
	                User userDetails =[SELECT Id, UserRole.Name FROM User where Id =: UserInfo.getUserId()];
                	interaction.OwnerId = userDetails.Id;
		            System.debug('HERE IS THE INTERACTION: ' + interaction);
					update interaction;
	            }
	        }
	    	update interaction;
        }
        Interaction__c newInteraction = new Interaction__c();
        newInteraction = (Interaction__c) Database.query('SELECT Id, Interaction_Type__c, Name, Originator_Name__c FROM Interaction__c WHERE Id = \'' + updateIntId + '\'');
        return newInteraction;
    }
    @AuraEnabled
    public static Interaction__c updateInteractionStandard(String origSfId, String interactionType, Date eventReceivedDate, String eventReceivedTime,String memberFirstName, String memberLastName, String memberDOB, String memberId, String updateIntId){
    	Interaction__c interaction = new Interaction__c();
    	String foundThirdPartyId = '';
        Third_Party__c thirdParty = new Third_Party__c();
        System.debug('PASSED INTERACTION: ' + updateIntId);
        System.debug('PASSED ORIGID: ' + origSfId);
    	if(updateIntId != ''){
    		interaction.Id = updateIntId;
    		interaction.Interaction_Type__c = (interactionType != null)?interactionType:'';
		    if(eventReceivedDate != null && eventReceivedTime != null && eventReceivedTime != '' && eventReceivedTime.contains(':')){
		    	Integer hours = Integer.valueOf(eventReceivedTime.split(':')[0]);
		    	Integer mins = Integer.valueOf(eventReceivedTime.split(':')[1]);
		    	Time newTime = Time.newInstance(hours,mins,0,0);
		    	DateTime dt = DateTime.newInstance(eventReceivedDate,newTime);
		    	interaction.Evt_Recvd_Dt_Time__c = dt;	
		    	System.debug('FINAL DATETIME: ' + interaction.Evt_Recvd_Dt_Time__c);
		    }
	    	if(memberFirstName != null && memberFirstName != '' && memberLastName != null && memberLastName != '' && memberDOB != null && memberDOB != '' && memberId != null && memberId != ''){
	            Account acc = new Account();
	            Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
	            acc.RecordTypeId = personAccountRecordTypeId;
	            acc.FirstName = (memberFirstName != null)?memberFirstName:'';
		        acc.LastName = (memberLastName != null)?memberLastName:'';
		        acc.PersonBirthdate = Date.parse(memberDOB);
                acc.Phone = '000-000-0000';
	            System.debug('HERE IS THE EID: ' + memberFirstName + memberLastName + memberDOB.remove('/') + memberId);
	            acc.EID__c = memberFirstName + memberLastName + memberDOB.remove('/') + memberId;
	            acc.EID__pc = memberFirstName + memberLastName + memberDOB.remove('/') + memberId;
	            Database.upsert(acc, Account.Fields.EID__c);
	            System.debug('HERE IS THE PERSON ACCT1: ' + acc);
	            Account personContact = [SELECT id, PersonContactId FROM Account where id=: acc.id];
	            System.debug('HERE IS THE PERSON ACCT2: ' + acc);
	            interaction.Originator__c = personContact.PersonContactId;
	            interaction.Originator_Type__c = 'Member';
	            interaction.Contact_Name__c = (memberFirstName != null && memberLastName != null)?memberFirstName + ' ' + memberLastName:'';
	            User userDetails =[SELECT Id, UserRole.Name FROM User where Id =: UserInfo.getUserId()];
                interaction.OwnerId = userDetails.Id;
	            update interaction;
	    	 } else if(origSfId != null && origSfId != ''){
	    	 	String query = 'SELECT Id,First_Name__c,Last_Name__c,Phone_Number__c,Email__c,Phone_Ext__c,Originator_Type__c,Agency_Broker_Name__c,Reward_Account_Number__c,General_Agency__c,Franchise_Code__c,Group_Name__c,Group_Number__c,Policy_Number__c,Other_Originator_Type__c FROM One_Click_Originator__c WHERE Id = \'' + origSfId + '\'';
		        List<One_Click_Originator__c> results = Database.query(query);
		        One_Click_Originator__c originator = new One_Click_Originator__c();
		        if(results.size() > 0){
		            originator = results[0];
	                if(originator.Phone_Number__c != null && originator.Phone_Number__c.length() == 10){
	                    originator.Phone_Number__c = originator.Phone_Number__c.substring(0,3) + '-' + originator.Phone_Number__c.substring(3,6) + '-' + originator.Phone_Number__c.substring(6,10);
	                }
		        }
		        if(originator.Originator_Type__c != 'Internal UHG Employee'){
            		query = 'SELECT Id, Get_Encrypted_Fields__c From Third_Party__c WHERE Customer_Admin_Type__c = \'' + originator.Originator_Type__c + '\'';
	                if(originator.Originator_Type__c == 'Agency/Broker'){
	                	if(originator.Agency_Broker_Name__c != null && originator.Agency_Broker_Name__c != ''){
							query = query + ' AND Agency_Broker_Name__c = \'' + String.escapeSingleQuotes(originator.Agency_Broker_Name__c) + '\'';
						}
						if(originator.Reward_Account_Number__c != null && originator.Reward_Account_Number__c != ''){
							query = query + ' AND Reward_Account_Number__c = \'' + originator.Reward_Account_Number__c + '\'';
						}
	                } else if(originator.Originator_Type__c == 'General Agent'){
	                	if(originator.General_Agency__c != null && originator.General_Agency__c != ''){
							query = query + ' AND General_Agency__c = \'' + String.escapeSingleQuotes(originator.General_Agency__c) + '\'';
						}
						if(originator.Franchise_Code__c != null && originator.Franchise_Code__c != ''){
							query = query + ' AND Franchise_Code__c = \'' + originator.Franchise_Code__c + '\'';
						}
	                } else if(originator.Originator_Type__c == 'Group Contact'){
	                	if(originator.Policy_Number__c != null && originator.Policy_Number__c != ''){
							query = query + ' AND Policy_Number__c = \'' + originator.Policy_Number__c + '\'';
						}
	                } else if(originator.Originator_Type__c == 'Other Originator'){
	                	if(originator.Policy_Number__c != null && originator.Policy_Number__c != ''){
							query = query + ' AND Other_Admin_Type__c = \'' + originator.Other_Originator_Type__c + '\'';
						}
		            }
	                System.debug('HERE IS THE QUERY: ' + query);
	                List<Third_Party__c> tpResults = Database.query(query);
	                System.debug('HERE IS THE RESULT: ' + tpResults);
               		String grpName = (originator.Group_Name__c != null)?originator.Group_Name__c:'';
	                String grpNum = (originator.Group_Number__c != null)?originator.Group_Number__c:'';
               		String encryptedFieldsText = originator.First_Name__c + '|||||' + originator.Last_Name__c + '|||||' + originator.Email__c + '|||||' + originator.Phone_Number__c + '|||||' + grpName + '|||||' + grpNum;  
	                for(Integer i = 0; i < tpResults.size(); i++){
	                    System.debug('CHECKING ENCRYPTED KEY: ' + encryptedFieldsText);
	                    System.debug('CHECKING ENCRYPTED RES: ' + tpResults[i].Get_Encrypted_Fields__c);
	                    if(tpResults[i].Get_Encrypted_Fields__c == encryptedFieldsText){
	                        foundThirdPartyId = tpResults[i].Id;
	                        System.debug('FOUND THIRD PARTY: ' + foundThirdPartyId);
	                    }
	                }
	                System.debug('HERE IS THE TPID: ' + foundThirdPartyId);
            	}
            	if(originator.Originator_Type__c == 'Agency/Broker'){
	                interaction.Agency_Broker_Name__c = (originator.Agency_Broker_Name__c != null)?originator.Agency_Broker_Name__c:'';
	                interaction.Reward_Account_Number__c = (originator.Reward_Account_Number__c != null)?originator.Reward_Account_Number__c:'';
                    interaction.Originator_Type__c = 'Agency/Broker';                    
	                if(foundThirdPartyId == ''){
	                    thirdParty.Agency_Broker_Name__c = (originator.Agency_Broker_Name__c != null)?originator.Agency_Broker_Name__c:'';
	                    thirdParty.Reward_Account_Number__c = (originator.Reward_Account_Number__c != null)?originator.Reward_Account_Number__c:'';
	                }
	            } else if(originator.Originator_Type__c == 'General Agent'){
	                interaction.General_Agency__c = (originator.General_Agency__c != null)?originator.General_Agency__c:''; 
	                interaction.Franchise_Code__c = (originator.Franchise_Code__c != null)?originator.Franchise_Code__c:'';
                    interaction.Originator_Type__c = 'General Agent';
	                if(foundThirdPartyId == ''){
	                    thirdParty.General_Agency__c = (originator.General_Agency__c != null)?originator.General_Agency__c:''; 
	                    thirdParty.Franchise_Code__c = (originator.Franchise_Code__c != null)?originator.Franchise_Code__c:'';
	                }
	            } else if(originator.Originator_Type__c == 'Group Contact'){
	                interaction.Group_Name__c = (originator.Group_Name__c != null)?originator.Group_Name__c:''; 
	                interaction.Group_Number__c = (originator.Group_Number__c != null)?originator.Group_Number__c:'';
	                interaction.Policy_Number__c = (originator.Policy_Number__c != null)?originator.Policy_Number__c:'';
	                interaction.Originator_Type__c='Group Contact';
	                if(foundThirdPartyId == ''){ 
	                    thirdParty.Group_Name__c = (originator.Group_Name__c != null)?originator.Group_Name__c:''; 
	                    thirdParty.Group_Number__c = (originator.Group_Number__c != null)?originator.Group_Number__c:'';
	                    thirdParty.Policy_Number__c = (originator.Policy_Number__c != null)?originator.Policy_Number__c:'';
	                }
	            } else if(originator.Originator_Type__c == 'Other Originator'){
	                interaction.Other_Admin_Type__c = (originator.Other_Originator_Type__c != null)?originator.Other_Originator_Type__c:''; 
                    interaction.Originator_Type__c = 'Other Originator';
	                if(foundThirdPartyId == ''){ 
	                    thirdParty.Other_Admin_Type__c = (originator.Other_Originator_Type__c != null)?originator.Other_Originator_Type__c:''; 
	                }
	            } else if(originator.Originator_Type__c == 'Internal UHG Employee'){
	                //interaction.Originator_Name__c = (custAdmin.firstName != null && custAdmin.lastName != null)?custAdmin.firstName + ' ' + custAdmin.lastName:'';
	                Account acc = new Account();
	                Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
	                acc.RecordTypeId = personAccountRecordTypeId;
	                acc.FirstName = (originator.First_Name__c != null)?originator.First_Name__c:'';
	                acc.LastName = (originator.Last_Name__c != null)?originator.Last_Name__c:'';
	                acc.Phone = (originator.Phone_Number__c != null)?originator.Phone_Number__c:'000-000-0000';
	                acc.PersonEmail = (originator.Email__c != null)?originator.Email__c:'';
	                acc.EID__c = (originator.Email__c != null)?originator.Email__c:'';
	                acc.EID__pc = (originator.Email__c != null)?originator.Email__c:'';
                    interaction.Originator_SFID__c = (originator.Id != null)?originator.Id:'';
	                Database.upsert(acc, Account.Fields.EID__c);
	                System.debug('HERE IS THE PERSON ACCT1: ' + acc);
	                Account personContact = [SELECT id, PersonContactId FROM Account where id=: acc.id];
	                System.debug('HERE IS THE PERSON ACCT2: ' + acc);
	                interaction.Originator__c = personContact.PersonContactId;
	                interaction.Originator_Type__c = 'Internal UHG Employee';
	                 
	            }
	            if(originator.Originator_Type__c != 'Internal UHG Employee'){
	                if(foundThirdPartyId == ''){
	                    thirdParty.First_Name__c = (originator.First_Name__c != null)?originator.First_Name__c:'';
	                    thirdParty.LastName__c = (originator.Last_Name__c != null)?originator.Last_Name__c:'';
	                    thirdParty.Email__c = (originator.Email__c != null)?originator.Email__c:'';
	                    thirdParty.Phone_Number__c = (originator.Phone_Number__c != null)?originator.Phone_Number__c:'000-000-0000';
	                    thirdParty.Customer_Admin_Type__c = (originator.Originator_Type__c != null)?originator.Originator_Type__c:'';
	                    insert thirdParty;
	                    interaction.Third_Party__c = (thirdParty.Id != null)?thirdParty.Id:'';
	                } else if(foundThirdPartyId != ''){
	                    interaction.Third_Party__c = foundThirdPartyId;
	                }
	            }
	            interaction.Contact_Name__c = (originator.First_Name__c != null && originator.Last_Name__c != null)?originator.First_Name__c + ' ' + originator.Last_Name__c:'';
	            Interaction.Customer_Admin_Type__c = (originator.Originator_Type__c != null)?originator.Originator_Type__c:'';
	            interaction.Originator_Phone__c = (originator.Phone_Number__c != null)?originator.Phone_Number__c:'000-000-0000';
	            interaction.Originator_Extension__c = (originator.Phone_Ext__c != null)?originator.Phone_Ext__c:'';
	            interaction.Originator_Email__c = (originator.Email__c != null)?originator.Email__c:'';
                interaction.Originator_SFID__c = (originator.Id != null)?originator.Id:'';
                String otherAdminTypeVal = originator.Other_Originator_Type__c;
                otherAdminTypeVal = (otherAdminTypeVal != null) ? otherAdminTypeVal : '';
                interaction.Originator_Relationship__c = otherAdminTypeVal;
                User userDetails =[SELECT Id, UserRole.Name FROM User where Id =: UserInfo.getUserId()];
                interaction.OwnerId = userDetails.Id;
	            System.debug('HERE IS THE INTERACTION: ' + interaction);
	    	 	update interaction;
	    	 }
    	}
    	System.debug('FINAL INTERACTION: ' + interaction);
    	Interaction__c newInteraction = new Interaction__c();
        if(updateIntId != ''){
        	newInteraction = (Interaction__c) Database.query('SELECT Id, Interaction_Type__c, Name, Originator_Name__c, Originator__c, Current_Status__c, Resolution_Date__c FROM Interaction__c WHERE Id = \'' + updateIntId + '\'');
        } 
        return newInteraction;
    }
    
    @AuraEnabled
    public static Interaction__c createInteractionStandard(String origSfId, String interactionType, Date eventReceivedDate, String eventReceivedTime,String memberFirstName, String memberLastName, String memberDOB, String memberId){
        Interaction__c interaction = new Interaction__c();
        String foundInteractionId = '';
        String foundThirdPartyId = '';
        Id intrecid = Schema.SObjectType.Interaction__c.getRecordTypeInfosByDeveloperName().get('BEO_Interaction').getRecordTypeId();
       
        Third_Party__c thirdParty = new Third_Party__c();
        interaction.Interaction_Type__c = (interactionType != null)?interactionType:'';
        interaction.recordtypeid=intrecid;
        if(eventReceivedDate != null && eventReceivedTime != null && eventReceivedTime != '' && eventReceivedTime.contains(':')){
        	Integer hours = Integer.valueOf(eventReceivedTime.split(':')[0]);
        	Integer mins = Integer.valueOf(eventReceivedTime.split(':')[1]);
        	Time newTime = Time.newInstance(hours,mins,0,0);
        	DateTime dt = DateTime.newInstance(eventReceivedDate,newTime);
        	interaction.Evt_Recvd_Dt_Time__c = dt;	
        	System.debug('FINAL DATETIME: ' + interaction.Evt_Recvd_Dt_Time__c);
        }
        
        if(memberFirstName != null && memberFirstName != '' && memberLastName != null && memberLastName != '' && memberDOB != null && memberDOB != '' && memberId != null && memberId != ''){
            Account acc = new Account();
            Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
            acc.RecordTypeId = personAccountRecordTypeId;
            acc.FirstName = (memberFirstName != null)?memberFirstName:'';
	        acc.LastName = (memberLastName != null)?memberLastName:'';
	        acc.PersonBirthdate = Date.parse(memberDOB);
            acc.Phone = '000-000-0000';
            System.debug('HERE IS THE EID: ' + memberFirstName + memberLastName + memberDOB.remove('/') + memberId);
            acc.EID__c = memberFirstName + memberLastName + memberDOB.remove('/') + memberId;
            acc.EID__pc = memberFirstName + memberLastName + memberDOB.remove('/') + memberId;
            Database.upsert(acc, Account.Fields.EID__c);
            System.debug('HERE IS THE PERSON ACCT1: ' + acc);
            Account personContact = [SELECT id, PersonContactId FROM Account where id=: acc.id];
            System.debug('HERE IS THE PERSON ACCT2: ' + acc);
            /* DE341644 - 7/6/20 below logic has been commented out to remove automatic linking of cases to existing interactions, which may be re-implemented at a future date
            String intQuery = '';
            intQuery = 'SELECT Id, Get_Encrypted_Originator_Contact_Name__c From Interaction__c WHERE'
            + ' Originator__c = \'' + personContact.PersonContactId + '\'';
            intQuery = intQuery + ' AND Interaction_Type__c = \'' + interactionType + '\'';
            if(eventReceivedDate != null && eventReceivedTime != null && eventReceivedTime != '' && eventReceivedTime.contains(':')){
            	Integer hours = Integer.valueOf(eventReceivedTime.split(':')[0]);
            	Integer mins = Integer.valueOf(eventReceivedTime.split(':')[1]);
            	Time newTime = Time.newInstance(hours,mins,0,0);
            	DateTime dt = DateTime.newInstance(eventReceivedDate,newTime);
            	String dtString = dt.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
            	System.debug('FINAL DATETIME0: ' + dtString);
            	intQuery = intQuery + ' AND Evt_Recvd_Dt_Time__c = ' + dtString;
            }
            System.debug('INTERACTION QUERY: ' + intQuery);
            List<Interaction__c> intResults = Database.query(intQuery);
            System.debug('INTERACTION Results: ' + intResults);
            String encryptedIntFields = memberFirstName + ' ' + memberLastName + '|||||' +  memberFirstName + ' ' + memberLastName;
            for(Integer i = 0; i < intResults.size(); i++){
                System.debug('CHECKING ENCRYPTED KEY: ' + encryptedIntFields);
                System.debug('CHECKING ENCRYPTED RES: ' + intResults[i].Get_Encrypted_Originator_Contact_Name__c);
                if(intResults[i].Get_Encrypted_Originator_Contact_Name__c == encryptedIntFields){
                    foundInteractionId = intResults[i].Id;
                    System.debug('FOUND INTERACTION: ' + foundInteractionId);
                }
            }*/
			if(foundInteractionId == ''){
	            interaction.Originator__c = personContact.PersonContactId;
	            interaction.Originator_Type__c = 'Member';
	            interaction.Contact_Name__c = (memberFirstName != null && memberLastName != null)?memberFirstName + ' ' + memberLastName:'';
	            insert interaction;
            }
        } else if(origSfId != null && origSfId != ''){
        	String query = 'SELECT Id,First_Name__c,Last_Name__c,Phone_Number__c,Email__c,Phone_Ext__c,Originator_Type__c,Agency_Broker_Name__c,Reward_Account_Number__c,General_Agency__c,Franchise_Code__c,Group_Name__c,Group_Number__c,Policy_Number__c,Other_Originator_Type__c FROM One_Click_Originator__c WHERE Id = \'' + origSfId + '\'';
	        List<One_Click_Originator__c> results = Database.query(query);
	        One_Click_Originator__c originator = new One_Click_Originator__c();
	        if(results.size() > 0){
	            originator = results[0];
                if(originator.Phone_Number__c != null && originator.Phone_Number__c.length() == 10){
                    originator.Phone_Number__c = originator.Phone_Number__c.substring(0,3) + '-' + originator.Phone_Number__c.substring(3,6) + '-' + originator.Phone_Number__c.substring(6,10);
                }
                /* DE341644 - 7/6/20 below logic has been commented out to remove automatic linking of cases to existing interactions, which may be re-implemented at a future date
	            String intQuery = '';
	            //check for Id != '' so we don't have to dynamically add the "AND" after the first condition is added
	            intQuery = 'SELECT Id, Get_Encrypted_Originator_Contact_Name__c From Interaction__c WHERE Id != \'\'';
	            if(originator.Phone_Number__c != null && originator.Phone_Number__c != ''){
	            	intQuery = intQuery + ' AND Originator_Phone__c = \'' + originator.Phone_Number__c + '\'';
	            }
	            if(originator.Email__c != null && originator.Email__c != ''){
	            	intQuery = intQuery + ' AND Originator_Email__c = \'' + String.escapeSingleQuotes(originator.Email__c) + '\'';
	            }
				if(originator.Originator_Type__c == 'Agency/Broker'){
					if(originator.Agency_Broker_Name__c != null && originator.Agency_Broker_Name__c != ''){
						intQuery = intQuery + ' AND Agency_Broker_Name__c = \'' + String.escapeSingleQuotes(originator.Agency_Broker_Name__c) + '\'';
					}
					if(originator.Reward_Account_Number__c != null && originator.Reward_Account_Number__c != ''){
						intQuery = intQuery + ' AND Reward_Account_Number__c = \'' + originator.Reward_Account_Number__c + '\'';
					}
				} else if(originator.Originator_Type__c == 'General Agent'){
					if(originator.General_Agency__c != null && originator.General_Agency__c != ''){
						intQuery = intQuery + ' AND General_Agency__c = \'' + String.escapeSingleQuotes(originator.General_Agency__c) + '\'';
					}
					if(originator.Franchise_Code__c != null && originator.Franchise_Code__c != ''){
						intQuery = intQuery + ' AND Franchise_Code__c = \'' + originator.Franchise_Code__c + '\'';
					}
				} else if(originator.Originator_Type__c == 'Group Contact'){
					if(originator.Group_Name__c != null && originator.Group_Name__c != ''){
						intQuery = intQuery + ' AND Group_Name__c = \'' + String.escapeSingleQuotes(originator.Group_Name__c) + '\'';
					}
					if(originator.Group_Number__c != null && originator.Group_Number__c != ''){
						intQuery = intQuery + ' AND Group_Number__c = \'' + originator.Group_Number__c + '\'';
					}
					if(originator.Policy_Number__c != null && originator.Policy_Number__c != ''){
						intQuery = intQuery + ' AND Policy_Number__c = \'' + originator.Policy_Number__c + '\'';
					}
				} else if(originator.Originator_Type__c == 'Other Originator'){
					if(originator.Other_Originator_Type__c != null && originator.Other_Originator_Type__c != ''){
						intQuery = intQuery + ' AND Other_Admin_Type__c = \'' + originator.Other_Originator_Type__c + '\'';
					}
				}
	            intQuery = intQuery + ' AND Interaction_Type__c = \'' + interactionType + '\'';
	            if(eventReceivedDate != null && eventReceivedTime != null && eventReceivedTime != '' && eventReceivedTime.contains(':')){
	            	Integer hours = Integer.valueOf(eventReceivedTime.split(':')[0]);
	            	Integer mins = Integer.valueOf(eventReceivedTime.split(':')[1]);
	            	Time newTime = Time.newInstance(hours,mins,0,0);
	            	DateTime dt = DateTime.newInstance(eventReceivedDate,newTime);
	            	String dtString = dt.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
	            	System.debug('FINAL DATETIME0: ' + dtString);
	            	intQuery = intQuery + ' AND Evt_Recvd_Dt_Time__c = ' + dtString;
	            }
	            System.debug('INTERACTION QUERY: ' + intQuery);
	            List<Interaction__c> intResults = Database.query(intQuery);
	            System.debug('INTERACTION Results: ' + intResults);
	            String encryptedIntFields = originator.First_Name__c + ' ' + originator.Last_Name__c + '|||||' +  originator.First_Name__c + ' ' + originator.Last_Name__c;
	            for(Integer i = 0; i < intResults.size(); i++){
	                System.debug('CHECKING ENCRYPTED KEY: ' + encryptedIntFields);
	                System.debug('CHECKING ENCRYPTED RES: ' + intResults[i].Get_Encrypted_Originator_Contact_Name__c);
	                if(intResults[i].Get_Encrypted_Originator_Contact_Name__c == encryptedIntFields){
	                    foundInteractionId = intResults[i].Id;
	                    System.debug('FOUND INTERACTION: ' + foundInteractionId);
	                }
	            }*/
	            if(foundInteractionId == ''){
	            	if(originator.Originator_Type__c != 'Internal UHG Employee'){
	            		query = 'SELECT Id, Get_Encrypted_Fields__c From Third_Party__c WHERE Customer_Admin_Type__c = \'' + originator.Originator_Type__c + '\'';
		                if(originator.Originator_Type__c == 'Agency/Broker'){
		                	if(originator.Agency_Broker_Name__c != null && originator.Agency_Broker_Name__c != ''){
								query = query + ' AND Agency_Broker_Name__c = \'' + String.escapeSingleQuotes(originator.Agency_Broker_Name__c) + '\'';
							}
							if(originator.Reward_Account_Number__c != null && originator.Reward_Account_Number__c != ''){
								query = query + ' AND Reward_Account_Number__c = \'' + originator.Reward_Account_Number__c + '\'';
							}
		                } else if(originator.Originator_Type__c == 'General Agent'){
		                	if(originator.General_Agency__c != null && originator.General_Agency__c != ''){
								query = query + ' AND General_Agency__c = \'' + String.escapeSingleQuotes(originator.General_Agency__c) + '\'';
							}
							if(originator.Franchise_Code__c != null && originator.Franchise_Code__c != ''){
								query = query + ' AND Franchise_Code__c = \'' + originator.Franchise_Code__c + '\'';
							}
		                } else if(originator.Originator_Type__c == 'Group Contact'){
		                	if(originator.Policy_Number__c != null && originator.Policy_Number__c != ''){
								query = query + ' AND Policy_Number__c = \'' + originator.Policy_Number__c + '\'';
							}
		                } else if(originator.Originator_Type__c == 'Other Originator'){
		                	if(originator.Policy_Number__c != null && originator.Policy_Number__c != ''){
								query = query + ' AND Other_Admin_Type__c = \'' + originator.Other_Originator_Type__c + '\'';
							}
			            }
		                System.debug('HERE IS THE QUERY: ' + query);
		                List<Third_Party__c> tpResults = Database.query(query);
		                System.debug('HERE IS THE RESULT: ' + tpResults);
	               		String grpName = (originator.Group_Name__c != null)?originator.Group_Name__c:'';
		                String grpNum = (originator.Group_Number__c != null)?originator.Group_Number__c:'';
	               		String encryptedFieldsText = originator.First_Name__c + '|||||' + originator.Last_Name__c + '|||||' + originator.Email__c + '|||||' + originator.Phone_Number__c + '|||||' + grpName + '|||||' + grpNum;  
		                for(Integer i = 0; i < tpResults.size(); i++){
		                    System.debug('CHECKING ENCRYPTED KEY: ' + encryptedFieldsText);
		                    System.debug('CHECKING ENCRYPTED RES: ' + tpResults[i].Get_Encrypted_Fields__c);
		                    if(tpResults[i].Get_Encrypted_Fields__c == encryptedFieldsText){
		                        foundThirdPartyId = tpResults[i].Id;
		                        System.debug('FOUND THIRD PARTY: ' + foundThirdPartyId);
		                    }
		                }
		                System.debug('HERE IS THE TPID: ' + foundThirdPartyId);
	            	}
	            	if(originator.Originator_Type__c == 'Agency/Broker'){
		                interaction.Agency_Broker_Name__c = (originator.Agency_Broker_Name__c != null)?originator.Agency_Broker_Name__c:'';
		                interaction.Reward_Account_Number__c = (originator.Reward_Account_Number__c != null)?originator.Reward_Account_Number__c:'';
	                    interaction.Originator_Type__c = 'Agency/Broker';                    
		                if(foundThirdPartyId == ''){
		                    thirdParty.Agency_Broker_Name__c = (originator.Agency_Broker_Name__c != null)?originator.Agency_Broker_Name__c:'';
		                    thirdParty.Reward_Account_Number__c = (originator.Reward_Account_Number__c != null)?originator.Reward_Account_Number__c:'';
		                }
		            } else if(originator.Originator_Type__c == 'General Agent'){
		                interaction.General_Agency__c = (originator.General_Agency__c != null)?originator.General_Agency__c:''; 
		                interaction.Franchise_Code__c = (originator.Franchise_Code__c != null)?originator.Franchise_Code__c:'';
	                    interaction.Originator_Type__c = 'General Agent';
		                if(foundThirdPartyId == ''){
		                    thirdParty.General_Agency__c = (originator.General_Agency__c != null)?originator.General_Agency__c:''; 
		                    thirdParty.Franchise_Code__c = (originator.Franchise_Code__c != null)?originator.Franchise_Code__c:'';
		                }
		            } else if(originator.Originator_Type__c == 'Group Contact'){
		                interaction.Group_Name__c = (originator.Group_Name__c != null)?originator.Group_Name__c:''; 
		                interaction.Group_Number__c = (originator.Group_Number__c != null)?originator.Group_Number__c:'';
		                interaction.Policy_Number__c = (originator.Policy_Number__c != null)?originator.Policy_Number__c:'';
		                interaction.Originator_Type__c='Group Contact';
		                if(foundThirdPartyId == ''){ 
		                    thirdParty.Group_Name__c = (originator.Group_Name__c != null)?originator.Group_Name__c:''; 
		                    thirdParty.Group_Number__c = (originator.Group_Number__c != null)?originator.Group_Number__c:'';
		                    thirdParty.Policy_Number__c = (originator.Policy_Number__c != null)?originator.Policy_Number__c:'';
		                }
		            } else if(originator.Originator_Type__c == 'Other Originator'){
		                interaction.Other_Admin_Type__c = (originator.Other_Originator_Type__c != null)?originator.Other_Originator_Type__c:''; 
	                    interaction.Originator_Type__c = 'Other Originator';
		                if(foundThirdPartyId == ''){ 
		                    thirdParty.Other_Admin_Type__c = (originator.Other_Originator_Type__c != null)?originator.Other_Originator_Type__c:''; 
		                }
		            } else if(originator.Originator_Type__c == 'Internal UHG Employee'){
		                //interaction.Originator_Name__c = (custAdmin.firstName != null && custAdmin.lastName != null)?custAdmin.firstName + ' ' + custAdmin.lastName:'';
		                Account acc = new Account();
		                Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
		                acc.RecordTypeId = personAccountRecordTypeId;
		                acc.FirstName = (originator.First_Name__c != null)?originator.First_Name__c:'';
		                acc.LastName = (originator.Last_Name__c != null)?originator.Last_Name__c:'';
		                acc.Phone = (originator.Phone_Number__c != null)?originator.Phone_Number__c:'000-000-0000';
		                acc.PersonEmail = (originator.Email__c != null)?originator.Email__c:'';
		                acc.EID__c = (originator.Email__c != null)?originator.Email__c:'';
		                acc.EID__pc = (originator.Email__c != null)?originator.Email__c:'';
		                Database.upsert(acc, Account.Fields.EID__c);
		                System.debug('HERE IS THE PERSON ACCT1: ' + acc);
		                Account personContact = [SELECT id, PersonContactId FROM Account where id=: acc.id];
		                System.debug('HERE IS THE PERSON ACCT2: ' + acc);
		                interaction.Originator__c = personContact.PersonContactId;
		                interaction.Originator_Type__c = 'Internal UHG Employee';
		                 
		            }
		            if(originator.Originator_Type__c != 'Internal UHG Employee'){
		                if(foundThirdPartyId == ''){
		                    thirdParty.First_Name__c = (originator.First_Name__c != null)?originator.First_Name__c:'';
		                    thirdParty.LastName__c = (originator.Last_Name__c != null)?originator.Last_Name__c:'';
		                    thirdParty.Email__c = (originator.Email__c != null)?originator.Email__c:'';
		                    thirdParty.Phone_Number__c = (originator.Phone_Number__c != null)?originator.Phone_Number__c:'000-000-0000';
		                    thirdParty.Customer_Admin_Type__c = (originator.Originator_Type__c != null)?originator.Originator_Type__c:'';
		                    insert thirdParty;
		                    interaction.Third_Party__c = (thirdParty.Id != null)?thirdParty.Id:'';
		                } else if(foundThirdPartyId != ''){
		                    interaction.Third_Party__c = foundThirdPartyId;
		                }
		            }
		            interaction.Contact_Name__c = (originator.First_Name__c != null && originator.Last_Name__c != null)?originator.First_Name__c + ' ' + originator.Last_Name__c:'';
		            Interaction.Customer_Admin_Type__c = (originator.Originator_Type__c != null)?originator.Originator_Type__c:'';
		            interaction.Originator_Phone__c = (originator.Phone_Number__c != null)?originator.Phone_Number__c:'000-000-0000';
		            interaction.Originator_Extension__c = (originator.Phone_Ext__c != null)?originator.Phone_Ext__c:'';
		            interaction.Originator_Email__c = (originator.Email__c != null)?originator.Email__c:'';
                    interaction.Originator_SFID__c = (originator.Id != null)?originator.Id:'';
	                String otherAdminTypeVal = originator.Other_Originator_Type__c;
	                otherAdminTypeVal = (otherAdminTypeVal != null) ? otherAdminTypeVal : '';
	                interaction.Originator_Relationship__c = otherAdminTypeVal;
		            System.debug('HERE IS THE INTERACTION: ' + interaction);
	        		insert interaction;
	            }
	        }
        }
        Interaction__c newInteraction = new Interaction__c();
        if(foundInteractionId != ''){
        	newInteraction = (Interaction__c) Database.query('SELECT Id, Interaction_Type__c, Name, Originator_Name__c, Originator__c, Current_Status__c, Resolution_Date__c FROM Interaction__c WHERE Id = \'' + foundInteractionId + '\'');
        } else {
        	newInteraction = (Interaction__c) Database.query('SELECT Id, Interaction_Type__c, Name, Originator_Name__c, Originator__c, Current_Status__c, Resolution_Date__c FROM Interaction__c WHERE Id = \'' + interaction.Id + '\'');
        }
        return newInteraction;
    }
    
    @AuraEnabled
    public static String createPersonAccount(String SearchType,String firstName,String lastName,String uniqueId, String dob, String uhgAccess){
        Account acc = new Account();
    	System.debug('HERE IS PASSED INFO: ' + firstName +','+lastName+','+uniqueId);
        Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        acc.RecordTypeId = personAccountRecordTypeId;
        acc.FirstName = (firstname != null)?firstname:'';
        acc.LastName = (lastName != null)?lastName:'';
        acc.UHG_Restriction__c = uhgAccess;
        //acc.PersonBirthdate = Date.parse(memberDOB);
        //acc.Phone = (memberPhoneNumber != null)?memberPhoneNumber:'';
	    //acc.PersonEmail = (memberEmail != null)?memberEmail:'';
        acc.EID__c = uniqueId;
        acc.EID__pc = uniqueId;
        Database.upsert(acc, Account.Fields.EID__c);
        System.debug('HERE IS THE PERSON ACCT1: ' + acc);
        Account personContact = [SELECT id, PersonContactId FROM Account where id=: acc.id];
        
        if(personContact.PersonContactId != null && dob != null && dob != '') {
            
            Contact personContactObj = new Contact();
            personContactObj.Id = personContact.PersonContactId;
            String dobToBeFormatted = '';
            if(dob.split('/').size() == 3){
                dobToBeFormatted = dob;
            } else if(dob.split('-').size() == 3){
                dobToBeFormatted = dob.split('-')[1] + '/' + dob.split('-')[2] + '/' + dob.split('-')[0];
            }
            System.debug('DOB DATE NEW FORMAT: ' + dobToBeFormatted);
            if(dobToBeFormatted != null && dobToBeFormatted != '') {
                personContactObj.Birthdate = Date.parse(dobToBeFormatted);
            }
            update personContactObj;
        } 
        
        return personContact.PersonContactId;
    }
    
    //DE385766:Change
    @AuraEnabled
    public static List<String> createOneNDoneCase(String origSfId,String strRecord, Boolean isProvider, String contactID, String flowType, String resolution, String updateCaseId,List<String> docIDs,String groupName, String subjectName){
        List<String> strCreatedCaseId = new List<String>();
        System.debug('CASE ID:' + updateCaseId);
        
        System.debug('JSON STRING: ' + strRecord);

        try{
           
            SAETTSCaseWrapper caseWrapper = (SAETTSCaseWrapper)JSON.deserialize(strRecord, SAETTSCaseWrapper.class);
           
            Interaction__c interaction = (Interaction__c) Database.query('SELECT Id, Interaction_Type__c, Name, Originator__c, Originator_Name__c, Originator_Phone__c, Originator_Email__c, Customer_Admin_Type__c, Reward_Account_Number__c, Franchise_Code__c, Contact_Name__c FROM Interaction__c WHERE Id = \'' + caseWrapper.Interaction + '\'');
            
            RecordType recordType = [SELECT Id, Name FROM RecordType WHERE sObjectType='case' AND Name='BEO'];
            User userDetails =[SELECT Id, UserRole.Name FROM User where Id =: UserInfo.getUserId()];
          
            Case caseObj = new Case();
            if(updateCaseId != null && updateCaseId != ''){
            	caseObj.Id = updateCaseId;
            }
            caseObj.ContactId = contactID;
            /*if(flowType == 'Member'){
                Account acc = new Account();
                Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
                acc.RecordTypeId = personAccountRecordTypeId;
                String firstName = '';
                String lastName = '';
                if(caseWrapper.SubjectName.contains(' ')){
                	firstName = caseWrapper.SubjectName.split(' ')[0];
                	lastName = caseWrapper.SubjectName.split(' ')[1];
            	}
                acc.FirstName = (firstName != null)?firstName:'';
                acc.LastName = (lastName != null)?lastName:'';
                acc.PersonBirthdate = Date.parse(caseWrapper.subjectDOB);
                //acc.Phone = (memberPhoneNumber != null)?memberPhoneNumber:'';
                //acc.PersonEmail = (memberEmail != null)?memberEmail:'';
                acc.EID__c = firstName + lastName + caseWrapper.subjectDOB.remove('/') + caseWrapper.SubjectId;
                acc.EID__pc = firstName + lastName + caseWrapper.subjectDOB.remove('/') + caseWrapper.SubjectId;
                Database.upsert(acc, Account.Fields.EID__c);
                System.debug('HERE IS THE PERSON ACCT1: ' + acc);
                Account personContact = [SELECT id, PersonContactId FROM Account where id=: acc.id];
                System.debug('HERE IS THE PERSON ACCT2: ' + acc);
                caseObj.ContactId = personContact.PersonContactId;
            }*/

            caseObj.Subject_Type__c = flowType;
       
            caseObj.Status = 'Closed';
            //caseObj.Subject_Name__c = caseWrapper.SubjectName; //Set to a static name
           
            caseObj.ID__c = caseWrapper.SubjectId;
            /*if(caseWrapper.SubjectName.length()>120){
                caseObj.Subject_Name__c = caseWrapper.SubjectName.substring(0,120);
            }else{
                caseObj.Subject_Name__c = caseWrapper.SubjectName;
            }*/
             if(subjectName.length()>120){
                caseObj.Subject_Name__c = subjectName.substring(0,120);
            }else{
                caseObj.Subject_Name__c = subjectName;
            }
            
            
            
            //the below vars are definitely not set correctly
            if(flowType == 'Member'){
               
                //caseObj.Surrogate_Key__c = caseWrapper.SubjectName.remove(' ') + caseWrapper.SubjectDOB.remove('/') + caseWrapper.SubjectId + caseWrapper.SubjectGroupId;
                caseObj.Surrogate_Key__c = subjectName.remove(' ') + caseWrapper.SubjectDOB.remove('/') + caseWrapper.SubjectId + caseWrapper.SubjectGroupId;
            }
            caseObj.Originator_Relationship__c = (caseWrapper.otherAdminType != '') ? caseWrapper.otherAdminType : null;
			caseObj.Reward_Account_Number__c = (interaction.Reward_Account_Number__c != null)?interaction.Reward_Account_Number__c:'';
			caseObj.Franchise_Code__c = (interaction.Franchise_Code__c != null)?interaction.Franchise_Code__c:'';
			
			caseObj.Caller__c = (interaction.Contact_Name__c != null)?interaction.Contact_Name__c:'';
            caseObj.Case_Type__c = 'BEO Case';
            
            
            caseObj.Interaction__c = (caseWrapper.Interaction != null)?caseWrapper.Interaction : '';
			//caseObj.Business_Direction__c = (caseWrapper.specialInstructions != null)?caseWrapper.specialInstructions:'';
			caseObj.Special_Instructions_Business_Unit__c = (caseWrapper.specialInstructionsBusinessUnit != null)?caseWrapper.specialInstructionsBusinessUnit:'';
			caseObj.Issue_Category_Desc__c = (caseWrapper.issueCategoryDesc != null)?caseWrapper.issueCategoryDesc:'';
			//caseObj.Task_Category_Type_Desc__c = (caseWrapper.taskCategoryTypeDesc != null)?caseWrapper.taskCategoryTypeDesc:'';
			//caseObj.Task_Category_Subtype_Desc__c = (caseWrapper.taskCategorySubtypeDesc != null)?caseWrapper.taskCategorySubtypeDesc:'';
			caseObj.Special_Instructions_Subject__c = (caseWrapper.specialInstructionsSubject != null)?caseWrapper.specialInstructionsSubject:'';
			caseObj.Special_Instructions_Description__c = (resolution != null)?resolution:'';
			//caseObj.Special_Instructions_Reference_ID__c = (caseWrapper.specialInstructionsReferenceID != null)?caseWrapper.specialInstructionsReferenceID:'';
            
            
            caseObj.Event_Type__c = 'One & Done';
            if(caseWrapper.specialInstructionsQueue != null && caseWrapper.specialInstructionsQueue != ''){
				List<Group> queueList = [SELECT Id FROM Group WHERE Type='Queue' AND Name =: caseWrapper.specialInstructionsQueue];
				System.debug('QUEUE STUFF2: ' + queueList);
				if (queueList != null && queueList.size() > 0) {
					//caseObj.OwnerId = queueList[0].Id;
					caseObj.Queue_Id__c = queueList[0].Id;
				}
			}
            
			String dosStr = '';
			if(caseWrapper.specialInstructionsDateOfService != null && caseWrapper.specialInstructionsDateOfService != ''){
				dosStr = caseWrapper.specialInstructionsDateOfService;
				if(dosStr.contains(',')){
					dosStr = dosStr.replace(',',',\n');
				}
			}
			caseObj.Date_of_Service__c = (dosStr != null)?dosStr:'';
            
            
            caseObj.RecordTypeId = recordType.Id;
            caseObj.Broker_Name__c = (caseWrapper.brokerName != null)?caseWrapper.brokerName:'';
            caseObj.Broker_ID__c = (caseWrapper.brokerId != null)?caseWrapper.brokerId:'';
            //caseObj.Group_Name__c = (caseWrapper.groupName != null )? caseWrapper.groupName : ''; 
            caseObj.Group_Name__c = (groupName != null )? groupName : '';
           	caseObj.Group_ID__c = (caseWrapper.groupId != null )? caseWrapper.groupId : '';
           	caseObj.Policy_Year__c = (caseWrapper.groupPolicyYear != null )? caseWrapper.groupPolicyYear : ''; 
           	caseObj.Situs_State__c = (caseWrapper.SubjectSitus != null )? caseWrapper.SubjectSitus : '';
           	caseObj.Situs__c = (caseWrapper.SubjectSitus != null )? caseWrapper.SubjectSitus : '';
           	
           	caseObj.Funding_Type__c = (caseWrapper.groupFundingType != null )? caseWrapper.groupFundingType : '';
           	caseObj.Platform__c = (caseWrapper.groupPlatform != null )? caseWrapper.groupPlatform : '';
           	caseObj.Line_of_Business__c = caseWrapper.groupLineOfBusiness != '' ? caseWrapper.groupLineOfBusiness : null;
            caseObj.Region__c = caseWrapper.groupRegion != '' ? caseWrapper.groupRegion : null;
            caseObj.Sales_Office__c = caseWrapper.groupSalesOffice != '' ? caseWrapper.groupSalesOffice : null;
            caseObj.Health_Plan_Major__c = caseWrapper.groupHelathPlanMajor != '' ? caseWrapper.groupHelathPlanMajor : null;
            caseObj.Health_Plan_Minor__c = caseWrapper.groupHelathPlanMinor != '' ? caseWrapper.groupHelathPlanMinor : null;
            caseObj.Policy__c = caseWrapper.groupPolicy != '' ? caseWrapper.groupPolicy : null;
            String groupPolicyRenwyear = caseWrapper.groupPolicyRenewalYear != null ? caseWrapper.groupPolicyRenewalYear : '';
            caseObj.Group_Solaris_ID__c = (caseWrapper.groupSolarisId != null)?caseWrapper.groupSolarisId:'';
            caseObj.SourceCode__c  = (caseWrapper.groupSourceCode != null)?caseWrapper.groupSourceCode:''; //jangi
		    String dateFormat = '';
   			if(groupPolicyRenwyear.split('/').size() == 3){
   				dateFormat = groupPolicyRenwyear;
	   		} else if(groupPolicyRenwyear.split('-').size() == 3){
	   			dateFormat = groupPolicyRenwyear.split('-')[1] + '/' + groupPolicyRenwyear.split('-')[2] + '/' + groupPolicyRenwyear.split('-')[0];
	   		}
	   		System.debug('DATE NEW FORMAT: ' + dateFormat);
	   		if(dateFormat != null && dateFormat != '') {
	   			caseObj.Policy_Renewal_Year__c = Date.parse(dateFormat);
	   		}
            
            
            caseObj.SLA__c = caseWrapper.slaDay;
            caseObj.Email__c = (caseWrapper.emailURL != null)?caseWrapper.emailURL:'';
            Date cuurentDate = System.Today();
            Decimal slaDay = caseWrapper.slaDay;
            Integer slaDayVal = 0;            
            if(slaDay != null) {
                slaDayVal = slaDay.intValue();
            }
			
            // Get the default business hours
            BusinessHours businessHoursObj = [SELECT Id FROM BusinessHours WHERE Name='ETS-BE/BEO' AND IsActive=true];
            
            /* List of Dates to be considered by excluding the Weekend & Holidays */
            List<Date> listOfDatesToConsider = new List<Date>();
            
            for(Integer i=0; i<slaDayVal; i++){
                Date currDate = cuurentDate.addDays(i);
                DateTime curDateAndTime = DateTime.newInstance(currDate.year(), currDate.month(), currDate.day());
                Boolean isBusinessDay = BusinessHours.isWithin(businessHoursObj.id, curDateAndTime);
                if(isBusinessDay) {
                    listOfDatesToConsider.add(currDate);
                } else {
                    slaDayVal = slaDayVal+1;
                }
            }  
            
            
            
            if(listOfDatesToConsider != null && listOfDatesToConsider.size() > 0) {
                
                Date followUpDate = listOfDatesToConsider[listOfDatesToConsider.size()-1]; 
                caseObj.Follow_Up_Date__c = DateTime.newInstance(followUpDate, DateTime.now().time());
            }            
            
            
            // Follow Up Date Calculation END - Yogitha
            
            // US2488115 -> Member Relationship Saved to the Case - Yogitha
            
            caseObj.Member_Relationship__c = caseWrapper.memberRelationship;            
            
            // 
            // US1974034 - Thanish (23rd Aug 2019) - to show subject DOB in MM/DD/YYYY format
            //Adding null check - 23/10/2019 - Sarma
            
            System.debug('SUBJECT INFO9: ' + caseObj.ID__c + ',' + caseObj.Subject_Name__c);
            if(caseWrapper.SubjectDOB != null){
                 if(caseWrapper.SubjectDOB.contains('/')) {
                caseObj.DOB__c = caseWrapper.SubjectDOB;
                } else {
                    caseObj.DOB__c =  SAEUtils.formatDate(caseWrapper.SubjectDOB);
                }
            }
            if(isProvider){
                caseObj.Subject_Group_ID__c = '';
            }else{
                caseObj.Subject_Group_ID__c = caseWrapper.SubjectGroupId;
            }
            
            
            caseObj.Topic__c = caseWrapper.AddInfoTopic;
            caseObj.Type__c = caseWrapper.ttsType;
            caseObj.Subtype__c = caseWrapper.ttsSubType;
            caseObj.Original_Type__c = caseWrapper.AddInfoOrginType;
            caseObj.Original_Subtype__c = caseWrapper.AddInfoOrginSubType;
            caseObj.Created_By_Role__c = userDetails.UserRole.Name;
            caseObj.TaxID__c = caseWrapper.TaxId;
            caseObj.Onshore_Restriction__c = 'No';
            caseObj.UHG_Restriction__c = caseWrapper.uhgRestriction;
            
            
            upsert caseObj;
            case newCase = [Select Id,CaseNumber,Subject_Name__c,ID__c from Case where Id=:caseObj.Id];
            strCreatedCaseId.add(newCase.Id);
            strCreatedCaseId.add(newCase.CaseNumber);
            
            //Insert attachement to cases
            if(docIDs.size()!=null){
                insertAttachments(docIDs,newCase.id);
            }
            
            //Update interactions:US2580332
            if(newCase!=null){
                populateEvntTypeBusinessUnit(newCase.id);
            }
            
            
            
            //Case caseObjTest = [Select Id,Target_Date__c from Case where Id=:strCreatedCaseId];
        } catch(Exception e) {
        	System.debug('CREATE CASE: BAD THINGS');
            System.debug(LoggingLevel.ERROR,'####ERROR:'+e.getMessage());
            System.debug(LoggingLevel.ERROR,'####ERROR LINE:'+e.getLineNumber());
        }
        
        return strCreatedCaseId;
    }
    @AuraEnabled
    public static List<UHG_Restricted_Plans__mdt> getOptumExlusions() {
        List<UHG_Restricted_Plans__mdt> mapOptumExlusions = new List<UHG_Restricted_Plans__mdt>();
        try {
            mapOptumExlusions = [SELECT DeveloperName,MasterLabel FROM UHG_Restricted_Plans__mdt];

        } catch(Exception e) {
            System.debug(LoggingLevel.ERROR,e.getMessage());
        }
        return mapOptumExlusions;
    }
     @AuraEnabled
    Public static SubjectCardSearchResultWrapper getMemberDetails(String memberId, String memberDOB,String firstName, String lastName, String groupNumber,String searchOption, String payerID, String providerLastName, String providerFirstName, String npi, String providerFlow, String taxId, String providerId){
     SAEMemberProviderDetail.MemberDetails md = new SAEMemberProviderDetail.MemberDetails();
        md.memberId = memberId;
        md.memberDOB = memberDOB;
        md.firstName = firstName;
        md.lastName = lastName;
        md.searchOption = searchOption;
        md.payerID= payerID;
        md.isFourthCallout = false;
        ACET_ProviderSearchCtrl.ProviderDetails providerDetails =new ACET_ProviderSearchCtrl.ProviderDetails ();
        providerDetails.isNoProviderToSearch =true;
        providerDetails.isProviderNotFound =true;
        providerDetails.isOther=true;
        SAEMemberProviderWS memberService = new SAEMemberProviderWS();
        ACETWSCalloutResult CalloutResult =    memberService.getMemberDetails(md,providerDetails);
        system.debug('>>>>>>>>>>>>'+CalloutResult);
        SubjectCardSearchResultWrapper dataWrap = new SubjectCardSearchResultWrapper();
        dataWrap.resultWrapper = (SAEProviderMemberSearchInteractionResult)CalloutResult.response;
        dataWrap.message = CalloutResult.Message;
        dataWrap.statusCode = CalloutResult.statusCode;
        return dataWrap;
    }
   @AuraEnabled(cacheable=true) 
    // String payerID - US1944108
    public static SubjectCardSearchResultWrapper findMembers(String memberId, String memberDOB,String firstName, String lastName, String groupNumber,String searchOption, String payerID,
                                                    String providerFN, String providerLN, String providerNPI, String providerFlow){
    
		System.debug('SEARCH PASSED: ' + memberId + ',' + memberDOB);
        SAEProviderMemberSearchInteractionResult resultwrap = new SAEProviderMemberSearchInteractionResult();                 
        SAEMemberProviderWS MemberProviderService = new SAEMemberProviderWS();
        SAEMemberStandaloneSearchWebService findIndividualWS = new SAEMemberStandaloneSearchWebService();
        ACETWSCalloutResult CalloutResult = null;
        System.debug('SEARCH PASSED1: ');
        if(String.isNotBlank(memberId) && !String.isNotBlank(memberDOB) && !String.isNotBlank(firstName) && !String.isNotBlank(lastName) &&
           !String.isNotBlank(groupNumber)){
           		System.debug('SEARCH PASSED2 ');
               system.debug('findIndividual');
               CalloutResult = findIndividualWS.findIndividual(memberId);
               system.debug('CalloutResult>>> ' + CalloutResult);
               if (CalloutResult.Success != null && CalloutResult.Success){
                   resultwrap= (SAEProviderMemberSearchInteractionResult)CalloutResult.Response;
                   System.debug('resultwrap.memberProviderResultlst@@@ ' + resultwrap.lstSAEMemberStandaloneSearch);
                   System.debug('resultwrap ' + resultwrap);
               }
           }else{
               //payerID - US1944108
               System.debug('SEARCH PASSED3: ');
               CalloutResult = MemberProviderService.getMemberWS(memberId,memberDOB,firstName,lastName,groupNumber,searchOption, payerID, providerLN, providerFN, providerNPI, providerFlow);
               if (CalloutResult.Success != null && CalloutResult.Success){   
                   resultwrap= (SAEProviderMemberSearchInteractionResult)CalloutResult.Response;
                   System.debug('resultwrap.memberProviderResultlst@@@ ' + resultwrap.memberProviderResultlst);
                   System.debug('resultwrap.@@@ ' + resultwrap);
               }
           }
        system.debug('>>>resultwrap------'+resultwrap); 
        
        SubjectCardSearchResultWrapper dataWrap = new SubjectCardSearchResultWrapper();
        dataWrap.resultWrapper = resultwrap;
        dataWrap.message = CalloutResult.Message;
        dataWrap.statusCode = CalloutResult.statusCode;
        return dataWrap;
        
    }
    public class SubjectCardSearchResultWrapper{
        @AuraEnabled public SAEProviderMemberSearchInteractionResult resultWrapper {get;set;}
        @AuraEnabled public string message {get;set;}
        @AuraEnabled public integer statusCode {get;set;}
    }
    
    /*commented out for now, possibly to be used later to get member relationship to populate on case page
    @AuraEnabled(cacheable=true)
    public static SAEHouseHoldController.SearchResultWrapper returnHouseHoldData(String transactionId) {
        System.debug('returnHouseHoldData');
        SAEHouseHoldController.SearchResultWrapper houseHoldDataObj = new SAEHouseHoldController.SearchResultWrapper();
		houseHoldDataObj = SAEHouseHoldController.getHouseHoldMembers(transactionId); 
        System.debug('Result Data 123 -'+houseHoldDataObj.resultWrapper);
        return houseHoldDataObj;
    }*/
    
    @AuraEnabled
    public static Boolean getMockStatus() {
        Boolean isStaticResponseChecked = false;
        isStaticResponseChecked = SAEUtils.getMockStatus();
        return isStaticResponseChecked;
    }
    
    @AuraEnabled
    public static Object getMockData(String transactionId, String memberId, String memberDOB, String memberFN, String memberLN, String memberGrpN, String searchOption, String payerID) {
        system.debug('### memberId==>:'+memberId + ' @@memberDOB@ ' + memberDOB);
        String processedData = '';
        String responseStr = '';
        HttpResponse response;
        String searchparameter='';
        switch on searchOption {
            when 'MemberIDNameGroupNumberDateOfBirth' {
                searchparameter=  memberId+'_'+memberFN+'_'+memberLN+'_'+memberGrpN+'_'+memberDOB; 
                
            }
            when 'MemberIDNameDateOfBirth' {
                searchparameter=  memberId+'_'+memberFN+'_'+memberLN+'_'+memberDOB; 
                
            }
            when 'MemberIDName'{
                searchparameter=  memberId+'_'+memberFN+'_'+memberLN; 
            }
            when 'MemberIDLastNameDateOfBirth' {
                searchparameter=  memberId+'_'+memberLN+'_'+memberDOB; 
            }
            when 'MemberIDFirstNameDateOfBirth'{
                searchparameter=  memberId+'_'+memberFN+'_'+memberDOB; 
            }
            when 'NameDateOfBirth' {
                searchparameter=  memberFN+'_'+memberLN+'_'+memberDOB; 
            }
            when 'MemberIDDateOfBirth'{
                searchparameter=  memberId+'_'+memberDOB; 
            }
            when else {
                System.debug('default');
            }
        }
        system.debug('### searchparameter==>:'+searchparameter);
        if(String.isNotBlank(searchparameter)) {
            
            response = SAEUtils.getResponse(searchparameter);
        }
        ACETWSCalloutResult calloutResult = SAEGetMemberProviderWebService.processResponse(response);
        SAEMemberProviderSearchCoveragesResult resultwrap = new SAEMemberProviderSearchCoveragesResult();
        resultwrap= (SAEMemberProviderSearchCoveragesResult)calloutResult.Response;
        SearchResultWrapper1 dataWrap = new SearchResultWrapper1();
        dataWrap.resultWrapper = resultwrap;
        dataWrap.message = calloutResult.Message;
        dataWrap.statusCode = calloutResult.statusCode;
        dataWrap.hasAccess = getHasUHGAccess();
        processedData = JSON.serialize(dataWrap);
        return processedData;
    }
     public class MemberDetails {
        @AuraEnabled public String memberId {get;set;}
        @AuraEnabled public String memberDOB {get;set;}
        @AuraEnabled public String firstName {get;set;}
        @AuraEnabled public String lastName {get;set;}
        @AuraEnabled public String state {get;set;}
        @AuraEnabled public String groupNumber {get;set;}
        @AuraEnabled public String searchOption {get;set;}
        @AuraEnabled public String payerId {get;set;}
        @AuraEnabled public String memberUniqueId {get;set;}
        @AuraEnabled public String transactionId {get;set;}   
        @AuraEnabled public Boolean isFourthCallout {get;set;}   
        @AuraEnabled public String serviceStart {get;set;}
        @AuraEnabled public String serviceEnd {get;set;}
    }
    @AuraEnabled(continuation = true cacheable = true) 
    public static Object fourthCallout(String memberId,String memberDOB,String memberFN, String memberLN, String searchOption, String payerID){
         SAEMemberProviderDetail.MemberDetails md = new SAEMemberProviderDetail.MemberDetails();
        md.memberId = memberId;
        md.memberDOB = memberDOB;
        md.firstName = memberFN;
        md.lastName = memberLN;
        md.searchOption = searchOption;
        md.payerID= payerID;
        md.isFourthCallout = true;
        ACET_ProviderSearchCtrl.ProviderDetails providerDetails =new ACET_ProviderSearchCtrl.ProviderDetails ();
        providerDetails.isNoProviderToSearch =true;
        providerDetails.isProviderNotFound =true;
        providerDetails.isOther=true;
         object con =SAEMemberProviderDetail.fourthCallout(md, providerDetails);
        return con;
    }
     @AuraEnabled(continuation = true cacheable = true) 
    public static Object callEligibilityServices(String memberId,String memberDOB,String memberFN, String memberLN, String memberGrpN, String searchOption, String payerID) {
        system.debug('//////'+memberId);
        SAEMemberProviderDetail.MemberDetails md = new SAEMemberProviderDetail.MemberDetails();
        md.memberId = memberId;
        md.memberDOB = memberDOB;
        md.firstName = memberFN;
        md.lastName = memberLN;
        md.searchOption = searchOption;
        md.payerID= payerID;
        md.isFourthCallout = false;
        ACET_ProviderSearchCtrl.ProviderDetails providerDetails =new ACET_ProviderSearchCtrl.ProviderDetails ();
        providerDetails.isNoProviderToSearch =true;
        providerDetails.isProviderNotFound =true;
        providerDetails.isOther=true;
         object con =SAEMemberProviderDetail.callEligibilityServices(md, providerDetails);
        return con;
    }
    @AuraEnabled(continuation = true cacheable = true) //SearchResultWrapper
    public static Object fetchData(String transactionId, String memberId, String memberDOB, String memberFN, String memberLN, String memberGrpN, String searchOption, String payerID) {
        
        SAEMemberProviderSearchCoveragesResult resultwrap = new SAEMemberProviderSearchCoveragesResult();
        system.debug(LoggingLevel.INFO,'memberId:: ' + memberId + ' ::memberDOB:: ' + memberDOB);
        system.debug(LoggingLevel.INFO,'memberFN:: ' + memberFN + ' ::memberLN:: ' + memberLN);
        system.debug(LoggingLevel.INFO,'searchOption:: ' + searchOption + ' ::payerID:: ' + payerID);
        System.debug('@@ SAEMemberProviderDetail:  transactionId: ' + transactionId);
        System.debug('@@ SAEMemberProviderDetail:  memberId: ' + memberId);
        if (searchOption == null) {
            searchOption = 'NameDateOfBirth';
        }
        SAEGetMemberProviderWebService memberProviderService = new SAEGetMemberProviderWebService();
        ACETWSCalloutResult CalloutResult = null;
        String reqMethod = 'GET';
        HttpResponse response;
        String endPoint = ISL_Webservice_Config__c.getInstance('SAE_ProviderSearch').Value__c;
        String dateStr = SAEUtils.formatDateRequest(memberDOB);
        String serviceStart = SAEUtils.formatDateFutureDate(ACETUtility.format(System.today().addYears(-5))); //US2034277 : TECH - Eligibility V2 Request Changes : old value -6
        //String serviceEnd = SAEUtils.formatDateFutureDate(System.today().addYears(1).format());
        String serviceEnd = SAEUtils.formatDateFutureDate(ACETUtility.format(Date.newInstance(System.today().year(), 12, 31)));
        String strProviderLastName = 'ACET';
        String strTaxIdNumber = '9999999';
        String strProviderNameID = '9999999';
        if (searchOption.equals('MemberIDNameDateOfBirth')) {
            memberGrpN = '';
        } else if (searchOption.equals('MemberIDLastNameDateOfBirth')) {
            memberGrpN = '';
            memberFN = '';
        } else if (searchOption.equals('MemberIDFirstNameDateOfBirth')) {
            memberGrpN = '';
            memberLN = '';
        } else if (searchOption.equals('NameDateOfBirth')) {
            memberGrpN = '';
        } else if (searchOption.equals('MemberIDDateOfBirth')) {
            memberGrpN = '';
            memberFN = '';
            memberLN = '';
        } else if (searchOption.equals('MemberIDName')) {
            memberGrpN = '';
            dateStr = '';
        }
        if (memberId == '101987516') {
            serviceStart = '2016-10-03';
        }
        
        String resultQuery = formRequestParameters(memberId, memberDOB, memberFN, 
                                                memberLN, memberGrpN, searchOption,
                                                strProviderLastName, dateStr, strProviderNameID,
                                                serviceStart, serviceEnd, strTaxIdNumber, payerID);
        
        System.debug('@@ SAEMemberProviderDetail:  resultQuery: ' + resultQuery);
        ////
		SAEMemberProviderDetail.EligibilityCalloutRequestWrapper eligibilityCalloutRequestWrapper = new SAEMemberProviderDetail.EligibilityCalloutRequestWrapper(); 
        //eligibilityCalloutRequestWrapper.memberDetailsObject = memberDetails;
       // eligibilityCalloutRequestWrapper.providerDetailsObject = providerDetails;
        // Create continuation. Argument is timeout in seconds.
        Continuation con = new Continuation(40);
        // Set callback method
        con.continuationMethod = 'processResponse';
        // Set state
        con.state = 'Hello, World!';
        // Create callout request
        HttpRequest req = new HttpRequest();
        System.debug(LoggingLevel.INFO, '@@ SAEMemberProviderDetail:  endPoint: ' + endPoint);
        String url = endPoint + resultQuery;
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setTimeout(12000);
        Map < String, ISL_Webservice_Config__c > wsConfigurations = ISL_Webservice_Config__c.getAll();
        for (String str: wsConfigurations.keySet()) {
            if (wsConfigurations.containsKey('ISLOAuthContentType')) {
                req.setHeader('Content-Type', wsConfigurations.get('ISLOAuthContentType').Value__c);
            }
        }
        List < Token_Generation__c > acessTokenRec = [SELECT id, name, Token_Name__c, Value__c FROM Token_Generation__c WHERE Token_Name__c = 'ISLConAccessToken'];
        if (acessTokenRec != null && acessTokenRec.size() > 0) {
            if (String.isNotBlank(acessTokenRec[0].Value__c)) {
                req.setHeader('authorization', 'Bearer ' + acessTokenRec[0].Value__c);
            }
        }
        // Add callout request to continuation
        con.addHttpRequest(req);
        System.debug('@@ SAEMemberProviderDetail:  RequestBody: ' + req);

        //2 start
        HttpRequest req2 = new HttpRequest();
        System.debug(LoggingLevel.INFO, '@@ SAEMemberProviderDetail:  endPoint: ' + endPoint);

        Integer nextYear = System.today().year() + 1;
        String firstDayOfNextCalendarYear = SAEUtils.formatDateFutureDate(ACETUtility.format(Date.newInstance(nextYear, 01, 01)));
        String resultQuery2 = formRequestParameters(memberId, memberDOB, memberFN, 
                                                memberLN, memberGrpN, searchOption,
                                                strProviderLastName, dateStr, strProviderNameID,
                                                firstDayOfNextCalendarYear, '', strTaxIdNumber, payerID);
        String url2 = endPoint + resultQuery2;
        req2.setEndpoint(url2);
        req2.setMethod('GET');
        req2.setTimeout(12000);
        Map < String, ISL_Webservice_Config__c > wsConfigurations2 = ISL_Webservice_Config__c.getAll();
        for (String str: wsConfigurations2.keySet()) {
            if (wsConfigurations2.containsKey('ISLOAuthContentType')) {
                req2.setHeader('Content-Type', wsConfigurations2.get('ISLOAuthContentType').Value__c);
            }
        }
        if (acessTokenRec != null && acessTokenRec.size() > 0) {
            if (String.isNotBlank(acessTokenRec[0].Value__c)) {
                req2.setHeader('authorization', 'Bearer ' + acessTokenRec[0].Value__c);
            }
        }
        // Add callout request to continuation
        con.addHttpRequest(req2);
        System.debug('@@ SAEMemberProviderDetail:  RequestBody: ' + req2);

        //3 start
        HttpRequest req3 = new HttpRequest();
        System.debug(LoggingLevel.INFO, '@@ SAEMemberProviderDetail:  endPoint: ' + endPoint);
        String resultQuery3 = formRequestParameters(memberId, memberDOB, memberFN, 
                                                memberLN, memberGrpN, searchOption,
                                                strProviderLastName, dateStr, strProviderNameID,
                                                '', '', strTaxIdNumber, payerID);
        String url3 = endPoint + resultQuery3;
        req3.setEndpoint(url3);
        req3.setMethod('GET');
        req3.setTimeout(12000);
        Map < String, ISL_Webservice_Config__c > wsConfigurations3 = ISL_Webservice_Config__c.getAll();
        for (String str: wsConfigurations3.keySet()) {
            if (wsConfigurations3.containsKey('ISLOAuthContentType')) {
                req3.setHeader('Content-Type', wsConfigurations3.get('ISLOAuthContentType').Value__c);
            }
        }
        if (acessTokenRec != null && acessTokenRec.size() > 0) {
            if (String.isNotBlank(acessTokenRec[0].Value__c)) {
                req3.setHeader('authorization', 'Bearer ' + acessTokenRec[0].Value__c);
            }
        }
        // Add callout request to continuation
        con.addHttpRequest(req3);
        System.debug('@@ SAEMemberProviderDetail:  RequestBody: ' + req3);
        // Return the continuation
        return con;
    }
    
	public static Object processResponse() {
        List<String> labels = new list<String>();
        labels.add('continuation-1');
        labels.add('continuation-2');
        labels.add('continuation-3');
        object result =  processResponse(labels,null);
        return result;
    }
    @AuraEnabled(cacheable = true)
    public static Object processResponse(List<String> labels, Object state) {
        // Get the response by using the unique label
        ACETWSCalloutResult finalCallOutResult;
        String processedData = '';
        HttpResponse response = Continuation.getResponse(labels[0]);
        // Set the result variable
        String result = response.getBody();
        System.debug('@@ SAEMemberProviderDetail: processResponse: result: ' + result);
        ACETWSCalloutResult calloutResult = SAEGetMemberProviderWebService.processResponse(response);
        System.debug('@@ SAEMemberProviderDetail: processResponse: calloutResult: ' + calloutResult);
        //2 starts
        // Get the response by using the unique label
        HttpResponse response2 = Continuation.getResponse(labels[1]);
        // Set the result variable
        String result2 = response2.getBody();
        System.debug('@@ SAEMemberProviderDetail: processResponse: result2: ' + result2);
        ACETWSCalloutResult calloutResult2 = SAEGetMemberProviderWebService.processResponse(response2);
        System.debug('@@ SAEMemberProviderDetail: processResponse: calloutResult2: ' + calloutResult2);

        if(calloutResult.Success != null && calloutResult.Success && calloutResult2.Success != null && calloutResult2.Success) {
            System.debug('@@ SAEMemberProviderDetail: processResponse: inside both: ');
            SAEMemberProviderSearchCoveragesResult returnReponse = new SAEMemberProviderSearchCoveragesResult();
            returnReponse = (SAEMemberProviderSearchCoveragesResult) calloutResult.Response;

            SAEMemberProviderSearchCoveragesResult returnReponse2 = new SAEMemberProviderSearchCoveragesResult();
            returnReponse2 = (SAEMemberProviderSearchCoveragesResult) calloutResult2.Response;
			//
            Boolean isActivePoilcyInFirstCall = false;
            for(SAEMemberProviderSearchCoveragesResult.CoverageLine cl : returnReponse.CoverageLines) {
                if(cl.highlightedPolicy != null && cl.highlightedPolicy) {
                    isActivePoilcyInFirstCall = true;
                }
            }
            if(isActivePoilcyInFirstCall) {
                for(SAEMemberProviderSearchCoveragesResult.CoverageLine cl : returnReponse2.CoverageLines) {
                    cl.highlightedPolicy = false;
                }
            }
            //
            returnReponse.CoverageLines.addAll(returnReponse2.CoverageLines);
            finalCallOutResult = calloutResult;
            //processedData = JSON.serialize(calloutResult);
        } else if(calloutResult.Success != null && calloutResult.Success) {
            System.debug('@@ SAEMemberProviderDetail: processResponse: inside 1st one is true: ');
            finalCallOutResult = calloutResult;
            //processedData = JSON.serialize(calloutResult);
        } else if(calloutResult2.Success != null && calloutResult2.Success) {
            System.debug('@@ SAEMemberProviderDetail: processResponse: inside 2nd one is true: ');
            finalCallOutResult = calloutResult2;
            //processedData = JSON.serialize(calloutResult2);
        }
        ACETWSCalloutResult calloutResult3;
        Boolean callWithOutDatesService = false;
        if((calloutResult.Success == null || !calloutResult.Success) && (calloutResult2.Success == null || !calloutResult2.Success)) {
             System.debug('@@ SAEMemberProviderDetail: processResponse: inside callWithOutDatesService is true: ');
            callWithOutDatesService = true;
        }
        if(callWithOutDatesService){
            System.debug('@@ SAEMemberProviderDetail: processResponse: inside 3rd one is true: ');
            //call third endpoint
            //3 starts
            // Get the response by using the unique label
            HttpResponse response3 = Continuation.getResponse(labels[2]);
            // Set the result variable
            String result3 = response3.getBody();
            System.debug('@@ SAEMemberProviderDetail: processResponse: result3: ' + result3);
            calloutResult3 = SAEGetMemberProviderWebService.processResponse(response3);
            finalCallOutResult = calloutResult3;
            //processedData = JSON.serialize(calloutResult3);
        }
        //new
        SAEMemberProviderSearchCoveragesResult resultwrap = new SAEMemberProviderSearchCoveragesResult();
        resultwrap= (SAEMemberProviderSearchCoveragesResult)finalCallOutResult.Response;
        //USS2221006 - START
        if(!calloutResult.Success && calloutResult.Message.contains('AAA:72')) {
            finalCallOutResult.Message = calloutResult.Message;
        } else if(!calloutResult2.Success && calloutResult2.Message.contains('AAA:72')) {
             finalCallOutResult.Message = calloutResult2.Message;
        }
        //USS2221006 - END
        SearchResultWrapper1 dataWrap = new SearchResultWrapper1();
        dataWrap.resultWrapper = resultwrap;
        dataWrap.message = finalCallOutResult.Message;
        dataWrap.statusCode = finalCallOutResult.statusCode;
        dataWrap.hasAccess = getHasUHGAccess();
        processedData = JSON.serialize(dataWrap);
        //new
        System.debug('@@ SAEMemberProviderDetail: processResponse: processedData: ' + processedData);
        return processedData;
    }

    public static String formRequestParameters(String memberId, String memberDOB, String memberFN, 
                                                String memberLN, String memberGrpN, String searchOption,
                                                String strProviderLastName, String dateStr, String strProviderNameID,
                                                String serviceStart, String serviceEnd, String strTaxIdNumber, String payerID) {
        String resultQuery = '?';
        resultQuery += 'searchOption=' + searchOption + '&payerID=' + payerID;
        resultQuery += '&lastName=' + memberLN;
        resultQuery += '&firstName=' + memberFN;
        resultQuery += '&providerLastName=' + strProviderLastName;
        resultQuery += '&providerFirstName=' + '';
        resultQuery += '&dateOfBirth=' + dateStr;
        resultQuery += '&groupNumber=' + memberGrpN;
        if (searchOption.contains('MemberID')) {
            resultQuery += '&memberId=' + memberId;
        }
        resultQuery += '&serviceStart=' + serviceStart;
        resultQuery += '&serviceEnd=' + serviceEnd;
        resultQuery += '&taxIdNumber=' + strTaxIdNumber;
        resultQuery += '&providerNameID=' + strProviderNameID;
        return resultQuery;
    }
    
    public class SearchResultWrapper1 {
        
        @AuraEnabled public SAEMemberProviderSearchCoveragesResult resultWrapper {get;set;}
        @AuraEnabled public Integer statusCode{get;set;}
        @AuraEnabled public String message{get;set;}                
        @AuraEnabled public Boolean hasAccess{get;set;}
        
        @AuraEnabled public SAEHouseHoldWrapper resultWrapper1 {get;set;}
    }
    
    @TestVisible
    private static Boolean getHasUHGAccess()
    {
        List<User> CurrentUser = [SELECT ID,UHG_Access__c FROM User WHERE Id = :USerInfo.getUserId()];
        if(CurrentUser.get(0).UHG_Access__c.equals('Yes')){
            return true;
        }
        else{
            return false;
        }
    }
    
    @AuraEnabled
    public static List<List<String>> searchOriginatorSolaris(String editSfId,String editFirstName,String editLastName,String editPhone, String editPhoneExt,String editEmail, String editOriginatorType, String editAgencyBroker, String editRewardAccount,
    		String editGeneralAgency, String editFranchiseCode, String editGroupName, String editGroupNum, String editPolicyNum, String editOtherOrigType){
    	List<List<String>> results = new List<List<String>>();
    	ETSBE_GetSolarisWebservice getSolaris = new ETSBE_GetSolarisWebservice();
		ACETWSCalloutResult CalloutResult;
		if(editOriginatorType == 'Agency/Broker'){
    		List<ETSBE_SolarisGeneralAgentDetailResult> resultWrapperList = new List<ETSBE_SolarisGeneralAgentDetailResult>();
            if(editRewardAccount != null && editRewardAccount != ''){
                CalloutResult = getSolaris.findGeneralAgent(editRewardAccount, 'rewAccNum');
	    		if(CalloutResult.Success != null && CalloutResult.Success){
    				resultWrapperList.addAll((List<ETSBE_SolarisGeneralAgentDetailResult>)CalloutResult.Response);
                    
                    for(ETSBE_SolarisGeneralAgentDetailResult newResults: resultWrapperList){
                        List<String> agencyBrokerInfo = new List<String>();
                        if(newResults.rewardAccountNumber != null && newResults.rewardAccountNumber != '' && newResults.agencyBrokerName != null && newResults.agencyBrokerName != ''){
                            agencyBrokerInfo.add(newResults.rewardAccountNumber);
                            agencyBrokerInfo.add(newResults.agencyBrokerName);
                            results.add(agencyBrokerInfo);
                        }    					
                    }
    			}
            }
    		if(editAgencyBroker != null && editAgencyBroker != ''){
				CalloutResult = getSolaris.findGeneralAgent(editAgencyBroker, 'agent');
	    		if(CalloutResult.Success != null && CalloutResult.Success){
    				resultWrapperList.addAll((List<ETSBE_SolarisGeneralAgentDetailResult>)CalloutResult.Response);
                    if(results.size() == 0 && resultWrapperList.size() > 10){
                        List<String> errorMsg = new List<String>();
                        errorMsg.add('Too Many Results');
                        results = new List<List<String>>();
                        results.add(errorMsg);
                    } else if(resultWrapperList.size() <= 10) {
                        for(ETSBE_SolarisGeneralAgentDetailResult newResults: resultWrapperList){
                            List<String> agencyBrokerInfo = new List<String>();
                            if(newResults.rewardAccountNumber != null && newResults.rewardAccountNumber != '' && newResults.agencyBrokerName != null && newResults.agencyBrokerName != ''){
                                System.debug('----------------------------------------------------------------------------------------------');
                                if(results.size() > 0 && results.size() <10){
                                    Boolean uniqueRecord = true;
                                    for(Integer i = 0; i < results.size(); i++){
                                        if(newResults.rewardAccountNumber == results[i][0] && newResults.agencyBrokerName == results[i][1]){
                                            uniqueRecord = false;
                                        }
                                    }
                                    if(uniqueRecord == true){
                                        agencyBrokerInfo = new List<String>();
                                        agencyBrokerInfo.add(newResults.rewardAccountNumber);
                                        agencyBrokerInfo.add(newResults.agencyBrokerName);
                                        results.add(agencyBrokerInfo);
                                    }
                                } else {
                                    agencyBrokerInfo.add(newResults.rewardAccountNumber);
                                    agencyBrokerInfo.add(newResults.agencyBrokerName);
                                    results.add(agencyBrokerInfo);
                                }
                            }
                        }
                    }
    			}
    		}
		} else if(editOriginatorType == 'General Agent'){
			List<ETSBE_SolarisGeneralAgentDetailResult> resultWrapperList = new List<ETSBE_SolarisGeneralAgentDetailResult>();
            if(editFranchiseCode != null && editFranchiseCode != ''){
                CalloutResult = getSolaris.findGeneralAgent(editFranchiseCode, 'franchise');
	    		if(CalloutResult.Success != null && CalloutResult.Success){
    				resultWrapperList.addAll((List<ETSBE_SolarisGeneralAgentDetailResult>)CalloutResult.Response);
                    for(ETSBE_SolarisGeneralAgentDetailResult newResults: resultWrapperList){
                        if(newResults.producers != null && !newResults.producers.isEmpty()){
                            for(ETSBE_SolarisGeneralAgentDetailResult.Producer newProducer: newResults.producers){
                                if(newProducer.name != null && newProducer.name != '' && newProducer.franchiseCode != null && newProducer.franchiseCode != ''){
                                    List<String> generalAgencyInfo = new List<String>();
                                    generalAgencyInfo.add(newProducer.franchiseCode);
                                    generalAgencyInfo.add(newProducer.name);
                                    results.add(generalAgencyInfo);
                                }
                            }
                        }
                    }
    			}
            }
		} else if(editOriginatorType == 'Group Contact'){
			List<ETSBE_SolarisGroupDetailResult> resultWrapperList = new List<ETSBE_SolarisGroupDetailResult>();
            if(editGroupNum != null && editGroupNum != ''){
                CalloutResult = getSolaris.findGroupContact(editGroupNum);
	    		if(CalloutResult.Success != null && CalloutResult.Success){
    				resultWrapperList.addAll((List<ETSBE_SolarisGroupDetailResult>)CalloutResult.Response);
                    
                    for(ETSBE_SolarisGroupDetailResult newResults: resultWrapperList){
                        List<String> groupInfo = new List<String>();
                        if(newResults.groupId != null && newResults.groupId != '' && newResults.policyNumber != null && newResults.policyNumber != ''){
                            groupInfo.add(newResults.groupName);
                            groupInfo.add(newResults.groupId);
                            groupInfo.add(newResults.policyNumber);
                            results.add(groupInfo);
                        }    					
                    }
    			}
            }
    		if(editPolicyNum != null && editPolicyNum != ''){
				CalloutResult = getSolaris.findGroupContact(editPolicyNum);
	    		if(CalloutResult.Success != null && CalloutResult.Success){
    				resultWrapperList.addAll((List<ETSBE_SolarisGroupDetailResult>)CalloutResult.Response);
                    if(results.size() == 0 && resultWrapperList.size() > 10){
                        List<String> errorMsg = new List<String>();
                        errorMsg.add('Too Many Results');
                        results = new List<List<String>>();
                        results.add(errorMsg);
                    } else if(resultWrapperList.size() <= 10) {
                        for(ETSBE_SolarisGroupDetailResult newResults: resultWrapperList){
                            List<String> groupInfo = new List<String>();
                            if(newResults.groupId != null && newResults.groupId != '' && newResults.policyNumber != null && newResults.policyNumber != ''){
                                System.debug('----------------------------------------------------------------------------------------------');
                                if(results.size() > 0 && results.size() <10){
                                    Boolean uniqueRecord = true;
                                    for(Integer i = 0; i < results.size(); i++){
                                        if(newResults.groupName == results[i][0] && newResults.groupId == results[i][1] && newResults.policyNumber == results[i][2]){
                                            uniqueRecord = false;
                                        }
                                    }
                                    if(uniqueRecord == true){
                                        groupInfo.add(newResults.groupName);
                                        groupInfo.add(newResults.groupId);
                                        groupInfo.add(newResults.policyNumber);
                                        results.add(groupInfo);
                                    }
                                } else {
                                    groupInfo.add(newResults.groupName);
                                    groupInfo.add(newResults.groupId);
                                    groupInfo.add(newResults.policyNumber);
                                    results.add(groupInfo);
                                }
                            }
                        }
                    }
    			}
    		}
    		//BELOW TO BE REMOVED AFTER SBAM/SOLARIS MERGE AND WHEN THERE IS AN API FOR MERIT RATHER THAN STORING THE GROUP RECORD IN SALESFORCE
			List<Merit_Group__c> results2 = new List<Merit_Group__c>();
	        List<SBam_Group__c> results1 = new List<SBam_Group__c>();
	        String resultstring;
        	String query = 'Select Group_Name__c, Group_Number__c, Policy_Renewal_Date__c, Policy_Number__c, Situs_State__c, Funding_Type__c, Line_of_Business__c, Sales_Office__c, Health_Plan_Major__c, Health_Plan_Minor__c, Region__c, Platform__c, Assigned_Broker__c FROM Merit_Group__c  WHERE Policy_Number__c = \'' + editPolicyNum + '\'';
        	System.debug('QUERY: ' + query);
        	results2 = Database.query(query);
        	String query1 = 'Select Group_Name__c, Group_Number__c, Policy_Renewal_Date__c, Policy_Number__c, Situs_State__c, Funding_Type__c, Line_of_Business__c, Sales_Office__c, Health_Plan_Major__c, Health_Plan_Minor__c, Region__c, Platform__c, Assigned_Broker__c FROM SBam_Group__c  WHERE Group_Number__c = \'' + editGroupNum + '\' OR Policy_Number__c = \'' + editPolicyNum + '\'';
        	System.debug('QUERY: ' + query1);
        	results1 = Database.query(query1);
        	System.debug('DB Results: ' + results);
        	List<ETSBE_SolarisGroupDetailResult> newResults = new List<ETSBE_SolarisGroupDetailResult>();
        	if(results2 != null && results2.size() > 0){
                for(Merit_Group__c result: results2){
            		ETSBE_SolarisGroupDetailResult newResult = new ETSBE_SolarisGroupDetailResult();
            		newResult.groupName = (result.Group_Name__c != null)?result.Group_Name__c:'';
            		newResult.groupId =  (result.Group_Number__c != null)?result.Group_Number__c:'';
            		newResult.policyNumber = (result.Policy_Number__c != null)?result.Policy_Number__c:'';
            		
            		List<String> groupInfo = new List<String>();
                    if(newResult.groupId != null && newResult.groupId != '' && newResult.policyNumber != null && newResult.policyNumber != ''){
                        groupInfo.add(newResult.groupName);
                        groupInfo.add(newResult.groupId);
                        groupInfo.add(newResult.policyNumber);
                        results.add(groupInfo);
                    } 
                }
                
            }
            if(results1 != null && results1.size() > 0){
                for(SBam_Group__c result: results1){
            		ETSBE_SolarisGroupDetailResult newResult = new ETSBE_SolarisGroupDetailResult();
            		newResult.groupName = (result.Group_Name__c != null)?result.Group_Name__c:'';
            		newResult.groupId =  (result.Group_Number__c != null)?result.Group_Number__c:'';
            		newResult.policyNumber = (result.Policy_Number__c != null)?result.Policy_Number__c:'';
            		List<String> groupInfo = new List<String>();
                    if(newResult.groupId != null && newResult.groupId != '' && newResult.policyNumber != null && newResult.policyNumber != ''){
                        groupInfo.add(newResult.groupName);
                        groupInfo.add(newResult.groupId);
                        groupInfo.add(newResult.policyNumber);
                        results.add(groupInfo);
                    } 
                }
                
            }
			//ABOVE TO BE REMOVED AFTER SBAM/SOLARIS MERGE AND WHEN THERE IS AN API FOR MERIT RATHER THAN STORING THE GROUP RECORD IN SALESFORCE
	
		}
		System.debug('RETURN RESULTS: ' + results);
    	return results;
    }
    
    //below is for creating a case from the automation email bot only
    //DE385766
    @AuraEnabled
    public static List<String> createBotCase(String origSfId,String strRecord, Boolean isProvider, String contactID, String flowType, String resolution, String dcsmId,String groupName,String subjectName){
        List<String> strCreatedCaseId = new List<String>();

        System.debug('JSON STRING: ' + strRecord);
        try{
           
            SAETTSCaseWrapper caseWrapper = (SAETTSCaseWrapper)JSON.deserialize(strRecord, SAETTSCaseWrapper.class);
            
            Interaction__c interaction = (Interaction__c) Database.query('SELECT Id, Current_Status__c, Interaction_Type__c, Name, Originator__c, Originator_Name__c, Originator_Phone__c, Originator_Email__c, Customer_Admin_Type__c, Reward_Account_Number__c, Franchise_Code__c, Contact_Name__c FROM Interaction__c WHERE Id = \'' + caseWrapper.Interaction + '\'');
            
            RecordType recordType = [SELECT Id, Name FROM RecordType WHERE sObjectType='case' AND Name='BEO'];
            User userDetails =[SELECT Id, UserRole.Name FROM User where Id =: UserInfo.getUserId()];
            
            Case caseObj = new Case();
            User oUser = [select Id,Name,Agent_Type__c,Profile_Name__c,ProfileId,Role_Name__c, BEO_Specialty__c FROM User Where SecureUserId__c =: dcsmId];
            //TODO UN-COMMENT ONCE WE HAVE THE MSID/FEDID SET UP FOR THE USER PROFILE
            //caseObj.OwnerId = oUser.Id;
            caseObj.ContactId = contactID;
            /*if(flowType == 'Member'){
                Account acc = new Account();
                Id personAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
                acc.RecordTypeId = personAccountRecordTypeId;
                String firstName = '';
                String lastName = '';
                if(caseWrapper.SubjectName.contains(' ')){
                	firstName = caseWrapper.SubjectName.split(' ')[0];
                	lastName = caseWrapper.SubjectName.split(' ')[1];
            	}
                acc.FirstName = (firstName != null)?firstName:'';
                acc.LastName = (lastName != null)?lastName:'';
                acc.PersonBirthdate = Date.parse(caseWrapper.subjectDOB);
                //acc.Phone = (memberPhoneNumber != null)?memberPhoneNumber:'';
                //acc.PersonEmail = (memberEmail != null)?memberEmail:'';
                acc.EID__c = firstName + lastName + caseWrapper.subjectDOB.remove('/') + caseWrapper.SubjectId;
                acc.EID__pc = firstName + lastName + caseWrapper.subjectDOB.remove('/') + caseWrapper.SubjectId;
                Database.upsert(acc, Account.Fields.EID__c);
                System.debug('HERE IS THE PERSON ACCT1: ' + acc);
                Account personContact = [SELECT id, PersonContactId FROM Account where id=: acc.id];
                System.debug('HERE IS THE PERSON ACCT2: ' + acc);
                caseObj.ContactId = personContact.PersonContactId;
            }*/
            
            
            caseObj.Subject_Type__c = flowType;
            
            caseObj.Status = 'Bot';
            //caseObj.Subject_Name__c = caseWrapper.SubjectName; //Set to a static name
            
            caseObj.ID__c = caseWrapper.SubjectId;
            //caseObj.Subject_Name__c = caseWrapper.SubjectName;
            caseObj.Subject_Name__c=subjectName;
            
            //the below vars are definitely not set correctly
            if(flowType == 'Member'){
                
                //caseObj.Surrogate_Key__c = caseWrapper.SubjectName.remove(' ') + caseWrapper.SubjectDOB.remove('/') + caseWrapper.SubjectId + caseWrapper.SubjectGroupId;
                caseObj.Surrogate_Key__c = subjectName.remove(' ') + caseWrapper.SubjectDOB.remove('/') + caseWrapper.SubjectId + caseWrapper.SubjectGroupId;
            }
            caseObj.Originator_Relationship__c = (caseWrapper.otherAdminType != '') ? caseWrapper.otherAdminType : null;
			caseObj.Reward_Account_Number__c = (interaction.Reward_Account_Number__c != null)?interaction.Reward_Account_Number__c:'';
			caseObj.Franchise_Code__c = (interaction.Franchise_Code__c != null)?interaction.Franchise_Code__c:'';
			System.debug('CREATE CASE5: ');
			caseObj.Caller__c = (interaction.Contact_Name__c != null)?interaction.Contact_Name__c:'';
            caseObj.Case_Type__c = 'BEO Case';
            
            
            caseObj.Interaction__c = (caseWrapper.Interaction != null)?caseWrapper.Interaction : '';
			//caseObj.Business_Direction__c = (caseWrapper.specialInstructions != null)?caseWrapper.specialInstructions:'';
			caseObj.Special_Instructions_Business_Unit__c = (caseWrapper.specialInstructionsBusinessUnit != null)?caseWrapper.specialInstructionsBusinessUnit:'';
			caseObj.Issue_Category_Desc__c = (caseWrapper.issueCategoryDesc != null)?caseWrapper.issueCategoryDesc:'';
			//caseObj.Task_Category_Type_Desc__c = (caseWrapper.taskCategoryTypeDesc != null)?caseWrapper.taskCategoryTypeDesc:'';
			//caseObj.Task_Category_Subtype_Desc__c = (caseWrapper.taskCategorySubtypeDesc != null)?caseWrapper.taskCategorySubtypeDesc:'';
			caseObj.Special_Instructions_Subject__c = (caseWrapper.specialInstructionsSubject != null)?caseWrapper.specialInstructionsSubject:'';
			caseObj.Special_Instructions_Description__c = (resolution != null)?resolution:'';
			//caseObj.Special_Instructions_Reference_ID__c = (caseWrapper.specialInstructionsReferenceID != null)?caseWrapper.specialInstructionsReferenceID:'';
            
            
            caseObj.Event_Type__c = 'Standard';
            if(caseWrapper.specialInstructionsQueue != null && caseWrapper.specialInstructionsQueue != ''){
				List<Group> queueList = [SELECT Id FROM Group WHERE Type='Queue' AND Name =: caseWrapper.specialInstructionsQueue];
				System.debug('QUEUE STUFF2: ' + queueList);
				if (queueList != null && queueList.size() > 0) {
					//caseObj.OwnerId = queueList[0].Id;
					caseObj.Queue_Id__c = queueList[0].Id;
				}
			}
            
			String dosStr = '';
			if(caseWrapper.specialInstructionsDateOfService != null && caseWrapper.specialInstructionsDateOfService != ''){
				dosStr = caseWrapper.specialInstructionsDateOfService;
				if(dosStr.contains(',')){
					dosStr = dosStr.replace(',',',\n');
				}
			}
			caseObj.Date_of_Service__c = (dosStr != null)?dosStr:'';
            
            
            caseObj.RecordTypeId = recordType.Id;
            caseObj.Broker_Name__c = (caseWrapper.brokerName != null)?caseWrapper.brokerName:'';
            caseObj.Broker_ID__c = (caseWrapper.brokerId != null)?caseWrapper.brokerId:'';
            //caseObj.Group_Name__c = (caseWrapper.groupName != null )? caseWrapper.groupName : '';
            caseObj.Group_Name__c= groupName;
           	caseObj.Group_ID__c = (caseWrapper.groupId != null )? caseWrapper.groupId : '';
           	caseObj.Policy_Year__c = (caseWrapper.groupPolicyYear != null )? caseWrapper.groupPolicyYear : ''; 
           	caseObj.Situs_State__c = (caseWrapper.SubjectSitus != null )? caseWrapper.SubjectSitus : '';
           	caseObj.Situs__c = (caseWrapper.SubjectSitus != null )? caseWrapper.SubjectSitus : '';
           	
           	caseObj.Funding_Type__c = (caseWrapper.groupFundingType != null )? caseWrapper.groupFundingType : '';
           	caseObj.Platform__c = (caseWrapper.groupPlatform != null )? caseWrapper.groupPlatform : '';
           	caseObj.Line_of_Business__c = caseWrapper.groupLineOfBusiness != '' ? caseWrapper.groupLineOfBusiness : null;
            caseObj.Region__c = caseWrapper.groupRegion != '' ? caseWrapper.groupRegion : null;
            caseObj.Sales_Office__c = caseWrapper.groupSalesOffice != '' ? caseWrapper.groupSalesOffice : null;
            caseObj.Health_Plan_Major__c = caseWrapper.groupHelathPlanMajor != '' ? caseWrapper.groupHelathPlanMajor : null;
            caseObj.Health_Plan_Minor__c = caseWrapper.groupHelathPlanMinor != '' ? caseWrapper.groupHelathPlanMinor : null;
            caseObj.Policy__c = caseWrapper.groupPolicy != '' ? caseWrapper.groupPolicy : null;
            String groupPolicyRenwyear = caseWrapper.groupPolicyRenewalYear != null ? caseWrapper.groupPolicyRenewalYear : '';
            caseObj.Group_Solaris_ID__c = (caseWrapper.groupSolarisId != null)?caseWrapper.groupSolarisId:'';
		    String dateFormat = '';
   			if(groupPolicyRenwyear.split('/').size() == 3){
   				dateFormat = groupPolicyRenwyear;
	   		} else if(groupPolicyRenwyear.split('-').size() == 3){
	   			dateFormat = groupPolicyRenwyear.split('-')[1] + '/' + groupPolicyRenwyear.split('-')[2] + '/' + groupPolicyRenwyear.split('-')[0];
	   		}
	   		System.debug('DATE NEW FORMAT: ' + dateFormat);
	   		if(dateFormat != null && dateFormat != '') {
	   			caseObj.Policy_Renewal_Year__c = Date.parse(dateFormat);
	   		}
            
            
            caseObj.SLA__c = caseWrapper.slaDay;
            caseObj.Email__c = (caseWrapper.emailURL != null)?caseWrapper.emailURL:'';
            Date cuurentDate = System.Today();
            Decimal slaDay = caseWrapper.slaDay;
            Integer slaDayVal = 0;            
            if(slaDay != null) {
                slaDayVal = slaDay.intValue();
            }
			
            // Get the default business hours
            BusinessHours businessHoursObj = [SELECT Id FROM BusinessHours WHERE Name='ETS-BE/BEO' AND IsActive=true];
            
            /* List of Dates to be considered by excluding the Weekend & Holidays */
            List<Date> listOfDatesToConsider = new List<Date>();
            
            for(Integer i=0; i<slaDayVal; i++){
                Date currDate = cuurentDate.addDays(i);
                DateTime curDateAndTime = DateTime.newInstance(currDate.year(), currDate.month(), currDate.day());
                Boolean isBusinessDay = BusinessHours.isWithin(businessHoursObj.id, curDateAndTime);
                if(isBusinessDay) {
                    listOfDatesToConsider.add(currDate);
                } else {
                    slaDayVal = slaDayVal+1;
                }
            }  
            
            
            
            if(listOfDatesToConsider != null && listOfDatesToConsider.size() > 0) {
                System.debug(listOfDatesToConsider[listOfDatesToConsider.size()-1]);
                Date followUpDate = listOfDatesToConsider[listOfDatesToConsider.size()-1]; 
                caseObj.Follow_Up_Date__c = DateTime.newInstance(followUpDate, DateTime.now().time());
            }            
            
            
            // Follow Up Date Calculation END - Yogitha
            
            // US2488115 -> Member Relationship Saved to the Case - Yogitha
            
            caseObj.Member_Relationship__c = caseWrapper.memberRelationship;            
            
            // 
            // US1974034 - Thanish (23rd Aug 2019) - to show subject DOB in MM/DD/YYYY format
            //Adding null check - 23/10/2019 - Sarma
            
            
            if(caseWrapper.SubjectDOB != null){
                 if(caseWrapper.SubjectDOB.contains('/')) {
                caseObj.DOB__c = caseWrapper.SubjectDOB;
                } else {
                    caseObj.DOB__c =  SAEUtils.formatDate(caseWrapper.SubjectDOB);
                }
            }
            if(isProvider){
                caseObj.Subject_Group_ID__c = '';
            }else{
                caseObj.Subject_Group_ID__c = caseWrapper.SubjectGroupId;
            }
            
            
            caseObj.Topic__c = caseWrapper.AddInfoTopic;
            caseObj.Type__c = caseWrapper.ttsType;
            caseObj.Subtype__c = caseWrapper.ttsSubType;
            caseObj.Original_Type__c = caseWrapper.AddInfoOrginType;
            caseObj.Original_Subtype__c = caseWrapper.AddInfoOrginSubType;
            caseObj.Created_By_Role__c = userDetails.UserRole.Name;
            caseObj.TaxID__c = caseWrapper.TaxId;
            caseObj.Onshore_Restriction__c = 'No';
            caseObj.UHG_Restriction__c = caseWrapper.uhgRestriction;
            
            
            insert caseObj;
            case newCase = [Select Id,CaseNumber,Subject_Name__c,ID__c from Case where Id=:caseObj.Id];
	        newCase.OwnerId = oUser.Id;
            update newCase;
	        interaction.OwnerId = oUser.Id;
	        update interaction;
            strCreatedCaseId.add(newCase.Id);
            strCreatedCaseId.add(newCase.CaseNumber);
            
            
            
            //Case caseObjTest = [Select Id,Target_Date__c from Case where Id=:strCreatedCaseId];
        } catch(Exception e) {
        	System.debug('CREATE CASE: BAD THINGS');
            System.debug(LoggingLevel.ERROR,'####ERROR:'+e.getMessage());
            System.debug(LoggingLevel.ERROR,'####ERROR LINE:'+e.getLineNumber());
        }
        
        return strCreatedCaseId;
    }
    
    
    /*Logic to Insert Attachements onto Case Record  US:US2564216:*/
    
    Public static void insertAttachments(List<String> docIDs,String caseId){
        
        List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();       
        ContentDocumentLink contentDocumentLink=new ContentDocumentLink();
        try{
            List< ContentVersion> contentVersionsLst=[select id ,ContentDocumentId from ContentVersion where ContentDocumentId IN: docIDs] ;  
              if(contentVersionsLst.size()!=null){
                for(ContentVersion contentVersion : contentVersionsLst){
                    contentDocumentLink = createContentDocumentLink(contentVersion.ContentDocumentId,caseId);     
                    contentDocumentLinks.add(contentDocumentLink);
                }
            }
            insert contentDocumentLinks;  
        } catch(Exception e) {
            System.debug(LoggingLevel.ERROR,'####ERROR:'+e.getMessage());
        }
    }
    
    //US3041121:Change
    @AuraEnabled
    Public Static void deleteAttachedFiles(String docId,String caseId){
        
        if(caseId!=null && docId!=null){
         try{
            ContentVersion conVer=[select id ,ContentDocumentId from ContentVersion where ContentDocumentId =: docId] ; 
            
            ContentDocument conDoc=[select id from ContentDocument where id=:conVer.ContentDocumentId];

            if(conDoc!=null){
               Delete conDoc;   
            }
                
            }catch(Exception e) {
             System.debug(LoggingLevel.ERROR,'####DOC DELETION ERROR:'+e.getMessage());
          }                         
        }
    }     
     public Static ContentDocumentLink createContentDocumentLink(Id contentDocumentId, String caseId){
        ContentDocumentLink contentDocumentLink = new ContentDocumentLink();
        contentDocumentLink.ContentDocumentId = contentDocumentId;
        contentDocumentLink.LinkedEntityId = caseId;              
        //contentDocumentLink.ShareType = 'I'; 
        contentDocumentLink.Visibility = 'AllUsers';
        return contentDocumentLink;
    }  
     
    //US2580332:DE391382 Populate EventType/Business Unit
    public static void populateEvntTypeBusinessUnit(String caseId){       
         Interaction__c interaction = new Interaction__c();
         Case caseRecord=[select Interaction__r.Business_Unit__c,Interaction__r.Event_Type__c,Special_Instructions_Business_Unit__c,Event_Type__c from Case where id=:caseId limit 1];
         
        if(caseRecord!=null && caseRecord.Interaction__r.Event_Type__c==null && caseRecord.Interaction__r.Business_Unit__c==null){
            interaction.Business_Unit__c=caseRecord.Special_Instructions_Business_Unit__c;
            interaction.Event_Type__c=caseRecord.Event_Type__c;
        }else if(caseRecord!=null && caseRecord.Interaction__r.Event_Type__c!=null && caseRecord.Interaction__r.Business_Unit__c==null  ){
            interaction.Business_Unit__c=caseRecord.Special_Instructions_Business_Unit__c; 
        }  else if(caseRecord!=null && caseRecord.Interaction__r.Event_Type__c==null && caseRecord.Interaction__r.Business_Unit__c!=null){
            interaction.Event_Type__c=caseRecord.Event_Type__c;
        }    
        interaction.CSS_SRT__c ='Others';       
        interaction.Id=caseRecord.Interaction__c;
        update interaction;  
        
    }
    @auraEnabled
    public static void fps_UpdateCase(String a_originator, string a_groupNumber, string a_caseId, String a_interactionType){
        system.debug('in fps'+a_groupNumber+'p'+a_caseId+'p'+a_interactionType+'p'+a_originator); 
        if(a_caseId != null){
            Case caseRecord=[select id,Originator_name__c,Originator_Type__c,Policy__c,Subject_Name__c,Subject_Group_ID__c,SourceCode__c,Platform__c,status from Case where id=:a_caseId limit 1];
            if(a_originator != null){
                One_Click_Originator__c originator =(One_Click_Originator__c)JSON.deserialize(a_originator,One_Click_Originator__c.class);
                caseRecord.Originator_name__c = (originator.First_Name__c +' '+originator.Last_Name__c);
                caseRecord.Originator_Relationship__c = originator.Originator_Type__c ;
                caseRecord.One_Click_Originator__c = String.isNotBlank(originator.Id)?originator.Id:'' ;
            }
            if(a_groupNumber != null){
                ETSBE_SolarisGroupDetailResult groupVal = (ETSBE_SolarisGroupDetailResult)JSON.deserialize(a_groupNumber, ETSBE_SolarisGroupDetailResult.class);
                caseRecord.Subject_Name__c = groupVal.groupName;
                caseRecord.Subject_Group_ID__c = groupVal.groupId;
                caseRecord.SourceCode__c = groupVal.sourceCode;
                caseRecord.Policy__c = groupVal.policyNumber;
                caseRecord.Platform__c =groupVal.platform;
            }
            caseRecord.Origin = a_interactionType ;
            if(caseRecord.Status == 'New')
            caseRecord.Status = 'Open';
            update caseRecord ;
        }
    }
    @auraEnabled
    public static case fps_createCase(String a_originator, string a_groupNumber,String a_interactionType){
        system.debug('in fps'+a_groupNumber+'p'+a_interactionType+'p'+a_originator); 
         system.debug('Originator values'+a_originator); 
         system.debug('Group values'+a_groupNumber); 
         system.debug('interaction values'+a_interactionType); 
        Case caseRecord = new case();
        Id recid = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('FPS_OST').getRecordTypeId();
        if(a_originator != null){
            One_Click_Originator__c originator =(One_Click_Originator__c)JSON.deserialize(a_originator,One_Click_Originator__c.class);
            caseRecord.Originator_name__c = (originator.First_Name__c +' '+originator.Last_Name__c);
            caseRecord.Originator_Relationship__c = originator.Originator_Type__c ;
            caseRecord.Policy_Number__c= originator.Policy_Number__c;
            caseRecord.One_Click_Originator__c = String.isNotBlank(originator.Id) ?originator.Id : '';
        }    
        if(a_groupNumber != null){
            ETSBE_SolarisGroupDetailResult groupInfo = (ETSBE_SolarisGroupDetailResult)JSON.deserialize(a_groupNumber, ETSBE_SolarisGroupDetailResult.class);
            caseRecord.Subject_Name__c = groupInfo.groupName;
            caseRecord.Subject_Group_ID__c = groupInfo.groupId;
            caseRecord.SourceCode__c = groupInfo.sourceCode;
            caseRecord.Policy__c = groupInfo.policyNumber;
            caseRecord.Platform__c =groupInfo.platform;
            String firstname = '';
            String lastname ='';
            String contactId ;
            if(groupInfo != null){
                if(groupInfo.groupName.length()<=80){
                    firstname = '';
                    lastname = groupInfo.groupName;
                } else if(groupInfo.groupName.length()>80 && groupInfo.groupName.length()<=120){
                    firstname = groupInfo.groupName.substring(0,40);
                    lastname = groupInfo.groupName.substring(40,groupInfo.groupName.length());
                }
                else if(groupInfo.groupName.length()>120){
                    firstname = groupInfo.groupName.substring(0,40);
                    lastname = groupInfo.groupName.substring(40,120);
                }
            }
            contactId = createPersonAccount('Group/Employer',firstName,lastName,groupInfo.groupId, null, 'No');
            caseRecord.contactId = contactId;
        }
        caseRecord.Origin = a_interactionType ;
        caseRecord.Status = 'New';
        caseRecord.RecordTypeId =recid ;
        system.debug('caseRecord=='+caseRecord);
        insert caseRecord ;
        
        return caseRecord ;
    }
    
    /* fps related code*/
    public static map<string, string> getCustomMetadata(){
        map<string, string> mapMetaDataVals = new map<string, string>();
        for(ACET_LWC_Util__mdt utilRec : [Select MasterLabel,Field_Properties__c,Picklist_Properties__c
                                          from ACET_LWC_Util__mdt where DeveloperName = 'FPS_Originator']){
            mapMetaDataVals.put('pickVals',utilRec.Picklist_Properties__c);
            mapMetaDataVals.put('fieldVisibility',utilRec.Field_Properties__c);// visibility
        }
        return mapMetaDataVals;
    }
    
    /*@AuraEnabled(cacheable=true)
    public static List<FieldsetResult> getOrgFieldsetFields(){
        Map<String,String> businessPropeties = ETSBE_OneClickController.getCustomMetadata();
        list<string> lstVisibleFields = new list<string>();
        Map<String, list<string>>  pickVals= new Map<String, list<string>>();
        for(string rec : businessPropeties.keySet()){
            if(rec == 'fieldVisibility'){
                 lstVisibleFields =  businessPropeties.get(rec).split(';');
            }
            if(rec == 'pickVals'){
                Map<String, Object>  map1 = (Map<String, Object>) JSON.deserializeUntyped(businessPropeties.get(rec));
                for(string str : map1.keySet()){
                     list<string> lstOpts = new list<string>();
                     list<object> lstObj = (list<object>) map1.get(str);
                     for(object obj : lstObj){
                        string strg = (string) obj;
                        lstOpts.add(strg);
                    }
                     pickVals.put(str, lstOpts);
                 }
            }
        }
        List<FieldsetResult> fldres = new List<FieldsetResult> ();
        List<Schema.FieldSetMember> lstOrgFieldsetLeft = 
        One_Click_Originator__c.getSObjectType().getDescribe().fieldSets.getMap().get('FPS_Originator').getFields();
        list<string> listPLOptions = new list<string>();
        for(Schema.FieldSetMember fld : lstOrgFieldsetLeft) {
            system.debug('-------type------'+fld.getType());
            Boolean isPickLst;
            string fldtype;
            listPLOptions = new list<string>();
            if(fld.getType() == Schema.DisplayType.PICKLIST){
                fldtype = 'PICKLIST';
                isPickLst = true;
                if(pickVals.containsKey(fld.getFieldPath())){
                     listPLOptions = pickVals.get(fld.getFieldPath());
                }
            }else{
                if(fld.getType() == Schema.DisplayType.STRING){
                   fldtype = 'text';
                }else{
                   fldtype = string.valueOf(fld.getType());
                }
                isPickLst = false;
            }
            if(lstVisibleFields.contains(fld.getFieldPath())){
                ETSBE_OneClickController.FieldsetResult newfld = new FieldsetResult(fld.getFieldPath(), fld.getLabel(),isPickLst,null,fld.getRequired(),true,false,listPLOptions,lstVisibleFields,fldtype,false);
                fldres.add(newfld);
               
            }
            else{
                ETSBE_OneClickController.FieldsetResult newfld = new FieldsetResult(fld.getFieldPath(), fld.getLabel(),isPickLst,null,fld.getRequired(),true,true,listPLOptions,lstVisibleFields,fldtype,false);
                fldres.add(newfld);
                
            }
            
       }
        List<Schema.FieldSetMember> lstOrgFieldsetRight = 
        One_Click_Originator__c.getSObjectType().getDescribe().fieldSets.getMap().get('FPS_Originator_Right').getFields();
       for(Schema.FieldSetMember fld : lstOrgFieldsetRight) {
          system.debug('-------type------'+fld.getType());
            Boolean isPickLst;
            string fldtype;
            listPLOptions = new list<string>();
            if(fld.getType() == Schema.DisplayType.PICKLIST){
                fldtype = 'PICKLIST';
                isPickLst = true;
                if(pickVals.containsKey(fld.getFieldPath())){
                    listPLOptions = pickVals.get(fld.getFieldPath());
                }
                  system.debug('---------listPLOptions------'+listPLOptions);
            }else{
                if(fld.getType() == Schema.DisplayType.STRING){
                   fldtype = 'text';
                }else{
                   fldtype = string.valueOf(fld.getType());
                }
                isPickLst = false;
            }
            if(lstVisibleFields.contains(fld.getFieldPath())){
                ETSBE_OneClickController.FieldsetResult newfld = new FieldsetResult(fld.getFieldPath(), fld.getLabel(),isPickLst,null,fld.getRequired(),false,false,listPLOptions,lstVisibleFields,fldtype,false);
                fldres.add(newfld);
            }
            else{
                ETSBE_OneClickController.FieldsetResult newfld = new FieldsetResult(fld.getFieldPath(), fld.getLabel(),isPickLst,null,fld.getRequired(),false,true,listPLOptions,lstVisibleFields,fldtype,false);
                fldres.add(newfld);
            }
           
       }
      system.debug('-------fldres-------'+fldres);
      return fldres;
    }*/
    @AuraEnabled(cacheable=true)
    public static List<FieldsetResult> getOrgFieldsetFields(){
        Map<String,String> businessPropeties = ETSBE_OneClickController.getCustomMetadata();
        list<string> lstVisibleFields = new list<string>();
        Map<String, list<string>>  pickVals= new Map<String, list<string>>();
        for(string rec : businessPropeties.keySet()){
            if(rec == 'fieldVisibility'){
                lstVisibleFields =  businessPropeties.get(rec).split(';');
            }
            if(rec == 'pickVals'){
                Map<String, Object>  map1 = (Map<String, Object>) JSON.deserializeUntyped(businessPropeties.get(rec));
                for(string str : map1.keySet()){
                    list<string> lstOpts = new list<string>();
                    list<object> lstObj = (list<object>) map1.get(str);
                    for(object obj : lstObj){
                        string strg = (string) obj;
                        lstOpts.add(strg);
                    }
                    pickVals.put(str, lstOpts);
                }
            }
        }
        List<FieldsetResult> fieldResult = new List<FieldsetResult> ();
        fieldResult = getOrgFieldsetFieldsClone1(lstVisibleFields,pickVals);
        return fieldResult;
    }
    
    public static List<FieldsetResult> getOrgFieldsetFieldsClone1(list<string> lstVisibleFields,Map<String, list<string>>  pickVals){
        List<FieldsetResult> fldres = new List<FieldsetResult> ();
        List<Schema.FieldSetMember> lstOrgFieldsetLeft = 
            One_Click_Originator__c.getSObjectType().getDescribe().fieldSets.getMap().get('FPS_Originator').getFields();
        list<string> listPLOptions = new list<string>();
        for(Schema.FieldSetMember fld : lstOrgFieldsetLeft) {
            system.debug('-------type------'+fld.getType());
			system.debug('-------label------'+fld.getLabel());
            Boolean isPickLst;
            string fldtype;
            listPLOptions = new list<string>();
            if(fld.getType() == Schema.DisplayType.PICKLIST){
                fldtype = 'PICKLIST';
                isPickLst = true;
                if(pickVals.containsKey(fld.getFieldPath())){
                    listPLOptions = pickVals.get(fld.getFieldPath());
                }
            }else{
                if(fld.getType() == Schema.DisplayType.STRING){
                    fldtype = 'text';
                }else{
                    fldtype = string.valueOf(fld.getType());
                }
                isPickLst = false;
            }
            if(lstVisibleFields.contains(fld.getFieldPath())){
                ETSBE_OneClickController.FieldsetResult newfld = new FieldsetResult(fld.getFieldPath(), fld.getLabel(),isPickLst,null,fld.getRequired(),true,false,listPLOptions,lstVisibleFields,fldtype,false);
                fldres.add(newfld);
            }
            else{
                ETSBE_OneClickController.FieldsetResult newfld = new FieldsetResult(fld.getFieldPath(), fld.getLabel(),isPickLst,null,fld.getRequired(),true,true,listPLOptions,lstVisibleFields,fldtype,false);
                fldres.add(newfld);
            }
        }
        fldres = getOrgFieldsetFieldsClone2(lstVisibleFields, pickVals, fldres);
        return fldres;
    }
    public static List<FieldsetResult> getOrgFieldsetFieldsClone2(list<string> lstVisibleFields, Map<String, list<string>>  pickVals, List<FieldsetResult> fldres){
        List<Schema.FieldSetMember> lstOrgFieldsetRight = 
            One_Click_Originator__c.getSObjectType().getDescribe().fieldSets.getMap().get('FPS_Originator_Right').getFields();
        list<string> listPLOptions = new list<string>();
        for(Schema.FieldSetMember fld : lstOrgFieldsetRight) {
            system.debug('-------type------'+fld.getType());
			system.debug('-------label------'+fld.getLabel());
            Boolean isPickLst;
            string fldtype;
            listPLOptions = new list<string>();
            if(fld.getType() == Schema.DisplayType.PICKLIST){
                fldtype = 'PICKLIST';
                isPickLst = true;
                if(pickVals.containsKey(fld.getFieldPath())){
                    listPLOptions = pickVals.get(fld.getFieldPath());
                }
                system.debug('---------listPLOptions------'+listPLOptions);
            }else{
                if(fld.getType() == Schema.DisplayType.STRING){
                    fldtype = 'text';
                }else{
                    fldtype = string.valueOf(fld.getType());
                }
                isPickLst = false;
            }
            if(lstVisibleFields.contains(fld.getFieldPath())){
                ETSBE_OneClickController.FieldsetResult newfld = new FieldsetResult(fld.getFieldPath(), fld.getLabel(),isPickLst,null,fld.getRequired(),false,false,listPLOptions,lstVisibleFields,fldtype,false);
                fldres.add(newfld);
            }
            else{
                ETSBE_OneClickController.FieldsetResult newfld = new FieldsetResult(fld.getFieldPath(), fld.getLabel(),isPickLst,null,fld.getRequired(),false,true,listPLOptions,lstVisibleFields,fldtype,false);
                fldres.add(newfld);
            }
            
        }
        return fldres;
    }
   

    public class FieldsetResult
    {
        @AuraEnabled 
        public String apiName{get;set;}
        @AuraEnabled 
        public String name{get;set;}
        @AuraEnabled 
        public boolean isPicklist{get;set;}
        @AuraEnabled 
        public String value{get;set;}
        @AuraEnabled 
        public boolean isRequired{get;set;}
        @AuraEnabled 
        public boolean isLeft{get;set;}
        @AuraEnabled 
        public boolean isVisible{get;set;}
        @AuraEnabled 
        public list<string> picklistValues{get;set;}
        @AuraEnabled 
        public list<string> hiddenFields{get;set;}
        @AuraEnabled 
        public string fieldType{get;set;}
        @AuraEnabled 
        public boolean isDisable{get;set;}

        public FieldsetResult(String apiName, String name,Boolean isPicklist,String value,boolean isRequired,boolean isLeft,boolean isVisible,list<string> picklistValues,list<string> hiddenFields,string fieldType,boolean isDisable)
        {
            this.apiName = apiName;
            this.name = name;
            this.isPicklist = isPicklist;
            this.value = value;
            this.isRequired = isRequired;
            this.isLeft = isLeft; 
            this.isVisible = isVisible;
            this.picklistValues = picklistValues;
            this.hiddenFields = hiddenFields;
            this.fieldType = fieldType;
            this.isDisable = isDisable;
        }
    }
    public static One_Click_Originator__c getOriginatorRole(One_Click_Originator__c editOrig,String editOtherOrigRole) {
        editOrig.Originator_Role__c = (editOtherOrigRole != null && editOtherOrigRole != 'None')?editOtherOrigRole:'';
        return editOrig;
    }
    /* fps code */
    @auraEnabled
    public static casedetailsWrapper fps_getCaseDetails(String caseId){
        casedetailsWrapper caseData = new casedetailsWrapper();
        Case caseObj = new Case();
        List<One_Click_Originator__c> originator = new List<One_Click_Originator__c>();
        if(caseId != null){
         caseObj = [Select Id, Status,Origin ,ContactId, One_Click_Originator__c ,One_Click_Originator__r.Originator_Role__c,One_Click_Originator__r.First_Name__c,One_Click_Originator__r.Last_Name__c,One_Click_Originator__r.Phone_Number__c,One_Click_Originator__r.Email__c,One_Click_Originator__r.Other_Originator_Type__c,One_Click_Originator__r.Originator_Type__c,One_Click_Originator__r.Policy_Number__c,One_Click_Originator__r.Reward_Account_Number__c,One_Click_Originator__r.Franchise_Code__c,SourceCode__c , Event_Type__c, Originator_name__c, OriginatorPhone__c, Originator_Relationship__c, OriginatorEmail__c, Originator_Type__c, Caller__c, Reward_Account_Number__c, Franchise_Code__c, Subject_Name__c, Subject_Type__c, Date_of_Service__c, Group_Name__c, Line_of_Business__c, Assigned_Broker__c, Region__c,UHG_Restriction__c, Sales_Office__c, Health_Plan_Major__c, Health_Plan_Minor__c, Member_SSN__c, DOB__c, Policy_Year__c, Situs__c, ID__c, Subject_Group_ID__c, Funding_Type__c, Platform__c, Policy__c, Policy_Renewal_Year__c,Broker_Name__c,Broker_ID__c from Case where Id =: caseId];    
        }
        if(caseObj.One_Click_Originator__r.Id != null)
        originator = [SELECT Id,First_Name__c,Last_Name__c,Phone_Number__c,Email__c,Phone_Ext__c,Originator_Type__c,Agency_Broker_Name__c,Reward_Account_Number__c,General_Agency__c,Franchise_Code__c,Group_Name__c,Group_Number__c,Policy_Number__c,Other_Originator_Type__c,Originator_Role__c FROM One_Click_Originator__c WHERE Id =: caseObj.One_Click_Originator__r.Id];
        caseData.casedetails = caseObj;
        caseData.originatorDetails = originator;
        return caseData;
    }  
    public class casedetailsWrapper
    {
        @AuraEnabled 
        public case casedetails{get;set;}
        @AuraEnabled 
        public List<One_Click_Originator__c> originatorDetails{get;set;}
    }
}