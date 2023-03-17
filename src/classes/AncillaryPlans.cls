/**
 * @description       : Ancillary Plans UI Wrapper Classic
 * @author            : Raviteja
 * @group             : Styx
 * @last modified on  : 08-06-2021
 * @last modified by  : Raviteja
**/
public class AncillaryPlans{
    public String planName{get;set;}
    public String planType{get;set;}
    public List<Incentives> incentives{get;set;}
    public String planLanguage{get;set;}
    public Boolean incentivecheck{get;set;}
    public Boolean accordioncheck{get;set;}
    
    public class Incentives {
		public String rewardmethod{get;set;}
		public String dailyrewardamount{get;set;}
		public String annualrewardamount{get;set;}
		public String calculationbasis{get;set;}
		public String effectivedate{get;set;}
		public String expirationdate{get;set;}
	} 
}