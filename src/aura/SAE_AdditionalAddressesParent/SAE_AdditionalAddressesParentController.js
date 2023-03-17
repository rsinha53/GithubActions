({
    providerIdChange: function (component, event, helper) {
        //helper.getProviderData(component, event, helper, 0);
    },

    initComplete_Event : function(component, event, helper) {
        var settings = event.getParam("settings");
    },
    handledtcallbackevent : function(component, event, helper) {
        var settings = event.getParam("settings");
        var lgt_dt_table_ID = event.getParam("lgt_dt_table_ID");

        var element = document.getElementById("filterSection");
        element.classList.remove("slds-hide");

        var tabKey = component.get("v.AutodocKey");
        tabKey = tabKey + '_address';
        setTimeout(function(){
            window.lgtAutodoc.initAutodoc(tabKey);
        },1);
    },
    handlecreatedRow_Event : function(component,event,helper) {
         var row = event.getParam("row");   
         var data = event.getParam("data");
         var statusCode = data.ActiveStatus;
        // if(statusCode == 'A') {
        //     $(row).children().first().html('<div class="slds-icon_container_circle slds-icon-action-approval slds-icon_container"><img src="'+$A.get('$Resource.SLDS') + '/assets/icons/action/approval_60.png" style="max-width:12px;"></img></div>');
        // }else if(statusCode == 'I') {
        //     $(row).children().first().html('<div class="slds-icon_container_circle slds-icon-action-close slds-icon_container"><img src="'+$A.get('$Resource.SLDS') + '/assets/icons/action/close_60.png" style="max-width:12px;"></img></div>');
        // }
        
        if(statusCode == 'Active')
        {
            $(row).find("td:eq(1)").html('<div class="slds-icon_container_circle slds-icon-action-approval slds-icon_container" style="background: #76b74e;padding: 0;"><img src="'+$A.get('$Resource.SLDS') + '/assets/icons/action/approval_60.png" style="" class="slds-icon slds-icon_x-small"></img></div>');
        }
        else if(statusCode == 'Inactive')
        {
            $(row).find("td:eq(1)").html('<div class="slds-icon_container_circle slds-icon-action-close slds-icon_container" style="background: #ef6e64;padding: 0;"><img src="'+$A.get('$Resource.SLDS') + '/assets/icons/action/close_60.png" style="" class="slds-icon slds-icon_x-small"></img></div>');
        }
        else
        {

        }

        // console.log('data## '+ JSON.stringify(data));
        // console.log('row## '+row);
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
            helper.getProviderData(component, event, helper, 0);
        }

        if (sectionState == -1) {
            sectionDiv.setAttribute('class', 'slds-section slds-is-open');
        } else {
            sectionDiv.setAttribute('class', 'slds-section slds-is-close');
        }
    },

    activeToggle: function (component, event, helper){
        helper.getProviderData(component, event, helper, 0);
	}
})