@isTest
private class ACETMergeAndSplitSRKTest {         
static testMethod void NewContactTest() { 
        setTestData('Member');
        
        ACETMemberDetailController memberDetailController = new ACETMemberDetailController();
        String interactionId = ApexPages.currentPage().getParameters().get('InteractionId');
        String mchId = ApexPages.currentPage().getParameters().get('Id');
        String srk = ApexPages.currentPage().getParameters().get('SRK');
        
        //Check : new interaction created
        //system.assertNotEquals(interactionId, null);
        
        //check : No contact and account with selected member 
        String contactName = ApexPages.currentPage().getParameters().get('firstName') + ' ' + ApexPages.currentPage().getParameters().get('lastName');
        
        List<Case> cList = [select id,contactid from Case where surrogate_key__c =: srk ];
             
        //system.assert(cList.isEmpty());
        
        Continuation conti = (Continuation)memberDetailController.CallWSonPageLoad();
        Map<String, HttpRequest> requests = conti.getRequests();

        HttpResponse response;
        HttpRequest request;

        for(String RequestLabel: requests.keyset()){
            request = requests.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            if(request.getEndpoint().contains('/api/alpha/eisl/individuals/v2.0/read')) {
                response.setBody('{"getIndividualResponse":{"individual":{"individualIdentifier":"154907823","name":{"firstName":"Ruby","lastName":"Kelly","middleName":"","nameSuffix":""},"birthDate":"1959-09-21","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"","maritalStatusCode":"","maritalStatusDescription":"","deceasedDate":"","privacyIndicator":"","tobaccoUsageIndicator":"","ethnicityCode":"","ethnicityDescription":"","address":[{"typeCode":"HOM","addressLine1":"95 Elgar Pass","addressLine2":"","city":"HFD","postalCode":"06140","stateCode":"CT","countryCode":"US"}],"phone":[{"phoneType":"H","phoneNumber":"321-686-6997","phoneExt":"","internationalIndicator":"N","primaryIndicator":"Y"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"ruby@optum.com","primaryIndicator":"Y"}],"employment":[{"employmentStatus":"","employeeIdentifier":"","employmentStartDate":"","retirementDate":""}],"language":[{}],"otherContact":[{}],"identifiers":[{"id":"890504596","type":"SRK"},{"id":"898987679","type":"SRK"},{"id":"352816681","type":"HIC"}]}}}');
            }      
            else if(request.getEndpoint().contains('/api/alpha/eisl/individuals/membership/v2.0/search')) {
                response.setBody('{"findMembershipsResponse": { "memberships": [{       "sourceSysCode": "CR",      "coverages": [{         "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "890504596",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }, {            "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "898987679",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }],     "identifiers": [{           "id": "352816681",          "type": "HIC"       }, {            "id": "69688001800",            "type": "SCR"       }, {            "id": "69688001800",            "type": "MCH"       }],     "enrolleeSystemSpecificIdentifiers": [{         "id": "23462613",           "type": "enrolleeSystemID"      }, {            "id": "154907823",          "type": "enrolleeIndividualIdentifier"      }, {            "id": "890504596",          "type": "enrolleeSurrogateKey"      }]  },  {       "sourceSysCode": "CR",      "coverages": [{         "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "890504596",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }, {            "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "898987679",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }],     "identifiers": [{           "id": "352816681",          "type": "HIC"       }, {            "id": "69688001800",            "type": "SCR"       }, {            "id": "69688001800",            "type": "MCH"       }],     "enrolleeSystemSpecificIdentifiers": [{         "id": "23462613",           "type": "enrolleeSystemID"      }, {            "id": "154907823",          "type": "enrolleeIndividualIdentifier"      }, {            "id": "898987679",          "type": "enrolleeSurrogateKey"      }]  }], "pagination": {     "pageNumber": "1",      "pageSize": "5",        "recordCount": "1",     "totalCount": "1",      "totalPages": "1"   }}}');
            }     
            Test.setContinuationResponse(RequestLabel, response); 
        }
        Object result = Test.invokeContinuationMethod(memberDetailController, conti);  

        //Check : No cases in salesforce with the selected surrogate key
        Set<String> surrogateKeysList = memberDetailController.MemberDetail.SurrogateKeys;
        system.debug('surrogateKeysList  :: '+surrogateKeysList );
        ////system.assert(surrogateKeysList.size() == 2);
        List<Case> caseList = [Select Id From Case where Surrogate_Key__c =: surrogateKeysList ];
        //system.assert(caseList.isEmpty());
        
        if(memberDetailController.MemberDetail.CoverageLines != null && memberDetailController.MemberDetail.CoverageLines.size() > 0)
        memberDetailController.ProferredCoverageGUID = +memberDetailController.MemberDetail.CoverageLines[0].guid;          
        memberDetailController.toggleShowCoverages();
        memberDetailController.selectPreferredCoverage();

        //call get membership function
        Continuation conti2 = (Continuation)memberDetailController.CallGetMembership();
        /****
        Map<String, HttpRequest> requests2 = conti2.getRequests();

        for(String RequestLabel: requests2.keyset()){
            request = requests2.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            system.debug(RequestLabel +' :: '+request);
            if(request.getEndpoint().contains('/api/alpha/eisl/individuals/membership/v2.0/read')) {
                system.debug('2323inside GetmemberShip');
                response.setBody('{"getMembershipResponse":{"membership":{"sourceSysCode":"CR","coverages":[{"groupNumber":"1118478","groupName":"Membership_services_MG33","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"0","benefitBundleOptionDescription":"MNRP PlanOptionDesc","benefitEffectiveDate":"2015-01-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"M000000015","benefitPlanName":"CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C","benefitType":"MD","coverageLevelCode":"FAM","relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"69688001800","subscriberIdCardSerialNumber":"69688001800","eligibilityStatusCode":"A","cancelReasonTypeCode":"","planType":"02","indicators":{"qmscoIndicator":"N"}}]}]}],"cob":[{}],"providers": [{"providerIdentifiers": [{ "id": "NHP260", "type": "PUL"}, {   "id": "1407810955", "type": "NPI"}, {   "id": "110001474",  "type": "1C"}, {    "id": "772445246578629791", "type": "LTK"}, {   "id": "130363003",  "type": "SY"}, {    "id": "1214988",    "type": "MPI"}],"assignmentType": "PCP","effectiveDate": "2017-04-01","expirationDate": "9999-12-31","firstName": "MICHAEL","lastName": "PARKER","networkId": "1018476","organizationLocationId": "0"'+
                        '}],"identifiers":[{"id":"890504596","type":"enrolleeSurrogateKey"},{"id":"154907823","type":"enrolleeIndividualIdentifier"},{"id":"23462613","type":"enrolleeSystemID"},{"id":"23462613","type":"subscriberSystemID"},{"id":"154907823","type":"subscriberIndividualIdentifer"},{"id":"890504596","type":"subscriberSurrogateKey"}]}}}');                
            }      
            else if(request.getEndpoint().contains('/api/alpha/eisl/individuals/familymembership/v2.0/read')) {
                response.setBody('{"getFamilyMembershipResponse": {"individual": [{"individualIdentifier": "154907823","name": {"firstName": "Ruby","lastName": "Kelly","middleName": "","nameSuffix": ""},"birthDate": "1959-09-21","genderCode": "M","genderDescription": "Male","socialSecurityNumber": "689220485","address": [{"typeCode": "HOM","addressLine1": "95 Elgar Pass","addressLine2": "","city": "HFD","postalCode": "06140","stateCode": "CT","countryCode": "US"}],"membership": [{"sourceSysCode": "CR","coverages": [{"groupNumber": "1118478","groupName": "Membership_services_MG33","eligibilitySystemTypeCode": "CR","claimSystemTypeCode": "CR","bundleOptions": [{"benefits": [{"benefitBundleOptionId": "0","benefitBundleOptionDescription": "MNRP PlanOptionDesc","benefitEffectiveDate": "2015-01-01","benefitExpirationDate": "9999-12-31","benefitPlanId": "M000000015","benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C","benefitType": "MD","coverageLevelCode": "FAM","relationshipCode": "18","relationshipDescription": "Self","memberIdCardSerialNumber": "69688001800","subscriberIdCardSerialNumber": "69688001800","eligibilityStatusCode": "A","cancelReasonTypeCode": "","planType": "02"}]}]}],"cob": [{}],"providers": [{}],"identifiers": [{"id": "23462613","type": "subscriberSystemId"},{"id": "23462613","type": "enrolleeSystemID"},{"id": "890504596","type": "subscriberSurrogateKey"},{"id": "890504596","type": "enrolleeSurrogateKey"},{"id": "154907823","type": "enrolleeEID"}]}]}]}}');
            }     
            Test.setContinuationResponse(RequestLabel, response); 
        }
        Object result2 = Test.invokeContinuationMethod(memberDetailController, conti2);
        *****/
        //check : New contact and account is created with selected member
       /**** String fName = ApexPages.currentPage().getParameters().get('firstName');
        String lName = ApexPages.currentPage().getParameters().get('lastName');
        List<Contact> contactlist = [Select Id, name, eid__c, accountId, phone From Contact  where EID__C =:mchId]; 
        ***/
        ////system.assert(!contactlist.isEmpty());
        //check : Contact list will have only one contact ruby kelly as no other family members
        ////system.assert(contactlist.size() == 1);
        //system.debug('contactlist >>> '+contactlist);
        
        
        //Create few call topic cases
        /**** 
        Interaction__c interact = ACETMemberQueryUtil.queryInteraction(interactionId);
        if(contactlist != null && contactlist.size() > 0)
                interact.Originator__c = contactlist[0].Id;
        update  interact;
        
        Case case1 = new Case(contactId=contactlist[0].Id,accountId=contactlist[0].accountId,Surrogate_Key__c= '890504596',Interaction__c=interact.Id);
        Case case2 = new Case(contactId=contactlist[0].Id,accountId=contactlist[0].accountId,Surrogate_Key__c= '898987679',Interaction__c=interact.Id);
        insert case1;
        insert case2;
        
        ****/
        
        
    }
    
