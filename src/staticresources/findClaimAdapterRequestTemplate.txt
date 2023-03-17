{
	"findClaims": {
		
		"findClaimRequestMsg": {
		"headerMsg": {
					"pagination": {
						"pageNumber": "",
						"pageSize": ""
					}
				},
			"body": {
				"claimTransaction": {
					"otherClaimId": [{
						"sourceSysCode": "Claim ID",
						"id": "@@ClaimId@@"
					}],
					"billingProvider": {
						"organization": {
							"tinOwner": [{
								"tin": {
									"taxIdNbr": "@@TaxId@@"
								}
							}]
						}
					},
					"claimServiceDateRange": {
						"startDate": "@@startDate@@",
						"stopDate": "@@stopDate@@"
					},
					"coverageTypeCode": [{
						"code": "@@code@@"
					}],
					"authorization": {
						"number": "@@authnum@@"
					},
					"deductableIndicator" : "@@deductible@@",
					"patientIndividual": {
						"otherIdentifiers": [{
							"code": "EID",
							"sourceSysCode": "EID",
							"id": "@@EID@@"
						}]
					}
				}
			},
			"trailMsg": {
				"sortOrderValue": "",
				"sortColumnValue": ""
			}
		}
	}
}