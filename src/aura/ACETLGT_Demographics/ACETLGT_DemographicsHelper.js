({
  showResults: function(component, event, helper) {
    console.log('Inside show Resultss');

    //helper.showSpinner2(component,event,helper);
    var result = true;
    var action = component.get("c.getSearchResults");
    var identifier = component.get("v.identifier");
    var identifierType = component.get("v.identifierType");
    console.log('identifier::-->' + identifier);
    action.setStorable();
    if (result && identifier != undefined) {
      //component.set("v.Memberdetail");

      // Setting the apex parameters
      action.setParams({
        srk: identifier,
        identifier: identifierType
      });

      //Setting the Callback
      action.setCallback(this, function(a) {
        //get the response state
        var state = a.getState();
        console.log('----state---' + state);
        //check if result is successfull
        if (state == "SUCCESS") {
          var result = a.getReturnValue();
          console.log('---Demo---result--------' + result);
          if (!$A.util.isEmpty(result) && !$A.util.isUndefined(result)) {
            if (!$A.util.isEmpty(result.resultWrapper) && !$A.util.isUndefined(result.resultWrapper)) {
              var address = result.resultWrapper;
              var memberDetail = {};
              memberDetail.Addresses = result.resultWrapper.Addresses;
              component.set("v.Memberdetail", memberDetail);
              var tempAddress = component.get("v.Memberdetail.Addresses");
              var city, zip;
              if (tempAddress != undefined) {
                for (var i = 0; i < tempAddress.length; i++) {
                  if (tempAddress[i].AddressType == 'Home') {
                    city = tempAddress[i].City;
                    zip = tempAddress[i].Zip;
                  }
                }
              }
              var appEvent = component.getEvent("getAddressEvent");

              appEvent.setParams({
                "city": city,
                "zip": zip
              });
              appEvent.fire();
              console.log('=======Email=====>>' + component.get("v.Memberdetail.Email"));
            }
          }
        } else if (state == "ERROR") {
          component.set("v.Memberdetail");
        }
        component.set("v.Spinner", false);
        //helper.hideSpinner2(component,event,helper);
      });

      //adds the server-side action to the queue        
      $A.enqueueAction(action);
    }
    //console.log('-result-->'+ result);
    //return result;
  },
  hideSpinner2: function(component, event, helper) {
    component.set("v.Spinner", false);
    console.log('Hide');
  },
  // this function automatic call by aura:waiting event  
  showSpinner2: function(component, event, helper) {
    // make Spinner attribute true for display loading spinner 
    component.set("v.Spinner", true);
    console.log('show spinner in Demo');
  },
  displayToast: function(title, message) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      "title": title,
      "message": message,
      "type": "error",
      "mode": "dismissible",
      "duration": "10000"
    });
    toastEvent.fire();
  },

  refreshHelper: function(component, event, helper) {
    var pageReference = component.get("v.pageReferenceobj");
    var queryString = window.location.href;
    const urlParams = new URLSearchParams(queryString);
    const lastName = urlParams.get('c__lastName');
    const firstName = urlParams.get('c__firstName');
    const grpnum = urlParams.get('c__grpnum');
    const Idstr = urlParams.get('c__Id');
    var Id;
    if(!$A.util.isUndefinedOrNull(Idstr)){
    Id = Idstr.substr(0, Idstr.length - 2) + '00';
      }
    component.set("v.subId", Id);
    const subjectdob = urlParams.get('c__subjectdob');
    if(lastName && firstName && grpnum && Id && subjectdob){
    var action = component.get('c.fetchDemographicDetails');
    action.setParams({
      lastName: lastName,
      firstName: firstName,
      policyNumber: grpnum,
      subscriberId: Id,
      dob: subjectdob
    });
    action.setCallback(this, function(result) {
      if (result.getState() == 'SUCCESS') {
        var resultJSON = JSON.parse(result.getReturnValue());
        for (var obj in resultJSON.telephones) {
          resultJSON.telephones[obj].PhoneNumber = resultJSON.telephones[obj].PhoneNumber.substring(0, 3) + '-' +
            resultJSON.telephones[obj].PhoneNumber.substring(3, 6) + '-' +
            resultJSON.telephones[obj].PhoneNumber.substring(6, 10);
        }
        component.set('v.Phones', resultJSON.telephones);
        component.set('v.Email', resultJSON.email);
      }

    });
    $A.enqueueAction(action);
    }
  },
  launchepmpHelper: function(component, event, helper) {
    var queryString = window.location.href;
    const urlParams = new URLSearchParams(queryString);
    const lastName = urlParams.get('c__lastName');
    const firstName = urlParams.get('c__firstName');
    const grpnum = urlParams.get('c__grpnum');
    const Idstr = urlParams.get('c__Id');
    var Id;
    if(!$A.util.isUndefinedOrNull(Idstr)){
    Id = Idstr.substr(0, Idstr.length - 2) + '00';
      }
    const subjectdob = urlParams.get('c__subjectdob');
    var Unencryptedvalue = 'first_nm=' + firstName + '&lst_nm=' + lastName + '&policy_nbr=' + grpnum + '&subscriber_id=' + Id;
    console.log('Unencryptedvalue without dob EPMP--->' + Unencryptedvalue);
    var action = component.get("c.GetEncryptedValue");
    action.setParams({
      tempquerystring: Unencryptedvalue,
      dob: subjectdob
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        localStorage.setItem("EPMP_URL_" + Id, response.getReturnValue());
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(enclosingTabId) {
          workspaceAPI.openSubtab({
            parentTabId: enclosingTabId,
            pageReference: {
              "type": "standard__component",
              "attributes": {
                "componentName": "c__ACETLGT_epmp_tab"
              },
              "state": {
                "c__memberid": Id
              }
            },
            focus: true
          }).then(function(response) {
            component.set("v.subtabId", response);
            workspaceAPI.getTabInfo({
              tabId: response
            }).then(function(tabInfo) {
              workspaceAPI.setTabLabel({
                tabId: tabInfo.tabId,
                label: 'Preferences'
              });
              workspaceAPI.setTabIcon({
                tabId: tabInfo.tabId,
                icon: "standard:people",
                iconAlt: "Member"
              });
            });
          }).catch(function(error) {
            console.log(error);
          });
        });
      } else if (state === "INCOMPLETE") {}

    });
    $A.enqueueAction(action);
  }
})