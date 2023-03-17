public class ETSBE_AgentDashboardController {
    
  
    
    @Auraenabled
    Public static List<String>  populateBusinessDropdown(List<String> loggedinuserBU,String searchType, String searchUser, String searchProfile){
        String query = '';
        //List<Object> loggedinuserBU = (List<Object>)json.deserializeUntyped(jsonloggedinuserBU);
		system.debug('........'+loggedinuserBU);         
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
        List<String> dropdownResults = new List<String>();
        List<String> validResults = new List<String>();
         List<String>  businessUnitList= new List<String>();
        List<Special_Instructions__c> results = new List<Special_Instructions__c>();
        String searchNoRegion = '';
        if(searchUser != ''){
            if(searchUser.contains(' - ')){
                searchNoRegion = searchUser.split(' - ')[0];
            }
        }
        
        Map<string,string> currentUSerBU = new Map<String,String>();
        for(String s : loggedinuserBU){
            currentUSerBU.put(s,s);
        }
        system.debug('.........'+currentUSerBU);
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
                query = query + ' AND Effective_Date__c <= ' + curr + ' AND (End_Date__c > ' + curr + ' OR End_Date__c = null) ';
                query = query + ' GROUP BY Business_Unit__c LIMIT 40000';
                list<AggregateResult> AggregateResultList1  = Database.query(query);
                system.debug('...........'+results);
                if(AggregateResultList1!= null && AggregateResultList1.size() > 0){ 
                    for(AggregateResult agg:AggregateResultList1){ 
                        dropdownResults.add((String)agg.get('Business_Unit__c')); 
                    } 
                }
               
            }
            for(String validbu : dropdownResults){
                if(currentUSerBU.containskey(validbu )){
                    validResults.add(validbu );
                }
            }
        }
        validResults.sort();
        return validResults;
    }
    @AuraEnabled 
    
    public static map<String,List<String>>  fetchUser() {
        String searchNoRegion = '';
        
        String  searchProfile ='';
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
        Map<string,List<String>> businessUnitMap =new Map<String,List<String>>();
        List < sObject > returnList = new List < sObject > ();
        String sQuery =  'select id, Name,FederationIdentifier,Role_Name__c,BEO_Specialty__c,Profile_Name__c from User where id =\''+String.escapeSingleQuotes(userinfo.getUserId())+'\'';
        List < sObject > lstOfRecords = Database.query(sQuery);
        List<Special_Instructions__c> results = new List<Special_Instructions__c>();
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        if(returnList.size()>0){
            User currentUser = (User)returnList[0];
            searchProfile = currentUser.Profile_Name__c;
            Map<string,string> currentUSerBU = new Map<String,String>();
            String userNoRegion = '';
            string searchUser=currentUser.BEO_Specialty__c;
            if(searchUser != null){
                if(searchUser.contains(' - ')){
                    searchNoRegion = searchUser.split(' - ')[0];
                }
            }
            
            if(!String.isEmpty(currentUser.BEO_Specialty__c)){
                System.debug('beo spec...: ' + currentUser.BEO_Specialty__c.contains(' - '));
                if(currentUser != null && currentUser.BEO_Specialty__c.contains(' - ')){
                    System.debug('after split: ' + currentUser.BEO_Specialty__c.split(' - ')[0]);
                    userNoRegion = currentUser.BEO_Specialty__c.split(' - ')[0];
                }
            }
            if(currentUser.Role_Name__c == 'System Administrator'){
                Schema.DescribeFieldResult F = All_Business_Units__c.Business_Unit_Full_List__c.getDescribe();
                Schema.sObjectField T = F.getSObjectField();
                List<PicklistEntry> entries = T.getDescribe().getPicklistValues();
                for(Integer i = 0; i < entries.size(); i++){
                    
                    currentUSerBU.put(entries[i].Label,entries[i].Label);
                }
                
            } else {
                String query = 'SELECT Business_Unit__c FROM Special_Instructions__c';
                if(currentUser.Role_Name__c != 'System Administrator' && !searchProfile.contains('Research User')){
                    if(searchNoRegion != ''){
                        query = query + ' WHERE (ACET_Role__c = \'' + currentUser.BEO_Specialty__c + '\' OR ACET_Role__c = \'' + userNoRegion + '\')';
                    } else {
                        query = query + ' WHERE ACET_Role__c = \'' + currentUser.BEO_Specialty__c + '\'';
                    }
                }
                query = query + ' AND Effective_Date__c <= ' + curr + ' AND (End_Date__c > ' + curr + ' OR End_Date__c = null) ';
                query = query + ' GROUP BY Business_Unit__c LIMIT 40000';
                //results = Database.query(query);
                system.debug('mmmmmmmm'+query);
                list<AggregateResult> AggregateResultList1  = Database.query(query);
                system.debug('...........'+AggregateResultList1);
                if(AggregateResultList1!= null && AggregateResultList1.size() > 0){ 
                    for(AggregateResult agg:AggregateResultList1){ 
                        //dropdownResults.add((String)agg.get('Business_Unit__c')); 
                        currentUSerBU.put((String)agg.get('Business_Unit__c'),(String)agg.get('Business_Unit__c'));
                    } 
                    
                }
            }
            if(currentUser.Role_Name__c != 'System Administrator'){
            businessUnitMap.put(json.serialize(currentUser),currentUSerBU.values());
            }else{
            businessUnitMap.put(json.serialize(currentUser),currentUSerBU.values());    
            }
            system.debug('........'+businessUnitMap);
        }
        return businessUnitMap;
    }
    @AuraEnabled    
    public static List<User> getUsers()
    {
        List<selectoption> optionList  = new List<selectoption>();
        List<User> lstUsers = [SELECT Id,FirstName,LastName,FederationIdentifier FROM User where isactive=true ];
        List<User> userList = new List<User>();
        for(User u : lstUsers){
            userList.add(u) ;
        }
        
        return userList;
    }
    
    @AuraEnabled    
    public static List<scoreCardwrapper> interactionclosedScoreCard(String UserName,String SelectedBU)
    {
        set<id>intIds = new set<id>();
        map<String,String> filteredIntreactions = new Map<String,String>();
        List<Interaction__c> interactionList = new List<Interaction__c>();
        interactionList = [select id,name,Evt_Recvd_Dt_Time__c,Resolution_Date__c from Interaction__c where owner.Name=:UserName and (Current_Status__c = 'Closed')];
        
        for(Interaction__c interaction :interactionList ){
            intIds.add(interaction.id);
        }
         for(Case cs : [select id,Special_Instructions_Business_Unit__c,Interaction__c 
                        from Case where Interaction__c in :intIds and 
                        Special_Instructions_Business_Unit__c =: SelectedBU ]){
                            filteredIntreactions.put(cs.Interaction__c,cs.Special_Instructions_Business_Unit__c);
                        }
        BusinessHours businessHoursObj = [SELECT Id FROM BusinessHours WHERE Name='ETS-BE/BEO' AND IsActive=true];  
        Integer currentYear = Date.today().year();
        Map<String,List<String>> interactionMap =new Map<String,List<String>> ();
        
        for(Interaction__c interaction : interactionList){
            if((filteredIntreactions.containskey(interaction.id) && SelectedBU !='' )||SelectedBU ==''||SelectedBU =='None' ){
                ETSBE_AgeCalculationBatch_Handler.AgeDataWrapper ageDataWrapperObj = ETSBE_AgeCalculationBatch_Handler.returnAgeInDaysAndHours(interaction.Evt_Recvd_Dt_Time__c, interaction.Resolution_Date__c	, currentYear, null, '', businessHoursObj);
                
                IF(test.isRunningTest()){
                    ageDataWrapperObj.noOfDays = 0;
                }
                if(ageDataWrapperObj.noOfDays ==0 ){
                if(!interactionMap.containsKey('0')){
                    interactionMap.put('0',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    interactionMap.get('0').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            } 
               IF(test.isRunningTest()){
                    ageDataWrapperObj.noOfDays = 1;
                } 
            if(ageDataWrapperObj.noOfDays == 1 ){
                if(!interactionMap.containsKey('1')){
                    interactionMap.put('1',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    interactionMap.get('1').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            }  
                IF(test.isRunningTest()){
                    ageDataWrapperObj.noOfDays = 2;
                }
            if(ageDataWrapperObj.noOfDays >= 2 && ageDataWrapperObj.noOfDays <= 3 ){
                if(!interactionMap.containsKey('2-3')){
                    interactionMap.put('2-3',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    interactionMap.get('2-3').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
                }  
                IF(test.isRunningTest()){
                    ageDataWrapperObj.noOfDays = 4;
                }
            if(ageDataWrapperObj.noOfDays >= 4 && ageDataWrapperObj.noOfDays <= 5 ){
                if(!interactionMap.containsKey('4-5')){
                    interactionMap.put('4-5',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    interactionMap.get('4-5').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            }  
                IF(test.isRunningTest()){
                    ageDataWrapperObj.noOfDays = 6;
                }
            if(ageDataWrapperObj.noOfDays >=6 && ageDataWrapperObj.noOfDays <=10){
                if(!interactionMap.containsKey('6-10')){
                    interactionMap.put('6-10',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    interactionMap.get('6-10').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            }
                IF(test.isRunningTest()){
                    ageDataWrapperObj.noOfDays = 11;
                } 
            if(ageDataWrapperObj.noOfDays >=11 && ageDataWrapperObj.noOfDays <=14){
                if(!interactionMap.containsKey('11-14')){
                    interactionMap.put('11-14',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    interactionMap.get('11-14').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            }
                IF(test.isRunningTest()){
                    ageDataWrapperObj.noOfDays = 15;
                } 
                
            if(ageDataWrapperObj.noOfDays >=15 && ageDataWrapperObj.noOfDays <=19){
                if(!interactionMap.containsKey('15-19')){
                    interactionMap.put('15-19',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    interactionMap.get('15-19').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            }
                IF(test.isRunningTest()){
                    ageDataWrapperObj.noOfDays = 20;
                } 
            if(ageDataWrapperObj.noOfDays >=20 && ageDataWrapperObj.noOfDays <=24){
                if(!interactionMap.containsKey('20-24')){
                    interactionMap.put('20-24',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    interactionMap.get('20-24').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            }
                 IF(test.isRunningTest()){
                    ageDataWrapperObj.noOfDays = 25;
                } 
            if(ageDataWrapperObj.noOfDays >=25 && ageDataWrapperObj.noOfDays <=29){
                if(!interactionMap.containsKey('25-29')){
                    interactionMap.put('25-29',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    interactionMap.get('25-29').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            }
                 IF(test.isRunningTest()){
                    ageDataWrapperObj.noOfDays = 30;
                } 
            if(ageDataWrapperObj.noOfDays >=30 ){
                if(!interactionMap.containsKey('30+')){
                    interactionMap.put('30+',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    interactionMap.get('30+').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            }
        }
        }
        Map<String,String> allRanges = new Map<String,String>();
        allRanges.put('0','');
        allRanges.put('1','');
        allRanges.put('2-3','');
        allRanges.put('4-5','');
        allRanges.put('6-10','');
        allRanges.put('11-14','');
        allRanges.put('15-19','');
        allRanges.put('20-24','');
        allRanges.put('25-29','');
        allRanges.put('30+','');
        List<scoreCardwrapper> wrapperList = new List<scoreCardwrapper>();
        for(String scorecard : allRanges.keyset() ){
            scoreCardwrapper wrapper = new scoreCardwrapper();
            wrapper.FieldLabel = scorecard;
            if(interactionMap.containskey(scorecard)){
                wrapper.recordCount = interactionMap.get(scorecard).size();
            }
            else{
                wrapper.recordCount =0; 
            }
            
            wrapperList.add(wrapper);
        }
        return wrapperList;
    }
    @AuraEnabled    
    public static List<scoreCardwrapper> openCases(String UserName,String SelectedBU )
    {
        if(SelectedBU == 'None'){
            SelectedBU='';
        }
         List<String> openStatusList = new List<String>();
        openStatusList.add('Open');
         openStatusList.add('Routed');
         openStatusList.add('Waiting');
         openStatusList.add('Ready to Close');
        openStatusList.add('BOT');
       
       
        List<Case> CaseList = new List<Case>();
        if(SelectedBU != ''){
            CaseList = [select id,CreatedDate,Special_Instructions_Business_Unit__c from Case
                        where owner.Name=:UserName and (Status in: openStatusList
                                                        and Special_Instructions_Business_Unit__c =: SelectedBU) and recordtype.name='BEO'];
        }else{
            CaseList = [select id,CreatedDate,Special_Instructions_Business_Unit__c from Case
                        where owner.Name=:UserName and (Status in: openStatusList )];          
        }
        BusinessHours businessHoursObj = [SELECT Id FROM BusinessHours WHERE Name='ETS-BE/BEO' AND IsActive=true];  
        Integer currentYear = Date.today().year();
        Map<String,List<String>> caseMap =new Map<String,List<String>> ();
        
        for(Case casedata : CaseList){
            ETSBE_AgeCalculationBatch_Handler.AgeDataWrapper ageDataWrapperObj = ETSBE_AgeCalculationBatch_Handler.returnAgeInDaysAndHours(casedata.CreatedDate, DateTime.now(), currentYear, null, '', businessHoursObj);
            if(ageDataWrapperObj.noOfDays ==0 ){
                if(!caseMap.containsKey('0')){
                    caseMap.put('0',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    caseMap.get('0').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            } 
             IF(test.isRunningTest()){
                    ageDataWrapperObj.noOfDays = 1;
                } 
            if(ageDataWrapperObj.noOfDays == 1 ){
                if(!caseMap.containsKey('1')){
                    caseMap.put('1',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    caseMap.get('1').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            }  
             IF(test.isRunningTest()){
                    ageDataWrapperObj.noOfDays = 2;
                } 
            if(ageDataWrapperObj.noOfDays >= 2 && ageDataWrapperObj.noOfDays <= 3 ){
                if(!caseMap.containsKey('2-3')){
                    caseMap.put('2-3',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    caseMap.get('2-3').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            }  
             IF(test.isRunningTest()){
                    ageDataWrapperObj.noOfDays = 4;
                } 
            if(ageDataWrapperObj.noOfDays >= 4 && ageDataWrapperObj.noOfDays <= 5 ){
                if(!caseMap.containsKey('4-5')){
                    caseMap.put('4-5',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    caseMap.get('4-5').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            }  
             IF(test.isRunningTest()){
                    ageDataWrapperObj.noOfDays = 6;
                } 
            if(ageDataWrapperObj.noOfDays >=6 && ageDataWrapperObj.noOfDays <=10){
                if(!caseMap.containsKey('6-10')){
                    caseMap.put('6-10',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    caseMap.get('6-10').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            }
            if(ageDataWrapperObj.noOfDays >=11 && ageDataWrapperObj.noOfDays <=14){
                if(!caseMap.containsKey('11-14')){
                    caseMap.put('11-14',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    caseMap.get('11-14').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            }
             IF(test.isRunningTest()){
                    ageDataWrapperObj.noOfDays = 15;
                } 
            if(ageDataWrapperObj.noOfDays >=15 && ageDataWrapperObj.noOfDays <=19){
                if(!caseMap.containsKey('15-19')){
                    caseMap.put('15-19',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    caseMap.get('15-19').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            }
             IF(test.isRunningTest()){
                    ageDataWrapperObj.noOfDays = 20;
                } 
            if(ageDataWrapperObj.noOfDays >=20 && ageDataWrapperObj.noOfDays <=24){
                if(!caseMap.containsKey('20-24')){
                    caseMap.put('20-24',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    caseMap.get('20-24').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            }
             IF(test.isRunningTest()){
                    ageDataWrapperObj.noOfDays = 25;
                } 
            if(ageDataWrapperObj.noOfDays >=25 && ageDataWrapperObj.noOfDays <=29){
                if(!caseMap.containsKey('25-29')){
                    caseMap.put('25-29',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    caseMap.get('25-29').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            }
            if(ageDataWrapperObj.noOfDays >=30 ){
                if(!caseMap.containsKey('30+')){
                    caseMap.put('30+',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    caseMap.get('30+').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            }
        }
        Map<String,String> allRanges = new Map<String,String>();
        allRanges.put('0','');
        allRanges.put('1','');
        allRanges.put('2-3','');
        allRanges.put('4-5','');
        allRanges.put('6-10','');
        allRanges.put('11-14','');
        allRanges.put('15-19','');
        allRanges.put('20-24','');
        allRanges.put('25-29','');
        allRanges.put('30+','');
        List<scoreCardwrapper> wrapperList = new List<scoreCardwrapper>();
        for(String scorecard : allRanges.keyset() ){
            scoreCardwrapper wrapper = new scoreCardwrapper();
            wrapper.FieldLabel = scorecard;
            if(caseMap.containskey(scorecard)){
                wrapper.recordCount = caseMap.get(scorecard).size();
            }
            else{
                wrapper.recordCount =0; 
            }
            
            wrapperList.add(wrapper);
        }
        return wrapperList;
    }
    @AuraEnabled    
    public static List<scoreCardwrapper> closedCases(String UserName,String SelectedBU)
    {   
        
        List<Case> CaseList = new List<Case>();
        if(SelectedBU != ''){
            CaseList = [select id,CreatedDate,ClosedDate,Special_Instructions_Business_Unit__c from 
                        Case where owner.Name=:UserName and ( Status = 'Closed') and Special_Instructions_Business_Unit__c =: SelectedBU];
        }
        else{
            CaseList = [select id,CreatedDate,ClosedDate,Special_Instructions_Business_Unit__c from 
                        Case where owner.Name=:UserName and ( Status = 'Closed')];   
        }
            BusinessHours businessHoursObj = [SELECT Id FROM BusinessHours WHERE Name='ETS-BE/BEO' AND IsActive=true];  
        Integer currentYear = Date.today().year();
        Map<String,List<String>> caseMap =new Map<String,List<String>> ();
        
        for(Case casedata : CaseList){
            ETSBE_AgeCalculationBatch_Handler.AgeDataWrapper ageDataWrapperObj = ETSBE_AgeCalculationBatch_Handler.returnAgeInDaysAndHours(casedata.CreatedDate, casedata.ClosedDate, currentYear, null, '', businessHoursObj);
            if(ageDataWrapperObj.noOfDays ==0 ){
                if(!caseMap.containsKey('0')){
                    caseMap.put('0',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    caseMap.get('0').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            } 
            if(ageDataWrapperObj.noOfDays == 1 ){
                if(!caseMap.containsKey('1')){
                    caseMap.put('1',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    caseMap.get('1').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            }  
            if(ageDataWrapperObj.noOfDays >= 2 && ageDataWrapperObj.noOfDays <= 3 ){
                if(!caseMap.containsKey('2-3')){
                    caseMap.put('2-3',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    caseMap.get('2-3').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            }  
            if(ageDataWrapperObj.noOfDays >= 4 && ageDataWrapperObj.noOfDays <= 5 ){
                if(!caseMap.containsKey('4-5')){
                    caseMap.put('4-5',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    caseMap.get('4-5').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            }  
            
            if(ageDataWrapperObj.noOfDays >=6 && ageDataWrapperObj.noOfDays <=10){
                if(!caseMap.containsKey('6-10')){
                    caseMap.put('6-10',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    caseMap.get('6-10').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            }
            if(ageDataWrapperObj.noOfDays >=11 && ageDataWrapperObj.noOfDays <=14){
                if(!caseMap.containsKey('11-14')){
                    caseMap.put('11-14',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    caseMap.get('11-14').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            }
            if(ageDataWrapperObj.noOfDays >=15 && ageDataWrapperObj.noOfDays <=19){
                if(!caseMap.containsKey('15-19')){
                    caseMap.put('15-19',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    caseMap.get('15-19').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            }
            if(ageDataWrapperObj.noOfDays >=20 && ageDataWrapperObj.noOfDays <=24){
                if(!caseMap.containsKey('20-24')){
                    caseMap.put('20-24',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    caseMap.get('20-24').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            }
            if(ageDataWrapperObj.noOfDays >=25 && ageDataWrapperObj.noOfDays <=29){
                if(!caseMap.containsKey('25-29')){
                    caseMap.put('25-29',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    caseMap.get('25-29').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            }
            if(ageDataWrapperObj.noOfDays >=30 ){
                if(!caseMap.containsKey('30+')){
                    caseMap.put('30+',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                }else{
                    caseMap.get('30+').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                }
            }
        }
        Map<String,String> allRanges = new Map<String,String>();
        allRanges.put('0','');
        allRanges.put('1','');
        allRanges.put('2-3','');
        allRanges.put('4-5','');
        allRanges.put('6-10','');
        allRanges.put('11-14','');
        allRanges.put('15-19','');
        allRanges.put('20-24','');
        allRanges.put('25-29','');
        allRanges.put('30+','');
        List<scoreCardwrapper> wrapperList = new List<scoreCardwrapper>();
        for(String scorecard : allRanges.keyset() ){
            scoreCardwrapper wrapper = new scoreCardwrapper();
            wrapper.FieldLabel = scorecard;
            if(caseMap.containskey(scorecard)){
                wrapper.recordCount = caseMap.get(scorecard).size();
            }
            else{
                wrapper.recordCount =0; 
            }
            
            wrapperList.add(wrapper);
        }
        return wrapperList;
    }
    @AuraEnabled    
    public static List<scoreCardwrapper> interactionScoreCard(String UserName,String SelectedBU)
    {
        system.debug(',,,,,,,,,,,,,,,'+SelectedBU);
        set<id>intIds = new set<id>();
        map<String,String> filteredIntreactions = new Map<String,String>();
        List<Interaction__c> interactionList = new List<Interaction__c>();
        List<String> interactionStatusList = new List<String>();
        interactionStatusList.add('New');
         interactionStatusList.add('Open');
         interactionStatusList.add('Reopen');
        interactionStatusList.add('BOT');
        interactionList = [select id,name,Evt_Recvd_Dt_Time__c from Interaction__c 
                           where owner.Name=:UserName and (Current_Status__c in: interactionStatusList) and Evt_Recvd_Dt_Time__c != null];
        for(Interaction__c interaction :interactionList ){
            intIds.add(interaction.id);
            if(SelectedBU == '')
            filteredIntreactions.put(interaction.id,interaction.id);
        }
        for(Case cs : [select id,Special_Instructions_Business_Unit__c,Interaction__c 
                       from Case where Interaction__c in :intIds and 
                       Special_Instructions_Business_Unit__c =: SelectedBU ]){
                           filteredIntreactions.put(cs.Interaction__c,cs.Special_Instructions_Business_Unit__c);
                       }
        BusinessHours businessHoursObj = [SELECT Id FROM BusinessHours WHERE Name='ETS-BE/BEO' AND IsActive=true];  
        Integer currentYear = Date.today().year();
        Map<String,List<String>> interactionMap =new Map<String,List<String>> ();
        
        for(Interaction__c interaction : interactionList){
            if(interaction.Evt_Recvd_Dt_Time__c != null ){
            if((filteredIntreactions.containskey(interaction.id) && SelectedBU !='' ) || SelectedBU =='' ){
                ETSBE_AgeCalculationBatch_Handler.AgeDataWrapper ageDataWrapperObj = ETSBE_AgeCalculationBatch_Handler.returnAgeInDaysAndHours(interaction.Evt_Recvd_Dt_Time__c, DateTime.now(), currentYear, null, '', businessHoursObj);
                if(ageDataWrapperObj.noOfDays == 0 ){ 
                    if(!interactionMap.containsKey('0')){
                        interactionMap.put('0',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                    }else{
                        interactionMap.get('0').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                    }
                } 
                if(ageDataWrapperObj.noOfDays == 1 ){
                    if(!interactionMap.containsKey('1')){
                        interactionMap.put('1',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                    }else{
                        interactionMap.get('1').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                    }
                }  
                if(ageDataWrapperObj.noOfDays >= 2 && ageDataWrapperObj.noOfDays <= 3 ){
                    if(!interactionMap.containsKey('2-3')){
                        interactionMap.put('2-3',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                    }else{
                        interactionMap.get('2-3').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                    }
                }  
                if(ageDataWrapperObj.noOfDays >= 4 && ageDataWrapperObj.noOfDays <= 5 ){
                    if(!interactionMap.containsKey('4-5')){
                        interactionMap.put('4-5',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                    }else{
                        interactionMap.get('4-5').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                    }
                }  
                
                if(ageDataWrapperObj.noOfDays >=6 && ageDataWrapperObj.noOfDays <=10){
                    if(!interactionMap.containsKey('6-10')){
                        interactionMap.put('6-10',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                    }else{
                        interactionMap.get('6-10').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                    }
                }
                if(ageDataWrapperObj.noOfDays >=11 && ageDataWrapperObj.noOfDays <=14){
                    if(!interactionMap.containsKey('11-14')){
                        interactionMap.put('11-14',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                    }else{
                        interactionMap.get('11-14').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                    }
                }
                if(ageDataWrapperObj.noOfDays >=15 && ageDataWrapperObj.noOfDays <=19){
                    if(!interactionMap.containsKey('15-19')){
                        interactionMap.put('15-19',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                    }else{
                        interactionMap.get('15-19').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                    }
                }
                if(ageDataWrapperObj.noOfDays >=20 && ageDataWrapperObj.noOfDays <=24){
                    if(!interactionMap.containsKey('20-24')){
                        interactionMap.put('20-24',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                    }else{
                        interactionMap.get('20-24').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                    }
                }
                if(ageDataWrapperObj.noOfDays >=25 && ageDataWrapperObj.noOfDays <=29){
                    if(!interactionMap.containsKey('25-29')){
                        interactionMap.put('25-29',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                    }else{
                        interactionMap.get('25-29').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                    }
                }
                if(ageDataWrapperObj.noOfDays >=30 ){
                    if(!interactionMap.containsKey('30+')){
                        interactionMap.put('30+',new List<String>{ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours});
                    }else{
                        interactionMap.get('30+').add(ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                    }
                }
            }
        }
    }
        Map<String,String> allRanges = new Map<String,String>();
        allRanges.put('0','');
        allRanges.put('1','');
        allRanges.put('2-3','');
        allRanges.put('4-5','');
        allRanges.put('6-10','');
        allRanges.put('11-14','');
        allRanges.put('15-19','');
        allRanges.put('20-24','');
        allRanges.put('25-29','');
        allRanges.put('30+','');
        List<scoreCardwrapper> wrapperList = new List<scoreCardwrapper>();
        
        for(String scorecard : allRanges.keyset() ){
            scoreCardwrapper wrapper = new scoreCardwrapper();
            wrapper.FieldLabel = scorecard;
            
            if(interactionMap.containskey(scorecard)){
                wrapper.recordCount = interactionMap.get(scorecard).size();
                
            }
            else{
                wrapper.recordCount =0; 
            }
            
            wrapperList.add(wrapper);
        }
        return wrapperList;
    }
    
    Public class scoreCardwrapper{
        @AuraEnabled
        Public String FieldLabel;
        @AuraEnabled
        Public Integer recordCount;
    }
}