    static testMethod void UpdateContactTest() {
        
        NewContactTest();
        
        ACETMemberDetailController memberDetailController = new ACETMemberDetailController();
        String interactionId = ApexPages.currentPage().getParameters().get('InteractionId');
        String mchId = ApexPages.currentPage().getParameters().get('Id');
        String srk = ApexPages.currentPage().getParameters().get('SRK');
        
        //Check : new interaction created
        //system.assertNotEquals(interactionId, null);
        
        //check : No contact and account with selected member 
        String contactName = ApexPages.currentPage().getParameters().get('firstName') + ' ' + ApexPages.currentPage().getParameters().get('lastName');
        List<Contact> contactlist = [Select Id From Contact where EID__C =:mchId];      
        ////system.assert(!contactlist.isEmpty());
        
        Continuation conti = (Continuation)memberDetailController.CallWSonPageLoad();
        Map<String, HttpRequest> requests = conti.getRequests();

        HttpResponse response;
        HttpRequest request;

        for(String RequestLabel: requests.keyset()){
            request = requests.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            if(request.getEndpoint().contains('/api/alpha/eisl/individuals/v2.0/read')) {
                response.setBody('{"getIndividualResponse":{"individual":{"individualIdentifier":"154907823","name":{"firstName":"Ruby","lastName":"Kelly","middleName":"","nameSuffix":""},"birthDate":"1959-09-21","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"","maritalStatusCode":"","maritalStatusDescription":"","deceasedDate":"","privacyIndicator":"","tobaccoUsageIndicator":"","ethnicityCode":"","ethnicityDescription":"","address":[{"typeCode":"HOM","addressLine1":"95 Elgar Pass","addressLine2":"","city":"HFD","postalCode":"06140","stateCode":"CT","countryCode":"US"}],"phone":[{"phoneType":"H","phoneNumber":"321-686-8888","phoneExt":"","internationalIndicator":"N","primaryIndicator":"Y"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"ruby@optum.com","primaryIndicator":"Y"}],"employment":[{"employmentStatus":"","employeeIdentifier":"","employmentStartDate":"","retirementDate":""}],"language":[{}],"otherContact":[{}],"identifiers":[{"id":"890504596","type":"SRK"},{"id":"898987679","type":"SRK"},{"id":"898987777","type":"SRK"},{"id":"898987888","type":"SRK"},{"id":"352816681","type":"HIC"}]}}}');
            }      
            else if(request.getEndpoint().contains('/api/alpha/eisl/individuals/membership/v2.0/search')) {
                response.setBody('{"findMembershipsResponse": { "memberships": [{       "sourceSysCode": "CR",      "coverages": [{         "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "890504596",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }, {            "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "898987679",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }],     "identifiers": [{           "id": "352816681",          "type": "HIC"       }, {            "id": "69688001800",            "type": "SCR"       }, {            "id": "69688001800",            "type": "MCH"       }],     "enrolleeSystemSpecificIdentifiers": [{         "id": "23462613",           "type": "enrolleeSystemID"      }, {            "id": "154907823",          "type": "enrolleeIndividualIdentifier"      }, {            "id": "890504596",          "type": "enrolleeSurrogateKey"      }]  }, {        "sourceSysCode": "CR",      "coverages": [{         "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "890504596",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }, {            "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "898987679",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }],     "identifiers": [{           "id": "352816681",          "type": "HIC"       }, {            "id": "69688001800",            "type": "SCR"       }, {            "id": "69688001800",            "type": "MCH"       }],     "enrolleeSystemSpecificIdentifiers": [{         "id": "23462613",           "type": "enrolleeSystemID"      }, {            "id": "154907823",          "type": "enrolleeIndividualIdentifier"      }, {            "id": "898987679",          "type": "enrolleeSurrogateKey"      }]  },  {       "sourceSysCode": "CR",      "coverages": [{         "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "890504596",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }, {            "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "898987679",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }],     "identifiers": [{           "id": "352816681",          "type": "HIC"       }, {            "id": "69688001800",            "type": "SCR"       }, {            "id": "69688001800",            "type": "MCH"       }],     "enrolleeSystemSpecificIdentifiers": [{         "id": "23462613",           "type": "enrolleeSystemID"      }, {            "id": "154907823",          "type": "enrolleeIndividualIdentifier"      }, {            "id": "898987777",          "type": "enrolleeSurrogateKey"      }]  }, {        "sourceSysCode": "CR",      "coverages": [{         "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "890504596",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }, {            "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "898987679",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }],     "identifiers": [{           "id": "352816681",          "type": "HIC"       }, {            "id": "69688001800",            "type": "SCR"       }, {            "id": "69688001800",            "type": "MCH"       }],     "enrolleeSystemSpecificIdentifiers": [{         "id": "23462613",           "type": "enrolleeSystemID"      }, {            "id": "154907823",          "type": "enrolleeIndividualIdentifier"      }, {            "id": "898987888",          "type": "enrolleeSurrogateKey"      }]  }], "pagination": {     "pageNumber": "1",      "pageSize": "5",        "recordCount": "1",     "totalCount": "1",      "totalPages": "1"   }}}');
            }     
            Test.setContinuationResponse(RequestLabel, response); 
        }
        Object result = Test.invokeContinuationMethod(memberDetailController, conti);  

        //Check : No cases in salesforce with the selected surrogate key
        Set<String> surrogateKeysList = memberDetailController.MemberDetail.SurrogateKeys;
        //system.assert(surrogateKeysList.size() == 4);
        List<Case> caseList = [Select Id From Case where Surrogate_Key__c =: surrogateKeysList ];
        //system.assert(!caseList.isEmpty());
        //system.assert(caseList.size() == 2);
        
        if(memberDetailController.MemberDetail.CoverageLines != null && memberDetailController.MemberDetail.CoverageLines.size() > 0)
        memberDetailController.ProferredCoverageGUID = +memberDetailController.MemberDetail.CoverageLines[0].guid;          
        memberDetailController.toggleShowCoverages();
        memberDetailController.selectPreferredCoverage();

        //call get membership function
        Continuation conti2 = (Continuation)memberDetailController.CallGetMembership();
        /*****
        Map<String, HttpRequest> requests2 = conti2.getRequests();

        for(String RequestLabel: requests2.keyset()){
            request = requests2.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            system.debug(RequestLabel +' :: '+request);
            if(request.getEndpoint().contains('/api/alpha/eisl/individuals/membership/v2.0/read')) {
                system.debug('2323inside GetmemberShip');
                response.setBody('{"getMembershipResponse":{"membership":{"sourceSysCode":"CR","coverages":[{"groupNumber":"1118478","groupName":"Membership_services_MG33","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"0","benefitBundleOptionDescription":"MNRP PlanOptionDesc","benefitEffectiveDate":"2015-01-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"M000000015","benefitPlanName":"CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C","benefitType":"MD","coverageLevelCode":"FAM","relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"69688001800","subscriberIdCardSerialNumber":"69688001800","eligibilityStatusCode":"A","cancelReasonTypeCode":"","planType":"02","indicators":{"qmscoIndicator":"N"}}]}]}],"cob":[{}],"providers": [{"providerIdentifiers": [{ "id": "NHP260", "type": "PUL"}, {   "id": "1407810955", "type": "NPI"}, {   "id": "110001474",  "type": "1C"}, {    "id": "772445246578629791", "type": "LTK"}, {   "id": "130363003",  "type": "SY"}, {    "id": "1214988",    "type": "MPI"}],"assignmentType": "PCP","effectiveDate": "2017-04-01","expirationDate": "9999-12-31","firstName": "MICHAEL","lastName": "PARKER","networkId": "1018476","organizationLocationId": "0"'+
                        '}],"identifiers":[{"id":"890504596","type":"enrolleeSurrogateKey"},{"id":"154907823","type":"enrolleeIndividualIdentifier"},{"id":"23462613","type":"enrolleeSystemID"},{"id":"23462613","type":"subscriberSystemID"},{"id":"154907823","type":"subscriberIndividualIdentifer"},{"id":"890504596","type":"subscriberSurrogateKey"}]}}}');                
            }      
            else if(request.getEndpoint().contains('/api/alpha/eisl/individuals/familymembership/v2.0/read')) {
                response.setBody('{"getFamilyMembershipResponse": {"individual": [{"individualIdentifier": "154907823","name": {"firstName": "Ruby","lastName": "Kelly","middleName": "","nameSuffix": ""},"birthDate": "1959-09-21","genderCode": "M","genderDescription": "Male","socialSecurityNumber": "689220485","address": [{"typeCode": "HOM","addressLine1": "95 Elgar Pass","addressLine2": "","city": "HFD","postalCode": "06140","stateCode": "CT","countryCode": "US"}],"membership": [{"sourceSysCode": "CR","coverages": [{"groupNumber": "1118478","groupName": "Membership_services_MG33","eligibilitySystemTypeCode": "CR","claimSystemTypeCode": "CR","bundleOptions": [{"benefits": [{"benefitBundleOptionId": "0","benefitBundleOptionDescription": "MNRP PlanOptionDesc","benefitEffectiveDate": "2015-01-01","benefitExpirationDate": "9999-12-31","benefitPlanId": "M000000015","benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C","benefitType": "MD","coverageLevelCode": "FAM","relationshipCode": "18","relationshipDescription": "Self","memberIdCardSerialNumber": "69688001800","subscriberIdCardSerialNumber": "69688001800","eligibilityStatusCode": "A","cancelReasonTypeCode": "","planType": "02"}]}]}],"cob": [{}],"providers": [{}],"identifiers": [{"id": "23462613","type": "subscriberSystemId"},{"id": "23462613","type": "enrolleeSystemID"},{"id": "890504596","type": "subscriberSurrogateKey"},{"id": "890504596","type": "enrolleeSurrogateKey"},{"id": "154907823","type": "enrolleeEID"}]}]}]}}');
            }     
            Test.setContinuationResponse(RequestLabel, response); 
        }
        Object result2 = Test.invokeContinuationMethod(memberDetailController, conti2);
        
        //check : New contact and account is created with selected member
        String fName = ApexPages.currentPage().getParameters().get('firstName');
        String lName = ApexPages.currentPage().getParameters().get('lastName');
        contactlist = [Select Id, name, eid__c, accountId,phone From Contact  where EID__C =:mchId];        
        //system.assert(!contactlist.isEmpty());
        //check : Contact list will have only one contact ruby kelly as no other family members
        //system.assert(contactlist.size() == 1);
        system.debug('contactlist >>> '+contactlist);
        
        
        //Create few call topic cases
         
        Interaction__c interact = ACETMemberQueryUtil.queryInteraction(interactionId);
        interact.Originator__c = contactlist[0].Id;
        update  interact;
        
        Case case1 = new Case(contactId=contactlist[0].Id,accountId=contactlist[0].accountId,Surrogate_Key__c= '898987888',Interaction__c=interact.Id);
        Case case2 = new Case(contactId=contactlist[0].Id,accountId=contactlist[0].accountId,Surrogate_Key__c= '898987777',Interaction__c=interact.Id);
        insert case1;
        insert case2;
        
        List<Case> caseListNew = [select id from case where Surrogate_Key__C in : memberDetailController.MemberDetail.SurrogateKeys];
        //system.assert(caseListNew.size() == 4);
        
        *****/
        
    }
static testMethod void UpdateAccountTest() {
        
        NewContactTest();
        
        ACETMemberDetailController memberDetailController = new ACETMemberDetailController();
        String interactionId = ApexPages.currentPage().getParameters().get('InteractionId');
        String mchId = ApexPages.currentPage().getParameters().get('Id');
        String srk = ApexPages.currentPage().getParameters().get('SRK');
        
        //Check : new interaction created
        //system.assertNotEquals(interactionId, null);
        
        //check : No contact and account with selected member 
        String contactName = ApexPages.currentPage().getParameters().get('firstName') + ' ' + ApexPages.currentPage().getParameters().get('lastName');
        List<Contact> contactlist = [Select Id From Contact where EID__C =:mchId];      
        //system.assert(!contactlist.isEmpty());
        
        Continuation conti = (Continuation)memberDetailController.CallWSonPageLoad();
        Map<String, HttpRequest> requests = conti.getRequests();

        HttpResponse response;
        HttpRequest request;

        for(String RequestLabel: requests.keyset()){
            request = requests.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            if(request.getEndpoint().contains('/api/alpha/eisl/individuals/v2.0/read')) {
                response.setBody('{"getIndividualResponse":{"individual":{"individualIdentifier":"154907823","name":{"firstName":"Ruby","lastName":"Kelly","middleName":"","nameSuffix":""},"birthDate":"1959-09-21","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"","maritalStatusCode":"","maritalStatusDescription":"","deceasedDate":"","privacyIndicator":"","tobaccoUsageIndicator":"","ethnicityCode":"","ethnicityDescription":"","address":[{"typeCode":"HOM","addressLine1":"95 Elgar Pass","addressLine2":"","city":"HFD","postalCode":"06140","stateCode":"CT","countryCode":"US"}],"phone":[{"phoneType":"H","phoneNumber":"321-686-8888","phoneExt":"","internationalIndicator":"N","primaryIndicator":"Y"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"ruby@optum.com","primaryIndicator":"Y"}],"employment":[{"employmentStatus":"","employeeIdentifier":"","employmentStartDate":"","retirementDate":""}],"language":[{}],"otherContact":[{}],"identifiers":[{"id":"890504596","type":"SRK"},{"id":"898987679","type":"SRK"},{"id":"898987777","type":"SRK"},{"id":"898987888","type":"SRK"},{"id":"352816681","type":"HIC"}]}}}');
            }      
            else if(request.getEndpoint().contains('/api/alpha/eisl/individuals/membership/v2.0/search')) {
                response.setBody('{"findMembershipsResponse": { "memberships": [{       "sourceSysCode": "CR",      "coverages": [{         "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "890504596",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }, {            "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "898987679",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }],     "identifiers": [{           "id": "352816681",          "type": "HIC"       }, {            "id": "69688001800",            "type": "SCR"       }, {            "id": "69688001800",            "type": "MCH"       }],     "enrolleeSystemSpecificIdentifiers": [{         "id": "23462613",           "type": "enrolleeSystemID"      }, {            "id": "154907823",          "type": "enrolleeIndividualIdentifier"      }, {            "id": "890504596",          "type": "enrolleeSurrogateKey"      }]  }, {        "sourceSysCode": "CR",      "coverages": [{         "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "890504596",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }, {            "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "898987679",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }],     "identifiers": [{           "id": "352816681",          "type": "HIC"       }, {            "id": "69688001800",            "type": "SCR"       }, {            "id": "69688001800",            "type": "MCH"       }],     "enrolleeSystemSpecificIdentifiers": [{         "id": "23462613",           "type": "enrolleeSystemID"      }, {            "id": "154907823",          "type": "enrolleeIndividualIdentifier"      }, {            "id": "898987679",          "type": "enrolleeSurrogateKey"      }]  },  {       "sourceSysCode": "CR",      "coverages": [{         "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "890504596",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }, {            "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "898987679",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }],     "identifiers": [{           "id": "352816681",          "type": "HIC"       }, {            "id": "69688001800",            "type": "SCR"       }, {            "id": "69688001800",            "type": "MCH"       }],     "enrolleeSystemSpecificIdentifiers": [{         "id": "23462613",           "type": "enrolleeSystemID"      }, {            "id": "154907823",          "type": "enrolleeIndividualIdentifier"      }, {            "id": "898987777",          "type": "enrolleeSurrogateKey"      }]  }, {        "sourceSysCode": "CR",      "coverages": [{         "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "890504596",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }, {            "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "898987679",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }],     "identifiers": [{           "id": "352816681",          "type": "HIC"       }, {            "id": "69688001800",            "type": "SCR"       }, {            "id": "69688001800",            "type": "MCH"       }],     "enrolleeSystemSpecificIdentifiers": [{         "id": "23462613",           "type": "enrolleeSystemID"      }, {            "id": "154907823",          "type": "enrolleeIndividualIdentifier"      }, {            "id": "898987888",          "type": "enrolleeSurrogateKey"      }]  }], "pagination": {     "pageNumber": "1",      "pageSize": "5",        "recordCount": "1",     "totalCount": "1",      "totalPages": "1"   }}}');
            }     
            Test.setContinuationResponse(RequestLabel, response); 
        }
        Object result = Test.invokeContinuationMethod(memberDetailController, conti);  

        //Check : No cases in salesforce with the selected surrogate key
        Set<String> surrogateKeysList = memberDetailController.MemberDetail.SurrogateKeys;
        //system.assert(surrogateKeysList.size() == 4);
        List<Case> caseList = [Select Id From Case where Surrogate_Key__c =: surrogateKeysList ];
        //system.assert(!caseList.isEmpty());
        //system.assert(caseList.size() == 2);
        
        if(memberDetailController.MemberDetail.CoverageLines != null && memberDetailController.MemberDetail.CoverageLines.size() > 0)
        memberDetailController.ProferredCoverageGUID = +memberDetailController.MemberDetail.CoverageLines[0].guid;          
        memberDetailController.toggleShowCoverages();
        memberDetailController.selectPreferredCoverage();

        //call get membership function
        /***
        Continuation conti2 = (Continuation)memberDetailController.CallGetMembership();
        Map<String, HttpRequest> requests2 = conti2.getRequests();

        for(String RequestLabel: requests2.keyset()){
            request = requests2.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            system.debug(RequestLabel +' :: '+request);
            if(request.getEndpoint().contains('/api/alpha/eisl/individuals/membership/v2.0/read')) {
                system.debug('2323inside GetmemberShip');
                response.setBody('{"getMembershipResponse":{"membership":{"sourceSysCode":"CR","coverages":[{"groupNumber":"1118478","groupName":"Membership_services_MG33","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"0","benefitBundleOptionDescription":"MNRP PlanOptionDesc","benefitEffectiveDate":"2015-01-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"M000000015","benefitPlanName":"CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C","benefitType":"MD","coverageLevelCode":"FAM","relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"69688001800","subscriberIdCardSerialNumber":"69688001800","eligibilityStatusCode":"A","cancelReasonTypeCode":"","planType":"02","indicators":{"qmscoIndicator":"N"}}]}]}],"cob":[{}],"providers": [{"providerIdentifiers": [{ "id": "NHP260", "type": "PUL"}, {   "id": "1407810955", "type": "NPI"}, {   "id": "110001474",  "type": "1C"}, {    "id": "772445246578629791", "type": "LTK"}, {   "id": "130363003",  "type": "SY"}, {    "id": "1214988",    "type": "MPI"}],"assignmentType": "PCP","effectiveDate": "2017-04-01","expirationDate": "9999-12-31","firstName": "MICHAEL","lastName": "PARKER","networkId": "1018476","organizationLocationId": "0"'+
                        '}],"identifiers":[{"id":"890504596","type":"enrolleeSurrogateKey"},{"id":"154907823","type":"enrolleeIndividualIdentifier"},{"id":"23462613","type":"enrolleeSystemID"},{"id":"23462613","type":"subscriberSystemID"},{"id":"154907823","type":"subscriberIndividualIdentifer"},{"id":"890504596","type":"subscriberSurrogateKey"}]}}}');                
            }      
            else if(request.getEndpoint().contains('/api/alpha/eisl/individuals/familymembership/v2.0/read')) {
                response.setBody('{"getFamilyMembershipResponse": {"individual": [{"individualIdentifier": "154907823","name": {"firstName": "Ruby","lastName": "Kelly","middleName": "","nameSuffix": ""},"birthDate": "1959-09-21","genderCode": "M","genderDescription": "Male","socialSecurityNumber": "689220485","address": [{"typeCode": "HOM","addressLine1": "95 Elgar Pass","addressLine2": "","city": "HFD","postalCode": "06140","stateCode": "CT","countryCode": "US"}],"membership": [{"sourceSysCode": "CR","coverages": [{"groupNumber": "1118478","groupName": "Membership_services_MG33","eligibilitySystemTypeCode": "CR","claimSystemTypeCode": "CR","bundleOptions": [{"benefits": [{"benefitBundleOptionId": "0","benefitBundleOptionDescription": "MNRP PlanOptionDesc","benefitEffectiveDate": "2015-01-01","benefitExpirationDate": "9999-12-31","benefitPlanId": "M000000015","benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C","benefitType": "MD","coverageLevelCode": "FAM","relationshipCode": "18","relationshipDescription": "Self","memberIdCardSerialNumber": "69688001800","subscriberIdCardSerialNumber": "69688001800","eligibilityStatusCode": "A","cancelReasonTypeCode": "","planType": "02"}]}]}],"cob": [{}],"providers": [{}],"identifiers": [{"id": "23462613","type": "subscriberSystemId"},{"id": "23462613","type": "enrolleeSystemID"},{"id": "890504596","type": "subscriberSurrogateKey"},{"id": "890504596","type": "enrolleeSurrogateKey"},{"id": "154907823","type": "enrolleeEID"}]}]}]}}');
            }     
            Test.setContinuationResponse(RequestLabel, response); 
        }
        Object result2 = Test.invokeContinuationMethod(memberDetailController, conti2);
        
        //check : New contact and account is created with selected member
        String fName = ApexPages.currentPage().getParameters().get('firstName');
        String lName = ApexPages.currentPage().getParameters().get('lastName');
        contactlist = [Select Id, name, eid__c, accountId,phone From Contact  where EID__C =:mchId];        
        //system.assert(!contactlist.isEmpty());
        //check : Contact list will have only one contact ruby kelly as no other family members
        //system.assert(contactlist.size() == 1);
        system.debug('contactlist >>> '+contactlist);
        
        
        //Create few call topic cases
         
        Interaction__c interact = ACETMemberQueryUtil.queryInteraction(interactionId);
        interact.Originator__c = contactlist[0].Id;
        update  interact;
        
        Case case1 = new Case(contactId=contactlist[0].Id,accountId=contactlist[0].accountId,Surrogate_Key__c= '898987888',Interaction__c=interact.Id);
        Case case2 = new Case(contactId=contactlist[0].Id,accountId=contactlist[0].accountId,Surrogate_Key__c= '898987777',Interaction__c=interact.Id);
        insert case1;
        insert case2;
        
        List<Case> caseListNew = [select id from case where Surrogate_Key__C in : memberDetailController.MemberDetail.SurrogateKeys];
        //system.assert(caseListNew.size() == 4);
        ***/
        
        
    }       
static testMethod void OrphanCaseTest() {
        
        //Below line will create new contact, will create two call topics cases , then on next call will update contact and create two more cases
        UpdateContactTest();
        
        ACETMemberDetailController memberDetailController = new ACETMemberDetailController();
        String interactionId = ApexPages.currentPage().getParameters().get('InteractionId');
        String mchId = ApexPages.currentPage().getParameters().get('Id');
        String srk = ApexPages.currentPage().getParameters().get('SRK');
        
        //Check : new interaction created
        //system.assertNotEquals(interactionId, null);
        
        //check : No contact and account with selected member 
        String contactName = ApexPages.currentPage().getParameters().get('firstName') + ' ' + ApexPages.currentPage().getParameters().get('lastName');
        List<Contact> contactlist = [Select Id From Contact where EID__C =:mchId];      
        //system.assert(!contactlist.isEmpty());
        
        Continuation conti = (Continuation)memberDetailController.CallWSonPageLoad();
        Map<String, HttpRequest> requests = conti.getRequests();

        HttpResponse response;
        HttpRequest request;

        for(String RequestLabel: requests.keyset()){
            request = requests.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            if(request.getEndpoint().contains('/api/alpha/eisl/individuals/v2.0/read')) {
                response.setBody('{"getIndividualResponse":{"individual":{"individualIdentifier":"154907823","name":{"firstName":"Ruby","lastName":"Kelly","middleName":"","nameSuffix":""},"birthDate":"1959-09-21","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"","maritalStatusCode":"","maritalStatusDescription":"","deceasedDate":"","privacyIndicator":"","tobaccoUsageIndicator":"","ethnicityCode":"","ethnicityDescription":"","address":[{"typeCode":"HOM","addressLine1":"95 Elgar Pass","addressLine2":"","city":"HFD","postalCode":"06140","stateCode":"CT","countryCode":"US"}],"phone":[{"phoneType":"H","phoneNumber":"321-686-8888","phoneExt":"","internationalIndicator":"N","primaryIndicator":"Y"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"ruby@optum.com","primaryIndicator":"Y"}],"employment":[{"employmentStatus":"","employeeIdentifier":"","employmentStartDate":"","retirementDate":""}],"language":[{}],"otherContact":[{}],"identifiers":[{"id":"890504596","type":"SRK"},{"id":"898987679","type":"SRK"},{"id":"352816681","type":"HIC"}]}}}');
            }      
            else if(request.getEndpoint().contains('/api/alpha/eisl/individuals/membership/v2.0/search')) {
                response.setBody('{"findMembershipsResponse": { "memberships": [{       "sourceSysCode": "CR",      "coverages": [{         "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "890504596",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }, {            "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "898987679",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }],     "identifiers": [{           "id": "352816681",          "type": "HIC"       }, {            "id": "69688001800",            "type": "SCR"       }, {            "id": "69688001800",            "type": "MCH"       }],     "enrolleeSystemSpecificIdentifiers": [{         "id": "23462613",           "type": "enrolleeSystemID"      }, {            "id": "154907823",          "type": "enrolleeIndividualIdentifier"      }, {            "id": "890504596",          "type": "enrolleeSurrogateKey"      }]  }, {        "sourceSysCode": "CR",      "coverages": [{         "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "890504596",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }, {            "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "898987679",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }],     "identifiers": [{           "id": "352816681",          "type": "HIC"       }, {            "id": "69688001800",            "type": "SCR"       }, {            "id": "69688001800",            "type": "MCH"       }],     "enrolleeSystemSpecificIdentifiers": [{         "id": "23462613",           "type": "enrolleeSystemID"      }, {            "id": "154907823",          "type": "enrolleeIndividualIdentifier"      }, {            "id": "898987679",          "type": "enrolleeSurrogateKey"      }]  }], "pagination": {     "pageNumber": "1",      "pageSize": "5",        "recordCount": "1",     "totalCount": "1",      "totalPages": "1"   }}}');
            }     
            Test.setContinuationResponse(RequestLabel, response); 
        }
        Object result = Test.invokeContinuationMethod(memberDetailController, conti);  

        //Check : No cases in salesforce with the selected surrogate key
        Set<String> surrogateKeysList = memberDetailController.MemberDetail.SurrogateKeys;
        //system.assert(surrogateKeysList.size() == 2);
        List<Case> caseList = [Select Id From Case where Surrogate_Key__c =: surrogateKeysList ];
        //system.assert(!caseList.isEmpty());
        //system.assert(caseList.size() == 2);
        
        if(memberDetailController.MemberDetail.CoverageLines != null && memberDetailController.MemberDetail.CoverageLines.size() > 0)
        memberDetailController.ProferredCoverageGUID = +memberDetailController.MemberDetail.CoverageLines[0].guid;          
        memberDetailController.toggleShowCoverages();
        memberDetailController.selectPreferredCoverage();
        /****
        //call get membership function
        Continuation conti2 = (Continuation)memberDetailController.CallGetMembership();
        Map<String, HttpRequest> requests2 = conti2.getRequests();

        for(String RequestLabel: requests2.keyset()){
            request = requests2.get(RequestLabel);
            response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            system.debug(RequestLabel +' :: '+request);
            if(request.getEndpoint().contains('/api/alpha/eisl/individuals/membership/v2.0/read')) {
                system.debug('2323inside GetmemberShip');
                response.setBody('{"getMembershipResponse":{"membership":{"sourceSysCode":"CR","coverages":[{"groupNumber":"1118478","groupName":"Membership_services_MG33","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"0","benefitBundleOptionDescription":"MNRP PlanOptionDesc","benefitEffectiveDate":"2015-01-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"M000000015","benefitPlanName":"CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C","benefitType":"MD","coverageLevelCode":"FAM","relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"69688001800","subscriberIdCardSerialNumber":"69688001800","eligibilityStatusCode":"A","cancelReasonTypeCode":"","planType":"02","indicators":{"qmscoIndicator":"N"}}]}]}],"cob":[{}],"providers": [{"providerIdentifiers": [{ "id": "NHP260", "type": "PUL"}, {   "id": "1407810955", "type": "NPI"}, {   "id": "110001474",  "type": "1C"}, {    "id": "772445246578629791", "type": "LTK"}, {   "id": "130363003",  "type": "SY"}, {    "id": "1214988",    "type": "MPI"}],"assignmentType": "PCP","effectiveDate": "2017-04-01","expirationDate": "9999-12-31","firstName": "MICHAEL","lastName": "PARKER","networkId": "1018476","organizationLocationId": "0"'+
                        '}],"identifiers":[{"id":"890504596","type":"enrolleeSurrogateKey"},{"id":"154907823","type":"enrolleeIndividualIdentifier"},{"id":"23462613","type":"enrolleeSystemID"},{"id":"23462613","type":"subscriberSystemID"},{"id":"154907823","type":"subscriberIndividualIdentifer"},{"id":"890504596","type":"subscriberSurrogateKey"}]}}}');                
            }      
            else if(request.getEndpoint().contains('/api/alpha/eisl/individuals/familymembership/v2.0/read')) {
                response.setBody('{"getFamilyMembershipResponse": {"individual": [{"individualIdentifier": "154907823","name": {"firstName": "Ruby","lastName": "Kelly","middleName": "","nameSuffix": ""},"birthDate": "1959-09-21","genderCode": "M","genderDescription": "Male","socialSecurityNumber": "689220485","address": [{"typeCode": "HOM","addressLine1": "95 Elgar Pass","addressLine2": "","city": "HFD","postalCode": "06140","stateCode": "CT","countryCode": "US"}],"membership": [{"sourceSysCode": "CR","coverages": [{"groupNumber": "1118478","groupName": "Membership_services_MG33","eligibilitySystemTypeCode": "CR","claimSystemTypeCode": "CR","bundleOptions": [{"benefits": [{"benefitBundleOptionId": "0","benefitBundleOptionDescription": "MNRP PlanOptionDesc","benefitEffectiveDate": "2015-01-01","benefitExpirationDate": "9999-12-31","benefitPlanId": "M000000015","benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C","benefitType": "MD","coverageLevelCode": "FAM","relationshipCode": "18","relationshipDescription": "Self","memberIdCardSerialNumber": "69688001800","subscriberIdCardSerialNumber": "69688001800","eligibilityStatusCode": "A","cancelReasonTypeCode": "","planType": "02"}]}]}],"cob": [{}],"providers": [{}],"identifiers": [{"id": "23462613","type": "subscriberSystemId"},{"id": "23462613","type": "enrolleeSystemID"},{"id": "890504596","type": "subscriberSurrogateKey"},{"id": "890504596","type": "enrolleeSurrogateKey"},{"id": "154907823","type": "enrolleeEID"}]}]}]}}');
            }     
            Test.setContinuationResponse(RequestLabel, response); 
        }
        Object result2 = Test.invokeContinuationMethod(memberDetailController, conti2);
        
        //check : New contact and account is created with selected member
        String fName = ApexPages.currentPage().getParameters().get('firstName');
        String lName = ApexPages.currentPage().getParameters().get('lastName');
        contactlist = [Select Id, name, eid__c, accountId,phone From Contact  where EID__C =:mchId];        
        //system.assert(!contactlist.isEmpty());
        //check : Contact list will have only one contact ruby kelly as no other family members
        //system.assert(contactlist.size() == 1);
        system.debug('contactlist >>> '+contactlist);
        
        
        //Create few call topic cases
         
        Interaction__c interact = ACETMemberQueryUtil.queryInteraction(interactionId);
        interact.Originator__c = contactlist[0].Id;
        update  interact;
        
        List<Case> caseListNew = [select id,ContactId from case where Surrogate_Key__C in : memberDetailController.MemberDetail.SurrogateKeys];
        //system.assert(caseListNew.size() == 2);
        
        //check : total cases in system
        List<Case> totalCases = [select id, ContactId from case];
        //system.assert(totalCases.size() == 4);
        //check : 2 cases should have contact and 2 cases should not
        Integer orphanCase = 0;
        Integer contactCase = 0;
        for(Case c : totalCases){
            if(!String.isEmpty(c.ContactId)){
                contactCase ++;
            }else{
                orphanCase ++;
            }
        }
        //system.assert(contactCase == 2);
        //system.assert(orphanCase == 2);
    ****/
    }
static testMethod void ReparentOrphanCaseTest() {
    
    //Below line will create new contact, will create two call topics cases , then on next call will update contact and create two more cases
    OrphanCaseTest();
    
    ACETMemberDetailController memberDetailController = new ACETMemberDetailController();
    String interactionId = ApexPages.currentPage().getParameters().get('InteractionId');

    //Setting new  mschId for a new contact from OIL
    ApexPages.currentPage().getParameters().put('Id','89786758');
    ApexPages.currentPage().getParameters().put('firstName','Ruby_1');
    ApexPages.currentPage().getParameters().put('lastName','Kelly_1');  
    
    String mchId = ApexPages.currentPage().getParameters().get('Id');
        String srk = ApexPages.currentPage().getParameters().get('SRK');
    
    //Check : new interaction created
    //system.assertNotEquals(interactionId, null);
    
    //check : No contact and account with selected member 
    List<Contact> contactlist = [Select Id From Contact where EID__C =:mchId];      
        //system.assert(contactlist.isEmpty());
        
    Continuation conti = (Continuation)memberDetailController.CallWSonPageLoad();
    Map<String, HttpRequest> requests = conti.getRequests();

    HttpResponse response;
    HttpRequest request;

    for(String RequestLabel: requests.keyset()){
        request = requests.get(RequestLabel);
        response = new HttpResponse();
        response.setStatusCode(200);
        response.setStatus('OK');
        if(request.getEndpoint().contains('/api/alpha/eisl/individuals/v2.0/read')) {
            //Setting same surrogate key which orphan case have in the system for a this fresh new contact 
            response.setBody('{"getIndividualResponse":{"individual":{"individualIdentifier":"154907823","name":{"firstName":"Ruby_1","lastName":"Kelly_1","middleName":"","nameSuffix":""},"birthDate":"1959-09-21","genderCode":"M","genderDescription":"Male","socialSecurityNumber":"","maritalStatusCode":"","maritalStatusDescription":"","deceasedDate":"","privacyIndicator":"","tobaccoUsageIndicator":"","ethnicityCode":"","ethnicityDescription":"","address":[{"typeCode":"HOM","addressLine1":"95 Elgar Pass","addressLine2":"","city":"HFD","postalCode":"06140","stateCode":"CT","countryCode":"US"}],"phone":[{"phoneType":"H","phoneNumber":"321-686-8888","phoneExt":"","internationalIndicator":"N","primaryIndicator":"Y"}],"email":[{"communicationTypeCode":"EML","electronicAddress":"ruby@optum.com","primaryIndicator":"Y"}],"employment":[{"employmentStatus":"","employeeIdentifier":"","employmentStartDate":"","retirementDate":""}],"language":[{}],"otherContact":[{}],"identifiers":[{"id":"898987888","type":"SRK"},{"id":"898987777","type":"SRK"},{"id":"352816681","type":"HIC"}]}}}');
        }      
        else if(request.getEndpoint().contains('/api/alpha/eisl/individuals/membership/v2.0/search')) {
            response.setBody('{"findMembershipsResponse": { "memberships": [{       "sourceSysCode": "CR",      "coverages": [{         "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "890504596",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }, {            "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "898987679",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }],     "identifiers": [{           "id": "352816681",          "type": "HIC"       }, {            "id": "69688001800",            "type": "SCR"       }, {            "id": "69688001800",            "type": "MCH"       }],     "enrolleeSystemSpecificIdentifiers": [{         "id": "23462613",           "type": "enrolleeSystemID"      }, {            "id": "154907823",          "type": "enrolleeIndividualIdentifier"      }, {            "id": "898987888",          "type": "enrolleeSurrogateKey"      }]  }, {        "sourceSysCode": "CR",      "coverages": [{         "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "890504596",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }, {            "subscriberSystemSpecificIdentifiers": [{               "id": "23462613",               "type": "subscriberSystemID"            }, {                "id": "154907823",              "type": "subscriberIndividualIdentifier"            }, {                "id": "898987679",              "type": "subscriberSurrogateKey"            }],         "groupNumber": "1118478",           "groupName": "Membership_services_MG33",            "membershipEffectiveDate": "2015-01-01",            "membershipExpirationDate": "9999-12-31",           "coverageType": "M",            "coverageTypeDescription": "MEDICAL",           "coverageLevelCode": "FAM",         "product": {                "productIdentifier": "PM00000004",              "productName": "Non-Gated INN/OON",             "productType": ""           },          "benefit": {                "benefitPlanId": "M000000015",              "benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C"            },          "relationshipCode": "18",           "privacyIndicator": "",         "legacyAttributes": {               "eligibilitySystemTypeCode": "CR",              "claimSystemTypeCode": "CR"         }       }],     "identifiers": [{           "id": "352816681",          "type": "HIC"       }, {            "id": "69688001800",            "type": "SCR"       }, {            "id": "69688001800",            "type": "MCH"       }],     "enrolleeSystemSpecificIdentifiers": [{         "id": "23462613",           "type": "enrolleeSystemID"      }, {            "id": "154907823",          "type": "enrolleeIndividualIdentifier"      }, {            "id": "898987777",          "type": "enrolleeSurrogateKey"      }]  }], "pagination": {     "pageNumber": "1",      "pageSize": "5",        "recordCount": "1",     "totalCount": "1",      "totalPages": "1"   }}}');
        }     
        Test.setContinuationResponse(RequestLabel, response); 
    }
    Object result = Test.invokeContinuationMethod(memberDetailController, conti);  

    //Check : Orphan cases are in salesforce with the selected surrogate key
    Set<String> surrogateKeysList = memberDetailController.MemberDetail.SurrogateKeys;
    //system.assert(surrogateKeysList.size() == 2);
    List<Case> caseList = [Select Id From Case where Surrogate_Key__c =: surrogateKeysList ];
    //system.assert(!caseList.isEmpty());
    //system.assert(caseList.size() == 2);
    
    /****
    memberDetailController.ProferredCoverageGUID = +memberDetailController.MemberDetail.CoverageLines[0].guid;          
    memberDetailController.toggleShowCoverages();
    memberDetailController.selectPreferredCoverage();

    //call get membership function
    Continuation conti2 = (Continuation)memberDetailController.CallGetMembership();
    Map<String, HttpRequest> requests2 = conti2.getRequests();

    for(String RequestLabel: requests2.keyset()){
        request = requests2.get(RequestLabel);
        response = new HttpResponse();
        response.setStatusCode(200);
        response.setStatus('OK');
        system.debug(RequestLabel +' :: '+request);
        if(request.getEndpoint().contains('/api/alpha/eisl/individuals/membership/v2.0/read')) {
            system.debug('2323inside GetmemberShip');
            response.setBody('{"getMembershipResponse":{"membership":{"sourceSysCode":"CR","coverages":[{"groupNumber":"1118478","groupName":"Membership_services_MG33","eligibilitySystemTypeCode":"CR","claimSystemTypeCode":"CR","bundleOptions":[{"benefits":[{"benefitBundleOptionId":"0","benefitBundleOptionDescription":"MNRP PlanOptionDesc","benefitEffectiveDate":"2015-01-01","benefitExpirationDate":"9999-12-31","benefitPlanId":"M000000015","benefitPlanName":"CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C","benefitType":"MD","coverageLevelCode":"FAM","relationshipCode":"18","relationshipDescription":"Self","memberIdCardSerialNumber":"69688001800","subscriberIdCardSerialNumber":"69688001800","eligibilityStatusCode":"A","cancelReasonTypeCode":"","planType":"02","indicators":{"qmscoIndicator":"N"}}]}]}],"cob":[{}],"providers": [{"providerIdentifiers": [{ "id": "NHP260", "type": "PUL"}, {   "id": "1407810955", "type": "NPI"}, {   "id": "110001474",  "type": "1C"}, {    "id": "772445246578629791", "type": "LTK"}, {   "id": "130363003",  "type": "SY"}, {    "id": "1214988",    "type": "MPI"}],"assignmentType": "PCP","effectiveDate": "2017-04-01","expirationDate": "9999-12-31","firstName": "MICHAEL","lastName": "PARKER","networkId": "1018476","organizationLocationId": "0"'+
                    '}],"identifiers":[{"id":"890504596","type":"enrolleeSurrogateKey"},{"id":"154907823","type":"enrolleeIndividualIdentifier"},{"id":"23462613","type":"enrolleeSystemID"},{"id":"23462613","type":"subscriberSystemID"},{"id":"154907823","type":"subscriberIndividualIdentifer"},{"id":"890504596","type":"subscriberSurrogateKey"}]}}}');                
        }      
        else if(request.getEndpoint().contains('/api/alpha/eisl/individuals/familymembership/v2.0/read')) {
            response.setBody('{"getFamilyMembershipResponse": {"individual": [{"individualIdentifier": "154907823","name": {"firstName": "Ruby","lastName": "Kelly","middleName": "","nameSuffix": ""},"birthDate": "1959-09-21","genderCode": "M","genderDescription": "Male","socialSecurityNumber": "689220485","address": [{"typeCode": "HOM","addressLine1": "95 Elgar Pass","addressLine2": "","city": "HFD","postalCode": "06140","stateCode": "CT","countryCode": "US"}],"membership": [{"sourceSysCode": "CR","coverages": [{"groupNumber": "1118478","groupName": "Membership_services_MG33","eligibilitySystemTypeCode": "CR","claimSystemTypeCode": "CR","bundleOptions": [{"benefits": [{"benefitBundleOptionId": "0","benefitBundleOptionDescription": "MNRP PlanOptionDesc","benefitEffectiveDate": "2015-01-01","benefitExpirationDate": "9999-12-31","benefitPlanId": "M000000015","benefitPlanName": "CTSM FREEDOM DIRECT $30/50 ER$200 OPD&C","benefitType": "MD","coverageLevelCode": "FAM","relationshipCode": "18","relationshipDescription": "Self","memberIdCardSerialNumber": "69688001800","subscriberIdCardSerialNumber": "69688001800","eligibilityStatusCode": "A","cancelReasonTypeCode": "","planType": "02"}]}]}],"cob": [{}],"providers": [{}],"identifiers": [{"id": "23462613","type": "subscriberSystemId"},{"id": "23462613","type": "enrolleeSystemID"},{"id": "890504596","type": "subscriberSurrogateKey"},{"id": "890504596","type": "enrolleeSurrogateKey"},{"id": "154907823","type": "enrolleeEID"}]}]}]}}');
        }     
        Test.setContinuationResponse(RequestLabel, response); 
    }
    Object result2 = Test.invokeContinuationMethod(memberDetailController, conti2);
    
    //check : New contact and account is created with selected member
    contactlist = [Select Id, name, eid__c, accountId,phone From Contact];      
        //system.assert(!contactlist.isEmpty());
        //check : Contact list will now have only two contact ruby kelly and ruby_1 kelly_1 as no other family members
        system.debug('contactlist >>> '+contactlist);
//      //system.assert(contactlist.size() == 2);
        system.debug('contactlist >>> '+contactlist);
        
        
        //Create few call topic cases
     
        Interaction__c interact = ACETMemberQueryUtil.queryInteraction(interactionId);
        interact.Originator__c = contactlist[0].Id;
    update  interact;
    
    //Reparent will happen and new contact will have 2 case which were orphaned
    List<Case> caseListNew = [select id,ContactId from case where Surrogate_Key__C in : memberDetailController.MemberDetail.SurrogateKeys];
    //system.assert(caseListNew.size() == 2);
    
    //check : total cases in system
    List<Case> totalCases = [select id, ContactId from case];
    //system.assert(totalCases.size() == 4);
    //check : 2 cases should have contact and 2 cases should not
    Integer orphanCase = 0;
    Integer contactCase = 0;
    for(Case c : totalCases){
        if(!String.isEmpty(c.ContactId)){
            contactCase ++;
        }else{
            orphanCase ++;
        }
    }
    //system.assert(contactCase == 4);
    //system.assert(orphanCase == 0);
    *****/
}
    private static void setTestData(String flow){

        Interaction__c inte = TestDataFactory.createInteractionNoContact();

        ApexPages.currentPage().getParameters().put('InteractionId',inte.id);
        ApexPages.currentPage().getParameters().put('SRK','73452645');                 
        ApexPages.currentPage().getParameters().put('IsMember','true');
        String vccdParams = '{"callerType":"test","idStr":"0012345","QuestionType":"MA","callerANI":"ANI123","TFN":"123456789","MemberDOB":"01/01/2017","CallerID":"123456789","TaxID":"123456789","npi":"123456789","MemberID":"123456789","ClaimID":"123456789","AuthorizationNumber":"123456789","ReferralNumber":"123456789"}';
        ApexPages.currentPage().getParameters().put('vccdParams',vccdParams);
        ApexPages.currentPage().getParameters().put('lastName','Kelly');
        ApexPages.currentPage().getParameters().put('IsMember ','true');
        ApexPages.currentPage().getParameters().put('firstName','Ruby');
        ApexPages.currentPage().getParameters().put('sourceOriginator','Phone');
        ApexPages.currentPage().getParameters().put('subjectdob','1/1/2010');
        ApexPages.currentPage().getParameters().put('Id','154907823');
        ApexPages.currentPage().getParameters().put('individualIdentifier','154907823');

        List<ISL_Webservice_Config__c> ISLWebserviceCSList = new List<ISL_Webservice_Config__c>();
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('ISLConAccessToken', 'dfb379c2-06b7-46c4-8c6f-bbc390d1b854'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('OILHttpHeaderAccept', 'application/json;charset=UTF-8'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('OILHttpHeaderActor', 'ACET'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('OILHttpHeaderScope', 'read'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('ISLOAuthContentType', 'application/x-www-form-urlencoded'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('ISLOAuthGrantType', 'client_credentials'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_ISLOAuthClientId', 'ISLStageConClientId'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_ISLOAuthClientSecret', 'ISLStageConClientSecret'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_ISLOAuthEndpoint', 'https://api-stg.optum.com:8443'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_GetMemberEndpoint', '/GetIndividualService'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_GetMembershipEndpoint', '/api/alpha/eisl/individuals/membership/v2.0/read'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_SearchMembershipEndpoint', '/FindMemberShipService'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_GetFamilyMembersEndpoint', '/api/alpha/eisl/individuals/familymembership/v2.0/read'));
        
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_GetIndividualEndpoint', '/api/alpha/eisl/individuals/v2.0/read'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_FindMembershipEndpoint', '/api/alpha/eisl/individuals/membership/v2.0/search'));
        
        
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('dev_ISLOAuthTokenEndpoint', '/auth/oauth/v2/token'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('OILTimeout', '3000'));
        ISLWebserviceCSList.add(TestDataFactory.CreateISLWebserviceCS('SRKCounter', '1'));   
        insert ISLWebserviceCSList;
        //interaction and highlight panel       

        ACETHighlightsPanelAdditionalInfo AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
        AdditionalInfo.DOB = '12/27/2009';
        AdditionalInfo.SitusState = '12/27/2009';
        AdditionalInfo.EffectiveDate = '12/27/2009';
        AdditionalInfo.EndDate = '12/27/2009';
        AdditionalInfo.groupName  = 'Member Offshore';
        AdditionalInfo.Network    = 'Test';
        AdditionalInfo.OriginatorRelationship  = 'Test';
        AdditionalInfo.PolicyNumber  = 'UHC1234';
        AdditionalInfo.Product  = 'Product Test';
        AdditionalInfo.productType  = 'Care Service';
        AdditionalInfo.Relationship  = 'Primary';     

        //Setting relationship codes        
        ACETRelationshipCodes__c rCodes = new ACETRelationshipCodes__c (Name = '18',Description__c = 'Self');
        insert rCodes;      

        ACETOrgNameToSwivelEndpointMap__c durl = new ACETOrgNameToSwivelEndpointMap__c();
        durl.Swivel_Endpoint__c = 'test';
        durl.name = 'dev_ICUEConsumerDashboard';
        insert durl;

        ACETOrgNameToSwivelEndpointMap__c setting = new ACETOrgNameToSwivelEndpointMap__c();
        setting.Name = 'dev_ICUE';
        setting.Swivel_Endpoint__c = 'https://www.google.com';
        insert setting;
        
        ACETOnshoreIndicatorVerbiage__c onshoreIndicatorSetting = new ACETOnshoreIndicatorVerbiage__c();
        onshoreIndicatorSetting.Code__c = 123;
        onshoreIndicatorSetting.Hover_Help_Description__c = 'test';
        onshoreIndicatorSetting.name = 'test';
        insert onshoreIndicatorSetting;


    }    

}