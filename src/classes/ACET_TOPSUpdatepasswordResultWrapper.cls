public class ACET_TOPSUpdatepasswordResultWrapper {

	public class Errors {
		public Integer code;
		public String name;
		public String severity;
		public String origin;
		public String description;
	}

	public PutResult putResult;

	public class PutResult {
		public List<Errors> errors;
		public String sourceSystem;
	}

	
	public static ACET_TOPSUpdatepasswordResultWrapper parse(String json) {
		return (ACET_TOPSUpdatepasswordResultWrapper) System.JSON.deserialize(json, ACET_TOPSUpdatepasswordResultWrapper.class);
	}
}