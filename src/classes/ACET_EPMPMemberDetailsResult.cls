public class ACET_EPMPMemberDetailsResult {
    
    public List<Telephone> telephones{get;set;}
    public String email{get;set;}
    
    public ACET_EPMPMemberDetailsResult(){}
    
    public ACET_EPMPMemberDetailsResult(ACET_EPMPMemberDetailsJSON2Apex emdj2a){
        if(emdj2a.contactInfo!=null){
            if(!emdj2a.contactInfo.telephones.isEmpty()){
                this.telephones = new List<Telephone>();
                for( ACET_EPMPMemberDetailsJSON2Apex.Telephones telephoneObj: emdj2a.contactInfo.telephones){                    
                    if(telephoneObj.telephoneNumber!=null &&  telephoneObj.telephoneNumber!=''){
                        Telephone tele = new Telephone();
                        tele.PhoneNumber = telephoneObj.telephoneNumber;
                        tele.WorkExt = telephoneObj.extension;
                        tele.PhoneNumberType = telephoneObj.communicationTypeDescription!=null?
                            telephoneObj.communicationTypeDescription.text:'';
                        tele.primaryIndicator = telephoneObj.primaryTelephoneIndicator=='Y'?'Primary':'';
                        this.telephones.add(tele);
                    }
                }
            }
            if(!emdj2a.contactInfo.electronicContacts.isEmpty()){
                for( ACET_EPMPMemberDetailsJSON2Apex.ElectronicContacts emailObj:
                    emdj2a.contactInfo.electronicContacts){
                    this.email = emailObj.primaryElectronicAddressIndicator=='Y'?
                        emailObj.electronicAddress: this.email;
                    if(this.email!=null){
                        break;
                    }
                }
            }
        }
        
    }
    public class Telephone{
        public String PhoneNumber{get;set;}
        public String workExt{get;set;}
        public String PhoneNumberType{get;set;}
        public String primaryIndicator{get;set;}
    } 
}