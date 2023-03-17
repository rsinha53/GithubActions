({    
    rerender : function(component, helper){
        this.superRerender();
        
       setTimeout(function(){  
            var directMessage = component.get('v.selectedDirectMessage');
           
            if (!directMessage || directMessage.flMessage.isRead){
                return;
            } else if(component.get("v.isFamilyLevel") && (component.get("v.logedUserID") != component.get("v.accountOwner"))){
                return;
            }

            var directMsg = component.get("v.lstDirectMessages");

            if(directMsg){
                for(let i = 0; i < directMsg.length; i++){
                    if(directMsg[i].directMessageFeed.directMessageFeedID == directMessage.flMessage.feedId){               
                        directMsg[i].flMessage.isRead = true;
                        var action = component.get("c.changeReadStatus");
                        action.setParams({
                            "isRead":true,
                            "feedID":directMessage.flMessage.feedId
                        });                
                        action.setCallback(this,function(response){
                            var result = response.getReturnValue();
                            if(result == true) {
                                component.set("v.lstDirectMessages", directMsg);
                            }
                        });
                        
                        $A.enqueueAction(action); 
                    } 
                }
            }
            
       }, 3000);

    },
    
})