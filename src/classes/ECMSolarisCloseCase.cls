public without sharing class ECMSolarisCloseCase {
	
    //send closed cases back to Solaris
    @Future(callout=true)
    public static void sendSolarisClosedCases(List<String> caseList){  
        if(caseList != Null && caseList.isEmpty() == False){
            List<Case> listCases = new list<Case>([SELECT Id,CaseNumber,CreatedDate,ClosedDate,Group_Solaris_ID__c,Subject_Name__c,Interaction__c,Interaction__r.Id,Interaction__r.Originator_Name__c,Interaction__r.Originator_Type__c,Event_Received_Date_Time__c,Issue_Category_Desc__c,Special_Instructions_Description__c FROM Case WHERE id in :caseList]);
            System.debug('LISTCASES: ' + listCases);
            BusinessHours businessHoursObj = [SELECT Id FROM BusinessHours WHERE Name='ETS-BE/BEO' AND IsActive=true];
        	for(Case sendCase: listCases){
        		System.debug('TRIGGER CLOSED CASE2: ' + sendCase.Id + ',' + sendCase.CaseNumber);
				String accountId = (sendCase.Group_Solaris_ID__c != null)?sendCase.Group_Solaris_ID__c:'';
        		String caseId = (sendCase.CaseNumber != null)?sendCase.CaseNumber:'';
        		
        		String formatRecDate = string.valueOfGmt(sendCase.Event_Received_Date_Time__c);
        		System.debug('DATE REC1: ' + formatRecDate);
        		if(formatRecDate != null && formatRecDate.contains(' ')){
        			formatRecDate = formatRecDate.split(' ')[0];
        		}
        		System.debug('DATE REC2: ' + formatRecDate);
				String receivedDate = formatRecDate;
				String subject = (sendCase.Special_Instructions_Description__c != null)?sendCase.Special_Instructions_Description__c:'';
				//subject = subject.replaceAll('\n','\\\\n');
				subject = JSON.serialize(subject);
        		String contactName = (sendCase.interaction__r.Originator_Name__c != null)?sendCase.interaction__r.Originator_Name__c:'';
        		String originatorType = (sendCase.interaction__r.Originator_Type__c != null)?sendCase.interaction__r.Originator_Type__c:'';
				String issueType = (sendCase.Issue_Category_Desc__c != null)?sendCase.Issue_Category_Desc__c:'';
				System.debug('DATE STUFF1: ' + sendCase.ClosedDate);
				String formatDate = string.valueOfGmt(sendCase.ClosedDate);
        		System.debug('DATE STUFF2: ' + formatDate);
        		if(formatDate != null && formatDate.contains(' ')){
        			formatDate = formatDate.split(' ')[0];
        		}
        		System.debug('DATE STUFF3: ' + formatDate);
        		String closedDate = formatDate;
        		
        		String agefield = '';
		        try {
		            DateTime startDateTime;
		            Datetime endDateTime;
		            if(sendCase != null) {
		                startDateTime = sendCase.CreatedDate;
		                if(sendCase.ClosedDate != null) {
		                	endDateTime = sendCase.ClosedDate;    
		                } else {
		                    endDateTime = DateTime.now();
		                }                
		            }
		            ETSBE_AgeCalculationBatch_Handler.AgeDataWrapper ageDataWrapperObj = ETSBE_AgeCalculationBatch_Handler.returnAgeInDaysAndHours(startDateTime, endDateTime, 0, null, '', businessHoursObj);
		            if(ageDataWrapperObj != null && ageDataWrapperObj.noOfDays != null && ageDataWrapperObj.noOfHours != null) {
		            	//agefield = ageDataWrapperObj.noOfDays + ' Days' + ' ' + ageDataWrapperObj.noOfHours + ' Hours';
		            	agefield = String.valueOf(ageDataWrapperObj.noOfDays);  
		            }            
		        } catch(Exception e) {
		            System.debug('Exception occurred in calculateCaseAge(String caseId) method in CaseAgeController class -> '+e);
		        }
        		String caseAge = agefield;
        		
        		System.debug('SEND CASE INFO: ' + accountId + '|||' + caseId + '|||' + receivedDate + '|||' + subject + '|||' + contactName + '|||' + originatorType + '|||' + issueType + '|||' + closedDate + '|||' + caseAge);
        		//SEND CASE INFO: |||00208081|||2020-04-15|||Ingersoll Auto Group Inc.|||Chris Alexander|||Group Contact||||||2020-04-15|||7
        		ETSBE_GetSolarisWebservice getSolaris = new ETSBE_GetSolarisWebservice();
            	getSolaris.sendClosedCase(accountId,caseId,receivedDate,subject,contactName,originatorType,issueType,closedDate,caseAge);
        		//ACETWSCalloutResult calloutResult = getSolaris.findGroupContact('1058476');
        		System.debug('SEND CASE INFO 2');
        		/*
        		RequestBody = '{"request":{'
	        	+ '"accountId":"",'
	        	+ '"caseId":"' + caseId + '",'
	        	+ '"receivedDate":"' + receivedDate + '",'
	        	+ '"subject":"' + subject + '",'
	        	+ '"contactName":"' + contactName + '",'
	        	+ '"originatorType":"' + originatorType + '",'
	        	+ '"issueType":"' + issueType + '",'
	        	+ '"closedDate":"' + closedDate + '",'
	        	+ '"age":"' + caseAge + '"'
	        	+ '}}';*/
        	}
        	
            
        }
    
    }
}