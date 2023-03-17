public class ACETFindIndividualResultJSON2Apex{

    public static void consumeObject(JSONParser parser) {
        Integer depth = 0;
        do {
            JSONToken curr = parser.getCurrentToken();
            if (curr == JSONToken.START_OBJECT || 
                curr == JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == JSONToken.END_OBJECT ||
                curr == JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }

    public class Pagination {
        public String pageNumber {get;set;} 
        public String pageSize {get;set;} 
        public String recordCount {get;set;} 
        public String totalCount {get;set;} 
        public String totalPages {get;set;} 

        public Pagination(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'pageNumber') {
                            pageNumber = parser.getText();
                        } else if (text == 'pageSize') {
                            pageSize = parser.getText();
                        } else if (text == 'recordCount') {
                            recordCount = parser.getText();
                        } else if (text == 'totalCount') {
                            totalCount = parser.getText();
                        } else if (text == 'totalPages') {
                            totalPages = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Pagination consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Address {
        public String typeCode {get;set;} 
        public String addressLine1 {get;set;} 
        public String addressLine2 {get;set;} 
        public String city {get;set;} 
        public String postalCode {get;set;} 
        public String stateCode {get;set;} 
        public String countryCode {get;set;} 
        public String countryDescription {get;set;} 

        public Address(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'typeCode') {
                            typeCode = parser.getText();
                        } else if (text == 'addressLine1') {
                            addressLine1 = parser.getText();
                        } else if (text == 'addressLine2') {
                            addressLine2 = parser.getText();
                        } else if (text == 'city') {
                            city = parser.getText();
                        } else if (text == 'postalCode') {
                            postalCode = parser.getText();
                        } else if (text == 'stateCode') {
                            stateCode = parser.getText();
                        } else if (text == 'countryCode') {
                            countryCode = parser.getText();
                        } else if (text == 'countryDescription') {
                            countryDescription = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Address consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Telephone {
        public String phoneType {get;set;} 
        public String phoneNumber {get;set;} 

        public Telephone(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'phoneType') {
                            phoneType = parser.getText();
                        } else if (text == 'phoneNumber') {
                            phoneNumber = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Telephone consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public FindIndividualsResponse findIndividualsResponse {get;set;} 

    public ACETFindIndividualResultJSON2Apex(JSONParser parser) {
        while (parser.nextToken() != JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != JSONToken.VALUE_NULL) {
                    if (text == 'findIndividualsResponse') {
                        findIndividualsResponse = new FindIndividualsResponse(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'Root consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class Name_Z {
        public String firstName {get;set;} 
        public String lastName {get;set;} 

        public Name_Z(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'firstName') {
                            firstName = parser.getText();
                        } else if (text == 'lastName') {
                            lastName = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Name_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class FindIndividualsResponse {
        public List<Individuals> individuals {get;set;} 
        public Pagination pagination {get;set;} 

        public FindIndividualsResponse(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'individuals') {
                            individuals = new List<Individuals>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                individuals.add(new Individuals(parser));
                            }
                        } else if (text == 'pagination') {
                            pagination = new Pagination(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'FindIndividualsResponse consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Individuals {
        public String individualIdentifier {get;set;} 
        public Name name {get;set;} 
        public String birthDate {get;set;} 
        public String genderCode {get;set;} 
        public String socialSecurityNumber {get;set;} 
        public Address address {get;set;} 
        public List<Telephone> telephone {get;set;} 
        public List<Identifiers> identifiers {get;set;} 

        public Individuals(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'individualIdentifier') {
                            individualIdentifier = parser.getText();
                        } else if (text == 'name') {
                            name = new Name(parser);
                        } else if (text == 'birthDate') {
                            birthDate = parser.getText();
                        } else if (text == 'genderCode') {
                            genderCode = parser.getText();
                        } else if (text == 'socialSecurityNumber') {
                            socialSecurityNumber = parser.getText();
                        } else if (text == 'address') {
                            address = new Address(parser);
                        } else if (text == 'telephone') {
                            telephone = new List<Telephone>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                telephone.add(new Telephone(parser));
                            }
                        } else if (text == 'identifiers') {
                            identifiers = new List<Identifiers>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                identifiers.add(new Identifiers(parser));
                            }
                        } else {
                            System.debug(LoggingLevel.WARN, 'Individuals consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Identifiers {
        public String id {get;set;} 
        public String type_Z {get;set;} // in json: type
        public String sourceSysCode {get;set;} 

        public Identifiers(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'type') {
                            type_Z = parser.getText();
                        } else if (text == 'sourceSysCode') {
                            sourceSysCode = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Identifiers consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Address_Z {
        public String typeCode {get;set;} 
        public String addressLine1 {get;set;} 
        public String city {get;set;} 
        public String postalCode {get;set;} 
        public String stateCode {get;set;} 
        public String countryCode {get;set;} 
        public String countryDescription {get;set;} 

        public Address_Z(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'typeCode') {
                            typeCode = parser.getText();
                        } else if (text == 'addressLine1') {
                            addressLine1 = parser.getText();
                        } else if (text == 'city') {
                            city = parser.getText();
                        } else if (text == 'postalCode') {
                            postalCode = parser.getText();
                        } else if (text == 'stateCode') {
                            stateCode = parser.getText();
                        } else if (text == 'countryCode') {
                            countryCode = parser.getText();
                        } else if (text == 'countryDescription') {
                            countryDescription = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Address_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Name {
        public String firstName {get;set;} 
        public String lastName {get;set;} 
        public String middleName {get;set;} 

        public Name(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'firstName') {
                            firstName = parser.getText();
                        } else if (text == 'lastName') {
                            lastName = parser.getText();
                        } else if (text == 'middleName') {
                            middleName = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Name consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    public static ACETFindIndividualResultJSON2Apex parse(String json) {
        return new ACETFindIndividualResultJSON2Apex(System.JSON.createParser(json));
    }

}