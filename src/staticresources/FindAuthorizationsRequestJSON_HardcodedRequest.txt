{
  "findMedicalHealthServiceCaseAuthorizations": {
    "findAuthorizationsRequestBaseType": {
      "requestHeader": {
        "srcSystem": "iCARE",
        "logLevel": "DEBUG",
        "userID": { "id": "RKUMA122" },
        "searchCriteria": { "text": "MEMBER" }
      },
      "findAuthorizationsByMemberRequest": {
        "authMember": {
          "identifier": {
            "sourceSysCode": "SRK",
            "id": "890504567"
          },
          "dateOfBirth": "1961-06-16",
          "firstName": "Alice",
          "lastName": "Ruby-Grace"
       },
        "dateRange": {
          "sourceSysCode": "",
          "id": "",
          "effectiveDateRange": {
            "startDate": "2015-04-26",
            "stopDate": "2017-12-31"
          }
        }


      }
    }
  }
}