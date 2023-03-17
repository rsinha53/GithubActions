{
	"getMedicalHealthServiceCaseAuthorizationReq": {
		"getAuthorizationRequestBaseType": {
			"requestHeader": {
				"srcSystem": "iCARE",
				"logLevel": "DEBUG",
				"userID": {
					"id": "bashok"
				}
			},
			"getAuthorizationRequest": [{
				"searchCriteria": {
					"identifier": [{
						"sourceSysCode": "AUTHID",
						"id": 100011989
					},
					{
						"sourceSysCode": "XREFID",
						"id": 780991
					}]
				}
			}]
		}
	}
}