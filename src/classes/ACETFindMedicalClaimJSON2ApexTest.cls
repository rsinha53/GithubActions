@IsTest
public class ACETFindMedicalClaimJSON2ApexTest {
	
	/*// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{\"findClaimsResult\": {\"findClaimResponseMsg\": {'+
		'   \"headerMsg\": {},'+
		'   \"body\": {\"claim\": [{\"claimTransactionDetail\":    {'+
		'      \"otherClaimId\": [      {'+
		'         \"sourceSysCode\": \"CAE Claim ID\",'+
		'         \"id\": \"5889556100\"'+
		'      }],'+
		'      \"billingProvider\":       {'+
		'         \"organization\": {\"tinOwner\": [{\"tin\": {\"taxIdNbr\": \"942854057\"}}]},'+
		'         \"professional\": {\"firstName\": \"Rekha\"}'+
		'      },'+
		'      \"inNetworkIndicator\": \"I\",'+
		'      \"phiRestrictionIndicator\": \"N\",'+
		'      \"claimAdjudicationDate\": {\"date\": \"2016-03-02\"},'+
		'      \"totalBilledChargeAmount\": {\"value\": \"1000\"},'+
		'      \"totalClaimPaidAmount\": {\"value\": \"480\"},'+
		'      \"totalClaimDeductibleAmount\": {\"value\": \"400\"},'+
		'      \"claimServiceDateRange\":       {'+
		'         \"startDate\": \"2016-03-02\",'+
		'         \"stopDate\": \"2016-03-02\"'+
		'      },'+
		'      \"statusCode\":       {'+
		'         \"code\": \"A\",'+
		'         \"desc\": \"ADJUDICATED\"'+
		'      },'+
		'      \"diagnosisCode\": [{\"diagnosisCodeOidId\": {\"codeValueId\": \"2800\"}}]'+
		'   }}]}'+
		'}}}';
		
		ACETFindMedicalClaimJSON2Apex r = ACETFindMedicalClaimJSON2Apex.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ACETFindMedicalClaimJSON2Apex.FindClaimResponseMsg objFindClaimResponseMsg = new ACETFindMedicalClaimJSON2Apex.FindClaimResponseMsg(System.JSON.createParser(json));
		System.assert(objFindClaimResponseMsg != null);
		System.assert(objFindClaimResponseMsg.headerMsg == null);
		System.assert(objFindClaimResponseMsg.body == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ACETFindMedicalClaimJSON2Apex.Organization objOrganization = new ACETFindMedicalClaimJSON2Apex.Organization(System.JSON.createParser(json));
		System.assert(objOrganization != null);
		System.assert(objOrganization.tinOwner == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ACETFindMedicalClaimJSON2Apex.OtherClaimId objOtherClaimId = new ACETFindMedicalClaimJSON2Apex.OtherClaimId(System.JSON.createParser(json));
		System.assert(objOtherClaimId != null);
		System.assert(objOtherClaimId.sourceSysCode == null);
		System.assert(objOtherClaimId.id == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ACETFindMedicalClaimJSON2Apex objRoot = new ACETFindMedicalClaimJSON2Apex(System.JSON.createParser(json));
		System.assert(objRoot != null);
		System.assert(objRoot.findClaimsResult == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ACETFindMedicalClaimJSON2Apex.ClaimServiceDateRange objClaimServiceDateRange = new ACETFindMedicalClaimJSON2Apex.ClaimServiceDateRange(System.JSON.createParser(json));
		System.assert(objClaimServiceDateRange != null);
		System.assert(objClaimServiceDateRange.startDate == null);
		System.assert(objClaimServiceDateRange.stopDate == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ACETFindMedicalClaimJSON2Apex.BillingProvider objBillingProvider = new ACETFindMedicalClaimJSON2Apex.BillingProvider(System.JSON.createParser(json));
		System.assert(objBillingProvider != null);
		System.assert(objBillingProvider.organization == null);
		System.assert(objBillingProvider.professional == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ACETFindMedicalClaimJSON2Apex.DiagnosisCode objDiagnosisCode = new ACETFindMedicalClaimJSON2Apex.DiagnosisCode(System.JSON.createParser(json));
		System.assert(objDiagnosisCode != null);
		System.assert(objDiagnosisCode.diagnosisCodeOidId == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ACETFindMedicalClaimJSON2Apex.DiagnosisCodeOidId objDiagnosisCodeOidId = new ACETFindMedicalClaimJSON2Apex.DiagnosisCodeOidId(System.JSON.createParser(json));
		System.assert(objDiagnosisCodeOidId != null);
		System.assert(objDiagnosisCodeOidId.codeValueId == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ACETFindMedicalClaimJSON2Apex.TinOwner objTinOwner = new ACETFindMedicalClaimJSON2Apex.TinOwner(System.JSON.createParser(json));
		System.assert(objTinOwner != null);
		System.assert(objTinOwner.tin == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ACETFindMedicalClaimJSON2Apex.StatusCode objStatusCode = new ACETFindMedicalClaimJSON2Apex.StatusCode(System.JSON.createParser(json));
		System.assert(objStatusCode != null);
		System.assert(objStatusCode.code == null);
		System.assert(objStatusCode.desc_Z == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ACETFindMedicalClaimJSON2Apex.TotalBilledChargeAmount objTotalBilledChargeAmount = new ACETFindMedicalClaimJSON2Apex.TotalBilledChargeAmount(System.JSON.createParser(json));
		System.assert(objTotalBilledChargeAmount != null);
		System.assert(objTotalBilledChargeAmount.value == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ACETFindMedicalClaimJSON2Apex.HeaderMsg objHeaderMsg = new ACETFindMedicalClaimJSON2Apex.HeaderMsg(System.JSON.createParser(json));
		System.assert(objHeaderMsg != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ACETFindMedicalClaimJSON2Apex.Professional objProfessional = new ACETFindMedicalClaimJSON2Apex.Professional(System.JSON.createParser(json));
		System.assert(objProfessional != null);
		System.assert(objProfessional.firstName == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ACETFindMedicalClaimJSON2Apex.FindClaimsResult objFindClaimsResult = new ACETFindMedicalClaimJSON2Apex.FindClaimsResult(System.JSON.createParser(json));
		System.assert(objFindClaimsResult != null);
		System.assert(objFindClaimsResult.findClaimResponseMsg == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ACETFindMedicalClaimJSON2Apex.Tin objTin = new ACETFindMedicalClaimJSON2Apex.Tin(System.JSON.createParser(json));
		System.assert(objTin != null);
		System.assert(objTin.taxIdNbr == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ACETFindMedicalClaimJSON2Apex.ClaimAdjudicationDate objClaimAdjudicationDate = new ACETFindMedicalClaimJSON2Apex.ClaimAdjudicationDate(System.JSON.createParser(json));
		System.assert(objClaimAdjudicationDate != null);
		System.assert(objClaimAdjudicationDate.date == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ACETFindMedicalClaimJSON2Apex.ClaimTransactionDetail objClaimTransactionDetail = new ACETFindMedicalClaimJSON2Apex.ClaimTransactionDetail(System.JSON.createParser(json));
		System.assert(objClaimTransactionDetail != null);
		System.assert(objClaimTransactionDetail.otherClaimId == null);
		System.assert(objClaimTransactionDetail.billingProvider == null);
		System.assert(objClaimTransactionDetail.inNetworkIndicator == null);
		System.assert(objClaimTransactionDetail.phiRestrictionIndicator == null);
		System.assert(objClaimTransactionDetail.claimAdjudicationDate == null);
		System.assert(objClaimTransactionDetail.totalBilledChargeAmount == null);
		System.assert(objClaimTransactionDetail.totalClaimPaidAmount == null);
		System.assert(objClaimTransactionDetail.totalClaimDeductibleAmount == null);
		System.assert(objClaimTransactionDetail.claimServiceDateRange == null);
		System.assert(objClaimTransactionDetail.statusCode == null);
		System.assert(objClaimTransactionDetail.diagnosisCode == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ACETFindMedicalClaimJSON2Apex.Body objBody = new ACETFindMedicalClaimJSON2Apex.Body(System.JSON.createParser(json));
		System.assert(objBody != null);
		System.assert(objBody.claim == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ACETFindMedicalClaimJSON2Apex.Claim objClaim = new ACETFindMedicalClaimJSON2Apex.Claim(System.JSON.createParser(json));
		System.assert(objClaim != null);
		System.assert(objClaim.claimTransactionDetail == null);
	}*/
}