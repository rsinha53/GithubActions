({
	firePaginationEvent : function(component,pageNumber) {
        var paginationEvt = component.getEvent("pagination");
        paginationEvt.setParams({
            "pageNumber":pageNumber,
        });
        paginationEvt.fire();
    },

    sendSelectedFeedID:function(component,event,feedID){   
        var selectedMessageEvt = component.getEvent("selectedFamilyLinkMessage");
        selectedMessageEvt.setParams({
            "directMessageFeedID":feedID
        });
        selectedMessageEvt.fire();
    }
})