public with sharing class ACETDynamicCallTypesDisplayController {

    public String attrCallTop {get; set;}
    public String selectedPicklistCallType {get; set;}
    public List<String> selectedCallType {get; set;}
    public List<String> selectedAccountType {get; set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public String attrLabel {get; set;}
 
    public ACETDynamicCallTypesDisplayController() {
        wrapper = new ACETCallTopicsDataWrapper();
    }
    
    public List<SelectOption> getDynamicPickListCallTypes() {
        Boolean isOtherAvailable = false;
        List<String> callTypeList = getCallTypesAndAccountTypes(attrCallTop,'CallType');
        List<SelectOption> options = new List<SelectOption>();
        if(callTypeList != null && callTypeList.size() > 0) {
            options.add(new selectOption('','--None--'));
            for(String callType : callTypeList) {
                if(callType != null) {
                    if(callType != 'Other') {
                        options.add(new selectOption(callType,callType));   
                    }
                    else {
                        isOtherAvailable = true;
                    }   
                }
            } 
            if(isOtherAvailable) {
                options.add(new selectOption('Other','Other')); 
            }
        }
        return options;
    }
    
     public List<SelectOption> getDynamicCallTypes() {
        System.debug('Entering'+attrCallTop);
        Boolean isOtherAvailable = false;
        List<String> callTypeList = getCallTypesAndAccountTypes(attrCallTop,'CallType');
        List<SelectOption> options = new List<SelectOption>();
        if(callTypeList != null && callTypeList.size() > 0) {
            for(String callType : callTypeList) {
                if(callType != null) {
                    if(callType != 'Other') {
                        options.add(new selectOption(callType,callType));   
                    }
                    else {
                        isOtherAvailable = true;
                    }   
                }
            }
            if(isOtherAvailable) {
                options.add(new selectOption('Other','Other')); 
            }
        }
        return options;
    }
    
    public List<CallTypeWrapper> getDynamicCallTypess() {
        Boolean isOtherAvailable = false;
        List<String> callTypeList = ACETDynamicCallTypesDisplayController.getCallTypesAndAccountTypes(attrCallTop,'CallType');
        List<CallTypeWrapper> callTypeWrapList = new List<CallTypeWrapper>();
        if(callTypeList != null && callTypeList.size() > 0) {
            for(String callType : callTypeList) {
                if(callType != null) {
                    if(callType != 'Other') {
                        callTypeWrapList.add(new CallTypeWrapper(callType));   
                    } 
                    else {
                        isOtherAvailable  = true;
                    }
                } 
            }
            if(isOtherAvailable) {
                callTypeWrapList.add(new CallTypeWrapper('Other'));
            }
        }
        System.debug('Adding Checkbox values:::::'+callTypeWrapList);
        return callTypeWrapList;
    }

    public List<SelectOption> getAccountType()
    {
        List<SelectOption> options = new List<SelectOption>();
        List<String> accountTypeList = getCallTypesAndAccountTypes(attrCallTop,'Account');
        if(accountTypeList != null) {
            for(String accType : accountTypeList) {
                if(accType != null) {
                    options.add(new selectOption(accType,accType)); 
                } 
            } 
        }
       return options;
    }
    
    public Static List<String> getCallTypesAndAccountTypes(String selectedCallTopic, String selectedType) {
        List<Swivel_Topic__c> callsTopicList = [select Call_Type__c,Active__c,Account_Type__c from Swivel_Topic__c where Active__c = true AND Swivel_Topic__c =: selectedCallTopic];
        Set<String> callTypeSet = new Set<String>();
        List<String> sortCallTypeList = new List<String>();
        if(callsTopicList != null) {
            for(Swivel_Topic__c types:callsTopicList) {
                if(selectedType == 'Account') {
                    callTypeSet.add(types.account_type__c);
                }
                else {
                    callTypeSet.add(types.Call_Type__c);
                }
            } 
        }
        if(callTypeSet.size () > 0) {
            sortCallTypeList.addAll(callTypeSet);
            sortCallTypeList.sort();   
        }
        return sortCallTypeList;
    } 
    
    public class CallTypeWrapper {
        public String callType {get; set;}
        public CallTypeWrapper(String callTypeC) {
            callType = callTypeC;
        }
    }
}