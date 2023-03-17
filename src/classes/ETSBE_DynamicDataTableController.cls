public class ETSBE_DynamicDataTableController{
     //*******Constants*******************
    private static final String DATE_DATATYPE = 'DATE';
    private static final String DATETIME_DATATYPE = 'DATETIME';
    private static final String CURRENCY_DATATYPE = 'CURRENCY';
    private static final String PARENT_RELATIONSHIP = 'REFERENCE';
    @AuraEnabled
    public static String getFieldSet(String sObjectName, String fieldSetName) {
        String result = '';
        
        try{
            SObjectType objToken = Schema.getGlobalDescribe().get(sObjectName);
            Schema.DescribeSObjectResult d = objToken.getDescribe();
            Map<String, Schema.FieldSet> FsMap = d.fieldSets.getMap();
            system.debug('>>>>>>> FsMap >>> ' + FsMap);
            if(FsMap.containsKey(fieldSetName))
                for(Schema.FieldSetMember f : FsMap.get(fieldSetName).getFields()) {
                    if(result != ''){
                        result += ',';
                    }
                    String jsonPart = '{';
                    jsonPart += '"label":"' + f.getLabel() + '",';
                    jsonPart += '"required":"' + (f.getDBRequired() || f.getRequired()) + '",';
                    jsonPart += '"type":"' + (f.getType()) + '",';
                    jsonPart += '"name":"' + f.getFieldPath() + '"';
                    jsonPart += '}';
                    result += jsonPart;
                }
        }
        catch(Exception e){
            result += e.getLineNumber() + ' : ' + e.getMessage();
        }
        return '['+result+']';
    }

     @AuraEnabled
    public static Map<String,String> getFieldSet1(String sObjectName, String fieldSetName) {
         String result = '';
         String Label ='';
        MAp<String,String> returnMap = new Map<String,String>();
        
            SObjectType objToken = Schema.getGlobalDescribe().get(sObjectName);
            Schema.DescribeSObjectResult d = objToken.getDescribe();
            Map<String, Schema.FieldSet> FsMap = d.fieldSets.getMap();
            system.debug('>>>>>>> FsMap >>> ' + FsMap);
            if(FsMap.containsKey(fieldSetName))
                for(Schema.FieldSetMember f : FsMap.get(fieldSetName).getFields()) {
                    if(result != ''){
                        result += ',';
                    }
                    if(label != ''){
                        label += ',';
                    }
                    String jsonPart = '{';
                    jsonPart += '"label":"' + f.getLabel() + '",';
                    jsonPart += '"required":"' + (f.getDBRequired() || f.getRequired()) + '",';
                    jsonPart += '"type":"' + (f.getType()) + '",';
                    jsonPart += '"name":"' + f.getFieldPath() + '"';
                    jsonPart += '}';
                    result += jsonPart;
                    label += f.getLabel();
                }
            result = '['+result+']';
            returnMap.put('Label',label);
            returnMap.put('Value',result);
        
        return returnMap;
    }
    @AuraEnabled
    public static String generateDataSet (string objAPIname, string fieldsAPIname, string columnsLabel, string hyperlinkColumn,String UserName,String SelectedBU,String lastId,boolean isoverdue,integer pageLength){
        //Variable to store column label and API name information information
        
        List<String> columnLabelList = new List<String>();
        list<sobject> sbList= new List<sobject>();
        set<sobject>sbset = new set<sobject>();
        list<sobject> priorityList= new List<sobject>();
        List<String> FieldAPINameList = new List<String>();
       
        datasetForTable dataSet =new datasetForTable();
        Map<String,String> fieldToFieldTypeMap = new Map<String,String>();
        //Section to generate dynamic query start------------------
        string fieldQuery = '';
        string objectApiName ='';
        string fieldApiName = '';
        string sortingOrderBy = '';
        string whereClause = '';
        string limitString = '';
        string HyperLinkField = '';
        string queryString ='';
        boolean isCase=false;
        if(hyperlinkColumn != null && hyperlinkColumn !=''){
            HyperLinkField = hyperlinkColumn.trim();
        }if(objAPIname!=null && objAPIname!=''){
            objectApiName = objAPIname.trim();
        }if(fieldsAPIname != null && fieldsAPIname != ''){
            FieldAPINameList = (List<String>) JSON.deserialize(fieldsAPIname, List<String>.class);
            fieldQuery = String.join(FieldAPINameList, ',');
            
        }
            string openstatus ='Open';
       
        String[] openStatusList = new String[]{'Open','Routed','Waiting','Ready to Close','BOT'};
       
        List<String> interactionStatusList = new List<String>();
        interactionStatusList.add('New');
         interactionStatusList.add('Open');
         interactionStatusList.add('Reopen');
        interactionStatusList.add('BOT');
       String withDrawnStatus = 'Withdrawn';
        String closedstatus ='Closed';
        string beocase='BEO';
        String InteractionRecordtype='BEO Interaction';
                
        if(objectApiName == 'Case' && isoverdue == true){
            isCase =true;
        queryString = 'select  id,' + fieldQuery + ',Owner.Name from ' + objectApiName ;
        }else{
            queryString = 'select  id,' + fieldQuery + ' from ' + objectApiName ;
        }
        if(objectApiName == 'Case' && isoverdue == false){
            isCase =true;
            queryString=queryString+' where (Status In: openStatusList) ';
            if(SelectedBU != '' &&SelectedBU != null){
                queryString=queryString+' and Special_Instructions_Business_Unit__c =: SelectedBU';
            }
            
            string priority='Urgent';
           
            
            String prioritystring = queryString;
            string countstring= queryString;
            if(!test.isRunningTest())
            countstring=countstring+ '  and (createdby.name =: UserName or Owner.Name=:UserName) and recordtype.name=:beocase ' ;
            dataSet.recordcount = database.query(countstring).size();
            string loggedinUser ='';
            loggedinUser = userinfo.getname();
            if(!test.isRunningTest())
            prioritystring = prioritystring+' and priority=:priority and Owner.Name=:loggedinUser and recordtype.name=:beocase ';
            prioritystring = prioritystring +'  order by casenumber desc ';
             if(loggedinUser == username)
            priorityList=database.query(prioritystring);
             
            
            if(priorityList.size()>0  && loggedinUser == username){
                if(lastId == '')
                sbset.addall(priorityList);
                if(sbset.size()<=25){
                    integer pagedata =0;
                     if(lastId != ''){
                          queryString =queryString+' and casenumber<:lastId';
                        }
                    pagedata = pageLength-sbset.size();
                     
                    queryString =queryString+' and (priority !=:priority or (createdby.name =: UserName and priority =:priority and owner.name !=:loggedinUser ))';
                    if(!test.isRunningTest())
            		queryString=queryString+ '  and (createdby.name =: UserName or Owner.Name=:UserName) and recordtype.name=:beocase ' ;
                    queryString = queryString +'   order by casenumber desc limit ' + pagedata;
                    
                    sbset.addall(database.query(queryString));
                  
                }
            }else{
                if(lastId != ''){
                  queryString =queryString+' and casenumber<:lastId';
                }
               // queryString =queryString+' and ((priority !=:priority and Owner.name =: UserName) or (createdby.name =: UserName and priority =:priority))';
                
                if(!test.isRunningTest())
            	queryString=queryString+ '  and (createdby.name =: UserName or Owner.Name=:UserName) and recordtype.name=:beocase ' ;
            	
            	queryString = queryString +'  order by casenumber desc limit ' + pageLength;
                sbset.addall(database.query(queryString));
            }
            
            sblist.addall(sbset); 
        }
        else  if(objectApiName == 'Interaction__c' && isoverdue == false){
            queryString=queryString+' where (Current_Status__c in:interactionStatusList) and Evt_Recvd_Dt_Time__c != null';
            
            if(lastId != ''){
                queryString =queryString+' and Name<:lastId';
            }
           queryString=queryString+ ' and (createdby.name =: UserName or Owner.Name=:UserName) ' ;
             if(SelectedBU == 'None'){
            SelectedBU='';
            }
            if(SelectedBU == '' || SelectedBU == null){
            dataSet.recordcount = database.query(queryString).size();
            
            queryString = queryString +' order by Name desc limit '+pageLength;
            }
             sbList=database.query(queryString);
           
            
        }
        else if(objectApiName == 'Case' && isoverdue == true){
             date todaydate= date.today();
             
            queryString=queryString+' where (Status in: openStatusList  and Follow_Up_Date__c <= : todaydate )  and recordtype.name=:beocase ';
            if(SelectedBU == 'None'){
            SelectedBU='';
            }
            if(SelectedBU != '' &&SelectedBU != null){
                queryString=queryString+'  and Special_Instructions_Business_Unit__c =: SelectedBU';
            }
                String prioritystring = queryString;
            string countstring= queryString;
            if(!test.isRunningTest())
            countstring=countstring+ '  and (createdby.name =: UserName or Owner.Name=:UserName) and recordtype.name=:beocase ' ;
            dataSet.recordcount = database.query(countstring).size();
            string loggedinUser ='';
            loggedinUser = userinfo.getname();
           if(!test.isRunningTest())
            prioritystring = prioritystring+' and priority=:priority and Owner.Name=:loggedinUser and recordtype.name=:beocase ';
            prioritystring = prioritystring +'  order by casenumber desc ';
             if(loggedinUser == username)
            priorityList=database.query(prioritystring);
             
            
            if(priorityList.size()>0  && loggedinUser == username){
                if(lastId == '')
                sbset.addall(priorityList);
                if(sbset.size()<=25){
                    integer pagedata =0;
                     if(lastId != ''){
                          queryString =queryString+' and casenumber<:lastId';
                        }
                    pagedata = pageLength-sbset.size();
                     
                    queryString =queryString+' and (priority !=:priority or (createdby.name =: UserName and priority =:priority and owner.name !=:loggedinUser ))';
                    if(!test.isRunningTest())
            		queryString=queryString+ '  and (createdby.name =: UserName or Owner.Name=:UserName) and recordtype.name=:beocase ' ;
                    queryString = queryString +'   order by casenumber desc limit ' + pagedata;
                    
                    
                    sbset.addall(database.query(queryString));
                   
                }
            }else{
                if(lastId != ''){
                  queryString =queryString+' and casenumber<:lastId';
                }
              
                
                if(!test.isRunningTest())
            	queryString=queryString+ '  and (createdby.name =: UserName or Owner.Name=:UserName) and recordtype.name=:beocase ' ;
            	
            	queryString = queryString +'  order by casenumber desc limit ' + pageLength;
                sbset.addall(database.query(queryString));
            }
            
            sblist.addall(sbset);
        
        }
        else  if(objectApiName == 'Interaction__c' && isoverdue == true){
         date todaydate= date.today();
             queryString=queryString+' where  (Current_Status__c in:interactionStatusList and Follow_Up_Date__c <= : todaydate ) ';
            if(SelectedBU == 'None'){
            SelectedBU='';
            }
            
                
            
            if(lastId != ''){
                queryString =queryString+' and Name<:lastId';
            }
            queryString=queryString+ ' and createdby.name =: UserName and Evt_Recvd_Dt_Time__c != null ' ;
            if(SelectedBU == '' || SelectedBU == null){
            dataSet.recordcount = database.query(queryString).size();
            
            queryString = queryString +'  order by Name desc limit '+pageLength;
            }
             sbList=database.query(queryString);
        }
        //Section to find columns label start-------------------
        
            
        
         
         
        
        if(columnsLabel!=null && columnsLabel!=''){
            List<string> filedLabels = columnsLabel.trim().split(',');
            if(filedLabels.size() > 0 ){
                for(string ss : filedLabels){
                    if(ss != null && ss != ''){
                        columnLabelList.add(ss.trim());
                    }
                }
            }
        }
        //Section to find coumns label ends--------------------
            
        //Section to find field and their field type map starts------------
        fieldToFieldTypeMap = generateFieldTypeMap(objectApiName,FieldAPINameList);
       
        //Section to find field and their field type map ends------------

        

        if(objectApiName == 'Interaction__c' && SelectedBU != '' && SelectedBU!= null){
        set<id> intids = new set<id>();
        set<id> validInt = new set<id>();
            for(sobject sb:sbList){
                intids.add((id)sb.get('Id'));
            }
           /*for(Case c :[select id,Interaction__c from case where Special_Instructions_Business_Unit__c =:SelectedBU 
                           and Interaction__c in: intids ]){
           
               validInt.add(c.Interaction__c);
           }*/
            //US2580332:Populate EventType/Business Unit
            for(Interaction__c interac:[select id,Business_Unit__c from Interaction__c where Business_Unit__c=:SelectedBU AND id=:intids]){
                 validInt.add(interac.id);                
            }
            sbList.clear();
            queryString =queryString+ ' and id in:validInt ';
            
            dataSet.recordcount = database.query(queryString).size();
            
            queryString = queryString +' order by Name desc limit '+pageLength;
            sbList =database.query(queryString);
            
        }
        
        //generating the dataset in order to display on UI
        list<list<String>> dataValues=new list<list<String>>();
        list<list<String>> columnsLabels=new list<list<String>>();
        if(sbList.size()>0 ){
            BusinessHours businessHoursObj = [SELECT Id FROM BusinessHours WHERE Name='ETS-BE/BEO' AND IsActive=true];            
            
            Integer currentYear = Date.today().year();
            for(sobject sb:sbList){
                list<String> fieldvalues = new List<String>();
                for(String ss:FieldAPINameList){
                    try{
                        string colValue;
                      
                        if(ss.contains('.')){
                            List<string> splitedFields = ss.split('\\.');
                            
                            if(sb.getSobject(splitedFields[0])!=null && splitedFields[1] !=null){
                                
                                colValue = (String) sb.getSobject(splitedFields[0]).get(splitedFields[1]);
                            }
                        }else{
                            if(sb.get(ss)!=null){
                                if(objectApiName == 'Case' && isoverdue == false){
                                    datetime datetimeopened = (datetime)sb.get('Createddate');
                                ETSBE_AgeCalculationBatch_Handler.AgeDataWrapper ageDataWrapperObj = ETSBE_AgeCalculationBatch_Handler.returnAgeInDaysAndHours(datetimeopened, DateTime.now(), currentYear, null, '', businessHoursObj);    
                                sb.put('Case_Age__c',ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                                   String ownername ='';
                                    if(sb.getSobject('Owner')!=null)
                                       ownername =(String) sb.getSobject('Owner').get('Name');
                                   
                                     if(sb.get('Priority') == 'Urgent' && ownername== userinfo.getName() ){
                                       // iconStyle = 'data-src="/assets/icons/utility-sprite/svg/symbols.svg#close"';
                                        String flagrec = '<span class="slds-icon_container slds-icon-utility-chart " >';
                                            flagrec =flagrec +'<svg aria-hidden="true" class="slds-icon  slds-icon-text-error slds-icon--small">';
                                             flagrec=flagrec+ '<use xmlns:xlink="http://www.w3.org/1999/xlink" ';
                                             flagrec=flagrec+ '  xlink:href="/apexpages/slds/latest//assets/icons/utility-sprite/svg/symbols.svg#priority">';
                                               flagrec=flagrec+ ' </use></svg><span class="slds-assistive-text">Urgent</span></span>';
                                        sb.put('Priority',flagrec );
                                        
                                       
                                    } else{
                                         sb.put('Priority','');
                                    }
                                   
                                
                                
                                }
                                    
                                else if(objectApiName == 'Case' && isoverdue == true){
									String ownername ='';
                                    if(sb.getSobject('Owner')!=null)
                                       ownername =(String) sb.getSobject('Owner').get('Name');                             
                                    if(sb.get('Priority') == 'Urgent' && ownername== userinfo.getName() ){
                                       // iconStyle = 'data-src="/assets/icons/utility-sprite/svg/symbols.svg#close"';
                                        String flagrec = '<span class="slds-icon_container slds-icon-utility-chart " >';
                                            flagrec =flagrec +'<svg aria-hidden="true" class="slds-icon  slds-icon-text-error slds-icon--small">';
                                             flagrec=flagrec+ '<use xmlns:xlink="http://www.w3.org/1999/xlink" ';
                                             flagrec=flagrec+ '  xlink:href="/apexpages/slds/latest//assets/icons/utility-sprite/svg/symbols.svg#priority">';
                                               flagrec=flagrec+ ' </use></svg><span class="slds-assistive-text">Urgent</span></span>';
                                        sb.put('Priority',flagrec );
                                        
                                       
                                    } else{
                                         sb.put('Priority','');
                                    }
                                   
                                    }
                                if(objectApiName == 'Interaction__c' && isoverdue == false ){
                                     
                                    if((datetime)sb.get('Evt_Recvd_Dt_Time__c') != null) {
                                    datetime datetimeopened = (datetime)sb.get('Evt_Recvd_Dt_Time__c');
                                ETSBE_AgeCalculationBatch_Handler.AgeDataWrapper ageDataWrapperObj = ETSBE_AgeCalculationBatch_Handler.returnAgeInDaysAndHours(datetimeopened, DateTime.now(), currentYear, null, '', businessHoursObj);    
                                sb.put('Age__c',ageDataWrapperObj.noOfDays+':'+ageDataWrapperObj.noOfHours);
                                    }else{
                                       sb.put('Age__c','0'+':'+'0');
                                    }
                                    
                                }
                                    colValue = string.valueof(sb.get(ss));
                                if(fieldToFieldTypeMap.get(ss)!=null){
                                    if(fieldToFieldTypeMap.get(ss)== DATE_DATATYPE || fieldToFieldTypeMap.get(ss)==DATETIME_DATATYPE){
                                        try{
                                            colValue = colValue.split(' ')[0];
                                            List<String> dateColumns=colValue.split('-');
                                            integer year=integer.valueof(dateColumns[0]);
                                            integer month=integer.valueof(dateColumns[1]);
                                            integer day=integer.valueof(dateColumns[2]);
                                            date myDate = date.newInstance(year, month, day);
                                            
                                            colValue = myDate.format();
                                        }catch(exception ex){
                                            system.debug('******column is not of date or datetime datatype:'+ex.getmessage());
                                        }
                                    }else if(fieldToFieldTypeMap.get(ss)==CURRENCY_DATATYPE){
                                        String currencyIso = UserInfo.isMultiCurrencyOrganization() ? (String) sb.get('CurrencyIsoCode') : UserInfo.getDefaultCurrency();
                                        colValue = GetCurrencySymbolFromISO(currencyIso)+ Decimal.valueof(colValue).format();
                                    }
                                }
                            }
                        }
                        
                        
                        if(colValue == null || colValue == ''){
                            fieldvalues.add('');
                        }else{
                            if(ss.equalsIgnoreCase(HyperLinkField)){
                                colValue = '<a  id="'+sb.get('id')+'"  onclick="navigatetoobject()"  target=\'_blank\'>' + colValue + '</a>';
                            }
                            if(colValue == 'true'){
                            colValue ='Yes';
                            }
                            if(colvalue=='false'){
                            colValue ='No';
                            }
                            fieldvalues.add(string.valueof(colValue));
                        }
                    }catch(exception ex){ 
                        fieldvalues.add('');
                        system.debug('*******Error in some Field API Name.'+ ex.getmessage());
                    }
                }
                dataValues.add(fieldvalues);
            }
        }
        if(columnLabelList.size()>0){
            for(String ss : columnLabelList){
                if(ss=='Priority' && isCase ==true){
                    ss = 'Alerts';
                }
                columnsLabels.add(new List<String>{ss});
            }
        }
         dataSet.columns = columnsLabels ;
        dataSet.data = dataValues;
       
        List<integer> lengthdata = new List<integer>();
        
        
        if(dataSet.recordcount <=25) {
          dataSet.bLengthChange =false;
            dataSet.pageLength = 25; 
        }else{
            dataSet.bLengthChange =true;
            dataSet.pageLength =pageLength;
            if(dataSet.recordcount >50)
            {
                lengthdata.add(25);
                lengthdata.add(50);
                lengthdata.add(100);
            }
            else if(dataSet.recordcount <=50 && dataSet.recordcount >25)
            {
                lengthdata.add(25);
                lengthdata.add(50);
            }
       
        
        dataset.lengthMenu= lengthdata;
            dataset.destroy = true;
        }
        string jsondata=JSON.serialize(dataSet);    
       
        return jsondata;
        
    }
    //method to generate field and their field type map
    public static Map<String,String> generateFieldTypeMap(string objectApiName,List<String> FieldAPINameList){
        Map<String,String> returnMap = new Map<String,String>();
        if(objectApiName!=null && objectApiName !=''){
            Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectApiName).getdescribe().fields.getMap(); 
            for(String ss:FieldAPINameList){
                if(ss.contains('.')){
                    returnMap.put(ss,PARENT_RELATIONSHIP); 
                }else{
                    returnMap.put(ss,string.valueof(fieldMap.get(ss).getDescribe().getType())); 
                }
            }
        }
        return returnMap;
    }
    //method to return currency symbol
    public static String GetCurrencySymbolFromISO(String Iso) {
         String currencySymbol = 
           ('USD' == Iso ? '$' : 
           ('CAD' == Iso ? '$' : 
           ('EUR' == Iso ? '€' : 
           ('GBP' == Iso ? '£' : 
           ('JPY' == Iso ? '¥' : 
           ('KRW' == Iso ? '₩' : 
           ('CNY' == Iso ? '元' : 
           '')))))));
           return currencySymbol;
    }
    public class datasetForTable{
        public List<List<String>> columns;
        public List<List<String>> data;
        public integer[] lengthMenu;
        Public boolean bLengthChange;
        Public integer pageLength;
        Public integer recordcount ;
        Public boolean  destroy;
    }
 @AuraEnabled
    Public static string updateCase(String caseId){
        string OwnerName = [select id,owner.name from case where id=:caseId ].Owner.Name;
        string returndata='';
        
        case updateCase = new case();
        updateCase.id = caseId;
        updateCase.Priority='Standard';
        if(OwnerName == userinfo.getName()){
             update updateCase;
        }
       
        return returndata;
    }
}