public without sharing class ETSBE_EscalatController {

  @AuraEnabled 
    public static void updateInteractrec(string caseid, String strWrapper, String EscalationDesc,String selectedUser){
        system.debug('-----caseid----------'+caseid);      
      Case cas = [select id,IsEscalated,Escalated_To__c,PC_Escalation_Reason__c,Interaction__c from case where id=:caseid];
      if(String.isNotBlank(string.valueOf(cas.Interaction__c))){
          Interaction__c intract =[select id,Escalated__c,Escalated_To__c,Escalation_Reason__c,Escalated_Date_Time__c from Interaction__c where id=:cas.Interaction__c];
          intract.Escalated__c = cas.IsEscalated;
          if(String.isBlank(string.valueOf(intract.Escalated_Date_Time__c))){
          intract.Escalated_Date_Time__c = system.now();
          }
            update intract; 
            sendEscalationEmailToSupervisor(strWrapper, caseid, true, EscalationDesc, selectedUser );
      }
  }
  
  @AuraEnabled 
    public static void updateCaserec(string intractid, String strWrapper,string EscalationDesc,String selectedUser){        
        system.debug('-----Intractid----------'+Intractid);
      try {          
          
          Interaction__c intract = [select id,Escalated__c,Escalated_Date_Time__c,Escalated_To__c,Escalation_Reason__c from Interaction__c where id=:Intractid];
          List<Case> cases = [select id,IsEscalated,Escalated_To__c,PC_Escalation_Reason__c,Interaction__c from case where Interaction__c=:intractid];
          if(cases !=null && cases.size()>0){
              List<case> lstcases = new List<case>();
              for(case casrec: cases){
                  casrec.IsEscalated= true;
                  casrec.PC_Escalation_Reason__c =intract.Escalation_Reason__c;
                  lstcases.add(casrec);
              }
                update lstcases;
                sendEscalationEmailToSupervisor(strWrapper, intractid, false,EscalationDesc,selectedUser);
          }
      } catch(Exception e) {
          System.debug('Exception occurred in the updateCaserec - '+e);    
      }      
  } 
    
  @AuraEnabled 
  public static CaseInteractionWrapperData checkCaseEsc(string intractid) {
      
      CaseInteractionWrapperData interactionWrapperData = new CaseInteractionWrapperData();
      boolean iscaseesc = false;
      
      List<Case> cases = [select id,IsEscalated,Escalated_To__c,PC_Escalation_Reason__c,Interaction__c from case where Interaction__c=:intractid];
      
      for(case casrec:cases){
          if(casrec.IsEscalated==true && String.isNotBlank(string.valueOf(casrec.Escalated_To__c))){
              iscaseesc = true;
              break;
          }
      }
      
      Interaction__c intreractObj = [Select Owner.Name from Interaction__c where Id =: intractid];
      if(intreractObj != null) {
          interactionWrapperData.interactOwner = (intreractObj.Owner.Name != null) ? intreractObj.Owner.Name : '';
          interactionWrapperData.isCaseEsc = iscaseesc;
      }
      
      return interactionWrapperData;
  }
    
  @AuraEnabled 
  public static CaseInteractionWrapperData checkIntEsc(string caseid) {
      
      CaseInteractionWrapperData caseWrapperData = new CaseInteractionWrapperData();
      boolean isintesc =false;
      Case cas = [select id,IsEscalated,Escalated_To__c,PC_Escalation_Reason__c,Interaction__c,Owner.Name,Department__c,Special_Instructions_Reference_ID__c,Member_SSN__c,Subject_Type__c,Subject_Name__c,RecordTypeId from case where id=:caseid];
      
      if(cas != null) {
          
          if(String.isNotBlank(string.valueOf(cas.Interaction__c))){
              Interaction__c intract =[select id,Escalated__c,Escalated_To__c,Escalation_Reason__c,Escalated_Date_Time__c from Interaction__c where id=:cas.Interaction__c];
              if(intract!=null && intract.Escalated__c== true && String.isNotBlank(string.valueOf(intract.Escalated_To__c))){
                  isintesc=true;
              }
          }
          
          caseWrapperData.isIntEsc = isintesc;
          caseWrapperData.caseOwner = (cas.Owner.Name != null) ? cas.Owner.Name : '';
          caseWrapperData.department = (cas.Department__c != null) ? cas.Department__c : '';
          caseWrapperData.referenceId = (cas.Special_Instructions_Reference_ID__c != null) ? cas.Special_Instructions_Reference_ID__c : '';
          caseWrapperData.memberSSN = '';
	  caseWrapperData.CaseRecType = cas.RecordTypeId;	
          String memberName = '';
          if(cas.Subject_Type__c != null && cas.Subject_Name__c != null && cas.Subject_Type__c == 'Member') {
             memberName = cas.Subject_Name__c;
          }
          caseWrapperData.memberName = memberName;          
	  }
      return caseWrapperData;
  }
    
  @AuraEnabled 
  public static user getUser(){
     // query current user information  
      User currntUser = [select id,Name,Agent_Type__c,Profile_Name__c,Role_Name__c FROM User Where id =: userInfo.getUserId()];
        return currntUser;
    }
    
  @AuraEnabled
  public static String getQueueFromCase(Id caseId) {
		String queueInfo = '';
		Case foundCase = new Case();
		if(caseID!=null) {
			//need to add case number, topic, originator name, subject name, maybe more???
			List<Case> cases = [ SELECT Id, OwnerId, CaseNumber, Topic__c, Originator_name__c, Subject_Name__c, Queue_Id__c from CASE where ID = :caseId ];
			if(cases.size() > 0) {
				foundCase = cases[0];
				system.debug('QUEUE CHECK1: ' + foundCase.Queue_Id__c);
				if(foundCase.Queue_Id__c != null && foundCase.Queue_Id__c != ''){
					system.debug('QUEUE CHECK2: ' + foundCase.Queue_Id__c);
					List<Group> queueList = [SELECT Id,Name FROM Group WHERE Type='Queue' AND Id =: foundCase.Queue_Id__c];
					system.debug('QUEUE CHECK3: ' + queueList);
					if (queueList != null && queueList.size() > 0) {
						//caseObj.OwnerId = queueList[0].Id;
						queueInfo = foundCase.Queue_Id__c  + '|||||' + queueList[0].Name;
						system.debug('QUEUE CHECK4: ' + queueInfo);
					} else {
						queueInfo = foundCase.OwnerId;
						system.debug('QUEUE CHECK5: ' + queueInfo);
					}
				}
			}
		}
		return queueInfo;

	}
    
    
    public static void sendEscalationEmailToSupervisor(String strWrapperData, String Id, Boolean isCase, string EscalationDesc,String selectedUser) {
              /*Logic to Select Multiple Users:US2715331*/
        List<String> usridsList =  new List<String>();
        List<User> usrLst=new List<User>();
        List<String>emailStrLst=new List<String>();
       
        if(selectedUser!=null){
            Map<String, Object> mapval = (Map<String, Object>) JSON.deserializeUntyped(selectedUser);
            for(Object obj : mapval.values()){   
                Map<string,object> recFetchMap =  (Map<string,object>)obj;
                usridsList.add((String)recFetchMap.get('value'));
            }
        }   
      try {
            /*Fetch user emails based on userid*/
            if(usridsList.size()!=null && usridsList.size()>0){
                usrLst=[select id,Email from User where id=:usridsList];
                if(usrLst.size()>0){
                    for(User usrEmail:usrLst){
                        emailStrLst.add(usrEmail.Email);
                    }
                }               
            }
                        
          
          Case caseObj = new Case();
          Interaction__c intactObj  = new Interaction__c();
          String toAddrsEmailNotis = '';
          
          
          if(isCase) {
              caseObj = [Select ID__c, Subject_Name__c, Escalated_To__r.Email, PC_Escalation_Reason__c,Subject_Type__c,Line_of_Business__c from Case where Id =: Id];    
          } else {
              intactObj = [Select Escalation_Reason__c, Escalated_To__r.Email from Interaction__c where Id =: Id];
          }
                 
          SAETTSCaseWrapper caseWrapperData = (SAETTSCaseWrapper)JSON.deserialize(strWrapperData, SAETTSCaseWrapper.class);
          
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();          
          if(isCase) {
          	toAddrsEmailNotis = caseObj.Escalated_To__r.Email;    
          } else {
            toAddrsEmailNotis = intactObj.Escalated_To__r.Email;
          }         
          String[] toAddresses = new String[]{toAddrsEmailNotis};
            mail.setToAddresses(toAddresses); 
            mail.setCcAddresses(emailStrLst);
          if(isCase) {
              if(caseObj.Subject_Type__c != null && caseObj.Subject_Type__c == 'Group/Employer') {
				mail.setSubject('***ACET ETS_BE Escalate*** -Action Required - '+caseObj.Line_of_Business__c+' '+caseObj.Subject_Name__c+' '+caseObj.ID__c); 
              } else {
              	mail.setSubject('***ACET ETS_BE Escalate*** -Action Required - '+caseObj.Subject_Name__c+' '+caseObj.ID__c);                 
              }              
          } else {
              mail.setSubject('***ACET ETS_BE Escalate***');
          }
                    
          //String emailBody = 'Dear Team,<br/><br/>';
          Document docObj = [Select Id,Name from Document where Name='Chromium Edge Logo' LIMIT 1];
		  String docId = docObj.Id;
          String orgId =  UserInfo.getOrganizationId();
		  String emailBody = 'The following issue has been escalated. Please copy and paste the below link in the Chromium Edge browser &nbsp;<img src="'+System.Url.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.ImageServer?id='+docId+'&oid='+orgId+'" height="4%" width="4%"></img>&nbsp; for more information.<br/><br/>';
          
		  String url = System.Url.getSalesforceBaseUrl().toExternalForm()+'/'+Id;          
          emailBody += 'Issue Link: <a href="'+url+'">'+url+'</a>';
          
          emailBody += '<br/><br/>Details for Escalation:<br/><br/>';
          emailBody += '<b>Who currently owns issue?</b> ';
          emailBody += caseWrapperData.WhoOwnsIssue+'<br/>';
          emailBody += '<b>Where was the issue routed?</b> ';
          emailBody += caseWrapperData.WhereWasIssueRouted+'<br/>';
          emailBody += '<b>Is there a specific rep working this issue?</b> ';
          emailBody += caseWrapperData.IsSpecRepWorking+'<br/>';
          emailBody += '<b>Request Number:</b> ';
          emailBody += caseWrapperData.RequestNumber+'<br/>';
          emailBody += '<b>Reason for Escalation:</b> ';
          if(isCase) {
          	emailBody += caseObj.PC_Escalation_Reason__c+'<br/>';    
          } else {
			emailBody += intactObj.Escalation_Reason__c+'<br/>';
          }          
          emailBody += '<b>Member Information:</b> ';
          emailBody += caseWrapperData.MemberInfo+'<br/>';
          emailBody += '<b>Escalation Description:</b> ';
          emailBody += EscalationDesc+'<br/>';
          
          emailBody += '<br/><br/>Thanks !!!';
          
          mail.setHtmlBody(emailBody);
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
          System.debug('Mail sent successfully');
          
      } catch(Exception e) {
          
          System.debug('Excpetion occurred in the sendEscalationEmailToSupervisor method in ETSBE_EscalatController Apex Class -> '+e);
      }      
      
      System.debug('sendEscalationEmailToSupervisor in the ETSBE_EscalatController Apex Class - END');
      
  }
    
    public class CaseInteractionWrapperData {
        
        // Case Fields
        @AuraEnabled public String caseOwner {get;set;}
        @AuraEnabled public String department {get;set;}
        @AuraEnabled public String referenceId {get;set;}
        @AuraEnabled public String memberName {get;set;}
        @AuraEnabled public String memberSSN {get;set;}
        @AuraEnabled public Boolean isIntEsc {get;set;}
        @AuraEnabled public String CaseRecType {get;set;}
        
        //Interaction fields
        @AuraEnabled public String interactOwner {get;set;}
        @AuraEnabled public Boolean isCaseEsc {get;set;}

    }
    
    /*Multiselect user apex logic:US2715331***/
    
    @AuraEnabled
    public static List<RecordsData> fetchRecords(String objectName, String filterField, String searchString, String values) {
        try {
            List<RecordsData> recordsDataList = new List<RecordsData>();
            system.debug('values@@' +values);
            List<String> selectedvalues = (List<String>) JSON.deserialize(values, List<String>.class);
            system.debug('selectedvalues@' +selectedvalues);
			List<Profile> excludeProfiles=[Select id,Name from Profile where Name ='Family Link Provider User' OR Name='FamilyLink Community User'];

            String query;
            if(objectName=='User'){
                query = 'SELECT Id, ' + filterField + ' FROM '+objectName+  ' WHERE Profile.Id NOT IN : excludeProfiles AND ';
            }else{
                query = 'SELECT Id, ' + filterField + ' FROM '+objectName;
            }
			 if(selectedvalues != null && selectedvalues.size() > 0) {
                query += 'Id IN: selectedvalues LIMIT 49999';
            } else {
                query +=  +filterField+
                    ' LIKE ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '%\' LIMIT 49999';
            }
			
			
            for(SObject s : Database.query(query)) {
                recordsDataList.add( new RecordsData((String)s.get(filterField), (String)s.get('id')) );
            }
            return recordsDataList;
        } catch (Exception err) {
            if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
                throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
            } else {
                throw new AuraHandledException(err.getMessage());
            }
        }
    }
    
    public class RecordsData {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        @AuraEnabled public Boolean isSelected;
        public RecordsData(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
    
    
}