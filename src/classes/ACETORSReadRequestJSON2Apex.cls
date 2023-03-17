/*
    Created By: Chandan Patro
    Created Date: 14th March 2020
    Description: This class is a wraaper class for ORS Read Request Api.
*/
public class ACETORSReadRequestJSON2Apex {
    
    public SearchInput searchInput;
    public class SearchInput {
		public ControlModifiers controlModifiers;
		public String issueId;
	}
    
    public class ControlModifiers {
		public OrsSystemParameters orsSystemParameters;
	}
    
	public class OrsSystemParameters {
		public String logonId;
		public String logonOffice;
	}

	public static ACETORSReadRequestJSON2Apex parse(String json) {
		return (ACETORSReadRequestJSON2Apex) System.JSON.deserialize(json, ACETORSReadRequestJSON2Apex.class);
	}
    
    public String addSearchInput(String logonId,String logonOffice, String issueId) {
        searchInput = new SearchInput();
        ControlModifiers cm= new ControlModifiers();
        OrsSystemParameters ors= new OrsSystemParameters();
        ors.logonId = logonId;
        ors.logonOffice = logonOffice;
        cm.orsSystemParameters=ors;
        searchInput.controlModifiers=cm;
        searchInput.issueId = issueId;
        return JSON.serialize(this);
    }

}