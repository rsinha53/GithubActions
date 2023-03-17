/**
 * @description       : US3385722 - Doc360 Document Search Results Wrapper
 * @author            : Raviteja
 * @group             : Team Styx
 * @last modified on  : 06-08-2021
 * @last modified by  : Raviteja
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   06-08-2021   Raviteja       Initial Version
**/
public class ACETFindDoc360SearchResults {
    
	public Boolean moreRecordsLeft{get;set;}
	public Integer startRow{get;set;}
	public Integer totalRecords{get;set;}
	public String scrollId{get;set;}
	public List<RecordsList> recordsList{get;set;}

	public class RecordsList {
		public String objectId{get;set;}
		public String objectName{get;set;}
		public String mimeType{get;set;}
		public String contentType{get;set;}
		public Integer contentSize{get;set;}
		public String contentFileExtension{get;set;}
		public Integer totalPages{get;set;}
		public String contentStream{get;set;}
		public List<Attributes> attributes{get;set;}
	}

	public class Attributes {
		public Integer classId{get;set;}
		public Integer id{get;set;}
		public String alias1{get;set;}
		public String alias2{get;set;}
		public String conversionFormat{get;set;}
		public String federateSearchAlias{get;set;}
		public String labelName{get;set;}
		public String wildCardIndicator{get;set;}
		public String wildCardMinLengthRequired{get;set;}
		public String legacyLabelName{get;set;}
		public String physicalName{get;set;}
		public String priority{get;set;}
		public String sortNumericInd{get;set;}
		public String value{get;set;}
	}
}