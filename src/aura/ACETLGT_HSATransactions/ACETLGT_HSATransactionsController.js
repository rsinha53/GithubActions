({
	doInit : function(component, event, helper) {	
        
        //Disable Transaction : Show Entries
        component.find('entriesDropdown').set("v.disabled", true);
        

        //Page Reference
		var pageReference = component.get("v.pageReference");
        var uInfo = pageReference.state.c__userInfo;
        var srk = pageReference.state.c__srk;
        var intId = pageReference.state.c__intId;
        var memId = pageReference.state.c__mId;
        var grpNum = pageReference.state.c__gId;  
        var groupNumber = pageReference.state.c__gId;
        var hsaId = pageReference.state.c__hsaId;
    var CPTIN = window.atob(pageReference.state.c__CPTIN);
    component.set("v.AutodocKey",pageReference.state.c__AutodocKey);
        
        //String Highlight panel data
        var hghString = pageReference.state.c__hgltPanelDataString;
        component.set("v.hgltPanelDataString", hghString);
        //
        var hpi = JSON.parse(hghString);

        component.set("v.usInfo", uInfo);
        component.set("v.srk", srk);
        component.set("v.intId", intId);
        component.set("v.memId", memId);
        component.set("v.memberId",memId);
        component.set("v.grpNum", grpNum);
        component.set("v.groupId",groupNumber);
        component.set("v.hsaId", hsaId);
        component.set("v.highlightPanel", hpi);
		component.set("v.CPTIN", CPTIN);
		component.set("v.toggleTable",true);
        var intId = component.get("v.intId");

        if(intId != undefined ){
            var childCmp = component.find("cComp");
            var memID = component.get("v.memId");
            var GrpNum = component.get("v.grpNum");
			var bundleId = hpi.benefitBundleOptionId;
            childCmp.childMethodForAlerts(intId,memID,GrpNum,'',bundleId);
        }

        helper.loadHSAValues(component,helper);
        helper.loadTransactionValues(component,helper);
        component.set("v.toggleTable",true);
        
    },

    handleBankAuthSectionToggle: function (component, event, helper)  {
        var openSections = event.getParam('Bank_Authentication');
    },

    handleAccountInfoSectionToggle: function (component, event, helper)  {
        var openSections = event.getParam('Account_Info');
	},
	
	handleTransactionInfoSectionToggle: function (component, event, helper)  {
        var openSections = event.getParam('Transaction_Info');
    },
    
	//To show or hide hover popup depending on its current state.
	togglePopup : function(component, event) {
		let showPopup = event.currentTarget.getAttribute("data-popupId");
        component.find(showPopup).toggleVisibility();
	},
    
    changeTransactionStatus : function(component, event, helper) {
        
        var val = component.find("statusDropdown").get("v.value");
        if(val == 'All'){
            //Disable Transaction : Show Entries
            component.find('entriesDropdown').set("v.value", 100);
            component.find('entriesDropdown').set("v.disabled", true);
        }else{
            //Enable Transaction : Show Entries
            component.find('entriesDropdown').set("v.disabled", false);
        }
        
    },
    
    refreshPage : function(component, event, helper) {
        var valu = component.get("v.status");
        console.log('>>>VALU'+valu);
        if(valu == 'All'){
        	component.set("v.toggleTable",true);
            helper.loadTransactionValues(component,helper);
        } else{
            component.set("v.toggleTable",false);
            helper.loadDataTableValues(component,helper);
       }     
        
    },
    handle_dt_callback_Event: function(component, event, helper) {
  var settings = event.getParam("settings");
  var lgt_dt_table_ID = event.getParam("lgt_dt_table_ID");
  var Responce = event.getParam("Responce");
          var comp =  event.getParam("comp");

        var table = $(lgt_dt_table_ID).DataTable();
        var info = table.page.info();
        console.log('pageinfo'+JSON.stringify(info));
        console.log('responce'+JSON.stringify(Responce));
        var currentpage = info.page + 1;
        var totalpages = info.pages;

    var entryinfo ;
        var startinfo = parseInt(info.start)+parseInt('1');
        var startto ;
        setTimeout(function() {
                if(currentpage == totalpages){
              startto =parseInt(info.recordsTotal);
                   entryinfo = 'Showing '+ startinfo +' to '+  startto  +' of ' +info.recordsTotal +' entries';
                  comp.set("v.lgt_dt_entries_info",entryinfo);
                }else  if(currentpage >1){
                    startto = parseInt(info.start)+parseInt(info.length);
                    entryinfo = 'Showing '+ startinfo +' to '+  startto  +' of ' +info.recordsTotal +' entries';
                                    comp.set("v.lgt_dt_entries_info",entryinfo);
                }
            }, 1);
    
    
 },
 handle_dt_initComplete_Event: function(component, event, helper) {
  var settings = event.getParam("settings");
 },
 handle_dt_pageNum_Event: function(component, event, helper) {
  var pgnum = event.getParam("pageNumber");
  //alert("====>>"+pgnum);
  component.set("v.page_Number", pgnum);
 }


})