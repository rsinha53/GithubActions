public class ACET_TimelyFilling_Contractor_JSON2Apex {

	
	public class Employerandindividual {
		public String prov_id;
		public String tax_id_nbr;
		public String tax_id_typ_cd;
		public String pnc_eff_dt;
		public String pnc_canc_dt;
		public String pnc_contr_id;
		public String pnc_mkt_nbr;
		public String pnc_mkt_desc;
		public String pnc_mkt_typ_cd;
		public String pnc_mkt_typ_desc;
		public String pnc_ipa_nbr;
		public String pnc_ipa_desc;
		public String pnc_prdct_ofr_id;
		public String pnc_prdct_ofr_desc;
		public String pnc_prd_grp_cd;
		public String pnc_prd_grp_desc;
		public String pnc_fee_sched_nbr;
		public String pnc_pay_meth_cd;
		public String pnc_tax_id_nbr;
		public String pnc_tax_id_typ_cd;
		public String pnc_contr_typ_cd;
		public String pnc_contr_arng_cd;
		public String pnc_contr_arng_desc;
		public String pnc_lst_updt_dt;
		public String pnc_contr_grp_cd;
		public String pnc_acpt_ptnt_cd;
		public String pnc_acpt_ptnt_desc;
		public String pnc_vendr_cd;
		public String pnc_prov_contr_role_cd;
		public String pnc_prov_contr_role_desc;
		public String pnc_optnt_rt_id;
		public String pnc_mdcr_ext_absnt_ind;
		public String pnc_mdcr_ded_pct;
		public String pnc_mdcr_coins_pct;
		public String pnc_rasgn_prov_id;
		public String pnc_rasgn_ipa_nbr;
		public String pnc_rasgn_cmnct_id;
		public String pnc_creat_dt;
		public String pnc_contr_templt_id;
		public String pnc_dicarta_doc_id;
		public String pnc_rt_list_nbr;
		public String pnc_rt_list_ver_nbr;
		public String pnc_facl_contr_typ_cd;
		public String pnc_hcfa_proc_ind;
		public String pnc_untmly_pay_cd;
		public String pnc_rt_spcl_proc_nbr;
		public String pnc_reim_wthld_pct;
		public String pnc_contr_tmpl_seq_nbr;
		public String pnc_cptatn_ffs_ind;
		public String pnc_tmly_fl_day_nbr;
		public String pnc_pnlty_ntfy_id;
		public String pnc_contr_papr_typ_cd;
		public String pnc_rsgn_epd_adr_seq;
		public String pnc_lab_affil_cd;
		public String pnc_enw_opt_out_ind;
		public String cdk_contr_ownr_id;
		public String cdk_bus_seg_cd;
		public String cdk_bus_seg_desc;
		public String cdk_contr_org_cd;
		public String cdk_contr_org_desc;
		public String cdk_prdct_catgy_cd;
		public String cdk_hlth_prov_cd;
		public String cdk_add_desc_typ_cd;
		public String risk_carve_out;
		public String contr_papr_typ_desc;
		public String facl_contr_typ_desc;
		public String pnc_tmln_rsn_typ_cd;
	}

	public List<Employerandindividual> employerandindividual;
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

	public static ACET_TimelyFilling_Contractor_JSON2Apex parse(String json) {
		return (ACET_TimelyFilling_Contractor_JSON2Apex) System.JSON.deserialize(json, ACET_TimelyFilling_Contractor_JSON2Apex.class);
	}
}