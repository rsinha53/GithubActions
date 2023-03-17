/*
 * @Desc: US2974834 - Deserialize  Benefit Check API Response
 * @Date: 18-12-2020
 * @Dev: Kavinda
*/
public class ACET_BenefitCheckResponseWrap {

    @AuraEnabled public List<ServiceLines> serviceLines {get;set;} 
	@AuraEnabled public String serviceStatusCode {get;set;} 
	@AuraEnabled public String serviceStatusDescription {get;set;} 
	@AuraEnabled public String rtaID {get;set;} 
	@AuraEnabled public String transID {get;set;} 
	@AuraEnabled public String icn {get;set;} 

	public class ServiceLines {
		@AuraEnabled public String procedureCode {get;set;} 
		@AuraEnabled public String status {get;set;} 
		@AuraEnabled public String reasonCode {get;set;} 
		@AuraEnabled public String procedureIndex {get;set;} 
	} 

    public static ACET_BenefitCheckResponseWrap parse(String json){
		return (ACET_BenefitCheckResponseWrap) System.JSON.deserialize(json, ACET_BenefitCheckResponseWrap.class);
	}

}