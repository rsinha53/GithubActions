// Controller class needed for Claim Details
// Ketki J - 10/24/2020
// US2338190
 public class ACET_ClaimDetailController {

     public static String interest='--';
     public static String reserve='--';
     public static String causeCode='CAUSE CODE';
     public static String referal='REFERRAL #';
     public static String code='CODE(S)';
     public static String remark='REMARK(S)';
     public static String policyName='--';
     public static String reimbursementPolicyURL='--';
     public static String icesCodes='--';
     public static String name='Policy:';
     public static String noOfColumns = 'slds-size_12-of-12';
     public static String fieldValueStyle='overflow-wrap: break-word;font-size: 14px;width:480px';
     public static String description= 'Clicking the policy name will navigate you to the Link portal where you can search for the applicable policy.';

    public class ClaimStatus {
    	 @AuraEnabled public ACET_AutoDocUtil.TableDetails serviceLines;
         @AuraEnabled public  String interestPaidAmt {get;set;}
         @AuraEnabled public  String reserveAmt {get;set;}
    }
    public class ClaimInputs {
        @AuraEnabled public String claimNumber {get;set;}
        @AuraEnabled public String taxId {get;set;}
        @AuraEnabled public String payerId {get;set;}
        @AuraEnabled public String processDate {get;set;}
        @AuraEnabled public String ClaimType {get;set;}
    }

    public class SearchResultWrapper{
        @AuraEnabled public SAEEligibilityClaimDetailsJSON2Apex.ClaimsDetailInfo resultClaimDetailsWrapper {get;set;}
        @AuraEnabled public string message {get;set;}
        @AuraEnabled public integer statusCode {get;set;}
    }

    // Card Data
    public class ClaimDetailCard {
        @AuraEnabled public ACET_AutoDocUtil.TableDetails claimLevelDiagnosisDetails;
        @AuraEnabled public ACET_AutoDocUtil.TableDetails serviceLines;
        //Ketki 11/5/2020 US2338191 - start
        @AuraEnabled public List<ACET_AutoDocUtil.CardDetails> serviceLineDetails;
        @AuraEnabled public List<ACET_AutoDocUtil.CardDetails> serviceLineAdditionalInfo;
        //Ketki 11/5/2020 US2338191  - end
        @AuraEnabled public AdditionalClaimInfo additionalClaimInfo;
        @AuraEnabled public ACET_AutoDocUtil.CardDetails intrestDetails;
        @AuraEnabled public String transactionId {get;set;} // Added by mani 11/19/2020 US1866504
        @AuraEnabled public String dccflnNbr {get;set;} // Added bySwapna
        @AuraEnabled public List<SAEEligibilityClaimDetailsJSON2Apex.PaymentInfo> paymentInfo;
        @AuraEnabled public List<SAEEligibilityClaimDetailsJSON2Apex.Lines> lines;
        @AuraEnabled public String interest {get;set;}
        @AuraEnabled public String reserve {get;set;}
         @AuraEnabled public String referralNumber {get;set;}

        @AuraEnabled public Boolean isSuccess;
        @AuraEnabled public String errorMessage;

        // US3464932
        @AuraEnabled public List<FeeScheduleData> feeData;

        @AuraEnabled public ACET_AutoDocUtil.TableDetails additionalClaimInfoCNF;
    }

    public class AdditionalClaimInfo{
        @AuraEnabled public String causeCode;
        @AuraEnabled public String firstSrvDate;//Added by mani
        @AuraEnabled public String icn;
    }


    @AuraEnabled
    public static ACET_ClaimDetailController.ClaimDetailCard getClaimDetails(ClaimInputs claimInputs){
        ACET_ClaimDetailController.ClaimDetailCard returnWrapper = new ACET_ClaimDetailController.ClaimDetailCard();
        try{
            SAEClaimDetailsWS claimDetailsService = new SAEClaimDetailsWS();
            ACETWSCalloutResult CalloutResult = claimDetailsService.getClaimInformation(claimInputs);
            system.debug('CalloutResult***'+CalloutResult);
            //sravani start  - If condition and Else conditons.
            if(CalloutResult.statusCode ==200){
           		returnWrapper.isSuccess = true;
              // Added by mani 11/19/2020 US1866504
                SAEEligibilityClaimDetailsJSON2Apex fullresult = new SAEEligibilityClaimDetailsJSON2Apex();
                fullresult = (SAEEligibilityClaimDetailsJSON2Apex) CalloutResult.Response;
                SAEEligibilityClaimDetailsJSON2Apex.ClaimsDetailInfo result = fullresult.claimsDetailInfo[0];
                system.debug('**50**'+result);
                /*SAEEligibilityClaimDetailsJSON2Apex.ClaimsDetailInfo result = new SAEEligibilityClaimDetailsJSON2Apex.ClaimsDetailInfo();
				result = (SAEEligibilityClaimDetailsJSON2Apex.ClaimsDetailInfo) CalloutResult.Response;*/
                returnWrapper.claimLevelDiagnosisDetails = createDiagnosisCard(result,claimInputs.claimNumber);
                //Ketki 11/5/2020 US2338191 - start
                 Map <String, List <SAEEligibilityClaimDetailsJSON2Apex.Lines>> sortedLines = sortLines(result);
                returnWrapper.serviceLines = createServiceLines(sortedLines,claimInputs.claimNumber,claimInputs.claimType);
                returnWrapper.serviceLineDetails= createServiceLineDetails(sortedLines, claimInputs.claimNumber);
                returnWrapper.paymentInfo=result.paymentInfo;
                returnWrapper.lines=result.lines ;
                returnWrapper.serviceLineAdditionalInfo =createServiceLineAdditionalInfo(sortedLines,claimInputs.claimNumber,result);
                returnWrapper.intrestDetails = intrestDetails(sortedLines, claimInputs.claimNumber,claimInputs.processDate);
                //Ketki 11/5/2020 US2338191 - end
                returnWrapper.additionalClaimInfo= getAdditionalInfo(result, claimInputs.processDate );
                //Claim not on file
                returnWrapper.additionalClaimInfoCNF= createServiceLineAdditionalInfoCNF(sortedLines,claimInputs.claimNumber);
                string tranId = fullresult.transactionId;
                system.debug('Transactionid**'+tranId);
                returnWrapper.transactionId=tranId;
				returnWrapper.dccflnNbr=result.dccflnNbr;

                 returnWrapper.interest=interest;
				returnWrapper.reserve=reserve;
                // US3464932
                returnWrapper.feeData = getFeeData(result);
                returnWrapper.referralNumber = getValueoff(result.referralNumber);
            }
            else{
                //added by sravani start
                System.debug('CalloutResult failed No results found');
                Object res = CalloutResult.Response;
                String resString = JSON.serialize(res);
                Map<String, Object> httpResponseJSON = (Map<String, Object>) JSON.deserializeUntyped(resString);
                    system.debug('httpResponseJSON::'+httpResponseJSON);
                String messageSer = String.isNotBlank((String)httpResponseJSON.get('Message')) ? (String)httpResponseJSON.get('Message') : '';
                returnWrapper.errorMessage= messageSer;
                returnWrapper.isSuccess = false;
                //added by sravani end
            }
        }catch(Exception e){
        	System.debug('exception::'+e.getStackTraceString());
        	returnWrapper.isSuccess = false;
        	returnWrapper.errorMessage = e.getMessage() + ' ' + e.getLineNumber();
   		}
        // US34244763 - Thanish - 11th May 2021 - validation tops creds for the use of related external ids cmp
        ACET_ClaimDetailController.validateTopsCreds();
        return returnWrapper;

    }

    private static AdditionalClaimInfo getAdditionalInfo(SAEEligibilityClaimDetailsJSON2Apex.ClaimsDetailInfo claimDetailInfo, String inputProcessDate){
        AdditionalClaimInfo claimInfo=new AdditionalClaimInfo();
        claimInfo.causeCode='--';
        claimInfo.firstSrvDate='--';//Added by mani
        claimInfo.icn=claimDetailInfo.icn;
        for(SAEEligibilityClaimDetailsJSON2Apex.Lines line: claimDetailInfo.lines){
            if(String.isNotBlank(line.processedDt) && line.processedDt.equals(inputProcessDate)){
                String causeCodevar;
                switch on line.causeCd {
                    when '0' { causeCodevar = 'GENERAL SICKNESS';}
                    when '1'{ causeCodevar = 'PSYCHIATRIC';}
                    when '2'{ causeCodevar = 'NORMAL MATERNITY';}
                    when '3'{ causeCodevar = 'EMERGENCY ILLNES';}
                    when '4'{ causeCodevar = 'ROUTINE';}
                    when '5'{ causeCodevar = 'COMPLICATION OF PREGNANCY';}
                    when '6'{ causeCodevar = 'ALCOHOLISM AND DRUG ADDICTION';}
                    when 'A'{ causeCodevar = 'ACCIDENTS';}
                    when else { causeCodevar = '--';}
                }
                claimInfo.causeCode=causeCodevar;
                claimInfo.firstSrvDate=line.firstSrvcDt;//Added by mani
            }
        }
        return claimInfo;
    }

    private static ACET_AutoDocUtil.TableDetails createDiagnosisCard(SAEEligibilityClaimDetailsJSON2Apex.ClaimsDetailInfo claimDetailInfo,string claimNumber ){
        System.debug('the input data for createDiagnosisCard is: '+ claimDetailInfo);
        try{
                    ACET_AutoDocUtil.TableDetails claimDiagnosisTable = new ACET_AutoDocUtil.TableDetails();
                    claimDiagnosisTable.type = 'table';
                    claimDiagnosisTable.componentOrder = 10;
                    claimDiagnosisTable.showComponentName = false;
            		//claimDiagnosisTable.caseItemsEnabled = true;
                    claimDiagnosisTable.componentName = 'Claim Level Diagnosis Details: '+claimNumber ;
                    claimDiagnosisTable.autodocHeaderName = 'Claim Level Diagnosis Details: '+claimNumber;
                    // US3653575
                    claimDiagnosisTable.reportingHeader = 'Claim Level Diagnosis Details';
                    claimDiagnosisTable.tableHeaders = new List < String > {
                        'DX LINE', 'DX CODE', 'POA'
                    };


                    //String headerPopupId = String.valueof(DateTime.now().getTime());

                     List<ACET_AutoDocUtil.HoverHeader> hoverList = new List<ACET_AutoDocUtil.HoverHeader>();


            		ACET_AutoDocUtil.HoverHeader dxLine = new ACET_AutoDocUtil.HoverHeader();
            		dxLine.popupId ='dxLine';
            		dxLine.headerValue = 'DX LINE';
            		hoverList.add(dxLine);
            		//claimDiagnosisTable.tableHoverHeaders =hoverList;

            		ACET_AutoDocUtil.HoverHeader dxCode = new ACET_AutoDocUtil.HoverHeader();
            		dxCode.popupId ='dxCode';
            		dxCode.headerValue = 'DX CODE';
            		hoverList.add(dxCode);
            		//claimDiagnosisTable.tableHoverHeaders=hoverList ;

            		ACET_AutoDocUtil.HoverHeader hoverPOA = new ACET_AutoDocUtil.HoverHeader();
                    hoverPOA.popupId = 'popupIDPOA';
                    hoverPOA.headerValue = 'POA';
            		hoverPOA.hasHover = true;
            		hoverPOA.alignRight = true;
            		hoverPOA.hoverWidth = '180px';
            		hoverPOA.hoverDescription='Present On Admission';
                    hoverList.add(hoverPOA);
                    claimDiagnosisTable.tableHoverHeaders= hoverList;



                    List < ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();
                    if (claimDiagnosisTable != null && claimDetailInfo.diagnosisCodes != null) {
                        Integer count=0;
                        for(SAEEligibilityClaimDetailsJSON2Apex.DiagnosisCodes codes: claimDetailInfo.diagnosisCodes){
                            count++;
                            ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                            tableRow.checked = false;
                            tableRow.uniqueKey = codes.diagnosisCode;
                            // US3653575
                            tableRow.caseItemsExtId = claimNumber;
                            List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                            rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', ''+count,'DX LINE','',true));
                            rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', codes.diagnosisCode,'DX CODE','',true));
                            rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText',codes.submtPOAInd != null ? codes.submtPOAInd : '--' ,'POA','',true));
                            tableRow.rowColumnData = rowColumns;
                            tableRows.add(tableRow);
                        }
                    }

                    if (claimDetailInfo.diagnosisCodes == null || claimDetailInfo.diagnosisCodes.isEmpty()) {
                        ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                        tableRow.checked = false;
                        tableRow.uniqueKey = 'No records found.';
                        // US3653575
                        tableRow.caseItemsExtId = claimNumber;
                        List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();

                        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '', 'DX LINE'));
                        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', 'No records found.' , 'DX CODE','',true));
                        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '','POA'));

                        tableRow.rowColumnData = rowColumns;
                        tableRows.add(tableRow);
                    }
                    claimDiagnosisTable.tableBody = tableRows;
            		return claimDiagnosisTable;
    		}catch(exception e) {
            		system.debug('exception'+e.getStackTraceString());
                	return null;
        	}
    }

    //Ketki 11/5/2020 US2338191- start
    public static String formatDateTimeValue(String dateStr, String timeStr) {
        dateStr = SAEUtils.formatDateFutureDate(dateStr);
        timeStr = timeStr.replace('.', ':');
        return dateStr + ' ' + timeStr;
    }

    private static Map <String, List <SAEEligibilityClaimDetailsJSON2Apex.Lines>> sortLines (SAEEligibilityClaimDetailsJSON2Apex.ClaimsDetailInfo claimDetailInfo){
        System.debug('the input data for claimServiceLine Card is: '+ claimDetailInfo);

         //Rearranging data based on line number
        Map < String, List < SAEEligibilityClaimDetailsJSON2Apex.Lines >> serviceLineMap = new Map < String, List < SAEEligibilityClaimDetailsJSON2Apex.Lines >> ();
        for (SAEEligibilityClaimDetailsJSON2Apex.Lines serviceLine:claimDetailInfo.Lines) {
            List < SAEEligibilityClaimDetailsJSON2Apex.Lines > serviceLinesList = new List < SAEEligibilityClaimDetailsJSON2Apex.Lines > ();
            if (serviceLineMap.containsKey(serviceLine.lineNbr)) {
                serviceLinesList = serviceLineMap.get(serviceLine.lineNbr);
                serviceLinesList.add(serviceLine);
            } else {
                serviceLinesList.add(serviceLine);
                serviceLineMap.put(serviceLine.lineNbr, serviceLinesList);
            }
        }

        //Sort Map based on processedDate
        Map < String, List < SAEEligibilityClaimDetailsJSON2Apex.Lines >> sortedServiceLineMap = new Map < String, List < SAEEligibilityClaimDetailsJSON2Apex.Lines >> ();
        for (SAEEligibilityClaimDetailsJSON2Apex.Lines serviceLine: claimDetailInfo.Lines) {
            Datetime processedDt = Datetime.newInstance(9999, 12, 31, 0, 0, 0);
            List < SAEEligibilityClaimDetailsJSON2Apex.Lines > sortedServiceLinesList = new List < SAEEligibilityClaimDetailsJSON2Apex.Lines > ();
            if (serviceLineMap.containskey(serviceLine.lineNbr)) {
                for (Integer i = serviceLineMap.get(serviceLine.lineNbr).size() - 1; i >= 0 ; i--) {
                    if (Datetime.valueOf(formatDateTimeValue(serviceLineMap.get(serviceLine.lineNbr)[i].processedDt, serviceLineMap.get(serviceLine.lineNbr)[i].processedTime)) < processedDt) {
                        processedDt = Datetime.valueOf(formatDateTimeValue(serviceLineMap.get(serviceLine.lineNbr)[i].processedDt, serviceLineMap.get(serviceLine.lineNbr)[i].processedTime));
                        sortedServiceLinesList.add(serviceLineMap.get(serviceLine.lineNbr)[i]);
                    }
                }
                sortedServiceLineMap.put(serviceLine.lineNbr, sortedServiceLinesList);
            }
        }

        System.debug('sortedServiceLineMap::'+sortedServiceLineMap);
        return sortedServiceLineMap;
    }


   private static ACET_AutoDocUtil.TableDetails createServiceLines(Map <String, List <SAEEligibilityClaimDetailsJSON2Apex.Lines>> sortedServiceLineMap , string claimNumber, string claimType){

        System.debug('sortedServiceLineMap::'+sortedServiceLineMap);

        //Cause Code Map
       map<string,string> causecodemap = new map<string,string>();
       causecodemap.put('0','GENERAL SICKNESS');
       causecodemap.put('1','PSYCHIATRIC');
       causecodemap.put('2','NORMAL MATERNITY');
       causecodemap.put('3','EMERGENCY ILLNESS');
       causecodemap.put('4','ROUTINE');
       causecodemap.put('5','COMPLICATION OF PREGNANCY');
       causecodemap.put('6','ALCOHOLISM AND DRUG ADDICTION');
       causecodemap.put('A','ACCIDENT');

        //POC Map
        map<string,string> posmap = new map<string,string>();
        List<ACET_ServiceLines_POC__mdt> pocList = [SELECT Place_of_Service_Name__c,POC__c FROM ACET_ServiceLines_POC__mdt];
        for(ACET_ServiceLines_POC__mdt p : pocList){
            posmap.put(p.POC__c,p.Place_of_Service_Name__c);
        }

        ACET_AutoDocUtil.TableDetails servLineTable = new ACET_AutoDocUtil.TableDetails();
        servLineTable.type = 'table';
        servLineTable.showComponentName = false;
        servLineTable.componentName = 'Service Line(s): '+claimNumber;
        servLineTable.autodocHeaderName = 'Service Line(s): '+claimNumber;
        // US3653575
        servLineTable.reportingHeader = 'Service Line(s)';
        servLineTable.componentOrder = 15;
        if(claimType == 'P'){
            servLineTable.tableHeaders = new List < String > {
                'LINE',
                    'V',
                    //added sravani
                    'PROCESSED',
                    code,
                    //sravani
                    'MOD',
                    'SERVICE DATE(S)',
                    remark,
                    'POS',
                    'DX',
                    'CHARGED',
                    'ALLOWED',
                    'DENIED',
                    'UNITS',
                    'DED',
                    'COPAY',
                    'COINS',
                    '%',
                    'PAID',
                    'SRN #',
                    referal,
                     causeCode,
                    'SUFFIX'
                    // 'PROCESSED'
                    };
                        }else{
                            servLineTable.tableHeaders = new List < String > {
                                'LINE',
                                    'V',
                                    'PROCESSED',
                                    code,
                                    'MOD',
                                    'SERVICE DATE(S)',
                                    remark,
                                    'POS',
                                    'CHARGED',
                                    'ALLOWED',
                                    'DENIED',
                                    'UNITS',
                                    'DED',
                                    'COPAY',
                                    'COINS',
                                    '%',
                                    'PAID',
                                    'SRN #',
                                    referal,
                                    causeCode,
                                    'SUFFIX'
                                    };
                                        }
        List<ACET_AutoDocUtil.HoverHeader> hoverList = new List<ACET_AutoDocUtil.HoverHeader>();


        ACET_AutoDocUtil.HoverHeader LINE = new ACET_AutoDocUtil.HoverHeader();
        LINE.popupId ='LINE';
        LINE.headerValue = 'LINE';
        hoverList.add(LINE);
        ACET_AutoDocUtil.HoverHeader v = new ACET_AutoDocUtil.HoverHeader();
        v.popupId ='V';
        v.headerValue = 'V';
        hoverList.add(v);
        ACET_AutoDocUtil.HoverHeader proc = new ACET_AutoDocUtil.HoverHeader();
        proc.popupId ='PROCESSED';
        proc.headerValue = 'PROCESSED';
        hoverList.add(proc);
        ACET_AutoDocUtil.HoverHeader rev = new ACET_AutoDocUtil.HoverHeader();
        rev.popupId =code;
        rev.headerValue = code;
        hoverList.add(rev);
        ACET_AutoDocUtil.HoverHeader mo = new ACET_AutoDocUtil.HoverHeader();
        mo.popupId ='MOD';
        mo.headerValue = 'MOD';
        hoverList.add(mo);
        ACET_AutoDocUtil.HoverHeader sd = new ACET_AutoDocUtil.HoverHeader();
        sd.popupId ='SERVICEDATE';
        sd.headerValue = 'SERVICE DATE(S)';
        hoverList.add(sd);
        ACET_AutoDocUtil.HoverHeader rc = new ACET_AutoDocUtil.HoverHeader();
        rc.popupId ='REMARKCODE';
        rc.headerValue = remark;
        hoverList.add(rc);
        ACET_AutoDocUtil.HoverHeader pos = new ACET_AutoDocUtil.HoverHeader();
        pos.popupId ='POS';
        pos.headerValue = 'POS';
        hoverList.add(pos);
        if(claimType == 'P'){
            ACET_AutoDocUtil.HoverHeader dx = new ACET_AutoDocUtil.HoverHeader();
            dx.popupId ='DX';
            dx.headerValue = 'DX';
            hoverList.add(dx);
        }
        ACET_AutoDocUtil.HoverHeader cg = new ACET_AutoDocUtil.HoverHeader();
        cg.popupId ='CHARGED';
        cg.headerValue = 'CHARGED';
        hoverList.add(cg);
        ACET_AutoDocUtil.HoverHeader al = new ACET_AutoDocUtil.HoverHeader();
        al.popupId ='ALLOWED';
        al.headerValue = 'ALLOWED';
        hoverList.add(al);
        ACET_AutoDocUtil.HoverHeader de = new ACET_AutoDocUtil.HoverHeader();
        de.popupId ='DENIED';
        de.headerValue = 'DENIED';
        hoverList.add(de);
        ACET_AutoDocUtil.HoverHeader un = new ACET_AutoDocUtil.HoverHeader();
        un.popupId ='UNITS';
        un.headerValue = 'UNITS';
        hoverList.add(un);
        ACET_AutoDocUtil.HoverHeader ded = new ACET_AutoDocUtil.HoverHeader();
        ded.popupId ='DED';
        ded.headerValue = 'DED';
        hoverList.add(ded);
        ACET_AutoDocUtil.HoverHeader co = new ACET_AutoDocUtil.HoverHeader();
        co.popupId ='COPAY';
        co.headerValue = 'COPAY';
        hoverList.add(co);
        ACET_AutoDocUtil.HoverHeader coi = new ACET_AutoDocUtil.HoverHeader();
        coi.popupId ='COINS';
        coi.headerValue = 'COINS';
        hoverList.add(coi);

        ACET_AutoDocUtil.HoverHeader per = new ACET_AutoDocUtil.HoverHeader();
        per.popupId = '%';
        per.headerValue = '%';
        per.hasHover = true;
        per.alignRight = true;
        per.hoverWidth = '290px';
        per.hoverDescription='This is the benefit level % applied to this line.';
        hoverList.add(per);

        ACET_AutoDocUtil.HoverHeader paid = new ACET_AutoDocUtil.HoverHeader();
        paid.popupId ='PAID';
        paid.headerValue = 'PAID';
        hoverList.add(paid);

        ACET_AutoDocUtil.HoverHeader srn = new ACET_AutoDocUtil.HoverHeader();
        srn.popupId ='SRN';
        srn.headerValue = 'SRN #';
        hoverList.add(srn);
        ACET_AutoDocUtil.HoverHeader ref = new ACET_AutoDocUtil.HoverHeader();
        ref.popupId ='REFERRAL#';
        ref.headerValue = referal;
        hoverList.add(ref);
        ACET_AutoDocUtil.HoverHeader cc = new ACET_AutoDocUtil.HoverHeader();
        cc.popupId ='CAUSECODE';
        cc.headerValue = causeCode;
        hoverList.add(cc);
        ACET_AutoDocUtil.HoverHeader sf = new ACET_AutoDocUtil.HoverHeader();
        sf.popupId ='SUFFIX';
        sf.headerValue = 'SUFFIX';
        hoverList.add(sf);

        servLineTable.tableHoverHeaders= hoverList;

        //Table body
        List < ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();
        for (String lineNum: sortedServiceLineMap.keyset()) {
            Integer i = sortedServiceLineMap.get(lineNum).size();
            for (SAEEligibilityClaimDetailsJSON2Apex.Lines serviceLine: sortedServiceLineMap.get(lineNum)) {

                ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                tableRow.checked = false;
                tableRow.uniqueKey = serviceLine.lineNbr+'L' + i;
                tableRow.hideChildRow = tableRow.isChildRow = i == sortedServiceLineMap.get(lineNum).size() ? false : true;
                List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                if (sortedServiceLineMap.get(lineNum).size() > 1) {
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Accordian', tableRow.isChildRow ? '' : serviceLine.lineNbr, 'LINE'));
                } else {
                    rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', serviceLine.lineNbr, 'LINE'));
                }
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', 'L' + i , 'V'));
                //added sravani start

				Integer counter = 0;
                String remarkCodes = '--';
                boolean claimcodeType = false; // added sravani this line
                if(serviceLine.claimCodes != null){
                    for (Integer j=0; j < serviceLine.claimCodes.size(); j++ ) {
                           SAEEligibilityClaimDetailsJSON2Apex.ClaimCodes clmCode =  serviceLine.claimCodes[j];

                           if(clmCode.type == 'REMARK' || clmCode.type == 'CLOSURE'){
                               claimcodeType = true; // added sravani this line
                                if(counter == 0){
                                    remarkCodes = clmCode.code ;
                                }
                                else{
                                    remarkCodes += ', ' + clmCode.code;
                                }
                                counter++;
                                if( counter>=4 )
                                 break;
                          }
                    }
                }

                Integer cnt = 0;
                String DXValue = '--';
                if(serviceLine.diagnosisPtrs != null){
                    for (Integer j=0; j < serviceLine.diagnosisPtrs.size(); j++ ) {
                        SAEEligibilityClaimDetailsJSON2Apex.diagnosisPtrs diagnosisPtrs =  serviceLine.diagnosisPtrs[j];
                        if(cnt == 0){
                            DXValue = string.valueof(diagnosisPtrs.diagnosisPtr);
                        }
                        else{
                            DXValue += ', ' + string.valueof(diagnosisPtrs.diagnosisPtr);
                        }
                        cnt++;
                    }
                }

                string causecode = '--';
                if(serviceLine.causeCd != null  && serviceLine.causeCd != '' && causecodemap.containsKey(serviceLine.causeCd)){
                    causecode=causecodemap.get(serviceLine.causeCd);
                }
                integer percentage;
                if(serviceLine.planCoveragePercent != null  && serviceLine.planCoveragePercent != ''){
                    decimal percent =  decimal.valueof(serviceLine.planCoveragePercent)*100;
                    percentage = integer.valueOf(percent);
                }

                string poscode = '';
                if(serviceLine.lineLevelPlaceOfService != null  && serviceLine.lineLevelPlaceOfService != '' && posmap.containsKey(serviceLine.lineLevelPlaceOfService)){
                    poscode=posmap.get(serviceLine.lineLevelPlaceOfService);
                }

                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', serviceLine.processedDt, 'PROCESSED'));
                string revServiceCode = serviceLine.revenueCode!=null?serviceLine.revenueCode:'--'; //added sravani start
                revServiceCode+='/';
                revServiceCode+= serviceLine.srvcCode!=null?serviceLine.srvcCode:'--';
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('link', revServiceCode, code));
                //sravani end

                String mod=serviceLine.modifiers !=null && serviceLine.modifiers.size() >0 ? serviceLine.modifiers[0].modifierCode: '--';
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText',mod, 'MOD'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', serviceLine.firstSrvcDt + ' - ' + serviceLine.lastSrvcDt, 'SERVICE DATE(S)'));



                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', (serviceLine.ovrCd != null && !serviceLine.ovrCd.equals('00') && serviceLine.ovrCd != '')?remarkCodes+', '+serviceLine.ovrCd:remarkCodes, remark)); //added sravani
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', serviceLine.lineLevelPlaceOfService != null ? serviceLine.lineLevelPlaceOfService :'--', 'POS',poscode,'cursor:pointer;'));
                if(claimType == 'P'){
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText',DXValue, 'DX'));
                }
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Currency', serviceLine.billedAmt != null ? serviceLine.billedAmt :'--', 'CHARGED'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Currency', serviceLine.allowdAmt != null? serviceLine.allowdAmt :'--', 'ALLOWED'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Currency', serviceLine.notCovAmt != null? serviceLine.notCovAmt :'--', 'DENIED'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', serviceLine.notCovAmt != null? serviceLine.unitCount :'--', 'UNITS'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Currency', serviceLine.deductible != null? serviceLine.deductible :'--', 'DED'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Currency', serviceLine.copay != null? serviceLine.copay  :'--', 'COPAY'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Currency', serviceLine.coinsurance != null? serviceLine.coinsurance :'--', 'COINS'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText',serviceLine.planCoveragePercent != null? string.valueof(percentage)+'%'  :'--', '%'));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Currency', serviceLine.paidAmt != null? serviceLine.paidAmt  :'--', 'PAID'));
                //this is a gap
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData(serviceLine.priorAuthNbr != null? 'Link'  :'outputText',serviceLine.priorAuthNbr != null? serviceLine.priorAuthNbr  :'--', 'SRN #'));
                //this is a gap
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '--', referal));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', causecode, causeCode));
                rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', serviceLine.icnsuffix != null? serviceLine.icnsuffix :'--', 'SUFFIX'));
               //rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', serviceLine.processedDt, 'PROCESSED'));
                //rowColumns.add(ACET_AutoDocUtil.setRowColumnData('Currency', serviceLine.interestPaidAmt != null? serviceLine.interestPaidAmt  :'--', 'INTEREST'));

                // tableRow.rowColumnData = rowColumns;
                // US3653575
                for (ACET_AutoDocUtil.RowColumnData cell : rowColumns) {
                    cell.isReportable = true;
                }
                tableRow.rowColumnData = rowColumns;
                tableRow.caseItemsExtId = claimNumber;
                tableRows.add(tableRow);
                i--;
            }
            servLineTable.tableBody = tableRows;
        }
        return servLineTable;
    }

    //Ketki 11/5/2020 US2338191

    private static List<ACET_AutoDocUtil.CardDetails> createServiceLineDetails(Map <String, List <SAEEligibilityClaimDetailsJSON2Apex.Lines>> sortedServiceLineMap, string claimNumber){
        System.debug('the input data for ServiceLineDetails Card is: '+ sortedServiceLineMap);
        List<ACET_AutoDocUtil.CardDetails> lineDetailCardList = new List<ACET_AutoDocUtil.CardDetails>();
        Map<String,String> ovrCdMap = new Map<String,String>();
        List<ACET_ServiceLines_ovrCd__mdt> ovrCdList = [SELECT Id, ovrCd__c, Description__c FROM ACET_ServiceLines_ovrCd__mdt];
        for(ACET_ServiceLines_ovrCd__mdt s : ovrCdList){
            ovrCdMap.put(s.ovrCd__c,s.Description__c);
        }
        system.debug('ovrCdMap@@'+ovrCdMap);
        for(String lineNum:sortedServiceLineMap.keySet()){
            Integer i = sortedServiceLineMap.get(lineNum).size();
            for (SAEEligibilityClaimDetailsJSON2Apex.Lines serviceLine: sortedServiceLineMap.get(lineNum)) {
                ACET_AutoDocUtil.CardDetails serviceLineDetailCard = new ACET_AutoDocUtil.CardDetails();
                serviceLineDetailCard.type = 'card';
                serviceLineDetailCard.componentOrder = 16;
                string revServiceCode = serviceLine.revenueCode!=null?serviceLine.revenueCode:'--'; //added sravani start
                revServiceCode+='/';
                revServiceCode+= serviceLine.srvcCode!=null?serviceLine.srvcCode:'--';
                serviceLineDetailCard.componentName =  'Line ' +lineNum + ' ' +'L' + i +  ': '+revServiceCode+ ': '+claimNumber; //added sravani end
                serviceLineDetailCard.noOfColumns = noOfColumns;

                List < ACET_AutoDocUtil.FieldDetails > cardData = new List < ACET_AutoDocUtil.FieldDetails > ();

				Integer counter = 0;
                if(serviceLine.claimCodes != null){
                    for (Integer j=0; j < serviceLine.claimCodes.size() ;j++ ) {
                       SAEEligibilityClaimDetailsJSON2Apex.ClaimCodes clmCode =  serviceLine.claimCodes[j];

                          if(clmCode.type == 'REMARK' || clmCode.type == 'CLOSURE'){
                          cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true,'', clmCode.code + ' - '+ clmCode.description, 'unescapedHtml', false, 'Remark', true));
                            counter ++ ;
                            if( counter>=4 )
                                 break;
                              }
                    }
                }
                if(serviceLine.ovrCd != null && !serviceLine.ovrCd.equals('00') && serviceLine.ovrCd != '' && ovrCdMap.containsKey(serviceLine.ovrCd)){
                    cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true,'', serviceLine.ovrCd + ' - '+ ovrCdMap.get(serviceLine.ovrCd).toUpperCase(), 'unescapedHtml', false, 'ovrcd', true));
                }
                serviceLineDetailCard.cardData = cardData;
                lineDetailCardList.add(serviceLineDetailCard);
                i--;
            }
        }
        return lineDetailCardList;
    }

     private static void serviceLineAdditionalInfo(SAEEligibilityClaimDetailsJSON2Apex.ClaimsDetailInfo claimsDetailInfo,SAEEligibilityClaimDetailsJSON2Apex.Lines serviceLine){
         Integer counter = 0;
         for (Integer j=0; j < serviceLine.claimCodes.size(); j++ ) {
                           SAEEligibilityClaimDetailsJSON2Apex.ClaimCodes clmCode =  serviceLine.claimCodes[j];
                           if(clmCode.type == 'ICES'){
                                if(counter == 0){
                                    icesCodes = ' '+ clmCode.code ;

                                }
                                else if(counter <= 2){
                                    icesCodes += ',' + clmCode.code;
                                }
                               else
                                  break;
                                counter++;
                          }
                    }
         if(claimsDetailInfo.reimbursementPolicy != null){
             for (Integer k=0; k < claimsDetailInfo.reimbursementPolicy.size(); k++ ) {
                 SAEEligibilityClaimDetailsJSON2Apex.ReimbursementPolicy reimPolicy =  claimsDetailInfo.reimbursementPolicy[k];
                 if(icesCodes.contains(reimPolicy.icesCode)){
                     policyName=reimPolicy.policyName ;
                     reimbursementPolicyURL= claimsDetailInfo.reimbursementPolicyURL ;
                     break;
                 }}}

     }

    private static List<ACET_AutoDocUtil.CardDetails> createServiceLineAdditionalInfo(Map <String, List <SAEEligibilityClaimDetailsJSON2Apex.Lines>> sortedServiceLineMap, string claimNumber,SAEEligibilityClaimDetailsJSON2Apex.ClaimsDetailInfo claimsDetailInfo){

        System.debug('the input data for ServiceLineDetails Card is: '+ sortedServiceLineMap);
        List<ACET_AutoDocUtil.CardDetails> additionalInfoCardList = new List<ACET_AutoDocUtil.CardDetails>();

        for(String lineNum:sortedServiceLineMap.keySet()){
            Integer i = sortedServiceLineMap.get(lineNum).size();
            for (SAEEligibilityClaimDetailsJSON2Apex.Lines serviceLine: sortedServiceLineMap.get(lineNum)) {
                ACET_AutoDocUtil.CardDetails serviceLineAdditionalInfoCard = new ACET_AutoDocUtil.CardDetails();
                serviceLineAdditionalInfoCard.type = 'card';
                serviceLineAdditionalInfoCard.componentOrder = 17;
                string revServiceCode = serviceLine.revenueCode!=null?serviceLine.revenueCode:'--'; //added sravani start
                revServiceCode+='/';
                revServiceCode+= serviceLine.srvcCode!=null?serviceLine.srvcCode:'--';
                serviceLineAdditionalInfoCard.componentName = 'Additional Info/Policy : L' + i +  ': '+revServiceCode + ': '+claimNumber ; //added by sravaniend
                serviceLineAdditionalInfoCard.noOfColumns = noOfColumns;

                // US3653575
                serviceLineAdditionalInfoCard.reportingHeader = 'Additional Info/Policy';
                serviceLineAdditionalInfoCard.caseItemsExtId = claimNumber;

                List < ACET_AutoDocUtil.FieldDetails > cardData = new List < ACET_AutoDocUtil.FieldDetails > ();


               if(serviceLine.claimCodes != null){
                 serviceLineAdditionalInfo(claimsDetailInfo,serviceLine);
                }

                cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false,true, '','Code: '+icesCodes,'outputText'));
                cardData.get(0).reportingFieldName = 'Code';
                ACET_AutoDocUtil.FieldDetails hoverPTI =new ACET_AutoDocUtil.FieldDetails(false, false,true,'','Policy: '+policyName,'linkUrl');
                hoverPTI.name=name;
                hoverPTI.urlLabel=' '+policyName;
                hoverPTI.urlValue= reimbursementPolicyURL;
                hoverPTI.fieldValueStyle=fieldValueStyle;
                hoverPTI.description =description;
                hoverPTI.reportingFieldName = 'Policy';
                cardData.add(hoverPTI);
                cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false,true, '','Description: --','outputText'));
                cardData.get(2).reportingFieldName = 'Description';



                serviceLineAdditionalInfoCard.cardData = cardData;
                additionalInfoCardList.add(serviceLineAdditionalInfoCard);
                i--;
            }
        }
        return additionalInfoCardList;
    }
    //Ketki 11/5/2020 US2338191 - end

 	private static ACET_AutoDocUtil.TableDetails createServiceLineAdditionalInfoCNF(Map <String, List <SAEEligibilityClaimDetailsJSON2Apex.Lines>> sortedServiceLineMap, string claimNumber){

        System.debug('the input data for ServiceLineDetails Card is: '+ sortedServiceLineMap);
        System.debug('sortedServiceLineMap::'+sortedServiceLineMap);
        ACET_AutoDocUtil.TableDetails servLineTable = new ACET_AutoDocUtil.TableDetails();
        servLineTable.type = 'table';
        servLineTable.showComponentName = false;
        servLineTable.componentName = 'Additional Information: '+claimNumber;
        servLineTable.autodocHeaderName = 'Additional Information: '+claimNumber;
        servLineTable.componentOrder = 19;
        servLineTable.tableHeaders = new List < String > {
            'Code',
                'Description',
                'Tool Tip',
                'SOP'
                };

        //Table body
        List < ACET_AutoDocUtil.TableRow > tableRows = new List < ACET_AutoDocUtil.TableRow > ();
        for (String lineNum: sortedServiceLineMap.keyset()) {
            Integer i = sortedServiceLineMap.get(lineNum).size();
            for (SAEEligibilityClaimDetailsJSON2Apex.Lines serviceLine: sortedServiceLineMap.get(lineNum)) {




                if(serviceLine.claimCodes != null){
                    for (Integer j=0; j < serviceLine.claimCodes.size(); j++ ) {
                        ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                        tableRow.checked = false;
                        tableRow.uniqueKey = serviceLine.lineNbr+'L' + i;
                        SAEEligibilityClaimDetailsJSON2Apex.ClaimCodes clmCode =  serviceLine.claimCodes[j];
                        List < ACET_AutoDocUtil.RowColumnData > rowColumns = new List < ACET_AutoDocUtil.RowColumnData > ();
                        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', clmCode.code != null ? clmCode.code :'--', 'CODE'));
                        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', clmCode.description != null ? clmCode.description.length()<100 ? clmCode.description : clmCode.description.substring(0, 99)+'...' :'--', 'Description',clmCode.description));
                        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '--', 'Tool Tip'));
                        rowColumns.add(ACET_AutoDocUtil.setRowColumnData('outputText', '--', 'SOP'));
                        tableRow.rowColumnData = rowColumns;
                        tableRows.add(tableRow);
                    }
                }


                i--;
            }

        }
        servLineTable.tableBody = tableRows;
        return servLineTable;
    }

    //US3120337 - Chandra Start
    @AuraEnabled
    public static string getPaymentNumber(String taxId,String payerId,String transactionId){
        String paymentNumber = '';
        ACET_PaymentDetailControllerWS paymentDetailService = new ACET_PaymentDetailControllerWS();
        ACETWSCalloutResult calloutResult = paymentDetailService.getPaymentDetailsWS(taxId,payerId,transactionId);
        if(calloutResult.Success){
            list<ACET_PaymentDetailController_Json2Apex.payments> result = new list<ACET_PaymentDetailController_Json2Apex.payments>();
            result = (list<ACET_PaymentDetailController_Json2Apex.payments>) CalloutResult.Response;
            for(ACET_PaymentDetailController_Json2Apex.payments p:result){
            		paymentNumber = p.chkSrsDesg+p.checkNbr;
        	}
        }
        return paymentNumber;
    }
    //US3120337 - Chandra End

    // Sanka - US3464932
    public static List<FeeScheduleData> getFeeData(SAEEligibilityClaimDetailsJSON2Apex.ClaimsDetailInfo claimDetailInfo)
    {
        List<FeeScheduleData> returnWrap = new List<FeeScheduleData>();
        try {
            for (Integer i = 1; i <= claimDetailInfo.lines.size(); i++) {
                SAEEligibilityClaimDetailsJSON2Apex.Lines line = claimDetailInfo.lines.get(i-1);
                System.debug(Integer.valueOf(line.lineNbr));
                if(i == Integer.valueOf(line.lineNbr)){
                    FeeScheduleData fc = new FeeScheduleData();
                    fc.fromDate = line.firstSrvcDt;
                    fc.toDate = line.lastSrvcDt;
                    fc.pos = claimDetailInfo.placeOfService;
                    fc.procCode = line.procedureCd;
                    fc.modifier = line.modifiers != null ? String.join(getModifiers(line.modifiers), ',') : '';
                    fc.diagnosisCode = getDiagCode(line.diagnosisPtrs, claimDetailInfo.diagnosisCodes); // need clarification
                    //fc.unitType = 100 <= getNumeric(line.procedureCd) && getNumeric(line.procedureCd) <= 1999 ? 'U' : 'D';
                    fc.unitType = fc.procCode.isNumeric() ? (100 <= Integer.valueOf( fc.procCode) && Integer.valueOf( fc.procCode) <= 1999 ? 'U' : 'D') : 'D';
                    fc.noOfUnits = line.unitCount;
                    fc.chargeAmount = line.billedAmt;

                    returnWrap.add(fc);
                }
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
            System.debug(e.getStackTraceString());
            returnWrap =  new List<FeeScheduleData>();
        }
        return returnWrap;
    }

    public static List<String> getModifiers(List<SAEEligibilityClaimDetailsJSON2Apex.Modifiers> mods)
    {
        List<String> modStr = new List<String>();
        for (SAEEligibilityClaimDetailsJSON2Apex.Modifiers mod : mods) {
            modStr.add(mod.modifierCode);
        }
        return modStr;
    }

    public static String getDiagCode(List<SAEEligibilityClaimDetailsJSON2Apex.DiagnosisPtrs> lineCodes, List<SAEEligibilityClaimDetailsJSON2Apex.DiagnosisCodes> claimCodes){
        String diagCode = '';
        List<String> diagcodes = new List<String>();
        if(lineCodes == null || claimCodes == null){
            return '';
        }
        try{
            SAEEligibilityClaimDetailsJSON2Apex.DiagnosisCodes dc = claimCodes.get((Integer.valueOf(lineCodes.get(0).diagnosisPtr)) - 1);
            diagcodes.add(dc.diagnosisCode);
        }catch(Exception e){
            return '';
        }
        return String.join(diagcodes, ',');
    }

    // US34244763 - Thanish - 11th May 2021
    public static void validateTopsCreds(){
        String topsUserId = (String) Cache.Session.get('local.TOPSProfileInfo.userId');
        if(String.isBlank(topsUserId)){
            ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
            loginflow.validateTopsCredentials();
        }
    }

     private static ACET_AutoDocUtil.CardDetails intrestDetails(Map <String, List <SAEEligibilityClaimDetailsJSON2Apex.Lines>> sortedServiceLineMap,string claimnumber,String inputProcessDate){
         System.debug('the input data for ServiceLineDetails Card is: '+ sortedServiceLineMap);
         ACET_AutoDocUtil.CardDetails intrestDetailsCard = new ACET_AutoDocUtil.CardDetails();
         intrestDetailsCard.type = 'card';
         intrestDetailsCard.componentOrder = 7;
         intrestDetailsCard.noOfColumns = noOfColumns;
         List < ACET_AutoDocUtil.FieldDetails > cardData = new List < ACET_AutoDocUtil.FieldDetails > ();
         if(sortedServiceLineMap.containskey('0')){
             for(SAEEligibilityClaimDetailsJSON2Apex.Lines serviceLine: sortedServiceLineMap.get('0')){
                 if(serviceLine.processedDt.equals(inputProcessDate)){
                     interest = getValueoff(serviceLine.interestPaidAmt);
                     reserve = getValueoff(serviceLine.reserveAmt);
                     if(serviceLine.claimCodes != null){
                         for(SAEEligibilityClaimDetailsJSON2Apex.ClaimCodes code : serviceLine.claimCodes){
                             string cardInfo = intrestCardField(code);
                             cardData.add(new ACET_AutoDocUtil.FieldDetails(false, false, true,'',cardInfo, 'unescapedHtml'));
                         }
                     }
                     break;
                 }
             }
             intrestDetailsCard.componentName =  'Interest: $ '+interest+': '+claimnumber;
             intrestDetailsCard.cardData = cardData;
         }
         return intrestDetailsCard;
     }
     private static string intrestCardField(SAEEligibilityClaimDetailsJSON2Apex.ClaimCodes clmCode){
         string cardData = '--';
         if(clmCode.type == 'REMARK'){
             cardData =  clmCode.code + ' - '+ clmCode.description;
         }
         return cardData;
     }

     @AuraEnabled
     public static ACET_ContractExceptionsController.ContractExceptionsWrapper getContractExceptions(string providerId, string taxId, string contractId) {
       return ACET_ContractExceptionsController.getContractExceptions(providerId, taxId, contractId);
     }
     public class FeeScheduleData
     {
         @AuraEnabled public String fromDate{get;set;}
         @AuraEnabled public String toDate{get;set;}
         @AuraEnabled public String pos{get;set;}
         @AuraEnabled public String procCode{get;set;}
         @AuraEnabled public String modifier{get;set;}
         @AuraEnabled public String diagnosisCode{get;set;}
         @AuraEnabled public String unitType{get;set;}
         @AuraEnabled public String noOfUnits{get;set;}
         @AuraEnabled public String chargeAmount{get;set;}
     }
     private static String getValueoff(String value){
        return String.isNotBlank(value)?value:'--';
    }

     @AuraEnabled
     public static SAEClaimSearchController.SearchResultWrapper getClaimDetailsByClaimId(SAEClaimSearchController.ClaimInputs ClaimInputs,boolean isDeductible,boolean isApplied, Integer start,Boolean isMoreThan90days) {
         system.debug('getClaimDetails ClaimInputs: '+ClaimInputs);
         SAEClaimSearchController.SearchResultWrapper claimDetails = SAEClaimSearchController.getClaimsAutodoc(ClaimInputs, isDeductible, isApplied, start,  isMoreThan90days);
         return claimDetails;
     }
 }