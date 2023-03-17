public class ACET_FacetsGetCasesResponse {

	public class Meta {
		@AuraEnabled public Integer offset {get;set;} 
		@AuraEnabled public Integer limit_Z {get;set;} // in json: limit
		@AuraEnabled public Boolean nextPageInd {get;set;} 

		public Meta(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'offset') {
							offset = parser.getIntegerValue();
						} else if (text == 'limit') {
							limit_Z = parser.getIntegerValue();
						} else if (text == 'nextPageInd') {
							nextPageInd = parser.getBooleanValue();
						} else {
							//System.debug(LoggingLevel.WARN, 'Meta consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Tasks {
		public String seqNo {get;set;} 
		public String customerId {get;set;} 
		public CallerType customerType {get;set;} 
		public CallerType subjectType {get;set;} 
		public String compliantIndicator {get;set;} 
		public String inputDate {get;set;} 
        public String lastUpdateUserId {get;set;}
		public CallerType inputInd {get;set;}
		public String completedDate {get;set;} 
		public String lastUpdatedDate {get;set;} 
		public CallerType categoryCode {get;set;} 
		public CallerType proofOfClosureCode {get;set;} 
		public CallerType priorityCode {get;set;} 
		public CallerType statusReasonCode {get;set;} 
		public CallerType subjectCode {get;set;} 
		public String nextReviewInterval {get;set;} 
		public String nextReviewDate {get;set;} 
		public String receivedDate {get;set;} 
		public String primaryUserId {get;set;} 
		public CallerType statusCode {get;set;} 
		public String summaryText {get;set;} 
		public CallerType noteType {get;set;} 
		public String noteText {get;set;} 
		public String pageType {get;set;} 
		public String providerId {get;set;} 
		public String familyLinkId {get;set;} 

		public Tasks(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'seqNo') {
							seqNo = parser.getText();
						} else if (text == 'customerId') {
							customerId = parser.getText();
						} else if (text == 'customerType') {
							customerType = new CallerType(parser);
						} else if (text == 'subjectType') {
							subjectType = new CallerType(parser);
						} else if (text == 'compliantIndicator') {
							compliantIndicator = parser.getText();
						} else if (text == 'inputDate') {
							inputDate = parser.getText();
						} else if (text == 'inputInd') {
							inputInd = new CallerType(parser);
						} else if (text == 'completedDate') {
							completedDate = parser.getText();
						} else if (text == 'lastUpdatedDate') {
							lastUpdatedDate = parser.getText();
						} else if (text == 'lastUpdateUserId') {
							lastUpdateUserId = parser.getText();
						} else if (text == 'categoryCode') {
							categoryCode = new CallerType(parser);
						} else if (text == 'proofOfClosureCode') {
							proofOfClosureCode = new CallerType(parser);
						} else if (text == 'priorityCode') {
							priorityCode = new CallerType(parser);
						} else if (text == 'statusReasonCode') {
							statusReasonCode = new CallerType(parser);
						} else if (text == 'subjectCode') {
							subjectCode = new CallerType(parser);
						} else if (text == 'nextReviewInterval') {
							nextReviewInterval = parser.getText();
						} else if (text == 'nextReviewDate') {
							nextReviewDate = parser.getText();
						} else if (text == 'receivedDate') {
							receivedDate = parser.getText();
						} else if (text == 'primaryUserId') {
							primaryUserId = parser.getText();
						} else if (text == 'statusCode') {
							statusCode = new CallerType(parser);
						} else if (text == 'summaryText') {
							summaryText = parser.getText();
						} else if (text == 'noteType') {
							noteType = new CallerType(parser);
						} else if (text == 'noteText') {
							noteText = parser.getText();
						} else if (text == 'pageType') {
							pageType = parser.getText();
						} else if (text == 'providerId') {
							providerId = parser.getText();
						} else if (text == 'familyLinkId') {
							familyLinkId = parser.getText();
						} else {
							//System.debug(LoggingLevel.WARN, 'Tasks consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	@AuraEnabled public Meta meta {get;set;} 
	@AuraEnabled public List<Data> data {get;set;}
    @AuraEnabled public Integer responseStatus;
    @AuraEnabled public string responseStatusMessage;

	public ACET_FacetsGetCasesResponse(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'meta') {
						meta = new Meta(parser);
					} else if (text == 'data') {
						data = arrayOfData(parser);
					} else {
						//System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Attributes {
		@AuraEnabled public String inquiryId {get;set;} 
		@AuraEnabled public CallerType callerType {get;set;} 
		@AuraEnabled public CallerType inquiryMethod {get;set;} 
		@AuraEnabled public CallerType satisfactionLevel {get;set;} 
		@AuraEnabled public String disclaimerInd {get;set;} 
		@AuraEnabled public String callerResponse {get;set;} 
		@AuraEnabled public CallerName callerName {get;set;} 
		@AuraEnabled public String languageCode {get;set;} 
		@AuraEnabled public String relationship {get;set;} 
		@AuraEnabled public String idNumber {get;set;} 
		@AuraEnabled public List<Tasks> tasks {get;set;} 

		public Attributes(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'inquiryId') {
							inquiryId = parser.getText();
						} else if (text == 'callerType') {
							callerType = new CallerType(parser);
						} else if (text == 'inquiryMethod') {
							inquiryMethod = new CallerType(parser);
						} else if (text == 'satisfactionLevel') {
							satisfactionLevel = new CallerType(parser);
						} else if (text == 'disclaimerInd') {
							disclaimerInd = parser.getText();
						} else if (text == 'callerResponse') {
							callerResponse = parser.getText();
						} else if (text == 'callerName') {
							callerName = new CallerName(parser);
						} else if (text == 'languageCode') {
							languageCode = parser.getText();
						} else if (text == 'relationship') {
							relationship = parser.getText();
						} else if (text == 'idNumber') {
							idNumber = parser.getText();
						} else if (text == 'tasks') {
							tasks = arrayOfTasks(parser);
						} else {
							//System.debug(LoggingLevel.WARN, 'Attributes consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Data {
		@AuraEnabled public String type_Z {get;set;} // in json: type
		@AuraEnabled public String id {get;set;} 
		@AuraEnabled public Attributes attributes {get;set;} 

		public Data(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'type') {
							type_Z = parser.getText();
						} else if (text == 'id') {
							id = parser.getText();
						} else if (text == 'attributes') {
							attributes = new Attributes(parser);
						} else {
							//System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class CallerType {
		@AuraEnabled public String code {get;set;} 
		@AuraEnabled public String desc_Z {get;set;} // in json: desc

		public CallerType(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'code') {
							code = parser.getText();
						} else if (text == 'desc') {
							desc_Z = parser.getText();
						} else {
							//System.debug(LoggingLevel.WARN, 'CallerType consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class CallerName {
		@AuraEnabled public String firstName {get;set;} 
		@AuraEnabled public String lastName {get;set;} 
		@AuraEnabled public String middleInit {get;set;} 
		@AuraEnabled public String title {get;set;} 

		public CallerName(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'firstName') {
							firstName = parser.getText();
						} else if (text == 'lastName') {
							lastName = parser.getText();
						} else if (text == 'middleInit') {
							middleInit = parser.getText();
						} else if (text == 'title') {
							title = parser.getText();
						} else {
							//System.debug(LoggingLevel.WARN, 'CallerName consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public static ACET_FacetsGetCasesResponse parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new ACET_FacetsGetCasesResponse(parser);
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

    private static List<Tasks> arrayOfTasks(System.JSONParser p) {
        List<Tasks> res = new List<Tasks>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Tasks(p));
        }
        return res;
    }

}