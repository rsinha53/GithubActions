public with sharing class ACETWebserviceHelper {
  /*  public static ACETMemberDetail queryIndividuals(ACETMemberDetail MemberDetail){ 
        if(MemberDetail == null){
            MemberDetail = new ACETMemberDetail(); 
        }
        String Id = ApexPages.currentPage().getParameters().get('Id');
        MemberDetail.SurrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        system.debug(' ACETWebserviceHelper :queryIndividuals : MemberDetail.SurrogateKey '+MemberDetail.SurrogateKey);     
        if(!String.isEmpty(MemberDetail.SurrogateKey) && MemberDetail.SurrogateKey != 'undefined'){
            system.debug('For Adaptar');
            ACETGetIndividualWebService stub = new ACETGetIndividualWebService();
            ACETWSCalloutResult calloutResult = stub.getIndividual(MemberDetail.SurrogateKey, MemberDetail);     
        } 
        else {
            system.debug('For Bravo');
            MemberDetail.SurrogateKey = '';
            ACETGetIndividualWebService stub = new ACETGetIndividualWebService();
            ACETWSCalloutResult calloutResult = stub.getIndividual(Id, MemberDetail);
        }
        return memberDetail; 
    }
    
    public static ACETMemberDetail queryMembership(ACETMemberDetail MemberDetail){
        if(MemberDetail == null){
            MemberDetail = new ACETMemberDetail(); 
        }       
        String Id = ApexPages.currentPage().getParameters().get('Id');
        MemberDetail.SurrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        system.debug(' ACETWebserviceHelper :queryMembership : MemberDetail.SurrogateKey '+MemberDetail.SurrogateKey); 
        if(!String.isEmpty(MemberDetail.SurrogateKey) && MemberDetail.SurrogateKey != 'undefined'){
            //call findMembership service first                
            ACETfindMembershipWebService stub = new ACETfindMembershipWebService();
            ACETWSCalloutResult calloutResult = stub.findMembership(MemberDetail.SurrogateKey, MemberDetail); 
            //some fields for coverage lines depends on getMembership service
            if(MemberDetail.PreferredCoverage != null){
                ACETGetMembershipWebService stub2 = new ACETGetMembershipWebService();
                ACETWSCalloutResult calloutResult2 = stub2.getMembership(MemberDetail.SurrogateKey,MemberDetail.PreferredCoverage.groupNumber,MemberDetail);
            }         
        } 
        else{
            MemberDetail.SurrogateKey = '';
             //call findMembership service first                
            ACETfindMembershipWebService stub = new ACETfindMembershipWebService();
            ACETWSCalloutResult calloutResult = stub.findMembership(Id, MemberDetail); 
                      
            //some fields for coverage lines depends on getMembership service         
            ACETGetMembershipWebService stub2 = new ACETGetMembershipWebService();
            ACETWSCalloutResult calloutResult2 = stub2.getMembership(Id,'',MemberDetail); 
            //system.debug('**calloutResult.Response**' + calloutResult.Response );     
        } 
        return memberDetail;  
    }
    
    public static Object callMemberServices(){
        Map<String,String> serviceRequestLabels = new Map<String,String>();
        Continuation PageLoadContinuation;
            ACETMemberDetail MemberDetail = new ACETMemberDetail(); 
            //GetIndividual webservice callout
            ACETGetIndividualWebService ACETGetIndWebservice = new ACETGetIndividualWebService();
            PageLoadContinuation = ACETGetIndWebservice.StartRequest(MemberDetail.SurrogateKey, MemberDetail,'memberServicesCallback',null);  
            serviceRequestLabels.put('GetIndividualService',ACETGetIndWebservice.RequestLabel);
            
            //FindMembership webservice callout
            ACETFindMembershipWebservice ACETFindMemWebservice = new ACETFindMembershipWebservice();
            PageLoadContinuation = ACETFindMemWebservice.StartRequest(MemberDetail.SurrogateKey, MemberDetail,'memberServicesCallback',PageLoadContinuation); 
            serviceRequestLabels.put('FindMembershipService',ACETFindMemWebservice.RequestLabel);
            
             //GetFamilyMembership webservice callout
            ACETGetFamilyMemberWebService ACETGetFamMemWebservice = new ACETGetFamilyMemberWebService();
            PageLoadContinuation = ACETGetFamMemWebservice.StartRequest('11801753', MemberDetail,'memberServicesCallback',PageLoadContinuation);
            serviceRequestLabels.put('GetFamilyMembershipService',ACETGetFamMemWebservice.RequestLabel);            
         
          return PageLoadContinuation; 
    }
    public static PageReference memberServicesCallback(){
        return null;
    }*/
    
    public static String formatDateWithTime(String dateTimeString){
        if(dateTimeString == null){
            return null;
        }
        List<String> dateParts = dateTimeString.split('T');
        String dateWithSlash = formatDateFromDashToSlash(dateParts[0]);
        //sample datetime 2019-10-11T15:28:26.000Z -> 10/11/2019 3:28 PM
        List<String> timeParts = dateParts[1].split(':');
        integer hour = integer.valueOf(timeParts[0]);
        String AMPM = '';
        if(hour>12){
            AMPM = 'PM';
            hour = hour - 12;
        }
        else{
            AMPM = 'AM';
        }
        String minute = timeParts[1];
        
        String fullDateTime = '' + dateWithSlash + ' ' + hour + ':' + minute + ' ' + AMPM;
        return fullDateTime;
        
    }
    
    public static String formatDatetimeFromDashToSlash(String datetimeString){
        if(datetimeString == null) return null;
        
        List<String> dateParts = datetimeString.split('T');
        
        String result = formatDateFromDashToSlash(dateParts[0]);  
        if(dateParts.size() > 1){           
            result = result + ' ' + dateParts[1].split('\\.')[0];   
        }
        
        return result;
    }
    
    public static String formatDateFromDashToSlash(String dateString){
        if(dateString == null) return null;
        
        List<String> dateParts = dateString.split('T')[0].split('-');
        if(dateParts.size() == 3){
            String mm = dateParts[1];
            String dd = dateParts[2];
            String yyyy = dateParts[0];
            
            mm = mm.contains('0') && mm.indexOf('0') == 0 ? mm.replace('0','') : mm ; 
            dd = dd.contains('0') && dd.indexOf('0') == 0 ? dd.replace('0','') : dd; 
                                   
            return mm  + '/' + dd + '/' + yyyy;
        }else{
            return dateString;
        }
    }
    
        public static String formatToYYYYMMDD(String dateWithSlash){
        if(dateWithSlash != null && !string.isBlank(dateWithSlash)){
        List<String> dateList = dateWithSlash.split('/');
        String temp = dateList[2];//2003
        dateList[2] = dateList[1];//02
        dateList[1] = dateList[0];
        dateList[0] = temp;

        String strMonth = dateList[1];
        String strDate = dateList[2];
        
        if(strMonth.length() == 1){
            strMonth = ('0' + strMonth);
        }

        if(strDate.length() == 1){
            strDate = ('0' + strDate);
        }

        dateList[1] = strMonth;
        dateList[2] = strDate;

        String dateWithDash = dateList[0] +'-'+dateList[1] + '-' + dateList[2];
        return dateWithDash; 
        }else{
        return null;
        }
    }

    public static String getErrorMessageFromCode(Integer errorCode){
        String errorMessage;
        if(errorCode == 500){
            //errorMessage = 'System Unavailable.';
            errorMessage=Label.ACETUnexpectedErrorMessage;
        }else {//for 400 and 404
            errorMessage = 'Membership is not found in Cirrus based on the subscriber ID.';
        }
        return errorMessage;
    }
}