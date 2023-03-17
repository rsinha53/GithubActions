({
 ClearFunctionhelper: function(component, event,helper) {
  var Claim_Number_cmp = component.find('clmAuraid');
  var Search_By = component.find('Search_By_ID').get("v.value");
  if (Search_By == "Claim_Number") {
   component.set("v.Claim_Number", "");
  } else {
   component.set("v.TaxID", "");
   component.set("v.Authorization_Number", "");
   component.set("v.Referral_Number", "");
   component.find('Deductible_Only_AuraId').set("v.checked", false);
   component.set("v.Date_Of_Service", "All");
   component.set("v.Provider_Type", "All");
   component.set("v.Network_Status", "All");
   component.set("v.Encounters","All");
   var TaxId_cmp = component.find('TaxIdAuraid');
   TaxId_cmp.setCustomValidity("");
   TaxId_cmp.reportValidity();
  }
 },
 SearchFunctionValidationhelper: function(component, event,helper) {
  try{
     var Search_By= component.find("Search_By_ID").get("v.value");
     var Claim_Number_cmp; 
     
     if(component.find('clmAuraid') != null || component.find('clmAuraid') != '' || component.find('clmAuraid') != undefined)
      	Claim_Number_cmp = component.find('clmAuraid');
  	 else 
        Claim_Number_cmp = '';
      
     if ( Search_By == "Claim_Number") {
        var Claim_Number = component.get("v.Claim_Number");
       	if ($A.util.isEmpty(Claim_Number) || $A.util.isUndefined(Claim_Number)) {
            Claim_Number_cmp.setCustomValidity("Error: You must enter a value.");
            Claim_Number_cmp.reportValidity();
            return false;
       } else {
        Claim_Number_cmp.setCustomValidity("");
        Claim_Number_cmp.reportValidity();
        return true;
       }
      } else if (Search_By == "Subject") {
       var TaxId_cmp,TaxId,Start_Date,End_Date;
       
       TaxId_cmp = component.find('TaxIdAuraid');
       
       if(component.get("v.TaxID") !=null || component.get("v.TaxID") != '' || component.get("v.TaxID") != undefined)
          TaxId  = component.get("v.TaxID");
       else
          TaxId = '';
          
       var today = new Date();
       var Start_Date_cmp = component.find('Start_Date_Auraid');
       var End_Date_cmp = component.find('End_Date_Auraid');
       
       if(component.get("v.Start_Date") !=null || component.get("v.Start_Date") !='' || component.get("v.Start_Date") !=undefined)
          Start_Date = component.get("v.Start_Date");
       else
          Start_Date = '';
          
       if(component.get("v.End_Date") != null || component.get("v.End_Date") != '' || component.get("v.End_Date") != undefined)
       	  End_Date = component.get("v.End_Date");
       else 
          End_Date = '';
          
       var inputStart_Date = new Date($A.localizationService.formatDate(Start_Date));
       var DateofService = component.get("v.Date_Of_Service");
       if ((DateofService == "Date Range") && ($A.util.isEmpty(Start_Date) || $A.util.isUndefined(Start_Date))) {
          Start_Date_cmp.setCustomValidity("Error: You must enter a value.");
          Start_Date_cmp.reportValidity();
          return false;
       }
       if (DateofService == "Day" && DateofService != "This Calender Year") {
        if (today < inputStart_Date) {
          Start_Date_cmp.setCustomValidity("Error: Start Date must be less than or equal to today's date.");
          Start_Date_cmp.reportValidity();
          return false;
        }
        if (Start_Date == '' || Start_Date == null || Start_Date == undefined) {
          Start_Date_cmp.setCustomValidity("Error: You must enter a value.");
          Start_Date_cmp.reportValidity();
          return false;
        }
       }
       if ((component.get("v.Date_Of_Service") == "Date Range") && (End_Date == '' || End_Date == null || End_Date == undefined)) {
        End_Date_cmp.set("v.required", "true");
        End_Date_cmp.setCustomValidity("Error: You must enter a value.");
        End_Date_cmp.reportValidity();
        return false;
      }
       if (TaxId != null && TaxId != '' && TaxId != undefined && TaxId.length < '9') {
            TaxId_cmp.setCustomValidity("Error: Tax ID Should be min 10 digits");
            TaxId_cmp.reportValidity();
            component.set("v.isValidSearch", false);
       } else {
          TaxId_cmp.setCustomValidity("");
          TaxId_cmp.reportValidity();
          component.set("v.isValidSearch", true);
          return true;
       }
      }
     }catch(e){
       console.log(e);;
     }
 },
 Call_Server_Side_Action: function(component, event,helper) {
        try{
  component.set("v.responce", "");
  component.set("v.Loadingspinner", true);
  var action = component.get("c.getClaimsSearchResults");
  var Search_By = component.find('Search_By_ID').get("v.value");
  var claimnumber = component.get("v.Claim_Number");
  var DateofService = component.get("v.Date_Of_Service");
  var Network_Status = component.get("v.Network_Status");
  var Start_Date = component.get("v.Start_Date");
  var End_Date = component.get("v.End_Date");
  var Provider_Type = component.get("v.Provider_Type");
  var Deductible = '';
  var memid = component.get("v.pageReference").state.c__memberid;
  var eid  = component.get("v.pageReference").state.c__eid;
     var pageparams = component.get("v.pageReference");
  var Authorization_Number = component.get("v.Authorization_Number");
  var Referral_Number = component.get("v.Referral_Number");
  var Encounters = component.get("v.Encounters");
     debugger;
  if (Search_By == "Subject") {
   if (DateofService == "All") {
    Start_Date = "1939-10-11";
    End_Date = "9999-10-11";
   } else if (DateofService == "Day") {
    End_Date = Start_Date;
   }
   if (Network_Status == "All") {
    Network_Status = '';
   }
   if (Provider_Type == "All") {
    Provider_Type = '';
   }
   if (component.find('Deductible_Only_AuraId').get("v.checked")) {
    Deductible = "Y";
   } else {
    Deductible = '';
   }
   if ($A.util.isEmpty(Authorization_Number) || $A.util.isUndefined(Authorization_Number)) {
    Authorization_Number = '';
   }
   if ($A.util.isEmpty(Referral_Number) || $A.util.isUndefined(Referral_Number)) {
    Referral_Number = '';
   }
  }
  if (Search_By != "Subject") {
	     component.set("v.ClaimnumbersearSearchsuccess",true);
   action.setParams({
    claimnumber: component.get("v.Claim_Number"),
    MemberId: memid,
    EID: eid
   });
  } else {
   action.setParams({
    taxid: component.get("v.TaxID"),
    inNetwork: Network_Status,
    startdate: Start_Date,
    enddate: End_Date,
    strdeductible: Deductible,
    AuthorizationNumber: Authorization_Number,
    ReferralNumber: Referral_Number,
    providers: Provider_Type,
    MemberId:memid,
    EID: eid,
    Encounters:Encounters
   });
  }
  action.setCallback(this, function(response) {
   component.set("v.Loadingspinner", false);
   // var elmnt = document.getElementById("scrollLocation");
   // elmnt.scrollIntoView(true);
   var state = response.getState();
   if (state === "SUCCESS") {
    //alert("======1--");
    var responce = JSON.parse(response.getReturnValue().responce);
    helper.processdatatable(component,event,helper,responce);
   } else if (state === "ERROR") {
    var errors = response.getError();
    if (errors) {
     if (errors[0] && errors[0].message) {
       console.log("Error message: " +
       errors[0].message);
     }
    } else {
     console.log("Unknown error");
    }
   }
  });
  $A.enqueueAction(action);
        }catch(e){
            helper.logError(component,e);
        } 
 },
    processdatatable:function(component,event,helper,responce){
     var lgt_dt_DT_Object = new Object();
    lgt_dt_DT_Object.lgt_dt_PageSize = 50;
    lgt_dt_DT_Object.lgt_dt_StartRecord =1;
    lgt_dt_DT_Object.lgt_dt_PageNumber=1;
    lgt_dt_DT_Object.lgt_dt_SortBy = '6';
    lgt_dt_DT_Object.lgt_dt_SortDir = 'desc';
    lgt_dt_DT_Object.lgt_dt_serviceName = 'ACETLGT_FindClaimWebservice';
       lgt_dt_DT_Object.lgt_dt_columns = JSON.parse('[{"title":"Claim Number","defaultContent":"","data":"ClaimID","className":"ClaimID_clm_cls","type": "string" },{"title":"Cirrus Claim ID","defaultContent":"","data":"SourceClaimId","className":"SourceClaimId_clm_cls","type": "string"},{"title":"PHI","defaultContent":"","data":"PHIRestriction","type": "string"},{"title":"Tax ID","defaultContent":"","data":"TaxID","type": "string"},{"title":"Provider","defaultContent":"","data":"Provider","type": "string"},{"title":"Network","defaultContent":"","data":"Network","type": "string"},{"title":"DOS Start","defaultContent":"","data":"ServiceStart","type": "date"},{"title":"DOS End","defaultContent":"","data":"ServiceEnd","date": "string"},{"title":"Charged","defaultContent":"","data":"TotalCharged","type": "number"},{"title":"Paid","defaultContent":"","data":"TotalPaid","type": "number"},{"title":"Deductible","defaultContent":"","data":"Deductible","type": "number"},{"title":"Patient Resp","defaultContent":"","data":"patientResponsibility","type": "number"},{"title":"Status Date","defaultContent":"","data":"claimEventStatusDate","type": "string"},{"title":"Status","defaultContent":"","data":"Status","type": "string"},{"title":"Encounter","defaultContent":"","data":"claimEncounterIndicator","type": "string"},{"title":"Event Type","defaultContent":"","data":"claimEvtType","type": "string"},{"title":"Primary Dx ","defaultContent":"","data":"PrimaryDiagnosisCode","className":"encoder-pro-code","type": "string"}]');

    lgt_dt_DT_Object.lgt_dt_serviceObj = responce;
    lgt_dt_DT_Object.lgt_dt_lock_headers = "300"
    component.set("v.lgt_dt_DT_Object", JSON.stringify(lgt_dt_DT_Object));
    var lgt_dt_Cmp = component.find("ClaimsSearchTable_auraid");
    lgt_dt_Cmp.tableinit();
    
 },
logError: function(component,e){
        try{
            debugger;
            console.log(e);
            var errorArray=e.stack.split("\n");
            var errorcause;
            var errorline;
            if(errorArray && errorArray.length>=2)
                errorcause=errorArray[0]+ ' \n' +errorArray[1];
            else
                errorcause=e.stack;
            var errorlineArray =errorcause.split(":");
            if(errorlineArray && errorArray.length>=3)
                errorline=errorlineArray[3];
            var errormessage =e.message;
            var errortype =e.name;
            errorcause+=' \n in ' +window.location.pathname;
            var logAction = component.get("c.logError");
            logAction.setParams({
                "Application": 'Polaris',
                "errorcause" : errorcause,
                "errorline" :errorline,
                "errormessage" : errormessage, 
                "errorType" : errortype
            });
            
            logAction.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log('Error Logged Succesfully');
                    console.log(e);
                    this.showError();
                }
            });
            $A.enqueueAction(logAction);
        }catch(err){
            console.log('Exception happened ');
            console.log(err);
        }
    },
    showError : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message:'Unexpected error occurred. Please try again. If problem persists, contact the Help Desk.',
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'sticky'
        });
        toastEvent.fire();
    }
})