public class ACET_NetworkStatusResult {
    
    public Attributes attributes;
    
    public class Attributes {
        public String networkStatus;
        public String primarySpecialty;
    }
    
    
    public static ACET_NetworkStatusResult parse(String json) {
        return (ACET_NetworkStatusResult) System.JSON.deserialize(json, ACET_NetworkStatusResult.class);
    }
}