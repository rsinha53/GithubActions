public class ACETLGT_showConfetti {
    public ACETLGT_showConfetti(ApexPages.StandardController controller){
        recordId = controller.getId();
    }
    public boolean showHeader{get;set;}
    public String subHeaderText{get;set;}
    public String HeaderText{get;set;}
    public String recordId{get;set;}
    public void getsObjectCountInfo() {
         
        List<String> profileList = new List<String>();
        confettiWrapper wrapObj;
        
        List<ACETLGT_Confetti__c> mcsList = [select id,Header_Message__c, SubHeader_Message__c ,Case_Count__c ,Milestone__c ,recordId__c ,sObject_Query__c ,UserId__c,Profile_List__c from ACETLGT_Confetti__c LIMIT 1];
        ACETLGT_Confetti__c mcs = mcsList.size() > 0 ? mcsList.get(0):null;
        integer casecount;
        integer objmilestone;
        if(mcs != null && (mcs.UserId__c != null && userInfo.getUserId().substring(0,14) ==mcs.UserId__c.substring(0,14)) && (mcs.recordId__c != null && recordId.substring(0,14) == mcs.recordId__c.substring(0,14)) ){
            casecount = Integer.valueOf(mcs.Case_Count__c);
            objmilestone = Integer.valueOf(mcs.Milestone__c) ;
        
            
            boolean retVal = casecount == Integer.valueOf(objmilestone);
            showHeader = retVal;
            subHeaderText = mcs.SubHeader_Message__c;
            HeaderText = mcs.Header_Message__c;
            system.debug('count-->'+casecount +'==return==>'+ retVal);
            
            
        }
    }
    @AuraEnabled
    public static confettiWrapper getsObjectCount(string recId) {
        List<String> profileList = new List<String>();
        confettiWrapper wrapObj;
        
        List<ACETLGT_Confetti__c> mcsList = [select id,Header_Message__c, SubHeader_Message__c ,Case_Count__c ,Milestone__c ,recordId__c ,sObject_Query__c ,UserId__c,Profile_List__c from ACETLGT_Confetti__c LIMIT 1];
        ACETLGT_Confetti__c mcs = mcsList.size() > 0 ? mcsList.get(0):null;
        integer casecount;
        integer objmilestone;
        
        if(mcs != null && (userInfo.getUserId().substring(0,14) ==mcs.UserId__c.substring(0,14)) && (recId.substring(0,14) == mcs.recordId__c.substring(0,14)) ){
            casecount = Integer.valueOf(mcs.Case_Count__c);
            objmilestone = Integer.valueOf(mcs.Milestone__c) ;
        
            
            boolean retVal = casecount == Integer.valueOf(objmilestone);
            system.debug('count-->'+casecount +'==return==>'+ retVal);
            wrapObj = new confettiWrapper(mcs.Header_Message__c, mcs.SubHeader_Message__c,retVal );   
            system.debug('wrapObj-->'+wrapObj);
            return wrapObj;
        }else{
            return null;
        }
    }
    @InvocableMethod(label='Update Metadata Counter ' description='updates the metadata counter' category='Case')
    public static List<string> getsObjectCountClassic(List<string> recIdList) {
        List<String> profileList = new List<String>();
        String recId = recIdList.get(0);
        List<ACETLGT_Confetti__c> mcsList = [select id,Header_Message__c, SubHeader_Message__c ,Case_Count__c ,Milestone__c ,recordId__c ,sObject_Query__c ,UserId__c,Profile_List__c from ACETLGT_Confetti__c LIMIT 1];
        ACETLGT_Confetti__c mcs = mcsList.size() > 0 ? mcsList.get(0):null;
        for(string str:mcs.Profile_List__c.split(',')){
            profileList.add(str);
        }
        integer casecount;
        integer objmilestone;
        if(mcs != null && (mcs.Case_Count__c == null || mcs.Case_Count__c ==0)){
            string sObjectQueryStr = mcs.sObject_Query__c;
        	system.debug('sObjectQueryStr-->'+sObjectQueryStr);
            casecount = database.countQuery(sObjectQueryStr);
            objmilestone = 1000000;
        }else if(mcs != null){
            casecount = Integer.valueOf(mcs.Case_Count__c);
            objmilestone = Integer.valueOf(mcs.Milestone__c) ;
        }else{
            string sObjectQueryStr = 'select count() from Case where isdeleted=false and case_creator_user_type__c=\'End User\' and status = \'Closed\' and owner.profile.name in: profileList';
        	system.debug('sObjectQueryStr-->'+sObjectQueryStr);
            casecount = database.countQuery(sObjectQueryStr);
            objmilestone = 1000000;
        }
        	Integer currentCasecount = casecount + 1;
        	boolean retVal = currentCasecount == Integer.valueOf(objmilestone);
            system.debug('count-->'+currentCasecount +'==return==>'+ retVal);
            Map<String, Object> fieldWithValuesMap = new Map<String, Object>();
            if(retVal){
                ACETLGT_Confetti__c acetconf = new ACETLGT_Confetti__c(id=mcs.id);
                acetconf.Case_Count__c = currentCasecount;
                acetconf.recordId__c = recId;
                acetconf.UserId__c = userInfo.getUserId();
                acetconf.Milestone__c = objmilestone;
                if(acetconf != null)
                	update acetconf;

            }else{
                ACETLGT_Confetti__c acetconf = new ACETLGT_Confetti__c(id=mcs.id);
                acetconf.Case_Count__c = currentCasecount;
                if(currentCasecount < objmilestone){
                    acetconf.recordId__c = '';
                    acetconf.UserId__c = '';
                    acetconf.Milestone__c = objmilestone;
                }
                if(acetconf != null)
                	update acetconf;
            }
        
        return null;

    }

    public class confettiWrapper{
        @AuraEnabled
        public string headerMessage;
        @AuraEnabled
        public string subheaderMessage;
        @AuraEnabled
        public Boolean respstatus;
        public confettiWrapper(string hM,string ShM, Boolean Sts){
            headerMessage = hM;
            subheaderMessage = ShM;
            respstatus = Sts;
        }
	} 
}