public without sharing class ADBFIMWebservice {

	public static FIMResultWrapper findIndWs(String memberId, String dob){
        system.debug('+++ '+dob+' // '+memberId);
        ACETWSCalloutResult ws = new ACETWSCalloutResult();
        FIMResultWrapper result = new FIMResultWrapper();
        ws = ACETLGT_FindIndMemberShipsWebService.findIndividualMembershipDashboard(memberId);
        result.fimResponseCode = ws.statusCode;
        if(ws.statusCode == 200){
            if(ws.responseBody !=null){
                ACETLGT_FindIndMembershipsJSON2Apex ACTFMJSON2Apex = (ACETLGT_FindIndMembershipsJSON2Apex)JSON.deserialize(ws.responseBody, ACETLGT_FindIndMembershipsJSON2Apex.class);
        		System.debug('res : ' + ACTFMJSON2Apex);        		
                List<ACETLGT_FindIndMembershipsJSON2Apex.Individuals> members = ACTFMJSON2Apex.findIndividualMembershipsResponse.individuals;
        		for(ACETLGT_FindIndMembershipsJSON2Apex.Individuals m : members){
                    System.debug('SSN : ' + m.socialSecurityNumber);
                    if(dob == m.birthDate){
                        result.memberId = memberId;
                        result.callerSSN = m.socialSecurityNumber;
                        result.callerHomeState= ((m.address!= Null && m.address.statecode!=null && m.address.statecode!= '')?m.address.statecode:'');
                        break;
                    }                    
                }
            }                
        }
        
        system.debug('+++'+result);
        return result;
    }    
            
    
}