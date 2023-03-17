({
    //Added by Sameera
	firePaginationEvent : function(component,pageNumber) {
		
        var paginationEvt = component.getEvent("pagination");
        paginationEvt.setParams({
            "pageNumber":pageNumber,
            "isFamilyLevel":false
        });
        paginationEvt.fire();
        
    },
    
    //fire component event by passing the selected feedID to the SNI_FL_AgentView.cmp
    sendSelectedFeedID:function(component,event,feedID){
        
        var selectedMessageEvt = component.getEvent("selectedMessage");
        selectedMessageEvt.setParams({
            "directMessageFeedID":feedID
        });
        selectedMessageEvt.fire();
        

    }
})