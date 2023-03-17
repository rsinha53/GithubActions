/*
**********************************************************************************
Class Name:  ACETARADataService
Description :
Author: priyanka,
Created Date : 27-11-2019
Modification History :
**********************************************************************************
*/

@RestResource(urlMapping='/Case/ProActiveAlerts')
global with sharing class ACETARADataService {

    /*
**********************************************************************************
Class Name:  ResponseWrapper
Description :  wrapper class for the response to an API request
Author: priyanka,
Created Date : 12-2-2019
Modification History :
**********************************************************************************
*/
    global without sharing class ResponseWrapper {
        global String status {get;set;} //status string
        global String message {get;set;} //message string

        global ResponseWrapper() {
            //default all values
            this.status = '';
            this.message = '';
        }
    }

    @HttpPost
    global static ResponseWrapper insertCaseData() {
        ResponseWrapper responseJSON = new ResponseWrapper() ;
        IntegrationResultCapture__c resultCapture = new IntegrationResultCapture__c();
        ACETARADataServiceParser  cseDetails = new ACETARADataServiceParser();
        List<Case> caseList = new List<Case>();
        RestRequest req = RestContext.request; //the RestRequest for the Apex REST method
        AccountContactRelation memberRec = new AccountContactRelation();
        Id cseOverviewRecordtype =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case Overview').getRecordTypeId();
        //Getting JSON String from request body
        String jsonBody = req.requestBody.toString(); //the body of the request
        System.debug('jsonBody**'+jsonBody);
        Case cse;
        Boolean nameMatch = false;
        try{
            resultCapture.request__c = jsonBody ;
            cseDetails = ACETARADataServiceParser.parse(jsonBody);
            System.debug('***cseDetails**'+ cseDetails);
            //Insert caseDetails
            if(cseDetails != null && (cseDetails.alert_type).length() > 0 && cseDetails.alert_type != 'OLIM' && cseDetails.alert_type != 'INPT/DISC'){
                /*checking for the big five data in the request else return the error case not inserted**/
                if(cseDetails.patient_name != null && (cseDetails.patient_name).length() >0
                   && cseDetails.policy_id !=null && (cseDetails.policy_id).length() >0
                   && cseDetails.alt_id != null && (cseDetails.alt_id).length() >0
                  && cseDetails.birthdate!=null && (cseDetails.birthdate).length() >0){
                  String policy_id = ACETUtility.policyRefactor(cseDetails.policy_id);
                  String alt_id =  cseDetails.alt_id.replaceFirst('^0+','');
                  /**Finding the family account with policy and member id else return error with case not inserted**/
                  List<Account> famliyAccount = [select id, Name, FirstName, LastName, Member_ID__c from account where  Member_ID__c =:alt_id  and Policy_ID__c  =: policy_id]; 
                    /** If family account exists then fetch the related person Accounts with date of birth (name cannot be queried as encrypted)**/
                    if(famliyAccount.size()>0){
                        List<AccountContactRelation> acrRec =[Select Id,contactId,contact.FirstName,contact.accountId,contact.Birthdate FROM AccountContactRelation where AccountId =:famliyAccount[0].Id and contact.Birthdate =: date.valueOf(cseDetails.birthdate)];
                        /**Once we get the person account to compare the name with the request and the person account to fetch the correct member record **/
                        System.debug('acrRec++++'+acrRec);
                        if(acrRec.size()>0)
                        {
                            for(AccountContactRelation acr : acrRec){
                                //Split the name from KAFKA to compare the name matches the ACET member name
                                List<String> name = (cseDetails.patient_name).split(',',2);
                                SYstem.debug('contacts++++'+(acr.contact.FirstName) );
                                System.debug('name+++'+(name[1].trim()));
                                if((acr.contact.FirstName).equalsIgnoreCase(name[1].trim()))
                                {
                                    nameMatch = true;
                                    memberRec = acr;
                                }
                               }
                                if(!nameMatch){
                                    responseJSON.status = '500';
                   				    responseJSON.message ='Case Data Not Inserted .Please check the Name Details.Name Doesnot Match';
                                    insert resultCapture;
                                    return responseJSON;
                                }
                            List<case> cseOverview = [Select Id from case where accountId =: memberRec.contact.accountId and recordtypeId =:cseOverviewRecordtype ];
                            cse = new Case();
                            cse.AccountId = memberRec.contact.accountId;
                            cse.ContactId =memberRec.contactId;
                            cse.ParentId = cseOverview[0].Id;
                            cse.patient_name__c = cseDetails.patient_name;
                            cse.subscriber_nbr__c = cseDetails.subscriber_nbr;
                            cse.policy_id__c = cseDetails.policy_id;
                            cse.alt_id__c = cseDetails.alt_id;
                           // cse.birthdate__c =cseDetails.birthdate!=null? Date.valueOf(cseDetails.birthdate):null;
                            cse.prior_auth_number__c = cseDetails.prior_auth_number;
                            cse.prior_auth_status__c = cseDetails.prior_auth_status;
                            cse.prior_auth_decision__c = cseDetails.prior_auth_decision;
                            cse.benefit_therapy_indicator__c = cseDetails.benefit_therapy_indicator;
                            cse.coverage_type__c = cseDetails.coverage_type ;
                            cse.total_benefit_limit__c = cseDetails.total_benefit_limit ;
                            cse.percent_benefit_used__c = cseDetails.percent_benefit_used;
                            cse.limit_exceeded_claim_proc_date__c =cseDetails.limit_exceeded_claim_proc_date!= null? Date.valueOf(cseDetails.limit_exceeded_claim_proc_date):null ;
                            cse.benefit_start_date__c =cseDetails.benefit_start_date!=null? Date.valueOf(cseDetails.benefit_start_date) :null;
                            cse.benefit_end_date__c = cseDetails.benefit_end_date!=null ? Date.valueOf(cseDetails.benefit_end_date) : null;
                            cse.plan_type__c = cseDetails.plan_type ;
                            cse.benefit_network_type__c =cseDetails.benefit_network_type;
                            cse.soft_or_hard_limit__c = cseDetails.soft_or_hard_limit ;
                            cse.caseid__c = cseDetails.caseid != null ? Double.valueOf(cseDetails.caseid) : null;
                            cse.hosp_state__c =cseDetails.hosp_state ;
                            cse.prov_mpin__c =cseDetails.prov_mpin ;
                            cse.hosp_name__c = csedetails.hosp_name ;
                            cse.admitdate__c = cseDetails.admitdate !=null ? Date.valueOf(cseDetails.admitdate):null;
                            cse.dischargedate__c = (cseDetails.dischargedate !=null && cseDetails.dischargedate.length() > 0 && (cseDetails.dischargedate).toUpperCase() !='NULL') ? Date.valueOf(cseDetails.dischargedate) :null;
                            cse.admit_reason_dx_code__c = cseDetails.admit_reason_dx_code;
                            cse.admit_reason_dxcode_desc__c = cseDetails.admit_reason_dxcode_desc ;
                            cse.case_manager__c = cseDetails.case_manager;
                            cse.days_since_last_admit__c = cseDetails.days_since_last_admit !=null ? double.valueOf(cseDetails.days_since_last_admit) : null;
                            cse.alert_category__c = cseDetails.alert_category ;
                            cse.submitted_date__c =cseDetails.submitted_date!= null ? Date.valueOf(cseDetails.submitted_date) : null;
                            cse.procedure_code__c  = (cseDetails.procedure_code!= null)?cseDetails.procedure_code:'';
                            cse.expected_procedure_date__c = (cseDetails.alert_type != 'PDN' && cseDetails.expected_procedure_date != null && cseDetails.expected_procedure_date.length()>0 && (cseDetails.expected_procedure_date).toUpperCase() != 'NULL') ? Date.valueOf(cseDetails.expected_procedure_date):null;
                            cse.alert_type__c = cseDetails.alert_type;
                            cse.alert_shared_date__c = cseDetails.alert_shared_date != null? Date.valueOf(cseDetails.alert_shared_date): null;
                            //cse.Status = 'Open';
                            cse.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Proactive Alert').getRecordTypeId();
                            caseList.add(cse);

                        }
                        else{
                            responseJSON.status = '500';
                            responseJSON.message ='Case Data Not Inserted .Member doesnot exist';
                        }
                    }
                    else{
                        responseJSON.status = '500';
                        responseJSON.message ='Case Data Not Inserted .Family doesnot exist';
                    }
                }
                else{
                    responseJSON.status = '500';
                    responseJSON.message ='Case Data Not Inserted .Please check the Big Five Data';
                }

            }
            else{
                responseJSON.status = '500';
                responseJSON.message ='Case Data Not Inserted .Check the Alert Type';
            }
            if(caseList.size()>0){
                System.debug('***caseList'+caseList);
                insert caseList;
                responseJSON.status = '200';
                responseJSON.message ='Case Data Inserted Successfully';
            }
        }
        Catch(DmlException e){
            responseJSON.status = '500';
            responseJSON.message = e.getMessage();

        }
        Catch(JSONException e){
            responseJSON.status = '400';
            responseJSON.message = 'Case Data Not Inserted .Please check the Data sent ';
        }
        Catch(Exception ex){
            System.debug('***Exception'+ex);
            responseJSON.status = '500';
            responseJSON.message = 'Case Data Not Inserted';
            //Exception Handling
        }
        resultCapture.response__c = responseJSON.status +'message:'+responseJSON.message;
        insert resultCapture;
        return responseJSON;
    }


}