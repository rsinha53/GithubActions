/*
    Created By: Ravi kishore
    Created Date: 6th augJuly 2019
    Description: This class is used to refresh the access token for SNIApi and send notification if it fails.
*/

public class ACETGetSNIApiAccessTokenBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    final String[] toAddresses = new String[]{'kalpa.b.alawatta@optum.com','chaminda.dharmatilake@optum.com','kumar_manish3@optum.com','matthew.mittereder@optum.com','nalin.perera@optum.com','dinkar_singh_rathore@optum.com'};
   
    public list<ISL_Webservice_Config__c> start(Database.BatchableContext BC){
		
		list<ISL_Webservice_Config__c> lstISLWebConfig = new list<ISL_Webservice_Config__c>();
		Map<String, ISL_Webservice_Config__c> WSConfigurations = ISL_Webservice_Config__c.getAll();
		ISL_Webservice_Config__c newCustomSetting;
		if (! WSConfigurations.containsKey('SNIAPIAccessToken')) {
            newCustomSetting = new ISL_Webservice_Config__c();
            newCustomSetting.Name = 'SNIAPIAccessToken';
            newCustomSetting.Value__c = '';
			newCustomSetting.ACET_Common_Name__c = 'SNIApiEndpoint';
        }
		else{
		   newCustomSetting = WSConfigurations.get('SNIAPIAccessToken');    
		}
		lstISLWebConfig.add(newCustomSetting);
		return lstISLWebConfig;
	}
    public void execute(Database.BatchableContext BC, list<ISL_Webservice_Config__c> scope) {
        Boolean errorState,ISLConTokenCheck; 
	    // Boolean errorState; 
		//String formatted = Datetime.now().format();
		String formatted = ACETUtility.format(Datetime.now()); // US3705586 : Madushani : ICU Date Format Changes.
        errorState= ISLConTokenCheck = False;
		ACETSNIApiOAuthWebservice OAuthWS = new ACETSNIApiOAuthWebservice();
        String OAuthaccesstoken = OAuthWS.getAccessToken();
        system.debug('accesstoken------'+OAuthaccesstoken);
        
		List<ISL_Webservice_Config__c> lstISLWebServ = new List<ISL_Webservice_Config__c>();
        for(ISL_Webservice_Config__c rec: scope){
            ISL_Webservice_Config__c tokenObj = rec;
            if(tokenObj.Name == 'SNIAPIAccessToken'){
                ISLConTokenCheck= True;  
                if(OAuthaccesstoken!= null && OAuthaccesstoken!=''){ 
                    if(OAuthaccesstoken.contains('_expiry_')){
                        string[] splitVal = OAuthaccesstoken.split('_expiry_');
                        tokenObj.Value__c = splitVal[0]; // OAuthaccesstoken;
                        tokenObj.TokenExpiry__c	 = integer.valueOf(splitVal[1]);
                        // tknExp  = integer.valueOf(splitVal[1]);
                         datetime dtim = datetime.now();
                         datetime dtim1 = dtim.addSeconds(integer.valueOf(splitVal[1]));
                         tokenObj.TokenExpiredBy__c	 = dtim1;
                        
                        system.debug('TokenExpiry----------------'+tokenObj.TokenExpiry__c);
                        lstISLWebServ.add(tokenObj);
                    }
                    
                } else
                    errorState = True;
            }
        }
		
		if(lstISLWebServ.size()>0){          
           Database.UpsertResult[] results= Database.upsert(lstISLWebServ);
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
        
        If(errorState){
            //If Access Token is 'SNIAPIAccessToken' && received as Null/Empty, send a notification with the details.
               if(ISLConTokenCheck){   
                   if(OAuthaccesstoken== null) 
                       sendmail(toAddresses,'ACET Salesforce Access Token Batch Job Failure-'+formatted+' '+'CST','Token SNIAPIAccessToken is Null due to Webservice Failure at'+' '+formatted+' '+'CST');                     
                   else                    
                       sendmail(toAddresses,'ACET Salesforce Access Token Batch Job Failure-'+formatted+' '+'CST','Token SNIAPIAccessToken is Blank due to Webservice Failure at'+' '+formatted+' '+'CST');                     
               }
        }
    }
      
    public void finish(Database.BatchableContext BC) {
        
         ACETGetSNIApiAccessTokenBatch.deleteAndScheduleAgain();
         //String formatted = Datetime.now().format();
         String formatted = ACETUtility.format(Datetime.now()); // US3705586 : Madushani : ICU Date Format Changes.
         AsyncApexJob mainjob =[Select Id,status,numberoferrors,jobitemsprocessed,totaljobitems from AsyncApexJob WHERE Id =:BC.getJobId()];              
         if(mainjob.NumberOfErrors>0)
           sendmail(toAddresses,'ACET Salesforce Access Token Batch Job Failure-'+formatted+' '+'CST','The batch Apex got failed at'+' '+formatted+' '+'CST'+' '+'with'+' '+mainjob.NumberOfErrors+' '+'error(s).');                 
    }

    public static void deleteAndScheduleAgain(){
        system.debug('deleteAndScheduleAgain----------------');
        string jobName = 'SNI API Access Token';
        List<CronTrigger> ct = [select Id from CronTrigger WHERE CronJobDetail.Name =: jobName AND State != 'DELETED'];
        if (ct != null && !ct.isEmpty()){
           System.abortJob(ct[0].Id);
        }
       
         Map<String, ISL_Webservice_Config__c> WSConfigurations = ISL_Webservice_Config__c.getAll();
        
          if (WSConfigurations.containsKey('SNIAPIAccessToken')) {
           
           ISL_Webservice_Config__c cuSett = WSConfigurations.get('SNIAPIAccessToken');
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
         //system.debug('deleteAndScheduleAgain--------------122--');
         if(CronExpr != '' && ! test.isRunningTest())
            System.schedule(jobName, CronExpr, new ACETGetSNIAPIAccessTokenScheduler());
        }
        }
    }        
    public static void sendmail(string[] toAddresses,string subject,string body){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        // Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
    }
}