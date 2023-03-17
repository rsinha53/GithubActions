/**
 * @description       : Deserialize class for Link claim Recon service
 * @author            : Nikhil Kanth
 * @group             : 
 * @last modified on  : 05-04-2021
 * @last modified by  : Nikhil Kanth
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   05-04-2021   Nikhil Kanth   Initial Version
 **/
public class ACET_ClaimReconResultWrapper {

    public class Operator {
        public String operatorName;
        public String emailId;
        public String phoneNo;
    }

    public class TicketInfo {
        public String otherComments;
        public String ticketNumber;
        public String ticketStatus;
        public String ticketSubmDt;
        public String ticketType;
        public List < String > adjustmentIds;
        public String submDt;
        public String closedDt;
    }

    public List < Tickets > tickets;
    public Boolean partialData;

    public class Comments {
        public String addedBy;
        public String addedOn;
        public String comment;
    }

    public class MemberAddress {
        public String address;
        public String city;
        public String state;
        public String zipCode;
    }

    public class PatientInfo {
        public String ptntFn;
        public String ptntLn;
        public String ptntMi;
        public String ptntDob;
        public String relationshipCd;
        public String depSeqNbr;
    }

    public class TicketDetail {
        public List < Comments > comments;
        public ProviderInfo providerInfo;
        public ClaimInfo claimInfo;
        public Operator operator;
        public TicketInfo ticketInfo;
        public MemberInfo memberInfo;
        public PatientInfo patientInfo;
    }

    public class RenProvNm {
        public String firstName;
        public String lastName;
    }

    public class ProviderInfo {
        public String billProvNm;
        public String billProvMPin;
        public RenProvNm renProvNm;
        public String tin;
    }

    public class MemberInfo {
        public String memberId;
        public MemberName memberName;
        public MemberAddress memberAddress;
        public String platform;
        public String subscriberId;
        public String policyNbr;
        public String groupNbr;
        public String cosmosDiv;
        public String govtPgmCd;
    }

    public class Tickets {
        public TicketDetail ticketDetail;
    }

    public class MemberName {
        public String firstName;
        public String lastName;
        public String middleInitial;
    }

    public class ClaimInfo {
        public String claimNumber;
        public String amtOwed;
        public String totalChargedAmt;
        public String firstSrvcDt;
        public String claimType;
        public String claimIcn;
        public String claimStatus;
        public String dontKnowAboutCheckBox;
        public String ptntAcctNbr;
    }


    public static ACET_ClaimReconResultWrapper parse(String json) {
        return (ACET_ClaimReconResultWrapper) System.JSON.deserialize(json, ACET_ClaimReconResultWrapper.class);
    }
}