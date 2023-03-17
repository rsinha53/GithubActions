public without sharing class SNI_FL_ROIPublicPageController {
    public list<SNI_FL_Members_ROI__c> lstRoiMem{get; set;}
    public string curMemName {get; set;}
    public SNI_FL_ROIPublicPageController(){
       // Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=Family_Link.pdf');

        system.debug('SNI_FL_ROIPublicPageController-----');
        lstRoiMem = new list<SNI_FL_Members_ROI__c>();
        map<string,string> mapParam = apexpages.currentpage().getparameters();
        list<string> lsttr = new list<string>();
        system.debug('SNI_FL_ROIPublicPageController---mapParam----'+mapParam);
       if(mapParam != null && mapParam.size()>0){
            for(string str:mapParam.keySet()){
                lsttr.add(mapParam.get(str));
            }
            system.debug('SNI_FL_ROIPublicPageController---lsttr---'+lsttr);
            lstRoiMem = getRoiMembersForPrint('',lsttr);
           if(lstRoiMem.size()>0){
             curMemName = lstRoiMem[0].SNI_FL_Member__r.SNI_FL_Member__r.FirstName+' '+lstRoiMem[0].SNI_FL_Member__r.SNI_FL_Member__r.LastName;
               system.debug('SNI_FL_ROIPublicPageController---lstRoiMem---'+curMemName);
           }
           //system.debug('SNI_FL_ROIPublicPageController---lstRoiMem---'+lstRoiMem);
        }
    }
    @AuraEnabled
    public static void saveRoiDetails(list<SNI_FL_Members_ROI__c> lstRoiIds){
         system.debug('lstRoiIds-----------'+lstRoiIds);
        if(lstRoiIds.size()>0){
            for(SNI_FL_Members_ROI__c roiMem : lstRoiIds){
                roiMem.SNI_FL_Status__c = 'Active';
                roiMem.SNI_FL_ROI_Signed_Date__c = system.today();
            }
            update lstRoiIds;
        }
    }


    public static list<SNI_FL_Members_ROI__c> getRoiMembersForPrint(string curRoiId,list<string> lstRoiIds ){
        system.debug('public page --getRoiMembers-----------');
        list<SNI_FL_Members_ROI__c> lstMemsROI = new list<SNI_FL_Members_ROI__c>();
        if( lstRoiIds != null && lstRoiIds.size()>0){
          lstMemsROI = [select id,SNI_FL_Status__c,Authorized_Member__c,SNI_FL_Member__r.SNI_FL_Member__r.FirstName,SNI_FL_Member__r.SNI_FL_Member__r.LastName from SNI_FL_Members_ROI__c where  Id IN: lstRoiIds];
        }
        return lstMemsROI;
    }

    @AuraEnabled
    public static list<SNI_FL_Members_ROI__c> getRoiMembers(list<string> lstRoiIds ){
        system.debug('public page --getRoiMembers-----------');
        //list<SNI_FL_Members_ROI__c> lstMemsROI = new list<SNI_FL_Members_ROI__c>();
        if( lstRoiIds != null && lstRoiIds.size()>0){
            list<SNI_FL_Members_ROI__c> lstMemsROIinn = [select id,SNI_FL_Status__c,Authorized_Member__c,SNI_FL_Member__r.SNI_FL_Member__r.FirstName,SNI_FL_Member__r.SNI_FL_Member__r.LastName from SNI_FL_Members_ROI__c where  Id IN: lstRoiIds ]; //and SNI_FL_Status__c = 'Pending'
            boolean recExist = false;
            if(lstMemsROIinn != null && lstMemsROIinn.size()>0){
                for(SNI_FL_Members_ROI__c roiMem  : lstMemsROIinn){
                    if(roiMem.SNI_FL_Status__c == 'Pending'){
                        recExist = true;
                        //return false;
                    }
                }
            }
            if(recExist){
                return lstMemsROIinn;
            }
            else{
                return new list<SNI_FL_Members_ROI__c>();
            }
        }
        return new list<SNI_FL_Members_ROI__c>();
    }
    /*
    @AuraEnabled
    public static wrappRoimems getRoiMembers(string curRoiId,list<string> lstRoiIds ){

        list<SNI_FL_Members_ROI__c> lstMemsROI = new list<SNI_FL_Members_ROI__c>();


        wrappRoimems wrapObj = new wrappRoimems();
        if( curRoiId != null && lstRoiIds.size()>0){
           lstRoiIds.add(curRoiId);
            system.debug('lstRoiIds siZE-----------'+lstRoiIds.size());
            for(SNI_FL_Members_ROI__c curMem : [select id,SNI_FL_Status__c,Authorized_Member__c,SNI_FL_Member__r.SNI_FL_Member__r.FirstName,SNI_FL_Member__r.SNI_FL_Member__r.LastName from SNI_FL_Members_ROI__c where  Id IN: lstRoiIds and SNI_FL_Status__c = 'Pending']){

                if(curMem.id == curRoiId){

                  wrapObj.curMemName = curMem.SNI_FL_Member__r.SNI_FL_Member__r.FirstName + ' ' +curMem.SNI_FL_Member__r.SNI_FL_Member__r.LastName;
                }
               else{
                    lstMemsROI.add(curMem);
                }

            }
          system.debug('lstMemsROI-----------'+lstMemsROI);
        }
        wrapObj.lstRoiMems = lstMemsROI;
        return wrapObj;
    }
    public class wrappRoimems{
        @AuraEnabled
        public string curMemName{get; set;}
        @AuraEnabled
        public list<SNI_FL_Members_ROI__c> lstRoiMems{get; set;}
    }*/
}