public without sharing class SNI_FL_ROIFormController {
    
    @auraEnabled
    public static List<SNI_FL_ROIUtility.ROIReturnWrapper> getSignROIMembers(List<String> ctmIdList,Id famId,boolean initCall,boolean isInvited){
        List<SNI_FL_ROIUtility.ROIReturnWrapper> wrapList=new List<SNI_FL_ROIUtility.ROIReturnWrapper>();
        system.debug('invited=='+isInvited);
        if(isInvited)
            wrapList=SNI_FL_ROIUtility.getROIMembers(ctmIdList,famId,isInvited);
        else
            wrapList= SNI_FL_ROIUtility.getSignROIMembers(ctmIdList,famId,initCall);
        return wrapList;
    }
    
    @auraEnabled
    public static void SignAuthUpdate(String ctmId,String memberlist,boolean isInvited){
        System.debug('isInvited='+isInvited);
        /*if(isInvited)
SNI_FL_ROIUtility.inviteAuthUpdate(ctmId,memberlist);
else */
        SNI_FL_ROIUtility.signAuthUpdate(ctmId,memberlist);
    }
    
    @auraEnabled
    public static Integer getAge(date dob){
        return SNI_FL_ROIUtility.calculateAge(dob,System.today());
    }
    
    @auraEnabled
    public static void createComUser(String memberCtmId){
        System.debug('memberCtmId='+memberCtmId);
        SNI_FL_ROIUtility.createCommunityUser(memberCtmId);
    }
    
    @auraEnabled
    public static SNI_FL_ROIUtility.ViewROIReturnWrapper ROImembers(String roiRecId, boolean isCTM){
        SNI_FL_ROIUtility.ViewROIReturnWrapper vroi= new SNI_FL_ROIUtility.ViewROIReturnWrapper();
        vroi = SNI_FL_ROIUtility.ROImembers(roiRecId,isCTM);
        return vroi;
    }
    
    /*---Ankit Email Template-*/
    
    @auraEnabled
    public static void SignAuthemailD(String curMembrEmail, Id careTeamId,String rOISignedWith,boolean isInvited){
        System.debug('curMembrEmail'+ curMembrEmail);
        System.debug('careTeamId'+ careTeamId);
        System.debug('isInvited'+ isInvited);
        System.debug('RoiSignedWithLst'+ rOISignedWith);
        List<SNI_FL_Care_Team_Member__c> careTeamLst = new List<SNI_FL_Care_Team_Member__c>();
        List<SNI_FL_Care_Team_Member__c> RoiSignedWithLst =(List<SNI_FL_Care_Team_Member__c>)JSON.deserialize(rOISignedWith, List<SNI_FL_Care_Team_Member__c>.class);
        
        System.debug('RoiSignedWithLst'+ RoiSignedWithLst);
        List<SNI_FL_Members_ROI__c> roiLst =  new List<SNI_FL_Members_ROI__c>();
        if(careTeamId !=null){
            careTeamLst = [SELECT Id,SNI_FL_Member__c,SNI_FL_Authorized__c,SNI_FL_Member__r.Name from SNI_FL_Care_Team_Member__c where Id =: careTeamId ];
        }
        String careTeamName = careTeamLst[0].SNI_FL_Member__r.Name;
        roiLst = [Select Id,SNI_FL_ROI_Signed_Date__c,SNI_FL_Status__c from SNI_FL_Members_ROI__c where sni_fl_member__c =: careTeamId and SNI_FL_ROI_Signed_With__c =:RoiSignedWithLst];
        List<SNI_FL_Members_ROI__c> updatedRoiList = new List<SNI_FL_Members_ROI__c>();
        System.debug('roiLst in signAuthUpdate='+roiLst.size());
        for(SNI_FL_Members_ROI__c mmbrroi:roiLst){
            if(mmbrroi.SNI_FL_Status__c == 'InActive' && mmbrroi.SNI_FL_Status__c!= null){
                mmbrroi.SNI_FL_Status__c = 'Pending';
                mmbrroi.SNI_FL_Signed_Email__c= curMembrEmail;
                updatedRoiList.add(mmbrroi);}
        }
        update updatedRoiList;
        
        //Logic for email sending
        //Creating instance and variable
        
    }
    
}