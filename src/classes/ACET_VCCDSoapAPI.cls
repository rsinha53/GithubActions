/* 
   Description : This class is used to update VCCD incoming details to Object 
   Author : Jitendra Anagani
   Date : 04/06/2020
*/
global with sharing class ACET_VCCDSoapAPI {

    global class ACET_VCCDRequest {
        webservice String ani;
        webservice String subjectDOB;
        webservice String questionType;
        webservice String productType;
        webservice String claimId;
        webservice String ucid;
        webservice String claimsDOSMD;
        webservice String memberId;
        webservice String taxId;
        webservice String NPI;
        webservice String MSID;
        webservice String TFN;
        webservice String callerType;
        webservice String dnis;
webservice String rcKeyCallId;
webservice String VisionClaimID;
webservice String dentalClaimID;
webservice String claimsDOS;
webservice String AcctManagerPhone;
webservice String legacyProviderId;
webservice String groupID;
webservice String producerID;
webservice String HIPPAFlag;
webservice String eligibilityTypeCode;
webservice String dob;
webservice String ProcedureID;
webservice String firstName;
webservice String lastName;
webservice String Zip;
webservice String State;
// US3070821-For Optum Finacial variables-Rollstone (Prasad)
        webservice String faroId;
        webservice String SSN;
        webservice String callerId;
        webservice String skill;
        webservice String employer;
        webservice String payer;
        webservice String accountNumber;
        webservice String callReason;
    }

    /**
     * Used to Insert Incoming VCCD Details to VCCD Response Object.
     * Param : objInfo Stores the instance of Webservice inputs
     * Return Type : XML String with Success or Error Status Code
     */
    webservice static string ProcessVCCDInbound(ACET_VCCDRequest objInfo) {

        try {
            Boolean isSpire = false;
			Boolean isOptum = false;
            //VCCD_Response__c object API Name
            DOM.Document objDoc = new DOM.Document();
            DOM.XMLNode objRoot = objDoc.createRootElement('responseInfo',null,null);

            if(objInfo == null) {
                DOM.XMLNode objResponseMessage = objRoot.addChildElement('Status',null,null);
                objResponseMessage.addTextNode('Invalid Request');
                DOM.XMLNode objResponseMessage1 = objRoot.addChildElement('StatusCode',null,null);
                objResponseMessage1.addTextNode('400');
                return objDoc.toXmlString();
            }


            if(String.isBlank(objInfo.MSID) == true) {
                DOM.XMLNode objResponseMessage = objRoot.addChildElement('Status',null,null);
                objResponseMessage.addTextNode('Invalid MSID');
                DOM.XMLNode objResponseMessage1 = objRoot.addChildElement('StatusCode',null,null);
                objResponseMessage1.addTextNode('300');
                return objDoc.toXmlString();
            }

            VCCD_Response__c objResponse = new VCCD_Response__c();

            objResponse.isActive__c = true;

            if(String.isNotBlank(objInfo.ani) == true) {
                isSpire = true;
                objResponse.ani__c =  objInfo.ani;
            }

            if(String.isNotBlank(objInfo.claimId) == true) {
                isSpire = true;
                objResponse.claimId__c =  objInfo.claimId;
            }

            if(String.isNotBlank(objInfo.claimsDOSMD) == true) {
                isSpire = true;
                objResponse.claimsDOSMD__c =  objInfo.claimsDOSMD;
            }

            if(String.isNotBlank(objInfo.memberId) == true) {
                isSpire = true;
                objResponse.memberId__c =  objInfo.memberId;
            }

            if(String.isNotBlank(objInfo.MSID) == true) {
                objResponse.MSID__c =  objInfo.MSID;
            }

            if(String.isNotBlank(objInfo.NPI) == true) {
                isSpire = true;
                objResponse.NPI__c =  objInfo.NPI;
            }

            if(String.isNotBlank(objInfo.productType) == true) {
                isSpire = true;
                objResponse.productType__c =  objInfo.productType;
            }

            if(String.isNotBlank(objInfo.questionType) == true) {
                isSpire = true;
                List<ACET_VCCD_Topic_Mappings__mdt> lstofVCCDMappings = [SELECT MappingValue__c, QuestionType__c FROM ACET_VCCD_Topic_Mappings__mdt where Label=:objInfo.questionType.trim()];
                String strQuestionType = '--';
                if(!lstofVCCDMappings.isEmpty()){
                    objResponse.QuestionTypeTopic__c = lstofVCCDMappings[0].QuestionType__c;
                    strQuestionType = lstofVCCDMappings[0].MappingValue__c;
                }
                objResponse.QuestionType__c = strQuestionType;
                objResponse.QuestionTypeCode__c  = objInfo.questionType;
            }

            if(String.isNotBlank(objInfo.subjectDOB) == true) {
                isSpire = true;
                objResponse.subjectDOB__c = Date.valueof(objInfo.subjectDOB);
            }

            if(String.isNotBlank(objInfo.taxId) == true)
                isSpire = true;{
                objResponse.taxId__c =  objInfo.taxId;
            }

            if(String.isNotBlank(objInfo.ucid) == true) {
                isSpire = true;
                objResponse.ucid__c =  objInfo.ucid;
            }
            if(String.isNotBlank(objInfo.TFN) == true) {
                isSpire = true;
                objResponse.TFN__c =  objInfo.TFN;
            }
            if(String.isNotBlank(objInfo.callerType) == true) {
                isSpire = true;
                objResponse.Caller_Type__c =  objInfo.callerType;
            }
            if(String.isNotBlank(objInfo.rcKeyCallId) == true) {
                objResponse.rcKeyCallId__c =  objInfo.rcKeyCallId;
            } if(String.isNotBlank(objInfo.VisionClaimID) == true) {
                objResponse.VisionClaimID__c =  objInfo.VisionClaimID;
            } if(String.isNotBlank(objInfo.dentalClaimID) == true) {
                objResponse.dentalClaimID__c =  objInfo.dentalClaimID;
            } if(String.isNotBlank(objInfo.claimsDOS) == true) {
                objResponse.claimsDOS__c =  objInfo.claimsDOS;
            } if(String.isNotBlank(objInfo.AcctManagerPhone) == true) {
                objResponse.AcctManagerPhone__c =  objInfo.AcctManagerPhone;
            } if(String.isNotBlank(objInfo.legacyProviderId) == true) {
                objResponse.legacyProviderId__c =  objInfo.legacyProviderId;
            } if(String.isNotBlank(objInfo.groupID) == true) {
                objResponse.groupID__c =  objInfo.groupID;
            } if(String.isNotBlank(objInfo.producerID) == true) {
                objResponse.producerID__c =  objInfo.producerID;
            } if(String.isNotBlank(objInfo.HIPPAFlag) == true) {
                objResponse.HIPPAFlag__c =  objInfo.HIPPAFlag;
            } if(String.isNotBlank(objInfo.eligibilityTypeCode) == true) {
                objResponse.eligibilityTypeCode__c =  objInfo.eligibilityTypeCode;
            }
            if(String.isNotBlank(objInfo.dob) == true) {
                objResponse.DOB__c = Date.valueof(objInfo.dob);
            }
            if(String.isNotBlank(objInfo.ProcedureID) == true) {
                objResponse.ProcedureID__c= objInfo.ProcedureID;
            }
            if(String.isNotBlank(objInfo.firstName) == true) {
                objResponse.firstName__c = objInfo.firstName;
            }
            if(String.isNotBlank(objInfo.firstName) == true) {
                objResponse.firstName__c = objInfo.firstName;
            }
            if(String.isNotBlank(objInfo.lastName) == true) {
                objResponse.lastName__c= objInfo.lastName;
            }
            if(String.isNotBlank(objInfo.Zip) == true) {
                objResponse.Zip__c= objInfo.Zip;
            }
            if(String.isNotBlank(objInfo.State) == true) {
                objResponse.State__c  = objInfo.State;
            }

            
           // if(isSpire == true ) {
                if(String.isNotBlank(objInfo.MSID)) {
                    List<User> lstUsers = new List<User>();
                    
                 lstUsers = [Select id,name, FederationIdentifier from User where FederationIdentifier = :objInfo.MSID AND profile.name IN ('Provider Service', 'ACET EB Agent', 'ACET Member', 'ACET Provider')];   
                    if(lstUsers.isEmpty() == false) {
                        objResponse.isActive__c = true;
                    } else {
                        objResponse.isActive__c = false;
                    }
                }
                objResponse.isSpire__c = true;
           // }
		   //US3070821-For Optum Finacial code Start-Rollstone
             if(String.isNotBlank(objInfo.faroId) == true) {
                isOptum = true;
                objResponse.FaroId__c =  objInfo.faroId;
            }
            if(String.isNotBlank(objInfo.SSN) == true) {
                isOptum = true;
                objResponse.SSN__c =  objInfo.SSN;
            }
            if(String.isNotBlank(objInfo.callerId) == true) {
                isOptum = true;
                objResponse.CallerId__c =  objInfo.callerId;
            }
            if(String.isNotBlank(objInfo.skill) == true) {
                isOptum = true;
                objResponse.Skill__c =  objInfo.skill;
            }
            if(String.isNotBlank(objInfo.employer) == true) {
                isOptum = true;
                objResponse.Employer__c =  objInfo.employer;
            }
            if(String.isNotBlank(objInfo.payer) == true) {
                isOptum = true;
                objResponse.Payer__c =  objInfo.payer;
            }
            if(String.isNotBlank(objInfo.accountNumber) == true) {
                isOptum = true;
                objResponse.AccountNumber__c =  objInfo.accountNumber;
            }
            if(String.isNotBlank(objInfo.callReason) == true) {
                isOptum = true;
                objResponse.CallReason__c =  objInfo.callReason;
            }
            if(isOptum == true ) {
              if(String.isNotBlank(objInfo.MSID)) {
                    List<User> lstUsers = new List<User>();
                    //AND profile.name = 'OF CSR'
                    lstUsers = [Select id,name, FederationIdentifier from User where FederationIdentifier = :objInfo.MSID];
                    if(lstUsers.isEmpty() == false) {
                       objResponse.isActive__c = true;
                    } else {
                        objResponse.isActive__c = false;
                    } 
                }
                objResponse.IsOptum__c = true;
            }
           //US3070821-For Optum Finacial code end-Rollstone

            insert objResponse;
            
            DOM.XMLNode objResponseMessage = objRoot.addChildElement('Status',null,null);
            objResponseMessage.addTextNode('Success');
            DOM.XMLNode objResponseMessage1 = objRoot.addChildElement('StatusCode',null,null);
            objResponseMessage1.addTextNode('200');
            return objDoc.toXmlString();
        
        } catch (exception ex) {
            DOM.Document objDoc = new DOM.Document();
            DOM.XMLNode objRoot = objDoc.createRootElement('responseInfo',null,null);
            DOM.XMLNode objResponseMessage = objRoot.addChildElement('Status',null,null);
            objResponseMessage.addTextNode('Invalid Request');
            DOM.XMLNode objResponseMessage1 = objRoot.addChildElement('StatusCode',null,null);
            objResponseMessage1.addTextNode('500');
            return objDoc.toXmlString();
        }
    }

}