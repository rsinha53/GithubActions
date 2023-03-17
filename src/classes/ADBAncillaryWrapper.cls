public class ADBAncillaryWrapper {

	public class Cov_typ_ref_cd {
		public String ref_dspl;
		public String ref_desc;
	}

	public class Mbrshp {
		public String src_mbr_id;
		public String orig_sys_mbr_id;
		public String orig_sys_cd;
		public List<Mbr_covs> mbr_covs;
	}

	public Data data;

	public class Mbr_covs {
		public Integer cov_typ_ref_id;
		public Cov_typ_ref_cd cov_typ_ref_cd;
		public String carr_nm;
		public String cov_eff_dt;
		public String cov_end_dt;
		public List<Mbr_cov_phmds> mbr_cov_phmds;
	}

	public class Data {
		public List<Mbrshp> mbrshp;
	}

	public class Mbr_cov_phmds {
		public String pln_cd;
		public String pln_nm;
	}

	
	public static ADBAncillaryWrapper parse(String json) {
		return (ADBAncillaryWrapper) System.JSON.deserialize(json, ADBAncillaryWrapper.class);
	}
}