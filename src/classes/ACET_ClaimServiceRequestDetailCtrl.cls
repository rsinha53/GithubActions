/**
 * @description       : To get Claim Recon and Claim Attachment service details
 * @author            : Nikhil Kanth
 * @group             : 
 * @last modified on  : 05-11-2021
 * @last modified by  : Nikhil Kanth
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   05-04-2021   Nikhil Kanth   Initial Version
 **/
public class ACET_ClaimServiceRequestDetailCtrl {

    /**
     * @description calling claim recon service
     * @author Nikhil Kanth | 05-04-2021 
     * @param tcktNumber 
     * @param taxId 
     **/
    @AuraEnabled
    public static ACET_ClaimServiceRequestDetailWrapper getReconTicketDetails(String tcktNumber, String taxId) {
        ACET_ClaimServiceRequestDetailWrapper detailWrapper = new ACET_ClaimServiceRequestDetailWrapper();
        try {
            //Request Params
            Map < String, String > requestParamsMap = new Map < String, String > ();
            requestParamsMap.put('ticketNumber', tcktNumber);
            requestParamsMap.put('tin', taxId);
            requestParamsMap.put('searchType', 'T');
            requestParamsMap.put('payerId', '87726');

            // calling webservice using webservice framework
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'LinkClaimRecon';
            wsCallOutFW.requestParamsMap = requestParamsMap;
            wsCallOutFW.encodeURLParameters = true;

            //get Response
            HttpResponse response = wsCallOutFW.getResponse();

            Integer statusCode = response.getStatusCode();
            String responseBody = response.getBody();

            if (statusCode == 200) {
                ACET_ClaimReconResultWrapper resultWrapper = ACET_ClaimReconResultWrapper.parse(responseBody);
                ACET_ClaimReconResultWrapper.TicketDetail ticketDetailInfo = resultWrapper.tickets[0].ticketDetail;

                //ExternalIds Card Info
                detailWrapper.externalIdDetails.status = ticketDetailInfo.ticketInfo.ticketStatus;
                detailWrapper.externalIdDetails.adjustment = ticketDetailInfo.ticketInfo.adjustmentIds[0];
                detailWrapper.externalIdDetails.memberName = ticketDetailInfo.memberInfo.memberName.firstName + ' ' + ticketDetailInfo.memberInfo.memberName.lastName;
                detailWrapper.externalIdDetails.memberId = ticketDetailInfo.memberInfo.memberId;
                detailWrapper.externalIdDetails.claimNumber = ticketDetailInfo.claimInfo.claimNumber;
                detailWrapper.externalIdDetails.claimServiceDate = ticketDetailInfo.claimInfo.firstSrvcDt;
                detailWrapper.externalIdDetails.billedAmount = '$ ' + ticketDetailInfo.claimInfo.totalChargedAmt;
                detailWrapper.externalIdDetails.amountRequested = '$ ' + ticketDetailInfo.claimInfo.amtOwed;
                detailWrapper.externalIdDetails.platform = ticketDetailInfo.memberInfo.platform;
                detailWrapper.externalIdDetails.contactName = ticketDetailInfo.operator.operatorName;
                detailWrapper.externalIdDetails.phnNumber = ticketDetailInfo.operator.phoneNo;
                detailWrapper.externalIdDetails.emailAddress = ticketDetailInfo.operator.emailId;
                detailWrapper.externalIdDetails.billingProvider = ticketDetailInfo.providerInfo.billProvNm;
                detailWrapper.externalIdDetails.servicingProvider = ticketDetailInfo.providerInfo.renProvNm.firstName + ' ' + ticketDetailInfo.providerInfo.renProvNm.lastName;

                //History Table
                for (ACET_ClaimReconResultWrapper.Comments commentInfo: ticketDetailInfo.comments) {
                    ACET_ClaimServiceRequestDetailWrapper.History historyCmnt = new ACET_ClaimServiceRequestDetailWrapper.History();
                    historyCmnt.addedBy = commentInfo.addedBy;
                    historyCmnt.dateAndTime = commentInfo.addedOn;
                    historyCmnt.comments = commentInfo.comment;
                    detailWrapper.historyList.add(historyCmnt);
                }
            } else {
                ACET_ClaimServiceRequestDetailWrapper.History historyCmnt = new ACET_ClaimServiceRequestDetailWrapper.History();
                detailWrapper.historyList.add(historyCmnt);
            }
        } catch (Exception ex) {
            System.debug('Exception::' + ex.getStackTraceString());
        }
        return detailWrapper;
    }

