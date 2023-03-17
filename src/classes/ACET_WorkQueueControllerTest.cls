@isTest
public class ACET_WorkQueueControllerTest {
    @istest
    static void test1(){
        
	ACET_WorkQueueController.getRoutingData();
    ACET_UpdateORSRequest uor=new ACET_UpdateORSRequest();
    ACET_WorkQueueController.getSubTypeValues('View Claims','sample1');
    ACET_WorkQueueController.getTopics();
    ACET_WorkQueueController.OrsRequestDetails ors=new ACET_WorkQueueController.OrsRequestDetails();
        ors.comment='sample1';
        ors.departmentCode='sample2';
        ors.issueId='sample3';
        ors.officeId='sample4';
        ors.routeOrClose='sample5';
        ors.teamCode='sample6';
        Tops_Encryption_Mappings__c topsEncryption = new Tops_Encryption_Mappings__c(EBCDIC__c='B', Char_1__c='45', Char_2__c='38', 
                                                                                     Char_3__c='64', Char_4__c='51', Char_5__c='64', 
                                                                                     Char_6__c='51', Char_7__c='45', Char_8__c='38');
        Insert topsEncryption;
        
        ISL_Webservice_Config__c apiEndpointSetting = new ISL_Webservice_Config__c(Name='SNIAPIAccessToken',
                                                                                   Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert apiEndpointSetting;
        
        ISL_Webservice_Config__c serviceSetting = new ISL_Webservice_Config__c(Name='dev_ORSEAIPToken',
                                                                               Value__c='zwdsk9VPXJASohgqS2zqXD0UxD9MEa5g');
        Insert serviceSetting;
        
        Per_User_Credentials__c userCredentialRec = new Per_User_Credentials__c(userName__c = 'test',
                                                                                Password__c='bbbbbbbb',
                                                                                user__c=userinfo.getUserId());
        Insert userCredentialRec;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SAEHttpCalloutMock.ACETLoginFlowMock());
        ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
        loginflow.userPassword = 'bbbbbbbb';
        //loginflow.validateTopsCredentials();
        //loginflow.createOrUpdateORSCredentials();
    	ACET_WorkQueueController.updateORSRecord(ors);
        ACET_WorkQueueController.createCommentList('comment');
        ACET_WorkQueueController.createCommentList('comment comment comment comment comment comment commentcomment commentco');
        Cache.Session.put('local.TOPSProfileInfo.userId', '673/JR2');
        ACET_WorkQueueController.callSelectWorkLoadService();
        Test.stopTest();
    }
	
	@isTest static void test2() {
         ACET_SWLResponse swlResp=new ACET_SWLResponse();
         ACET_SWLResponse.owner ow=new ACET_SWLResponse.owner();
         ow.firstName='nameF';
         ow.lastName='nameL';
         ow.officeName='UG';
         ACET_SWLResponse.serviceRequestOwner sro=new ACET_SWLResponse.serviceRequestOwner();
         sro.associateFirstName='';
         sro.associateLastName='';
         sro.dependentFirstName='';
         sro.dependentLastName='';
         sro.issueId='';
         sro.lastUpdate='';
         sro.memberId='';
         sro.originalDate='';
         sro.originatorFirstName='';
         sro.originatorLastName='';
         sro.owner=ow;
         sro.policyNumber='';
         sro.reasonCode='';
         sro.reasonDescription='';
         sro.reasonDescription='';
         sro.serviceRequestSubType='';
         sro.serviceRequestSubTypeDescription='';
         sro.serviceRequestType='';
         sro.serviceRequestTypeDescription='';
         sro.statusCode='';
         sro.statusDescription='';
         sro.priority='';
         ACET_SWLResponse.followUpOwner fluo=new ACET_SWLResponse.followUpOwner();
         fluo.daysToComplete='';
         fluo.estimatedCompletionDate='';
         fluo.nextActionDueDate='';
         fluo.owner=ow;
         fluo.preferredContactTime='';
         fluo.purposeCode='';
         fluo.statusCode='';
         fluo.statusDescription='';
         ACET_SWLResponse.pagingState pgs=new ACET_SWLResponse.pagingState();
         pgs.moreData=true;
         pgs.nextKey='ASPTRES-AKNGO';
         ACET_SWLResponse.workList wl=new ACET_SWLResponse.workList();
         wl.followUpOwner=fluo;
         wl.serviceRequestOwner=sro;
         List<ACET_SWLResponse.workList> lst=new List<ACET_SWLResponse.workList>();
         lst.add(wl);
         swlResp.pagingState=pgs;
         swlResp.workList=lst;
         
     }
	
}