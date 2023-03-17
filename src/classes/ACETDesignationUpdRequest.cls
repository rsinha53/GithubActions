/* Class Name:ACETDesignationUpdRequest
 * Author:Chandan
 * Created Date: 07/05/2020
 * Description: Class to generate request for Designation Update API
**/
public class  ACETDesignationUpdRequest {
    
    public Family family;

	public class Family {
		public String acetFamilyId;
		public String adviserMsId;
		public String advisorFullName;
		public String designation;
	}
    
	public static ACETDesignationUpdRequest parse(String json) {
		return (ACETDesignationUpdRequest) System.JSON.deserialize(json, ACETDesignationUpdRequest.class);
	}
    
    public String addSearchInput(String acetFamilyId,String adviserMsId,String advisorFullName,String designation) {
        family = new Family();
        family.acetFamilyId=acetFamilyId;
        family.adviserMsId=advisorFullName.equalsIgnoreCase('Unassigned')?'':adviserMsId;
        family.advisorFullName=advisorFullName;
        family.designation=designation;
        return JSON.serialize(this);
    }
}