({
	doInit: function (cmp, event, helper) {
        console.log('TEST');
        var recid = cmp.get("v.recordId");
        cmp.set("v.recordId",recid)
     //   console.log('--------recid--------'+recid);
		helper.getAuthDetails(cmp, event, helper);
        //helper.testData(cmp,event,helper);
    },
    
    displayCompleteNote : function(component, event, helper) {

        var Notes ;
        
        var target = event.target
        console.log('target'+target);
        var dataEle = target.getAttribute("data-selected-Index");
        var Id = component.get("v.authorizeDetails");
        if(dataEle){
         Notes = Id.notesDetail[dataEle].text;
        }
        console.log('Notes'+Notes);
        component.set("v.completeNotes",Notes);
        component.set("v.completeNoteViewModalOpen",true);
},
    closeNoteModel : function(component, event, helper) {
         component.set("v.completeNoteViewModalOpen",false);
    }
})