/**
* Author: Hasara Disanayaka
* Description : Used by Health Spend Card
* AuraEnabled : 
* Date Created: 30/06/2020
*/ 
public without sharing class ADBClaimsSearchController {
    @AuraEnabled
    public static ADBMemberDetailWrapper getMemberSearch(String memberId, String memDob, String firstName, String lastName, String timestamp){
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
            system.debug('ADBClaimsSearchController.getMemberSearchResponse Exception ::' + e.getMessage());
        }
        system.debug('ADBClaimsSearchController.getMemberSearchResponse detailWrapper ::: '+detailWrapper );
        return detailWrapper;
    }
    
    @AuraEnabled
    public static ADBClaimDetailWrapper getClaimsSearch(String carrierID, String accountId, String groupId, String rxMemberId, String instanceId, String timestamp, String fillDateThru, String fillDateFrom) {
        ADBClaimsSearchResponseWrapper responseWrapper = new ADBClaimsSearchResponseWrapper();
        ADBClaimsSearchRequestWrapper requestWrapper = new ADBClaimsSearchRequestWrapper();
        ADBClaimDetailWrapper claimDetailWrapper = new ADBClaimDetailWrapper();
        try{
            requestWrapper.memberId = rxMemberId;
            requestWrapper.carrierId = carrierID;
            requestWrapper.accountId = accountId;
            requestWrapper.groupId  = groupId;
            requestWrapper.fillDateFrom = fillDateFrom;
            requestWrapper.fillDateThru =  fillDateThru;
            requestWrapper.searchInputMetaData = new ADBClaimsSearchRequestWrapper.SearchInputMetaData();
            requestWrapper.searchInputMetaData.consumerAppId = 'ACETDASHBOARD';
            requestWrapper.searchInputMetaData.consumerAppType = 'IA';
            requestWrapper.searchInputMetaData.rXClaimInstanceId = instanceId;
            requestWrapper.searchInputMetaData.externalCorrelationId = 'ACETDASHBOARD-ONBRDTESTCLM' + timestamp;
            requestWrapper.searchInputMetaData.consumerType = 'CA';
            String serializedBody = JSON.serialize(requestWrapper);
            system.debug('ADBClaimsSearchController.getClamSearchResponse serializedBody ::: '+ serializedBody);
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBClaimSearchEndpoint',serializedBody,null);
            HttpResponse response = wsCallOutFW.getResponse(); 
            // Faking the prod response
            /*HttpResponse response = new HttpResponse();
StaticResource requestTemplate = [SELECT body FROM StaticResource WHERE Name = 'ADBPharmacyClaimsMockResponse'];//ADBPharmacyNoClaimsMockResponse //
String strBody = requestTemplate.Body.toString();
system.debug('strBody Auth service'+strBody);
response.setBody(strBody);
system.debug('response Auth service'+response);
response.setStatusCode(200);*/
            
            if(response.getStatusCode() == 200){
                // Deserializing the response to response Wrapper
                responseWrapper = (ADBClaimsSearchResponseWrapper) JSON.deserialize(response.getBody(), ADBClaimsSearchResponseWrapper.class);
                Map<String, String> statusMap = new Map<String, String>();
                Set<String> statuses = new Set<String>();
                if(responseWrapper != null && responseWrapper.claimSearchResponse != null && responseWrapper.claimSearchResponse.claimSearchV2ServiceItem != null){
                    claimDetailWrapper.claimSearchV2ServiceItem = new List<ADBClaimDetailWrapper.ClaimSearchV2ServiceItem>();
                    Integer i = 0;
                    for(ADBClaimsSearchResponseWrapper.ClaimSearchV2ServiceItem claimSearchItems : responseWrapper.ClaimSearchResponse.ClaimSearchV2ServiceItem){
                        statuses.add(claimSearchItems.claimStatus);
                    }
                    for(ADBClaimStatus__mdt mdt : [SELECT Key__c, Value__c FROM ADBClaimStatus__mdt WHERE key__c IN : statuses]){
                        statusMap.put(mdt.Key__c, mdt.Value__c);
                    }
                    for(i=0; i < responseWrapper.claimSearchResponse.claimSearchV2ServiceItem.size(); i++){
                        ADBClaimsSearchResponseWrapper.ClaimSearchV2ServiceItem currItem = responseWrapper.claimSearchResponse.claimSearchV2ServiceItem[i];
                        String cStatus = currItem.claimStatus;
                        String fDate = currItem.fillDate;
                        String fillDate;
                        String claimsStatus = statusMap.get(cStatus);
                        
                        ADBClaimDetailWrapper.ClaimSearchV2ServiceItem tempClaim = new ADBClaimDetailWrapper.ClaimSearchV2ServiceItem();
                        tempClaim.claimStatus = String.isBlank(claimsStatus) ? cStatus : claimsStatus;
                        fillDate = (fDate != null) ? fDate.substring(4,6)+'/'+fDate.substring(6, 8)+'/'+fDate.substring(0,4) : fDate;
                        tempClaim.fillDate = fillDate;
                        tempClaim.productNameAbbreviation = currItem.productNameAbbreviation;
                        tempClaim.pharmacyName = currItem.pharmacyName;
                        tempClaim.daysSupply = currItem.daysSupply;
                        claimDetailWrapper.claimSearchV2ServiceItem.add(tempClaim);
                    }
                }
            }
        }catch(Exception e){
            system.debug('ADBClaimsSearchController.getMemberSearch Exception ::' + e.getMessage());
        }
        system.debug('ADBClaimsSearchController response detailWrapper claimDetailWrapper::: '+ claimDetailWrapper);
        return claimDetailWrapper;
    }
}