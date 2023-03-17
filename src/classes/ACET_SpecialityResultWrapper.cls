public class ACET_SpecialityResultWrapper {

	public List<Records> records;
	public Metadata metadata;

	public class Metadata {
		public Integer offset;
		public Integer psize;
		public Integer total;
		public String elapsedTime;
		public String elasticTime;
	}

	public class Records {
		public String active_ind;
		public String code;
		public String description;
		public String shrt_description;
		public String full_description;
	}

	
	public static ACET_SpecialityResultWrapper parse(String json) {
		return (ACET_SpecialityResultWrapper) System.JSON.deserialize(json, ACET_SpecialityResultWrapper.class);
	}
}