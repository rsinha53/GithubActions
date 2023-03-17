@IsTest
public class ACETLGT_EligibilityServiceJSON2APEXTest {
    public static testmethod void test1(){
        ACETLGT_EligibilityServiceJSON2APEX esja = new ACETLGT_EligibilityServiceJSON2APEX();
        esja.status = new ACETLGT_EligibilityServiceJSON2APEX.status();
        esja.status.messages 
            = new List<ACETLGT_EligibilityServiceJSON2APEX.messages>{new ACETLGT_EligibilityServiceJSON2APEX.messages()};
                System.debug(esja.status.messages[0].severity);
        System.debug(esja.status.messages[0].name);
        System.debug(esja.status.messages[0].description);
        System.debug(esja.status.messages[0].code);
        esja.result = new ACETLGT_EligibilityServiceJSON2APEX.result();
        esja.result.data =
            new List<ACETLGT_EligibilityServiceJSON2APEX.data>{new ACETLGT_EligibilityServiceJSON2APEX.data()};
                esja.result.data[0].children = 
                new List<ACETLGT_EligibilityServiceJSON2APEX.children>{new ACETLGT_EligibilityServiceJSON2APEX.children()};
                    System.debug(esja.result.data[0].children[0].behavioralCondition);
        System.debug(esja.result.data[0].children[0].lastName);
        System.debug(esja.result.data[0].children[0].newlyDiagnosed);
        System.debug(esja.result.data[0].children[0].middleInitial);
        System.debug(esja.result.data[0].children[0].medicalCondition);
        System.debug(esja.result.data[0].children[0].firstName);
        System.debug(esja.result.data[0].lob);        
        System.debug(esja.result.data[0].agreedtoPAFS);
        System.debug(esja.result.data[0].assignedTo);
        System.debug(esja.result.data[0].familyLinkID);
        System.debug(esja.result.data[0].accountTypes);
        System.debug(esja.result.data[0].memberID);
        System.debug(esja.result.data[0].localMarket);
        System.debug(esja.result.data[0].policyID);
        System.debug(esja.result.data[0].employeeId);
        System.debug(esja.result.data[0].caregiverName);
        System.debug(esja.result.data[0].serviceGroup);
        System.debug(esja.result.data[0].containmentGroup1);
        System.debug(esja.result.data[0].containmentGroup2);
        System.debug(esja.result.data[0].sniEligibility);
        System.debug(esja.result.data[0].rank);
        System.debug(esja.result.data[0].finaloverflowGroup);
        System.debug(esja.result.data[0].routingThreshold);
        System.debug(esja.result.data[0].referralThreshold);
        System.debug(esja.result.data[0].memberExists);
        System.debug(esja.result.data[0].advisorFullName);
        System.debug(esja.result.data[0].initialCallDate);        
    }
}