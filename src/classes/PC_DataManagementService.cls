/**
 * @name         :  PC_DataManagementService
 * @description  :  This class will be responsible for handling opreation in IntakeService.
 * @author       :  Bhanu Jain
 * @createddate  :  9/17/2018
 **/
public with sharing class PC_DataManagementService {

    /**
     * @name         :   insertData
     * @description  :   This Method will insert data recieved from the webservice requester
     * @param        :   SourceSystemInfo__mdt sourceSysInfoMDT,
                         List<Field_Mapping__mdt> fieldMappings,
                         Map<String, Object> dataSet,
                         JSONContextParser parser
     * @return       :   List<SObject>
     * @author       :  Bhanu Jain
     * @createddate  :  9/17/2018
     * @lastmodifiedby:  
     **/ 
    public static Map<Database.SaveResult, Sobject> insertData(SourceSystemInfo__mdt sourceSysInfoMDT,
            List<Field_Mapping__mdt> fieldMappings,
            Map<String, Object> dataSet,
            JSONContextParser parser) {  
        List<SObject> fullListOfSObjectInSeq = new List<SObject>();
        list<Object> attach = new list<Object>();  
        list<SObject> claimsObjLst = new list<SObject>();
              
        Map<Database.SaveResult, Sobject> srVsSobjMap = new Map<Database.SaveResult, Sobject>();
        for(String instance : dataSet.keySet()) {
            Map<String, Object> dataInstance = (Map<String, Object>)dataSet.get(instance);
            Map<String, Object> dataInstanceAtt  = new Map<String, Object>();
            Map<String, Object> dataInstanceClaims  = new Map<String, Object>();
              
              //This is to get array of attachments from the request to a list
              for(Object instanceAtt : dataInstance.keySet()) {
                 if(String.ValueOf(instanceAtt)  == 'Attachments'){  
                    system.debug('###'+dataInstance.get(String.Valueof(instanceAtt)));
                    dataInstanceAtt = (Map<String, Object>)dataInstance.get(String.ValueOf(instanceAtt) );
                    if(!dataInstanceAtt.values().isEmpty() ){
                        for(Object instanceAttins : dataInstanceAtt.values()) {
                            system.debug('###'+instanceAttins );
                            attach.add(instanceAttins);
                        }
                    }
                  }
                  if(String.ValueOf(instanceAtt)  == 'ClaimsData'){
                    system.debug('### claims -->'+dataInstance.get(String.Valueof(instanceAtt)));
                    dataInstanceClaims = (Map<String, Object>)dataInstance.get(String.ValueOf(instanceAtt) );
                    System.debug('### dataInstanceClaims -->'+ dataInstanceClaims);
                    if(!dataInstanceClaims.values().isEmpty() ){
                        for(Object instanceClaims : dataInstanceClaims.values()) {
                            system.debug('### instanceClaims'+instanceClaims );
                            String stringClaims = JSON.serialize(instanceClaims);
                            Map<String, Object> claimsRec = (Map<String, Object>)JSON.deserializeUntyped(stringClaims);
                            system.debug('### claimsRec'+claimsRec );  
                            sObject claimRecObj = getClaimsObjectList(sourceSysInfoMDT, fieldMappings, claimsRec ,parser); 
                            claimsObjLst.add(claimRecObj);                 
                        }
                    }
                  }
               }    
                
             Map<String,Map<String,Sobject>> sobjectMaps = getSobjectMaps(sourceSysInfoMDT, fieldMappings, dataInstance ,parser);
            if(claimsObjLst.size()>0){
                Map<String,Sobject> sMap = sobjectMaps.get('SOBJECT');
                sMap.get('Case').put('CPU_Processing_Status__c','Case Items Created');
            }
            system.debug('!!!!sobjectMaps insertdata'+sobjectMaps );
            
            List<SObject> sobjListPerItr = getSobjectListToInsert(sobjectMaps , sourceSysInfoMDT.Id);
            fullListOfSObjectInSeq.addAll(sobjListPerItr);
        }
        system.debug('fullListOfSObjectInSeq >> '+fullListOfSObjectInSeq);
        system.debug('###attach before insert'+attach);
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.allowFieldTruncation = true;
        dmo.optAllOrNone = false;
        Database.SaveResult[] srList = Database.insert(fullListOfSObjectInSeq, false);
        system.debug('done succesfully');
        for(Integer index = 0 ; index < fullListOfSObjectInSeq.size(); index ++) {
            srVsSobjMap.put(srList.get(index), fullListOfSObjectInSeq.get(index) );
            
        }
        system.debug('srVsSobjMap---->'+srVsSobjMap);
        ID caseParentId;
        if(srList!= null){
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess() && String.ValueOf(sr.getId()).startsWith('500')) {
                    System.debug('###Successfully inserted Case' + sr.getId());
                    caseParentId = sr.getId();
                }
            }
        }
        system.debug('### caseId'+caseParentId );
        if(!claimsObjLst.isEmpty() && caseParentId != null){
            List<SObject> caseItemLst = new List<SObject>();
            for(SObject claim: claimsObjLst){
                claim.put('Case__c',caseParentId);              
                caseItemLst.add(claim);
            }

            Database.DMLOptions dmo1 = new Database.DMLOptions();
            dmo1.allowFieldTruncation = true;
            dmo1.optAllOrNone = false;
            Database.SaveResult[] srList1 = Database.insert(caseItemLst, false);

            if(srList!= null){
                for (Database.SaveResult sr : srList1) {
                    if (sr.isSuccess() && String.ValueOf(sr.getId()).startsWith('500')) {
                        System.debug('###Successfully inserted Case Item' + sr.getId());              
                    }
                }
            }
        }

        if(!attach.isEmpty() && caseParentId != null)
        {
            system.debug('###Inside attachment logic');
            Integer index = 0;
            List<ContentVersion> conVerList = new List<ContentVersion>();
                
            for(Object obj: attach){
                system.debug('###obj'+obj);
                Map<String, Object> a2 =(Map<String, Object>)attach[index];
                system.debug('###'+a2);
                system.debug('###body'+a2.get('Body'));
                system.debug('###name'+a2.get('Name'));
                
                ContentVersion conVer = new ContentVersion();
                conVer.PathOnClient = String.ValueOf(a2.get('Name')) ; // The files name, extension is very important here which will help the file in preview.
                conVer.Title = String.ValueOf(a2.get('Name')).substringBeforeLast('.'); // Display name of the files
                conVer.VersionData = EncodingUtil.base64Decode(String.ValueOf(a2.get('Body'))); // converting your binary string to Blob
                converList.add(conVer);
                index++;
                
            }
            if(!converList.isEmpty())
            {
                
                Database.SaveResult[] docList = Database.insert(converList);
                Set<Id> verIds = new Set<Id>(); 
                system.debug('###docList '+docList );
                    
                for (Database.SaveResult doc: docList )
                {
                    verIds.add(doc.getId());
                }
                system.debug('###verIds'+verIds);
                
                List<ContentDocumentLink> cdllist = new List<ContentDocumentLink>();
                
                for(ContentVersion cv: [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id in: verIds]){
                    ContentDocumentLink cdl = new ContentDocumentLink();
                    cdl.ContentDocumentId = cv.ContentDocumentId;
                    cdl.LinkedEntityId = caseParentId ;
                    cdl.ShareType = 'V';
                    cdllist.add(cdl);
                }
                system.debug('###cdllist'+cdllist);
                Database.SaveResult[] docLinkList = Database.insert(cdllist);
            }
        }
        
        system.debug('@@@srVsSobjMap'+srVsSobjMap);
        return srVsSobjMap;
    }
   
    
    /**
     * @name         :   insertSobjects
     * @description  :   This Method will insert data recieved from the webservice requester
     * @param        :   List<SObject> sobjectList
     * @return       :   Database.SaveResult[]
     * @author       :  Bhanu Jain
     * @createddate  :  9/17/2018
     * @lastmodifiedby:  
     **/ 
    public static Database.SaveResult[] insertSobjects(List<SObject> sobjectList) {
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.allowFieldTruncation = true;
        dmo.optAllOrNone = false;
        Database.SaveResult[] srList = Database.insert(sobjectList, false);
        return srList;

    }   
    /**
     * @name         :   getSobjectListToInsert
     * @description  :   This Method will prepare list of SObject hierarchy to insert;
     * @param        :   Map<String,Map<String,Sobject>> sobjectMaps
     *                   String sourceSystemInfoId
     * @return       :   List<SObject>
     * @author       :  Bhanu Jain
     * @createddate  :  9/17/2018
     * @lastmodifiedby:  
     **/  
    private static List<SObject> getSobjectListToInsert(Map<String,Map<String,Sobject>> sobjectMaps,  String sourceSystemInfoId) {
        Map<String,Sobject> sMap = sobjectMaps.get('SOBJECT');
        Map<String,Sobject> rMap = sobjectMaps.get('REFERENCE');
        system.debug('sMap----->'+sMap);
        system.debug('rMap----->'+rMap);
        Map<Integer, List<String>> sobjectHierarchyMap = getHierarchyLevelOfSobjectMap(sourceSystemInfoId);
        Map<String,List<String>> childToParentMap = getChildToParentMap(sourceSystemInfoId);
        
        Map<String,Map<String,String>> childToParentsMap = getChildToParentsMap(sourceSystemInfoId);
        for(Integer level = 0; level < sobjectHierarchyMap.size(); level++ ) {
            String externalId = String.valueOf(System.Now());
            List<String> sobjectApis = sobjectHierarchyMap.get(level);
            system.debug('sobjectApis----->'+sobjectApis);
            //if(level == 0) {
            for(Integer i = 0; i< sobjectApis.size(); i++) {
                try {
                    //If the SOBJEXT field not here than either it is not created or we cant create.
                    //This exception should we handled for those SOBJECT where we cant create this field
                    externalId = String.valueOf(System.Now());
                    system.debug('sMap.get(sobjectApis.get(i))----->'+sMap.get(sobjectApis.get(i)));
                    system.debug('rMap.get(sobjectApis.get(i))----->'+rMap.get(sobjectApis.get(i)));
                    if(null!=sMap.get(sobjectApis.get(i)))
                    sMap.get(sobjectApis.get(i)).put('SOBJEXT__c',externalId);
                    if(null!=rMap.get(sobjectApis.get(i)))
                    rMap.get(sobjectApis.get(i)).put('SOBJEXT__c',externalId);
                    
                }catch(System.SObjectException e) {
                    system.debug(' >> '+ e.getMessage());
                }               
            }
               
            //}
            system.debug('sMap >> '+sMap);
            system.debug('rMap >> '+rMap);
            if(level != 0) {
                for(String sobjectApi : sobjectApis) {
                    if(childToParentMap.containsKey(sobjectApi)) { //means current sobject have parent
                        //who is the parent
                        //this map will content only one element i.e. record of only parent
                        //key will be look up field to parent
                        //value will be parent api
                        String parentLookUpFieldApi = childToParentMap.get(sobjectApi).get(0);//0th element parentLookUpFieldApi
                        String parentApi = childToParentMap.get(sobjectApi).get(1);//1st element parentApi
                        system.debug('parentApi >> at level '+level +' is '+parentApi);
                        system.debug('parentLookUpFieldApi >> at level '+level +' is '+parentLookUpFieldApi);
                        //now check this parent at level-1 sobjectapis list
                        for(String sobjApiNameAtBelowLevel : sobjectHierarchyMap.get(level - 1)) {
                            if(sobjApiNameAtBelowLevel == parentApi) {
                                //sMap.get(sobjectApi).put(parentApi.replace('__c', '__r'),rMap.get(parentApi)); // put here parent refrence sobject
                                system.debug('sobjectApi >> '+sobjectApi);
                                if(parentLookUpFieldApi.endsWith('Id')) {
                                    parentLookUpFieldApi = parentLookUpFieldApi.subString(0,parentLookUpFieldApi.length() - 2);
                                }
                                system.debug('parentLookUpFieldApi >> '+parentLookUpFieldApi);
                                system.debug(sMap.get(sobjectApi));
                                system.debug(parentLookUpFieldApi.replace('__c', '__r'));
                                system.debug(rMap.get(parentApi));

                                sMap.get(sobjectApi).putSObject(parentLookUpFieldApi.replace('__c', '__r'),rMap.get(parentApi));
                                //sMap.get(sobjectApi).putSObject('Case__r',rMap.get(parentApi));
                                try {
                                    //If the SOBJEXT field not here than either it is not created or we cant create.
                                    //This exception should we handled for those SOBJECT where we cant create this field
                                    //externalId = String.valueOf(System.Now());
                                    sMap.get(sobjectApi).put('SOBJEXT__c',externalId);
                                    rMap.get(sobjectApi).put('SOBJEXT__c',externalId);
                                    
                                }catch(System.SObjectException e) {
                                    system.debug(' >> '+ e.getMessage());
                                }

                            }
                        }
                    }
                }               
            }
        }
        system.debug('sMap >> '+sMap);
        system.debug('sobjectHierarchyMap >> '+sobjectHierarchyMap);
        //here we have final sMap to insert
        List<SObject> sobjToInsert = new List<SObject>();
        for(Integer level = 0; level < sobjectHierarchyMap.size(); level++ ) {
            for(String sobjApi : sobjectHierarchyMap.get(level)) {
                if(null!=sMap.get(sobjApi))
                sobjToInsert.add(sMap.get(sobjApi));
            }
        }
        system.debug('getSobjectListToInsert ends '+sobjToInsert);

        return sobjToInsert;
    }

    /*********************************************************************************************************
     * @name			getClaimsObjectList
     * @author			mrajen15 <muthukumarr@optum.com>
     * @created			28 / 04 / 2021
     * @description		This Method will prepare sobjects from the recieved data.
     * @param			SourceSystemInfo__mdt sourceSysInfoMDT,
                         List<Field_Mapping__mdt> fieldMappings,
                         Map<String, Object> dataSet,
                         JSONContextParser parser
     * @return			List<SObject>
    **********************************************************************************************************/

    private static SObject getClaimsObjectList(SourceSystemInfo__mdt sourceSysInfoMDT,
            List<Field_Mapping__mdt> fieldMappings,
            Map<String, Object> dataInstance,
            JSONContextParser parser){
                //Test 123
        Map<String,Sobject> sobjectToInsertMap = new Map<String,Sobject>();

        for(Field_Mapping__mdt fm : fieldMappings){
            system.debug('fm.field_api_name__c >> '+fm.field_api_name__c);
            if(fm.Type__c == 'Inbound' && fm.SObject_Api__c =='Case_Item__c') {
                String sObjectApi = fm.SObject_Api__c;
                
                if(!sobjectToInsertMap.containsKey(sObjectApi)){
                    sobjectToInsertMap.put(sObjectApi,Schema.getGlobalDescribe().get(sObjectApi).newSObject());
                    String recordTypeId = getRecordTypeId(sourceSysInfoMDT.Id,sObjectApi);
                    if(!PC_Util.isEmpty(recordTypeId)) {
                        sobjectToInsertMap.get(sObjectApi).put('RecordTypeId',recordTypeId);
                        
                    }
                }
                sobjectToInsertMap = processFieldMapping(fm,sobjectToInsertMap,dataInstance,parser,sObjectApi);
            }
        }
        return sobjectToInsertMap.get('Case_Item__c');
    }

    private static Map<String,Sobject> processFieldMapping(Field_Mapping__mdt fm,
                                                                              Map<String,Sobject> sobjectToInsertMap,
                                                                              Map<String, Object> dataInstance,
                                                                              JSONContextParser parser,
                                                                              String sObjectApi){
                String fieldApi = fm.field_api_name__c;
                String fieldValue = (String)parser.getValue(fm.json_tag__c, dataInstance);
                
                if(PC_Util.isEmpty(fieldValue) && fm.is_Required__c){
                    throw new RequiredFieldMissingException(fm.json_tag__c);
                }

                String transformedFieldValue;
                if(fm.Type__c == 'Inbound' && fm.is_active__c) {
                    if (!PC_Util.isEmpty(fieldValue)) {
                        transformedFieldValue = PC_DataTranformer.transform(fm,fieldValue);
                        transformedFieldValue = PC_TransformedValueHelper.updateValue(transformedFieldValue);                        
                    }
                    
                    //Apply Business rules for field value
                    String businessVal = PC_BusinessRulesUtil.getValue(fieldApi , dataInstance , parser);
                    Object datatypeConvertedValue;
                    if(!PC_Util.isEmpty(businessVal)) {
                        if (businessVal != 'BLANK') {
                            datatypeConvertedValue = PC_DataTypeConverter.convert(fm,businessVal); 
                        } else {
                            datatypeConvertedValue = null; 
                        }
                    }else {
                        datatypeConvertedValue = PC_DataTypeConverter.convert(fm,transformedFieldValue); 
                    }
                    sobjectToInsertMap.get(sObjectApi).put(fieldApi,datatypeConvertedValue);    
                }
                return sobjectToInsertMap;
    }

    /**
     * @name         :   getSobjectMaps
     * @description  :   This Method will prepare sobjects from the recieved data.
     * @param        :   SourceSystemInfo__mdt sourceSysInfoMDT,
                         List<Field_Mapping__mdt> fieldMappings,
                         Map<String, Object> dataSet,
                         JSONContextParser parser
     * @return       :   List<SObject>
     * @author       :  Bhanu Jain
     * @createddate  :  9/17/2018
     * @lastmodifiedby:  
     **/    

    private static Map<String,Map<String,Sobject>>  getSobjectMaps(SourceSystemInfo__mdt sourceSysInfoMDT,
            List<Field_Mapping__mdt> fieldMappings,
            Map<String, Object> dataInstance,
            JSONContextParser parser){
        Map<String,Map<String,Sobject>> sobjectMaps = new Map<String,Map<String,Sobject>>();
        Map<String,Sobject> sobjectToInsertMap = new Map<String,Sobject>(); 
        Map<String,Sobject> sobjectToRefMap = new Map<String,Sobject>();
        
        for(Field_Mapping__mdt fm : fieldMappings){
            system.debug('fm.field_api_name__c >> '+fm.field_api_name__c);
            if(fm.Type__c == 'Inbound') {
                String sObjectApi = fm.SObject_Api__c;
                
                if(!sobjectToInsertMap.containsKey(sObjectApi)){
                    sobjectToInsertMap.put(sObjectApi,Schema.getGlobalDescribe().get(sObjectApi).newSObject());
                    String recordTypeId = getRecordTypeId(sourceSysInfoMDT.Id,sObjectApi);
                    if(!PC_Util.isEmpty(recordTypeId)) {
                        sobjectToInsertMap.get(sObjectApi).put('RecordTypeId',recordTypeId);
                    }
                    //below map contains reference sobject for each sobject with externalid field populated 
                    sobjectToRefMap.put(sobjectApi,Schema.getGlobalDescribe().get(sobjectApi).newSObject());
                }
                String fieldApi = fm.field_api_name__c;
                String fieldValue = (String)parser.getValue(fm.json_tag__c, dataInstance);
                
                if(PC_Util.isEmpty(fieldValue) && fm.is_Required__c){
                    throw new RequiredFieldMissingException(fm.json_tag__c);
                }
                String transformedFieldValue;
                if(fm.Type__c == 'Inbound' && fm.is_active__c) {
                    if (!PC_Util.isEmpty(fieldValue)) {
                        transformedFieldValue = PC_DataTranformer.transform(fm,fieldValue);
                        transformedFieldValue = PC_TransformedValueHelper.updateValue(transformedFieldValue);
                        
                        if (fm.Field_Api_Name__c == 'PC_Provider_State__c' && fieldValue.contains(';')) {
                            String referalId = (String) parser.getValue('Case__r.CaseNumber', dataInstance);
                            PC_TransformedValueHelper.caseFieldValueMap.put(referalId, fieldValue);
                        }
                    }
                    
                    //Apply Business rules for field value
                    String businessVal = PC_BusinessRulesUtil.getValue(fieldApi , dataInstance , parser);
                    Object datatypeConvertedValue;
                    if(!PC_Util.isEmpty(businessVal)) {
                        if (businessVal != 'BLANK') {
                            datatypeConvertedValue = PC_DataTypeConverter.convert(fm,businessVal); 
                        } else {
                            datatypeConvertedValue = null; 
                        }
                    }else {
                        datatypeConvertedValue = PC_DataTypeConverter.convert(fm,transformedFieldValue); 
                    }
                    sobjectToInsertMap.get(sObjectApi).put(fieldApi,datatypeConvertedValue);    
                }
            }
        }
        
        // Below method populates multiple state info in Issue Description under Project Submission
        for (String sobjApiname : sobjectToInsertMap.keySet()) {
            if (sobjApiname.equalsIgnoreCase('Project_Submission_Detail__c')) {
                String refId = (String) sobjectToInsertMap.get('Project_Submission_Detail__c').get('Referral_ID__c');
                if (refId != null && PC_TransformedValueHelper.caseFieldValueMap.containsKey(refId)) {
                    String existingVal = (sobjectToInsertMap.get('Project_Submission_Detail__c').get('Issue_Description__c') != null ?
                                          (String) sobjectToInsertMap.get('Project_Submission_Detail__c').get('Issue_Description__c') :
                                          '');
                    String mergedDesc = existingVal + '\n' + PC_TransformedValueHelper.caseFieldValueMap.get(refId);
                    mergedDesc = (mergedDesc.length() > 2500 ? mergedDesc.left(2500) : mergedDesc);
                    sobjectToInsertMap.get('Project_Submission_Detail__c').put('Issue_Description__c', mergedDesc);
                }
            } else if (sobjApiname.equalsIgnoreCase('Case')) {
                Object contactType = sobjectToInsertMap.get('Case').get('PC_Contact_Type__c');
                if (contactType != null && ((String) contactType).equalsIgnoreCase('Internal')) {
                    sobjectToInsertMap.get('Case').put('PC_External_Contact_Email__c', null);
                    sobjectToInsertMap.get('Case').put('PC_External_Contact_Name__c', null);
                    sobjectToInsertMap.get('Case').put('PC_External_Contact_Phone__c', null);
                }
            }
        }
        
        //This map will contain sobject with all fields populated from json
        sobjectMaps.put('SOBJECT',sobjectToInsertMap);
        sobjectMaps.put('REFERENCE',sobjectToRefMap);
        system.debug('sobjectMaps >> '+sobjectMaps);
        return sobjectMaps;
    }

    /**
     * @name         :   getHierarchyLevelOfSobjectMap
     * @description  :   Prepare map for maintaining hierarchy level of sobjects.
     * @param        :   SourceSystemInfo__mdt sourceSysInfoMDT,
     * @return       :   Map<Integer, List<String>>
     * @author       :   Bhanu Jain
     * @createddate  :   9/17/2018
     * @lastmodifiedby:  
     **/ 
    private static Map<Integer, List<String>> getHierarchyLevelOfSobjectMap(String sourceSystemInfoId){
        List<SObject_Hierarchy__mdt> sobjectHierarchys = [Select sobject_Api__c, level__c, parent_Api__c, SourceSystemInfo__c from SObject_Hierarchy__mdt
                                                          where SourceSystemInfo__c =: sourceSystemInfoId];
        Map<Integer, Set<String>> sobjectHierarchyMap = new Map<Integer, Set<String>>();

        for(SObject_Hierarchy__mdt sh : sobjectHierarchys){
            if(!sobjectHierarchyMap.containsKey(Integer.valueOf(sh.level__c))){
                sobjectHierarchyMap.put(Integer.valueOf(sh.level__c),new Set<String>());
            }
            sobjectHierarchyMap.get(Integer.valueOf(sh.level__c)).add(sh.sobject_Api__c); 
        }
        
        Map<Integer, List<String>> sobjectHierarchyListMap = new Map<Integer, List<String>>();
        for(Integer level : sobjectHierarchyMap.keySet()) {
            List<String> uniqueApiAtLevel = new List<String>();
            uniqueApiAtLevel.addAll(sobjectHierarchyMap.get(level));
            sobjectHierarchyListMap.put(level, uniqueApiAtLevel);
        }
        system.debug('sobjectHierarchyListMap--->'+sobjectHierarchyListMap);
        return sobjectHierarchyListMap;
    }

    /**
     * @name         :   getChildToParentMap
     * @description  :   Prepare a child to map its parent
     * @param        :   SourceSystemInfo__mdt sourceSysInfoMDT,
     * @return       :   Map<Integer, List<String>>
     * @author       :   Bhanu Jain
     * @createddate  :   9/17/2018
     * @lastmodifiedby:  
     **/    
    private static Map<String,List<String>> getChildToParentMap(String sourceSystemInfoId){
        Map<String,List<String>> childToParentMap = new Map<String,List<String>>();
        List<SObject_Hierarchy__mdt> sobjectHierarchys = [Select Sobject_Api__c, level__c, parent_Api__c, Lookup_Field_Api__c, SourceSystemInfo__c from SObject_Hierarchy__mdt
                                                          where SourceSystemInfo__c =: sourceSystemInfoId];
        for(SObject_Hierarchy__mdt sh : sobjectHierarchys){
            if(!PC_Util.isEmpty(sh.parent_Api__c)) {
                childToParentMap.put(sh.sobject_Api__c, new List<String>());
                childToParentMap.get(sh.sobject_Api__c).add(sh.Lookup_Field_Api__c);
                childToParentMap.get(sh.sobject_Api__c).add(sh.parent_Api__c);
            }
        }
        return childToParentMap;
    }
    /**
     * @name         :   getChildToParentsMap
     * @description  :   Prepare a child to map its parent
     * @param        :   SourceSystemInfo__mdt sourceSysInfoMDT,
     * @return       :   Map<Integer, List<String>>
     * @author       :   Bhanu Jain
     * @createddate  :   9/17/2018
     * @lastmodifiedby:  
     **/    
    public static Map<String,Map<String,String>> getChildToParentsMap(String sourceSystemInfoId){
        Map<String,Map<String,String>> childToParentMap = new Map<String,Map<String,String>>();
        List<SObject_Hierarchy__mdt> sobjectHierarchys = [Select Sobject_Api__c, level__c, parent_Api__c, Lookup_Field_Api__c, SourceSystemInfo__c from SObject_Hierarchy__mdt
                                                          where SourceSystemInfo__c =: sourceSystemInfoId];
        for(SObject_Hierarchy__mdt sh : sobjectHierarchys){
            if(!PC_Util.isEmpty(sh.parent_Api__c)) {
                if(! childToParentMap.containsKey(sh.sobject_Api__c)) {
                    childToParentMap.put(sh.sobject_Api__c,new Map<String,String>());
                }
                childToParentMap.get(sh.sobject_Api__c).put(sh.Lookup_Field_Api__c,sh.parent_Api__c);
            }
        }
        system.debug('childToParentsMap >> '+childToParentMap);
        return childToParentMap;
    }   
    /**
     * @name         :   getRecordTypeId
     * @description  :   return record type id of the sobject
     * @param        :   SourceSystemInfo__mdt sourceSysInfoMDT,
     * @return       :   Map<Integer, List<String>>
     * @author       :   Bhanu Jain
     * @createddate  :   9/17/2018
     * @lastmodifiedby:  
     **/    
    private static String getRecordTypeId(String sourceSystemInfoId, String sobjectApi){
        String recTypeId;
        List<SObject_Hierarchy__mdt> sobjectHierarchys = [Select Sobject_Api__c, Record_type_Name__c from SObject_Hierarchy__mdt 
                                                          where SourceSystemInfo__c =: sourceSystemInfoId];
        for(SObject_Hierarchy__mdt sh : sobjectHierarchys){
            if(sobjectApi == sh.Sobject_Api__c) {
                if(!PC_Util.isEmpty(sh.Record_type_Name__c)) {
                    recTypeId =  Schema.getGlobalDescribe().get(sObjectApi).getDescribe().getRecordTypeInfosByName().get(sh.Record_type_Name__c).getRecordTypeId();
                }

            }
        }
        return recTypeId;
    }   
}