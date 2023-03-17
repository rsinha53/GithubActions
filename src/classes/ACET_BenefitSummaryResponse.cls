public class ACET_BenefitSummaryResponse {
    
    public Boolean newBenefits {get;set;} 
	public List<Benefits> benefits {get;set;} 

	public ACET_BenefitSummaryResponse(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'newBenefits') {
						newBenefits = parser.getBooleanValue();
					} else if (text == 'benefits') {
						benefits = arrayOfBenefits(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'ACET_BenefitSummaryResponse consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Children {
		public String categoryName {get;set;} 
		public String benefitId {get;set;} 

		public Children(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'categoryName') {
							categoryName = parser.getText();
						} else if (text == 'benefitId') {
							benefitId = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Children consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Benefits {
		public String categoryName {get;set;} 
		public List<Children> children {get;set;} 

		public Benefits(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'categoryName') {
							categoryName = parser.getText();
						} else if (text == 'children') {
							children = arrayOfChildren(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Benefits consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static ACET_BenefitSummaryResponse parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new ACET_BenefitSummaryResponse(parser);
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
	

    private static List<Children> arrayOfChildren(System.JSONParser p) {
        List<Children> res = new List<Children>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Children(p));
        }
        return res;
    }




    private static List<Benefits> arrayOfBenefits(System.JSONParser p) {
        List<Benefits> res = new List<Benefits>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Benefits(p));
        }
        return res;
    }

}