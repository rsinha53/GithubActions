public with sharing class ACET_FeeScheduleController 
{
    // US3400693
    @AuraEnabled
    public static ACET_SAECalloutResult callScheduleService(List<FSRequest> requestList, ACET_AutoDocUtil.TableDetails currentTbl){
        ACET_SAECalloutResult returnRes = new ACET_SAECalloutResult();
        System.debug(JSON.serialize(requestList));
        System.debug(JSON.serialize(currentTbl));
        ACET_AutoDocUtil.TableDetails feeScheduleTbl = new ACET_AutoDocUtil.TableDetails();
        feeScheduleTbl.type = 'table';
        feeScheduleTbl.autodocHeaderName = 'Fee Schedule Lookup Results: ';
        feeScheduleTbl.componentName = 'Fee Schedule Lookup Results';
        // US3653575
        feeScheduleTbl.reportingHeader = 'Fee Schedule Lookup Results';
        feeScheduleTbl.componentOrder = 2;
        feeScheduleTbl.showComponentName = true;
        feeScheduleTbl.tableHeaders = new List<String>{'START', 'END', 'POS', 'CPT/HCPC CODE','MODIFIER','DX', 'FEE SCHEDULE #', 'TYPE', 'COUNT', 'BILLED AMOUNT', 'ALLOWED AMOUNT'};
        feeScheduleTbl.tableBody = currentTbl != null ? currentTbl.tableBody : new List<ACET_AutoDocUtil.TableRow>();
        feeScheduleTbl.selectedRows = currentTbl != null ? currentTbl.selectedRows : null;
        try {    
            //Not a good practice. Old polaris way. Until a better solution!!    
            for (Integer i = 0; i < requestList.size(); i++) {
                FSRequest req = requestList.get(i);
                ACET_FeeScheduleService.FeeRequst fr = new ACET_FeeScheduleService.FeeRequst();
                fr.fromDateOfService = req.startDate;
                fr.toDateOfService = req.endDate;
                fr.placeOfServiceCode = req.pos;
                fr.procedureCode = req.cpthcpc.split(','); //new List<String>{req.cpthcpc}; 
                fr.modifier = req.modifier.split(','); // new List<String>{req.modifier};
                fr.diagnosisCode = req.dx;
                fr.unitType = req.type;
                fr.numberOfUnits = req.count;
                fr.chargeAmount = req.billedAmount;
                //New
                fr.contractPayMethod = 'C';
                fr.ioRateTableNumber = '000000000';
                fr.icdVersionIndicator = '0';
                fr.productCode = req.prodCode;
                fr.productOfferId = req.prodOffId;
                fr.taxId = req.taxId;
                fr.providerId = req.provId;
                fr.market = req.market;
                fr.marketType = req.mktType;
                fr.ipa = req.ipa;
                fr.feeScheduleNumber = req.feeSchedNo;
                // Correct code
                ACET_SAECalloutResult resp = ACET_FeeScheduleService.invoke(fr);
                // testing
                //ACET_SAECalloutResult resp = ACET_FeeScheduleService.callServiceTest();
                if(resp.isSuccess && resp.response != null){
                    ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
                    tableRow = new ACET_AutoDocUtil.TableRow();
                    tableRow.uniqueKey = currentTbl != null ? currentTbl.tableBody.size() + String.valueOf(i) : String.valueOf(i);
                    tableRow.caseItemsExtId = req.contractId;
                    tableRow.rowColumnData = new List<ACET_AutoDocUtil.RowColumnData>();
                    ACET_FeeScheduleService.FeeResponse feeResp = (ACET_FeeScheduleService.FeeResponse)resp.response;
                    tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(feeResp.startDate) ? feeResp.startDate : '--', '', '', true));
                    tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(feeResp.endDate) ? feeResp.endDate : '--', '', '', true));
                    tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(feeResp.pos) ? feeResp.pos : '--', '', '', true));
                    tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(feeResp.cptHcpc) ? feeResp.cptHcpc : '--', '', '', true));
                    tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(feeResp.modifier) ? feeResp.modifier : '--', '', '', true));
                    tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(feeResp.dx) ? feeResp.dx : '--', '', '', true));
                    tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(feeResp.feeScheduleNo) ? feeResp.feeScheduleNo : '--', '', '', true));
                    tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(feeResp.type) ? feeResp.type : '--', '', '', true));
                    tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(feeResp.count) ? feeResp.count : '--', '', '', true));
                    tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(feeResp.billedAmount) ? feeResp.billedAmount : '--', '', '', true));
                    tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('outputText', String.isNotBlank(feeResp.fee) ? feeResp.fee : '--', '', '', true));
                    feeScheduleTbl.tableBody.add(tableRow);
                }
            } 
            returnRes.response = feeScheduleTbl; 
            returnRes.isSuccess = true;
            returnRes.statusCode = 200;
        } catch (Exception e) {
            returnRes.isSuccess = false;
            returnRes.message = e.getMessage();
            returnRes.statusCode = 999;
        }

        if(feeScheduleTbl.tableBody.isEmpty()){
            ACET_AutoDocUtil.TableRow tableRow = new ACET_AutoDocUtil.TableRow();
            tableRow = new ACET_AutoDocUtil.TableRow();
            tableRow.uniqueKey = '0';
            tableRow.rowColumnData = new List<ACET_AutoDocUtil.RowColumnData>();
            tableRow.rowColumnData.add(ACET_AutoDocUtil.setRowColumnData('noRecords', 'No Records Found', 'noRecords'));
            feeScheduleTbl.tableBody.add(tableRow);
            returnRes.response = feeScheduleTbl; 
        }

        return returnRes;
    }

    //For Claims
    @AuraEnabled
    public static ACET_SAECalloutResult callScheduleService_Claim(List<FSRequest> requestList){
        ACET_SAECalloutResult returnRes = new ACET_SAECalloutResult();
        return returnRes;
    }

    @AuraEnabled
    public static ACET_SAECalloutResult callContractService(String provId, String taxId, String mktType, String mktNbr, String prdtOffCd, List<FSRequest> requestList){
        ACET_SAECalloutResult returnRes = new ACET_SAECalloutResult();

        ACET_ProviderContractService conServe = new ACET_ProviderContractService();
        ACETWSCalloutResult contractResult =  conServe.getEAndIContracts(provId, taxId, null, mktType, mktNbr, prdtOffCd, true);

        if(contractResult.Success){
            ACET_EAndIContractsResponse cons = (ACET_EAndIContractsResponse) contractResult.Response;
            System.debug(JSON.serialize(contractResult.response));
            if(cons.employerandindividual != null && cons.employerandindividual.size() > 0){
                for(FSRequest fr: requestList){
                    fr.startDate = SAEUtils.formatDateFutureDate(fr.startDate);
                    fr.endDate = SAEUtils.formatDateFutureDate(fr.endDate);
                    Date startD = Date.valueOf(fr.startDate);System.debug(startD);
                    Date endD = Date.valueOf(fr.endDate);System.debug(endD);
                    
                    for(ACET_EAndIContractsResponse.Employerandindividual con : cons.employerandindividual){
                        Date startD_con = Date.valueOf(con.pnc_eff_dt);System.debug(startD_con);
                        Date endD_con = Date.valueOf(con.pnc_canc_dt);System.debug(endD_con);
                        if(con.pnc_tax_id_nbr == taxId && (startD_con <= startD && startD <= endD_con)){
                            fr.prodCode = con.pnc_prd_grp_desc;
                            fr.prodOffId = con.pnc_prdct_ofr_id;
                            fr.taxId = con.tax_id_nbr;
                            fr.provId = con.prov_id;
                            fr.market = con.pnc_mkt_nbr;
                            fr.mktType = con.pnc_mkt_typ_cd;
                            fr.ipa = con.pnc_ipa_nbr;
                            fr.feeSchedNo = con.pnc_fee_sched_nbr;
							fr.tableNum = con.pnc_optnt_rt_id;
                            fr.facilityCode = con.pnc_facl_contr_typ_cd;
                        }
                    }            
                }
                returnRes.response = requestList;
                returnRes.isSuccess = true;
            }else{
                returnRes.statusCode = contractResult.statusCode;
                returnRes.isSuccess = false;
                returnRes.message = 'Contracts not available';
            }            
        }else{
            returnRes.statusCode = contractResult.statusCode;
            returnRes.isSuccess = false;
            returnRes.message = 'Unexpected error occured.';
        }
        return returnRes;
    }

    // ACET_POS_Codes
    @AuraEnabled
    public static String getPOSCodes(){
        String retResp = '';
        try{
            retResp = [SELECT Body FROM StaticResource WHERE Name = 'ACET_POS_Codes' LIMIT 1].Body.toString();
        }catch(Exception e){
            System.debug(e.getMessage());
        }
        return retResp;
    }
    
	 @AuraEnabled
    public static String billTypecheck(String billType){
    List<SAE_Bill_Type__mdt> bt = [select id,patient_Type__c,Bill_type__c from SAE_Bill_Type__mdt];
	String patient;
	for (SAE_Bill_Type__mdt ft: bt){
     if(ft.Bill_type__c.Contains(billType)){
        patient = ft.patient_Type__c;  
      }
     }
     return patient;
    }
	
    public class FSRequest
    {
        @AuraEnabled public String startDate {get;set;}
        @AuraEnabled public String endDate {get;set;}
        @AuraEnabled public String pos {get;set;}
        @AuraEnabled public String cpthcpc {get;set;}
        @AuraEnabled public String modifier {get;set;}
        @AuraEnabled public String dx {get;set;}
        @AuraEnabled public String type {get;set;}
        @AuraEnabled public String count {get;set;}
        @AuraEnabled public String billedAmount {get;set;}
        @AuraEnabled public String contractId {get;set;}

        //New Parameters
        @AuraEnabled public String conPayMeth {get;set;} //C
        @AuraEnabled public String rateTblNo {get;set;}  //000000000
        @AuraEnabled public String icdVerInd {get;set;}  //0
        @AuraEnabled public String prodCode {get;set;}
        @AuraEnabled public String prodOffId {get;set;}
        @AuraEnabled public String taxId {get;set;}
        @AuraEnabled public String provId {get;set;}
        @AuraEnabled public String market {get;set;}
        @AuraEnabled public String mktType {get;set;}
        @AuraEnabled public String ipa {get;set;}
        @AuraEnabled public String feeSchedNo {get;set;}
		@AuraEnabled public String tableNum {get;set;}
        @AuraEnabled public String facilityCode {get;set;}

        //Claims
        @AuraEnabled public String contractType{get;set;}
    }
}