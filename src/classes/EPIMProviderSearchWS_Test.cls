@isTest
public class EPIMProviderSearchWS_Test {
    @testSetup
    public static void dataSetup (){
        WebserviceConfigurations__c wsc = new WebserviceConfigurations__c();
        wsc.name = 'EPIM Authorisation Token';
        wsc.EndpointPath__c = 'https://epim-prod-api.auth.us-east-1.amazoncognito.com/oauth2/token';
        wsc.Headers__c = 'Content-Type=application/x-www-form-urlencoded';
        wsc.Method__c = 'POST';
        wsc.JSONBodyWithMergeFields__c = 'grant_type=client_credentials&client_id=7gpol6ochdpsm7iu6m4sr07spk&client_secret=1ihkeb7t7cnapi3q7lgtu2c0ri9n0i6lhpn4huvks57kc0dnimcv&scope=epim.api.identifier/search';
        insert wsc;
        
        WebserviceConfigurations__c wsc1 = new WebserviceConfigurations__c();
        wsc1.name = 'EPIM Search Organisation';
        wsc1.EndpointPath__c = 'https://api.optum-epim-prod.net/api/epim/v1/searchOrganization/search?pageNumber=';
        wsc1.Headers__c = 'Content-Type=application/x-www-form-urlencoded';
        wsc1.Method__c = 'POST';
        wsc1.JSONBodyWithMergeFields__c = 'grant_type=client_credentials&client_id=7gpol6ochdpsm7iu6m4sr07spk&client_secret=1ihkeb7t7cnapi3q7lgtu2c0ri9n0i6lhpn4huvks57kc0dnimcv&scope=epim.api.identifier/search';
        insert wsc1;
        
        WebserviceConfigurations__c wsc2 = new WebserviceConfigurations__c();
        wsc2.name = 'EPIM Search Practitioner';
        wsc2.EndpointPath__c = 'https://api.optum-epim-prod.net/api/epim/v1/searchpractitioner/v2/search?pageNumber=';
        wsc2.Headers__c = 'Content-Type=application/x-www-form-urlencoded';
        wsc2.Method__c = 'POST';
        wsc2.JSONBodyWithMergeFields__c = 'grant_type=client_credentials&client_id=7gpol6ochdpsm7iu6m4sr07spk&client_secret=1ihkeb7t7cnapi3q7lgtu2c0ri9n0i6lhpn4huvks57kc0dnimcv&scope=epim.api.identifier/search';
        insert wsc2;
    }
    static testMethod void EPIMProviderSearchWSMethod(){
        WebserviceConfigurations__c wsc = new WebserviceConfigurations__c();
        wsc.name = 'EPIM Authorisation Token';
        wsc.EndpointPath__c = 'https://epim-prod-api.auth.us-east-1.amazoncognito.com/oauth2/token';
        wsc.Headers__c = 'Content-Type=application/x-www-form-urlencoded';
        wsc.Method__c = 'POST';
        wsc.active__c = true;
        wsc.JSONBodyWithMergeFields__c = 'grant_type=client_credentials&client_id=7gpol6ochdpsm7iu6m4sr07spk&client_secret=1ihkeb7t7cnapi3q7lgtu2c0ri9n0i6lhpn4huvks57kc0dnimcv&scope=epim.api.identifier/search';
        insert wsc;
        
        WebserviceConfigurations__c wsc1 = new WebserviceConfigurations__c();
        wsc1.name = 'EPIM Search Organisation';
        wsc1.EndpointPath__c = 'https://api.optum-epim-prod.net/api/epim/v1/searchOrganization/search?pageNumber=';
        wsc1.Headers__c = 'Content-Type=application/x-www-form-urlencoded';
        wsc1.Method__c = 'POST';
        wsc1.active__c = true;
        wsc1.JSONBodyWithMergeFields__c = 'grant_type=client_credentials&client_id=7gpol6ochdpsm7iu6m4sr07spk&client_secret=1ihkeb7t7cnapi3q7lgtu2c0ri9n0i6lhpn4huvks57kc0dnimcv&scope=epim.api.identifier/search';
        insert wsc1;
        
        
        Map<String, WebserviceConfigurations__c> WebConfigMap = new Map<String, WebserviceConfigurations__c>();
        WebConfigMap.put('EPIM Authorisation Token',wsc);
        WebConfigMap.put('EPIM Search Organisation',wsc1);
        Map<String, String> params = new Map<String, String>();
        List<Map<String,Object>> searchParams = new List<Map<String,Object>>();
        Map<String,Object> paramsmap = new Map<String,Object>();
        Object obj = (Object)'Apollo';
        paramsmap.put('Name',obj);
        searchParams.add(paramsmap);
        params.put('Name','test');
        test.startTest();
            HTTPResponse resp = new HTTPResponse();
            Test.setMock(HttpCalloutMock.class, new EPIMProviderSearchWSMockClass());
            ACETWSCalloutResult act = ProviderSearchController.searchProvider(searchParams,'1',false);
            //resp = EPIMProviderSearchWS.makeProviderSearchCallout('EPIM Search Organisation', WebConfigMap, '1', params, 'sampletoken',false);
            
         //EPIMProviderSearchWS.ParseOrgSearchResponse(params,resp);
        test.stopTest();
    }
    static testMethod void EPIMProviderSearchWSMethod1(){
        WebserviceConfigurations__c wsc = new WebserviceConfigurations__c();
        wsc.name = 'EPIM Authorisation Token';
        wsc.EndpointPath__c = 'https://epim-prod-api.auth.us-east-1.amazoncognito.com/oauth2/token';
        wsc.Headers__c = 'Content-Type=application/x-www-form-urlencoded';
        wsc.Method__c = 'POST';
        wsc.active__c = true;
        wsc.JSONBodyWithMergeFields__c = 'grant_type=client_credentials&client_id=7gpol6ochdpsm7iu6m4sr07spk&client_secret=1ihkeb7t7cnapi3q7lgtu2c0ri9n0i6lhpn4huvks57kc0dnimcv&scope=epim.api.identifier/search';
        insert wsc;
        
        WebserviceConfigurations__c wsc1 = new WebserviceConfigurations__c();
        wsc1.name = 'EPIM Search Organisation';
        wsc1.EndpointPath__c = 'https://api.optum-epim-prod.net/api/epim/v1/searchOrganization/search?pageNumber=';
        wsc1.Headers__c = 'Content-Type=application/x-www-form-urlencoded';
        wsc1.Method__c = 'POST';
        wsc1.active__c = true;
        wsc1.JSONBodyWithMergeFields__c = 'grant_type=client_credentials&client_id=7gpol6ochdpsm7iu6m4sr07spk&client_secret=1ihkeb7t7cnapi3q7lgtu2c0ri9n0i6lhpn4huvks57kc0dnimcv&scope=epim.api.identifier/search';
        insert wsc1;
        
        
        Map<String, WebserviceConfigurations__c> WebConfigMap = new Map<String, WebserviceConfigurations__c>();
        WebConfigMap.put('EPIM Authorisation Token',wsc);
        WebConfigMap.put('EPIM Search Organisation',wsc1);
        Map<String, String> params = new Map<String, String>();
        List<Map<String,Object>> searchParams = new List<Map<String,Object>>();
        Map<String,Object> paramsmap = new Map<String,Object>();
        Object obj = (Object)'Apollo';
        paramsmap.put('Name',obj);
        searchParams.add(paramsmap);
        params.put('Name','test');
        test.startTest();
            HTTPResponse resp = new HTTPResponse();
            Test.setMock(HttpCalloutMock.class, new EPIMProviderSearchWSMockClass());
            //ACETWSCalloutResult act = ProviderSearchController.searchProvider(searchParams,'1',false);
            resp = EPIMProviderSearchWS.makeProviderSearchCallout('EPIM Search Organisation', WebConfigMap, '1', params, 'sampletoken',false);
            
         EPIMProviderSearchWS.ParseOrgSearchResponse(params,resp);
        test.stopTest();
    }
    static testMethod void EPIMProviderSearchWSMethod2(){
        WebserviceConfigurations__c wsc = new WebserviceConfigurations__c();
        wsc.name = 'EPIM Authorisation Token';
        wsc.EndpointPath__c = 'https://epim-prod-api.auth.us-east-1.amazoncognito.com/oauth2/token';
        wsc.Headers__c = 'Content-Type=application/x-www-form-urlencoded';
        wsc.Method__c = 'POST';
        wsc.active__c = true;
        wsc.JSONBodyWithMergeFields__c = 'grant_type=client_credentials&client_id=7gpol6ochdpsm7iu6m4sr07spk&client_secret=1ihkeb7t7cnapi3q7lgtu2c0ri9n0i6lhpn4huvks57kc0dnimcv&scope=epim.api.identifier/search';
        insert wsc;
        
      
        
        WebserviceConfigurations__c wsc2 = new WebserviceConfigurations__c();
        wsc2.name = 'EPIM Search Practitioner';
        wsc2.EndpointPath__c = 'https://api.optum-epim-prod.net/api/epim/v1/searchpractitioner/v2/search?pageNumber=';
        wsc2.Headers__c = 'Content-Type=application/x-www-form-urlencoded';
        wsc2.Method__c = 'POST';
        wsc2.active__c = true;
        wsc2.JSONBodyWithMergeFields__c = 'grant_type=client_credentials&client_id=7gpol6ochdpsm7iu6m4sr07spk&client_secret=1ihkeb7t7cnapi3q7lgtu2c0ri9n0i6lhpn4huvks57kc0dnimcv&scope=epim.api.identifier/search';
        insert wsc2;
        Map<String, WebserviceConfigurations__c> WebConfigMap = new Map<String, WebserviceConfigurations__c>();
        WebConfigMap.put('EPIM Authorisation Token',wsc);
        WebConfigMap.put('EPIM Search Practitioner',wsc2);
        Map<String, String> params = new Map<String, String>();
        params.put('test','test');
        test.startTest();
        //JSON2ApexPracDetail search=new JSON2ApexPracDetail();
            HTTPResponse resp = new HTTPResponse();
            Test.setMock(HttpCalloutMock.class, new EPIMProviderSearchWSMockClass());
            resp = EPIMProviderSearchWS.makeProviderSearchCallout('EPIM Search Practitioner', WebConfigMap, '1', params, 'sampletoken',true);
            //EPIMProviderSearchWS.makeProviderDetailCallout('EPIM Authorisation Token', WebConfigMap, '0', '');
            EPIMProviderSearchWS.GetToken(wsc);
            
            EPIMProviderSearchWS.ParseSuccessResponse(params,resp);
        test.stopTest();
    }
    static testMethod void EPIMProviderSearchWSMethod3(){
        WebserviceConfigurations__c wsc = new WebserviceConfigurations__c();
        wsc.name = 'EPIM Authorisation Token';
        wsc.EndpointPath__c = 'https://epim-prod-api.auth.us-east-1.amazoncognito.com/oauth2/token';
        wsc.Headers__c = 'Content-Type=application/x-www-form-urlencoded';
        wsc.Method__c = 'POST';
        wsc.active__c = true;
        wsc.JSONBodyWithMergeFields__c = 'grant_type=client_credentials&client_id=7gpol6ochdpsm7iu6m4sr07spk&client_secret=1ihkeb7t7cnapi3q7lgtu2c0ri9n0i6lhpn4huvks57kc0dnimcv&scope=epim.api.identifier/search';
        insert wsc;
        
      
        
        WebserviceConfigurations__c wsc2 = new WebserviceConfigurations__c();
        wsc2.name = 'EPIM Search Practitioner';
        wsc2.EndpointPath__c = 'https://api.optum-epim-prod.net/api/epim/v1/searchpractitioner/v2/search?pageNumber=';
        wsc2.Headers__c = 'Content-Type=application/x-www-form-urlencoded';
        wsc2.Method__c = 'POST';
        wsc2.active__c = true;
        wsc2.JSONBodyWithMergeFields__c = 'grant_type=client_credentials&client_id=7gpol6ochdpsm7iu6m4sr07spk&client_secret=1ihkeb7t7cnapi3q7lgtu2c0ri9n0i6lhpn4huvks57kc0dnimcv&scope=epim.api.identifier/search';
        insert wsc2;
        Map<String, WebserviceConfigurations__c> WebConfigMap = new Map<String, WebserviceConfigurations__c>();
        WebConfigMap.put('EPIM Authorisation Token',wsc);
        WebConfigMap.put('EPIM Search Practitioner',wsc2);
        Map<String, String> params = new Map<String, String>();
        params.put('test','test');
        List<Map<String,Object>> searchParams = new List<Map<String,Object>>();
        Map<String,Object> paramsmap = new Map<String,Object>();
        Object obj = (Object)'Apollo';
        paramsmap.put('Name',obj);
        searchParams.add(paramsmap);
        test.startTest();
        //JSON2ApexPracDetail search=new JSON2ApexPracDetail();
            HTTPResponse resp = new HTTPResponse();
            Test.setMock(HttpCalloutMock.class, new EPIMProviderSearchWSMockClass());
            ACETWSCalloutResult act = ProviderSearchController.searchProvider(searchParams,'1',true);
        test.stopTest();
        ProviderSearchController.providerSearchParams psparam = new ProviderSearchController.providerSearchParams();
    }

