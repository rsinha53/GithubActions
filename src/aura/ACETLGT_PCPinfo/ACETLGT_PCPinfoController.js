({
	handleCoveragesFamilyEvent : function(cmp, event) {
        
        var memberDetail = event.getParam("MemberDetail");
        cmp.set("v.Memberdetail", memberDetail);
        //var covLineMap = event.getParam("covLineSelMap");
        //console.log(covLineMap);
        console.log('~~~Event~~~memberDetail~4~~>>'+memberDetail);
        
    },
    doInit: function(component, event, helper) {
		    setTimeout(function(){ 
     var tabKey = 'pcpinfosec'+component.get("v.AutodocKey");
      window.lgtAutodoc.initAutodoc(tabKey);
            }, 5000);
	},
    onclickName: function(component, event, helper) {

        var originator = component.get("v.originator");
        if(!originator){
             // var ShowOriginatorErrorEvt = $A.get("e.c:ACETLGT_ShowOriginatorErrorEvt");
              // ShowOriginatorErrorEvt.fire();
           var showOriginatorError = component.getEvent("showOriginatorError");
           showOriginatorError.fire();
           var scrollOptions = {
            left: 0,
            top: 0,
            behavior: 'smooth'
           }
        window.scrollTo(scrollOptions);
        }else{
            
            var assignmentLevel = event.currentTarget.getAttribute("data-assignmentLevel");
            var locationAffiliationID = event.currentTarget.getAttribute("data-locationAffiliationID");
            var organizationId = event.currentTarget.getAttribute("data-organizationId");
			var pcpProviderType = '';            
            assignmentLevel =  assignmentLevel ? assignmentLevel : '';
            locationAffiliationID = locationAffiliationID ? locationAffiliationID : '';
            organizationId =  organizationId ? organizationId : '';
            
			if(assignmentLevel == '01')
            {
                organizationId = '';
                pcpProviderType = 'Physician';
            }
            else if(assignmentLevel == '02')
            {
                locationAffiliationID = '';
                pcpProviderType = 'Facility';
            }
        var memberdetail = component.get("v.Memberdetail");	
            var workspaceAPI = component.find("workspace");
                var hgltDataString = component.get("v.highlightPanelDataStr");
				    hgltDataString = JSON.parse(hgltDataString);
                    hgltDataString.Product = component.get('v.Product');
                    hgltDataString = JSON.stringify(hgltDataString);
            
                    workspaceAPI.getEnclosingTabId().then(function (enclosingTabId) {
                        workspaceAPI.openSubtab({
                            parentTabId: enclosingTabId,
                            pageReference: {
                                "type": "standard__component",
                                "attributes": {
                                    "componentName": "c__ACETLGT_ProviderLookup"
                                },
                                "state": {
                                    "c__callTopic" : "Provider Lookup",
                                    "c__interaction":component.get("v.int"),
                                    "c__intId":component.get("v.intId"),
                                    "c__srk":component.get("v.identifier"),
									"c__gId":component.get("v.grpNum"),
									"c__memberid":component.get("v.memId"),
                                    "c__city":component.get("v.providerCity"),
                                    "c__zip":component.get("v.providerZip"),
                                    "c_PCP_OBGYNID":locationAffiliationID,
                                    "c__hgltPanelDataString":hgltDataString,
                                    "c__FromPCP":'true',
                                     "c__eid":component.get("v.eid"),
									  "c__userInfo":component.get("v.userInfo"),
									  "c__fname":component.get("v.VA_firstName"),
									  "c__lname":component.get("v.VA_lastName"),
									  "c__va_dob":component.get("v.VA_DOB"),
                                    "c__groupName":component.get("v.groupName"),
                                        "c__providerState":component.get("v.providerState"),
                                        "c__Ismnf":component.get("v.Ismnf"),
                                    "c__hgltPanelData":component.get("v.highlightPanel"),
                                    "c__coverageInfoBenefits":component.get("v.covInfoBenefits"),
									"c__COStartDate":component.get("v.COStartDate"),
                                    "c__COEndDate":component.get("v.COEndDate"),
                                    "c__pcpProviderId": organizationId,
                                    "c__pcpProviderType" : pcpProviderType
                                }
                            }
                        }).then(function(response) {
                            workspaceAPI.getTabInfo({
                                tabId: response
                            }).then(function(tabInfo) {
                                workspaceAPI.setTabLabel({
                                    tabId: tabInfo.tabId,
                                    label: "Provider Lookup"
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
        }
              
	}
    /*,
    showdiv : function(component, event, helper) {
		console.log("in");
        var hiddenelement = document.getElementsByClassName("hiddendiv");
        console.log("in---->"+hiddenelement[0].style.display);
        if(hiddenelement[0].style.display == "none")
        	hiddenelement[0].style.display = "block";
        else if(hiddenelement[0].style.display == "block")
            hiddenelement[0].style.display = "none";
        else
            hiddenelement[0].style.display = "block";
	}*/
})