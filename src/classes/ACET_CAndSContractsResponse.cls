// US2186401 - Thanish - 31st Dec 2019
// used to parse and store the response from C and S Contract api
public class ACET_CAndSContractsResponse {

	public class Communityandstate {
		public String prov_id;
		public String tax_id_nbr;
		public String tax_id_typ_cd;
		public String adr_id;
		public String adr_typ_cd;
		public String ovtn_contr_id;
		public String ovtn_contr_seq_nbr;
		public String ovtn_lob_typ_cd;
		public String ovtn_lob_desc;
		public String ovtn_pnl_typ_cd;
		public String ovtn_pnl_desc;
		public String ovtn_ipa_typ_cd;
		public String ovtn_par_prov_ind;
		public String ovtn_prc_pkg_cd;
		public String ovtn_prc_pkg_nprtcp_cd;
		public String ovtn_pcp_ind;
		public String ovtn_acpt_new_ptnt_ind;
		public String ovtn_acpt_xst_ptnt_ind;
		public String ovtn_acpt_gdr_cd;
		public String ovtn_tmln_rsn_typ_cd;
		public String csp_pltfm_prov_id;
		public List<Bsar> bsar;
		public String ovtn_bil_eff_dt;
		public String ovtn_eff_dt;
		public String ovtn_canc_dt;
	}

	public List<Communityandstate> communityandstate;
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

	public class Bsar {
		public String bsar_actv_cd;
		public String bsar_id;
		public String bsar_bus_seg_cd;
		public String bsar_adr_rel_seq_nbr;
	}

    // parses C And S JSON response to an ACET_CAndSContractsResponse object
	public static ACET_CAndSContractsResponse parse(String json) {
		return (ACET_CAndSContractsResponse) System.JSON.deserialize(json, ACET_CAndSContractsResponse.class);
	}
}