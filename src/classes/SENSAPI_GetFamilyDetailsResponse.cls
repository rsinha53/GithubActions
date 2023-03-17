/*------------------------------------------------------------
Author:        Pratikshya Satapathy
Description:   Response Wrapper for the service request "Get Family And Member Details"              
Test Class:    Covered in League_GetFamilyDetailsReqProcTest
History
Date             Author                    Comments
-------------------------------------------------------------
08-08-2022      Pratikshya Satapathy        Created
09-06-2022      Neeraja                     Modified
09-07-2022      Tushar Kaore        		Modified
------------------------------------------------------------*/
public class SENSAPI_GetFamilyDetailsResponse implements IRestResponseWrapper{
    
    
    public FamilyAccount familyAccount;
    public API_Status status;
        
    public class FamilyAccount{
        public String alternateId;
        public String subscriberId;
        public String sensId;
        public String overviewSensId;
        public CareAdvisorDetails careAdvisor;
        public List<CareTeam> familyMembers;
        
        public FamilyAccount(){
            this.careAdvisor = new CareAdvisorDetails();
            this.familyMembers = new list<CareTeam>();
        }
    }
    
    
    public class CareAdvisorDetails{ 
       	public	string	firstName;
        //transient public	string	middleName;
        public	string	lastName;
        public	string	sensId;
        //transient  public string	email;
        public	string	bio;
        //transient  public	string	icon;
        public	string	status;
        //transient public	boolean	suspended;
        //transient public	Date joinedSince;
        //transient public	string	username;
        //transient public	string	phone;
        //transient public	string	mobilePhone;
        public	string	role;
    }
    
    public class CareTeam{
        
        public String sensId;
        public String memberUserSensId;
        public String enterpriseId;
        public String overviewSensId;
        public String firstName;
        public String middleName;
        public String lastName;
        public String gender;
        public String relationship;
        public date dateOfBirth;
        public String email;
        public Boolean isPao;
        public Boolean isNonPolicy; 
        public String status;
        public Date addedDate;
        public Date invitedDate;
        public Date registeredDate;
        public Date removedDate;
        public Address address;
        public Boolean smsOptIn;
        public Boolean emailOptIn;
        public String preferredName;
        public String phone;
        public String mobile;
    }
    
    public class Address{
        public String address;
        public String city;
        public String zipcode;
        public String state;
        public String country;
        
        public Address(){
            
        }
    }
    
    public SENSAPI_GetFamilyDetailsResponse(){
        status = new API_Status();
    }
    
    public class API_Status{
        public Boolean isSuccess;
        public Integer responseCode;
        public List<String> errorMessage;
       	
        public API_Status(){
            
        }
        
         public API_Status(Boolean isSuccess, Integer responseCode, String errorMessage){
            this.isSuccess = isSuccess;
            this.responseCode = responseCode;
             this.errorMessage = new List<String>{errorMessage};
        }
        
        public API_Status(Boolean isSuccess, Integer responseCode){
            this.isSuccess = isSuccess;
            this.responseCode = responseCode;
        }
    }
    
}