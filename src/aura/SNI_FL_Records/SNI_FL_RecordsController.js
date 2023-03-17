({ 
    clickOnDocuments : function(component, event, helper) {
        component.set("v.displayedTab", "documentsSec");
        helper.checkIfMobileDevice(component,event,helper);
    },
      
    clickOnRxMed : function(component, event, helper) {
        component.set("v.displayedTab", "rxMedSec");
        helper.checkIfMobileDevice(component,event,helper);
    },
  
    clickOnContacts : function(component, event, helper) {
        component.set("v.displayedTab", "contactsSec");
        helper.checkIfMobileDevice(component,event,helper);
    }, 
      clickOnFamilysec : function(component, event, helper) {
        component.set("v.selectedTab", "familysec");
        component.set("v.isFamilySec", true);
        helper.checkIfMobileDevice(component,event,helper);
    }, 
    clickOnMembsec : function(component, event, helper) {
        component.set("v.selectedTab", "membsec");
        component.set("v.isFamilySec", false);
        helper.checkIfMobileDevice(component,event,helper);
    }, 
      closeContactModal: function(component,event,helper){
          component.set('v.buttonClicked','');
      },
      closeRxMedModal:function(component,event,helper){
          component.set('v.buttonClicked','');
      },
      handleChange: function(component, event, helper){
          var selectedOptVal = event.getParam("value");

          console.log('---opt---'+selectedOptVal);
          var options = component.get("v.options"), 
              val = selectedOptVal,
              index, selectedlabel;
              options.forEach(function(v,i,a) { 
                  if(v.value == val) {
                      index = i;
                  }
              });
          selectedlabel = options[index].label;
          console.log('---selectedlabel---'+selectedlabel);
          component.set('v.recordId',selectedOptVal);
          component.set('v.recordName',selectedlabel);
          component.set('v.isFileSec',true);
          helper.UploadFinished(component,event,helper);
      },
      openNewRecord: function(component, event, helper){
          var selTab = component.get('v.displayedTab');
          if(selTab == 'documentsSec'){
              component.set('v.buttonClicked','newDocument');
              component.set("v.newDocModalOpen", true);
              var rcheck = component.get("v.recursiveCheck");
              if(rcheck){
                  helper.fetchmembers(component,event,helper);
              }
          } else if(selTab == 'contactsSec'){
              component.set('v.buttonClicked','newContact');
              var newContact = {Name:'',Phone__c:'',Email__c:'',Relationship__c:'',Address__c:'',Status__c:'Active',Family__c:''}
              component.set('v.selectedContact', newContact);
          } else if(selTab == 'rxMedSec'){
              component.set('v.buttonClicked','newRxMed');
              var newRxMed = {Name:'',Pill_Size__c:'',Directions__c:'',Rx_Number__c:'',Refill_Date__c:'', Pharmacy__c:'',Pharmacy_Phone_Number__c:'',Status__c:'Active',Family__c:''}
              component.set('v.selectedRxMed', newRxMed);
          }
          
      },
      closeWarning: function(component, event, helper) {
          component.set("v.newDocModalOpen", false);
          component.set('v.isFileSec',false);
      },
      handleUploadFinished: function(component, event, helper) {
          helper.UploadFinished(component,event,helper);
      },
      saveContactRecord: function(component, event, helper){
          try {
              var selectedCon = component.get('v.selectedContact');
              if(selectedCon.Phone__c == undefined ){
                  selectedCon.Phone__c = '';
              }
              if(selectedCon.Address__c == undefined ){
                  selectedCon.Address__c = '';
              }
              if(selectedCon.Relationship__c == undefined ){
                  selectedCon.Relationship__c = '';
              }
              if(selectedCon.Email__c == undefined ){
                  selectedCon.Email__c = '';
              }
              
              if(helper.validateContactFields(component,event,helper)){
                  selectedCon.Name = selectedCon.Name.trim();
                  var action = component.get("c.addContacts");
                  action.setParams({
                      "selContactName": selectedCon.Name,
                      "selContactEmail": selectedCon.Email__c,
                      "selContactPhone": selectedCon.Phone__c,
                      "selContactAddress": selectedCon.Address__c,
                      "selContactRelationship": selectedCon.Relationship__c,
                      "familyId": component.get("v.familyId")
                  });
                  action.setCallback(this, function (r) {
                      if(r.getState() === 'SUCCESS') {
                          var storedResponse = r.getReturnValue();
                          if(storedResponse!=null) {
                              if(!storedResponse.ErrorOccured){

                                  component.set("v.selectedContact",storedResponse.selContact);
                                  //helper.fetchContacts(component,event,helper);
                                  component.set('v.buttonClicked','');
                                  helper.fetchContacts(component, event, helper);
                              }else {
                                  var urlEvent = $A.get("e.force:navigateToURL");
                                  urlEvent.setParams({
                                      url: "/error"
                                  });
                                  urlEvent.fire();
                              }
                          }
                      }
                  });
                  $A.enqueueAction(action);
              }
          } catch (ex) {

          }	
      },
      fetchFamilyContacts: function(component, event, helper){
      },
      saveRxMedRecords : function(component, event, helper){
          try {
              var selectedRxMed = component.get('v.selectedRxMed');
              if(selectedRxMed.Pill_Size__c == undefined ){
                  selectedRxMed.Pill_Size__c = '';
              }
              if(selectedRxMed.Directions__c == undefined ){
                  selectedRxMed.Directions__c = '';
              }
              if(selectedRxMed.Rx_Number__c == undefined ){
                  selectedRxMed.Rx_Number__c = '';
              }
              if(selectedRxMed.Refill_Date__c == undefined || selectedRxMed.Refill_Date__c == ''){
                  selectedRxMed.Refill_Date__c = null;
              }
              if(selectedRxMed.Pharmacy__c == undefined ){
                  selectedRxMed.Pharmacy__c = '';
              }
               if(selectedRxMed.Pharmacy_Phone_Number__c == undefined ){
                  selectedRxMed.Pharmacy_Phone_Number__c = '';
              }
              if(helper.validateRxMedsFields(component,event,helper)){
                  selectedRxMed.Name = selectedRxMed.Name.trim();
                  var action = component.get("c.addRxMeds");
                  action.setParams({
                      "selRxName": selectedRxMed.Name,
                      "selPillSize": selectedRxMed.Pill_Size__c,
                      "selDirections": selectedRxMed.Directions__c,
                      "selRxNum": selectedRxMed.Rx_Number__c,
                      "selRefillDate": selectedRxMed.Refill_Date__c,
                      "selPharmacy": selectedRxMed.Pharmacy__c,
                       "selPharmacyPhone": selectedRxMed.Pharmacy_Phone_Number__c,
                      "familyId": component.get("v.familyId")
                  });
                    action.setCallback(this, function (r) {
                      
                      if(r.getState() === 'SUCCESS') {
                          var storedResponse = r.getReturnValue();
                          if(storedResponse!=null) {
                              
                              if(!storedResponse.ErrorOccured){
                                  
                                  component.set("v.selectedContact",storedResponse.RxMed);
                                     component.set('v.buttonClicked','');
                                  helper.fetchRxMed(component, event, helper);
                              }else {
                                  
                                  var urlEvent = $A.get("e.force:navigateToURL");
                                  urlEvent.setParams({
                                      url: "/error"
                                  });
                                  urlEvent.fire();
                              }
                          }
                      }
                  });
                  $A.enqueueAction(action);
              }
          } catch (ex) {
              
          }	
      },
      
  });