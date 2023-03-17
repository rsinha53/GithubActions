({
    doInit: function(component, event, helper) {
        
    },
    
    openAuthDetail : function(component, event, helper) {
		var dataset = event.currentTarget.dataset;
        var workspaceAPI = component.find("workspace");
        var srk, userInfo;
        var groupNum = component.get("v.groupId");
		srk = component.get("v.srk");
		var allowedUser = component.get("v.allowedUser");
        var memberId = component.get("v.memberId");
        var intId = component.get("v.intId");
        var autodockey = component.get("v.AutodocKey");
		userInfo = component.get("v.userInfo");
        //alert("autodockey>>>"+autodockey);
        console.log('!!!'+dataset.authno+allowedUser);

        var hgltData = component.get("v.highlightPanel");

        var hgltps = component.get("v.highlightPanel_String");
        

        workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
            
            workspaceAPI.openSubtab({
                parentTabId: enclosingTabId,
                pageReference: {
                    "type": "standard__component",
                    "attributes": {
                        "componentName": "c__ACETLGT_AuthorizationDetail"
                    },
                    "state": {
                        "c__userInfo": userInfo,
                        "c__intId": intId,
                        "c__AutodocKey": autodockey,
                        "c__mId": memberId,
                        "c__gId":groupNum,
                        "c__srk":srk,
                        "c__allowedUser": allowedUser,
                        "c__authno" : dataset.authno,
						"c__authid": dataset.authid,
                        "c__authtype": dataset.authtype,
						"c__authcasetypecode": dataset.authcasetypecode,
						"c__authcasetypedesc": dataset.authcasetypedesc,
						"c__authcasestatus": dataset.authcasestatus,
						"c__authexpdisdate": dataset.authexpdisdate,
						"c__authpredet": dataset.authpredet,
						"c__authexpadmitdate": dataset.authexpadmitdate,
						"c__authactadmitdate": dataset.authactadmitdate,
						"c__authactdisdate": dataset.authactdisdate,
                        "c__jsonstring": dataset.jsonstring,
                        "c__hgltPanelData":hgltData,
                        "c__hgltPanelDataString":hgltps
                        
                        
                    }
                }
            }).then(function(response) {
                workspaceAPI.getTabInfo({
                    tabId: response
                }).then(function(tabInfo) {
                                        
                    workspaceAPI.setTabLabel({                        
                        tabId: tabInfo.tabId,
                        label: "Auth - " + dataset.authno
                    });
                    workspaceAPI.setTabIcon({
                        tabId: tabInfo.tabId,
                        icon: "standard:people",
                        iconAlt: "Member"
                    });
                });
            }).catch(function(error) {
                console.log(error);
            });
        });        
        
   	//alert('Auth type: ' + dataset.authid + '||||'+ dataset.authno+'|||'+srk);
	},
    
    handleIFCSectionToggle: function (component, event, helper)  {        
        var openSections = event.getParam('activeINFSections');
    },
    
    handleOPFCSectionToggle: function (component, event, helper)  {
        var openSections = event.getParam('activeOPFSections');
    },
    
    handleOPCSectionToggle: function (component, event, helper)  {
        var openSections = event.getParam('activeOPSections');
    },

    
    
    dataTblIdOCChange: function(component, event, helper)  {
        helper.render_IPC_Datatables(component, event, helper) ;
    },
    
     dataTblIdOFCChange: function(component, event, helper)  {
        helper.render_OFC_Datatables(component, event, helper) ;
    },
    
     dataTblIdOPCChange: function(component, event, helper)  {
        helper.render_OC_Datatables(component, event, helper) ;
    },
    ChangeCheckBox : function(component, event, helper) {

    	//var capturedCheckboxName = event.currentTarget.getAttribute("data-rolval");//event.getSource().get("v.value");
      	//alert(capturedCheckboxName)
       
      	//component.set("v.valList",capturedCheckboxName);
        //alert(component.get("v.valList").value);
        
        //var tempArr = component.get("v.valList");
        
        //if(tempArr.includes(capturedCheckboxName)== true){
        	//alert("ignore")
          //  var index = tempArr.indexOf(capturedCheckboxName);
            //alert(a);
            //tempArr.splice(index, 1)
            //delete tempArr[index];
        //}else{
          //  tempArr.push(capturedCheckboxName);
        //}

        //component.set("v.valList",tempArr);
		//var checkval = tempArr.replace(',',''); 
        //alert(tempArr.length);
        //if( tempArr.length == 0){
          //  component.set("v.isPharmacyListEmptyError",false);
        //}
        
    }
    
})