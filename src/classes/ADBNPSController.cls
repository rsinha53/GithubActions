public without sharing class ADBNPSController {
    
    @AuraEnabled public static List<List<String>> callNPSService(String memberId){
        ADBNPSDetailsWrapper npsWrapper = new ADBNPSDetailsWrapper();
        List<ADBNPSDetailsWrapper> respWrapper = new List<ADBNPSDetailsWrapper>();
        List<ADBNPSDetailsWrapper> uiWrapper = new List<ADBNPSDetailsWrapper>();
        List<List<String>> iconData = new List<List<String>>();
        try{
            npsWrapper.memberId = memberId; 
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBNPSEndpoint', JSON.serialize(npsWrapper), null);
            HttpResponse response = wsCallOutFW.getResponse();
            //HttpResponse response = new HttpResponse();
            //StaticResource requestTemplate = [SELECT body FROM StaticResource WHERE Name = 'NPSMockResponse_44303237200'];
            //USPMembers //NPSMockResponse_34586091000 //NPSMockResponse_89717342600 //NPSMockResponse_44303237200 //NPSMockResponse_09727635200 //NPSMockResponse_82470805700
            //ACETDashboardMembers //NPSMockResponse //NPSMockResponse_909546670
            /*String strBody = requestTemplate.Body.toString();
            system.debug('strBody Auth service'+strBody);
            response.setBody(strBody);
            system.debug('response Auth service'+response);
            response.setStatusCode(200);*/
            if(response.getStatusCode() == 200 || response.getStatusCode() == 400) {
                respWrapper = (List<ADBNPSDetailsWrapper>) JSON.deserialize(response.getBody(), List<ADBNPSDetailsWrapper>.class);
                if(respWrapper!= null){
                    integer counter = 0;
                    for(counter = 0; counter < 3; counter++){
                        if(counter < respWrapper.size()){								 
                            DateTime d = Date.Today().adddays(-365);
                            String getLastYear =  d.format('yyyy');
                            String getLastDate =  d.format('MM/dd');
                            String iconDate = respWrapper[counter].callTimestamp;
                            String npsResult = respWrapper[counter].npsResult;
                            if(String.isBlank(npsResult)){
                                npsResult = 'NAN';
                            }
                            if(String.isNotBlank(iconDate)){
                                list<String> splitDate = iconDate.split('T');
                                list<String> lstSplitDate = splitDate[0].split('-');
                                String getIconYear = lstSplitDate[0];
                                String getIconMonthDate = lstSplitDate[1]+'/'+lstSplitDate[2];
                                String getIconDate = lstSplitDate[1]+'/'+lstSplitDate[2]+'/'+lstSplitDate[0];
                                if(getIconYear > getLastYear){
                                    uiWrapper.add(respWrapper[counter]);
                                    List<String> getIconDetail  = getNPSIcon(respWrapper[counter].npsResult);
                                    getIconDetail.add(getIconDate);
                                    getIconDetail.add(npsResult);
                                    iconData.add(getIconDetail);
                                }else if(getIconYear == getLastYear && getIconMonthDate > getLastDate){
                                    uiWrapper.add(respWrapper[counter]);
                                    List<String> getIconDetail  = getNPSIcon(respWrapper[counter].npsResult);
                                    getIconDetail.add(getIconDate);
                                    getIconDetail.add(npsResult);
                                    iconData.add(getIconDetail); 
                                }
                            }
                        }
                    }
                }
            }
            else{
                system.debug('NPS Service Response code && Response body if not 200 ::' + response.getStatusCode() +'-'+ response.getBody());
            }
        }catch(Exception e){
            system.debug('NPS Service Exception ::' + e.getMessage());
        }
        return iconData;
    }
    
    @AuraEnabled public static List<String> getNPSIcon(String score){
        List<String> iconData = new List<String>();
        String iconName;
        if(String.isBlank(score)){
            score = 'NAN';
        }
        try {
            List<ADBNPSIcon__mdt> icon = [SELECT IconName__c FROM ADBNPSIcon__mdt WHERE Label =: score];
            if(icon.size() > 0){
                iconName = icon[0].IconName__c;
                iconData.add(iconName);
                system.debug('@@iconName'+iconName);
            }
        }catch(Exception e){
            system.debug('ADBCallerProfileController.getNPSIcon Exception ::' + e.getMessage());
        }
        return iconData;
    }
}