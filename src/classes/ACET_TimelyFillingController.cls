public class ACET_TimelyFillingController {
    public class timelyFillingInputs {
        @AuraEnabled public String controctorID {get;set;}
    }
    
    public class SearchResultWrapper{
        @AuraEnabled public ACET_AutoDocUtil.CardDetails  timelyFillingSummry {get;set;}
        @AuraEnabled public String message {get;set;}
        @AuraEnabled public Integer statusCode {get;set;}
    }
    @AuraEnabled
    public static SearchResultWrapper getTimelyFillingDetails(String controctorID,String firstSrvDate,String Platform, string ClaimNumber){
        system.debug('controctorID'+controctorID);
        ACET_TimelyFillingWS claimService = new ACET_TimelyFillingWS();
        ACETWSCalloutResult CalloutResult = null;
        Integer days = 0;
        SearchResultWrapper searchResultWrapper = new SearchResultWrapper();
        if(controctorID != null || controctorID!=''){
        CalloutResult = claimService.getClaimWS(controctorID);
            System.debug('CalloutResult is:'+CalloutResult);
        ACET_TimelyFillingWS.SAETimelyFillingResult resultwrap = new ACET_TimelyFillingWS.SAETimelyFillingResult();
        if (CalloutResult != null && CalloutResult.Success){

            resultwrap = (ACET_TimelyFillingWS.SAETimelyFillingResult)CalloutResult.Response;
            Date d = date.parse(firstSrvDate);
            days = integer.valueOf(resultwrap.Provider_TF);
            date d1=d.addDays(days);
            string TFL_Date = d1.format();
            SAETimelyFillingResults info = new SAETimelyFillingResults();
            info.Provider_TF=resultwrap.Provider_TF;
            info.TFL_Date=TFL_Date;
            searchResultWrapper.timelyFillingSummry = createTimelyFillingDetails(info,Platform,ClaimNumber );
            searchResultWrapper.statusCode = 200;
            system.debug('TFL_Date'+info.TFL_Date);
            system.debug('Provider TFL'+info.Provider_TF);

            }else{
                System.debug('CalloutResult failed No results found');
                Object res = CalloutResult.Response;
                if (res != null){
                    String resString = JSON.serialize(res);
                    Map<String, Object> httpResponseJSON = (Map<String, Object>) JSON.deserializeUntyped(resString);
                    String messageSer = String.isNotBlank((String)httpResponseJSON.get('Message')) ? (String)httpResponseJSON.get('Message') : '';
                    integer statusCode = (integer)httpResponseJSON.get('statusCode');
                    searchResultWrapper.message= messageSer;
                    //searchResultWrapper.isSuccess = false;
                    searchResultWrapper.statusCode = statusCode;
                    //added by sravani end
                }
            }
        }else{
            SAETimelyFillingResults info = new SAETimelyFillingResults();
            searchResultWrapper.timelyFillingSummry = createTimelyFillingDetails(info,'','');
            searchResultWrapper.statusCode = 200;
        }

        return searchResultWrapper;

    }

    @AuraEnabled
    public static SearchResultWrapper getControctorDetails(String taxId,String providerId,String marketType,String marketSite,String productCode)
    {
        SearchResultWrapper searchResultWrapper = new SearchResultWrapper();
        ACET_TimelyFillingWS claimService = new ACET_TimelyFillingWS();
        ACETWSCalloutResult CalloutResult = null;
        string contractorid = null;
        CalloutResult = claimService.getContracorid(taxId,providerId,marketType,marketSite,productCode);
        system.debug('test 48'+CalloutResult.Response);
        if(CalloutResult != null && CalloutResult.Success){
            searchResultWrapper.statusCode = calloutResult.statusCode;
            searchResultWrapper.message = string.valueof(CalloutResult.Response);
        }else{
            System.debug('CalloutResult failed No results found');
            Object res = CalloutResult.Response;
            if (res != null){
                String resString = JSON.serialize(res);
                Map<String, Object> httpResponseJSON = (Map<String, Object>) JSON.deserializeUntyped(resString);
                String messageSer = String.isNotBlank((String)httpResponseJSON.get('Message')) ? (String)httpResponseJSON.get('Message') : '';
                integer statusCode = (integer)httpResponseJSON.get('statusCode');
                searchResultWrapper.message= messageSer;
                //searchResultWrapper.isSuccess = false;
                searchResultWrapper.statusCode = statusCode;
                //added by sravani end
            }
        }
       /* ACET_TimelyFillingWS.ContractorDetailsResult resultwrap = new ACET_TimelyFillingWS.ContractorDetailsResult();
        if (CalloutResult != null && CalloutResult.Success){
            resultwrap = (ACET_TimelyFillingWS.ContractorDetailsResult)CalloutResult.Response;
            contractorid=resultwrap.Contractorid;
        }*/
        system.debug('Contractor id 55'+contractorid);
        return searchResultWrapper;
    }

    public static ACET_AutoDocUtil.CardDetails createTimelyFillingDetails(SAETimelyFillingResults rwrap,string Platform,string ClaimNumber){

        ACET_AutoDocUtil.CardDetails cardDetails = new ACET_AutoDocUtil.CardDetails();
        cardDetails.componentName = 'Timely Filing: '+claimNumber;
        // US3653575
        cardDetails.reportingHeader = 'Timely Filing';
        cardDetails.caseItemsExtId = claimNumber;
        cardDetails.componentOrder = 8;
        cardDetails.type = 'card';
        cardDetails.noOfColumns = 'slds-size_4-of-12';

        List < ACET_AutoDocUtil.FieldDetails > cardData = new List < ACET_AutoDocUtil.FieldDetails > ();
        if(Platform == 'UNET' && rwrap !=null){
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Provider TFL', rwrap.Provider_TF != null ? rwrap.Provider_TF : '--' , 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'TFL Code', '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'TFL Date',rwrap.TFL_Date, 'outputText',true));
            cardDetails.cardData = cardData;
          }else{
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Provider TFL', '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'TFL Code', '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'TFL Date', '--', 'outputText',true));
            cardDetails.cardData = cardData;
        }
              return cardDetails;
    }
     public class SAETimelyFillingResults{
        @AuraEnabled public String Provider_TF {get;set;}
        @AuraEnabled public String TFL_Date {get;set;}
     }
}