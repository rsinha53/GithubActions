/**
* Author: Madhura Priyadarshana
* Description : service class for 
* AuraEnabled : False
* Created Date : 21 August 2019
*/
public with sharing class ADBOpportunityWebService {
    
    //  Constant Request parameter values
    final static String AUDIENCE_LEVEL = 'MDM_PERSON';
    final static String AUDIENCE_KEY_DATA_TYPE = 'string';
    final static String INTERACTIVE_CHANNEL_NAME = 'OGM_NBA_IC';
    final static String INT_POINT = 'Action_Items';
    final static String EVENT_NAME = 'contact'; //  or 'Reference'
    final static String OPPORTUNITY_TYPE_CD = 'ALL';
    final static String APPLICATION_ID = 'ACETDASHBOARD';
    
    final static String ACCOUNT_ID = '157205';// Only needed for Optum RX
    final static String CARRIER_ID = 'IBCFOCCOM'; // Only needed for Optum RX
    final static String DEDUPLICATIONPOLCIY = '1';
    final static String GROUP_ID = '10049517';// Only needed for Optum RX
    final static String MEMBER_ID_TYPE;
    final static String NUMBER_OF_OFFERS;
    
    
    //  Constant Offer category names
    final static String CLINICAL_PROGRAMS = 'Clinical Programs';
    final static String COST_SAVING_FINANCIAL = 'Cost Saving/Financial';
    final static String HEALTH_AND_WELLNESS = 'Health and Wellness';
    final static String PHARMACY = 'Pharmacy';
    
    // Constant save request parameter values
    final static String STATUS_REASON_CODE = 'CLinApp';
    
    public static ADBOpportunityCardWrapper getOpportunities(ADBOpportunityRequestWrapper request) {
        ADBOpportunityCardWrapper wrapper = new ADBOpportunityCardWrapper();
        request.accountId = ACCOUNT_ID;   // '157205' need to be set from request
        request.applicationId = APPLICATION_ID;
        request.audienceKeyDataType = AUDIENCE_KEY_DATA_TYPE;
        request.audienceLevel = AUDIENCE_LEVEL;
        request.carrierId = CARRIER_ID;    // 'IBCFOCCOM' need to be set from request
        request.deduplicationPolicy = DEDUPLICATIONPOLCIY;  //'1'  need to be set from request
        request.eventName = EVENT_NAME;
        request.groupId = GROUP_ID;   //'10049517'  need to be set from request
        request.interactiveChannelName = INTERACTIVE_CHANNEL_NAME;
        request.intPoint = INT_POINT;
        //request.memberIdType = MEMBER_ID_TYPE;   // 'CDB_XREF_ID' need to be set from request
        //request.numberOfOffers = NUMBER_OF_OFFERS;  //'10'  need to be set from request
        request.opportunityTypeCd = OPPORTUNITY_TYPE_CD;
        
        ADBOpportunityRequestWrapper.CallLevel callLevelId1 = new ADBOpportunityRequestWrapper.CallLevel();
        callLevelId1.key = '';
        callLevelId1.value = '';
        request.callLevelId1 = callLevelId1;
        
        ADBOpportunityRequestWrapper.CallLevel callLevelId2 = new ADBOpportunityRequestWrapper.CallLevel();
        callLevelId2.key = '';
        callLevelId2.value = '';
        request.callLevelId2 = callLevelId2;
        
        ADBOpportunityRequestWrapper.CallLevel callLevelId3 = new ADBOpportunityRequestWrapper.CallLevel();
        callLevelId3.key = '';
        callLevelId3.value = '';
        request.callLevelId3 = callLevelId3;
        
        String serializedBody = JSON.serialize(request);
        system.debug('serialized body 1st request' + serializedBody);
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBOpportunityService', serializedBody, null);
        HttpResponse response = wsCallOutFW.getResponse();

        // Mock Opportunities --- Begin
        /*if(request.memberId == '32363775') { // Bethel - No opportunities message
            String memberMockData = 'ADBOpportunityMockResponseBethel';
            StaticResource mock = [SELECT body FROM StaticResource WHERE Name =: memberMockData];
            response.setBody(mock.body.toString());
            response.setStatusCode(200);
        } else if (request.memberId == '31144921') { // Evelyn - Display opportunities in card
            String memberMockData = 'ADBOpportunityMockResponseEvelyn';
            StaticResource mock = [SELECT body FROM StaticResource WHERE Name =: memberMockData];
            response.setBody(mock.body.toString());
            response.setStatusCode(200);
        }
        response.setStatusCode(200);*/
        // Mock Opportunities --- End

        system.debug('response ++++++++++++' + response.getBody());
        if(response.getStatusCode() == 200) {
            return generateUIWrapper(response);
        }
        else {
            wrapper.statusCode = response.getStatusCode();
            wrapper.statusMessage = response.getStatus();
            wrapper.responseMessage = 'Offer Information cannot be retrieved. Open a Help Desk ticket.';
        }
        
        return wrapper;
    }
    
    @AuraEnabled
    public static ADBOpportunitySaveResponseWrapper getSaveOpportunities(ADBOpportunitySaveRequestWrapper req, ADBOpportunity offerResponseList, String evntName, String blacklistDays, String userId, String userComments) {
        ADBOpportunitySaveResponseWrapper wrapper = new ADBOpportunitySaveResponseWrapper();
        system.debug('offers response list :::: $$$'+ offerResponseList);
        // below are the request parameters for SLI request on submit button
        req.memberIdType = offerResponseList.memberIdType; 
        req.policyId = offerResponseList.policyId; // optional
        req.mdmPersonId = offerResponseList.mdmPersonId; 
        req.srcMemberId = offerResponseList.srcMemberId;  
        req.srcMemberIdType = offerResponseList.srcMemberIdType;
        req.mbrOppId = offerResponseList.mbrOppId; // optional
        req.homMbrOppId = offerResponseList.homMbrOppId;  // optional
        req.sourceCd = offerResponseList.sourceCd;
        req.opportunityId = offerResponseList.opportunityId;// optional
        req.opportunityTypeCd = offerResponseList.opportunityTypeCd; 
        req.eventDesc = offerResponseList.event; 
        req.audienceLevel = AUDIENCE_LEVEL; 
        req.audienceKeyDataType = AUDIENCE_KEY_DATA_TYPE;
        req.interactiveChannelName = INTERACTIVE_CHANNEL_NAME;
        req.intPoint = INT_POINT;
        req.eventName = evntName;
        req.statusReasonCode = (offerResponseList.statusReasonCode != null)?offerResponseList.statusReasonCode:'';
        req.dispositionText = userComments;  
        req.treatmentCode = offerResponseList.treatmentCode; 
        req.offerCode = offerResponseList.offerCode; 
        req.blacklistDays = blacklistDays;
        req.carrierId = offerResponseList.carrierId; 
        req.accountId = offerResponseList.accountId;	
        req.groupId = offerResponseList.groupId;
        req.applicationId = APPLICATION_ID;
        req.userId = userId;
        ADBOpportunitySaveRequestWrapper.CallLevel callLevelId1 = new ADBOpportunitySaveRequestWrapper.CallLevel();
        callLevelId1.key = '';
        callLevelId1.value = '';
        req.callLevelId1 = callLevelId1;
        
        ADBOpportunitySaveRequestWrapper.CallLevel callLevelId2 = new ADBOpportunitySaveRequestWrapper.CallLevel();
        callLevelId2.key = '';
        callLevelId2.value = '';
        req.callLevelId2 = callLevelId2;
        
        ADBOpportunitySaveRequestWrapper.CallLevel callLevelId3 = new ADBOpportunitySaveRequestWrapper.CallLevel();
        callLevelId3.key = '';
        callLevelId3.value = '';
        req.callLevelId3 = callLevelId3;
        
        String serializedBody = JSON.serialize(req);
        
        system.debug('serialized body'+ serializedBody);
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBOpportunitySaveService', serializedBody, null);
        HttpResponse response = wsCallOutFW.getResponse();
        if(response.getStatusCode() == 200) {
            system.debug('success' + response.getBody());
            
        } else {
            system.debug('failure' + response);
            wrapper.responseCode = String.valueOf(response.getStatusCode());
            wrapper.responseMsg = response.getStatus();
        }
        
        return wrapper;
    }
    
    private static ADBOpportunityCardWrapper generateUIWrapper(HttpResponse response) {
        ADBOpportunityCardWrapper wrapper = new ADBOpportunityCardWrapper();
        Boolean validOfferCategory = false;
        Integer pharmacyCount, financialCount, healthCount, clinicalCount = 0;
        
        wrapper.statusCode = 200;
        wrapper.statusMessage = 'OK';
        List<ADBOpportunity> uiWrappers = new List<ADBOpportunity>();
        
        ADBOpportunityResponseWrapper responseWrapper = (ADBOpportunityResponseWrapper) JSON.deserialize(response.getBody(), 
                                                                                                         ADBOpportunityResponseWrapper.class);
        
        System.debug('response Wrapper : ' + responseWrapper);
        if (responseWrapper.offers != null){
            for(ADBOpportunityResponseWrapper.Offers offer : responseWrapper.offers) {
                //  resetting fields for next offer
                ADBOpportunity newOpprtunity = new ADBOpportunity();
                validOfferCategory = false;
                
                for(ADBOpportunityResponseWrapper.KeyValuePair pair : offer.offerAttributes) {
                    if('NBAEventDesc'.equals(pair.key)) {
                        newOpprtunity.Event = pair.value;                    
                    } else if('NBAHoverBullet1'.equals(pair.key)) {
                        newOpprtunity.Description = pair.value;
                        newOpprtunity.descriptionHoverOver = pair.value;
                    } else if('NBAToDoDesc'.equals(pair.key)) {
                        newOpprtunity.Todo = pair.value;
                        newOpprtunity.todoHoverOver = pair.value;
                    } 
                    else if('MemberIdType'.equals(pair.key)) {
                        newOpprtunity.memberIdType = pair.value;
                    } 
                    else if('MDM_PERSON_ID'.equals(pair.key)) {
                        newOpprtunity.mdmPersonId = pair.value;
                    } 
                    else if('PolicyId'.equals(pair.key)) {
                        newOpprtunity.policyId = pair.value;
                    } 
                    else if('SrcMemberId'.equals(pair.key)) {
                        newOpprtunity.srcMemberId = pair.value;
                    } 
                    else if('SrcMemberIdType'.equals(pair.key)) {
                        newOpprtunity.srcMemberIdType = pair.value;
                    } 
                    else if('MemberOppId'.equals(pair.key)) {
                        newOpprtunity.mbrOppId = pair.value;
                    } 
                    else if('HomMbrOppId'.equals(pair.key)) {
                        newOpprtunity.homMbrOppId = pair.value;
                    } 
                    else if('SourceCd'.equals(pair.key)) {
                        newOpprtunity.sourceCd = pair.value;
                    } 
                    else if('OPPORTUNITY_ID'.equals(pair.key)) {
                        newOpprtunity.opportunityId = pair.value;
                    } 
                    else if('OPPORTUNITY_TYPE_CD'.equals(pair.key)) {
                        newOpprtunity.opportunityTypeCd = pair.value;
                    }
                    else if('intPoint'.equals(pair.key)) {
                        newOpprtunity.intPoint = pair.value;
                    }
                    else if('OfferCode'.equals(pair.key)) {
                        newOpprtunity.offerCode = pair.value;
                    } 
                    else if('TreatmentCode'.equals(pair.key)) {
                        newOpprtunity.treatmentCode = pair.value;
                    }
                    else if('CarrierId'.equals(pair.key)) {
                        newOpprtunity.carrierId = pair.value;
                    }
                    else if('AccountId'.equals(pair.key)) {
                        newOpprtunity.accountId = pair.value;
                    }
                    else if('GroupId'.equals(pair.key)) {
                        newOpprtunity.groupId = pair.value;
                    }else if('NBAParentID'.equals(Pair.key)) {
                        newOpprtunity.nbaParentId = Pair.value;                    
                    }
                    else if('NBAHoverDesc'.equals(pair.key)) {
                        newOpprtunity.eventHoverOver = pair.value;
                    } else if('NBAHoverBullet2'.equals(pair.key)) {
                        if(CLINICAL_PROGRAMS.equalsIgnoreCase(pair.value)) {
                            newOpprtunity.offerCategory = 'CLN';
                            validOfferCategory = true;
                        } else if(COST_SAVING_FINANCIAL.equalsIgnoreCase(pair.value)) {
                            newOpprtunity.offerCategory = 'FIN';
                            validOfferCategory = true;
                        } else if(HEALTH_AND_WELLNESS.equalsIgnoreCase(pair.value)) {
                            newOpprtunity.offerCategory = 'MED';
                            validOfferCategory = true;
                        } else if(PHARMACY.equalsIgnoreCase(pair.value)) {
                            newOpprtunity.offerCategory = 'PAR';
                            validOfferCategory = true;
                        }
                    } 
                    
                    newOpprtunity.callerAccept = true;
                    newOpprtunity.callerConsidering = true;
                    newOpprtunity.removeOpportunity = true;
                    
                }
                if(offer!=null && offer.dispositions!=null){
                    system.debug('in dispositions');
                    for(ADBOpportunityResponseWrapper.Dispositions disps : offer.dispositions){
                        system.debug('disposition disps'+disps);
                        if(disps!=null && disps.disposition!=null){
                             List<ADBOpportunity.dispositions> dsList= new List<ADBOpportunity.dispositions>();
                            system.debug('disposition pair new loop');
                            ADBOpportunity.dispositions ds = new ADBOpportunity.dispositions();
                            for(ADBOpportunityResponseWrapper.KeyValuePair dispPairs : disps.disposition){
                                system.debug('disposition pair'+dispPairs);
                                if('ToDoLink'.equals(dispPairs.key)) {
                                    ds.todoLink = dispPairs.value;                    
                                }else if('Reason'.equals(dispPairs.key)) {
                                    ds.nbaStatusReason = dispPairs.value;                    
                                }else if('Name'.equals(dispPairs.key)) {
                                    ds.dispName = dispPairs.value;                    
                                }else if('BLDays'.equals(dispPairs.key)) {
                                    ds.blacklistDays = dispPairs.value;                    
                                }
                                
                            }
                            if( (!String.isEmpty(ds.dispName)) &&  ( !'RemoveOff'.equals(ds.dispName)  || ( 'RemoveOff'.equals(ds.dispName) && 'ClInApp'.equals(ds.nbaStatusReason) ) )  ){
                               		if(null != newOpprtunity.disposition){
                                    List<ADBOpportunity.dispositions> dsListTemp = newOpprtunity.disposition;
                                    dsListTemp.add(ds);
                                    newOpprtunity.disposition = dsListTemp;
                                    }else{
                                        List<ADBOpportunity.dispositions> dsListTemp = new List<ADBOpportunity.dispositions>();
                                    dsListTemp.add(ds);
                                    newOpprtunity.disposition = dsListTemp;
                                    }   
                              }
             
                        }
                    }
                }
                if(validOfferCategory) {
                    uiWrappers.add(newOpprtunity);      
                    System.debug('wrapper size : ' + uiWrappers.size());
                }else{
                    wrapper.responseMessage = 'Valid Category is false - Not returning wrapper';
                }
            }
            wrapper.offers = uiWrappers;
        }
        else{
            wrapper.responseMessage = responseWrapper.responseMsg;
        }
        
        return wrapper;
    }
}