public class ACET_EPMPMemberDetailsJSON2Apex {

	public ContactInfo contactInfo{get;set;}    
    
	public class ContactInfo {
		public List<ElectronicContacts> electronicContacts{get;set;}
		public List<Telephones> telephones{get;set;}
	}

	public class ElectronicContacts {
		public String electronicAddress{get;set;}
		public String primaryElectronicAddressIndicator{get;set;}
	}    
    
	public class AddressTypeDescription {
		public String text{get;set;}
	}

	public class AddressTypeCode {
		public String code{get;set;}
	}

	public class Telephones {
		public AddressTypeCode communicationTypeCode{get;set;}
		public AddressTypeDescription communicationTypeDescription{get;set;}
		public String telephoneNumber{get;set;}
		public String extension{get;set;}
		public String primaryTelephoneIndicator{get;set;}
	}
	
	public static ACET_EPMPMemberDetailsJSON2Apex parse(String json) {
		return (ACET_EPMPMemberDetailsJSON2Apex) System.JSON.deserialize(json, ACET_EPMPMemberDetailsJSON2Apex.class);
	}
}