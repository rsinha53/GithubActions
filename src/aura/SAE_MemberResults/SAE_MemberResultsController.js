({
    getMemberResults : function(cmp,event,helper){       
        helper.memberResults(cmp,event,helper);      
    },
    getRowInfo : function(cmp,event,helper){
        debugger;
        var htmlcmp = event.currentTarget;
        var selectedRow = event.currentTarget.getAttribute("data-row");
        var selectedRowIndex = htmlcmp.getAttribute("data-index");
        
        var searchResults;
        if(cmp.get('v.memberResults') != null){
            searchResults = cmp.get('v.memberResults');
        }
        var memUniqueId;
        //US2132239 : Member Only - No Provider to Search - PART2 : Date format
        let memDob = '';
        if(!$A.util.isUndefinedOrNull(searchResults[selectedRowIndex].birthDate)) {
            let tempDob  = new Date(searchResults[selectedRowIndex].birthDate);
            memDob =  ('0' + (tempDob.getMonth()+1)).slice(-2) + '/' + ('0' + tempDob.getDate()).slice(-2) + '/' + tempDob.getFullYear();
        }
        if(cmp.get("v.providerSearchFlag")){
            //US2132239 : Member Only - No Provider to Search - PART2
            memUniqueId = "No Provider To Search"  + ";" + cmp.get("v.memberID") + ';' + searchResults[selectedRowIndex].firstName.toUpperCase() + " " + searchResults[selectedRowIndex].lastName.toUpperCase() + ';' + memDob;
        }else if(cmp.get('v.isOtherFlag')){
            //US2132239 : Member Only - No Provider to Search - PART2
            memUniqueId = "Other"  + ";" + cmp.get("v.memberID") + ';' + searchResults[selectedRowIndex].firstName.toUpperCase() + " " + searchResults[selectedRowIndex].lastName.toUpperCase() + ';' + memDob;
        }else{
            //US2132239 : Member Only - No Provider to Search - PART2
            memUniqueId = cmp.get("v.providerId") + ";" + cmp.get("v.memberID") + ';' + searchResults[selectedRowIndex].firstName.toUpperCase() + " " + searchResults[selectedRowIndex].lastName.toUpperCase() + ';' + memDob;
        }

        cmp.set("v.disolveResults",false);
        var appEvent = $A.get("e.c:SAE_SelectedMemberRowEvent");
        var selectedMemberDetails = {
            "sourceCode": searchResults[selectedRowIndex].sourceSysCode,
            "Name": searchResults[selectedRowIndex].fullName,
            "DOB": searchResults[selectedRowIndex].birthDate,
            "firstName": searchResults[selectedRowIndex].firstName,
            "lastName": searchResults[selectedRowIndex].lastName,
            "SSN": searchResults[selectedRowIndex].SSN,
            "memberID": cmp.get("v.memberID"),
            "interactionCard":cmp.get("v.interactionCard"),
            "providerFlow": cmp.get("v.providerFlow"),
            "address": searchResults[selectedRowIndex].address
        };
        appEvent.setParams({
            "selectedMemberDetails": selectedMemberDetails,
            "flowType":"Member",
            "memUniqueId" : memUniqueId,
            "providerSearchFlag" : cmp.get("v.providerSearchFlag"),
            "isOtherFlag": cmp.get("v.isOtherFlag"),
            "contactName": cmp.get("v.contactName"),
            "contactNumber": cmp.get("v.contactNumber")
        });
        appEvent.fire();
    }
})