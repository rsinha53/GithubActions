({
	createObjectData: function(component, event) {
        var recId=component.get("v.recordId");
        var parentRecId=component.get("v.parentRecId");
        var RowItemList = component.get("v.lstPIRRPRefs");
        RowItemList.push({
            'sobjectType': 'PIR_Resolution_Partners_Reference__c',
            'PIR_Resolution_Partner__c': recId,
            'Reference__c': '',
            'Completed__c': 'false'
        });
        component.set("v.lstPIRRPRefs", RowItemList);
    },
    validateRequired: function(component, event) {
        var isValid = true;
        var allPIRRPRefRows = component.get("v.lstPIRRPRefs");
        for (var indexVar = 0; indexVar < allPIRRPRefRows.length; indexVar++) {
            if (allPIRRPRefRows[indexVar].Reference__c == '') {
                var fld = allPIRRPRefRows[indexVar].Reference__c;
                isValid = false;
                //fld.set("v.errors", [{message:"Enter some text"}]);
                alert('Reference Can\'t be Blank on Row Number ' + (indexVar + 1));
            }
        }
        return isValid;
    }
})