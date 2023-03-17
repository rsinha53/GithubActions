/**
* Author: Hasara Disanayaka
* Description : Used by Health Spend Card
* AuraEnabled : 
* Date Created: 30/06/2020
*/ 
public without sharing class ADBMemberSearchController {

    public static ADBMemberDetailWrapper getMemberSearchResponse(String memberId, String memDob, String firstName, String lastName, String timestamp){
        ADBMemberSearchResponseWrapper responseWrapper = new ADBMemberSearchResponseWrapper();
        ADBMemberSearchRequestWrapper requestWrapper = new ADBMemberSearchRequestWrapper();
        ADBMemberDetailWrapper detailWrapper = new ADBMemberDetailWrapper();
        try{
            requestWrapper.memberIDType = 'S';
            requestWrapper.firstName = firstName;
            requestWrapper.lastName = lastName;
            requestWrapper.dateOfBirth = memDob;
            requestWrapper.memberId  = '';
            requestWrapper.SearchInputMetaData = new ADBMemberSearchRequestWrapper.searchInputMetaData();
            requestWrapper.searchInputMetaData.consumerAppId = 'ACETDASHBOARD';
            requestWrapper.searchInputMetaData.consumerAppType = 'IA';
            requestWrapper.searchInputMetaData.externalCorrelationId = 'ACETDASHBOARD-ONBRDTESTCLM' + timestamp;
            requestWrapper.searchInputMetaData.consumerType = 'CA';
            requestWrapper.SearchInputMetaData.Pagination = new ADBMemberSearchRequestWrapper.pagination();
            requestWrapper.searchInputMetaData.pagination.maxResults = 5;
            requestWrapper.searchInputMetaData.pagination.maxResultsIndicator = true;
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBMemberSearchEndpoint',JSON.serialize(requestWrapper),null);
            HttpResponse response = wsCallOutFW.getResponse();
            if(response.getStatusCode() == 200){
                // Deserializing the response to response Wrapper
                responseWrapper = (ADBMemberSearchResponseWrapper) JSON.deserialize(response.getBody(), ADBMemberSearchResponseWrapper.class);
                system.debug('ADBMemberSearchController.getMemberSearchResponse responseWrapper ::: '+ responseWrapper);
                if(responseWrapper != null && responseWrapper.Response != null && responseWrapper.Response.MemberSearchItems != null){
                    for(ADBMemberSearchResponseWrapper.MemberSearchItems memSearchItems : responseWrapper.Response.MemberSearchItems){
                        if(!responseWrapper.Response.MemberSearchItems.isEmpty() && memSearchItems.memberId != null && memSearchItems.carrierId !=null &&
                           memSearchItems.accountId != null && memSearchItems.groupId != null && memSearchItems.instanceId != null ){
                               detailWrapper.memberId = memSearchItems.memberId;
                               detailWrapper.carrierId = memSearchItems.carrierId;
                               detailWrapper.accountId = memSearchItems.accountId;
                               detailWrapper.groupId = memSearchItems.groupId;
                               detailWrapper.instanceId = memSearchItems.instanceId;
                               detailWrapper.pbm = 'Optum Rx';
                               if(memSearchItems.memberEffectiveDate.fromDate != null && memSearchItems.memberEffectiveDate.thruDate != null){
                                   String fromDate = memSearchItems.memberEffectiveDate.fromDate.substring(4,6)+'/'+memSearchItems.memberEffectiveDate.fromDate.substring(6, 8)+'/'+memSearchItems.memberEffectiveDate.fromDate.substring(0,4);
                                   detailWrapper.fromDate = fromDate;
                                   String thruDate = memSearchItems.memberEffectiveDate.thruDate.substring(4,6)+'/'+memSearchItems.memberEffectiveDate.thruDate.substring(6, 8)+'/'+memSearchItems.memberEffectiveDate.thruDate.substring(0,4);
                                   detailWrapper.thruDate = thruDate;
                               }
                           }
                    }
                }
            }
        }catch(Exception e){
            system.debug('ADBMemberSearchController.getMemberSearchResponse Exception ::' + e.getMessage());
        }
        system.debug('ADBMemberSearchController.getMemberSearchResponse detailWrapper ::: '+detailWrapper );
        return detailWrapper;
    }
}