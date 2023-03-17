// Author - Thanish
// Date - 4th Oct 2019
// Tested class - SAEProviderSearchResultsWrapper

@isTest
private class SAEProviderSearchResultsWrapperTest {

    @isTest
    static void testWrapper() {
        SAEProviderSearchResultsWrapper PSRW = new SAEProviderSearchResultsWrapper();
        
        PSRW.benefitLevel = 'benefitLevel';  PSRW.taxId = 'taxId'; PSRW.lastName = 'lastName';
        PSRW.hospAffil = 'hospAffil'; PSRW.gender = 'gender'; PSRW.npi = 'npi';
        PSRW.firstName = 'firstName'; PSRW.dea = 'dea'; PSRW.language = 'language';
        PSRW.providerId = 'providerId'; PSRW.phone = 'phone'; PSRW.careGroupName = 'careGroupName';
        PSRW.ssn = 'ssn'; PSRW.patientReview = 'patientReview'; PSRW.providerType = 'providerType';
        PSRW.state = 'state'; PSRW.speciality = 'speciality'; PSRW.zipCode = 'zipCode';
        PSRW.grpPracticeNum = 'grpPracticeNum'; PSRW.planType = 'planType'; PSRW.radius = 'radius';
        
        System.assertNotEquals(null, PSRW);
    }
}