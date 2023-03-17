// Service class for SelectWorkLoadList API
// Sanka Dharmasena - US3184988 - 27.01.2021
public with sharing class ACET_SelectWorkLoadService {
    
    public static ACET_SAECalloutResult callSelectWorkLoadService(){
        ACET_SAECalloutResult retResponse = new ACET_SAECalloutResult();
        try{
            List <String> searchInputParams = ACET_WorkQueueController.getTopsUserCreds();           
            // Setting request Data
            orsSystemParameter sysParams = new orsSystemParameter();
            sysParams.logonOffice =searchInputParams.size() > 1 ? searchInputParams.get(0) : ''; //'673';
            
            sysParams.logonId = searchInputParams.size() > 1 ? searchInputParams.get(1) : '';//'CSM';
            //sysParams.logonOffice =  '673';//searchInputParams.size() > 1 ? searchInputParams.get(0) : '';
            //sysParams.logonId = searchInputParams.size() > 1 ? searchInputParams.get(1) : '';
            

            controlModifiersType cm = new controlModifiersType();
            cm.orsSystemParameter = sysParams;

            requestHeader rh = new requestHeader();
            rh.applicationInstanceName = 'ACET';
            rh.applicationName = 'ACET';
            rh.logLevel = 'INFO';
            serviceOption so = new serviceOption(); 
            so.key = 'MAX_CALL_COUNT';
            so.value = '2';
            rh.serviceOption = new List<serviceOption>{so};

            workLoadSelection wls = new workLoadSelection();
            //wls.associateId = associateId;
            //wls.officeId = officeId;
            wls.associateId =  searchInputParams.size() > 1 ? searchInputParams.get(1) : '';//officeId1;//sysParams.logonId;//sysParams.logonOffice;//'CSM';
            wls.officeId = searchInputParams.size() > 1 ? searchInputParams.get(0) : '';//associateId1;//sysParams.logonOffice;//'673';

            requestParams reqParam = new requestParams();
            reqParam.requestIndicator = 'A';
            reqParam.businessIndicator = 'U';
            reqParam.workLoadSelection = new List<workLoadSelection>{wls};
            reqParam.sortOrder = 'D';
            reqParam.controlModifiersType = cm;
            reqParam.requestHeader = rh;

            String requestBody = JSON.serialize(reqParam);

            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            // Web service record name - SelectWorkLoadListService
            // Record created in KISS (a1Ve0000004qev8EAA) - Endpoint needs to be updated
            wsCallOutFW.serviceName = 'ORSMyFollowupsSelectWorkloadList';//'SelectWorkLoadListService';
            wsCallOutFW.requestBody = requestBody;
            HttpResponse httpResponse = wsCallOutFW.getResponse();
            if(httpResponse.getStatusCode() == 200){
                retResponse.statusCode = 200;
                retResponse.isSuccess = true;
                ACET_SWLResponse resp = (ACET_SWLResponse) JSON.deserialize(httpResponse.getBody(),ACET_SWLResponse.class);
                retResponse.response = resp;
            }else{
                retResponse.statusCode = httpResponse.getStatusCode();
                retResponse.isSuccess = false;
                retResponse.response = httpResponse.getBody();
            } 
        }catch(Exception e){
            retResponse.statusCode = 400;
            retResponse.isSuccess = false;
            System.debug('ACET_SelectWorkLoadService ' + e.getMessage() + ' ' + e.getLineNumber());
        }
        return retResponse;
    }

    // wrapper classes to generate request body
    public class requestParams{
        public String requestIndicator{get;set;}
		public String businessIndicator{get;set;}
		public list<workLoadSelection> workLoadSelection{get;set;}
		public String sortOrder{get;set;}
		public controlModifiersType controlModifiersType{get;set;}
		public requestHeader requestHeader{get;set;}
    }
    public class workLoadSelection{
		public String officeId{get;set;}
		public String associateId{get;set;}
	}
	public class serviceOption{
		public String key{get;set;}
		public String value{get;set;}
	}
	public class requestHeader{
		public String applicationInstanceName{get;set;}
		public String applicationName{get;set;}
		public String logLevel{get;set;}
		public list<serviceOption> serviceOption{get;set;}
	}
	public class orsSystemParameter{
		public String logonOffice{get;set;}
		public String logonId{get;set;}
	}
	public class controlModifiersType{
		public orsSystemParameter orsSystemParameter{get;set;}
	}
}