({
    getClaimServiceLineList : function(component){
		var tableDetails = new Object(); 
		var i=0;
		tableDetails.type = "table";
		tableDetails.autodocHeaderName = "Service Line(s)";           
		tableDetails.componentName = "Service Line(s)";
		tableDetails.showComponentName = true;
		tableDetails.tableHeaders = [
			"LINE", "V", "CODE", "MOD",
			"SERVICE DATE(S)", "REMARK CODE(S)", "POS", "DX", "CHARGED", "ALLOWED",
			"DENIED","UNITS","DED","COPAY","COINS","PAID","SRN #","REFERRAL #","PROCESSED"
		];
		tableDetails.tableBody = [];
		for(i=1; i<=5;i++){
			let row = {
				"checked" : false,
				"uniqueKey" : i,
				"rowColumnData" : [
					{     
						"isOutputText" : true,
						"fieldLabel" : "LINE",
						"fieldValue" : i,
						"key" : i
					},
					{    
						"isOutputText" : true,
						"fieldLabel" : "V",
						"fieldValue" : "L"+i,
						"key" : i
					},
					{    
                        "isLink" : true,
						"fieldLabel" : "CODE",
						"fieldValue" : "99213"+i,
						"key" : i
					},
					{    
						"isOutputText" : true,
						"fieldLabel" : "MOD",
						"fieldValue" : "25",
						"key" : i
					},
					{    
						"isOutputText" : true,
						"fieldLabel" : "SERVICE DATE(S)",
						"fieldValue" : "9/10/2020 - 12/13/2020",
						"key" : i
					},
					{    
						"isOutputText" : true,
						"fieldLabel" : "REMARK CODE(S)",
						"fieldValue" : "D1, D2",
						"key" : i
					},
					{    
						"isOutputText" : true,
						"fieldLabel" : "POS",
						"fieldValue" : "21",
						"key" : i
					},
					{    
						"isOutputText" : true,
						"fieldLabel" : "DX",
						"fieldValue" : "K15.7",
						"key" : i
					},
					{    
						"isCurrencyOutputText" : true,
						"fieldLabel" : "CHARGED",
						"fieldValue" : "15.00",
						"key" : i
					},
					{    
						"isCurrencyOutputText" : true,
						"fieldLabel" : "ALLOWED",
						"fieldValue" : "7.00",
						"key" : i
					},
					{    
						"isCurrencyOutputText" : true,
						"fieldLabel" : "DENIED",
						"fieldValue" : "8.00",
						"key" : i
					},
					{    
						"isOutputText" : true,
						"fieldLabel" : "UNITS",
						"fieldValue" : "5",
						"key" : i
					},
					{    
						"isCurrencyOutputText" : true,
						"fieldLabel" : "DED",
						"fieldValue" : "1000.00",
						"key" : i
					},
					{    
						"isCurrencyOutputText" : true,
						"fieldLabel" : "COPAY",
						"fieldValue" : "4.00",
						"key" : i
					},
					{    
						"isCurrencyOutputText" : true,
						"fieldLabel" : "COINS",
						"fieldValue" : "3.00",
						"key" : i
					},
					{    
						"isCurrencyOutputText" : true,
						"fieldLabel" : "PAID",
						"fieldValue" : "0.00",
						"key" : i
					},
					{    
						"isOutputText" : true,
						"fieldLabel" : "SRN #",
						"fieldValue" : "A123456789012",
						"key" : i
					},
					{    
						"isOutputText" : true,
						"fieldLabel" : "REFERRAL #",
						"fieldValue" : "R123456789012",
						"key" : i
					},
					{    
						"isOutputText" : true,
						"fieldLabel" : "PROCESSED",
						"fieldValue" : "9/10/2020",
						"key" : i
					}]                	
				}   
			tableDetails.tableBody.push(row);					
		}
   
		component.set("v.claimServiceLineList", tableDetails);
	},
    sortClaimSvcInfoCards: function (cmp) {
        var clmSvcInfoList = cmp.get("v.clmSvcInfoList");
        var order = 1;
        for (var i = clmSvcInfoList.length; i > 0; i--) {
            clmSvcInfoList[(i - 1)].set('v.cardOrder', order);
            ++order;
        }
        cmp.set("v.clmSvcInfoList", clmSvcInfoList);
    },
    enableLink : function (cmp,index) {
        var tableDetails = cmp.get("v.claimServiceLineList");
        var tableRows = tableDetails.tableBody;
        tableRows[index].linkDisabled = false;
        tableDetails.tableBody = tableRows;
        cmp.set("v.claimServiceLineList",tableDetails);
    },
    navigateToCallTopic : function(component, event, helper, topicname) {
        setTimeout(function() {
            var auth='';
            if(component.find(topicname).length > 0){
                auth=component.find(topicname)[component.find(topicname).length-1];
            }else{
                auth=component.find(topicname);
            }
            auth.getElement().scrollIntoView({
                behavior: 'smooth',
                block: 'center',
                inline: 'nearest'
            });
        }, 100);
    },
    autoDocSRN : function(component, event, helper, authVal, ClaimType,lineNum,cellIndex) {
        var cmpname = 'Service Line(s): '+component.get("v.claimNo");
        var gettableDetails = _autodoc.getAutodocComponent(component.get("v.autodocUniqueId"),component.get("v.autodocUniqueIdCmp"),cmpname);
        if(!$A.util.isEmpty(gettableDetails)){
            if(gettableDetails.selectedRows.length > 0){
                var srn = '';
                for( var i = 0; i < gettableDetails.selectedRows.length; i++){
                    var srn = gettableDetails.selectedRows[i].rowColumnData[cellIndex].fieldValue;
                    var lineNums = gettableDetails.selectedRows[i].rowColumnData[1].fieldValue;
                    if(srn==authVal && lineNums==lineNum && cellIndex != 3){
                        gettableDetails.selectedRows[i].rowColumnData[cellIndex].autodocFieldValue= srn+' was selected';
                    }
                }
                _autodoc.setAutodoc(component.get("v.autodocUniqueId"),component.get("v.autodocUniqueIdCmp"), gettableDetails);
            }
        }
	},
    getReferrals: function(component, event, helper) {
        console.log('entered into referrral');
        var claimInput = component.get("v.claimInput");
        var action = component.get("c.getClaimsAutodoc");
        action.setParams({
            ClaimInputs: claimInput // pass the claim input values
        });
        action.setCallback(this, function(response) {
            var responseData = response.getReturnValue();
            console.log('for referral data'+responseData);
            if (responseData.success) {
                // write logic to populate referral number in table 
                component.set("v.referralNum", referralNum);
                component.set("v.referralFlag", true);
            }
        });
        //  $A.enqueueAction(action);
    
    }
	
})