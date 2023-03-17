/**
* Author: Hasara Disanayaka
* Date Created: 05/03/2020
* Date Modified:
* Purpose: To Capture the MPE service Response
* 
**/
public without sharing class ADBMPEResponseWrapper {
    public String responseCode;
    public String responseMsg;
    public String responseDetailMsg;
    
    // Response variable coming from service and need for the use
    public memberProductEligibilityResponse MemberProductEligibilityResponse;
    
    public class memberProductEligibilityResponse{
        public List<ConsumerDetails> consumerDetails;   
    }
    
    public class ConsumerDetails {
        public IdSet idSet;
        public PopulationDetails populationDetails;
    }
    
    public class PopulationDetails {
        public String populationId;
    }
    
    public class IdSet {
        public Integer personId;
    }
       public static ADBMPEResponseWrapper parse(String json) {
        return (ADBMPEResponseWrapper) System.JSON.deserialize(json, ADBMPEResponseWrapper.class);
    } 
}