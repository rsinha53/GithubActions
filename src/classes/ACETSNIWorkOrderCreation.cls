/**
* Author: Chandan
* Description: This class is created to create/update WO coming from ITE services
* Date Modified: 3rd Dec 2020
*/
public without sharing class ACETSNIWorkOrderCreation {
    
    //This would be landing method to create/update WO
    //All the data from webservice would be passed to this method
    public static ACETSNIICUEDataService.ResponseWrapper checkExistingWO(ACETSNIICUEDataParser wrap){
        Id priorAuthRecordType = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Prior Authorization').getRecordTypeId();           
        Id priorAuthCancelRecordType = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Prior Authorization Canceled').getRecordTypeId();           
        Id priorAuthRecordHoldRecordType = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Prior Authorization On Hold').getRecordTypeId();           
        Set<Id> priorAuthRecordTypeSet=new set<Id>{priorAuthRecordType,priorAuthCancelRecordType,priorAuthRecordHoldRecordType};
        List<WorkOrder> woList= [SELECT Id,WorkOrderNumber,AccountId,Add_Member__c,Policy_ID__c,Member_ID__c,Date_of_Birth__c,First_Name__c,
                                 Last_Name__c,Prior_Auth_Owner__c,Service_Reference__c,HSC_Unique_ID__c,Xref_ID__c,
                                 Status_Detail__c,Priority,Service_Setting__c,Service_Start_Date__c,
                                 Service_End_Date__c,Host_System_Date_and_Time__c,Expected_Admission_Date__c,
                                 Expected_Discharge_Date__c,Actual_Admission_Date__c,Actual_Discharge_Date__c,
                                 RecordTypeId,Servicing_Provider_Name_Status__c,Diagnosis_code__c, (SELECT Id, Decision_Outcome__c,Reason__c,
                                                              Decision_Subtype__c,Procedure_Code__c,Procedure_Description__c,Work_Order__c,
                                                              serviceLinkUniqueId__c
                                                              from Service_Lines__r)/*, (SELECT Id,Name,Network_Status__c,Role__c,Work_Order__c
                                                                                       from ProvidersWO__r),(SELECT Id,Diagnosis_Code__c,Work_Order__c,Primary_Diagnosis__c
                                                                                                             from Diagnosis_CodesWO__r)*/
                                 FROM WorkOrder where Service_Reference__c =:wrap.serviceRef and RecordTypeId in :priorAuthRecordTypeSet];//wo.recordtype ?
        if(woList!=null && woList.size()>0)
            return updateWorkOrder(woList.get(0),wrap);
        else
            return existingMemberCheck(wrap); 
    }
    
    //existingMemberCheck
    public static ACETSNIICUEDataService.ResponseWrapper existingMemberCheck(ACETSNIICUEDataParser wrap ){
        system.debug('existingMemberCheck-----');
        Id familyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Family').getRecordTypeId();
        Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        
        String famId;
        String pId;
        boolean isError =false;
        String groupNum = '';
        try
       {
            for(Account acc: [Select id from Account where Policy_ID__c=:wrap.policy and Member_ID__c=:wrap.memberId and recordtypeId=:familyAccRecordTypeId]){
                famId=acc.id;
            }
            
            if(String.isNotBlank(famId)){
                for(AccountContactRelation acr: [Select ContactId,accountId,Relationship__c,contact.FirstName,contact.LastName,contact.BirthDate,contact.Name,
                                                 Member_ID__c,Policy_ID__c,Contact.AccountId from AccountContactRelation
                                                 where accountId =:famId]){
                                                     system.debug('api dob----'+wrap.memberDOB);
                                                     system.debug('acr.contact.FirstName---'+acr.contact.FirstName+'---contact dob----'+acr.contact.BirthDate);
                                                     //wrap.memberDOB =Need to see which format its coming
                                                     //string serDob = wrap.memberDOB != null ? date.valueOf(wrap.memberDOB).format(): '';
                                                     string serDob = wrap.memberDOB != null ? ACETUtility.format(date.valueOf(wrap.memberDOB)): ''; // US3705586 : Vishal : ICU Date Format Changes.
                                                     string conDob = acr.contact.BirthDate != null ? ACETUtility.format(date.valueOf(acr.contact.BirthDate)): ''; // US3705586 : Vishal : ICU Date Format Changes.
                                                     //.equalsIgnoreCase((acr.contact.BirthDate).format()
                                                                                                            
                                                     if(wrap.memFirstName.equalsIgnoreCase(acr.contact.FirstName) && wrap.memLastName.equalsIgnoreCase(acr.contact.LastName) && serDob.equalsIgnoreCase(conDob))
                                                         pId=acr.Contact.AccountId;  
                                                     
                                                 }
                return createWorkOrder(pId,wrap);
            }
            
            else 
            {
                string errorMsg = '';
                //Member search logic goes here
                String tranId='';
                //Link Eligibility Service
                ACETSNILinkMemberSearch.SearchResultWrapper linkEligibilityWrap= ACETSNILinkMemberSearch.findMembers(wrap.memberId, wrap.memberDOB, wrap.memFirstName, wrap.memLastName, '', 'MemberIDDateOfBirth');
                if(linkEligibilityWrap!=null && linkEligibilityWrap.statusCode ==200){
                    List<ACETLinkCoveragesResult.CoverageLine> coverageLines = linkEligibilityWrap.resultWrapper.CoverageLines;
                    System.debug(coverageLines);
                    if(coverageLines!=null && coverageLines.size()>0){
                        groupNum = coverageLines[0].GroupNumber;
                        for(ACETLinkCoveragesResult.CoverageLine cv: coverageLines){
                            if(cv.ITEhighlightedPolicyId != null && cv.ITEhighlightedPolicyId){
                                tranId=cv.transactionId;
                                System.debug('tranId='+tranId);
                                
                            }
                            
                        } 
                    }
                    //LinK Extended Service Called
                    if(String.isNotBlank(tranId)){
                        ACETSNILinkMemberSearch.SearchResultWrapper linkExtendedWrap=ACETSNILinkMemberSearch.getHouseHoldData(tranId);
                        String plcId,memberFNVal,memberLNVal,memberDOBVal,memberIdVal;
                        if(linkExtendedWrap!=null && linkExtendedWrap.statusCode==200 && linkExtendedWrap.houseHoldResultWrapper.houseHoldList!=null && linkExtendedWrap.houseHoldResultWrapper.houseHoldList.size()>0)
                        {
                            for(ACETHouseHoldWrapper.HouseHold houseObj: linkExtendedWrap.houseHoldResultWrapper.houseHoldList){
                                if(houseObj.isMainMember == true) {
                                    plcId = houseObj.policyId;
                                    memberFNVal = houseObj.firstName;
                                    memberLNVal = houseObj.lastName;
                                    memberDOBVal = houseObj.dob;
                                    memberIdVal = houseObj.memberId;
                                }
                            }
                            if(String.isNotBlank(plcId) && String.isNotBlank(memberIdVal) && String.isNotBlank(memberDOBVal) 
                               && String.isNotBlank(memberFNVal) && String.isNotBlank(memberLNVal))	{
                                   //Uhg Check logic is bypassed for ICue
                                   //var checkUhgAction = component.get("c.checkUHGaccess");
                                   //Call to SNI Eligibility 
                                   String policyIdVar=plcId.length() < 9?('0000000000' + plcId).Substring(('0000000000' +plcId).length()-9):plcId;
                                   ACETSNILinkMemberSearch.SearchResultWrapper sniWrap=ACETSNILinkMemberSearch.findSNIDetails(memberIdVal, policyIdVar,memberFNVal, memberLNVal, memberDOBVal);
                                   //start
                                   if(sniWrap!=null && sniWrap.statusCode == 200){ // put error message...
                                       String sniEligible = sniWrap.SNIresultWrapper.sniEligibility;
                                       String advFullName = sniWrap.SNIresultWrapper.advisorFullName;
                                       String assignedToVal = sniWrap.SNIresultWrapper.assignedTo;
                                       String lob = sniWrap.SNIresultWrapper.lob;
                                       String productTypes = sniWrap.SNIresultWrapper.productTypes;
                                       String serviceGroup =sniWrap.SNIresultWrapper.serviceGroup;
                                       
                                       //if(sniEligible != null && sniEligible != '' && typeof sniEligible != 'undefined' && sniEligible != 'not eligible' ){ //add one more condition here
                                       if(String.isNotBlank(sniEligible)){
                                                 
                                           ACETHouseHoldWrapper.memberDetails hsw=ACETSNISaveHouseholdData.getSNISaveHouseholdData(linkExtendedWrap.houseHoldResultWrapper.houseHoldList,memberDOBVal,'',memberIdVal,advFullName,sniEligible,policyIdVar,plcId,assignedToVal,lob,productTypes,serviceGroup, groupNum);
                                           if(hsw!= null) {
                                             //  if(!hsw.isSniEligible){ //Why we require this logic -need to check
                                                   if( hsw.newMemberMatch!=null  && String.isNotBlank(hsw.isAcetSearch) )
                                                   {
                                                       return createWorkOrder(pId,wrap); //Check PID should be null/blank here as orphan record need to be created 
                                                       //Orphan WO would be created
                                                   }
                                                   if(!String.isBlank(hsw.accountId) && String.isBlank(hsw.isAcetSearch)){
                                                       String[] IdsFamilyAccount = (hsw.accountId).split('@');
                                                       //Family and members Created
                                                       //Here WO need to be created under particluar member
                                                       //WO creation
                                                       if(String.isNotBlank(IdsFamilyAccount[1])){
                                                           for(AccountContactRelation acr: [Select ContactId,accountId,Relationship__c,contact.FirstName,contact.LastName,contact.BirthDate,contact.Name,
                                                                                            Member_ID__c,Policy_ID__c,Contact.AccountId from AccountContactRelation
                                                                                            where accountId =:IdsFamilyAccount[1]]){
                                                                                                 String dateOfBirth = AcetUtility.formatDateFromDashToSlash(wrap.memberDOB); //wrap.memberDOB =Need to see which format its coming
                                                                                                 String conBd = ACETUtility.format(acr.contact.BirthDate); // US3705586 : Vishal : ICU Date Format Changes.
                                                                                                if(wrap.memFirstName.equalsIgnoreCase(acr.contact.FirstName) && wrap.memLastName.equalsIgnoreCase(acr.contact.LastName) && dateOfBirth.equalsIgnoreCase(conBd)) // US3705586 : Vishal : ICU Date Format Changes.
                                                                                                    pId=acr.Contact.AccountId;  
                                                                                                
                                                                                            }
                                                           return createWorkOrder(pId,wrap);
                                                       }
                                                       
                                                   }
                                              // }
                                               else{
                                                   isError =true;
                                               errorMsg = 'Member is not SNI Eligible';
                                           }
                                       }
                                       else{ 
                                           isError =true;
                                           errorMsg = 'Members creation failed';
                                       }
                                   }
                                   else{ // data nulll
                                       //Error message would be returned
                                       isError =true;
                                       errorMsg = 'SNI Eligible is blank';
                                   }
                               }
                        }
                        else{
                            //Error message would be returned
                            isError =true;
                            errorMsg = 'Member details are missing from the service';
                        }
                    }
                    else{
                        isError =true;
                        errorMsg = 'Error occured in Link Extended';
                        //Link Extended failed - So error need to be returned here
                    }
                }
                else{
                    isError=True;
                    errorMsg = 'Error occured in Link Eligibility';
                }//Transaction ID is blank.. So we cant call Link Extended -So error need to be returned here
            }
            else{
                isError=True;
                errorMsg = 'Error occured in Link Eligibility'; 
            }//Link Elligibility is Down -So error need to be returned here
            ACETSNIICUEDataService.ResponseWrapper wrapRes = new ACETSNIICUEDataService.ResponseWrapper();
            if(isError){
                Application_Error_Log__c AppErrorLog = ACETUtility.CreateApplicationErrorLog('ACET', 'SNIICUEService', '', 'existingMemberCheck : '+errorMsg, 417);
                insert AppErrorLog;
                return sendResponse(errorMsg,'417','');
				//return sendResponse(errorMsg,'');
            }
            else
                return sendResponse('Error Occured','417','');
			//return sendResponse('Error Occured','');
        }
        
    }
    catch(Exception ex){
        Application_Error_Log__c AppErrorLog = ACETUtility.CreateApplicationErrorLog('ACET', 'SNIICUEService', '', 'existingMemberCheck : '+ex.getMessage(), 500);
        insert AppErrorLog;
        return sendResponse('WorkOrder creation/updation failed','500','');
		//return sendResponse('WorkOrder creation/updation failed','');
    }
}
public static ACETSNIICUEDataService.ResponseWrapper sendResponse(string blankField,string statusCode,string workOrderId){
    ACETSNIICUEDataService.ResponseWrapper responseWrap = new ACETSNIICUEDataService.ResponseWrapper();
    system.debug('sendResponse-blankField---'+blankField);
    if(string.isNotBlank(blankField)){ // blankField != null){
        responseWrap.message = blankField;
        responseWrap.status = statusCode;
        responseWrap.workOrderId = '';
        if(blankField == 'Required fields cannot be blank'){
            Application_Error_Log__c AppErrorLog = ACETUtility.CreateApplicationErrorLog('ACET', 'SNIICUEService', '', blankField , 400);
            insert AppErrorLog;
        }
    }
    else{
        responseWrap.message = 'WorkOrder created/updated successfully';
        responseWrap.status = '200';
        responseWrap.workOrderId = workOrderId;
    }
    return responseWrap;
}
//Method to create WO 
public static ACETSNIICUEDataService.ResponseWrapper createWorkOrder(Id pId,ACETSNIICUEDataParser wrap){ //WorkOrder wrapper object would also come
  system.debug('createWorkOrder-----');
    try{
        if(String.isBlank(wrap.policy)|| String.isBlank(wrap.memberId)|| String.isBlank(wrap.memberDOB)|| String.isBlank(wrap.memFirstName) ||
           String.isBlank(wrap.memLastName) || String.isBlank(wrap.serviceRef) || String.isBlank(wrap.HSCId) || String.isBlank(wrap.xrefID) ||
           String.isBlank(wrap.statusDetail) || String.isBlank(wrap.reviewPriority) || String.isBlank(wrap.serviceSetting) || 
           String.isBlank(wrap.hostSystemTimeStamp) )
        {
            return sendResponse('Required fields cannot be blank','400','');
		   // return sendResponse('Required fields cannot be blank','');
        }
        else{
            Id priorAuthRecordType = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Prior Authorization').getRecordTypeId();
            boolean autoCloseMilestone=false;
            //WorkOrder data comes here
            WorkOrder wo=new WorkOrder();
            wo.AccountId=pId; //If pId is null it would create orphan record
            if(String.isBlank(pId)) wo.Add_Member__c=true;//Orphan Record
            wo.Policy_ID__c=wrap.policy;
            wo.Member_ID__c=wrap.memberId;
            //wo.Date_of_Birth__c=Date.parse(wrap.memberDOB);
            wo.Date_of_Birth__c=wrap.memberDOB != null ? Date.valueOf(wrap.memberDOB) : null;
            wo.First_Name__c=wrap.memFirstName;
            wo.Last_Name__c=wrap.memLastName;
            wo.Member_Name__c=wrap.memFirstName+' '+wrap.memLastName;
            //wo.Prior_Auth_Owner__c=wrap.requestType;//need confirmnation on this
            wo.Service_Reference__c=wrap.serviceRef;
            wo.HSC_Unique_ID__c=wrap.HSCId;
            wo.Xref_ID__c=wrap.xrefID;
            if(String.isnotblank(wrap.statusDetail) && (wrap.statusDetail.equals('Decision has been made') || wrap.statusDetail.equals('Decision Has Been Made') || wrap.statusDetail.equals('Canceled')))
                  autoCloseMilestone=true;
            if(!autoCloseMilestone)
             wo.Status_Detail__c=wrap.statusDetail;
            wo.Priority=wrap.reviewPriority;
            wo.Service_Setting__c=wrap.serviceSetting;
            wo.Service_Start_Date__c=String.isNotBlank(wrap.startDate)?Date.valueOf(wrap.startDate):null;
            wo.Service_End_Date__c =String.isNotBlank(wrap.endDate)?Date.valueOf(wrap.endDate):null;
            //wo.Host_System_Date_and_Time__c=String.isNotBlank(wrap.hostSystemTimeStamp)?Datetime.parse(wrap.hostSystemTimeStamp):null; //Datetime.valueOf(wrap.hostSystemTimeStamp);
            if(String.isNotBlank(wrap.hostSystemTimeStamp)){
                date dt = Date.valueOf(wrap.hostSystemTimeStamp);
                wo.Host_System_Date_and_Time__c = DateTime.newInstance(dt.year(),dt.month(),dt.day());
            }
            wo.Expected_Admission_Date__c=String.isNotBlank(wrap.expectedAdmissionDate)?Date.valueOf(wrap.expectedAdmissionDate):null;
            wo.Expected_Discharge_Date__c=String.isNotBlank(wrap.expectedDischargeDate)?Date.valueOf(wrap.expectedDischargeDate):null;
            wo.Actual_Admission_Date__c=String.isNotBlank(wrap.actualAdmissionDate)?Date.valueOf(wrap.actualAdmissionDate):null;
            wo.Actual_Discharge_Date__c=String.isNotBlank(wrap.actualDischargeDate)?Date.valueOf(wrap.actualDischargeDate):null;
            //wo.RecordTypeId =priorAuthRecordType ;//As PB Automatically add the recordType based on the status
            
            //Diagnosis Code creation/updation logic goes here
            if(wrap.diagnosisCodes!=null && wrap.diagnosisCodes.size()>0){
                list<Diagnosis_Code__c> dgList=new list<Diagnosis_Code__c>();
                for(String dgCode :wrap.diagnosisCodes){
                    wo.Diagnosis_code__c  = dgCode;
                }
                
            }
            
            //Provider creation/updation logic goes here
            if(wrap.providerInfos!=null && wrap.providerInfos.size()>0){
                boolean isFirstProvider=false;
                for(ACETSNIICUEDataParser.ProviderInfo pro :wrap.providerInfos){
                    // If servicing provider is not there, then we would be taking the first provider
                    if(!isFirstProvider){
                      wo.Servicing_Provider_Name_Status__c=pro.providerName+'/'+pro.providerNetworkStatus;
                      isFirstProvider=true;
                    }
                    if(pro.providerRole!=null && pro.providerRole.size()>0){
                        for(String prRole : pro.providerRole){
                            //If servicing provider is there,then we would be taking the serving one
                            if(String.isNotBlank(prRole) && prRole=='Servicing'){
                                wo.Servicing_Provider_Name_Status__c=pro.providerName+'/'+pro.providerNetworkStatus;
                            }
                        }
                    }
                }
            }

            insert wo;
            
            if(autoCloseMilestone){
                wo.Status_Detail__c=wrap.statusDetail.equals('Decision Has Been Made')?'Decision has been made':wrap.statusDetail;
                update wo;
            }
            
            
            //Service Line Creation logic goes here
            if(wrap.serviceLines!=null && wrap.serviceLines.size()>0){
                list<Service_Lines__c> slList=new list<Service_Lines__c>();
                for(ACETSNIICUEDataParser.ServiceLine slr :wrap.serviceLines){
                    Service_Lines__c sl=new Service_Lines__c();
                    sl.Decision_Outcome__c= slr.decisionOutCome;
                    sl.Reason__c=slr.decisionReason;
                    sl.Decision_Subtype__c=slr.decisionSubType;
                    sl.Procedure_Code__c= slr.procedureCode;
                   // sl.Procedure_Description__c=slr.procedureDescription;
		    if(string.isNotBlank(slr.procedureDescription)){
                      sl.Procedure_Description__c= slr.procedureDescription.length()>255?slr.procedureDescription.substring(0, 255):slr.procedureDescription;
		    }
                    sl.serviceLinkUniqueId__c=slr.serviceLinkUniqueId;//New field not added yet
                    sl.Work_Order__c=wo.Id;
                    slList.add(sl);
                }
                if(slList!=null && slList.size()>0) insert slList; 
            }
            list<WorkOrder> lstWO = [select id,WorkOrderNumber from WorkOrder where id =: wo.Id];
            if(lstWO != null && lstWO.size()>0){
              return sendResponse('','',lstWO[0].WorkOrderNumber);
            }
            else{
              return sendResponse('','',null);  
            }
            //return sendResponse('','',wo.Id);
			//return sendResponse('',wo.Id);
        }
      
   }
    catch(Exception ex){
        Application_Error_Log__c AppErrorLog = ACETUtility.CreateApplicationErrorLog('ACET', 'SNIICUEService', '', 'createWorkOrder: '+ex.getMessage(), 500);
        insert AppErrorLog;
        return sendResponse('WorkOrder creation/updation failed','500','');
		//return sendResponse('WorkOrder creation/updation failed','');
    }
    /*
//Provider Creation logic goes here
if(wrap.providerInfos!=null && wrap.providerInfos.size()>0){
list<Provider__c> prList=new list<Provider__c>();
for(ACETSNIICUEDataParser.ProviderInfo pro :wrap.providerInfos){
Provider__c pr=new Provider__c();
//pr.Name= pro.providerName; //Its auto number field - We need to convert into text field
pr.Network_Status__c=pro.providerNetworkStatus;
pr.Role__c='';
if(pro.providerRole!=null && pro.providerRole.size()>0){
for(String prRole : pro.providerRole){
if(String.isNotBlank(prRole)){
pr.Role__c=String.isNotBlank(pr.Role__c)?pr.Role__c +'/'+ prRole:prRole;
}
}
}

System.debug('pr.Role__c in insert='+pr.Role__c);
//pro.providerUniqueID;//New field not added yet
pr.Work_Order__c=wo.Id;
prList.add(pr);
}
if(prList!=null && prList.size()>0) insert prList; 
}

//Diagnosis Code creation logic goes here
if(wrap.diagnosisCodes!=null && wrap.diagnosisCodes.size()>0){
list<Diagnosis_Code__c> dgList=new list<Diagnosis_Code__c>();
for(String dgCode :wrap.diagnosisCodes){
Diagnosis_Code__c dg=new Diagnosis_Code__c();
dg.Diagnosis_Code__c=dgCode;
dg.Work_Order__c=wo.Id;
dg.Primary_Diagnosis__c=true;
dgList.add(dg);
}
if(dgList!=null && dgList.size()>0) insert dgList; 
}
*/
    
}

//Logic to update WO 
public static ACETSNIICUEDataService.ResponseWrapper updateWorkOrder(WorkOrder wo,ACETSNIICUEDataParser wrap){
    system.debug('updateWorkOrder-----');
    try{
        //wo.AccountId=pId; //If pId is null it would create orphan record
        if(String.isBlank(wrap.policy)|| String.isBlank(wrap.memberId)|| String.isBlank(wrap.memberDOB)|| String.isBlank(wrap.memFirstName) ||
           String.isBlank(wrap.memLastName) || String.isBlank(wrap.serviceRef) || String.isBlank(wrap.HSCId) || String.isBlank(wrap.xrefID) ||
           String.isBlank(wrap.statusDetail) || String.isBlank(wrap.reviewPriority) || String.isBlank(wrap.serviceSetting) || 
           String.isBlank(wrap.hostSystemTimeStamp) )
        {
           return sendResponse('Required fields cannot be blank','400','');
		   // return sendResponse('Required fields cannot be blank','');
        }
        else{
            
            //WorkOrder data comes here
            Id priorAuthRecordType = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Prior Authorization').getRecordTypeId();
            //wo.AccountId=pId; //If pId is null it would create orphan record
            wo.Policy_ID__c=wrap.policy;
            wo.Member_ID__c=wrap.memberId;
            wo.Date_of_Birth__c=wrap.memberDOB != null ? Date.valueOf(wrap.memberDOB) : null;
            wo.First_Name__c=wrap.memFirstName;
            wo.Last_Name__c=wrap.memLastName;
            //wo.Prior_Auth_Owner__c=wrap.requestType;//need confirmnation on this
            wo.Service_Reference__c=wrap.serviceRef;
            wo.HSC_Unique_ID__c=wrap.HSCId;
            wo.Xref_ID__c=wrap.xrefID;
            wo.Status_Detail__c=wrap.statusDetail.equals('Decision Has Been Made')?'Decision has been made':wrap.statusDetail;
            wo.Priority=wrap.reviewPriority;
            wo.Service_Setting__c=wrap.serviceSetting;
            wo.Service_Start_Date__c=String.isNotBlank(wrap.startDate)?Date.valueOf(wrap.startDate):null;
            wo.Service_End_Date__c =String.isNotBlank(wrap.endDate)?Date.valueOf(wrap.endDate):null;
            //wo.Host_System_Date_and_Time__c=Datetime.valueOf(wrap.hostSystemTimeStamp);
           /*  if(String.isNotBlank(wrap.hostSystemTimeStamp)){
                date dt = Date.valueOf(wrap.hostSystemTimeStamp);
                wo.Host_System_Date_and_Time__c = DateTime.newInstance(dt.year(),dt.month(),dt.day());
            }*/
            wo.Expected_Admission_Date__c=String.isNotBlank(wrap.expectedAdmissionDate)?Date.valueOf(wrap.expectedAdmissionDate):null;
            wo.Expected_Discharge_Date__c=String.isNotBlank(wrap.expectedDischargeDate)?Date.valueOf(wrap.expectedDischargeDate):null;
            wo.Actual_Admission_Date__c=String.isNotBlank(wrap.actualAdmissionDate)?Date.valueOf(wrap.actualAdmissionDate):null;
            wo.Actual_Discharge_Date__c=String.isNotBlank(wrap.actualDischargeDate)?Date.valueOf(wrap.actualDischargeDate):null;
            //wo.RecordTypeId =priorAuthRecordType ;//As PB Automatically add the recordType based on the status
            
            //Diagnosis Code creation/updation logic goes here
            if(wrap.diagnosisCodes!=null && wrap.diagnosisCodes.size()>0){
                list<Diagnosis_Code__c> dgList=new list<Diagnosis_Code__c>();
                for(String dgCode :wrap.diagnosisCodes){
                    wo.Diagnosis_code__c  = dgCode;
                }
                
            }
            
            //Provider creation/updation logic goes here
            if(wrap.providerInfos!=null && wrap.providerInfos.size()>0){
                boolean isFirstProvider=false;
                for(ACETSNIICUEDataParser.ProviderInfo pro :wrap.providerInfos){
                    // If servicing provider is not there, then we would be taking the first provider
                    if(!isFirstProvider){
                      wo.Servicing_Provider_Name_Status__c=pro.providerName+'/'+pro.providerNetworkStatus;
                      isFirstProvider=true;
                    }
                    if(pro.providerRole!=null && pro.providerRole.size()>0){
                        for(String prRole : pro.providerRole){
                            //If servicing provider is there,then we would be taking the serving one
                            if(String.isNotBlank(prRole) && prRole=='Servicing'){
                                wo.Servicing_Provider_Name_Status__c=pro.providerName+'/'+pro.providerNetworkStatus;
                            }
                        }
                    }
                }
            }
            update wo;
            
            Map<String,Service_Lines__c> extServiceLineMap=new Map<String,Service_Lines__c>();
            if(wo.Service_Lines__r!=null && wo.Service_Lines__r.size()>0){
                for(Service_Lines__c sln:wo.Service_Lines__r){
                    extServiceLineMap.put(sln.serviceLinkUniqueId__c,sln);
                }
            }
            
            //Service Line creation/updation logic goes here
            if(wrap.serviceLines!=null && wrap.serviceLines.size()>0){
                list<Service_Lines__c> slList=new list<Service_Lines__c>();
                for(ACETSNIICUEDataParser.ServiceLine slr :wrap.serviceLines){
                    Service_Lines__c sl ; //= new Service_Lines__c();
                    if(extServiceLineMap.get(slr.serviceLinkUniqueId)!=null){
                        sl = extServiceLineMap.get(slr.serviceLinkUniqueId);
                    }
                    else{
                        sl = new Service_Lines__c();
                        sl.Work_Order__c=wo.Id;
                        sl.serviceLinkUniqueId__c=slr.serviceLinkUniqueId;
                    }
                    //Service_Lines__c sl=extServiceLineMap.get(slr.serviceLinkUniqueId)!=null?extServiceLineMap.get(slr.serviceLinkUniqueId):new Service_Lines__c();
                    //Service_Lines__c sl=new Service_Lines__c();
                    sl.Decision_Outcome__c= slr.decisionOutCome;
                    sl.Reason__c=slr.decisionReason;
                    sl.Decision_Subtype__c=slr.decisionSubType;
                    sl.Procedure_Code__c= slr.procedureCode;
                    //sl.Procedure_Description__c=slr.procedureDescription;
		    if(string.isNotBlank(slr.procedureDescription)){
                      sl.Procedure_Description__c= slr.procedureDescription.length()>255?slr.procedureDescription.substring(0, 255):slr.procedureDescription;
		    }
                    //sl.serviceLinkUniqueId__c=slr.serviceLinkUniqueId;
                    //sl.Work_Order__c=wo.Id;
                    slList.add(sl);
                }
                if(slList!=null && slList.size()>0) upsert slList; 
                
            }
            
            /*Map<String,Provider__c> extProviderMap=new Map<String,Provider__c>();
            if(wo.ProvidersWO__r!=null && wo.ProvidersWO__r.size()>0){
                for(Provider__c prd:wo.ProvidersWO__r){
                    extProviderMap.put(prd.id,prd);//Instead of id, the unique Identifier would be coming
                }   
            }
            //we dont have any unique id here? i guess Diagnosis_Code__c should be unique
            map<String,Diagnosis_Code__c> extDCMap=new map<String,Diagnosis_Code__c>();
            if(wo.Diagnosis_CodesWO__r!=null && wo.Diagnosis_CodesWO__r.size()>0){
                for(Diagnosis_Code__c dgn:wo.Diagnosis_CodesWO__r){
                    extDCMap.put(dgn.Diagnosis_Code__c,dgn);
                }
            }*/
            system.debug('update---wo number---'+wo.WorkOrderNumber);
            return sendResponse('','',wo.WorkOrderNumber);
		   //return sendResponse('',wo.Id);
        }
    }
    catch(Exception ex){
        Application_Error_Log__c AppErrorLog = ACETUtility.CreateApplicationErrorLog('ACET', 'SNIICUEService', '', 'updateWorkOrder: '+ex.getMessage(), 500);
        insert AppErrorLog;
        return sendResponse('WorkOrder creation/updation failed','500','');
	   //return sendResponse('WorkOrder creation/updation failed','');
    }
    /*
//Provider creation/updation logic goes here
if(wrap.providerInfos!=null && wrap.providerInfos.size()>0){
list<Provider__c> prList=new list<Provider__c>();
for(ACETSNIICUEDataParser.ProviderInfo pro :wrap.providerInfos){
//Provider__c pr=extProviderMap.get(pro.providerUniqueID)!=null?extProviderMap.get(pro.providerUniqueID):new Provider__c();
Provider__c pr=new Provider__c();
//pr.Name= pro.providerName; //Its auto number field - We need to convert into text field
pr.Network_Status__c=pro.providerNetworkStatus;
pr.Role__c='';
if(pro.providerRole!=null && pro.providerRole.size()>0){
for(String prRole : pro.providerRole){
if(String.isNotBlank(prRole)){
pr.Role__c=String.isNotBlank(pr.Role__c)?pr.Role__c +'/'+ prRole:prRole;
}
}
}

System.debug('pr.Role__c in update='+pr.Role__c);

//pro.providerUniqueID;//New field not added yet
pr.Work_Order__c=wo.Id;
prList.add(pr);
}
if(prList!=null && prList.size()>0) upsert prList; 
}

//Diagnosis Code creation/updation logic goes here
if(wrap.diagnosisCodes!=null && wrap.diagnosisCodes.size()>0){
list<Diagnosis_Code__c> dgList=new list<Diagnosis_Code__c>();
for(String dgCode :wrap.diagnosisCodes){
Diagnosis_Code__c dg=extDCMap.get(dgCode)!=null?extDCMap.get(dgCode):new Diagnosis_Code__c();
dg.Diagnosis_Code__c=dgCode;
dg.Work_Order__c=wo.Id;
dg.Primary_Diagnosis__c=true;
dgList.add(dg);
}
if(dgList!=null && dgList.size()>0) upsert dgList; 
}
*/
}
}