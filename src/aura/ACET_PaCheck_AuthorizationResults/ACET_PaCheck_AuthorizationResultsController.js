({
	//US3067258- Swapnil
	onInit : function(component, event, helper) {
		helper.setTableData(component,event);
		//US3219740 - Sravan
		/*helper.getProviderNotificationTool(component, event, helper); Commented as part of US3487597 - Sravan*/
	},
    togglePopup : function(cmp, event) {
        if(cmp.find('idToolTip') && cmp.find('idToolTip').getElement() ) {
            if(cmp.find('idToolTip').getElement().classList.contains('slds-hide')) {
                cmp.find('idToolTip').getElement().classList.remove('slds-hide');
                let lst = cmp.get("v.descriptionList");
                if(lst && lst.length > 0) {
                    cmp.find('idToolTip').getElement().style.top = -(lst.length + 0.6) + 'rem';
                } else {
                    cmp.find('idToolTip').getElement().style.top = -(1.6) + 'rem';
                }
            } else {
                cmp.find('idToolTip').getElement().classList.add('slds-hide');
            }
        }
    },

	handleRadioChange : function(component, event, helper) {
        var fieldName = event.getSource().get("v.name");
        var sCode = component.get("v.sourceCode");
        var paCheckTabId= component.get('v.paCheckTabId'); //DE427094 Swapnil
        if(sCode == 'AP'){
        if (fieldName == 'uhcComeAsBlocked'+paCheckTabId) {
            component.set('v.priorAuthRadioButton', '');
			component.set('v.delegatedPlanRadioButton', '');
            component.set('v.handledByUHCRadioButton', '');
            component.set('v.uhcPrimaryRadioButton', '');
            component.set('v.memberNotifRadioButton', '');

		}
		else if (fieldName == 'priorAuthRadioButton'+paCheckTabId) {
			component.set('v.delegatedPlanRadioButton', '');
            component.set('v.handledByUHCRadioButton', '');
            component.set('v.uhcPrimaryRadioButton', '');
            component.set('v.memberNotifRadioButton', '');
            //component.set('v.testingRadioButton', '');
		} 
        else if (fieldName == 'delegatedPlanRadioButton'+paCheckTabId) {
			component.set('v.handledByUHCRadioButton', '');
            component.set('v.uhcPrimaryRadioButton', '');
            component.set('v.memberNotifRadioButton', '');
            //component.set('v.testingRadioButton', '');
		}
		else if (fieldName == 'handledByUHCRadioButton'+paCheckTabId) {
			component.set('v.uhcPrimaryRadioButton', '');
            component.set('v.memberNotifRadioButton', '');
            //component.set('v.testingRadioButton', '');
		}
		else if (fieldName == 'uhcPrimaryRadioButton'+paCheckTabId) {
			component.set('v.memberNotifRadioButton', '');
            //component.set('v.testingRadioButton', '');
		}
        }

        else if(sCode == 'CS' || sCode == 'CO'){
            if (fieldName == 'uhcPrimaryRadioButton'+paCheckTabId) {
                component.set('v.uhcComeAsBlocked','');
                component.set('v.priorAuthRadioButton','');
                component.set('v.SST','');
                component.set('v.medNecIndValue','');
                component.set('v.delegatedPlanRadioButton','');
                component.set('v.handledByUHCRadioButton','');
                component.set('v.memberNotifRadioButton','');

            }
            else if (fieldName == 'uhcComeAsBlocked'+paCheckTabId) {
                component.set('v.priorAuthRadioButton','');
                component.set('v.SST','');
                component.set('v.medNecIndValue','');
                component.set('v.delegatedPlanRadioButton','');
                component.set('v.handledByUHCRadioButton','');
                component.set('v.memberNotifRadioButton','');
            }
                else if (fieldName == 'priorAuthRadioButton'+paCheckTabId) {
                    component.set('v.SST','');
                    component.set('v.delegatedPlanRadioButton','');
                    component.set('v.handledByUHCRadioButton','');
                    component.set('v.memberNotifRadioButton','');
                }
                    else if (fieldName == 'medNecIndValue'+paCheckTabId) {
                        component.set('v.SST','');
                        component.set('v.priorAuthRadioButton','');
                        component.set('v.delegatedPlanRadioButton','');
                        component.set('v.handledByUHCRadioButton','');
                        component.set('v.memberNotifRadioButton','');
                    }
                        else if (fieldName == 'delegatedPlanRadioButton'+paCheckTabId) {
                            component.set('v.handledByUHCRadioButton','');
                            component.set('v.memberNotifRadioButton','');
                        }
                            else if (fieldName == 'handledByUHCRadioButton'+paCheckTabId) {
                                component.set('v.memberNotifRadioButton','');
                            }
        }

		//US2828663	Pre Authorization Details in Autodoc - Sarma - 06/01/2021
		helper.updateQuestionAuodoc(component,event);
	},

	/*handleProvideNGT: function(component, event, helper){
		var providerNotificationTool = component.get("v.providerNotificationTool");
        if(!$A.util.isUndefinedOrNull(providerNotificationTool) && !$A.util.isEmpty(providerNotificationTool)){
            window.open(providerNotificationTool, '_blank');
        }
	}, Commented as part of US3487597 - Sravan*/

    //DE422112 Swapnil
    handleAutodocRefresh: function (cmp, event, helper) {
        if (event.getParam("autodocUniqueId") == cmp.get("v.autodocUniqueId")) {
            _autodoc.resetAutodoc(cmp.get("v.autodocUniqueId"));
            var caseWrapper = cmp.get("v.caseWrapper");
            caseWrapper.savedAutodoc = '';
            caseWrapper.caseItems = [];
            cmp.set("v.caseWrapper", caseWrapper);
        }
    },

    closeModal : function(cmp,event,helper){
      cmp.set('v.openSpInsPopUP',false);
    },
    handleSelectedRowLink: function (cmp, event, helper) {
        var selectedRowdata = event.getParam("selectedRows");
        var cellIndex = event.getParam("currentCellIndex");
        if(cmp.get("v.sourceCode") == 'CS' && cellIndex &&  cellIndex == '7'){
            cmp.set('v.openSpInsPopUP',false);
            cmp.set('v.spInstructionString','');
            helper.getSpInData(cmp,event,helper,selectedRowdata);

        }

        if(cmp.get("v.sourceCode") == 'CS' && cellIndex &&  cellIndex == '1'){
            helper.addCodeDetails(cmp,event,helper,selectedRowdata);
        }

    },
    scrollAuthDetailsToView : function(component, event, helper) {
       /* var elementId = component.find("authDataTable")
        setTimeout(function() {
            if (!$A.util.isUndefinedOrNull(elementId)) {
                elementId.getElement().scrollIntoView({
                    behavior: 'smooth',
                    block: 'start',
                    inline: 'end'
                });
    	  }
        }, 100);*/

    }


})