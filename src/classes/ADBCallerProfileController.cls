/**
* Author: Hasara Disanayaka
* Description : Used by both CallerProfileComponent and SubjectProfileComponent
* AuraEnabled : 
* Date Created: 11/27/2019
*/ 
public without sharing class ADBCallerProfileController { 
    final static String ACTIVE_POLICY = 'Active Policy';
	final static String FUTURE_POLICY = 'Future Policy';
    final static String PAST_POLICY = 'Past Policy';													
	//  Constant Request parameter values Select Issue Service
    final static String ACTOR = 'ACET';
    final static String UPDATED_SUCCESSFUL = 'Individual information successfully updated';
    final static String PREF_ALRDY_UPDTD = 'This preference was already indicated. No update is required';
    final static String GAN_UPDATED_PENDING = 'Pending status updated Successfully for GAN';
 
 // Get data for member eligibility sub card from eligibility extended web service 
    @AuraEnabled
    public static ADBEligibilityExtendedRequestWrapper getMemberInfo(String memberId, String memberDob,String transactionId){
        // defining wrapper to hold the Response
        ADBEligibilityExtendedResponseWrapper response = new ADBEligibilityExtendedResponseWrapper();
        ADBEligibilityExtendedRequestWrapper memberInfoWrapper = new ADBEligibilityExtendedRequestWrapper();
        try {
            response = ADBEligibilityService.getExtendedEligibilities(transactionId,memberId,memberDob);
            system.debug('response :::'+ response);
            if(response != null){
                // Mapping Subcriber details from response 
                if(response.MemberInfo != null){
                    memberInfoWrapper.relationship = response.MemberInfo.relationship; 
                    memberInfoWrapper.firstName = response.MemberInfo.firstName; 
                    memberInfoWrapper.lastName =  response.MemberInfo.lastName;
                    memberInfoWrapper.dob =  response.MemberInfo.dob;
                }
                
                // Mapping Mailing Address from response 
                if(response.PostalAddress != null){
                    memberInfoWrapper.city = response.PostalAddress.city;
                    memberInfoWrapper.zip = response.PostalAddress.zip;
                    memberInfoWrapper.state = response.PostalAddress.state;
                    memberInfoWrapper.street1 = response.PostalAddress.street1;
                    memberInfoWrapper.street2 = response.PostalAddress.street2;
                }
                // Mapping Dependents details from response 
                memberInfoWrapper.member = new List<ADBEligibilityExtendedRequestWrapper.Member>();
                Integer i = 0;
                if(response.memberInfo.members != null){
                    for(i=0; i < response.memberInfo.members.size(); i++){
                        ADBEligibilityExtendedRequestWrapper.Member tempMember = new ADBEligibilityExtendedRequestWrapper.Member();
                        tempMember.memRelationship = response.memberInfo.members[i].relationship;
                        tempMember.memFirstName = response.memberInfo.members[i].firstName;
                        tempMember.memLastName = response.memberInfo.members[i].lastName;
                        tempMember.memDob = response.memberInfo.members[i].dob;
                        memberInfoWrapper.member.add(tempMember);
                    }    
                }
            }   
        } catch(Exception ex) {
            system.debug('ERROR : ADBEligibilityExtendedResponseWrapper.getMemberInfo() : ' + ex.getMessage()); 
        }
        return memberInfoWrapper;        
    } 
    
    // Get data for member eligibility sub card from Language Preference web service 
    @AuraEnabled
    public static ADBEligibilityExtendedRequestWrapper getlanguagePreference(String memberId, String memberDob,String transactionId){
        // defining wrapper to hold the Response
        ADBLanguagePreferenceResponseWrapper response = new ADBLanguagePreferenceResponseWrapper();
        ADBEligibilityExtendedRequestWrapper memberInfoWrapper = new ADBEligibilityExtendedRequestWrapper();
        try {
            response = ADBEligibilityService.getLanguagePreference(transactionId,memberId);
            system.debug('response :::'+ response);
            if(response != null){
                // Mapping prefence language details from response 
                if(response.Attributes != null){
                    memberInfoWrapper.verbalLanguagePreference = response.Attributes.verbalLanguagePreference; 
                }
            }   
        } catch(Exception ex) {
            system.debug('line : ' + ex.getLineNumber());
            system.debug('ERROR : ADBEligibilityExtendedResponseWrapper.getlanguagePreference() : ' + ex.getMessage()); 
        }
        return memberInfoWrapper;        
    } 
    
    // method to get epmp service details: US2368815 - sunil vennam 
    @AuraEnabled
    public static ADBEpmpPreferenceResponseWrapper callEpmpPreferenceAPI(String memberId,String memDob,String memFirstName, String memLastName, String memberPolicy){
        ADBEpmpPreferenceResponseWrapper uiWrapper = new ADBEpmpPreferenceResponseWrapper();
        String phone = '';
        try {
            uiWrapper = ADBEpmpPreferenceService.callEpmpPreferenceService(memberId, memFirstName, memLastName, memDob, memberPolicy);
            ADBEpmpPreferenceResponseWrapper.prefs pref = new ADBEpmpPreferenceResponseWrapper.prefs(); 
            List<ADBEpmpPreferenceResponseWrapper.prefs> prefs = new List<ADBEpmpPreferenceResponseWrapper.prefs>();
            if(uiWrapper!=null){
                // logic to set phone 
                if(uiWrapper.contactInfo!=null && uiWrapper.contactInfo.telephones!=null){
                    for(ADBEpmpPreferenceResponseWrapper.telephones phones : uiWrapper.contactInfo.telephones){
                        if(phones.communicationTypeDescription!=null && phones.communicationTypeDescription.text!=null && phones.communicationTypeDescription.text=='Mobile'){
                            if(phones.telephoneNumber!=null){
                                String pNumber = phones.telephoneNumber;
                                phone = '('+pNumber.substring(0, 3)+')'+pNumber.substring(3, 6)+'-'+pNumber.substring(6, 10);
                                uiWrapper.phone = phone;
                            }
                        }
                        if(phones.communicationTypeDescription!=null && phones.communicationTypeDescription.text!=null && phones.communicationTypeDescription.text=='Global activation number'){
                            if(phones.telephoneNumber!=null){
                                if(phones.renderingAttributesType != null && phones.renderingAttributesType.activationStatus=='activated'){
                                    uiWrapper.ganActivationStatus = 'Enrolled';
                                }
                            }else{
                                uiWrapper.ganActivationStatus = 'Not Enrolled';
                            }
                        }
                    }
                }
                // logic to set email address 
                if(uiWrapper.contactInfo!=null && uiWrapper.contactInfo.electronicContacts!=null){
                    for(ADBEpmpPreferenceResponseWrapper.electronicContacts contacts : uiWrapper.contactInfo.electronicContacts){
                        if(contacts!=null && contacts.primaryElectronicAddressIndicator!=null && contacts.primaryElectronicAddressIndicator == 'Y'){
                            uiWrapper.email_Address =  contacts.electronicAddress==null ? '' : contacts.electronicAddress;
                        }
                    }
                }
                // logic to set communication preference 
                if(uiWrapper.preferences!=null && uiWrapper.preferences.preferenceCategories!=null){
                    for(ADBEpmpPreferenceResponseWrapper.preferenceCategories prefcategories : uiWrapper.preferences.preferenceCategories){
			            if(prefcategories!=null && prefcategories.name!=null && prefcategories.name == 'Notifications_and_Reminders' && prefcategories.preferenceCategories !=null){
                            for(ADBEpmpPreferenceResponseWrapper.preferenceCategories prefcat : prefcategories.preferenceCategories){
                                if(prefcat!=null && prefcat.consumerPreferenceTypes!=null && prefcat.name!='Global_Opt_Into_SMS'){
                            		for(ADBEpmpPreferenceResponseWrapper.consumerPreferenceTypes consumerTypes : prefcat.consumerPreferenceTypes){
                                        pref = new ADBEpmpPreferenceResponseWrapper.prefs();
                                        pref.category = prefcat.name;
                                        pref.name = consumerTypes.name;
                                        pref.value = 'TM';
                                        prefs.add(pref);
                                    }
                                }
                            }
                        }
                        if(prefcategories!=null && prefcategories.consumerPreferenceTypes!=null && prefcategories.name!=null && prefcategories.name == 'Paperless_Settings'){
                            for(ADBEpmpPreferenceResponseWrapper.consumerPreferenceTypes consumerTypes : prefcategories.consumerPreferenceTypes){
                                if(consumerTypes!=null && consumerTypes.properties!=null && consumerTypes.name!=null && consumerTypes.name == 'Required_documents'){
                                    for(ADBEpmpPreferenceResponseWrapper.properties props : consumerTypes.properties){
                                        if(props!=null && props.name!=null && props.name == 'Document_Delivery_Channel'){
                                            for(ADBEpmpPreferenceResponseWrapper.listValues vals: props.listValues){
                                                if(vals.code!=null && vals.code == 'EM' && vals.selected!=null && vals.selected == true){
                                                    uiWrapper.communication_Preference = 'Paperless';
                                                }
                                                else if(vals.code!=null && vals.code == 'PM' && vals.selected!=null && vals.selected == true){
                                                    uiWrapper.communication_Preference = 'Mail';
                                                }
                                                else if(vals.code!=null && vals.code == 'EM' && vals.selected!=null && vals.selected == false && vals.code == 'EM' && vals.selected == false && vals.isDefaultValue!=null && vals.isDefaultValue == true){
                                                    uiWrapper.communication_Preference = 'Mail';   
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    uiWrapper.prefs = prefs;
                }
            }
        } catch(Exception ex) {
            System.debug('ERROR : ADBCallerProfileController.callEpmpPreferenceAPI() : ' + ex.getMessage());
            uiWrapper.responseCode = '500';
            uiWrapper.responseMsg = ex.getMessage();
        }
        return uiWrapper;
    }
    @AuraEnabled
    public static ADBPHIContactRequestWrapper getPHIContacts(String userID, String cdxRefId){
        ADBPHIContactRequestWrapper requestWrapper = new ADBPHIContactRequestWrapper();
        HttpResponse response;
        try{
            requestWrapper.memberDetailRequest  = new ADBPHIContactRequestWrapper.MemberDetailRequest();
            requestWrapper.memberDetailRequest.requestHeader  = new ADBPHIContactRequestWrapper.RequestHeader();
            requestWrapper.memberDetailRequest.icueUserCDxRefIdentifierType  = new ADBPHIContactRequestWrapper.IcueUserCDxRefIdentifierType();
            requestWrapper.memberDetailRequest.requestHeader.userID = userID;
            requestWrapper.memberDetailRequest.requestHeader.applicationName = ACTOR;
            requestWrapper.memberDetailRequest.icueUserCDxRefIdentifierType.cdxRefId = cdxRefId;
            system.debug('CallerProfileController.getPHIContacts requestWrapper ::: '+ requestWrapper);
            String serializedBody = JSON.serialize(requestWrapper);
            system.debug('CallerProfileController.getPHIContacts serializedBody ::: '+ serializedBody);
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBPHIContactEndpoint', serializedBody,null);
            response = wsCallOutFW.getResponse();
            system.debug('PHI Contact-response ::' +response);
            if(response.getStatusCode() == 200){
                requestWrapper.member = new List<ADBPHIContactRequestWrapper.Member>();
                //  Handling the single vs list of memberContacts response format
                String res = response.getBody();
                Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(res);
                System.debug('result : ' + responseMap);
                Map<String, Object> memberResponse = (Map<String, Object>)responseMap.get('memberContactsResponse');
                System.debug('mem : ' + memberResponse.get('memberContacts'));
                Boolean isList = (memberResponse.get('memberContacts') instanceof List<Object>);
                if(isList){
                    ADBPHIContactResponseWrapper listContact = (ADBPHIContactResponseWrapper)JSON.deserialize(res, ADBPHIContactResponseWrapper.class);
                    for(Integer i=0; i < listContact.memberContactsResponse.memberContacts.size(); i++){
                        ADBPHIContactRequestWrapper.Member tempMember = new ADBPHIContactRequestWrapper.Member();
                        tempMember.memFirstName = listContact.memberContactsResponse.memberContacts[i].firstName;
                        tempMember.memLastName = listContact.memberContactsResponse.memberContacts[i].lastName;
                        requestWrapper.member.add(tempMember);
                    }
                }else{
                    res = res.replace('"memberContacts"', '"singleMemberContact"');
                    ADBPHIContactResponseWrapper memberContact = (ADBPHIContactResponseWrapper)JSON.deserialize(res, ADBPHIContactResponseWrapper.class);
                    System.debug('singleObject : ' + memberContact);
                    ADBPHIContactRequestWrapper.Member tempMember = new ADBPHIContactRequestWrapper.Member();
                    tempMember.memFirstName = memberContact.memberContactsResponse.singleMemberContact.firstName;
                    tempMember.memLastName = memberContact.memberContactsResponse.singleMemberContact.lastName;
                    requestWrapper.member.add(tempMember);
                }
            }else{
                system.debug('CallerProfileController.getPHIContacts Error ::' + response.getStatusCode() +'-'+ response.getBody());
            }
        }catch(Exception ex){
            system.debug('CallerProfileController.getPHIContacts Exception ::' + ex.getMessage());
        }
        return requestWrapper;
    }
    // Open PHI url logic - US2781361 : Sunil Vennam
    @AuraEnabled
    public static String getPHIUrl(String xrefId, String userId){
        String phiSSOURL = 'cdbXrefID='+xrefId+'&applicationId=ACET&isOffers=true&landingPage=secondaryContact';
        String redirectUrl = ADBICUESSOUtilController.generateRedirectUrl( '', '', '', '',  '', userId, '', phiSSOURL, '', '');
        
        return redirectUrl; 
    }
    @AuraEnabled
    public static String getcoverageICUEHomeUrl(String cdbXrefId,String userId){
        String icueHomeUrl = '';
        List<ADBIcueSsoApiUrlParams__mdt> urlParams = [SELECT URL__c  
                                                       FROM ADBIcueSsoApiUrlParams__mdt WHERE MasterLabel = 'CoverageHistoryurl'];
        if(urlParams != null && !urlParams.isEmpty()){
            String prefilledUrl = urlParams[0].URL__c;
            System.debug('prefilledUrl'+prefilledUrl);
            List<String> fillers = new String[]{cdbXrefId};    
                prefilledUrl = String.format(prefilledUrl, fillers);  
            icueHomeUrl = ADBICUESSOUtilController.generateUrlWithParams(prefilledUrl,userId);
            return icueHomeUrl;
        }
        return icueHomeUrl;
    }
    

    @AuraEnabled
    public static String saveEpmpMail(String reqObj){
        system.debug('reqObj'+reqObj);
        ADBEpmpMailSaveRequestWrapper er = (ADBEpmpMailSaveRequestWrapper) JSON.deserialize(reqObj, ADBEpmpMailSaveRequestWrapper.class);
        String returnMsg = '';
        er.calling_app_name = 'ACET';
        er.user_type = 'Agent';
        try{
            String serializedBody = JSON.serialize(er);
            system.debug('serializedBody'+serializedBody);
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBEpmpSaveEMailEndpoint', serializedBody, null);
            HttpResponse response = wsCallOutFW.getResponse();
            if(response.getStatusCode() == 200 || response.getStatusCode() == 400) {
                system.debug('response for epmp save mail'+response.getBody());
                er = (ADBEpmpMailSaveRequestWrapper) JSON.deserialize(response.getBody(), ADBEpmpMailSaveRequestWrapper.class);
                if(er.status != null && er.status.messages != null && er.status.messages.message[0] != null){
                    if(er.status.messages.message[0].code == '200' 
                       && er.status.messages.message[0].description == UPDATED_SUCCESSFUL){
                           returnMsg = UPDATED_SUCCESSFUL;
                       }else if(er.status.messages.message[0].code == '400' 
                                && er.status.messages.message[0].description != ''){
                                    returnMsg = er.status.messages.message[0].description;
                                }
                }
            }else{
                system.debug('EPMP Save Mail Address Service Response code && Response body if not 200 ::' + response.getStatusCode() +'-'+ response.getBody());
            }
        }catch(Exception e){
            system.debug('EPMP Save Mail Address Service Exception ::' + e.getMessage());
        }
        return returnMsg;
    }
    
    @AuraEnabled
    public static String saveEpmpCommunctnPreference(String reqObj){
        system.debug('reqObj'+reqObj);
        ADBEpmpCommPreferenceRequestWrapper rw = (ADBEpmpCommPreferenceRequestWrapper) JSON.deserialize(reqObj, ADBEpmpCommPreferenceRequestWrapper.class);
        String returnMsg = '';
        rw.calling_app_name = 'ACET';
        rw.user_type = 'Agent';
        rw.electronicConsentID = 'Regulatory_notices';
        rw.mpConsentID = 'Marketing_Promotional_ConsentId';
        try{
            String serializedBody = JSON.serialize(rw);
            system.debug('serializedBody'+serializedBody);
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBEpmpSaveCommPrefEndpoint', serializedBody,null);
            HttpResponse response = wsCallOutFW.getResponse();
            // Checking the status code is success
            if(response.getStatusCode() == 200 || response.getStatusCode() == 400){
                system.debug('response for epmp save Communication Preference'+response.getBody());
                rw = (ADBEpmpCommPreferenceRequestWrapper) JSON.deserialize(response.getBody(), ADBEpmpCommPreferenceRequestWrapper.class);
                system.debug('respWrapper'+rw);
                if(rw.status != null && rw.status.messages != null && rw.status.messages.message[0] != null){
                    if(rw.status.messages.message[0].code == '200' 
                       && rw.status.messages.message[0].description == UPDATED_SUCCESSFUL){
                           returnMsg = UPDATED_SUCCESSFUL;
                       }else if(rw.status.messages.message[0].code == '200' 
                                && rw.status.messages.message[0].description == PREF_ALRDY_UPDTD){
                                    returnMsg = PREF_ALRDY_UPDTD;
                                }else if(rw.status.messages.message[0].code == '400' 
                                         && rw.status.messages.message[0].description != ''){
                                             returnMsg = rw.status.messages.message[0].description;
                                         }
                }
            }else{
                system.debug('EPMP Save Communication Preference Service Response code && Response body if not 200 ::' + response.getStatusCode() +'-'+ response.getBody());
            }
        }catch(Exception e){
            system.debug('EPMP Save Communication Preference Service Exception ::' + e.getMessage());
        }
        return returnMsg;
    }
    
    @AuraEnabled
    public static String saveEpmpPhoneNumber(String memberId, String memDob , String memFirstName,String memLastName,String memberPolicy, String userID, String telephoneNumber){
        ADBEpmpPhoneRequestWrapper rw = new ADBEpmpPhoneRequestWrapper();
        String returnMsg = '';
        rw.first_nm = memFirstName;
        rw.lst_nm = memLastName;
        rw.policy_nbr = memberPolicy;
        rw.user_id = userID;
        rw.subscriber_id = memberId;
        rw.dob = memDob;
        rw.calling_app_name = 'ACET';
        rw.user_type = 'Onboarding';
        rw.phoneTypeCode = '4';
        rw.phoneTypeCodeDesc = 'Mobile';
        rw.telephoneNumber = telephoneNumber;
        try{
            String serializedBody = JSON.serialize(rw);
            system.debug('serializedBody'+serializedBody);
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBEpmpSavePhoneEndpoint', serializedBody,null);
            HttpResponse response = wsCallOutFW.getResponse();
            // Checking the status code is success
            if(response.getStatusCode() == 200 || response.getStatusCode() == 400){
                system.debug('response for epmp save phone'+response.getBody());
                rw = (ADBEpmpPhoneRequestWrapper) JSON.deserialize(response.getBody(), ADBEpmpPhoneRequestWrapper.class);
                if(rw.status != null && rw.status.messages != null && rw.status.messages.message[0] != null){
                    if(rw.status.messages.message[0].code == '200' 
                       && rw.status.messages.message[0].description == UPDATED_SUCCESSFUL){
                           returnMsg = UPDATED_SUCCESSFUL;
                       }else if(rw.status.messages.message[0].code == '400' 
                                && rw.status.messages.message[0].description != ''){
                                    returnMsg = rw.status.messages.message[0].description;
                                }
                }
            }else{
                system.debug('EPMP Save Phone Response code && Response body if not 200 ::' + response.getStatusCode() +'-'+ response.getBody());
            }
        }catch(Exception e){
            system.debug('EPMP Save Phone Service Exception ::' + e.getMessage());
        }
        return returnMsg;
    }
    
    public class EPMPUrlRequest{
        public String subscriberId;
        public String firstName;
        public String lastName;
        public String dob;
        public String userId;
        public String policy;
        public String landingPage;
    }
    
    // EPMP method:- Nadeem 
    @AuraEnabled
    public static String getEPMPSSOUrl (String memberId, String userId, String firstname, String lastname, String memberDob, String policy, String selectedLink){
        String landingPage = '';
		
		if(selectedLink == 'Email' || selectedLink == 'MobilePhone'){
			landingPage = 'contact';
		}else if(selectedLink == 'CommPref'){
			landingPage = '';
		}
        String baseURL = '';
        EPMPUrlRequest ic = new EPMPUrlRequest();
        ic.subscriberId = memberId;
        ic.firstName = firstname;
        ic.lastName = lastname;
        ic.dob = cleanDate(memberDob);
        ic.policy = policy; 
        ic.userId = userId;
        ic.landingPage =  landingPage;
        String serializedBody = JSON.serialize(ic);
        baseURL = ADBICUESSOUtilController.getBaseUrl(serializedBody, 'ADBCommPrefEPMPUrlEndpoint');
        return baseURL;
    }
    
    public static String cleanDate(String theDate){
        String [] s = theDate.split('/');
        String newDate= '';
        String newMonth= '';
        String newDay= '';
        if(s[0].length() == 1){
            newMonth = '0'+s[0];
        }else{
            newMonth = s[0];
        }
        if(s[1].length() == 1){
            newDay = '0'+s[1];
        }else{
            newDay = s[1];
        }
        newDate = s[2]+'-'+newMonth+'-'+newDay;
        return newDate;
    }
    
    @AuraEnabled
    public static String saveEpmpPhoneNumberGAN(String reqObj){
        system.debug('reqObj'+reqObj);
        ADBEpmpSavePhoneNumberGAN rw = (ADBEpmpSavePhoneNumberGAN) JSON.deserialize(reqObj, ADBEpmpSavePhoneNumberGAN.class);        
        String returnMsg = '';
        rw.c360Identifier = '';
        rw.activationCode = 'activate';
        rw.role = 'Member';
        rw.user_type = 'Member';
        rw.user_id = 'ACET';
        rw.calling_app_name = 'ACET';
        
        try{
            String serializedBody = JSON.serialize(rw);
            system.debug('serializedBody'+serializedBody);
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBEpmpGANUpdateEndpoint', serializedBody,null);
            HttpResponse response = wsCallOutFW.getResponse();
            // Checking the status code is success
            if(response.getStatusCode() == 200 || response.getStatusCode() == 400){
                system.debug('response for epmp save Phone Number GAN'+response.getBody());
                rw = (ADBEpmpSavePhoneNumberGAN) JSON.deserialize(response.getBody(), ADBEpmpSavePhoneNumberGAN.class);
                system.debug('respWrapper'+rw);
                if(rw.status != null && rw.status.messages != null && rw.status.messages.message[0] != null){
                    if(rw.status.messages.message[0].code == '200' 
                       && (rw.status.messages.message[0].description == GAN_UPDATED_PENDING 
                           || rw.status.messages.message[0].description == 'Pre-Activated Successfully for GAN')){
                           returnMsg = rw.status.messages.message[0].description;
                       }else{
                           returnMsg =  rw.status.messages.message[0].description;
                       }
                }
            }else{
                system.debug('EPMP Save Phone GAN Service Response code && Response body if not 200 ::' + response.getStatusCode() +'-'+ response.getBody());
            }
        }catch(Exception e){
            system.debug('EPMP Save GAN Service Exception ::' + e.getMessage());
        }
        return returnMsg;
    }
    
    @AuraEnabled
    public static String updateSelectionsAPI(String reqObj){
        system.debug('reqObj in updateSelectionsAPI'+reqObj);
        ADBEpmpSelectionsReqWrapper rw = (ADBEpmpSelectionsReqWrapper) JSON.deserialize(reqObj, ADBEpmpSelectionsReqWrapper.class);        
        String returnMsg = '';
        rw.user_type = 'Agent';
        rw.user_id = 'ACET';
        rw.calling_app_name = 'ACET';
        
        try{
            String serializedBody = JSON.serialize(rw);
            system.debug('serializedBody'+serializedBody);
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBEpmpSelectionsEndpoint', serializedBody,null);
            HttpResponse response = wsCallOutFW.getResponse();
            // Checking the status code is success
            if(response.getStatusCode() == 200 || response.getStatusCode() == 400) {
                system.debug('response for epmp selections api'+response.getBody());
                rw = (ADBEpmpSelectionsReqWrapper) JSON.deserialize(response.getBody(), ADBEpmpSelectionsReqWrapper.class);
                system.debug('respWrapper'+rw);
                if(rw.status != null && rw.status.messages != null && rw.status.messages.message[0] != null){
                    if(rw.status.messages.message[0].code == '200' 
                       && rw.status.messages.message[0].description == UPDATED_SUCCESSFUL){
                           returnMsg = UPDATED_SUCCESSFUL;
                       }else{
                           returnMsg = rw.status.messages.message[0].description;
                       }
                }
            }else{
                system.debug('EPMP Selections API Response code && Response body if not 200 ::' + response.getStatusCode() +'-'+ response.getBody());
            }
        }catch(Exception e){
            system.debug('EPMP Selections API Exception ::' + e.getMessage());
        }
        return returnMsg;
    }
    
    @AuraEnabled public static String getCurrentCall(String callStatus){
        String currentCallValue;
        if(!String.isBlank(callStatus)){
            try {
                List<ADB_Current_Call__mdt> callValue = [SELECT Description__c FROM ADB_Current_Call__mdt WHERE Label =: callStatus];
                if(callValue.size() > 0){
                    currentCallValue = callValue[0].Description__c;
                }
            }catch(Exception e){
                system.debug('ADBCallerProfileController.getCurrentCall Exception ::' + e.getMessage());
            }
            if(currentCallValue != null){
                return currentCallValue;
            }else{
                return callStatus;
            }
        }else{
            return callStatus; 
        }
    }
}