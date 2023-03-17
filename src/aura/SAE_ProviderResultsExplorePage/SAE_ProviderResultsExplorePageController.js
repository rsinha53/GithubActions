({
    getProviderResults : function(cmp,event,helper){
       
        helper.providerResults(cmp,event,helper);
        helper.searchResults(cmp,event,helper);
       
    },
    getRowInfo : function(cmp,event,helper){
      
       var htmlcmp = event.currentTarget;
       var selectedRow = event.currentTarget.getAttribute("data-row");
       var selectedRowIndex = htmlcmp.getAttribute("data-index");
       console.log(selectedRow);
      
       var searchResults;
        if(cmp.get('v.providerResults') != null){
            searchResults = cmp.get('v.providerResults').PhysicianFacilitySummary0002Response;
        }
       
       console.log(searchResults[selectedRowIndex]);
        
       var postalAddress;
       // US2039716 - Thanish - 19th Sept 2019
       var primarySpeaciality;
       var phone;
       var providerId;
       var addressSequenceId;
       var providerType;

        if (searchResults[selectedRowIndex].physicianFacilityInformation.providerType == 'O') {
           primarySpeaciality = "";
        } else {
            primarySpeaciality = searchResults[selectedRowIndex].physicianFacilityInformation.specialty[0].specialty.value;
        }
        // End of Code - US2039716 - Thanish - 19th Sept 2019

        postalAddress = searchResults[selectedRowIndex].physicianFacilityInformation.address.postalAddress.addressLine1 + ',' +
            searchResults[selectedRowIndex].physicianFacilityInformation.address.postalAddress.city + ',' +
            searchResults[selectedRowIndex].physicianFacilityInformation.address.postalAddress.county + ',' +
            searchResults[selectedRowIndex].physicianFacilityInformation.address.postalAddress.state + ',' +
            searchResults[selectedRowIndex].physicianFacilityInformation.address.postalAddress.zip;
       
        // US2039716 - Thanish - 17th Sept 2019
        phone = searchResults[selectedRowIndex].physicianFacilityInformation.phone[0].areaCode + searchResults[selectedRowIndex].physicianFacilityInformation.phone[0].phoneNumber; 

        providerId = searchResults[selectedRowIndex].physicianFacilityInformation.providerId;

        addressSequenceId = searchResults[selectedRowIndex].physicianFacilityInformation.address.epdAddressSequenceId;

        providerType = searchResults[selectedRowIndex].physicianFacilityInformation.providerType;
        // End of code - US2039716 - Thanish - 17th Sept 2019

        var appEvent = $A.get("e.c:SAE_GetRowDataFromExlporePage");
        var selectedProviderRecord = searchResults[selectedRowIndex].physicianFacilityInformation;
                              
                              var npi = selectedProviderRecord.npi[0].npi;
        var npiVal;
       
        if(npi && !$A.util.isEmpty(npi.trim())){
            npiVal = npi;
        }
                              
        var selectedProviderDetails = {
            "taxIdOrNPI": selectedProviderRecord.taxId.taxId,
            "npi": npiVal,
            "taxId": selectedProviderRecord.taxId.taxId,
            "contactName": "",
            "filterType": "",
            "firstName": selectedProviderRecord.providerType == 'P' ? selectedProviderRecord.firstName : "",
                                             "lastName": selectedProviderRecord.providerType == 'P' ? selectedProviderRecord.lastName : selectedProviderRecord.facilityName,
                                             "searchOption": "",
            "addressId": selectedProviderRecord.address.addressId, // US1918689 - Thanish - 13th Nov 2019 - passing addressID of physician.
            "postalAddress": postalAddress,
            "state": selectedProviderRecord.address.postalAddress.state,
           "zip": selectedProviderRecord.address.postalAddress.zip,
            "phone": phone,
            "primarySpeaciality" : primarySpeaciality,
            "providerId" : providerId,
            "addressSequenceId" : addressSequenceId,
            "providerType" : providerType,
            // Sanka - US2099074
            "tpsmIndicator" : selectedProviderRecord.taxId.tpsm.tpsmInd,
            "corpMpin" : selectedProviderRecord.taxId.corpMPIN,
            "addressLine1" : selectedProviderRecord.address.postalAddress.addressLine1,
            "addressLine2" : selectedProviderRecord.address.postalAddress.addressLine2,
            "degreeCode" : selectedProviderRecord.degrees.length > 0 ? selectedProviderRecord.degrees[0].degreeCode : ""
        };
        appEvent.setParams({
            "selectedProviderDetails": selectedProviderDetails
        });
        appEvent.fire();
        cmp.set("v.disolveResults",false);
        
    }
})