//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class Motion_PlanWaiverTest {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    \"data\": ['+
		'        {'+
		'            \"Status\": \"Active\",'+
		'            \"Type\": \"Medical\",'+
		'            \"StartDate\": \"06/08/2020 00:00:00\",'+
		'            \"EndDate\": \"06/08/2020 00:00:00\",'+
		'            \"EnteredBy\": \"AARON ABBOTT\",'+
		'            \"DateEntered\": \"2020-06-08T10:34:08.8732464\",'+
		'            \"ClientAdminNotes\": \"Test\"'+
		'        }'+
		'    ],'+
		'    \"PageDetails\": {'+
		'        \"TotalPages\": 1,'+
		'        \"Limit\": 25,'+
		'        \"Offset\": 1,'+
		'        \"Total\": 1,'+
		'        \"LastPage\": false'+
		'    }'+
		'}';
		Motion_PlanWaiver r = Motion_PlanWaiver.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Motion_PlanWaiver.Data objMedicalWaivers = new Motion_PlanWaiver.Data(System.JSON.createParser(json));
		System.assert(objMedicalWaivers != null);
		System.assert(objMedicalWaivers.Status == null);
		System.assert(objMedicalWaivers.Type_Z == null);
		System.assert(objMedicalWaivers.StartDate == null);
		System.assert(objMedicalWaivers.EndDate == null);
		System.assert(objMedicalWaivers.EnteredBy == null);
		System.assert(objMedicalWaivers.DateEntered == null);
		System.assert(objMedicalWaivers.ClientAdminNotes == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Motion_PlanWaiver.PageDetails objPagination = new Motion_PlanWaiver.PageDetails(System.JSON.createParser(json));
		System.assert(objPagination != null);
		System.assert(objPagination.TotalPages == null);
		System.assert(objPagination.Limit_Z == null);
		System.assert(objPagination.Offset == null);
		System.assert(objPagination.Total == null);
		System.assert(objPagination.LastPage == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Motion_PlanWaiver objWaiver = new Motion_PlanWaiver(System.JSON.createParser(json));
		System.assert(objWaiver != null);
		System.assert(objWaiver.medicalWaivers == null);
		System.assert(objWaiver.pagination == null);
	}
}