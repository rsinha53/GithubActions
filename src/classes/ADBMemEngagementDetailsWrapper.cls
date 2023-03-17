/**
* Created By : Madhura Priyadarshana
* Description : Wrapper to be used to handle member engagement detail response at contact history
* Date Created: 1/11/2020
*/
public without sharing class ADBMemEngagementDetailsWrapper {

    @AuraEnabled public EngagementDetails engagementDetails;
    @AuraEnabled public String systemErrorMsg;
    
    public class EngagementDetails{
        @AuraEnabled public MemberVO memberVO;
        @AuraEnabled public EngagementVO engagementVO;
        public CommunicationTransactionList[] communicationTransactionList;
    }
    
    public class MemberVO{
        @AuraEnabled public String relationshipCode;        
    }
    
    public class CommunicationTransactionList{
        public CommunicationTransactionVO communicationTransactionVO;
    }

    public class CommunicationTransactionVO{
        public String channelSourceType;
        public String engageCmnctCategoryType;
    }

    public class EngagementVO{
        @AuraEnabled public String createUserId;
        @AuraEnabled public String createDateTime;
        @AuraEnabled public Boolean statusOpen;
        @AuraEnabled public Boolean statusClosed;
        @AuraEnabled public String engagementStatusType;
        @AuraEnabled public String engagementCategoryType;
        @AuraEnabled public String engagementReasonText;
    }

    //	Notes section
    @AuraEnabled public String notesErrorMsg;

    public class NoteDetails{
        @AuraEnabled public String noteTypeDescription;
        @AuraEnabled public String noteCategoryDescription;
        @AuraEnabled public String noteText;
        @AuraEnabled public String createDate;
        @AuraEnabled public String createUserName;
		@AuraEnabled public String functionalRoleDescription;
    }

    public class MemberAttributes{
        @AuraEnabled public Integer engageID;
        @AuraEnabled public NoteDetails noteDetails;
        @AuraEnabled public List<NoteDetails> lstNoteDetails;
    }

    public class ResponseBody{
        @AuraEnabled public MemberAttributes memberAttributes;
    }

    public class Response{
        @AuraEnabled public ResponseBody responseBody;
    }

    @AuraEnabled public Response response;
}