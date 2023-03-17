/*
 * @Desc: US2034021 - Deserialize Find Individuals Response
 * @Date: 12-09-2019
 * @Dev: Malinda
*/
public class SAEMemberStandaloneSearchJSON2Apex {
	
	public class Pagination {
		public String pageNumber {get;set;} 
		public String pageSize {get;set;} 
		public String recordCount {get;set;} 
		public String totalCount {get;set;} 
		public String totalPages {get;set;} 
		public String moreRecords {get;set;} 
		
	}
	
	public FindIndividualsResponse findIndividualsResponse {get;set;} 
	
	public class Address {
		public String typeCode {get;set;} 
		public String addressLine1 {get;set;} 
		public String addressLine2 {get;set;} 
		public String city {get;set;} 
		public String postalCode {get;set;} 
		public String stateCode {get;set;} 
		public String countryCode {get;set;} 
		public String countryDescription {get;set;} 
		
	}
	
	public class Telephone {
		public String phoneType {get;set;} 
		public String phoneNumber {get;set;} 
	
	}
	
	public class FindIndividualsResponse {
		public List<Individuals> individuals {get;set;} 
		public Pagination pagination {get;set;} 
	
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
		public List<String> electronicAddress {get;set;}

	}
	
	public class Identifiers {
		public String id {get;set;} 
		public String type_Z {get;set;} // in json: type
		public String sourceSysCode {get;set;} 
		
	}
	
	public class Name {
		public String firstName {get;set;} 
		public String lastName {get;set;} 
		public String middleName {get;set;} 
		public String nameSuffix {get;set;} 
		
	}
	
}