public class ACETDiagnosisAndPricingTable {
    
    public Interaction__c objInteraction {
        get{
            objInteraction = new Interaction__c();
            return objInteraction;
        }set;
    }
    public Interaction__c admissionDate {get;set;}
    public Interaction__c dischargeDate {get;set;}
    
    public string dischargeDateDummy {get;set;}
    
    public string pricingSetParam{get; set;}
    public ACETFeeScheduleWrapper feeScheduleWrapper {get;set;}
    public string surrogateKey {get; set;} 
    public Boolean isErrorMessageAdded {get; set;}
    public string DOSFromToday {get;set;}
    public string DOSThruToday {get;set;}
    public string diagCodes {get;set;}
    public string dateOfServiceFrom {get;set;}
    public string dateOfServicethru {get;set;}
    public string CPT {get;set;}
    public string MOdifiers {get;set;}
    public string POS {get;set;}
    public string drugCode {get;set;}
    public string daysOfUNits {get;set;}
    public string dollarCharges {get;set;}
    public string editCodeText {get;set;}
    public string pricedAmount {get;set;}
    public string drgCode {get;set;}
    public string invoiceAmount {get;set;} 
    
    public string revCode {get;set;}
    public string claimforType {get;set;}
    public string typeOfBill {get;set;}
    public string pricingSetId {
        get{
            if(pricingSetParam != null && pricingSetParam != ''){
                return pricingSetParam;                
            }
            return pricingSetId;
        }set;
    }
    public string billedAmount {get;set;}
    public string pricingScheduleId {get;set;}
    public string rxNationalDrugCode {get;set;}
    
    //PI 20.1 Sprint Changes  
    public string claimTypeLst {get;set;}
    public string rowEntry {get;set;}
    
    public List<ACETProviderFeeScheduleJSON2APEX.claimLines> outputResponse{get; set;}
    
    public List<ACETFeeScheduleWrapper> resultList{get;set;}
    public ACETFeeScheduleWrapper diagnosisCode {get;set;}
    
    public list<string> posVals{get; set;}
    public Map<String,String> posMap;
    public String objList{get;set;}
    public list<integer> inputList{get; set;}
    public boolean showvalue{get;set;}
    public boolean showDetails{get;set;} 
    public Map<Integer,List<ACETProviderFeeScheduleJSON2APEX.claimLines>> tablesDisplayMap {get;set;} 
    public Map<Integer,Decimal> mapPriceTotal;
    
    public ACETDiagnosisAndPricingTable(){
        admissionDate = new Interaction__c();
        dischargeDate = new Interaction__c(); 
        tablesDisplayMap = new Map<Integer,List<ACETProviderFeeScheduleJSON2APEX.claimLines>>();
        mapPriceTotal = new Map<Integer,Decimal>();
        claimforType = '';
        
        claimTypeLst = 'Professional-CMS1500';
        outputResponse = new List<ACETProviderFeeScheduleJSON2APEX.claimLines>();
        diagnosisCode = new ACETFeeScheduleWrapper();
        
        DOSFromToday = string.valueOf(Date.today());
        DOSThruTOday = string.valueOf(Date.today());
        posVals = new list<string>();
        posMap = new map<String,String>();
        for(Place_Of_Service_Values__mdt posValue : [select label,Priority__c,Description__c,Place_Of_Service__c from Place_Of_Service_Values__mdt order by Priority__c asc] ){                        
            posVals.add(posValue.Place_Of_Service__c+'-'+posValue.Description__c);
            posMap.put(posValue.Place_Of_Service__c,posValue.Description__c);
            objList = JSON.serialize(posVals);
        }
        inputList= new List<Integer>();
        
        for(Integer i=0;i<15;i++){
            inputList.add(i);//first row
        }
        
        
        showDetails = false;
        showvalue =false; 
        if(pricingSetParam != null){
            showDetails = true;
        }
    }
   
    public void showData()
    {
         
        system.debug('--------showvalue ------'+pricingSetParam); 
        showvalue = true;
        system.debug('--------showvalue after------'+showvalue);
    }
    
