{
"findClaimPaymentsSummary": 
{             
  "findClaimPaymentSummaryRequestMsg": 
    {
	"body": 
	    {
		"request": 
		   {
		"providerNPIId": 
		[{
				   "tin": { "taxIdNbr": "@@TaxID@@"},
				   "typeCode": {"code": "@@NPI@@"}
		}],
                "checkSeriesDesignatorId": {"id": "@@checkSeriesDesignatorId@@"},
                "checkNumberId": {"id":@@checkNumberId@@ },
                "callCode": {"code": "@@callcode@@"},
                "patientIndividual": {
				     "name": {
					      "firstName": "@@PatientFirstName@@",
					      "lastName": "@@PatientLastName@@"
				             },
                 "otherIdentifiers": [{"id": "@@MemberID@@"}]
				   },
                 
                "billingProvider": 
                {
		        "professional": 
		        { "otherIdentifier": 
		               [{
		        	      "otherId": {"id": "@@ProviderID@@"}
                         }]
                  }
                }
             }
          }
       }
   }
}