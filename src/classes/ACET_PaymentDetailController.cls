public class ACET_PaymentDetailController {
    public static Boolean isClaims=false;
    public static String adTaxId;
    public static String providerId;
    public static String sourceCode;

    public class SearchResultWrapper{
        @AuraEnabled public Map<string,ACET_PaymentDetailController_Json2Apex.payments> paymentDetailSummry {get;set;}
        @AuraEnabled public string message {get;set;}
        @AuraEnabled public integer statusCode {get;set;}
    }
    public class PaymentImageWrapper{
        @AuraEnabled public string checkImgRef{get;set;}
    }
    public class PaymentInput{
        @AuraEnabled public string taxid{get;set;}
        @AuraEnabled public string sourceCode{get;set;}
        @AuraEnabled public string providerId{get;set;}
        @AuraEnabled public string payerId{get;set;}
        @AuraEnabled public string transactionId{get;set;}
        @AuraEnabled public string PaymentNo{get;set;}
        @AuraEnabled public boolean isClaim{get;set;}
        @AuraEnabled public string adTaxId{get;set;}
    }
    public class paymentDetailCard {
        @AuraEnabled public ACET_AutoDocUtil.CardDetails paymentDetailInfo;
         @AuraEnabled public ACET_PaymentDetailController_Json2Apex.payments paymentDetails;
        @AuraEnabled public Boolean isSuccess;
        @AuraEnabled public String errorMessage;
        // US3476420
        @AuraEnabled public String taxId;
    }
    @AuraEnabled
    public static paymentDetailCard getPaymentDetailsForPTI(PaymentInput input) {
        isClaims=input.isClaim;
        providerId=input.providerId;
        adTaxId=input.adTaxId;
        sourceCode=input.sourceCode;
        return ACET_PaymentDetailController.getPaymentDetails(input.taxid,input.payerId,input.transactionId,input.PaymentNo);
    }
    @AuraEnabled
    public static paymentDetailCard getPaymentDetails(String taxid,String payerId,String transactionId,string PaymentNo){
        system.debug('taxid@@'+taxid);
        system.debug('payerId@@'+payerId);
        system.debug('transactionId@@'+transactionId);
        system.debug('PaymentNo@@'+PaymentNo);
        ACET_PaymentDetailController.paymentDetailCard returnWrapper = new ACET_PaymentDetailController.paymentDetailCard();
        try{
            ACET_PaymentDetailControllerWS paymentDetailsService = new ACET_PaymentDetailControllerWS();
            ACET_PaymentDetailController_Json2Apex.payments payments = New ACET_PaymentDetailController_Json2Apex.payments();
            ACETWSCalloutResult CalloutResult = paymentDetailsService.getPaymentDetailsWS(taxid,payerId,transactionId);
            if (CalloutResult.Success) {
                list<ACET_PaymentDetailController_Json2Apex.payments> result = new list<ACET_PaymentDetailController_Json2Apex.payments>();
                result = (list<ACET_PaymentDetailController_Json2Apex.payments>) CalloutResult.Response;
                Map <String,ACET_PaymentDetailController_Json2Apex.payments> paymentsDetails = new Map <String,ACET_PaymentDetailController_Json2Apex.payments>();
                paymentsDetails=createPaymentDetailsMap(result);
                system.debug('PaymentNo@@'+PaymentNo);
                payments=paymentsDetails.get(PaymentNo);
                system.debug('payments@@'+payments);
                returnWrapper.paymentDetails=payments;
                // US3476420
                returnWrapper.taxId = taxid;
                returnWrapper.paymentDetailInfo=createPaymentDetails(payments,PaymentNo);
                returnWrapper.isSuccess = true;
            }else{
                 //added by sravani start
            System.debug('CalloutResult failed No results found');
            Object res = CalloutResult.Response;
            String resString = JSON.serialize(res);
            Map<String, Object> httpResponseJSON = (Map<String, Object>) JSON.deserializeUntyped(resString);
            String messageSer = String.isNotBlank((String)httpResponseJSON.get('Message')) ? (String)httpResponseJSON.get('Message') : '';
            integer statusCode = (integer)httpResponseJSON.get('statusCode');
            returnWrapper.errorMessage= messageSer;
            returnWrapper.isSuccess = false;
            //returnWrapper.statusCode = statusCode;
            //added by sravani end
            }
        }catch(Exception e){
            System.debug('exception::'+e.getStackTraceString());
            returnWrapper.errorMessage = e.getMessage() + ' ' + e.getLineNumber();
        }
        system.debug('returnWrapper>>>'+returnWrapper.paymentDetails);
        return returnWrapper;

    }
    public static Map <String,ACET_PaymentDetailController_Json2Apex.payments> createPaymentDetailsMap(list<ACET_PaymentDetailController_Json2Apex.payments> paymentList){
        string paymentNumber='';
        Map <String,ACET_PaymentDetailController_Json2Apex.payments> PaymentMap = new Map <String,ACET_PaymentDetailController_Json2Apex.payments>();
        for(ACET_PaymentDetailController_Json2Apex.payments p:paymentList){
            paymentNumber = p.chkSrsDesg+p.checkNbr;
            PaymentMap.put(paymentNumber,p);
        }
        system.debug('Test Payment Map'+PaymentMap);
        system.debug('Test Payment Map'+PaymentMap.keyset());
        return PaymentMap;
    }
    @AuraEnabled
    public static ACET_AutoDocUtil.CardDetails createPaymentDetails(ACET_PaymentDetailController_Json2Apex.payments payments,string paymentNo){
        ACET_PaymentDetailController_Json2Apex.PayeeAddress PayeeAddress = Payments.PayeeAddress;
        ACET_AutoDocUtil.CardDetails cardDetails = new ACET_AutoDocUtil.CardDetails();
        cardDetails.componentName = 'Payment Status: '+paymentNo;
        // US3653575
        cardDetails.reportingHeader = 'Payment Status';
        cardDetails.componentOrder = 7;
        cardDetails.type = 'card';
        cardDetails.noOfColumns = 'slds-size_1-of-5';
        List < ACET_AutoDocUtil.FieldDetails > cardData = new List < ACET_AutoDocUtil.FieldDetails > ();
        if(payments!=null) {
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Issued', Payments.paymentIssueDt != null ? Payments.paymentIssueDt :'--', 'outputText',true));
            if(Payments.paymentType=='VCP'){
                cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Type', Payments.paymentType, 'outputText',true));
                
            }else if(Payments.checkEFTIndicator=='E'){
                cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Type', 'Electronic', 'outputText',true));
                
            }else if(Payments.checkEFTIndicator=='P'){
                cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Type', 'Paper', 'outputText',true));
            }
            else
               cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Type', '--', 'outputText',true));
            String checkStatus=Payments.checkStatus != null ? Payments.checkStatus :'--';
            if((Payments.checkEFTIndicator=='P' && (checkStatus.equalsIgnoreCase('Check Cashed') || checkStatus.equalsIgnoreCase('Payment Stopped'))) || (Payments.paymentType=='VCP'))
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, ' Status',checkStatus, 'link',true));
            else
                cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, ' Status',checkStatus, 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Cashed/Redeemed', Payments.cashedDt != null ? Payments.cashedDt :'--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Draft/Token #', Payments.draftNbr != null ? Payments.draftNbr :'--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Total', Payments.checkAmt != null ? '$'+Payments.checkAmt :'--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Payee Type', Payments.payeeTypeCode != null ? Payments.payeeTypeCode :'--', 'outputText',true));
            if(isClaims){
                SAE_ProviderSnapshotWrapper.ReturnResponse pDetails =SAE_ProviderSnapshotController.getProviderDataForClaim(providerId,adTaxId,isClaims);
                String pti='--';
                System.debug('pDetails'+pDetails);
                if(pDetails != null ){
                    if(pDetails.AdditionalDetails != null && pDetails.isSuccess ){
                    pti=pDetails.AdditionalDetails.pti;
                    }}
                ACET_AutoDocUtil.FieldDetails hoverPTI = new ACET_AutoDocUtil.FieldDetails(false, false, true, 'PTI',pti, 'hoverText',true);
                hoverPTI.popupId = 'ptipopup';
                hoverPTI.description = 'See below for description:';
                hoverPTI.descriptionList = new List < String > {
                'Y = Select the physician/practitioner record.',
                'N = Select the group record.',
                'E = Select the individual record if found, otherwise select the group record.',
                'M = Multiple groups exist for a physician or allied health professional.',
                'O = This value will only be used for 100% Non-Par groups.',
                'G = Select the individual if PAR, if not select the group'
            };
            hoverPTI.moveLeft = '-350';
            hoverPTI.moveRight = '-250';
            cardData.add(hoverPTI);
            }
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Payee Name', Payments.payeeNm != null ? Payments.payeeNm :'--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Address',PayeeAddress.addressLine1+'\n'+PayeeAddress.city+', '+PayeeAddress.state+'\n'+PayeeAddress.zip.substring(0,5), 'formattedText',true));
            cardData=addNewFields(Payments.checkEFTIndicator,Payments.paymentType,cardData);
            cardDetails.cardData = cardData;
            system.debug('cardDetails@@'+cardDetails);
            
        }else{
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Issued','--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Type','--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Status','--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Cashed/Redeemed','--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Draft/Token #','--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Total','--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Payee Type','--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Payee Name','--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Address','--', 'outputText',true));
            
        }
        return cardDetails;
    }
    
   public class PaymentImageImputWrapper{
        @AuraEnabled public string checkStatus{get;set;}
       @AuraEnabled public string checkNbr{get;set;}//Reuse
       @AuraEnabled public string chkSrsDesg{get;set;}
       @AuraEnabled public string checkEFTIndicator{get;set;}
       @AuraEnabled public string memberId{get;set;}
       @AuraEnabled public string tin{get;set;}
       @AuraEnabled public string docClass{get;set;}
       @AuraEnabled public string clNum{get;set;}
       @AuraEnabled public boolean paperCheck{get;set;}
    }
    private Static List < ACET_AutoDocUtil.FieldDetails > addNewFields(String checkEFTIndicator,String paymentType,List < ACET_AutoDocUtil.FieldDetails > cardData){
        if((sourceCode=='CO' || sourceCode=='CS') && checkEFTIndicator=='P' && paymentType!='VCP'){
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Void/Stop','5/21/2021', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Returned','5/22/2021', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Remailed','5/23/2021', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Reissued','5/24/2021', 'outputText',true));
             cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Reissued #','TR123456789', 'outputText',true));
            }
        return cardData;
    }
    @AuraEnabled
   // public Static String getPaymentStatusImage(String checkStatus,String checkNbr,String chkSrsDesg,String checkEFTIndicator){
    public Static String getPaymentStatusImage(PaymentImageImputWrapper paymentImageImputWrapper){
        String URL='';
        if(paymentImageImputWrapper.paperCheck && (paymentImageImputWrapper.checkEFTIndicator=='P' && (paymentImageImputWrapper.checkStatus.equalsIgnoreCase('Check Cashed') || paymentImageImputWrapper.checkStatus.equalsIgnoreCase('Payment Stopped')))){
            PaymentImageWrapper response=(PaymentImageWrapper) System.JSON.deserialize(ACET_PaymentDetailControllerWS.getPaymentStatusImageWS(paymentImageImputWrapper.checkNbr,paymentImageImputWrapper.chkSrsDesg), PaymentImageWrapper.class);
            URL= response.checkImgRef;
        }else{
            ACET_ClaimRelatedDocumentController.AttachmentsResponseData doc360Input=new ACET_ClaimRelatedDocumentController.AttachmentsResponseData();
            Map<String,String> feildMap= new Map<String,String>();
            if(PaymentImageImputWrapper.docClass == 'u_unet_gflx_eob'){
                feildMap.put('u_master_tin',PaymentImageImputWrapper.tin);
                feildMap.put('u_member_id_PRA',PaymentImageImputWrapper.memberId);
                feildMap.put('u_check_nbr',PaymentImageImputWrapper.chkSrsDesg+PaymentImageImputWrapper.checkNbr);
                feildMap.put('docClass',PaymentImageImputWrapper.docClass);
            }else if(PaymentImageImputWrapper.docClass == 'u_cosmos_pra'){
                feildMap.put('u_tin_cosmos',PaymentImageImputWrapper.tin);
                feildMap.put('u_claim_nbr',PaymentImageImputWrapper.clNum+'*');
                feildMap.put('docClass',PaymentImageImputWrapper.docClass);
            }else if(PaymentImageImputWrapper.docClass == 'u_cosmos_pra_ub'){
                feildMap.put('u_tin',PaymentImageImputWrapper.tin);
                feildMap.put('u_claim_nbr_EOB',PaymentImageImputWrapper.clNum+'*');
                feildMap.put('docClass',PaymentImageImputWrapper.docClass);
            }

            doc360Input.feildMap = feildMap;
            URL=ACET_WebServiceUtils.generateDoc360URL(json.serialize(doc360Input));
        }
        return URL;
        
    }
    
    // US3678785
    @AuraEnabled
    public static Map<String, ACET_SAECalloutResult> searchPayment(ACET_ViewPaymentsRequest.PaymentDetailsParams requestObject) {
        system.debug('requestObject: '+requestObject);
        Map<String, ACET_SAECalloutResult> returnData = new Map <String, ACET_SAECalloutResult>();
        ACET_SAECalloutResult checkSearchResp = ACET_ViewPaymentsCheckSearchWS.getCheckSearchData(requestObject);
        returnData.put('checkSearchResp', checkSearchResp);
        return returnData;

    }

    // US3476420
    @AuraEnabled
    public static ACET_SAECalloutResult getBulkRecoveryData(ACET_BulkRecoveryService.BulkRequest bulkRequest)
    {
        return ACET_BulkRecoveryService.getRecoveryList(bulkRequest);
    }

}