({
   getuserinfo: function(component, event, helper) {
     var action = component.get("c.getUserInfo");
    action.setCallback(this, function(response) {
      var state = response.getState();
      if(state == "SUCCESS" && component.isValid()){
        var result = response.getReturnValue();
        console.log(result.Profilename);
 component.set("v.userProfilename",result.Profilename);
   }else{
     console.error("fail:" + response.getError()[0].message); 
    }
   });
  $A.enqueueAction(action);
},
    changeSearchFilters: function(component, event, helper) {
        component.set('v.showResults', false);        
        var docType = component.get('v.docTypeSelected');
        if (docType == '--None--') {
            //var listsearchFilter = [];
            //component.set('v.listSearchFilter', listsearchFilter);
        } else {
            if(docType == 'Renewal Letter' || docType == 'Renewal Package' || docType == 'Summary Plan Description') {
                component.set('v.showBulkResend', false);
            } else {
                component.set('v.showBulkResend', true);
            }
            var action = component.get('c.changeSearchFilter');
            action.setParams({
                documentType: docType
            });
            // Set up the callback
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var listSearchFilter = response.getReturnValue();
                    console.log('changeSearchFilter returned: ' + listSearchFilter);
                    // component.set('v.listSearchFilter', listSearchFilter);
                    //TODO: build for loop to set default values from highlights panel data?
                    var doceffdateOHG = component.get("v.planEffEndLabel");
                    var doceffdateOHM = component.get("v.planEffEndLabelOHM");
                    var doceffdateSBC = component.get("v.planEffEndLabelSBC");
                    var hData = component.get("v.highlightPanel");
                    for (var i = 0; i < listSearchFilter.length; i++) {
                        if(listSearchFilter[0].Document_Type__r.WS_Field_Name__c != null){
                         component.set('v.selecteddoctype',listSearchFilter[0].Document_Type__r.WS_Field_Name__c);
                        }
                        //   if (listSearchFilter[i].Document_Type_Field__r.HP_Field_Name__c != 'GroupNumber' && listSearchFilter[i].Document_Type_Field__r.HP_Field_Name__c != 'groupFlowGroupNumber' && hData[listSearchFilter[i].Document_Type_Field__r.HP_Field_Name__c]) {
                        if (listSearchFilter[i].Document_Type_Field__r.HP_Field_Name__c != 'groupFlowGroupNumber' && hData[listSearchFilter[i].Document_Type_Field__r.HP_Field_Name__c]) {
                            listSearchFilter[i].value = hData[listSearchFilter[i].Document_Type_Field__r.HP_Field_Name__c];
                            if (listSearchFilter[i].Document_Type_Field__r.Label == 'Subscriber ID' && listSearchFilter[i].value.length > 9) {
                                listSearchFilter[i].value = listSearchFilter[i].value;//.substring(0, 9);
                            }
                        } else if (listSearchFilter[i].Document_Type_Field__r.HP_Field_Name__c != null && listSearchFilter[i].Document_Type_Field__r.HP_Field_Name__c == 'EffectiveStartDate') {
                            if (listSearchFilter[i].DeveloperName == doceffdateOHG || listSearchFilter[i].DeveloperName == doceffdateOHM || listSearchFilter[i].DeveloperName == doceffdateSBC) {
                                var d = new Date(hData.EffectiveDate);
                                var year = d.getFullYear();
                                var month = d.getMonth();
                                var day = d.getDate() + 364;
                                var newdate = new Date(year, month, day);
                                var finaldate = newdate.getFullYear() + '-' + (newdate.getMonth() + 1) + '-' + newdate.getDate();
                                listSearchFilter[i].value = finaldate;
                            } else {
                                var d = new Date(hData.EffectiveDate);
                                var finaldate = d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate();
                                listSearchFilter[i].value = finaldate;
                            }
                        }
                    }
                    //alert('here1' + JSON.stringify(listSearchFilter));
                    component.set('v.listSearchFilter', listSearchFilter);
                    //alert('here2' + JSON.stringify(component.get('v.listSearchFilter')));
        			component.set('v.displaySearchFields', true);
                    //alert('here3');
                    if (component.get('v.memberid') != null || component.get('v.srk') != null) {
                        var action2 = component.get("c.findMemberInfo");
                        action2.setParams({
                            memberId: component.get('v.memberid'),
                            SRK: component.get('v.srk'),
                            documentType: component.get('v.docTypeSelected')
                           
                        });
                        action2.setCallback(this, function(response) {
                            component.set("v.notFoundMessage", false);
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                component.set("v.memberAdd", JSON.parse(response.getReturnValue()));
                                var addInfo = component.get("v.memberAdd");
                                //if address wrap comes back empty, show not found message
                                if ((addInfo.personFirstName == null || addInfo.personFirstName == '') && (addInfo.personMiddleName == null || addInfo.personMiddleName == '') && (addInfo.personLastName == null || addInfo.personLastName == '') && (addInfo.personSuffix == null || addInfo.personSuffix == '') && (addInfo.personAddOne == null || addInfo.personAddOne == '') && (addInfo.personAddTwo == null || addInfo.personAddTwo == '') && (addInfo.personCity == null || addInfo.personCity == '') && (addInfo.personState == null || addInfo.personState == '') && (addInfo.personZipCode == null || addInfo.personZipCode == '') && (addInfo.personOrganization == null || addInfo.personOrganization == '')) {
                                    component.set("v.notFoundMessage", true);
                                }
                                //Set Middle Intial
                    if((addInfo.personMiddleName != null || addInfo.personMiddleName != '')){
                    var pMiddleName = (addInfo.personMiddleName.length > 1) ? addInfo.personMiddleName.charAt(0) : addInfo.personMiddleName;
                    component.set("v.personMiddleIntial", pMiddleName);
                    }
                    if((addInfo.personMiddleNameAA != null || addInfo.personMiddleNameAA != '')){
                    var pMiddleNameAA = (addInfo.personMiddleNameAA.length > 1) ? addInfo.personMiddleNameAA.charAt(0) : addInfo.personMiddleNameAA;
                    component.set("v.personMiddleIntialAA", pMiddleNameAA);
                    }
                                
                            } else {
                                component.set("v.notFoundMessage", true);
                            }
                        });
                        $A.enqueueAction(action2);
                    }
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    console.error(errors);
                }
                
            });
            $A.enqueueAction(action);
        }
    },

    showResults: function(component, event, helper, docType, searchParams) {
        console.log('searchParams---->'+searchParams);
        component.set("v.disableBulkResend", true);
        var action = component.get("c.getCommunicationSearchResults");
        action.setParams({
            documentType: docType,
            dynamicParams: searchParams
        });
        //Setting the Callback
        action.setCallback(this, function(response) {
            //get the response state
            var state = response.getState();
            console.log('----state---' + state);
            //check if result is successfull
            if (state == "SUCCESS") {
                var WSObject = JSON.parse(response.getReturnValue().responce);
                var listResultFields = JSON.parse(response.getReturnValue().resultFields);
                console.log('getResultfields returned: ' + listResultFields);
                if (listResultFields != null && listResultFields.length > 0) {
                    var columns = [];
                    for (var i = 0; i < listResultFields.length; i++) {
                        var type;
                        if (listResultFields[i].Document_Type_Field__c != null) {

                            if (listResultFields[i].Document_Type_Field__r.Data_Type__c == 'Datetime' || listResultFields[i].Document_Type_Field__r.Data_Type__c == 'Date') {
                                type = "date";
                            } else {
                                type = "string";
                            }
                            var column = {
                                title: listResultFields[i].Document_Type_Field__r.Field_Name__c,
                                defaultContent: "",
                                data: listResultFields[i].Document_Type_Field__r.WS_Field_Name__c,
                                //className:"",
                                type: type
                            }
                            if (listResultFields[i].Document_Type_Field__r.Field_Name__c == 'Document ID') {
                                column.className = 'DocID_clm_cls';
                            }
                            columns.push(column);
                        }
                        
                    }
                    var lgt_dt_DT_Object = new Object();
                    lgt_dt_DT_Object.lgt_dt_PageSize = 50;
                    lgt_dt_DT_Object.lgt_dt_StartRecord = 1;
                    lgt_dt_DT_Object.lgt_dt_PageNumber = 1;
                    lgt_dt_DT_Object.lgt_dt_SortBy = '0';
                    lgt_dt_DT_Object.lgt_dt_SortDir = 'desc';
                    lgt_dt_DT_Object.lgt_dt_serviceName = 'ACETLGT_FindDocWebservice';
                    lgt_dt_DT_Object.lgt_dt_columns = columns;
                    lgt_dt_DT_Object.lgt_dt_serviceObj = WSObject;
                    lgt_dt_DT_Object.lgt_dt_lock_headers = "300";
                    component.set("v.lgt_dt_DT_Object", JSON.stringify(lgt_dt_DT_Object));
                    var lgt_dt_Cmp = component.find("CommunicationSearchTable_auraid");
                    //                    setTimeout(function(){ lgt_dt_Cmp.tableinit(); }, 3000);
                    var emptyList = [];
                    component.set('v.tableData', emptyList);
                    lgt_dt_Cmp.tableinit();
                }
            } else if (state == "ERROR") {
                console.log('getCommunicationSearchResults ERROR');
            }
        });
        $A.enqueueAction(action);
    },

    //success message    
    //String message = 'Document ' + docIds[i] + ' ' + selComResult.Resend_Status + ' ' + selComResult.Resend_Date_Time;
    //helper.toastmessagehelper(component,event,helper,'Success','Resend Submitted',message);
    //error message
    //helper.toastmessagehelper(component,event,helper,'Error',docRedeliveryCalloutResult.Message,'error');


    toastmessagehelper: function(component, event, helper, title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type,
            "mode": 'sticky'
        });
        toastEvent.fire();
    },

    closeModal: function(component, event, helper) {
        component.set("v.displayResendPopup", false);
    }
   
})