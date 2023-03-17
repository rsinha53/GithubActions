// US2186401 - Thanish - 6th Jan 2019
// used to parse and store the response from M and R Contract api
public class ACET_MAndRContractsResponse {

	public class Medicareandretirement {
		public String prov_id;
		public String tax_id_nbr;
		public String tax_id_typ_cd;
		public String adr_id;
		public String adr_typ_cd;
		public String cos_new_pat_ind;
		public String cos_div;
		public String cos_panel_num;
		public String cos_panel_desc;
		public String cos_prov_type;
		public String cos_prov_num;
		public String cos_status_code;
		public String cos_role;
		public String cos_network_num;
		public String cos_contract_num;
		public String cos_dicarta_doc_id;
		public String cos_contr_templt_id;
		public String cos_eff_dt;
		public String cos_canc_date;
	}

	public List<Medicareandretirement> medicareandretirement;
	public Metadata metadata;

	public class Metadata {
		public Integer offset;
		public Integer psize;
		public Integer total;
		public String elapsedTime;
		public String elasticTime;
		public String versionNumber;
		public String releaseType;
		public String releaseDate;
		public String supportContact;
	}

	
	public static ACET_MAndRContractsResponse parse(String json) {
		return (ACET_MAndRContractsResponse) System.JSON.deserialize(json, ACET_MAndRContractsResponse.class);
	}
}