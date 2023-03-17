public without sharing class ACETLGT_CovidVaccineIndicatorWrapper{
	public  ResponseWrapper data {get;set;}
	public class ResponseWrapper {
		public Immunization_indv[] immunization_indv{get;set;}
	}
	public class Immunization_indv {
		public Integer indv_id{get;set;}
		public String fst_nm{get;set;}
		public String lst_nm{get;set;}
		public String bth_dt{get;set;}
		public Integer gdr_ref_id{get;set;}
		public Immunizations[] immunizations{get;set;}
	}
	public class Immunizations{
		public String service_dt{get;set;}
		public String cvx_code{get;set;}
		public String cpt_code{get;set;}
		public String manufacturer{get;set;}
		public String ndc{get;set;}
		public String npi{get;set;}
		public String provider_first_name{get;set;}
		public String provider_last_name{get;set;}
		public String provider_org_name{get;set;}
		public String dose_number{get;set;}
		public String dose_quanity{get;set;}
		public String dose_route{get;set;}
		public String dose_site{get;set;}
		public String expiration_dt{get;set;}
	}
	
	
}