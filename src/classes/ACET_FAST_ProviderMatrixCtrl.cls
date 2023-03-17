/*****************************************************************************************************
ACET_FAST_ProviderMatrixCtrl
Test Class Name:  ACET_FAST_ProviderMatrixCtrlTest
Author: Shaik Mohammad Yaseen
Description: This class is used an controller for ACET_FAST_ProviderMatrix Components. 
Reference US3245110 - Provider Matrix Data
15/02/2021 - Shaik Mohammad Yaseen - Initial
******************************************************************************************************/
public without sharing class ACET_FAST_ProviderMatrixCtrl {
    
    @AuraEnabled
    public static List<Provider_Matrix__c> getProverMatrixRecs(string lob, string category, string subCategory, string globalStr,boolean isGlobalSearch){
        set<id> pmatrixIdSet = new set<Id>();
        
        List<Provider_Matrix__c> pMatrixList = new List<Provider_Matrix__c>();
        if(lob!='' && lob!=null){
            pMatrixList = getFilterRecs(lob,category,subCategory);
            if(pMatrixList.size()>0){
                for(Provider_Matrix__c pMatrix: pMatrixList){
                    pmatrixIdSet.add(pMatrix.id);
                }
            }
        }
        if(isGlobalSearch){
            pMatrixList = new List<Provider_Matrix__c>();
            pMatrixList = (pmatrixIdSet.size()>0)? getGlobalSearchRecs(globalStr,pmatrixIdSet) : getGlobalSearchRecs(globalStr);
            
        }
        return pMatrixList;
    }
    public static List<Provider_Matrix__c> getFilterRecs(string lob, string category, string subCategory){
        List<Provider_Matrix__c> qryList = new List<Provider_Matrix__c>();
        List<String> providerMatrixFields = ACET_FAST_ProviderMatrixCtrl.getProviderMatrixFieldSets();
        String soql = 'SELECT ' + String.join(providerMatrixFields, ',') + ' FROM Provider_Matrix__c ';
        
        if(lob!='' && lob!=null){
            soql = soql+' WHERE LOB__c = \'' + String.escapeSingleQuotes(lob) + '\'';
            if(category != '' && category != null){
                soql= soql+' AND Category__c= \''+ String.escapeSingleQuotes(category) + '\'';
                if(subCategory!='' && subCategory!= null){
                    soql = soql+'AND Sub_Category__c = \''+String.escapeSingleQuotes(subCategory) + '\'';
                }
            }
            soql = soql+' ORDER BY CreatedDate LIMIT 2000';
            system.debug('soql==>'+soql);
            qryList = database.query(soql);
        }
        return qryList; 
    }
    public static List<Provider_Matrix__c> getGlobalSearchRecs(string globalStr){
        List<Provider_Matrix__c> pMatrixList = new List<Provider_Matrix__c>();
        String globalSearchStr = '*'+globalStr+'*';
        
        List<String> providerMatrixFields = ACET_FAST_ProviderMatrixCtrl.getProviderMatrixFieldSets();
        String qryFields = String.join(providerMatrixFields, ',');
        
        String searchQuery = 'FIND \'' + globalSearchStr + '\' IN ALL FIELDS RETURNING  Provider_Matrix__c('+' '+qryFields+' '+')';
        List<List <sObject>> searchList = search.query(searchQuery);
        pMatrixList = ((List<Provider_Matrix__c>)searchList[0]);
        return pMatrixList;
    }
    public static List<Provider_Matrix__c> getGlobalSearchRecs(string globalStr, set<Id> pMatrixRecIdSet){
        List<Provider_Matrix__c> pMatrixList = new List<Provider_Matrix__c>();
        String globalSearchStr = '*'+globalStr+'*';
        
        List<String> providerMatrixFields = ACET_FAST_ProviderMatrixCtrl.getProviderMatrixFieldSets();
        String qryFields = String.join(providerMatrixFields, ',');
        
        String searchQuery = 'FIND \'' + globalSearchStr + '\' IN ALL FIELDS RETURNING  Provider_Matrix__c('+' '+qryFields+' '+' WHERE Id IN:pMatrixRecIdSet)';
        List<List <sObject>> searchList = search.query(searchQuery);
        pMatrixList = ((List<Provider_Matrix__c>)searchList[0]);
        return pMatrixList;
    }
    public static List<String> getProviderMatrixFieldSets(){
        List<String> fields = new List<String>();
        FieldSet fieldsToQuery = SObjectType.Provider_Matrix__c.fieldSets.ACET_FAST_ProviderMatrixKCFields;
        for (FieldSetMember field : fieldsToQuery.getFields()) {
            fields.add(field.getFieldPath());
        }
        return fields;
    }
    @AuraEnabled
    public static CaseRecordTypeNameLobListWrapper getLobValues(string caseRecId){
        CaseRecordTypeNameLobListWrapper cRectypeLobListWrap = new CaseRecordTypeNameLobListWrapper();
        List<case> caseRecLst = [SELECT id, Recordtype.Name from case where id=:caseRecId];
        if(caseRecLst.size()>0){
            case caseRec = caseRecLst[0];
            
            cRectypeLobListWrap.caseRectypeName = caseRec.Recordtype.Name;
            if(cRectypeLobListWrap.caseRectypeName=='Reactive Resolution'){
                cRectypeLobListWrap.rpRecordtypeId= getRecordTypeIdbyDevName('PIR_Resolution_Partner__c','Reactive_Resolution_Partners');
            }else{
                cRectypeLobListWrap.rpRecordtypeId= getRecordTypeIdbyDevName('PIR_Resolution_Partner__c','Proactive_Action_Partner');
            }
        }
        List<SelectOptionWrapper> options = new List<SelectOptionWrapper>();
        Schema.DescribeFieldResult fieldResult = Provider_Matrix__c.LOB__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOptionWrapper(f.getLabel(), f.getValue()));
        }
        cRectypeLobListWrap.lobList = options;
        return cRectypeLobListWrap;
    }
    @AuraEnabled
    public static List<SelectOptionWrapper> getCategoryValues(string lobValue){
        
        Map<String,List<String>> dependentPicklistValuesMap = ACET_FAST_Utility.getDependentPicklistValues(Provider_Matrix__c.Category__c);
        Map<string,string> categoryMap=new Map<string,string>(); 
        List<SelectOptionWrapper> options = new List<SelectOptionWrapper>();
        Schema.DescribeFieldResult fieldResult = Provider_Matrix__c.Category__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
           
            categoryMap.put(f.getLabel(), f.getValue());
        }
        if(dependentPicklistValuesMap.containsKey(lobValue)){
             for( string pickValue : dependentPicklistValuesMap.get(lobValue)){
                 if(categoryMap.containsKey(pickValue)){
           options.add(new SelectOptionWrapper(pickValue, categoryMap.get(pickValue)));
                 }
           
           }
        }
        return options;
    }
    @AuraEnabled
    public static List<SelectOptionWrapper> getSubCategoryValues(string categoryValue){
         
        Map<String,List<String>> dependentPicklistValuesMap = ACET_FAST_Utility.getDependentPicklistValues(Provider_Matrix__c.Sub_Category__c);
        Map<string,string> subCategoryMap=new Map<string,string>(); 
        List<SelectOptionWrapper> options = new List<SelectOptionWrapper>();
        Schema.DescribeFieldResult fieldResult = Provider_Matrix__c.Sub_Category__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
           
           subCategoryMap.put(f.getLabel(), f.getValue());
        }
        if(dependentPicklistValuesMap.containsKey(categoryValue)){
         for( string pickValue : dependentPicklistValuesMap.get(categoryValue)){
           if(subCategoryMap.containsKey(pickValue)){
           options.add(new SelectOptionWrapper(pickValue, subCategoryMap.get(pickValue)));
          }
         } 
        }
        system.debug('==Options=='+options);
        return options;
    }
    @AuraEnabled
    public static String getRPId(string pMatrixId){
        string rpNameValue = '';
        if(pMatrixId!='' && pMatrixId!=null){
            List<Provider_Matrix__c> pMatrixList = new List<Provider_Matrix__c>();
            pMatrixList=[SELECT id, CrossWalk_Case_RPI__c FROM Provider_Matrix__c WHERE id=:pMatrixId];
            if(pMatrixList.size()>0){
                rpNameValue=pMatrixList[0].CrossWalk_Case_RPI__c;
            }
        }
        
        string rpId = '';
        if(rpNameValue!=null && rpNameValue!=''){
            List<Provider_Matrix__c> rpNamesList = new List<Provider_Matrix__c>();  
            rpNamesList = [SELECT id from Provider_Matrix__c where name=:rpNameValue];
            if(rpNamesList.size()>0){
                rpId =  rpNamesList[0].id;
            }
        }
        
        return rpId;
    }
    public static Id getRecordTypeIdbyDevName(String objectName, String strRecordTypeDevName){
        return  Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosByDeveloperName().get(strRecordTypeDevName).getRecordTypeId();
    }
    public class SelectOptionWrapper{
        @AuraEnabled
        public string sLabel{get;set;}
        @AuraEnabled
        public string sValue{get;set;}
        public SelectOptionWrapper(string sLabel, string sValue){
            this.sLabel = sLabel;
            this.sValue = sValue;
        }
    }
    public class CaseRecordTypeNameLobListWrapper{
        @AuraEnabled
        public List<SelectOptionWrapper> lobList{set;get;}
        @AuraEnabled
        public string caseRectypeName{set;get;}
        @AuraEnabled
        public string rpRecordtypeId{set;get;}
        public CaseRecordTypeNameLobListWrapper(){
            lobList = new List<SelectOptionWrapper>();
        }
    }
}