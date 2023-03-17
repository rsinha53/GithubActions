({
	// Purpose - get contract data when tab changed
    refreshTableData : function(cmp, event, helper) {
        cmp.set("v.selectedTab", event.currentTarget.getAttribute("data-tab"));
    },
    
    defaultTab : function(cmp) {
        var sourceCode = cmp.get("v.sourceCode");
        switch(sourceCode) {
            case 'CO':
                cmp.set("v.selectedTab","MNR");
                break;
            case 'CS':
                cmp.set("v.selectedTab","ENI");
                break;
            case 'AP':
            	cmp.set("v.selectedTab","CNS");
                break;
            case 'PA':
            	cmp.set("v.selectedTab","PHS");
                break;
            default:
        	    cmp.set("v.selectedTab","ENI");
        }
    },

    onTabChange: function (cmp, event, helper) {
        var cnsTable = cmp.get("v.cnsTable");
        var eniTable = cmp.get("v.eniTable");
        var mnrTable = cmp.get("v.mnrTable");
        switch (cmp.get("v.selectedTab")) {
            case 'CNS':
                if ($A.util.isEmpty(cnsTable)) {
                    helper.getCNSContracts(cmp, event, helper);
                } else {
                    if($A.util.isEmpty(cnsTable.tableBody)) {
                        cnsTable.tableBody = helper.setEmptyRow(cnsTable.tableBody);
                        cmp.set("v.cnsTable",cnsTable);
                    }
                }
                break;
            case 'ENI':
                if ($A.util.isEmpty(cmp.get("v.eniTable"))) {
                    helper.getENIContracts(cmp, event, helper);
                } else {
                    if($A.util.isEmpty(eniTable.tableBody)) {
                        eniTable.tableBody = helper.setEmptyRow(eniTable.tableBody);
                        cmp.set("v.eniTable",eniTable);
                    }
                }
                break;
            case 'MNR':
                if ($A.util.isEmpty(cmp.get("v.mnrTable"))) {
                    helper.getMNRContracts(cmp, event, helper);
                } else {
                    if($A.util.isEmpty(mnrTable.tableBody)) {
                        mnrTable.tableBody = helper.setEmptyRow(mnrTable.tableBody);
                        cmp.set("v.mnrTable",mnrTable);
                    }
                }
                break;
            case 'PHS':
                if($A.util.isEmpty(cmp.get("v.phsTable"))){
                    helper.getPHSContracts(cmp);
                }
                break;
            default:
        	    break;
        }
    },

    providerDetailsChanged: function (cmp, event, helper) {
        var cnsTable = cmp.get("v.cnsTable");
        var eniTable = cmp.get("v.eniTable");
        var mnrTable = cmp.get("v.mnrTable");
        switch (cmp.get("v.selectedTab")) {
            case 'CNS':
                if ($A.util.isEmpty(cmp.get("v.cnsTable"))) {
                    helper.getCNSContracts(cmp, event, helper);
                } else {
                    if($A.util.isEmpty(cnsTable.tableBody)) {
                        cnsTable.tableBody = helper.setEmptyRow(cnsTable.tableBody);
                        cmp.set("v.cnsTable",cnsTable);
                    }
                }
                break;
            case 'ENI':
                if ($A.util.isEmpty(cmp.get("v.eniTable"))) {
                    helper.getENIContracts(cmp, event, helper);
                } else {
                    if($A.util.isEmpty(eniTable.tableBody)) {
                        eniTable.tableBody = helper.setEmptyRow(eniTable.tableBody);
                        cmp.set("v.eniTable",eniTable);
                    }
                }
                break;
            case 'MNR':
                if ($A.util.isEmpty(cmp.get("v.mnrTable"))) {
                    helper.getMNRContracts(cmp, event, helper);
                } else {
                    if($A.util.isEmpty(mnrTable.tableBody)) {
                        mnrTable.tableBody = helper.setEmptyRow(mnrTable.tableBody);
                        cmp.set("v.mnrTable",mnrTable);
                    }
                }
                break;
            case 'PHS':
                if($A.util.isEmpty(cmp.get("v.phsTable"))){
                    helper.getPHSContracts(cmp);
                }
                break;
            default:
        	    break;
        }
    },

    onPHSChange: function(cmp, event, helper) {
     var phsTable = cmp.get("v.phsTable");
        if(!$A.util.isEmpty(phsTable)){ // DE434487 - Thanish - 22nd Apr 2021
         helper.noRecordFound(cmp,phsTable,cmp.get("v.isPHSAll"));
        }
    },

    onCNSAllChange : function(cmp, event, helper) {
        var cnsTable = cmp.get("v.cnsTable");
        if(!$A.util.isEmpty(cnsTable)){ // DE434487 - Thanish - 22nd Apr 2021
        if(cmp.get("v.isCNSAll")) {
            cnsTable.tableBody = cnsTable.originalTableBody;
        } else {
            cnsTable.tableBody = helper.filterActiveDataForCAndS(false, cnsTable.originalTableBody);
        }
        if (!$A.util.isEmpty(cnsTable) && $A.util.isEmpty(cnsTable.tableBody)) {
            cnsTable.tableBody = helper.setEmptyRow(cnsTable.tableBody);
        }
        cmp.set("v.cnsTable", cnsTable);
         helper.noRecordFound(cmp,cnsTable,cmp.get("v.isCNSAll"));
        }
    },

    onENIAllChange : function(cmp, event, helper) {
        var eniTable = cmp.get("v.eniTable");
        if(!$A.util.isEmpty(eniTable)){ // DE434487 - Thanish - 22nd Apr 2021
        if(cmp.get("v.isENIAll")) {
            eniTable.tableBody = eniTable.originalTableBody;
        } else {
            eniTable.tableBody = helper.filterENIAccordingToMember(cmp, eniTable.originalTableBody);
        }
        if (!$A.util.isEmpty(eniTable) && $A.util.isEmpty(eniTable.tableBody)) {
            eniTable.tableBody = helper.setEmptyRow(eniTable.tableBody);
        }
        cmp.set("v.eniTable", eniTable);
             helper.noRecordFound(cmp,eniTable,cmp.get("v.isENIAll"));
        }
    },

    onMNRAllChange : function(cmp, event, helper) {
        var mnrTable = cmp.get("v.mnrTable");
        if(!$A.util.isEmpty(mnrTable)){ // DE434487 - Thanish - 22nd Apr 2021
        if(cmp.get("v.isMNRAll")) {
            mnrTable.tableBody = mnrTable.originalTableBody;
        } else {
            mnrTable.tableBody = helper.filterMNRAccordingToMember(cmp, mnrTable.originalTableBody);
        }
        if (!$A.util.isEmpty(mnrTable) && $A.util.isEmpty(mnrTable.tableBody)) {
            mnrTable.tableBody = helper.setEmptyRow(mnrTable.tableBody);
        }
        cmp.set("v.mnrTable", mnrTable);
           helper.noRecordFound(cmp,mnrTable,cmp.get("v.isMNRAll"));
        }
    },
    
    onDateLinkClicked : function(cmp, event, helper) {
        var contractDetailsList = cmp.get("v.contractDetailsList");
        var selectedRow = event.getParam("selectedRows");
        var contractId = selectedRow.rowColumnData[0].fieldValue;
        cmp.set("v.contractId", contractId);
        var dataIndex = contractDetailsList.findIndex(function(data){
            return selectedRow.uniqueKey == data.uniqueKey;
        });

        if(dataIndex > -1){
            contractDetailsList[dataIndex].showDetails = true;
            cmp.set("v.contractDetailsList", contractDetailsList);

        } else{
            var contractDetails = new Object();
            if(selectedRow.uniqueKey.indexOf('cns') >= 0){
                contractDetails.type = 'cns';
                contractDetails.uniqueKey = selectedRow.uniqueKey;
                contractDetails.contractDetails = selectedRow.contractDetails;
                contractDetails.timelyFiling = selectedRow.timelyFiling;
                contractDetails.showDetails = true;
                contractDetails.effectiveToCancelDate = selectedRow.rowColumnData[5].fieldValue;

            } else if(selectedRow.uniqueKey.indexOf('eni') >= 0){
                contractDetails.type = 'eni';
                contractDetails.uniqueKey = selectedRow.uniqueKey;
                contractDetails.contractDetails = selectedRow.contractDetails;
                contractDetails.timelyFiling = selectedRow.timelyFiling;
                contractDetails.showDetails = true;
                contractDetails.effectiveToCancelDate = selectedRow.rowColumnData[7].fieldValue;
                // US3468218 - Fee Schedule Integration
                contractDetails.feeScheduleData = selectedRow.feeScheduleData;

            } else if(selectedRow.uniqueKey.indexOf('mnr') >= 0){
                contractDetails.type = 'mnr';
                contractDetails.uniqueKey = selectedRow.uniqueKey;
                contractDetails.contractDetails = selectedRow.contractDetails;
                contractDetails.timelyFiling = selectedRow.timelyFiling;
                contractDetails.showDetails = true;
                contractDetails.effectiveToCancelDate = selectedRow.rowColumnData[6].fieldValue;
                
            } else if(selectedRow.uniqueKey.indexOf('phs') >= 0){
                // PHS is an api gap
            }
            contractDetailsList.unshift(contractDetails);
            cmp.set("v.contractDetailsList", contractDetailsList);
        }
        // US3667063 - Thanish - 2nd Jul 2021
        setTimeout(function() {
            var cDetailsScroll = document.getElementById(cmp.get("v.autodocUniqueId") + "ContractDetails");
            if(!$A.util.isEmpty(cDetailsScroll)){
                cDetailsScroll.scrollIntoView({
                    behavior: 'smooth',
                    block: 'center',
                    inline: 'nearest'
                });
            }
        }, 100);
    }
})