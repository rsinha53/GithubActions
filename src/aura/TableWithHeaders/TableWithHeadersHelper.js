({
    sortHelper : function(cmp, index, searchDir, colName) {
        var data = cmp.get("v.tableBody");
      
        var reverse = searchDir == 'asc'? 1: -1;
        console.log('colName:: '+ colName);
        if(colName == 'DERM ID'){            
            if(reverse==1){                
                data.sort(function(n1,n2){
                   var n1 = parseInt(n1.rowColumnData[index].fieldValue);
                   var n2 = parseInt(n2.rowColumnData[index].fieldValue);
                    //alert(n1);
                    //alert(n2);
                    if(n1=='' || Number.isNaN(n1)){
                        n1=0;
                    }
                    if(n2=='' || Number.isNaN(n2)){
                        n2=0;
                    }
                   return n1-n2;
                });                
            }else{
                data.sort(function(n1,n2){
                   var n1 = parseInt(n1.rowColumnData[index].fieldValue);
                   var n2 = parseInt(n2.rowColumnData[index].fieldValue);
                    if(n1=='' || Number.isNaN(n1)){
                        n1=0;
                    }
                    if(n2=='' || Number.isNaN(n2)){
                        n2=0;
                    }
                   return n2-n1;
                });   
            }
        } else if(colName == 'DOB'){            
            if(reverse==1){ 
                data.sort(function (d1, d2) {
                    var d1 = d1.rowColumnData[index].fieldValue;
                    var d2 = d2.rowColumnData[index].fieldValue;
                   /* var date =  d1.split('/');
                    d1 = date[1]+'/'+date[0]+'/'+date[2];
                    date =  d2.split('/');
                    d2 = date[1]+'/'+date[0]+'/'+date[2];*/
                    d1 = new Date(d1);
                    d2 = new Date(d2);
                    console.log('Asc Date1::'+d1);
                    console.log('Asc Date2::'+d2);
                    if (d1 > d2) return 1;
                    if (d1 < d2) return -1;
                    return 0;
                });                
            } else {
                data.sort(function (d1, d2) {
                    var d1 = d1.rowColumnData[index].fieldValue;
                    var d2 = d2.rowColumnData[index].fieldValue;
                    /*var date =  d1.split('/');
                    d1 = date[1]+'/'+date[0]+'/'+date[2];
                    date =  d2.split('/');
                    d2 = date[1]+'/'+date[0]+'/'+date[2];*/                 
                    d1 = new Date(d1);
                    d2 = new Date(d2);
                    console.log('Dsc Date1::'+d1);
                    console.log('Dsc Date2::'+d2);                                      
                    if (d1 > d2) return -1;
                    if (d1 < d2) return 1;
                    return 0;
                });                
            }
              
        }else{
             data.sort(function(a,b){
             	var a = a.rowColumnData[index].fieldValue;
                var b = b.rowColumnData[index].fieldValue;
                return reverse * ((a>b)-(b>a));
            });
        }       
        cmp.set("v.tableBody",data);
    },    
	navigateToMember: function(component, event, helper, lastName,firstName){
        var iscaseMember = component.get("v.iscaserecord");
        
			component.set("v.showResult",true);								   
        var workspaceAPI = component.find("workspace");
        var membnotfoundTabId;
        var fullName=firstName+ ' ' + lastName; 
        var eligibleMemberId= event.currentTarget.getAttribute("data-EligibleMemberId");
        var registeredMemberId=event.currentTarget.getAttribute("data-RegisteredMemberId");
        var email=event.currentTarget.getAttribute("data-email");
        var dob=event.currentTarget.getAttribute("data-dob");
        var interactionType = event.currentTarget.getAttribute("data-interactType");
        var groupName=event.currentTarget.getAttribute("data-groupName");
        var groupNo=event.currentTarget.getAttribute("data-groupNo");
		var phoneNo=event.currentTarget.getAttribute("data-phone");        
         if(!iscaseMember){
        //To get tab Id to close the Member Information from Tab
        workspaceAPI.getFocusedTabInfo().then(function(response){
            if(response != null){
                membnotfoundTabId = response.tabId;
            }
        });       
       
        workspaceAPI.openTab({
            pageReference: {
                "type": "standard__component",
                "attributes": {
                    "componentName": "c__Motion_MemberDetails"  
                },
                "state": {
                    
                    "c__lastName": lastName,
                    "c__firstName": firstName,
                    "c__name": fullName,
                    "c__registeredMemberId":registeredMemberId,
                    "c__eligibleMemberId":eligibleMemberId,
                    "c__memberEmail":email,
                    "c__memberDob":dob,
                    "c__interactionType":interactionType,
                    "c__groupName":groupName,
                    "c__groupNo": groupNo,
					"c__phoneNo": phoneNo,
                    
                }
            },
            focus: true
        }).then(function(response) {
                    
                    workspaceAPI.getTabInfo({
                        tabId: response
                        
                    }).then(function(tabInfo) {
                        
                        workspaceAPI.setTabLabel({
                            tabId: tabInfo.tabId,
                            label: 'Detail - '+ lastName
                        });
                        workspaceAPI.setTabIcon({
                            tabId: tabInfo.tabId,
                            icon: "standard:people",
                            iconAlt: "Member"
                        });
                       //Close the membernotfound form tab after opening Member detail page                        
                            workspaceAPI.closeTab({
                            tabId: membnotfoundTabId    
                           });      
                    });
                }).catch(function(error) {
            console.log(error);
        });
        } else{
            component.set("v.showResult",false);
            var caseEvent = component.getEvent("ChangeFirstNameEvent");
            caseEvent.setParams({ "FirstName" :  firstName,
                                 "LastName" : lastName,
                                 "FullName" : firstName+ ' ' + lastName,
                                 "isCsMbr" : iscaseMember,
                                 "showpopup" : false,
                                 "SubjectType" : "Member",
                                 "DOB" : dob,
                                 "email" : email,
                                 "RegisterMemberId" : registeredMemberId,
                                 "EligibleMemberId" : eligibleMemberId,
                                 "GroupName": groupName,
                                 "groupNumber":groupNo,
                                 "phone":phoneNo
                                });
        	caseEvent.fire();
        }
        
    },
    
    search: function (cmp, event) {
        var data = cmp.get("v.tableBody");

       // const inputValue = event.getSource().get('v.value').toUpperCase();
        var filtered = [];
        
        data.forEach(filterRecs);
        
        function filterRecs(item, index) {
            if(index < 25){        
                filtered.push(item);
            }
        }
        console.log('In TableWith Header Heleper:search: filtered::'+ filtered.length);
        //console.log('In TableWith Header Heleper:search: filtered::'+ JSON.stringify(filtered));
        cmp.set("v.tableBody", filtered);
    },
    
})