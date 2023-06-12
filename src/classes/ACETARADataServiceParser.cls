public class ACETARADataServiceParser {
    public String patient_name; // Hello
    public String subscriber_nbr;
    public String policy_id;
    public String alt_id ;
    public String birthdate;
    Public String prior_auth_number;
    Public String prior_auth_status;
    Public String prior_auth_decision;
    Public String submitted_date ;
    Public String procedure_code;
    Public String expected_procedure_date;
    Public String alert_type;
    Public String alert_shared_date;
    Public String benefit_therapy_indicator;
    Public String coverage_type;
    Public String total_benefit_limit;
    Public String benefit_limit_used;
    Public String percent_benefit_used;
    Public String limit_exceeded_claim_proc_date;
    Public String benefit_start_date;
    Public String benefit_end_date;
    Public String plan_type;
    Public String benefit_network_type;
    Public String soft_or_hard_limit;
    Public String caseid;
    Public String hosp_state;
    Public String prov_mpin;
    Public String hosp_name;
    Public String admitdate;
    Public String dischargedate;
    Public String admit_reason_dx_code;
    Public String admit_reason_dxcode_desc;
    Public String case_manager;
    Public String days_since_last_admit;
    Public String alert_category;
	
    public static ACETARADataServiceParser parse(String json) {
		return (ACETARADataServiceParser) System.JSON.deserialize(json, ACETARADataServiceParser.class);
	}
}
