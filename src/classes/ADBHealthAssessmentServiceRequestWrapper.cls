public without sharing class ADBHealthAssessmentServiceRequestWrapper {
    public String first_name { get; set; }
    
    public String last_name { get; set; }
    
    public String date_of_birth { get; set; }
    
    public String search_id { get; set; }
    
    public String contract_number { get; set; }
    
    
    // Parameters for capturing response
    
    public String responseCode { get; set; }
    
    public String responseMsg { get; set; }
    
    public hras hra;
    
    public class hras{
        public List<surveys> surveys;
    }
    
    public class surveys{
        public String completionTS;
    }
}