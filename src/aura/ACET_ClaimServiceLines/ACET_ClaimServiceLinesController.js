({
    onInit: function(component, event, helper) {
        var  claimServiceLineList = component.get("v.claimServiceLineDetails");
        console.log("claimServiceLineDetails in ACET_ClaimServiceLines : "+ JSON.stringify(claimServiceLineList));
        var  allSvlLineCardData = component.get("v.allSvlLineCardData");
        console.log("allSvlLineCardData in ACET_ClaimServiceLines : "+ JSON.stringify(allSvlLineCardData));

        var currentIndexOfOpenedTabs = component.get("v.currentIndexOfOpenedTabs");
        claimServiceLineList.componentOrder = claimServiceLineList.componentOrder + (20*currentIndexOfOpenedTabs);
        component.set("v.claimServiceLineList",claimServiceLineList);
        //helper.getClaimServiceLineList(component);

        var memberDob = component.get("v.memberDOB");
        if(!$A.util.isUndefinedOrNull(memberDob) && !$A.util.isEmpty(memberDob)){
            let dt = new Date(memberDob),
                month = '' + (dt.getMonth() + 1),
                day = '' + dt.getDate(),
                year = dt.getFullYear();

            if (month.length < 2)
                month = '0' + month;
            if (day.length < 2)
                day = '0' + day;
            memberDob = year + '-' + month + '-' + day;
            component.set("v.startDate", memberDob);
        }

        //helper.getReferrals(component, event, helper);
    },
    handlecloseServiceLine : function (component, event, helper){
        var componentUniqueid = event.getParam("componentUniqueid");
        var rowIndex = event.getParam("rowIndex");
        var serviceLineList = component.get("v.serviceLineList");
        const ind = serviceLineList.indexOf(rowIndex);
        if (ind > -1) {
            serviceLineList.splice(ind, 1);
        }
        var clmSvcInfoList = component.get("v.clmSvcInfoList");

        var componentfound = component.find(componentUniqueid);

        //remove component
        for( var i = 0; i < clmSvcInfoList.length; i++){
            if ( clmSvcInfoList[i] === componentfound) {
                clmSvcInfoList.splice(i, 1);

            }
        }
        //enable the link
        var index = componentUniqueid.split('-')[0];
        helper.enableLink(component,index);

        component.set("v.clmSvcInfoList", clmSvcInfoList);
    },
    getSelectedRecords: function (component, event, helper) {
        event.stopPropagation();
        var data = event.getParam("selectedRows");
        var currentRowIndex = event.getParam("currentRowIndex");
        var cellIndex = event.getParam("currentCellIndex");
        var cellData = data.rowColumnData[cellIndex].cellData;
        console.log("Row data"+ JSON.stringify(data) );
        var serviceLineList = component.get("v.serviceLineList");
        var serviceLineListFlag = true;
        if(serviceLineList.includes(currentRowIndex)){
            serviceLineListFlag = false;
        }
        var claimInput = component.get("v.claimInput");
        var ClaimType = claimInput.ClaimType;
        if(cellIndex == 3){
            if(serviceLineListFlag){
                serviceLineList.push(currentRowIndex);
                console.log('currentRowIndex '+ JSON.stringify(currentRowIndex));
                let claimSvcLineDtl = {};//sravani start
                claimSvcLineDtl.line = data.rowColumnData[0].fieldValue;
                claimSvcLineDtl.v = data.rowColumnData[1].fieldValue;
                claimSvcLineDtl.code = data.rowColumnData[3].fieldValue;
                claimSvcLineDtl.rcode = data.rowColumnData[6].fieldValue;
                claimSvcLineDtl.processDt = data.rowColumnData[2].fieldValue;


                let selectedSvcLineDtl = data.rowColumnData[1].fieldValue +  ': '+data.rowColumnData[3].fieldValue;
                console.log('selectedSvcLineDtl '+ selectedSvcLineDtl);
                //sravani end
                let allSvlLineCardData = component.get("v.allSvlLineCardData");
                let origselectedSvcLineDtlCard = allSvlLineCardData[currentRowIndex];
                // let origselectedSvcLineDtlCard = allSvlLineCardData.find(v => v.componentName.includes(selectedSvcLineDtl));
                //create a copy of the selectedSvcLineDtlCard object
                let selectedSvcLineDtlCard = JSON.parse(JSON.stringify(origselectedSvcLineDtlCard));
                console.log('selectedSvcLineDtlCard '+ JSON.stringify(selectedSvcLineDtlCard));

                let allSvlLnAddInfoCardData = component.get("v.allSvlLnAddInfoCardData");
                let origSelectedSvcLineAddInfoCard = allSvlLnAddInfoCardData[currentRowIndex];
                //let origSelectedSvcLineAddInfoCard = allSvlLnAddInfoCardData.find(v => v.componentName.includes(selectedSvcLineDtl));
                //create a copy of the origSelectedSvcLineAddInfoCard object
                let selectedSvcLineAddInfoCard = JSON.parse(JSON.stringify(origSelectedSvcLineAddInfoCard));

                console.log('selectedSvcLineAddInfoCard '+ JSON.stringify(selectedSvcLineAddInfoCard));
                //var remarkDetails = "D1 - DSNET - NETWORK/PPO DISCOUNT - THE PLAN DISCOUNT SHOWN IS YOUR SAVINGS FOR USING A NETWORK PROVIDER.: SF - CBLI - COB - LACK OF INFORMATION - PAYMENT FOR THIS SERVICE IS DENIED";

                //claimSvcLineDtl.rdetails = remarkDetails;
                let componentUniqueid = currentRowIndex + "-" + claimSvcLineDtl.line+"-"+ claimSvcLineDtl.v + "-"+ claimSvcLineDtl.code;

                $A.createComponent('c:ACET_ClaimServiceLineInformation', {
                    "aura:id" : componentUniqueid,
                    componentUniqueid : componentUniqueid,
                    serviceLineDtls: claimSvcLineDtl,
                    selectedSvcLineDtlCard: selectedSvcLineDtlCard,
                    selectedSvcLineAddInfoCard: selectedSvcLineAddInfoCard,
                    autodocUniqueId: component.get("v.autodocUniqueId"),
                    autodocUniqueIdCmp: component.get("v.autodocUniqueIdCmp"),
                    interactionRec:component.get("v.interactionRec"),
                    currentIndexOfOpenedTabs: component.get("v.currentIndexOfOpenedTabs"),
                    rowIndex:currentRowIndex

                },function (newClmSvcInfoCard, status, errorMessage) {
                    if (status === "SUCCESS"){
                        var clmSvcInfoList = component.get("v.clmSvcInfoList");
                        clmSvcInfoList.unshift(newClmSvcInfoCard);
                        component.set("v.clmSvcInfoList", clmSvcInfoList);
                        helper.sortClaimSvcInfoCards(component);


                        setTimeout(function(){
                            try {
                                component.find(componentUniqueid).getElement().scrollIntoView({
                                    behavior: 'smooth',
                                    block: 'center'
                                });
                            } catch(exception) {
                                console.log(' exception ' + exception);
                            }
                        }, 100);
                    }
                });
            }
        }else if((cellIndex == 18 && ClaimType == 'P') || (cellIndex == 17 && ClaimType == 'H')){
            component.set("v.AUTHFlag", false);
            var claimInput = component.get("v.claimInput");
            var authNum = '';
            authNum = data.rowColumnData[cellIndex].fieldValue;
            component.set("v.authNum", authNum);
            component.set("v.AUTHFlag", true);
            var lineNum = data.rowColumnData[1].fieldValue;
            helper.navigateToCallTopic(component, event, helper,'AuthorizationDetails');
            helper.autoDocSRN(component, event, helper, authNum, claimInput.ClaimType,lineNum,cellIndex);
        }else{
            component.set("v.referralFlag", false);
            var referralNum = '';
            referralNum = data.rowColumnData[cellIndex].fieldValue;
            component.set("v.referralNum", referralNum);
            component.set("v.referralFlag", true);
            var lineNum = data.rowColumnData[1].fieldValue;
            helper.navigateToCallTopic(component, event, helper,'ReferralDetails');
            helper.autoDocSRN(component, event, helper, referralNum, claimInput.ClaimType,lineNum,cellIndex);
 
        }
    },

})