({
    providerResults : function(cmp, event, helper) {
        var providerResults = event.getParam('providerResults');
        cmp.set("v.providerResults",providerResults);
        cmp.set("v.providerResultsOriginal",providerResults);
        cmp.set("v.disolveResults",true);
    },
    
    searchResults : function(cmp,event,helper){
        debugger;
               var filterResults;
        if(event.getParam('providerResults') != null){
            filterResults  = event.getParam('providerResults').PhysicianFacilitySummary0002Response;
        }
        var searchKeyWord = event.getParam('searchKeyWord');
        console.log("searchKey"+searchKeyWord);
        var tempArray = [];
        if(filterResults != null){
            if(!$A.util.isEmpty(searchKeyWord)){
            for(var i in filterResults){
                var facilityName;
                var postalAddress;
                var taxId;
                
                if (filterResults[i].physicianFacilityInformation.providerType == 'O') {
                    facilityName = filterResults[i].physicianFacilityInformation.facilityName.toUpperCase();
                } else {
                    facilityName = filterResults[i].physicianFacilityInformation.firstName.toUpperCase() + ', ' + filterResults[i].physicianFacilityInformation.lastName.toUpperCase();
                }
                
                postalAddress = filterResults[i].physicianFacilityInformation.address.postalAddress.addressLine1.toUpperCase() + ',' +
                    filterResults[i].physicianFacilityInformation.address.postalAddress.city.toUpperCase() + ',' +
                    filterResults[i].physicianFacilityInformation.address.postalAddress.county.toUpperCase()  + ',' +
                    filterResults[i].physicianFacilityInformation.address.postalAddress.state.toUpperCase() + ',' +
                    filterResults[i].physicianFacilityInformation.address.postalAddress.zip.toUpperCase();
                
                taxId = filterResults[i].physicianFacilityInformation.taxId.taxId.toUpperCase();   
               
                if(facilityName.includes(searchKeyWord.toUpperCase()) || postalAddress.includes(searchKeyWord.toUpperCase()) || taxId.includes(searchKeyWord.toUpperCase())){
               
                    tempArray.push(filterResults[i]);
                     console.log(tempArray);
                    var searchPrvResults = cmp.get("v.providerResults");
                    searchPrvResults.PhysicianFacilitySummary0002Response = tempArray;
                    cmp.set("v.providerResults",searchPrvResults);
                }
            }
            }else {
               cmp.set("v.providerResults",cmp.get("v.providerResultsOriginal"));
            }
        }
               }
})