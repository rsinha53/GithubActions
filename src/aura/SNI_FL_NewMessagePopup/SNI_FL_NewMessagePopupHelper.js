({
	saveNewMessage : function(component, event, helper) {
		
		let partnerQueue = component.get('v.selectedPartnerQueue');//US3376756-sameera
		var selectedToUsers = component.get('v.selectedUserLookUpRecords');
		var selectedToUserIds = [];
		var subject = component.get("v.subjectValue");
		var msgBody = '';
		msgBody = component.find("number").get("v.value");
		var fileId = component.get("v.attachId");
		var accId = '';
		var isBackupAgentView = component.get("v.isBackupAgentView");
		var isFamilyLevel = component.get("v.isFamilyLevel");

		if(isFamilyLevel){
			accId = component.get("v.familyId");
			isBackupAgentView = true;
        } else {
            accId = component.get("v.selectedFamilyRecord");
		}

			for(var i = 0; i<selectedToUsers.length; i++){

                if(typeof selectedToUsers[i].LastName !== 'undefined' && selectedToUsers[i].LastName != null){
                    selectedToUserIds.push(selectedToUsers[i].Id);
                }
                else if (typeof selectedToUsers[i].SNI_FL_Member__c !== 'undefined') {
                    selectedToUserIds.push(selectedToUsers[i].SNI_FL_Member__c);      
                }
                else if( typeof selectedToUsers[i].Partner__c !== 'undefined'){
                    selectedToUserIds.push(selectedToUsers[i].Partner__c);
                }
			}
	
		
		if (msgBody == null || msgBody == undefined || msgBody == ''){
			if(fileId != null && fileId != undefined && fileId != ''){
				msgBody = 'Posted a file';
				
				var action = component.get('c.saveNewMessage');
	
				action.setParams({
					'familyAccount' : (accId.value == undefined)?accId:accId.value,
					'lstOfMessageToUsers' : selectedToUserIds,
					'subject' : subject,
					'messageBody' : msgBody,
					'uploadedFiledID' : fileId,
					'isBackupAgentView' : isBackupAgentView,
					'isFamlyLink':false,
					'selectedPartnerQueue' :partnerQueue//US3376756-sameera
				});
				action.setCallback(this,function(response){
					var result = response.getReturnValue();
					if(response.getState() === 'SUCCESS') {
						var spinner = component.find("mySpinner");
						this.fireAllMessageRetrievalEvt(component, event);
						$A.util.addClass(spinner, "slds-hide");
						component.set("v.IsOpenNewMsg", false);
					} else {
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							"title": "Error!",
							"message": "error Send Message",
							"type": "error"
						});
						toastEvent.fire();
					}
				});
				$A.enqueueAction(action);
				
			} else {
				var spinner = component.find("mySpinner");
				$A.util.addClass(spinner, "slds-hide");
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					"title": "Error!",
					"message": "Please write some text to send message"
				});
				toastEvent.fire();
			}
		} else {

			var action = component.get('c.saveNewMessage');
			action.setParams({
				'familyAccount' : (accId.value == undefined)?accId:accId.value,
				'lstOfMessageToUsers' : selectedToUserIds,
				'subject' : subject,
				'messageBody' : msgBody,
				'uploadedFiledID' : fileId,
				'isBackupAgentView' : isBackupAgentView,
				'isFamlyLink':false,
				'selectedPartnerQueue' :partnerQueue//US3376756-sameera
			});
			action.setCallback(this,function(response){
				var result = response.getReturnValue();
				if(response.getState() === 'SUCCESS') {
					var spinner = component.find("mySpinner");
					this.fireAllMessageRetrievalEvt(component, event);
					$A.util.addClass(spinner, "slds-hide");
					component.set("v.IsOpenNewMsg", false);
				} else {
					var spinner = component.find("mySpinner");
					$A.util.addClass(spinner, "slds-hide");
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						"title": "Error!",
						"message": "error Send Message",
						"type": "error"
					});
					toastEvent.fire();
				}
			});
			$A.enqueueAction(action);
		}
	},

	deleteAttachment : function(component, event, helper) {
		var fileId = component.get("v.attachId");
		if(fileId != null && fileId != undefined ){
			var action = component.get('c.deleteAttachment');
			action.setParams({
				'uploadedFileId' : fileId 
			});
			action.setCallback(this,function(response){
				var result = response.getReturnValue();
				if(response.getState() === 'SUCCESS') {
					console.log('Attached file ' + fileId + ' deleted.');
				} else {
					console.log('Attached file ' + fileId + ' not deleted.');
				}
			});
			$A.enqueueAction(action);
		}
	},

	//Fire event to SNI_FL_FamilyView to get data again
	//Author:Sameera ACDC
	fireAllMessageRetrievalEvt:function(component,event){

		var evt = component.getEvent("retrieveAllMessages");
		evt.setParams({
			"isNewMessageCreated":true
		});
		evt.fire();
	},

	getMemberIdByFamilyId:function(component, event, helper){				
		var familyID = component.get("v.familyId");	 		
        var action = component.get("c.getMemberIdByAccountId");
            action.setParams({
                "accountID":familyID
            });        
            action.setCallback(this,function(response){
                var state = response.getState();
                if (state === "SUCCESS") {					
					component.set("v.memberId", response.getReturnValue());   
					var familyName = component.get("v.AccountName"); 
					var display = familyName + " - " + response.getReturnValue(); 
					component.set("v.displayName", display)       
                }
                else {
                    console.log("Failed with state: " + state);
                }   
            });
			$A.enqueueAction(action);

    }

})