({
   doInit : function(component, event, helper) {
       
   },
   onClickSBC: function(component, event, helper) {
       component.set("v.isOpen", true);
       helper.showResults(component, event, helper);
   },
   closeModel: function(component, event, helper) {
      component.set("v.isOpen", false);
   },
   handle_dt_initComplete_Event: function(component, event, helper) {
        var settings = event.getParam("settings");
    }, 
   handle_dt_callback_Event: function(component, event, helper) {
        var settings = event.getParam("settings");
        var lgt_dt_table_ID = event.getParam("lgt_dt_table_ID");
    },
    handle_dt_createdRow_Event: function(component, event, helper) {
        var row = event.getParam("row");
        var data = event.getParam("data");
        var dataIndex = event.getParam("dataIndex");
        var docType = $A.get("$Label.c.oxford_sbc");
        var docId;
        var docContentType;
        var docName;
        var docsize;
        var isDocSizeMoreThanOneMB;
       
        var memID = component.get("v.memberId");
        if (data != null) {
           
            docId = data["DocumentId"];
            docContentType = data["cmis:contentStreamMimeType"];
            docName = data["cmis:contentStreamFileName"];
            docsize = parseInt(data["cmis:contentStreamLength"]);
            if (docsize) {
                isDocSizeMoreThanOneMB = (docsize / (1024 * 1024) >= 1 ? true : false);
            }
            var tableData = component.get('v.tableData');
            tableData.push(JSON.stringify(data));
        }
        console.log(data);
        $(row).children().first().html("<a id='lnkDocId' href='#'>" + docId + "</a>");
        $(row).children().first().on('click', function(e) {
            helper.opendocument(component, event, helper,docId);
        });
    },

    handle_dt_pageNum_Event: function(component, event, helper) {}

   
})