({
    getTopics : function(cmp)
    {
        var action=cmp.get("c.getTopics");
        action.setCallback(this, function (response) {
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('checking'+result);
            var data = [];
            if (state == "SUCCESS") {
                data.push('--None--');
                for(var i=0;i<result.length;i++)
                {
                    data.push(result[i]);
                }
                cmp.set("v.topicOptions", data);
            }
            
        });
        $A.enqueueAction(action);
        
    },
    getData : function(cmp) {
        debugger;
        var errorMsg = 'Unexpected error occurred on Work Queue. Please try again. If problem persists please contact the help desk. ';

        var action = cmp.get("c.callSelectWorkLoadService");
    
        var spinner = cmp.find('srncspinner');
        $A.util.removeClass(spinner,'slds-hide');
        $A.util.addClass(spinner, 'slds-show');
        action.setCallback(this, function (response) {
            debugger;
            cmp.set("v.searchParam","");
            var state = response.getState();
            var result = response.getReturnValue();
            //result = JSON.parse(result);
            console.log('checking'+result);
            var data = [];
            if (state == "SUCCESS") {
                if(!$A.util.isUndefinedOrNull(result) && !$A.util.isEmpty(result) && !$A.util.isUndefinedOrNull(result.statusCode) && !$A.util.isEmpty(result.statusCode) && result.statusCode == 200) {
                    for(var i=0;i<result.response.workList.length;i++)//result.response.workList.length
                    {/*
                        if(i==95)
                        {
                            result.response.workList[0].serviceRequestOwner.originalDate='2019-06-10';
                            //this.convertMilitaryDate(result.response.workList[0].serviceRequestOwner.originalDate,'dt')
                        }
                        if(i==96)
                        {
                            result.response.workList[0].serviceRequestOwner.originalDate='2019-07-24';
                            //this.convertMilitaryDate(result.response.workList[0].serviceRequestOwner.originalDate,'dt')
                        }
                        if(i==97)
                        {
                            result.response.workList[0].serviceRequestOwner.originalDate='2019-07-30';
                            //this.convertMilitaryDate(result.response.workList[0].serviceRequestOwner.originalDate,'dt')
                        }
                        if(i==98)
                        {
                            result.response.workList[0].serviceRequestOwner.originalDate='2020-08-30';
                            //this.convertMilitaryDate(result.response.workList[0].serviceRequestOwner.originalDate,'dt')
                        }
                         if(i==99)
                        {
                            result.response.workList[0].serviceRequestOwner.originalDate='2021-08-30';
                            //this.convertMilitaryDate(result.response.workList[0].serviceRequestOwner.originalDate,'dt')
                        }*/
                        //data.push(new workItem('ORS', 'DA2192736455','2020-08-30'));
                        data.push(new workItem('ORS', result.response.workList[i].serviceRequestOwner.issueId,result.response.workList[i].serviceRequestOwner.originalDate));
                    }
                    var sortData=this.sortAllData(cmp,'created','Accending',data);
                     for(var i=0;i<sortData.length;i++)
                     {
                         sortData[i].created=this.convertMilitaryDate(sortData[i].created,'dt');
                     }
                     cmp.set("v.fullData", sortData);
                    cmp.set("v.data", sortData);//data);
                    $A.util.removeClass(spinner,'slds-show');
                    $A.util.addClass(spinner, 'slds-hide');
                    function workItem(c, dc, sc) {
                        this.type = c;
                        this.extId = dc;
                        this.created = sc;
                    }
                } else {
                    $A.util.removeClass(spinner,'slds-show');
                    $A.util.addClass(spinner, 'slds-hide');
                    this.fireToastMessage("We hit a snag.", errorMsg, "error", "dismissible", "6000");
                }
            } else {
                $A.util.removeClass(spinner,'slds-show');
                $A.util.addClass(spinner, 'slds-hide');
             	this.fireToastMessage("We hit a snag.", errorMsg, "error", "dismissible", "6000");   
            }
            
        });
        $A.enqueueAction(action);
    },
    convertMilitaryDate: function (dateParam, type) {
        let format = "";
        if (type == 'dt') {
            format = 'MM/dd/yyyy';
        } else if (type == 'dttm') {
            format = 'MM/dd/yyyy hh:mm:ss a';
        }
        let returnDate = '';
        if (!$A.util.isUndefinedOrNull(dateParam)) {
            try {
                if (type == 'dt') {
                    var dttm = dateParam;
                    if (!$A.util.isUndefinedOrNull(dateParam.split('-')[3])) {
                        var arr = dateParam.split('-');
                        dttm = arr[0] + '-' + arr[1] + '-' + arr[2];
                    }
                    returnDate = $A.localizationService.formatDateUTC(dttm, format);
                } else if (type == 'dttm') {
                    var arr = dateParam.split('-');
                    var dttm = arr[0] + '-' + arr[1] + '-' + arr[2];
                    returnDate = $A.localizationService.formatDateTimeUTC(dttm, format);
                }
            } catch (error) { }
        }
        return returnDate;
    },
    getORSMetaDataRecords: function(cmp, event, helper) {
        var action = cmp.get("c.getRoutingData");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var orsMetaData = response.getReturnValue();
                cmp.set("v.orsMap", orsMetaData.orsMap);
            }
        });
        $A.enqueueAction(action);
    },
   
	fireToastMessage: function (title, message, type, mode, duration) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			"title": title,
			"message": message,
			"type": type,
			"mode": mode,
			"duration": duration
		});
		toastEvent.fire();
	},
    sortAllData : function(cmp,fieldName,sortDirection,data) {
        //var data = //component.get("v.allData");
        var key = function(a) { return a[fieldName]; }
        var reverse = sortDirection == 'Accending' ? 1: -1;
        if (fieldName == 'CaseNumber' || fieldName == 'ID') {
            data.sort(function(a,b){
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a>b) - (b>a));
            });
        } else if(fieldName == 'created'){
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
        return data;//component.set("v.allData",data);
    },
    resetData: function(cmp, event, helper) {
        var sendToListInputs = {
            "advocateRole": "Select",
            "teamQuickList": "",
            "office": "Select",
            "department": "Select",
            "team": "Select",
            "individual": "",
            "state": "Select",
            'issue': "Select",
            "city": "",
            "phoneNumber": "",
            "comments": "",
            "officeAPI": "",
            "departmentAPI": "",
            "teamAPI": "",
            "memberName": "",
            "memberId": "",
            "memberDOB": "",
            "providerName": "",
            "NPI": "",
            "MPIN": "",
            "TIN": "",
            "escalationReason": "Select"

        };
        cmp.set("v.sendToListInputs", sendToListInputs);
        
        cmp.set('v.wqTopic',  '--None--');
        cmp.set('v.wqType',  '--None--');
        cmp.set('v.wqSubtype', '--None--');
        cmp.set('v.selectedSendValue', 'teamList');
        cmp.set('v.routeOrCloseCase', '');
        cmp.set('v.IsDelegatedSpeciality',false);
    },
    callUpdateORSService : function(cmp,commentText,helper) {
        debugger;
        
        var errorMsg = 'Unexpected error occurred on Work Queue. Please try again. If problem persists please contact the help desk. ';

        let sendToListInputs = cmp.get('v.sendToListInputs');

        let orsRequestDetails = {
            routeOrClose: cmp.get('v.routeOrCloseCase'),
            issueId: cmp.get('v.selectedExtId'),
            comment: commentText,
            officeId: sendToListInputs.officeAPI,
            departmentCode: sendToListInputs.departmentAPI,
            teamCode: sendToListInputs.teamAPI
        };

        var action = cmp.get("c.updateORSRecord");
        action.setParams({
            orsRequestDetails: orsRequestDetails
        });
        var spinner = cmp.find('sendToSpinner');
        $A.util.removeClass(spinner,'slds-hide');
        $A.util.addClass(spinner, 'slds-show');

        action.setCallback(this, function (response) {
            var state = response.getState();
            var result = response.getReturnValue();
            console.log('HHHHHHH::::   ' + JSON.stringify(result));
            $A.util.removeClass(spinner,'slds-show');
            $A.util.addClass(spinner, 'slds-hide');
            if (state == "SUCCESS") {
                if(!$A.util.isUndefinedOrNull(result) && !$A.util.isEmpty(result) && !$A.util.isUndefinedOrNull(result.statusCode) && !$A.util.isEmpty(result.statusCode) && result.statusCode == 201) {
                    helper.getData(cmp);
                } else {
                    this.fireToastMessage("We hit a snag.", errorMsg, "error", "dismissible", "6000");
                }
            }
            else {
                this.fireToastMessage("We hit a snag.", errorMsg, "error", "dismissible", "6000");
            }
            cmp.set('v.isShow',false);
            cmp.set('v.isShowSend',false);
            helper.resetData(cmp);
            
        });
        $A.enqueueAction(action);
    },
})