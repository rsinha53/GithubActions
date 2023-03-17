public class SNI_FL_MemberROI_TriggerHelper {

    public static Boolean isAuthorizedMemberAdded =false; // Added by ACDC for US3059977
    public static String teamName = 'ACDC';

  public static void changeCareTeamRecStatus(set<string> setCTIds){
        if(setCTIds != null && setCTIds.size()>0){
            list<SNI_FL_Care_Team_Member__c> lstCt = new list<SNI_FL_Care_Team_Member__c>();
            for(SNI_FL_Care_Team_Member__c ct: [select id,SNI_FL_Authorized__c from SNI_FL_Care_Team_Member__c where SNI_FL_Member__c IN: setCTIds]){
                ct.SNI_FL_Authorized__c = true;
                lstCt.add(ct);
            }
            if(lstCt.size()>0){
                update lstCt;
            }
        }
    }
   @future(callout=true)
    public static  void SendEmailtoROI(set<Id> setCTIds,string curMembrEmail){
        //String curMembrEmail='';
        System.debug('setCTIds++'+ setCTIds);
        list<SNI_FL_Members_ROI__c> roimembers = [select id,SNI_FL_Signed_Email__c,SNI_FL_Account__c,SNI_FL_Account__r.personContactId from SNI_FL_Members_ROI__c where SNI_FL_Member__c in :setCTIds AND SNI_FL_Status__c != 'Inactive'];
         String roiId = '';
        System.debug('roimembers++'+ roimembers);
        for(Integer i=0;i<roimembers.size();i++){
            System.debug('ROI id++'+ roimembers[i].Id);
            if(roiId == ''){
                roiId ='m0=' + roimembers[i].Id;
            }
            else{
                roiId = roiId+'&m'+i+'='+roimembers[i].Id;
            }
          // roiId = roiId + '&m'+i+'=' +roimembers[i].Id;
            }
        //curMembrEmail=roimembers[0].SNI_FL_Signed_Email__c;
        System.debug('Entereted in Email--');
        Messaging.SingleEmailMessage emailmsg = new Messaging.SingleEmailMessage();
        String[] to = new String[]{curMembrEmail};
            if(curMembrEmail!=null && curMembrEmail!= '')
            emailmsg.toAddresses = new String[] { curMembrEmail };

        emailmsg.setSubject('Care Advisor Connect Sign Authorization');
        System.debug('List of Roi Ids'+ roiId);       
        	    string famlinkUrl = label.FamilyLinkUrl;
        famlinkUrl = famlinkUrl+'s/SignAuth?'+roiId; //removed the &
        //famlinkUrl = famlinkUrl+'s/SignAuth?'+2F00176000009rnMhAAI;
        System.debug('famlinkUrl======>'+ famlinkUrl);
        String body = '<html><body style=\"font-family: Calibri;\"><br>';
        body += '<img border=\"0\" beditid=\"r1sp1\" blabel=\"headerImage\" id=\"r1sp1\" src=\"https://optumhealthd2c--emidscm--c.documentforce.com/servlet/servlet.ImageServer?id=015760000004yW1&oid=00D760000008flq&lastMod=1652370736000\" style=\"background-color:white;width:310px; height:55px\" >';
        body += '<hr style="color:#000099"/><br><br><div style=\"background-color:white\">Hello,<br><br>'+system.Label.FamilyLinksignAuthemailContent;
        body += '&nbsp;&nbsp;<a href="'+famlinkUrl+'" style=\"color:blue\">Click here</a> to view your form.<br><br>Thank you,<br>';

        body += 'Care Advisor Connect Team<br><br></div><br><div><img border=\"0\" beditid=\"r1sp1\" blabel=\"headerImage\" id=\"r1sp1\" src=\"https://optumhealthd2c--emidscm--c.documentforce.com/servlet/servlet.ImageServer?id=015760000004yW1&oid=00D760000008flq&lastMod=1652370736000\" style=\"padding-Right:1000px;background-color:white;width:350px\" ></div><br><div style=\"background-color:#000099;color:white\">This email was sent to <a href=\"\" style=\"color:#33CCFF\">'+curMembrEmail+'</a> <br><br>You will receive this type of notification to communicate important information about your account, and new features. <br><br>Your family privacy and security is our top priority. Care Advisor Connect will never sell your information or share data from your account. Let us know what you think of Care Advisor Connect. We\'d love to make it better for you.<br>Email us at: <a href=\"\" style=\"color:#33CCFF\">careadvisorconnect@optum.com</a> </div></body></html>';
        //body += 'The FamilyLink Team<br><br></div><br><br><div><img border=\"0\" beditid=\"r1sp1\" blabel=\"headerImage\" id=\"r1sp1\" src=\"#\" style=\"padding-left:1000px;background-color:white;width:350px\" ></div><br><div style=\"background-color:#000099;color:white\">This email was sent to <a href=\"\" style=\"color:blue\">ravikishore_m@optum.com</a> <br><br>You will receive this type of notification to communicate important information about your account, and new features. <br><br>Your family privacy and security is our top priority. FamilyLink will never sell your information or share data from your account. Let us know what you think of FamilyLink. We\'d love to make it better for you.<br>Email us at: <a href=\"\" style=\"color:#33CCFF\">feedback@familylink.io</a> </div></body></html>';

        //system.debug('body----------'+body);
        //string body='<html><body style=\"font-family: Calibri;background-color:#000099\"><br><br><br><br><br><br><br><img border=\"0\" beditid=\"r1sp1\" blabel=\"headerImage\" id=\"r1sp1\"  style=\"background-color:white;width:1400px; height:350px\" /><p>Dear UnitedHealthcare Member, <br><br> Thank you for contacting UnitedHealthcare. The form you requested can be accessed here: <br><br> <a href=\"#\">ROI Form Link</a> <br><br> If you have any other questions, please call us at the number on the back of your health plan ID card. We\'re here to make it easy for you! <br><br> Sincerely, <br><br> UHC Advocate</p></body></html>';
            try{
                //Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                //message.toAddresses = ;
                //message.optOutPolicy = 'FILTER';
                //message.subject = 'Subject Test Message';
                emailmsg.htmlbody = body;
                Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {emailmsg};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            system.debug('email results--:'+results);
            if(!results.get(0).isSuccess()){
                System.debug('Send Error: ' + results.get(0).getErrors()[0].getMessage());
            } else {
                System.debug('Email Send Successful!==============Ankit');
            }
            /*if(curMembrEmail!=null)
            {
                        SNI_FL_Notification_SendResponse responseEmail = SendEmailNotification(curMembrEmail,'test', 'FamilyLink Sign Authorization', body);
                }*/
        }catch(Exception e){
            System.debug('Error in Sending Email'+ e.getMessage());
        }
    }

    public static void updateExpirationDate(List<SNI_FL_Members_ROI__c> triggerNew,map<id,SNI_FL_Members_ROI__c> oldMap){
        System.debug('in updateExpirationDate');
        set<Id> accId=new set<Id>();
        set<id> roiId=new set<Id>();
        for(SNI_FL_Members_ROI__c memROI : triggerNew){
            if(oldmap.get(memROI.id).SNI_FL_ROI_Signed_Date__c != memROI.SNI_FL_ROI_Signed_Date__c){
                System.debug('sign date got changed');
                accId.add(memROI.SNI_FL_Account__c);
                roiId.add(memROI.Id);
            }
        }
        if(accId!=null && accId.size()>0){
            map<id,Account> accMap=new map<id,Account>([Select id,PersonBirthdate from Account where id in:accId]);

            if(accMap!=null && accMap.size()>0){
                for(SNI_FL_Members_ROI__c memROI : triggerNew){
                    if(roiId.contains(memROI.id)){
                        Date dob=accMap.get(memROI.SNI_FL_Account__c)!=null?accMap.get(memROI.SNI_FL_Account__c).PersonBirthdate:null;
                        System.debug('dob='+dob);
                        memROI.Exp_Date__c=SNI_FL_ROIUtility.getExpiryDate(memROI.SNI_FL_ROI_Signed_Date__c,dob);
                        System.debug('memROI.Exp_Date__c='+memROI.Exp_Date__c);
                    }
                }

            }
        }
    }

    //When ROI status is active authorized member will be added to member case overview team
    //Author:Sameera ACDC
    //US3059977
    //Date:11/20/2020
    //Invoked by SNI_FL_MembersROI.trigger
    public static void addAuthorizedMemberToCaseTeam(List<SNI_FL_Members_ROI__c> lstActiveMemberROIs){

        try{

            Map<ID,Set<ID>> accountwithCareteamIDs = new Map<ID,Set<ID>>();//AccountId with set of CareteamIDs
            Map<ID,Case> accountwithCaseOverviewCases = new Map<ID,Case>();// AccountId with CaseOverview Case
            Map<ID,User> lstAccountWithAuthorizedUser = new Map<ID,User>();//Person accountid with user record
            List<CaseTeamMember> lstCaseTeamMembersToInsert = new List<CaseTeamMember>();//Caseteam records to insert

            CaseTeamRole caseteamRole = [SELECT Id FROM CaseTeamRole WHERE Name='Family Member']; //Query caseteam common role

            //Creates a account and careteam record ids
            for(SNI_FL_Members_ROI__c memberROIrecord:lstActiveMemberROIs){
                if(accountwithCareteamIDs.containsKey(memberROIrecord.SNI_FL_Account__c)){
                    Set<ID> authorizedMembers = accountwithCareteamIDs.get(memberROIrecord.SNI_FL_Account__c);
                    authorizedMembers.add(memberROIrecord.SNI_FL_ROI_Signed_With__c);
                    accountwithCareteamIDs.put(memberROIrecord.SNI_FL_Account__c,authorizedMembers);
                }else{
                    Set<ID> authorizedMembers = new Set<ID>();
                    authorizedMembers.add(memberROIrecord.SNI_FL_ROI_Signed_With__c);
                    accountwithCareteamIDs.put(memberROIrecord.SNI_FL_Account__c,authorizedMembers);
                }
            }

            //Get opportunity cases with accountids
            for(Case opportunityCase:[SELECT Id, AccountId FROM Case WHERE AccountId IN :accountwithCareteamIDs.keySet() AND ParentId='']){
                accountwithCaseOverviewCases.put(opportunityCase.AccountId,opportunityCase);
            }


            Map<Id,SNI_FL_Care_Team_Member__c> careTeam = new Map<Id,SNI_FL_Care_Team_Member__c>([SELECT id,SNI_FL_Member__c FROM SNI_FL_Care_Team_Member__c WHERE id IN :accountwithCareteamIDs.values()[0]]);


            //Person accountid with user record
            for(User usr:[SELECT ID,AccountId FROM User WHERE AccountId IN (
                SELECT SNI_FL_Member__c FROM SNI_FL_Care_Team_Member__c WHERE id IN :accountwithCareteamIDs.values()[0])]){
                    lstAccountWithAuthorizedUser.put(usr.AccountId,usr);
            }


            for(ID accountId:accountwithCareteamIDs.keySet()){

                Case opportunityCase = accountwithCaseOverviewCases.get(accountId);

                for(Id careTeamRecord:accountwithCareteamIDs.get(accountId)){

                    User authorizedMemberRecord = lstAccountWithAuthorizedUser.get(careTeam.get(careTeamRecord).SNI_FL_Member__c);
                    if(authorizedMemberRecord != NULL){
                        CaseTeamMember member = new CaseTeamMember();
                        member.ParentId = opportunityCase.id;
                        member.MemberId = authorizedMemberRecord.id;
                        member.TeamRoleId = caseteamRole.id;

                        lstCaseTeamMembersToInsert.add(member);
                    }

                }
            }

            if(lstCaseTeamMembersToInsert.size()>0){
               upsert lstCaseTeamMembersToInsert;
            }

        }catch(Exception e){
            System.debug(teamName+' Exception type caught: ' + e.getTypeName());
            System.debug(teamName+' Message: ' + e.getMessage());
            System.debug(teamName+' Cause: ' + e.getCause());    // returns null
            System.debug(teamName+' Line number: ' + e.getLineNumber());
            System.debug(teamName+' Stack trace: ' + e.getStackTraceString());
        }

     }

     public static void checkROIStatus(List<SNI_FL_Members_ROI__c> newTrigger, map<id,SNI_FL_Members_ROI__c> oldTriggerMap){
        List<SNI_FL_Members_ROI__c> lstMemberROIs = new List<SNI_FL_Members_ROI__c>();
        for(SNI_FL_Members_ROI__c memberROI : newTrigger){
            string oldStatus = oldTriggerMap.get(memberROI.id).SNI_FL_Status__c;
            if(oldStatus != memberROI.SNI_FL_Status__c && memberROI.SNI_FL_Status__c != 'InActive'){
                memberROI.Is_Revoked__c = False ;
            }
        }
    }
}