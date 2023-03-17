public class SNI_FL_NotificationCenter2 {
    public static boolean isSubscribed = false;
    public static boolean phoneIdExists = false;
    
    public Static WebserviceConfigurations__c getWebConfigInfo(String sWebConfigName)
    {
        string qryStr = '%SMS%';
        WebserviceConfigurations__c webserviceConfigurations = [SELECT Id, Name, AuthorizationToken__c, EndpointPath__c, Headers__c, 
                                                       JSONBodyWithMergeFields__c, Method__c, Timeout__c, E400__c, E401__c, 
                                                       E500__c, TokenAPI__r.Name, TokenAPI__r.IsCachedToken__c, Handle_Unauthorized__c 
                                                       FROM WebserviceConfigurations__c Where Name=:sWebConfigName and active__c = true];
        
        System.debug('webserviceConfigurations==='+webserviceConfigurations);
        if( webserviceConfigurations != Null){
            return webserviceConfigurations;
        }else{
            
			Return null;            
        }
			
    }

    public  static String authenticate(){   
        String accessToken;
        String ServiceName = 'SMS Authorization';
        Http http = new Http();
        WebserviceConfigurations__c  configObj = getWebConfigInfo(ServiceName);
        System.debug('****configObj----'+configObj);
        Httprequest request = new Httprequest();
       if (configObj != null){
           if(configObj.Method__c != null)
	        request.setMethod(String.valueOf(configObj.Method__c));
           if(configObj.EndpointPath__c !=null)
	        request.setEndpoint(String.valueOf(configObj.EndpointPath__c));
           if(configObj.JSONBodyWithMergeFields__c != null)
	        request.setBody(String.valueOf(configObj.JSONBodyWithMergeFields__c));
	        request.setHeader('Content-Type','application/x-www-form-urlencoded');
	        request.setHeader('Accept','application/json');
	    }
        system.debug('request is** ' + request);
        HttpResponse response = http.send(request);        
        System.debug('response.getStatusCode()==='+response.getStatusCode()+'===response.getBody()====>'+response.getBody());
        // If the request is successful,parse the JSON response.
        if (response.getStatusCode() == 200)
        {
            // Deserialize the JSON string into collections of primitive data types.
            Map<String, Object> result =(Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('>>>>>'+response.getBody());
            System.debug('>>>>>'+result.get('access_token'));
            accessToken=(String)result.get('access_token');
        }
        System.debug('$$$$authenticate$$$$');
        return accessToken;
      }
	
    
    public static String generatePhoneId(String accessToken,String sPhoneNo){ 
        String returnValue;
        try
        {
        System.debug('inside phoneid'+'=='+sPhoneNo);
        //String accToken= authenticate();
        Http http = new Http();
        String prodAcc = System.Label.Access_SMS_PROD_ProgramID;
        WebserviceConfigurations__c  configObj = getWebConfigInfo('SMS GeneratePhoneId');
        System.debug('***configObj ---'+configObj );
        Httprequest request = new Httprequest ();
        if(configObj != null){
            if(configObj.EndpointPath__c != null)
            request.setEndpoint(String.valueOf(configObj.EndpointPath__c));          
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Accept', 'application/json');
            request.setHeader('Authorization', 'Bearer '+accessToken);
            if(configObj.Method__c != null )
            request.setMethod(String.valueOf(configObj.Method__c));
        }
        string phoneno;
        if(prodAcc =='YES' && !sPhoneNo.contains('+1')){ 
            sPhoneNo='+1'+sPhoneNo;
        }else if(prodAcc =='NO'){
            if(sPhoneNo == null){
                PhoneNo = System.Label.Phone_No_for_SMS_Testing;
            	sPhoneNo = PhoneNo;
            }
            
            if(!sPhoneNo.contains('+91')){  
                sPhoneNo = '+91'+sPhoneNo;
            }
         }
        If(prodAcc == 'NO'){
            request.setBody('{\n\"number\": \"'+sPhoneNo+'\",\n \"country-code\": \"IN\"\n}');
        }else if(prodAcc == 'YES'){
            request.setBody('{\n\"number\": \"'+sPhoneNo+'\",\n \"country-code\": \"US\"\n}');
        }
        HttpResponse response = http.send(request);
        
        System.debug('$$$$Genarate Phone Id call$$$$');
       System.debug('response.getStatusCode()==='+response.getStatusCode()+'====>'+response.getBody());
        // If the request is successful,parse the JSON response.
        Map<String, Object> result =(Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        if (response.getStatusCode() == 200){
            // Deserialize the JSON string into collections of primitive data types.
            //result =(Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('>>>>>'+response.getBody());
            returnValue=String.valueOf(result.get('id'));
            phoneIdExists = false;
        }else if(response.getStatusCode() == 422 && String.valueOf(result.get('message'))=='Could not create Phone'){
            String sprogramId = '';
            if(prodAcc != null && prodAcc == 'YES'){
                sprogramId = System.Label.PROD_SMS_ProgramID;
            }else if(prodAcc == 'NO'){
                sprogramId = System.Label.NONPROD_SMS_ProgramID;
            }
            returnValue = getPhoneIdValue(accessToken,sPhoneNo);
            phoneIdExists = true;
            getSubscriptionStatus(accessToken,returnValue,sprogramId);   
        }
        }
        catch(CalloutException ce)
        {
            System.debug('exception in getphoneId=='+ce.getMessage());
        }
        return returnValue;
    }

     public static String getPhoneIdValue(String accessToken,String PhoneNo){ 
        
        System.debug('inside phone Number'+'=='+PhoneNo);
        //String accToken= authenticate();
        Http http = new Http();
        WebserviceConfigurations__c  configObj = getWebConfigInfo('SMS getPhoneIdValue');
        System.debug('***configObj ---'+configObj );
        Httprequest request = new Httprequest ();
         if(configObj != null){
            String sEndPointUrl;
            if(configObj.EndpointPath__c != null)
            	sEndPointUrl=configObj.EndpointPath__c;
            string sPhoneNo;
            String prodAcc = System.Label.Access_SMS_PROD_ProgramID;
            if(prodAcc =='YES' && !PhoneNo.contains('+1')){
                PhoneNo='+1'+PhoneNo;
            }else if(prodAcc =='NO'){
                if(PhoneNo == null){
                   sPhoneNo = System.Label.Phone_No_for_SMS_Testing;
                   phoneno = sPhoneNo; 
                }
                if(!phoneno.contains('+91')){
                    phoneno = '+91'+phoneno;
                }
             } 
            System.debug('****sEndPointUrl---'+sEndPointUrl);
            if(sEndPointUrl != null)
            	request.setEndpoint(sEndPointUrl+PhoneNo);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Accept', 'application/json');
            request.setHeader('Authorization', 'Bearer '+accessToken);
            if(configObj.Method__c != null)
            	request.setMethod(String.valueOf(configObj.Method__c));
         }
        HttpResponse response = http.send(request);
        String returnValue;
        System.debug('$$$$GetPhoneId call$$$$');
       System.debug('response.getStatusCode()==='+response.getStatusCode()+'====>'+response.getBody());
        // If the request is successful,parse the JSON response.
        if (response.getStatusCode() == 200)
        {
            // Deserialize the JSON string into collections of primitive data types.
            Map<String, Object> result =(Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('>>>>>'+response.getBody());
            if(result.get('phone') != null){
            list<Object> phoneAttributes = (list<Object>) result.get('phone');
            map<String,Object> idAttribute = (map<String,Object>) phoneAttributes[0];
             returnValue = String.valueOf(idAttribute.get('id'));
            }
            system.debug('***returnValue--'+returnValue);
            //returnValue=String.valueOf(result.get('id'));
            
            
        }
        System.debug('>>>>>returnValue---'+returnValue); 
        return returnValue;
    }
    
   public static String subscribePhoneID(String accessToken,String phoneId)
    {   
        System.debug('inside subscribeid ');
        Http http = new Http();
        WebserviceConfigurations__c  configObj = getWebConfigInfo('SMS subscribePhoneID');
        //String accToken= authenticate();
        System.debug('*****configObj---'+configObj);
        String prodAcc = System.Label.Access_SMS_PROD_ProgramID;
        String sprogramId = '';
        if(prodAcc != null && prodAcc == 'YES'){
            sprogramId = System.Label.PROD_SMS_ProgramID;
        }else if(prodAcc == 'NO'){
            sprogramId = System.Label.NONPROD_SMS_ProgramID;
        }
        Httprequest request = new Httprequest();
        if(configObj != null){
            String sEndPointUrl;
            if(configObj.EndpointPath__c != null){
            	sEndPointUrl=(String)configObj.EndpointPath__c+'/'+phoneId+'/subscribe';
            	request.setEndpoint(sEndPointUrl);
        	}
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Accept', 'application/json');
            request.setHeader('Authorization', 'Bearer '+accessToken);
            request.setBody('{\n\"program-id\":\"'+sprogramId+'\"\n}');
        	if(configObj.Method__c != null)
            	request.setMethod(String.valueOf(configObj.Method__c));
        }
        HttpResponse response = http.send(request);
        System.debug('$$$$subscribePhoneID Call$$$$');
        String returnValue;
        System.debug('response.getStatusCode()==='+response.getStatusCode()+'==response.getBody()=='+response.getBody());
         System.debug('response.getStatus()==='+response.getStatus());
        // If the request is successful,parse the JSON response.
        if (response.getStatusCode() == 200)
        {
            // Deserialize the JSON string into collections of primitive data types.
            Map<String, Object> result =(Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('>>>>>'+response.getBody());
            returnValue=String.valueOf(response.getStatusCode());
        }
        return returnValue;
    }
    
     public static boolean getSubscriptionStatus(String accessToken,String phoneId,String programId){   
        System.debug('inside getSubscriptionStatus ');
        Http http = new Http();
        WebserviceConfigurations__c  configObj = getWebConfigInfo('SMS getSubscriptionStatus');
        System.debug('*****configObj---'+configObj);
        Httprequest request = new Httprequest();
        if(configObj != null){
            String sEndPointUrl;
            if(configObj.EndpointPath__c != null){
                //https://ocp.optum.com/smsmgrstage/v1/subscriptions?program-id=507273&phone-id=2201397&page=1&per-page=250&sort-by=created-at&sort-order=des
            	sEndPointUrl=(String)configObj.EndpointPath__c+'program-id='+programId+'&phone-id='+phoneId+'&page=1&per-page=250&sort-by=created-at&sort-order=desc';
            	request.setEndpoint(sEndPointUrl);
        	}
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Accept', 'application/json');
            request.setHeader('Authorization', 'Bearer '+accessToken);
            if(configObj.Method__c != null){
            	request.setMethod(String.valueOf(configObj.Method__c));
            }
        }
        HttpResponse response = http.send(request);
        System.debug('$$$$getSubscriptionStatus Call$$$$');
        System.debug('response.getStatusCode()==='+response.getStatusCode()+'==response.getBody()=='+response.getBody());
        System.debug('response.getStatus()==='+response.getStatus());
        // If the request is successful,parse the JSON response.
        if (response.getStatusCode() == 200){
            // Deserialize the JSON string into collections of primitive data types.
            Map<String, Object> result =(Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('>>>>>'+response.getBody());
            System.debug('>>>>>subscitipon status'+result);
            List<Object> subscriptionData = (list<Object>) result.get('subscription');
			map<String,Object> subValue = (map<String,Object>) subscriptionData[0];
            isSubscribed = String.valueOf(subValue.get('status')).trim() == 'subscribed'?true:false;
            system.debug('subscription value == ' + isSubscribed);
        }
        return isSubscribed;
    }
    
    
 @future(callout=true)
 public static void subscribePhoneIDUI(String phoneno)
    {   
        System.debug('inside subscribeid ');
        Http http = new Http();
        WebserviceConfigurations__c  configObj = getWebConfigInfo('SMS subscribePhoneID');
        String accToken= authenticate();
        String phoneidval =  generatePhoneId(accToken,phoneno);
        if(phoneidval != null && !isSubscribed){
             System.debug('*****configObj---'+configObj);
                String prodAcc = System.Label.Access_SMS_PROD_ProgramID;
                String sprogramId = '';
                if(prodAcc != null && prodAcc == 'YES'){
                    sprogramId = System.Label.PROD_SMS_ProgramID;
                }else if(prodAcc == 'NO'){
                    sprogramId = System.Label.NONPROD_SMS_ProgramID;
                }
                Httprequest request = new Httprequest();
                if(configObj != null){
                    String sEndPointUrl;
                    if(configObj.EndpointPath__c != null){
                        sEndPointUrl=(String)configObj.EndpointPath__c+'/'+phoneidval+'/subscribe';
                        request.setEndpoint(sEndPointUrl);
                    }
                    request.setHeader('Content-Type', 'application/json');
                    request.setHeader('Accept', 'application/json');
                    request.setHeader('Authorization', 'Bearer '+accToken);
                    request.setBody('{\n\"program-id\":\"'+sprogramId+'\"\n}');
                    if(configObj.Method__c != null)
                        request.setMethod(String.valueOf(configObj.Method__c));
                }
                HttpResponse response = http.send(request);
                System.debug('$$$$subscribePhoneID Call$$$$');
                String returnValue;
                System.debug('response.getStatusCode()==='+response.getStatusCode()+'==response.getBody()=='+response.getBody());
                 System.debug('response.getStatus()==='+response.getStatus());
                // If the request is successful,parse the JSON response.
                    
           }
        
       
        
    }
    
 @future(callout=true)
 public static void UnsubscribePhoneID(String PhoneNo)
 {   
        System.debug('inside Un subscribeid ');
        Http http = new Http();
        WebserviceConfigurations__c  configObj = getWebConfigInfo('SMS UnsubscribePhoneID');
        String accToken= authenticate();
        String phoneidval =  generatePhoneId(accToken,PhoneNo);
        if(isSubscribed ){
		System.debug('*****configObj---'+configObj);
		        String prodAcc = System.Label.Access_SMS_PROD_ProgramID;
		        String sprogramId = '';
		        if(prodAcc != null && prodAcc == 'YES'){
		            sprogramId = System.Label.PROD_SMS_ProgramID;
		        }else if(prodAcc == 'NO'){
		            sprogramId = System.Label.NONPROD_SMS_ProgramID;
		        }
                string sPhoneNo;
                if(prodAcc =='YES' && !PhoneNo.contains('+1')){
                    PhoneNo='+1'+PhoneNo;
                }else if(prodAcc =='NO'){
                    if(PhoneNo == null){
                       sPhoneNo = System.Label.Phone_No_for_SMS_Testing;
                       phoneno = sPhoneNo; 
                    }
                    if(!phoneno.contains('+91')){
                        phoneno = '+91'+phoneno;
                    }
                 } 
		        Httprequest request = new Httprequest();
		
		        if(configObj != null){
		            String sEndPointUrl;
		            if(configObj.EndpointPath__c != null){
		            	sEndPointUrl=(String)configObj.EndpointPath__c+'/'+phoneno+'/unsubscribe';
		            	request.setEndpoint(sEndPointUrl);
		        	}
		            request.setHeader('Content-Type', 'application/json');
		            request.setHeader('Accept', 'application/json');
		            request.setHeader('Authorization', 'Bearer '+accToken);
		            request.setBody('{\n\"program-id\":\"'+sprogramId+'\"\n}');
		        	if(configObj.Method__c != null)
		            	request.setMethod(String.valueOf(configObj.Method__c));
		        }
		        HttpResponse response = http.send(request);
		        System.debug('$$$$subscribePhoneID Call$$$$');
		        String returnValue;
		        System.debug('response.getStatusCode()==='+response.getStatusCode()+'==response.getBody()=='+response.getBody());
		         System.debug('response.getStatus()==='+response.getStatus());
		        
			}
	
   }


    
    
	public static String sendSMS(String sPhoneNo, String sMessage){
        
        String accessToken=authenticate();
        Boolean SendSMS = false;
        String returnValue;
        String sPhoneid;
        if(accessToken != null){
            sPhoneid= generatePhoneId(accessToken,sPhoneNo);
            if(sPhoneid != null){
                String sStatus = subscribePhoneID(accessToken,sPhoneid);
                system.debug('***' + sStatus + phoneIdExists + isSubscribed);
                if((sStatus != null && sStatus == '200' && !phoneIdExists) || (phoneIdExists == true && isSubscribed == true)){
                    SendSMS = true;
                }
                /*if(sStatus != null && sStatus == '200'){
                    SendSMS = true;
                }*/
            }
        }
        System.debug('****SendSMS---'+SendSMS);
        if(SendSMS){
            System.debug('after authenticate');
            //String sProgramId=System.Label.ProgramId;
            String prodAcc = System.Label.Access_SMS_PROD_ProgramID;
            String sProgramId = '';
            if(prodAcc != null && prodAcc == 'YES'){
                sProgramId = System.Label.PROD_SMS_ProgramID;
            }else if(prodAcc == 'NO'){
                sProgramId = System.Label.NONPROD_SMS_ProgramID;
            }
            //String iPhoneid= '2201624';
            Http http = new Http();
            WebserviceConfigurations__c  configObj = getWebConfigInfo('SMS Notification');
            System.debug('*****configObj ---'+configObj);
            Httprequest request = new Httprequest ();
            String sEndPointUrl= (String)configObj.EndpointPath__c;//'https://ocp.optum.com/smsmgrstage/v1/programs/';
            String sUrl= sEndPointUrl+sProgramId+'/phones/'+sPhoneId+'/outbound-messages';
            System.debug('sUrl==='+sUrl);
            request.setEndpoint(sUrl);
            
            request.setMethod(String.valueOf(configObj.Method__c));
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Accept', 'application/json');
            request.setHeader('Authorization', 'Bearer '+accessToken);
            request.setBody('{"body": "'+sMessage+'"}' );
            HttpResponse response = http.send(request);
            
            System.debug('response.getStatusCode() from sendsms==='+response.getStatusCode()+'===='+response.getBody());
            // If the request is successful,parse the JSON response.
            if (response.getStatusCode() == 200){
            
                // Deserialize the JSON string into collections of primitive data types.
                Map<String, Object> result =(Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                System.debug('$$$$ SendSMS Call$$$$');
                returnValue = 'Success';
                System.debug('>>from sms method>>>'+response.getBody());
            }
            else{
                returnValue = 'Failure';
            }
         }
        return returnValue;
    }      
    
 /*
    //@future(callout=true)
    public static String sendSMS(String sPhoneNo){   
        String accessToken=authenticate();
        Boolean SendSMS = false;
        String returnValue;
        if(accessToken != null){
            String sPhoneid= generatePhoneId(accessToken,sPhoneNo);
            if(sPhoneid != null){
                String sStatus = subscribePhoneID(accessToken,sPhoneid);
                if(sStatus != null && sStatus == '200'){
                    SendSMS = true;
                }
            }
        }
        System.debug('****SendSMS---'+SendSMS);
        if(SendSMS){
            System.debug('after authenticate');
            //String sProgramId=System.Label.ProgramId;
            String prodAcc = System.Label.Access_SMS_PROD_ProgramID;
            String sProgramId = '';
            if(prodAcc != null && prodAcc == 'YES'){
                sProgramId = System.Label.PROD_SMS_ProgramID;
            }else if(prodAcc == 'NO'){
                sProgramId = System.Label.NONPROD_SMS_ProgramID;
            }
            String iPhoneid= '2201624';
            Http http = new Http();
            WebserviceConfigurations__c  configObj = getWebConfigInfo('SMS Notification');
            System.debug('*****configObj ---'+configObj);
            Httprequest request = new Httprequest ();
            String sEndPointUrl= (String)configObj.EndpointPath__c;//'https://ocp.optum.com/smsmgrstage/v1/programs/';
            String sUrl= sEndPointUrl+sProgramId+'/phones/'+iPhoneId+'/outbound-messages';
            System.debug('sUrl==='+sUrl);
            request.setEndpoint(sUrl);
            
            request.setMethod(String.valueOf(configObj.Method__c));
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Accept', 'application/json');
            request.setHeader('Authorization', 'Bearer '+accessToken);
            request.setBody('{"body": "This is message from CHN"}' );
            HttpResponse response = http.send(request);
            
            System.debug('response.getStatusCode() from sendsms==='+response.getStatusCode()+'===='+response.getBody());
            // If the request is successful,parse the JSON response.
            if (response.getStatusCode() == 200){
            
                // Deserialize the JSON string into collections of primitive data types.
                Map<String, Object> result =(Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                System.debug('$$$$ SendSMS Call$$$$');
                returnValue = 'Success';
                System.debug('>>from sms method>>>'+response.getBody());
            }
            else{
                returnValue = 'Failure';
            }
         }
        return returnValue;
    }*/

  
    

}