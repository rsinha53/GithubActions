public without sharing class CDB_ACETWebservice {
    public static Boolean CHNEligible;
    public static Boolean CHNQualified;
    public static Map<String, WebserviceConfigurations__c> mapNameToWebservice = new Map<String, WebserviceConfigurations__c>();
    public static String token = '';
    public static boolean IsSandbox;
    public static String workOId;
    public static ACETSNILinkMemberSearch.SearchResultWrapper srWrapper = new ACETSNILinkMemberSearch.SearchResultWrapper();
    public static List<CDB_Application_Log__c> cdbLogList = new List<CDB_Application_Log__c>();
    public static List<Application_Error_Log__c> appLogList = new List<Application_Error_Log__c>();
    
    public static ACETSNILinkMemberSearch.SearchResultWrapper getCDBData(String memberId,String memberDOB,String firstName, String lastName, String groupNumber, String searchOption, String woId){
        ACETHouseHoldWrapper houseHoldW = new ACETHouseHoldWrapper();
        //ACETSNILinkMemberSearch.SearchResultWrapper srWrapper = new ACETSNILinkMemberSearch.SearchResultWrapper();
        workOId = woId;
        system.debug('woId'+woId);
        try {
            Organization objorg = [SELECT IsSandbox FROM Organization LIMIT 1];
            IsSandbox = objorg.IsSandbox;
            string qryStr = '%CDB%';
            
            List<WebserviceConfigurations__c> WsObj = [SELECT Id, Name, AuthorizationToken__c, EndpointPath__c, Headers__c, 
                                                       JSONBodyWithMergeFields__c, Method__c, Timeout__c, E400__c, E401__c, 
                                                       E500__c, TokenAPI__r.Name, TokenAPI__r.IsCachedToken__c, Handle_Unauthorized__c 
                                                       FROM WebserviceConfigurations__c Where Name LIKE : qrystr and active__c = true];
            
            //Creating map of Webservice Configuration Name and its record
            //Map<String, WebserviceConfigurations__c> mapNameToWebservice = new Map<String, WebserviceConfigurations__c>();
            for (WebserviceConfigurations__c wsc : WsObj) {
                if (!mapNameToWebservice.containsKey(wsc.Name)) {
                    mapNameToWebservice.put(wsc.Name, wsc);
                }
            }
            
            HTTPResponse HttpRes1 = getAccessToken(IsSandbox, mapNameToWebservice); //access token API call
            if(HttpRes1!= null) {
                //String token = '';
                if(HttpRes1.getStatusCode() == 200){
                    Map<String, Object> result1 = (Map<String, Object>)JSON.deserializeUntyped(HttpRes1.getBody());
                    token = (String)result1.get('access_token');
                    HTTPResponse HttpRes2=getUserInfoWithDOB(IsSandbox,mapNameToWebservice, token,memberId, memberDOB,firstName,LastName); //Identifier API call
                    if(HttpRes2 != null){
                        if(HttpRes2.getStatusCode() == 200){
                            String apiIdentifier;
                            Object resp2 = JSON.deserializeUntyped(HttpRes2.getBody());
                            system.debug('resp2:::' + resp2);
                            List<Object> responseLst = (List<Object>)resp2;
                            if(responseLst.size()>1){
                                srWrapper.multlpleEntriesFound = true;
                            }else{
                                srWrapper.multlpleEntriesFound = false;
                            }
                            srWrapper.recordsFoundInCDB = responseLst;
                            for (Object ob : responseLst) {
                                Map<String, Object> obMap = (Map<String, Object>)ob;
                                apiIdentifier = string.valueOf(obMap.get('apiIdentifier'));
                            } 
                            if(srWrapper.multlpleEntriesFound == true){
                                srWrapper.IsSandbox = IsSandbox;
                                srWrapper.mapNameToWebservice = mapNameToWebservice;
                                srWrapper.token = token;
                                srWrapper.woId = woId;
                                //srWrapper.CHNEligible = CHNEligible;
                                //srWrapper.CHNQualified = CHNQualified!=''?true:false;
                                //srWrapper.referralIdentifier = CHNQualified;
                                return srWrapper;
                            }else{
                                setWrapperData(apiIdentifier,IsSandbox,mapNameToWebservice,token,woId, memberId);
                            }
                        } else if (HttpRes2.getStatusCode() == 404) {
                            srWrapper.statusCode = HttpRes2.getStatusCode();    
                        }else {
                            //error
                            srWrapper.statusCode = HttpRes2.getStatusCode();
                            Map<String, Object> Errresult2;
                            if(HttpRes2.getBody()!=NULL && HttpRes2.getBody()!= ''){
                                Errresult2 = (Map<String, Object>)JSON.deserializeUntyped(HttpRes2.getBody());
                                srWrapper.message = (String)Errresult2.get('message');
                            }   
                        }
                    }
                } else {
                    //error
                    srWrapper.statusCode = HttpRes1.getStatusCode();
                    if(HttpRes1.getBody() != null && HttpRes1.getBody()!= ''){
                        Map<String, Object> Errresult3 = (Map<String, Object>)JSON.deserializeUntyped(HttpRes1.getBody());
                        srWrapper.message = (String)Errresult3.get('message');
                    }                    
                }
            }
            
        }catch(Exception e){
            System.debug('Exception happened:'+e);
            system.debug(e.getStackTraceString());
            srWrapper.Message = ACETUtility.getErrorMessage('GN500');
            //srWrapper.Message = e.getStackTraceString();
            srWrapper.statusCode=999;
        }
        system.debug('srWrapper99='+srWrapper);
        return srWrapper;    
    }
    
    public static ACETSNILinkMemberSearch.SearchResultWrapper setWrapperData(String ApiIdentifier, Boolean IsSandbox, Map<String,WebserviceConfigurations__c> mapNameToWebservice, string token,String woId,String memberId){
        //ACETSNILinkMemberSearch.SearchResultWrapper srWrapper = new ACETSNILinkMemberSearch.SearchResultWrapper();
        ACETHouseHoldWrapper houseHoldW = new ACETHouseHoldWrapper();
        if(apiIdentifier != null){
            //changing apiIdentifier to filter only CS and OP source code member details
            blob decodedIdentifierBlob = EncodingUtil.base64Decode(apiIdentifier);
            system.debug(decodedIdentifierBlob.toString());
            
            CDB_userAPIJSON2Apex parsedUserAPIData = CDB_userAPIJSON2Apex.parse(decodedIdentifierBlob.tostring());
            system.debug('actual json--- '+parsedUserAPIData);
            CDB_userAPIJSON2Apex parsedUserAPIData_new = CDB_userAPIJSON2Apex.parse(decodedIdentifierBlob.tostring());
            parsedUserAPIData_new.fids = new List<CDB_userAPIJSON2Apex.Fids>();
            
            for (CDB_userAPIJSON2Apex.Fids fid : parsedUserAPIData.fids) {
                if (fid.sourceCD == 'CDB_CS' || fid.sourceCD == 'CDB_OP' || fid.sourceCD == 'CDB_CA' || fid.sourceCD == 'CDB_CO') {                    
                    parsedUserAPIData_new.fids.add(fid);
                }
            }
            
            system.debug('parsed json--- '+JSON.serialize(parsedUserAPIData_new));
            apiIdentifier = EncodingUtil.base64Encode(blob.valueof(JSON.serialize(parsedUserAPIData_new)));
            //system.debug('parsedUserAPIData-'+String.valueOf(parsedUserAPIData).remove('CDB_userAPIJSON2Apex:'));
            system.debug(apiIdentifier);
            Integer pageNo = 1, totalpgs = 1;
            String memberIdFromAPI;
            ACETHouseHoldWrapper.HouseHold HHDataOfMainMember = new ACETHouseHoldWrapper.HouseHold();
            Map<String, Map<String, String>> mapNameToPolicyToSourceCode = new Map<String, Map<String, String>>();
            Map<String, ACETHouseHoldWrapper.HouseHold> mapToIdentifyDuplicateMembers = new Map<String, ACETHouseHoldWrapper.HouseHold>();
            List<ACETHouseHoldWrapper.HouseHold> listAllHH = new List<ACETHouseHoldWrapper.HouseHold>();
            While (pageNo <= totalpgs){
                HTTPResponse HttpMemberRes = getMemberInfo(IsSandbox,mapNameToWebservice, apiIdentifier,token,pageNo); //Member detail API call
                if(HttpMemberRes != null){
                    system.debug('check111==' + HttpMemberRes);
                    if(HttpMemberRes.getStatusCode() == 200){
                        String responseStr = HttpMemberRes.getBody();
                        
                        if (responseStr!=null && String.isNotBlank(responseStr)) {
                            //system.debug('inside if' + responseStr);
                            ACET_CDBWebserviceJSONtoApex parsedCDBData = ACET_CDBWebserviceJSONtoApex.parse(responseStr);
                            //system.debug('****response parsed Eligibilities****'+parsedCDBData);
                            if (parsedCDBData.eligibilities != null || parsedCDBData.eligibilities.size() > 0) {
                                system.debug('****response parsedCDBData.eligibilities.size()****'+parsedCDBData.eligibilities.size());
                                List<ACET_CDBWebserviceJSONtoApex.Eligibilities> elig = parsedCDBData.eligibilities;
                                //List<ACETHouseHoldWrapper.HouseHold> listAllHH = new List<ACETHouseHoldWrapper.HouseHold>();
                              //String memberIdFromAPI;
           //ACETHouseHoldWrapper.HouseHold HHDataOfMainMember = new ACETHouseHoldWrapper.HouseHold();

                                
                                //creating a map of Name and primary postal address of a member
                                boolean terminationcheck=false;
                                Map<String, ACET_CDBWebserviceJSONtoApex.postalAddresses> mapNametoPostalAdd = new Map<String, ACET_CDBWebserviceJSONtoApex.postalAddresses>();
                                for (ACET_CDBWebserviceJSONtoApex.Eligibilities e : elig) {
                                    ACET_CDBWebserviceJSONtoApex.SourceIndividual SIndi = e.sourceIndividual;
                                    for (ACET_CDBWebserviceJSONtoApex.Memberships mship : e.Memberships) {
                                        terminationcheck=false;
                                         if(mship.customerAccount != null && mship.customerAccount.customerAccountIdentifier != null && (mship.customerAccount.customerAccountIdentifier.contains('703352') || mship.customerAccount.customerAccountIdentifier.contains('8231')) && mship.terminationDate > String.valueOf(Date.today()) ){
                                        terminationcheck=true;
                                            }   
                                    if (SIndi.postalAddresses != null && terminationcheck==true){
                                        for (ACET_CDBWebserviceJSONtoApex.postalAddresses pa : SIndi.postalAddresses) {
                                            if (!mapNametoPostalAdd.containsKey(SIndi.personName.firstName) && pa.primaryIndicator == true) {
                                                mapNametoPostalAdd.put(SIndi.personName.firstName,pa);
                                                break;
                                            }
                                        }                         
                                        if (!mapNametoPostalAdd.containsKey(SIndi.personName.firstName)) {
                                            mapNametoPostalAdd.put(SIndi.personName.firstName,SIndi.postalAddresses[0]);
                                        }
                                    }
                                }
                                }
                                if (parsedCDBData.eligibilityMetaData != null && parsedCDBData.eligibilityMetaData.totalResults > 17 && totalPgs ==1) {
                                    totalPgs =  Math.mod(parsedCDBData.eligibilityMetaData.totalResults,17) > 0 ? (integer.valueof(parsedCDBData.eligibilityMetaData.totalResults/17) + 1) : integer.valueof(parsedCDBData.eligibilityMetaData.totalResults/17);
                                    system.debug('totalresults'+parsedCDBData.eligibilityMetaData.totalResults);
                                }
                                system.debug('totalpages'+totalpgs);
                                
                                
                                //Map<String, Map<String, String>> mapNameToPolicyToSourceCode = new Map<String, Map<String, String>>();
                                //Map<String, ACETHouseHoldWrapper.HouseHold> mapToIdentifyDuplicateMembers = new Map<String, ACETHouseHoldWrapper.HouseHold>();
                                //system.debug('size of eligi--'+elig.size());
                                for (ACET_CDBWebserviceJSONtoApex.Eligibilities e : elig) {
                                    
                                    ACETHouseHoldWrapper.HouseHold HH = new ACETHouseHoldWrapper.HouseHold();
                                    //ACET_CDBWebserviceJSONtoApex.Memberships mship = new ACET_CDBWebserviceJSONtoApex.Memberships();
                                    if (e.Memberships != null) {
                                        
                                        //mship = e.Memberships[0];
                                        for (ACET_CDBWebserviceJSONtoApex.Memberships mship : e.Memberships) {
                                            if (mship.customerAccount != null && mship.customerAccount.customerAccountIdentifier != null && (mship.customerAccount.customerAccountIdentifier.contains('703352') || mship.customerAccount.customerAccountIdentifier.contains('8231')) && mship.terminationDate > String.valueOf(Date.today())) {
                                                HH.policyId = mship.customerAccount.customerAccountIdentifier;
                                                HH.policyId = PolicyNumberutil.validatePolicyNumber(HH.policyId);
                                                if (e.sourceIndividual != null) {
                                                    ACET_CDBWebserviceJSONtoApex.SourceIndividual SI = e.sourceIndividual;
                                                    
                                                    ACETHouseHoldWrapper.addressInfo addinfo = new ACETHouseHoldWrapper.addressInfo();
                                                    if (SI.personName != null) {
                                                        addinfo.city = mapNametoPostalAdd.get(SI.personName.firstName).townName;
                                                        addinfo.country = 'USA';
                                                        addinfo.state = mapNametoPostalAdd.get(SI.personName.firstName).stateProvinceCode;
                                                        addinfo.street =  mapNametoPostalAdd.get(SI.personName.firstName).line1Text + ' ' + mapNametoPostalAdd.get(SI.personName.firstName).line2Text;
                                                        addinfo.zip = mapNametoPostalAdd.get(SI.personName.firstName).postalCode;
                                                        HH.firstName = SI.personName.firstName;
                                                        HH.lastName = SI.personName.lastName;
                                                        HH.fullName = SI.personName.suffix + ' ' + SI.personName.firstName + ' ' +  SI.personName.middleName + ' ' + SI.personName.lastName;
                                                    }
                                                    
                                                    if (SI.demographicInfo != null) {
                                                        HH.dob = SI.demographicInfo.birthDate;
                                                        if (SI.demographicInfo.genderType != null) {
                                                            HH.gender = SI.demographicInfo.genderType.Code;
                                                        }
                                                    }   
                                                    
                                                    HH.address = addinfo;
                                                    HH.sourceCode = SI.enrolleeSourceCode;
                                                    
                                                    if (SI.alternateIdentifiers != null) {
                                                        
                                                        //storing enterprise ID of member
                                                        if (SI.alternateIdentifiers.enterpriseIndividualIdentifier != null) {
                                                            HH.enterpriseId = SI.alternateIdentifiers.enterpriseIndividualIdentifier;
                                                        }
                                                        
                                                        //storing alternate ID of member
                                                        if (SI.alternateIdentifiers.alternateIds != null) {
                                                            if (SI.alternateIdentifiers.alternateIds[0].identifier.length() <= 9)
                                                                HH.alternateId = '00' + SI.alternateIdentifiers.alternateIds[0].identifier;
                                                            else if (SI.alternateIdentifiers.alternateIds[0].identifier.length() == 10)
                                                                HH.alternateId = '0' + SI.alternateIdentifiers.alternateIds[0].identifier;
                                                            else
                                                                HH.alternateId = SI.alternateIdentifiers.alternateIds[0].identifier;
                                                            
                                                        }
                                                        
                                                        //storing MemberID/Subscriber ID of member
                                                        if (SI.alternateIdentifiers.subscriberIds != null) {
                                                            if (SI.alternateIdentifiers.subscriberIds[0].identifier.length() <= 9)
                                                                HH.memberId = '00' + SI.alternateIdentifiers.subscriberIds[0].identifier;
                                                            else if (SI.alternateIdentifiers.subscriberIds[0].identifier.length() == 10)
                                                                HH.memberId = '0' + SI.alternateIdentifiers.subscriberIds[0].identifier;
                                                            else
                                                                HH.memberId = SI.alternateIdentifiers.subscriberIds[0].identifier; 
                                                        }
                                                        
                                                        if (String.isEmpty(memberIdFromAPI)) {
                                                            if (SI.alternateIdentifiers.subscriberIds != null) {   
                                                                if (SI.alternateIdentifiers.subscriberIds[0].identifier.length() <= 9)
                                                                    memberIdFromAPI = '00'+SI.alternateIdentifiers.subscriberIds[0].identifier;
                                                                else if (SI.alternateIdentifiers.subscriberIds[0].identifier.length() == 10)
                                                                    memberIdFromAPI = '0'+SI.alternateIdentifiers.subscriberIds[0].identifier;
                                                                else
                                                                    memberIdFromAPI =SI.alternateIdentifiers.subscriberIds[0].identifier;
                                                            } 
                                                        }
                                                        
                                                    }
                                                    
                                                    if (SI.eligibilityAttributes != null) {
                                                        //HH.alternateId  = SI.alternateIdentifiers.alternateSubscriberId; 
                                                        
                                                        
                                                        if (SI.eligibilityAttributes.relationshipType != null) {
                                                            HH.relationship = SI.eligibilityAttributes.relationshipType.description;
                                                            Boolean isMainMember = (SI.eligibilityAttributes.relationshipType.description == 'Self'?true:false);//to check if Member is the main member
                                                            HH.isMainMember = isMainMember;      
                                                        }
                                                    }
                                                    
                                                    system.debug('HHDataOfMainMember----'+ HHDataOfMainMember);
                                                    //system.debug('HH.sourceCode-'+HH.sourceCode);
                                                    //system.debug('HH.CHNQualified-'+HH.CHNQualified);
                                                    //system.debug('HH.CHNReferralIdentifier-'+HH.CHNReferralIdentifier);
                                                    //system.debug('HH----'+ HH);
                                                    Date dobirth = ACETUtility.parseDate(HH.dob);
                                                    String ToIdentifyDuplicateMembersWRelation = HH.firstName.touppercase()+'~'+HH.lastName.touppercase()+'~-~'+ACETUtility.format(dobirth);
                                                    HH.UniqueIdentifier = ToIdentifyDuplicateMembersWRelation;
                                                    
                                                    String UniqueNameWithPolicy = HH.firstName.touppercase()+HH.lastName.touppercase()+date.valueOf(HH.dob)+HH.policyId;
                                                    if (!mapToIdentifyDuplicateMembers.containsKey(ToIdentifyDuplicateMembersWRelation)){  
                                                        system.debug('mapToIdentifyDuplicateMembers--'+mapToIdentifyDuplicateMembers.keyset());
                                                        if (SI.eligibilityAttributes != null) {
                                                            if (SI.eligibilityAttributes.relationshipType != null) {
                                                                if(SI.eligibilityAttributes.relationshipType.description == 'Self') {
                                                                    HHDataOfMainMember = HH; //to get the information of main member   
                                                                    system.debug('HHDataOfMainMember--'+HHDataOfMainMember.memberId);
                                                                }
                                                            }
                                                        }
                                                        listAllHH.add(HH);
                                                        mapToIdentifyDuplicateMembers.put(UniqueNameWithPolicy, HH);
                                                    }
                                                    system.debug('mapToIdentifyDuplicateMembers--'+mapToIdentifyDuplicateMembers.keyset());
                                                }
                                                break;
                                            }  
                                        }
                                    }
                                }
                                
                                
                                system.debug('--listAllHH'+listAllHH);
                                List<ACETHouseHoldWrapper.HouseHold> newListHH = new List<ACETHouseHoldWrapper.HouseHold>();
                                List<ACETHouseHoldWrapper.HouseHold> listHH = new List<ACETHouseHoldWrapper.HouseHold>();
                                ACETHouseHoldWrapper.memberDetails result = new ACETHouseHoldWrapper.memberDetails();
                                Set<String> setEID = new Set<String>();
                                Set<String> EIDs = new Set<String>();
                                //executing the wrapper logic in the final iteration
                                if (pageNo == totalpgs){
                                    if (listAllHH.size() > 0) {
                                        system.debug('HHDataOfMainMember.memberId-'+HHDataOfMainMember.memberId);
                                        system.debug('memberIdFromAPI-'+memberIdFromAPI);
                                        //assigning the laternate Id in case null subscriber Id
                                        memberIdFromAPI = (memberIdFromAPI != '' && memberIdFromAPI != null)? listAllHH[0].alternateId : memberIdFromAPI;
                                        //if there is no Main Member in the returned data, we send the detail of first member in the list ahead
                                        String memberIdOfMainMember = (HHDataOfMainMember.memberId == null || HHDataOfMainMember.memberId == '')?memberIdFromAPI:HHDataOfMainMember.memberId;
                                        String dobOfMainMember = (HHDataOfMainMember.dob == null || HHDataOfMainMember.dob == '')?listAllHH[0].dob:HHDataOfMainMember.dob;
                                        String policyId = (HHDataOfMainMember.policyId == null || HHDataOfMainMember.policyId== '')?listAllHH[0].policyId:HHDataOfMainMember.policyId;
                                        system.debug('memberIdOfMainMember-'+memberIdOfMainMember);
                                        for (ACETHouseHoldWrapper.HouseHold HH : listAllHH) {
                                            if (!EIDs.contains(HH.enterpriseId)) {
                                                EIDs.add(HH.enterpriseId);
                                            }
                                        }
                                        
                                        //check CHN Qualification and Eligibility of members
                                        CHNEligible = MemberEligibilityCheck(memberIdOfMainMember);
                                        List<CHN_Qualified_Data__c> CHNQualList = MemberQulificationCheck(EIDs);
                                        CHNQualified = CHNQualList.size()>0?true:false;
                                        //system.debug('CHNEligible--'+CHNEligible);
                                        system.debug('CHNQualified--'+CHNQualified);
                                        
                                        
                                        Map<String, CHN_Qualified_Data__c> mapNameToCHNQualification = new  Map<String, CHN_Qualified_Data__c>();
                                        for (CHN_Qualified_Data__c Qual : CHNQualList) {
                                            //Date dobirth = ACETUtility.parseDate(String.valueOf(Qual.Date_of_Birth__c));
                                            //String nameKey = Qual.First_Name__c.touppercase()+Qual.Last_Name__c.touppercase()+Qual.Date_of_Birth__c/*ACETUtility.formatStrict(dobirth)*/;
                                            if (!mapNameToCHNQualification.containsKey(Qual.EID__c)){
                                                mapNameToCHNQualification.put(Qual.EID__c, Qual);
                                            }
                                        }
                                        system.debug('mapNameToCHNQualification--'+mapNameToCHNQualification);
                                        
                                        //If Policy ID from CDB doesn't matches with Policy ID from Qualified Data, we replace it.
                                        if (mapNameToCHNQualification.values().size()>0 && policyId != (new List<CHN_Qualified_Data__c>(mapNameToCHNQualification.values()))[0].Policy_Number__c) {
                                            if ((new List<CHN_Qualified_Data__c>(mapNameToCHNQualification.values()))[0].Policy_Number__c != null)
                                                policyId = (new List<CHN_Qualified_Data__c>(mapNameToCHNQualification.values()))[0].Policy_Number__c;
                                        }
                                        system.debug('policyId---'+policyId);
                                        
                                        for (String st : mapToIdentifyDuplicateMembers.keySet()) {
                                            system.debug('st-'+st);
                                            if (st.contains(policyId) && (mapToIdentifyDuplicateMembers.get(st).enterpriseId == null || !setEID.contains(mapToIdentifyDuplicateMembers.get(st).enterpriseId))) {
                                                setEID.add(mapToIdentifyDuplicateMembers.get(st).enterpriseId);
                                                listHH.add(mapToIdentifyDuplicateMembers.get(st));
                                            }    
                                        }
                                        system.debug('listHH--'+listHH);
                                        //Storing each member's referral Identifier and Qualification
                                        for ( ACETHouseHoldWrapper.HouseHold HH : listHH) {
                                            //String ToIdentifyDuplicateMembersWRelation = HH.firstName.touppercase()+HH.lastName.touppercase()+date.valueOf(HH.dob);
                                            if (!mapNameToCHNQualification.isEmpty()) {
                                                if (mapNameToCHNQualification.containsKey(HH.enterpriseId)) {
                                                    system.debug('inside if of referral identifier');
                                                    HH.CHNReferralIdentifier = mapNameToCHNQualification.get(HH.enterpriseId).CHN_Referral_Identifier__c;
                                                    HH.complexIndicator = mapNameToCHNQualification.get(HH.enterpriseId).Complex_Indicator__c;
                                                    system.debug('HH.CHNReferralIdentifier-'+HH.CHNReferralIdentifier);
                                                    system.debug('HH.complexIndicator-'+HH.complexIndicator);
                                                    HH.CHNQualified = true;
                                                    HH.CHNEligibile = CHNEligible;
                                                }
                                                else {
                                                    HH.CHNQualified = false;
                                                }
                                            }
                                            newListHH.add(HH);
                                        }
                                        result = ACETSNISaveHouseholdData.getSNISaveHouseholdData(newListHH,dobOfMainMember,woId,memberIdOfMainMember,'','eligible',policyId,policyId,'','','','','');
                                        srWrapper.statusCode = 200;
                                    } else {
                                        srWrapper.statusCode = 400;
                                        srWrapper.message = 'No records found';
                                    }
                                    
                                    //system.debug('result--'+result);
                                    houseHoldW.houseHoldList = newListHH;
                                    houseHoldW.memberDetails = result;
                                    // system.debug('houseHoldList=='+ houseHoldW.houseHoldList);
                                }//if condition for allowing the srwrapper in the final iteration  
                                
                            }
                            
                            
                            
                        }
                        
                        srWrapper.houseHoldResultWrapper = houseHoldW;
                        
                        
                    }else {
                        //error
                        system.debug('check111' + HttpMemberRes.getStatusCode());
                        srWrapper.statusCode = HttpMemberRes.getStatusCode();
                        Map<String, Object> Errresult1 = (Map<String, Object>)JSON.deserializeUntyped(HttpMemberRes.getBody());
                        srWrapper.message = (String)Errresult1.get('message');
                    }
                    srWrapper.CHNEligible = CHNEligible;
                    srWrapper.CHNQualified = CHNQualified;
                }
                
                if(pageNo == totalpgs){
                    Database.DMLOptions opt = new Database.DMLOptions();
                    opt.allowFieldTruncation = true;
                    Database.insert(cdbloglist, opt);
                    insert appLogList;                
                    break;
                }
                
                pageNo = totalpgs > 1 ? (pageNo +1) : pageNo;
                System.debug('Pagenumber'+pageNo);
                
            }//while ends  
        }
        //  system.debug('memberDetails len=='+ srWrapper.houseHoldResultWrapper.memberDetails.size());
        return srWrapper;
    }
    public static HTTPResponse getAccessToken(Boolean IsSandbox, Map<String,WebserviceConfigurations__c> WsObj){
        
        
        String ServiceName = 'CDB Authorization';
        
        String method= '';
        HttpRequest req = new HttpRequest();
        system.debug('WsObj--'+WsObj);
        //system.debug('WsObj.get(ServiceName).Method__c--'+WsObj.get(ServiceName).Method__c);
        req.setMethod(String.valueOf(WsObj.get(ServiceName).Method__c));
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setEndpoint(String.valueOf(WsObj.get(ServiceName).EndpointPath__c));
        System.debug('Body--->'+WsObj.get(ServiceName).JSONBodyWithMergeFields__c);
        req.setBody(String.valueOf(WsObj.get(ServiceName).JSONBodyWithMergeFields__c));
        
        //req.setBody('grant_type=client_credentials' + '&client_id='+CLIENT_ID + '&client_secret='+CLIENT_SECRET + '&scope=https://api.uhg.com/.default');
        Http http = new Http();
        HTTPResponse response = http.send(req);
        System.debug('Body ' + response.getBody());
        System.debug('Status ' + response.getStatus());
        if(response.getStatusCode() == 200){ //new object
            createCDBStatusLog(String.valueOf(WsObj.get(ServiceName).Method__c),string.ValueOf(req.getBody()),response.getBody(),String.valueOf(WsObj.get(ServiceName).EndpointPath__c),String.valueOf(response.getStatusCode()));
        }else{
            Map<String, Object> Errresult3 = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            createAppErrorLog('CDB', 'CDB Response Member Search', String.valueOf(WsObj.get(ServiceName).EndpointPath__c), (String)Errresult3.get('message'), response.getStatusCode());
        }
        return response;
    }
    
    public  static HTTPResponse getUserInfo(Boolean IsSandbox ,Map<String,WebserviceConfigurations__c> WsObj ,String AccToken,String eid){
        String ServiceName ='CDB User Service EID';
        
        HttpRequest request = new HttpRequest();
        request.setMethod(String.valueOf(WsObj.get(ServiceName).Method__c));
        request.setEndpoint(String.valueOf(WsObj.get(ServiceName).EndpointPath__c));
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('consumername', 'CHN');
        request.setHeader('roles', 'CHN');
        request.setHeader('x-uhg-user-identifier', 'eyJlaWQiOiIyMjY4NzE0MjAiLCJmaWRzIjpbXX0=');
        request.setHeader('x-upstream-env','stage');
        
        /*
request.setHeader('x-uhg-user-identifier', 'eyJlaWQiOiIyMTk0NDg0MSIsImZpZHMiOlt7ImlkIjoiMzg4NjYzNDMwIiwic291cmNlQ0QiOiJDREJfT0IifSx7ImlkIjoiNDQwMzQzOTkiLCJzb3VyY2VDRCI6IkNEQl9DUyJ9LHsiaWQiOiIyMDQ1ODA1NTkiLCJzb3VyY2VDRCI6IkNEQl9DQSJ9XSwiY3JpZHMiOltdLCJoaHNJZCI6bnVsbH0=');
request.setHeader('x-upstream-env','stage');*/
        request.setHeader('Authorization', 'Bearer ' + AccToken);
        request.setBody('{\n\"id\": \"'+eid+'\",\n\"idType\": \"enterpriseid\"\n}');
        //request.setBody('{\n\"id\": \"'+memberid+'\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"'+DateofBirth+'\"\n}');
        //request.setBody('{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}');
        Http http = new Http();
        HttpResponse response1 = http.send(request);
        System.debug('Body1 ' + response1.getBody());
        System.debug('Status1 ' + response1.getStatus());
        System.debug('Status code1 ' + response1.getStatusCode());
        if(response1.getStatusCode() == 200 || response1.getStatusCode() == 404){ //new object
            createCDBStatusLog(String.valueOf(WsObj.get(ServiceName).Method__c),string.ValueOf(request.getBody()),response1.getBody(),String.valueOf(WsObj.get(ServiceName).EndpointPath__c),String.valueOf(response1.getStatusCode()));
        }else{
            Map<String, Object> Errresult3 = (Map<String, Object>)JSON.deserializeUntyped(response1.getBody());
            createAppErrorLog('CDB', 'CDB Response Member Search', String.valueOf(WsObj.get(ServiceName).EndpointPath__c), (String)Errresult3.get('message'), response1.getStatusCode());
        }
        Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(response1.getBody());
        system.debug('getUserInfo results=='+results.size());
        system.debug('getUserInfo '+results);
        String apiIdentifier = (String)results.get('apiIdentifier');
        system.debug('apiIdentifier--'+apiIdentifier);
        return response1;
    }
    
    public  static HTTPResponse getUserInfoWithDOB(Boolean IsSandbox,Map<String,WebserviceConfigurations__c> WsObj,String AccToken,String Memberid,String DateofBirth,String firstName,String LastName){
        String ServiceName ='CDB User Service API With DOB';
        
        HttpRequest request = new HttpRequest();
        request.setMethod(String.valueOf(WsObj.get(ServiceName).Method__c));
        request.setEndpoint(String.valueOf(WsObj.get(ServiceName).EndpointPath__c));
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('consumername', 'CHN');
        request.setHeader('roles', 'CHN');
        request.setHeader('x-uhg-user-identifier', 'eyJlaWQiOiIyMjY4NzE0MjAiLCJmaWRzIjpbXX0=');
        if (IsSandbox == true) {
            request.setHeader('x-upstream-env','stage');
        }
        request.setHeader('Authorization', 'Bearer ' + AccToken);
        if(Memberid!='' && DateofBirth!=''){
            request.setBody('[ {\n\"key\":\"search_keys\",\n\"value\":\"'+Memberid+'\" }, { \n\"key\": \"birthDate\", \n\"value\": \"'+DateofBirth+'\" } ]'); //manmeet -change
        }else if(LastName!='' && firstName!='' && DateofBirth!=''){
            system.debug(LastName +firstName + DateofBirth);
            request.setBody('[ {\n\"key\":\"familyName\",\n\"value\":\"'+LastName+'\" },{\n\"key\":\"givenName\",\n\"value\":\"'+firstName+'\" }, { \n\"key\": \"birthDate\", \n\"value\": \"'+DateofBirth+'\" } ]'); //manmeet -change
        }else if(Memberid!='' && LastName!=''){
            request.setBody('[ {\n\"key\":\"search_keys\",\n\"value\":\"'+Memberid+'\" },{\n\"key\":\"familyName\",\n\"value\":\"'+LastName+'\" } ]'); //manmeet -change
        }
        //request.setBody('{\n\"id\": \"'+Memberid+'\",\n\"idType\": \"enterpriseid\"\n}');
        //request.setBody('{\n\"id\": \"'+memberid+'\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"'+DateofBirth+'\"\n}');
        //request.setBody('{\n\"id\": \"00411796502\",\n\"idType\": \"searchid\",\n\"dateOfBirth\": \"1995-11-21\"\n}');
        
        Http http = new Http();
        system.debug('request is:' + request);
        HttpResponse response1 = http.send(request);
        System.debug('Body1 ' + response1.getBody());
        System.debug('Status1 ' + response1.getStatus());
        System.debug('Status code1 ' + response1.getStatusCode());
        
        if(response1.getStatusCode() == 200 || response1.getStatusCode() == 404){ //new object
            createCDBStatusLog(String.valueOf(WsObj.get(ServiceName).Method__c),string.ValueOf(request.getBody()),response1.getBody(),String.valueOf(WsObj.get(ServiceName).EndpointPath__c),String.valueOf(response1.getStatusCode()));
        }else{
            Map<String, Object> Errresult3 = (Map<String, Object>)JSON.deserializeUntyped(response1.getBody());
            createAppErrorLog('CDB', 'CDB Response Member Search', String.valueOf(WsObj.get(ServiceName).EndpointPath__c), (String)Errresult3.get('message'), response1.getStatusCode());
        }
        
        //Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(response1.getBody());
        //String apiIdentifier = (String)results.get('apiIdentifier');
        //system.debug('apiIdentifier--'+apiIdentifier);
        return response1;
    }
    public static HttpResponse getMemberInfo(Boolean IsSandbox,Map<String,WebserviceConfigurations__c> WsObj, String apiIdentifier,String AccToken, Integer pageNo){
        String ServiceName ='CDB Member Search API';
        system.debug('api identifier'+apiIdentifier);
        HttpRequest request1 = new HttpRequest();
        request1.setEndpoint(String.valueOf(WsObj.get(ServiceName).EndpointPath__c));
        request1.setMethod(String.valueOf(WsObj.get(ServiceName).Method__c));
        request1.setHeader('Content-Type', 'application/json');
        request1.setHeader('consumername', 'CHN');
        request1.setHeader('roles', 'CHN');
        if (IsSandbox == true) {
            request1.setHeader('x-upstream-env','stage');
        }
        if(apiIdentifier!=null){                                                 
            request1.setHeader('x-uhg-user-identifier',apiIdentifier);
        }
        request1.setHeader('Authorization', 'Bearer ' + AccToken);
        
        request1.setBody('{\n\"includeFamily\": true,\n\"includeInactive\": false,\n\"limit":{\n\"page":'+pageNo+',\n\"size":17\n}\n}'); 
        //request1.setBody('{\n\"includeFamily\": true,\n\"includeInactive\": false\n}'); // new change
        //request1.setBody(String.valueOf(WsObj.get(ServiceName).JSONBodyWithMergeFields__c));
        Http http = new Http();
        HttpResponse response2 = http.send(request1);
        String finalres = (String)response2.getBody();
        System.debug('finalres--> ' + finalres);
        System.debug('Body2 ' + response2.getBody());
        System.debug('Status2 ' + response2.getStatus());
        System.debug('Status code2 ' + response2.getStatusCode());
        if(response2.getStatusCode() == 200 || response2.getStatusCode() == 404){ //new object
            createCDBStatusLog(String.valueOf(WsObj.get(ServiceName).Method__c),string.ValueOf(request1.getBody()),response2.getBody(),String.valueOf(WsObj.get(ServiceName).EndpointPath__c),String.valueOf(response2.getStatusCode()));
        }else{
            Map<String, Object> Errresult3 = (Map<String, Object>)JSON.deserializeUntyped(response2.getBody());
            createAppErrorLog('CDB', 'CDB Response Member Search', String.valueOf(WsObj.get(ServiceName).EndpointPath__c), (String)Errresult3.get('message'), response2.getStatusCode());
        }
        try{
            system.debug('cdbloglist---'+cdbloglist);
            //insert appLogList;
            //insert cdbloglist;
        }
        catch(Exception ex){
            system.debug('exception occured::' + ex.getMessage());
        }
        Return response2;  
    }
    
    public static List<CHN_Qualified_Data__c> MemberQulificationCheck(Set<String> EIDs){
        String ReferralStatus = 'new';
        String Querystr = 'SELECT Id,EID__c, Complex_Indicator__c, Policy_Number__c, CHN_Referral_Identifier__c FROM CHN_Qualified_Data__c';
        if(EIDs.size() >0)
            Querystr+=' Where EID__c IN: EIDs AND Referral_Status__c = :ReferralStatus';
        System.debug('***Querystr---'+Querystr);
        List<CHN_Qualified_Data__c> lstQualificedData = new List<CHN_Qualified_Data__c>();
        lstQualificedData = Database.query(Querystr);
        System.debug('****lstQualificedData---'+lstQualificedData);
        /*if(lstQualificedData != null && lstQualificedData.size()>0){
return lstQualificedData[0].CHN_Referral_Identifier__c;
}*/
        return lstQualificedData;  
    }
    
    public static boolean MemberEligibilityCheck(String memberId){
        String Querystr = 'SELECT OwnerId, Id, First_Name__c, Last_Name__c, Date_of_Birth__c,Member_ID__c , Policy_ID__c, POP_ID__c, Optum_Segment_Id__c FROM CHN_Members__c';
        if(memberId != null)
            Querystr+=' Where Member_ID__c =: memberId';
        System.debug('***Querystr---'+Querystr);
        List<CHN_Members__c> lstEligibleData = new List<CHN_Members__c>();
        lstEligibleData = Database.query(Querystr);
        System.debug('****lstEligibleData---'+lstEligibleData);
        String popUpIds = system.label.CHN_ELIGIBLE_POPUP_ID;
        popUpIds = popUpIds.toUppercase();
        if(lstEligibleData != null && lstEligibleData.size()>0){
            if (popUpIds.contains(lstEligibleData[0].Pop_ID__c.toUppercase())){
                return true;
            } 
        }
        return false;
    }
    
    public static void createAppErrorLog(string appName, string servName, String endPoint, string respStatus, Integer respStatuscode){
        Application_Error_Log__c appErrorLog = ACETUtility.CreateApplicationErrorLog(appName, servName, endPoint, respStatus, respStatuscode); 
        appLogList.add(appErrorLog);
    }
    
    public static void createCDBStatusLog(string method, string request, String response, string endpoint, string statuscode){
        integer maxSize = 131071;
        CDB_Application_Log__c cdbLog = new CDB_Application_Log__c(); 
        cdbLog.method__c = method;
        cdbLog.request__c = request;
        system.debug('GetmemberInfoLen=='+response.length());
        if(response.length() > maxSize ){
            response = response.substring(0, maxSize);
        }
        cdbLog.response__c = response;
        cdbLog.endpoint__c = endpoint;
        cdbLog.status_code__c = statuscode;
        cdbLogList.add(cdbLog);
    }
}