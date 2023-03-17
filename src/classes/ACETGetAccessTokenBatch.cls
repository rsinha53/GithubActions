public class ACETGetAccessTokenBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {   
    final String[] toAddresses = new String[]{'ranjit_samal@optum.com','srinivasarao_m@optum.com','kumar_manish3@optum.com','chaminda.dharmatilake@optum.com','nalin.perera@optum.com'};
    public List<ISL_Webservice_Config__c> start(Database.BatchableContext BC){        
        List<ISL_Webservice_Config__c> lstWSConfig = new List<ISL_Webservice_Config__c>([SELECT Id, Name, Value__c 
                                FROM ISL_Webservice_Config__c WHERE (Name = 'ISLConAccessToken' OR Name = 'SAEAPIAccessToken' OR Name = 'CISLConAccessToken' OR Name = 'StargateConAccessToken' OR Name = 'OILAccessToken' OR Name = 'StargateORXConAccessToken' OR Name = 'StargateJWTConAccessToken' OR Name = 'StargateDashboardJWTConAccessToken')]);//US2034021 : Tech -  Member ID Standalone Search Integration
        system.debug(LoggingLevel.INFO, 'lstWSConfig.size: ' + lstWSConfig.size());
        
        if (lstWSConfig.size() == 0) {
            lstWSConfig = new List<ISL_Webservice_Config__c>();
            lstWSConfig.add(new ISL_Webservice_Config__c(Name='ISLConAccessToken'));
            lstWSConfig.add(new ISL_Webservice_Config__c(Name='CISLConAccessToken'));
            lstWSConfig.add(new ISL_Webservice_Config__c(Name='StargateConAccessToken'));
            lstWSConfig.add(new ISL_Webservice_Config__c(Name='OILAccessToken'));
            lstWSConfig.add(new ISL_Webservice_Config__c(Name='SAEAPIAccessToken'));
            lstWSConfig.add(new ISL_Webservice_Config__c(Name='StargateORXConAccessToken'));	//	US2722432	Aligning Stargate and ORX token generation callout by Madhura 08-July-2020
	    lstWSConfig.add(new ISL_Webservice_Config__c(Name='StargateJWTConAccessToken'));   // US2819526 Member Listing Cirrus API Stargate Conversion
        lstWSConfig.add(new ISL_Webservice_Config__c(Name='StargateDashboardJWTConAccessToken'));   
        
        }   
        system.debug(LoggingLevel.INFO, 'lstWSConfig.size: ' + lstWSConfig.size());        
        return lstWSConfig;                 
    }    
    public void execute(Database.BatchableContext BC, List<ISL_Webservice_Config__c> scope) {
        Boolean errorState,ISLConTokenCheck,CISLConTokenCheck,StargateConTokenCheck,StargateORXConTokenCheck,StargateJWTConTokenCheck,StargateDashboardJWTConTokenCheck; String formatted = ACETUtility.format(Datetime.now());
        errorState= ISLConTokenCheck= CISLConTokenCheck = StargateConTokenCheck = StargateORXConTokenCheck =StargateJWTConTokenCheck =StargateDashboardJWTConTokenCheck= False;
      
        ACETOAuthWebservice OAuthWS = new ACETOAuthWebservice(); ACETCISLAuthWebservice CISLAuthWS = new ACETCISLAuthWebservice('CISL');ACETStargateAuthWebservice sgAuthWS = new ACETStargateAuthWebservice('Stargate'); ACETStargateProdAuthWebservice prdAuthWS = new ACETStargateProdAuthWebservice('Stargate_prod'); 
        //	US2722432	Aligning Stargate and ORX token generation callout by Madhura 08-July-2020
        ACETStargateAuthWebservice sgORXAuthWS = new ACETStargateAuthWebservice('StargateORX');
        
        //US2034021 : Tech -  Member ID Standalone Search Integration
        OILAuthWebservice OILAuthWs = new OILAuthWebservice('OIL');
        String OILAccessToken = OILAuthWs.GetAccessToken();
        
        String OAuthaccesstoken= OAuthWS.GetAccessToken(); String CISLaccesstoken= CISLAuthWS.GetAccessToken(); String Stargateaccesstoken= sgAuthWS.GetAccessToken(); String StargateORXAccesstoken= sgORXAuthWS.GetAccessToken(); String SAEAPIAccessToken= prdAuthWS.GetAccessToken();//String variables to store Access Token.
        String StargateJWTAccesstoken= ADBWebService.getjwToken('ACETStargateJWTToken');
		String StargateDashboardJWTAccesstoken= ADBWebService.getjwToken('ACETDashboardStargateJWTToken');
		system.debug('StargateJWTAccesstoken:: '+StargateJWTAccesstoken+'::Stargate Dashboard JWT Token ::'+StargateDashboardJWTAccesstoken);
        system.debug(LoggingLevel.INFO, 'ACETGetAccessTokenBatch Scope: ' + scope);
        List<ISL_Webservice_Config__c> lstAccessTokenConfig= new List<ISL_Webservice_Config__c>();
       
        for(ISL_Webservice_Config__c rec: scope){
            ISL_Webservice_Config__c AccessTokenConfig = rec;            
            if(AccessTokenConfig.Name=='ISLConAccessToken'){  
                ISLConTokenCheck= True;              
                System.debug('OAuthaccesstoken='+OAuthaccesstoken);  
                if(OAuthaccesstoken!= null && OAuthaccesstoken!=''){         
                    AccessTokenConfig.Value__c = OAuthaccesstoken;
                    lstAccessTokenConfig.add(AccessTokenConfig);
                }       
                else
                    errorState = True;
            }
            else if(AccessTokenConfig.Name=='CISLConAccessToken'){    
                CISLConTokenCheck= True;          
                System.debug('CISLaccesstoken='+CISLaccesstoken);
                if(CISLaccesstoken!= null && CISLaccesstoken!= ''){
                    AccessTokenConfig.Value__c = CISLaccesstoken;
                    lstAccessTokenConfig.add(AccessTokenConfig);
                }    
                else
                    errorState = True;
            }
            else if(AccessTokenConfig.Name=='StargateConAccessToken'){    
                StargateConTokenCheck= True;          
                System.debug('Stargateaccesstoken='+Stargateaccesstoken);
                if(Stargateaccesstoken!= null && Stargateaccesstoken!= ''){
                    
                    if(Stargateaccesstoken.contains('_expiry_')){
                        string[] splitVal = Stargateaccesstoken.split('_expiry_');
                        AccessTokenConfig.Value__c = splitVal[0]; // Stargateaccesstoken;
                        AccessTokenConfig.TokenExpiry__c   = integer.valueOf(splitVal[1]);
                        datetime dtim = datetime.now();
                        datetime dtim1 = dtim.addSeconds(integer.valueOf(splitVal[1]));
                        AccessTokenConfig.TokenExpiredBy__c   = dtim1;
                        lstAccessTokenConfig.add(AccessTokenConfig);
                    }
                }    
                else
                    errorState = True;
            }
            //	US2722432	Aligning Stargate and ORX token generation callout by Madhura 08-July-2020
            else if(AccessTokenConfig.Name == 'StargateORXConAccessToken'){    
                StargateORXConTokenCheck = true;          
                System.debug('StargateORXAccesstoken='+StargateORXAccesstoken);
                if(String.isNotEmpty(StargateORXAccesstoken)){                    
                    if(StargateORXAccesstoken.contains('_expiry_')){
                        string[] splitVal = StargateORXAccesstoken.split('_expiry_');
                        AccessTokenConfig.Value__c = splitVal[0]; // StargateORXAccesstoken;
                        AccessTokenConfig.TokenExpiry__c = integer.valueOf(splitVal[1]);
                        datetime dtim = datetime.now();
                        datetime dtim1 = dtim.addSeconds(integer.valueOf(splitVal[1]));
                        AccessTokenConfig.TokenExpiredBy__c = dtim1;
                        lstAccessTokenConfig.add(AccessTokenConfig);
                    }
                }    
                else
                    errorState = True;
            }
            else if(AccessTokenConfig.Name=='SAEAPIAccessToken'){    
                StargateConTokenCheck= True;          
                System.debug('SAEAPIAccessToken='+SAEAPIAccessToken);
                if(SAEAPIAccessToken!= null && SAEAPIAccessToken!= ''){
                    if(SAEAPIAccessToken.contains('_expiry_')){
                        string[] splitVal = SAEAPIAccessToken.split('_expiry_');
                        AccessTokenConfig.Value__c = splitVal[0]; 
                        AccessTokenConfig.TokenExpiry__c   = integer.valueOf(splitVal[1]);
                        datetime dtim = datetime.now();
                        datetime dtim1 = dtim.addSeconds(integer.valueOf(splitVal[1]));
                        AccessTokenConfig.TokenExpiredBy__c   = dtim1;
                        lstAccessTokenConfig.add(AccessTokenConfig);
                    }
                }    
                else
                    errorState = True;
            }
            else if(AccessTokenConfig.Name=='OILAccessToken'){  //US2034021 : Tech -  Member ID Standalone Search Integration
                ISLConTokenCheck= True;              
                if(OILAccessToken!= null && OILAccessToken!=''){         
                    AccessTokenConfig.Value__c = OILAccessToken;
                    lstAccessTokenConfig.add(AccessTokenConfig);
                }    
                else
                    errorState = True;
            }
			else if(AccessTokenConfig.Name=='StargateJWTConAccessToken'){    
                StargateJWTConTokenCheck= True;          
                System.debug('StargateJWTAccesstoken='+StargateJWTAccesstoken);
                if(StargateJWTAccesstoken!= null && StargateJWTAccesstoken!= ''){
                    AccessTokenConfig.Value__c = StargateJWTAccesstoken;
                    lstAccessTokenConfig.add(AccessTokenConfig);
                }    
                else
                    errorState = True;
            }
            else if(AccessTokenConfig.Name=='StargateDashboardJWTConAccessToken'){    
                StargateDashboardJWTConTokenCheck= True;          
                System.debug('StargateDashboardJWTAccesstoken='+StargateDashboardJWTAccesstoken);
                if(StargateDashboardJWTAccesstoken!= null && StargateDashboardJWTAccesstoken!= ''){
                    AccessTokenConfig.Value__c = StargateDashboardJWTAccesstoken;
                    lstAccessTokenConfig.add(AccessTokenConfig);
                }    
                else
                    errorState = True;
            }
            
        } 
          if(lstAccessTokenConfig.size()>0){          
           Database.UpsertResult[] results= Database.upsert(lstAccessTokenConfig);
            if (results != null){
                for (Database.UpsertResult AccessTokenUR: results) {
                    if (!AccessTokenUR.isSuccess()) {
                        for(Database.Error DbError :AccessTokenUR.getErrors()) {
                            system.debug(LoggingLevel.INFO, 'Save Access Token Error. StatusCode: ' + DbError.getStatusCode() + ', Message: ' + DbError.getMessage());
                            errorState = True;
                        }
                    }
                    else {
                        system.debug(LoggingLevel.INFO, 'Access token saved successfully in custom setting');
                        
                    }
              }
              
           }
         }  
           System.debug('errorState='+errorState);
           
           //Added by Pravindra Khatri- 12/26
           //Scenario 1: Batch Notification to ACET Orion Team in case of only Webservice failure.
           If(errorState){
               //If Access Token is 'ISLConAccessToken' && received as Null/Empty, send a notification to Orion Team with the details.
               if(ISLConTokenCheck){   
                   if(OAuthaccesstoken== null) 
                       sendmail(toAddresses,'ACET Salesforce Access Token Batch Job Failure-'+formatted+' '+'CST','Token ISLConAccessToken is Null due to Webservice Failure at'+' '+formatted+' '+'CST');                     
                   else                    
                       sendmail(toAddresses,'ACET Salesforce Access Token Batch Job Failure-'+formatted+' '+'CST','Token ISLConAccessToken is Blank due to Webservice Failure at'+' '+formatted+' '+'CST');                     
               }
               //If Access Token is 'CISLConAccessToken' && received as Null/Empty, send a notification to Orion Team with the details.
               if(CISLConTokenCheck){               
                   if(CISLaccesstoken== null) 
                      sendmail(toAddresses,'ACET Salesforce Access Token Batch Job Failure-'+formatted+' '+'CST','Token CISLConAccessToken is Null due to Webservice Failure at'+' '+formatted+' '+'CST');                     
                   else
                      sendmail(toAddresses,'ACET Salesforce Access Token Batch Job Failure-'+formatted+' '+'CST','Token CISLConAccessToken is Blank due to Webservice Failure at'+' '+formatted+' '+'CST');                     
               }
           		//If Access Token is 'StargateConAccessToken' && received as Null/Empty, send a notification to Orion Team with the details.
               if(StargateConTokenCheck){               
                   if(Stargateaccesstoken== null) 
                      sendmail(toAddresses,'ACET Salesforce Access Token Batch Job Failure-'+formatted+' '+'CST','Token StargateConAccessToken is Null due to Webservice Failure at'+' '+formatted+' '+'CST');                     
                   else
                      sendmail(toAddresses,'ACET Salesforce Access Token Batch Job Failure-'+formatted+' '+'CST','Token StargateConAccessToken is Blank due to Webservice Failure at'+' '+formatted+' '+'CST');                     
               }
               //If Access Token is 'StargateORXConAccessToken' && received as Null/Empty, send a notification to Orion Team with the details.
               if(StargateORXConTokenCheck){               
                   if(StargateORXAccesstoken== null) 
                      sendmail(toAddresses,'ACET Salesforce Access Token Batch Job Failure-'+formatted+' '+'CST','Token StargateORXConAccessToken is Null due to Webservice Failure at'+' '+formatted+' '+'CST');                     
                   else
                      sendmail(toAddresses,'ACET Salesforce Access Token Batch Job Failure-'+formatted+' '+'CST','Token StargateORXConAccessToken is Blank due to Webservice Failure at'+' '+formatted+' '+'CST');                     
               }
			   if(StargateJWTConTokenCheck){               
                   if(StargateJWTAccesstoken== null) 
                      sendmail(toAddresses,'ACET Salesforce Access Token Batch Job Failure-'+formatted+' '+'CST','Token StargateJWTAccesstoken is Null due to Webservice Failure at'+' '+formatted+' '+'CST');                     
                   else
                      sendmail(toAddresses,'ACET Salesforce Access Token Batch Job Failure-'+formatted+' '+'CST','Token StargateJWTAccesstoken is Blank due to Webservice Failure at'+' '+formatted+' '+'CST');                     
               }
               if(StargateDashboardJWTConTokenCheck){               
                   if(StargateDashboardJWTAccesstoken== null) 
                      sendmail(toAddresses,'ACET Salesforce Access Token Batch Job Failure-'+formatted+' '+'CST','Token StargateDashboardJWTAccesstoken is Null due to Webservice Failure at'+' '+formatted+' '+'CST');                     
                   else
                      sendmail(toAddresses,'ACET Salesforce Access Token Batch Job Failure-'+formatted+' '+'CST','Token StargateDashboardJWTAccesstoken is Blank due to Webservice Failure at'+' '+formatted+' '+'CST');                     
               }
           }
    }    
    public void finish(Database.BatchableContext BC) {
        //Added by Abhinav for Stargate Migration from Layer 7
          ACETGetAccessTokenBatch.deleteAndScheduleAgain();
		  ACETGetAccessTokenBatch.deleteAndScheduleAgainStargateORX();
           ACETGetAccessTokenBatch.deleteAndScheduleAgainProdAuth();
        //Added by Pravindra Khatri- 12/26
        //Scenario 2: Batch Notification to ACET Orion Team in case of only Batch Apex Failure, not Webservice.
        String formatted = ACETUtility.format(Datetime.now());
        AsyncApexJob mainjob =[Select Id,status,numberoferrors,jobitemsprocessed,totaljobitems from AsyncApexJob WHERE Id =:BC.getJobId()];              
        if(mainjob.NumberOfErrors>0)
           sendmail(toAddresses,'ACET Salesforce Access Token Batch Job Failure-'+formatted+' '+'CST','The batch Apex got failed at'+' '+formatted+' '+'CST'+' '+'with'+' '+mainjob.NumberOfErrors+' '+'error(s).');                 
    }
    /*
     @Author : Pravindra Khatri
     @Date   : 12/26
     @Purpose: This method is used to send a notification alert to ACET Orion Team in case of webservice/Batch Failure(s).
    */    
    public static void sendmail(string[] toAddresses,string subject,string body){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
    }
    public static void deleteAndScheduleAgain(){
        system.debug('deleteAndScheduleAgain----------------');
        Map<String, ISL_Webservice_Config__c> WSConfigurations = ISL_Webservice_Config__c.getAll();
        string jobName = 'ACET Stargate Get Access Token Job';
        String conAccessTokenType = 'StargateConAccessToken';
  
        if (WSConfigurations.containsKey('StargateConAccessToken')){
                
            List<CronTrigger> ct = [select Id from CronTrigger WHERE CronJobDetail.Name =: jobName AND State != 'DELETED'];
            if (ct != null && !ct.isEmpty()){
                System.abortJob(ct[0].Id);
            }
            ISL_Webservice_Config__c cuSett = WSConfigurations.get(conAccessTokenType);
            if(cuSett.TokenExpiry__c != null){ 
                
                Integer expSec  = Integer.valueof(cuSett.TokenExpiry__c) ;
                string CronExpr = '';
                if(expSec < 60){
                    CronExpr = ''+expSec+' 0 * * * ?';
                }
                else{
                    integer minVal = (integer) expSec/60;
                    integer secVal = math.mod(expSec,60);
                    DATETIME curDt = system.now();
                    curDt = curDt.addminutes(minVal).addseconds(secVal);
                    CronExpr = ''+curDt.second()+' '+curDt.minute()+' * * * ?';
                }
                system.debug('!!!'+CronExpr);
                if(CronExpr != '' && ! test.isRunningTest())
                    System.schedule(jobName, CronExpr, new ACETGetAccessTokenScheduler());
            }
    }
    }
    
	   public static void deleteAndScheduleAgainStargateORX(){
        system.debug('deleteAndScheduleAgainStargateORX----------------');
        Map<String, ISL_Webservice_Config__c> WSConfigurations = ISL_Webservice_Config__c.getAll();
        string jobName = 'ACET Stargate ORX Get Access Token Job';
        String conAccessTokenType = 'StargateORXConAccessToken';
  
        if (WSConfigurations.containsKey('StargateORXConAccessToken')) {
         List<CronTrigger> ct = [select Id from CronTrigger WHERE CronJobDetail.Name =: jobName AND State != 'DELETED'];
            if (ct != null && !ct.isEmpty()){
                System.abortJob(ct[0].Id);
            }
            ISL_Webservice_Config__c cuSett = WSConfigurations.get(conAccessTokenType);
            if(cuSett.TokenExpiry__c != null){ 
                
                Integer expSec  = Integer.valueof(cuSett.TokenExpiry__c) ;
                string CronExpr = '';
                if(expSec < 60){
                    CronExpr = ''+expSec+' 0 * * * ?';
                }
                else{
                    integer minVal = (integer) expSec/60;
                    integer secVal = math.mod(expSec,60);
                    DATETIME curDt = system.now();
                    curDt = curDt.addminutes(minVal).addseconds(secVal);
                    CronExpr = ''+curDt.second()+' '+curDt.minute()+' * * * ?';
                }
                system.debug('!!!ORX'+CronExpr);
                if(CronExpr != '' && ! test.isRunningTest())
                    System.schedule(jobName, CronExpr, new ACETGetAccessTokenScheduler());
            }
        }
    }
	
       public static void deleteAndScheduleAgainProdAuth(){
        system.debug('deleteAndScheduleAgainSAE----------------');
        Map<String, ISL_Webservice_Config__c> WSConfigurations = ISL_Webservice_Config__c.getAll();
        string jobName = 'ACET Stargate Auth PROD Get Access Token Job';
        String conAccessTokenType = 'SAEAPIAccessToken';
  
        if (WSConfigurations.containsKey('SAEAPIAccessToken')) {
         List<CronTrigger> ct = [select Id from CronTrigger WHERE CronJobDetail.Name =: jobName AND State != 'DELETED'];
            if (ct != null && !ct.isEmpty()){
                System.abortJob(ct[0].Id);
            }
            ISL_Webservice_Config__c cuSett = WSConfigurations.get(conAccessTokenType);
            if(cuSett.TokenExpiry__c != null){ 
                
                Integer expSec  = Integer.valueof(cuSett.TokenExpiry__c) ;
                string CronExpr = '';
                if(expSec < 60){
                    CronExpr = ''+expSec+' 0 * * * ?';
                }
                else{
                    integer minVal = (integer) expSec/60;
                    integer secVal = math.mod(expSec,60);
                    DATETIME curDt = system.now();
                    curDt = curDt.addminutes(minVal).addseconds(secVal);
                    CronExpr = ''+curDt.second()+' '+curDt.minute()+' * * * ?';
                }
                system.debug('!!!SAE'+CronExpr);
                if(CronExpr != '' && ! test.isRunningTest())
                    System.schedule(jobName, CronExpr, new ACETGetAccessTokenScheduler());
            }
        }
    }
}