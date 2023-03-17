public without sharing class SAEClaimSearchController {
    public static String prvres='PRV RESP';
    public static String payNum = 'PAYMENT #';
    public static String nySUR = 'NY SUR';
    public static String nySURNmr = 'NY SUR #';
    public static String memres ='MEM RESP';
    public static String link ='link';
    public static String noResultfoundMessage ='No Matching Claim Results Found';
	public class SearchResultWrapper{
    	@AuraEnabled public ACET_AutoDocUtil.TableDetails claimSearchResult {get;set;}
        @AuraEnabled public List<ACET_AutoDocUtil.CardDetails>  claimSummayByClaim {get;set;}
        @AuraEnabled public List<ACET_AutoDocUtil.TableDetails>  claimAdditionalInfoByClaim {get;set;}
        @AuraEnabled public List<ACET_AutoDocUtil.TableDetails>  claimStatusByClaim {get;set;}
        @AuraEnabled public List<ACET_AutoDocUtil.CardDetails>  inOutPatientDetails {get;set;}
        @AuraEnabled public List<memberInfo>  memberInfo {get;set;}
        @AuraEnabled public string message {get;set;}
        @AuraEnabled public integer statusCode {get;set;}
        @AuraEnabled public Boolean showToastMessage { get; set; }
    }

    public class memberInfo{
        @AuraEnabled public String claimno{get;set;}
        @AuraEnabled public String ptntFn{get;set;}
        @AuraEnabled public String ptntLn{get;set;}
        @AuraEnabled public String ptntDob{get;set;}
        @AuraEnabled public String receivedDate {get;set;}
        @AuraEnabled public String platform {get;set;}
        @AuraEnabled public String policyNbr {get;set;}
        @AuraEnabled public String sbmtMembrId{get;set;}
        @AuraEnabled public String referralId{get;set;}
        }

    public class ClaimInputs {
        @AuraEnabled public String claimNumber {get;set;}
        @AuraEnabled public String taxId {get;set;}
        @AuraEnabled public String ClaimType {get;set;}
        @AuraEnabled public String FromDate {get;set;}
        @AuraEnabled public String ToDate {get;set;}
        @AuraEnabled public String AuthId {get;set;}
        @AuraEnabled public String selectedop{get;set;}
        @AuraEnabled public String memberId {get;set;}
        @AuraEnabled public String memberDOB {get;set;}
        @AuraEnabled public String payerId {get;set;}
        @AuraEnabled public boolean initailClaims {get;set;}
        @AuraEnabled public string startDateCompare {get; set;}
        @AuraEnabled public boolean isFromPayments {get;set;}
        @AuraEnabled public String sourceCode {get;set;}

    }
    private static List<String> tableHeader=new List<String>{'CLAIM #','TAX ID','PROVIDER ID','PROVIDER NAME','SERVICE DATES','CHARGED','STATUS','RECEIVED DATE','PROCESSED DATE'};

  	@AuraEnabled
    public static SearchResultWrapper getClaimsAutodoc(ClaimInputs claimInputs,boolean isDeductible,boolean isApplied, Integer start,Boolean isMoreThan90days){
        SAEClaimSearchResult resultwrap = new SAEClaimSearchResult();
        List<SAEClaimSearchResult.ClaimSearchResult> rwrap = new List<SAEClaimSearchResult.ClaimSearchResult>();
        SAEClaimSearchWS claimService = new SAEClaimSearchWS();
        list<ACETWSCalloutResult> CalloutResultList = New list<ACETWSCalloutResult>();
        ACETWSCalloutResult CalloutResult0 = null;
         System.debug(LoggingLevel.INFO, 'claimInputs' + claimInputs);
        
        // make callout for default 90 days
        IF(!isMoreThan90days || string.isNotBlank(claimInputs.claimNumber)){
       // tDate= fDate.addDays(90);
            //claimInputs.FromDate = fDate.format();
            //claimInputs.ToDate = tDate.format();
            System.debug(LoggingLevel.INFO, 'claimInputs2 ' + claimInputs);
        CalloutResult0 = claimService.getClaimWS(claimInputs);
        system.debug('callout result default '+CalloutResult0);
        
        //adding result to list
        CalloutResultList.add(CalloutResult0);
        }        
        // make multiple callout if days greater then 90
        else if(isMoreThan90days){
            date fromDate = Date.parse(claimInputs.FromDate);
            date toDate = Date.parse(claimInputs.ToDate);
            Integer noOfDays = fromDate.daysBetween(toDate);

            date fDate = fromDate;
            date tDate = toDate;

            // set provided todate to a variable
            tDate = toDate;
            for(integer i = 0;i <= noOfDays/90;i++){
                fDate = fromDate;
                if(fromDate.addDays(90) > toDate){
                        tDate = toDate;
                }else{
                    tDate = fromDate.addDays(90);
                }
                //claimInputs.FromDate = fDate.format();
                //claimInputs.ToDate = tDate.format();

                claimInputs.FromDate = getformatDate(fDate);
                claimInputs.ToDate = getformatDate(tDate);
                
                ACETWSCalloutResult CalloutResult1 = null;
                CalloutResult1 = claimService.getClaimWS(claimInputs);
                CalloutResultList.add(CalloutResult1);
                fromDate =tDate+1;
                if(fromDate > toDate){
                               break;
                }
            }
        }
        SearchResultWrapper searchResultWrapper = new SearchResultWrapper();
        Boolean IsSucess= false;
         if(CalloutResultList.size() > 0){
            
            for(ACETWSCalloutResult CalloutResult : CalloutResultList){
        if (CalloutResult != null && CalloutResult.Success){
        		resultwrap = (SAEClaimSearchResult)CalloutResult.Response;
                List<SAEClaimSearchResult.ClaimSearchResult> rwrapTemp = resultwrap.claimResultLst;
                 if(isApplied){
                     for(SAEClaimSearchResult.ClaimSearchResult results: rwrapTemp){
                         if((results.totalDeductibleAmt!='--')|| (results.totalCoinsuranceAmt!='--'))
                         	rwrap.add(results);
                     }
    			 }
                 else if (isDeductible){
                      for(SAEClaimSearchResult.ClaimSearchResult results: rwrapTemp){
                         if(results.totalDeductibleAmt!='--')
                         	rwrap.add(results);
                 		}
                 }
                 else{
                        //rwrap = rwrapTemp;
                        rwrap.addAll(rwrapTemp);
                 }

                    /*List<SAEClaimSearchResult.ClaimSearchResult> rwraptest45 = sortDates(rwrap);

                searchResultWrapper.claimSearchResult = createClaimSearchResults(rwrap,claimInputs);
                searchResultWrapper.claimSummayByClaim = createClaimSummaryByClaim(rwrap);
                searchResultWrapper.claimStatusByClaim = createClaimStatusByClaim(rwrap);
                    searchResultWrapper.memberInfo=memberinfoByClaim(rwrap);*/
            	searchResultWrapper.statusCode = 200;
                    system.debug('@sucess');
                    IsSucess = true;
         }
        else{
            searchResultWrapper.claimSearchResult = ClaimSearchnotFound();
            Object res = CalloutResult.Response;
            if (res != null){
            String resString = JSON.serialize(res);
            Map<String, Object> httpResponseJSON = (Map<String, Object>) JSON.deserializeUntyped(resString);
            String messageSer = String.isNotBlank((String)httpResponseJSON.get('Message')) ? (String)httpResponseJSON.get('Message') : '';
            integer statusCode = (integer)httpResponseJSON.get('statusCode');
            searchResultWrapper.message = messageSer;
            searchResultWrapper.statusCode = statusCode;

            Boolean showToastMessage = (Boolean)httpResponseJSON.get('showToastMessage');
            searchResultWrapper.showToastMessage= showToastMessage;
                    }
                    system.debug('@error'+searchResultWrapper);
                }
            }
        }
        if(claimInputs.isFromPayments!= null && claimInputs.isFromPayments) {
            System.debug('claimInputs.isFromPayments' + rwrap[0].claimType);
            claimInputs.ClaimType = rwrap[0].claimType;
        }
        if( searchResultWrapper.statusCode == 200 || IsSucess){
            List<SAEClaimSearchResult.ClaimSearchResult> rwraptest45 = sortDates(rwrap);

            searchResultWrapper.claimSearchResult = createClaimSearchResults(rwrap,claimInputs);
            searchResultWrapper.claimSummayByClaim = createClaimSummaryByClaim(rwrap);
            searchResultWrapper.inOutPatientDetails = createInpatientOutpatientByClaim(rwrap);
            searchResultWrapper.claimAdditionalInfoByClaim = createClaimsAdditionalInfoByClaim(rwrap);
            searchResultWrapper.claimStatusByClaim = createClaimStatusByClaim(rwrap,claimInputs);
            searchResultWrapper.memberInfo  = memberinfoByClaim(rwrap);
            searchResultWrapper.statusCode = 200;
        }

         return searchResultWrapper;
    }

    private static ACET_AutoDocUtil.TableDetails createClaimSearchResults(List<SAEClaimSearchResult.ClaimSearchResult> rwrap, ClaimInputs claimInputs){

        Integer rcount =0;
        ACET_AutoDocUtil.TableDetails lookupTable = new ACET_AutoDocUtil.TableDetails();
        lookupTable.type = 'table';
        lookupTable.showComponentName = false;
        lookupTable.componentOrder = 3;
        lookupTable.caseItemsEnabled = true;
        lookupTable.componentName = 'Claim Results';
        lookupTable.autodocHeaderName = 'Claim Results';
        lookupTable.tableHeaders = tableHeader;
        List<ACET_AutoDocUtil.TableRow> tableRows = new List<ACET_AutoDocUtil.TableRow>();
        List<ACET_AutoDocUtil.TableRow> selectedRows = new List<ACET_AutoDocUtil.TableRow>();
        if(lookupTable != null){
            System.debug('rwrap size:'+rwrap.size());
            if(rwrap.size()>0){
                for(Integer i=rwrap.size()-1;i>=0;i--){

                    if((rwrap[i].claimType=='H'&& claimInputs.ClaimType=='H')||(rwrap[i].claimType=='I'&& claimInputs.ClaimType=='H')){


                     rcount=rcount+1;
					ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                    tableRow.checked = false;
                    tableRow.uniqueKey = String.valueof(Math.random()).substring(3,13);
                    tableRow.caseItemsExtId = rwrap[i].claimNumber;
                    tableRow.resolved = false;
                    tableRow.linkDisabled = false;
                    tableRow.checkBoxDisabled = false;
                    tableRow.additionalData = new Map<String,Object>();
                    tableRow.additionalData.put('ClaimType', rwrap[i].claimType ) ;
					tableRow.additionalData.put('NetworkStatus', rwrap[i].networkStatus); //Added by Raviteja 05/05/2021 for US3502296 Team Blinkers
					tableRow.additionalData.put('billtype', rwrap[i].billTyp); //Added by Raviteja 10/05/2021 for US3502296 Team Blinkers
                    tableRow.additionalData.put('TopsAdditionalInfo', rwrap[i].TopsAdditionalInfo);
                    tableRow.additionalData.put('platform', rwrap[i].platform);



					List<ACET_AutoDocUtil.RowColumnData> rowColumns = new List<ACET_AutoDocUtil.RowColumnData>();
                    //rowColumns.add(ACET_AutoDocUtil.setRowColumnData('link', rwrap[i].claimNumber,'CLAIM #'));
                     rowColumns.add(ACET_AutoDocUtil.setRowColumnData('link', rwrap[i].claimNumber,'CLAIM #',rwrap[i].claimNumber,'overflow: hidden;'));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', rwrap[i].taxID,'TAX ID'));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', rwrap[i].providerID,'PROVIDER ID'));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', rwrap[i].providerName,'PROVIDER NAME'));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', rwrap[i].DOSStart+' - '+rwrap[i].DOSEnd,'SERVICE DATES'));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Currency', rwrap[i].charged,'CHARGED',''));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', rwrap[i].status,'STATUS'));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', rwrap[i].receivedDate,'RECEIVED DATE'));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', rwrap[i].processDate,'PROCESSED DATE'));

                    tableRow.rowColumnData = rowColumns;
                    tableRows.add(tableRow);
                    }
                    else if(rwrap[i].claimtype=='P'&&claimInputs.ClaimType=='P'){
                    rcount=rcount+1;
					ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                    tableRow.checked = false;
                    tableRow.uniqueKey = String.valueof(Math.random()).substring(3,13);
                    tableRow.caseItemsExtId = rwrap[i].claimNumber;
                    tableRow.resolved = false;
                    tableRow.linkDisabled = false;
                    tableRow.checkBoxDisabled = false;
                    tableRow.additionalData = new Map<String,Object>();
                    tableRow.additionalData.put('ClaimType', rwrap[i].claimType ) ;
					tableRow.additionalData.put('NetworkStatus', rwrap[i].networkStatus); //Added by Raviteja 05/05/2021 for US3502296 Team Blinkers
					tableRow.additionalData.put('billtype', rwrap[i].billTyp); //Added by Raviteja 10/05/2021 for US3502296 Team Blinkers
                    tableRow.additionalData.put('TopsAdditionalInfo', rwrap[i].TopsAdditionalInfo);
                    tableRow.additionalData.put('platform', rwrap[i].platform);


					List<ACET_AutoDocUtil.RowColumnData> rowColumns = new List<ACET_AutoDocUtil.RowColumnData>();
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('link', rwrap[i].claimNumber,'CLAIM #',rwrap[i].claimNumber,'overflow: hidden;'));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', rwrap[i].taxID,'TAX ID'));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', rwrap[i].providerID,'PROVIDER ID'));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', rwrap[i].providerName,'PROVIDER NAME'));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', rwrap[i].DOSStart+' - '+rwrap[i].DOSEnd,'SERVICE DATES'));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Currency', rwrap[i].charged,'CHARGED',''));//US2992845 - Update Dollar Sign Icon to Match Style Guide - Praveen 21/01/2021
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', rwrap[i].status,'STATUS'));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', rwrap[i].receivedDate,'RECEIVED DATE'));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', rwrap[i].processDate,'PROCESSED DATE'));

                    tableRow.rowColumnData = rowColumns;
                    tableRows.add(tableRow);
                    }
                    else if(claimInputs.ClaimType=='AllIntial' || claimInputs.ClaimType=='A' || claimInputs.ClaimType=='All'){
                     rcount=rcount+1;
					ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                    tableRow.checked = false;
                    tableRow.uniqueKey = String.valueof(Math.random()).substring(3,13);
                    tableRow.caseItemsExtId = rwrap[i].claimNumber;
                    tableRow.resolved = false;
                    tableRow.linkDisabled = false;
                    tableRow.checkBoxDisabled = false;
                    tableRow.additionalData = new Map<String,Object>();
                    tableRow.additionalData.put('ClaimType', rwrap[i].claimType ) ;
					tableRow.additionalData.put('NetworkStatus', rwrap[i].networkStatus); //Added by Raviteja 05/05/2021 for US3502296 Team Blinkers
                    tableRow.additionalData.put('billtype', rwrap[i].billTyp); //Added by Raviteja 10/05/2021 for US3502296 Team Blinkers
                    tableRow.additionalData.put('TopsAdditionalInfo', rwrap[i].TopsAdditionalInfo);
                    tableRow.additionalData.put('platform', rwrap[i].platform);

					List<ACET_AutoDocUtil.RowColumnData> rowColumns = new List<ACET_AutoDocUtil.RowColumnData>();
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('link', rwrap[i].claimNumber,'CLAIM #',rwrap[i].claimNumber,'overflow: hidden;'));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', rwrap[i].taxID,'TAX ID'));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', rwrap[i].providerID,'PROVIDER ID'));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', rwrap[i].providerName,'PROVIDER NAME'));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', rwrap[i].DOSStart+' - '+rwrap[i].DOSEnd,'SERVICE DATES'));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Currency', rwrap[i].charged,'CHARGED',''));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', rwrap[i].status,'STATUS'));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', rwrap[i].receivedDate,'RECEIVED DATE'));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', rwrap[i].processDate,'PROCESSED DATE'));

                    tableRow.rowColumnData = rowColumns;
                    tableRows.add(tableRow);
                    }
              	}
                if(rcount<=0){
                    ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow.checked = true;
                tableRow.resolved = true;
                tableRow.isResolvedDisabled = true;
                lookupTable.caseItemsEnabled = true;
                tableRow.caseItemsExtId = noResultfoundMessage;
                tableRow.uniqueKey = noResultfoundMessage;
                tableRow.rowColumnData = innitializeTableColumn();
                tableRows.add(tableRow);
                selectedRows.add(tableRow);
                }
            }else{
				ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow.checked = true;
                tableRow.resolved = true;
                tableRow.isResolvedDisabled = true;
                lookupTable.caseItemsEnabled = true;
                tableRow.caseItemsExtId = noResultfoundMessage;
                tableRow.uniqueKey = noResultfoundMessage;
                tableRow.rowColumnData = innitializeTableColumn();
                tableRows.add(tableRow);
                selectedRows.add(tableRow);
          }
        }
		lookupTable.tableBody = tableRows;
        lookupTable.selectedRows = selectedRows;
        Integer totalRecords = Integer.valueOf(rcount);
        Integer noOfPages = (Integer) Math.ceil((Decimal)totalRecords/100);
        Integer startNo = (totalRecords>0)?1:0;
        Integer endNo = (totalRecords>100)?100:totalRecords;

        lookupTable.startNumber = startNo;
        lookupTable.endNumber = endNo;
        lookupTable.recordCount = totalRecords;
        lookupTable.noOfPages = noOfPages;

        return lookupTable;
    }


    private static List<ACET_AutoDocUtil.CardDetails> createClaimSummaryByClaim (List<SAEClaimSearchResult.ClaimSearchResult> rwrap){

        List<ACET_AutoDocUtil.CardDetails> resMap = new List<ACET_AutoDocUtil.CardDetails>();
        for(SAEClaimSearchResult.ClaimSearchResult clm: rwrap ){

            ACET_AutoDocUtil.CardDetails cardDetails = new ACET_AutoDocUtil.CardDetails();
            cardDetails.type = 'card';
            cardDetails.componentOrder = 4 ;
            cardDetails.componentName = 'Claim Summary: '+ clm.claimNumber;
            cardDetails.noOfColumns = 'slds-size_4-of-12';

            // US3653575
            cardDetails.reportingHeader = 'Claim Summary';
            cardDetails.caseItemsExtId = clm.claimNumber;

			String prfx = clm.tinPrfx +'-';
            String sufx = '-' + clm.tinSufx;
            String tin = clm.tin;
            String papOREle = '--';
            String adjTax = '--';
            if(prfx != null && sufx != null && tin != null && prfx != '---' && sufx != '---'){
                adjTax = prfx+tin+sufx ;
            }
            papOREle=getPapOrEle(clm.paperlessInd);
            List < ACET_AutoDocUtil.FieldDetails > cardData = new List < ACET_AutoDocUtil.FieldDetails > ();
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Billing Provider / Status', clm.providerName, link,true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Billing Tax ID', clm.taxID, 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Billing  Provider ID',getfieldValue(clm.providerID), 'outputText',true));// clm.providerID !=null ? clm.providerID :'--'
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Adjudicated Provider / Status', clm.adjProviderName, link,true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Adjudicated Tax ID', adjTax, 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Adjudicated Provider ID',getfieldValue(clm.adjProviderID) , 'outputText',true));//clm.adjProviderID !=null ? clm.adjProviderID :'--'
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Service Dates', clm.DOSStart+' - '+clm.DOSEnd, 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Received',clm.receivedDate, 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Claim Form',clm.claimType == 'P' ? 'HCFA 1500 / '+papOREle : 'UB04 / '+papOREle, 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Cause Code','--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Patient Account #',getfieldValue(clm.ptntAcctNbr), 'outputText',true));//clm.ptntAcctNbr != null ? clm.ptntAcctNbr : '--'
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Keyed Claim #', getfieldValue(clm.caeClmNbr) ,'outputText',true));//clm.caeClmNbr !=null ? clm.caeClmNbr :'--'
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Original Claim #', getfieldValue(clm.resubmCaeClmNbr) ,'outputText',true));//clm.resubmCaeClmNbr !=null ? clm.resubmCaeClmNbr :'--'
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Type',clm.paperlessInd !=null ? clm.paperlessInd == 'Y'? 'Electronic' : 'Paper' :'--', 'outputText',true));
            ACET_AutoDocUtil.FieldDetails adjTaxId=new ACET_AutoDocUtil.FieldDetails(false, false, true, 'AdjTaxID', getfieldValue(clm.adjTaxID) , '');//clm.adjTaxID !=null ? clm.adjTaxID :'--'
            adjTaxId.hideField=true;
            adjTaxId.showCheckbox=false;
            cardData.add(adjTaxId);
            ACET_AutoDocUtil.FieldDetails cid =new ACET_AutoDocUtil.FieldDetails(false, false, true, 'contractId', clm.contractId !=null ? clm.contractId :'', '');
            cid.hideField=true;
            cid.showCheckbox=false;
            cardData.add(cid);
            ACET_AutoDocUtil.FieldDetails adjservicingMpin=new ACET_AutoDocUtil.FieldDetails(false, false, true, 'adjservicingMpin', clm.adjservicingMpin, '');
            adjservicingMpin.hideField=true;
            cardData.add(adjservicingMpin);
            ACET_AutoDocUtil.FieldDetails claimIdField = new ACET_AutoDocUtil.FieldDetails(false, false, true, 'claimId',getfieldValue(clm.claimNumber) , '');//clm.claimNumber !=null ? clm.claimNumber :'--'
            claimIdField.hideField=true;
            cardData.add(claimIdField);
            ACET_AutoDocUtil.FieldDetails claimStatusField=new ACET_AutoDocUtil.FieldDetails(false, false, true, 'claimStatus', getfieldValue(clm.status), ''); //clm.status !=null ? clm.status :'--'
            claimStatusField.hideField=true;
            cardData.add(claimStatusField);
            cardDetails.cardData = cardData;
            resMap.add(cardDetails);
        }
        return resMap;
   }

    private static String getPapOrEle(String value){
        String papOREle = '--';
        if(value=='N')
            papOREle='Paper';
        else if(value=='Y')
            papOREle='Electronic';
        return papOREle;
    }

    private static List<ACET_AutoDocUtil.TableDetails> createClaimsAdditionalInfoByClaim(List<SAEClaimSearchResult.ClaimSearchResult> rwrap){
        List<ACET_AutoDocUtil.TableDetails> resMap = new List<ACET_AutoDocUtil.TableDetails>();
        if(rwrap != null){
            for(SAEClaimSearchResult.ClaimSearchResult clm: rwrap ){
                ACET_AutoDocUtil.TableDetails additionalInfoTable = new ACET_AutoDocUtil.TableDetails();
                additionalInfoTable.type = 'table';
                additionalInfoTable.showComponentName = false;
                additionalInfoTable.componentName = 'Additional Information: '+ clm.claimNumber;
                additionalInfoTable.autodocHeaderName = 'Additional Information: '+ clm.claimNumber;
                additionalInfoTable.componentOrder = 19;
                additionalInfoTable.tableHeaders = new List < String > {'Code','Description','Tool Tip','SOP'};
                    //Table body
                    List < ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();
                if(clm.claimCodes != null){
                    for(SAEClaimSearchResult.cls_claimCodes codesRec : clm.claimCodes){
                        ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                        tableRow.checked = false;
                        tableRow.uniqueKey = clm.claimNumber;
                        List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', codesRec.code != null ? codesRec.code :'--', 'CODE'));
                        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', codesRec.description != null ? codesRec.description.length()<100 ? codesRec.description : codesRec.description.substring(0, 99)+'...' :'--', 'Description',codesRec.description));
                        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '--', 'Tool Tip'));
                        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '--', 'SOP'));
                        tableRow.rowColumnData = rowColumns;
                        tableRows.add(tableRow);
                    }
                }else{
                    ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                    tableRow.checked = false;
                    tableRow.uniqueKey = clm.claimNumber;
                    List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '--', 'CODE'));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '--', 'Description'));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '--', 'Tool Tip'));
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '--', 'SOP'));
                    tableRow.rowColumnData = rowColumns;
                    tableRows.add(tableRow);
                }
                additionalInfoTable.tableBody = tableRows;
                resMap.add(additionalInfoTable);
            }
        }
        return resMap;
    }

    @AuraEnabled
    public static List<ACET_AutoDocUtil.TableDetails> createClaimStatusByClaim(List<SAEClaimSearchResult.ClaimSearchResult> rwrap,ClaimInputs claimInputs) {
         system.debug('sourceCode'+claimInputs);
         List<ACET_AutoDocUtil.TableDetails> resMap = new List<ACET_AutoDocUtil.TableDetails>();
         for(SAEClaimSearchResult.ClaimSearchResult claim: rwrap ){
            ACET_AutoDocUtil.TableDetails claimStatusTable = new ACET_AutoDocUtil.TableDetails();
            claimStatusTable.type = 'table';
            claimStatusTable.componentOrder = 6;
            // US3653575
            claimStatusTable.showComponentName = true;
            claimStatusTable.reportingHeader = 'Claim Status';
            claimStatusTable.componentName = 'Claim Status: '+ claim.claimNumber ;
            claimStatusTable.autodocHeaderName = 'Claim Status: '+ claim.claimNumber;
              List < String >  headers=new List < String > {
                'V', 'PROCESSED', 'STATUS', 'BENEFIT LEVEL',
			'CHARGED', 'ALLOWED', 'DENIED', 'DED', 'COPAY', 'COINS',
			'PAID',prvres,memres,payNum,'INTEREST', 'RESERVE'
            };
                List<ACET_AutoDocUtil.HoverHeader> hoverList = new List<ACET_AutoDocUtil.HoverHeader>();
             ACET_AutoDocUtil.HoverHeader v = new ACET_AutoDocUtil.HoverHeader();
             v.popupId ='V';
             v.headerValue = 'V';
             hoverList.add(V);
             ACET_AutoDocUtil.HoverHeader pro = new ACET_AutoDocUtil.HoverHeader();
             pro.popupId ='PROCESSED';
             pro.headerValue = 'PROCESSED';
             hoverList.add(pro);
             ACET_AutoDocUtil.HoverHeader status = new ACET_AutoDocUtil.HoverHeader();
             status.popupId ='STATUS';
             status.headerValue = 'STATUS';
             hoverList.add(status);
             ACET_AutoDocUtil.HoverHeader bl = new ACET_AutoDocUtil.HoverHeader();
             bl.popupId ='BENEFIT LEVEL';
             bl.headerValue = 'BENEFIT LEVEL';
             hoverList.add(bl);
             ACET_AutoDocUtil.HoverHeader cr = new ACET_AutoDocUtil.HoverHeader();
             cr.popupId ='CHARGED';
             cr.headerValue = 'CHARGED';
             hoverList.add(cr);
             ACET_AutoDocUtil.HoverHeader al = new ACET_AutoDocUtil.HoverHeader();
             al.popupId ='ALLOWED';
             al.headerValue = 'ALLOWED';
             hoverList.add(al);
             ACET_AutoDocUtil.HoverHeader de = new ACET_AutoDocUtil.HoverHeader();
             de.popupId ='DENIED';
             de.headerValue = 'DENIED';
             hoverList.add(de);
             ACET_AutoDocUtil.HoverHeader ded = new ACET_AutoDocUtil.HoverHeader();
             ded.popupId ='DED';
             ded.headerValue = 'DED';
             hoverList.add(ded);
             ACET_AutoDocUtil.HoverHeader co = new ACET_AutoDocUtil.HoverHeader();
             co.popupId ='COPAY';
             co.headerValue = 'COPAY';
             hoverList.add(co);
             ACET_AutoDocUtil.HoverHeader coin = new ACET_AutoDocUtil.HoverHeader();
             coin.popupId ='COINS';
             coin.headerValue = 'COINS';
             hoverList.add(coin);
             ACET_AutoDocUtil.HoverHeader paid = new ACET_AutoDocUtil.HoverHeader();
             paid.popupId ='PAID';
             paid.headerValue = 'PAID';
             hoverList.add(paid);
             ACET_AutoDocUtil.HoverHeader prv = new ACET_AutoDocUtil.HoverHeader();
             prv.popupId = prvres;
             prv.headerValue = prvres;
             hoverList.add(prv);
             ACET_AutoDocUtil.HoverHeader mem = new ACET_AutoDocUtil.HoverHeader();
             mem.popupId =memres;
             mem.headerValue = memres;
             hoverList.add(mem);
             ACET_AutoDocUtil.HoverHeader pay = new ACET_AutoDocUtil.HoverHeader();
             pay.popupId =payNum;
             pay.headerValue = payNum;
             hoverList.add(pay);
             ACET_AutoDocUtil.HoverHeader inte = new ACET_AutoDocUtil.HoverHeader();
             inte.popupId ='INTEREST';
             inte.headerValue = 'INTEREST';
             hoverList.add(inte);
             ACET_AutoDocUtil.HoverHeader rev = new ACET_AutoDocUtil.HoverHeader();
             rev.popupId ='RESERVE';
             rev.headerValue = 'RESERVE';
             rev.hasHover = true;
             rev.alignRight = true;
             rev.hoverWidth = '800px';
             rev.hoverDescription='The COB Credit Reserve (CCR) is an additional benefit to the COW Provision. If the normal benefit exceeds the COW amount, the excess is a COB Savings (the amount saved by being secondary and not paying the entire normal benefit).';
             hoverList.add(rev);
            List < ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();

             Integer count = 1;
             if(true){
                 SAEClaimSearchResult.ClaimSearchResult clm = claim;
                 ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                 tableRow.checked = false;
                 tableRow.uniqueKey = clm.claimNumber;
                //  US3653575
                tableRow.caseItemsExtId = claim.claimNumber;
                 List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                 rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', ''+count,'V'));
                 rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', clm.processDate,'PROCESSED'));
                 rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', clm.status,'STATUS'));
                 rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', clm.claimBenefitlevel,'BENEFIT LEVEL'));
                 rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Currency', clm.totalChargedAmt,'CHARGED'));
                 rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Currency', clm.totalAllowdAmt,'ALLOWED'));
                 rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Currency', clm.totalDeniedAmount,'DENIED'));
                 rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Currency', clm.totalDeductibleAmt,'DED'));
                 rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Currency', clm.totalCopayAmt,'COPAY'));
                 rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Currency', clm.totalCoinsAmt,'COIN'));
                 rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Currency', clm.totalPaidAmt,'PAID'));
                 rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Currency', clm.provWriteOffAmt,prvres));
                 system.debug('MEMB RESP ********************************'+clm.totalPtntRespAmt);
                 rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Currency', clm.totalPtntRespAmt,memres));
                 if(clm.totalPaidAmt == '0.00' || clm.totalPaidAmt == '0' || clm.totalPaidAmt=='--'){
                     rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '--',payNum));
                 }else{
                     rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Link',clm.chkInfo,payNum));
                 }

               /**  if(clm.interestPaidAmt == '$0.00' || clm.interestPaidAmt == '$0' || clm.interestPaidAmt=='--'){
                 rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '--','INTEREST'));
                 }else{
                     rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Link',clm.interestPaidAmt,'INTEREST'));
                 }**/
                 rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Link','','INTEREST'));
                 rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Currency', '','RESERVE'));
                 if(claimInputs.sourceCode=='CS'){
                     headers.add(nySUR);
                     headers.add(nySURNmr);
                     ACET_AutoDocUtil.HoverHeader nySurAt = new ACET_AutoDocUtil.HoverHeader();
                     nySurAt.popupId =nySUR;
                     nySurAt.headerValue = nySUR;
                     hoverList.add(nySurAt);
                     ACET_AutoDocUtil.HoverHeader nySurLink = new ACET_AutoDocUtil.HoverHeader();
                     nySurLink.popupId =nySURNmr;
                     nySurLink.headerValue =nySURNmr;
                     hoverList.add(nySurLink);
                     rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Currency', '--',nySUR));
                     rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '--',nySURNmr));
                     }
                 claimStatusTable.tableHeaders = headers;
                 claimStatusTable.tableHoverHeaders= hoverList;
                 tableRow.rowColumnData = rowColumns;
                 tableRows.add(tableRow);
                 count ++ ;
             }


            if (rwrap == null || rwrap.isEmpty()) {
                ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow.checked = false;
                tableRow.uniqueKey = 'No records found.';
                // US3653575
                tableRow.caseItemsExtId = claim.claimNumber;
                List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '','V'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '','PROCESSED'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '', 'STATUS'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '','BENEFIT LEVEL'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '','CHARGED'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '','ALLOWED'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', 'No records found.','DENIED'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '','DED'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '','COPAY'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '','COIN'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '','PAID'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '',prvres));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '',memres));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '',payNum));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '','INTEREST'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '','RESERVE'));
                tableRow.rowColumnData = rowColumns;
                tableRows.add(tableRow);
            }
            claimStatusTable.tableBody = tableRows;
            resMap.add(claimStatusTable) ;
        }
		return resMap;
	 }

    @AuraEnabled
    public static List<SAEClaimSearchResult.ClaimSearchResult> sortDates(List<SAEClaimSearchResult.ClaimSearchResult> rwraptemptest){
      List<SAEClaimSearchResult.ClaimSearchResult> temp1 = new List<SAEClaimSearchResult.ClaimSearchResult>();
        if(rwraptemptest.size()>0){
			temp1 = rwraptemptest;

            for(integer i =0; i<rwraptemptest.size(); i++){
                for(integer j=i+1; j<rwraptemptest.size();j++){
                    if(rwraptemptest[i].DOSStart>rwraptemptest[j].DOSStart){
                      SAEClaimSearchResult.ClaimSearchResult res1 = rwraptemptest[i];
                        rwraptemptest[i] = rwraptemptest[j];
                        rwraptemptest[j] = res1;
                    }
                }
            }
        }
        system.debug('after test working'+temp1);
        return temp1;
	 }

    @AuraEnabled
    public static ACET_AutoDocUtil.TableDetails ClaimSearchnotFound(){
        ACET_AutoDocUtil.TableDetails lookupTable = new ACET_AutoDocUtil.TableDetails();
        lookupTable.type = 'table';
        lookupTable.showComponentName = false;
        lookupTable.componentOrder = 3;
        lookupTable.caseItemsEnabled = true;
        lookupTable.componentName = 'Claim Results';
        lookupTable.autodocHeaderName = 'Claim Results';
        lookupTable.tableHeaders =tableHeader;
        List<ACET_AutoDocUtil.TableRow> tableRows = new List<ACET_AutoDocUtil.TableRow>();
        List<ACET_AutoDocUtil.TableRow> selectedRows = new List<ACET_AutoDocUtil.TableRow>();
        ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
        tableRow.checked = true;
        tableRow.resolved = true;
        tableRow.isResolvedDisabled = true;
        tableRow.uniqueKey = noResultfoundMessage;
        tableRow.caseItemsExtId = noResultfoundMessage;
        tableRow.rowColumnData = innitializeTableColumn();
        tableRows.add(tableRow);
        selectedRows.add(tableRow);
        lookupTable.tableBody = tableRows;
        lookupTable.selectedRows = selectedRows;
        lookupTable.startNumber = 1;
        lookupTable.endNumber = 0;
        lookupTable.recordCount = 0;
        lookupTable.noOfPages = 0;
        return lookupTable;
    }

    private static List<memberInfo> memberinfoByClaim(List<SAEClaimSearchResult.ClaimSearchResult> rwrap){

        List<memberInfo> resMap = new List<memberInfo>();

        for(SAEClaimSearchResult.ClaimSearchResult clm: rwrap ){
            memberInfo m = new memberInfo();
            m.ptntLn=clm.ptntLn;
            m.ptntFn=clm.ptntFn;
            m.ptntDob=clm.ptntDob;
            m.sbmtMembrId=clm.sbmtMembrId;
            m.referralId=clm.referralId;
            m.claimno=clm.claimNumber;
            m.receivedDate = clm.receivedDate;
            m.platform = clm.platform;
            m.policyNbr = clm.policyNbr;
            resMap.add(m);
        }
        return resMap;
    }

    private static List<ACET_AutoDocUtil.RowColumnData> innitializeTableColumn(){
    List<ACET_AutoDocUtil.RowColumnData> rowColumns = new List<ACET_AutoDocUtil.RowColumnData>();
                //rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText','','CLAIM #'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '','CLAIM #','','overflow: hidden;'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText','','TAX ID'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText','','PROVIDER ID'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText','','PROVIDER NAME'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText',noResultfoundMessage,'SERVICE DATES'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText','','CHARGED'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText','','STATUS'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText','','RECEIVED DATE'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText','','PROCESSED DATE'));
     return   rowColumns;
    }

    //ACET_MedNecServiceTest
    @AuraEnabled
    public static ACET_SAECalloutResult getUNETResult(ACET_MedNecService.medNecInputParams input){
        system.debug('@inputRequest@'+input);
        ACET_SAECalloutResult finalResult = new ACET_SAECalloutResult();
        List<string> lstOfClaimIds = new list<string>();

        String userToken = (String) Cache.Session.get('local.TOPSProfileInfo.userToken');
        if (String.isBlank(userToken)) {
            ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
            loginflow.validateTopsCredentials();
            userToken = (String) Cache.Session.get('local.TOPSProfileInfo.userToken');
        }
        if(string.isNotBlank(userToken)){
            input.securityToken = userToken;
            ACET_SAECalloutResult medNecResult = ACET_MedNecService.callMedNec(input);
            finalResult = medNecResult;
            if(medNecResult.statusCode == 200){
                ACET_MedNecServiceResponse responseData = (ACET_MedNecServiceResponse) medNecResult.response;
               lstOfClaimIds = getClaimIds(responseData);
                 finalResult.response = lstOfClaimIds;

            }
            else{
                 finalResult.response = lstOfClaimIds;
            }
        }
        else{
            finalResult.isSuccess = false;
            finalResult.Message = 'Secuirty token is Blank';
            finalResult.statusCode = 999;
            finalResult.Response = 'Secuiry token is Blank';
        }

        return finalResult;

    }


    public static List<string> getClaimIds(ACET_MedNecServiceResponse resp ){
        List<string> lstToReturn = new List<string>();
        if(resp!= null && resp.searchResult != null && resp.searchResult.searchOutput != null &&
        resp.searchResult.searchOutput.claims != null  && !resp.searchResult.searchOutput.claims.isEmpty() ){
            for(ACET_MedNecServiceResponse.claims clm : resp.searchResult.searchOutput.claims){
                if(string.isNotBlank(clm.auditControlNumber)){
                    lstToReturn.add(clm.auditControlNumber);
                }
            }
        }
        return lstToReturn;

    }

    public static  string getformatDate(Date dt){
        String sMonth = String.valueof(dt.month());
        String sDay = String.valueof(dt.day());
        if(sMonth.length()==1){
            sMonth = '0' + sMonth;
        }
        if(sDay.length()==1){
            sDay = '0' + sDay;
        }
        String sDate = sMonth + '/'+ sDay+'/'+ String.valueof(dt.year());
        system.debug('=sDate='+sDate);
        return sDate;
    }

    // US3476420
    @AuraEnabled
    public static ACET_SAECalloutResult doPaymentCheckSearch(ACET_ViewPaymentsRequest.PaymentDetailsParams requestObject) {
        return ACET_ViewPaymentsCheckSearchWS.getCheckSearchData(requestObject);
    }

    private static List<ACET_AutoDocUtil.CardDetails> createInpatientOutpatientByClaim (List<SAEClaimSearchResult.ClaimSearchResult> rwrap){
        List<KL_Data__c> dataList= [SELECT Code_Description__c, Code_Type__c, Id, Name FROM KL_Data__c where Code_Type__c = 'Bill Type'];
        Map<String,string> dataMap = new Map<String,string>();
        for(KL_Data__c k : dataList){
            dataMap.put(k.Name,k.Code_Description__c);
        }

        String exceptionDesc = 'Not able to submit notes for no auth denials due to not having the medical necessity amendment in the provider contract.';

        List<ACET_AutoDocUtil.CardDetails> resMap = new List<ACET_AutoDocUtil.CardDetails>();
        for(SAEClaimSearchResult.ClaimSearchResult clm: rwrap ){
            string billTypeDes = '--';
            if(clm.billTyp != null && clm.billTyp != '' && dataMap.containsKey(clm.billTyp)){
                billTypeDes= dataMap.get(clm.billTyp);
            }

            ACET_AutoDocUtil.CardDetails cardDetails = new ACET_AutoDocUtil.CardDetails();
            cardDetails.type = 'card';
            cardDetails.componentOrder = 21;
            cardDetails.componentName = 'In/Outpatient Details: '+ clm.claimNumber;
            // US3653575
            cardDetails.reportingHeader = 'In/Outpatient Details';
            cardDetails.caseItemsExtId = clm.claimNumber;
            cardDetails.noOfColumns = 'slds-size_4-of-12';

            List < ACET_AutoDocUtil.FieldDetails > cardData = new List < ACET_AutoDocUtil.FieldDetails > ();
            ACET_AutoDocUtil.FieldDetails bt = new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Hospital Bill Type', clm.billTyp, 'hoverText', true);
            bt.popupId = String.valueof(DateTime.now().getTime());
            bt.isNubbinLeft = true;
            bt.description = billTypeDes;
            bt.popupWidth = '300px';
            cardData.add(bt);
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Billing DRG', '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, ' Adjudicated DRG', clm.drgNbr, 'outputText',true));
            ACET_AutoDocUtil.FieldDetails ce = new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Contract Exceptions', 'N', 'hoverText', true);
            ce.popupId = String.valueof(DateTime.now().getTime());
            ce.isNubbinLeft = true;
            ce.description = exceptionDesc;
            ce.popupWidth = '250px';
            cardData.add(ce);
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Med Record #', '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Auth Day', '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Admit Hour', '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Discharge Hour', '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Semi-Private $', '--', 'outputText',true));
            cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true, 'Hospital Remarks', '--', 'outputText',true));

            cardDetails.cardData = cardData;
            resMap.add(cardDetails);

        }
         return resMap;
    }

    public static String getfieldValue(string fieldValue){
        return string.isNotBlank(fieldValue) ? fieldValue :'--';
    }

}