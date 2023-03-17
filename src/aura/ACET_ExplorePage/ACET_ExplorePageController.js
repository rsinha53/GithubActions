({
    doInit: function (cmp, event, helper) {
        console.log('### in Explorer Page');
        helper.closeInteractionOverviewTabs(cmp);
        var timer = setTimeout(function () {
            helper.closeInteractionOverviewTabs(cmp);
        }, 3000);
        helper.initializeObjects(cmp);
        helper.populatePickListOptions(cmp);

        // US3536342 - Thanish - 3rd Jun 2021 - handling onscroll events for snapshot
        window.onscroll= function(){
            let workspace = cmp.find("workspace");

            if(!$A.util.isEmpty(workspace)){
                workspace.getFocusedTabInfo().then(function (response) {
                    var pageHeader = document.getElementById(response.tabId + "pageHeader");

                    if(!$A.util.isEmpty(pageHeader)){
                        var highlightPanelToggle = document.getElementById(response.tabId + "highlightPanelToggle");
                        var commentsToggle = document.getElementById(response.tabId + "commentsToggle");

                        if(window.scrollY == 0){
                            pageHeader.setAttribute("style", "position: relative; background: rgb(243, 242, 242);");
                        } else{
                            // US3550144 - Thanish - 8th Jul 2021
                            if(cmp.get("v.isSandbox")){
                                pageHeader.setAttribute("style", "position: fixed; top: 150.4px; left: 0rem; z-index: 50; width: 100%; background: rgb(243, 242, 242);");
                            } else{
                                pageHeader.setAttribute("style", "position: fixed; top: 119.4px; left: 0rem; z-index: 50; width: 100%; background: rgb(243, 242, 242);");
                            }
                            if(!$A.util.isEmpty(highlightPanelToggle) && highlightPanelToggle.classList.contains("isOpened")){
                                highlightPanelToggle.click();
                            }
                            if(!$A.util.isEmpty(commentsToggle) && commentsToggle.classList.contains("isOpened")){
                                commentsToggle.click();
                            }
                        }
                    }
                });
            }
        };
    },

    openMisdirectComp: function (cmp, event, helper) {
        helper.openMisDirect(cmp);
    },
    /**
     * To Handle VCCD Application Event .
     *
     * @param objComponent To access dom elements.
     * @param objEvent To handle events.
     * @param objHelper To handle events.
     */
    handleVCCDEvent: function (objComponent, objEvent, objHelper) {
        let strMessage = objEvent.getParam("message");
        if ($A.util.isUndefinedOrNull(strMessage) === false && strMessage !== '') {
            try {
                let objMessage = JSON.parse(strMessage);
                objComponent.set("v.isVCCD", objMessage.isVCCD); //US2631703 - Durga- 08th June 2020
                objComponent.set("v.VCCDObjRecordId", objMessage.objRecordData.Id); //US2631703 - Durga- 08th June 2020
                var flowDetails = objComponent.get("v.flowDetails");
                flowDetails.contactFirstName = "";
                flowDetails.contactLastName = "";
                flowDetails.contactExt = "";
                flowDetails.IVRInfo =  objMessage.objRecordData;//US2903847
                if(!$A.util.isUndefinedOrNull(objMessage.isGenesys) && !$A.util.isEmpty(objMessage.isGenesys) ){
                    flowDetails.isGenesys = objMessage.isGenesys;//US2903847
                    if(objMessage.isGenesys && !$A.util.isUndefinedOrNull(objMessage.objRecordData)
                       && !$A.util.isUndefinedOrNull(objMessage.objRecordData.QuestionType__c) ){
                        objHelper.getQuestionTypeforGenesys(objComponent,flowDetails,objMessage.objRecordData.QuestionType__c)
                    }
                }
                else{
                objComponent.set("v.flowDetails", flowDetails);
                }
                objEvent.stopPropagation();
            } catch (exception) {
                console.log('Inside VCCD Handle Exception' + exception);
            }
        }
    }

})