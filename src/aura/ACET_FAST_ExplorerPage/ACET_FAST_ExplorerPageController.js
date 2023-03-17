({
    doInit: function (cmp, event, helper) {
        console.log('### in Explorer Page');
        helper.closeInteractionOverviewTabs(cmp);
        var timer = setTimeout(function () {
            helper.closeInteractionOverviewTabs(cmp);
        }, 3000);
        helper.initializeObjects(cmp);
        helper.populatePickListOptions(cmp);
        helper.setCaseRecordTypevalue(cmp,event);
    },

    openMisdirectComp: function (cmp, event, helper) {
        helper.openMisDirect(cmp);
    },
    
   /* showAlerts: function (cmp, event, helper) {
        console.log('inside show alert');
        cmp.find("alertsAI").alertsMethod();
    },*/
    
    handleOnChange: function (cmp, event, helper){
        helper.handleOnChangehelper(cmp,event);               
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