    //PI 20.1 sprint Changes
    public list<SelectOption> getclaimTypeOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Professional-CMS1500','Professional-CMS1500'));
        options.add(new SelectOption('Facility-UB04','Facility-UB04'));
        return options;
    }
    
    public void setTableSize(){
        diagnosisCode.diagnosisCode1 = null;
        diagnosisCode.diagnosisCode2 = null;
        diagnosisCode.diagnosisCode3 = null;
        diagnosisCode.diagnosisCode4 = null;
        diagnosisCode.diagnosisCode5 = null;
        diagnosisCode.diagnosisCode6 = null;
        diagnosisCode.diagnosisCode7 = null;
        diagnosisCode.diagnosisCode8 = null;
        diagnosisCode.diagnosisCode9 = null;
        diagnosisCode.diagnosisCode10 = null;
        diagnosisCode.diagnosisCode11= null;
        diagnosisCode.diagnosisCode12 = null;
        admissionDate.tst_Date_Field__c = null;
        drgCode = null;
        invoiceAmount = null;
        typeOfBill = null;
        objInteraction.tst_Date_Field__c = null;
        
        System.debug('claim clear'+claimTypeLst);
        inputList= new List<Integer>();
        
        for(Integer i=0;i<15;i++){
            inputList.add(i);//first row
        }
    }
    public void addRowsFromEntry(){
	if(rowEntry != null && rowEntry != ''){
        Integer noOfrows = Integer.valueOf(rowEntry);
        system.debug('noOfrows:::'+noOfrows);
        boolean moreRows = false;
        for(Integer i=0;i<noOfrows;i++){
            if(inputList.size() > 74){
                moreRows = true;
                break;
            }
            else{
                inputList.add(i);//first row    
            }                                
        }
	}
        system.debug('inputList.size-->'+inputList.size());
    }
    
    public string returnDateFormat(string inputStr){
        if(inputStr != null && inputStr != ''){
            return inputStr.split('-')[1]+'/'+inputStr.split('-')[2]+'/'+inputStr.split('-')[0];
        }
        return inputStr;
    }
    
    public string jsonStr{get; set;}
    integer i=0; 
    public map<string, boolean> outputcombination;
       public void searchResults(){ 
        if(claimTypeLst == 'Facility-UB04'){
            i ++;
            outputResponse = new List<ACETProviderFeeScheduleJSON2APEX.claimLines>();   
        }
          
        //pricingSetId = 'ACET-INSTITUTIONAL';
         if(outputcombination == null){
            outputcombination = new map<string, boolean>();
        }
      
        system.debug('jsonStr'+jsonStr);
        if(claimTypeLst == 'Professional-CMS1500'){ 
            claimforType = 'PROF';
        }else {
            claimforType = 'INST';
        }
        
        //this.admissionDate = string.valueOf(objInteraction.tst_Date_Field__c);
        showDetails = true;
        List<ACETFeeScheduleWrapper> claimLinesTemp1 = new List<ACETFeeScheduleWrapper>();   
        if(jsonStr != null && jsonStr != ''){
            claimLinesTemp1 = (List<ACETFeeScheduleWrapper>) JSON.deserialize(jsonStr, list<ACETFeeScheduleWrapper>.class);  
        }
        
        showDetails = true;
        
        string admissionDatestr;
        string dischargeDatestr = '';
        if(admissionDate.tst_Date_Field__c != null){
            admissionDatestr = string.valueOf(admissionDate.tst_Date_Field__c);
        }else{
            admissionDatestr = '';
        }
        
        if(dischargeDate.tst_Date_Field__c != null){
            dischargeDatestr = string.valueOf(dischargeDate.tst_Date_Field__c);
        }
        dischargeDateDummy = '';//we need remove once DD mapping is confirm
        
        ACETProviderFeeScheduleWebService ACTPFeeShed = new ACETProviderFeeScheduleWebService();
        ACETWSCalloutResult oACETWSCalloutResult = ACTPFeeShed.init(DOSFromToday,DOSThruToday,dollarCharges,dateOfServiceFrom,dateOfServicethru,MOdifiers,POS,CPT,rxNationalDrugCode,daysOfUnits,pricingSetId,diagnosisCode,claimLinesTemp1,drgCode,invoiceAmount,admissionDatestr,dischargeDateDummy,revCode,claimforType,typeOfBill);
        Decimal totalPriceAmount = 0.00; 
        if(oACETWSCalloutResult.response != null){
            system.debug('oACETWSCalloutResult.response  ::'+oACETWSCalloutResult.response);
            ACETProviderFeeScheduleJSON2APEX outputResponseTemp = (ACETProviderFeeScheduleJSON2APEX)oACETWSCalloutResult.response;
            if(outputResponseTemp != null){
                if(outputResponseTemp.feeScheduleDetailResponse != null){
                    if(outputResponseTemp.feeScheduleDetailResponse.claimHeaders != null){
                        
                        for(ACETProviderFeeScheduleJSON2APEX.claimHeaders ch: outputResponseTemp.feeScheduleDetailResponse.claimHeaders){
                            if(ch.diagnosisRelatedGroupCode != null)
                                ch.diagnosisRelatedGroupCode = ch.diagnosisRelatedGroupCode;
                            if(ch.claimLines != null){
                                for(ACETProviderFeeScheduleJSON2APEX.claimLines cli: ch.claimLines ){
                                    cli.claimClassIDParent = ch.claimClassID;
                                    cli.manualReviewIndicatorParent = ch.manualReviewIndicator;
                                    cli.pricingSetIDParent = ch.pricingSetID;
                                    cli.pricingScheduleIDParent = ch.pricingScheduleID;
                                    cli.pricingScheduleVersionIDParent = ch.pricingScheduleVersionID;
                                    cli.dateOfServiceFrom = returnDateFormat(cli.dateOfServiceFrom);
                                    cli.dateOfServiceThru = returnDateFormat(cli.dateOfServiceThru);
                                    cli.revenueCode = cli.revenueCode;
                                    cli.drgCode = ch.diagnosisRelatedGroupCode;
                                   
                                    cli.totalPricedAmount = totalPriceAmount;
                                    
                                    
                                    if(cli.finalPricedAmount != null){   
                                        totalPriceAmount += decimal.valueOf(cli.finalPricedAmount);
                                        mapPriceTotal.put(i,totalPriceAmount);
                                    }
                                    string claimLineNumberTmp = cli.claimLineNumber;
                                    cli.claimLineNumber = null; 
                                    string combination = string.valueOf(cli.dateOfServiceFrom+''+cli.dateOfServiceThru+''+cli.procedureCode+''+ cli.modifierPricedList + '' + cli.placeOfServiceCode + '' + cli.drgCode+''+cli.serviceUnits+''+cli.billedAmount+''+pricingSetId);
                                     system.debug('>>'+cli);
                                    if(claimTypeLst == 'Facility-UB04'){
                                        cli.claimLineNumber = claimLineNumberTmp;
                                        outputResponse.add(cli); 
                                    }else{ 
                                    if(outputcombination.get(combination) == null) {
                                        cli.claimLineNumber = claimLineNumberTmp;
                                        outputResponse.add(cli);    
                                    }
                                    outputcombination.put(combination,true);
                                    }
                                }
                            }                           
                        }  
                    } 
                    
                }
            }
            if(claimTypeLst == 'Facility-UB04' && outputResponse.size() > 0){
                ACETProviderFeeScheduleJSON2APEX.claimLines cli = new ACETProviderFeeScheduleJSON2APEX.claimLines();
                cli.totalPricedAmount = totalPriceAmount;
                outputResponse.add(cli);   
            }
            tablesDisplayMap.put(i,outputResponse);
            showDetails = true; 
        }
        if(oACETWSCalloutResult.Message != null && oACETWSCalloutResult.Message != ''){
            if(claimTypeLst == 'Facility-UB04')
                i --;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,oACETWSCalloutResult.Message));
        }  
        
    }
    
    public void cliamTypeChange(){
        system.debug('claimTypeLst----->'+claimTypeLst);
        typeOfBill = null;
        drgCode = null;
        showvalue = true;
        invoiceAmount = null;
        typeOfBill = null;
        admissionDate.tst_Date_Field__c = null;
        objInteraction.tst_Date_Field__c = null;
        diagnosisCode.diagnosisCode1 = null;
        diagnosisCode.diagnosisCode2 = null;
        diagnosisCode.diagnosisCode3 = null;
        diagnosisCode.diagnosisCode4 = null;
        diagnosisCode.diagnosisCode5 = null;
        diagnosisCode.diagnosisCode6 = null;
        diagnosisCode.diagnosisCode7 = null;
        diagnosisCode.diagnosisCode8 = null;
        diagnosisCode.diagnosisCode9 = null;
        diagnosisCode.diagnosisCode10 = null;
        diagnosisCode.diagnosisCode11 = null;
        diagnosisCode.diagnosisCode12 = null;
        system.debug('claimTypeLst>>'+claimTypeLst);
        showDetails = false; 
        
        outputResponse = new list<ACETProviderFeeScheduleJSON2APEX.claimLines>();
        tablesDisplayMap = new Map<Integer,List<ACETProviderFeeScheduleJSON2APEX.claimLines>>();
        inputList= new List<Integer>();
        for(Integer i=0;i<15;i++){
            inputList.add(i);//first row
        }
    }
}