    static testMethod void EPIMProviderSearchWSMethod4()
    {
        ACETProviderLookupController.ProviderLookupResult providerResults = new ACETProviderLookupController.ProviderLookupResult();
           Account acc = new Account(Name='test account');
           insert acc;
           case cs= new case();
           Id devRecordTypeId1 = Schema.SObjectType.case.getRecordTypeInfosByName().get('ECM').getRecordTypeId();
           cs.Priority='Standard';
           cs.accountid = acc.id;
           cs.Opportunity_Category__c='Behavioral';
           insert cs;
           List<Map<String,Object>> selectedRecords = new List<Map<String,Object>>();
           Map<String,Object> selMap = new Map<String,Object>();
           selMap.put('Name',(Object)'Test');
           selMap.put('Address',(Object)'Test');
           selMap.put('City',(Object)'Test');
           selMap.put('Phone',(Object)'1245345734');
           selMap.put('Fax',(Object)'1245345734');
           selMap.put('State',(Object)'TX');
           selMap.put('NPI',(Object)'Test');
           selMap.put('Speaciality',(Object)'Test');
           selMap.put('TIN',(Object)'Test');
           selMap.put('EPIMID',(Object)'Test');
           selMap.put('Zipcode',(Object)'75038');
           selectedRecords.add(selMap);
           String suc = ProviderSearchController.createAssociateRecords(selectedRecords,cs.id);




    }
}