public class Acet_ICUEFindDocResponseWrapper {

	public Boolean moreRecordsLeft;
	public Integer startRow;
	public Integer totalRecords;
	public Object scrollId;
	public List<RecordsList> recordsList;

	public class RecordsList {
		public String objectId;
		public Object objectName;
		public Object mimeType;
		public String contentType;
		public Integer contentSize;
		public Object contentFileExtension;
		public Integer totalPages;
		public Object contentStream;
		public List<Attributes> attributes;
	}

	public class Attributes {
		public Integer classId;
		public Integer id;
		public Object alias1;
		public Object alias2;
		public Object conversionFormat;
		public Object federateSearchAlias;
		public String labelName;
		public Object wildCardIndicator;
		public Object wildCardMinLengthRequired;
		public String legacyLabelName;
		public String physicalName;
		public Object priority;
		public Object sortNumericInd;
		public String value;
	}

	
	public static Acet_ICUEFindDocResponseWrapper parse(String json) {
		return (Acet_ICUEFindDocResponseWrapper) System.JSON.deserialize(json, Acet_ICUEFindDocResponseWrapper.class);
	}
}