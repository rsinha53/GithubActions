({
   /*
     * this function will build table data
     * based on current page selection
     * */

    casesFROMORSService : function(component,event,helper) {
       
        if(!component.get("v.isSpireOnlyCases")){
        var isProvider = component.get("v.isProvider");
        
        var taxId = component.get("v.taxId");
        var memberId = component.get("v.memberID");
        var EEID = component.get("v.memberSubscriberId");
        var nextIssueKey = component.get("v.nextIssueKey");
        var orsSelectIssues = component.get("v.orsSelectIssues");
        var isMember = component.get("v.showFamilyCases");
        var isContinueORSFetch=true;
        var isSixMonths = component.get("v.lastsixchecked");
        var isSixtyDays = component.get("v.isLastSixtyDaysOnly");
        var memDOB;
        if(!isProvider){
            var dobMem = component.get("v.memberDOB").split('/');
            memDOB = dobMem[2] +'-'+ dobMem[0] +'-'+ dobMem[1];
        }
        console.log("memberDOB :::: "+memDOB);
        var memRelation = component.get("v.relationShipcode");
        var memberNumber = component.get("v.memberID");

        console.log("#Fetching ORS cases");

        var action = component.get("c.selectIssues");
        action.setParams({
            "lastName": '', 
            "alternateId": EEID,
            "state": '',
            "callerFirstName": '', 
            "callerLastName": '',
            "isProvider":isProvider,
            "providerTaxId":taxId,
            "isToggleOnOff":false,
            "nextIssueKey": nextIssueKey,
            "memdob": memDOB,
            "memRelation": memRelation,
            "memberNumber": memberNumber
        });
       
        action.setCallback(this, function(response) {  
            var state = response.getState();
                if(isProvider){
                    helper.getFACETCases(component,event,helper);
                }
            if(state == 'SUCCESS') {
                var result = response.getReturnValue();
                // US2101464 - Thanish - 22nd Jun 2020 - Error handling ...
                if(result.length > 0){
                    if(result[0].responseStatus!=200){
                            component.set("v.orsServiceFailed", true);
                            if(component.get("v.orsServiceFailed")) {
                                this.fireErrorToastMessage(result[0].responseStatusMessage);   
                            }
                        component.set("v.paginationBtnDisable",false);
                        helper.hideCaseSpinner(component);
                    }else{
                        component.set("v.moreData",result[0].moreData);
                        if(result[0].moreData){
                            component.set("v.nextIssueKey",result[0].nextIssueKey);

                            for(var i in result){
                                orsSelectIssues.push(result[i]);
                                    /*if(isMember && isSixMonths){
                                    isContinueORSFetch=result[i].isSixMonths;
                                }else if(isProvider && isSixtyDays){
                                    isContinueORSFetch=result[i].isSixtyDays;
                                }else if(isMember && !isSixMonths){
                                    isContinueORSFetch=true;
                                }else if(isProvider && !isSixtyDays){
                                    isContinueORSFetch=true;
                                    }*/
                                }
                                //component.set("v.isContinueORSFetch",isContinueORSFetch);
                            component.set("v.orsSelectIssues",orsSelectIssues);
                            //if(!isContinueORSFetch){
                                helper.addORselectIssues(component,event,helper);
                            //}
                            //this.callNextORScases(component,event,helper);

                        }else{
                            for(var i in result){
                                orsSelectIssues.push(result[i]);
                    }
                            component.set("v.orsSelectIssues",orsSelectIssues);
                            component.set("v.isAllORSCasesFetched",true);

                            helper.addORselectIssues(component,event,helper);

                        }
                }
                }

            }else if(state == 'ERROR'){ // Thanish - 2nd Jul 2020 - Bug Fix
                    component.set("v.orsServiceFailed", true);
                    if(component.get("v.orsServiceFailed")) {
                        this.fireErrorToastMessage("Unexpected Error Occurred in the Case History�card. Please try again. If problem persists please contact the help desk.");
                    }
                component.set("v.paginationBtnDisable",false);
                helper.hideCaseSpinner(component);
            }
        });
        
        $A.enqueueAction(action);
        //component.set("v.nextIssueKey",'');
        }
    },
    
    // US2101464 - Thanish - 22nd Jun 2020 - Error code handling ...
    fireErrorToastMessage: function (message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "We hit a snag.",
            "message": message,
            "type": "error",
            "mode": "dismissible",
            "duration": "30000"
        });
        toastEvent.fire();
    },

    // US2584524 - FACETS Member snapshot case history
    getFACETCases : function(component,event,helper) {
        if(component.get("v.isFacetsEnabled")=='TRUE'){


            console.log("###get FACET cases");

            var isProvider = component.get("v.isProvider");
            var memberId = '';
            var nextPageInd = component.get("v.nextPageInd");
            var lstFacetCases = component.get("v.lstFacetCases");
            var cnsProviderId ='';
            var offset=component.get("v.offSet");
            if(isProvider){
                cnsProviderId = component.get("v.cnsProviderId");
            }else{
                memberId = component.get("v.memberID");
            }

            var action = component.get("c.fetchFACETCases");
            action.setParams({
                "subscriberId": memberId,
                "providerId": cnsProviderId,
                "inquiryId": '',
                "offset": offset

            });

            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log('### facets response state==>:'+state);
                if(state == 'SUCCESS') {
                    var result = response.getReturnValue();
                    console.log('### facets response==>:'+JSON.stringify(result));
                    if(result.length > 0){
                        if(result[0].responseStatus!=200){
                            component.set("v.facetsServiceFailed", true);
                            if(!component.get("v.orsServiceFailed") && component.get("v.facetsServiceFailed")) {
                                this.fireErrorToastMessage(result[0].responseStatusMessage);
                            }
                            component.set("v.paginationBtnDisable", false);
                            helper.hideCaseSpinner(component);
                        }else{
                            component.set("v.nextPageInd",result[0].moreData);
                            if(result[0].moreData){
                                var recordCount=result[0].recordCount;
                                var currentOffset = component.get("v.offSet");
                                var nextOffset = recordCount + currentOffset;
                                console.log('### recordCount==>:'+ nextOffset);
                                component.set("v.offSet",nextOffset);
                                console.log('### offset==>:'+component.get("v.offSet"));
                                for(var i in result){
                                    lstFacetCases.push(result[i]);
                                }
                                component.set("v.lstFacetCases",lstFacetCases);
                                helper.addORselectIssues(component,event,helper);
                            }else{
                                for(var i in result){
                                    lstFacetCases.push(result[i]);
                                }
                                component.set("v.lstFacetCases",lstFacetCases);
                                component.set("v.isAllFACETCasesFetched",true);

                                helper.addORselectIssues(component,event,helper);

                            }
                        }
                    }
                } else if (state == 'ERROR') {
                    component.set("v.facetsServiceFailed", true);
                    if(!component.get("v.orsServiceFailed") && component.get("v.facetsServiceFailed")) {
                        this.fireErrorToastMessage("Unexpected Error Occurred in the Case History�card. Please try again. If problem persists please contact the help desk.");
                    }
                    component.set("v.paginationBtnDisable", false);
                    helper.hideCaseSpinner(component);
                }
            });

            $A.enqueueAction(action);
        }
    },

    buildData : function(component, helper) {
        var data = [];
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.allData");
        //US3579548 - Sravan - Start
        if($A.util.isUndefinedOrNull(allData) || $A.util.isEmpty(allData)){
         	component.set("v.caseSearchFlag",true);
        }
        //US3579548 - Sravan - End
        console.log('All data'+ JSON.stringify(allData));
        if(pageNumber == 1){
            var endNumber = allData.length > pageSize ? pageSize : allData.length;
            component.set("v.currentEndNumber", endNumber);
            component.set("v.currentStartNumber", 1);
        }

        var x = (pageNumber-1)*pageSize;
        
        //creating data-table data
        for(; x<(pageNumber)*pageSize; x++){
            if(allData[x]){
            	data.push(allData[x]);
            }
        }
      
        var tempObj = {
            "OriginatorType":'',
            "CreatedDate": '',
            "relationship": '',
            "ID": [],
            "IDType": '',
            "IDMap": new Map(),
            "CaseNumber": '',
            "TopicReason": '',
            "recordID":'',
            "Status": ''
        };
        var newCaseLst = [];
        for(var i = 0; i < data.length;i++){
            tempObj = new Object();
            tempObj.OriginatorType = data[i].OriginatorType;
            tempObj.CreatedDate = data[i].CreatedDate;
            tempObj.relationship = data[i].relationship;
            if(!$A.util.isEmpty(data[i].ID) && data[i].ID.includes(',')){
                var IDList =  data[i].ID.split(',');
                tempObj.ID = IDList;
            }else{
                var IDList = [];
                IDList.push(data[i].ID);
				tempObj.ID =   IDList;              
            }
            var idMap = new Map();
            if(!$A.util.isEmpty(data[i].idMap)){
              tempObj.IDMap = data[i].idMap;
            }else{
                //var emptyMap = new Map();
                //emptyMap.add('--','--');
            }

            //US3537364
            var openedTabs = component.get("v.openedTabs");
            tempObj.hasOpened = false;
            tempObj.subtabClass = '';
            tempObj.tabOpenedCase = '';
            if (!$A.util.isEmpty(openedTabs)) {
                try {
                    for (let index = 0; index < tempObj.ID.length; index++) {
                        const id = tempObj.ID[index];
                        if (openedTabs[id] != null) {
                            tempObj.hasOpened = true;
                            tempObj.subtabClass = openedTabs[id];
                            tempObj.tabOpenedCase = id;
                            break;
                        }
                    }
                } catch (error) {
                    console.log(error);
                }
            }
            // End

            tempObj.IDType = data[i].IDType;
            tempObj.CaseNumber = data[i].CaseNumber;
            tempObj.TopicReason = data[i].TopicReason;
            tempObj.Status = data[i].Status;
            tempObj.recordID = data[i].recordID;
            newCaseLst.push(tempObj);
        }
        component.set("v.data", newCaseLst);
        this.generatePageList(component, pageNumber);
    },
    
    showCaseSpinner: function (component) {
        var spinner = component.find("case-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    hideCaseSpinner: function (component) {
        var spinner = component.find("case-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    /*
     * this function generate page list
     * */
    generatePageList : function(component, pageNumber){
        pageNumber = parseInt(pageNumber);
        var pageList = [];
        var totalPages = component.get("v.totalPages");
        if(totalPages > 1){
            if(totalPages <= 10){
                var counter = 2;
                for(; counter < (totalPages); counter++){
                    pageList.push(counter);
                } 
            } else{
                if(pageNumber < 5){
                    pageList.push(2, 3, 4, 5, 6);
                } else{
                    if(pageNumber>(totalPages-5)){
                        pageList.push(totalPages-5, totalPages-4, totalPages-3, totalPages-2, totalPages-1);
                    } else{
                        pageList.push(pageNumber-2, pageNumber-1, pageNumber, pageNumber+1, pageNumber+2);
                    }
                }
            }
        }
        component.set("v.pageList", pageList);
    },
    
    sortData : function(component,fieldName,sortDirection){
        var data = component.get("v.data");
        //function to return the value stored in the field
        var key = function(a) { return a[fieldName]; }
        if(sortDirection == 'arrowdown') {
            component.set("v.arrowDirection", 'arrowup');
        }else{
            component.set("v.arrowDirection", 'arrowdown');
        }
        sortDirection = component.get("v.arrowDirection");
        var reverse = sortDirection == 'arrowup' ? 1: -1;        
        
        // to handel number/currency type fields 
        // Fixing exception
        if (fieldName == 'CaseNumber' || fieldName == 'ID') {
            data.sort(function(a,b){
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a>b) - (b>a));
            }); 
        }else if(fieldName == 'CreatedDate'){
            data.sort(function(a,b){
                var dateA = new Date(key(a)).getTime();
                var dateB = new Date(key(b)).getTime();
                return reverse * (dateA > dateB ? 1 : -1);
            });
        }else{// to handel text type fields
            data.sort(function(a,b){ 
                var a = key(a) ? key(a).toLowerCase() : '';//To handle null values , uppercase records during sorting
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a>b) - (b>a));
            });    
        }
        //set sorted data to accountData attribute
        component.set("v.data",data);
    },
    
    filterCaseResults: function(cmp,event,helper){
        cmp.set("v.caseSearchFlag",false);
        var value = event.getParam("value").toLowerCase();
        //var data = cmp.get("v.allData");
        var data = cmp.get("v.originalData");
        if(value == undefined || value == ''){
            cmp.set('v.allData', data);
            this.resetPages(cmp,helper);
            this.buildData(cmp, helper);
            return;   
        }
        var caseLst = [];
        for (var i = 0; i < data.length; i++) {
        	//console.log(data[i]);
            if((data[i].Status != null && data[i].Status != '') && data[i].Status.toLowerCase().indexOf(value) != -1 || 
                (data[i].CreatedDate != null && data[i].CreatedDate != '') && data[i].CreatedDate.indexOf(value) != -1 || 
                (data[i].ID != null && data[i].ID != '') && data[i].ID.toLowerCase().indexOf(value) != -1 || 
               	(data[i].IDType != null && data[i].IDType != '') && data[i].IDType.toLowerCase().indexOf(value) != -1 || 
               	(data[i].subject != null && data[i].subject != '') && data[i].subject.toLowerCase().indexOf(value) != -1 ||
                (data[i].TopicReason != null && data[i].TopicReason != '') && data[i].TopicReason.toLowerCase().indexOf(value) != -1 || 
                (data[i].CaseNumber != null && data[i].CaseNumber != '') && data[i].CaseNumber.toLowerCase().indexOf(value) != -1 ||
                (data[i].OriginatorType != null && data[i].OriginatorType != '') && data[i].OriginatorType.toLowerCase().indexOf(value) != -1 ||
                (data[i].relationship != null && data[i].relationship != '') && data[i].relationship.toLowerCase().indexOf(value) != -1) {
                caseLst.push(data[i]);
            }
        }
        if(caseLst.length > 0){
            cmp.set('v.allData', caseLst);
        }else{
            cmp.set('v.allData', []);
            cmp.set("v.caseSearchFlag",true);
        }

        this.resetPages(cmp,helper);

        this.buildData(cmp, helper);
    },

    resetPages: function(cmp,helper){
        if (Math.ceil(cmp.get('v.allData').length / cmp.get("v.pageSize")) == 0) {
            cmp.set("v.totalPages", 1);
        } else {
            cmp.set("v.totalPages", Math.ceil(cmp.get('v.allData').length / cmp.get("v.pageSize")));
        }
        //DE318080 - Ends
        cmp.set("v.currentPageNumber", 1);
        cmp.set("v.sortDirection", "desc");
        cmp.set("v.sortBy", "CaseNumber");
    },

    showResults: function (cmp, event, helper, memberTabId) {

        //if (cmp.get("v.memberTabId") == event.getParam("memberTabId")) {
         
            //cmp.set("v.memberID", event.getParam("memberID"));
            //cmp.set("v.xRefId", event.getParam("xRefId"));
            
            
            var comibinedCaseHistory = [];
            var caseHistoryList = cmp.get("v.caseHistoryList");
            comibinedCaseHistory = caseHistoryList;
            var orsSelectIssues = cmp.get("v.orsSelectIssues");
        var lstFacetCases = cmp.get("v.lstFacetCases");

            var caseHistoryMap = new Map();
            //var dupCheck = new Array();
            var dupCheck = new Map();
            
            for (var j of caseHistoryList) {
                
                if(j.ID.indexOf(',') > -1){
                    var str = j.ID.split(',');
                    for(var m=0; m<str.length;m++){
                        dupCheck.set(str[m], j);
                    }
                }
                else{
                    dupCheck.set(j.ID,j);
                }
                caseHistoryMap.set(j.ID, j);
            }
            for (var i of orsSelectIssues) {
                //if(caseHistoryMap.get(i.ID) == null || caseHistoryMap.get(i.ID) == 'undefined') {
                if(!dupCheck.has(i.ID)) {
                    comibinedCaseHistory.push(i);
                }
            }

        // FACETS Dup Check
        for (var i of lstFacetCases) {

            if(!dupCheck.has(i.ID)) {

                comibinedCaseHistory.push(i);
            }
        }

            /*
            for (var i of orsSelectIssues){
               comibinedCaseHistory.push(i); 
            }*/

            if(comibinedCaseHistory.length > 0){
                cmp.set("v.currentStartNumber", 1);
            }

            cmp.set("v.allUnfilteredData", comibinedCaseHistory);

            var filteredData = this.filterAllData(cmp, event, helper, comibinedCaseHistory);
            comibinedCaseHistory = filteredData;

            cmp.set("v.allData", comibinedCaseHistory);
            cmp.set("v.originalData", comibinedCaseHistory);
            cmp.set("v.selectedTabsoft", 'CaseNumber');
            //DE318080 - Avish
            //cmp.set("v.totalPages", Math.ceil(comibinedCaseHistory.length/cmp.get("v.pageSize")));
            if (Math.ceil(comibinedCaseHistory.length / cmp.get("v.pageSize")) == 0) {
                cmp.set("v.totalPages", 1);
            } else {
                cmp.set("v.totalPages", Math.ceil(comibinedCaseHistory.length / cmp.get("v.pageSize")));
            }
            //DE318080 - Ends
            cmp.set("v.currentPageNumber", 1);
            cmp.set("v.sortDirection", "desc");
            cmp.set("v.sortBy", "CaseNumber");
            this.buildData(cmp, helper);
            this.hideCaseSpinner(cmp);
        //}
        cmp.get("v.arrowDirection", 'arrowdown');
    },

    showResultsToggle: function (cmp, event, helper) {
        var memberId = cmp.get("v.memberID");
        var isToggleOnOff = cmp.get("v.isToggleOnOff");
        var action = cmp.get("c.selectIssues");
        action.setParams({
            "lastName": '',
            "alternateId": memberId,
            "state": '',
            "callerFirstName": '',
            "callerLastName": '',
            "isProvider": '',
            "providerTaxId": '',
            "isToggleOnOff": isToggleOnOff
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                if(result.length == 0){
                    result = cmp.get("v.orsSelectIssues");
                }
                cmp.set("v.orsToggleSelectIssues", result);
                this.showResultsToggleBuild(cmp, event, helper);
            } else if (state == 'ERROR') {
                console.log('ors failed');
                cmp.set("v.orsToggleSelectIssues", cmp.get("v.orsSelectIssues"));
                this.showResultsToggleBuild(cmp, event, helper);
            }else{
                console.log('ors failed');
                cmp.set("v.orsToggleSelectIssues", cmp.get("v.orsSelectIssues"));
                this.showResultsToggleBuild(cmp, event, helper);
            }
        });

        cmp.set("v.orsToggleSelectIssues", cmp.get("v.orsSelectIssues"));
        helper.showResultsToggleBuild(cmp, event, helper);

        //$A.enqueueAction(action);
    },

    showResultsToggleBuild: function (cmp, event, helper){
        
        this.hideCaseSpinner(cmp);
        var comibinedCaseHistory = [];
        if (cmp.get("v.memberTabId") == event.getParam("memberTabId")) {
            var caseHistoryList = event.getParam("caseHistoryList");
            comibinedCaseHistory = caseHistoryList;
            var orsToggleSelectIssues = cmp.get("v.orsToggleSelectIssues");

           var caseHistoryMap = new Map();
            //var dupCheck = new Array();
            var dupCheck = new Map();
            
            for (var j of caseHistoryList) {
                
                if(j.ID.indexOf(',')>-1){
                    var str = j.ID.split(',');
                    for(var m=0; m<str.length;m++){
                        dupCheck.set(str[m], j);
                    }
                }
                else{
                    dupCheck.set(j.ID,j);
                }
                caseHistoryMap.set(j.ID, j);
            }
            for (var i of orsToggleSelectIssues) {
                //if(caseHistoryMap.get(i.ID) == null || caseHistoryMap.get(i.ID) == 'undefined') {
                if(!dupCheck.has(i.ID)) {
                    comibinedCaseHistory.push(i);
                }
            }
            
            /*/added for testing
            for (var i of orsToggleSelectIssues){
               comibinedCaseHistory.push(i); 
            }*/

            if(comibinedCaseHistory.length > 0){
                cmp.set("v.currentStartNumber", 1);
            }
                        
            cmp.set("v.allUnfilteredData", comibinedCaseHistory);

            var filteredData = this.filterAllData(cmp, event, helper, comibinedCaseHistory);
            comibinedCaseHistory = filteredData;

            cmp.set("v.caseHistoryList", comibinedCaseHistory);
            cmp.set("v.allData", comibinedCaseHistory);
            cmp.set("v.originalData", comibinedCaseHistory);
            cmp.set("v.selectedTabsoft", 'CaseNumber');
            if (Math.ceil(comibinedCaseHistory.length / cmp.get("v.pageSize")) == 0) {
                cmp.set("v.totalPages", 1);
            } else {
                cmp.set("v.totalPages", Math.ceil(comibinedCaseHistory.length / cmp.get("v.pageSize")));
            }
            cmp.set("v.currentPageNumber", 1);
            cmp.set("v.sortDirection", "desc");
            cmp.set("v.sortBy", "CaseNumber");
            this.buildData(cmp, helper);
        }
    },

    filterAllData: function (cmp, event, helper, caseListOrg) {
        cmp.set("v.caseSearchFlag",false);
        // var allFilters = cmp.get('v.items');
        var hasSixMonths = cmp.get("v.lastsixchecked");
        var hasProviderOnly = cmp.get("v.providerChecked");

        var isSpireOnlyCases = cmp.get("v.isSpireOnlyCases");

        // US2667560 -  Sanka - ORS Family Filtering
        var onlyIndividual = cmp.get("v.isIndividual");
        var isMember = cmp.get("v.showFamilyCases");
        var xRefIdORS = cmp.get("v.xRefIdORS");

        var isLastSixtyDaysOnly = cmp.get("v.isLastSixtyDaysOnly");

        var caseList = [];
        // caseList = caseListOrg;
        var sprireOrORSCases =[];
        if(isSpireOnlyCases){
            for (let i = 0; i < caseListOrg.length; i++) {
                const element = caseListOrg[i];
                if (element.isSprireCase != undefined && element.isSprireCase == true) {
                    sprireOrORSCases.push(element);
                }
            }
        }else{
            sprireOrORSCases = caseListOrg;
        }

        if (isMember && onlyIndividual) {
            for (let i = 0; i < sprireOrORSCases.length; i++) {
                const element = sprireOrORSCases[i];
                if (element.xRefIdORS == undefined) {
                    caseList.push(element);
                } else if (element.xRefIdORS != undefined && element.xRefIdORS == xRefIdORS.toUpperCase()) {
                    caseList.push(element);
                }

            }
        } else {
            caseList = sprireOrORSCases;
        }

        if (!hasProviderOnly && !hasSixMonths) {
            return caseList;
        }

        /*if (!hasProviderOnly && !isLastSixtyDaysOnly && !isMember) {
            return caseList;
        }*/

        var filteredData = [];
        for (let index = 0; index < caseList.length; index++) {
            const element = caseList[index];
            if (hasProviderOnly && hasSixMonths) {
                if (element.isProvider && element.isSixMonths) {
                    filteredData.push(element);
                }
                continue;
            } else if (hasProviderOnly && !hasSixMonths) {
                if (element.isProvider) {
                    filteredData.push(element);
                }
                continue;
            } else if (!hasProviderOnly && hasSixMonths) {
                if (element.isSixMonths) {
                    filteredData.push(element);
                }
                continue;
            }
        }


        return filteredData;
    },

    addRemoveFilters: function (cmp, event, helper) {
        var comibinedCaseHistory = cmp.get("v.allUnfilteredData");

        var filteredData = this.filterAllData(cmp, event, helper, comibinedCaseHistory);
        comibinedCaseHistory = filteredData;

        cmp.set("v.allData", comibinedCaseHistory);
        cmp.set("v.originalData", comibinedCaseHistory);
        cmp.set("v.selectedTabsoft", 'CaseNumber');
        //DE318080 - Avish
        //cmp.set("v.totalPages", Math.ceil(comibinedCaseHistory.length/cmp.get("v.pageSize")));
        if (Math.ceil(comibinedCaseHistory.length / cmp.get("v.pageSize")) == 0) {
            cmp.set("v.totalPages", 1);
        } else {
            cmp.set("v.totalPages", Math.ceil(comibinedCaseHistory.length / cmp.get("v.pageSize")));
        }
        //DE318080 - Ends
        cmp.set("v.currentPageNumber", 1);
        cmp.set("v.sortDirection", "desc");
        cmp.set("v.sortBy", "CaseNumber");
        this.buildData(cmp, helper);
        this.hideCaseSpinner(cmp);

        cmp.get("v.arrowDirection", 'arrowdown');
    },

    getMemberCaseHistory: function (cmp,memberId,xRefId,helper){
        var action = cmp.get("c.getRelatedCasesHistory");
        action.setParams({
            "taxMemberID": memberId,
            "xRefIdIndividual": xRefId,
            "toggleOnOff": false,
            "flowType": cmp.get("v.flowType")
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state == 'SUCCESS') {
                
                this.hideCaseSpinner(cmp);
                cmp.set("v.isServiceCalled",true);
                var caselst = [];
                
                caselst = response.getReturnValue();
                cmp.set("v.caseHistoryList", caselst);
                cmp.set("v.lastsixchecked", true);
                //US2815284
                if (cmp.get("v.enableMemberFilter") && !cmp.get("v.isProvider")) {
                    cmp.set("v.providerChecked", false);
                    cmp.set("v.enableMemberFilter", false);
                } else {
                cmp.set("v.providerChecked", true);
                }
                cmp.set("v.isIndividual", true);
                this.showResults(cmp, event, helper, cmp.get("v.memberTabId"));
                
            }else {
                this.hideCaseSpinner(cmp);
            }
        });
        $A.enqueueAction(action);
    },

    addORselectIssues: function (cmp, event, helper) {
            var comibinedCaseHistory = [];
            var caseHistoryList = cmp.get("v.allUnfilteredData");
            comibinedCaseHistory = caseHistoryList;
            var orsSelectIssues = cmp.get("v.orsSelectIssues");
        var lstFacetCases = cmp.get("v.lstFacetCases");
            var totalExistingpage = cmp.get("v.totalPages");

            var caseHistoryMap = new Map();
            var dupCheck = new Map();

            for (var j of caseHistoryList) {

                if(j.ID.indexOf(',') > -1){
                    var str = j.ID.split(',');
                    for(var m=0; m<str.length;m++){
                        dupCheck.set(str[m], j);
                    }
                }
                else{
                    dupCheck.set(j.ID,j);
                }
                caseHistoryMap.set(j.ID, j);
            }
            for (var i of orsSelectIssues) {
                if(!dupCheck.has(i.ID)) {
                comibinedCaseHistory.push(i);
            }
        }
        // FACETS Dup Check
        for (var i of lstFacetCases) {

            if(!dupCheck.has(i.ID)) {

                    comibinedCaseHistory.push(i);
                }
            }
            cmp.set("v.allUnfilteredData", comibinedCaseHistory);
            
            var filteredData = helper.filterAllData(cmp, event, helper, comibinedCaseHistory);
            comibinedCaseHistory = filteredData;

            cmp.set("v.allData", comibinedCaseHistory);
            cmp.set("v.originalData", comibinedCaseHistory);
            cmp.set("v.selectedTabsoft", 'CaseNumber');
            if (Math.ceil(comibinedCaseHistory.length / cmp.get("v.pageSize")) == 0) {
                cmp.set("v.totalPages", 1);
            } else {
                cmp.set("v.totalPages", Math.ceil(comibinedCaseHistory.length / cmp.get("v.pageSize")));
            }
        //if(cmp.get("v.isProvider")){
            //if(!cmp.get("v.isORSCalled")){
               /* cmp.set("v.currentPageNumber", 1);
                    cmp.set("v.sortDirection", "desc");
                    cmp.set("v.sortBy", "CreatedDate");
                    helper.buildData(cmp, helper);
        		//var selectedTabsoft = cmp.get("v.selectedTabsoft");
        		var arrowDirection = cmp.get("v.arrowDirection");
        		helper.sortData(cmp,"CreatedDate",arrowDirection);*/

        	cmp.set("v.selectedTabsoft", 'CreatedDate');
            if (Math.ceil(comibinedCaseHistory.length / cmp.get("v.pageSize")) == 0) {
                cmp.set("v.totalPages", 1);
            } else {
                cmp.set("v.totalPages", Math.ceil(comibinedCaseHistory.length / cmp.get("v.pageSize")));
            }
            cmp.set("v.currentPageNumber", 1);
            cmp.set("v.sortDirection", "desc");
            cmp.set("v.sortBy", "CreatedDate");

        var arrowDirection = cmp.get("v.arrowDirection");
        helper.sortAllData(cmp,"CreatedDate","arrowUp");

        this.buildData(cmp, helper);

            /*}else{
                    cmp.set("v.currentPageNumber", totalExistingpage);
                    cmp.set("v.sortDirection", "desc");
                    cmp.set("v.sortBy", "CaseNumber");
                    helper.processPages(cmp, helper);
            }*/
       /* }else{
            cmp.set("v.currentPageNumber", 1);
            cmp.set("v.sortDirection", "desc");
            cmp.set("v.sortBy", "CaseNumber");
            helper.buildData(cmp, helper);
        }*/


            if(!cmp.get("v.isORSCalled")){
                cmp.set("v.isORSCalled",true);
            }

        //cmp.set("v.paginationBtnDisable",false);
            helper.hideCaseSpinner(cmp);
        },

        processPages : function(component, helper) {
            var pageNumber = component.get("v.currentPageNumber");
            var pageSize = component.get("v.pageSize");
            var x = (pageNumber-1)*pageSize;
            component.set("v.currentStartNumber", parseInt(x) + 1);
            component.set("v.currentEndNumber", parseInt(x) + parseInt(pageSize));
            console.log(component.get("v.currentStartNumber"));
            helper.buildData(component, helper);
            var selectedTabsoft = component.get("v.selectedTabsoft");
            var arrowDirection = component.get("v.arrowDirection");
            helper.sortData(component,selectedTabsoft,arrowDirection);
        },

    sortAllData : function(component,fieldName,sortDirection) {
        var data = component.get("v.allData");

        var key = function(a) { return a[fieldName]; }
        if(sortDirection == 'arrowdown') {
            component.set("v.arrowDirection", 'arrowup');
        }else{
            component.set("v.arrowDirection", 'arrowdown');
        }
        sortDirection = component.get("v.arrowDirection");
        var reverse = sortDirection == 'arrowup' ? 1: -1;
        if (fieldName == 'CaseNumber' || fieldName == 'ID') {
            data.sort(function(a,b){
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a>b) - (b>a));
            });
        } else if(fieldName == 'CreatedDate'){
            data.sort(function(a,b){
                var dateA = new Date(key(a)).getTime();
                var dateB = new Date(key(b)).getTime();
                return reverse * (dateA > dateB ? 1 : -1);
            });
        }else{
            data.sort(function(a,b){
                var a = key(a) ? key(a).toLowerCase() : '';
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a>b) - (b>a));
            });
        }
        component.set("v.allData",data);

    },
    // US3177995 - Thanish - 22nd Jun 2021
    getPurgedORSRecords: function(cmp){
        this.showCaseSpinner(cmp);
        var action = cmp.get("c.getPurgedORSRecords");
        action.setParams({
            "searchId": cmp.get("v.subjectCard.EEID")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state=='SUCCESS') {
                var result = response.getReturnValue();
                var data = cmp.get("v.data");
                var allData = cmp.get("v.allData");
                // var allUnfilteredData = cmp.get("v.allUnfilteredData");
                var concatData = data.concat(result.response);
                var concatAllData = allData.concat(result.response);
                // var concatAllUnfilteredData = allUnfilteredData.concat(result.response);

                cmp.set("v.data", concatData);
                cmp.set("v.allData", concatAllData);
                // cmp.set("v.allUnfilteredData", allUnfilteredData);
                cmp.set("v.currentEndNumber", concatData.length);
            } else if(state=='ERROR') {
            }
            this.hideCaseSpinner(cmp);
        });
        $A.enqueueAction(action);
    },

    removePurgedORSRecords: function(cmp){
        this.showCaseSpinner(cmp);
        var data = cmp.get("v.data");
        var allData = cmp.get("v.allData");
        // var allUnfilteredData = cmp.get("v.allUnfilteredData");
        if(!$A.util.isEmpty(data)){
            var filtered = data.filter(record => record.IDType != 'Purged ORS');
            cmp.set("v.data", filtered);
            cmp.set("v.currentEndNumber", filtered.length);
        }
        if(!$A.util.isEmpty(allData)){
            cmp.set("v.allData", allData.filter(record => record.IDType != 'Purged ORS'));
        }
        // if(!$A.util.isEmpty(allUnfilteredData)){
        //     cmp.set("v.allUnfilteredData", allUnfilteredData.filter(record => record.IDType != 'Purged ORS'));
        // }
        this.hideCaseSpinner(cmp);
    }
})