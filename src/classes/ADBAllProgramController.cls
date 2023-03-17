public without sharing class ADBAllProgramController {
    
    @AuraEnabled public static ADBMemberProgramsServiceResponseWrapper getMemberProgramsAPIDetails(String firstName, String lastName, String XrefId, String XrefPartitionId) {
        ADBMemberProgramsServiceResponseWrapper resp = new ADBMemberProgramsServiceResponseWrapper();
        try {
            resp = ADBMemberProgramsService.callMemberProgramsAPI(firstName, lastName, XrefId, XrefPartitionId);
        } catch(Exception ex) {
            System.debug('ERROR :ADBMemberProgramsService.callMemberProgramsAPI() : ' + ex.getMessage());
        }
        return resp;
    } 
    
    @AuraEnabled public static String submitAllProgramsDisposition(String programICUESSOURL,String nbastatus,String userId){
        system.debug('in ADBAllProgramsController::submitAllProgramsDisposition method::programICUESSOURL'+programICUESSOURL+'::nbastatus'+nbastatus);
        String mdfdDis = nbastatus;
        if(nbastatus == 'Accept'){
            mdfdDis = 'TellMeMore';
        }
        else if(nbastatus == 'Maybe_Later'){
            mdfdDis = 'MaybeLater';
        }
        else if(nbastatus == 'Decline'){
            mdfdDis = 'NoInterest';
        }
        else if(nbastatus == 'Not_Appropriate'){
            mdfdDis = 'RemoveOff';
        }
        String redirectUrl = ADBICUESSOUtilController.generateRedirectUrl( '', '', '', '',  '', userId, '', programICUESSOURL, mdfdDis, '');
        return redirectUrl; 
    }
}