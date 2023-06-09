//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//
// The supplied json has fields with names that are not valid in apex
// and so can only be parsed with explicitly generated code, this option
// was auto selected for you.

public class Motion_PlanWaiver {

	public class Data {
		public String Status {get;set;} 
		public String Type_Z {get;set;} // in json: Type
		public String StartDate {get;set;} 
		public String EndDate {get;set;} 
		public String EnteredBy {get;set;} 
		public String DateEntered {get;set;} 
		public String ClientAdminNotes {get;set;} 

		public Data(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Status') {
							Status = parser.getText();
						} else if (text == 'Type') {
							Type_Z = parser.getText();
						} else if (text == 'StartDate') {
							StartDate = parser.getText();
						} else if (text == 'EndDate') {
							EndDate = parser.getText();
						} else if (text == 'EnteredBy') {
							EnteredBy = parser.getText();
						} else if (text == 'DateEntered') {
							DateEntered = parser.getText();
						} else if (text == 'ClientAdminNotes') {
							ClientAdminNotes = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'MedicalWaivers consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class PageDetails {
		public Integer TotalPages {get;set;} 
		public Integer Limit_Z {get;set;} //NumberOfRecordsPerPage
		public Integer Offset {get;set;} //CurrentPageNumber
		public Integer Total {get;set;}  //TotalRecordsCount
		public Boolean LastPage {get;set;} //LastPageFlag

		public PageDetails(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'TotalPages') {
							TotalPages = parser.getIntegerValue();
						} else if (text == 'Limit') {
							Limit_Z = parser.getIntegerValue();
						} else if (text == 'Offset') {
							Offset = parser.getIntegerValue();
						} else if (text == 'Total') {
							Total = parser.getIntegerValue();
						} else if (text == 'LastPage') {
							LastPage = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Pagination consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public List<Data> medicalWaivers {get;set;} 
	public PageDetails pagination {get;set;} 

	public Motion_PlanWaiver(JSONParser parser) {
      while (parser.nextToken() !=null && parser.getCurrentToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'data') {
						medicalWaivers = arrayOfMedicalWaivers(parser);
					} else if (text == 'PageDetails') {
						pagination = new PageDetails(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'Waiver consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static Motion_PlanWaiver parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new Motion_PlanWaiver(parser);
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
	





    private static List<Data> arrayOfMedicalWaivers(System.JSONParser p) {
        List<Data> res = new List<Data>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Data(p));
        }
        return res;
    }



}