({
   showResults: function(component, event, helper) {
        var groupId = component.get("v.groupId");
        var bbundleId = component.get("v.bbundleId");
        var action = component.get("c.initDocDatatable");
        action.setParams({
            docType : $A.get("$Label.c.oxford_sbc"),
            GroupID: groupId,
            BBundleId: bbundleId
        });
        //Setting the Callback
        action.setCallback(this, function(response) {
            //get the response state
            var state = response.getState();
           
            if (state === "SUCCESS") {
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
                        }
                        columns.push(column);
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
                    var lgt_dt_Cmp = component.find("ViewDocumentsTable_auraid");
                  
                    var emptyList = [];
                    component.set('v.tableData', emptyList);
                    lgt_dt_Cmp.tableinit();
                }else if (state == "ERROR") {
                console.log('Planbenefits-SBC-Documents ERROR');
                }
            }
        });
        $A.enqueueAction(action);
    },
     opendocument: function(component, event, helper,docId) {
         var action = component.get("c.getDoc360URL"); //Modified by Raviteja - Team Styx US3543138
          action.setParams({
                    documentId : docId,
                    doctypeWSName: $A.get("$Label.c.oxford_sbc")
                });
                action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var urlString = response.getReturnValue();
                   window.open(urlString, 'EDMS', 'toolbars=0,width=1200,height=800,left=0,top=0,scrollbars=1,resizable=1');
                }
                });
         $A.enqueueAction(action);
     }
})