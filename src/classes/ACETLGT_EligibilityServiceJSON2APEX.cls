public class ACETLGT_EligibilityServiceJSON2APEX {
		public status status{get;set;}
		public result result{get;set;}
	public class status{
		public list<messages> messages{get;set;}
	}
	public class result{
		public list<data> data{get;set;}
	}
	public class messages{
		public String severity{get;set;}
		public String name{get;set;}
		public String description{get;set;}
		public String code{get;set;}
	}
	public class data{
		public String lob{get;set;}
		public String agreedtoPAFS{get;set;}
		public String assignedTo{get;set;}
		public String familyLinkID{get;set;}
		public list<String> accountTypes{get;set;}
		public String memberID{get;set;}
		public List<String> localMarket{get;set;}
		public String policyID{get;set;}
		public String employeeId{get;set;}
		public String caregiverName{get;set;}
		public String serviceGroup{get;set;}
		public list<children> children{get;set;}
		public String containmentGroup1{get;set;}
		public String sniEligibility{get;set;}
		public String rank{get;set;}
		public String finaloverflowGroup{get;set;}
		public String routingThreshold{get;set;}
		public String containmentGroup2{get;set;}
		public String referralThreshold{get;set;}
		public Boolean memberExists{get;set;}
		public String advisorFullName{get;set;}
		public String initialCallDate{get;set;}
	}
	public class children{
		public String behavioralCondition{get;set;}
		public String lastName{get;set;}
		public Boolean newlyDiagnosed{get;set;}
		public String middleInitial{get;set;}
		public String medicalCondition{get;set;}
		public String firstName{get;set;}
	}
}