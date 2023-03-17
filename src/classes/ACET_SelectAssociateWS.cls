// Controller class to callSelectAssociateAPI on SendTo component 
// Ketki J - 3/16/2021
// US2426570
public class ACET_SelectAssociateWS {
    
    private static final String LOG_LEVEL= '2';
    private static final String SERVICE_VERSION= 'DEFAULT';
    private static final String APPLICATION_INSTANCE_NAME= 'ACET';
    private static final String APPLICATION_NAME= 'ACET';
    private static final String CALL_LIMIT= '5';
    private static final String ACTIVE_INDICATOR= 'Y';
    
    public class SelectAssociateInput {
        @AuraEnabled public String officeId {get;set;}
        @AuraEnabled public String departmentCode {get;set;}
        @AuraEnabled public String teamCode {get;set;}
    }
    public class SelectAssociateOutput {
        @AuraEnabled public String associateName {get;set;}
        @AuraEnabled public String associateId {get;set;}
        @AuraEnabled public String associateOfficeId {get;set;}
    }

    @AuraEnabled
    public static List<SelectAssociateOutput> callSelectAssociate(SelectAssociateInput input) {
        String responseStr = '';
        List<SelectAssociateOutput> result=new List<SelectAssociateOutput>();
        try{
            System.debug('### ACET_SelectAssociateWS - officeId:'+ input.officeId+' departmentCode:'+input.departmentCode+' teamCode:'+input.teamCode);

            ACET_WebserviceCalloutFramework wsCallOut = new ACET_WebserviceCalloutFramework();
            wsCallOut.serviceName = 'SelectionAssociatesAPI';
            wsCallOut.requestBody = getSelectAssociateRequestBody(input);
            HttpResponse response = wscallout.getResponse();
            responseStr = response.getBody();
            system.debug('ResponseBody** ' + responseStr);
            List<SelectAssociateJson2Apex.Associates> associateResponseArray = new List<SelectAssociateJson2Apex.Associates>();
            if(response.getStatusCode() == 200){
            if(responseStr != null && String.isNotBlank(responseStr)){
                //calloutResult.statusCode= response.getStatusCode();
                SelectAssociateJson2Apex responseObj = SelectAssociateJson2Apex.parse(responseStr);
                System.debug('### ACET_SelectAssociate - Deserialized responseObj:'+responseObj);

                if(responseObj != null) {
                    if(responseObj.associates != null && !responseObj.associates.isEmpty()){
                       associateResponseArray=responseObj.associates;
                        for(SelectAssociateJson2Apex.Associates associate : associateResponseArray){
                            SelectAssociateOutput output=new SelectAssociateOutput();
                            SelectAssociateJson2Apex.AssociateName res = new SelectAssociateJson2Apex.AssociateName();
                            if(associate.associateName != null){
                                String fullName=associate.associateName.firstName +' '+ associate.associateName.lastName;
                                output.associateName=fullName;
                                output.associateId= associate.associateId;
                                output.associateOfficeId = associate.officeId;
                            }

                            result.add(output);
                        }
                    }
                }
            }
           }
        }
        catch(Exception ex){
            System.debug('@@@ ACET_SelectAssociateWS: Exception Stack Trace: '+ex.getStackTraceString());
        }
        
        return result;
        
    }
    
    //create request body
    private static String getSelectAssociateRequestBody(SelectAssociateInput input)
    {
        String requestBody='';
        ACET_SelectAssociateRequest associateRequest = new ACET_SelectAssociateRequest();
        
        associateRequest.officeId = input.officeId;
        associateRequest.departmentCode=input.departmentCode;
        associateRequest.teamCode =input.teamCode;
        
        ACET_SelectAssociateRequest.PagingState paginState=new ACET_SelectAssociateRequest.PagingState();
        paginState.moreData=false;
        associateRequest.pagingState=paginState;
               
        ACET_SelectAssociateRequest.ControlModifiers modifier=new ACET_SelectAssociateRequest.ControlModifiers();
        modifier.callLimit= '5';
        associateRequest.controlModifiers=modifier;
        
        ACET_SelectAssociateRequest.ServiceOptions options=new ACET_SelectAssociateRequest.ServiceOptions();
        options.key='SOAP_FAULTS_AS_STATUS_MESSAGE_BEANS';
        options.value='true';
        
        List<ACET_SelectAssociateRequest.ServiceOptions> serviceOptionsList=new List<ACET_SelectAssociateRequest.ServiceOptions>();
        serviceOptionsList.add(options);
        
        ACET_SelectAssociateRequest.RequestHeader requestHeader=new ACET_SelectAssociateRequest.RequestHeader();
        requestHeader.serviceOptions=serviceOptionsList;
        requestHeader.applicationInstanceName='ACET';
        requestHeader.applicationName='ACET';
        requestHeader.logLevel='DEFAULT';
        
        associateRequest.requestHeader= requestHeader;
        
        object objResponse = associateRequest;
        requestBody = JSON.serialize(objResponse);       
        //requestBody=requestBody.replace('type_Z','type');
        system.debug('ACET_SelectAssociate : reqBody:: '+requestBody);
        
        return requestBody;
        
    }

}