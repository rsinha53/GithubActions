({  
    onInit : function(cmp, event, helper) {
        //US2523190
        var titleLbId=cmp.get("v.titleLabel");
        cmp.set("v.titleLabId",titleLbId.replace(/\s+/, ''));
        var sampleVal = 'Home Health Care - \r\nIn Network:  Covered, Authorization May Be Required.\r\n  •  Aide\r\n  •  Private duty nursing \r\n  •  PT/OT/ST\r\n  •  Skilled nursing \r\n  •  Social worker \r\n  •  Home Infusion\r\n- Limited to skilled nursing for a home bound beneficiary which is provided or supervised by a registered nurse, and home health aide when the purpose of the treatment is skilled care; and medical social services which are necessary for the treatment of the beneficiarys medical condition.\r\nOut of Network:  Authorization Required\r\n\r\nPersonal Care Assistants (in home)/ Aide Services -\r\nIn Network:  Covered. Authorization Required.\r\n-Limited to 40 hours per week\r\n- Excludes: Personal Care Preference Program.  Cannot benefit from Personal Care Assistant and Personal Care Preference Program.\r\nOut of Network:  Personal Preference Program (person of member’s choosing) is covered by Medicaid FFS.  Members cannot have both Personal Care Assistant and be part of Personal Preference Program.\r\n\r\nRespite care - \r\nNot Covered';
        cmp.set("v.BenefitDescAutodocId",cmp.get("v.titleLabel")); //US1934460 - Avish   
        cmp.set("v.contactName",sampleVal);
    },
    
    //US2523190 this method toggles checkbox when selected any where in record
    selectRow: function (cmp, event) {
        var row = event.currentTarget.getAttribute("data-row-index");
        $('#trd'+row).find('input:checkbox').each(function() {
            if (this.className == 'autodoc') {
                this.checked = (!this.checked);
                if(this.checked){
                    $(event.target).closest("tr").addClass('highlight');
                } else {
                    $(event.target).closest("tr").removeClass('highlight');
                }
            }
        });
    },
    
    chevToggle : function(cmp, event, helper) {
        var iconName = cmp.find("chevInactive").get("v.iconName");
        
        if(iconName === "utility:chevrondown"){
            cmp.set("v.icon", "utility:chevronright");
            cmp.set("v.toggleName", "slds-hide");
            
        }else{
            cmp.set("v.icon", "utility:chevrondown");
            cmp.set("v.toggleName", "slds-show");
            // US1741780 - if condition for service call
            if(!cmp.get("v.isServiceCalled")){
                helper.showBenefitResultSpinner(cmp);
                helper.getBenefitLanguageDetails(cmp,helper); //US3125215 - Thanish - 22nd Dec 2020
            }
        }
    },
})