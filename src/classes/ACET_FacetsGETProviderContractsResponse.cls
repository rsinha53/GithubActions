public class ACET_FacetsGETProviderContractsResponse {

	public class InNetworkRelations {
		public String relationPcp {get;set;} 
		public String networkID {get;set;} 
		public String agreementId {get;set;} 
		public Entity networkPrefix {get;set;} 
		public String lineOfBusiness {get;set;} 
		public String effDate {get;set;} 
		public String termDate {get;set;} 

		public InNetworkRelations(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'relationPcp') {
							relationPcp = parser.getText();
						} else if (text == 'networkID') {
							networkID = parser.getText();
						} else if (text == 'agreementId') {
							agreementId = parser.getText();
						} else if (text == 'networkPrefix') {
							networkPrefix = new Entity(parser);
						} else if (text == 'lineOfBusiness') {
							lineOfBusiness = parser.getText();
						} else if (text == 'effDate') {
							effDate = parser.getText();
						} else if (text == 'termDate') {
							termDate = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'InNetworkRelations consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Entity {
		public String code {get;set;} 
		public String desc_Z {get;set;} // in json: desc

		public Entity(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'code') {
							code = parser.getText();
						} else if (text == 'desc') {
							desc_Z = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Entity consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class OutOfNetworkRelations {
		public Entity nonParProdPfx {get;set;} 
		public String agreementId {get;set;} 
		public String effectiveDate {get;set;} 
		public String termDate {get;set;} 

		public OutOfNetworkRelations(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'nonParProdPfx') {
							nonParProdPfx = new Entity(parser);
						} else if (text == 'agreementId') {
							agreementId = parser.getText();
						} else if (text == 'effectiveDate') {
							effectiveDate = parser.getText();
						} else if (text == 'termDate') {
							termDate = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'OutOfNetworkRelations consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Attributes {
		public String providerId {get;set;} 
		public Entity entity {get;set;} 
		public String npi {get;set;} 
		public List<InNetworkRelations> inNetworkRelations {get;set;} 
		public List<OutOfNetworkRelations> outOfNetworkRelations {get;set;} 
		public List<ProvAgreements> provAgreements {get;set;} 

		public Attributes(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'providerId') {
							providerId = parser.getText();
						} else if (text == 'entity') {
							entity = new Entity(parser);
						} else if (text == 'npi') {
							npi = parser.getText();
						} else if (text == 'inNetworkRelations') {
							inNetworkRelations = arrayOfInNetworkRelations(parser);
						} else if (text == 'outOfNetworkRelations') {
							outOfNetworkRelations = arrayOfOutOfNetworkRelations(parser);
						} else if (text == 'provAgreements') {
							provAgreements = arrayOfProvAgreements(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Attributes consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class RiskWithhold {
		public String riskWithholdPct {get;set;} 

		public RiskWithhold(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'riskWithholdPct') {
							riskWithholdPct = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'RiskWithhold consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Discounts {
		public String agppPrmptPayDisc {get;set;} 
		public String minimumDiscount {get;set;} 
		public String maximumDiscount {get;set;} 
		public String strgtDefPricDiscType {get;set;} 
		public String strgtDefPricDiscMethod {get;set;} 
		public String strgtDefPricDiscPric {get;set;} 

		public Discounts(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'agppPrmptPayDisc') {
							agppPrmptPayDisc = parser.getText();
						} else if (text == 'minimumDiscount') {
							minimumDiscount = parser.getText();
						} else if (text == 'maximumDiscount') {
							maximumDiscount = parser.getText();
						} else if (text == 'strgtDefPricDiscType') {
							strgtDefPricDiscType = parser.getText();
						} else if (text == 'strgtDefPricDiscMethod') {
							strgtDefPricDiscMethod = parser.getText();
						} else if (text == 'strgtDefPricDiscPric') {
							strgtDefPricDiscPric = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Discounts consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class RelatedPrefixes {
		public Entity agseServDefnPfx {get;set;} 
		public String agdpPrefix {get;set;} 
		public String agcbPrefix {get;set;} 
		public String agcgPrefix {get;set;} 
		public String aghiPrefix {get;set;} 
		public String agipPrefix {get;set;} 
		public String agslPrefix {get;set;} 
		public String agppPrefix {get;set;} 
		public String agpdPrefix {get;set;} 
		public String agrgPrefix {get;set;} 
		public String agrtPrefix {get;set;} 
		public String agilPrefix {get;set;} 
		public String agmdPrefix {get;set;} 
		public String ageaPrefix {get;set;} 
		public String agdePrefix {get;set;} 
		public String agdaPrefix {get;set;} 
		public String agutPrefix {get;set;} 
		public String agaaPrefix {get;set;} 
		public String agafPrefix {get;set;} 
		public String agsvPrefix {get;set;} 
		public String aglpPrefix {get;set;} 
		public String agwfPrefix {get;set;} 
		public String itagPrefix {get;set;} 

		public RelatedPrefixes(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'agseServDefnPfx') {
							agseServDefnPfx = new Entity(parser);
						} else if (text == 'agdpPrefix') {
							agdpPrefix = parser.getText();
						} else if (text == 'agcbPrefix') {
							agcbPrefix = parser.getText();
						} else if (text == 'agcgPrefix') {
							agcgPrefix = parser.getText();
						} else if (text == 'aghiPrefix') {
							aghiPrefix = parser.getText();
						} else if (text == 'agipPrefix') {
							agipPrefix = parser.getText();
						} else if (text == 'agslPrefix') {
							agslPrefix = parser.getText();
						} else if (text == 'agppPrefix') {
							agppPrefix = parser.getText();
						} else if (text == 'agpdPrefix') {
							agpdPrefix = parser.getText();
						} else if (text == 'agrgPrefix') {
							agrgPrefix = parser.getText();
						} else if (text == 'agrtPrefix') {
							agrtPrefix = parser.getText();
						} else if (text == 'agilPrefix') {
							agilPrefix = parser.getText();
						} else if (text == 'agmdPrefix') {
							agmdPrefix = parser.getText();
						} else if (text == 'ageaPrefix') {
							ageaPrefix = parser.getText();
						} else if (text == 'agdePrefix') {
							agdePrefix = parser.getText();
						} else if (text == 'agdaPrefix') {
							agdaPrefix = parser.getText();
						} else if (text == 'agutPrefix') {
							agutPrefix = parser.getText();
						} else if (text == 'agaaPrefix') {
							agaaPrefix = parser.getText();
						} else if (text == 'agafPrefix') {
							agafPrefix = parser.getText();
						} else if (text == 'agsvPrefix') {
							agsvPrefix = parser.getText();
						} else if (text == 'aglpPrefix') {
							aglpPrefix = parser.getText();
						} else if (text == 'agwfPrefix') {
							agwfPrefix = parser.getText();
						} else if (text == 'itagPrefix') {
							itagPrefix = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'RelatedPrefixes consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Data {
		public String type_Z {get;set;} // in json: type
		public String id {get;set;} 
		public Attributes attributes {get;set;} 

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
							System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ProfileInfo {
		public String profileOverrideID {get;set;} 

		public ProfileInfo(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'profileOverrideID') {
							profileOverrideID = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ProfileInfo consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class DelegateInfo {
		public String delegServRelatedEnt {get;set;} 

		public DelegateInfo(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'delegServRelatedEnt') {
							delegServRelatedEnt = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'DelegateInfo consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	/*public class OutlierInfo {
		public String outlierDiscount {get;set;} 

		public OutlierInfo(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'outlierDiscount') {
							outlierDiscount = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'OutlierInfo consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}*/
	
	public class PymtDrag {

		public PymtDrag(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						{
							System.debug(LoggingLevel.WARN, 'PymtDrag consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Dofr {
		public String dofrID {get;set;} 
		public String delCredentialingID {get;set;} 
		public String delegatedQmID {get;set;} 

		public Dofr(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'dofrID') {
							dofrID = parser.getText();
						} else if (text == 'delCredentialingID') {
							delCredentialingID = parser.getText();
						} else if (text == 'delegatedQmID') {
							delegatedQmID = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Dofr consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ProvAgreements {
		public String agreementId {get;set;} 
		public String agreementDesc {get;set;} 
		public String agreementEffDt {get;set;} 
		public String agreementTermDt {get;set;} 
		public String agreemtPrevTermDt {get;set;} 
		public Entity agreementType {get;set;} 
		public Integer claimAcceptMonths {get;set;} 
		public String outpatientPricingType {get;set;} 
		public String networxProfPricing {get;set;} 
		public String multipleSurgeryPct {get;set;} 
		public DelegateInfo delegateInfo {get;set;} 
		public ProfileInfo profileInfo {get;set;} 
		public RiskWithhold riskWithhold {get;set;} 
		public OutlierInfo outlierInfo {get;set;} 
		public Discounts discounts {get;set;} 
		public PymtDrag pymtDrag {get;set;} 
		public RelatedPrefixes relatedPrefixes {get;set;} 
		public Dofr dofr {get;set;} 
		public String inpatientPricingType {get;set;} 

		public ProvAgreements(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'agreementId') {
							agreementId = parser.getText();
						} else if (text == 'agreementDesc') {
							agreementDesc = parser.getText();
						} else if (text == 'agreementEffDt') {
							agreementEffDt = parser.getText();
						} else if (text == 'agreementTermDt') {
							agreementTermDt = parser.getText();
						} else if (text == 'agreemtPrevTermDt') {
							agreemtPrevTermDt = parser.getText();
						} else if (text == 'agreementType') {
							agreementType = new Entity(parser);
						} else if (text == 'claimAcceptMonths') {
							claimAcceptMonths = parser.getIntegerValue();
						} else if (text == 'outpatientPricingType') {
							outpatientPricingType = parser.getText();
						} else if (text == 'networxProfPricing') {
							networxProfPricing = parser.getText();
						} else if (text == 'multipleSurgeryPct') {
							multipleSurgeryPct = parser.getText();
						} else if (text == 'delegateInfo') {
							delegateInfo = new DelegateInfo(parser);
						} else if (text == 'profileInfo') {
							profileInfo = new ProfileInfo(parser);
						} else if (text == 'riskWithhold') {
							riskWithhold = new RiskWithhold(parser);
						} else if (text == 'outlierInfo') {
							outlierInfo = new OutlierInfo(parser);
						} else if (text == 'discounts') {
							discounts = new Discounts(parser);
						} else if (text == 'pymtDrag') {
							pymtDrag = new PymtDrag(parser);
						} else if (text == 'relatedPrefixes') {
							relatedPrefixes = new RelatedPrefixes(parser);
						} else if (text == 'dofr') {
							dofr = new Dofr(parser);
						} else if (text == 'inpatientPricingType') {
							inpatientPricingType = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ProvAgreements consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class OutlierInfo {
		public String outlierIndicator {get;set;} 
		public String outlierLimit {get;set;} 
		public String outlierDiscount {get;set;} 

		public OutlierInfo(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'outlierIndicator') {
							outlierIndicator = parser.getText();
						} else if (text == 'outlierLimit') {
							outlierLimit = parser.getText();
						} else if (text == 'outlierDiscount') {
							outlierDiscount = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'OutlierInfo consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public Data data {get;set;} 

	public ACET_FacetsGETProviderContractsResponse(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'data') {
						data = new Data(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'ACET_FacetsGETProviderContractsResponse consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static ACET_FacetsGETProviderContractsResponse parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new ACET_FacetsGETProviderContractsResponse(parser);
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
	
    private static List<OutOfNetworkRelations> arrayOfOutOfNetworkRelations(System.JSONParser p) {
        List<OutOfNetworkRelations> res = new List<OutOfNetworkRelations>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new OutOfNetworkRelations(p));
        }
        return res;
    }

    private static List<ProvAgreements> arrayOfProvAgreements(System.JSONParser p) {
        List<ProvAgreements> res = new List<ProvAgreements>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new ProvAgreements(p));
        }
        return res;
    }

    private static List<InNetworkRelations> arrayOfInNetworkRelations(System.JSONParser p) {
        List<InNetworkRelations> res = new List<InNetworkRelations>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new InNetworkRelations(p));
        }
        return res;
    }

}