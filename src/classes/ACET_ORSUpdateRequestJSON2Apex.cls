/*
    Created By: Chandan Patro
    Created Date: 15th Jan 2021
    Description: This class created to generete Request for ORS Update Micro Service
    US2958684: Update to ORS Microservice to the Update API
*/
public class ACET_ORSUpdateRequestJSON2Apex {

	public class ControlModifiers {
		public OrsSourceSystemParameters orsSourceSystemParameters;
	}

	public class OrsSourceSystemParameters {
		public String logonId;
		public String logonOffice;
	}

	public class Meta {
		public ControlModifiers controlModifiers;
	}

	public class DependentName {
		public String firstName;
		public String lastName;
	}

	public class Issue {
		public List<String> comments;
		public String contactMethodCode;
        //public String updateDate;    
        //public String updateTime;    
        public String directionCode;
		public Member member;
		public Originator originator;
		
	}

	public Meta meta;
	public Data data;

	public class Originator {
		public DependentName callerName;
		public String originatorTypeCode;
	}

	public class Data {
		public String modifiedByApplicationIndicator;
		public String updateType;
		public Issue issue;
	}

	public class Member {
		public DependentName dependentName;
	}

	
	public static ACET_ORSUpdateRequestJSON2Apex parse(String json) {
		return (ACET_ORSUpdateRequestJSON2Apex) System.JSON.deserialize(json, ACET_ORSUpdateRequestJSON2Apex.class);
	}
    
    public string getORSUpdateRequestBody(String callerfirstname,String callerlastname,String dependentfirstname,String dependentlastname,String updateType,String updateTime,String updateDate,String contactmethodCode,String directionCode,String originatorTypeCode,String[] searchInputParams,String issueId,String[] commentSized){
        //Meta
        meta = new Meta();
        ControlModifiers cm= new ControlModifiers();
        //ors Credentials
        orsSourceSystemParameters ors= new orsSourceSystemParameters();
        ors.logonId = searchInputParams[1]; //'JR2';;
        ors.logonOffice = searchInputParams[0]; //'673';;
        cm.orsSourceSystemParameters=ors;
        meta.controlModifiers=cm;
        //Data
        data = new Data();
        data.modifiedByApplicationIndicator = 'H';
        data.updateType = updateType;
        //Isue Details
        Issue issue=new Issue();
        issue.comments = commentSized;
        issue.contactMethodCode = contactmethodCode;
        issue.directionCode = directionCode;
        //Member Information
        Member member = new Member();
        DependentName memberName=new DependentName();
        memberName.firstName = callerfirstname;
        memberName.lastName = callerlastname;
        member.dependentName=memberName;
        issue.member=member;
        //Originator information
        Originator originator=new Originator();
        DependentName callerName = new DependentName();
        callerName.firstName = callerfirstname;
        callerName.lastName = callerlastname;
        originator.callerName=callerName;
        originator.originatorTypeCode = originatorTypeCode;
        issue.originator=originator;
        //issue.updateDate=updateDate;
        //issue.updateTime=updateTime;
        data.issue=issue;
        return JSON.serialize(this);
    }
    
}