public class ACETLGT_AddressSubmitController {
        public class resultwrap {
            @AuraEnabled
                        public string errorMessage{set;get;}
            @AuraEnabled
            public string isSuccess{set;get;}
        }
        public class AddOnFilePersonWrapper {
         @AuraEnabled
        public string personAddOne {get; set;}
                 @AuraEnabled
        public string personAddTwo {get; set;}
                     @AuraEnabled
        public string personCity {get; set;}
                     @AuraEnabled
        public string personState {get; set;}
                     @AuraEnabled
        public string personZipCode {get; set;}
                     @AuraEnabled
        public string personSuffix {get; set;}
                     @AuraEnabled

        public string personFirstName {get; set;}
                     @AuraEnabled

        public string personMiddleName {get; set;}
                     @AuraEnabled

        public string personLastName {get; set;}
            @AuraEnabled
            public string   personOrganization1 {get;set;}
              @AuraEnabled
            public string   personOrganization2 {get;set;}
            @AuraEnabled
            Public string idQualifier {get;set;}
            
                @AuraEnabled
            Public string recipientType {get;set;}
            
                   @AuraEnabled
            Public string recepientId {get;set;}

        }
    @AuraEnabled(continuation=true)
    public static AddOnFilePersonWrapper findMemberInfo(string srk , string MemberId)
    {
        string recepientId;
     string idQualifier;
     string recipientType;
        AddOnFilePersonWrapper AddOnFilePersonWrap = new AddOnFilePersonWrapper();
          ACETMemberDetail memberDetail = new ACETMemberDetail();
        memberDetail.SurrogateKey = srk;
        System.debug('memberDetail.SurrogateKey---'+memberDetail.SurrogateKey);
        ACETGetIndividualWebService stub = new ACETGetIndividualWebService();
        ACETWSCalloutResult calloutResult ;
        if(!String.isEmpty(MemberDetail.SurrogateKey)){
            calloutResult = stub.getIndividual(MemberDetail.SurrogateKey, MemberDetail);     
        } 
        else {
            calloutResult = stub.getIndividual(MemberId, MemberDetail);
            
        }
        system.debug('calloutResult--->'+calloutResult);  
        if(calloutResult.success != null && calloutResult.success){
            memberDetail =  (ACETMemberDetail)calloutResult.Response; 
        }
        system.debug('memberDetail--->'+memberDetail);
        
        map<String,ACETMemberDetail.Address> mapAddress = new map<String,ACETMemberDetail.Address>();
        if(memberDetail.Addresses != null){         
            for(ACETMemberDetail.Address address : memberDetail.Addresses){
                mapAddress.put(address.AddressType , address);      
            }}
        if(mapAddress.get('Mailing') != null){ 
     AddOnFilePersonWrap.personAddOne = mapAddress.get('Mailing').AddressLine1;
             AddOnFilePersonWrap.personAddTwo = mapAddress.get('Mailing').AddressLine2;
           AddOnFilePersonWrap.personCity = mapAddress.get('Mailing').City;
             AddOnFilePersonWrap.personState = mapAddress.get('Mailing').State;
            AddOnFilePersonWrap.personZipCode = mapAddress.get('Mailing').Zip;
        }
        else if(mapAddress.get('Home') != null){ 
            AddOnFilePersonWrap.personAddOne = mapAddress.get('Home').AddressLine1;
            AddOnFilePersonWrap.personAddTwo = mapAddress.get('Home').AddressLine2;
            AddOnFilePersonWrap.personCity = mapAddress.get('Home').City;
            AddOnFilePersonWrap.personState = mapAddress.get('Home').State;
             AddOnFilePersonWrap.personZipCode = mapAddress.get('Home').Zip;
        }
        if(memberDetail.age!= null){
            if(Integer.valueof(memberDetail.age) > 12){
              recepientId = MemberId;
                idQualifier = 'MemberID';
                recipientType = 'Member';
               AddOnFilePersonWrap.personFirstName = memberDetail.FirstName;
                 AddOnFilePersonWrap.personMiddleName = memberDetail.MiddleName;
                 AddOnFilePersonWrap.PersonLastName = memberDetail.LastName;
                AddOnFilePersonWrap.PersonSuffix = memberDetail.Suffix;
            }
            else{
                // if age is less than 12 get subscriber name
               //ACETFindMembershipWebservice MembershipWS = new ACETFindMembershipWebservice();
                //ACETWSCalloutResult memshipResult = MembershipWS.findMembership(MemberId, memberDetail);
                ACETMemberDetail MemberDetailMembership = new ACETMemberDetail();
                
                ACETLGT_FindIndMemberShipsWebService FindIndMemService = new ACETLGT_FindIndMemberShipsWebService();
                ACETWSCalloutResult memshipResult = FindIndMemService.findMemberWS(memberId, memberDetail.firstName, memberDetail.lastName, memberDetail.dob, '', '', '');
                MemberDetailMembership = (ACETMemberDetail)memshipResult.Response;
                ACETGetFamilyMemberWebService Family = new ACETGetFamilyMemberWebService();
                ACETWSCalloutResult res = Family.getFamilyMembers(MemberId,MemberDetailMembership);
                ACETMemberDetail MemberDetailfamily = new ACETMemberDetail();
                idQualifier = 'MemberID';
                recipientType = 'Member';
                MemberDetailfamily = (ACETMemberDetail)res.Response;
                if(MemberDetailfamily != null){
                    for(ACETMemberDetail.FamilyMember fm : MemberDetailfamily.FamilyMembers){
                        if(fm.relationship == '18')
                        {
                           recepientId = fm.subscriberIndividualId;
                             AddOnFilePersonWrap.personFirstName = fm.FirstName;
                           AddOnFilePersonWrap.personMiddleName = fm.MiddleInitial;
                           AddOnFilePersonWrap.PersonLastName = fm.LastName;
                             AddOnFilePersonWrap.PersonSuffix = fm.Suffix;
                        }
                    }
                }
              //  system.debug('ACETWSCalloutResult is '+res);
            }
        }
        AddOnFilePersonWrap.idQualifier = idQualifier;
        AddOnFilePersonWrap.recepientId=recepientId;
        AddOnFilePersonWrap.recipientType=recipientType;
        return AddOnFilePersonWrap; 
    }
        @AuraEnabled(continuation=true)
      public static resultwrap btnSubmit(AddOnFilePersonWrapper AddOnFilePersonWrap,string BusinessUnit,string selectedAddress,string matformids){
system.debug(matformids); 
          Map<string, string> m = (Map<string, string>)JSON.deserialize(matformids, Map<String,String>.class);
system.debug(m.keyset());
          resultwrap rw = new resultwrap();
          try{
            ACETProcessFulfillmentWebservice ACETPFWS = new ACETProcessFulfillmentWebservice();
            ACETWSCalloutResult proFulfillmentCalloutResult = new ACETWSCalloutResult ();
List<Material_Forms__c> matFormsupdated = new List<Material_Forms__c>();
              
    List<Material_Forms__c> matForms =  [SELECT Id,Business_Unit__c,Category__c,Document_Title__c,Document_URL__c,FulfillmentType__c,MRE__c,Quantity__c FROM Material_Forms__c  WHERE ID IN :m.keyset()];
              for(Material_Forms__c mf :matForms){
                  mf.Quantity__c = m.get(mf.id);
                       matFormsupdated.add(mf);
                  
              }
              system.debug(matFormsupdated);
              if(selectedAddress =='AddressOnFile'){
                proFulfillmentCalloutResult = ACETPFWS.processRedeliveryWS(AddOnFilePersonWrap.recepientId, AddOnFilePersonWrap.idQualifier ,AddOnFilePersonWrap.recipientType, AddOnFilePersonWrap.personFirstName, AddOnFilePersonWrap.personMiddleName, AddOnFilePersonWrap.personLastName, AddOnFilePersonWrap.personSuffix, AddOnFilePersonWrap.personAddOne,AddOnFilePersonWrap.personAddtwo, AddOnFilePersonWrap.personCity, AddOnFilePersonWrap.personState,AddOnFilePersonWrap.personZipCode, matFormsupdated,AddOnFilePersonWrap.personOrganization1,AddOnFilePersonWrap.personOrganization2,BusinessUnit);
            }
            else if(selectedAddress =='AlternateAddress'){
                system.debug('selectAddress is '+selectedAddress);
                proFulfillmentCalloutResult = ACETPFWS.processRedeliveryWS(AddOnFilePersonWrap.recepientId,AddOnFilePersonWrap.idQualifier,AddOnFilePersonWrap.recipientType, AddOnFilePersonWrap.personFirstName, AddOnFilePersonWrap.personMiddleName,AddOnFilePersonWrap.personLastName,AddOnFilePersonWrap.personSuffix, AddOnFilePersonWrap.personAddOne,AddOnFilePersonWrap.personAddtwo, AddOnFilePersonWrap.personCity, AddOnFilePersonWrap.personState,AddOnFilePersonWrap.personZipCode, matFormsupdated,AddOnFilePersonWrap.personOrganization1,AddOnFilePersonWrap.personOrganization2,BusinessUnit);
            }
            if(proFulfillmentCalloutResult.success != null && proFulfillmentCalloutResult.success ){ 
                if(proFulfillmentCalloutResult.Message.equalsIgnoreCase('Accepted')){
                    system.debug('Success');
                    rw.isSuccess = 'true';
                } 
                else{
                    rw.isSuccess = 'false';
                }
            }
            else {
                if(proFulfillmentCalloutResult.statusCode==400) {
                  //  setErrorMsg('GN400B');
                }
                else if(proFulfillmentCalloutResult.statusCode==404) {
                  //  setErrorMsg('MR404');
                }
                else {
                   // setErrorMsg('GN'+proFulfillmentCalloutResult.statusCode);
                }
            }

        }
        catch(exception ex)
        {
            system.debug('Exception is '+ex.getMessage()+'at line '+ex.getLineNumber());
        }
        return rw;
    }
}