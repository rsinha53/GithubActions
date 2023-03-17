({
    onInit : function(cmp, event, helper) {
        let today = new Date();
        cmp.set("v.autodocUniqueIdCmp", today.getTime());

        var contractDetail = cmp.get("v.data");
        var isPhysician = cmp.get("v.isPhysician");
        if((contractDetail.type == 'eni' && !isPhysician) || (contractDetail.type == 'mnr' && !isPhysician)){
           helper.getContractExceptions(cmp, event, helper);
        }
    },

	closeContractDetails : function(cmp) {
		var contractSummary = cmp.get("v.contractSummary");
		var data = cmp.get("v.data");

		var selectedIndex = contractSummary.tableBody.findIndex(function(row){
			return row.uniqueKey == data.uniqueKey;
		});
		contractSummary.tableBody[selectedIndex].linkDisabled = false;
		
		data.showDetails = false;
		cmp.set("v.data", data);
		cmp.set("v.contractSummary", contractSummary);
	},

	cDetailsSelectAll: function (cmp, event) {
		var checked = event.getSource().get("v.checked");
		var data = cmp.get("v.data");
        var cardData = data.contractDetails.cardData;
        for (var i of cardData) {
            if (i.showCheckbox && !i.defaultChecked) {
                i.checked = checked;
            }
        }
		data.contractDetails.cardData = cardData;
		_autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp") + "contractDetails", data.contractDetails);
		cmp.set("v.data", data);
	},

	tFilingSelectAll: function (cmp, event) {
		var checked = event.getSource().get("v.checked");
		var data = cmp.get("v.data");
        var cardData = data.timelyFiling.cardData;
        for (var i of cardData) {
            if (i.showCheckbox && !i.defaultChecked) {
                i.checked = checked;
            }
        }
		data.timelyFiling.cardData = cardData;
		_autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), cmp.get("v.autodocUniqueIdCmp") + "timelyFiling", data.timelyFiling);
		cmp.set("v.data", data);
    },

	// US2848719 - Thanish - 26th Mar 2021
	handleFeeScheduleClick: function (cmp) {
		cmp.set("v.showFeeSchedule", true);
	}
})