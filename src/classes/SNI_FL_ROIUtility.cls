public without sharing class SNI_FL_ROIUtility {
    
    public class ROIReturnWrapper {
        @AuraEnabled
        public string ctmId{get; set;}
        @AuraEnabled
        public boolean isChild{get; set;}
        @AuraEnabled
        public string ctmMemberId{get; set;}
        @AuraEnabled
        public String isAuthROIdone {get;set;}
        @AuraEnabled
        public String expiryDate{get;set;}
       	@AuraEnabled
        public String isROIdone {get;set;}
        @AuraEnabled
        public List<SNI_FL_Care_Team_Member__c> ctmAuthCreationPendingList {get;set;}//New Member - 
        @auraEnabled
        public List<SNI_FL_Care_Team_Member__c> ctmPendingList {get;set;}//invite pop up would be shown for them 
        @AuraEnabled
        public List<SNI_FL_Care_Team_Member__c> createROIList {get;set;}//Roi would be created for them
        @AuraEnabled
        public List<SNI_FL_Care_Team_Member__c> ctmAllList {get;set;}//invite -right hand side value
        @AuraEnabled
        public List<String> ctmPendingIdList {get;set;}//Id //As part of the design change- We need id of pending list 
                                                       //to create inactive records for all pending list-->to other invited/registered mem
        @AuraEnabled
        public List<SNI_FL_Care_Team_Member__c> FLAccOwnerList {get;set;}//invite -right hand side dob,address value for FLAO
        
        public ROIReturnWrapper(){
            ctmPendingList=new list<SNI_FL_Care_Team_Member__c>();
            ctmAllList=new list<SNI_FL_Care_Team_Member__c>();
            createROIList=new list<SNI_FL_Care_Team_Member__c>();
            ctmPendingIdList=new list<String>(); 
            FLAccOwnerList = new list<SNI_FL_Care_Team_Member__c>();
        }
    }
    public class ViewROIReturnWrapper {
        @AuraEnabled
        public String ctmName {get;set;}
        @AuraEnabled
        public String ctmMID {get;set;}
        @AuraEnabled
        public Date ctmDOB {get;set;}
        @AuraEnabled
        public String ctmAdd {get;set;}
        @AuraEnabled
        public List<String> ROINames {get;set;}
        @AuraEnabled
        public String signedbyName {get;set;}
        @AuraEnabled
        public boolean ischild {get;set;}
        @AuraEnabled
        public String signeddate {get;set;}
        @AuraEnabled
        public String childnamenoap {get;set;}
        @AuraEnabled
        public String childname {get;set;}
        @AuraEnabled
        public String addcontent {get;set;}
        public ViewROIReturnWrapper(){
            ROINames = new list<String>();
        }
    }
    
    @AuraEnabled
   //Logic to get all the member who have not signed ROI
   public static List<ROIReturnWrapper> getROIMembers(List<Id> ctmIdList,Id famId,boolean isInvited){
    try{
     //Invite Pop up- ('Registered'),('Authorised') - SNI_FL_ROI_Signed_With__c --> How many members have given him
     //MemName in right side -('Registered'),('Invited') - SNI_FL_Member__c --> How many this guy has given access
     List<String> statusList= new List<String>{('Authorised'),('Registered')};
     map<id,SNI_FL_Care_Team_Member__c> careTeamMap= new map<id,SNI_FL_Care_Team_Member__c>();
     map<id,SNI_FL_Care_Team_Member__c> careTeamAllMap= new map<id,SNI_FL_Care_Team_Member__c>();
     map<id,SNI_FL_Care_Team_Member__c> ctMap= new map<id,SNI_FL_Care_Team_Member__c>();
     list<SNI_FL_Care_Team_Member__c> ctFLAccOwnerList= new list<SNI_FL_Care_Team_Member__c>();
         for(SNI_FL_Care_Team_Member__c ctm:[Select id,SNI_FL_Member__r.PersonBirthdate,SNI_FL_Authorized__c,SNI_FL_Status__c,
                                             SNI_FL_Family__c,SNI_FL_Member__c,SNI_FL_Member__r.name,SNI_FL_Member__r.PersonMailingAddress,
                                             SNI_FL_Family__r.member_id__c,SNI_FL_Primary_Caregiver__c,SNI_FL_Not_Visible_in_Familylink__c 
                                             from SNI_FL_Care_Team_Member__c where SNI_FL_Family__c =:famId
                                             and SNI_FL_Status__c != 'Removed']){//added Removed Status
             Integer ageNum=SNI_FL_ROIUtility.calculateAge(ctm.SNI_FL_Member__r.PersonBirthdate,System.today());                                                 
             System.debug('ageNum='+ageNum);
             if(ctm.SNI_FL_Status__c=='Invited' || ctm.SNI_FL_Status__c=='Registered'){
                     careTeamAllMap.put(ctm.id,ctm);                                
             }
             if((ageNum != null && ageNum < 13) || ctm.SNI_FL_Authorized__c ||(ctm.SNI_FL_Primary_Caregiver__c && ctm.SNI_FL_Status__c=='Registered')){  // ctm.authorised ||
                     careTeamMap.put(ctm.id,ctm);
             }
             if(ctm.SNI_FL_Primary_Caregiver__c && ctm.SNI_FL_Status__c=='Registered'){
                    ctFLAccOwnerList.add(ctm);   
             }
             ctMap.put(ctm.id,ctm);
         }
     System.debug('careTeamAllMap='+careTeamAllMap);
     System.debug('careTeamMap='+careTeamMap);
     map<id,set<id>> roiMap=new Map<id,set<id>>();
     map<id,set<id>> roiPendingMap=new Map<id,set<id>>();
     System.debug('ctmIdList='+ctmIdList);
     for(SNI_FL_Members_ROI__c roi: [SELECT Id,SNI_FL_Status__c, SNI_FL_Account__c, SNI_FL_Signed_Email__c, SNI_FL_Type__c, 
                                     SNI_FL_ROI_Signed_Date__c, SNI_FL_ROI_Signed_With__c, SNI_FL_Member__c 
                                     FROM SNI_FL_Members_ROI__c where SNI_FL_ROI_Signed_With__c in :ctmIdList
                                     and SNI_FL_Member__r.SNI_FL_Status__c != 'Removed'])
        { 
            if(!roiMap.keyset().contains(roi.SNI_FL_ROI_Signed_With__c)){
                roiMap.put(roi.SNI_FL_ROI_Signed_With__c, new set<id> {roi.SNI_FL_Member__c});
            }
            else{
                set<id> memIds=roiMap.get(roi.SNI_FL_ROI_Signed_With__c);  
                memIds.add(roi.SNI_FL_Member__c);
                roiMap.put(roi.SNI_FL_ROI_Signed_With__c, memIds);
            }
            if(roi.SNI_FL_Status__c != 'Active'){ //Considered Pending and Inactive
                if(!roiPendingMap.keyset().contains(roi.SNI_FL_ROI_Signed_With__c)){
                roiPendingMap.put(roi.SNI_FL_ROI_Signed_With__c, new set<id> {roi.SNI_FL_Member__c});
                }
                else{
                    set<id> memIds=roiPendingMap.get(roi.SNI_FL_ROI_Signed_With__c);  
                    memIds.add(roi.SNI_FL_Member__c);
                    roiPendingMap.put(roi.SNI_FL_ROI_Signed_With__c, memIds);
                }
                
            }
            
        }
        System.debug('roiMap='+roiMap);
        System.debug('roiPendingMap='+roiPendingMap);
        
 
        List<ROIReturnWrapper> wrapList=new List<ROIReturnWrapper>();
        
        for(Id ctmId:ctMap.keyset()){ //careTeamMap.keyset()
          if(!isInvited || (isInvited && ctmIdList.contains(ctmId))){
            ROIReturnWrapper rw=new ROIReturnWrapper();
            rw.ctmId=ctmId;
            rw.ctmAllList=careTeamAllMap.values();
            //IF he is in added status-then only add it
            if(!careTeamAllMap.keyset().contains(ctmId))
                   rw.ctmAllList.add(ctMap.get(ctmId));//Invite
            set<id> roiCreatedSet=roiMap.get(ctmId);
            set<id> roiPendingset=roiPendingMap.get(ctmId);
            System.debug('roiCreatedSet'+roiCreatedSet);
            System.debug('roiPendingset'+roiPendingset);
            System.debug('careTeamMap.keyset().size()'+careTeamMap.keyset().size());
	        Integer activeROICount=0;
            if(roiCreatedSet!=null && roiCreatedSet.size()>0){
              activeROICount=roiCreatedSet.size();
              if(roiPendingset!=null && roiPendingset.size()>0)
                 activeROICount-=roiPendingset.size();
            }
            system.debug('activeROICount='+activeROICount+'---- for ctm id='+ctmId);
            if(roiCreatedSet==null || roiCreatedSet.size()==0){
                System.debug('Coming to Not Started');
                System.debug('careTeamMap.keyset()='+careTeamMap.keyset());
                rw.isROIdone='Not Started';
                for(Id ctmId1:careTeamMap.keyset()){
                    if(ctmId!=ctmId1) {
						if(careTeamMap.get(ctmId1)!=null){
								   rw.createROIList.add(careTeamMap.get(ctmId1)); 
								   rw.ctmPendingList.add(careTeamMap.get(ctmId1)); 
						}
                        rw.ctmPendingIdList.add(ctmId1);
                    }
                }
            }
	    //for inactive records active count logic wont satisfy- so it would not go to below block
	    //But for pending records active count logic might satisfy (Pending sign auth)- So it would go to below map

            else if((careTeamMap.keyset().contains(ctmId) && activeROICount==careTeamMap.keyset().size()-1)
                        || ((!careTeamMap.keyset().contains(ctmId)) && activeROICount==careTeamMap.keyset().size())){
                            System.debug('Coming to Completed');
                            rw.isROIdone='Completed';
                            //It would enter to below logic for pending invite situation
                            if(roiPendingset!=null && roiPendingset.size()>0){
                                //rw.isROIdone='Partial';
                                for(Id ctmId1:roiPendingset){
                                    if(ctmId!=ctmId1) {
                                        if(careTeamMap.get(ctmId1)!=null)
                                          rw.ctmPendingList.add(careTeamMap.get(ctmId1)); 
                                        //rw.ctmPendingMap.put(ctmId1, careTeamMap.get(ctmId1));
                                        rw.ctmPendingIdList.add(ctmId1);
                                    }
                                }
                            }
                        }

            else{
                System.debug('Coming to partial');
                rw.isROIdone='Partial';
                for(Id ctmId1:careTeamMap.keyset()){
                    if(ctmId!=ctmId1 && !roiCreatedSet.contains(ctmId1)){
                        System.debug('careTeamMap111='+careTeamMap.get(ctmId1));
                        if(careTeamMap.get(ctmId1)!=null){
						  rw.createROIList.add(careTeamMap.get(ctmId1)); 
						  rw.ctmPendingList.add(careTeamMap.get(ctmId1));
						}
                        rw.ctmPendingIdList.add(ctmId1);
                    }
                }
                System.debug('roiPendingset222='+roiPendingset);
                if(roiPendingset!=null && roiPendingset.size()>0){
                    for(Id ctmId1:roiPendingset){
                        if(ctmId!=ctmId1) {
                        System.debug('careTeam222='+careTeamMap.get(ctmId1));
                            rw.ctmPendingList.add(careTeamMap.get(ctmId1)); 
                            rw.ctmPendingIdList.add(ctmId1);
                        }
                   }  
                }
            }
            rw.FLAccOwnerList = ctFLAccOwnerList;
            wrapList.add(rw);
          }
        }
        System.debug('wrapList='+wrapList); 
        if(isInvited && wrapList!=null && wrapList.size()>0){
            ROIReturnWrapper wrap =wrapList.get(0);
            List<SNI_FL_Members_ROI__c> roiList =  new List<SNI_FL_Members_ROI__c>();

            List<SNI_FL_Members_ROI__c> roiLstInvite =createROIRecords(wrap);
            if(roiLstInvite!=null && roiLstInvite.size()>0)
                roiList.addall(roiLstInvite);
            if(wrap.ctmPendingIdList!=null && wrap.ctmPendingIdList.size()>0){
                List<SNI_FL_Members_ROI__c> roiLstPendingInvite =createROIForPendingInvite(wrap.ctmPendingIdList,careTeamAllMap,ctMap);
                if(roiLstPendingInvite!=null && roiLstPendingInvite.size()>0)
                    roiList.addall(roiLstPendingInvite);
            }
            if(roiList!=null && roiList.size()>0){
                //Below logic build to remove the duplicate
                map<String,SNI_FL_Members_ROI__c> roiFinalMap=new map<String,SNI_FL_Members_ROI__c>();
                for(SNI_FL_Members_ROI__c roi:roiList){
                    roiFinalMap.put(roi.SNI_FL_Member__c+'_'+roi.SNI_FL_ROI_Signed_With__c,roi);
                }
                if(roiFinalMap!=null && roiFinalMap.size()>0){
                    insert roiFinalMap.values();
                }
            }
        }
        
        return wrapList;
	 }catch(Exception e){
         System.debug('Exception happened='+e);
         return null;
     }
	  
    }
     @AuraEnabled
    public static List<SNI_FL_Members_ROI__c> createROIForPendingInvite(List<String> ctmPendingIdList , 
                                                                        map<id,SNI_FL_Care_Team_Member__c> careTeamAllMap,
                                                                        map<id,SNI_FL_Care_Team_Member__c> ctMap){
        List<SNI_FL_Members_ROI__c> roiLst = new List<SNI_FL_Members_ROI__c>();
        map<id,set<id>> roiPenMap=new Map<id,set<id>>();//Roi map for pending members
            if(ctmPendingIdList!=null && ctmPendingIdList.size()>0 && careTeamAllMap!=null && careTeamAllMap.size()>0 
              && ctMap!=null && ctMap.size()>0){
                for(SNI_FL_Members_ROI__c roi: [SELECT Id,SNI_FL_Status__c, SNI_FL_Account__c, SNI_FL_Signed_Email__c, SNI_FL_Type__c, 
                                        SNI_FL_ROI_Signed_Date__c, SNI_FL_ROI_Signed_With__c, SNI_FL_Member__c 
                                        FROM SNI_FL_Members_ROI__c where SNI_FL_Member__c in :ctmPendingIdList])
                { 
                    if(!roiPenMap.keyset().contains(roi.SNI_FL_Member__c)){
                        roiPenMap.put(roi.SNI_FL_Member__c, new set<id>{roi.SNI_FL_ROI_Signed_With__c});
                    }
                    else{
                        set<id> memIds=roiPenMap.get(roi.SNI_FL_Member__c);  
                        memIds.add(roi.SNI_FL_ROI_Signed_With__c);
                        roiPenMap.put(roi.SNI_FL_Member__c, memIds);
                    }
                }
              System.debug('roiPenMap='+roiPenMap);
              Map<id,List<SNI_FL_Care_Team_Member__c>> createROIMap= new Map<id,List<SNI_FL_Care_Team_Member__c>>();
              for(Id ctmId:ctmPendingIdList){ //careTeamMap.keyset()
                  
                  set<id> roiCreatedSet=roiPenMap.get(ctmId);
                  if(roiCreatedSet==null || roiCreatedSet.size()==0){
                     for(Id ctmId1:careTeamAllMap.keyset()){ //careTeamAllMap- Invited and Registered
                            if(ctmId!=ctmId1) {
                                List<SNI_FL_Care_Team_Member__c> cPenList=createROIMap.get(ctmId);
                                if(cPenList!=null && cPenList.size()>0)
                                    cPenList.add(ctMap.get(ctmId1));
                                else
                                    cPenList= new List<SNI_FL_Care_Team_Member__c>{ctMap.get(ctmId1)}; 
                                createROIMap.put(ctmId, cPenList);
                            }
                     }
                   }
                   else if((careTeamAllMap.keyset().contains(ctmId) && roiCreatedSet.size()==careTeamAllMap.keyset().size()-1)
                        || ((!careTeamAllMap.keyset().contains(ctmId)) && roiCreatedSet.size()==careTeamAllMap.keyset().size())){
                        
                        }
                  else{
                      for(Id ctmId1:careTeamAllMap.keyset()){
                        if(ctmId!=ctmId1 && !roiCreatedSet.contains(ctmId1)){
                            List<SNI_FL_Care_Team_Member__c> cPenList=createROIMap.get(ctmId);
                                if(cPenList!=null && cPenList.size()>0)
                                    cPenList.add(ctMap.get(ctmId1));
                                else
                                    cPenList= new List<SNI_FL_Care_Team_Member__c>{ctMap.get(ctmId1)}; 
                                createROIMap.put(ctmId, cPenList);
                        }
                      }   
                  }
               }
                if(createROIMap!=null && createROIMap.size()>0){
                    
                    for(Id memCtm: createROIMap.keyset()){
                        List<SNI_FL_Care_Team_Member__c> cPenList=createROIMap.get(memCtm);
                        if(cPenList!=null && cPenList.size()>0){
                            for(SNI_FL_Care_Team_Member__c roiSignedWithCtm:cPenList){
                                SNI_FL_Members_ROI__c roi = new SNI_FL_Members_ROI__c();
                                roi.SNI_FL_Account__c = ctMap.get(memCtm).SNI_FL_Member__c;
                                roi.SNI_FL_Member__c = memCtm;
                                //roi.SNI_FL_ROI_Signed_Date__c = system.today();
                                roi.SNI_FL_ROI_Signed_With__c = roiSignedWithCtm.Id;
                                roi.SNI_FL_Status__c = 'Inactive';
                                //roi.SNI_FL_Type__c = 'Electronically';
                                roiLst.add(roi); 
                            }
                        }
                        
                    }
                }
            }
           return roiLst;                                                                 
    }
    
    @AuraEnabled
    public static List<SNI_FL_Members_ROI__c> createROIRecords(ROIReturnWrapper wrap){
        
            List<SNI_FL_Members_ROI__c> roiLst =  new List<SNI_FL_Members_ROI__c>();
            
                System.debug('wrap.createROIList='+wrap.createROIList);
                if(wrap.createROIList!=null && wrap.createROIList.size()>0){
                    for(SNI_FL_Care_Team_Member__c ctm:wrap.createROIList){
                        SNI_FL_Members_ROI__c roi = new SNI_FL_Members_ROI__c();
                        roi.SNI_FL_Account__c = ctm.SNI_FL_Member__c;
                        roi.SNI_FL_Member__c = ctm.id;
                        //roi.SNI_FL_ROI_Signed_Date__c = system.today();
                        roi.SNI_FL_ROI_Signed_With__c = wrap.ctmId;
                        roi.SNI_FL_Status__c = 'Inactive';
                        //roi.SNI_FL_Type__c = 'Electronically';
                        roiLst.add(roi); 
                    }
                }
            System.debug('roiLst='+roiLst);
            return roiLst;

    }
    
    @auraEnabled
    public static void signAuthUpdate(String ctmMember,String rOISignedWith){
        System.debug('inside signAuthUpdate='+ctmMember);
        List<SNI_FL_Care_Team_Member__c> careTeamLst = new List<SNI_FL_Care_Team_Member__c>();
        List<SNI_FL_Care_Team_Member__c> RoiSignedWithLst =(List<SNI_FL_Care_Team_Member__c>)JSON.deserialize(rOISignedWith, List<SNI_FL_Care_Team_Member__c>.class);
        List<SNI_FL_Members_ROI__c> roiLst =  new List<SNI_FL_Members_ROI__c>();
        if(ctmMember !=null){
            careTeamLst = [SELECT Id,SNI_FL_Member__c,SNI_FL_Authorized__c from SNI_FL_Care_Team_Member__c where Id =: ctmMember ];
            careTeamLst[0].SNI_FL_Authorized__c = true;
        }
        for(SNI_FL_Members_ROI__c roi : [Select Id,SNI_FL_ROI_Signed_Date__c,SNI_FL_Status__c from SNI_FL_Members_ROI__c where sni_fl_member__c =: ctmMember and SNI_FL_ROI_Signed_With__c =:RoiSignedWithLst]){
           
		   
		   roi.SNI_FL_ROI_Signed_Date__c = system.today();
           roi.SNI_FL_Status__c = 'Active';
            roiLst.add(roi);
        }
        System.debug('roiLst in signAuthUpdate='+roiLst);
        if(roiLst.size()>0){
            update roiLst ;
        }
        System.debug('careTeamLst in signAuthUpdate='+careTeamLst);
        if(careTeamLst.size()>0){
            update careTeamLst;
        }
    }
    
    @AuraEnabled
    public static date getExpiryDate(Date signDate ,Date bday){

        //Date dt=System.today();
        Date ExpiryDate= signDate!=null?signDate.day()==29 && signDate.month()==2?signDate.addYears(1)+1:signDate.addYears(1):null;
        System.debug('ExpiryDate='+ExpiryDate);
        if(ExpiryDate!=null && bday!=null){
            Integer ageNum=SNI_FL_ROIUtility.calculateAge(bday,System.today());
            if(ageNum==12){
               Date comingBday=  bday.day()==29 && bday.month()==2?Date.isLeapYear(bday.addYears(13).year())?bday.addYears(13):bday.addYears(13)+1:bday.addYears(13);
               System.debug('comingBday='+comingBday);
               if(comingBday<ExpiryDate)
                   ExpiryDate=comingBday;
            }
        }
        return ExpiryDate;
        
    }
    @AuraEnabled
   //Logic to get all the member who have not signed ROI
   public static List<ROIReturnWrapper> getSignROIMembers(List<String> ctmIdList,Id famId,boolean initCall){
     //Invite Pop up- ('Registered'),('Authorised') - SNI_FL_ROI_Signed_With__c --> How many members have given him
     //MemName in right side -('Registered'),('Invited') - SNI_FL_Member__c --> How many this guy has given access
     List<String> statusList= new List<String>{('Invited'),('Registered')};
     map<id,SNI_FL_Care_Team_Member__c> careTeamMap= new map<id,SNI_FL_Care_Team_Member__c>();
     map<id,SNI_FL_Care_Team_Member__c> careTeamAllMap= new map<id,SNI_FL_Care_Team_Member__c>();
     
    for(SNI_FL_Care_Team_Member__c ctm:[Select id,SNI_FL_Member__r.PersonBirthdate,SNI_FL_Status__c,SNI_FL_Family__c,SNI_FL_Member__c,SNI_FL_Member__r.name,
                                                     SNI_FL_Primary_Caregiver__c,SNI_FL_Not_Visible_in_Familylink__c 
                                             from SNI_FL_Care_Team_Member__c where SNI_FL_Family__c =:famId and SNI_FL_Not_Visible_in_Familylink__c != true]){
             if(ctm.SNI_FL_Status__c=='Invited' || ctm.SNI_FL_Status__c=='Registered'){
                     careTeamMap.put(ctm.id,ctm);                                
             }
             if(ctmIdList.contains(ctm.id))
             careTeamAllMap.put(ctm.id,ctm);
             
         }
     map<id,set<id>> roiMap=new Map<id,set<id>>();
     map<id,set<id>> roiPendingMap=new Map<id,set<id>>();
     map<id,set<id>> roiInactiveMap =new Map<id,set<id>>();
     map<id,Date> expiryDateMap = new Map<Id,Date>();
     //Code added as per US3008715: Family Link -Expired ROI 
     //Deactivation of ROI would happen at only loading of careteam
     if(initCall){
        Date todayDate=System.today();
        List<SNI_FL_Members_ROI__c> lstROIExpired = new List<SNI_FL_Members_ROI__c>([
                                         SELECT Id,Exp_Date__c,SNI_FL_Status__c, SNI_FL_Account__c,  
                                         SNI_FL_ROI_Signed_Date__c, SNI_FL_ROI_Signed_With__c, SNI_FL_Member__c
                                         FROM SNI_FL_Members_ROI__c where Exp_Date__c<= :todayDate 
                                         and SNI_FL_Member__c in :ctmIdList]);
         SNI_FL_ROIUtility.deActivateROI(lstROIExpired);         
     }
     //End
     
     for(SNI_FL_Members_ROI__c roi: [SELECT Id,Exp_Date__c,SNI_FL_Status__c, SNI_FL_Account__c, SNI_FL_Signed_Email__c, SNI_FL_Type__c, 
                                     SNI_FL_ROI_Signed_Date__c, SNI_FL_ROI_Signed_With__c, SNI_FL_Member__c
                                     FROM SNI_FL_Members_ROI__c where SNI_FL_Member__c in :ctmIdList ])
        { 
            if(roi.SNI_FL_Status__c != 'InActive' && roi.SNI_FL_Status__c != 'Pending' && (careTeamMap.Keyset()).contains(roi.SNI_FL_ROI_Signed_With__c) ){
            if(!roiMap.keyset().contains(roi.SNI_FL_Member__c)){
                roiMap.put(roi.SNI_FL_Member__c, new set<id> {roi.SNI_FL_ROI_Signed_With__c});
            }
            else{
                set<id> memIds=roiMap.get(roi.SNI_FL_Member__c);  
                memIds.add(roi.SNI_FL_ROI_Signed_With__c);
                roiMap.put(roi.SNI_FL_Member__c, memIds);
            }
		expiryDateMap.put(roi.SNI_FL_Member__c,roi.Exp_Date__c);
            }
            if(roi.SNI_FL_Status__c == 'InActive' && (careTeamMap.Keyset()).contains(roi.SNI_FL_ROI_Signed_With__c)){
                if(!roiInactiveMap.keyset().contains(roi.SNI_FL_Member__c)){
                    roiInactiveMap.put(roi.SNI_FL_Member__c, new set<id> {roi.SNI_FL_ROI_Signed_With__c});
                }
                else{
                    set<id> memIds=roiInactiveMap.get(roi.SNI_FL_Member__c);  
                    memIds.add(roi.SNI_FL_ROI_Signed_With__c);
                    roiInactiveMap.put(roi.SNI_FL_Member__c, memIds);
                }
            }
             else if(roi.SNI_FL_Status__c == 'Pending'){
                if(!roiPendingMap.keyset().contains(roi.SNI_FL_Member__c)){
                roiPendingMap.put(roi.SNI_FL_Member__c, new set<id> {roi.SNI_FL_ROI_Signed_With__c});
                }
                else{
                    set<id> memIds=roiPendingMap.get(roi.SNI_FL_Member__c);  
                    memIds.add(roi.SNI_FL_ROI_Signed_With__c);
                    roiPendingMap.put(roi.SNI_FL_Member__c, memIds);
                }
                
            }
          
        }

        List<ROIReturnWrapper> wrapList=new List<ROIReturnWrapper>();
        for(Id ctmId:careTeamAllMap.keyset()){
            ROIReturnWrapper rw=new ROIReturnWrapper();
            rw.ctmId=ctmId;
            SNI_FL_Care_Team_Member__c cc=careTeamAllMap.get(ctmId);
            Integer ageNum=SNI_FL_ROIUtility.calculateAge(cc.SNI_FL_Member__r.PersonBirthdate,System.today());                                                 
            System.debug('ageNum='+ageNum);
            //Integer ageNum = cc.SNI_FL_Member__r.PersonBirthdate != null ? system.today().year() - cc.SNI_FL_Member__r.PersonBirthdate.year() : null;
            rw.isChild= ageNum != null && ageNum < 13?true:false;
            rw.expiryDate = expiryDateMap.get(ctmId) != null?expiryDateMap.get(ctmId).month()+'/'+expiryDateMap.get(ctmId).day()+'/'+expiryDateMap.get(ctmId).year() : null ;
            rw.ctmMemberId = careTeamAllMap.get(ctmId).SNI_FL_Member__c;
            list<SNI_FL_Care_Team_Member__c> clist = careTeamMap.values();
            for(integer i= 0 ; i< clist.size() ;i++){
                if(clist[i].Id == ctmId){
                    clist.remove(i);
                }
            }
            rw.ctmAllList = clist ;
            set<id> roiCreatedSet=roiMap.get(ctmId);
            set<id> roiPendingset=roiPendingMap.get(ctmId);
            set<id> roiInactiveset = roiInactiveMap.get(ctmId);
            set<id> memIdSet=roiMap.get(ctmId);
            system.debug('hello'+roiPendingset+'hello'+roiCreatedSet);
            system.debug('helo'+roiCreatedSet);
            system.debug('hello'+ careTeamMap.keyset().size());
            system.debug('helloclist'+clist+'size'+clist.size());
            if(roiCreatedSet==null || roiCreatedSet.size()==0){
                rw.isAuthROIdone='Not Started';
                for(Id ctmId1:careTeamMap.keyset()){
                    if(ctmId!=ctmId1) {
                        rw.createROIList.add(careTeamMap.get(ctmId1)); 
                        rw.ctmPendingList.add(careTeamMap.get(ctmId1)); 
                    }
                }
            }
            
             else if(roiCreatedSet.size()==clist.size()){
                 system.debug('debughere');
                rw.isAuthROIdone='Partial';
                for(Id ctmId1:careTeamMap.keyset()){
                  if(ctmId!=ctmId1 && !roiCreatedSet.contains(ctmId1))
                   rw.createROIList.add(careTeamMap.get(ctmId1)); 
                   rw.ctmPendingList.add(careTeamMap.get(ctmId1));
                }
                if(roiInactiveset!=null && roiInactiveset.size()>0){
                    for(Id ctmId1:roiInactiveset){ 
                        if(ctmId!=ctmId1) {
                            rw.ctmPendingList.add(careTeamMap.get(ctmId1)); 
                        }
                   }  
                }
                else
                 rw.isAuthROIdone='Completed';
            }
            else{
                 system.debug('inside else');
                 rw.isAuthROIdone='Partial';
                 for(Id ctmId1:careTeamMap.keyset()){
                   if(ctmId!=ctmId1 && !roiCreatedSet.contains(ctmId1)) //{
                   rw.createROIList.add(careTeamMap.get(ctmId1)); 
                   rw.ctmPendingList.add(careTeamMap.get(ctmId1));
            }
                if(roiInactiveset!=null && roiInactiveset.size()>0){
                    for(Id ctmId1:roiInactiveset){
                        if(ctmId!=ctmId1) {
                            rw.ctmPendingList.add(careTeamMap.get(ctmId1)); 
                        }
                   }  
                }
            }
            if(roiPendingset!=null && roiPendingset.size()>0){
                rw.isAuthROIdone='Pending';
             }
            wrapList.add(rw);
        }
       system.debug('initCall'+initCall);
      if(!initCall)
      createSignROIRecords(wrapList);
      return wrapList;
   }
    @AuraEnabled
    public static void createSignROIRecords(list<ROIReturnWrapper> wrapList){
        system.debug('debug=');
        List<SNI_FL_Members_ROI__c> roiLst =  new List<SNI_FL_Members_ROI__c>();
        if(wrapList!=null && wrapList.size()>0){
            for(ROIReturnWrapper wrap:wrapList){
                if(wrap.createROIList!=null && wrap.createROIList.size()>0){
                    for(SNI_FL_Care_Team_Member__c ctm:wrap.createROIList){
                        List<SNI_FL_Members_ROI__c> roiRecs = [SELECT Id from SNI_FL_Members_ROI__c where SNI_FL_Member__c =:wrap.ctmId and SNI_FL_ROI_Signed_With__c =: ctm.id ];
                        if(roiRecs.size()==0){
                        SNI_FL_Members_ROI__c roi = new SNI_FL_Members_ROI__c();
                        roi.SNI_FL_Account__c = wrap.ctmMemberId;
                        roi.SNI_FL_Member__c = wrap.ctmId;
                      
                        roi.SNI_FL_ROI_Signed_With__c = ctm.id;
                        roi.SNI_FL_Status__c = 'Inactive';
                        
                        roiLst.add(roi); 
                        }
                    }
                }
                
            }
        }
        if(roiLst!=null && roiLst.size()>0)
            insert roiLst;
    }
    
    @auraEnabled
    public static void inviteAuthUpdate(String rOISignedWith,String ctmMember){
       List<SNI_FL_Care_Team_Member__c> careTeamLst = new List<SNI_FL_Care_Team_Member__c>();
        List<SNI_FL_Care_Team_Member__c> ctmMemberLst =(List<SNI_FL_Care_Team_Member__c>)JSON.deserialize(ctmMember, List<SNI_FL_Care_Team_Member__c>.class);
        List<SNI_FL_Members_ROI__c> roiLst =  new List<SNI_FL_Members_ROI__c>();
        if(rOISignedWith !=null){
            careTeamLst = [SELECT Id,SNI_FL_Member__c,SNI_FL_Authorized__c from SNI_FL_Care_Team_Member__c where Id =: rOISignedWith ];
            careTeamLst[0].SNI_FL_Authorized__c = true;
        }
        for(SNI_FL_Members_ROI__c roi : [Select Id,SNI_FL_ROI_Signed_Date__c,SNI_FL_Status__c from SNI_FL_Members_ROI__c where sni_fl_member__c =: rOISignedWith and SNI_FL_ROI_Signed_With__c =:ctmMemberLst]){
            //roi.SNI_FL_Account__c = careTeamLst[0].SNI_FL_Member__c;
            //roi.SNI_FL_Member__c = member;
            roi.SNI_FL_ROI_Signed_Date__c = system.today();
            //roi.SNI_FL_ROI_Signed_With__c = careTeam.Id;
            roi.SNI_FL_Status__c = 'Active';
            //roi.SNI_FL_Type__c = 'Electronically';
            roiLst.add(roi);
        }
        if(roiLst.size()>0){
            update roiLst ;
        }
        if(careTeamLst.size()>0){
            update careTeamLst;
        }
    }
    
   

    @AuraEnabled
    public static map<string,string> getROIMembersMap(List<Id> ctmIdList,Id famId){
        map<string,string> mapRoi = new map<string,string>();
        List<ROIReturnWrapper> lstWrap = SNI_FL_ROIUtility.getROIMembers(ctmIdList,famId,false);
        system.debug('getROIMembersMap-----ctmIdList-----'+ctmIdList);
        system.debug('getROIMembersMap-----famId-----'+famId);
        system.debug('getROIMembersMap-----lstWrap-----'+lstWrap);
        if(lstWrap != null && lstWrap.size()>0){
            for(ROIReturnWrapper roi : lstWrap){
                system.debug('getROIMembersMap-----isROIdone-------'+roi.isROIdone);
                mapRoi.put(roi.ctmId,roi.isROIdone);
            }
        }
        return mapRoi;
    }
    /* this will create community user after CareTeam member ROi done and also update CT status to invited */
    @auraEnabled
    public Static void createCommunityUser(String careTeamId){
        system.debug('------createCommunityUser-------'+careTeamId);
        try{
            if(String.isNotBlank(careTeamId)){
			    list<SNI_FL_Care_Team_Member__c> lstCtRec = [select SNI_FL_Member__c,Email__c,SNI_FL_Member__r.FirstName,SNI_FL_Member__r.LastName from SNI_FL_Care_Team_Member__c where id =: careTeamId];
                if(lstCtRec != null && lstCtRec.size()>0){
                    Profile flp = [Select Id from Profile where name = 'Care Advisor Connect Community User' LIMIT 1];   
                    list<Account> acc = [select Id,PersonContactId from Account where id=: lstCtRec[0].SNI_FL_Member__c];
                    if(acc.size()>0){    
                        User comUser = New User();
                        comUser.UserName = lstCtRec[0].Email__c;
                        comUser.FirstName = lstCtRec[0].SNI_FL_Member__r.FirstName;
                        comUser.LastName = lstCtRec[0].SNI_FL_Member__r.LastName;
                        comUser.Alias = String.isNotBlank(lstCtRec[0].SNI_FL_Member__r.LastName) ? lstCtRec[0].SNI_FL_Member__r.LastName.substring(0,3):'';                         
                        comUser.email = lstCtRec[0].Email__c;
                        comUser.ContactId = acc[0].PersonContactId;
                        comUser.CommunityNickName = 'FLUser'+string.valueOf(math.random()).substring(0,6);
                        comUser.ProfileID = flp.id;
                        comUser.TimeZoneSidKey = 'America/Mexico_City';
                        comUser.LocaleSidKey = 'en_US';
                        comUser.EmailEncodingKey = 'UTF-8';
                        comUser.LanguageLocaleKey = 'en_US';
                        Database.SaveResult[] srList = Database.insert(new list<user>{comUser},false);
                        System.debug('User Created='+comUser);
                        for (Database.SaveResult sr : srList) {
                            if (sr.isSuccess()) {
                                SNI_FL_ROIUtility.careTeamUpdateOperation(careTeamId,null);
                            }
                        }
                    }
                }
            }
        }catch(Exception ex){
            system.debug('------exception-------'+ex);
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_InviteController',ex);
        }
    }
	@auraEnabled
    public Static void createCommunityUserinResend(String careTeamId,string email){
        system.debug('------createCommunityUser-------'+careTeamId);
        try{
            if(String.isNotBlank(careTeamId)){
                list<SNI_FL_Care_Team_Member__c> lstCtRec = [select SNI_FL_Member__c,Email__c,SNI_FL_Member__r.FirstName,SNI_FL_Member__r.LastName from SNI_FL_Care_Team_Member__c where id =: careTeamId];
                if(lstCtRec != null && lstCtRec.size()>0){
                    Profile flp = [Select Id from Profile where name = 'Care Advisor Connect Community User' LIMIT 1];   
                    list<Account> acc = [select Id,PersonContactId from Account where id=: lstCtRec[0].SNI_FL_Member__c];
                    if(acc.size()>0){    
                        User comUser = New User();
                       // comUser.UserName = lstCtRec[0].Email__c;
                       comUser.UserName = email;
                        comUser.FirstName = lstCtRec[0].SNI_FL_Member__r.FirstName;
                        comUser.LastName = lstCtRec[0].SNI_FL_Member__r.LastName;
                        comUser.Alias = String.isNotBlank(lstCtRec[0].SNI_FL_Member__r.LastName) ? lstCtRec[0].SNI_FL_Member__r.LastName.substring(0,3):'';                         
                        system.debug('createCommunityUser--email---'+lstCtRec[0].Email__c);
                        //comUser.email = lstCtRec[0].Email__c;
                        comUser.email = email;
                        comUser.ContactId = acc[0].PersonContactId;
                        comUser.CommunityNickName = 'FLUser'+string.valueOf(math.random()).substring(0,6);
                        comUser.ProfileID = flp.id;
                        comUser.TimeZoneSidKey = 'America/Mexico_City';
                        comUser.LocaleSidKey = 'en_US';
                        comUser.EmailEncodingKey = 'UTF-8';
                        comUser.LanguageLocaleKey = 'en_US';
                        Database.SaveResult[] srList = Database.insert(new list<user>{comUser},false);
                        System.debug('User Created='+comUser);
                        for (Database.SaveResult sr : srList) {
                            if (sr.isSuccess()) {
                                SNI_FL_ROIUtility.careTeamUpdateOperation(careTeamId,email);
                            }
                        }
                    }
                }
            }
        }catch(Exception ex){
            system.debug('------exception-------'+ex);
            AcetUtility.CreateAndRedirectToError('FamilyLink','SNI_FL_InviteController',ex);
        }
    }
	@future
    public static void careTeamUpdateOperation(string ctrecID,string email){
        SNI_FL_Care_Team_Member__c ctm = new SNI_FL_Care_Team_Member__c();
        ctm.Id=ctrecID;
        ctm.SNI_FL_Status__c='Invited';
        ctm.SNI_FL_Invited_Date__c = System.today();
		if(email != null && email != ''){
            ctm.Email__c = email;
        }
        update ctm;
    }
    /* Using this wrapper to show/hide invite, edit invite and resend button on each member card */
    public class ROIInviteWrapReturn {
        //  @AuraEnabled
        public string ctMembId{get; set;}
        //  @AuraEnabled
        public boolean showResend {get;set;}
        //  @AuraEnabled
        public boolean invite {get;set;}
        //  @AuraEnabled
        public boolean editInvite {get;set;}
    }
    /* This is for Invite -- This will check whether to redirect to Sign Authorization popup or not from Invite*/
    //@AuraEnabled
    public static map<string,ROIInviteWrapReturn> checkRedirectInvitetoAuth(string familyId){
        map<string,ROIInviteWrapReturn> lstWrap = new map<string,ROIInviteWrapReturn>();
        if(familyId != null){
            Map<string,set<string>> mapCTmems = new Map<string,set<string>>();
            list<SNI_FL_Care_Team_Member__c> lstCTMem = [SELECT Id,SNI_FL_Status__c,SNI_FL_Primary_Caregiver__c From SNI_FL_Care_Team_Member__c WHERE SNI_FL_Family__c =: familyId and SNI_FL_Not_Visible_in_Familylink__c != true];
            // when only one Careteam record is avaialable
            set<string> sharedBy = new set<string>();
            set<string> sharedWith = new set<string>();
            if(lstCTMem.size() > 0 ){
                for(SNI_FL_Care_Team_Member__c ctOuter : lstCTMem){
                    if(ctOuter.SNI_FL_Primary_Caregiver__c != true && ctOuter.SNI_FL_Status__c != 'Removed'){
                        set<string> setOtherMems = new set<string>();
                        for(SNI_FL_Care_Team_Member__c ctInner : lstCTMem){
                            if(ctOuter.id != ctInner.id && ctInner.SNI_FL_Status__c != 'Removed'){
                                setOtherMems.add(ctInner.id);
                                sharedBy.add(ctInner.id);
                            }
                        }
                        if(setOtherMems.size()>0){
                            sharedWith.add(ctOuter.id);
                            mapCTmems.put(ctOuter.id,setOtherMems);
                        }
                    }
                }
                if(mapCTmems.size()>0){
                    Map<string,set<string>> mapMemRoi = new Map<string,set<string>>();
                    for(SNI_FL_Members_ROI__c memRoi :  [select SNI_FL_Member__c,SNI_FL_ROI_Signed_With__c from SNI_FL_Members_ROI__c where SNI_FL_Member__c IN : sharedBy and SNI_FL_ROI_Signed_With__c IN : sharedWith]){
                        if(mapMemRoi.containsKey(memRoi.SNI_FL_ROI_Signed_With__c)){
                            set<string> sigRoi = mapMemRoi.get(memRoi.SNI_FL_ROI_Signed_With__c);
                            sigRoi.add(memRoi.SNI_FL_Member__c);
                        }
                        else{
                            mapMemRoi.put(memRoi.SNI_FL_ROI_Signed_With__c,new set<string>{memRoi.SNI_FL_Member__c});
                        }
                    }
                    for(string memId : mapCTmems.keyset()){ // map with Careteam members
                        boolean isRoi = true;
                        ROIInviteWrapReturn roi = new ROIInviteWrapReturn();
                        if(mapMemRoi.containsKey(memId)){
                            set<string> roiSetforMem = mapMemRoi.get(memId);
                            boolean exist = false;
                            boolean notExist = false;
                            for(string innerMem : mapCTmems.get(memId)){
                                if(roiSetforMem.contains(innerMem)){
                                    exist = true;
                                }
                                if(! roiSetforMem.contains(innerMem)){
                                    notExist = true;
                                }
                            }
                            if(exist && notExist){
                                roi.editInvite = true; // edit invite
                                roi.showResend = false;// resend
                                roi.invite = false; // Invite
                            }
                            else if(exist && ! notExist){
                                roi.showResend = true;// resend
                                roi.invite = false; // Invite
                                roi.editInvite = false; // edit invite
                            }
                            else if(! exist &&  notExist){
                                roi.invite = true; // Invite
                                roi.editInvite = false; // edit invite
                                roi.showResend = false;// resend
                            }
                        }
                        else{
                            roi.invite = true; // show invite
                            roi.editInvite = false; // edit invite
                            roi.showResend = false;// resend
                        }
                        
                        roi.ctMembId = memId;
                        //lstWrap.add(roi);
                        lstWrap.put(memId,roi);
                    }
                }
            }
        }
        return lstWrap;
    } 
    
    public static ViewROIReturnWrapper ROImembers(String roiRecId, boolean isCTM){
        
        
        Id accId; 
        Integer ageNum;        
        ViewROIReturnWrapper vroi = new ViewROIReturnWrapper();
        if(isCTM){ 
            system.debug('if--');
            accId = [SELECT SNI_FL_Member__c FROM SNI_FL_Care_Team_Member__c WHERE id =:roiRecId LIMIT 1].SNI_FL_Member__c;
            SNI_FL_Care_Team_Member__c CTMRec = [SELECT SNI_FL_Member__r.FirstName,SNI_FL_Member__r.LastName,SNI_FL_Member__r.PersonBirthdate,SNI_FL_Family__c,SNI_FL_Member__r.PersonMailingstreet,SNI_FL_Member__r.PersonMailingCity,SNI_FL_Member__r.PersonMailingcountry,SNI_FL_Member__r.PersonMailingstate,SNI_FL_Member__r.PersonMailingpostalCode FROM SNI_FL_Care_Team_Member__c Where id =:roiRecId LIMIT 1];
            vroi.ctmName = CTMRec.SNI_FL_Member__r.FirstName +' '+ CTMRec.SNI_FL_Member__r.LastName;
            vroi.ctmName = vroi.ctmName.toUpperCase();
            ageNum=SNI_FL_ROIUtility.calculateAge(CTMRec.SNI_FL_Member__r.PersonBirthdate,System.today());
            vroi.isChild= ageNum != null && ageNum < 13?true:false;
            string personalMailingStreet = String.ValueOf(CTMRec.SNI_FL_Member__r.PersonMailingstreet);
            string personalMailingcity = String.ValueOf(CTMRec.SNI_FL_Member__r.PersonMailingCity);
            string personalCountry = String.ValueOf(CTMRec.SNI_FL_Member__r.PersonMailingcountry);
            string personalState = String.ValueOf(CTMRec.SNI_FL_Member__r.PersonMailingstate);
            string personalPostalCode = String.ValueOf(CTMRec.SNI_FL_Member__r.PersonMailingpostalCode); 
            vroi.ctmAdd = personalMailingStreet+' '+personalMailingcity+', '+personalState+' '+personalPostalCode+' ' +personalCountry;
            vroi.ctmDOB = date.ValueOf(CTMRec.SNI_FL_Member__r.PersonBirthdate);
            Id  conId = [Select id,AccountId  from contact where AccountId=:CTMRec.SNI_FL_Member__c].Id;
            for(Account a : [SELECT Id,Member_Id__c,(SELECT Id,AccountId,ContactId FROM AccountContactRelations WHERE ContactId=:conId) FROM Account WHERE Id IN(SELECT AccountId FROM AccountContactRelation WHERE ContactId=:conId) AND Member_Id__c != Null]){
                if(a.AccountContactRelations.size()>0 && a.Member_Id__c != ''){
                    vroi.ctmMID = a.Member_Id__c;
                }                                   
            }
            SNI_FL_Care_Team_Member__c ctm=[select id,SNI_FL_Family__c,SNI_FL_Primary_Caregiver__c,SNI_FL_Member__r.Name from SNI_FL_Care_Team_Member__c where SNI_FL_Primary_Caregiver__c=true AND SNI_FL_Family__c=:CTMRec.SNI_FL_Family__c LIMIT 1];
            if(vroi.isChild==true){
                vroi.signedbyName = ctm.SNI_FL_Member__r.Name;
                vroi.signedbyName = vroi.signedbyName.toUpperCase();
            }
            
        }else{
            accId = [SELECT SNI_FL_Account__c FROM SNI_FL_Members_ROI__c WHERE id =:roiRecId LIMIT 1].SNI_FL_Account__c;
            SNI_FL_Members_ROI__c ROIRec = [SELECT SNI_FL_Account__c,SNI_FL_Account__r.FirstName,SNI_FL_Account__r.LastName,
                                            SNI_FL_Account__r.PersonBirthdate,SNI_FL_Account__r.PersonMailingCity,
                                            SNI_FL_Account__r.PersonMailingcountry,SNI_FL_Account__r.PersonMailingstate,
                                            SNI_FL_Account__r.PersonMailingpostalCode,SNI_FL_Account__r.PersonMailingstreet,
                                            SNI_FL_Member__r.SNI_FL_Family__c FROM SNI_FL_Members_ROI__c Where id =:roiRecId LIMIT 1];
            vroi.ctmName = ROIRec.SNI_FL_Account__r.FirstName +' '+ ROIRec.SNI_FL_Account__r.LastName;
            vroi.ctmName = vroi.ctmName.toUpperCase();
            
            Id  conId = [Select id,AccountId  from contact where AccountId=:ROIRec.SNI_FL_Account__c].Id;
            for(Account a : [SELECT Id,Member_Id__c,(SELECT Id,AccountId,ContactId FROM AccountContactRelations WHERE ContactId=:conId) FROM Account WHERE Id IN(SELECT AccountId FROM AccountContactRelation WHERE ContactId=:conId) AND Member_Id__c != Null]){
                if(a.AccountContactRelations.size()>0 && a.Member_Id__c != ''){
                    vroi.ctmMID = a.Member_Id__c;
                }                                   
            }
            
            vroi.ctmDOB = date.ValueOf(ROIRec.SNI_FL_Account__r.PersonBirthdate);
            string psrt = String.ValueOf(ROIRec.SNI_FL_Account__r.PersonMailingstreet);
            string pcity = String.ValueOf(ROIRec.SNI_FL_Account__r.PersonMailingCity);
            string pcon = String.ValueOf(ROIRec.SNI_FL_Account__r.PersonMailingcountry);
            string pstate = String.ValueOf(ROIRec.SNI_FL_Account__r.PersonMailingstate);
            string pcode = String.ValueOf(ROIRec.SNI_FL_Account__r.PersonMailingpostalCode);
            vroi.ctmAdd = psrt+' '+pcity+', '+pstate+' '+pcode+' ' +pcon;
            
            ageNum=SNI_FL_ROIUtility.calculateAge(ROIRec.SNI_FL_Account__r.PersonBirthdate,System.today());
            vroi.isChild= ageNum != null && ageNum < 13?true:false;
            SNI_FL_Care_Team_Member__c ctmr=[select id,SNI_FL_Family__c,SNI_FL_Primary_Caregiver__c,SNI_FL_Member__r.Name from SNI_FL_Care_Team_Member__c where SNI_FL_Primary_Caregiver__c=true AND SNI_FL_Family__c=:ROIRec.SNI_FL_Member__r.SNI_FL_Family__c LIMIT 1];
             if(vroi.isChild==true){
                vroi.signedbyName = ctmr.SNI_FL_Member__r.Name;
                vroi.signedbyName = vroi.signedbyName.toUpperCase();
            }   
            
            
        }
        List<SNI_FL_Members_ROI__c> ROIRecList = [SELECT Authorized_Member__c,SNI_FL_ROI_Signed_Date__c FROM SNI_FL_Members_ROI__c Where SNI_FL_Account__c =:accId AND SNI_FL_Status__c ='Active'];
        
        List<String> ROiNames = new list<String>();
        for(SNI_FL_Members_ROI__c roi : ROIRecList){
            String roiname = roi.Authorized_Member__c;
            if(String.isNotBlank(roiname)){
           	    roiname = roiname.toUpperCase();
                ROiNames.add(roiname);
            }
            
            
        }
        
        vroi.ROINames=ROiNames;
        if(ROIRecList!=Null && ROIRecList.size()>0){
        Date dt = ROIRecList.get(0).SNI_FL_ROI_Signed_Date__c;
        vroi.signeddate =DateTime.newInstance(dt.year(), dt.month(), dt.day()).format('MM/dd/yyyy');
        }
        if(vroi!=Null && vroi.isChild==true){
            vroi.childname = vroi.ctmName+'\'s';
            vroi.childnamenoap = vroi.ctmName;
            vroi.ctmName = vroi.signedbyName;
            vroi.addcontent = ' ';
        }else{
            vroi.childname = 'my';
            vroi.childnamenoap = 'I';
            vroi.addcontent =' of ';
        }
        
        return vroi;
    }
    
    @AuraEnabled
    public static Integer calculateAge(Date dt1,Date dt2){
        //Date dt1=date.parse('02/28/2019');//.addyears(-1)-240;
        System.debug('Date1='+dt1);
        //Date dt2= date.parse('02/29/2020');
        System.debug('Date2='+dt2);
        Integer ageNum; 
        if(dt1!=null && dt2!=null){
            Integer days = dt1.daysBetween(dt2);
            System.debug('Intial days without leap year='+days);
            Integer leapYear=0;
            boolean alreadyLeapYear=false;
            for(Integer i=dt1.year();i<=dt2.year();i++){
                if(i==dt1.year() && dt1.month()<3){
                  if(Date.isLeapYear(i)){
                   leapYear+=1;
                   alreadyLeapYear=true;
                  }
                }
                else if(!alreadyLeapYear && i==dt2.year() && (dt2.month()>2 || (dt2.month()==2 && dt2.day()==29)))
                 leapYear+=Date.isLeapYear(i)?1:0;
                else if(i!=dt1.year() && i!=dt2.year())
                  leapYear+=Date.isLeapYear(i)?1:0;
            }
            if(days!=null){
                days=days-leapYear;//excluding the extra day
                System.debug('days excluding leap year='+days);
                ageNum = Integer.valueOf(days/365);   
                System.debug('ageNum='+ageNum); 
            }
        }
        
        return ageNum;
    }
    
     @AuraEnabled
     public static void deActivateROI(List<SNI_FL_Members_ROI__c> lstROIExpired){
        
        if(lstROIExpired!=null && lstROIExpired.size()>0){
            
         List<SNI_FL_Members_ROI__c> roiDeactivationList=new List<SNI_FL_Members_ROI__c>();
         map<id,SNI_FL_Care_Team_Member__c> ctmDeAuthoriseMap=new map<id,SNI_FL_Care_Team_Member__c>();
         for(SNI_FL_Members_ROI__c roi: lstROIExpired)
         {
             System.debug('roi.Exp_Date__c='+roi.Exp_Date__c);
             System.debug('date.today()='+date.today());
             if(roi.Exp_Date__c!=null && roi.Exp_Date__c <=System.today()){
                 //roi.Exp_Date__c=null; //As everything is handaled in Trigger when Signed date changes
                 roi.SNI_FL_Status__c='InActive';
                 roi.SNI_FL_ROI_Signed_Date__c=null;
                 //roi.Auth_Form_Uploaded__c =false;
                 roiDeactivationList.add(roi);
                 
                 SNI_FL_Care_Team_Member__c ct=new SNI_FL_Care_Team_Member__c();
                 ct.id=roi.SNI_FL_Member__c;
                 ct.SNI_FL_Authorized__c=false;
                 ctmDeAuthoriseMap.put(ct.id,ct);
             }
         }
         if(roiDeactivationList!=null && roiDeactivationList.size()>0)
             update roiDeactivationList;
         if(ctmDeAuthoriseMap!=null && ctmDeAuthoriseMap.size()>0)
             update ctmDeAuthoriseMap.values(); 
        }
         
     }
        
    }