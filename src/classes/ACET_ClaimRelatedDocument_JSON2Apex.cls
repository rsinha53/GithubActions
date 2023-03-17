public class ACET_ClaimRelatedDocument_JSON2Apex {

	public Boolean moreRecordsLeft;
	public Integer startRow;
	public Integer totalRecords;
	public String scrollId;
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


	public static ACET_ClaimRelatedDocument_JSON2Apex parse(String json) {
        system.debug('jsondata'+json);
		return (ACET_ClaimRelatedDocument_JSON2Apex) System.JSON.deserialize(json, ACET_ClaimRelatedDocument_JSON2Apex.class);
	}
}