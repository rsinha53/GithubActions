public class ADBRepeatCallController {
@AuraEnabled
    public static ADBRepeatCallUIWrapper getRepeatCallerInfo(String reqBody){
        ADBRepeatCallerWrapper r = new ADBRepeatCallerWrapper();
        ADBRepeatCallUIWrapper uw = new ADBRepeatCallUIWrapper();
        try{
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBRepeatCallerEndpoint',reqBody,null);
            HttpResponse res = wsCallOutFW.getResponse();
           
            /*HttpResponse res = new HttpResponse();
            StaticResource requestTemplate = [SELECT body FROM StaticResource WHERE Name = 'ADBRepeatCallerMock'];
            String strBody = requestTemplate.Body.toString();
            system.debug('strBody Repeat service'+strBody);
            res.setBody(strBody);
            system.debug('response Repeat service'+res);
            res.setStatusCode(200);*/
            
            if(res.getStatusCode() == 200){
                r = (ADBRepeatCallerWrapper)JSON.deserialize(res.getBody(), ADBRepeatCallerWrapper.class);
                System.debug('flow repeat : ' + r.gateResult);
                if(r != null && r.gateResult!=null && r.gateResult.responseCode == 0 && r.gateResult.responseObject!=null &&
                  r.gateResult.responseObject.repeatCaller!=null && r.gateResult.responseObject.repeatCaller!=null){
                      System.debug('call description : ' + r.gateResult.responseObject.repeatCaller.description);
                      String description = r.gateResult.responseObject.repeatCaller.description;
                      Integer count = r.gateResult.responseObject.repeatCaller.count;
                      if(String.isNotBlank(description)){
                          if(description.contains('-')){
                            list<String> desSplitValue = description.split('-');
                            uw.description = desSplitValue[1];
                          }else{
                              uw.description = description;
                          }   
                      }
                      uw.count = count;
                }
            }
        }catch(Exception e){
            System.debug('ERROR at ADBRepeatCallController.getRepeatCallerInfo : ' + e.getMessage());
        }
        return uw;
    }
}