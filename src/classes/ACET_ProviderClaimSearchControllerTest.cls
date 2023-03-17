@isTest
public class ACET_ProviderClaimSearchControllerTest {
@isTest static void testAllMethods() {
        ACETProviderClaimSearchController claim=new ACETProviderClaimSearchController();
        claim.status='';
        claim.taxid='';
        claim.ReferralNumber='';
        claim.authnumberhide=true;
        claim.searchBy='ClaimNumber';
        claim.searchbyaction();
        claim.searchBy='CaseNumber';
        claim.searchbyaction();
        claim.searchBy='AuthorizationNumber';
        claim.searchbyaction();
        claim.searchBy='referralnumber';
        claim.searchbyaction();
        claim.dateServiceChange();
        claim.dateOfService='Day';
        claim.dateServiceChange();
        claim.dateOfService='ThisYear';
        claim.dateServiceChange();
        claim.dateOfService='LastYear';
        claim.dateServiceChange();
        claim.clear();
        claim.search();
        claim.cancel();
    }
}