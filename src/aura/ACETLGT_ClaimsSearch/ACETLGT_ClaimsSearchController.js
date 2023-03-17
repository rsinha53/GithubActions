({
 doInit: function(component, event, helper) {
  setTimeout(function() {
   helper.Call_Server_Side_Action(component, event, helper);
  }, 1);

  if (component.get("v.pageReference") != null) {
   var pagerefarance = component.get("v.pageReference");
   var memid = component.get("v.pageReference").state.c__memberid;
   var srk = component.get("v.pageReference").state.c__srk;
   var eid = component.get("v.pageReference").state.c__eid;
   var callTopic = component.get("v.pageReference").state.c__callTopic;
   var interaction = component.get("v.pageReference").state.c__interaction;
   var intId = component.get("v.pageReference").state.c__intId;
   var groupId = component.get("v.pageReference").state.c__gId;
   var uInfo = component.get("v.pageReference").state.c__userInfo;
   var hData = component.get("v.pageReference").state.c__hgltPanelData;
      var bookOfBusinessTypeCode = '';
      if(component.get("v.pageReference").state.c__bookOfBusinessTypeCode != undefined){
          bookOfBusinessTypeCode = component.get("v.pageReference").state.c__bookOfBusinessTypeCode;
      }
      console.log('bookOfBusinessTypeCode',bookOfBusinessTypeCode);
      component.set('v.bookOfBusinessTypeCode',bookOfBusinessTypeCode);
     if(component.get("v.pageReference").state.c__bobcode != undefined){
               component.set("v.bobcode",component.get("v.pageReference").state.c__bobcode);  
             }
      var searchByClaimNumber = component.get("v.pageReference").state.c__searchByClaimNumber;
      if(searchByClaimNumber!=null && searchByClaimNumber==true){
          component.set("v.ChangeSearch", true);
          component.set("v.Claim_Number", component.get("v.pageReference").state.c__claimNumber);
          //component.set("v.AutodocKey", component.get("v.pageReference").state.c__AutodocKey);
          var len = 10;
        var buf = [],
            chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
            charlen = chars.length,
            length = len || 32;
            
        for (var i = 0; i < length; i++) {
            buf[i] = chars.charAt(Math.floor(Math.random() * charlen));
        }
        var GUIkey = buf.join('');
        component.set("v.GUIkey",GUIkey);
        component.set("v.AutodocKey",component.get("v.pageReference").state.c__AutodocKey);
      }
      else{
   component.set('v.AutodocKey', intId + 'viewClaims');
      }
   //alert("======>>"+component.get('AutodocKey'));
   component.set('v.grpNum', groupId);
   component.set('v.int', interaction);
   component.set('v.intId', intId);
   component.set('v.eid', eid);
   component.set('v.memberid', memid);
   component.set('v.srk', srk);
   console.log('hData :: ' + hData);
   console.log('hData 2:: ' + JSON.stringify(hData));
   component.set("v.usInfo", uInfo);
   var hghString = pagerefarance.state.c__hgltPanelDataString;     
   hData = JSON.parse(hghString);
   component.set("v.highlightPanel", hData);
  }
  document.onkeypress = function(event) {
   if (event.key === "Enter") {
    var isvalid = helper.SearchFunctionValidationhelper(component, event);
    var isValidSearch = component.get("v.isValidSearch");
    if (isvalid && isValidSearch) {
     helper.Call_Server_Side_Action(component, event, helper);
    }
   }
  };

  if (intId != undefined) {
   var childCmp = component.find("cComp");
   var memID = component.get("v.memberid");
   var GrpNum = component.get("v.grpNum");
   var bundleId = hData.benefitBundleOptionId;
   childCmp.childMethodForAlerts(intId, memID, GrpNum, '', bundleId);
  }

 },
 onchange_Search_By: function(component, event, helper) {
  var ChangeSearch = component.get("v.ChangeSearch");
  if (ChangeSearch == true) {
   component.set("v.ChangeSearch", false);
  } else if (ChangeSearch == false) {
   component.set("v.ChangeSearch", true);
  }
     var ClaimnumbersearSearchsuccess = component.get("v.ClaimnumbersearSearchsuccess");
     if(ClaimnumbersearSearchsuccess){
         helper.ClearFunctionhelper(component, event, helper);
     }
 },
 onclick_Clear: function(component, event, helper) {
  helper.ClearFunctionhelper(component, event);
  var lgt_dt_Cmp = component.find("ClaimsSearchTable_auraid");
  lgt_dt_Cmp.clearTable_event();

 },
 onclick_Search: function(component, event, helper) {
 var emptyArray = [];
  component.set("v.encoderProArray",emptyArray);
 
  var pagenum = component.get("v.page_Number");
  var tabkey = component.get("v.AutodocKey");
  if (pagenum != undefined)
  	window.lgtAutodoc.storePaginationData(pagenum,tabkey);
  //alert("=====>"+ pagenum);
  //helper.ClearFunctionhelper(component, event);
  var lgt_dt_Cmp = component.find("ClaimsSearchTable_auraid");
  lgt_dt_Cmp.clearTable_event();

  //alert(pagenum);

  var isvalid = helper.SearchFunctionValidationhelper(component, event);
  var isValidSearch = component.get("v.isValidSearch");
  if (isvalid && isValidSearch) {

   helper.Call_Server_Side_Action(component, event, helper);
  }
 },
 onchange_DOS: function(component, event, helper) {
  var DateofService = component.get("v.Date_Of_Service");
  var End_Date_cmp = component.find('End_Date_Auraid');
  var Start_Date_cmp = component.find('Start_Date_Auraid');
  component.set("v.Start_Date", "");
  component.set("v.End_Date", "");
  Start_Date_cmp.set("v.required", false);
  Start_Date_cmp.setCustomValidity("");
  Start_Date_cmp.reportValidity();
  if (DateofService == "This Calender Year") {
   Start_Date_cmp.set("v.required", "false");
   End_Date_cmp.set("v.required", "false");
   component.set("v.Start_Date", (new Date()).getFullYear() + "-01-01");
   component.set("v.End_Date", (new Date()).getFullYear() + "-12-31");
   Start_Date_cmp.set("v.disabled", "true");
   End_Date_cmp.set("v.disabled", "true");
  } else if (DateofService == "Last Calender Year") {
   Start_Date_cmp.set("v.required", "false");
   End_Date_cmp.set("v.required", "false");
   component.set("v.Start_Date", new Date().getFullYear() - 1 + "-01-01");
   component.set("v.End_Date", new Date().getFullYear() - 1 + "-12-31");
   Start_Date_cmp.set("v.disabled", "true");
   End_Date_cmp.set("v.disabled", "true");
  } else if (DateofService == "Day") {
   component.set("v.Start_Date", "");
   Start_Date_cmp.set("v.disabled", false);
   Start_Date_cmp.set("v.required", "true");
  } else if (DateofService == "Date Range") {
   Start_Date_cmp.set("v.disabled", false);
   End_Date_cmp.set("v.disabled", false);
   Start_Date_cmp.set("v.required", "true");
   End_Date_cmp.set("v.required", "true");

  }
 },
 onchange_Start_Date: function(component, event, helper) {
 if(component.get("v.End_Date")!=null && component.get("v.End_Date")!=''){
 	component.find("End_Date_Auraid").reportValidity();
 }
  var DateofService = component.get("v.Date_Of_Service");
  var Start_Date_cmp = component.find('Start_Date_Auraid');
  if ((DateofService == "Day" && DateofService != "Date Range") || (DateofService != "Day" && DateofService == "Date Range")) {
   var today = new Date();
   var Start_Date = component.get("v.Start_Date");
   var inputStart_Date = new Date($A.localizationService.formatDate(Start_Date));
   if (today < inputStart_Date) {
    Start_Date_cmp.setCustomValidity("Error: Start Date must be less than or equal to today's date.");
    Start_Date_cmp.reportValidity();
    component.set("v.isValidSearch", "");
   } else {
    Start_Date_cmp.setCustomValidity("");
    Start_Date_cmp.reportValidity();
    component.set("v.isValidSearch", true);
   }

  }
 },
 onkeyup_TaxID: function(component, event, helper) {
  var TaxId = component.get("v.TaxID");
  var TaxId_cmp = component.find('TaxIdAuraid');
  TaxId_cmp.setCustomValidity("");
  TaxId_cmp.reportValidity();
  if (isNaN(TaxId)) {
   component.set("v.TaxID", "");
   TaxId_cmp.setCustomValidity("Error: Please Enter Numbers Only.");
   TaxId_cmp.reportValidity();
   component.set("v.isValidSearch", false);
  } else if (TaxId.length >= 10) {
   component.set("v.TaxID", TaxId.substring(0, 9));
   TaxId_cmp.setCustomValidity("Error: Enter 9 digits to search by Tax ID.");
   TaxId_cmp.reportValidity();
   component.set("v.isValidSearch", false);
  } else {
   TaxId_cmp.setCustomValidity("");
   TaxId_cmp.reportValidity();
   component.set("v.isValidSearch", true);

  }
 },
 onkeyup_Claim_Number: function(component, event, helper) {
  var Claim_Number_cmp = component.find('clmAuraid');

  var Claim_Number = component.get("v.Claim_Number");
  if (Claim_Number == null || Claim_Number == "" || Claim_Number == undefined) {
   Claim_Number_cmp.setCustomValidity("Error: You must enter a value.");
   Claim_Number_cmp.reportValidity();
  } else {
   Claim_Number_cmp.setCustomValidity("");
   Claim_Number_cmp.reportValidity();
  }
 },
 handle_dt_createdRow_Event: function(component, event, helper) {
  var row = event.getParam("row");
  var data = event.getParam("data");
  var encoderProArray = [];
  encoderProArray = component.get("v.encoderProArray");
  if(data.PrimaryDiagnosisCode!=null){
	  encoderProArray.push(data.PrimaryDiagnosisCode);
	  component.set("v.encoderProArray",encoderProArray);
	  console.log('section code added' + JSON.stringify(encoderProArray));
  }
  var dataIndex = event.getParam("dataIndex");
  var table_id = event.getParam("table_id");
  var memberid = component.get("v.memberid");
     var eid = component.get("v.eid");
  var srk = component.get("v.srk");
  $(row).children().first().html("<a id='lnkClaimId' href='javascript:void(0);'>" + data.ClaimID + "</a>");
  $(row).children().first().on('click', function(e) {
   var pagerefaranceobj = component.get("v.pageReference");
   var workspaceAPI = component.find("workspace");
   workspaceAPI.getEnclosingTabId().then(function(enclosingTabId) {
    workspaceAPI.openSubtab({
     parentTabId: enclosingTabId,
     pageReference: {
      "type": "standard__component",
      "attributes": {
       "componentName": "c__ACETLGT_ClaimDetail"
      },
      "state": {
       "c__claimID": data.ClaimID,
       "c__claimType": data.claimType,
       "c__cirrClaimID": data.SourceClaimId,
       "c__phi": data.PHIRestriction,
       "c__taxID": data.TaxID,
       "c__provider": data.Provider,
       "c__network": data.Network,
       "c__dosStart": data.ServiceStart,
       "c__dosEnd": data.ServiceEnd,
       "c__charged": data.TotalCharged,
       "c__paid": data.TotalPaid,
       "c__deductible": data.Deductible,
       "c__patientResp": data.patientResponsibility,
       "c__statusDate": data.claimEventStatusDate,
       "c__status": data.Status,
       "c__eventType": data.claimEvtType,
       "c__primaryDX": data.PrimaryDiagnosisCode,
       "c__memberID": memberid,
          "c__eid": eid,
       "c__srk": pagerefaranceobj.state.c__srk,
       "c__userInfo": component.get("v.userInfo"),
       "c__hgltPanelData": pagerefaranceobj.state.c__hgltPanelData,
       "c__int": component.get("v.int"),
       "c__intId": component.get("v.intId"),
       "c__gId": component.get("v.grpNum"),
       "c__fname": pagerefaranceobj.state.c__fname,
       "c__lname": pagerefaranceobj.state.c__lname,
       "c__va_dob": pagerefaranceobj.state.c__va_dob,
       "c__originatorval": pagerefaranceobj.state.c__originatorval,
       "c__userInfo": pagerefaranceobj.state.c__userInfo,
       "c__hgltPanelData": pagerefaranceobj.state.c__hgltPanelData,
       "c__hgltPanelDataString": pagerefaranceobj.state.c__hgltPanelDataString,
       "c__AutodocKey": component.get("v.AutodocKey"),
        "c__bobcode":component.get("v.bobcode")  
      }
     }
    }).then(function(response) {
     workspaceAPI.getTabInfo({
      tabId: response
     }).then(function(tabInfo) {
      workspaceAPI.setTabLabel({
       tabId: tabInfo.tabId,
       label: "Claim - " + data.ClaimID
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
  });
  $(row).children(":nth-child(4)").html("<a id='lnkClaimId' href='javascript:void(0);'>" + data.TaxID + "</a>");
  $(row).children(":nth-child(4)").on('click', function(e) {

   var pagerefaranceobj = component.get("v.pageReference");
   var workspaceAPI = component.find("workspace");
            var fName = component.get("v.pageReference").state.c__fname;
            var lName = component.get("v.pageReference").state.c__lname;
            var memGender = component.get("v.pageReference").state.c__memGender;
            var mName = component.get("v.pageReference").state.c__mName;
            var suffixName = component.get("v.pageReference").state.c__suffixName;
            var ssn;
            if (component.get("v.pageReference").state.c__SSN != undefined) {
                ssn = component.get("v.pageReference").state.c__SSN;    
            } 
   workspaceAPI.getEnclosingTabId().then(function(enclosingTabId) {
    workspaceAPI.openSubtab({
     parentTabId: enclosingTabId,
     pageReference: {
      "type": "standard__component",
      "attributes": {
       "componentName": "c__ACETLGT_ProviderLookup"
      },
      "state": {
       "c__taxID": data.TaxID,
       "c__memberid": memberid,
       "c__srk": pagerefaranceobj.state.c__srk,
       "c__userInfo": component.get("v.userInfo"),
       "c__hgltPanelData": component.get("v.highlightPanelData"),
       "c__int": component.get("v.int"),
       "c__intId": component.get("v.intId"),
       "c__originatorval": pagerefaranceobj.state.c__originatorval,
       "c__userInfo": pagerefaranceobj.state.c__userInfo,
       "c__hgltPanelData": pagerefaranceobj.state.c__hgltPanelData,
       "c__hgltPanelDataString": pagerefaranceobj.state.c__hgltPanelDataString,
       "c__callTopic": "Provider Lookup",
       "c__gId": component.get("v.grpNum"),
       "c__FromClaims": "true",
        "c__subSrk":pagerefaranceobj.state.c__subSrk,
       "c__fName": fName,
      "c__lName": lName,
        "c__mName": mName,
         "c__memGender": memGender,
         "c__suffixName": suffixName,
           "c__SSN":ssn
      }
     }
    }).then(function(response) {
     workspaceAPI.getTabInfo({
      tabId: response
     }).then(function(tabInfo) {
      workspaceAPI.setTabLabel({
       tabId: tabInfo.tabId,
       label: "Provider Lookup"
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
  });
 },
 handle_dt_callback_Event: function(component, event, helper) {
  var settings = event.getParam("settings");
  var lgt_dt_table_ID = event.getParam("lgt_dt_table_ID");
  var Responce = event.getParam("Responce");
 },
 handle_dt_initComplete_Event: function(component, event, helper) {
  var settings = event.getParam("settings");
 },
 handle_dt_pageNum_Event: function(component, event, helper) {
        try{
  var pgnum = event.getParam("pageNumber");
  var encoderProArray = component.get("v.encoderProArray");
  var sectionVsCodes = new Object();
  sectionVsCodes["claimItem"] = encoderProArray;
  component.set("v.page_Number", pgnum);
  console.log('section vs codes ' + JSON.stringify(sectionVsCodes));
  
  var EPAction = component.get("c.getEncoderProDescription");
                        EPAction.setParams({
                            data: JSON.stringify(sectionVsCodes)
                        });
                        EPAction.setCallback(this, function(response) {
                            //map encoder pro codes
                            var state = response.getState();
                            console.log('encoder pro state' + state);
                            if (state === "SUCCESS") {
                                var resultString = response.getReturnValue();
                                console.log('encoder pro results:' + resultString);
                                var results = JSON.parse(resultString);
                                var hoverTimeout;
                                $("td.encoder-pro-code").mouseenter(function(event) {
                                    var codeArray = Object.keys(results.Response);
if(codeArray!= undefined && codeArray.length>0){
                                    console.log(codeArray);
                                    for (var i = 0; i < codeArray.length; i++) {
                                        var currentCode = codeArray[i];
                                        if ($(this).text() == currentCode) {
                                            var toolTip = document.createElement("div");
                                            $(toolTip).addClass("eptooltip-modal");
                                            var descArray = results.Response[currentCode];
                                            var descHtml = "<ul style = 'padding:1%'>"
                                            for (var j = 0; j < descArray.length; j++) {
                                                if (JSON.stringify(descArray[j]).indexOf(":") > 0)
                                                    descHtml = descHtml + "<li>" + JSON.stringify(descArray[j]).slice(JSON.stringify(descArray[j]).indexOf(":") + 2, JSON.stringify(descArray[j]).lastIndexOf("\"")) + "</li>";
                                                else
                                                    descHtml = descHtml + "<li>" + JSON.stringify(descArray[j]).slice(1, JSON.stringify(descArray[j]).lastIndexOf("\"")) + "</li>";

                                            }
                                            descHtml = descHtml + "</ul>";
                                            $(toolTip).html(descHtml);
                                            $(toolTip).css("word-wrap","break-word !important");
                                            $(this).append(toolTip);
                                            var posX = event.clientX + 10 + 'px';
                                            var posY = event.clientY + 20 + 'px';
                                            console.log(posX + " :: " + posY);
                                            $(toolTip).show();
                                            if (event.relatedTarget != null && event.relatedTarget.tagName == 'DIV') {
                                                $(toolTip).hide();
                                            }
                                            $(toolTip).css("top", posY);
                                            $(toolTip).css("left", posX);
                                        }
                                    }
                        }


                                });
                                $("td.encoder-pro-code").mouseleave(function() {
                                    $(this).find(".eptooltip-modal").remove();
                                });
                            }


                        });
                                                    $A.enqueueAction(EPAction);
        }catch(e){
            helper.logError(component,e);
        } 
                        
  
  
 }
})