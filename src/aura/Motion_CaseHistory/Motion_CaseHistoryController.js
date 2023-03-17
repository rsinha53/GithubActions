({
    doInit : function(component, event, helper){
        component.set('v.openAcrd','');
        component.set('v.enablePagination',true);
        component.set('v.PageNumber',1);
        
    },
    openAccordian: function(component, event, helper){
        component.set('v.openAcrd','A');
       
    },
    handleSectionToggle: function(component, event, helper){
        var openSections = event.getParam('openSections');
        helper.fetchCaseHelper(component, event, helper);
    },
    getSelectedRecords: function(component, event, helper){
        var data = event.getParam("selectedRows");
        component.set("v.selectedRows",data);
    },
    navigateToCase: function(component, event, helper){
        var selectedRowdata = event.getParam("selectedRows");
        var caseId = selectedRowdata.uniqueKey;        
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            recordId: caseId,
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                tabId: response
            }).then(function(tabInfo) {
                
            });
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    getResults : function(component,event,helper) {
		var page=component.getEvent("motionpagechange");
        page.setParams(
          {"pagechange" : true});
        page.fire();												
	   var pageNum = event.getParam('requestedPageNumber');
         component.set("v.pageNumber",pageNum);	
        helper.fetchCaseHelper(component, event, helper);
    },
	enableLink : function (cmp, event) {
        var openedLinkData = event.getParam("selectedRows");
        var tableDetails = cmp.get("v.TableDetail");
        var tableRows = tableDetails.tableBody;
        tableRows.forEach(element => {
            if (element.uniqueKey == openedLinkData.uniqueKey) {
                element.linkDisabled = false;
            }
        });
        var enabled = [];
        var disabled = [];
        tableRows.forEach(element => {
            if (element.linkDisabled) {
                disabled.push(element);
            } else {
                enabled.push(element);
            }
        });
        tableDetails.tableBody = disabled.concat(enabled);
        cmp.set("v.TableDetail",tableDetails);
	},
    
})