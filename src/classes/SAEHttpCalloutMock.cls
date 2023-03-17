@isTest
global class SAEHttpCalloutMock {
        
    global class SAESpecialityValueMock implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint', SAEConstants.SAE_POLICYSEARCH_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
            response.setHeader('Method', 'POST');
            response.setBody('{"records":[{"active_ind":"A","code":"827","description":"OBI","shrt_description":"ORTH BRACE","full_description":"ORTHOTIC BRACES & INSERTS"}],"metadata":{"offset":450,"psize":50,"total":476,"elapsedTime":"1 Milliseconds","elasticTime":"5 Milliseconds"}}');
            response.setStatusCode(200);
            return response;
        }
    }
    
    global class SAEEligibilityV2Mock implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint', SAEConstants.SAE_MEMBERPROVIDER_VALUE + '?' + SAEConstants.queryParameter);
            response.setHeader('Method', 'GET');
            response.setBody(SAETestDataFactory.getStaticResourceResponse(SAEConstants.SAE_MEMBERPROVIDER_STATICRESOURCE_NAME));
            response.setStatusCode(200);
            response.setStatus('OK');
            return response;
        }
    }

    global class SAEEligibilityV2MockZero implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint', SAEConstants.SAE_MEMBERPROVIDER_VALUE + '?' + SAEConstants.queryParameter);
            response.setHeader('Method', 'GET');
            response.setBody(SAETestDataFactory.getStaticResourceResponse('Eligibility_V2_SMITHSAUNA'));
            response.setStatusCode(200);
            response.setStatus('OK');
            return response;
        }
    }

    global class SAEExtendedCoverageWSMock implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint', SAEConstants.SAE_POLICYSEARCH_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
            response.setHeader('Method', 'GET');
            response.setBody(SAETestDataFactory.getStaticResourceResponse(SAEConstants.SAE_POLICYSEARCH_STATICRESOURCE_NAME));
            response.setStatusCode(200);            
            response.setStatus('OK'); //Avish_11262020
            return response;
        }
    }
    
    global class ACETLoginFlowUpdPasswordMock implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Method', 'POST');
            response.setBody('{"postResult": {"userProfile": {"userId": "673/JR2","unitId": "673/SYS/SOS","expiryDate": "","expiryTime": "","officeNumber": "673","departmentCode": "SYS","teamCode": "673SOS","operatorId": "JR2","associateName": {"firstName": "JAMAL","lastName": "ROYSTER"},"phone": "9999999999","hideIssue": "N","designeeUserId": "AS6","directoryCode": "A","soleDestinationOffice": "000","soleDestinationDepartment": "","soleDestinationTeam": "","socialSecurityNumber": "1247968","sortOrderForIssuesToBeAssigned": "D","sortOrderForStatusOfIssues": "T","primaryPlatform": "U","status": "A","cosmosUserId": "00000000","routePreferences": [null,null],"businessGroups": ["STANDARD"],"authorization": {"inquireIssues": "","updateIssues": "Y","assignIssues": "Y","receiveIssues": "Y","routeIssues": "Y","modifyGrievance": "N","overrideDepartment": "Y","overrideTeam": "Y","overrideOperatorID": "Y","sal": "N"}},"userTokens": [{"userToken": "F:B7F3E0","sourceSystem": "TOPS","daysRemainingPasswordExpiration": "1"}]}}');
            response.setStatusCode(200);
            return response;
        }
    }

    global class ACETLoginFlowMock implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Method', 'POST');
            response.setBody('{"postResult": {"userProfile": {"userId": "673/JR2","unitId": "673/SYS/SOS","expiryDate": "","expiryTime": "","officeNumber": "673","departmentCode": "SYS","teamCode": "673SOS","operatorId": "JR2","associateName": {"firstName": "JAMAL","lastName": "ROYSTER"},"phone": "9999999999","hideIssue": "N","designeeUserId": "AS6","directoryCode": "A","soleDestinationOffice": "000","soleDestinationDepartment": "","soleDestinationTeam": "","socialSecurityNumber": "1247968","sortOrderForIssuesToBeAssigned": "D","sortOrderForStatusOfIssues": "T","primaryPlatform": "U","status": "A","cosmosUserId": "00000000","routePreferences": [null,null],"businessGroups": ["STANDARD"],"authorization": {"inquireIssues": "","updateIssues": "Y","assignIssues": "Y","receiveIssues": "Y","routeIssues": "Y","modifyGrievance": "N","overrideDepartment": "Y","overrideTeam": "Y","overrideOperatorID": "Y","sal": "N"}},"userTokens": [{"userToken": "F:B7F3E0","sourceSystem": "TOPS","daysRemainingPasswordExpiration": "14"}]}}');
            response.setStatusCode(200);
            return response;
        }
    }
    
    global class ACETLoginFlowMock999 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Method', 'POST');
            response.setBody('{"postResult": {"userProfile": {"userId": "673/JR2","unitId": "673/SYS/SOS","expiryDate": "","expiryTime": "","officeNumber": "673","departmentCode": "SYS","teamCode": "673SOS","operatorId": "JR2","associateName": {"firstName": "JAMAL","lastName": "ROYSTER"},"phone": "9999999999","hideIssue": "N","designeeUserId": "AS6","directoryCode": "A","soleDestinationOffice": "000","soleDestinationDepartment": "","soleDestinationTeam": "","socialSecurityNumber": "1247968","sortOrderForIssuesToBeAssigned": "D","sortOrderForStatusOfIssues": "T","primaryPlatform": "U","status": "A","cosmosUserId": "00000000","routePreferences": [null,null],"businessGroups": ["STANDARD"],"authorization": {"inquireIssues": "","updateIssues": "Y","assignIssues": "Y","receiveIssues": "Y","routeIssues": "Y","modifyGrievance": "N","overrideDepartment": "Y","overrideTeam": "Y","overrideOperatorID": "Y","sal": "N"}},"userTokens": [{"userToken": "F:B7F3E0","sourceSystem": "TOPS","daysRemainingPasswordExpiration": "14"}]}}');
            response.setStatusCode(999);
            return response;
        }
    }
    
     global class ACETLoginFlowUpdatePasswordMock implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Method', 'PUT');
            response.setBody('{"postResult": {"userProfile": {"userId": "673/JR2","unitId": "673/SYS/SOS","expiryDate": "","expiryTime": "","officeNumber": "673","departmentCode": "SYS","teamCode": "673SOS","operatorId": "JR2","associateName": {"firstName": "JAMAL","lastName": "ROYSTER"},"phone": "9999999999","hideIssue": "N","designeeUserId": "AS6","directoryCode": "A","soleDestinationOffice": "000","soleDestinationDepartment": "","soleDestinationTeam": "","socialSecurityNumber": "1247968","sortOrderForIssuesToBeAssigned": "D","sortOrderForStatusOfIssues": "T","primaryPlatform": "U","status": "A","cosmosUserId": "00000000","routePreferences": [null,null],"businessGroups": ["STANDARD"],"authorization": {"inquireIssues": "","updateIssues": "Y","assignIssues": "Y","receiveIssues": "Y","routeIssues": "Y","modifyGrievance": "N","overrideDepartment": "Y","overrideTeam": "Y","overrideOperatorID": "Y","sal": "N"}},"userTokens": [{"userToken": "F:B7F3E0","sourceSystem": "TOPS","daysRemainingPasswordExpiration": "14"}]}}');
            response.setStatusCode(200);
            return response;
        }
    }
    
    global class ACETLoginFlowUpdatePasswordMock400 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Method', 'PUT');
            response.setBody('{"putResult": {"errors": [{"code": 400,"name": "InvalidRequest","severity": "INFORMATIONAL","origin": "TOPS","description": "Verify logon settings TOPS F5427FAV ReturnCode [6] explanationCode [997] "}],"sourceSystem": "TOPS"}}');
            response.setStatusCode(400);
            return response;
        }
    }
    
    global class ACETLoginFlowUpdatePasswordMock500 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Method', 'PUT');
            response.setBody('{"putResult": {"errors": [{"code": 400,"name": "InvalidRequest","severity": "INFORMATIONAL","origin": "TOPS","description": "Verify logon settings TOPS F5427FAV ReturnCode [6] explanationCode [997] "}],"sourceSystem": "TOPS"}}');
            response.setStatusCode(500);
            return response;
        }
    }
    
    global class ACETLoginFlowUpdatePasswordMock404 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Method', 'PUT');
            response.setBody('{"putResult": {"errors": [{"code": 400,"name": "InvalidRequest","severity": "INFORMATIONAL","origin": "TOPS","description": "Verify logon settings TOPS F5427FAV ReturnCode [6] explanationCode [997] "}],"sourceSystem": "TOPS"}}');
            response.setStatusCode(404);
            return response;
        }
    }
    
    global class ACETLoginFlowUpdatePasswordMock999 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Method', 'PUT');
            response.setBody('{"putResult": {"errors": [{"code": 400,"name": "InvalidRequest","severity": "INFORMATIONAL","origin": "TOPS","description": "Verify logon settings TOPS F5427FAV ReturnCode [6] explanationCode [997] "}],"sourceSystem": "TOPS"}}');
            response.setStatusCode(999);
            return response;
        }
    }

    global class ACETLoginFlowMock400 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Method', 'POST');
            response.setBody('{"postResult": {"errors": [{"code": 400,"name": "InvalidRequest","severity": "INFORMATIONAL","origin": "TOPS","description": "Verify logon settings TOPS F5427FAV ReturnCode [6] explanationCode [997] "}],"sourceSystem": "TOPS"}}');
            response.setStatusCode(400);
            return response;
        }
    }
    
    global class ACETLoginFlowMock404 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Method', 'POST');
            response.setBody('{"postResult": {"userProfile": {"userId": "673/JR2","unitId": "673/SYS/SOS","expiryDate": "","expiryTime": "","officeNumber": "673","departmentCode": "SYS","teamCode": "673SOS","operatorId": "JR2","associateName": {"firstName": "JAMAL","lastName": "ROYSTER"},"phone": "9999999999","hideIssue": "N","designeeUserId": "AS6","directoryCode": "A","soleDestinationOffice": "000","soleDestinationDepartment": "","soleDestinationTeam": "","socialSecurityNumber": "1247968","sortOrderForIssuesToBeAssigned": "D","sortOrderForStatusOfIssues": "T","primaryPlatform": "U","status": "A","cosmosUserId": "00000000","routePreferences": [null,null],"businessGroups": ["STANDARD"],"authorization": {"inquireIssues": "","updateIssues": "Y","assignIssues": "Y","receiveIssues": "Y","routeIssues": "Y","modifyGrievance": "N","overrideDepartment": "Y","overrideTeam": "Y","overrideOperatorID": "Y","sal": "N"}},"userTokens": [{"userToken": "F:B7F3E0","sourceSystem": "TOPS","daysRemainingPasswordExpiration": "14"}]}}');
            response.setStatusCode(404);
            return response;
        }
    }
    
    global class ACETLoginFlowMock500 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Method', 'POST');
            response.setBody('{"postResult": {"userProfile": {"userId": "673/JR2","unitId": "673/SYS/SOS","expiryDate": "","expiryTime": "","officeNumber": "673","departmentCode": "SYS","teamCode": "673SOS","operatorId": "JR2","associateName": {"firstName": "JAMAL","lastName": "ROYSTER"},"phone": "9999999999","hideIssue": "N","designeeUserId": "AS6","directoryCode": "A","soleDestinationOffice": "000","soleDestinationDepartment": "","soleDestinationTeam": "","socialSecurityNumber": "1247968","sortOrderForIssuesToBeAssigned": "D","sortOrderForStatusOfIssues": "T","primaryPlatform": "U","status": "A","cosmosUserId": "00000000","routePreferences": [null,null],"businessGroups": ["STANDARD"],"authorization": {"inquireIssues": "","updateIssues": "Y","assignIssues": "Y","receiveIssues": "Y","routeIssues": "Y","modifyGrievance": "N","overrideDepartment": "Y","overrideTeam": "Y","overrideOperatorID": "Y","sal": "N"}},"userTokens": [{"userToken": "F:B7F3E0","sourceSystem": "TOPS","daysRemainingPasswordExpiration": "14"}]}}');
            response.setStatusCode(500);
            return response;
        }
    }

	global class ACETORSIssueMock implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Method', 'POST');
            response.setBody('{"searchResult": {"searchOutput": {"issuesList": [{"issueId": "D00860744188246","reasonCode": "","statusCode": "H","status": "HOLD","contactMethodCode": "W","contactMethodDescription": "WALK-IN","originatorTypeCode": "EM","originatorTypeDescription": "MEMBER","originatedDate": "2020-03-26","originatedTime": "07:44:00","comment": "BE LOST).","updateDate": "2020-03-26","associateName": {"firstName": "JAMAL","lastName": "ROYSTER"},"businessSegmentName": "","subReasonText": "","complaintCategoryText": "","reasonCategory": "","followupStatusCode": "","followupStatusDescription": "NONE","followupPurposeCode": "","claimNumber": "","claimAuthorization": "","claimServiceDate": "","claimCount": "00","hippa": "","extrClaimNumber": "","extrSubscriberId": "","origOfficeNumber": "673","ownerOfficeId": "673","ownerDepartmentCode": "SYS","memberInfo": {"dependentName": {"firstName": "JACK","lastName": ""},"groupNumber": "000000000","groupName": "UHC","product": "","memberNumber": "123456789","policy": "12345","alternateId": "123456789","eligibilitySourceSystem": "","primaryPolicyNumber": "","sharedArrangementId": "","obligorId": "","logoIndicator": "","fontIndicator": "","planCode": "","benefitPackageCode": "014","regionCode": "","ipaCode": "","panelCode": "","source": "AK"},"providerInfo": {"productCode": "","panelNumber": "","ipa": "","sourceSystem": "","firstInitial": "S","lastName": "MITRA","mpin": ""},"originatorInfo": {"originatorMPIN": "000000000000","originatorTIN": "000000000","originatorSuffix": "00000","originatorId": "JR2"},"otherInfo": {"agencyName": "","agencyTaxId": "","agencyUniqueId": "00000000000"},"serviceRequest": {"srProductType": "","srType": "","srSubType": ""}},{"issueId": "D00860742040426","reasonCode": "","statusCode": "H","status": "HOLD","contactMethodCode": "W","contactMethodDescription": "WALK-IN","originatorTypeCode": "EM","originatorTypeDescription": "MEMBER","originatedDate": "2020-03-26","originatedTime": "07:42:00","comment": "BE LOST).","updateDate": "2020-03-26","associateName": {"firstName": "JAMAL","lastName": "ROYSTER"},"businessSegmentName": "","subReasonText": "","complaintCategoryText": "","reasonCategory": "","followupStatusCode": "","followupStatusDescription": "NONE","followupPurposeCode": "","claimNumber": "","claimAuthorization": "","claimServiceDate": "","claimCount": "00","hippa": "","extrClaimNumber": "","extrSubscriberId": "","origOfficeNumber": "673","ownerOfficeId": "673","ownerDepartmentCode": "SYS","memberInfo": {"dependentName": {"firstName": "JACK","lastName": ""},"groupNumber": "000000000","groupName": "UHC","product": "","memberNumber": "123456789","policy": "12345","alternateId": "123456789","eligibilitySourceSystem": "","primaryPolicyNumber": "","sharedArrangementId": "","obligorId": "","logoIndicator": "","fontIndicator": "","planCode": "","benefitPackageCode": "014","regionCode": "","ipaCode": "","panelCode": "","source": "AK"},"providerInfo": {"productCode": "","panelNumber": "","ipa": "","sourceSystem": "","firstInitial": "S","lastName": "MITRA","mpin": ""},"originatorInfo": {"originatorMPIN": "000000000000","originatorTIN": "000000000","originatorSuffix": "00000","originatorId": "JR2"},"otherInfo": {"agencyName": "","agencyTaxId": "","agencyUniqueId": "00000000000"},"serviceRequest": {"srProductType": "","srType": "","srSubType": ""}}],"alertsList": [],"pagingState": {"moreData": false}}}}');
            response.setStatusCode(200);
            return response;
        }
    }
    
    global class ACETORSIssueMock400 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Method', 'POST');
            response.setBody('{"searchResult": {"searchOutput": {"issuesList": [{"issueId": "D00860744188246","reasonCode": "","statusCode": "H","status": "HOLD","contactMethodCode": "W","contactMethodDescription": "WALK-IN","originatorTypeCode": "EM","originatorTypeDescription": "MEMBER","originatedDate": "2020-03-26","originatedTime": "07:44:00","comment": "BE LOST).","updateDate": "2020-03-26","associateName": {"firstName": "JAMAL","lastName": "ROYSTER"},"businessSegmentName": "","subReasonText": "","complaintCategoryText": "","reasonCategory": "","followupStatusCode": "","followupStatusDescription": "NONE","followupPurposeCode": "","claimNumber": "","claimAuthorization": "","claimServiceDate": "","claimCount": "00","hippa": "","extrClaimNumber": "","extrSubscriberId": "","origOfficeNumber": "673","ownerOfficeId": "673","ownerDepartmentCode": "SYS","memberInfo": {"dependentName": {"firstName": "JACK","lastName": ""},"groupNumber": "000000000","groupName": "UHC","product": "","memberNumber": "123456789","policy": "12345","alternateId": "123456789","eligibilitySourceSystem": "","primaryPolicyNumber": "","sharedArrangementId": "","obligorId": "","logoIndicator": "","fontIndicator": "","planCode": "","benefitPackageCode": "014","regionCode": "","ipaCode": "","panelCode": "","source": "AK"},"providerInfo": {"productCode": "","panelNumber": "","ipa": "","sourceSystem": "","firstInitial": "S","lastName": "MITRA","mpin": ""},"originatorInfo": {"originatorMPIN": "000000000000","originatorTIN": "000000000","originatorSuffix": "00000","originatorId": "JR2"},"otherInfo": {"agencyName": "","agencyTaxId": "","agencyUniqueId": "00000000000"},"serviceRequest": {"srProductType": "","srType": "","srSubType": ""}},{"issueId": "D00860742040426","reasonCode": "","statusCode": "H","status": "HOLD","contactMethodCode": "W","contactMethodDescription": "WALK-IN","originatorTypeCode": "EM","originatorTypeDescription": "MEMBER","originatedDate": "2020-03-26","originatedTime": "07:42:00","comment": "BE LOST).","updateDate": "2020-03-26","associateName": {"firstName": "JAMAL","lastName": "ROYSTER"},"businessSegmentName": "","subReasonText": "","complaintCategoryText": "","reasonCategory": "","followupStatusCode": "","followupStatusDescription": "NONE","followupPurposeCode": "","claimNumber": "","claimAuthorization": "","claimServiceDate": "","claimCount": "00","hippa": "","extrClaimNumber": "","extrSubscriberId": "","origOfficeNumber": "673","ownerOfficeId": "673","ownerDepartmentCode": "SYS","memberInfo": {"dependentName": {"firstName": "JACK","lastName": ""},"groupNumber": "000000000","groupName": "UHC","product": "","memberNumber": "123456789","policy": "12345","alternateId": "123456789","eligibilitySourceSystem": "","primaryPolicyNumber": "","sharedArrangementId": "","obligorId": "","logoIndicator": "","fontIndicator": "","planCode": "","benefitPackageCode": "014","regionCode": "","ipaCode": "","panelCode": "","source": "AK"},"providerInfo": {"productCode": "","panelNumber": "","ipa": "","sourceSystem": "","firstInitial": "S","lastName": "MITRA","mpin": ""},"originatorInfo": {"originatorMPIN": "000000000000","originatorTIN": "000000000","originatorSuffix": "00000","originatorId": "JR2"},"otherInfo": {"agencyName": "","agencyTaxId": "","agencyUniqueId": "00000000000"},"serviceRequest": {"srProductType": "","srType": "","srSubType": ""}}],"alertsList": [],"pagingState": {"moreData": false}}}}');
            response.setStatusCode(400);
            return response;
        }
    }
    
    global class ACETORSIssueMock500 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Method', 'POST');
            response.setBody('{"searchResult": {"searchOutput": {"issuesList": [{"issueId": "D00860744188246","reasonCode": "","statusCode": "H","status": "HOLD","contactMethodCode": "W","contactMethodDescription": "WALK-IN","originatorTypeCode": "EM","originatorTypeDescription": "MEMBER","originatedDate": "2020-03-26","originatedTime": "07:44:00","comment": "BE LOST).","updateDate": "2020-03-26","associateName": {"firstName": "JAMAL","lastName": "ROYSTER"},"businessSegmentName": "","subReasonText": "","complaintCategoryText": "","reasonCategory": "","followupStatusCode": "","followupStatusDescription": "NONE","followupPurposeCode": "","claimNumber": "","claimAuthorization": "","claimServiceDate": "","claimCount": "00","hippa": "","extrClaimNumber": "","extrSubscriberId": "","origOfficeNumber": "673","ownerOfficeId": "673","ownerDepartmentCode": "SYS","memberInfo": {"dependentName": {"firstName": "JACK","lastName": ""},"groupNumber": "000000000","groupName": "UHC","product": "","memberNumber": "123456789","policy": "12345","alternateId": "123456789","eligibilitySourceSystem": "","primaryPolicyNumber": "","sharedArrangementId": "","obligorId": "","logoIndicator": "","fontIndicator": "","planCode": "","benefitPackageCode": "014","regionCode": "","ipaCode": "","panelCode": "","source": "AK"},"providerInfo": {"productCode": "","panelNumber": "","ipa": "","sourceSystem": "","firstInitial": "S","lastName": "MITRA","mpin": ""},"originatorInfo": {"originatorMPIN": "000000000000","originatorTIN": "000000000","originatorSuffix": "00000","originatorId": "JR2"},"otherInfo": {"agencyName": "","agencyTaxId": "","agencyUniqueId": "00000000000"},"serviceRequest": {"srProductType": "","srType": "","srSubType": ""}},{"issueId": "D00860742040426","reasonCode": "","statusCode": "H","status": "HOLD","contactMethodCode": "W","contactMethodDescription": "WALK-IN","originatorTypeCode": "EM","originatorTypeDescription": "MEMBER","originatedDate": "2020-03-26","originatedTime": "07:42:00","comment": "BE LOST).","updateDate": "2020-03-26","associateName": {"firstName": "JAMAL","lastName": "ROYSTER"},"businessSegmentName": "","subReasonText": "","complaintCategoryText": "","reasonCategory": "","followupStatusCode": "","followupStatusDescription": "NONE","followupPurposeCode": "","claimNumber": "","claimAuthorization": "","claimServiceDate": "","claimCount": "00","hippa": "","extrClaimNumber": "","extrSubscriberId": "","origOfficeNumber": "673","ownerOfficeId": "673","ownerDepartmentCode": "SYS","memberInfo": {"dependentName": {"firstName": "JACK","lastName": ""},"groupNumber": "000000000","groupName": "UHC","product": "","memberNumber": "123456789","policy": "12345","alternateId": "123456789","eligibilitySourceSystem": "","primaryPolicyNumber": "","sharedArrangementId": "","obligorId": "","logoIndicator": "","fontIndicator": "","planCode": "","benefitPackageCode": "014","regionCode": "","ipaCode": "","panelCode": "","source": "AK"},"providerInfo": {"productCode": "","panelNumber": "","ipa": "","sourceSystem": "","firstInitial": "S","lastName": "MITRA","mpin": ""},"originatorInfo": {"originatorMPIN": "000000000000","originatorTIN": "000000000","originatorSuffix": "00000","originatorId": "JR2"},"otherInfo": {"agencyName": "","agencyTaxId": "","agencyUniqueId": "00000000000"},"serviceRequest": {"srProductType": "","srType": "","srSubType": ""}}],"alertsList": [],"pagingState": {"moreData": false}}}}');
            response.setStatusCode(500);
            return response;
        }
    }
    
    global class ACETORSIssueMock404 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Method', 'POST');
            response.setBody('{"searchResult": {"searchOutput": {"issuesList": [{"issueId": "D00860744188246","reasonCode": "","statusCode": "H","status": "HOLD","contactMethodCode": "W","contactMethodDescription": "WALK-IN","originatorTypeCode": "EM","originatorTypeDescription": "MEMBER","originatedDate": "2020-03-26","originatedTime": "07:44:00","comment": "BE LOST).","updateDate": "2020-03-26","associateName": {"firstName": "JAMAL","lastName": "ROYSTER"},"businessSegmentName": "","subReasonText": "","complaintCategoryText": "","reasonCategory": "","followupStatusCode": "","followupStatusDescription": "NONE","followupPurposeCode": "","claimNumber": "","claimAuthorization": "","claimServiceDate": "","claimCount": "00","hippa": "","extrClaimNumber": "","extrSubscriberId": "","origOfficeNumber": "673","ownerOfficeId": "673","ownerDepartmentCode": "SYS","memberInfo": {"dependentName": {"firstName": "JACK","lastName": ""},"groupNumber": "000000000","groupName": "UHC","product": "","memberNumber": "123456789","policy": "12345","alternateId": "123456789","eligibilitySourceSystem": "","primaryPolicyNumber": "","sharedArrangementId": "","obligorId": "","logoIndicator": "","fontIndicator": "","planCode": "","benefitPackageCode": "014","regionCode": "","ipaCode": "","panelCode": "","source": "AK"},"providerInfo": {"productCode": "","panelNumber": "","ipa": "","sourceSystem": "","firstInitial": "S","lastName": "MITRA","mpin": ""},"originatorInfo": {"originatorMPIN": "000000000000","originatorTIN": "000000000","originatorSuffix": "00000","originatorId": "JR2"},"otherInfo": {"agencyName": "","agencyTaxId": "","agencyUniqueId": "00000000000"},"serviceRequest": {"srProductType": "","srType": "","srSubType": ""}},{"issueId": "D00860742040426","reasonCode": "","statusCode": "H","status": "HOLD","contactMethodCode": "W","contactMethodDescription": "WALK-IN","originatorTypeCode": "EM","originatorTypeDescription": "MEMBER","originatedDate": "2020-03-26","originatedTime": "07:42:00","comment": "BE LOST).","updateDate": "2020-03-26","associateName": {"firstName": "JAMAL","lastName": "ROYSTER"},"businessSegmentName": "","subReasonText": "","complaintCategoryText": "","reasonCategory": "","followupStatusCode": "","followupStatusDescription": "NONE","followupPurposeCode": "","claimNumber": "","claimAuthorization": "","claimServiceDate": "","claimCount": "00","hippa": "","extrClaimNumber": "","extrSubscriberId": "","origOfficeNumber": "673","ownerOfficeId": "673","ownerDepartmentCode": "SYS","memberInfo": {"dependentName": {"firstName": "JACK","lastName": ""},"groupNumber": "000000000","groupName": "UHC","product": "","memberNumber": "123456789","policy": "12345","alternateId": "123456789","eligibilitySourceSystem": "","primaryPolicyNumber": "","sharedArrangementId": "","obligorId": "","logoIndicator": "","fontIndicator": "","planCode": "","benefitPackageCode": "014","regionCode": "","ipaCode": "","panelCode": "","source": "AK"},"providerInfo": {"productCode": "","panelNumber": "","ipa": "","sourceSystem": "","firstInitial": "S","lastName": "MITRA","mpin": ""},"originatorInfo": {"originatorMPIN": "000000000000","originatorTIN": "000000000","originatorSuffix": "00000","originatorId": "JR2"},"otherInfo": {"agencyName": "","agencyTaxId": "","agencyUniqueId": "00000000000"},"serviceRequest": {"srProductType": "","srType": "","srSubType": ""}}],"alertsList": [],"pagingState": {"moreData": false}}}}');
            response.setStatusCode(404);
            return response;
        }
    }
    
    global class ACETORSIssueMock999 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Method', 'POST');
            response.setBody('{"searchResult": {"searchOutput": {"issuesList": [{"issueId": "D00860744188246","reasonCode": "","statusCode": "H","status": "HOLD","contactMethodCode": "W","contactMethodDescription": "WALK-IN","originatorTypeCode": "EM","originatorTypeDescription": "MEMBER","originatedDate": "2020-03-26","originatedTime": "07:44:00","comment": "BE LOST).","updateDate": "2020-03-26","associateName": {"firstName": "JAMAL","lastName": "ROYSTER"},"businessSegmentName": "","subReasonText": "","complaintCategoryText": "","reasonCategory": "","followupStatusCode": "","followupStatusDescription": "NONE","followupPurposeCode": "","claimNumber": "","claimAuthorization": "","claimServiceDate": "","claimCount": "00","hippa": "","extrClaimNumber": "","extrSubscriberId": "","origOfficeNumber": "673","ownerOfficeId": "673","ownerDepartmentCode": "SYS","memberInfo": {"dependentName": {"firstName": "JACK","lastName": ""},"groupNumber": "000000000","groupName": "UHC","product": "","memberNumber": "123456789","policy": "12345","alternateId": "123456789","eligibilitySourceSystem": "","primaryPolicyNumber": "","sharedArrangementId": "","obligorId": "","logoIndicator": "","fontIndicator": "","planCode": "","benefitPackageCode": "014","regionCode": "","ipaCode": "","panelCode": "","source": "AK"},"providerInfo": {"productCode": "","panelNumber": "","ipa": "","sourceSystem": "","firstInitial": "S","lastName": "MITRA","mpin": ""},"originatorInfo": {"originatorMPIN": "000000000000","originatorTIN": "000000000","originatorSuffix": "00000","originatorId": "JR2"},"otherInfo": {"agencyName": "","agencyTaxId": "","agencyUniqueId": "00000000000"},"serviceRequest": {"srProductType": "","srType": "","srSubType": ""}},{"issueId": "D00860742040426","reasonCode": "","statusCode": "H","status": "HOLD","contactMethodCode": "W","contactMethodDescription": "WALK-IN","originatorTypeCode": "EM","originatorTypeDescription": "MEMBER","originatedDate": "2020-03-26","originatedTime": "07:42:00","comment": "BE LOST).","updateDate": "2020-03-26","associateName": {"firstName": "JAMAL","lastName": "ROYSTER"},"businessSegmentName": "","subReasonText": "","complaintCategoryText": "","reasonCategory": "","followupStatusCode": "","followupStatusDescription": "NONE","followupPurposeCode": "","claimNumber": "","claimAuthorization": "","claimServiceDate": "","claimCount": "00","hippa": "","extrClaimNumber": "","extrSubscriberId": "","origOfficeNumber": "673","ownerOfficeId": "673","ownerDepartmentCode": "SYS","memberInfo": {"dependentName": {"firstName": "JACK","lastName": ""},"groupNumber": "000000000","groupName": "UHC","product": "","memberNumber": "123456789","policy": "12345","alternateId": "123456789","eligibilitySourceSystem": "","primaryPolicyNumber": "","sharedArrangementId": "","obligorId": "","logoIndicator": "","fontIndicator": "","planCode": "","benefitPackageCode": "014","regionCode": "","ipaCode": "","panelCode": "","source": "AK"},"providerInfo": {"productCode": "","panelNumber": "","ipa": "","sourceSystem": "","firstInitial": "S","lastName": "MITRA","mpin": ""},"originatorInfo": {"originatorMPIN": "000000000000","originatorTIN": "000000000","originatorSuffix": "00000","originatorId": "JR2"},"otherInfo": {"agencyName": "","agencyTaxId": "","agencyUniqueId": "00000000000"},"serviceRequest": {"srProductType": "","srType": "","srSubType": ""}}],"alertsList": [],"pagingState": {"moreData": false}}}}');
            response.setStatusCode(999);
            return response;
        }
    }

    // Thanish - 17th Jun 2020 - Code Coverage
    global class ACETORSOneIssueMock implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Method', 'POST');
            response.setBody('{"searchResult":{"searchOutput":{"issuesList":[{"issueId":"D00860742040426","reasonCode":"","statusCode":"H","status":"HOLD","contactMethodCode":"W","contactMethodDescription":"WALK-IN","originatorTypeCode":"EM","originatorTypeDescription":"MEMBER","originatedDate":"2020-03-26","originatedTime":"07:42:00","comment":"BE LOST).","updateDate":"2020-03-26","associateName":{"firstName":"JAMAL","lastName":"ROYSTER"},"businessSegmentName":"","subReasonText":"","complaintCategoryText":"","reasonCategory":"","followupStatusCode":"","followupStatusDescription":"NONE","followupPurposeCode":"","claimNumber":"","claimAuthorization":"","claimServiceDate":"","claimCount":"00","hippa":"","extrClaimNumber":"","extrSubscriberId":"","origOfficeNumber":"673","ownerOfficeId":"673","ownerDepartmentCode":"SYS","memberInfo":{"dependentName":{"firstName":"JACK","lastName":""},"groupNumber":"000000000","groupName":"UHC","product":"","memberNumber":"123456789","policy":"12345","alternateId":"123456789","eligibilitySourceSystem":"","primaryPolicyNumber":"","sharedArrangementId":"","obligorId":"","logoIndicator":"","fontIndicator":"","planCode":"","benefitPackageCode":"014","regionCode":"","ipaCode":"","panelCode":"","source":"AK"},"providerInfo":{"productCode":"","panelNumber":"","ipa":"","sourceSystem":"","firstInitial":"S","lastName":"MITRA","mpin":""},"originatorInfo":{"originatorMPIN":"000000000000","originatorTIN":"000000000","originatorSuffix":"00000","originatorId":"JR2"},"otherInfo":{"agencyName":"","agencyTaxId":"","agencyUniqueId":"00000000000"},"serviceRequest":{"srProductType":"","srType":"","srSubType":""}}],"alertsList":[],"pagingState":{"moreData":false}}}}');
            response.setStatusCode(200);
            return response;
        }
    }

    global class ACETGetRCEDMock implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest request) {
            	HttpResponse response = new HttpResponse();
                response.setHeader('Endpoint',  SAEConstants.SAE_RCED_API_VALUE);
                response.setHeader('Method', 'POST');
                response.setBody(SAETestDataFactory.getStaticResourceResponse('RCEDAPIResource1'));
                response.setStatusCode(200);
                return response;
        }
    }
    global class ACETGetIPAMarketAssociationMock implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest request) {
            	HttpResponse response = new HttpResponse();
                response.setHeader('Endpoint',  SAEConstants.SAE_RCED_API_VALUE);
                response.setHeader('Method', 'POST');
                response.setBody(SAETestDataFactory.getStaticResourceResponse('IPAMarketAssociation_0000005440'));
                response.setStatusCode(200);
                return response;
        }
    }

    global class SAEWebserviceMock implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint',  SAEConstants.SAE_POLICYSEARCH_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
            response.setHeader('Method', 'GET');
            response.setBody(SAETestDataFactory.getStaticResourceResponse(SAEConstants.SAE_NetworkStatusService_STATICRESOURCE_NAME));
            response.setStatusCode(200);
            return response;
        }
    }

      global class SAEWebserviceMockFor400 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint',  SAEConstants.SAE_POLICYSEARCH_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
            response.setHeader('Method', 'GET');
            response.setBody(SAETestDataFactory.getStaticResourceResponse(SAEConstants.SAE_NetworkStatusService_STATICRESOURCE_NAME));
            response.setStatusCode(400);
            return response;
        }
    }

    global class SAEWebserviceMockFor500 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint',  SAEConstants.SAE_POLICYSEARCH_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
            response.setHeader('Method', 'GET');
            response.setBody(SAETestDataFactory.getStaticResourceResponse(SAEConstants.SAE_NetworkStatusService_STATICRESOURCE_NAME));
            response.setStatusCode(500);
            return response;
        }
    }

    global class SAEWebserviceMockFor404 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint',  SAEConstants.SAE_POLICYSEARCH_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
            response.setHeader('Method', 'GET');
            response.setBody(SAETestDataFactory.getStaticResourceResponse(SAEConstants.SAE_NetworkStatusService_STATICRESOURCE_NAME));
            response.setStatusCode(404);
            return response;
        }
    }

    global class SAEWebserviceMockForElse implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint',  SAEConstants.SAE_POLICYSEARCH_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
            response.setHeader('Method', 'GET');
            response.setBody(SAETestDataFactory.getStaticResourceResponse(SAEConstants.SAE_NetworkStatusService_STATICRESOURCE_NAME));
            response.setStatusCode(600);
            return response;
        }
    }

    global class SAEExtendedCoverageMemberProviderWSMock implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint',  SAEConstants.SAE_MEMBERPROVIDER_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
            response.setHeader('Method', 'GET');
            response.setBody(SAETestDataFactory.getStaticResourceResponse(SAEConstants.SAE_MEMBERPROVIDER_STATICRESOURCE_NAME));
            response.setStatusCode(200);
            return response;
        }
    }

    global class SAEGetCOBWebServiceMock implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest request) {
            	HttpResponse response = new HttpResponse();
                response.setHeader('Endpoint',  SAEConstants.SAE_MEMBERPROVIDER_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
                response.setHeader('Method', 'GET');
                response.setBody(SAETestDataFactory.getStaticResourceResponse(SAEConstants.SAE_COB_STATICRESOURCE_NAME));
                response.setStatusCode(200);
                return response;
        }
    }

    global class SAEMemberStandaloneSearchWebServiceMock implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest request) {
            	HttpResponse response = new HttpResponse();
                response.setHeader('Endpoint',  SAEConstants.SAE_OIL_ENDPOINT + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
                response.setHeader('Method', 'POST');
                response.setBody(SAETestDataFactory.getStaticResourceResponse(SAEConstants.SAE_INDIVIDUAL_RESPONSE_NAME));
                response.setStatusCode(200);
                return response;
        }
    }

    global class SAEClaimSummarySearchWebServiceMock implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest request) {
            	HttpResponse response = new HttpResponse();
                response.setHeader('Endpoint',  SAEConstants.SAE_MEMBERPROVIDER_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
                response.setHeader('Method', 'GET');
                response.setBody(SAETestDataFactory.getStaticResourceResponse(SAEConstants.SAE_CLAIM_SUMMARY_RESPONSE_NAME));
                response.setStatusCode(200);
                return response;
        }
    }

    global class SAEDetailsSearchWebServiceMock implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest request) {
            	HttpResponse response = new HttpResponse();
                response.setHeader('Endpoint',  SAEConstants.SAE_MEMBERPROVIDER_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
                response.setHeader('Method', 'GET');
                response.setBody(SAETestDataFactory.getStaticResourceResponse(SAEConstants.SAE_CLAIM_DETAILS_RESPONSE_NAME));
                response.setStatusCode(200);
                return response;
        }
    }
    
    global class SAEClaimDetailWebServiceMock implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest request) {
            	HttpResponse response = new HttpResponse();
                response.setHeader('Endpoint',  SAEConstants.SAE_MEMBERPROVIDER_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
                response.setHeader('Method', 'GET');
                response.setBody(SAETestDataFactory.getStaticResourceResponse('claimDetail_18A9027070'));
                response.setStatusCode(200);
                return response;
        }
    }
    
    global class SAEClaimReconWebServiceMock implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest request) {
            	HttpResponse response = new HttpResponse();
                response.setHeader('Endpoint',  SAEConstants.SAE_MEMBERPROVIDER_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
                response.setHeader('Method', 'GET');
                response.setBody(SAETestDataFactory.getStaticResourceResponse('claimRecon_PIQ1234567'));
                response.setStatusCode(200);
                return response;
        }
    }
    
    global class SAEClaimAttachmentListWebServiceMock implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest request) {
            	HttpResponse response = new HttpResponse();
                response.setHeader('Endpoint',  SAEConstants.SAE_MEMBERPROVIDER_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
                response.setHeader('Method', 'GET');
                response.setBody(SAETestDataFactory.getStaticResourceResponse('claimAttachmentList_PIQ1234567'));
                response.setStatusCode(200);
                return response;
        }
    }
    
    global class SAEClaimActWebServiceMock implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest request) {
            	HttpResponse response = new HttpResponse();
                response.setHeader('Endpoint',  SAEConstants.SAE_MEMBERPROVIDER_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
                response.setHeader('Method', 'GET');
                response.setBody(SAETestDataFactory.getStaticResourceResponse('claimAction_18A9027070'));
                response.setStatusCode(200);
                return response;
        }
    }
    
    global class SAEProviderWSMock implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint', 'https://gateway-stage.optum.com/api/alpha/pdr/pes/physicians-and-facilities/v4.0/search?app-nm=acet&start=0&count=50&tax-id-nbr=061330992&tax-id-type-cd=T&attribute-set=summary_0002');
            response.setHeader('Method', 'POST');
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{ "metadata": { "offset": 0,"psize": 2,"total": 5465,"elapsedTime": "143 MilliSeconds","elasticTime": "73 MilliSeconds","wildCardResp": " ","elapsedPODMTime": " "}, "PhysicianFacilitySummary0002Response": [{ "physicianFacilityInformation": { "firstName": "LARRY", "lastName": "MARCUS", "taxId": { "taxId": "061330992", "corporateOwnerLastName": "NORTHEAST MEDICAL GROUP", "corpMPIN": "000971492","cancelDate": "9999-12-31" }} }, { "physicianFacilityInformation": { "firstName": "LARRY", "lastName": "MARCUS", "taxId": { "taxId": "061330992", "corporateOwnerLastName": "NORTHEAST MEDICAL GROUP", "corpMPIN": "000971492","cancelDate": "9999-12-31" } } } ] }');            
            response.setStatusCode(200);
            response.setStatus('status');
            return response;
        }
    }

        global class SAEPCPHistoryWebServiceMock implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest request) {
            	HttpResponse response = new HttpResponse();
                response.setHeader('Endpoint',  SAEConstants.SAE_PCP_HISTORY_ENDPOINT );
                response.setHeader('Method', 'GET');
                response.setBody(SAETestDataFactory.getStaticResourceResponse(SAEConstants.SAE_PCP_HISTORY_STATICRESOURCE_NAME));
                response.setStatusCode(200);
                return response;
        }
    }

    global class SAEPCPHistoryWebServiceMock400 implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest request) {
            	HttpResponse response = new HttpResponse();
                response.setHeader('Endpoint',  SAEConstants.SAE_PCP_HISTORY_ENDPOINT );
                response.setHeader('Method', 'GET');
                response.setBody(SAETestDataFactory.getStaticResourceResponse(SAEConstants.SAE_PCP_HISTORY_STATICRESOURCE_NAME));
                response.setStatusCode(400);
                return response;
        }
    }

    global class SAEPCPHistoryWebServiceMock404 implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest request) {
            	HttpResponse response = new HttpResponse();
                response.setHeader('Endpoint',  SAEConstants.SAE_PCP_HISTORY_ENDPOINT );
                response.setHeader('Method', 'GET');
                response.setBody(SAETestDataFactory.getStaticResourceResponse(SAEConstants.SAE_PCP_HISTORY_STATICRESOURCE_NAME));
                response.setStatusCode(404);
                return response;
        }
    }

    global class SAEPCPHistoryWebServiceMock500 implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest request) {
            	HttpResponse response = new HttpResponse();
                response.setHeader('Endpoint',  SAEConstants.SAE_PCP_HISTORY_ENDPOINT );
                response.setHeader('Method', 'GET');
                response.setBody(SAETestDataFactory.getStaticResourceResponse(SAEConstants.SAE_PCP_HISTORY_STATICRESOURCE_NAME));
                response.setStatusCode(500);
                return response;
        }
    }

    global class SAEGETAccessTokenSchedulerWebServiceMock implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint',  SAEConstants.SAE_GetACCESSTOKENSCHEDULER_ENDPOINT );
            response.setHeader('Method', 'POST');
            //response.setBody(SAETestDataFactory.getStaticResourceResponse(SAEConstants.SAE_GetACCESSTOKENSCHEDULER));
            response.setBody('{"token_type": "bearer","access_token": "g5YuwO6RT4HAmZTrWaXSfX7tpBuPMLtH","expires_in": 1458}');
            response.setStatusCode(200);
            return response;
        }
    }

    global class SAEExtendedCoverageWSMock_LocalSC implements HttpCalloutMock {
        String LocalSC;

        public SAEExtendedCoverageWSMock_LocalSC(String loc){
            this.LocalSC = loc;
        }

        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint', SAEConstants.SAE_POLICYSEARCH_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
            response.setHeader('Method', 'GET');
            String responseBody = SAETestDataFactory.getStaticResourceResponse(SAEConstants.SAE_POLICYSEARCH_STATICRESOURCE_NAME);
            responseBody = responseBody.replace('CS', LocalSC);
            response.setBody(responseBody);
            response.setStatusCode(200);
            response.setStatus('OK'); //Avish_11262020
            return response;
        }
    }

    global class SAEWebserviceMockForError implements HttpCalloutMock {
            Integer errorCode;
            String faultCode;
            public SAEWebserviceMockForError(Integer errorCode, String faultCode){
                this.errorCode = errorCode;
                this.faultCode = faultCode;
            }
            global HTTPResponse respond(HTTPRequest request) {
                String strJson = SAETestDataFactory.getStaticResourceResponse(SAEConstants.SAE_NetworkStatusService_STATICRESOURCE_NAME);
                String strJsonUpdated = strJson.replace('"faultCode":null', '"faultCode":"'+faultCode+'"');
                HttpResponse response = new HttpResponse();
                response.setHeader('Endpoint',  SAEConstants.SAE_POLICYSEARCH_VALUE + '?transactionId=' + SAEConstants.SAE_POLICYSEARCH_TRANSACTION_ID);
                response.setHeader('Method', 'GET');
                response.setBody(strJsonUpdated);
                response.setStatusCode(errorCode);
                response.setStatus('OK'); //Avish_11262020
                return response;
            }
        }

    global class ACETAuthorizationFindAuthWebServiceMock implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest request) {
            	HttpResponse response = new HttpResponse();
                response.setHeader('Endpoint',  SAEConstants.FIND_AUTH_RESOURCE_URL + '?transactionId=' + SAEConstants.FIND_AUTH_TRANSACTION_ID);
                response.setHeader('Method', 'POST');
                response.setBody(SAETestDataFactory.getStaticResourceResponse(SAEConstants.FIND_AUTH_RESP));
                response.setStatusCode(200);
                return response;
        }
    }

    global class ACETAuthorizationGetAuthWebServiceMock implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest request) {
            	HttpResponse response = new HttpResponse();
                response.setHeader('Endpoint',  SAEConstants.GET_AUTH_RESOURCE_URL + '?transactionId=' + SAEConstants.FIND_AUTH_TRANSACTION_ID);
                response.setHeader('Method', 'POST');
                response.setBody(SAETestDataFactory.getStaticResourceResponse(SAEConstants.GET_AUTH_RESP));
                response.setStatusCode(200);
                return response;
        }
    }
    
    //US1741780 Added by Sarma on 21/3/2020 
        global class ACETCopayCoInsuranceWebServiceMock implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest request) {
            	HttpResponse response = new HttpResponse();
                response.setHeader('Endpoint',  SAEConstants.COPAY_COINSURANCE_RESOURCE_URL);
                response.setHeader('Method', 'GET');
                response.setBody(SAETestDataFactory.getStaticResourceResponse(SAEConstants.COPAY_COINSURANCE_RESP));
                response.setStatusCode(200);
                return response;
        }
    }

        //US2779783 Added by Sarma on 07/08/2020
        global class ACETCopayCoInsuranceWebServiceMockDollarAmount implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest request) {
            	HttpResponse response = new HttpResponse();
                response.setHeader('Endpoint',  SAEConstants.COPAY_COINSURANCE_RESOURCE_URL);
                response.setHeader('Method', 'GET');
                response.setBody(SAETestDataFactory.getStaticResourceResponse('copay_2_AgAINCgZju_acupunctur'));
                response.setStatusCode(200);
                return response;
        }
    }

    // Get auth service error code 401
    global class ACETAuthorizationGetAuthWebServiceMock401 implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest request) {
            	HttpResponse response = new HttpResponse();
                response.setHeader('Endpoint',  SAEConstants.GET_AUTH_RESOURCE_URL + '?transactionId=' + SAEConstants.FIND_AUTH_TRANSACTION_ID);
                response.setHeader('Method', 'POST');
                response.setBody(SAETestDataFactory.getStaticResourceResponse(SAEConstants.GET_AUTH_RESP));
                response.setStatusCode(401);
                return response;
        }
    }
    // Get auth service error code 400
    global class ACETAuthorizationGetAuthWebServiceMock400 implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest request) {
            	HttpResponse response = new HttpResponse();
                response.setHeader('Endpoint',  SAEConstants.GET_AUTH_RESOURCE_URL + '?transactionId=' + SAEConstants.FIND_AUTH_TRANSACTION_ID);
                response.setHeader('Method', 'POST');
                response.setBody(SAETestDataFactory.getStaticResourceResponse(SAEConstants.GET_AUTH_RESP));
                response.setStatusCode(400);
                return response;
        }
    }

    // US2678228
    global class SAEProperUseWSMock implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint', SAEConstants.SAE_PROPERUSE_VALUE);
            response.setHeader('Method', 'GET');
            response.setBody(SAETestDataFactory.getStaticResourceResponse(SAEConstants.SAE_PROPERUSE_STATICRESOURCE_NAME));
            response.setStatusCode(200);
            return response;
        }
    }

    //US2770009
    global class SAERCEDAPIWSMockExce implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint', SAEConstants.SAE_RCED_API_VALUE); //Avish_11262020
            response.setHeader('Method', 'GET');
            response.setBody(SAETestDataFactory.getStaticResourceResponse(SAEConstants.SAE_RCED_STATICRESOURCE_NAME)); //Avish_11262020
            response.setStatusCode(404);
            return response;
        }
    }
    //US2770009
    global class SAERCEDAPIWSMock200 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint', SAEConstants.SAE_RCED_STATICRESOURCE_NAME);
            response.setHeader('Method', 'GET');
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"groupName":"Sample, Test","statusCode":200}');
            response.setStatusCode(200);
            return response;
        }
    }
    //US2770009
    global class SAERCEDAPIWSMockError implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint', SAEConstants.SAE_RCED_STATICRESOURCE_NAME);
            response.setHeader('Method', 'GET');
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"readResult":{"errors":[{"code":500,"name":"DataProviderMessage","severity":"FAULT","origin":"CDB","description":"STATUS-SYSTEM = CICSAAA2, STATUS-GENERATED-BY = CDB, STATUS-OWNED-BY = CDB, STATUS-SERVICE-NAME = V6435S44, STATUS-SERVICE-VERSION = 000001 {VR1: CODE-TYPE-DESC = CDB-RETURN-CODE, CODE = 01, CODE-DESC = PROGRAM O6435D44 WARNING, ADDITIONAL-INFO = WARNING - DATA NOT FOUND}  {VR1: CODE-TYPE-DESC = CDB-EXPLANATION, CODE = 010, CODE-DESC = PROGRAM O6435D44 WARNING, ADDITIONAL-INFO = D445000001 5000-FETCH-FAM-DATA} "}]}}');//SAETestDataFactory.getStaticResourceResponse(SAEConstants.SAE_RCED_API_VALUE)
            response.setStatusCode(500);
            return response;
        }
    }
    //US2770009
    global class SAERCEDAPIWSMockError999 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint', SAEConstants.SAE_RCED_STATICRESOURCE_NAME);
            response.setHeader('Method', 'GET');
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"readResult":{"errors":[{"code":999,"name":"DataProviderMessage","severity":"FAULT","origin":"CDB","description":"STATUS-SYSTEM = CICSAAA2, STATUS-GENERATED-BY = CDB, STATUS-OWNED-BY = CDB, STATUS-SERVICE-NAME = V6435S44, STATUS-SERVICE-VERSION = 000001 {VR1: CODE-TYPE-DESC = CDB-RETURN-CODE, CODE = 01, CODE-DESC = PROGRAM O6435D44 WARNING, ADDITIONAL-INFO = WARNING - DATA NOT FOUND}  {VR1: CODE-TYPE-DESC = CDB-EXPLANATION, CODE = 010, CODE-DESC = PROGRAM O6435D44 WARNING, ADDITIONAL-INFO = D445000001 5000-FETCH-FAM-DATA} "}]}}');//SAETestDataFactory.getStaticResourceResponse(SAEConstants.SAE_RCED_API_VALUE)
            response.setStatusCode(999);
            return response;
        }
    }

    //US2973232
    global class BenfitSummarySuccessResponse implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint', '');
            response.setHeader('Method', 'GET');
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"newBenefits":true,"benefits":[{"categoryName":"Common Services & Therapies","children":[{"categoryName":"Chiropractic Services","benefitId":"bcdd3200-ac77-11ea-be01-11a16443667b#0706284_ACIS012#20191224T080438701#UNET"},{"categoryName":"Physical Therapy","benefitId":"bf801770-ac77-11ea-be01-11a16443667b#0706284_ACIS012#20191224T080438701#UNET"},{"categoryName":"Occupational Therapy","benefitId":"bf801770-ac77-11ea-be01-11a16443667b#0706284_ACIS012#20191224T080438701#UNET"}]}]}');
            response.setStatusCode(200);
            return response;
        }
    }

    //US2973232
     global class BenfitDetailSuccessResponse implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Endpoint', '');
            response.setHeader('Method', 'GET');
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"newBenefits":true,"benefit":[{"benefitName":"Wisdom Teeth","benefitDetails":"test","benefitNetworkSection":[{"costs":"Not Covered.","networkStatus":["Choice Tier 1 Customer Network IPA 901"]},{"costs":"Not Covered. <br>","networkStatus":["Choice Tier 2 UnitedHealthcare"]}],"limitsAndExceptions":[]}]}');
            response.setStatusCode(200);
            return response;
        }
}
    //US3017101
    global class CAndScontractsSuccessResponse implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setBody('{"communityandstate":[{"prov_id":"000385340","tax_id_nbr":"756004221","tax_id_typ_cd":"T","adr_id":"001117235","adr_typ_cd":"L","ovtn_contr_id":"19625971","ovtn_contr_seq_nbr":"1","ovtn_lob_typ_cd":"301","ovtn_lob_desc":"TX STAR (CAID)","ovtn_pnl_typ_cd":"","ovtn_pnl_desc":" ","ovtn_ipa_typ_cd":"","ovtn_par_prov_ind":"Y","ovtn_prc_pkg_cd":"TXCDPROF0007","ovtn_prc_pkg_nprtcp_cd":"TXCDPROF0007","ovtn_pcp_ind":"P","ovtn_acpt_new_ptnt_ind":"Y","ovtn_acpt_xst_ptnt_ind":"Y","ovtn_acpt_gdr_cd":"B","ovtn_tmln_rsn_typ_cd":"","csp_pltfm_prov_id":"000385340005","bsar":[{"bsar_actv_cd":"A","bsar_id":"796660","bsar_bus_seg_cd":"AMR","bsar_adr_rel_seq_nbr":"705231"}],"ovtn_bil_eff_dt":"2017-12-01","ovtn_eff_dt":"2017-12-01","ovtn_canc_dt":"9999-12-31","ovtn_fl_lmt_day_cnt":"0"}],"metadata":{"offset":0,"psize":450,"total":265,"elapsedTime":"128 Milliseconds","elasticTime":"16 Milliseconds","versionNumber":"1.3","releaseType":"Minor","releaseDate":"April 23,2020","supportContact":"PES_SSMO - BDPaaS_SSMO_DL@ds.uhc.com"}}');
            response.setStatusCode(200);
            return response;
        }
    }

    //US3082944
    global class ACET_FacetsGETProviderContractsService200 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setBody('{"data":{"type":"ProviderContractsType","id":"000837829001","attributes":{"providerId":"000837829001","entity":{"code":"G","desc":"Provider Group"},"npi":"1396764254","inNetworkRelations":[{"relationPcp":"N","networkID":"IANETWORK","agreementId":"IACHPROF0001","networkPrefix":{"code":"CHIP","desc":"CHIP Provider Network"},"lineOfBusiness":"721","effDate":"2018-09-01T00:00:00","termDate":"9999-12-31T00:00:00"},{"relationPcp":"N","networkID":"IANETWORK","agreementId":"IALTPROF0001","networkPrefix":{"code":"LTC","desc":"LTC Provider Network"},"lineOfBusiness":"725","effDate":"2018-09-01T00:00:00","termDate":"9999-12-31T00:00:00"}],"outOfNetworkRelations":[{"nonParProdPfx":{"code":"MOMC","desc":"MO Medicare NonPar Relationship"},"agreementId":"MOMC","effectiveDate":"2018-01-01T00:00:00","termDate":"9999-12-31T00:00:00"}],"provAgreements":[{"agreementId":"IACHPROF0001","agreementDesc":"IA CH MxSP Par 100% with 30% Default - MD","agreementEffDt":"2016-04-01T00:00:00","agreementTermDt":"9999-12-31T00:00:00","agreemtPrevTermDt":"2016-03-31T00:00:00","agreementType":{"code":"BMB","desc":"Blended Medical Behavioral"},"claimAcceptMonths":6,"outpatientPricingType":"NetworX Pricer","networxProfPricing":"Yes","multipleSurgeryPct":"0","delegateInfo":{"delegServRelatedEnt":" "},"profileInfo":{"profileOverrideID":" "},"riskWithhold":{"riskWithholdPct":"0"},"outlierInfo":{"outlierDiscount":"0"},"discounts":{"agppPrmptPayDisc":" ","minimumDiscount":"0","maximumDiscount":"0","strgtDefPricDiscType":"None","strgtDefPricDiscMethod":"None","strgtDefPricDiscPric":"0"},"pymtDrag":{},"relatedPrefixes":{"agseServDefnPfx":{"code":"IA01","desc":"IA CHIP in Network Service Definition"},"agdpPrefix":" ","agcbPrefix":" ","agcgPrefix":" ","aghiPrefix":" ","agipPrefix":" ","agslPrefix":" ","agppPrefix":" ","agpdPrefix":" ","agrgPrefix":" ","agrtPrefix":" ","agilPrefix":" ","agmdPrefix":" ","ageaPrefix":" ","agdePrefix":" ","agdaPrefix":" ","agutPrefix":" ","agaaPrefix":" ","agafPrefix":" ","agsvPrefix":" ","aglpPrefix":" ","agwfPrefix":" ","itagPrefix":" "},"dofr":{"dofrID":" ","delCredentialingID":" ","delegatedQmID":" "}},{"agreementId":"IALTPROF0001","agreementDesc":"IA LT MxSP PAR 100% with 30% default - MD","agreementEffDt":"2015-01-01T00:00:00","agreementTermDt":"9999-12-31T00:00:00","agreementType":{"code":"MED","desc":"Medical Only"},"claimAcceptMonths":6,"outpatientPricingType":"NetworX Pricer","networxProfPricing":"Yes","multipleSurgeryPct":"0","delegateInfo":{"delegServRelatedEnt":" "},"profileInfo":{"profileOverrideID":" "},"riskWithhold":{"riskWithholdPct":"0"},"outlierInfo":{"outlierDiscount":"0"},"discounts":{"agppPrmptPayDisc":" ","minimumDiscount":"0","maximumDiscount":"0","strgtDefPricDiscType":"None","strgtDefPricDiscMethod":"None","strgtDefPricDiscPric":"0"},"pymtDrag":{},"relatedPrefixes":{"agseServDefnPfx":{"code":"IA03","desc":"IA LTC In Network Service Definition"},"agdpPrefix":" ","agcbPrefix":" ","agcgPrefix":" ","aghiPrefix":" ","agipPrefix":" ","agslPrefix":" ","agppPrefix":" ","agpdPrefix":" ","agrgPrefix":" ","agrtPrefix":" ","agilPrefix":" ","agmdPrefix":" ","ageaPrefix":" ","agdePrefix":" ","agdaPrefix":" ","agutPrefix":" ","agaaPrefix":" ","agafPrefix":" ","agsvPrefix":" ","aglpPrefix":" ","agwfPrefix":" ","itagPrefix":" "},"dofr":{"dofrID":" ","delCredentialingID":" ","delegatedQmID":" "}},{"agreementId":"MOMC","agreementDesc":"MO MC NonPar Medicare 100% with 25% default","agreementEffDt":"2020-05-01T00:00:00","agreementTermDt":"9999-12-31T00:00:00","agreemtPrevTermDt":"2020-04-30T00:00:00","agreementType":{"code":"NP","desc":"Non Participating"},"claimAcceptMonths":12,"outpatientPricingType":"NetworX Pricer","networxProfPricing":"Yes","multipleSurgeryPct":"0","delegateInfo":{"delegServRelatedEnt":" "},"profileInfo":{"profileOverrideID":" "},"riskWithhold":{"riskWithholdPct":"0"},"outlierInfo":{"outlierDiscount":"0"},"discounts":{"agppPrmptPayDisc":" ","minimumDiscount":"0","maximumDiscount":"0","strgtDefPricDiscType":"None","strgtDefPricDiscMethod":"None","strgtDefPricDiscPric":"0"},"pymtDrag":{},"relatedPrefixes":{"agseServDefnPfx":{"code":"MOMC","desc":"MO Medicare Out of Network Provider Service Definition (AGSE)"},"agdpPrefix":" ","agcbPrefix":" ","agcgPrefix":" ","aghiPrefix":" ","agipPrefix":" ","agslPrefix":" ","agppPrefix":" ","agpdPrefix":" ","agrgPrefix":" ","agrtPrefix":" ","agilPrefix":" ","agmdPrefix":" ","ageaPrefix":" ","agdePrefix":" ","agdaPrefix":" ","agutPrefix":" ","agaaPrefix":" ","agafPrefix":" ","agsvPrefix":" ","aglpPrefix":" ","agwfPrefix":" ","itagPrefix":" "},"dofr":{"dofrID":" ","delCredentialingID":" ","delegatedQmID":" "}}]}}}');
            response.setStatusCode(200);
            return response;
        }
    }

    global class ACET_ECAALetterEndPointService200 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setBody(SAETestDataFactory.getStaticResourceResponse('FindDoc_ICUE_A091944441'));
            response.setStatusCode(200);
            return response;
        }
    }

     global class ACET_MedNecService200 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setBody(SAETestDataFactory.getStaticResourceResponse('Mednec_902719_Betsy'));
            response.setStatusCode(200);
            return response;
        }
    }

    global class ACET_ENICOBResponse implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setBody('{"readResult":{"readOutput":{"eligibilities":[{"subscriberId":"00152546202","alternateId":"978101006","uhpDesignation":"","phiIndicator":"","claimSystem":"F","regionCode":"FOXX","offices":[{"officeNumber":"443","officeName":"","officeAddress":{"street1":"BUFFALO SERVICE CENTER","street2":"PO BOX 740800","street3":"","city":"ATLANTA","state":"GA","zip":"303740800","zip4":"","countryCode":""},"officePhone":"8662705311","officeTollFree":"8778423210"},{"officeNumber":"443","officeName":"","officeAddress":{"street1":"","street2":"","street3":"","city":"","state":"","zip":"","zip4":"","countryCode":""},"officePhone":"","officeTollFree":""}],"subscriberDetail":{"eligibility":{"consumerKeys":{"sourceCode":"CS","familyId":"0317373859","familyIdPartitionNumber":"00259","xrefId":"0544858083","xrefIdPartitionNumber":"00183","legacySourceId":"09055090015254620200001"},"demographics":{"personName":{"firstName":"OLGA","middleInitial":"L","middleName":"L","lastName":"SEVILA","nameSuffix":""},"topsName":"OLGA","gender":"F","age":"60","dependentNumber":"001","topsLatestCancelDate":"","systemDivision":"","tobaccoUsageIndicator":"","memberId":"","survivingSpouseId":"","hicNumber":"6D87KU2UP60","medicaidRecipientNumber":"","memberAltId":"","socialSecurityNumber":"152546202","legacyPolicyNumber":"0905509","claimEngineCode":"F","legacyCustomerNumber":"0905509","cesCustomerName":"LIBERTY MUTUAL","differentFamilyMemberAddressIndicator":"Y","alternateIdAssignTypeCode":"S","marketSegment":"USS","integratedCardTypeCode":"H","employeeStartDate":"1992-10-19","workHours":"00000","salaryTypeCode":"","salaryAmount":"0.00","retirementDate":"2018-08-02","deceasedDate":"9999-12-31","lateEnrollCode":"","exSpouseTypeCode":"","exSpouseSubscriberId":"","healthCoverageTransferIndicator":"","healthCoverageTransferEffectiveDates":{"start":"0001-01-01","end":"9999-12-31"},"atOccupationTypeCode":"","rrDependentProofOfEligibilityDate":"9999-12-31","cobraIndicator":"","cobIndicator":"N","cobVerifyDate":"2018-11-10","cobEffectiveDates":{"start":"0001-01-01","end":"9999-12-31"},"medicareExistsIndicator":"Y","medicareTypeCode":"C","medicareIneligibleNotEnrolledCode":"","medicareEntitlementTypeCode":"G","medicareEnrolls":[{"medicarePart":"A","medicareEnrollEffectiveDates":{"start":"2017-02-01","end":"9999-12-31"}},{"medicarePart":"B","medicareEnrollEffectiveDates":{"start":"2017-02-01","end":"9999-12-31"}}],"custodyCode":"","familyLastUpdateTimestamp":"","migrationLegacySourceId":"","migrationLegacyPolicyNumber":"","camsLegacySourceId":"","camsLegacyPolicyNumber":"","consumerProvidedTaxIdNumber":"","consumerProvidedTaxIdNumberStatusTypeCd":"","eobSuppressionIndicator":"","healthStatementSuppressionIndicator":"","administrativeLetterSuppressionIndicator":"","proofOfHealthCoverageSuppressionIndicator":"","preferenceCodeDescription":"No preference selected","memberLoyaltyYearsOfService":"","memberLoyaltyAcknowledgementDate":"","reportSegment":"USS","healthProgramCode":"","healthPlanCode":"","familyId":"0317373859","familyIdPartitionNumber":"00259","sourceCode":"CS","priorMemberId":"PMI","dateOfBirth":"1960-09-03","cdbRelationshipCode":"000","legacySourceRelationshipCode":"00","individualRelationshipCode":"RR","topsSequenceNumber":"00","topsOrigCoverageEffectiveDate":"2016-01-01","primeDependentCode":"","maritalStatus":"U","employeeStatus":"R","specialHandlerCode":"0","phiIndicator":"","qmscoIndicator":"","primaryPhoneNumber":"8133811886","alternatePhoneNumber":"8135622430","mobilePhoneNumber":"","organizationTypeCode":"","permanentAddress":{"postalAddress":{"street1":"2222 MAYDELL DRIVE","street2":"","street3":"","city":"TAMPA","state":"FL","zip":"33619","zip4":"","countryCode":"US"},"marketNumber":"0009452","countrySubCode":""},"mailingAddress":{"postalAddress":{"street1":"2222 MAYDELL DRIVE","street2":"","street3":"","city":"TAMPA","state":"FL","zip":"33619","zip4":"","countryCode":"US"},"marketNumber":"0009452","countrySubCode":""}},"healthCoverages":[{"policyNumber":"0905509","coverageType":"M","healthCoverageEffectiveDates":{"start":"2018-09-01","end":"2019-06-28"},"cesGroupNumber":"0905509","planVariationCode":"0375","reportingCode":"0375","productType":"POS","productCode":"Q","marketType":"50","marketNumber":"0009452","productServiceCode":"8","coverageLevel":"1","sharedArrangementCode":"03","obligorId":"01","allianceCode":"","passportGroupNumber":"","systemDivision":"","eligibilitySystemTypeCode":"01","claimSystemTypeCode":"01","eligibilityStatusTypeCode":"R","governmentProgramTypeCode":"","medicaTravelBenefitIndicator":"N","cancelReasonTypeCode":"CO","coveragePaidThruDate":"9999-12-31","coveragePaidThruReasonCode":"","listBillTypeCode":"N","billingSuffixCode":"PC","billingSubGroupNumber":"46375","topsCoverageLevel":"51","cosmosPanelNumber":"000","rrBenefitGroupNumber":"","rrBenefitGroupChoiceCode":"","rrBranchCode":"","rrUnionCode":"","rrOptOutPlanIndicator":"","fundingArrangement":"A","stateOfIssue":"MA","legacyProductId":"PS1M07O9999","legacyBenefitPlanId":"ACIS046","benefitSetEffectiveDates":{"start":"2018-01-01","end":"2020-12-31"},"salaries":[{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"}],"dependentCoverageAllowedIndicator":"Y","capitationType":"N","claimAccountCode":"000146","optumIndicator":"W","sharedSavingsIndicator":"N","legalEntity1":"20020","legalEntity2":"","productTermCode":"","urnCode":"Y","ubhCode":"Y","healthAlliesDiscount":"","nhaTypeCode":"","globalSolutionsIndicator":"N","displayIndicator":"C","topsSubscriberId":"S152546202","topsPolicyNumber":"905509","topsPlanVariationCode":"0375","topsReportingCode":"0375","coverageLastUpdateDate":"2019-07-09","emergentWrapIndicator":"N","eligibilityGracePeriodThruDate":"9999-12-31","lastPremiumPaidDate":"0001-01-01","migrationLegacyPolicyNumber":"","topsCoverageSet":{"topsCoverageSetId":"E","baseMme":"0","cme":"46","medicare":"5","rpcSuffix":"PC","rpcAccount":"000146"},"tier1Indicator":"","xrefIdPntr":"01","sharedSavingPackageIndicator":"N","proofOfHealthCoverage":"C","designatedVirtualClinicNetwork":"Y","consumerLegalEntity":"","individualGroupTypeCode":"","billIndicatorTypeCode":"","outlierCostManagementIndicator":"N","memberAdvocacyIndicator":"N","nhpNetworkFlexIndicator":"","hdhpIndicator":"03","policyType":"36","benefitPeriodStartDate":"2018-01-01","benefitPeriodEndDate":"2018-12-31","productClassifier":"00004","certificationOfCoverageYear":"2007","brandingType":"Name-50","brandingName":"","siteOfCareCoreMed":"A","siteOfCareRadiology":"E","siteOfCareCardiology":"E","siteOfCareChemo":"E","siteOfCareGeneticTest":"E","siteOfCareServiceOne":"E","siteOfCareServiceTwo":"E","packageBenefitPlanCode":"","hContractId":"","segmentId":""},{"policyNumber":"0905509","coverageType":"A","healthCoverageEffectiveDates":{"start":"2018-09-01","end":"2019-06-28"},"cesGroupNumber":"0905509","planVariationCode":"0375","reportingCode":"0375","productType":"","productCode":"","marketType":"50","marketNumber":"0009452","productServiceCode":"8","coverageLevel":"1","sharedArrangementCode":"03","obligorId":"01","allianceCode":"","passportGroupNumber":"","systemDivision":"","eligibilitySystemTypeCode":"01","claimSystemTypeCode":"01","eligibilityStatusTypeCode":"R","governmentProgramTypeCode":"","medicaTravelBenefitIndicator":"N","cancelReasonTypeCode":"CO","coveragePaidThruDate":"9999-12-31","coveragePaidThruReasonCode":"","listBillTypeCode":"N","billingSuffixCode":"PC","billingSubGroupNumber":"46375","topsCoverageLevel":"51","cosmosPanelNumber":"000","rrBenefitGroupNumber":"","rrBenefitGroupChoiceCode":"","rrBranchCode":"","rrUnionCode":"","rrOptOutPlanIndicator":"","fundingArrangement":"A","stateOfIssue":"MA","legacyProductId":"PS1M07O9999","legacyBenefitPlanId":"ACIS046","benefitSetEffectiveDates":{"start":"2019-01-01","end":"2020-01-31"},"salaries":[{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"}],"dependentCoverageAllowedIndicator":"Y","capitationType":"N","claimAccountCode":"000146","optumIndicator":"W","sharedSavingsIndicator":"N","legalEntity1":"20020","legalEntity2":"","productTermCode":"","urnCode":"N","ubhCode":"N","healthAlliesDiscount":"","nhaTypeCode":"","globalSolutionsIndicator":"N","displayIndicator":"","topsSubscriberId":"S152546202","topsPolicyNumber":"905509","topsPlanVariationCode":"0375","topsReportingCode":"0375","coverageLastUpdateDate":"2019-07-09","emergentWrapIndicator":"N","eligibilityGracePeriodThruDate":"9999-12-31","lastPremiumPaidDate":"0001-01-01","migrationLegacyPolicyNumber":"","topsCoverageSet":{"topsCoverageSetId":"E","baseMme":"0","cme":"46","medicare":"5","rpcSuffix":"PC","rpcAccount":"000146"},"tier1Indicator":"","xrefIdPntr":"01","sharedSavingPackageIndicator":"N","proofOfHealthCoverage":"","designatedVirtualClinicNetwork":"N","consumerLegalEntity":"","individualGroupTypeCode":"","billIndicatorTypeCode":"","outlierCostManagementIndicator":"N","memberAdvocacyIndicator":"N","nhpNetworkFlexIndicator":"","hdhpIndicator":"03","policyType":"36","benefitPeriodStartDate":"2018-01-01","benefitPeriodEndDate":"2018-12-31","packageBenefitPlanCode":"","hContractId":"","segmentId":""},{"policyNumber":"0905509","coverageType":"B","healthCoverageEffectiveDates":{"start":"2018-09-01","end":"2019-06-28"},"cesGroupNumber":"0905509","planVariationCode":"0375","reportingCode":"0375","productType":"POS","productCode":"Q","marketType":"50","marketNumber":"0009452","productServiceCode":"8","coverageLevel":"1","sharedArrangementCode":"03","obligorId":"01","allianceCode":"","passportGroupNumber":"","systemDivision":"","eligibilitySystemTypeCode":"01","claimSystemTypeCode":"01","eligibilityStatusTypeCode":"R","governmentProgramTypeCode":"","medicaTravelBenefitIndicator":"N","cancelReasonTypeCode":"CO","coveragePaidThruDate":"9999-12-31","coveragePaidThruReasonCode":"","listBillTypeCode":"N","billingSuffixCode":"PC","billingSubGroupNumber":"46375","topsCoverageLevel":"51","cosmosPanelNumber":"000","rrBenefitGroupNumber":"","rrBenefitGroupChoiceCode":"","rrBranchCode":"","rrUnionCode":"","rrOptOutPlanIndicator":"","fundingArrangement":"A","stateOfIssue":"MA","legacyProductId":"PS1M07O9999","legacyBenefitPlanId":"ACIS046","benefitSetEffectiveDates":{"start":"2018-01-01","end":"2020-12-31"},"salaries":[{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"}],"dependentCoverageAllowedIndicator":"Y","capitationType":"N","claimAccountCode":"000146","optumIndicator":"W","sharedSavingsIndicator":"N","legalEntity1":"20020","legalEntity2":"","productTermCode":"","urnCode":"N","ubhCode":"Y","healthAlliesDiscount":"","nhaTypeCode":"","globalSolutionsIndicator":"N","displayIndicator":"","topsSubscriberId":"S152546202","topsPolicyNumber":"905509","topsPlanVariationCode":"0375","topsReportingCode":"0375","coverageLastUpdateDate":"2019-07-09","emergentWrapIndicator":"N","eligibilityGracePeriodThruDate":"9999-12-31","lastPremiumPaidDate":"0001-01-01","migrationLegacyPolicyNumber":"","topsCoverageSet":{"topsCoverageSetId":"E","baseMme":"0","cme":"46","medicare":"5","rpcSuffix":"PC","rpcAccount":"000146"},"tier1Indicator":"","xrefIdPntr":"01","sharedSavingPackageIndicator":"N","proofOfHealthCoverage":"","designatedVirtualClinicNetwork":"N","consumerLegalEntity":"","individualGroupTypeCode":"","billIndicatorTypeCode":"","outlierCostManagementIndicator":"N","memberAdvocacyIndicator":"N","nhpNetworkFlexIndicator":"","hdhpIndicator":"03","policyType":"36","benefitPeriodStartDate":"2018-01-01","benefitPeriodEndDate":"2018-12-31","packageBenefitPlanCode":"","hContractId":"","segmentId":""},{"policyNumber":"0905509","coverageType":"E","healthCoverageEffectiveDates":{"start":"2018-09-01","end":"2019-06-28"},"cesGroupNumber":"0905509","planVariationCode":"0375","reportingCode":"0375","productType":"","productCode":"","marketType":"50","marketNumber":"0009452","productServiceCode":"8","coverageLevel":"1","sharedArrangementCode":"03","obligorId":"01","allianceCode":"","passportGroupNumber":"","systemDivision":"","eligibilitySystemTypeCode":"01","claimSystemTypeCode":"05","eligibilityStatusTypeCode":"R","governmentProgramTypeCode":"","medicaTravelBenefitIndicator":"N","cancelReasonTypeCode":"CO","coveragePaidThruDate":"9999-12-31","coveragePaidThruReasonCode":"","listBillTypeCode":"N","billingSuffixCode":"PC","billingSubGroupNumber":"46375","topsCoverageLevel":"51","cosmosPanelNumber":"000","rrBenefitGroupNumber":"","rrBenefitGroupChoiceCode":"","rrBranchCode":"","rrUnionCode":"","rrOptOutPlanIndicator":"","fundingArrangement":"A","stateOfIssue":"MA","legacyProductId":"PS1M07O9999","legacyBenefitPlanId":"ACIS046","benefitSetEffectiveDates":{"start":"2018-01-01","end":"2020-12-31"},"salaries":[{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"}],"dependentCoverageAllowedIndicator":"Y","capitationType":"N","claimAccountCode":"000146","optumIndicator":"W","sharedSavingsIndicator":"N","legalEntity1":"20020","legalEntity2":"","productTermCode":"","urnCode":"N","ubhCode":"N","healthAlliesDiscount":"","nhaTypeCode":"","globalSolutionsIndicator":"N","displayIndicator":"","topsSubscriberId":"S152546202","topsPolicyNumber":"905509","topsPlanVariationCode":"0375","topsReportingCode":"0375","coverageLastUpdateDate":"2019-07-09","emergentWrapIndicator":"N","eligibilityGracePeriodThruDate":"9999-12-31","lastPremiumPaidDate":"0001-01-01","migrationLegacyPolicyNumber":"","topsCoverageSet":{"topsCoverageSetId":"E","baseMme":"0","cme":"46","medicare":"5","rpcSuffix":"PC","rpcAccount":"000146"},"tier1Indicator":"","xrefIdPntr":"01","sharedSavingPackageIndicator":"N","proofOfHealthCoverage":"","designatedVirtualClinicNetwork":"N","consumerLegalEntity":"","individualGroupTypeCode":"","billIndicatorTypeCode":"","outlierCostManagementIndicator":"N","memberAdvocacyIndicator":"N","nhpNetworkFlexIndicator":"","hdhpIndicator":"03","policyType":"36","benefitPeriodStartDate":"2018-01-01","benefitPeriodEndDate":"2018-12-31","packageBenefitPlanCode":"","hContractId":"","segmentId":""},{"policyNumber":"0905509","coverageType":"U","healthCoverageEffectiveDates":{"start":"2018-09-01","end":"2019-06-28"},"cesGroupNumber":"0905509","planVariationCode":"0375","reportingCode":"0375","productType":"","productCode":"","marketType":"50","marketNumber":"0009452","productServiceCode":"8","coverageLevel":"1","sharedArrangementCode":"03","obligorId":"01","allianceCode":"","passportGroupNumber":"","systemDivision":"","eligibilitySystemTypeCode":"01","claimSystemTypeCode":"01","eligibilityStatusTypeCode":"R","governmentProgramTypeCode":"","medicaTravelBenefitIndicator":"N","cancelReasonTypeCode":"CO","coveragePaidThruDate":"9999-12-31","coveragePaidThruReasonCode":"","listBillTypeCode":"N","billingSuffixCode":"PC","billingSubGroupNumber":"46375","topsCoverageLevel":"51","cosmosPanelNumber":"000","rrBenefitGroupNumber":"","rrBenefitGroupChoiceCode":"","rrBranchCode":"","rrUnionCode":"","rrOptOutPlanIndicator":"","fundingArrangement":"A","stateOfIssue":"MA","legacyProductId":"PS1M07O9999","legacyBenefitPlanId":"ACIS046","benefitSetEffectiveDates":{"start":"2019-01-01","end":"2020-01-31"},"salaries":[{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"},{"year":"0000","inNetworkDeductible":"0.00","inNetworkOop":"0.00","outOfNetworkDeductible":"0.00","outOfNetworkOop":"0.00"}],"dependentCoverageAllowedIndicator":"Y","capitationType":"N","claimAccountCode":"000146","optumIndicator":"W","sharedSavingsIndicator":"N","legalEntity1":"20020","legalEntity2":"","productTermCode":"","urnCode":"Y","ubhCode":"N","healthAlliesDiscount":"","nhaTypeCode":"","globalSolutionsIndicator":"N","displayIndicator":"","topsSubscriberId":"S152546202","topsPolicyNumber":"905509","topsPlanVariationCode":"0375","topsReportingCode":"0375","coverageLastUpdateDate":"2019-07-09","emergentWrapIndicator":"N","eligibilityGracePeriodThruDate":"9999-12-31","lastPremiumPaidDate":"0001-01-01","migrationLegacyPolicyNumber":"","topsCoverageSet":{"topsCoverageSetId":"E","baseMme":"0","cme":"46","medicare":"5","rpcSuffix":"PC","rpcAccount":"000146"},"tier1Indicator":"","xrefIdPntr":"01","sharedSavingPackageIndicator":"N","proofOfHealthCoverage":"","designatedVirtualClinicNetwork":"N","consumerLegalEntity":"","individualGroupTypeCode":"","billIndicatorTypeCode":"","outlierCostManagementIndicator":"N","memberAdvocacyIndicator":"N","nhpNetworkFlexIndicator":"","hdhpIndicator":"03","policyType":"36","benefitPeriodStartDate":"2018-01-01","benefitPeriodEndDate":"2018-12-31","packageBenefitPlanCode":"","hContractId":"","segmentId":""}],"cobs":[{"coverageType":"M","otherInsuranceDates":{"start":"0001-01-01","end":"9999-12-31"},"otherInsuranceVerifyDate":"2018-11-10","otherInsuranceIndicator":"N","custodyCode":"","cobPrimacies":[]}],"medicares":[{"medicareExistsIndicator":"Y","medicareTypeCode":"C","medicareIneligibleNotEnrolledCode":"","medicareEntitlements":[{"entitlementTypeCode":"G","medicareEntitlementEffectiveDates":{"start":"2017-02-01","end":"9999-12-31"}}],"medicareEligibilities":[{"medicarePart":"A","eligibilityIndicator":"Y","medicareEligibilityEffectiveDates":{"start":"2017-02-01","end":"9999-12-31"},"medicareEnrollments":[{"medicareEnrollmentEffectiveDates":{"start":"2017-02-01","end":"9999-12-31"}}],"medicarePrimacies":[{"medicarePrimacyEffectiveDates":{"start":"2017-02-01","end":"9999-12-31"},"medicarePrimacy":"P","uhgOrderOfBenefits":"2","medicareCrossOverIndicator":"Y"}]},{"medicarePart":"B","eligibilityIndicator":"Y","medicareEligibilityEffectiveDates":{"start":"2017-02-01","end":"9999-12-31"},"medicareEnrollments":[{"medicareEnrollmentEffectiveDates":{"start":"2017-02-01","end":"9999-12-31"}}],"medicarePrimacies":[{"medicarePrimacyEffectiveDates":{"start":"2017-02-01","end":"9999-12-31"},"medicarePrimacy":"P","uhgOrderOfBenefits":"2","medicareCrossOverIndicator":"Y"}]}]}],"currentCobPrimarySecondary":{"typeCode":"N","effectiveDates":{"start":"2001-01-01","end":"9999-12-31"},"verifyDate":"2018-11-10"},"previousCobPrimarySecondary":{"typeCode":"","effectiveDates":{"start":"2001-01-01","end":"9999-12-31"},"verifyDate":""},"currentMedicarePrimarySecondary":{"typeCode":"Y","effectiveDates":{"start":"2017-02-01","end":"9999-12-31"}},"previousMedicarePrimarySecondary":{"typeCode":"","effectiveDates":{"start":"0001-01-01","end":"9999-12-31"}},"networkKey":"M","phiIndicator":"","blbsMemberEligibilityIndicator":"N"}},"dependents":[{"eligibility":{"consumerKeys":{"sourceCode":"CS","familyId":"0317373859","familyIdPartitionNumber":"00259","xrefId":"0544858223","xrefIdPartitionNumber":"00023","legacySourceId":"09055090015254620201001"},"demographics":{"personName":{"firstName":"WILLIAM","middleInitial":"","middleName":"","lastName":"DENNIS","nameSuffix":""},"topsName":"WILLIAM","gender":"M","age":"71","dependentNumber":"001","topsLatestCancelDate":"","systemDivision":"","tobaccoUsageIndicator":"","memberId":"","survivingSpouseId":"","hicNumber":"4WX6X68DT51","medicaidRecipientNumber":"","memberAltId":"","socialSecurityNumber":"267152315","legacyPolicyNumber":"0905509","claimEngineCode":"F","legacyCustomerNumber":"0905509","cesCustomerName":"LIBERTY MUTUAL","differentFamilyMemberAddressIndicator":"Y","alternateIdAssignTypeCode":"S","marketSegment":"USS","integratedCardTypeCode":"H","employeeStartDate":"0001-01-01","workHours":"00000","salaryTypeCode":"","salaryAmount":"0.00","retirementDate":"9999-12-31","deceasedDate":"9999-12-31","lateEnrollCode":"","exSpouseTypeCode":"","exSpouseSubscriberId":"","healthCoverageTransferIndicator":"","healthCoverageTransferEffectiveDates":{"start":"0001-01-01","end":"9999-12-31"},"atOccupationTypeCode":"","rrDependentProofOfEligibilityDate":"9999-12-31","cobraIndicator":"","cobIndicator":"N","cobVerifyDate":"2017-09-15","cobEffectiveDates":{"start":"0001-01-01","end":"9999-12-31"},"medicareExistsIndicator":"Y","medicareTypeCode":"C","medicareIneligibleNotEnrolledCode":"","medicareEntitlementTypeCode":"A","medicareEnrolls":[{"medicarePart":"A","medicareEnrollEffectiveDates":{"start":"2015-02-01","end":"9999-12-31"}},{"medicarePart":"B","medicareEnrollEffectiveDates":{"start":"2019-07-01","end":"9999-12-31"}}],"custodyCode":"","familyLastUpdateTimestamp":"","migrationLegacySourceId":"","migrationLegacyPolicyNumber":"","camsLegacySourceId":"","camsLegacyPolicyNumber":"","consumerProvidedTaxIdNumber":"","consumerProvidedTaxIdNumberStatusTypeCd":"","eobSuppressionIndicator":"","healthStatementSuppressionIndicator":"","administrativeLetterSuppressionIndicator":"","proofOfHealthCoverageSuppressionIndicator":"","preferenceCodeDescription":"No preference selected","memberLoyaltyYearsOfService":"","memberLoyaltyAcknowledgementDate":"","reportSegment":"USS","healthProgramCode":"","healthPlanCode":"","familyId":"0317373859","familyIdPartitionNumber":"00259","sourceCode":"CS","priorMemberId":"PMI","dateOfBirth":"1950-02-05","cdbRelationshipCode":"001","legacySourceRelationshipCode":"01","individualRelationshipCode":"SP","topsSequenceNumber":"02","topsOrigCoverageEffectiveDate":"2016-01-01","primeDependentCode":"","maritalStatus":"U","employeeStatus":"R","specialHandlerCode":"0","phiIndicator":"","qmscoIndicator":"","primaryPhoneNumber":"8133448660","alternatePhoneNumber":"8135622430","mobilePhoneNumber":"","organizationTypeCode":"","permanentAddress":{"postalAddress":{"street1":"8420 CAMDEN ST APT D","street2":"","street3":"","city":"TAMPA","state":"FL","zip":"33614","zip4":"","countryCode":"US"},"marketNumber":"0009452","countrySubCode":""},"mailingAddress":{"postalAddress":{"street1":"8420 CAMDEN ST APT D","street2":"","street3":"","city":"TAMPA","state":"FL","zip":"33614","zip4":"","countryCode":"US"},"marketNumber":"0009452","countrySubCode":""}},"cobs":[{"coverageType":"M","otherInsuranceDates":{"start":"0001-01-01","end":"9999-12-31"},"otherInsuranceVerifyDate":"2017-09-15","otherInsuranceIndicator":"N","custodyCode":"","cobPrimacies":[]}],"medicares":[{"medicareExistsIndicator":"Y","medicareTypeCode":"C","medicareIneligibleNotEnrolledCode":"","medicareEntitlements":[{"entitlementTypeCode":"A","medicareEntitlementEffectiveDates":{"start":"2015-02-01","end":"9999-12-31"}}],"medicareEligibilities":[{"medicarePart":"A","eligibilityIndicator":"Y","medicareEligibilityEffectiveDates":{"start":"2015-02-01","end":"9999-12-31"},"medicareEnrollments":[{"medicareEnrollmentEffectiveDates":{"start":"2015-02-01","end":"9999-12-31"}}],"medicarePrimacies":[{"medicarePrimacyEffectiveDates":{"start":"2018-08-02","end":"9999-12-31"},"medicarePrimacy":"P","uhgOrderOfBenefits":"2","medicareCrossOverIndicator":"Y"}]},{"medicarePart":"B","eligibilityIndicator":"Y","medicareEligibilityEffectiveDates":{"start":"2019-07-01","end":"9999-12-31"},"medicareEnrollments":[{"medicareEnrollmentEffectiveDates":{"start":"2019-07-01","end":"9999-12-31"}}],"medicarePrimacies":[{"medicarePrimacyEffectiveDates":{"start":"2019-07-01","end":"9999-12-31"},"medicarePrimacy":"P","uhgOrderOfBenefits":"2","medicareCrossOverIndicator":"Y"}]}]}],"currentCobPrimarySecondary":{"typeCode":"N","effectiveDates":{"start":"0001-01-01","end":"9999-12-31"},"verifyDate":"2017-09-15"},"previousCobPrimarySecondary":{"typeCode":"","effectiveDates":{"start":"0001-01-01","end":"9999-12-31"},"verifyDate":""},"currentMedicarePrimarySecondary":{"typeCode":"Y","effectiveDates":{"start":"2019-07-01","end":"9999-12-31"}},"previousMedicarePrimarySecondary":{"typeCode":"1","effectiveDates":{"start":"2018-08-02","end":"2019-06-30"}},"networkKey":"M","phiIndicator":"","blbsMemberEligibilityIndicator":"N"}},{"eligibility":{"consumerKeys":{"sourceCode":"CS","familyId":"0317373859","familyIdPartitionNumber":"00259","xrefId":"0544858277","xrefIdPartitionNumber":"00077","legacySourceId":"09055090015254620202001"},"demographics":{"personName":{"firstName":"JULISSA","middleInitial":"L","middleName":"L","lastName":"SEVILA MS","nameSuffix":""},"topsName":"JULISSA","gender":"F","age":"31","dependentNumber":"001","topsLatestCancelDate":"","systemDivision":"","tobaccoUsageIndicator":"","memberId":"","survivingSpouseId":"","hicNumber":"","medicaidRecipientNumber":"","memberAltId":"","socialSecurityNumber":"595920510","legacyPolicyNumber":"0905509","claimEngineCode":"F","legacyCustomerNumber":"0905509","cesCustomerName":"LIBERTY MUTUAL","differentFamilyMemberAddressIndicator":"Y","alternateIdAssignTypeCode":"S","marketSegment":"USS","integratedCardTypeCode":"H","employeeStartDate":"0001-01-01","workHours":"00000","salaryTypeCode":"","salaryAmount":"0.00","retirementDate":"9999-12-31","deceasedDate":"9999-12-31","lateEnrollCode":"","exSpouseTypeCode":"","exSpouseSubscriberId":"","healthCoverageTransferIndicator":"","healthCoverageTransferEffectiveDates":{"start":"0001-01-01","end":"9999-12-31"},"atOccupationTypeCode":"","rrDependentProofOfEligibilityDate":"9999-12-31","cobraIndicator":"","cobIndicator":"N","cobVerifyDate":"2016-01-21","cobEffectiveDates":{"start":"0001-01-01","end":"9999-12-31"},"medicareExistsIndicator":"","medicareTypeCode":"","medicareIneligibleNotEnrolledCode":"","medicareEntitlementTypeCode":"","custodyCode":"","familyLastUpdateTimestamp":"","migrationLegacySourceId":"","migrationLegacyPolicyNumber":"","camsLegacySourceId":"","camsLegacyPolicyNumber":"","consumerProvidedTaxIdNumber":"","consumerProvidedTaxIdNumberStatusTypeCd":"","eobSuppressionIndicator":"","healthStatementSuppressionIndicator":"","administrativeLetterSuppressionIndicator":"","proofOfHealthCoverageSuppressionIndicator":"","preferenceCodeDescription":"No preference selected","memberLoyaltyYearsOfService":"","memberLoyaltyAcknowledgementDate":"","reportSegment":"USS","healthProgramCode":"","healthPlanCode":"","familyId":"0317373859","familyIdPartitionNumber":"00259","sourceCode":"CS","priorMemberId":"PMI","dateOfBirth":"1990-01-09","cdbRelationshipCode":"002","legacySourceRelationshipCode":"02","individualRelationshipCode":"CH","topsSequenceNumber":"01","topsOrigCoverageEffectiveDate":"2016-01-01","primeDependentCode":"","maritalStatus":"U","employeeStatus":"A","specialHandlerCode":"0","phiIndicator":"","qmscoIndicator":"","primaryPhoneNumber":"8136640664","alternatePhoneNumber":"8135622430","mobilePhoneNumber":"","organizationTypeCode":"","permanentAddress":{"postalAddress":{"street1":"2214 MAYDELL DRIVE","street2":"","street3":"","city":"TAMPA","state":"FL","zip":"33619","zip4":"","countryCode":"US"},"marketNumber":"0009452","countrySubCode":""},"mailingAddress":{"postalAddress":{"street1":"2214 MAYDELL DRIVE","street2":"","street3":"","city":"TAMPA","state":"FL","zip":"33619","zip4":"","countryCode":"US"},"marketNumber":"0009452","countrySubCode":""}},"cobs":[{"coverageType":"M","otherInsuranceDates":{"start":"0001-01-01","end":"9999-12-31"},"otherInsuranceVerifyDate":"2016-01-21","otherInsuranceIndicator":"N","custodyCode":"","cobPrimacies":[]}],"currentCobPrimarySecondary":{"typeCode":"N","effectiveDates":{"start":"0001-01-01","end":"9999-12-31"},"verifyDate":"2016-01-21"},"previousCobPrimarySecondary":{"typeCode":"","effectiveDates":{"start":"0001-01-01","end":"9999-12-31"},"verifyDate":""},"currentMedicarePrimarySecondary":{"typeCode":"","effectiveDates":{"start":"0001-01-01","end":"9999-12-31"}},"previousMedicarePrimarySecondary":{"typeCode":"","effectiveDates":{"start":"0001-01-01","end":"9999-12-31"}},"networkKey":"M","phiIndicator":"","blbsMemberEligibilityIndicator":"N"}}]}]}}}');
            response.setStatusCode(200);
            return response;
        }
    }
	
    global class ACET_MNRCOBResponse implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setBody('<?xml version="1.0" encoding="UTF-8"?>'+
'<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><ns1:invokeServiceResponse xmlns:ns1="http://upm3.uhc.com/cosmosmember/readmembercobhistory/v4"><return xmlns:ns2="http://upm3.uhc.com/cosmosmember/readmembercobhistory/v4"><responseHeader><serviceCallStatus>SUCCESS</serviceCallStatus><externalId xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/><serviceName>ReadMemberCobHistory</serviceName><serviceVersion>4</serviceVersion><logLevel>DEFAULT</logLevel><upmEnvironment>u3c-ts4</upmEnvironment><internalUse><uid>[[ISET&#124;&#124;3187082479]UHGCORE-STAGE-GATEWAY]</uid><serviceName>ReadMemberCobHistory</serviceName><serviceVersion>4</serviceVersion><originalConsumer>ISET</originalConsumer><originalServiceName>ReadMemberCobHistory</originalServiceName><originalServiceVersion>4</originalServiceVersion><logSequence>8</logSequence><uidGeneratedBy>DP</uidGeneratedBy></internalUse></responseHeader><memberCobHistory><policyHistory><carrierNumber>02116</carrierNumber><fileMaintenanceDate>2020-09-11</fileMaintenanceDate><label>Other</label><policyComment>SAB OPTU/COB PER EMDEON CIGNA #10505956900001 8/1/19-7/31/20</policyComment><policyComment>NO OVERLAP W/COSMOS MCARE PLAN. P=NTL/MCARE INV#26285376</policyComment><policyHospitalClaimIndicator>A</policyHospitalClaimIndicator><policyPhysicianClaimIndicator>A</policyPhysicianClaimIndicator><primaryPolicyEffectiveDate>2020-08-01</primaryPolicyEffectiveDate><primaryPolicyExpirationDate>2020-08-01</primaryPolicyExpirationDate></policyHistory><primaryGroupName/><primaryGroupNumber/><primaryIndividualName/><primaryIndividualSSN>000000000</primaryIndividualSSN><relationshipToPrimaryInsured/><relationshipToSiteInsured/></memberCobHistory></return></ns1:invokeServiceResponse></soap:Body></soap:Envelope>');
            response.setStatusCode(200);
            return response;
        }
    }
	
	 global class ACETContinuation implements HttpCalloutMock{
        global HTTPResponse respond(HTTPRequest request) {
            	HttpResponse response = new HttpResponse();
                response.setHeader('Endpoint',  SAEConstants.SAE_CLAIM_DOCUMENTS_API_VALUE);
                response.setHeader('Method', 'POST');
                response.setBody(SAETestDataFactory.getStaticResourceResponse('u_clm_corsp_claim_7863109999'));
                response.setStatusCode(200);
                return response;
        }
    }

    global class ACET_ISETCOBResponse implements HttpCalloutMock {
            global HTTPResponse respond(HTTPRequest request) {
                HttpResponse response = new HttpResponse();
                response.setBody('<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><ns1:invokeServiceResponse xmlns:ns1="http://upm3.uhc.com/member/readcarriercomments/v3"><return xmlns:ns2="http://upm3.uhc.com/member/readcarriercomments/v3"><responseHeader><serviceCallStatus>SUCCESS</serviceCallStatus><externalId xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/><serviceName>ReadCarrierComments</serviceName><serviceVersion>3</serviceVersion><logLevel>DEFAULT</logLevel><upmEnvironment>u3c-ts4</upmEnvironment><internalUse><uid>[[ISET||98004623]UPM3-ALPHA-FRONTEND]</uid><serviceName>ReadCarrierComments</serviceName><serviceVersion>3</serviceVersion><originalConsumer>ISET</originalConsumer><originalServiceName>ReadCarrierComments</originalServiceName><originalServiceVersion>3</originalServiceVersion><logSequence>6</logSequence><uidGeneratedBy>DP</uidGeneratedBy></internalUse></responseHeader><commercialCarrierComments><cobAddressee><attention/><name/><phoneNumber/><postalAddress><street1/><street2/><street3/><city/><state/><zip/><zip4/><countryCode/></postalAddress></cobAddressee><comments><comment>lkjlkjlkjl</comment><commentDate>2018-10-03</commentDate></comments><comments><comment>more comments </comment><commentDate>2018-11-03</commentDate></comments><comments><comment>Even more comments. Dev team rocks!</comment><commentDate>2019-10-03</commentDate></comments><coveredAllDependents/><coveredOther/><coveredSpouse/><effectiveDate/><employerAddressee><attention/><name/><phoneNumber/><postalAddress><street1/><street2/><street3/><city/><state/><zip/><zip4/><countryCode/></postalAddress></employerAddressee><policy/></commercialCarrierComments><additionalCommentsAllowedIndicator>Y</additionalCommentsAllowedIndicator></return></ns1:invokeServiceResponse></soap:Body></soap:Envelope>');
                response.setStatusCode(200);
                return response;
            }
        }

        global class ACET_ISETCOBResponse_Medicare implements HttpCalloutMock {
            global HTTPResponse respond(HTTPRequest request) {
                HttpResponse response = new HttpResponse();
                response.setBody('<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><ns1:invokeServiceResponse xmlns:ns1="http://upm3.uhc.com/member/readcarriercomments/v3"><return xmlns:ns2="http://upm3.uhc.com/member/readcarriercomments/v3"><responseHeader><serviceCallStatus>SUCCESS</serviceCallStatus><externalId xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/><serviceName>ReadCarrierComments</serviceName><serviceVersion>3</serviceVersion><logLevel>DEFAULT</logLevel><upmEnvironment>u3c-ts4</upmEnvironment><internalUse><uid>[[ISET||430326673]UPM3-ALPHA-FRONTEND]</uid><serviceName>ReadCarrierComments</serviceName><serviceVersion>3</serviceVersion><originalConsumer>ISET</originalConsumer><originalServiceName>ReadCarrierComments</originalServiceName><originalServiceVersion>3</originalServiceVersion><logSequence>6</logSequence><uidGeneratedBy>DP</uidGeneratedBy></internalUse></responseHeader><medicareCarrierComments><comment>stesssssssssssssssssssssssssss</comment><commentDate>2017-10-16</commentDate><comment> This is a comment to test stuff</comment><commentDate>2018-10-05</commentDate></medicareCarrierComments><additionalCommentsAllowedIndicator>Y</additionalCommentsAllowedIndicator></return></ns1:invokeServiceResponse></soap:Body></soap:Envelope>');
                response.setStatusCode(200);
                return response;
            }
        }

        global class facetsGetService200 implements HttpCalloutMock {
                global HTTPResponse respond(HTTPRequest request) {
                    HttpResponse response = new HttpResponse();
                     response.setBody(SAETestDataFactory.getStaticResourceResponse('FacetGetResponse'));
                    response.setStatusCode(200);
                    return response;
                }
            }

            global class facetsCreateService200 implements HttpCalloutMock {
                global HTTPResponse respond(HTTPRequest request) {
                    HttpResponse response = new HttpResponse();
                    response.setBody('{"data":{"type":"CustomerServiceRecordType","id":"21G000001237"}}');
                    response.setStatusCode(201);
                    return response;
                }
            }

    global class ACET_SNIWebService200 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setBody(SAETestDataFactory.getStaticResourceResponse('SNI_MockData'));
            response.setStatusCode(200);
            return response;
        }
    }
	
	global class ACET_getCOBCommentsENIResponse_Commercial implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            String res = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'
                +'<soap:Body>'
                +'<ns1:invokeServiceResponse xmlns:ns1="http://upm3.uhc.com/member/readcarriercomments/v3">'
                +'<return xmlns:ns2="http://upm3.uhc.com/member/readcarriercomments/v3">'
                +'<responseHeader>'
                +'<serviceCallStatus>SUCCESS</serviceCallStatus>'
                +'<externalId xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>'
                +'<serviceName>ReadCarrierComments</serviceName>'
                +'<serviceVersion>3</serviceVersion>'
                +'<logLevel>DEFAULT</logLevel>'
                +'<upmEnvironment>u3c-ts4</upmEnvironment>'
                +'<internalUse>'
                +'<uid>[[ISET||438462445]UPM3-ALPHA-FRONTEND]</uid>'
                +'<serviceName>ReadCarrierComments</serviceName>'
                +'<serviceVersion>3</serviceVersion>'
                +'<originalConsumer>ISET</originalConsumer>'
                +'<originalServiceName>ReadCarrierComments</originalServiceName>'
                +'<originalServiceVersion>3</originalServiceVersion>'
                +'<logSequence>6</logSequence>'
                +'<uidGeneratedBy>DP</uidGeneratedBy>'
                +'</internalUse></responseHeader>'
                +'<commercialCarrierComments>'
                +'<cobAddressee><attention/><name/><phoneNumber/>'
                +'<postalAddress><street1/><street2/><street3/>'
                +'<city/><state/><zip/><zip4/>'
                +'<countryCode/></postalAddress>'
                +'</cobAddressee>'
                +'<comments>'
                +'<comment>testing testing</comment>'
                +'<commentDate>2021-02-03</commentDate>'
                +'</comments>'
                +'<coveredAllDependents/>'
                +'<coveredOther/><coveredSpouse/>'
                +'<effectiveDate/><employerAddressee>'
                +'<attention/><name/>'
                +'<phoneNumber/><postalAddress>'
                +'<street1/><street2/><street3/>'
                +'<city/><state/><zip/><zip4/><countryCode/></postalAddress>'
                +'</employerAddressee><policy/>'
                +'</commercialCarrierComments>'
                +'<additionalCommentsAllowedIndicator>Y</additionalCommentsAllowedIndicator>'
                +'</return></ns1:invokeServiceResponse></soap:Body></soap:Envelope>';
            response.setBody(res);
            response.setStatusCode(200);
            return response;
        }
    }
    
    global class ACET_getCOBCommentsENIResponse_Medicare implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            String res = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'
                +'<soap:Body>'
                +'<ns1:invokeServiceResponse xmlns:ns1="http://upm3.uhc.com/member/readcarriercomments/v3">'
                +'<return xmlns:ns2="http://upm3.uhc.com/member/readcarriercomments/v3">'
                +'<responseHeader>'
                +'<serviceCallStatus>SUCCESS</serviceCallStatus>'
                +'<externalId xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>'
                +'<serviceName>ReadCarrierComments</serviceName>'
                +'<serviceVersion>3</serviceVersion>'
                +'<logLevel>DEFAULT</logLevel>'
                +'<upmEnvironment>u3c-ts4</upmEnvironment>'
                +'<internalUse>'
                +'<uid>[[ISET||438462445]UPM3-ALPHA-FRONTEND]</uid>'
                +'<serviceName>ReadCarrierComments</serviceName>'
                +'<serviceVersion>3</serviceVersion>'
                +'<originalConsumer>ISET</originalConsumer>'
                +'<originalServiceName>ReadCarrierComments</originalServiceName>'
                +'<originalServiceVersion>3</originalServiceVersion>'
                +'<logSequence>6</logSequence>'
                +'<uidGeneratedBy>DP</uidGeneratedBy>'
                +'</internalUse></responseHeader>'
                +'<medicareCarrierComments>'
                +'<comment>stesssssssssssssssssssssssssss</comment>'
                +'<commentDate>2017-10-16</commentDate>'
                +'</medicareCarrierComments>'
                +'<additionalCommentsAllowedIndicator>Y</additionalCommentsAllowedIndicator>'
                +'</return></ns1:invokeServiceResponse></soap:Body></soap:Envelope>';
            response.setBody(res);
            response.setStatusCode(200);
            return response;
        }
    }
	
	global class ACET_NonTherapyResponse_200 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            String xmlResponseBody='';
            xmlResponseBody='<?xml version="1.0" encoding="UTF-8"?>'
                +'<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'
                +'<soap:Body><ns1:invokeServiceResponse xmlns:ns1="http://upm3.uhc.com/unetmember/selectservicecategoryaccumulations/v1">'
                +'<return xmlns:ns2="http://upm3.uhc.com/unetmember/selectservicecategoryaccumulations/v1">'
                +'<responseHeader>'
                +'<serviceCallStatus>SUCCESS</serviceCallStatus>'
                +'<externalId xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>'
                +'<serviceName>SelectServiceCategoryAccumulations</serviceName>'
                +'<serviceVersion>1</serviceVersion>'
                +'<logLevel>DEFAULT</logLevel>'
                +'<upmEnvironment>u3c-pr4</upmEnvironment>'
                +'<internalUse>'
                +'<uid>[[ISET||2290814143]UPM3-PROD-FRONTEND]</uid>'
                +'<serviceName>SelectServiceCategoryAccumulations</serviceName>'
                +'<serviceVersion>1</serviceVersion>'
                +'<originalConsumer>ISET</originalConsumer>'
                +'<originalServiceName>SelectServiceCategoryAccumulations</originalServiceName>'
                +'<originalServiceVersion>1</originalServiceVersion>'
                +'<logSequence>1</logSequence>'
                +'<uidGeneratedBy>DP</uidGeneratedBy>'
                +'</internalUse>'
                +'</responseHeader>'
                +'<benefitServiceCategoryAccumulationreference>'
                +'<nonUnetPaidAmount>0.00</nonUnetPaidAmount>'
                +'<nonUnetPaidCount>0</nonUnetPaidCount>'
                +'<planYearEndDate>2099-12-31</planYearEndDate>'
                +'<planYearStartDate>2020-10-11</planYearStartDate>'
                +'<serviceCategory>TM</serviceCategory>'
                +'<serviceCategoryDescription/>'
                +'<totalYtdPaidAmount>6.35</totalYtdPaidAmount>'
                +'<totalYtdPaidCount>0</totalYtdPaidCount>'
                +'<unitIndicator>L</unitIndicator>'
                +'<unitIndicatorDescription>Lifetime Accumulation</unitIndicatorDescription>'
                +'</benefitServiceCategoryAccumulationreference>'
                +'</return></ns1:invokeServiceResponse></soap:Body></soap:Envelope>';
            response.setBody(xmlResponseBody);
            response.setStatusCode(200);
            return response;
        }
    }
     global class ACET_NonTherapyEmptyResponse_200 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            String xmlResponseBody='';
            response.setBody(xmlResponseBody);
            response.setStatusCode(200);
            return response;
        }
     }
    //US3182780
     global class MACESSCreateService201 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setBody('{"ticketNumber":"PIQ-82840"}');
            response.setStatusCode(201);
            return response;
        }
    }

    global class MACESSUpdateService201 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setBody('{"ticketNumber":"PIQ-597","adjustmentNum":"SF20210113754555555"}');
            response.setStatusCode(201);
            return response;
        }
     }
     // US3464932
     global class ACET_FeeScheduleServiceResponse_200 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            StaticResource body = [SELECT Body
                                  FROM StaticResource 
                                  WHERE Name = 'ACET_CallScheduleServiceMockResponse'
                                  LIMIT 1];
            String xmlResponseBody= body.body.toString();
            response.setBody(xmlResponseBody);
            response.setStatusCode(200);
            return response;
        }
     }
     global class ACET_ProviderContractService_200 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            StaticResource body = [SELECT Body
                                  FROM StaticResource 
                                  WHERE Name = 'contracts_FeeScheduleMock_Response'
                                  LIMIT 1];
            String jsonResponseBody= body.body.toString();
            response.setBody(jsonResponseBody);
            response.setStatusCode(200);
            return response;
        }
     }
}