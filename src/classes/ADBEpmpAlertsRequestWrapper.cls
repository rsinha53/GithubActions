// Request wrapper for Alerts API -  US2382023 - Sunil Vennam
public without sharing class ADBEpmpAlertsRequestWrapper {
    public String first_nm{ get; set; }
    public String lst_nm{ get; set; }
    public String policy_nbr{ get; set; }
    public String subscriber_id{ get; set; }
    public String dob{ get; set; }
    public string includeAlertsInResponse{ get; set; }
    public string includeContactInfoInResponse{ get; set; }
    public string calling_app_name{ get; set; }
    public string user_id{ get; set; }
    public string user_type{ get; set; }
    
}