/*
    Created By: Avish Pagote
    Created Date: 23rd March 2021
    Description: To invoke the payment api calls
*/
public with sharing class ACET_ViewPaymentController {

	public static String PAYMENT_TYPE_VCP = 'VCP';
    public static String PAYMENT_TYPE_CHECK = 'Check';

    public static String PLATFORM_TYPE_COSMOS = 'COSMOS';
    public static String PLATFORM_TYPE_TOPS = 'TOPS';

    private static String paymentType;
    private static String platformType;
    @AuraEnabled
    public static List<Series_Designator_Payment__mdt> getAllSeriesDesignator()
    {
        String type='Epayment';
        return [SELECT Label FROM Series_Designator_Payment__mdt where Payment_Type__c=:type];
    }

    public static ACET_ViewPaymentsRequest.PaymentWrapper getPaymentType(String seriesDesignator, String checkNumber, String remitNumber) {
        ACET_ViewPaymentsRequest.PaymentWrapper paymentObj = new ACET_ViewPaymentsRequest.PaymentWrapper();
        List<Series_Designator_Payment__mdt> seriesDesignatorMDT =new List<Series_Designator_Payment__mdt>();
        if (seriesDesignator.length() == 2)
        seriesDesignatorMDT = [SELECT Label, Payment_Type__c, Platform__c FROM Series_Designator_Payment__mdt WHERE label = :seriesDesignator limit 1];
        
        if (seriesDesignator.length() >= 3 && (checkNumber.length() >= 8 && isAlphaNumeric(checkNumber)) && isLastCharacter(checkNumber)) {
            paymentObj.paymentType = PAYMENT_TYPE_VCP;
            paymentObj.platformType = PLATFORM_TYPE_COSMOS;
        }else if (seriesDesignator.length() == 2 && seriesDesignatorMDT.size()>0) {
            
            paymentObj.paymentType = seriesDesignatorMDT[0].Payment_Type__c;
            paymentObj.platformType = PLATFORM_TYPE_TOPS;
        } else {
            paymentObj.paymentType = PAYMENT_TYPE_CHECK;
            paymentObj.platformType = '';
        }
        return paymentObj;
    }

    @AuraEnabled
	public static Map<String, ACET_SAECalloutResult> searchPayment(ACET_ViewPaymentsRequest.PaymentDetailsParams requestObject) {
		Map<String, ACET_SAECalloutResult> returnData = new Map <String, ACET_SAECalloutResult>();
        ACET_ViewPaymentsRequest.PaymentWrapper paymentObj = getPaymentType(requestObject.seriesDesignator, requestObject.checkNumber, requestObject.remitNumber);
        
        if (paymentObj.platformType == PLATFORM_TYPE_TOPS) {
            returnData.put('TOPSResp', new ACET_SAECalloutResult());

        } else if (paymentObj.platformType == PLATFORM_TYPE_COSMOS){
			returnData.put('COSMOSResp', new ACET_SAECalloutResult());
        } else{
            ACET_SAECalloutResult readcheckResp = ACET_ViewPaymentsReadCheckWS.getReadChecData(requestObject.checkNumber,requestObject.seriesDesignator);
			returnData.put('readCheckResp', readcheckResp);
            if(readcheckResp.isSuccess){
                ACET_SAECalloutResult checkSearchResp = ACET_ViewPaymentsCheckSearchWS.getCheckSearchData(requestObject);
                returnData.put('checkSearchResp', checkSearchResp);
            }
        }

        return returnData;

    }

    // US3476420
    @AuraEnabled
	public static ACET_SAECalloutResult doPaymentCheckSearch(ACET_ViewPaymentsRequest.PaymentDetailsParams requestObject) {
        return ACET_ViewPaymentsCheckSearchWS.getCheckSearchData(requestObject);
    }

	public static boolean isAlphaNumeric(String checkNumber) {
		String emailRegex = '^[a-zA-Z0-9]*$';
		Pattern pattern = Pattern.compile(emailRegex);
		Matcher matcher = pattern.matcher(checkNumber);
		if (matcher.matches()) {
			return true;
		}

		return false;
	}

	public static boolean isLastCharacter(String checkNumber) {
		String lastChar = checkNumber.substring(checkNumber.length() - 1);
		if (lastChar == 'A' || lastChar == 'B' || lastChar == 'C' || lastChar == 'D') {
			return true;
		}
		return false;
	}

    public class PaymentWrapper{
        @AuraEnabled public String paymentType {get;set;}
        @AuraEnabled public String platformType {get;set;}
    }

    public class RequestBody {
        @AuraEnabled public Meta meta{get;set;}
        @AuraEnabled public Data data{get;set;}
    }
    
    public class Meta{
        @AuraEnabled public String sourceSystem{get;set;}
        @AuraEnabled public String securityToken{get;set;}
    }
    
    public class Data{
        @AuraEnabled public String searchType{get;set;}	
        @AuraEnabled public String seriesDesignator{get;set;}
        @AuraEnabled public String checkNumber{get;set;}
        @AuraEnabled public String accountNumber{get;set;}
        @AuraEnabled public String policyNumber{get;set;}
        @AuraEnabled public String subscriberId{get;set;}
        @AuraEnabled public String firstName{get;set;}
        @AuraEnabled public String lastName{get;set;}
        @AuraEnabled public String draftStatus{get;set;}
        @AuraEnabled public PagingState pagingState{get;set;}
    }
    
    public class PagingState{
        @AuraEnabled public String moreData{get;set;}
        @AuraEnabled public String nextKey{get;set;}
    }

}