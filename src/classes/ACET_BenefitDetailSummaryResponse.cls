public class ACET_BenefitDetailSummaryResponse {
    
    public Boolean newBenefits {get;set;} 
    public List<Benefit> benefit {get;set;} 
    
    public ACET_BenefitDetailSummaryResponse(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'newBenefits') {
                        newBenefits = parser.getBooleanValue();
                    } else if (text == 'benefit') {
                        benefit = arrayOfBenefit(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'ACET_BenefitDetailSummaryResponse consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class Benefit {
        public String benefitName {get;set;} 
        public String benefitDetails {get;set;} 
        public List<BenefitNetworkSection> benefitNetworkSection {get;set;} 
        //public List<LimitsAndExceptions> limitsAndExceptions {get;set;} 
        
        public Benefit(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'benefitName') {
                            benefitName = parser.getText();
                        } else if (text == 'benefitDetails') {
                            benefitDetails = parser.getText();
                        } else if (text == 'benefitNetworkSection') {
                            benefitNetworkSection = arrayOfBenefitNetworkSection(parser);
                        } else if (text == 'limitsAndExceptions') {
                            //limitsAndExceptions = arrayOfLimitsAndExceptions(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Benefit consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class BenefitNetworkSection {
        public String costs {get;set;} 
        public List<String> networkStatus {get;set;} 
        
        public BenefitNetworkSection(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'costs') {
                            costs = parser.getText();
                        } else if (text == 'networkStatus') {
                            networkStatus = arrayOfString(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'BenefitNetworkSection consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    /*public class LimitsAndExceptions {
        
        public LimitsAndExceptions(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        {
                            System.debug(LoggingLevel.WARN, 'LimitsAndExceptions consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }*/
    
    
    public static ACET_BenefitDetailSummaryResponse parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new ACET_BenefitDetailSummaryResponse(parser);
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
    
    
    
    
    
    /*private static List<LimitsAndExceptions> arrayOfLimitsAndExceptions(System.JSONParser p) {
        List<LimitsAndExceptions> res = new List<LimitsAndExceptions>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new LimitsAndExceptions(p));
        }
        return res;
    }*/
    
    
    private static List<BenefitNetworkSection> arrayOfBenefitNetworkSection(System.JSONParser p) {
        List<BenefitNetworkSection> res = new List<BenefitNetworkSection>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new BenefitNetworkSection(p));
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
    
    
    
    private static List<Benefit> arrayOfBenefit(System.JSONParser p) {
        List<Benefit> res = new List<Benefit>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Benefit(p));
        }
        return res;
    }
    
}