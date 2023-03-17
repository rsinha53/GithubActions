/*
Created By: Chandan Patro
Created Date: 14th March 2020
Description: This class is used to get all the data from ORS Read Api.
*/
public with sharing class ACETORSReadWebService extends ACETWebService {
    
    public override void getEndpoint(){
        //GetEndpointDetail('ORSReadAPI'); //Commented for Micro Service
        GetEndpointDetail('ORSReadIssueMicroService');//Added for Micro service
		 
    }
    
    public ACETORSReadWebService(){
        super('SNIEligibilityAPI');
    }
    
    public String GetRequestBody(String issueId)
    {
        
        String errorMsg='';
        String logonId;
        String logonOffice;
        //Logic to get the userid from Session cache
        String userid = (String)Cache.Session.get('local.TOPSProfileInfo.userId');//673/JR2 - LogonOffice/LogonId
        if(String.isBlank(userId)){
            //If UserId is Still blank then run the token service.
            ACET_LoginFlowCtrl loginflow = new ACET_LoginFlowCtrl();
            loginflow.validateTopsCredentials();
            if(loginflow.showError || loginflow.statusCode!=200){
                errorMsg=ACETUtility.getErrorMessage('TS500');
                //'Unexpected error occured for TOPS service,so please check your Tops Credential';
            }
            else{
                userid = (String)Cache.Session.get('local.TOPSProfileInfo.userId');//673/JR2 - LogonOffice/LogonId
            }
        }
        if(String.isBlank(errorMsg) && String.isNotBlank(userId)){
            logonId=userId.substringAfter('/');
            logonOffice=userId.substringBefore('/');
        }
        if(test.isRunningTest()){
            logonId=String.isNotBlank(logonId)?logonId:'TST';
            logonOffice=String.isNotBlank(logonOffice)?logonId:'123';
        }
        if(String.isBlank(errorMsg) && (String.isBlank(logonId) || String.isBlank(logonOffice))){
            System.debug('Token api ran succesful but there is some issue in session cache');
            errorMsg=ACETUtility.getErrorMessage('TS500');
            //errorMsg='Unexpected error happened while setting in session cache';
        }
        //ACETORSReadRequestJSON2Apex aORSRead = new ACETORSReadRequestJSON2Apex(); //Commented for micro services
        ACET_ORSReadIssueRequestWrapper aORSRead=new ACET_ORSReadIssueRequestWrapper();
        if(String.isNotBlank(logonId) && String.isNotBlank(logonOffice)){
            RequestBody = aORSRead.addSearchInput(logonId,logonOffice,issueId);
        }
        System.debug('OrsReadjsonInput='+RequestBody);
        return errorMsg;
    }
    
    public  ACETWSCalloutResult readORSWS(String issueId,String memberId,String policyId,String fName,String lName){
        
        getEndpoint();
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        Map<String,ACETORSReadResponseWrapper> ORSReadMap=new Map<String,ACETORSReadResponseWrapper>();
        try{
            HttpResponse response = new HttpResponse();
            Integer statusCode;
            String responseStr;
            String topsIssue=GetRequestBody(issueId);
            System.debug('topsIssue='+topsIssue);
            if(test.isRunningTest() || String.isBlank(topsIssue)){
                BaseURL = '';
                if(String.isNotBlank(RequestBody))
                    response = Send(OAuthConfig);
                responseStr = response!=null?response.getBody():'';
                System.debug('responseStr='+responseStr);
                statusCode= response!=null?response.getStatusCode():null;
                System.debug('statusCode='+statusCode);
                if(responseStr!=null && String.isNotBlank(responseStr) && statusCode!=null && statusCode== 200){
                    calloutResult.statusCode= statusCode;
                    map<String,SNI_Advocate_Detail__c> sniAdvocateMap=new map<String,SNI_Advocate_Detail__c>();
                    for(SNI_Advocate_Detail__c sniAdv: [Select id,MS_ID__c,Logon_ID__c,Logon_Office__c,First_Name__c,Last_Name__c,Middle_Name__c
                                                        from SNI_Advocate_Detail__c where Status__c='active']){
                                                            if(String.isNotBlank(sniAdv.Logon_ID__c) && String.isNotBlank(sniAdv.Logon_Office__c))
                                                                sniAdvocateMap.put(sniAdv.Logon_Office__c+sniAdv.Logon_ID__c, sniAdv);
                                                            
                                                        }
                    //ACETORSReadResponseJSON2Apex json2Apex = ACETORSReadResponseJSON2Apex.parse(responseStr);
                    ACET_ORSReadIssueWrapper json2Apex= ACET_ORSReadIssueWrapper.parse(responseStr);
                    List<ACET_ORSReadIssueWrapper.detailComments> detailComments = new List<ACET_ORSReadIssueWrapper.detailComments>();
                    map<String,ACET_ORSReadIssueWrapper.Owners> headerOwnerMap=new map<String,ACET_ORSReadIssueWrapper.Owners>();
                    
                    if(json2Apex != null && json2Apex.issue!=null){
                           ACET_ORSReadIssueWrapper.Issue issueDetail = json2Apex.issue;
                           String contactMethodCode=issueDetail.contactMethodCode;
                           String originatorTypeCode=issueDetail.originatorTypeCode;
                           String designeeId=issueDetail.designeeId;
                           String directionCode=issueDetail.directionCode;
                           String status=issueDetail.status;
                           String callerfirstname,callerlastname; //Required for ORS update micro service
                           String dependentfirstname,dependentlastname; //Required for ORS update micro service
                           if(issueDetail.originator!=null && issueDetail.originator.callerName!=null){
                               callerfirstname=issueDetail.originator.callerName.firstName;
                               callerlastname=issueDetail.originator.callerName.lastname;
                           }
                           
                           if(issueDetail.owners!=null && issueDetail.owners.size()>0){
                                  for(ACET_ORSReadIssueWrapper.Owners own :issueDetail.owners){
                                      headerOwnerMap.put(own.headerNumber,own);
                                  }   
                              }
                           String mId,pId,fn,ln,rel; //mName
                           if(issueDetail.member!=null){
                               
                               mId=  issueDetail.member.alternateId;//memberNumber
                               pId=  issueDetail.member.policy;
                               if(String.isNotBlank(pId))
                                   pid= ACETUtility.policyRefactor(pId);//Converting to compare it with ACET Policy
                               rel=issueDetail.member.relationship;
                               if(rel != null && issueDetail.member.dependentName != null) {
                                   fn=issueDetail.member.dependentName.firstName;
                                   ln=issueDetail.member.dependentName.lastName;
                               }
                               if(issueDetail.member.dependentName!=null) {
                               	dependentfirstname=issueDetail.member.dependentName.firstName; //Required for ORS update micro service
                               	dependentlastname= issueDetail.member.dependentName.lastName; //Required for ORS update micro service
                               }
                               //mName=fn+' '+ln;
                           }
                           if(ACETUtility.IDRefactorCheck(memberId,mId) && pId==policyId &&  ACETUtility.compareData(fName,fn,12) && ACETUtility.compareData(lName,ln,16)){
                               if(issueDetail.detailComments!=null && issueDetail.detailComments.size()>0){
                                      detailComments=issueDetail.detailComments;
                                      ACET_ORSReadIssueWrapper.detailComments priCommentNode=null;
                                      for(ACET_ORSReadIssueWrapper.detailComments det :detailComments){
                                          ACETORSReadResponseWrapper ars;
                                          //The Key to club the comments
                                          String key= det.headerNumber+'_'+det.commentDate+'_'+det.commentTime+'_'+det.commentType;
                                          //NW-EN-NB-NC-NE
                                          if(ORSReadMap.get(key)!=null){
                                              ars= ORSReadMap.get(key);
                                              //Logic to Club the comments from a multiline Comment
                                              if('EN|NC|NO'.contains(det.commentType) && String.isNotBlank(det.commentText)){//To filter out manual comment
                                                  ars.commment+=det.commentText;
                                              }
                                          }
                                          //Logic to remove system comment -So considering only 'EN|NC|NO'
                                          else if('EN|NC|NO'.contains(det.commentType) && String.isNotBlank(det.commentText)){
                                              
                                              String ownerId='';
                                              String ownerName='';
                                              //Logic to get the Owner 
                                              if(headerOwnerMap!=null){
                                                  ACET_ORSReadIssueWrapper.Owners own=headerOwnerMap.get(det.headerNumber);
                                                  if(own!=null){
                                                      ownerId=own.officeId+own.associateId;
                                                      ownerName=own.associateName!=null?own.associateName.firstName+' '+own.associateName.lastName:'';
                                                  }
                                              }
                                              
                                              //Logic to get the UserID- If UserId would not be there for the current node
                                              //Then trying to get the userId from Previous Node
                                              String userId=String.isnotblank(det.userid)?det.userid.replaceAll('[^a-zA-Z0-9]*', ''):'';
                                              if(String.isBlank(userId) && det.commentType=='EN')
                                                  userId=ownerId;
                                              else if(String.isBlank(userId) && priCommentNode!=null)
                                                  userId=getCommentUserId(priCommentNode); 
                                              /*String userId=getCommentUserId(det);
if(String.isBlank(userId) && priCommentNode!=null){
userId=getCommentUserId(priCommentNode);  
}*/
                                              //Logicto validate User Id
                                              //Need to build logic to filter out Acet Comments
                                              if(sniAdvocateMap!=null && String.isNotBlank(userId)){
                                                  SNI_Advocate_Detail__c sniAdv= sniAdvocateMap.get(userId);
                                                  if(sniAdv!=null){
                                                      ars=new ACETORSReadResponseWrapper(); 
                                                      ars.commment= det.commentText;
                                                      ars.userId=sniAdv.First_Name__c+' '+sniAdv.Last_Name__c;
                                                      ars.ownerId=ownerId;
                                                      ars.ownerName=ownerName;
                                                      String[] strTimeSplit = det.commentTime.split(':');
                                                      Datetime myDate = Datetime.newInstance(0, 0, 0, Integer.valueOf(strTimeSplit[0]), Integer.valueOf(strTimeSplit[1]), 0); //13:43:15
                                                      DateTime gmtTime = getDateTimeGmt('America/New_York', date.valueOf(det.commentDate), myDate.time());
                                                      ars.commmentDate=gmtTime.format('MM/dd/yyyy',String.valueOf(userInfo.getTimeZone()));
                                                      ars.commentTime=gmtTime.format('h:mm a',String.valueOf(userInfo.getTimeZone()));
                                                      Date tempDate = gmtTime.date();
                                                      system.debug('tempDate...'+tempDate);
                                                      ars.commentDateTime = DateTime.parse(ars.commmentDate+', '+ars.commentTime);
                                                      ars.orsKey=key;
                                                      ars.source='ORS';
                                                      ars.issueId=issueId;
                                                      ars.designeeId=designeeId;
                                                      ars.callerfirstname=callerfirstname;
                                                      ars.callerlastname=callerlastname;
                                                      ars.dependentfirstname=dependentfirstname;
                                                      ars.dependentlastname=dependentlastname;
                                                      ars.contactmethodCode=contactmethodCode;
                                                      ars.originatorTypeCode=originatorTypeCode;
                                                      ars.directionCode=directionCode;  
                                                      ars.status=status;
                                                      //ars.memberFN=memberFN;
                                                      //ars.memberLN=memberLN;
                                                      //ars.memberId=memberId;
                                                      //ars.policyID=policyID;
                                                  }
                                                  
                                              }
                                          }
                                          
                                          if(String.isNotBlank(key) && ars!=null)
                                              ORSReadMap.put(key,ars);
                                          priCommentNode=det;
                                      }
                                      calloutResult.Success = true;
                                      calloutResult.Message = '';
                                      if(ORSReadMap!=null){
                                          List<ACETORSReadResponseWrapper> OrsReadList=new List<ACETORSReadResponseWrapper>();
                                          //Logic to remove autodoc Comment 
                                          for(ACETORSReadResponseWrapper orsRead:ORSReadMap.values()){
                                              // remove any embedded autodocs beginning with "{{"; e.g. "hello {{autodoc Comment}} good day" -> "hello  good day"
                                              orsRead.commment = orsRead.commment.replaceAll('\\{\\{[^\\}\\}]*\\}\\}', '').trim();
                                              System.debug('orsRead='+orsRead);
                                              OrsReadList.add(orsRead);
                                          }
                                          System.debug('OrsReadList='+OrsReadList);
                                          calloutResult.Response = OrsReadList;
                                      }  
                                  }
                           }
                           else{
                               calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                               calloutResult.Success = false; 
                               calloutResult.statusCode = 999;
                               calloutResult.Message =ACETUtility.getErrorMessage('OR997');//'ORS is not valid for this Member';
                           }
                       }
                }
                else{
                    createAppErrorLog('OrsRead','ORSReadIssueMicroService', endPoint, '', statusCode, requestBody,responseStr,'');
                    calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                    calloutResult.Success = false;
                    calloutResult.statusCode = statusCode;
                    if(statusCode!=null && statusCode == 400)
                    {
                        calloutResult.Message =  ACETUtility.getErrorMessage('OR400');//'ORS Number is not valid'; //ACETUtility.getErrorMessage('GN400');
                    }
                    else if(statusCode!=null && statusCode == 500)
                    {
                        calloutResult.Message = ACETUtility.getErrorMessage('OR500');
                    }
                    else if(statusCode!=null && statusCode == 404)
                    {
                        calloutResult.Message = ACETUtility.getErrorMessage('OR500');
                    }
                    else
                    {
                        calloutResult.Success = false; 
                        calloutResult.Message = ACETUtility.getErrorMessage('OR500');
                        calloutResult.statusCode = 999;
                    }     
                }
            }
            else{
                calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                calloutResult.Success = false; 
                calloutResult.Message = topsIssue;
                calloutResult.statusCode = 999;
                //createAppErrorLog('OrsRead','ORSReadIssueMicroService', '', '', null, null,topsIssue,'');
 
            }
         }catch(Exception e){
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = ACETUtility.getErrorMessage('OR999');
            calloutResult.statusCode=999;
            Application_Error_Log__c er=ACETUtility.CreateApplicationExcepLog('ORSReadIssueMicroService', 'OrsRead', ''+e.getCause(), calloutResult.Message, ''+e.getLineNumber(), e.getMessage(), e.getTypeName());
            if(er!=null) insert er;

        }
        return calloutResult;
    } 
    
    //Code added to get the UserId from the Comment
    public String getCommentUserId(ACET_ORSReadIssueWrapper.detailComments det){
        
        //valid userId (i.e. 6 alphanumeric characters)? (so, no *, ?, etc.)
        String userId=(det!=null && String.isnotblank(det.userid))?det.userid.replaceAll('[^a-zA-Z0-9]*', ''):'';
        //String.isnotblank(det.userid)?det.userid.replaceAll('?', ''):'';
        if(det!=null && String.isBlank(userId)){
            //END OF NON OWNER COMMENT 673 SP5 S..." -> 673SP5
            String currentText= det.commentText.replaceFirst('[^0-9]*', '');
            String[] split = currentText.split(' ');
            if (split!=null && split.size() > 1) {
                userId = split[0] + split[1];
            }
        }
        
        return userId;
    }
    public static Datetime getDateTimeGmt(String tzId, Date d, Time t) {
        DateTime    res;
        if (tzId == null || d == null || t == null) return res;
        Timezone tz = Timezone.getTimeZone(tzId);
        DateTime dt = DateTime.newInstanceGmt(d,t);
        Integer offsetMs = tz.getOffset(dt);                 // #ms offset from datetime in Tz to GMT
        Integer offsetMins  = offsetMs / (1000 * 60);
        res = dt.addMinutes(-1 * offsetMins);
        
        return res;
    } 
}