@isTest
global class ACET_MemberSearchCtrl_Test {
    
    @testSetup static void testSetupMethod() {
        Organization_Properties__c orgProps = Organization_Properties__c.getOrgDefaults();
        orgProps.OrganizationName__c = 'QA';
        Upsert orgProps;
        
        // Token API data
        WebserviceConfigurations__c tokenAPIWSConfig = ACET_WebserviceCalloutFramework_Test.createTokenWSConfigs('LinkTokenAPI');
        OrgSpecificConfigurations__c tokenAPIOrgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createTokenOrgWSConfigs(tokenAPIWSConfig.Id);
        WebserviceConfigurations__c authTokenWSConfig = ACET_WebserviceCalloutFramework_Test.createAuthTokenWSConfig('LinkTokenAPI');

        // Service API data
        WebserviceConfigurations__c wsConfig = ACET_WebserviceCalloutFramework_Test.createWSConfig('LinkEligibilityMemberSearch', tokenAPIWSConfig.Id);
        OrgSpecificConfigurations__c orgSpecificConfigs = ACET_WebserviceCalloutFramework_Test.createOrgWSConfigs(wsConfig.Id);
        
        ISL_Webservice_Config__c webConfig = new ISL_Webservice_Config__c();
        webConfig.Name = 'SAE_ProviderSearch';
        webConfig.Value__c = 'https://api-gateway-stage.linkhealth.com/elink-services/api/eligibility';
        insert webConfig;
    }

    @isTest static void getMemberDetails_Test() {
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(200,''));
        Test.startTest();
        ACET_ExplorePageCtrl.FlowDetails fd = new ACET_ExplorePageCtrl.FlowDetails();
        fd.contactExt = '123';
        fd.contactName = 'cn';
        fd.contactNumber = '1234567890';
        fd.interactionType = 'Email';
        fd.isGenesys = false;
        fd.IVRInfo = null;
        fd.GeneysysQuestionType = '';

        ACET_ProviderSearchCtrl.ProviderDetails pd = new ACET_ProviderSearchCtrl.ProviderDetails();
        pd.isAdvancedSearch = true;
        pd.isValidProvider = true;
        pd.isProviderNotFound = false;
        pd.isNoProviderToSearch = false;
        pd.isOther = false;
        pd.isPysician = true;
        pd.practicingStatus = 'Active';
        pd.taxId = '';
        pd.npi = '1234567891';
        pd.firstName = 'pfn';
        pd.lastName = 'pln ';
        pd.filterType = 'Facility';
        pd.state = 'TX';
        pd.zip = 'NY';
        pd.state = '100001';
        pd.interactionType = 'Email';
        pd.providerUniqueId = '12345';
        pd.providerId = '12345';
        pd.phoneNumber = '1234567890';
        pd.contactType = '';

        ACET_MemberSearchCtrl.MemberDetails md = new ACET_MemberSearchCtrl.MemberDetails();
        md.dob = '01/01/1999';
        md.firstName = 'mfn';
        md.lastName = 'mln';
        md.groupNumber = '1234';
        md.isAdvancedSearch = true;
        md.isFindIndividualSearch = false;
        md.isMemberNotFound = false;
        md.isNoMemberToSearch = false;
        md.isValidMember = false;
        md.memberId = '12345';
        md.memberUniqueId = '12345';
        md.payerId = '123456';
        md.phoneNumber = '1234567890';
        md.searchOption = 'MemberIdDOB';
        md.state = 'TX';
        md.zip = '100001';
        md.sourceCode = 'CS';
        ACET_MemberSearchCtrl.getMemberDetails(fd, pd, md);

        pd.isValidProvider = false;
        pd.isProviderNotFound = true;
        md.sourceCode = 'AA';
        ACET_MemberSearchCtrl.getMemberDetails(fd, pd, md);
        Test.stopTest();
    }
    
    @isTest static void getFindIndividualMemberDetails_Test() {
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(200,''));
        Test.startTest();
        ACET_ExplorePageCtrl.FlowDetails fd = new ACET_ExplorePageCtrl.FlowDetails();
        fd.contactExt = '123';
        fd.contactName = 'cn';
        fd.contactNumber = '1234567890';
        fd.interactionType = 'Email';
        fd.isGenesys = false;
        fd.IVRInfo = null;
        fd.GeneysysQuestionType = '';

        ACET_ProviderSearchCtrl.ProviderDetails pd = new ACET_ProviderSearchCtrl.ProviderDetails();
        pd.isAdvancedSearch = true;
        pd.isValidProvider = true;
        pd.isProviderNotFound = false;
        pd.isNoProviderToSearch = false;
        pd.isOther = false;
        pd.isPysician = true;
        pd.practicingStatus = 'Active';
        pd.taxId = '';
        pd.npi = '1234567891';
        pd.firstName = 'pfn';
        pd.lastName = 'pln ';
        pd.filterType = 'Facility';
        pd.state = 'TX';
        pd.zip = 'NY';
        pd.state = '100001';
        pd.interactionType = 'Email';
        pd.providerUniqueId = '12345';
        pd.providerId = '12345';
        pd.phoneNumber = '1234567890';
        pd.contactType = '';

        ACET_MemberSearchCtrl.MemberDetails md = new ACET_MemberSearchCtrl.MemberDetails();
        md.dob = '';
        md.firstName = '';
        md.lastName = '';
        md.groupNumber = '';
        md.isAdvancedSearch = false;
        md.isFindIndividualSearch = true;
        md.isMemberNotFound = false;
        md.isNoMemberToSearch = false;
        md.isValidMember = false;
        md.memberId = '12345';
        md.memberUniqueId = '12345';
        md.payerId = '123456';
        md.phoneNumber = '1234567890';
        md.searchOption = 'MemberIdDOB';
        md.state = 'TX';
        md.zip = '100001';
        md.sourceCode = 'CS';
        ACET_MemberSearchCtrl.getMemberDetails(fd, pd, md);

        pd.isValidProvider = false;
        pd.isProviderNotFound = true;
        md.sourceCode = 'AA';
        ACET_MemberSearchCtrl.getMemberDetails(fd, pd, md);
        Test.stopTest();
    }

    @isTest static void getMemberDetails_ErrorStatus() {
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(400,'AAA:58'));
        Test.startTest();
        ACET_ExplorePageCtrl.FlowDetails fd = new ACET_ExplorePageCtrl.FlowDetails();
        fd.contactExt = '123';
        fd.contactName = 'cn';
        fd.contactNumber = '1234567890';
        fd.interactionType = 'Email';
        fd.isGenesys = false;
        fd.IVRInfo = null;
        fd.GeneysysQuestionType = '';

        ACET_ProviderSearchCtrl.ProviderDetails pd = new ACET_ProviderSearchCtrl.ProviderDetails();
        pd.isAdvancedSearch = true;
        pd.isValidProvider = true;
        pd.isProviderNotFound = false;
        pd.isNoProviderToSearch = false;
        pd.isOther = false;
        pd.isPysician = true;
        pd.practicingStatus = 'Active';
        pd.taxId = '';
        pd.npi = '1234567891';
        pd.firstName = 'pfn';
        pd.lastName = 'pln ';
        pd.filterType = 'Facility';
        pd.state = 'TX';
        pd.zip = 'NY';
        pd.state = '100001';
        pd.interactionType = 'Email';
        pd.providerUniqueId = '12345';
        pd.providerId = '12345';
        pd.phoneNumber = '1234567890';
        pd.contactType = '';

        ACET_MemberSearchCtrl.MemberDetails md = new ACET_MemberSearchCtrl.MemberDetails();
        md.dob = '01/01/1999';
        md.firstName = 'mfn';
        md.lastName = 'mln';
        md.groupNumber = '1234';
        md.isAdvancedSearch = true;
        md.isFindIndividualSearch = false;
        md.isMemberNotFound = false;
        md.isNoMemberToSearch = false;
        md.isValidMember = false;
        md.memberId = '12345';
        md.memberUniqueId = '12345';
        md.payerId = '123456';
        md.phoneNumber = '1234567890';
        md.searchOption = 'MemberIdDOB';
        md.state = 'TX';
        md.zip = '100001';
        md.sourceCode = 'CS';
        ACET_MemberSearchCtrl.getMemberDetails(fd, pd, md);

        pd.isValidProvider = false;
        pd.isProviderNotFound = true;
        md.sourceCode = 'AA';
        ACET_MemberSearchCtrl.getMemberDetails(fd, pd, md);
        ACET_MemberSearchCtrl.getStateValues();
        
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(400,'AAA:73'));
        ACET_MemberSearchCtrl.getMemberDetails(fd, pd, md);
        
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(400,'AAA:79'));
        ACET_MemberSearchCtrl.getMemberDetails(fd, pd, md);
        
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(400,'ED270UG'));
        ACET_MemberSearchCtrl.getMemberDetails(fd, pd, md);
        
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(400,'AAA:Fault Code'));
        ACET_MemberSearchCtrl.getMemberDetails(fd, pd, md);
        
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(400,'ED270IP'));
        ACET_MemberSearchCtrl.getMemberDetails(fd, pd, md);
        
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(400,'ED270BP'));
        ACET_MemberSearchCtrl.getMemberDetails(fd, pd, md);
        
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(400,'ED2SS70BP'));
        ACET_MemberSearchCtrl.getMemberDetails(fd, pd, md);
        
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(400,'ED270BR'));
        ACET_MemberSearchCtrl.getMemberDetails(fd, pd, md);
        
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(404,''));
        ACET_MemberSearchCtrl.getMemberDetails(fd, pd, md);
        
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(404,'AEFNND'));
        ACET_MemberSearchCtrl.getMemberDetails(fd, pd, md);
        
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(406,'ED270IA'));
        ACET_MemberSearchCtrl.getMemberDetails(fd, pd, md);
        
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(424,'ED270UR'));
        ACET_MemberSearchCtrl.getMemberDetails(fd, pd, md);
        
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(424,'AAA:42'));
        ACET_MemberSearchCtrl.getMemberDetails(fd, pd, md);
        
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(500,''));
        ACET_MemberSearchCtrl.getMemberDetails(fd, pd, md);
        
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(500,'ED270SE'));
        ACET_MemberSearchCtrl.getMemberDetails(fd, pd, md);
        
        Test.setMock(HttpCalloutMock.class, new WebservicecalloutFrameworkMock(999,''));
        ACET_MemberSearchCtrl.getMemberDetails(fd, pd, md);
        
        md.firstName = '';
        ACET_MemberSearchCtrl.getMemberDetails(fd, pd, md);
        
        md.firstName = 'mnb';
        md.lastName = '';
        ACET_MemberSearchCtrl.getMemberDetails(fd, pd, md);
        Test.stopTest();
    }

    global class WebservicecalloutFrameworkMock implements HttpCalloutMock {
        public Integer statusCode;
        public String faultCode;
        
        public WebservicecalloutFrameworkMock(Integer statusCode, String faultCode) {
            this.statusCode = statusCode;
            this.faultCode = faultCode;
        }
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            String jsonString = '';
            if (statusCode == 200) {
                jsonString = '{"memberPolicies":[{"patientInfo":[{"addressLine1":"453 VALON DR","addressLine2":"","city":"ATLANTA","dateOfBirth":"1960-05-02","firstName":"CLARK","gender":"M","lastName":"KENT","middleName":"E","relationship":"subscriber","searched":"true","state":"GA","zip":"30301","patientKey":"AvAOOPgZqwsIxfCVLqpmYe123JLec24giQRv4otVJm9bSWhu4cGa0WUxkbaG86%2FJOHuig38x3YZLs4pTS53gAjLg17r7UO3Y3PcVWrozkZvuQI1Hn533I3We8FrgJH98%2Fowh%2BTjVEcmIi%2BDm%2Fw4m%2BETdzvtjnsRDy%2FJqvXFfjjYuJ06V0BEB%2B%2Bz5oGqEjLm69lns%2BjEcG%2FDQ0ZqAmiYJMpdp5b2WXn%2BUQVMG9wsTLmXYcI%2B20E3Bz3pvDjXBGpax0rThR3vB%2BNvWcqAFM92YJkRpXslTK1p9aeK5%2BtjQL1H984MqAwg4w0QYz16twasO7jT38CkSkVlHS5GYwMG5VOmwgkMRwjid%2F%2FPjhs%2Fg22YA%2FjmreF2aZCW34EqmBJPFyiTc5ykcsCzrfVln%2BTn1auusMD2mAbxn5h%2FskfLE9j5ZLdEr1ae23viYGGdoq1r38AR9Q1c5jH6LWrvfEloejbKyQRcUvi%2FAEZxAXUr139lMWGH91Ou1w4Ofnxu%2B0wbUd5ccLYTDrg4wAR%2FPc9lpELbvrfBeh9go8OOARJT9wooh6Nv856m99XA%2FuiRxdEKV1%2BVPx7CgWyZDhGs9koJJIuudW7x2pUWbUCitw3EEuHnRqG9gh4vcZSs%2BmmmX916EAq75qZZblLlmw6pWHLiqI9owD1ykjDIVUFKyvQ6IK7Iz72PgtCe%2FdZQlbidGJqlD%2FBvce2kPl22%2BB%2FGAcb0IOhzAk3R8UOp8HI0DazjeRCVNadNu4MCGEmYwphtEgxPUrJMRQNqWj40F3dVmlnywq73G6Yqe%2FmmjQMMz%2B9tHyDsiTa%2BHktLryd%2B9t6d4kKvarbxl64EMX6N2xzULJGFrAkg","subscriberBoolean":true}],"additionalCoverageInfo":[{"additionalCoverage":"None","payerName":"","memberId":"","phone":"","url":"","insuranceType":"","payerStatus":"","coverageType":""}],"deductibleInfo":{"found":true,"nonMainPlan":true,"inAndOutOfNetworkOnly":false,"message":"","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"1000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"1000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"1000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"1000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"1000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"1000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""}}},"outOfPocketInfo":{"found":true,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"2000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"5000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"2000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"4000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"10000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"4000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""}}},"copayMaxInfo":{"found":false,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"Members plan does not have a copay maximum","individual":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"outOfPocketMaxInfo":{"found":false,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"Members plan does not have an out of pocket 2 maximum","individual":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"referralInfo":{"referralIndicator":"N","rLinkEBN":false,"cosmosDelegatedEntity":null},"insuranceInfo":{"addressLine1":"P.O. BOX 740800","addressLine2":"","city":"ATLANTA","countryCode":"","countrySubDivisionCode":"","found":"true","groupNumber":"0520001","insuranceType":"Commercial","insuranceTypeCode":"C1","lineOfBusiness":"1","paidThroughDate":null,"memberId":"919395000","payerName":"UNITEDHEALTHCARE","payerStatus":"Unable to determine","planDescription":"CHOICE PLUS","state":"GA","zip":"30374-0800","hraBalance":"","hraMessage":"","hraUnavailableMessage":"","phoneNumber":"","oxfordPlatform":"","payerId":"12345","administeredByUhc":false},"policyInfo":{"eligibilityDates":{"startDate":null,"endDate":null},"memberId":"919395000","planDates":{"startDate":"2019-01-01","endDate":"2021-03-18"},"policyStatus":"Active Policy","searchedDates":{"searchStartDate":"2020-04-16","searchEndDate":""},"graceMessageByState":"By law, exchange members who receive a subsidy have a three-month grace period to pay their premiums. We will process claims during the first month. During the second and third month of the grace period, we will pend claims if the premium hasnt been paid. If we receive the premium payment within the grace period, we will process this claim.","gracePaidThrough":null,"gracePeriodMonth":null,"coverageType":"Medical","nonMedicalPolicyBoolean":false,"id":"2","plnBenefit":false},"primaryCarePhysicianInfo":{"pcpFound":"false","lastName":null,"firstName":null,"middleName":null,"addressLine1":null,"addressLine2":null,"city":null,"state":null,"zip":null,"phoneNumber":null,"networkStatusCode":null,"affiliateHospitalName":null,"providerGroupName":null},"transactionId":"policy1zambqH4ZjEgM9zALrimzOnJDKHM2KBoLGgRzif1SH_S5u8-oRkG6W3dLaKtkbik4kSAaOoLS7faJ1W4BQ55q_92RYaHWjlr79KuGpzt4IndAzP_j2QMkR2Psg7Q8fxpzuZ2N8Cu74vojIGqyK5GdEmza_-WL3FBxRtFE244512"},{"patientInfo":[{"addressLine1":"453 VALON DR","addressLine2":"","city":"ATLANTA","dateOfBirth":"1960-05-02","firstName":"CLARK","gender":"M","lastName":"KENT","middleName":"E","relationship":"subscriber","searched":"true","state":"GA","zip":"30301","patientKey":"AvAOOPgZqwsIxfCVLqpmYe123JL3ec24giQRv4otVJm9bSWhu4cGa0WUxkbaG86%2FJOHuig38x3YZLs4pTS53gAjLg17r7UO3Y3PcVWrozkZvuQI1Hn533I3We8FrgJH98%2Fowh%2BTjVEcmIi%2BDm%2Fw4m%2BETdzvtjnsRDy%2FJqvXFfjjYuJ06V0BEB%2B%2Bz5oGqEjLm69lns%2BjEcG%2FDQ0ZqAmiYJMpdp5b2WXn%2BUQVMG9wsTLmXYcI%2B20E3Bz3pvDjXBGpax0rThR3vB%2BNvWcqAFM92YJkRpXslTK1p9aeK5%2BtjQL1H984MqAwg4w0QYz16twasO7jT38CkSkVlHS5GYwMG5VOmwgkMRwjid%2F%2FPjhs%2Fg22YA%2FjmreF2aZCW34EqmBJPFyiTc5ykcsCzrfVln%2BTn1auusMD2mAbxn5h%2FskfLE9j5ZLdEr1ae23viYGGdoq1r38AR9Q1c5jH6LWrvfEloejbKyQRcUvi%2FAEZxAXUr139lMWGH91Ou1w4Ofnxu%2B0wbUd5ccLYTDrg4wAR%2FPc9lpELbvrfBeh9go8OOARJT9wooh6Nv856m99XA%2FuiRxdEKV1%2BVPx7CgWyZDhGs9koJJIuudW7x2pUWbUCitw3EEuHnRqG9gh4vcZSs%2BmmmX916EAq75qZZblLlmw6pWHLiqI9owD1ykjDIVUFKyvQ6IK7Iz72PgtCe%2FdZQlbidGJqlD%2FBvce2kPl22%2BB%2FGAcb0IOhzAk3R8UOp8HI0DazjeRCVNadNu4MCGEmYwphtEgxPUrJMRQNqWj40F3dVmlnywq73G6Yqe%2FmmjQMMz%2B9tHyDsiTa%2BHktLryd%2B9t6d4kKvarbxl64EMX6N2xzULJGFrAkg","subscriberBoolean":true}],"additionalCoverageInfo":[{"additionalCoverage":"None","payerName":"","memberId":"","phone":"","url":"","insuranceType":"","payerStatus":"","coverageType":""}],"deductibleInfo":{"found":true,"nonMainPlan":true,"inAndOutOfNetworkOnly":false,"message":"","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"1000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"1000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"1000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"1000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"1000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"1000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""}}},"outOfPocketInfo":{"found":true,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"2000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"5000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"2000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"4000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"10000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"4000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""}}},"copayMaxInfo":{"found":false,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"Members plan does not have a copay maximum","individual":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"outOfPocketMaxInfo":{"found":false,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"Members plan does not have an out of pocket 2 maximum","individual":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"referralInfo":{"referralIndicator":"N","rLinkEBN":false,"cosmosDelegatedEntity":null},"insuranceInfo":{"addressLine1":"P.O. BOX 740800","addressLine2":"","city":"ATLANTA","countryCode":"","countrySubDivisionCode":"","found":"true","groupNumber":"520002","insuranceType":"Commercial","insuranceTypeCode":"C1","lineOfBusiness":"1","paidThroughDate":null,"memberId":"919395000","payerName":"UNITEDHEALTHCARE","payerStatus":"Unable to determine","planDescription":"CHOICE PLUS","state":"GA","zip":"30374-0800","hraBalance":"","hraMessage":"","hraUnavailableMessage":"","phoneNumber":"","oxfordPlatform":"","payerId":null,"administeredByUhc":false},"policyInfo":{"eligibilityDates":{"startDate":null,"endDate":null},"memberId":"919395000","planDates":{"startDate":"2018-05-01","endDate":"2020-12-31"},"policyStatus":"Active Policy","searchedDates":{"searchStartDate":"2020-04-16","searchEndDate":""},"graceMessageByState":"By law, exchange members who receive a subsidy have a three-month grace period to pay their premiums. We will process claims during the first month. During the second and third month of the grace period, we will pend claims if the premium hasnt been paid. If we receive the premium payment within the grace period, we will process this claim.","gracePaidThrough":null,"gracePeriodMonth":null,"coverageType":"Medical","nonMedicalPolicyBoolean":false,"id":"1","plnBenefit":false},"primaryCarePhysicianInfo":{"pcpFound":"false","lastName":null,"firstName":null,"middleName":null,"addressLine1":null,"addressLine2":null,"city":null,"state":null,"zip":null,"phoneNumber":null,"networkStatusCode":null,"affiliateHospitalName":null,"providerGroupName":null},"transactionId":"policy2zambqH4ZjEgM9zALrimzOnJDKHM2KBoLGgRwuki_U4BvORnml5a5xaeE9MhP0rw1CP5NoKpyX8Ahv1tWSPVqhF6FtMsuBP0IsmMyd0iV1fmim9iQE6ToQXxw73kCx76tjqeOfUAXfwDUETdaOqBrVnYwb6Drk-f9tmX8774861"},{"patientInfo":[{"addressLine1":"453 VALON DR","addressLine2":"","city":"ATLANTA","dateOfBirth":"1960-05-02","firstName":"CLARK","gender":"M","lastName":"KENT","middleName":"E","relationship":"subscriber","searched":"true","state":"GA","zip":"30301","patientKey":"AvAOOPgZqwsIxfCVLqpmYe123JL3ec24giQRv4otVJm9bSWhu4cGa0WUxkbaG86%2FJOHuig38x3YZLs4pTS53gAjLg17r7UO3Y3PcVWrozkZvuQI1Hn533I3We8FrgJH98%2Fowh%2BTjVEcmIi%2BDm%2Fw4m%2BETdzvtjnsRDy%2FJqvXFfjjYuJ06V0BEB%2B%2Bz5oGqEjLm69lns%2BjEcG%2FDQ0ZqAmiYJMpdp5b2WXn%2BUQVMG9wsTLmXYcI%2B20E3Bz3pvDjXBGpax0rThR3vB%2BNvWcqAFM92YJkRpXslTK1p9aeK5%2BtjQL1H984MqAwg4w0QYz16twasO7jT38CkSkVlHS5GYwMG5VOmwgkMRwjid%2F%2FPjhs%2Fg22YA%2FjmreF2aZCW34EqmBJPFyiTc5ykcsCzrfVln%2BTn1auusMD2mAbxn5h%2FskfLE9j5ZLdEr1ae23viYGGdoq1r38AR9Q1c5jH6LWrvfEloejbKyQRcUvi%2FAEZxAXUr139lMWGH91Ou1w4Ofnxu%2B0wbUd5ccLYTDrg4wAR%2FPc9lpELbvrfBeh9go8OOARJT9wooh6Nv856m99XA%2FuiRxdEKV1%2BVPx7CgWyZDhGs9koJJIuudW7x2pUWbUCitw3EEuHnRqG9gh4vcZSs%2BmmmX916EAq75qZZblLlmw6pWHLiqI9owD1ykjDIVUFKyvQ6IK7Iz72PgtCe%2FdZQlbidGJqlD%2FBvce2kPl22%2BB%2FGAcb0IOhzAk3R8UOp8HI0DazjeRCVNadNu4MCGEmYwphtEgxPUrJMRQNqWj40F3dVmlnywq73G6Yqe%2FmmjQMMz%2B9tHyDsiTa%2BHktLryd%2B9t6d4kKvarbxl64EMX6N2xzULJGFrAkg","subscriberBoolean":true}],"additionalCoverageInfo":[{"additionalCoverage":"None","payerName":"","memberId":"","phone":"","url":"","insuranceType":"","payerStatus":"","coverageType":""}],"deductibleInfo":{"found":false,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"Members plan does not have a deductible","individual":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"outOfPocketInfo":{"found":false,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"Members plan does not have an Out-of-Pocket Maximum","individual":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"copayMaxInfo":{"found":false,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"Members plan does not have a copay maximum","individual":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"outOfPocketMaxInfo":{"found":false,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"Members plan does not have an out of pocket 2 maximum","individual":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"referralInfo":{"referralIndicator":"N","rLinkEBN":false,"cosmosDelegatedEntity":null},"insuranceInfo":{"addressLine1":"PO BOX 30978","addressLine2":"","city":"SALT LAKE CITY","countryCode":"","countrySubDivisionCode":"","found":"true","groupNumber":"520003","insuranceType":"Commercial","insuranceTypeCode":"C1","lineOfBusiness":"1","paidThroughDate":null,"memberId":"919395000","payerName":"UNITEDHEALTHCARE","payerStatus":"Unable to determine","planDescription":"CHOICE PLUS","state":"UT","zip":"84130-0978","hraBalance":"","hraMessage":"","hraUnavailableMessage":"","phoneNumber":"","oxfordPlatform":"","payerId":null,"administeredByUhc":false},"policyInfo":{"eligibilityDates":{"startDate":null,"endDate":null},"memberId":"919395000","planDates":{"startDate":"2018-05-01","endDate":"2020-12-31"},"policyStatus":"Active Policy","searchedDates":{"searchStartDate":"2020-04-16","searchEndDate":""},"graceMessageByState":"By law, exchange members who receive a subsidy have a three-month grace period to pay their premiums. We will process claims during the first month. During the second and third month of the grace period, we will pend claims if the premium hasnt been paid. If we receive the premium payment within the grace period, we will process this claim.","gracePaidThrough":null,"gracePeriodMonth":null,"coverageType":"Medical","nonMedicalPolicyBoolean":false,"id":"3","plnBenefit":false},"primaryCarePhysicianInfo":{"pcpFound":"false","lastName":null,"firstName":null,"middleName":null,"addressLine1":null,"addressLine2":null,"city":null,"state":null,"zip":null,"phoneNumber":null,"networkStatusCode":null,"affiliateHospitalName":null,"providerGroupName":null},"transactionId":"policy3zambqH4ZjEgM9zIHh5sEf_nil-uqUd58uDWlg9ciJ9dp7c4eHBnrlbabuDlaVXX_Q0jDcIfCazlA58pT30BFRRhvfLzhZI9O9bWP1hWe3eyTJwzf-RX2wI0mznGSdS-IvadehBN-gSENwUA608003"},{"patientInfo":[{"addressLine1":"453 VALON DR","addressLine2":"","city":"ATLANTA","dateOfBirth":"1960-05-02","firstName":"CLARK","gender":"M","lastName":"KENT","middleName":"E","relationship":"subscriber","searched":"true","state":"GA","zip":"30301","patientKey":"AvAOOPgZqwsIxfCVLqpmYe123JL3ec24giQRv4otVJm9bSWhu4cGa0WUxkbaG86%2FJOHuig38x3YZLs4pTS53gAjLg17r7UO3Y3PcVWrozkZvuQI1Hn533I3We8FrgJH98%2Fowh%2BTjVEcmIi%2BDm%2Fw4m%2BETdzvtjnsRDy%2FJqvXFfjjYuJ06V0BEB%2B%2Bz5oGqEjLm69lns%2BjEcG%2FDQ0ZqAmiYJMpdp5b2WXn%2BUQVMG9wsTLmXYcI%2B20E3Bz3pvDjXBGpax0rThR3vB%2BNvWcqAFM92YJkRpXslTK1p9aeK5%2BtjQL1H984MqAwg4w0QYz16twasO7jT38CkSkVlHS5GYwMG5VOmwgkMRwjid%2F%2FPjhs%2Fg22YA%2FjmreF2aZCW34EqmBJPFyiTc5ykcsCzrfVln%2BTn1auusMD2mAbxn5h%2FskfLE9j5ZLdEr1ae23viYGGdoq1r38AR9Q1c5jH6LWrvfEloejbKyQRcUvi%2FAEZxAXUr139lMWGH91Ou1w4Ofnxu%2B0wbUd5ccLYTDrg4wAR%2FPc9lpELbvrfBeh9go8OOARJT9wooh6Nv856m99XA%2FuiRxdEKV1%2BVPx7CgWyZDhGs9koJJIuudW7x2pUWbUCitw3EEuHnRqG9gh4vcZSs%2BmmmX916EAq75qZZblLlmw6pWHLiqI9owD1ykjDIVUFKyvQ6IK7Iz72PgtCe%2FdZQlbidGJqlD%2FBvce2kPl22%2BB%2FGAcb0IOhzAk3R8UOp8HI0DazjeRCVNadNu4MCGEmYwphtEgxPUrJMRQNqWj40F3dVmlnywq73G6Yqe%2FmmjQMMz%2B9tHyDsiTa%2BHktLryd%2B9t6d4kKvarbxl64EMX6N2xzULJGFrAkg","subscriberBoolean":true}],"additionalCoverageInfo":[{"additionalCoverage":"None","payerName":"","memberId":"","phone":"","url":"","insuranceType":"","payerStatus":"","coverageType":""}],"deductibleInfo":{"found":true,"nonMainPlan":true,"inAndOutOfNetworkOnly":false,"message":"","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"1000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"1000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"1000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"1000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"1000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"1000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""}}},"outOfPocketInfo":{"found":true,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"2000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"5000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"2000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"4000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"10000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"4000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""}}},"copayMaxInfo":{"found":false,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"Members plan does not have a copay maximum","individual":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"outOfPocketMaxInfo":{"found":false,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"Members plan does not have an out of pocket 2 maximum","individual":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"referralInfo":{"referralIndicator":"N","rLinkEBN":false,"cosmosDelegatedEntity":null},"insuranceInfo":{"addressLine1":"P.O. BOX 740800","addressLine2":"","city":"ATLANTA","countryCode":"","countrySubDivisionCode":"","found":"true","groupNumber":"520004","insuranceType":"Commercial","insuranceTypeCode":"C1","lineOfBusiness":"1","paidThroughDate":null,"memberId":"919395000","payerName":"UNITEDHEALTHCARE","payerStatus":"Unable to determine","planDescription":"CHOICE PLUS","state":"GA","zip":"30374-0800","hraBalance":"","hraMessage":"","hraUnavailableMessage":"","phoneNumber":"","oxfordPlatform":"","payerId":null,"administeredByUhc":false},"policyInfo":{"eligibilityDates":{"startDate":null,"endDate":null},"memberId":"919395000","planDates":{"startDate":"2019-05-01","endDate":"2020-12-31"},"policyStatus":"Active Policy","searchedDates":{"searchStartDate":"2020-04-16","searchEndDate":""},"graceMessageByState":"By law, exchange members who receive a subsidy have a three-month grace period to pay their premiums. We will process claims during the first month. During the second and third month of the grace period, we will pend claims if the premium hasnt been paid. If we receive the premium payment within the grace period, we will process this claim.","gracePaidThrough":null,"gracePeriodMonth":null,"coverageType":"Medical","nonMedicalPolicyBoolean":false,"id":"1","plnBenefit":false},"primaryCarePhysicianInfo":{"pcpFound":"false","lastName":null,"firstName":null,"middleName":null,"addressLine1":null,"addressLine2":null,"city":null,"state":null,"zip":null,"phoneNumber":null,"networkStatusCode":null,"affiliateHospitalName":null,"providerGroupName":null},"transactionId":"policy4zambqH4ZjEgM9zALrimzOnJDKHM2KBoLGgRwuki_U4BvORnml5a5xaeE9MhP0rw1CP5NoKpyX8Ahv1tWSPVqhF6FtMsuBP0IsmMyd0iV1fmim9iQE6ToQXxw73kCx76tjqeOfUAXfwDUETdaOqBrVnYwb6Drk-f9tmX8774861"},{"patientInfo":[{"addressLine1":"453 VALON DR","addressLine2":"","city":"ATLANTA","dateOfBirth":"1960-05-02","firstName":"CLARK","gender":"M","lastName":"KENT","middleName":"E","relationship":"subscriber","searched":"true","state":"GA","zip":"30301","patientKey":"AvAOOPgZqwsIxfCVLqpmYe123JL3ec24giQRv4otVJm9bSWhu4cGa0WUxkbaG86%2FJOHuig38x3YZLs4pTS53gAjLg17r7UO3Y3PcVWrozkZvuQI1Hn533I3We8FrgJH98%2Fowh%2BTjVEcmIi%2BDm%2Fw4m%2BETdzvtjnsRDy%2FJqvXFfjjYuJ06V0BEB%2B%2Bz5oGqEjLm69lns%2BjEcG%2FDQ0ZqAmiYJMpdp5b2WXn%2BUQVMG9wsTLmXYcI%2B20E3Bz3pvDjXBGpax0rThR3vB%2BNvWcqAFM92YJkRpXslTK1p9aeK5%2BtjQL1H984MqAwg4w0QYz16twasO7jT38CkSkVlHS5GYwMG5VOmwgkMRwjid%2F%2FPjhs%2Fg22YA%2FjmreF2aZCW34EqmBJPFyiTc5ykcsCzrfVln%2BTn1auusMD2mAbxn5h%2FskfLE9j5ZLdEr1ae23viYGGdoq1r38AR9Q1c5jH6LWrvfEloejbKyQRcUvi%2FAEZxAXUr139lMWGH91Ou1w4Ofnxu%2B0wbUd5ccLYTDrg4wAR%2FPc9lpELbvrfBeh9go8OOARJT9wooh6Nv856m99XA%2FuiRxdEKV1%2BVPx7CgWyZDhGs9koJJIuudW7x2pUWbUCitw3EEuHnRqG9gh4vcZSs%2BmmmX916EAq75qZZblLlmw6pWHLiqI9owD1ykjDIVUFKyvQ6IK7Iz72PgtCe%2FdZQlbidGJqlD%2FBvce2kPl22%2BB%2FGAcb0IOhzAk3R8UOp8HI0DazjeRCVNadNu4MCGEmYwphtEgxPUrJMRQNqWj40F3dVmlnywq73G6Yqe%2FmmjQMMz%2B9tHyDsiTa%2BHktLryd%2B9t6d4kKvarbxl64EMX6N2xzULJGFrAkg","subscriberBoolean":true}],"additionalCoverageInfo":[{"additionalCoverage":"None","payerName":"","memberId":"","phone":"","url":"","insuranceType":"","payerStatus":"","coverageType":""}],"deductibleInfo":{"found":true,"nonMainPlan":true,"inAndOutOfNetworkOnly":false,"message":"","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"1000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"1000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"1000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"1000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"1000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"1000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""}}},"outOfPocketInfo":{"found":true,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"","individual":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"2000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"5000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"2000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""}},"family":{"found":true,"inNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"4000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":true,"customerNetworkTier1":false,"planAmount":"10000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":true,"customerNetworkTier1":false,"planAmount":"4000.0","planAmountFrequency":" (Calendar Year)","remainingAmount":"","metYtdAmount":""}}},"copayMaxInfo":{"found":false,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"Members plan does not have a copay maximum","individual":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"outOfPocketMaxInfo":{"found":false,"nonMainPlan":false,"inAndOutOfNetworkOnly":false,"message":"Members plan does not have an out of pocket 2 maximum","individual":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}},"family":{"found":false,"inNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"outOfNetwork":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""},"inNetworkTier1":{"found":false,"customerNetworkTier1":false,"planAmount":"","planAmountFrequency":"","remainingAmount":"","metYtdAmount":""}}},"referralInfo":{"referralIndicator":"N","rLinkEBN":false,"cosmosDelegatedEntity":null},"insuranceInfo":{"addressLine1":"P.O. BOX 740800","addressLine2":"","city":"ATLANTA","countryCode":"","countrySubDivisionCode":"","found":"true","groupNumber":"520005","insuranceType":"Commercial","insuranceTypeCode":"C1","lineOfBusiness":"1","paidThroughDate":null,"memberId":"919395000","payerName":"UNITEDHEALTHCARE","payerStatus":"Unable to determine","planDescription":"CHOICE PLUS","state":"GA","zip":"30374-0800","hraBalance":"","hraMessage":"","hraUnavailableMessage":"","phoneNumber":"","oxfordPlatform":"","payerId":null,"administeredByUhc":false},"policyInfo":{"eligibilityDates":{"startDate":null,"endDate":null},"memberId":"919395000","planDates":{"startDate":"2019-05-01","endDate":"2020-12-31"},"policyStatus":"Active Policy","searchedDates":{"searchStartDate":"2020-04-16","searchEndDate":""},"graceMessageByState":"By law, exchange members who receive a subsidy have a three-month grace period to pay their premiums. We will process claims during the first month. During the second and third month of the grace period, we will pend claims if the premium hasnt been paid. If we receive the premium payment within the grace period, we will process this claim.","gracePaidThrough":null,"gracePeriodMonth":null,"coverageType":"Medical","nonMedicalPolicyBoolean":false,"id":"1","plnBenefit":false},"primaryCarePhysicianInfo":{"pcpFound":"false","lastName":null,"firstName":null,"middleName":null,"addressLine1":null,"addressLine2":null,"city":null,"state":null,"zip":null,"phoneNumber":null,"networkStatusCode":null,"affiliateHospitalName":null,"providerGroupName":null},"transactionId":"policy5zambqH4ZjEgM9zALrimzOnJDKHM2KBoLGgRwuki_U4BvORnml5a5xaeE9MhP0rw1CP5NoKpyX8Ahv1tWSPVqhF6FtMsuBP0IsmMyd0iV1fmim9iQE6ToQXxw73kCx76tjqeOfUAXfwDUETdaOqBrVnYwb6Drk-f9tmX8774861"}],"requestingProvider":{"providerFirstName":null,"providerMiddleName":null,"providerLastName":"ACET","providerNameID":"9999999","taxIdNumber":"9999999","corporateTaxOwnerID":null,"corporateTaxOwnerName":null,"organizationName":null,"organizationID":null,"facilityName":null,"npi":null},"requestingProviderAddresses":[],"searchQuery":{"memberId":"919395000","lastName":"0","firstName":"0","dateOfBirth":"19600502","payerID":"87726","payerName":"0","serviceStart":"0","serviceEnd":"0","middleName":"0","gender":"0","ssn":"0","city":"0","state":"0","zip":"0","groupNumber":"0","serviceTypeCode":"0","providerLastName":"ACET","providerFirstName":"0","providerNameID":"9999999","corporateTaxOwnerID":"0","corporateTaxOwnerName":"0","organizationName":"0","organizationID":"0","taxIdNumber":"9999999","searchOption":"MemberIDDateOfBirth","payerLabel":"0","npi":"0"}}';
            } else {
                jsonString = '{"faultCode":"'+faultCode+'","message":"Based upon the search type performed we are unable to find a unique match. Please verify the data entered or perform another search type which includes the member ID."}';
            }
            response.setBody(jsonString);
            response.setStatusCode(statusCode);
            response.setStatus('status');
            return response; 
        }
    }

}