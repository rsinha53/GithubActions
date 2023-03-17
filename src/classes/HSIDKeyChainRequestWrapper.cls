public class HSIDKeyChainRequestWrapper {
    
    @AuraEnabled
    public String userUUID;
    
    @AuraEnabled
    public List<String> portals;
    
    public String parse(HSIDKeyChainRequestWrapper hsidDataPayLoad) {
        return System.JSON.serialize(hsidDataPayLoad);
    }
}