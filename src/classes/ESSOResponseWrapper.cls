public class ESSOResponseWrapper {

	public class UserDetail {
		public Credential credential {get;set;} 
		public UserAccountStatus UserAccountStatus {get;set;} 
		public Boolean migratedUser {get;set;} 
		public Boolean usernameChangeRequired {get;set;} 
		public Boolean passwordChangeRequired {get;set;} 

		public UserDetail(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'credential') {
							credential = new Credential(parser);
						} else if (text == 'UserAccountStatus') {
							UserAccountStatus = new UserAccountStatus(parser);
						} else if (text == 'migratedUser') {
							migratedUser = parser.getBooleanValue();
						} else if (text == 'usernameChangeRequired') {
							usernameChangeRequired = parser.getBooleanValue();
						} else if (text == 'passwordChangeRequired') {
							passwordChangeRequired = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'UserDetail consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Credential {
		public List<SecurityQuestionAndAnswers> securityQuestionAndAnswers {get;set;} 
		public List<String> types {get;set;} 

		public Credential(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'securityQuestionAndAnswers') {
							securityQuestionAndAnswers = arrayOfSecurityQuestionAndAnswers(parser);
						} else if (text == 'types') {
							types = arrayOfString(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Credential consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class UserName {
		public String value {get;set;} 
		public Boolean userAware {get;set;} 

		public UserName(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'value') {
							value = parser.getText();
						} else if (text == 'userAware') {
							userAware = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'UserName consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public String status {get;set;} 
	public Resources Resources {get;set;} 
    
    public ESSOResponseWrapper() {	
	}

	public ESSOResponseWrapper(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'status') {
						status = parser.getText();
					} else if (text == 'Resources') {
						Resources = new Resources(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'ESSOResponseWrapper consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class UserAccountStatus {
		public String passwordStatus {get;set;} 
		public String aaStatus {get;set;} 
		public String lastSuccessfulLoginTime {get;set;} 
		public String lastPasswordChangeTime {get;set;} 
		public String lastPasswordDisableTime {get;set;} 

		public UserAccountStatus(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'passwordStatus') {
							passwordStatus = parser.getText();
						} else if (text == 'aaStatus') {
							aaStatus = parser.getText();
						} else if (text == 'lastSuccessfulLoginTime') {
							lastSuccessfulLoginTime = parser.getText();
						} else if (text == 'lastPasswordChangeTime') {
							lastPasswordChangeTime = parser.getText();
						} else if (text == 'lastPasswordDisableTime') {
							lastPasswordDisableTime = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'UserAccountStatus consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class UserPayload {
		public List<String> UserType {get;set;} 
		public UUID dateOfBirth {get;set;} 
		public String firstName {get;set;} 
		public String lastName {get;set;} 
		public String gender {get;set;} 
		public List<Emails> emails {get;set;} 
		public UserDetail UserDetail {get;set;} 

		public UserPayload(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'UserType') {
							UserType = arrayOfString(parser);
						} else if (text == 'dateOfBirth') {
							dateOfBirth = new UUID(parser);
						} else if (text == 'firstName') {
							firstName = parser.getText();
						} else if (text == 'lastName') {
							lastName = parser.getText();
						} else if (text == 'gender') {
							gender = parser.getText();
						} else if (text == 'emails') {
							emails = arrayOfEmails(parser);
						} else if (text == 'UserDetail') {
							UserDetail = new UserDetail(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'UserPayload consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class UserIdentificationData {
		public UserName userName {get;set;} 
		public UUID UUID {get;set;} 

		public UserIdentificationData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'userName') {
							userName = new UserName(parser);
						} else if (text == 'UUID') {
							UUID = new UUID(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'UserIdentificationData consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Resource {
		public UserIdentificationData UserIdentificationData {get;set;} 
		public UserPayload UserPayload {get;set;} 

		public Resource(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'UserIdentificationData') {
							UserIdentificationData = new UserIdentificationData(parser);
						} else if (text == 'UserPayload') {
							UserPayload = new UserPayload(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Resource consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Emails {
		public String value {get;set;} 
		public String label {get;set;} 
		public Boolean default_Z {get;set;} 
		public Boolean verified {get;set;} 
		public Boolean unique {get;set;} 

		public Emails(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'value') {
							value = parser.getText();
						} else if (text == 'label') {
							label = parser.getText();
						} else if (text == 'default') {
							default_Z = parser.getBooleanValue();
						} else if (text == 'verified') {
							verified = parser.getBooleanValue();
						} else if (text == 'unique') {
							unique = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Emails consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Resources {
		public List<Resource> Resource {get;set;} 

		public Resources(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Resource') {
							Resource = arrayOfResource(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Resources consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class UUID {
		public String value {get;set;} 

		public UUID(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'value') {
							value = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'UUID consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class SecurityQuestionAndAnswers {
		public String id {get;set;} 
		public String question {get;set;} 

		public SecurityQuestionAndAnswers(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'question') {
							question = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'SecurityQuestionAndAnswers consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
    
	
	public ESSOResponseWrapper parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new ESSOResponseWrapper(parser);
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
	
    private static List<SecurityQuestionAndAnswers> arrayOfSecurityQuestionAndAnswers(System.JSONParser p) {
        List<SecurityQuestionAndAnswers> res = new List<SecurityQuestionAndAnswers>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new SecurityQuestionAndAnswers(p));
        }
        return res;
    }
    
    private static List<Resource> arrayOfResource(System.JSONParser p) {
        List<Resource> res = new List<Resource>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Resource(p));
        }
        return res;
    }

    private static List<String> arrayOfString(System.JSONParser p) {
        List<String> res = new List<String>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getText());
        }
        return res;
    }

    private static List<Emails> arrayOfEmails(System.JSONParser p) {
        List<Emails> res = new List<Emails>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Emails(p));
        }
        return res;
    }
}