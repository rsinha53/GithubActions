({
    //Commented US2943826
    /*openDigitalContactHistoryUrl: function(component, event, helper) {
        var action = component.get("c.getDigitalContactHistoryUrl");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                // to navigate to ISET pharmacy claims
                if(resp != null && resp != ''){
                window.open(resp, '_blank','width=1000, height=800, resizable scrollbars');
                }
            }
           
        });
        $A.enqueueAction(action);
    },*/
    
    sortBy: function(component,helper,field) {
        var sortAsc = component.get("v.sortAsc");
        var sortField = component.get("v.sortField");
        var records = component.get("v.contactHistoryDataList");
        sortAsc = sortField != field || !sortAsc;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.contactHistoryDataList", records);        
    },
    
    //	US3131760
    getEngagementHistory: function(component, event, helper) {
        console.log('xrefId on contact history: ', component.get("v.xrefId"));
        component.set("v.spinner", true);
        var action = component.get("c.getMemEngagementHistory");
        action.setParams({
            xrefId : component.get("v.xrefId") //34386045, '25056797', '25056796', 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
			component.set('v.apiCallMade',true);									
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log('history : ', JSON.stringify(resp));
                // to navigate to ISET pharmacy claims
                if(!$A.util.isEmpty(resp)){
                    if(!$A.util.isEmpty(resp.systemErrorMsg)){
						 var noRecordErrorMsg = $A.get("$Label.c.ADB_ContactHistryNoDataMsg");
                        if(resp.systemErrorMsg === noRecordErrorMsg){
                            component.set("v.noDataMsg", resp.systemErrorMsg);
                             var noRecord12MonthErrorMsg = $A.get("$Label.c.ADB_ContactHistryTwlveMnthsNoDataMsg");
                                component.set("v.noDataMsg", noRecord12MonthErrorMsg);
                        }else{
                            component.set("v.systemErrorMsg", resp.systemErrorMsg);
                        } 
                    }else if(!$A.util.isEmpty(resp.histories)){
                        var contactHistoryData = [];
                        var testContactHistoryData = [];
                        var masterContactHistoryDataList = resp.histories;
                        
                        // Check the 12 month rolling period 
                        var today = new Date();
                        var lastday = today.setDate(today.getDate()-365);
                        console.log('lastdate : ', lastday);
                        
                        if(masterContactHistoryDataList.length > 0){
                            for(var i=0; i<masterContactHistoryDataList.length; i++){
                                console.log('item  : ', masterContactHistoryDataList[i]);
                                var oDate = masterContactHistoryDataList[i].openedDate;
                                var openedDate = new Date(oDate);
                                if(openedDate - lastday >= 0 ){
                                    contactHistoryData.push(masterContactHistoryDataList[i]);
                                }
                            }
                            //	checking for last 12 month rolling period record existence
                            if(!$A.util.isEmpty(contactHistoryData)){
                                // Set first 10 rows
                                if(contactHistoryData.length >= 10){
                                    testContactHistoryData = contactHistoryData.slice(0, 10);
                                }else{
                                    testContactHistoryData = contactHistoryData;
                                }
                                
                                testContactHistoryData.sort(function(a, b) {
                                    var keyA = a.openedDateTime,
                                        keyB = b.openedDateTime;
                                    
                                    if (keyA > keyB){return -1;}
                                    if (keyA < keyB){return 1;}
                                    return 0;
                                });
                                component.set("v.contactHistoryDataList",testContactHistoryData);
                            }else{
                                var noRecord12MonthErrorMsg = $A.get("$Label.c.ADB_ContactHistryTwlveMnthsNoDataMsg");
                                component.set("v.noDataMsg", noRecord12MonthErrorMsg);
                            }
                        }else{
                            var noRecordErrorMsg = $A.get("$Label.c.ADB_ContactHistryNoDataMsg");
							component.set("v.noDataMsg", noRecordErrorMsg);
                        }                                                
                    }
                }else{
                    var noRecordErrorMsg = $A.get("$Label.c.ADB_ContactHistryNoDataMsg");
                    component.set("v.noDataMsg", noRecordErrorMsg);
                }                               
            }
            component.set("v.spinner", false);
        });
        $A.enqueueAction(action);        
    }
})