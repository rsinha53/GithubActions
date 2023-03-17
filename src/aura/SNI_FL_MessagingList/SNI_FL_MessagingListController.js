({
    doInit : function(component, event, helper) {
       
    },
    
    getSelectedRecord:function(component,event,helper){       
        var feedElementIDValue = '';
        var selectedItem = event.currentTarget;
        var ids = selectedItem.dataset.id;
        
        var Elements = component.find('vertical-tab');
        
        var length = Elements.length;
        if(length == undefined){
            
            var val = Elements.getElement().getAttribute('data-id');
            var feedElementID = Elements.getElement().getAttribute('data-feedelement-id');
            if(val != ids){
                $A.util.removeClass(Elements, "current");
                $A.util.addClass(Elements, "border-class");
            } else {
                feedElementIDValue = feedElementID;
                
                $A.util.addClass(Elements,"current");
                $A.util.removeClass(Elements, "border-class");
                
                //set the selected feedId in event and fire the event to SNI_FL_AgentView.cmp
                component.set("v.currentId", feedElementIDValue); 
                helper.sendSelectedFeedID(component,event,feedElementIDValue);
            }          
            
        }else{
            
            for (var i = 0; i < Elements.length; i++) {
                var val = Elements[i].getElement().getAttribute('data-id');
                var feedElementID = Elements[i].getElement().getAttribute('data-feedelement-id');
                if(val != ids){
                    $A.util.removeClass(Elements[i], "current");
                    $A.util.addClass(Elements[i], "border-class");
                } else {
                    feedElementIDValue = feedElementID;
                    
                    $A.util.addClass(Elements[i],"current");
                    $A.util.removeClass(Elements[i], "border-class");
                    
                    //set the selected feedId in event and fire the event to SNI_FL_AgentView.cmp
                    component.set("v.currentId", feedElementIDValue); 
                    helper.sendSelectedFeedID(component,event,feedElementIDValue);
                }
            }
        }
        
    },
    
    
    //Handle Next pagination
    handleNext:function(component,event,helper){
        
        var pageNumber = component.get("v.pageNumber");
        pageNumber++;
        
        helper.firePaginationEvent(component,pageNumber);

    },
    
    //Handle Previouse pagination
    handlePrevious:function(component,event,helper){
        
        var pageNumber = component.get("v.pageNumber");
        pageNumber--;
        
        helper.firePaginationEvent(component,pageNumber);

    },
    
    //Added by Sameera
    setisFamilyLevel:function(component,event,helper){
        component.set("v.isFamilyLevel",event.getParam("value"));
    },
    
    //CLear any selected messages
    clearSelectedMessages:function(component,event,helper){
        var Elements = component.find('vertical-tab');
        if(Elements.length == undefined){
            $A.util.removeClass(Elements, "current");
            $A.util.addClass(Elements[i], "border-class");
        }else{
            for (var i = 0; i < Elements.length; i++) {
                $A.util.removeClass(Elements[i], "current");
                $A.util.addClass(Elements[i], "border-class");
            }
        }
    }
    
})