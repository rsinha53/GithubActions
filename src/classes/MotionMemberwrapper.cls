public class MotionMemberwrapper {
	@AuraEnabled public PageDetails pagination {get;set;} 
	@AuraEnabled public List<Data> memberRecord {get;set;} 

	public MotionMemberwrapper(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'PageDetails') {
						pagination = new PageDetails(parser);
					} else if (text == 'data') {
						memberRecord = arrayOfData(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'MotionMemberwrapper consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Data {

		public String RegisteredMemberId {get;set;} //Changed from String to Integer in V2, but keeping it as string and converting Integer to String as it is used in many places
		public String EligibleMemberId {get;set;} //Changed from String to Integer in V2, same as above
		public String EmailAddress {get;set;} 
		public String GroupName {get;set;}
        public String GroupNumber{get;set;}
		public String Status {get;set;} 
		public String Address {get;set;} 
		public String State {get;set;} 
		public String Role {get;set;} 
		public String ClientName {get;set;} 
		public Object Weight {get;set;} 
		public String PlanType {get;set;} 
		public Object MaxDailyEarnings {get;set;} 
		public Object TimeZone {get;set;} 
		public Boolean MonthlyEmail {get;set;} 
		public Boolean WeeklyEMail {get;set;} 
		public Boolean OptOutAllEmails {get;set;} 
		public Integer SyncFrequency {get;set;} 
		public Object FraudTier {get;set;} 
		public Boolean FraudLockout {get;set;} 
		public Boolean DoNotLockAccount {get;set;} 
		public Boolean AlternateActivityEligible {get;set;} 
		public Boolean AlternateActivityOptInStatus {get;set;} 
		public Boolean ActiveMemberFlag {get;set;} 
		public Boolean AccountActiveFlag {get;set;} 
        public Object TransactionId {get;set;}
        public Object NullableBirthDate {get;set;}
        public Object NullableRegId {get;set;}
        public Object NullableRuleGroupId {get;set;}
		public Integer Id {get;set;} 
		public Integer LookupClientId {get;set;} 
		public Object ClientMemberId {get;set;} 
		public String FirstName {get;set;} 
		public String LastName {get;set;} 
		public String LookupRuleGroupId {get;set;} //PlanId -> Equivalent to LookupRuleGroupId of Version 1.0, Changed from String to Integer in V2, same as above
		public String Gender {get;set;} 
		public Object SSN {get;set;} 
		public String HomePhone {get;set;} 
		public String City {get;set;} 
		public Object StateCode {get;set;} 
		public String ZipCode {get;set;} 
		public Boolean Active {get;set;} 
		public String DependentCode {get;set;} //Relationship -> Equivalent to DependentCode of Version 1.0
		public String BirthDate {get;set;} 
		public Object PlanState {get;set;} 
		public Boolean IsPreload {get;set;} 
		public Object Height {get;set;} 
		public String OfferCode {get;set;} 
		public String CancelledDateTime {get;set;} 
		public String ProgramStartDate {get;set;} 
		public Object UhcMemberId {get;set;} 
		public Object AlternateId {get;set;} 
		public Object EmployerAssignedId {get;set;} 
		public Object AccountType {get;set;} 
        
		public Data(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'RegisteredMemberId') {
							RegisteredMemberId = String.valueOf(parser.getIntegerValue());
						} else if (text == 'EligibleMemberId') {
							EligibleMemberId = String.valueOf(parser.getIntegerValue());
						} else if (text == 'EmailAddress') {
							EmailAddress = parser.getText();
						} else if (text == 'GroupName') {
							GroupName = parser.getText();
						} else if (text == 'Status') {
							Status = parser.getText();
						} else if (text == 'Address') {
							Address = parser.getText();
						} else if (text == 'State') {
							State = parser.getText();
						} else if (text == 'Role') {
							Role = parser.getText();
						} else if (text == 'ClientName') {
							ClientName = parser.getText();
						} else if (text == 'PlanType') {
							PlanType = parser.getText();
						} else if (text == 'MonthlyEmail') {
							MonthlyEmail = parser.getBooleanValue();
						} else if (text == 'WeeklyEMail') {
							WeeklyEMail = parser.getBooleanValue();
						} else if (text == 'OptOutAllEmails') {
							OptOutAllEmails = parser.getBooleanValue();
						} else if (text == 'SyncFrequency') {
							SyncFrequency = parser.getIntegerValue();
						} else if (text == 'FraudLockout') {
							FraudLockout = parser.getBooleanValue();
						} else if (text == 'DoNotLockAccount') {
							DoNotLockAccount = parser.getBooleanValue();
						} else if (text == 'AlternateActivityEligible') {
							AlternateActivityEligible = parser.getBooleanValue();
						} else if (text == 'AlternateActivityOptInStatus') {
							AlternateActivityOptInStatus = parser.getBooleanValue();
						} else if (text == 'ActiveMemberFlag') {
							ActiveMEMBERFlag = parser.getBooleanValue();
						} else if (text == 'AccountActiveFlag') {
							AccountActiveFlag = parser.getBooleanValue();                        
                        } else if (text == 'Id') {
							Id = parser.getIntegerValue();
						} else if (text == 'LookupClientId') {
							LookupClientId = parser.getIntegerValue();						
						} else if (text == 'FirstName') {
							FirstName = parser.getText();
						} else if (text == 'LastName') {
							LastName = parser.getText();
						} else if (text == 'OfferCode') {
							GroupNumber = parser.getText();
						} else if (text == 'planId') {
							LookupRuleGroupId = String.valueOf(parser.getIntegerValue());
						}else if (text == 'Gender') {
							Gender = parser.getText();			
						} else if (text == 'City') {
							City = parser.getText();
						} else if (text == 'StateCode') {
							//StateCode = parser.readValueAs(Object.class);
						} else if (text == 'ZipCode') {
							ZipCode = parser.getText();
						} else if (text == 'Active') {
							Active = parser.getBooleanValue();
						} else if (text == 'Relationship') {
							DependentCode = parser.getText();
						} else if (text == 'BirthDate') {
							BirthDate = parser.getText();						
						} else if (text == 'IsPreload') {
							IsPreload = parser.getBooleanValue();												
						} else if (text == 'CancelledDateTime') {
							CancelledDateTime = parser.getText();
						} else if (text == 'ProgramStartDate') {
							ProgramStartDate = parser.getText();			
                        } else if(text == 'HomePhone') {
                            HomePhone = parser.getText();
                        } else {
							System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class PageDetails {
		@AuraEnabled public Integer Total {get;set;} 
		@AuraEnabled public Integer Offset {get;set;} 
		@AuraEnabled public Integer Limit_Z {get;set;} // in json: Limit
		@AuraEnabled public Integer TotalPages {get;set;} 
		@AuraEnabled public Boolean LastPage {get;set;} 

		public PageDetails(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Total') {
							Total = parser.getIntegerValue();
						} else if (text == 'Offset') {
							Offset = parser.getIntegerValue();
						} else if (text == 'Limit') {
							Limit_Z = parser.getIntegerValue();
						} else if (text == 'TotalPages') {
							TotalPages = parser.getIntegerValue();
						} else if (text == 'LastPage') {
							LastPage = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'PageDetails consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	@AuraEnabled 
	public static MotionMemberwrapper parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new MotionMemberwrapper(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	



    private static List<Data> arrayOfData(System.JSONParser p) {
        List<Data> res = new List<Data>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Data(p));
        }
        return res;
    }

}