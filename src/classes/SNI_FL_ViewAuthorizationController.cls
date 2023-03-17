public without sharing class SNI_FL_ViewAuthorizationController {

    public SNI_FL_ROIUtility.ViewROIReturnWrapper vroi{get;set;}
	public SNI_FL_ViewAuthorizationController() {
        String titleName = 'Family Link' ;
		Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename='+titleName);
        string recid = apexpages.currentpage().getparameters().get('recid');
        string isctm = apexpages.currentpage().getparameters().get('isctm');
        boolean isctmflag;
        if(isctm!=Null && isctm.toLowerCase()=='true'){
           isctmflag =true;
         }else{
              isctmflag =false;          
         }
        if(String.isNotBlank(recid)){
            vroi=SNI_FL_ROIUtility.ROImembers(recid,isctmflag);
        }
        
    }
    
   @auraEnabled
    public static boolean getCommunityInfo(){
        Boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
		if(isSandbox) {
            return true;
        }
        return false;
    }

}