    /**
     * @description calling Claim Attachment List API
     * @author Nikhil Kanth | 05-05-2021 
     * @param tcktNumber 
     * @param taxId 
     * @return ACET_ClaimServiceRequestDetailWrapper 
     **/
    @AuraEnabled
    public static ACET_ClaimServiceRequestDetailWrapper getClaimAttachmentList(String tcktNumber, String taxId) {
        ACET_ClaimServiceRequestDetailWrapper detailWrapper = new ACET_ClaimServiceRequestDetailWrapper();
        try {
            //Request Params
            Map < String, String > requestParamsMap = new Map < String, String > ();
            requestParamsMap.put('ticketNumber', tcktNumber);
            requestParamsMap.put('tin', taxId);

            // calling webservice using webservice framework
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'LinkClaimAttachmentList';
            wsCallOutFW.requestParamsMap = requestParamsMap;
            wsCallOutFW.encodeURLParameters = true;

            //get Response
            HttpResponse response = wsCallOutFW.getResponse();

            Integer statusCode = response.getStatusCode();
            String responseBody = response.getBody();

            if (statusCode == 200) {
                List < ACET_ClaimAttachmentResultWrapper > attachmentList = ACET_ClaimAttachmentResultWrapper.parse(responseBody);
                for (ACET_ClaimAttachmentResultWrapper attachItem: attachmentList) {
                    ACET_ClaimServiceRequestDetailWrapper.Attachment attachment = new ACET_ClaimServiceRequestDetailWrapper.Attachment();
                    attachment.addedBy = '--'; //Gap
                    attachment.dateAndTime = '--'; //Gap
                    attachment.fileName = attachItem.fileNm;
                    attachment.type = attachItem.ticketType;
                    attachment.fileId = attachItem.attachmentId;
                    detailWrapper.attachmentList.add(attachment);
                }
            } else {
                ACET_ClaimServiceRequestDetailWrapper.Attachment attachment = new ACET_ClaimServiceRequestDetailWrapper.Attachment();
                detailWrapper.attachmentList.add(attachment);
            }
        } catch (Exception ex) {
            System.debug('Exception::' + ex.getStackTraceString());
        }
        return detailWrapper;
    }

    /**
     * @description To generate doc360 url to get related attachments
     * @author Nikhil Kanth | 05-11-2021 
     * @param taxId 
     * @param claimNumber 
     * @param tcktNumber 
     * @return String 
     **/
    @AuraEnabled
    public static String getDoc360Url(String taxId, String claimNumber, String tcktNumber) {
        String url = '';
        try {
            //List < String > attachIdList = attachmentId.split('%7C');
            //get org name
            String orgName = Organization_Properties__c.getOrgDefaults().OrganizationName__c;

            //Querying doc360 webservice record
            WebserviceConfigurations__c wsConfig = [SELECT Id, Name,
                (SELECT EndpointDomain__c, Static_Data__c, EnableMock__c FROM OrgSpecificConfigurations__r WHERE Name =: orgName LIMIT 1)
                FROM WebserviceConfigurations__c WHERE Name = 'DOC360GLobalURL'
                LIMIT 1
            ];
            OrgSpecificConfigurations__c orgSpecificConfigs = wsConfig.OrgSpecificConfigurations__r;
            Map < String, String > orgStaticMap = (Map < String, String > ) JSON.deserialize(orgSpecificConfigs.Static_Data__c, Map < String, String > .class);

            //Adding filters for doc360 search
            Map < String, String > fieldfiltersMap = new Map < String, String > ();
            fieldfiltersMap.put('u_clm_nbr', claimNumber);
            fieldfiltersMap.put('u_tin', taxId);
            fieldfiltersMap.put('u_tkt_nbr', tcktNumber);
            //fieldfiltersMap.put('u_attch_ctl_nbr',attachIdList[0]);

            //Querying docclass metadata
            Doctype_Doc_Class__mdt docClass1 = [SELECT Label, Document_Type__c, Doc_Class_Abbr__c, Id, (Select id, Document_Type_Field__r.WS_Field_Name__c, Document_Type_Field__r.DeveloperName from Document_Type_DocClass_Search_By_Fields__r) FROM Doctype_Doc_Class__mdt where Label = 'u_prov_attch'];

            //Mapping keys to input filters
            List < String > keyList = new List < String > ();
            for (Document_Type_Search_By_Field__mdt each: docClass1.Document_Type_DocClass_Search_By_Fields__r) {
                if (fieldfiltersMap.containsKey(each.Document_Type_Field__r.DeveloperName))
                    keyList.add(each.Document_Type_Field__r.WS_Field_Name__c + '=' + fieldfiltersMap.get(each.Document_Type_Field__r.DeveloperName));
            }
            String keys = keyList.size() > 0 ? String.join(keyList, '&') : '';

            //Encoding input parameters
            String needToBeencoded = 'appId=' + orgStaticMap.get('appId') + '&user=' + orgStaticMap.get('user') + '&datagroup=' + docClass1.Doc_Class_Abbr__c + '&screen=3&' + keys;
            Blob beforeblob = Blob.valueOf(needToBeencoded);

            //Check for Mock and forming url
            if (!orgSpecificConfigs.EnableMock__c) {
                url = orgSpecificConfigs.EndpointDomain__c + '?' + EncodingUtil.base64Encode(beforeblob);
            }
        } catch (Exception ex) {
            System.debug('Exception::' + ex.getStackTraceString());
        }
        return url;
    }
}