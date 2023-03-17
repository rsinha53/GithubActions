public with sharing class MOTION_MemberSearchController {
    public class MemberSearchPickLists {
        @AuraEnabled public List<InteractionType> lstInteractionTypes{get;set;}
        @AuraEnabled public List<Status> lstStatusValues{get;set;}
    }
    @AuraEnabled
    public static MemberSearchPickLists memberSearchPickListValues(){
        MemberSearchPickLists mbrSearchLovs = new MemberSearchPickLists();
        mbrSearchLovs.lstInteractionTypes = getInteractionTypes();
        mbrSearchLovs.lstStatusValues = getStatusValues();       
        return mbrSearchLovs;
    }    
     public class Status implements Comparable{
        @AuraEnabled public String label{get;set;}
        @AuraEnabled public String value{get;set;}
 
        public Status(String sLabel, String sValue){
            label = sLabel;
            value = sValue;
        }
        public Integer compareTo(Object objToCompare){
            return label.CompareTo(((Status)objToCompare).label);
        }
    }
    public class InteractionType implements Comparable{
        @AuraEnabled public String label{get;set;}
        @AuraEnabled public String value{get;set;}
 
        public InteractionType(String sLabel, String sValue){
            label = sLabel;
            value = sValue;
        }
        public Integer compareTo(Object objToCompare){
            return label.CompareTo(((InteractionType)objToCompare).label);
        }
    }   
    public static List<InteractionType> getInteractionTypes(){
        List<InteractionType> lstInteractionType = new List<InteractionType>();
        //Metadata
        InteractionType intracType;
        for(MotionDefaultPicklistValues__mdt mt: [Select Id, MasterLabel,DeveloperName,Picklist_Name__c from MotionDefaultPicklistValues__mdt WHERE Picklist_Name__c = 'interaction_type'])
        {
            intracType = new InteractionType(mt.MasterLabel, mt.DeveloperName);                     
            lstInteractionType.add(intracType);
        }
        if(lstInteractionType!=null && !lstInteractionType.isEmpty()){
            lstInteractionType.sort();
        }             
        return lstInteractionType;
    }
    
    public static List<Status> getStatusValues(){
        List<Status> lstStatus = new List<Status>();
        //Metadata
        Status objStatus;        
        for(MotionDefaultPicklistValues__mdt mt: [Select Id, MasterLabel,DeveloperName,Picklist_Name__c from MotionDefaultPicklistValues__mdt WHERE Picklist_Name__c = 'status'])
        {
            objStatus = new Status(mt.MasterLabel, mt.DeveloperName);                
            if(objStatus.value !='All'){
            	lstStatus.add(objStatus);            
            }
        }        
        if(lstStatus!=null && !lstStatus.isEmpty()){
            lstStatus.sort();            
            lstStatus.add(new Status('All','All'));
            
        }    
        return lstStatus;    
    }
// Retrive Cases for Casehistory Component Motion
    @AuraEnabled
    public static ACET_AutoDocUtil.TableDetails getCases(Integer pageNumber , Integer pageSize, string eligibleMemberId, string registeredMemberId, Boolean isCheckboxDisabled){
            
        Integer offset = (pageNumber - 1) * pageSize;
        Integer recordEnd = pageSize * pageNumber;
        
        string eligibleID = '';
        string registeredId = '';
        if(eligibleMemberId!=NULL && eligibleMemberId != ''){
            eligibleID = eligibleMemberId;
        }
        else{
            eligibleID = 'NULL';
        }
        if(registeredMemberId!=NULL && registeredMemberId != ''){
            registeredId = registeredMemberId;
        }
        else{
            registeredId = 'NULL';
        }
        dateTime twoYearsBack = system.today()- 2 * 365;
        ACET_AutoDocUtil.TableDetails 	TableDetails = new ACET_AutoDocUtil.TableDetails();       
        ACET_AutoDocUtil.TableRow 		TableRow = New ACET_AutoDocUtil.TableRow();
        
        TableDetails.tableBody = New List< ACET_AutoDocUtil.TableRow >();
        TableRow.rowColumnData = new List< ACET_AutoDocUtil.RowColumnData >();
        
        List< ACET_AutoDocUtil.RowColumnData > dataList = new List< ACET_AutoDocUtil.RowColumnData >();
        
        Integer totalRelatedcases = [SELECT COUNT() FROM case 
                                     WHERE (Motion_Registered_Member_ID_Text__c =: registeredId OR Motion_Eligible_Member_ID_Text__c =: eligibleID) 
                                     AND
                                     (CreatedDate >: twoYearsBack)];     
        
        List<case> caseList 	= [SELECT Id, CaseNumber, Origin, Status, Case_Owner__c, OwnerId, CreatedDate, ClosedDate, Type__c, Subtype__c   
                                   FROM case 
                                   WHERE (Motion_Registered_Member_ID_Text__c =: registeredId OR Motion_Eligible_Member_ID_Text__c =: eligibleID) 
                                   AND
                                   (CreatedDate >: twoYearsBack)
                                   ORDER BY CreatedDate DESC
                                   LIMIT :pageSize OFFSET :offset];
                    
        List<ACET_AutoDocUtil.TableRow> tableRows = new List<ACET_AutoDocUtil.TableRow>();
        
        
        if(caseList!=NULL){
		List<Id> queueIds = new List<Id>();
            for(Case c : caseList)
            {
                if(c.OwnerId.getsobjecttype() == Group.SobjectType)
                {
                    queueIds.add(c.OwnerId);
                }
            }
            Map<Id, Group> queueIdName;
            if(queueIds != NULL && !queueIds.IsEmpty())
            {
                queueIdName = new Map<Id, Group> ([Select Id, Name FROM GROUP Where Type='Queue' AND DeveloperNAME Like '%Motion%' AND Id IN :queueIds]);
            }
            for(Integer i=0; i<caseList.size(); i++){
                
                ACET_AutoDocUtil.TableRow oneTableRow = new ACET_AutoDocUtil.TableRow();
                if(isCheckboxDisabled)
                	oneTableRow.checkBoxDisabled = true;
                else
                    oneTableRow.checkBoxDisabled = false;
                
                List< ACET_AutoDocUtil.RowColumnData> rowData = new List< ACET_AutoDocUtil.RowColumnData>();
                //////////////////////////////////////
                // Harkunal:06/04/2021:US3596560:Start
                // Adding a boolean attribute value to "true" as the last attribute to the rowData of the table to enable the fields for auto doc reporting. 
                /////////////////////////////////////
                
                //rowData.add(ACET_AutoDocUtil.setRowColumnData('link', caseList[i].caseNumber));
                //rowData.add(ACET_AutoDocUtil.setRowColumnData('outputText', caseList[i].Origin));
		//		if(caseList[i].Status == 'Motion_Follow_Up'){
                //    rowData.add(ACET_AutoDocUtil.setRowColumnData('outputText', 'Follow-Up'));
                //}else{
                //	rowData.add(ACET_AutoDocUtil.setRowColumnData('outputText', caseList[i].Status));    
                //}
                //string queuePrefix = Group.SObjectType.getDescribe().getKeyPrefix();
                //string Owner = caseList[i].OwnerId;
                //if(Owner.startsWith(queuePrefix) && !queueIdName.isEmpty() ){
                //    group grp = [Select Id, name FROM GROUP Where Type='Queue' AND DeveloperNAME Like '%Motion%' AND Id=:Owner Limit 1];
                //    rowData.add(ACET_AutoDocUtil.setRowColumnData('outputText', queueIdName.get(caseList[i].OwnerId).Name));
                //}else{ 
                //    rowData.add(ACET_AutoDocUtil.setRowColumnData('outputText', caseList[i].Case_Owner__c));    
                //}
                //String CreatedDate = '';
                //if(caseList[i].CreatedDate!=NULL){
                //    CreatedDate = caseList[i].CreatedDate.format('MM/dd/yyyy');    
                //}
                //rowData.add(ACET_AutoDocUtil.setRowColumnData('outputText', CreatedDate));
                //String ClosedDate = '';
                //if(caseList[i].ClosedDate!=NULL){
                //    ClosedDate = caseList[i].ClosedDate.format('MM/dd/yyyy');
                //}
                //rowData.add(ACET_AutoDocUtil.setRowColumnData('outputText', ClosedDate));
                //rowData.add(ACET_AutoDocUtil.setRowColumnData('outputText', caseList[i].Type__c));
                //rowData.add(ACET_AutoDocUtil.setRowColumnData('outputText', caseList[i].Subtype__c));
                rowData.add(ACET_AutoDocUtil.setRowColumnData('link', caseList[i].caseNumber,true));
                rowData.add(ACET_AutoDocUtil.setRowColumnData('outputText', caseList[i].Origin,true));
				if(caseList[i].Status == 'Motion_Follow_Up'){
                    rowData.add(ACET_AutoDocUtil.setRowColumnData('outputText', 'Follow-Up',true));
                }else{
                	rowData.add(ACET_AutoDocUtil.setRowColumnData('outputText', caseList[i].Status,true));    
                }
                string queuePrefix = Group.SObjectType.getDescribe().getKeyPrefix();
                string Owner = caseList[i].OwnerId;
                if(Owner.startsWith(queuePrefix) && !queueIdName.isEmpty() ){
                    group grp = [Select Id, name FROM GROUP Where Type='Queue' AND DeveloperNAME Like '%Motion%' AND Id=:Owner Limit 1];
                    rowData.add(ACET_AutoDocUtil.setRowColumnData('outputText', queueIdName.get(caseList[i].OwnerId).Name,true));
                }else{ 
                    rowData.add(ACET_AutoDocUtil.setRowColumnData('outputText', caseList[i].Case_Owner__c,true));    
                }
                String CreatedDate = '';
                if(caseList[i].CreatedDate!=NULL){
                    CreatedDate = caseList[i].CreatedDate.format('MM/dd/yyyy');    
                }
                rowData.add(ACET_AutoDocUtil.setRowColumnData('outputText', CreatedDate,true));
                String ClosedDate = '';
                if(caseList[i].ClosedDate!=NULL){
                    ClosedDate = caseList[i].ClosedDate.format('MM/dd/yyyy');
                }
                rowData.add(ACET_AutoDocUtil.setRowColumnData('outputText', ClosedDate,true));
                rowData.add(ACET_AutoDocUtil.setRowColumnData('outputText', caseList[i].Type__c,true));
                rowData.add(ACET_AutoDocUtil.setRowColumnData('outputText', caseList[i].Subtype__c,true));
                 
                ////////////////////////////////////
                //Harkunal:06/04/2021:US3596560:End
                ///////////////////////////////////
                                
                oneTableRow.rowColumnData = rowData;
                oneTableRow.uniqueKey = caseList[i].Id;
				oneTableRow.linkDisabled = false;
                tableRows.add(oneTableRow);  
            }
            TableDetails.tableBody = tableRows;
        }
                
        TableDetails.type = 'table';
        TableDetails.showCardStyle = false;
        TableDetails.showComponentName = false;  
 		TableDetails.autodocHeaderName    ='Case History';
        TableDetails.componentName='Case History';               //Harkunal:06/04/2021:US3596560:Added
        TableDetails.tableHeaders = new List<String>{
            	'Case ID',
                'Origin',
                'Status',
                'Case Owner',
                'Create Date',
                'Closed Date',
                'Topic Type',
                'Subtype'
                };
                    
                    
				if(totalRelatedcases < 5){
            TableDetails.endNumber = totalRelatedcases;
        }else{
            TableDetails.endNumber = (pageSize * pageNumber)>totalRelatedcases ? totalRelatedcases : (pageSize * pageNumber);
        }
        
        if(totalRelatedcases==0){	
			TableDetails.startNumber = 0;
         }else if((pageSize * pageNumber)-5 == 0){
            TableDetails.startNumber = 1;
         }else if(((pageSize * pageNumber)- 4)>TableDetails.endNumber){
            TableDetails.startNumber = TableDetails.endNumber;
         }else{
            TableDetails.startNumber = (pageSize * pageNumber) - 4;
        }
		
        TableDetails.recordCount 	= totalRelatedcases;
		
        Integer wholeNumCheck = math.mod(totalRelatedcases, 5);
        if(wholeNumCheck==0){
            TableDetails.noOfPages 		= totalRelatedcases/5 != 0 ? (totalRelatedcases/5) : 1;
        }
        else{
            TableDetails.noOfPages 		= totalRelatedcases/5 != 0 ? (totalRelatedcases/5)+1 : 1;    
        }									   
                
        return TableDetails;
    }
    //Case History component Motion END
    //Web Email case member Search Start
    @AuraEnabled
    public static Interaction__c searchAndCreateMotionPersonAccount(String dermID, String memberEligibleId, String firstName, String lastName, String memberEmail, String memberDob, String interactType, string phoneNo ){
		return Motion_MemberInformationController.searchAndCreateMotionPersonAccount(dermID, memberEligibleId, firstName, lastName, memberEmail, memberDob, interactType, phoneNo);

    }
    @AuraEnabled
    public static Motion_MemberInformationController.SnapshotDataData getThirdparty(String firstName, String lastName, string emailaddress, string phone, String groupname, string groupnumber, string dob, String state, string zip, string inttype){
        return Motion_MemberInformationController.getThirdparty(firstName, lastName, emailaddress, phone, groupname, groupnumber, dob, state, zip, inttype);
    }
	@AuraEnabled
    public static List<String> getcaseTypes (String topic){
        return ACETLGT_CaseActionsController.getTTSFilterMapKeyStr(topic);
    }
    
    @AuraEnabled
    public static List<String> getCaseSubTypes(string topic, string subtype){
        return ACETLGT_CaseActionsController.getTTSFilterMapValueStr(topic, subtype);
    }
    
    @AuraEnabled
    public static id getTaskRecordTypeId(string tType){
        
        recordType  motionTaskRecId = [select id FROM recordType Where developerName =:tType];
        return motionTaskRecId.Id;
    }
    
    @AuraEnabled
    public static void updatedCase(boolean FlowAddIndiv, string perAccId, string phone, string originator, string tpId, string tpRelation, string excFlow, String interactionId, String caseId, String topic, String caseType, String subtype, Boolean migIssueChecked, Boolean escalatedChecked,Boolean complaintChecked, String disasterEpidemicValue, String fullName, String SubjectType, String DOB, String email, String RegisterMemberId, String EligibleMemberId, String GroupName, String GroupId){
	string formatedDOB = '';
        if(DOB != '' && DOB != NULL){
        	formatedDOB = MotionCommonUtil.Dateconversion(DOB);    
        }
        case caseToUpdate = [SELECT Id, ContactId, Original_Type__c, Original_Subtype__c FROM Case Where Id=:caseId];
        
        Interaction__c caseIntRec = new Interaction__c();
        if(!String.isBlank(interactionId)){
            caseIntRec = [SELECT Id, Third_Party__c, Originator__c, Originator_Type__c FROM Interaction__c WHERE Id=:interactionId];
			caseToUpdate.Interaction__c = interactionId;
        }	  
        
        if(excFlow=='tpSelected'){
            try{                                    //Harkunal:06/14/2021:TA1074512:Added
                Third_Party__c TP = [Select Id, FullName__c, First_Name__c, LastName__c, Phone_Number__c, Email__c, DOB__c,Group_Name__c, Group_Number__c, Other_Originator__c from Third_Party__c where Id=:caseIntRec.Third_Party__c Limit 1];    
                caseToUpdate.Originator_name__c 		= (TP.First_Name__c != Null && TP.LastName__c != Null) ? TP.First_Name__c+' '+TP.LastName__c : '';
                caseToUpdate.Originator_Relationship__c = (TP.Other_Originator__c!=Null) ? TP.Other_Originator__c:'';
                caseToUpdate.OriginatorPhone__c 		= (TP.Phone_Number__c!=Null) ? TP.Phone_Number__c : '';
                caseToUpdate.OriginatorEmail__c 		= (TP.Email__c!=Null) ? TP.Email__c : '';
                caseToUpdate.ContactId 	= NULL;
                                                                                                                                                            
                caseToUpdate.Subject_Type__c 			= 'Member';
                if(FlowAddIndiv == true){
                    caseToUpdate.Subject_Name__c			= (TP.First_Name__c != Null && TP.LastName__c != Null) ? TP.First_Name__c+' '+TP.LastName__c : '';
                    if(TP.DOB__c!=Null){
                        string dateOfBirth 						= TP.DOB__c.format();
                        caseToUpdate.DOB__c 					= dateOfBirth;    
                    }
                    else{
                        caseToUpdate.DOB__c='';
                    }	 
                    caseToUpdate.Group_Name__c				= (TP.Group_Name__c!=Null) ? TP.Group_Name__c : '';
                    caseToUpdate.Subject_Group_ID__c		= (TP.Group_Number__c!=Null) ? TP.Group_Number__c : '';    
                }else{
                    caseToUpdate.Subject_Name__c			= (fullName!=Null) ? fullName : '';
                    caseToUpdate.DOB__c 					= formatedDOB;
                    caseToUpdate.Group_Name__c				= GroupName;
                    caseToUpdate.Subject_Group_ID__c		= GroupId;    
                }
                caseToUpdate.Motion_Registered_Member_ID_Text__c = RegisterMemberId;  
                caseToUpdate.Motion_Eligible_Member_ID_Text__c = EligibleMemberId;
            /////////////////////////////////////
            //Harkunal:06/14/2021:TA1074512:Start
            //Added try-catch for System.Query exception identifies during a working session with agent.
            /////////////////////////////////////            
            }
                catch (Exception e){      // To handle query exception
                    system.debug('Exception'+ e.getMessage());
            }
            ///////////////////////////////////
            //Harkunal:06/14/2021:TA1074512:End
            ///////////////////////////////////
          }
        else if(excFlow=='memberOrigin'){
			Account personContact = [SELECT id, PersonContactId,Name FROM Account where id=:perAccId];
            caseToUpdate.ContactId 					= personContact.PersonContactId;
              caseToUpdate.Originator_Relationship__c = '';
              caseToUpdate.OriginatorPhone__c = phone;		  
            caseToUpdate.Originator_name__c 		= fullName;
            caseToUpdate.OriginatorEmail__c 		= email;
            caseToUpdate.Subject_Name__c 			= fullName;			 
            caseToUpdate.Subject_Type__c 			= SubjectType;
            caseToUpdate.DOB__c			 			= formatedDOB;
            caseToUpdate.Motion_Registered_Member_ID_Text__c = RegisterMemberId;  
			caseToUpdate.Motion_Eligible_Member_ID_Text__c = EligibleMemberId;
            caseToUpdate.Group_Name__c 				= GroupName;
            caseToUpdate.Subject_Group_ID__c 		= GroupId;
       }
        
        if(!String.isBlank(topic)){
            caseToUpdate.Topic__c 						= topic;
        }
        if(!String.isBlank(caseType)){
            caseToUpdate.Type__c 						= caseType;
            caseToUpdate.Original_Type__c				= (caseToUpdate.Original_Type__c == NULL || caseToUpdate.Original_Type__c =='') ? caseType : caseToUpdate.Original_Type__c;
        }
        if(!String.isBlank(subtype)){
            caseToUpdate.Subtype__c 					= subtype;
            caseToUpdate.Original_Subtype__c			= (caseToUpdate.Original_Subtype__c ==NULL || caseToUpdate.Original_Subtype__c == '') ? subtype : caseToUpdate.Original_Subtype__c;
        }
        caseToUpdate.Migration_Issue__c 				= migIssueChecked;
        caseToUpdate.IsEscalated 						= escalatedChecked;
        caseToUpdate.Complaint__c 						= complaintChecked;
        caseToUpdate.National_Disaster_Epidemic__c 		= disasterEpidemicValue;
        
        update caseToUpdate;		   
		   							   
    }
    //Web Email case member Search End
    
    @AuraEnabled 
    public static Motion_MemberSearchUtil.TableDetails getBasicSearchResults(String intType, String firstName, String lastName, String dob, String reqPageNumber){
        Motion_MemberSearchUtil.TableDetails objTableDetail;
        try{
        HttpResponse response = MOTION_MemberAPIServiceController.basicSearchMemberService(intType, firstName, lastName, dob, reqPageNumber);            
            if(response.getStatusCode()==200){                               
                MotionMemberwrapper memberDetailResult= MotionMemberwrapper.parse(response.getBody());                
                if(memberDetailResult.memberRecord != null && memberDetailResult.memberRecord.size()>0)
                    objTableDetail=Motion_MemberSearchResults.setCredentialData(memberDetailResult);
            }
       }catch(Exception ex){
            if(ex.getMessage() == 'Read timed out'){
                ex.setMessage('We hit a snag. Unexpected Error Occurred with Member Results. Please try again. If problem persists please contact the help desk.');
            }
            system.debug('Exception-->'+ex.getMessage());
        	// throw new custException(ex.getMessage()); 
            throw new AuraHandledException(ex.getMessage());
        }
        return objTableDetail;
    }

    @AuraEnabled
    public static Motion_MemberSearchUtil.TableDetails getAdvanceSearchResults(String intType, String firstName, String lastName, String dob, String email, String memberId, String groupName, String status, String transactionId, String reqPageNumber){
       Motion_MemberSearchUtil.TableDetails objTableDetail;
       try{
         HttpResponse response = MOTION_MemberAPIServiceController.advanceSearchMemberService(intType, firstName, lastName, dob,email,memberId,groupName,status,transactionId, reqPageNumber);
            if(response.getStatusCode()==200){
                system.debug('responsegetBody'+objTableDetail);            
                MotionMemberwrapper memberDetailResult= MotionMemberwrapper.parse(response.getBody());            
                if(memberDetailResult.memberRecord != null && memberDetailResult.memberRecord.size()>0){
                    objTableDetail=Motion_MemberSearchResults.setCredentialData(memberDetailResult);
                }
            }
        }catch(Exception ex){
            if(ex.getMessage() == 'Read timed out'){
                ex.setMessage('We hit a snag. Unexpected Error Occurred with Member Results. Please try again. If problem persists please contact the help desk.');
            }
            system.debug('Exception-->'+ex.getMessage());
        	// throw new custException(ex.getMessage()); 
            throw new AuraHandledException(ex.getMessage());
        }
        return objTableDetail;
        
    }

    public class custException extends Exception {}    

}