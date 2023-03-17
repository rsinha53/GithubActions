({
    doInit : function(component, event, helper) {
	var len = 10;
        var buf = [],
            chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
            charlen = chars.length,
            length = len || 32;
            
        for (var i = 0; i < length; i++) {
            buf[i] = chars.charAt(Math.floor(Math.random() * charlen));
        }
        var GUIkey = buf.join('');
        component.set('v.dataTblId', GUIkey);
        helper.callCommentAction(component, event, helper);
        helper.checkBoxEnablement(component, event, helper);
    },
    openModel: function(component, event, helper) {
        debugger;
        component.set("v.OrsResultWrapperVariable.comment",'');
		component.set("v.isModalOpen", true);
        $A.util.removeClass(component.find("commentSection"), "none");
    },

    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
        component.set("v.value",[]);//Added by ACDC for defect US3068323
    },
    closeAlertModel: function(component, event, helper) {
        component.set("v.isAlertOpen", false);
    },
    OnClickValidation : function(component, event, helper){
            helper.validationCheck(component, event, helper);
        },
    submitDetails: function(component, event, helper) {
        // Set isModalOpen attribute to false
        //Add your code to call apex method or do some processing
        debugger;
        var valid = helper.onSubmitValidation(component, event, helper);
        if(valid){
        console.log(event.getSource().get("v.checked"));
        var addToService = component.find("addToService").get("v.checked");
        console.log(addToService);
        if(addToService){
            helper.sendCommentToOrs(component, event, helper);
        }
        else{
            helper.saveComments(component, event, helper);
        }

        component.set("v.isModalOpen", false);
        }else
        {
            return false;
        }
    },
    onCheckBoxClick : function(component, event, helper) {
        debugger
        var addToService = event.getSource().get("v.checked");
        console.log(addToService);
        if(addToService)
            component.set("v.isAlertOpen", true);
    },

    handleChange: function (component, event){
        var publiccomment = event.getParam("value");
        component.set("v.isPublicComment",publiccomment[0]);
    },

    onSubmit : function(component, event, helper) {
        event.preventDefault();
        var eventFields = event.getParam("fields");
        var field = 'ORS_Macess__c ';
        //if (eventFields.hasOwnProperty(field)) { //Coming False
        if((!eventFields.ORS_Macess__c) && (!eventFields.Macess__c)){
            helper.fireToast('Enter a valid ORS or Macess Number');
        }
        else {
      
            if((!!eventFields.ORS_Macess__c)) {
            component.set("v.issueId",eventFields.ORS_Macess__c.toString());
            }
            else if(!!eventFields.Macess__c){
            component.set("v.macessId",eventFields.Macess__c.toString())
             }
            
            //helper.callCommentAction(component, event, helper);
            var action = component.get("c.fetchCaseCommentsWrapper");
            var caseId = component.get("v.recordId");
            var issueId= component.get("v.issueId");
            console.log('issueId:'+issueId);
            action.setParams({
                "caseId":caseId,
                "issueId":issueId
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log(response.getReturnValue());
                if (state === "SUCCESS") {
                    if((!!eventFields.ORS_Macess__c) && response.getReturnValue().statusCode!=200){
                        helper.fireToast(response.getReturnValue().message);
                        component.set("v.mode","edit")
                        return false;
                    }else{
                        if((!!eventFields.ORS_Macess__c)){
                        component.set("v.mode","readonly");
                        }
                        component.set("v.OrsResultWrapperVariable", response.getReturnValue());
                        setTimeout(function(){
                            $(document).ready(function() {
                                $('#tableId').DataTable();
                            });
                        }, 500);

                        component.find('orsForm').submit(eventFields);
                    }

                }
                else{

                    //Throw error message for any error
                }
            });
            $A.enqueueAction(action);
        }


    },
    onSuccess : function(component, event, helper) {
		helper.refreshPage(component,event,helper);
    },
    onError : function(component, event, helper) {
    },
    onLoad : function(component, event, helper) {
    },
    /*doInit : function(component, event, helper) {
      helper.callCommentAction(component, event, helper);
      helper.checkBoxEnablement(component, event, helper);
  },
  openModel: function(component, event, helper) {
      component.set("v.isModalOpen", true);
  },

  closeModel: function(component, event, helper) {
      component.set("v.isModalOpen", false);
  },
  closeAlertModel: function(component, event, helper) {
      component.set("v.isAlertOpen", false);
  },
  submitDetails: function(component, event, helper) {
      // Set isModalOpen attribute to false
      //Add your code to call apex method or do some processing
      debugger;
      console.log(event.getSource().get("v.checked"));
      var addToService = component.find("addToService").get("v.checked");
      console.log(addToService);
      if(addToService){
          helper.sendCommentToOrs(component, event, helper);
      }
      else{
          helper.saveComments(component, event, helper);
      }
      component.set("v.isModalOpen", false);
  },
  onCheckBoxClick : function(component, event, helper) {
      debugger
      var addToService = event.getSource().get("v.checked");
      console.log(addToService);
      if(addToService)
          component.set("v.isAlertOpen", true);
  },

  handleChange: function (component, event){
  },
  onSubmit : function(component, event, helper) {
      var eventFields = event.getParam("fields");
      var field = 'ORS_Macess__c ';
      console.log('eventFields.ORS_Macess__c@@@='+eventFields.ORS_Macess__c);
      console.log('eventFields.hasOwnProperty(field)'+eventFields.hasOwnProperty(field));
      //if (eventFields.hasOwnProperty(field)) { //Coming False
      console.log('eventFields.ORS_Macess__c='+eventFields.ORS_Macess__c);
      if (!eventFields.ORS_Macess__c) {
          event.preventDefault();
          helper.fireToast('ORS Number is not valid.');
      }
      else{
          component.set("v.issueId",eventFields.ORS_Macess__c.toString());
          //helper.callCommentAction(component, event, helper);
          var action = component.get("c.fetchCaseCommentsWrapper");
          var caseId = component.get("v.recordId");
          var issueId= component.get("v.issueId");
          console.log('issueId:'+issueId);
          action.setParams({
              "caseId":caseId,
              "issueId":issueId
          });
          action.setCallback(this, function(response){
              var state = response.getState();
              console.log(response.getReturnValue());
              if (state === "SUCCESS") {
                  component.set("v.OrsResultWrapperVariable", response.getReturnValue());
                  setTimeout(function(){
                      $('#tableId').DataTable();
                  }, 500);
                  if(response.getReturnValue().statusCode!=200){
                      helper.fireToast(response.getReturnValue().message);
                      return false;
                  }

              }
              else{
                  //Throw error message for any error
              }
          });
          $A.enqueueAction(action);
      }
  },
  onSuccess : function(component, event, helper) {
  },
  onError : function(component, event, helper) {
  },
  onLoad : function(component, event, helper) {
  }*/
    displayCompleteComment : function(component, event, helper) {
      
         var comment ;
        var target = event.target;
        var dataEle = target.getAttribute("data-selected-Index");
        var Id = component.get("v.OrsResultWrapperVariable");
        if(dataEle){
         comment = Id.resultWrapper[dataEle].commment;
        }
        component.set("v.completeCaseComment",comment);
        component.set("v.completeCommentViewModalOpen",true);
},
    closeCommentModel : function(component, event, helper) {
         component.set("v.completeCommentViewModalOpen",false);
    }
});