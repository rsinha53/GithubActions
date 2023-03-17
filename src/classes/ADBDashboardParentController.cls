/**
* Author: Nadeem Fazloon
* Description : Used by ADB_DashboardParent
* Date Created: 05/15/2020
*/
public without sharing class ADBDashboardParentController {
	final static String ACTIVE_POLICY = 'Active Policy'; 
    final static String FUTURE_POLICY = 'Future Policy';
    final static String PAST_POLICY = 'Past Policy';												  
    // call the alerts service in the service call and return wrapper : US2382023 - Sunil Vennam
    @AuraEnabled
    public static ADBEpmpAlertsResponseWrapper callEpmpAlertsAPI(String memberId,String memDob,String memFirstName, String memLastName, String memberPolicy){
        ADBEpmpAlertsResponseWrapper uiWrapper = new ADBEpmpAlertsResponseWrapper();
        try {
            uiWrapper = ADBEpmpPreferenceService.callEpmpAlertsService(memberId, memFirstName, memLastName, memDob, memberPolicy);
        } catch(Exception ex) {
            System.debug('ERROR : ADBCallerProfileController.callEpmpPreferenceAPI() : ' + ex.getMessage());
            uiWrapper.responseCode = '500';
            uiWrapper.responseMsg = ex.getMessage();
        }
        return uiWrapper;
    }

    //US3245061 - to fetch the Find individual response to extract SSN for financial and other necessary cards
    @AuraEnabled
    public static FIMResultWrapper callFIMService(String memId, String dob) {
        FIMResultWrapper wr;
        try{
            wr = ADBFIMWebservice.findIndWs(memId, dob);
        }catch(Exception e){
            System.debug('ERROR at ADBDashboardParentController.callFIMService : ' + e.getMessage());
        }
        return wr;
    }
	 @AuraEnabled
    public static ADBCallerProfilePopupDetailsWrapper getCallerPopupDetails(String memberId, String memberDob, String firstName,String lastName,String groupNumber){
        
        // defining wrapper to hold the Response
        ADBEligibilityResponseWrapper responseWrapper = new ADBEligibilityResponseWrapper();
        ADBCallerProfilePopupDetailsWrapper popupWrapper = new ADBCallerProfilePopupDetailsWrapper();
        try {
            // get response from the web service
            responseWrapper = ADBEligibilityService.getEligibilityV2Response(memberId, memberDob, firstName, lastName, groupNumber);
            if(responseWrapper != null){
                Integer dateDiff = 0;
                boolean futurePolicyFound = false;
                for(ADBEligibilityResponseWrapper.memberPolicies policies : responseWrapper.MemberPolicies){
                    // getting the values from response and setting them to wrapper
                    if(policies != null && policies.policyInfo !=null && policies.policyInfo.policyStatus == ACTIVE_POLICY){
                        system.debug('member policies :::'+ policies); 
                        if(policies.patientInfo != null){
                            for(ADBEligibilityResponseWrapper.patientInfo ptinfo: policies.patientInfo) {
                                popupWrapper.memberFirstName = ptinfo.firstName;
                                popupWrapper.memberLastName = ptinfo.lastName;
                                popupWrapper.gender = ptinfo.gender;
                                popupWrapper.MemberDOB = ptinfo.dateOfBirth;
                                popupWrapper.city = ptinfo.city;
                                popupWrapper.zip = ptinfo.zip;
                                popupWrapper.state = ptinfo.state;
                                popupWrapper.addressLine1 = ptinfo.addressLine1;
                                popupWrapper.addressLine2 = ptinfo.addressLine2;
                            } 
                        }
                        popupWrapper.transactionId = policies.transactionId;
                        popupWrapper.planName = policies.insuranceInfo.planDescription;
                        popupWrapper.insuranceType = policies.insuranceInfo.insuranceType; 
                        popupWrapper.groupNumber = policies.insuranceInfo.groupNumber;
                        popupWrapper.payerName = policies.insuranceInfo.payerName;
                        popupWrapper.coverageType = policies.policyInfo.coverageType;
                        popupWrapper.memberId = policies.policyInfo.memberId;
                        popupWrapper.policyStatus = policies.policyInfo.policyStatus;
                        popupWrapper.effectiveDate = policies.policyInfo.planDates.startDate;
                        popupWrapper.endDate = policies.policyInfo.planDates.endDate;  
                        date eDate = date.valueof(policies.policyInfo.planDates.endDate);
                        system.debug('Policy end date active policy'+ eDate);
                        if(eDate < Date.today() && eDate!=null){
                            popupWrapper.errorMessage = 'terminated'; 
                            system.debug('error message message '+ popupWrapper.errorMessage);
                        }
                        popupWrapper.physicianFirstName = policies.primaryCarePhysicianInfo.firstName;
                        popupWrapper.physicianLastName = policies.primaryCarePhysicianInfo.lastName;    
                        
                        if(policies.outOfPocketInfo != null && policies.outOfPocketInfo.individual != null){
                            popupWrapper.found = policies.outOfPocketInfo.individual.inNetworkTier1.found;     
                            popupWrapper.inMetYtdAmount = policies.outOfPocketInfo.individual.inNetwork.metYtdAmount; 
                            popupWrapper.outMetYtdAmount = policies.outOfPocketInfo.individual.outOfNetwork.metYtdAmount;  
                            popupWrapper.preMetYtdAmount = policies.outOfPocketInfo.individual.inNetworkTier1.metYtdAmount; 
                        }
                        break;
                    }
                      else if(policies != null && policies.policyInfo !=null && policies.policyInfo.policyStatus == FUTURE_POLICY){
                        system.debug('member policies :::'+ policies); 
                        if(policies.patientInfo != null){
                            for(ADBEligibilityResponseWrapper.patientInfo ptinfo: policies.patientInfo) {
                                popupWrapper.memberFirstName = ptinfo.firstName;
                                popupWrapper.memberLastName = ptinfo.lastName;
                                popupWrapper.gender = ptinfo.gender;
                                popupWrapper.MemberDOB = ptinfo.dateOfBirth;
                                popupWrapper.city = ptinfo.city;
                                popupWrapper.zip = ptinfo.zip;
                                popupWrapper.state = ptinfo.state;
                                popupWrapper.addressLine1 = ptinfo.addressLine1;
                                popupWrapper.addressLine2 = ptinfo.addressLine2;
                            } 
                        }
                        popupWrapper.transactionId = policies.transactionId;
                        popupWrapper.planName = policies.insuranceInfo.planDescription;
                        popupWrapper.insuranceType = policies.insuranceInfo.insuranceType; 
                        popupWrapper.groupNumber = policies.insuranceInfo.groupNumber;
                        popupWrapper.payerName = policies.insuranceInfo.payerName;
                        popupWrapper.coverageType = policies.policyInfo.coverageType;
                        popupWrapper.memberId = policies.policyInfo.memberId;
                        popupWrapper.policyStatus = policies.policyInfo.policyStatus;
                        popupWrapper.effectiveDate = policies.policyInfo.planDates.startDate;
                        popupWrapper.endDate = policies.policyInfo.planDates.endDate;  
                          date eDate = date.valueof(policies.policyInfo.planDates.endDate);
                          system.debug('Policy end date '+ eDate);
                          if(eDate < Date.today() && eDate!=null){
                              popupWrapper.errorMessage = 'terminated'; 
                              system.debug('error message message '+ popupWrapper.errorMessage);
                          }
                        popupWrapper.physicianFirstName = policies.primaryCarePhysicianInfo.firstName;
                        popupWrapper.physicianLastName = policies.primaryCarePhysicianInfo.lastName;    
                        
                        if(policies.outOfPocketInfo != null && policies.outOfPocketInfo.individual != null){
                            popupWrapper.found = policies.outOfPocketInfo.individual.inNetworkTier1.found;     
                            popupWrapper.inMetYtdAmount = policies.outOfPocketInfo.individual.inNetwork.metYtdAmount; 
                            popupWrapper.outMetYtdAmount = policies.outOfPocketInfo.individual.outOfNetwork.metYtdAmount;  
                            popupWrapper.preMetYtdAmount = policies.outOfPocketInfo.individual.inNetworkTier1.metYtdAmount; 
                        }
                         futurePolicyFound = true;
                    }
					else if(policies != null && policies.policyInfo !=null && policies.policyInfo.policyStatus == PAST_POLICY
                           && (!futurePolicyFound)){
						Date endDt = Date.valueOf(policies.policyInfo.planDates.endDate);
                    	Date today =Date.today();
						Integer dateDiffTemp = endDt.daysBetween(today);
                        if(dateDiff == 0 || dateDiffTemp < dateDiff ){
                            dateDiff = dateDiffTemp;
                        system.debug('member policies in PAST Policy:::'+ policies); 
                        if(policies.patientInfo != null){
                            for(ADBEligibilityResponseWrapper.patientInfo ptinfo: policies.patientInfo) {
                                popupWrapper.memberFirstName = ptinfo.firstName;
                                popupWrapper.memberLastName = ptinfo.lastName;
                                popupWrapper.gender = ptinfo.gender;
                                popupWrapper.MemberDOB = ptinfo.dateOfBirth;
                                popupWrapper.city = ptinfo.city;
                                popupWrapper.zip = ptinfo.zip;
                                popupWrapper.state = ptinfo.state;
                                popupWrapper.addressLine1 = ptinfo.addressLine1;
                                popupWrapper.addressLine2 = ptinfo.addressLine2;
                            } 
                        }
                        popupWrapper.transactionId = policies.transactionId;
                        popupWrapper.planName = policies.insuranceInfo.planDescription;
                        popupWrapper.insuranceType = policies.insuranceInfo.insuranceType; 
                        popupWrapper.groupNumber = policies.insuranceInfo.groupNumber;
                        popupWrapper.payerName = policies.insuranceInfo.payerName;
                        popupWrapper.coverageType = policies.policyInfo.coverageType;
                        popupWrapper.memberId = policies.policyInfo.memberId;
                        popupWrapper.policyStatus = policies.policyInfo.policyStatus;
				        popupWrapper.effectiveDate = policies.policyInfo.planDates.startDate;
                        popupWrapper.endDate = policies.policyInfo.planDates.endDate; 
                        date eDate = date.valueof(policies.policyInfo.planDates.endDate);
                        system.debug('Policy end date '+ eDate);
                        if(eDate < Date.today() && eDate!=null){
                             popupWrapper.errorMessage = 'terminated'; 
                             system.debug('error message message '+ popupWrapper.errorMessage);
                        }
				        popupWrapper.physicianFirstName = policies.primaryCarePhysicianInfo.firstName;
                        popupWrapper.physicianLastName = policies.primaryCarePhysicianInfo.lastName;    
                        
                        if(policies.outOfPocketInfo != null && policies.outOfPocketInfo.individual != null){
                            popupWrapper.found = policies.outOfPocketInfo.individual.inNetworkTier1.found;     
                            popupWrapper.inMetYtdAmount = policies.outOfPocketInfo.individual.inNetwork.metYtdAmount; 
                            popupWrapper.outMetYtdAmount = policies.outOfPocketInfo.individual.outOfNetwork.metYtdAmount;  
                            popupWrapper.preMetYtdAmount = policies.outOfPocketInfo.individual.inNetworkTier1.metYtdAmount; 
                        } 
                    } 
                    } 
                }
            }
        } catch(Exception ex) {
            system.debug('ERROR : ADBOpportunityCardWrapper.getOpportunities() : ' + ex.getMessage()); 
        }
        return popupWrapper;        
    }	
}