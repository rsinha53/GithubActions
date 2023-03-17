public class CHNQualifiedDataUpdate implements Queueable, Database.AllowsCallouts {
    private CHN_Qualified_Data__c Qual;
    
    public CHNQualifiedDataUpdate(CHN_Qualified_Data__c Qual) {
        this.Qual = Qual;
    }
    
    public void execute(System.QueueableContext qc) {
        String token;
        List<ACETHouseHoldWrapper.HouseHold> listHH = new List<ACETHouseHoldWrapper.HouseHold>();
        Map<String, CHN_Qualified_Data__c> mapEIDtoQualData = new Map<String, CHN_Qualified_Data__c>();
        Map<String, ACETHouseHoldWrapper.HouseHold> mapEIDtoHouseHold = new Map<String, ACETHouseHoldWrapper.HouseHold>();
        Organization objorg = [SELECT IsSandbox FROM Organization LIMIT 1];
        boolean IsSandbox = objorg.IsSandbox;
        string qryStr = '%CDB%';
        List<WebserviceConfigurations__c> WsObj = [SELECT Id, Name, AuthorizationToken__c, EndpointPath__c, Headers__c, 
                                                   JSONBodyWithMergeFields__c, Method__c, Timeout__c, E400__c, E401__c, 
                                                   E500__c, TokenAPI__r.Name, TokenAPI__r.IsCachedToken__c, Handle_Unauthorized__c 
                                                   FROM WebserviceConfigurations__c Where Name LIKE : qrystr and active__c = true];
        
        //Creating map of Webservice Configuration Name and its record
        Map<String, WebserviceConfigurations__c> mapNameToWebservice = new Map<String, WebserviceConfigurations__c>();
        for (WebserviceConfigurations__c wsc : WsObj) {
            if (!mapNameToWebservice.containsKey(wsc.Name)) {
                mapNameToWebservice.put(wsc.Name, wsc);
            }
        }
        
        HTTPResponse HttpRes1 = CDB_ACETWebservice.getAccessToken(IsSandbox, mapNameToWebservice); //access token API call
        if(HttpRes1!= null) {
            if(HttpRes1.getStatusCode() == 200){
                Map<String, Object> result1 = (Map<String, Object>)JSON.deserializeUntyped(HttpRes1.getBody());
                token = (String)result1.get('access_token');
                
                HTTPResponse HttpRes2=CDB_ACETWebservice.getUserInfo(IsSandbox ,mapNameToWebservice ,token, Qual.EID__c);
                if(HttpRes2 != null){
                    if(HttpRes2.getStatusCode() == 200){
                        String apiIdentifier;
                         Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(HttpRes2.getBody());
                        apiIdentifier = (String)results.get('apiIdentifier');
                        HTTPResponse HttpMemberRes = CDB_ACETWebservice.getMemberInfo(IsSandbox,mapNameToWebservice, apiIdentifier,token, 1);
                        
                        if(HttpMemberRes != null){
                            system.debug('check111' + HttpMemberRes);
                            if(HttpMemberRes.getStatusCode() == 200){
                                String responseStr = HttpMemberRes.getBody();
                                
                                if (responseStr!=null && String.isNotBlank(responseStr)) {
                                    //system.debug('inside if' + responseStr);
                                    ACET_CDBWebserviceJSONtoApex parsedCDBData = ACET_CDBWebserviceJSONtoApex.parse(responseStr);
                                    //system.debug('****response parsed Eligibilities****'+parsedCDBData);
                                    if (parsedCDBData.eligibilities != null || parsedCDBData.eligibilities.size() > 0) {
                                        List<ACET_CDBWebserviceJSONtoApex.Eligibilities> elig = parsedCDBData.eligibilities;
                                        List<ACETHouseHoldWrapper.HouseHold> listAllHH = new List<ACETHouseHoldWrapper.HouseHold>();
                                        for (ACET_CDBWebserviceJSONtoApex.Eligibilities e : elig) {
                                            
                                            ACETHouseHoldWrapper.HouseHold HH = new ACETHouseHoldWrapper.HouseHold();
                                            //ACET_CDBWebserviceJSONtoApex.Memberships mship = new ACET_CDBWebserviceJSONtoApex.Memberships();
                                            if (e.Memberships != null) {
                                                for (ACET_CDBWebserviceJSONtoApex.Memberships mship : e.Memberships) {
                                                    if (mship.customerAccount != null && mship.customerAccount.customerAccountIdentifier != null && (mship.customerAccount.customerAccountIdentifier.contains('703352') || mship.customerAccount.customerAccountIdentifier.contains('8231')) && mship.terminationDate > String.valueOf(Date.today())) {
                                                        HH.policyId = mship.customerAccount.customerAccountIdentifier;
                                                        HH.policyId = PolicyNumberutil.validatePolicyNumber(HH.policyId);
                                                        if (e.sourceIndividual != null) {
                                                            ACET_CDBWebserviceJSONtoApex.SourceIndividual SI = e.sourceIndividual;
                                                            
                                                            ACETHouseHoldWrapper.addressInfo addinfo = new ACETHouseHoldWrapper.addressInfo();
                                                            if (SI.personName != null) {
                                                                HH.firstName = SI.personName.firstName;
                                                                HH.lastName = SI.personName.lastName;
                                                                HH.fullName = SI.personName.suffix + ' ' + SI.personName.firstName + ' ' +  SI.personName.middleName + ' ' + SI.personName.lastName;
                                                            }
                                                            
                                                            if (SI.demographicInfo != null) {
                                                                HH.dob = SI.demographicInfo.birthDate;
                                                            }
                                                            if (SI.alternateIdentifiers.subscriberIds != null) {
                                                                if (SI.alternateIdentifiers.subscriberIds[0].identifier.length() <= 9)
                                                                    HH.memberId = '00' + SI.alternateIdentifiers.subscriberIds[0].identifier;
                                                                else if (SI.alternateIdentifiers.subscriberIds[0].identifier.length() == 10)
                                                                    HH.memberId = '0' + SI.alternateIdentifiers.subscriberIds[0].identifier;
                                                                else
                                                                    HH.memberId = SI.alternateIdentifiers.subscriberIds[0].identifier; 
                                                            }
                                                            if (SI.alternateIdentifiers.enterpriseIndividualIdentifier != null && SI.alternateIdentifiers.enterpriseIndividualIdentifier == Qual.EID__c) {
                                                                HH.enterpriseId = SI.alternateIdentifiers.enterpriseIndividualIdentifier;
                                                                listHH.add(HH); 
                                                                break;
                                                                
                                                            }
                                                            
                                                        }
                                                    }
                                                }
                                            }
                                            
                                            
                                            system.debug('listHHdob--'+HH.dob);
                                        }
                                        system.debug('listHH--'+listHH);
                                        if (listHH.size() > 0) {
                                            for (ACETHouseHoldWrapper.HouseHold h : listHH) {
                                                if (!mapEIDtoHouseHold.containsKey(h.enterpriseId)) {
                                                    mapEIDtoHouseHold.put(h.enterpriseId, h);
                                                }
                                            }
                                            
                                            List<CHN_Qualified_Data__c> lstQualData = [SELECT ID, First_Name__c, Last_Name__c,Policy_Number__c, EID__c, Subscriber_Member_ID__c 
                                                                                       FROM CHN_Qualified_Data__c WHERE EID__C IN : mapEIDtoHouseHold.keySet()];
                                            system.debug('lstQualData--'+lstQualData);
                                            for (CHN_Qualified_Data__c q : lstQualData) {
                                                if (mapEIDtoHouseHold.get(q.EID__c) != null) {
                                                q.First_Name__c = mapEIDtoHouseHold.get(q.EID__c).firstName;
                                                q.Last_Name__c = mapEIDtoHouseHold.get(q.EID__c).lastName;
                                                q.Subscriber_Member_ID__c = mapEIDtoHouseHold.get(q.EID__c).memberId;
                                                //Date dobirth = ACETUtility.parseDate(mapEIDtoHouseHold.get(q.EID__c).dob);
                                                system.debug('--'+mapEIDtoHouseHold.get(q.EID__c).dob);
                                                q.Date_of_Birth__c = Date.valueOf(mapEIDtoHouseHold.get(q.EID__c).dob);
                                                q.Policy_Number__c = mapEIDtoHouseHold.get(q.EID__c).policyId;
                                                }
                                            }
                                            update lstQualData;
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
            
        }
    }
}