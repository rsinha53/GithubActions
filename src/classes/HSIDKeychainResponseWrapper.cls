public class HSIDKeychainResponseWrapper {
        
    public String status;
    public String eid;
    public Keychains keychains;
    public String createDateTime;
    public String lastUpdateDateTime;
    
    public class EligibilityInfo {
        public Name name;
        public Identifiers identifiers;
    }
    
    public class Identifiers {
        public String policy;
    }
    
    public class Keychains {
        public Careadvisor careadvisor;
    }
    
    public class Name {
        public String first;
        public String last;
    }
    
    public class Careadvisor {
        public String dob;
        public List<EligibilityInfo> eligibilityInfo;
    }
    
    
    public HSIDKeychainResponseWrapper parse(String json) {
        System.debug('json-->' +json);
        System.debug('(HSIDKeychainResponseWrapper)System.JSON.deserialize(json, HSIDKeychainResponseWrapper.class)' +(HSIDKeychainResponseWrapper)System.JSON.deserialize(json, HSIDKeychainResponseWrapper.class));
        return (HSIDKeychainResponseWrapper) System.JSON.deserialize(String.valueOf(json), HSIDKeychainResponseWrapper.class);
    }
    
}