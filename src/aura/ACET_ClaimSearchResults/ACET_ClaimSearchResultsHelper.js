({
    // US3305963 - Thanish - 18th Mar 2021
    claimSearchErrorMessage: "Unexpected Error Occurred with Claim Search. Please try again. If problem persists please contact the help desk",
    claimAdvSearErrMsg: "Unexpected Error Occurred with Advanced Search. Please try again. If problem persists please contact the help desk",
    advNoResultWarnMsg: "No Results Found for Advanced Search Criteria",

	showSpinner: function (cmp) {
        var spinner = cmp.find("lookup-spinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },

    hideSpinner: function (cmp) {
        var spinner = cmp.find("lookup-spinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },

    getAdVanceReq: function(cmp,event,helper){
         let memberInfo = {
            "memberId": "--",
            "memberPlan": '--',
            "memberName": "--",
            "relationshipType": "--",
            "relationshipCode": "--",
            "sourceCode":"--",
            "EEID" : "--",
            "firstServiceDate": "--",
            "lastServiceDate": "--"

        }
        let memberCardData = cmp.get('v.memberCardData');
        let policyDetails = cmp.get('v.policyDetails');
        let policySelectedIndex = cmp.get('v.policySelectedIndex');
        if (!$A.util.isUndefinedOrNull(memberCardData) && !$A.util.isUndefinedOrNull(memberCardData.CoverageLines) && memberCardData.CoverageLines.length > 0) {
            if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].GroupNumber)) {
                memberInfo.memberPlan = memberCardData.CoverageLines[policySelectedIndex].GroupNumber;
            }
            if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].eligibleDates)) {
                var datesArray  = memberCardData.CoverageLines[policySelectedIndex].eligibleDates.split("-");
                var startDate = datesArray[0].trim().split('/');
                var endDate = datesArray[1].trim().split('/');
                memberInfo.firstServiceDate = startDate[2] + '-' + startDate[0] + '-' + startDate[1];
                memberInfo.lastServiceDate = endDate[2] + '-' + endDate[0] + '-' + endDate[1];
            }

            if (!$A.util.isUndefinedOrNull(memberCardData.CoverageLines[policySelectedIndex].patientInfo)) {
                let patientInfo = memberCardData.CoverageLines[policySelectedIndex].patientInfo;
                if (!$A.util.isUndefinedOrNull(patientInfo.MemberId)) {
                    memberInfo.memberId = patientInfo.MemberId;
                }
                if (!$A.util.isUndefinedOrNull(patientInfo.fullName)) {
                    memberInfo.memberName = patientInfo.fullName;
                }
                if (!$A.util.isUndefinedOrNull(patientInfo.relationship)) {
                    memberInfo.relationshipType = patientInfo.relationship;
                }
            }
        }
        if ( !$A.util.isUndefinedOrNull(policyDetails) && !$A.util.isUndefinedOrNull(policyDetails.resultWrapper)
            && !$A.util.isUndefinedOrNull(policyDetails.resultWrapper.policyRes) ){
            var sourceCode = policyDetails.resultWrapper.policyRes.sourceCode;
            var EEID = policyDetails.resultWrapper.policyRes.EEID;
            var relCode = policyDetails.resultWrapper.policyRes.relationshipCode;
            if(!$A.util.isUndefinedOrNull(sourceCode) && !$A.util.isEmpty(sourceCode) ){
                 memberInfo.sourceCode = sourceCode;
            }
           if(!$A.util.isUndefinedOrNull(EEID) && !$A.util.isEmpty(EEID) ){
                 memberInfo.EEID = EEID;
            }
             if(!$A.util.isUndefinedOrNull(relCode) && !$A.util.isEmpty(relCode) ){
                 memberInfo.relationshipCode = relCode;
            }
        }

        var memInfo = memberInfo;
        if( !$A.util.isUndefinedOrNull(memInfo) && (memInfo.EEID != '--' || memInfo.memberId != '--') &&
           memInfo.memberPlan != '--' && memInfo.memberName != '--' && memInfo.relationshipCode != '--' &&
           memInfo.sourceCode == 'CS' && memInfo.firstServiceDate != '--' &&  memInfo.lastServiceDate != '--'){
            var namelist  =  memInfo.memberName.split(" ");
            var fistName = namelist[0];
            var EEID = '';
            if(memInfo.EEID == '--'){
                if(memInfo.memberId != '--'){
                    EEID = memInfo.memberId;
                }
                else{
                    console.log('==@@EEID and MemberId not found:'+JSON.stringify(memInfo));
                    return;
                }
            }
            else{
                EEID = memInfo.EEID;
                if(EEID.length >= 9){
                    EEID = EEID.slice(-9);
                }
                EEID = 'S'+EEID;
            }
            var inpRequest = {
                "memberId": EEID,
                "policy": memInfo.memberPlan,
                "firstName":  fistName,
                "relationship": memInfo.relationshipCode,
                "securityToken":"",
                "firstServiceDate":  memInfo.firstServiceDate,
                "lastServiceDate":  memInfo.lastServiceDate,
                "authorizationNumber": "",
                "claimLevelCauseCode": "",
                "cptCodeFrom": "",
                "cptCodeThru":"",
                "remarkCode":"",
                "revenueCodeFrom":"",
                "revenueCodeThru":"",
                "appliedToOopInd":""
            };
            console.log('=@#inpRequest'+JSON.stringify(inpRequest));
            console.log('=@#advancecliam2'+JSON.stringify(cmp.get('v.advClaimInput')));
            var advClaimInput = cmp.get('v.advClaimInput');
            if(advClaimInput.selectedFilter == 'Applied to OOP'){
                inpRequest.appliedToOopInd = 'Y';
            }
            else if(advClaimInput.selectedFilter == 'Authorization #' ){
                inpRequest.authorizationNumber = advClaimInput.inpValue;
            }

            else if(advClaimInput.selectedFilter == 'CPT/HCPC Code'){
                inpRequest.cptCodeFrom = advClaimInput.inpValue;
                inpRequest.cptCodeThru = advClaimInput.inpValue;
            }
            else if(advClaimInput.selectedFilter == 'Remark Code'){
                inpRequest.remarkCode = advClaimInput.inpValue;
            }

            else if(advClaimInput.selectedFilter == 'Revenue Code'){
                inpRequest.revenueCodeFrom = advClaimInput.inpValue;
                inpRequest.revenueCodeThru = advClaimInput.inpValue;
            }

            else if(advClaimInput.selectedFilter == 'Claim Level Cause Code'){
                var inpValue = advClaimInput.inpValue;
                inpRequest.claimLevelCauseCode = inpValue.split('-')[0].trim();
            }

            else if(advClaimInput.selectedFilter == 'Code Range'){
                var inpValue = advClaimInput.inpValue;
                inpRequest.cptCodeFrom =  inpValue.split('-')[0].trim();
                inpRequest.cptCodeThru = inpValue.split('-')[1].trim().split(' ')[0].trim();
            }
            console.log('=@#inpRequest'+JSON.stringify(inpRequest));
            helper.getUNETInfo(cmp,event,helper,inpRequest);

        }
        else{
            console.log('==Required fields are missing'+JSON.stringify(memInfo));
        }
    },

    getUNETInfo : function(cmp,event,helper,inpRequest){
        helper.showSpinner(cmp);
        cmp.set("v.advClaimNumbers",[]);
        var action = cmp.get("c.getUNETResult");
        action.setParams({
            "input": inpRequest
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                if (result.isSuccess) {
                    if (result.statusCode == 200) {
                        console.log(JSON.parse(JSON.stringify(result.response)));
                        console.log('===response'+JSON.stringify(response.getReturnValue()));
                        cmp.set("v.advClaimNumbers",result.response);
                        if(!$A.util.isEmpty(result.response)){
                            helper.highlightadvData(cmp,event,helper);
                        }
                        else{
                            helper.showToastMessage("Warning!", this.advNoResultWarnMsg, "warning", "dismissible", "30000");
                        }

                    }
                    else{

                        helper.showToastMessage("We hit a snag.", this.claimAdvSearErrMsg, "error", "dismissible", "30000");
                    }
                }
                else{

                    helper.showToastMessage("We hit a snag.", this.claimAdvSearErrMsg, "error", "dismissible", "30000");
                }
            }
            else{

                helper.showToastMessage("We hit a snag.", this.claimAdvSearErrMsg, "error", "dismissible", "30000");
            }
            helper.hideSpinner(cmp);
        });
        $A.enqueueAction(action);

    },

    getDeductibleInfo: function(cmp,event,helper){
        helper.showSpinner(cmp);
        let memberNotInFocus=false;
        var action = cmp.get('c.getClaimsAutodoc');
        var isDeductible = cmp.get("v.isDeductible");
        var isApplied =  cmp.get("v.isApplied");
        console.log('isDeductible '+ isDeductible+ ' isApplied '+ isApplied);
        console.log('passing to apex from helper of claimSearchResult : claimInput >>> ' + JSON.stringify( cmp.get("v.claimInput")))
        var claimInput = cmp.get("v.claimInput");
        claimInput.FromDate = $A.localizationService.formatDate(claimInput.FromDate, "MM/dd/yyyy");
        claimInput.ToDate = $A.localizationService.formatDate(claimInput.ToDate, "MM/dd/yyyy");
         var totaldays = (new Date(claimInput.ToDate) - new Date(claimInput.FromDate))/(1000*60*60*24);
        if(Math.round(totaldays) >= 90){
            cmp.set("v.isMoreThan90days", true);
        }
        console.log("the claim input fromDate :"+claimInput.FromDate);
        console.log("the claim input toDate :"+claimInput.ToDate);
        action.setParams({
            "claimInputs":claimInput,
            "isDeductible":isDeductible,
            "isApplied":isApplied,
            "start": cmp.get("v.pageNumber"),
            "isMoreThan90days" : cmp.get("v.isMoreThan90days")
        });

        action.setCallback(this, function(response) {
            var state = response.getState(); // get the response state
            console.log('state@@@' + state);
            var result = response.getReturnValue();
            console.log('response from service is>>> ' + JSON.stringify(result));
                if ( state == 'SUCCESS' && result.statusCode == 200) {

                   /* if(!$A.util.isUndefinedOrNull(claimInput.claimNumber) && !$A.util.isEmpty(claimInput.claimNumber)){
                        if(!$A.util.isUndefinedOrNull(result.memberInfo) && !$A.util.isEmpty(result.memberInfo)){
                            var memberId = result.memberInfo[0].sbmtMembrId;
                            var memberCardData = cmp.get("v.memberInfo");
                            if(memberCardData.MemberId != memberId){
                                cmp.set("v.showWarning",true);
                                 memberNotInFocus=true;

                             }

                        }
                    }*/

                        if(!memberNotInFocus){
                            var end = result.claimSearchResult.tableBody.length;
                            var advClaimNumbers = [];
                            for(var x in result.claimSearchResult){
                            var t=result.claimSearchResult[x];
                            if(x=='tableBody'){
                                for(var i=0; i<end;i++){
                                    advClaimNumbers.push(result.claimSearchResult.tableBody[i].rowColumnData[0].fieldValue);
                                        }
                                }
                    		}
                            if(!$A.util.isEmpty(advClaimNumbers)){
                                cmp.set('v.advClaimNumbers',advClaimNumbers);
                                helper.highlightadvData(cmp,event,helper);
                            }
                            else{
                                helper.showToastMessage("Warning!", this.advNoResultWarnMsg, "warning", "dismissible", "30000");
                            }
						}


                }
                else{
                    this.showToastMessage("We hit a snag.", this.claimAdvSearErrMsg, "error", "dismissible", "30000");
                }
                helper.hideSpinner(cmp);
            });
            $A.enqueueAction(action);

    },

    highlightadvData: function(cmp,event,helper){
        console.log('==advClaimNumbers'+JSON.stringify(cmp.get('v.advClaimNumbers')));
        //Removing Duplicates
        var advClaimlist1 = cmp.get('v.advClaimNumbers');
        var advClaimlist = advClaimlist1.filter((c, index) => {
            return advClaimlist1.indexOf(c) === index;
        });
        console.log('==advClaimNumbers2'+JSON.stringify(advClaimlist));

        var tableDetails = cmp.get("v.autodocClaimResult");
            var newBody = [];
            var tbody = tableDetails.tableBody;

            var tableDetails2 = cmp.get("v.paginationClaimResult");
            var tbody2 = tableDetails2.tableBody;
            if ( !$A.util.isEmpty(advClaimlist) &&  !$A.util.isEmpty(tbody2) ) { //&&  (tbody2[0].rowColumnData[4].fieldValue != "No Records Found")
                var resp = helper.gethighlightbody(cmp,event,helper,tbody2,advClaimlist);
                console.log('==newBodyResp'+JSON.stringify(resp));
                if( !$A.util.isEmpty(resp)){
                    if( !$A.util.isEmpty(resp.newBody)){
                        tableDetails2.tableBody = resp.newBody;
                        cmp.set("v.paginationClaimResult", tableDetails2);

                        var pageNum = 1;
                        cmp.set("v.pageNumber",1);
                        var result = tableDetails2;

                        var startnumber = ((pageNum-1)*100)>0?((pageNum-1)*100):0;
                        var EndNumber = (result.tableBody.length-startnumber)>100?startnumber+100:result.tableBody.length;
                        var tempresult = {};


                        for (var x in result) {
                            var t=result[x];
                            tempresult[x] = t;
                            if(x=='tableBody'){
                                var temparray = [];
                                for(var i=startnumber; i<EndNumber;i++){
                                    temparray.push(result.tableBody[i]);
                                }
                                tempresult.tableBody = temparray;
                                //tempresult.startNumber=startnumber+1;
                                //tempresult.endNumber=EndNumber;
                            }
                        }


                        var extProviderTable = _autodoc.getAutodocComponent(cmp.get("v.autodocUniqueId"),cmp.get("v.policySelectedIndex"),'Claim Results');
                        let prevSelectedClaimRows = [];
                        if(extProviderTable !=null && extProviderTable.selectedRows!=null && extProviderTable.selectedRows.length>0){
                            for(var i in extProviderTable.selectedRows){
                                prevSelectedClaimRows.push(extProviderTable.selectedRows[i]);
                            }
                        // DE477169
                        if (extProviderTable.hasUnresolved) {
                            cmp.set("v.disableButtons", false);
                        }
                            console.log('beforeprevSelectedClaimRows',prevSelectedClaimRows);
                        }
                        for(var z=0;z<tempresult.tableBody.length;z++){
                            prevSelectedClaimRows.push(tempresult.tableBody[z]);
                            }
                            tempresult.tableBody = prevSelectedClaimRows;

                            var filteredItems = tempresult.tableBody.reduce((pvd, current) => {
                                var found = pvd.find(item => item.caseItemsExtId === current.caseItemsExtId);
                                if (!found) {
                                return pvd.concat([current]);
                            } else {return pvd;}
                               }, []);

                               tempresult.tableBody = filteredItems;
					// US3507751 - Save Case Consolidation
					tempresult.callTopic = 'View Claims';

                            cmp.set("v.autodocClaimResult",tempresult);

                    }
                    else{
                        if(!$A.util.isEmpty(resp.advSearchNoMatch) && resp.advSearchNoMatch == true){
                            helper.showToastMessage("Warning!", this.advNoResultWarnMsg, "warning", "dismissible", "30000");
                            cmp.set("v.advSearchNoMatch",true);
                        }
                    }
                }
            }

    },

    gethighlightbody: function(cmp,event,helper,tbody,advClaimlist){
        var resp ={
            "newBody":"",
            "advSearchNoMatch": false
        };
        var newBody = [];
        resp.newBody = newBody;
        if ( !$A.util.isEmpty(advClaimlist) &&  !$A.util.isEmpty(tbody)) { // &&  (tbody[0].rowColumnData[0].fieldLabel != "NO RECORDS")
            var lstadvTbody = [];
                for (var index = 0; index < advClaimlist.length; index++) {
                    var advTbody = tbody.filter(function(row) {
                        return (row.rowColumnData[0].fieldValue == advClaimlist[index]);
                      });
                    if(!$A.util.isEmpty(advTbody)){
                        lstadvTbody.push(advTbody[0]);
                    }
                }
                console.log('==advBody'+JSON.stringify(lstadvTbody));
                if(!$A.util.isEmpty(lstadvTbody)){
                    var mapCheck = {};
                    for(var i = 0; i<lstadvTbody.length; i++){
                        lstadvTbody[i].rowColumnData[0].tdStyle = 'overflow: hidden;background-color: yellow';
                        mapCheck[lstadvTbody[i].rowColumnData[0].fieldValue] = lstadvTbody[i];
                        newBody.push(lstadvTbody[i]);
                    }

                    for(var x =0; x< tbody.length; x++){
                          if(!mapCheck.hasOwnProperty(tbody[x].rowColumnData[0].fieldValue)){
                            tbody[x].rowColumnData[0].tdStyle = 'overflow: hidden';
                            newBody.push(tbody[x]);
                        }
                    }
                    console.log('==newBody'+JSON.stringify(newBody));
                    resp.newBody = newBody;

                }
                else{
                    resp.advSearchNoMatch = true;
                }

        }
        return resp;
    },
    getClaimData: function (component, event, helper, offset){
        component.set("v.isCheckboxDisabled",false);
        component.set("v.showAdvanceSearch",false);
        let memberNotInFocus=false;
        var action = component.get('c.getClaimsAutodoc');
        //var payerId = '87726';
        var isDeductible = component.get("v.isDeductible");
        var isApplied =  component.get("v.isApplied");
        console.log('isDeductible '+ isDeductible+ ' isApplied '+ isApplied);
        console.log('passing to apex from helper of claimSearchResult : claimInput >>> ' + JSON.stringify( component.get("v.claimInput")))
        var claimInput = component.get("v.claimInput");
        claimInput.sourceCode =component.get("v.policyDetails").resultWrapper.policyRes.sourceCode;
        claimInput.FromDate = $A.localizationService.formatDate(claimInput.FromDate, "MM/dd/yyyy");
        claimInput.ToDate = $A.localizationService.formatDate(claimInput.ToDate, "MM/dd/yyyy");
        var totaldays = (new Date(claimInput.ToDate) - new Date(claimInput.FromDate))/(1000*60*60*24);
        if(Math.round(totaldays) >= 90){
            component.set("v.isMoreThan90days", true);
        }
        console.log("the claim input fromDate :"+claimInput.FromDate);
        console.log("the claim input toDate :"+claimInput.ToDate);
        action.setParams({
            "claimInputs":claimInput,
            "isDeductible":isDeductible,
            "isApplied":isApplied,
            "start": component.get("v.pageNumber"),
            "isMoreThan90days" : component.get("v.isMoreThan90days")
        });
        action.setCallback(this, function(response) {
			var caseNotSavedTopics = component.get("v.caseNotSavedTopics");
			if (!caseNotSavedTopics.includes("View Claims")) {
				caseNotSavedTopics.push("View Claims");
			}
			component.set("v.caseNotSavedTopics", caseNotSavedTopics);
            var state = response.getState(); // get the response state
            console.log('state@@@' + state);
            var result = response.getReturnValue();
            console.log('response from service is>>> ' + JSON.stringify(result));
            if(state == 'SUCCESS') {
                    var responseCount= component.get("v.responseCount");
            		responseCount++;
            		component.set("v.responseCount",responseCount);
                if (result.statusCode == 200) {
                console.log('response from service is>>> ' + JSON.stringify(result));



                    if(!$A.util.isUndefinedOrNull(claimInput.claimNumber) && !$A.util.isEmpty(claimInput.claimNumber)){
                        if(!$A.util.isUndefinedOrNull(result.memberInfo) && !$A.util.isEmpty(result.memberInfo)){
                            var memberDob = result.memberInfo[0].ptntDob;
                            var memberFullname = result.memberInfo[0].ptntFn+' '+result.memberInfo[0].ptntLn;
                            var memberFirstName = result.memberInfo[0].ptntFn;
                            var memberLastName = result.memberInfo[0].ptntLn;
                            var memberId = result.memberInfo[0].sbmtMembrId;
                            var policyNbr=result.memberInfo[0].policyNbr;

                            var serviceDates = result.claimSearchResult.tableBody[0].rowColumnData.
                            find( r=> r.fieldLabel == 'SERVICE DATES').fieldValue;
                            var eligibleDate = component.get("v.eligibleDate").split(" - ");
                            var higStartDate=$A.localizationService.formatDate(new Date(eligibleDate[0]),"yyyy-MM-dd");
                            var higEndDate=$A.localizationService.formatDate(new Date(eligibleDate[1]),"yyyy-MM-dd");
                            var claimServiceDates= serviceDates.split(" - ");
                            var startDate=$A.localizationService.formatDate(new Date(claimServiceDates[0]),"yyyy-MM-dd");
                            var endDate=$A.localizationService.formatDate(new Date(claimServiceDates[1]),"yyyy-MM-dd");
                            var claimNumber = result.claimSearchResult.tableBody[0].rowColumnData.
                            find( r=> r.fieldLabel == 'CLAIM #').fieldValue;
                            var memberCardData = component.get("v.memberInfo");
                            component.set("v.claimsMemberFullname",memberFullname);
                            component.set("v.claimsMemberFirstname",memberFirstName);
                            component.set("v.claimsMemberLastname",memberLastName);
                            component.set("v.claimsMemberDob",memberDob);
                            component.set("v.claimsMemberId", memberId);
                            component.set("v.claimsServiceDates", serviceDates);
                            component.set("v.claimspolicyNbr", policyNbr);

                           // if(memberCardData.MemberId != memberId){
                            if(memberCardData.fullName != memberFullname && memberCardData.dobVal != memberDob){
                               component.set("v.showWarning",true);
                                memberNotInFocus=true;

                            }
                            else if(!(startDate >= higStartDate && startDate <= higEndDate) && !(endDate >= higStartDate && endDate <= higEndDate))
                            {
                                var msg='The claim number '+claimNumber+' has service date(s) '+serviceDates+' that are beyond the Policy eligible dates. Highlight the appropriate policy and perform your claim search again. ';
                                component.set("v.showNewMessage",false);
                                component.set("v.isCheckboxDisabled",true);
                                result.claimSearchResult.tableBody[0].linkDisabled = true;
                                result.claimSearchResult.tableBody[0].checkBoxDisabled = true;
                                result.claimSearchResult.tableBody[0].isResolvedDisabled  = true;
                                this.showToastMessage("We hit a snag.",msg, "error", "dismissible", "30000");
                            }
                        }
                    }
                component.set("v.paginationClaimResult", result.claimSearchResult);
                    /*pagination start here*/

                    console.log('end++++++++++++',end);
                    var tmpresult = {};
                    tmpresult.tableBody = [];
                    tmpresult.tableHeaders = result.claimSearchResult.tableHeaders;
                    tmpresult.startNumber=1;
                	tmpresult.endNumber=0;
                    tmpresult.noOfPages=1;
                    tmpresult.recordCount=0;
                    if(!memberNotInFocus){
                         var end = (result.claimSearchResult.tableBody.length>100)?100:result.claimSearchResult.tableBody.length;
            		for(var x in result.claimSearchResult){
					var t=result.claimSearchResult[x];
                	tmpresult[x] = t;
                	if(x=='tableBody'){
                	var temparray = [];
                	for(var i=0; i<end;i++){
                    temparray.push(result.claimSearchResult.tableBody[i]);
                	}
                        if(temparray.length> 0 && component.get("v.highlightedPolicySourceCode") == "CS" ){
                            component.set("v.showAdvanceSearch",true);
                            component.set("v.enablePopup",!component.get("v.enablePopup"));
                        }
                	tmpresult.tableBody = temparray;
                	tmpresult.startNumber=temparray.length > 0 ? 1 : 0;
                	tmpresult.endNumber=end;
                    }
            }
                }
            console.log('tmpresult+++', tmpresult);
                    /*pagination end here*/
            var extProviderTable = _autodoc.getAutodocComponent(component.get("v.autodocUniqueId"),component.get("v.policySelectedIndex"),'Claim Results');
                    var preSelectCLiamList=[];
                    var preSelectMemberList=[];
                    var preSelectClaimStatusList=[];
                    let prevSelectedClaimRows = [];
            if( !$A.util.isEmpty(extProviderTable)  && !$A.util.isEmpty(extProviderTable.selectedRows))  {
                /*pagination test here -- Tilak Dont Delete thiscode
                if(!(result.claimSearchResult.tableBody)) {
                    result.claimSearchResult.tableBody = [];
                }
                prevSelectedClaimRows = extProviderTable.selectedRows;
                result.claimSearchResult.tableBody = prevSelectedClaimRows.concat(result.claimSearchResult.tableBody);
                component.set("v.selectedRows", prevSelectedClaimRows); -- Tilak end here */

                        // DE477169
                        if (extProviderTable.hasUnresolved) {
                            component.set("v.disableButtons", false);
                        }

                if(!(tmpresult.tableBody)) {
                    tmpresult.tableBody = [];
                }
                prevSelectedClaimRows = extProviderTable.selectedRows;
                var closedClaimDetails = component.get("v.closedClaimDetails");
                if(closedClaimDetails.length>0){
                    prevSelectedClaimRows.forEach(element => {
                        for(var i=0;i<closedClaimDetails.length;i++){
                        if (element.uniqueKey ==closedClaimDetails[i]){
                        element.linkDisabled = false;
                        closedClaimDetails.splice(i, 1);
                        break;
                    }}
                                                  });
                }
                var enabled = [];
                var disabled = [];
                prevSelectedClaimRows.forEach(element => {
                if (element.linkDisabled)
                disabled.push(element);
                else
                enabled.push(element);
                    });
                prevSelectedClaimRows= disabled.concat(enabled);
                component.set("v.selectedRows", prevSelectedClaimRows);
                for(var i=0;i<prevSelectedClaimRows.length;i++){
                    if (prevSelectedClaimRows[i].caseItemsExtId =="No Results Found")
                        prevSelectedClaimRows.splice(i, 1);
                }
                prevSelectedClaimRows.forEach(element => {
                    for(var i=0;i<tmpresult.tableBody.length;i++){
                    if (element.caseItemsExtId ==tmpresult.tableBody[i].caseItemsExtId){
                    tmpresult.tableBody.splice(i, 1);
                    break;
                }}
                                              });
                tmpresult.tableBody = prevSelectedClaimRows.concat(tmpresult.tableBody);
                var temparray1 = component.get("v.mapClaimSummaryDetails");
                let memberInfoDetails = component.get("v.memberInfoDetails");
                let arrClaimStatusDetails = component.get("v.listClaimStatusDetails");
                for(i in prevSelectedClaimRows){
					if(!$A.util.isUndefinedOrNull(temparray1) && !$A.util.isEmpty(temparray1)  && temparray1!="[]"){
                    preSelectCLiamList.push(temparray1.find(v => v.componentName.includes(prevSelectedClaimRows[i].rowColumnData[0].fieldValue)));
					}
                    if(!$A.util.isUndefinedOrNull(memberInfoDetails) && !$A.util.isEmpty(memberInfoDetails)  && memberInfoDetails!="[]"){
					preSelectMemberList.push(memberInfoDetails.find(v => v.claimno.includes(prevSelectedClaimRows[i].rowColumnData[0].fieldValue)));
					}
					if(!$A.util.isUndefinedOrNull(arrClaimStatusDetails) && !$A.util.isEmpty(arrClaimStatusDetails)  && arrClaimStatusDetails!="[]"){
                    preSelectClaimStatusList.push(arrClaimStatusDetails.find(v => v.componentName.includes(prevSelectedClaimRows[i].rowColumnData[0].fieldValue)));
					}
                }

            }


            if (prevSelectedClaimRows.length > 0) {
                debugger;
                /*tmpresult.endNumber=1 ;
                    tmpresult.noOfPages=1;
                    tmpresult.recordCount=prevSelectedClaimRows.length;*/
                                /*PAGINATION CODE - DONT DELETE THIS CODE
                var filteredItems = result.claimSearchResult.tableBody.reduce((pvd, current) => {
                    //unique ID caseItemsExtId
                    //var found = pvd.find(item => item.uniqueKey === current.uniqueKey);
                    var found = pvd.find(item => item.caseItemsExtId === current.caseItemsExtId);
                    if (!found) {
                    return pvd.concat([current]);
                } else {return pvd;}
                   }, []);
                result.claimSearchResult.tableBody = filteredItems; -- DONT DELETE THIS CODE*/
                tmpresult.recordCount=tmpresult.tableBody.length;
                var end = (tmpresult.tableBody.length>100)?100:tmpresult.tableBody.length;
                tmpresult.endNumber = end;
                tmpresult.noOfPages = Math.ceil(tmpresult.tableBody.length/100);
                console.log('tmpresult+++1', JSON.stringify(tmpresult));
            }
					//component.set("v.autodocClaimResult", result.claimSearchResult);
                    console.log('after set'+JSON.stringify(component.get("v.autodocClaimResult")));
                     if(!memberNotInFocus){
                    component.set("v.mapClaimSummaryDetails" ,result.claimSummayByClaim );
                    component.set("v.mapInOutPatientDetails" ,result.inOutPatientDetails );
                    component.set("v.mapClaimAdditionalInfo" ,result.claimAdditionalInfoByClaim );
                    //component.set("v.mapClaimproSummaryDetails" ,result.claimSummayByClaim );
                    component.set("v.listClaimStatusDetails" ,result.claimStatusByClaim );
                     }
                    component.set("v.memberInfoDetails" ,result.memberInfo );
                    if (preSelectCLiamList.length > 0) {
                        var cliamSummary = component.get("v.mapClaimSummaryDetails");
                        for(i in preSelectCLiamList){
                            cliamSummary.push(preSelectCLiamList[i]);
                        }
                        component.set("v.mapClaimSummaryDetails" ,cliamSummary);
                        //component.set("v.mapClaimproSummaryDetails" ,cliamSummary );
                    }
                    if(preSelectClaimStatusList.length > 0){
                        var cliamStatus = component.get("v.listClaimStatusDetails");
                        for(i in preSelectClaimStatusList){
                            cliamStatus.push(preSelectClaimStatusList[i]);
                        }
                        component.set("v.listClaimStatusDetails" ,cliamStatus);
                    }
                    if (preSelectMemberList.length > 0) {
                        var memberInfo = component.get("v.memberInfoDetails");
                        for(i in preSelectMemberList){
                            memberInfo.push(preSelectMemberList[i]);
                        }
                        component.set("v.memberInfoDetails" ,memberInfo);
                    }
                     //Added by Mani-12/22/2020
					// US3507751 - Save Case Consolidation
					tmpresult.callTopic = 'View Claims';

                    component.set("v.autodocClaimResult",tmpresult);

                }else{
                    if(result.showToastMessage == true){
                       this.showToastMessage("We hit a snag.", this.claimSearchErrorMessage, "error", "dismissible", "30000");// US3305963 - Thanish - 18th Mar 2021
					}
                   console.log('response from service is>>> ' + JSON.stringify(result));
                    /*pagination start here*/
                    var selRows=component.get("v.selectedRows");
                    for(var i=0;i<selRows.length;i++){
                        if (selRows[i].caseItemsExtId =="No Results Found")
                            selRows.splice(i, 1);
                    }
                    if(responseCount > 1){
                        var claimSearchResult = result.claimSearchResult ;

                        if( !$A.util.isUndefinedOrNull(claimSearchResult)){

                            if (!$A.util.isUndefinedOrNull(claimSearchResult.selectedRows) && !$A.util.isEmpty(claimSearchResult.selectedRows) &&
                                claimSearchResult.selectedRows[0].caseItemsExtId == "No Matching Claim Results Found"){

                               //update erorr message
                                claimSearchResult.selectedRows[0].caseItemsExtId = "No Additional Matching Claim Results Found" ;
                                claimSearchResult.tableBody[0].rowColumnData[4].fieldValue = "No Additional Matching Claim Results Found" ;
                                claimSearchResult.tableBody[0].caseItemsExtId = "No Additional Matching Claim Results Found" ;

                                //remove existing record wih error message
                                for(var i=0;i<selRows.length;i++){
                                    if (selRows[i].caseItemsExtId =="No Matching Claim Results Found" ||
                                     selRows[i].caseItemsExtId == "No Additional Matching Claim Results Found" ){
                                        selRows.splice(i, 1);
                                 }
                                }
                            }

                        }
                    }
                    component.set("v.paginationClaimResult", selRows);
                    var end = (selRows.length>100)?100:selRows.length;
                    console.log('end++++++++++++',end);
                    var selRws= result.claimSearchResult.tableBody.concat(selRows);
                     var tmpresult = {};
                    for(var x in result.claimSearchResult){
                        var t=result.claimSearchResult[x];
                        tmpresult[x] = t;
                        if(x=='tableBody'){
                            tmpresult.tableBody =selRws;
                            tmpresult.noOfPages=selRows.length > 0 ? Math.ceil(selRows.length/100):1;
                            tmpresult.selectedRows = selRws;
                            component.set("v.selectedRows",selRws);
                            tmpresult.startNumber=selRows.length > 0 ? 1 : 0;
                            tmpresult.endNumber=end;
                            tmpresult.recordCount=selRows.length;
                        }}
                    console.log('tmpresult+++', tmpresult);
					// US3507751 - Save Case Consolidation
					tmpresult.callTopic = 'View Claims';
                    /*pagination start*/
                     _autodoc.setAutodoc(component.get("v.autodocUniqueId"),component.get("v.policySelectedIndex"), tmpresult);
                    component.set("v.autodocClaimResult",tmpresult);

                    //component.set("v.autodocClaimResult", result.claimSearchResult);
                }
            }else if(state == 'ERROR'){
                this.showToastMessage("We hit a snag.", this.claimSearchErrorMessage, "error", "dismissible", "30000");
            }
            helper.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
	setDefaultAutodoc: function(cmp){
      var defaultAutoDocPolicy = _autodoc.getAutodocComponent(cmp.get("v.memberautodocUniqueId"),cmp.get("v.policySelectedIndex"),'Policies');
        var defaultAutoDocMember = _autodoc.getAutodocComponent(cmp.get("v.memberautodocUniqueId"),cmp.get("v.policySelectedIndex"),'Member Details');
        console.log('member'+JSON.stringify(defaultAutoDocMember));
        var memberAutodoc = new Object();
        memberAutodoc.type = 'card';
        memberAutodoc.componentName = "Member Details";
        memberAutodoc.autodocHeaderName = "Member Details";
        memberAutodoc.noOfColumns = "slds-size_6-of-12";
        memberAutodoc.componentOrder = 1; // DE477063 - Thanish - 13th Aug 2021
        var cardData = [];
        cardData = defaultAutoDocMember.cardData.filter(function(el){
            if(!$A.util.isEmpty(el.defaultChecked) && el.defaultChecked) {
                return el;
    }
        });
        memberAutodoc.cardData = cardData;
        memberAutodoc.ignoreAutodocWarningMsg = true;
        // DE456923 - Thanish - 30th Jun 2021
        var policyAutodoc = new Object();
        policyAutodoc.type = "table";
        policyAutodoc.autodocHeaderName = "Policies";
        policyAutodoc.componentName = "Policies";
        policyAutodoc.tableHeaders = ["GROUP #", "SOURCE", "PLAN", "TYPE", "PRODUCT", "COVERAGE LEVEL", "ELIGIBILITY DATES", "STATUS", "REF REQ", "PCP REQ", "RESOLVED"]; // // US2928520: Policies Card - updated with "TYPE"
        policyAutodoc.tableBody = defaultAutoDocPolicy.tableBody;
        policyAutodoc.selectedRows = defaultAutoDocPolicy.selectedRows;
        policyAutodoc.callTopic = 'View Member Eligibility';
        policyAutodoc.componentOrder = 0;
        policyAutodoc.ignoreAutodocWarningMsg = true;
        var autodocSubId = cmp.get("v.policySelectedIndex");
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), autodocSubId, policyAutodoc);
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), autodocSubId, memberAutodoc);

        // US3804847 - Krish - 26th August 2021
        var interactionCard = cmp.get("v.interactionCard");
        var providerFullName = '';
        var providerComponentName = '';
        if(!$A.util.isUndefinedOrNull(interactionCard) && !$A.util.isEmpty(interactionCard)){
            providerFullName = interactionCard.firstName + ' ' + interactionCard.lastName;
            providerComponentName = 'Provider: '+ ($A.util.isEmpty(providerFullName) ? "" : providerFullName);
        }
        var defaultAutoDocProvider = _autodoc.getAutodocComponent(cmp.get("v.memberautodocUniqueId"), cmp.get("v.policySelectedIndex"), providerComponentName);
        if(!$A.util.isUndefinedOrNull(defaultAutoDocProvider) && !$A.util.isEmpty(defaultAutoDocProvider)){
            defaultAutoDocProvider.componentOrder = 0.25;
            defaultAutoDocProvider.ignoreClearAutodoc = false;
            _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"), autodocSubId, defaultAutoDocProvider);
        }

    },

    // DE482674 - Thanish - 1st Sep 2021
    deleteDefaultAutodoc: function(cmp){
        _autodoc.deleteAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.policySelectedIndex"), "Policies");
        _autodoc.deleteAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.policySelectedIndex"), "Member Details");

        var interactionCard = cmp.get("v.interactionCard");
        var providerFullName = '';
        var providerComponentName = '';
        if(!$A.util.isUndefinedOrNull(interactionCard) && !$A.util.isEmpty(interactionCard)){
            providerFullName = interactionCard.firstName + ' ' + interactionCard.lastName;
            providerComponentName = 'Provider: '+ ($A.util.isEmpty(providerFullName) ? "" : providerFullName);
        }
        _autodoc.deleteAutodocComponent(cmp.get("v.autodocUniqueId"), cmp.get("v.policySelectedIndex"), providerComponentName);
    },

    showToastMessage: function (title, message, type, mode, duration) {
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
	caseWrapperHelper: function (component, event, helper) {
		let caseWrapper = component.get("v.caseWrapperMNF");
		var extProviderTable = _autodoc.getAutodocComponent(component.get("v.autodocUniqueId"), component.get("v.policySelectedIndex"), "Claim Results");
		if (!$A.util.isUndefinedOrNull(extProviderTable) && !$A.util.isEmpty(extProviderTable)) {
			var selectedRowdata = extProviderTable.selectedRows[0];
			if (!$A.util.isUndefinedOrNull(selectedRowdata) && !$A.util.isEmpty(selectedRowdata)) {
				let selectedClaimNo = selectedRowdata.rowColumnData[0].fieldValue;
				let selectedserviceDate = selectedRowdata.rowColumnData[4].fieldValue;
				var dates = selectedserviceDate.split("-");
				var startDate = dates[0].split("/");
				var claimStartDate;
				if (startDate.length > 1)
					claimStartDate = startDate[2].trim() + "-" + startDate[0].trim() + "-" + startDate[1].trim();

				console.log("%c" + selectedClaimNo + "---" + claimStartDate, 'color:blue');
				caseWrapper.claimNumber = selectedClaimNo;
				caseWrapper.serviceDate = claimStartDate;
			}
		}

		if (!$A.util.isUndefinedOrNull(caseWrapper)) {
			caseWrapper.Comments = component.get("v.commentsValue");
			component.set("v.caseWrapperMNF", caseWrapper);
		}
                },
//US1983608
navigateToDetail: function(component, event, helper,i) {
    //Added by Mani -- Start
    console.log('>>'+i);
    let policyDetails = component.get("v.policyDetails");
    console.log("P:oll" + JSON.stringify(policyDetails));
    let insuranceTypeCode = component.get("v.insuranceTypeCode");
    console.log("insuranceTypeCode" + insuranceTypeCode);
    let contractFilterData = {};
    if (!$A.util.isEmpty(policyDetails)) {
        contractFilterData = {
            "marketType": policyDetails.resultWrapper.policyRes.marketType,
            "marketSite": policyDetails.resultWrapper.policyRes.marketSite,
            "productCode": insuranceTypeCode,
            "platform": policyDetails.resultWrapper.policyRes.platform

        }
    }
    console.log("Policy Details--102" + JSON.stringify(contractFilterData));
    //Added by Mani -- End
    var selectedRowdata = component.get("v.selectedRows"); //event.getParam("selectedRows");
    var currentRowIndex = event.getParam("currentRowIndex");
    var landing =false;
    if(i==0){
        landing =true;  
    }
    //var i = 0;
    //for (var i = 0; i < selectedRowdata.length; i++) {
        console.log('selectedRowdata in acet_claim_search_result' + JSON.stringify(selectedRowdata));
        console.log('claim number outside if ' + selectedRowdata[i].rowColumnData[0].fieldValue);
        //write better logic to get claim number
        if (!$A.util.isUndefinedOrNull(selectedRowdata) &&
            !$A.util.isUndefinedOrNull(selectedRowdata[i].rowColumnData) &&
            selectedRowdata[i].rowColumnData.length > 0

        ) {
            console.log('selectedRowdata in acet_claim_search_result' + JSON.stringify(selectedRowdata));
            //console.log('claim number inside if '+ selectedRowdata[i].rowColumnData[0].fieldValue);
            //write better logic to get claim number
            let selectedClaimNo = selectedRowdata[i].rowColumnData[0].fieldValue;
            let selectedProcessedDate = selectedRowdata[i].rowColumnData[8].fieldValue;
            let taxId = selectedRowdata[i].rowColumnData[1].fieldValue;
            let claimStatus = selectedRowdata[i].rowColumnData[6].fieldValue;
            var claimStatusSet = component.get("v.claimStatusSet");
            let claimStatusSetNew = new Set();
            for (var x in claimStatusSet) {
                claimStatusSetNew.add(claimStatusSet[x]);
            }
            let isClaimNotOnFile = claimStatusSetNew.has(claimStatus) ? true : false;
            let claimInput = component.get("v.claimInput");
            claimInput.processDate = selectedProcessedDate;
            claimInput.ClaimType = selectedRowdata[i].additionalData.ClaimType;
            let claimInputTxaId = claimInput.taxId;
            if (taxId != '--') {
                claimInput.taxId = taxId;
            }
            console.log('claimInput####' + JSON.stringify(claimInput));
            let arrClaimSummaryDetails = component.get("v.mapClaimSummaryDetails");
            let selectedClaimDetailCard = arrClaimSummaryDetails.find(v => v.componentName.includes(selectedClaimNo));

            let mapInOutPatientDetails = component.get("v.mapInOutPatientDetails");
            let mapInOutPatientDetail = mapInOutPatientDetails.find(v => v.componentName.includes(selectedClaimNo));

            let arrClaimAdditionalInfo = component.get("v.mapClaimAdditionalInfo");
            let arrClaimAdditionalInfoTable = arrClaimAdditionalInfo.find(v => v.componentName.includes(selectedClaimNo));

            let arrClaimStatusDetails = component.get("v.listClaimStatusDetails");
            let selectedClaimStatusTable = arrClaimStatusDetails.find(v => v.componentName.includes(selectedClaimNo));

            let memberInfoDetails = component.get("v.memberInfoDetails");
            let selectedmemberInfoDetails = memberInfoDetails.find(v => v.claimno.includes(selectedClaimNo));
            console.log("selectedmemberInfoDetails-" + JSON.stringify(selectedmemberInfoDetails));

            console.log("mapClaimSummaryDetails-" + JSON.stringify(selectedClaimDetailCard));
            let PROVIDERID = selectedRowdata[i].rowColumnData[2].fieldValue;

            //Added by mani --Start-12/22/2019
            let memberID = component.get("v.memberId");
            if (!$A.util.isUndefinedOrNull(selectedClaimDetailCard) && !$A.util.isEmpty(selectedClaimDetailCard)) {
                var fieldString = selectedClaimDetailCard.cardData[6].fieldValue;
                var array = [];
                array = fieldString.split('-');
            }

            var firstSvcDateParts = array[0].trim().split('/');
            var firstSvcDate = firstSvcDateParts[2] + '-' + firstSvcDateParts[0] + '-' + firstSvcDateParts[1] + 'T00:00:00.000Z';

            var lastSvcDateParts = array[1].trim().split('/');
            var lastSvcDate = lastSvcDateParts[2] + '-' + lastSvcDateParts[0] + '-' + lastSvcDateParts[1] + 'T00:00:00.000Z';

            var receivedDate = selectedmemberInfoDetails.receivedDate.trim().split('/');
            var receivedDate = receivedDate[2] + '-' + receivedDate[0] + '-' + receivedDate[1] + 'T00:00:00.000Z';


            let relatedDocData = {
                "FirstDateofService": firstSvcDate,
                "LastDateofService": lastSvcDate,
                "MemberID": memberID,
                "TIN": selectedRowdata[i].rowColumnData[1].fieldValue,
                "ClaimNumber": selectedClaimNo,
                "FirstName": selectedmemberInfoDetails.ptntFn,
                "LastName": selectedmemberInfoDetails.ptntLn,
                "receivedDate": receivedDate,
                "selectedmemberInfoDetails": selectedmemberInfoDetails,
                "policyNumber": component.get("v.policyNumber"),
                "platform": selectedmemberInfoDetails.platform,
                "referralId": selectedmemberInfoDetails.referralId,
                "PatientFullName": selectedmemberInfoDetails.ptntFn + ' ' + selectedmemberInfoDetails.ptntLn
            };
            console.log("relatedDocData-" + JSON.stringify(relatedDocData));
            //Added by mani--End
            //chandra start
            var serviceDates = selectedRowdata[i].rowColumnData[4].fieldValue;
            var dates = serviceDates.split("-");
            var startDate = dates[0].split("/");
            var endDate = dates[1].split("/");
            var claimStartDate = startDate[2].trim() + "-" + startDate[0].trim() + "-" + startDate[1].trim();
            var claimEndDate = endDate[2].trim() + "-" + endDate[0].trim() + "-" + endDate[1].trim();
            //chandra End

            //Ketki Move to the top begin
            var tableDetails = component.get("v.autodocClaimResult");
            var newBody = [];
            var noRows = [];
            /*newBody.push(selectedRowdata);
            // US3537364
            for (let i = 0; i < tableDetails.tableBody.length; i++) {
                const element = tableDetails.tableBody[i];
                // if (i != currentRowIndex) {
                //     newBody.push(element);
                // }
                 if(element.caseItemsExtId=='No Results Found')
                            noRows.push(element);
                else if (element.caseItemsExtId != selectedRowdata[i].caseItemsExtId) {
                    newBody.push(element);
                }
                            }
            tableDetails.tableBody =noRows.concat(newBody);
            component.set("v.autodocClaimResult", tableDetails);*/
            //Ketki Move to the front end


            //US2876410 ketki 9/11:  Launch Claim Detail Page
            let workspaceAPI = component.find("workspace");
            workspaceAPI.getAllTabInfo().then(function(response) {

                let mapOpenedTabs = component.get('v.TabMap');
                let claimNoTabUniqueId = component.get('v.memberTabId') + selectedClaimNo;
                if ($A.util.isUndefinedOrNull(mapOpenedTabs)) {
                    mapOpenedTabs = new Map();
                }

                //KJ multiple tabs autodoc component order begin
                //let currentIndexOfOpenedTabs = component.get('v.currentIndexOfOpenedTabs');
                let extProviderTable = _autodoc.getAutodocComponent(component.get("v.autodocUniqueId"), component.get("v.policySelectedIndex"), 'Claim Results');
                let currentIndexOfOpenedTabs = extProviderTable.selectedRows.length - 1;
                //KJ multiple tabs autodoc component order end

                //Duplicate Found
                /* if (mapOpenedTabs.has(claimNoTabUniqueId)) {
                     //let tabResponse = mapOpenedTabs.get(claimNoTabUniqueId);
                     let tabResponse;
                     if (!$A.util.isUndefinedOrNull(response)) {
                         for (let i = 0; i < response.length; i++) {
                             if (!$A.util.isUndefinedOrNull(response[i].subtabs.length) && response[i].subtabs.length > 0) {
                                 for (let j = 0; j < response[i].subtabs.length; j++) {

                                    if(claimNoTabUniqueId === response[i].subtabs[j].pageReference.state.c__claimNoTabUnique)
                                    {

                                     tabResponse = response[i].subtabs[j];
                                     break;
                                    }
                                }
                             }
                         }
                      }

                     workspaceAPI.openTab({
                         url: tabResponse.url
                     }).then(function (response) {
                         workspaceAPI.focusTab({
                             tabId: response
                         });
                     }).catch(function (error) {
                     });
                 } else {*/
                console.log("Opening sub tab for claimNoTabUniqueId " + claimNoTabUniqueId);
                // Get selected claim service dates
                var memberPolicesTOsend = component.get("v.memberPolicies");
                console.log('===@@@####memberPolices is 202 ' + JSON.stringify(component.get("v.memberPolicies")));
                var selectedPolicy = component.get("v.selectedPolicy");
                //US3189884 - Sravan - Start
                var callTopicLstSelected = component.get("v.callTopicLstSelected");
                var callTopics = [];
                if (!$A.util.isUndefinedOrNull(callTopicLstSelected) && !$A.util.isEmpty(callTopicLstSelected)) {
                    callTopics = JSON.stringify(callTopicLstSelected);
                }
                var providerDetails = JSON.stringify(component.get("v.providerDetails"));
                //US3189884 - Sravan - End
                if (component.get("v.policyDetails").resultWrapper.policyRes.sourceCode == "CO") {
                    component.set("v.isMRlob", true);
                } else {
                    component.set("v.isMRlob", false);
                }
                workspaceAPI.openSubtab({
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__ACET_ClaimDetails"
                        },
                        "state": {
                            "c__claimNo": selectedClaimNo,
                            "c__isClaim": true,
                            "c__resultsTableRowData": selectedRowdata[i],
                            "c__currentRowIndex": currentRowIndex,
                            "c__claimNoTabUnique": claimNoTabUniqueId,
                            "c__hipaaEndpointUrl": component.get("v.hipaaEndpointUrl"),
                            "c__contactUniqueId": component.get("v.contactUniqueId"),
                            "c__interactionRec": JSON.stringify(component.get('v.interactionRec')),
                            "c__interactionOverviewTabId": component.get("v.interactionOverviewTabId"),
                            "c__claimInput": claimInput,
                            "c__isMRlob": component.get("v.isMRlob"),
                            "c__mapInOutPatientDetail": JSON.stringify(mapInOutPatientDetail),
                            "c__selectedClaimDetailCard": JSON.stringify(selectedClaimDetailCard),
                            "c__selectedClaimStatusTable": JSON.stringify(selectedClaimStatusTable),
                            "c__contractFilterData": JSON.stringify(contractFilterData), //Added By Mani
                            "c__autodocUniqueId": component.get("v.autodocUniqueId"),
                            "c__autodocUniqueIdCmp": component.get("v.autodocUniqueIdCmp"),
                            "c__caseWrapperMNF": component.get("v.caseWrapperMNF"),
                            //Added chandra for pcp Start
                            "c__componentId": component.get("v.componentId"),
                            "c__memberDOB": component.get("v.memberDOB"),
                            "c__policyDetails": component.get("v.policyDetails"),
                            "c__memberFN": component.get("v.memberFN"),
                            "c__memberCardData": component.get("v.memberCardData"),
                            "c__memberCardSnap": component.get("v.memberCardSnap"),
                            "c__policyNumber": component.get("v.policyNumber"),
                            "c__houseHoldData": JSON.stringify(component.get("v.houseHoldData")),
                            "c__dependentCode": component.get("v.dependentCode"),
                            "c__regionCode": component.get("v.regionCode"),
                            "c__cobData": JSON.stringify(component.get("v.cobData")),
                            "c__secondaryCoverageList": JSON.stringify(component.get("v.secondaryCoverageList")),
                            "c__cobMNRCommentsTable": JSON.stringify(component.get("v.cobMNRCommentsTable")),
                            "c__cobENIHistoryTable": JSON.stringify(component.get("v.cobENIHistoryTable")),
                            "c__houseHoldMemberId": component.get("v.houseHoldMemberId"),
                            "c__memberPolicies": JSON.stringify(memberPolicesTOsend),
                            //"c__memberPolicies": memberPolicesTOsend,
                            "c__policySelectedIndex": component.get("v.policySelectedIndex"),
                            "c__currentPayerId": component.get("v.currentPayerId"),
                            "c__memberautodocUniqueId": component.get("v.memberautodocUniqueId"),
                            "c__autoDocToBeDeleted": component.get("v.autoDocToBeDeleted"),
                            "c__serviceFromDate": claimStartDate,
                            "c__serviceToDate": claimEndDate,
                            //Added chandra for pcp END,
                            "c__memberLN": component.get("v.memberLN"),
                            "c__AuthAutodocPageFeatur": component.get("v.AuthAutodocPageFeature"),
                            "c__authContactName": component.get("v.authContactName"),
                            "c__SRNFlag": component.get("v.SRNFlag"),
                            "c__interactionType": component.get("v.interactionType"),
                            "c__AutodocPageFeatureMemberDtl": component.get("v.AutodocPageFeatureMemberDtl"),
                            "c__AutodocKeyMemberDtl": component.get("v.AutodocKeyMemberDtl"),
                            "c__isHippaInvokedInProviderSnapShot": component.get("v.isHippaInvokedInProviderSnapShot"),
                            "c__noMemberToSearch": component.get("v.noMemberToSearch"),
                            "c__interactionCard": component.get("v.interactionCard"),
                            "c__selectedTabTyp": component.get("v.selectedTabType"),
                            "c__originatorType": component.get("v.originatorType"),
                            "c__memberTabId": component.get("v.memberTabId"),
                            "c__providerId": PROVIDERID,
                            //KJ multiple tabs autodoc component order begin
                            //"c__currentIndexOfOpenedTabs": component.get("v.currentIndexOfOpenedTabs"),
                            "c__currentIndexOfOpenedTabs": (extProviderTable.selectedRows.length - 1),
                            //KJ multiple tabs autodoc component order end
                            "c__selectedPolicy": JSON.stringify(selectedPolicy),
                            "c__callTopicOrder": JSON.stringify(component.get("v.callTopicOrder")),
                            "c__planLevelBenefitsRes": JSON.stringify(component.get("v.planLevelBenefitsRes")),
                            "c__eligibleDate": component.get("v.eligibleDate"),
                            "c__highlightedPolicySourceCode": component.get("v.highlightedPolicySourceCode"),
                            "c__isSourceCodeChanged": component.get("v.isSourceCodeChanged"),
                            "c__policyStatus": component.get("v.policyStatus"),
                            "c__isTierOne": component.get("v.isTierOne"),
                            "c__callTopicLstSelected": callTopics, //US3189884 - Sravan
                            "c__callTopicTabId": component.get("v.callTopicTabId"), //US3189884 - Sravan
                            "c__relatedDocData": relatedDocData,
                            "c__providerDetails": providerDetails,
                            "c__addClaimType": selectedRowdata[i].additionalData.ClaimType,
                            "c__addnetworkStatus": selectedRowdata[i].additionalData.NetworkStatus,
                            "c__addbilltype": selectedRowdata[i].additionalData.billtype,
                            "c__isClaimNotOnFile": isClaimNotOnFile,
                            "c__selectedAdditionalInfoTable": JSON.stringify(arrClaimAdditionalInfoTable),
                            "c__memberEEID": component.get("v.subjectCard.EEID"), // US3177995 - Thanish - 22nd Jun 2021
                            "c__insuranceTypeCode": component.get("v.insuranceTypeCode"), // US3705824
                            "c__providerDetailsForRoutingScreen": component.get("v.providerDetailsForRoutingScreen"),
                            "c__flowDetailsForRoutingScreen": component.get("v.flowDetailsForRoutingScreen"),
                            "c__selectedIPAValue": component.get("v.selectedIPAValue")
                        }
                    },
                    focus: landing
                }).then(function(response) {
                    console.log("After opening sub tab for claimNoTabUniqueId " + claimNoTabUniqueId);
                    console.log(JSON.stringify(response));

                    //KJ multiple tabs autodoc component order begin

                    var info = {};
                    info.indexOfOpenedTab = currentIndexOfOpenedTabs;
                    info.response = response;
                    currentIndexOfOpenedTabs++;
                    component.set('v.currentIndexOfOpenedTabs', currentIndexOfOpenedTabs);
                    //KJ multiple tabs autodoc component order end

                    component.set('v.TabMap', mapOpenedTabs);

                    //mapOpenedTabs.set(claimNoTabUniqueId, response);
                    mapOpenedTabs.set(claimNoTabUniqueId, info);
                    console.log("mapOpenedTabs value " + JSON.stringify(mapOpenedTabs));
                    component.set('v.TabMap', mapOpenedTabs);
                    workspaceAPI.setTabLabel({
                        tabId: response,
                        label: selectedClaimNo
                    });
                    workspaceAPI.setTabIcon({
                        tabId: response,
                        icon: "custom:custom17",
                        iconAlt: "Claim Detail"
                    });
                }).catch(function(error) {});
                // }
            }).catch(function(error) {});
        }
    //}
    //US2876410 ketki 9/11:  Launch Claim Detail Page
}
})