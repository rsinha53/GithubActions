({
    navigate: function(component,event,helper,intId,Name,lastName,firstName,addr,sc,gen,ssn,Id,scr,srk,srkkeychain,dob,IsMember,eid,int,intType,coverages,intOrigType,isOnshore,grpnum,uInfo,affiliationIndicator,vccdparams,bookOfBusinessTypeCode,specialtyBenefits){
        console.log('!!!'+coverages);
        var workspaceAPI = component.find("workspace");
        var coverages2;
        var isSave = component.get("v.isSave");
        if(coverages != undefined && coverages != null && coverages != '')
          coverages2 = window.btoa(JSON.stringify(coverages));
          
        //US1993681 : unique snapshot page will be loaded
        var memUniqueId = srk;        
        var matchingTabs = [];
        var tabIndex;
        
        workspaceAPI.getAllTabInfo().then(function (response){
            if (!$A.util.isEmpty(response)){
                
                for (var i=0; i < response.length; i++){      
                    
                    var tabUniqueId = response[i].pageReference.state.c__SRK;

                    if (tabUniqueId == memUniqueId){                        
                        matchingTabs.push(response[i]);
                        tabIndex = i;
                        break;
                    }     

                }                

            }
            
            //Open tab initially
            if (matchingTabs.length == 0){ 
                if(localStorage.getItem(Name) != undefined)
                	localStorage.removeItem(Name);
                	
                workspaceAPI.openTab({
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__ACETLGT_MemberDetail"
                        },
                        "state": {
                            "c__Name" : Name,
                            "c__lastName" : lastName,
                            "c__firstName" : firstName,
                            "c__sc" : sc,
                            "c__gen" : gen,
                            "c__addr" : addr,
                            "c__fullssn" : window.btoa(ssn),
                            "c__Id" : Id,
                            "c__scr" : scr,
                            "c__SRK" : srk,
                            "c__SRKKeyChain" : srkkeychain,
                            "c__grpnum" : grpnum,
                            "c__subjectdob" : dob,
                            "c__IsMember" : IsMember,
                            "c__individualIdentifier" : eid,
                            "c__coverages" : coverages2,
                            "c__InteractionType" : intType,
                            "c__InteractionId" : intId,
                            "c__Interaction" : int,
                            "c__InteractionOrigType" : intOrigType,
                            "c__isOnshore": isOnshore,
                            "c__usInfo": uInfo,
			    "c__vccdParams": vccdparams,
                            "c__affiliationIndicator" : affiliationIndicator,  //US1840846      
                            "c__bookOfBusinessTypeCode" : bookOfBusinessTypeCode,
                            "c__specialtyBenefits" : specialtyBenefits 
                        }
                    },
                    focus: true
                }).then(function(response) {
                    
                    workspaceAPI.getTabInfo({
                        tabId: response
                        
                    }).then(function(tabInfo) {
                        
                        workspaceAPI.setTabLabel({
                            tabId: tabInfo.tabId,
                            label: 'Detail-'+lastName
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

            }else{
                console.log('matchingTabs[0].tabId ::: '+matchingTabs[0].tabId);
                //var tId = matchingTabs[0].tabId;
                
                
                workspaceAPI.closeTab({tabId: matchingTabs[0].tabId});

                workspaceAPI.openTab({
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__ACETLGT_MemberDetail"
                        },
                        "state": {
                            //"selRec": JSON.stringify(component.get("v.memRec")),
                            "c__Name" : Name,
                            "c__lastName" : lastName,
                            "c__firstName" : firstName,
                            "c__sc" : sc,
                            "c__gen" : gen,
                            "c__addr" : addr,
                            "c__fullssn" : window.btoa(ssn),
                            "c__Id" : Id,
                            "c__scr" : scr,
                            "c__SRK" : srk,
                            "c__SRKKeyChain" : srkkeychain,
                            "c__grpnum" : grpnum,
                            "c__subjectdob" : dob,
                            "c__IsMember" : IsMember,
                            "c__individualIdentifier" : eid,
                            "c__coverages" : coverages2,
                            "c__InteractionType" : intType,
                            "c__InteractionId" : intId,
                            "c__Interaction" : int,
                            "c__InteractionOrigType" : intOrigType,
                            "c__isOnshore": isOnshore,
                            "c__usInfo": uInfo,
			    "c__vccdParams": vccdparams,
                            "c__affiliationIndicator" : affiliationIndicator,  //US1840846
                            "c__specialtyBenefits" : specialtyBenefits 
                        }
                    },
                    focus: true
                }).then(function(response) {
                    
                    workspaceAPI.getTabInfo({
                        tabId: response
                        
                    }).then(function(tabInfo) {
                        
                        workspaceAPI.setTabLabel({
                            tabId: tabInfo.tabId,
                            label: 'Detail-'+lastName
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
                
                //Implement the logic to load the correct tab
                var focusTabId = matchingTabs[0].tabId;
                var tabURL = matchingTabs[0].url;

                console.log('focusTabId ::: tabURL :::: '+focusTabId+' -- '+tabURL);
                
                
                
                
            }
            
            //End of US1993681 : unique snapshot page will be loaded

        })

          
	}
})