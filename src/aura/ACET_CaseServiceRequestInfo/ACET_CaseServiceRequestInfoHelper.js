({
	//US2508530
    Data: [
		{ infoId: '', idType: '', routeTo: '', issueStatus: '', priority: '', createdBy: '', updatedBy: '' }
	],

    setData : function(cmp) {
		cmp.set("v.dataLoaded", false);
		cmp.set('v.tableData', this.Data);

		let action = cmp.get("c.getORSIssueRecords");
		action.setParams({
            caseRecordId : cmp.get("v.recordId")
		});
		action.setCallback(this, function(response){
            let state = response.getState();
			// US2101464 - Thanish - 19th Jun 2020 - Error code handling ...
            if(state === "SUCCESS") {

				if(response.getReturnValue().length > 0) {
					let responseStatus = response.getReturnValue()[0].reponseStatus;
					if(responseStatus == 200) {
					cmp.set('v.tableData', response.getReturnValue());
					cmp.set('v.rowCount', response.getReturnValue().length);

					let openedTabs = cmp.get("v.openedTabs");
					if(openedTabs.length > 0) {
						// giving some time for rendering the table
						setTimeout(function() {
							let links = document.getElementsByClassName("idLink");
							let i; let j;
							for(i = 0; i < openedTabs.length; i++) {
								for(j = 0; j < links.length; j++) {
									if(links[j].innerHTML == openedTabs[i]) {
										$A.util.addClass(links[j], "disableLink");
										$A.util.addClass(links[j], openedTabs[i]);
										break;
									}
								}
							}
						},100);
					}
				} else {
					cmp.set('v.tableData', this.Data);
					cmp.set('v.rowCount', 0);
						this.fireErrorToastMessage(response.getReturnValue()[0].reponseStatusMessage);
				}
            } else {
				
				cmp.set('v.tableData', this.Data);
				cmp.set('v.rowCount', 0);
					this.fireErrorToastMessage("Unexpected error occured. Please try again. If problem persists, contact help desk.");
				}
            } else {
				cmp.set('v.tableData', this.Data);
				cmp.set('v.rowCount', 0);
				this.fireErrorToastMessage("Unexpected error occured. Please try again. If problem persists, contact help desk.");
            }
			cmp.set("v.dataLoaded", true);
			cmp.set("v.sortedColumnLabel", null);
		});
		$A.enqueueAction(action);
		
		let timeInterval = {
			updatedDuration : "a few seconds",
			intervalCount : 0,
			func : null
		}
		cmp.set("v.timeInterval", timeInterval);
		this.updateRefreshTime(cmp);
	},
	
	updateRefreshTime : function(cmp) {
		let timeInterval = cmp.get("v.timeInterval");

		// clear running time interval ...
		if(!$A.util.isEmpty(timeInterval.func)) { 
			clearInterval(timeInterval.func);
			timeInterval.intervalCount = 0;
			timeInterval.updatedDuration = "a few seconds";
			cmp.set("v.timeInterval", timeInterval);
		}

		// create new time interval ...
		let refreshTimeInterval = setInterval(function() {
			timeInterval.intervalCount = timeInterval.intervalCount + 1;

			if(timeInterval.intervalCount == 1) {
				timeInterval.updatedDuration = "a minute";
			} else if(timeInterval.intervalCount < 60) {
				timeInterval.updatedDuration = timeInterval.intervalCount + " minutes";
			} else if(timeInterval.intervalCount < 120) {
				timeInterval.updatedDuration = "an hour";
			} else {
				timeInterval.updatedDuration = Math.floor(timeInterval.intervalCount/60) + " hours";
			}

			cmp.set("v.timeInterval", timeInterval);
		}, 60000);

		timeInterval.func = refreshTimeInterval;
		cmp.set("v.timeInterval", timeInterval);
	},

	// US2101464 - Thanish - 19th Jun 2020 - Error code handling ...
	fireErrorToastMessage: function (message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			"title": "Error in Service Request Information!",
			"message": message,
			"type": "error",
			"mode": "pesky",
			"duration": "10000"
		});
		toastEvent.fire();
	},
})