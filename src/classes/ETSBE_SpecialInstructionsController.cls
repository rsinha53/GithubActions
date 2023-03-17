public with sharing class ETSBE_SpecialInstructionsController {
    @AuraEnabled 
    public static user getUser(){
        User oUser = [select id,Name,Agent_Type__c,Profile_Name__c,ProfileId,Role_Name__c, BEO_Specialty__c FROM User Where id =: userInfo.getUserId()];
        system.debug('oUser:: '+oUser);
        
        return oUser;
    }
    
    
    @AuraEnabled
    public static List<String> populateBusinessDropdown(String searchType, String searchBusinessUnit, String searchTopic, String searchTypeSel, String searchUser, String searchProfile,String searchfundingType){
        if(searchfundingType == 'None'){
            searchfundingType ='';
        }
        String query = '';
        List<String> dropdownResults = new List<String>();
        List<Special_Instructions__c> results = new List<Special_Instructions__c>();
        String searchNoRegion = '';
        if(searchUser.contains(' - ')){
            searchNoRegion = searchUser.split(' - ')[0];
        }
        System.debug('TESTING CURRENT DATE: ' + Date.today().format());
        String curr = Date.today().format();
        String month = curr.split('/')[0];
        String day = curr.split('/')[1];
        String year = curr.split('/')[2];
        if(integer.valueof(month) < 10){
        	month = '0' + month;
        }
        if(integer.valueof(day) < 10){
        	day = '0' + day;
        }
        curr = year + '-' + month + '-' + day;
        System.debug('TESTING CURRENT FORMAT: ' + curr);
        if(searchType == 'Business Unit'){
            if(searchUser == 'System Administrator'){
                Schema.DescribeFieldResult F = All_Business_Units__c.Business_Unit_Full_List__c.getDescribe();
                Schema.sObjectField T = F.getSObjectField();
                List<PicklistEntry> entries = T.getDescribe().getPicklistValues();
                for(Integer i = 0; i < entries.size(); i++){
                    dropdownResults.add(entries[i].Label);
                }
            } else {
                query = 'SELECT Business_Unit__c FROM Special_Instructions__c';
                if(searchUser != 'System Administrator' && !searchProfile.contains('Research User')){
                    if(searchNoRegion != ''){
                        query = query + ' WHERE (ACET_Role__c = \'' + searchUser + '\' OR ACET_Role__c = \'' + searchNoRegion + '\')';
                    } else {
                        query = query + ' WHERE ACET_Role__c = \'' + searchUser + '\'';
                    }
                }
                System.debug('BU QUERY: ' + query);
                query = query + ' And Funding_Type__c= null AND Effective_Date__c <= ' + curr + ' AND (End_Date__c > ' + curr + ' OR End_Date__c = null) GROUP BY Business_Unit__c LIMIT 40000';
                list<AggregateResult> AggregateResultList1 = Database.query(query);
                if(AggregateResultList1!= null && AggregateResultList1.size() > 0){ 
                    for(AggregateResult agg:AggregateResultList1){ 
                        dropdownResults.add((String)agg.get('Business_Unit__c')); 
                    } 
                }
                /*for(Integer i = 0; i < results.size(); i++){
                    if(results[i].Business_Unit__c != null && results[i].Business_Unit__c != '' && dropdownResults.contains(results[i].Business_Unit__c) == false){
                        dropdownResults.add((String) results[i].Business_Unit__c);
                    }
                }*/
            }
        } else if(searchType == 'Topic'){
            query = 'SELECT Topic__c FROM Special_Instructions__c WHERE Business_Unit__c = \''+String.escapeSingleQuotes(searchBusinessUnit)+'\' And (Funding_Type__c = null or Funding_Type__c = \''+String.escapeSingleQuotes(searchfundingType)+'\')'; 
            if(searchUser != 'System Administrator' && !searchProfile.contains('Research User')){
                if(searchNoRegion != ''){
                    query = query + ' AND (ACET_Role__c = \'' + searchUser + '\' OR ACET_Role__c = \'' + searchNoRegion + '\')';
                } else {
                    query = query + ' AND ACET_Role__c = \'' + searchUser + '\'';
                }
            }
            query = query + ' AND Effective_Date__c <= ' + curr + ' AND (End_Date__c > ' + curr + ' OR End_Date__c = null) GROUP BY Topic__c';
            System.debug('IC QUERY: ' + query);
            list<AggregateResult> AggregateResultList1 = Database.query(query);
            if(AggregateResultList1!= null && AggregateResultList1.size() > 0){ 
                for(AggregateResult agg:AggregateResultList1){ 
                    dropdownResults.add((String)agg.get('Topic__c')); 
                } 
            }
            /*for(Integer i = 0; i < results.size(); i++){
                if(results[i].Topic__c != null && results[i].Topic__c != '' && dropdownResults.contains(results[i].Topic__c) == false){
                    dropdownResults.add((String) results[i].Topic__c);
                }
            }*/
        } else if(searchType == 'Type'){
            query = 'SELECT Type__c FROM Special_Instructions__c WHERE Business_Unit__c = \''+String.escapeSingleQuotes(searchBusinessUnit)+'\' AND Topic__c = \''+String.escapeSingleQuotes(searchTopic)+'\' And (Funding_Type__c = null or Funding_Type__c = \''+String.escapeSingleQuotes(searchfundingType)+'\')'; 
            if(searchUser != 'System Administrator' && !searchProfile.contains('Research User')){
                if(searchNoRegion != ''){
                    query = query + ' AND (ACET_Role__c = \'' + searchUser + '\' OR ACET_Role__c = \'' + searchNoRegion + '\')';
                } else {
                    query = query + ' AND ACET_Role__c = \'' + searchUser + '\'';
                }
            }
            query = query + '  AND Effective_Date__c <= ' + curr + ' AND (End_Date__c > ' + curr + ' OR End_Date__c = null) GROUP BY Type__c';
            System.debug('TCT QUERY: ' + query);
            list<AggregateResult> AggregateResultList1 = Database.query(query);
            if(AggregateResultList1!= null && AggregateResultList1.size() > 0){ 
                for(AggregateResult agg:AggregateResultList1){ 
                    dropdownResults.add((String)agg.get('Type__c')); 
                } 
            }
            /*for(Integer i = 0; i < results.size(); i++){
                if(results[i].Type__c != null && results[i].Type__c != '' && dropdownResults.contains(results[i].Type__c) == false){
                    dropdownResults.add((String) results[i].Type__c);
                }
            }*/
        } else if(searchType == 'Subtype'){
            query = 'SELECT Subtype__c FROM Special_Instructions__c WHERE Business_Unit__c = \''+String.escapeSingleQuotes(searchBusinessUnit)+'\' AND Topic__c = \''+String.escapeSingleQuotes(searchTopic)+'\' AND Type__c = \''+String.escapeSingleQuotes(searchTypeSel)+'\' And (Funding_Type__c = null or Funding_Type__c = \''+String.escapeSingleQuotes(searchfundingType)+'\')';
            if(searchUser != 'System Administrator' && !searchProfile.contains('Research User')){
                if(searchNoRegion != ''){
                    query = query + ' AND (ACET_Role__c = \'' + searchUser + '\' OR ACET_Role__c = \'' + searchNoRegion + '\')';
                } else {
                    query = query + ' AND ACET_Role__c = \'' + searchUser + '\'';
                }
            } 
            System.debug('TCS QUERY: ' + query);
            query = query + ' AND Effective_Date__c <= ' + curr + ' AND (End_Date__c > ' + curr + ' OR End_Date__c = null) GROUP BY Subtype__c';
            list<AggregateResult> AggregateResultList1 = Database.query(query);
            if(AggregateResultList1!= null && AggregateResultList1.size() > 0){ 
                for(AggregateResult agg:AggregateResultList1){ 
                    dropdownResults.add((String)agg.get('Subtype__c')); 
                } 
            }
            /*for(Integer i = 0; i < results.size(); i++){
                if(results[i].Subtype__c != null && results[i].Subtype__c != '' && dropdownResults.contains(results[i].Subtype__c) == false){
                    dropdownResults.add((String) results[i].Subtype__c);
                }
            }*/
        }
        
        dropdownResults.sort();
        return dropdownResults;
    }
    
    public class GroupDetails {
        @AuraEnabled public string policyNumber {get;set;}
        @AuraEnabled public string platform {get;set;}
        @AuraEnabled public string situsState {get;set;}
        @AuraEnabled public string region {get;set;}
        @AuraEnabled public string AgencyBrokerName {get;set;}
        @AuraEnabled public string groupNumber {get;set;}
        @AuraEnabled public string sourceCode {get;set;}
    }
    //jangi - start
    public class SpecialInstructionsWrapper{
        @AuraEnabled public ETSBE_SpecialInstructions specialInstruction {get;set;}
        @AuraEnabled public List<InternalContact> internalContact {get;set;}
    }
    
    public class InternalContact{
        @AuraEnabled public string firstName {get;set;}
        @AuraEnabled public string lastName {get;set;}
        @AuraEnabled public string name {get;set;}
        @AuraEnabled public string role {get;set;}
    } 
    //jangi - start ends
    @AuraEnabled
    public static SpecialInstructionsWrapper processTTSResults(String groupDetailsJSON, String searchBusinessUnit, String searchTopic, String searchType, String searchSubtype, String searchUser, String searchProfile){ //jangi
        GroupDetails groupData = (ETSBE_SpecialInstructionsController.GroupDetails) System.JSON.deserialize(groupDetailsJSON, ETSBE_SpecialInstructionsController.GroupDetails.class);
        System.debug('@@ groupData: ' + groupData);
        String query = '';
        ETSBE_SpecialInstructions specInstructions = new ETSBE_SpecialInstructions();
        List<Special_Instructions__c> results = new List<Special_Instructions__c>(); //jangi
        String searchNoRegion = '';
        if(searchUser.contains(' - ')){
            searchNoRegion = searchUser.split(' - ')[0];
        }
        query = 'SELECT Form_Link__c, name, URL_Email__c, Member_ID_Required_Indicator__c, Directions__c, SLA_Day__c,Routing_Option__c,Department__c,DOS_Required_Indicator__c,Validation_on_Routed_Appl__c,Routing_Appl_Desc__c,Queue_Name__c,Id, '
            +'Supplemental_Routing__c,Supplemental_Routing_Ref__c,Platform__c '
            +'FROM Special_Instructions__c WHERE Business_Unit__c = \''+String.escapeSingleQuotes(searchBusinessUnit)+'\' AND Topic__c = \''+String.escapeSingleQuotes(searchTopic)+'\' AND Type__c = \''+String.escapeSingleQuotes(searchType)+'\' AND Subtype__c = \''+String.escapeSingleQuotes(searchSubtype)+'\'';
        System.debug('PROFILE: ' + searchProfile);
        if(searchUser != 'System Administrator' && !searchProfile.contains('Research User')){
            System.debug('INSIDE PROFILE CHECK: ' );
            if(searchNoRegion != ''){
                query = query + ' AND (ACET_Role__c = \'' + String.escapeSingleQuotes(searchUser) + '\' OR ACET_Role__c = \'' + String.escapeSingleQuotes(searchNoRegion) + '\')';
            } else {
                query = query + ' AND ACET_Role__c = \'' + String.escapeSingleQuotes(searchUser) + '\'';
            }
        }
        String curr = Date.today().format();
        String month = curr.split('/')[0];
        String day = curr.split('/')[1];
        String year = curr.split('/')[2];
        if(integer.valueof(month) < 10){
        	month = '0' + month;
        }
        if(integer.valueof(day) < 10){
        	day = '0' + day;
        }
        curr = year + '-' + month + '-' + day;
        query = query + ' AND Effective_Date__c <= ' + curr + ' AND (End_Date__c > ' + curr + ' OR End_Date__c = null)';
        System.debug('HERE IS THE QUERY: ' + query);
        results = Database.query(query);
        //System.debug('results-'+results.size());
        //System.debug('results-'+results);
        SpecialInstructionsWrapper wrapper = new SpecialInstructionsWrapper(); //jangi
        if(results.size() > 0){
            
            wrapper = fetchSpecInstructionData(results,groupData); //jangi
            
        }
        return wrapper;
    }
    
    //jangi - start
    public static String removeLeadingZeroes(String str) {
        String strPattern = '^0+(?!$)';
        str = str.replaceAll(strPattern, '');
        return str;
    }
    //jangi - ends
    
    public static SpecialInstructionsWrapper fetchSpecInstructionData(List<Special_Instructions__c> specInstLst, ETSBE_SpecialInstructionsController.GroupDetails groupData){ //jangi
        Map<String,String> mapGroupDetailPlatform = new Map<String,String>{
            'AS400' => 'AS400', 'PRIME' => 'PRIME', 'UNET' => 'UNET','CIRRUS' => 'CIRRUS','FACETS' => 'FACETS','PULSE' => 'PULSE','NICE' => 'NICE','COSMOS' => 'COSMOS'};
        
        ETSBE_SpecialInstructions specInstructions = new ETSBE_SpecialInstructions();
        specInstructions.isCDX = false;
        SpecialInstructionsWrapper wrapper = new SpecialInstructionsWrapper(); //jangi
        List<Supplemental_Routing__c> SRResults = new List<Supplemental_Routing__c>();
        String querySR = '';
        Special_Instructions__c specInstRec = new Special_Instructions__c();
        Boolean isPlatform = true;
        //if(isPlatformInstruction){
        system.debug('groupData.platform@@ ' + groupData.platform);

        system.debug('specInstLst@@ ' + specInstLst);
        
        List<Special_Instructions__c> specInsListWithNoPlatformValues = new List<Special_Instructions__c>();
        List<Special_Instructions__c> specInsListWithPlatformValues = new List<Special_Instructions__c>();
        Boolean isGroupDataPlatformBlank;
        
        for(integer i=0; i<specInstLst.size();i++) {
            //if(isPlatform){
            if(String.isBlank(specInstLst[i].Supplemental_Routing__c)) {                                  
                if(String.isNotBlank(groupData.platform)) {
                    isGroupDataPlatformBlank = false;                        
                    if(String.isNotBlank(specInstLst[i].Platform__c)) {                            
                        if(mapGroupDetailPlatform.containsKey(groupData.platform.toUpperCase()) && specInstLst[i].Platform__c.toUpperCase() == groupData.platform.toUpperCase()) {                                
                            isPlatform = false;
                            specInsListWithPlatformValues.add(specInstLst[i]);
                            break;                                
                        } else if(!mapGroupDetailPlatform.containsKey(groupData.platform.toUpperCase())) {
                            isPlatform = false;
                            specInsListWithPlatformValues.add(specInstLst[i]);
                        } 
                    } else {
                        isPlatform = false;
                        specInsListWithNoPlatformValues.add(specInstLst[i]); 
                    }                        
                } else if(String.isBlank(groupData.platform)) {
                    isGroupDataPlatformBlank = true;
                    isPlatform = false;
                    if(String.isBlank(specInstLst[i].Platform__c)) {
                        specInsListWithNoPlatformValues.add(specInstLst[i]);
                    } else {
                        specInsListWithPlatformValues.add(specInstLst[i]);
                    }                        
                }
            }
            //}
        }
        System.debug('isPlatform-'+isPlatform);
        System.debug('specInsListWithNoPlatformValues-'+specInsListWithNoPlatformValues);
        System.debug('specInsListWithPlatformValues-'+specInsListWithPlatformValues);
        if(isPlatform == false) {
            
            if(isGroupDataPlatformBlank) {
                if(specInsListWithNoPlatformValues != null && specInsListWithNoPlatformValues.size() > 0) {
                    specInstructions.urlEmail = specInsListWithNoPlatformValues[0].URL_Email__c;
                    specInstRec = specInsListWithNoPlatformValues[0];
		    specInstructions.departmentdesc = specInsListWithNoPlatformValues[0].department__c;
                } else if(specInsListWithPlatformValues != null && specInsListWithPlatformValues.size() > 0) {
                    specInstructions.urlEmail = specInsListWithPlatformValues[0].URL_Email__c;
		    specInstructions.departmentdesc = specInsListWithPlatformValues[0].department__c;
                    specInstRec = specInsListWithPlatformValues[0];
                }                
            } else {
                if(specInsListWithPlatformValues != null && specInsListWithPlatformValues.size() > 0) {
                    specInstructions.urlEmail = specInsListWithPlatformValues[0].URL_Email__c;
                    specInstructions.departmentdesc = specInsListWithPlatformValues[0].department__c;
		    specInstRec = specInsListWithPlatformValues[0];
                } else if(specInsListWithNoPlatformValues != null && specInsListWithNoPlatformValues.size() > 0) {
                    specInstructions.urlEmail = specInsListWithNoPlatformValues[0].URL_Email__c;
                    specInstructions.departmentdesc = specInsListWithNoPlatformValues[0].department__c;
		    specInstRec = specInsListWithNoPlatformValues[0];
                }
            }            
        }
		
        
        if(isPlatform){
            if(specInstLst.size() > 0){
                specInstRec = specInstLst[0];
            }
            if(specInstRec.Supplemental_Routing__c == 'Policy' && groupData.policyNumber != null && groupData.platform != null){
                querySR = 'SELECT Policy_Category_Desc__c, Policy_Number__c,Routing_Partner__c, Platform_Desc__c,Routing_Partner_ID__c,Id,Priority_CD__c FROM Supplemental_Routing__c ' + 
                    'WHERE Policy_Category_Desc__c = \''+ specInstRec.Supplemental_Routing_Ref__c + 
                    '\' AND Policy_Number__c = \'' + removeLeadingZeroes(groupData.policyNumber) + 
                    '\' AND Platform_Desc__c = \'' + groupData.platform +'\'';
                System.debug(loggingLevel.INFO,'Policy QUERY: ' + querySR);
                SRResults = Database.query(querySR);
                if(SRResults.size() > 0){
                    specInstructions.isCDX = false;
                    
                    specInstructions.urlEmail = (SRResults[0].Routing_Partner_ID__c != null)?SRResults[0].Routing_Partner_ID__c:'';
                    specInstructions.departmentDesc = (SRResults[0].Routing_Partner__c != null)?SRResults[0].Routing_Partner__c:'';
                }
                
            }else if(specInstRec.Supplemental_Routing__c == 'ETS'){
                
                querySR = 'SELECT Policy_Category_Desc__c, Policy_Number__c, Platform_Desc__c,Routing_Partner_ID__c,Routing_Rule_Category_Desc__c,Routing_Partner__c,Property_Txt__c,Val_Txt__c, Id,Priority_CD__c FROM Supplemental_Routing__c ' + 
                    'WHERE Routing_Rule_Category_Desc__c = \''+ specInstRec.Supplemental_Routing_Ref__c + '\'';
                System.debug(loggingLevel.INFO,'Routing QUERY: ' + querySR);
                SRResults = Database.query(querySR);
                if(SRResults.size() > 0){
                    
                    List<Supplemental_Routing__c> routingPriorityLst = new List<Supplemental_Routing__c>();
                    Supplemental_Routing__c routingObj = new Supplemental_Routing__c();
                    for(Integer i=0; i<SRResults.size();i++){
                        
                        if((SRResults[i].Property_Txt__c != null && SRResults[i].Property_Txt__c == 'Issue.CustomerSitus')){
                            System.debug(loggingLevel.INFO, 'SRResults[i].Val_Txt__c@@@ ' + SRResults[i].Val_Txt__c);
                            if(SRResults[i].Val_Txt__c != null){
                                
                                if(SRResults[i].Val_Txt__c.contains('|')){
                                    String[]  strTemp = new List<String>();
                                    System.debug(loggingLevel.INFO, ' @@SRResults[i].Val_Txt__c@@ ' + SRResults[i].Val_Txt__c);
                                    strTemp = (SRResults[i].Val_Txt__c).split('\\|');
                                    
                                    if(strTemp.size() > 0){
                                        for(String str : strTemp){
                                            if(str == groupData.situsState){
                                                routingObj = SRResults[i];
                                                routingPriorityLst.add(SRResults[i]);
                                                System.debug(loggingLevel.INFO, ' @@SRResults[i]>>>> ' + SRResults[i]);
                                            }
                                        }
                                    }
                                }else{
                                    if(SRResults[i].Val_Txt__c == groupData.situsState){
                                        routingObj = SRResults[i];
                                        routingPriorityLst.add(SRResults[i]);
                                    }
                                }
                            }
                        }
                        if((SRResults[i].Property_Txt__c != null && SRResults[i].Property_Txt__c == 'Issue.GroupRegionID')){
                            System.debug(loggingLevel.INFO, 'SRResults[i].Val_Txt__c@@@ ' + SRResults[i].Val_Txt__c);
                            if(SRResults[i].Val_Txt__c != null){
                                if(SRResults[i].Val_Txt__c.contains('|')){
                                    List<String> strTemp = new List<String>();
                                    strTemp = SRResults[i].Val_Txt__c.split('\\|');
                                    if(strTemp.size() > 0){
                                        for(String str : strTemp){
                                            if(groupData.region != null && str == groupData.region.trim()){
                                                routingObj = SRResults[i];
                                                routingPriorityLst.add(SRResults[i]);
                                            }
                                        }
                                    }
                                }else{
                                    if(groupData.region != null && SRResults[i].Val_Txt__c == groupData.region.trim()){
                                        routingObj = SRResults[i];
                                        routingPriorityLst.add(SRResults[i]);
                                    }
                                }
                            }
                        }
                        if((SRResults[i].Property_Txt__c != null && SRResults[i].Property_Txt__c == 'Event.AgencyName')){
                            System.debug(loggingLevel.INFO, 'SRResults[i].Val_Txt__c@@@ ' + SRResults[i].Val_Txt__c);
                            if(SRResults[i].Val_Txt__c != null && SRResults[i].Val_Txt__c == groupData.AgencyBrokerName){
                                routingObj = SRResults[i];
                                routingPriorityLst.add(SRResults[i]);
                            }
                        }
                    }
                    
                    System.debug(loggingLevel.INFO, 'routingPriorityLst@@@ ' + routingPriorityLst);
                    if(routingPriorityLst.size() > 0){
                        if(routingPriorityLst.size() == 1){
                            specInstructions.departmentDesc = (routingPriorityLst[0].Routing_Partner__c != null)?routingPriorityLst[0].Routing_Partner__c:'';
                            specInstructions.urlEmail = (routingPriorityLst[0].Routing_Partner_ID__c != null)?routingPriorityLst[0].Routing_Partner_ID__c:'';
                        }else{
                            List<string>prioritys = new List<string>();
                            for(Integer i=0; i< routingPriorityLst.size();i++){
                                prioritys.add(routingPriorityLst[i].Priority_CD__c);
                                
                            }
                            prioritys.sort();
                            
                            string leastvalue='';
                            if(prioritys.size()>0)
                            leastvalue = prioritys[0];
                            system.debug(',,,,,,leastvalue,,,,,,,,,,,,'+leastvalue);
                            for(Integer i=0; i< routingPriorityLst.size();i++){
                                if(routingPriorityLst[i].Priority_CD__c != null && Integer.valueOf(routingPriorityLst[i].Priority_CD__c) == Integer.valueOf(leastvalue)){
                                      system.debug(',,,,,,foundroutingrecord,,,,,,,,,,,,'+routingPriorityLst[i].Id);
                                     specInstructions.urlEmail = (routingPriorityLst[i].Routing_Partner_ID__c != null)?routingPriorityLst[i].Routing_Partner_ID__c:'';
                                    if(routingPriorityLst[i].Routing_Partner__c != null) 
                                    specInstructions.departmentDesc = (routingPriorityLst[i].Routing_Partner__c != null)?routingPriorityLst[i].Routing_Partner__c:'';
                                }
                            }
                        }
                    }
                    
                    specInstructions.isCDX = false;
                }
            }else if(specInstRec.Supplemental_Routing__c == 'IMD'){      //US3155396:Change
                specInstructions.isCDX = true;
                specInstructions.urlEmail = '';
                specInstructions.departmentDesc = (specInstRec.department__c != null)?specInstRec.department__c:'';
            }else{
                specInstructions.isCDX = false;
                System.debug(loggingLevel.INFO, 'specInstRec.URL_Email__c@@@ ' + specInstRec.URL_Email__c);
                specInstructions.urlEmail = (specInstRec.URL_Email__c != null)?specInstRec.URL_Email__c:'';	
            
                specInstructions.departmentDesc = (specInstRec.department__c != null)?specInstRec.department__c:'';
            }
        }
        if(specInstRec.Supplemental_Routing__c == null){
            specInstructions.departmentDesc = (specInstRec.department__c != null)?specInstRec.department__c:'';
        }
        specInstructions.formLink = (specInstRec.Form_Link__c != null)?specInstRec.Form_Link__c:'';
        specInstructions.directions = (specInstRec.Directions__c != null)?specInstRec.Directions__c:'';
        specInstructions.slaDay = (specInstRec.SLA_Day__c != null)?specInstRec.SLA_Day__c:'';
        specInstructions.routingOptions = (specInstRec.Routing_Option__c != null)?specInstRec.Routing_Option__c:'';
        
        specInstructions.sfId = (specInstRec.Id != null)?specInstRec.Id:'';
        specInstructions.dosRequired = (specInstRec.DOS_Required_Indicator__c != null && specInstRec.DOS_Required_Indicator__c == 'Y')?true:false;
        specInstructions.queueName = (specInstRec.Queue_Name__c != null)?specInstRec.Queue_Name__c:'';
        specInstructions.valOnRoutedAppl = (specInstRec.Validation_on_Routed_Appl__c != null)?specInstRec.Validation_on_Routed_Appl__c:'';
        specInstructions.routingApplDesc = (specInstRec.Routing_Appl_Desc__c != null)?specInstRec.Routing_Appl_Desc__c:'';
        specInstructions.MemberIDRequiredIndicator = (specInstRec.Member_ID_Required_Indicator__c != null)?specInstRec.Member_ID_Required_Indicator__c:'';
        
        //jangi - starts
        System.debug(loggingLevel.INFO, 'groupData.sourceCode@@@ ' + groupData.sourceCode);
        System.debug(loggingLevel.INFO, 'specInstructions.isCDX@@@ ' + specInstructions);
        if(specInstructions != null){
            if(specInstructions.isCDX != null && specInstructions.isCDX && groupData.sourceCode == 'NA'){
                wrapper.internalContact = fetchSourceCodeNA(groupData.policyNumber);
            }
        }
        wrapper.specialInstruction = specInstructions;
        //jangi - ends
        return wrapper;
    }
    
    //jangi - starts
    public static List<InternalContact> fetchSourceCodeNA(string policyNumber){
        List<Merit_Group__c> results = new List<Merit_Group__c>();
        String query = 'Select Policy_Number__c, CM_First_Name__c,CM_Last_Name__c,' + 
            'SCE_First_Name__c,SCE_Last_Name__c FROM Merit_Group__c  WHERE Policy_Number__c = \'' + policyNumber + '\'';
        System.debug('QUERY: ' + query);
        results = Database.query(query);
        System.debug('MERIT Results: ' + results);
        
        
        List<InternalContact>  internalConLst = new List<InternalContact>();
        if(results != null && results.size() > 0){
            for(Merit_Group__c result: results){
                if(String.isNotBlank(result.CM_First_Name__c ) && String.isNotBlank(result.CM_Last_Name__c )){
                    InternalContact contactCM = new InternalContact();
                    contactCM.firstName = String.isNotBlank(result.CM_First_Name__c)? result.CM_First_Name__c : '';
                    contactCM.lastName = String.isNotBlank(result.CM_Last_Name__c)? result.CM_Last_Name__c :'';
                    contactCM.name = result.CM_First_Name__c + ' ' + result.CM_Last_Name__c;
                    contactCM.role = 'Client Manager';
                    internalConLst.add(contactCM);
                }
                
                if(String.isNotBlank(result.SCE_First_Name__c ) && String.isNotBlank(result.SCE_Last_Name__c )){
                    InternalContact contactSCE = new InternalContact();
                    contactSCE.firstName = String.isNotBlank(result.SCE_First_Name__c)? result.SCE_First_Name__c: '';
                    contactSCE.lastName = String.isNotBlank(result.SCE_Last_Name__c)? result.SCE_Last_Name__c : '';
                    contactSCE.name = result.SCE_First_Name__c + ' ' + result.SCE_Last_Name__c;
                    contactSCE.role = 'Strategic Client Executive';
                    internalConLst.add(contactSCE);
                }
            }
        }
        
        
        return internalConLst;
    }
    //jangi - ends
    //
    @AuraEnabled
    public static void submitRootCauseAnalysis(String rootDetailsJson, String caseId){
        List<ETSBE_RootCauseDetails> resultsList = (List<ETSBE_RootCauseDetails>) JSON.deserialize(rootDetailsJson,List<ETSBE_RootCauseDetails>.class);
        system.debug('HERE IS THE JSON: ' + rootDetailsJson);
        system.debug('HERE IS THE resultsList: ' + resultsList);
        system.debug('HERE IS THE CASE ID: ' + caseId);
        List<Case> caseNumber = new List<Case>();
        if(caseId != null && caseId != ''){
            caseNumber = [ SELECT CaseNumber FROM Case WHERE Id =: caseId ];
        }
        
        //remove old root causes 
        List<Root_Cause__c> oldRootCause = new List<Root_Cause__c>();
        if(caseNumber.size() > 0){
	        oldRootCause = [ SELECT Id FROM Root_Cause__c WHERE Issue_ID__c =: caseNumber[0].CaseNumber ];
	        System.debug('OLD ROOT: ' + oldRootCause);
	        if(oldRootCause.size() > 0){
		        try{
		        	delete oldRootCause;
		        } catch (DmlException e){
		        	system.debug('DML Error: ' + e);
		        }
	        }
        }
        
        Root_Cause__c newRoot = new Root_Cause__c();
        List<Root_Cause__c> newRootList = new List<Root_Cause__c>();
        for(Integer i = 0; i < resultsList.size(); i++){
            newRoot = new Root_Cause__c();
            newRoot.Issue_Category__c = (resultsList[i].issueCategory != null)?resultsList[i].issueCategory:'';
            newRoot.Defect_Type__c = (resultsList[i].defectType != null)?resultsList[i].defectType:'';
            newRoot.Root_Cause_Issue_Category__c = (resultsList[i].rootCauseIssueCategory != null)?resultsList[i].rootCauseIssueCategory:'';
            newRoot.Root_Cause__c = (resultsList[i].rootCause != null)?resultsList[i].rootCause:'';
            newRoot.Brief_Description__c = (resultsList[i].briefDesc != null)?resultsList[i].briefDesc:'';
            string dateFormat = '';
            //DE381934:Change:Starts
            if(resultsList[i].serviceImpactDate!=null){
                if(resultsList[i].serviceImpactDate.split('/').size() == 3){
                dateFormat = resultsList[i].serviceImpactDate;
            } else if(resultsList[i].serviceImpactDate.split('-').size() == 3){
                dateFormat = resultsList[i].serviceImpactDate.split('-')[1] + '/' + resultsList[i].serviceImpactDate.split('-')[2] + '/' + resultsList[i].serviceImpactDate.split('-')[0];
             } 
            }else{
                 newRoot.Service_Impact_Date__c =null;
            }
            //DE381934:Change:Ends
            System.debug('DATE NEW FORMAT: ' + dateFormat);
            if(dateFormat != null && dateFormat != ''){
                newRoot.Service_Impact_Date__c = Date.parse(dateFormat);
            }
            newRoot.Issue_ID__c = (caseNumber.size() > 0 && caseNumber[0].CaseNumber != null)?caseNumber[0].CaseNumber:'';
            newRoot.Case__c = String.isNotBlank(caseId)?caseId:'';
            newRoot.Business_Unit__c = (resultsList[i].businessUnit != null)?resultsList[i].businessUnit:'';
            newRootlist.add(newRoot);
        }
        system.debug('HERE IS THE NEW ROOT CAUSE: ' + newRootList);
        insert newRootList;
    }
    
    //DE385766
    @AuraEnabled
    public static String saveTTSCase(String strRecord, Boolean isProvider,String flowType,String contactID, String eventType,String specialInstructionsDescription,String emailURL,String groupName,String subjectName) {
       
        
        String strCreatedCaseId = '';
        String searchCaseId= '';
        
        try{

            
            Case caseRec=new Case();
            SAETTSCaseWrapper caseWrapper = (SAETTSCaseWrapper)JSON.deserialize(strRecord, SAETTSCaseWrapper.class);
            
            
            
            if(String.isNotBlank(caseWrapper.parentCaseId)){
                
                searchCaseId=caseWrapper.parentCaseId;
            }
       
            if(searchCaseId!=null && String.isNotBlank(searchCaseId)){
                caseRec=[Select id,Group_Name__c,Subject_Name__c from case where id=:searchCaseId limit 1];
                
            }
                       
            //associate record type to BEO
            RecordType recordType = [SELECT Id, Name FROM RecordType WHERE sObjectType='case' AND Name='BEO'];
            User userDetails =[SELECT Id, UserRole.Name FROM User where Id =: UserInfo.getUserId()];
            
            Case caseObj = new Case();
            
            if(caseWrapper.updateCaseId != null && caseWrapper.updateCaseId != ''){
            	caseObj.Id = caseWrapper.updateCaseId;
            }
            caseObj.ContactId = contactID;
            caseObj.Subject_Type__c = flowType;
            
            String strCaseStatus = 'Open';  // US2148602 - Case Creation - Status of Case Open : Removing 2nd condition - 28/10/2019 - Sarma.
            //caseWrapper.specialInstructions = 'a128A0000019FZNQA2';
            if(caseWrapper.AddInfoOrginType.equals('Issue Resolved')){
                strCaseStatus = 'Closed'; 
            }
            
            // US1753077 - Pilot Enhancement - Save Case - Validations and Additional Functionality: Kavinda - START
            // Here need to change Topic Type Based on the change which will be given today's scrumm - 2019/09/30
            if(caseWrapper.AddInfoOrginType.equals('System Unavailable')){
                if(caseWrapper.CaseCreationFrom != NULL && caseWrapper.CaseCreationFrom.equals('Member_Snapshot_Policies') ){
                    if(caseWrapper.PolicyCount != NULL && caseWrapper.PolicyCount == 0){
                        strCaseStatus = 'Open';
                    }
                }
            }
           
            // US1753077 - Pilot Enhancement - Save Case - Validations and Additional Functionality: Kavinda - END
            
	    //US1970508 - Ravindra - start
            // Originator
            //caseObj.Originator_name__c = caseWrapper.OriginatorName;
            //caseObj.Originator_Relationship__c = caseWrapper.OriginatorRelationship;
            //caseObj.Originator_Type__c = caseWrapper.OriginatorType; // Since this is formular field we don't want to manually assign values
            //caseObj.OriginatorPhone__c = caseWrapper.OriginatorPhone;
            //caseObj.OriginatorEmail__c = caseWrapper.OriginatorEmail;
            //caseObj.Caller__c = caseWrapper.OriginatorContactName;
            
            // Subject
            //caseObj.Subject_Name__c = caseWrapper.SubjectName;
            
            if(caseRec.Subject_Name__c!=null){
             caseObj.Subject_Name__c = caseRec.Subject_Name__c;
            
            }else{
                caseObj.Subject_Name__c=subjectName;
            }
            
            if(caseWrapper.noProviderToSearch != null && caseWrapper.noProviderToSearch) {
                if(caseWrapper.noMemberToSearch != null && caseWrapper.noMemberToSearch){
                } else if(caseWrapper.mnf == 'mnf') {
                } else {
                    //caseObj.Originator_name__c = '';
                    caseObj.ID__c = caseWrapper.SubjectId;
                    //caseObj.ContactId = caseWrapper.memberContactId;
                    if(caseWrapper.parentCaseId != '') {
                        caseObj.Subject_Name__c = caseObj.Subject_Name__c;
                    } else {
                        //caseObj.Subject_Name__c = caseWrapper.OriginatorName;   
                    }                    
                    
                }
                /*if(caseWrapper.xRefId != null && caseWrapper.xRefId != ''){
                    caseObj.XRefId__c = caseWrapper.xRefId;
                    caseObj.ContactId = caseWrapper.memberContactId;
                }*/
            } else if(caseWrapper.providerNotFound != null && caseWrapper.providerNotFound) {
                //Provider not found
                // Originator
                caseObj.ContactId = caseWrapper.providerContactId;
                caseObj.TaxID__c = caseWrapper.TaxId;
                if(caseWrapper.noMemberToSearch != null && caseWrapper.noMemberToSearch){
                    caseObj.Subject_Type__c = 'Provider';
                } else if(caseWrapper.mnf == 'mnf') {
                    //caseObj.Subject_Name__c = caseWrapper.SubjectName;
                    if(caseRec.Subject_Name__c!=null)
                    caseObj.Subject_Name__c = caseRec.Subject_Name__c;
                    else
                      caseObj.Subject_Name__c =subjectName;  
                    //caseObj.ContactId = caseWrapper.memberContactId;
                } else {
                    caseObj.ID__c = caseWrapper.SubjectId;
                    //caseObj.ContactId = caseWrapper.memberContactId;
                    //caseObj.XRefId__c = caseWrapper.xRefId;
                }
            } else if(caseWrapper.isOtherSearch != null && caseWrapper.isOtherSearch) {
                if(caseWrapper.noMemberToSearch != null && caseWrapper.noMemberToSearch){
                    caseObj.Subject_Name__c = caseWrapper.OriginatorName;
                } else if(caseWrapper.mnf == 'mnf') {
                    //caseObj.ContactId = caseWrapper.memberContactId;
                    //caseObj.Subject_Name__c = caseWrapper.SubjectName;
                     if(caseRec.Subject_Name__c!=null)
                    caseObj.Subject_Name__c = caseRec.Subject_Name__c;
                    else
                    caseObj.Subject_Name__c =subjectName;     
                } else {
                    //caseObj.ContactId = caseWrapper.memberContactId;
                    caseObj.ID__c = caseWrapper.SubjectId;
                }
            } else {
            	
                if(isProvider){
                    caseObj.Subject_Type__c = 'Provider';
                    caseObj.Subject_Name__c = caseWrapper.OriginatorName;
                }
                // Originator
                //caseObj.ContactId = caseWrapper.providerContactId;
                caseObj.ID__c = caseWrapper.providerId;
                if(caseWrapper.noMemberToSearch != null && caseWrapper.noMemberToSearch){
                    
                    caseObj.ContactId = caseWrapper.providerContactId;
                } else if(caseWrapper.mnf == 'mnf') {
                    
                    if(isProvider){
                        caseObj.ID__c = '';
                        caseObj.ContactId = caseWrapper.providerContactId;
                    } else {
                        //caseObj.ContactId = caseWrapper.memberContactId;
                    }
                } else {
                    
                    //caseObj.ID__c = caseWrapper.SubjectId;
                    if(isProvider){
                        caseObj.ContactId = caseWrapper.providerContactId;
                    } else {
                        caseObj.ID__c = caseWrapper.SubjectId;
                        //caseObj.ContactId = caseWrapper.memberContactId;
                    }
                    //caseObj.XRefId__c = caseWrapper.xRefId;
                }
                // Group/Family ID
                caseObj.TaxID__c = caseWrapper.TaxId;
            }
            
            if(caseWrapper.noMemberToSearch != null && caseWrapper.noMemberToSearch){
                
            } else if(caseWrapper.mnf == 'mnf') {
                //caseObj.Surrogate_Key__c = caseWrapper.SubjectName.remove(' ') + caseWrapper.SubjectDOB.remove('/');
                if(caseRec.Subject_Name__c!=null)
                caseObj.Surrogate_Key__c = caseRec.Subject_Name__c.remove(' ') + caseWrapper.SubjectDOB.remove('/');
                else
                 caseObj.Surrogate_Key__c = subjectName.remove(' ') + caseWrapper.SubjectDOB.remove('/');  
            } else {
                if(!isProvider && flowType == 'Member'){
                    
                   // caseObj.Surrogate_Key__c = caseWrapper.SubjectName.remove(' ') + caseWrapper.SubjectDOB.remove('/') + caseWrapper.SubjectId + caseWrapper.SubjectGroupId;
                   if(caseRec.Subject_Name__c!=null)
                   caseObj.Surrogate_Key__c = caseRec.Subject_Name__c.remove(' ') + caseWrapper.SubjectDOB.remove('/') + caseWrapper.SubjectId + caseWrapper.SubjectGroupId;
                   else
                   caseObj.Surrogate_Key__c = subjectName.remove(' ') + caseWrapper.SubjectDOB.remove('/') + caseWrapper.SubjectId + caseWrapper.SubjectGroupId;     
                }
            }
            
            //US1970508 - Ravindra - end
            if(eventType == 'One & Done'){
            	strCaseStatus = 'Closed';
            } else if(eventType == 'Standard'){
            	strCaseStatus = 'Open';
            }
            caseObj.Status = strCaseStatus;
            
            Interaction__c interaction = (Interaction__c) Database.query('SELECT Id, Interaction_Type__c, Name, Originator_Name__c, Originator_Phone__c, Originator_Email__c, Customer_Admin_Type__c, Reward_Account_Number__c, Franchise_Code__c, Contact_Name__c FROM Interaction__c WHERE Id = \'' + caseWrapper.Interaction + '\'');
            
            /*caseObj.Originator_name__c = (interaction.Originator_Name__c != null)?interaction.Originator_Name__c:'';
caseObj.OriginatorPhone__c = (interaction.Originator_Phone__c != null)?interaction.Originator_Phone__c:'';
caseObj.OriginatorEmail__c = (interaction.Originator_Email__c != null)?interaction.Originator_Email__c:'';*/
            //As per the User Story US2422958, the Originator Relationship should be mapped to Other Admin Type value of Customer Admin. Hence the The below line is commented.
            //caseObj.Originator_Relationship__c = (interaction.Customer_Admin_Type__c != null)?interaction.Customer_Admin_Type__c:'';
            // US2422958 -> Case - Originator Section - Populate the Fields for 'Other Admin' - Yogitha
            caseObj.Originator_Relationship__c = (caseWrapper.otherAdminType != '') ? caseWrapper.otherAdminType : null;
            caseObj.Reward_Account_Number__c = (interaction.Reward_Account_Number__c != null)?interaction.Reward_Account_Number__c:'';
            caseObj.Franchise_Code__c = (interaction.Franchise_Code__c != null)?interaction.Franchise_Code__c:'';
            
            caseObj.Caller__c = (interaction.Contact_Name__c != null)?interaction.Contact_Name__c:'';
            caseObj.Interaction__c = caseWrapper.Interaction != '' ?  caseWrapper.Interaction : null;
            caseObj.Business_Direction__c = caseWrapper.specialInstructions != ''?caseWrapper.specialInstructions:null;
            caseObj.Special_Instructions_Business_Unit__c = caseWrapper.specialInstructionsBusinessUnit != ''?caseWrapper.specialInstructionsBusinessUnit:null;
            caseObj.Issue_Category_Desc__c = caseWrapper.issueCategoryDesc != ''?caseWrapper.issueCategoryDesc:null;
            caseObj.Task_Category_Type_Desc__c = caseWrapper.taskCategoryTypeDesc != ''?caseWrapper.taskCategoryTypeDesc:null;
            caseObj.Funding_Type__c  = caseWrapper.groupFundingType != 'None'?caseWrapper.groupFundingType:null;
            caseObj.Task_Category_Subtype_Desc__c = caseWrapper.taskCategorySubtypeDesc != ''?caseWrapper.taskCategorySubtypeDesc:null;
            caseObj.Special_Instructions_Subject__c = caseWrapper.specialInstructionsSubject != ''?caseWrapper.specialInstructionsSubject:null;
            caseObj.Special_Instructions_Description__c = specialInstructionsDescription != ''?specialInstructionsDescription:null;
            caseObj.Special_Instructions_Reference_ID__c = caseWrapper.specialInstructionsReferenceID != ''?caseWrapper.specialInstructionsReferenceID:null;
            
            
            /*if(eventType == true){
caseObj.Event_Type__c = 'One & Done';	
} else {
caseObj.Event_Type__c = 'Standard';
}*/
            caseObj.Event_Type__c = eventType;
            
            
            if(caseWrapper.specialInstructionsQueue != null && caseWrapper.specialInstructionsQueue != ''){
                List<Group> queueList = [SELECT Id FROM Group WHERE Type='Queue' AND Name =: caseWrapper.specialInstructionsQueue];
                
                if (queueList != null && queueList.size() > 0) {
                    //caseObj.OwnerId = queueList[0].Id;
                    caseObj.Queue_Id__c = queueList[0].Id;
                }
            }
            String dosStr = '';
            if(caseWrapper.specialInstructionsDateOfService != null && caseWrapper.specialInstructionsDateOfService != ''){
                dosStr = caseWrapper.specialInstructionsDateOfService;
                if(dosStr.contains(',')){
                    dosStr = dosStr.replace(',',',\n');
                }
            } else if(caseWrapper.dosVal != '') {
                dosStr = caseWrapper.dosVal;
            }
            caseObj.Date_of_Service__c = (dosStr != null)?dosStr:'';
            //Workflow fix - Sarma - 08/11/2019
            
            //caseObj.Status = caseWrapper.Status;        
            caseObj.RecordTypeId = recordType.Id;
            //US1970508 - Ravindra - start
            
            //US1970508 - Ravindra - end
            caseObj.Broker_Name__c = (caseWrapper.brokerName != null)?caseWrapper.brokerName:'';
            caseObj.Broker_ID__c = (caseWrapper.brokerId != null)?caseWrapper.brokerId:'';
            // US2265872 - Group Data Elements to be saved to a Case START - Yogitha
            
            //caseObj.Group_Name__c = caseWrapper.groupName != '' ? caseWrapper.groupName : null;
            if(caseRec.Group_Name__c!=null) {
               caseObj.Group_Name__c = caseRec.Group_Name__c;
            }
            else{
              caseObj.Group_Name__c=groupName;  
            }
            //caseObj.Group_Name__c = caseRec.Group_Name__c != '' ? caseRec.Group_Name__c : null; 
            caseObj.Group_ID__c = caseWrapper.groupId != '' ? caseWrapper.groupId : null;
            caseObj.Policy_Year__c = caseWrapper.groupPolicyYear != '' ? caseWrapper.groupPolicyYear : null;             
            caseObj.Funding_Type__c = caseWrapper.groupFundingType != '' ? caseWrapper.groupFundingType : null;
            caseObj.Platform__c = caseWrapper.groupPlatform != '' ? caseWrapper.groupPlatform : null;
            caseObj.Line_of_Business__c = caseWrapper.groupLineOfBusiness != '' ? caseWrapper.groupLineOfBusiness : null;
            caseObj.Region__c = caseWrapper.groupRegion != '' ? caseWrapper.groupRegion : null;
            caseObj.Sales_Office__c = caseWrapper.groupSalesOffice != '' ? caseWrapper.groupSalesOffice : null;
            caseObj.Health_Plan_Major__c = caseWrapper.groupHelathPlanMajor != '' ? caseWrapper.groupHelathPlanMajor : null;
            caseObj.Health_Plan_Minor__c = caseWrapper.groupHelathPlanMinor != '' ? caseWrapper.groupHelathPlanMinor : null;
            caseObj.Policy__c = caseWrapper.groupPolicy != '' ? caseWrapper.groupPolicy : null;
            caseObj.Group_Solaris_ID__c = (caseWrapper.groupSolarisId != null)?caseWrapper.groupSolarisId:'';
			caseObj.SourceCode__c  = (caseWrapper.groupSourceCode != null)?caseWrapper.groupSourceCode:''; //jangi
            String groupPolicyRenwyear = caseWrapper.groupPolicyRenewalYear != null ? caseWrapper.groupPolicyRenewalYear : '';
            
            String dateFormat = '';
            if(groupPolicyRenwyear.split('/').size() == 3){
                dateFormat = groupPolicyRenwyear;
            } else if(groupPolicyRenwyear.split('-').size() == 3){
                dateFormat = groupPolicyRenwyear.split('-')[1] + '/' + groupPolicyRenwyear.split('-')[2] + '/' + groupPolicyRenwyear.split('-')[0];
            }
            
            if(dateFormat != null && dateFormat != '') {
                caseObj.Policy_Renewal_Year__c = Date.parse(dateFormat);
            }
            
            caseObj.Situs__c = caseWrapper.SubjectSitus != '' ? caseWrapper.SubjectSitus : null;
            //caseObj.Member_SSN__c = caseWrapper.SubjectMemberSSN != '' ? caseWrapper.SubjectMemberSSN : null;
            
            // US2265872 - Group Data Elements to be saved to a Case END - Yogitha
            
            // US2412544 -> Case - 'SLA' - Populate the Field 
            caseObj.SLA__c = caseWrapper.slaDay;
            
            // US2439068 -> Case - Change Email to 'Email/URL' & Populate - Yogitha            
            //caseObj.Email__c = caseWrapper.emailURL;
            caseObj.Email__c = emailURL;
            
            // Follow Up Date Calculation START - Yogitha
            
            Date cuurentDate = System.Today();
            Decimal slaDay = caseWrapper.slaDay;
            Integer slaDayVal = 0;            
            if(slaDay != null) {
                slaDayVal = slaDay.intValue();
            }
            
            // Get the default business hours
            BusinessHours businessHoursObj = [SELECT Id FROM BusinessHours WHERE Name='ETS-BE/BEO' AND IsActive=true];
            
            /* List of Dates to be considered by excluding the Weekend & Holidays */
            List<Date> listOfDatesToConsider = new List<Date>();
            
            for(Integer i=0; i<slaDayVal; i++){
                Date currDate = cuurentDate.addDays(i);
                DateTime curDateAndTime = DateTime.newInstance(currDate.year(), currDate.month(), currDate.day());
                Boolean isBusinessDay = BusinessHours.isWithin(businessHoursObj.id, curDateAndTime);
                if(isBusinessDay) {
                    listOfDatesToConsider.add(currDate);
                } else {
                    slaDayVal = slaDayVal+1;
                }
            }  
            
            
            if(listOfDatesToConsider != null && listOfDatesToConsider.size() > 0) {
                System.debug(listOfDatesToConsider[listOfDatesToConsider.size()-1]);
                Date followUpDate = listOfDatesToConsider[listOfDatesToConsider.size()-1]; 
                caseObj.Follow_Up_Date__c = DateTime.newInstance(followUpDate, DateTime.now().time());
            }            
            
            
            // Follow Up Date Calculation END - Yogitha
                         
            // US2469951 - TECH: Case Type field - populated
            caseObj.Case_Type__c = 'BEO Case';
            
            caseObj.Department__c = caseWrapper.department;
            
            // US2474077 -> TECH: Claims Complex and Dedicated Eligibility Child Case
            if(caseWrapper.parentCaseId != '' && !caseWrapper.isCloned) {
                caseObj.ParentId = caseWrapper.parentCaseId;  
            }
            caseObj.Onshore_Restriction__c = 'No';
            caseObj.UHG_Restriction__c = (caseWrapper.uhgRestriction != null && caseWrapper.uhgRestriction == 'Yes')?'Yes':'No';
            
            // US2488115 -> Member Relationship Saved to the Case - Yogitha
            caseObj.Member_Relationship__c = caseWrapper.memberRelationship;
            
            // US2534146 -> Case - 'Clone Case' - Button and Functionality - Yogitha
            caseObj.Is_Cloned__c = caseWrapper.isCloned;
            
            // 
            // US1974034 - Thanish (23rd Aug 2019) - to show subject DOB in MM/DD/YYYY format
            //Adding null check - 23/10/2019 - Sarma
            
            if(caseWrapper.SubjectDOB != null){
                if(caseWrapper.SubjectDOB.contains('/')) {
                    caseObj.DOB__c = caseWrapper.SubjectDOB;
                } else {
                    caseObj.DOB__c =  SAEUtils.formatDate(caseWrapper.SubjectDOB);
                }
            }
            if(isProvider){
                caseObj.Subject_Group_ID__c = '';
            }else{
                caseObj.Subject_Group_ID__c = caseWrapper.SubjectGroupId;
            }
            
            // Additional Information
            //keep this code

            caseObj.Topic__c = caseWrapper.AddInfoTopic;
            caseObj.Type__c = caseWrapper.ttsType;
            caseObj.Subtype__c = caseWrapper.ttsSubType;
            
            caseObj.Original_Type__c = caseWrapper.AddInfoOrginType;
            caseObj.Original_Subtype__c = caseWrapper.AddInfoOrginSubType;
            
            caseObj.Created_By_Role__c = userDetails.UserRole.Name;

            // US2091974 - Sanka - Case Creation
            caseObj.TaxID__c = caseWrapper.TaxId;

            upsert caseObj;
            
            strCreatedCaseId = caseObj.Id;
            Case caseObjTest = [Select Id,Target_Date__c,ParentId from Case where Id=:strCreatedCaseId];
           
            //US2038277 - Autodoc Integration - Sanka
            if(!String.isEmpty(caseWrapper.AutoDoc)){
                //addFilesToCase(caseObj.Id , caseWrapper.AutoDoc);                
            }
            
            // US2119574 - Thanish - 26th Nov 2019 - Added external IDf or empty caseItemsInfo
            String extID = ' ';
            if(!String.isEmpty(caseWrapper.TaxId)){
                extID = caseWrapper.TaxId;
            }
            
            
            // US2474077 -> TECH: Claims Complex and Dedicated Eligibility Child Case
            if(caseWrapper.parentCaseId != '' && (caseWrapper.isCloned == null || caseWrapper.isCloned == false)) {               
                insertAttachmentsAndCaseCommentstoChildCase(caseWrapper.parentCaseId, strCreatedCaseId);
            }
            
             //Update interactions:US2580332
            if(caseObj!=null){
               ETSBE_OneClickController.populateEvntTypeBusinessUnit(caseObj.id);
            }
            //addCaseItems(caseObj.Id, caseWrapper.AutoDocCaseItems,caseWrapper.ttsType,caseWrapper.ttsSubType, extID);
            //End
            
            
        }
        catch(Exception e) {
            System.debug('CREATE CASE16: BAD THINGS');
            System.debug(LoggingLevel.ERROR,'####ERROR:'+e.getMessage());
            System.debug(LoggingLevel.ERROR,'####ERROR LINE:'+e.getLineNumber());
        }
        
        return strCreatedCaseId;
        
    }
    
    @AuraEnabled
    public static Interaction__c getInteractionDetails(String intId){
        Interaction__c intRecord = [Select Id, Name, Business_Unit__c, Evt_Recvd_Dt_Time__c, Interaction_Type__c, Current_Status__c,Originator_SFID__c, Originator_Name__c, Originator_Type__c, Originator_Phone__c, Originator_Email__c, Resolution_Date__c From Interaction__c where Id =: intId];
        return intRecord;
    }
    //DE386094 Clone Case component Error
    @AuraEnabled
    Public static CaseWrapper getcloneCaseDetails(String caseId, String caseTypeVal){
        Case caseObj;
        CaseWrapper wrapper = new CaseWrapper();
        
        caseTypeVal = (caseTypeVal != null) ? caseTypeVal : '';
        caseObj = [Select Id, Status, ContactId, SourceCode__c ,Member_Relationship__c,Related_Cases__c,Relationship__c, Event_Type__c, Interaction__r.Id, Situs_State__c,
                   Interaction__r.Current_Status__c, Interaction__r.Originator_SFID__c, 
                   Interaction__r.Resolution_Date__c, Interaction__r.Interaction_Type__c,
                   Interaction__r.Name, Interaction__r.Originator_Name__c, Originator_name__c, OriginatorPhone__c,
                   Originator_Relationship__c, OriginatorEmail__c, Originator_Type__c, Caller__c,
                   Reward_Account_Number__c, Franchise_Code__c, Subject_Name__c, Subject_Type__c, Date_of_Service__c,
                   Group_Name__c, Line_of_Business__c, Assigned_Broker__c, Region__c,UHG_Restriction__c, 
                   Sales_Office__c, Health_Plan_Major__c, Health_Plan_Minor__c, Member_SSN__c, DOB__c, Policy_Year__c,
                   Situs__c, ID__c, Subject_Group_ID__c, Funding_Type__c, Platform__c, Policy__c, Policy_Renewal_Year__c,
                   Broker_Name__c,Broker_ID__c from Case where Id =: caseId];
        wrapper.caseObj = caseObj;
        String renewalDate;
        ETSBE_SolarisGroupDetailResult  newResult = new ETSBE_SolarisGroupDetailResult();
         newResult.groupName = (caseObj.Group_Name__c != null)?caseObj.Group_Name__c:'';
                newResult.groupId =  (caseObj.Subject_Group_ID__c != null)?caseObj.Subject_Group_ID__c:'';
                newResult.renewalEffectiveDate = '';
                if(caseObj.Policy_Renewal_Year__c != null){
                     renewalDate = caseObj.Policy_Renewal_Year__c.format();
                    System.debug('RENEWAL DATE: ' + renewalDate);
                    newResult.renewalEffectiveDate = renewalDate;   
                }
                newResult.policyNumber = (caseObj.Policy__c != null)?caseObj.Policy__c:'';
                newResult.situsState = (caseObj.Situs_State__c != null)?caseObj.Situs_State__c:'';
                newResult.fundingType = (caseObj.Funding_Type__c != null)?caseObj.Funding_Type__c:'';
                newResult.lineOfBusiness = (caseObj.Line_of_Business__c != null)?caseObj.Line_of_Business__c:'';
                newResult.salesOffice = (caseObj.Sales_Office__c != null)?caseObj.Sales_Office__c:'';
        newResult.businessMajorMarket = (caseObj.Health_Plan_Major__c != null)?caseObj.Health_Plan_Major__c:'';
        if(newResult.businessMajorMarket.contains('Major')){
                    newResult.businessMajorMarket = newResult.businessMajorMarket.remove('Major');
                } else if(newResult.businessMajorMarket.contains('major')){
                    newResult.businessMajorMarket = newResult.businessMajorMarket.remove('major');
                } else if(newResult.businessMajorMarket.contains('MAJOR')){
                    newResult.businessMajorMarket = newResult.businessMajorMarket.remove('MAJOR');
                }
                newResult.businessMinorMarket = (caseObj.Health_Plan_Minor__c != null)?caseObj.Health_Plan_Minor__c:'';
                if(newResult.businessMinorMarket.contains('Minor')){
                    newResult.businessMinorMarket = newResult.businessMinorMarket.remove('Minor');
                } else if(newResult.businessMinorMarket.contains('minor')){
                    newResult.businessMinorMarket = newResult.businessMinorMarket.remove('minor');
                } else if(newResult.businessMinorMarket.contains('MINOR')){
                    newResult.businessMinorMarket = newResult.businessMinorMarket.remove('MINOR');
                }
                newResult.businessMarketRegion = (caseObj.Region__c != null)?caseObj.Region__c:'';
                if(newResult.businessMarketRegion.contains('Region')){
                    newResult.businessMarketRegion = newResult.businessMarketRegion.remove('Region');
                } else if(newResult.businessMarketRegion.contains('region')){
                    newResult.businessMarketRegion = newResult.businessMarketRegion.remove('region');
                } else if(newResult.businessMarketRegion.contains('REGION')){
                    newResult.businessMarketRegion = newResult.businessMarketRegion.remove('REGION');
                }
                newResult.platform = (caseObj.Platform__c != null)?caseObj.Platform__c:'';
                newResult.brokerName = (caseObj.Assigned_Broker__c != null)?caseObj.Assigned_Broker__c:'';
                newResult.sourceCode = caseObj.SourceCode__c ;
        		newResult.contacts = new List<ETSBE_SolarisGroupDetailResult.Contact>();
        wrapper.groupData =newResult;
         List<InternalContact>  internalConLst = new List<InternalContact>();
        if(String.isNotBlank(caseObj.SourceCode__c ) && caseObj.SourceCode__c == 'NA'){
            internalConLst = fetchSourceCodeNA(caseObj.Policy__c );
            wrapper.internalContact = internalConLst;
        }
        return wrapper;
    }
    @AuraEnabled
    public static CaseWrapper getCaseDetails(String caseId, String caseTypeVal) {
        
        Case caseObj;
        CaseWrapper wrapper = new CaseWrapper();
        
        caseTypeVal = (caseTypeVal != null) ? caseTypeVal : '';
        if(caseTypeVal == 'ChildCase' || caseTypeVal == 'CloneCase') {
            //jangi
            caseObj = [Select Id, Status,Origin ,ContactId, SourceCode__c , Event_Type__c, Interaction__r.Id, Interaction__r.Current_Status__c, Interaction__r.Originator_SFID__c, Interaction__r.Resolution_Date__c, Interaction__r.Interaction_Type__c, Interaction__r.Name, Interaction__r.Originator_Name__c, Originator_name__c, OriginatorPhone__c, Originator_Relationship__c, OriginatorEmail__c, Originator_Type__c, Caller__c, Reward_Account_Number__c, Franchise_Code__c, Subject_Name__c, Subject_Type__c, Date_of_Service__c, Group_Name__c, Line_of_Business__c, Assigned_Broker__c, Region__c,UHG_Restriction__c, Sales_Office__c, Health_Plan_Major__c, Health_Plan_Minor__c, Member_SSN__c, DOB__c, Policy_Year__c, Situs__c, ID__c, Subject_Group_ID__c, Funding_Type__c, Platform__c, Policy__c, Policy_Renewal_Year__c,Broker_Name__c,Broker_ID__c from Case where Id =: caseId]; 
            
        } else {
            //jangi
            caseObj = [Select Id, Interaction__r.Id, Origin,SourceCode__c , Interaction__r.Current_Status__c, Interaction__r.Originator_SFID__c, Interaction__r.Resolution_Date__c, Interaction__r.Interaction_Type__c, Interaction__r.Name, Event_Type__c, Status, Special_Instructions_Business_Unit__c, Issue_Category_Desc__c, Special_Instructions_Description__c,Subject_Group_ID__c, Subject_Name__c,Policy__c,Group_Name__c,ID__c,Broker_ID__c,Event_Received_Date_Time__c,Originator_name__c,OriginatorPhone__c,Originator_Type__c,OriginatorEmail__c,Subject_Type__c, UHG_Restriction__c,Platform__c,Situs__c,Region__c,Line_of_Business__c from Case where Id =: caseId];
            
        }      
        
        wrapper.caseObj = caseObj;
        System.debug('caseObj@@ ' + caseObj);
        //jangi - starts
        List<InternalContact>  internalConLst = new List<InternalContact>();
        if(String.isNotBlank(caseObj.SourceCode__c ) && caseObj.SourceCode__c == 'NA'){
            internalConLst = fetchSourceCodeNA(caseObj.Policy__c );
            wrapper.internalContact = internalConLst;
        }else{
            ETSBE_GetSolarisWebservice groupSearchWS = new ETSBE_GetSolarisWebservice();
            System.debug('caseObj.Policy__c@@ ' + caseObj.Policy__c);
            ACETWSCalloutResult CalloutResult = groupSearchWS.findGroupContact(caseObj.Policy__c);
            List<ETSBE_SolarisGroupDetailResult> rslLst = new List<ETSBE_SolarisGroupDetailResult>();
            if(CalloutResult.Success != null && CalloutResult.Success){
                List<ETSBE_SolarisGroupDetailResult> resultWrapper = (List<ETSBE_SolarisGroupDetailResult>)CalloutResult.Response;
                
                System.debug('resultWrapper@@ ' + resultWrapper);
                for(integer i= 0; i < resultWrapper.size();i++){
                    System.debug(Logginglevel.INFO, 'caseObj.Subject_Name__c@@ ' + caseObj.Subject_Name__c + ' @@resultWrapper[i].groupName@@ ' + resultWrapper[i].groupName);
                    System.debug(Logginglevel.INFO, 'caseObj.Subject_Group_ID__c@@ ' + caseObj.Subject_Group_ID__c + ' @@resultWrapper[i].groupId@@ ' + resultWrapper[i].groupId);
                    System.debug(Logginglevel.INFO, 'caseObj.Policy__c@@ ' + caseObj.Policy__c + ' @@resultWrapper[i].policyNumber@@ ' + resultWrapper[i].policyNumber);
                    if((caseObj.Group_Name__c == resultWrapper[i].groupName) && (caseObj.Subject_Group_ID__c == resultWrapper[i].groupId) && 
                       (caseObj.Policy__c == resultWrapper[i].policyNumber)){
                           System.debug(Logginglevel.INFO, '@@Condition statisfy ' + resultWrapper[i].groupTeamMembers);
                           wrapper.groupData = resultWrapper[i];
                       }                   
                }
                
            }
        }
         //jangi - ends       
        System.debug(Logginglevel.INFO, 'wrapper.internalContact@@ ' + wrapper.internalContact);
        return wrapper;
        
    }
    public class CaseWrapper {
        @AuraEnabled public Case caseObj {get;set;}
        @AuraEnabled public ETSBE_SolarisGroupDetailResult groupData {get;set;}
        @AuraEnabled public List<InternalContact> internalContact {get;set;}
    }
    
    public static void insertAttachmentsAndCaseCommentstoChildCase(String parentCaseId, String childCaseId) {
        
        /* Copy the Case Comments from the Parent Case to the Child Case. */
        
        List<CaseComment> caseCommentsList = [SELECT Id, CommentBody, IsPublished FROM CaseComment where ParentId =: parentCaseId];
        List<CaseComment> caseCommentsListToBeInserted = new List<CaseComment>();
        System.debug('caseCommentsList-'+caseCommentsList);
        if(caseCommentsList != null && caseCommentsList.size() > 0) {
            
            for(CaseComment caseComData : caseCommentsList) {
                CaseComment caseCommObj = new CaseComment();
                caseCommObj.CommentBody = caseComData.CommentBody;
                caseCommObj.IsPublished = caseComData.IsPublished;
                caseCommObj.ParentId = childCaseId;
                caseCommentsListToBeInserted.add(caseCommObj);
            }            
        } 
        System.debug('caseCommentsListToBeInserted-'+caseCommentsListToBeInserted);
        if(caseCommentsListToBeInserted != null && caseCommentsListToBeInserted.size() > 0) {
            insert caseCommentsListToBeInserted;
        }
        
        
        /* Copy the Attachements from the Parent Case to the Child Case. */
        List<ContentDocumentLink> cdLinksList = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: parentCaseId];
        List<Id> cdLinkIds = new List<Id>();
        if(cdLinksList != null && cdLinksList.size() > 0) {    
            for(ContentDocumentLink cdLink : cdLinksList) {
                cdLinkIds.add(cdLink.ContentDocumentId);
            }    
        }
        List<ContentVersion> cvList = [Select title,PathOnClient,VersionData from ContentVersion where ContentDocumentId =: cdLinkIds];
        List<ContentVersion> cvListToBeInserted = new List<ContentVersion>();
        if(cvList != null && cvList.size() > 0) {    
            for(ContentVersion cv : cvList) {
                ContentVersion cvNewData = new ContentVersion();
                cvNewData.title = cv.title;      
                cvNewData.PathOnClient = cv.PathOnClient;           
                cvNewData.VersionData = cv.VersionData;
                cvListToBeInserted.add(cvNewData);
            }
            insert cvListToBeInserted;
        }
        List<Id> cvIdsList = new List<Id>();
        if(cvListToBeInserted != null && cvListToBeInserted.size() > 0) {    
            for(ContentVersion cv : cvListToBeInserted) {
                cvIdsList.add(cv.Id);
            }    
        }
        List<ContentVersion> newCVList = [Select ContentDocumentId from ContentVersion where Id =: cvIdsList];
        List<Id> newCVContentDocIds = new List<Id>();
        if(newCVList != null && newCVList.size() > 0) {
            for(ContentVersion cv : newCVList) {
                newCVContentDocIds.add(cv.ContentDocumentId); 
            }
        }
        if(newCVContentDocIds != null && newCVContentDocIds.size() > 0) {
            List<ContentDocumentLink> newCDList = new List<ContentDocumentLink>();
            for(Id cvContentDocId : newCVContentDocIds) {
                ContentDocumentLink cdLinkNewData = new ContentDocumentLink();
                cdLinkNewData.LinkedEntityId = childCaseId;
                cdLinkNewData.ShareType = 'V';
                cdLinkNewData.ContentDocumentId = cvContentDocId;
                newCDList.add(cdLinkNewData);
            }    
            insert newCDList;    
        }
        System.debug('Attachments for the Child Case inserted successfully');                
        
    }
    
    @AuraEnabled
    public static String updateTTSCase(String strWrapperData, String descriptionFieldName, String caseId, String realCaseId) {
        Case caserec=new  Case();       
        if(realCaseId!=null){
              caserec=[select id,Subject_Name__c from case where id=:realCaseId limit 1];
              
        }
        String updatedCaseId;
        
        SAETTSCaseWrapper caseWrapperData = (SAETTSCaseWrapper)JSON.deserialize(strWrapperData, SAETTSCaseWrapper.class);
        
        
        RecordType recordType = [SELECT Id, Name FROM RecordType WHERE sObjectType='case' AND Name='BEO'];
        
        Case caseObjDataToBeUpdated = new Case();
        
        caseObjDataToBeUpdated.Id = realCaseId;        
        caseObjDataToBeUpdated.Business_Direction__c = caseWrapperData.specialInstructions != ''?caseWrapperData.specialInstructions:null;
        caseObjDataToBeUpdated.Special_Instructions_Business_Unit__c = caseWrapperData.specialInstructionsBusinessUnit != ''?caseWrapperData.specialInstructionsBusinessUnit:null;
        caseObjDataToBeUpdated.Issue_Category_Desc__c = caseWrapperData.issueCategoryDesc != ''?caseWrapperData.issueCategoryDesc:null;
        caseObjDataToBeUpdated.Task_Category_Type_Desc__c = caseWrapperData.taskCategoryTypeDesc != ''?caseWrapperData.taskCategoryTypeDesc:null;
        caseObjDataToBeUpdated.Task_Category_Subtype_Desc__c = caseWrapperData.taskCategorySubtypeDesc != ''?caseWrapperData.taskCategorySubtypeDesc:null;
        caseObjDataToBeUpdated.Special_Instructions_Subject__c = caseWrapperData.specialInstructionsSubject != ''?caseWrapperData.specialInstructionsSubject:null;
        caseObjDataToBeUpdated.Special_Instructions_Description__c = caseId != '' ? caseId : null;
        System.debug('DESCRIPTIONS FIELD: ' + caseObjDataToBeUpdated.Special_Instructions_Description__c);
        caseObjDataToBeUpdated.Special_Instructions_Reference_ID__c = caseWrapperData.specialInstructionsReferenceID != ''?caseWrapperData.specialInstructionsReferenceID:null;                      
        caseObjDataToBeUpdated.SLA__c = caseWrapperData.slaDay;
        caseObjDataToBeUpdated.Email__c = caseWrapperData.emailURL;
        caseObjDataToBeUpdated.Department__c = caseWrapperData.department;
        caseObjDataToBeUpdated.Funding_Type__c  = caseWrapperData.groupFundingType != 'None'?caseWrapperData.groupFundingType:null;
        // Follow Up Date Calculation START - Yogitha
        //caseObjDataToBeUpdated.Subject_Name__c = caseWrapperData.SubjectName;
        caseObjDataToBeUpdated.Subject_Name__c = caserec.Subject_Name__c;
        Date cuurentDate = System.Today();
        Decimal slaDay = caseWrapperData.slaDay;
        Integer slaDayVal = 0;            
        if(slaDay != null) {
            slaDayVal = slaDay.intValue();
        }
        
        // Get the default business hours
        BusinessHours businessHoursObj = [SELECT Id FROM BusinessHours WHERE Name='ETS-BE/BEO' AND IsActive=true];
        
        /* List of Dates to be considered by excluding the Weekend & Holidays */
        List<Date> listOfDatesToConsider = new List<Date>();
        for(Integer i=0; i<slaDayVal; i++){
            Date currDate = cuurentDate.addDays(i);
            DateTime curDateAndTime = DateTime.newInstance(currDate.year(), currDate.month(), currDate.day());
            Boolean isBusinessDay = BusinessHours.isWithin(businessHoursObj.id, curDateAndTime);
            if(isBusinessDay) {
                listOfDatesToConsider.add(currDate);
            } else {
                slaDayVal = slaDayVal+1;
            }
        }  
        
        
        if(listOfDatesToConsider != null && listOfDatesToConsider.size() > 0) {
            System.debug(listOfDatesToConsider[listOfDatesToConsider.size()-1]);
            Date followUpDate = listOfDatesToConsider[listOfDatesToConsider.size()-1]; 
            caseObjDataToBeUpdated.Follow_Up_Date__c = DateTime.newInstance(followUpDate, DateTime.now().time());
        }            
        
        
        // Follow Up Date Calculation END - Yogitha
        
        String dosStr = '';
        if(caseWrapperData.specialInstructionsDateOfService != null && caseWrapperData.specialInstructionsDateOfService != ''){
            dosStr = caseWrapperData.specialInstructionsDateOfService;
            if(dosStr.contains(',')){
                dosStr = dosStr.replace(',',',\n');
            }
        } else if(caseWrapperData.dosVal != '') {
            dosStr = caseWrapperData.dosVal;
        }
        caseObjDataToBeUpdated.Date_of_Service__c = (dosStr != null) ? dosStr : '';
        
        
        if(caseWrapperData.specialInstructionsQueue != null && caseWrapperData.specialInstructionsQueue != ''){
            List<Group> queueList = [SELECT Id FROM Group WHERE Type='Queue' AND Name =: caseWrapperData.specialInstructionsQueue];
            
            if (queueList != null && queueList.size() > 0) {
                //caseObj.OwnerId = queueList[0].Id;
                caseObjDataToBeUpdated.Queue_Id__c = queueList[0].Id;
            }
        }
        
        caseObjDataToBeUpdated.Event_Type__c = 'Standard';
        caseObjDataToBeUpdated.Status = 'Open';        
        caseObjDataToBeUpdated.RecordTypeId = recordType.Id;
        
        update caseObjDataToBeUpdated;
        
        updatedCaseId = realCaseId;
        
        //Update interactions:US2580332
        if(updatedCaseId!=null){
             ETSBE_OneClickController.populateEvntTypeBusinessUnit(updatedCaseId);
            }
        return updatedCaseId;        
        
    }
    
    @AuraEnabled
    public static String getContactIdForHouseHoldMember(String searchType, String firstName, String lastName, String uniqueId, String dob, String uhgAccess) {
        
        String personContactId = '';
        
        personContactId = ETSBE_OneClickController.createPersonAccount(searchType, firstName, lastName, uniqueId, dob, uhgAccess);
        
        
        
        return personContactId;
    }
    
}