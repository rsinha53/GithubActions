window._autodoc = (function () {
    var autodocMap = new Map();
    var autodocMapAllData = new Map();
    
    return {
        getAutodoc: function (uniqueId) {
            var cmpDataMap = autodocMapAllData.get(uniqueId); 
            var cmpList = [];
            console.log(cmpDataMap);
            if(!$A.util.isEmpty(autodocMapAllData.get(uniqueId))){
                for (let value of cmpDataMap.values()){
                    for(var v in value){
                        console.log(value[v].componentName);
                        cmpList.push(value[v]);
                    }
                }            
            }
            
            return cmpList;
        },
        
        getAutodocComponent: function (uniqueId, uniqueIdCmp, cmpName) {
            var cmpDataMap = autodocMapAllData.get(uniqueId);
            var autodocCmp;
            var autodocCmpList;
            var cmp;

            if(!$A.util.isEmpty(cmpDataMap)){
                autodocCmpList = cmpDataMap.get(uniqueIdCmp);

                if (!$A.util.isEmpty(autodocCmpList)) {
                    for(cmp of autodocCmpList){
                        if(cmp.componentName == cmpName){
                            autodocCmp = cmp;
                        }
                    }
                }
            }
            return autodocCmp;
        },
        
        setAutodoc: function (uniqueId, uniqueIdCmp, cmpData) {
            console.log(JSON.parse(JSON.stringify(cmpData)));
            var cmpDataMap = autodocMapAllData.get(uniqueId);
            if ($A.util.isEmpty(autodocMapAllData.get(uniqueId))) {
                var cmpDataList = [];
                cmpDataList.push(cmpData);
                //autodocMap.set(uniqueId, cmpDataList);
                cmpDataMap = new Map();
                cmpDataMap.set(uniqueIdCmp, cmpDataList);
                autodocMapAllData.set(uniqueId, cmpDataMap);
            }else if((!$A.util.isEmpty(autodocMapAllData.get(uniqueId)) && $A.util.isEmpty(autodocMapAllData.get(uniqueId).get(uniqueIdCmp)))){
                var cmpDataList = [];
                cmpDataList.push(cmpData);
                //autodocMap.set(uniqueId, cmpDataList);
                cmpDataMap = autodocMapAllData.get(uniqueId);
                cmpDataMap.set(uniqueIdCmp, cmpDataList);
                autodocMapAllData.set(uniqueId, cmpDataMap);
            } else {
                var cmpDataList = autodocMapAllData.get(uniqueId).get(uniqueIdCmp);                
                var initialCmpDataListLength = cmpDataList.length;
                var existingCmpData = false;
                cmpDataList = cmpDataList.filter(function (value, index, arr) {
                    if (value.componentName != cmpData.componentName) {
                        return true;
                    } else {
                        existingCmpData = true;
                        return false;
                    }
                });
                console.log(JSON.parse(JSON.stringify(cmpDataList)));
                if (existingCmpData) {
                    // Check empty card data - Sanka Mod
                    if (cmpData.type == 'card') {
                        var checkedRows = cmpData.cardData.filter(function (row) {
                            return row.checked == true;
                        });
                        if (checkedRows.length > 0) {
                            cmpDataList.push(cmpData);
                        }
                    } else {
                        cmpDataList.push(cmpData);
                    }
                    //autodocMap.set(uniqueId, cmpDataList);
                } else {
                    var cmpDataList = autodocMapAllData.get(uniqueId).get(uniqueIdCmp);
                    cmpDataList.push(cmpData);
                    // autodocMap.set(uniqueId, cmpDataList);
                }
                //Order - Sanka Mod
                cmpDataList.sort((a, b) => (a.componentOrder > b.componentOrder) ? 1 : -1);
                
                cmpDataMap.set(uniqueIdCmp, cmpDataList);
                autodocMapAllData.set(uniqueId, cmpDataMap);
            } console.log(autodocMapAllData);
            return autodocMapAllData.get(uniqueId);
        },
		// US3020043 - Thanish - 29th Oct 2020
        deleteAutodoc: function (uniqueId, uniqueIdCmp) {
            var cmpDataMap = autodocMapAllData.get(uniqueId);
            if(!$A.util.isEmpty(cmpDataMap)){
                cmpDataMap.delete(uniqueIdCmp);
            }
        },
        
        deleteAutodocComponent: function (uniqueId, uniqueIdCmp, cmpName) {
            var cmpDataMap = autodocMapAllData.get(uniqueId);
            var autodocCmp;
            var autodocCmpList;
            var i;

            if(!$A.util.isEmpty(cmpDataMap)){
                autodocCmpList = cmpDataMap.get(uniqueIdCmp);

                if (!$A.util.isEmpty(autodocCmpList)) {
                    for(i=0; i<autodocCmpList.length; i++){
                        if(autodocCmpList[i].componentName == cmpName){
                            autodocCmpList.splice(i, 1);
                        }
                    }
                }
            }
        },

        //Reset Autodoc
        resetAutodoc: function (uniqueId) {
            autodocMapAllData.delete(uniqueId);
        },
        //Save Case Consolidation - US3424763
        getAllAutoDoc: function (snapshotId, viewOnly) {
            var selectedList = [];
            var unresolvedTopics = new Set();
            for (var key of autodocMapAllData.keys()) {
                console.log(key);
                if (key.includes(snapshotId)) {
                    var innerMap = autodocMapAllData.get(key);
                    if (!$A.util.isEmpty(innerMap)) {
                        for (var val of innerMap.values()) {
                            for (var v in val) {
                                console.log(val[v].componentName);
                                if (viewOnly) {
                                    selectedList.push(val[v]);
                                } else if (!viewOnly && !val[v].hasUnresolved) {
                                    selectedList.push(val[v]);
                                } else if (!viewOnly && val[v].hasUnresolved) {
                                    unresolvedTopics.add(val[v].callTopic);
        }
                            }
                        }
                    }
                }
            }
            var returnValue = new Object();
            returnValue.selectedList = selectedList;
            returnValue.unresolvedTopics = unresolvedTopics;
            return returnValue;
        },
        // DE456923 - Thanish - 28th Jun 2021
        clearAutoDoc: function (uniqueId) {
            console.log("clear autodoc");
            for (var key of autodocMapAllData.keys()) {
                if (key == uniqueId) {
                    var innerMap = autodocMapAllData.get(key);
                    if (!$A.util.isEmpty(innerMap)) {
                        for (var val of innerMap.values()) {
                            for (var v in val) {
                                // autodoc card clearing logic
                                if(val[v].type == "card") {
                                    if(val[v].ignoreClearAutodoc) {
                                        for (var data of val[v].cardData) {
                                            if(!data.disableCheckbox) {
                                                data.checked = false;
                                            }
                                        }
                                    } else{
                                        // DE477063 - Thanish - 13th Aug 2021 - adjusting empty cmp order
                                        var emptyCard = new Object();
                                        emptyCard.componentOrder = 999999;
                                        val[v] = emptyCard;
                                    }
                                }
                                // autodoc table clearing logic
                                else if(val[v].type == "table") {
                                    if(val[v].ignoreClearAutodoc) {
                                    } else{
                                        // DE477063 - Thanish - 13th Aug 2021 - adjusting empty cmp order
                                        var emptyTable = new Object();
                                        emptyTable.componentOrder = 999999;
                                        val[v] = emptyTable;
                                    }
                                }
                                // financials clearing logic
                                else if(val[v].type == "financials") {
                                	val[v] = {};
                                }
                            }
                        }
                    }
                }
            }
        }

    };
}());