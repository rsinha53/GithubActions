public with sharing class ACETHSAAccountsDetailController extends ACETErrorHandler {
    public string HSAKey{get; set;}
    public ACETDatatableWrapper DTWrapper {get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public Interaction__c Interaction { get; set; } 
    public Contact Subject { get; set; }
    public String InteractionId {get; set;}
    public String contactId {get; set;}
    public String callTopic {get; set;}
    public string comments {get;set;}
    public string memberId {get; set;}
    public String unmaskedSSN{Get;set;}
    public ACETHSASummaryWebservice ACETHSASummary;
    public ACETHSASummaryResult hsaSummaryResult { get; set;}
    public ACETHSATransactionWebservice ACETHSATransactionWS;
    public ACETHSATransactionResult hsaTransactionResult { get; set;}
    public List<ACETHSATransactionResult> allTransactionResults{get;set;}
    public String statusSelected{get;set;} 
    public String viewSelected{get;set;}
    public boolean isDisabled{get;set;}
    public boolean isAll{get;set;}
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;} 

    public ACETHSAAccountsDetailController() {
     try{
        InteractionId = apexpages.currentpage().getparameters().get('interactionId');
        contactId = apexpages.currentpage().getparameters().get('contactId');
        callTopic = apexpages.currentpage().getparameters().get('callTopic');
        Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);
        system.debug('*** contactId'+contactId);
        System.debug('Entering'+Interaction);
        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.CaseObj.Topic__c = callTopic;
        wrapper.AutodocComment = comments;
        if (!String.isEmpty(contactId)) {
            Subject = ACETProviderUtility.GetContactByID(contactId);
        }
        system.debug('*** Subject '+Subject );
        initHighlightPanelAdditionalInfo();
        
        HSAKey = ApexPages.currentPage().getParameters().get('HSAKey');
        unmaskedSSN = ApexPages.currentPage().getParameters().get('ssn');
        system.debug('***HSAKey '+HSAKey  );
        system.debug('*** unmaskedSSN  '+unmaskedSSN );
        statusSelected='All';
        viewSelected = '100';
        isDisabled = true;
       } catch(Exception ex){
             setErrorMsg('MGD997',ex);
        }
        
    }
    
    //Status Dropdown values
    public List<SelectOption> getstatusList () {
        List<SelectOption> statusList = new List<SelectOption>();
        statusList.add(new SelectOption('All','All'));
        statusList.add(new SelectOption('Pending','Pending'));
        statusList.add(new SelectOption('Processed','Processed'));
        statusList.add(new SelectOption('Recent','Recent'));
        statusList.add(new SelectOption('Scheduled','Scheduled'));
        return statusList;
    }
    
    //View Dropdown values
    public List<SelectOption> getviewList () {
        List<SelectOption> viewList = new List<SelectOption>();
        viewList.add(new SelectOption('25','25'));
        viewList.add(new SelectOption('50','50'));
        viewList.add(new SelectOption('75','75'));
        viewList.add(new SelectOption('100','100'));
        return viewList;
    }
    
    public PageReference CallWSOnPageLoad()
    {
       try{
        unmaskedSSN = ApexPages.currentPage().getParameters().get('ssn');
        
        ACETWSCalloutResult SummaryResponse;
        system.debug(LoggingLevel.INFO, 'Inside CallWSOnPageLoad.');
        ACETHSASummary = new ACETHSASummaryWebservice();
        SummaryResponse = ACETHSASummary.GetHsaSummary(unmaskedSSN);
        system.debug('@@@response'+SummaryResponse );
        if(SummaryResponse.Success){
            try{
            
            hsaSummaryResult = (ACETHSASummaryResult)SummaryResponse.Response;
            system.debug('@@@result'+hsaSummaryResult );   

        }catch(Exception ex){
             setErrorMsg('MGD997',ex);
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.Label.ACETUnexpectedErrorMessage));
            }
        }
        else{
            if(SummaryResponse.statusCode==401){
               setErrorMsg('GN'+'500',null);
             }else if(SummaryResponse.statusCode==400){
               setErrorMsg('GN'+'400B',null);
             }else{
             setErrorMsg('GN'+SummaryResponse.statusCode,null);
             }
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, SummaryResponse.Message));
        }
       }catch(Exception ex){
                 setErrorMsg('MGD997',ex);
        } 
        return null;
        
    }
    
    public void callTransaction(){
        system.debug('@@@Inside Transaction Call');
        system.debug('@@@Inside Transaction Call statusSelected'+statusSelected);
        system.debug('@@@Inside Transaction Call viewSelected'+viewSelected);
        
        if(statusSelected != 'All')
        {
            isDisabled = false;
        }
        else
        {
            isDisabled = true;
            viewSelected = '100';
        }
        
    }
    
    
    public PageReference CallWSTransactionOnPageLoad() {
        try{
        system.debug('@@@Inside Transaction Call On Load HSAKey  '+HSAKey  );
        system.debug('@@@Status'+statusSelected );
        system.debug('@@@View'+viewSelected );
        //HSAKey = 'NHw5MDQwNDIzMDR8bnVsbHxPUFR8SFNBfG51bGx8bnVsbA==';
           
        if(statusSelected != 'All')
        {
        isAll = false;
        system.debug('@@@Inside not all'+statusSelected );
        
            ACETHSATransactionWebservice ACETHSATransactionWS = new ACETHSATransactionWebservice();
            ACETHSATransactionWS.init(HSAKey, statusSelected );  
            DTWrapper = new ACETDatatableWrapper('ACETHSATransactionWebservice', ACETHSATransactionWS );         
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Date', 'transactionDate'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Status', 'status'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Description', 'description'));
            DTWrapper.Columns.add(new ACETDataTableWrapper.DataColumn('Amount', 'amount'));
            DTWrapper.PageSize = Integer.ValueOf(viewSelected) ;
            DTWrapper.initOnDocumentReady = false;
            
        }
        else
        {
            system.debug('@@@Inside all'+statusSelected );
            allTransactionResults = new List<ACETHSATransactionResult>();
            isAll = true;
            ACETWSCalloutResult transResponseRec,transResponseSch;
            ACETHSATransactionWebservice ACETHSATransactionWS = new ACETHSATransactionWebservice();
            ACETHSATransactionWS.init(HSAKey, 'Recent');  
            transResponseRec = ACETHSATransactionWS.querypaginateddata(1 , 50, 1);
            system.debug('@@@response'+transResponseRec);
            if(transResponseRec.Success){
                List<ACETHSATransactionResult> tempListRec = (List<ACETHSATransactionResult>)transResponseRec.Response;
                system.debug('@@@success'+tempListRec );
                allTransactionResults.addAll(tempListRec );
             
            }  
            else{
              if(transResponseRec.statusCode==401){
               setErrorMsg('GN'+'500',null);
             }else if(transResponseRec.statusCode==400){
               setErrorMsg('GN'+'400B',null);
             }else{
             setErrorMsg('GN'+transResponseRec.statusCode,null);
             }
           // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, transResponseRec.Message));
        }

            system.debug('Second Call');
            ACETHSATransactionWebservice ACETHSATransactionWS1 = new ACETHSATransactionWebservice();
            ACETHSATransactionWS1.init(HSAKey, 'Scheduled');  
            transResponseSch = ACETHSATransactionWS1.querypaginateddata(1 , 50, 1);
            system.debug('***'+transResponseSch);
            
            if(transResponseSch.Success){
                List<ACETHSATransactionResult> tempListSch = (List<ACETHSATransactionResult>)transResponseSch.Response;
                system.debug('@@@success'+tempListSch );
                allTransactionResults.addAll(tempListSch );
                
            }
            else{
             if(transResponseSch.statusCode==401){
               setErrorMsg('GN'+'500',null);
             }else if(transResponseSch.statusCode==400){
               setErrorMsg('GN'+'400B',null);
             }else{
             setErrorMsg('GN'+transResponseSch.statusCode,null);
             }
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, transResponseSch.Message));
        }  
            system.debug('@@@all'+allTransactionResults);      
            
            for(ACETHSATransactionResult output:allTransactionResults){
                System.debug('+++++' + output);
            }
            try{
                sortByDate();
                
            } catch(Exception e) {
                setErrorMsg('MGD997',e);
                System.debug('^^^^^' + e);
            }
            for(ACETHSATransactionResult output:allTransactionResults){
                System.debug('%%%%%%%' + output);
            }
        }
            }catch(Exception ex){
             setErrorMsg('MGD997',ex);
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, label.ACETOILNotAvailable));
        }
                
        
        return null;
    }
    private void sortByDate(){
        system.debug('in sortbydate');
        List<ACETHSATransactionResult> tempList = new List<ACETHSATransactionResult>();
        tempList.addAll(allTransactionResults);
        for(ACETHSATransactionResult temp: tempList){
            System.debug(temp);
        }
        for(Integer i = 0; i < (tempList.size() - 1) ; i++){
            String oldDate, newDate;
            oldDate = tempList[i].transactionDate.split('/')[2] + tempList[i].transactionDate.split('/')[0] + tempList[i].transactionDate.split('/')[1];
            newDate = tempList[i+1].transactionDate.split('/')[2] + tempList[i+1].transactionDate.split('/')[0] + tempList[i+1].transactionDate.split('/')[1];
            if(oldDate < newDate){
                ACETHSATransactionResult placeholder = tempList[i+1];
                tempList[i+1] = tempList[i];
                tempList[i] = placeholder;
            }
            if(i > 0){
                for(Integer j = i; j > 0; j--){
                    oldDate = tempList[j].transactionDate.split('/')[2] + tempList[j].transactionDate.split('/')[0] + tempList[j].transactionDate.split('/')[1];
                    newDate = tempList[j-1].transactionDate.split('/')[2] + tempList[j-1].transactionDate.split('/')[0] + tempList[j-1].transactionDate.split('/')[1];
                    if(oldDate > newDate){
                        ACETHSATransactionResult placeholder = tempList[j-1];
                        tempList[j-1] = tempList[j];
                        tempList[j] = placeholder;
                    }
                }
            }
        }
        for(ACETHSATransactionResult temp: tempList){
            System.debug(temp);
        }
            
        allTransactionResults = tempList; 
    }
    private void initHighlightPanelAdditionalInfo(){
      try{ 
        if(AdditionalInfo == null){
            AdditionalInfo = new ACETHighlightsPanelAdditionalInfo(); 
        }        
        string addInfo = ApexPages.currentPage().getParameters().get('additionalInfo');
        if(addInfo != null)
        {
            AdditionalInfo  = (ACETHighlightsPanelAdditionalInfo)JSON.deserialize(addInfo, ACETHighlightsPanelAdditionalInfo.class);
        }
          
        hpAdditionInfoStr = JSON.serialize(AdditionalInfo);
        system.debug('Testing heighlight panel'+hpAdditionInfoStr);
       }catch(Exception ex){
           setErrorMsg('MGD997',ex);
        } 
    }
    
  
}