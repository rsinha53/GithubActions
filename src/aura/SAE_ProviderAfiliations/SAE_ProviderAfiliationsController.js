({
    providerIdChange : function(component, event, helper) {
        //helper.getAffiliationData(component, event, helper);
        // helper.getAffiliations(component, event, helper);
    },

    initComplete_Event : function(component, event, helper) {
        var settings = event.getParam("settings");
    },
    handledtcallbackevent : function(component, event, helper) {
        var settings = event.getParam("settings");
        var lgt_dt_table_ID = event.getParam("lgt_dt_table_ID");
        var tabKey = component.get("v.AutodocKey") + '_affiliation';

        setTimeout(function(){
            window.lgtAutodoc.initAutodoc(tabKey);
        },1);
    },
    handlecreatedRow_Event : function(component,event,helper) {
         var row = event.getParam("row");
         var data = event.getParam("data");

        // US1958736 - Thanish - 6th Feb 2020 - truncating name field
        if(data.Name.length > 20) {
            var nameSubstring = data.Name.substring(0,20) + '...';
            $(row).find("td:eq(0)").html(nameSubstring);
            $(row).find("td:eq(0)").attr("title", data.Name);
        }
    },

    handle_dt_pageNum_Event : function(component, event, helper)
	{
		var pgnum = event.getParam("pageNumber");
        component.set("v.pageNumber",pgnum);
    },

    toggleSection: function (component, event, helper) {
        var sectionAuraId = event.target.getAttribute("data-auraId");
        var sectionDiv = component.find(sectionAuraId).getElement();

        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');

        var webservicecalled = component.get("v.webservicecalled");
        if(!webservicecalled){
            helper.getAffiliations(component, event, helper);
        }

        if (sectionState == -1) {
            sectionDiv.setAttribute('class', 'slds-section slds-is-open');
        } else {
            sectionDiv.setAttribute('class', 'slds-section slds-is-close');
        }
    },

    autodocHeaderClicked : function(cmp, event) {
        let tbody = event.currentTarget.parentElement.parentElement.parentElement.parentElement.getElementsByTagName("tbody")[0];
        let checkboxList = tbody.getElementsByTagName("input");
        let checkbox;

        if(checkboxList.length > 0) {
            if(event.currentTarget.checked) {
                for(checkbox of checkboxList) {
                    checkbox.checked = true;
                    checkbox.disabled = false;
                }
            } else {
                for(checkbox of checkboxList) {
                    checkbox.checked = false;
                    checkbox.disabled = false;
                }
            }
        }
    }
})