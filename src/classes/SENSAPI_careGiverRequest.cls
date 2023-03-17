public class SENSAPI_careGiverRequest {
    
    public String subscriberId; 
    public String action;
    public familyMemberCls familyMember;
    public class familyMemberCls{
        public string sensId; 
        public string firstName;
        public string lastName;
        public String dateOfBirth;
        public string email;
    }
    public static SENSAPI_careGiverRequest parse(String json){
        return (SENSAPI_careGiverRequest) System.JSON.deserialize(json, SENSAPI_careGiverRequest.class);
    }
}