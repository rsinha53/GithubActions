@isTest
public class ACETHouseHoldWrapperTest {
    @isTest
    public static void getACET() {
        ACETHouseHoldWrapper wrp = new ACETHouseHoldWrapper();
        ACETHouseHoldWrapper.HouseHold wrp1= new ACETHouseHoldWrapper.HouseHold();
        wrp1.dob = '6/17/1977' ;
        wrp1.firstName  = 'test' ;
        wrp1.lastName  = 'test' ;
        wrp1.relationship   = 'test' ;
        wrp1.fullName   = 'test' ;
        wrp1.memberId   = 'test' ;
        wrp1.CHNReferralIdentifier    = 'test' ;
        wrp1.isMainMember   = true ;
        wrp1.CHNQualified    = true ;
        wrp1.policyId   = 'test' ;
        wrp1.cosmosDivision  = 'test' ;
        wrp1.sourceCode  = 'test' ;
        wrp1.gender  = 'test' ;
        wrp1.CHNEligibile   = true ;
        
         ACETHouseHoldWrapper.addressInfo wrp2= new ACETHouseHoldWrapper.addressInfo();
         wrp2.city  = 'test';
         wrp2.country  = 'test';
         wrp2.state  = 'test';
         wrp2.street  = 'test';
         wrp2.zip  = 'test';
         
         ACETHouseHoldWrapper.memberDetails wrp3= new ACETHouseHoldWrapper.memberDetails();
         wrp3.accountId  = 'test';
         wrp3.relationship  = 'test';
         wrp3.memberId   = 'test';
         wrp3.policyId    = 'test';
         wrp3.assignTo    = 'test';
         wrp3.isAcetSearch   = 'test';
         wrp3.isSniEligible  = true;
         wrp3.isSniUser  = true;
    }
}