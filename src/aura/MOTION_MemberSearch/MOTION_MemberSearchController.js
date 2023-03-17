({
    /*  datatable with pagination */
    doInit : function(component, event, helper) {        
        helper.populatePickListValues(component, event, helper);       
    },
    
    clear: function(component, event, helper) {
        helper.clearSearch(component, event, helper);
        helper.populatePickListValues(component, event, helper);   
       // component.set("v.pageNumber",1);
    },
              
    showBasicSearchResults:function(component, event,helper){ 
        //helper.showSpinner(component);
        component.set("v.pageNumber",1);
      helper.showBasicSearchResults(component, event,helper);
        //component.set("v.pageNumber",1);
    },   
    
    showAdvanceSearchResults:function(component, event,helper){
        //helper.showSpinner(component);
        component.set("v.pageNumber",1);
        helper.showAdvanceSearchResults(component, event,helper);
        //component.set("v.pageNumber",1);
    },
     
    handleCaseMemberEvent:function(component, event, helper){
        
        var firstname = event.getParam('FirstName');
        var lastname =event.getParam("LastName");
        var fullname =event.getParam("FullName");
        var iscasemember = event.getParam("isCsMbr");
        component.set("v.selectedStep", "step2");
        component.set("v.showpopup", event.getParam('showpopup'));
        component.set("v.OpenMemberSearch", false);
        var originators = [            
            { value:  (firstname+' '+lastname), label: (firstname+' '+lastname) },
            { value:  ('Third Party'), label: ('Third Party') },
        ];
        component.set("v.FamilyMembersList", originators);
     }, 
    toggleSearch : function(component,event, helper) {        
        var togg = document.getElementById("toggleSearch");
        
        if(togg.innerHTML == 'Show Advanced Search'){
            var elem = document.getElementById("advsearch");
            //elem.setAttribute("style", "display: Block;");
            togg.innerHTML = 'Hide Advanced Search';
            component.set("v.searchStatus",true);
			component.set("v.searchTypeLabel", 'Hide Advanced Search');
            component.set("v.showAdvancedSearch", true);
        }
        else {
            
            var elem = document.getElementById("advsearch");
            //elem.setAttribute("style", "display: none;");
            togg.innerHTML = 'Show Advanced Search';
            component.set("v.searchStatus",false);
             component.set("v.searchTypeLabel", 'Show Advanced Search');
            component.set("v.showAdvancedSearch", false);
        }
    },
    getResults : function(cmp,event,helper) {
        var pageNum = event.getParam('requestedPageNumber');
        var srchType = event.getParam('requestedSearchType');
        cmp.set("v.pageNumber",pageNum);
        cmp.set("v.searchType",srchType);
        //alert(cmp.get("v.pageNumber"));
        if(!$A.util.isEmpty(pageNum)) {
            if(cmp.get("v.searchType")==='B'){ 
                //helper.getProviderData(cmp);
                //helper.hideSpinner(cmp);
                helper.showBasicSearchResults(cmp, event, helper);
            } else {
                //helper.hideSpinner(cmp);
                helper.showAdvanceSearchResults(cmp, event, helper);
            }           
        } 
    },
    navAddIndividual : function(component, event, helper){
        helper.navigationAddIndividual(component, event, helper);
    },
    
    closeModel:function(component,event,helper){
        component.set("v.showpopup",false);
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
        	workspaceAPI.closeTab({
        	tabId: tabId
        	});
        });
	},
	handleOriginatorEvent : function(component, event, helper){
            var firstname = event.getParam('FirstName');
        		var lastname =event.getParam("LastName");
            	component.set("v.selectedStep", "step2");
        		component.set("v.showpopup", event.getParam('showpopup'));
        		component.set("v.OpenMemberSearch", false);
        		var originators = [            
            				{ value:  (firstname+' '+lastname), label: (firstname+' '+lastname) },
            				
        		];
        
        component.set("v.FamilyMembersList", originators);
            },
    
    
})