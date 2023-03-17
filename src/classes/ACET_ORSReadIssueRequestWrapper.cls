public class ACET_ORSReadIssueRequestWrapper {
    
    public class ControlModifiers {
        public OrsSystemParameters orsSystemParameters;
    }
    
    public class OrsSystemParameters {
        public String logonId;
        public String logonOffice;
    }
    
    public ControlModifiers controlModifiers;
    public String issueId;
    
    
    public static ACET_ORSReadIssueRequestWrapper parse(String json) {
        return (ACET_ORSReadIssueRequestWrapper) System.JSON.deserialize(json, ACET_ORSReadIssueRequestWrapper.class);
    }
    
    public String addSearchInput(String logonId,String logonOffice, String issueId) {
        ControlModifiers cm= new ControlModifiers();
        OrsSystemParameters ors= new OrsSystemParameters();
        ors.logonId = logonId;
        ors.logonOffice = logonOffice;
        cm.orsSystemParameters=ors;
        this.issueId = issueId;
        this.controlModifiers = cm;
        return JSON.serialize(this);
        
    }
    
}