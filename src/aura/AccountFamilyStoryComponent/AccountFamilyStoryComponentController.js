({
    doInit: function(component, event, helper) {
        //helper.preventLeaving();
      console.log("entered*************");
        component.set('v.showHide', false);
		var action1 = component.get("c.getRestrictionData");
         action1.setParams({
             "accId": component.get("v.recordId")
        });
        action1.setCallback(this, function(response1) {
             console.log("entered*************-----123");
            var state1 = response1.getState();
            console.log('state1-------'+state1);
            console.log('response1-------'+response1);
            if(state1 == 'SUCCESS') {
                var result1 = response1.getReturnValue();
                console.log('response1-------'+response1);
                if(result1 != '' && result1){
                  component.set('v.showHide', true);
                }
            }

        });
         $A.enqueueAction(action1);

    },
    afterSave: function(component, event, helper) {
        //helper.allowLeaving();
    },
    handleShowModal: function(component) {
        var recordid = component.get("v.recordId");
        //var lName = component.get("v.LastName");
        //alert("Please fill Family Story");
        $A.createComponent("c:SNIOverlayLibraryModal", {},
                           function(content, status) {
                               if (status === "SUCCESS") {
                                   var modalBody = content;
                                   component.find('overlayLib').showCustomModal({
                                       header: "Do you really want to close this tab? Family Story is not filled!!!",
                                       body: modalBody,
                                       showCloseButton: false,
                                       closeCallback: function(ovl) {
                                           console.log('Overlay is closing');
                                       }
                                   }).then(function(overlay){
                                       console.log("Overlay is made");
                                   });
                               }
                           });
    },
    handleApplicationEvent : function(cmp, event) {
        var message = event.getParam("message");
        alert('@@@ ==> ' + message);
        if(message == 'Ok')
        {
          alert("Closing the window");
        }
       else if(message == 'Cancel')
      {
         alert("Not Closing the window");
      }
    },
    onSubmit : function(component, event, helper) {
        var eventFields = event.getParam("fields");
        var field = 'Family_Story__c';
        if (eventFields.hasOwnProperty(field)) {
            if ( !eventFields.Family_Story__c ) {
                event.preventDefault();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!!",
                    "message": "Please enter required information in the Family Background section.",
                    "type": "error"
                });
                toastEvent.fire();
            }
          }
     },

     onTabClosed : function(component, event, helper) {
       //event.stopPropagation();
       //confirm("Do you really want to close this tab? Family Story is not filled!!!");

        var action = component.get("c.getAtccountDtl");
        action.setParams({ accId: component.get("v.recordId")});
        action.setCallback(this,$A.getCallback(function(response1)
         {
         console.log('state'+response1);
         var state = response1.getState();
         if (state === "SUCCESS")
         {
             var result= response1.getReturnValue();
             if(!result){
                 var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!!!",
                    "message": "Please enter required information in the Family Background section.",
                    "type": "Error"
                });
                toastEvent.fire();
             }
         }
             else if (state === "ERROR")
             {
                 var errors = response1.getError();
                 console.log(errors);
             }
         }
         ));
        $A.enqueueAction(action);

    },

    onCancel : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Info!!!",
                    "message": "Please enter required information in the Family Background section.",
                    "type": "warning"
                });
                toastEvent.fire();
     }
})