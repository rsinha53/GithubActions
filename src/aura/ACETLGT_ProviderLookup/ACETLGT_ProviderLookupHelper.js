({
    sortSelect : function(component,event,helper) {
                   
    },

getUIOptionsafterChange: function(component,event,helper){

     component.set("v.isDisabledGetSubscriptionServiceValues",true);
component.set("v.isDisabledBenefitTierValues",true);
         component.set("v.isDisabledNetworkValues",true);
var lstNtwrk=['INN Only'];
component.set('v.networkStatusRadio',lstNtwrk);

var lstClaim=['--None--','Medical','Behavioral'];
component.set('v.claimTypeOptions',lstClaim);
var opts = [];
opts.push({label:'--None--',value:''});  
component.set('v.networkOptions',opts);

var lst = ['Select Provider Type'];
var specialtyLst = ['Select Classification'];
component.set('v.classificationOptions',lst);
component.set('v.specialityOptions',specialtyLst);
  setTimeout(function () {
      component.set("v.SpinnerOnLoad",false); 
  }, 2000);

},    

onProviderTypeChange : function(component,event,helper,providerType,classification) {

component.get('v.classification','');
if(providerType == 'Physician' || providerType == 'Facility') {
var specialtyLst = ['Select Classification'];
component.set('v.specialityOptions',specialtyLst);
component.set('v.isDisabledSpeciality',true);
var action = component.get("c.getClassifications");
action.setParams({
  "providerType": providerType
});
action.setCallback(this, function(a) {
 var state = a.getState();
 if(state == "SUCCESS"){
    var result = a.getReturnValue();
      if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
          var lst = ['--None--'];
          for(var i=0; i < result.length; i++) {
          if (result[i] != "--None--")
          lst.push(result[i]);
    }
       component.set('v.classificationOptions',lst);

  }
 }
});
$A.enqueueAction(action);
}else if (providerType == '') {
var lst = ['Select Provider Type'];
var specialtyLst = ['Select Classification'];
component.set('v.classificationOptions',lst);
component.set('v.specialityOptions',specialtyLst);
component.set('v.isDisabledSpeciality',true);
}
},
onClassificationChange : function(component,event,helper,providerType,classification) {
debugger;
if(providerType != '' && classification != '--None--') {
component.set('v.isDisabledSpeciality',false);
var action = component.get("c.getSpecilities");
action.setParams({
  "providerType": providerType,
 "classification": classification
});
action.setCallback(this, function(a) {
 var state = a.getState();
 if(state == "SUCCESS"){
    var result = a.getReturnValue();
      if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
          var lst = [];
          for(var i=0; i < result.length; i++) {
          lst.push(result[i]);
      }
       component.set('v.specialityOptions',lst);
          if (lst.length == 1) {
              component.set("v.specialty", lst[0]);
          }
         
  }
 }
 
});
$A.enqueueAction(action);
}else{
var lst = ['Select Classification'];
component.set('v.specialityOptions',lst); 
}
  
},
fireToast: function(title, messages, component, event, helper){
var toastEvent = $A.get("e.force:showToast");
toastEvent.setParams({
  "title": title,
  "message": messages,
  "type": "error",
  "mode": "dismissible",
  "duration": "20000"
});
toastEvent.fire();
helper.hideSpinner2(component, event, helper);
return;

},
onSearchRadioChange : function(component, event, helper,searchType,selectNetworkStatusRadioValue) {
        debugger;
if(searchType == 'Advanced'){
//Need to  remove disable INN and OON value
component.set("v.isDisabledGetSubscriptionServiceValues",false);
component.set("v.isDisabledBenefitTierValues",false);
component.set("v.isDisabledNetworkValues",false);
var lst=['INN Only','INN and OON'];
component.set('v.networkStatusRadio',lst);
if(component.get("v.providerType") == 'Facility') {
    component.set("v.searchPcpOBGYNId", "");
    component.set("v.isDisabledPcpOBYNId",true);
}
      
      }
else {
           component.set("v.isDisabledGetSubscriptionServiceValues",true);
 component.set("v.isDisabledBenefitTierValues",true);
 component.set("v.isDisabledNetworkValues",true);
           //Need to radio value
            if(component.get("v.providerType") == 'Facility') {
    component.set("v.searchPcpOBGYNId", "");
    component.set("v.isDisabledPcpOBYNId",true);
}
var lst=['INN Only'];
component.set('v.networkStatusRadio',lst);
component.set("v.selectStatusValue",'Active');
component.set('v.claimType','Medical');
var benefitCmpvalue  = component.find('benefitTierlId');
$A.util.removeClass(benefitCmpvalue, "slds-has-error"); 
$A.util.removeClass(component.find("msgTxtBenefitname"), "slds-show");
                   $A.util.addClass(component.find("msgTxtBenefitname"), "slds-hide");
helper.populateDefaultValues(component,event,helper);
      }
//this.onNetworkTypeChange(component,event,helper,searchType,selectNetworkStatusRadioValue);
},
onNetworkTypeChange : function(component,event,helper,searchRadioValue,selectNetworkStatusRadioValue) {
debugger;
if(searchRadioValue == 'Basic') {
   var lst=['--None--','Medical','Behavioral'];
   component.set('v.claimTypeOptions',lst); 
   component.set('v.isDisabledBenefitTierValues',true);
   helper.populateDefaultValues(component,event,helper);
}else if(searchRadioValue == 'Advanced' && selectNetworkStatusRadioValue == 'INN Only'){
    var lst=['--None--','Medical','Behavioral'];
    component.set('v.claimTypeOptions',lst); 
    component.set('v.isDisabledBenefitTierValues',false);
    helper.populateDefaultValues(component,event,helper);
}else if(searchRadioValue == 'Advanced' && selectNetworkStatusRadioValue != 'INN Only'){
 var lst= ['--None--'];
 component.set('v.claimTypeOptions',lst);
 var benefitOptions = [];
 benefitOptions.unshift({key: '',value: '--None--'});
 component.set('v.benefitTierOptions',benefitOptions);
 component.set('v.isDisabledBenefitTierValues',true);
 component.set('v.serviceType','');
  var action = component.get("c.getNetworks");
 action.setCallback(this, function(a) {
 var state = a.getState();
 if(state == "SUCCESS"){
    var result = a.getReturnValue();
      if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
          var opts = [];
         for(var i=0; i < result.length; i++) {
             opts.push({
              label: result[i].Network_ID__c,
              value: result[i].Label
          }); 
          
         }
        opts.unshift({label:'',value:'--None--'});
        component.set('v.networkOptions',opts);
        component.set('v.network',opts[0]);
  }
 }
 
});
$A.enqueueAction(action);
}
},
defNetworkValue: function(component,event,helper){ 
var action = component.get("c.getNetworkVal");
var netVal = component.get("v.highlightPanel.Network");
console.log('@@@@@@@@@@@@@@@@@netVal-------->'+netVal);
action.setParams({ netVal : netVal});
action.setCallback(this, function(response) {
  var state = response.getState();      
  if (state === "SUCCESS") {
      var result = response.getReturnValue();
      if(result !== null && result !== '' && result.length>0){ 
          if(result[0].includes("_")){
              component.set("v.defNetworkName",result[0].split('_')[1]);
                                                      
              component.set("v.defNetworkId",result[0].split('_')[0]);
          }
      } 
  }
});
$A.enqueueAction(action); 
},

clearFunctionHelper : function(component,event,helper) {
var searchRadioValue = component.get("v.searchRadioValue");
component.set("v.taxId", "");
component.set("v.lastName", "");
component.set("v.phoneNumber", "");
component.set("v.firstName", "");
component.set("v.searchPcpOBGYNId", "");
component.find('providerTypeId').set("v.value", "");
component.set("v.searchProviderId", "");
component.set("v.npi", "");
component.set("v.city", "");
component.set("v.zipCode", "");
var searchType = component.get("v.searchType");
component.set("v.isCheckedAcceptingNewPatient",false);
component.set("v.isDisabled",false);
component.set("v.isDisabledFreeStandingFacility",false);
component.set('v.isDisabledSpeciality',true);
component.set("v.isCheckedFreeStandingFacility",false);
component.set("v.isDisabledPcpOBYNId",false);
component.set('v.isDDPChecked',false);									  
component.set("v.isDisabledDDPType",false);					 					   
var benefitCmpvalue  = component.find('benefitTierlId');
$A.util.removeClass(benefitCmpvalue, "slds-has-error"); 
$A.util.removeClass(component.find("msgTxtBenefitname"), "slds-show");
$A.util.addClass(component.find("msgTxtBenefitname"), "slds-hide");
if(searchRadioValue == 'Basic') {
  component.set('v.claimType','Medical');        
}else {
  component.set('v.claimType','');
  component.set('v.network','');   
}
if(searchType == 'Specialty') {
 //component.find('claimTypeId').set("v.value","");
 component.find('languageId').set("v.value","");
 component.find('genderId').set("v.value",""); 
 var lst = ['Select Provider Type'];
 var specialtyLst = ['Select Classification'];
 component.set('v.classificationOptions',lst);
 component.set('v.specialityOptions',specialtyLst);
 component.set("v.radius","");
 component.find('selStateOptionsSpecialtySearch').find('selstate').set("v.value", ""); 
 var zipCmpValue  = component.find('zipCodeId');
 helper.clearvalidationContent(component,event,helper,zipCmpValue);
 var radiusCmpvalue  = component.find('radiusId');
 $A.util.removeClass(radiusCmpvalue, "slds-has-error"); 
 $A.util.removeClass(component.find("msgTxtRname"), "slds-show");
 $A.util.addClass(component.find("msgTxtRname"), "slds-hide");
}else if(searchType == 'Name') {
   component.find('selStateOptionsSpecialtySearch').find('selstate').set("v.value", ""); 
   var phoneNumber = component.find('phoneId');
   helper.clearvalidationContent(component,event,helper,phoneNumber);
   var zipCmpValue  = component.find('zipCodeId');
   helper.clearvalidationContent(component,event,helper,zipCmpValue);
   var firstNameCmpValue  = component.find('firstName');
   helper.clearvalidationContent(component,event,helper,firstNameCmpValue);
   var lastNameCmpValue  = component.find('lastName');
   helper.clearvalidationContent(component,event,helper,lastNameCmpValue);
}else if(searchType == 'ID'){
  component.find('selStateOptions').find('selstate').set("v.value", "");
   var taxId = component.find('taxId');
   helper.clearvalidationContent(component,event,helper,taxId);
   var npi = component.find('npiId');
   helper.clearvalidationContent(component,event,helper,npi);
   var providerId = component.find('searchProviderId');
   helper.clearvalidationContent(component,event,helper,providerId);
   var firstNameCmpValue  = component.find('firstNameId');
   helper.clearvalidationContent(component,event,helper,firstNameCmpValue);
   var lastNameCmpValue  = component.find('lastNameId');
   helper.clearvalidationContent(component,event,helper,lastNameCmpValue);
}

},
validateNamesWildCard: function (component, event, helper, isFirstName, inputComp, charlengthNum) {
//component.set("v.hasFirstNameError",false);
//component.set("v.hasLastNameError",false);
var charString = inputComp.get("v.value"); 
var lastchar = charString[charString.length - 1];
if (charString.includes("*") && lastchar == "*" && charString.length < charlengthNum) {
  if (isFirstName) {
      inputComp.setCustomValidity("Error: Enter at least one character followed by an asterisk, and no character after the asterisk, in order to perform a wildcard search on the first name field (example: ab*)."); 
      inputComp.reportValidity();
        
  } else {
       inputComp.setCustomValidity("Error: Enter at least three characters followed by an asterisk, and no character after the asterisk, in order to perform a wildcard search on the last name field (example: ab*)."); 
       inputComp.reportValidity();
 }
  return false;
} else if (charString.includes("*") && lastchar != "*" && charString.length >= charlengthNum) {
  if (isFirstName) {
      inputComp.setCustomValidity("Error: Enter at least one character followed by an asterisk, and no character after the asterisk, in order to perform a wildcard search on the first name field (example: ab*)."); 
      inputComp.reportValidity();
      
  } else {
      inputComp.setCustomValidity("Error: Enter at least three characters followed by an asterisk, and no character after the asterisk, in order to perform a wildcard search on the last name field (example: ab*)."); 
       inputComp.reportValidity();
  }
  return false;
} else {
   if (isFirstName) {
      inputComp.setCustomValidity("");
      inputComp.reportValidity();      
  }else{
                                                inputComp.setCustomValidity("");
       inputComp.reportValidity();     
  }
  return true;
}
},
showResults : function (component, event, helper,specialty,radius,claimType,classification,language,gender,state,strNewpatientsInd,practicingStatus,strFreeStandingFacl,taxId,lastName,phoneNumber,firstName,searchPcpOBGYNId,providerType,searchProviderId,npi,city,zipCode,network,qualityTierRuleId,qualityTierLevel,benefitTier,serviceType,benefitServiceArea,attributeList,ddpChecked) {  
console.log('Inside Search');
debugger;
helper.showSpinner2(component, event, helper);
var result = true;
var action = component.get("c.getProviderLookupResults");
if (result){ 
  component.set("v.lstProviders");
  component.set("v.Spinner", true);
  //alert('----1---');
   // Setting the apex parameters
  action.setParams({
      providerId : searchProviderId,
      npi : npi,
      taxId : taxId,
      lastName : lastName,  
      firstName : firstName,
      gender : gender,
      classification: classification,
      specialty: specialty,
      searchPcpOBGYNId : searchPcpOBGYNId,
      PostalPrefixCode : zipCode,
      radius : radius,
      City : city,
      StateCode : state,
      PhoneNumber : phoneNumber,
      networkId : network,
      qualityTierRuleId : !(component.get('v.searchRadioValue')=='Advanced' && component.get('v.selectNetworkStatusRadioValue')=='INN and OON')?qualityTierRuleId:'',
      qualityTierLevel : qualityTierLevel,
      BenefitServiceArea : benefitServiceArea,
      ServiceAreaType : serviceType,
      contractClaimType : claimType,
      NewPatientIndicator : strNewpatientsInd,
      languageCode : language,
      ProviderTypeCode : providerType,
      attributelist : attributeList,
      isLookupflow : true,
      FilterByStatus : practicingStatus,
      PFS : strFreeStandingFacl,
      networkType : component.get('v.selectNetworkStatusRadioValue'),
      searchType : component.get('v.searchRadioValue'),
      ddpChecked:ddpChecked									 
 });
  //Setting the Callback
  action.setCallback(this,function(a){
      //get the response state
      component.set("v.Spinner", false);
      var state = a.getState();
      //alert('----state---'+state);
      //check if result is successfull
      if(state == "SUCCESS"){
          
           var result = JSON.parse(a.getReturnValue().service);
          //alert('----IN1---');
          if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
           //alert('----IN2---');
           this.processtable(providerType,result,component,event);
           //alert('----IN3---');
          }
      } else if(state == "ERROR"){
                   component.set("v.lstProviders");
                   }
      //helper.hideSpinner2(component, event, helper);
  });
  
  //adds the server-side action to the queue        
  $A.enqueueAction(action);
}
return result;
},
showSpinner2: function(component, event, helper) {
// make Spinner attribute true for display loading spinner 
console.log('Show Spinner2');
component.set("v.Spinner", true); 
    },
hideSpinner2 : function(component, event, helper) {   
console.log('Hiding Spinner2');
                   component.set("v.Spinner", false);
    },
providerTypeHelper : function(component,event,helper,providerType) {
debugger;
component.set("v.isDisabled",false)
component.set("v.isDisabledPcpOBYNId",false);
component.set("v.isDisabledFreeStandingFacility",false); 
if(providerType != '') {
  if(providerType == 'Facility')  {  
          component.set("v.isCheckedAcceptingNewPatient",false);
          component.set("v.firstName", "");
          component.set("v.language", "");
          component.set("v.gender", "");
          component.set("v.searchPcpOBGYNId", "");
          component.set("v.isDisabled",true);
          component.set("v.isDisabledPcpOBYNId",true);
          component.set("v.isDisabledDDPType",false);
 }else {
          component.set("v.isCheckedFreeStandingFacility",false);
          component.set("v.isDisabledFreeStandingFacility",true);  
          component.set("v.isDisabledDDPType",true);
             component.set('v.isDDPChecked',false);
 }
}else {
  component.set('v.isDisabledSpeciality',true);
  component.set("v.isDisabledDDPType",false);
}
},
validatePhoneNumber : function(component,event,helper,inputComp,charlengthNum) {
var charString = inputComp.get("v.value");
if(charString.length != charlengthNum) {
  inputComp.setCustomValidity("Error: Enter a valid 10 digit number.");
  inputComp.reportValidity();
  return false;
}else {
  inputComp.setCustomValidity("");
  inputComp.reportValidity();
  return true;
}
},
validateTaxId : function(component,event,helper,inputComp,charlengthNum) {
var charString = inputComp.get("v.value");
if(charString.length != charlengthNum) {
  inputComp.setCustomValidity("Error: To search by Tax ID number, enter nine digits.");
  inputComp.reportValidity();
  return false;
}else {
  inputComp.setCustomValidity("");
  inputComp.reportValidity();
  return true;
}
},
validateNpiId : function(component,event,helper,inputComp,charlengthNum) {
var charString = inputComp.get("v.value");
if(charString.length != charlengthNum) {
  inputComp.setCustomValidity("Error: To search by NPI number, enter ten digits.");
  inputComp.reportValidity();
  return false;
}else {
  inputComp.setCustomValidity("");
  inputComp.reportValidity();
  return true;
}
},
clearvalidationContent: function(component,event,helper,inputComp) {
   inputComp.setCustomValidity("");
   inputComp.reportValidity();
},
validateRadius : function(component,event,helper,radiusCmpvalue,zipCode) {
var radius = radiusCmpvalue.get("v.value");
if (!$A.util.isEmpty(radius) && $A.util.isEmpty(zipCode)){
    component.set("v.hasRadiusError", true);
    component.set("v.RadiusErrorMessage","Error: Radius search requires a Zip Code.");
    $A.util.removeClass(component.find("msgTxtRname"), "slds-hide");
    $A.util.addClass(component.find("msgTxtRname"), "slds-show");  
    $A.util.addClass(radiusCmpvalue,"slds-has-error");
    return false;
}else {
   component.set("v.hasRadiusError", false);
   component.set("v.RadiusErrorMessage","");
   $A.util.removeClass(component.find("msgTxtRname"), "slds-show");
   $A.util.addClass(component.find("msgTxtRname"), "slds-hide");
   $A.util.removeClass(radiusCmpvalue, "slds-has-error"); 
   return true;
}
},
validateZipcode : function(component,event,helper,inputComp,charlengthNum) {
var charString = inputComp.get("v.value");
if(charString.length != charlengthNum) {
  inputComp.setCustomValidity("Error: To search by Zip Code, enter five digits.");
  inputComp.reportValidity();
  return false;
}else {
  inputComp.setCustomValidity("");
  inputComp.reportValidity();
  return true;
}
},
processtable : function(providerType,result,component,event){
var lgt_dt_DT_Object = new Object();
var lgt_dt_Cmp_name;
lgt_dt_DT_Object.lgt_dt_PageSize = JSON.parse(result).PageSize;
lgt_dt_DT_Object.lgt_dt_SortBy = -1;
lgt_dt_DT_Object.lgt_dt_SortDir = '';
lgt_dt_DT_Object.lgt_dt_serviceObj = result;
lgt_dt_DT_Object.lgt_dt_lock_headers = "300";
lgt_dt_DT_Object.lgt_dt_StartRecord =0;
lgt_dt_DT_Object.lgt_dt_PageNumber=0;
lgt_dt_DT_Object.lgt_dt_searching = true;  
if(providerType ==''){
lgt_dt_DT_Object.lgt_dt_serviceName = 'ACETLGT_FindProviderLookupWebservice';
lgt_dt_DT_Object.lgt_dt_columns = JSON.parse('[{"title":"Provider ID","defaultContent":"","data":"providerId","type": "string"},{"title":"Name","defaultContent":"","data":"fullName","type": "string"},{"title":"Provider Type","defaultContent":"","data":"providerType","type": "string"},{"title":"Tax ID","defaultContent":"","data":"taxId","type": "number"},{"title":"Address","defaultContent":"","data":"address","type": "string"},{"title":"Phone Number","defaultContent":"","data":"phoneNumber","type": "string"},{"title":"Specialty","defaultContent":"","data":"speciality","type": "string"},{"title":"PCP Role","defaultContent":"","data":"PCPRole","type": "string"},{"title":"PCP/OBGYN ID","defaultContent":"","data":"pcpObgnID","type": "string"},{"title":"Gender","defaultContent":"","data":"gender","type": "string"},'+(component.get('v.memberId')!=null?'{"title":"Tiered","defaultContent":"","data":"qualityBenefitTier","type": "string"},':'')+'{"title":"UnitedHealth Premium Program","defaultContent":"","data":"uphd","type": "string"},{"title":"DDP Type","defaultContent":"","data":"labTypeCode","type": "string"},{"title":"Radius","defaultContent":"","data":"radious","type": "string"},{"title":"Address Status","defaultContent":"","data":"providerLocationAffiliationsStatusCode","type": "string"}]');
lgt_dt_Cmp_name = "ProviderLookupTable_auraid";
}else if(providerType =='Physician'){
lgt_dt_DT_Object.lgt_dt_serviceName = 'ACETLGT_FindHCPWebservice';
lgt_dt_DT_Object.lgt_dt_columns = JSON.parse('[{"title":"Provider ID","defaultContent":"","data":"providerId","type": "string"},{"title":"Name","defaultContent":"","data":"fullName","type": "string"},{"title":"Provider Type","defaultContent":"","data":"providerType","type": "string"},{"title":"Tax ID","defaultContent":"","data":"taxId","type": "number"},{"title":"Address","defaultContent":"","data":"address","type": "string"},{"title":"Phone Number","defaultContent":"","data":"phoneNumber","type": "string"},{"title":"Specialty","defaultContent":"","data":"speciality","type": "string"},{"title":"PCP Role","defaultContent":"","data":"PCPRole","type": "string"},{"title":"PCP/OBGYN ID","defaultContent":"","data":"pcpObgnID","type": "string"},{"title":"Gender","defaultContent":"","data":"gender","type": "string"},'+(component.get('v.memberId')!=null?'{"title":"Tiered","defaultContent":"","data":"qualityBenefitTier","type": "string"},':'')+'{"title":"UnitedHealth Premium Program","defaultContent":"","data":"uphd","type": "string"},{"title":"Radius","defaultContent":"","data":"radious","type": "string"},{"title":"Address Status","defaultContent":"","data":"providerLocationAffiliationsStatusCode","type": "string"}]');
lgt_dt_Cmp_name = "ProviderLookupTable_auraid";
}else if(providerType =='Facility'){
lgt_dt_DT_Object.lgt_dt_serviceName = 'ACETLGT_FindHCOWebservice';
lgt_dt_DT_Object.lgt_dt_columns = JSON.parse('[{"title":"Provider ID","defaultContent":"","data":"providerId","type": "string"},{"title":"Name","defaultContent":"","data":"fullName","type": "string"},{"title":"Provider Type","defaultContent":"","data":"providerType","type": "string"},{"title":"Tax ID","defaultContent":"","data":"taxId","type": "number"},{"title":"Address","defaultContent":"","data":"address","type": "string"},{"title":"Phone Number","defaultContent":"","data":"phoneNumber","type": "string"},{"title":"Specialty","defaultContent":"","data":"speciality","type": "string"},{"title":"PCP Role","defaultContent":"","data":"PCPRole","type": "string"},{"title":"Gender","defaultContent":"","data":"gender"},{"title":"Tiered","defaultContent":"","data":"tierValue"},{"title":"UnitedHealth Premium Program","defaultContent":"","data":"uphd","type": "string"},{"title":"DDP Type","defaultContent":"","data":"labTypeCode","type": "string"},{"title":"Radius","defaultContent":"","data":"radious","type": "number"}]');
lgt_dt_Cmp_name = "ProviderLookupTable_auraid";
}
component.set("v.lgt_dt_DT_Object", JSON.stringify(lgt_dt_DT_Object));
var lgt_dt_Cmp = component.find(lgt_dt_Cmp_name);  
console.log("-----1----"+lgt_dt_Cmp_name);
lgt_dt_Cmp.tableinit();
console.log("-----2----");    
},
getCoverageInfoBenefits : function(component,event,helper) {
var covInfoBenefits = component.get("v.coverageData");
var groupName = component.get("v.groupName");
var providerState = component.get("v.providerState");
helper.showSpinner2(component, event, helper);
if(covInfoBenefits != undefined){
var surrogateKey = covInfoBenefits.SurrogateKey;
  var bundleId = covInfoBenefits.benefitBundleOptionId;
  var enrollerSRK = covInfoBenefits.EnrolleeSurrogateKey;
  var COStartDate = component.get("v.COStartDate");
  var COEndDate =  component.get("v.COEndDate");
  var groupNumber = covInfoBenefits.GroupNumber; 
  var action = component.get("c.getSearchResults");
  var reqParams = {
      'surrogateKey': surrogateKey,
      'bundleId': bundleId,
      'enrollerSRK': enrollerSRK,
      'startDate': COStartDate,
      'endDate': COEndDate,
      'coverageTypes': '',
      'groupNumber': groupNumber,
      'accumAsOf': '',
      'SitusState': '',
      'planId':component.get('v.BenefitPlanId'),
      'customerPurchaseId':component.get('v.customerPurchaseId')
  };
  action.setParams(reqParams);
  action.setCallback(this, function(response) {
      var state = response.getState();
      console.log(response);
      if (state === "SUCCESS") {
          var result = response.getReturnValue();
          console.log('network map',JSON.stringify(result));
          var opts = [];
          var serviceAreaList = [];
          var networkList = [];
          var networkTierMap = [];
          var benefitTierList = [];
          var serviceAreaTypeMap;
          var networkMap;
          var benefitServiceSet;
          var benefitServiceList =[];
          var searchRadioValue = component.get("v.searchRadioValue");
          if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
              if (!$A.util.isEmpty(result.benefitTierMap) && !$A.util.isUndefined(result.benefitTierMap)){
                  var benefitTierOptionsList = result.benefitTierMap;
                   serviceAreaTypeMap = result.serviceAreaTypeMap;
                   benefitServiceSet = result.benefitServiceSet;
                  component.set('v.qualityProviderRuleId',result.qualityProviderRuleId);
                  var caseMapping = {
                      'core benefits from freedom':'Core Benefits from Freedom',
                      'core benefits from liberty':'Core Benefits from Liberty',
                      'core benefits from garden':'Core Benefits from Garden',
                      'core benefits':'Core Benefits',
                      'core benefits from metro':'Core Benefits from Metro'
                  };
                   for (var singleKey in benefitTierOptionsList) {
                       if(benefitTierOptionsList[singleKey] && benefitTierOptionsList[singleKey].toLowerCase() != 'Core Benefits from Freedom'.toLowerCase()
                          && benefitTierOptionsList[singleKey].toLowerCase() != 'Core Benefits from Liberty'.toLowerCase()
                          && benefitTierOptionsList[singleKey].toLowerCase() != 'Core Benefits from Garden'.toLowerCase()
                          && benefitTierOptionsList[singleKey].toLowerCase() != 'Core Benefits'.toLowerCase()
                          && benefitTierOptionsList[singleKey].toLowerCase() != 'Core Benefits from Metro'.toLowerCase()) {
                      opts.push({
                          key: singleKey,
                          value: benefitTierOptionsList[singleKey]
                      });
                      }else if(benefitTierOptionsList[singleKey] &&  caseMapping[benefitTierOptionsList[singleKey].toLowerCase()]) {
                           opts.push({key: singleKey,value: caseMapping[benefitTierOptionsList[singleKey].toLowerCase()]});
                           component.set('v.benefitTier', singleKey);
                      }
      else {
                           opts.push({key: singleKey,value: benefitTierOptionsList[singleKey]});
                           component.set('v.benefitTier', singleKey);
                      }
                      benefitTierList.push({
                              key: singleKey,
                              value: benefitTierOptionsList[singleKey]
                      })
                  } 
                       opts.unshift({key: '',value: '--None--'});
              }
          
          console.log(JSON.stringify(opts));
          component.set('v.benefitTierOptions',opts);
          console.log(component.get("v.serviceAreaTypeMap"));
          for (var key in serviceAreaTypeMap) {
              if(key == component.get('v.benefitTier')){
                  component.set('v.serviceType',serviceAreaTypeMap[key]);
              }
               serviceAreaList.push({
                          key: key,
                          value: serviceAreaTypeMap[key]
                      });
          }
          console.log(serviceAreaList);
          component.set("v.serviceAreaTypeMap",serviceAreaList);
          component.set("v.benefitTierMap",benefitTierList);
          if (!$A.util.isEmpty(result.networkMap) && !$A.util.isUndefined(result.networkMap)){
             networkMap = result.networkMap;
            for(var networkKey in networkMap){                      
                var ntwArray = networkMap[networkKey];
                for(var i =0; i<ntwArray.length; i++) {
                    if(networkKey == component.get('v.benefitTier') && !$A.util.isUndefinedOrNull(ntwArray[i].split('_')[0])&& !$A.util.isUndefinedOrNull(ntwArray[i].split('_')[1])) {
                        if(groupName != 'STATE OF CONNECTICUT' && groupName != 'Katya_test1 20191127112736') {
                           if(ntwArray[i].split('_')[1] != 'Freedom Network' && ntwArray[i].split('_')[1] != 'Liberty Network' && ntwArray[i].split('_')[1] !='Metro Network' && ntwArray[i].split('_')[1] !='Garden State Network'){ 
                             networkList.push({label : ntwArray[i].split('_')[0],
                                             value : ntwArray[i].split('_')[1]
                                          }); 
                            console.log('test');
                         }else{
                             networkList.push({label : ntwArray[i].split('_')[0],
                                               value : ntwArray[i].split('_')[1]
                                             }); 
                            component.set('v.network',ntwArray[i].split('_')[0]);
                            }
                        }else if(groupName == 'STATE OF CONNECTICUT') {
                             if(ntwArray[i].split('_')[1] != 'State of CT ASO Preferred Provider'){ 
                                networkList.push({label : ntwArray[i].split('_')[0],
                                                 value : ntwArray[i].split('_')[1]
                                                }); 
                             }else {
                                 networkList.push({label : ntwArray[i].split('_')[0],
                                                   value : ntwArray[i].split('_')[1]
                                                  }); 
                                 component.set('v.network',ntwArray[i].split('_')[0]);
                             }
                        }else if(groupName == 'Katya_test1 20191127112736' && providerState == 'PR') {
                             if(ntwArray[i].split('_')[1] != 'MAPFRE Network'){ 
                                networkList.push({label : ntwArray[i].split('_')[0],
                                                 value : ntwArray[i].split('_')[1]
                                                }); 
                             }else {
                                 networkList.push({label : ntwArray[i].split('_')[0],
                                                   value : ntwArray[i].split('_')[1]
                                                  }); 
                                 component.set('v.network',ntwArray[i].split('_')[0]);
                             }
                        }
                    }
                }
                 networkTierMap.push({
                          key: networkKey,
                          value: networkMap[networkKey]
                      });     
          }
            networkList.unshift({label : '',
                value : '--None--'
                     }); 
          }
          for (var i in benefitServiceSet) {
              console.log(benefitServiceSet[i]);
              component.set('v.benefitServiceArea',benefitServiceSet[i]);
          }
          component.set("v.networkOptions",networkList);
          console.log(networkList);
          
          component.set("v.networkMap",networkTierMap);
                      var FromPCP = component.get("v.pageReference").state.c__FromPCP;
              if(FromPCP){
  var PCP_OBGYNID = component.get("v.pcpobjnidstr");
  var pcpProviderId = component.get("v.pcpProviderId");
  var pcpProviderType = component.get("v.pcpProviderType");
  component.set("v.searchType",'ID');
  component.set("v.searchPcpOBGYNId",PCP_OBGYNID);
  component.set("v.searchProviderId", pcpProviderId);
  //Set Provider Type as None for PCP ID Search
  component.set("v.providerType",'');
			component.set('v.isDisabledDDPType',false); 
                        helper.searchhelper(component, event, helper);
              }
      }
          helper.hideSpinner2(component,event,helper);
      } else if (state === "INCOMPLETE") {
          // do something
      } else if (state === "ERROR") {
          var errors = response.getError();
          helper.hideSpinner2(component,event,helper);
          if (errors) {
              console.log("Error: " + errors[0].message);
          } else {
              console.log("Unknown error");
          }
      }
      
  });
  $A.enqueueAction(action);
  
}else{
  //helper.hideSpinner2(cmp,event,helper);
}
},
populateDefaultValues : function(component,event,helper) {
 debugger;
 var benefitOptions = [];
 var networkList = [];
 console.log(component.get("v.benefitTierMap"));
 var benefitTierMap = component.get("v.benefitTierMap");
 var groupName = component.get("v.groupName");
 var providerState = component.get("v.providerState");
 var searchRadioValue = component.get("v.searchRadioValue");

 benefitOptions.unshift({key:'',value: '--None--'});
var caseMapping = {
  'core benefits from freedom':'Core Benefits from Freedom',
  'core benefits from liberty':'Core Benefits from Liberty',
  'core benefits from garden':'Core Benefits from Garden',
  'core benefits':'Core Benefits',
  'core benefits from metro':'Core Benefits from Metro'
};
 if(benefitTierMap != null && benefitTierMap != ''){        
 for (var i in benefitTierMap) {
     if(benefitTierMap[i].value && benefitTierMap[i].value.toLowerCase() != 'Core Benefits from Freedom'.toLowerCase() && benefitTierMap[i].value.toLowerCase() != 'Core Benefits from Liberty'.toLowerCase() && benefitTierMap[i].value.toLowerCase() != 'Core Benefits from Garden'.toLowerCase() && benefitTierMap[i].value.toLowerCase() != 'Core Benefits'.toLowerCase()&& benefitTierMap[i].value.toLowerCase() !='Core Benefits from Metro'.toLowerCase()) {
         benefitOptions.push({
                     key: benefitTierMap[i].key,
                     value: benefitTierMap[i].value
                   });
     }else if(benefitTierMap[i].value && caseMapping[benefitTierMap[i].value.toLowerCase()]) {
            benefitOptions.push({key:benefitTierMap[i].key,value: caseMapping[benefitTierMap[i].value.toLowerCase()]});
             component.set("v.benefitTier",benefitTierMap[i].key);             
     }  
 else{
         benefitOptions.push({key:benefitTierMap[i].key,value: benefitTierMap[i].value});
             component.set("v.benefitTier",benefitTierMap[i].key);	
 }
 }
 }
 component.set("v.benefitTierOptions",benefitOptions);
 var serviceAreaTypeMap = component.get("v.serviceAreaTypeMap");
 if(serviceAreaTypeMap != null && serviceAreaTypeMap != ''){
 for(var i =0; i< serviceAreaTypeMap.length; i++) {
      if(serviceAreaTypeMap[i].key == '5') {
        component.set('v.serviceType',serviceAreaTypeMap[i].value);
      }
  }
 }
 var networkMap = component.get("v.networkMap");
 if(networkMap != null && networkMap != ''){
  for(var i in networkMap){                      
          var ntwArray = networkMap[i].value;
          for(var j =0; j<ntwArray.length; j++) {
              if(networkMap[i].key == component.get('v.benefitTier')) {
                 // if(groupName != 'STATE OF CONNECTICUT' && groupName != 'Katya_test1 20191127112736') {
                    if(ntwArray[j].split('_')[1] != 'Freedom Network' && ntwArray[j].split('_')[1] != 'Liberty Network'&& ntwArray[j].split('_')[1] !='Metro Network' && ntwArray[j].split('_')[1] !='Garden State Network'){ 
                       networkList.push({label : ntwArray[j].split('_')[0],
                                         value : ntwArray[j].split('_')[1]
                                      }); 
                  }else {
                      networkList.push({label : ntwArray[j].split('_')[0],
                                        value : ntwArray[j].split('_')[1]
                                      });
                      component.set("v.network",ntwArray[j].split('_')[0]);
                     }
                /** }else if(groupName == 'STATE OF CONNECTICUT') {
                       if(ntwArray[j].split('_')[1] != 'State of CT ASO Preferred Provider'){ 
                                networkList.push({label : ntwArray[j].split('_')[0],
                                                 value : ntwArray[j].split('_')[1]
                                                }); 
                       }else {
                               networkList.push({label : ntwArray[j].split('_')[0],
                                                value : ntwArray[j].split('_')[1]
                                                  }); 
                                component.set('v.network',ntwArray[j].split('_')[0]);
                             }
                 }else if(groupName == 'Katya_test1 20191127112736' && providerState == 'PR') {
                             if(ntwArray[j].split('_')[1] != 'MAPFRE Network'){ 
                                networkList.push({label : ntwArray[j].split('_')[0],
                                                 value : ntwArray[j].split('_')[1]
                                                }); 
                             }else {
                                 networkList.push({label : ntwArray[j].split('_')[0],
                                                   value : ntwArray[j].split('_')[1]
                                                  }); 
                                 component.set('v.network',ntwArray[j].split('_')[0]);
                             }
                }*/
             }
          }
     }
 }
     networkList.unshift({label : '',
                       value : '--None--'
                     }); 
     component.set("v.networkOptions",networkList);
     
},
validateBenefitTier : function(component,event,helper,benefitCmpValue,benefitTier,selectNetworkStatusRadioValue) {
if ($A.util.isEmpty(benefitTier) && selectNetworkStatusRadioValue == 'INN Only'){
    component.set("v.BenefitErrorMessage","Error: You must select a value.");
    $A.util.removeClass(component.find("msgTxtBenefitname"), "slds-hide");
    $A.util.addClass(component.find("msgTxtBenefitname"), "slds-show");  
    $A.util.addClass(benefitCmpValue,"slds-has-error");
    return false;
}else {
   component.set("v.BenefitErrorMessage","");
   $A.util.removeClass(component.find("msgTxtBenefitname"), "slds-show");
   $A.util.addClass(component.find("msgTxtBenefitname"), "slds-hide");
   $A.util.removeClass(benefitCmpValue, "slds-has-error"); 
   return true;
}
},
hideSpinner2 : function(component, event, helper) {   
console.log('Hiding Spinner2');
                   component.set("v.SpinnerFromBenefit", false);
    },
showSpinner2: function(component, event, helper) {
// make Spinner attribute true for display loading spinner 
component.set("v.SpinnerFromBenefit", true); 
    },
validateProviderId : function(component,event,helper,inputComp,charlengthNum) {
var charString = inputComp.get("v.value");
if(charString.length != charlengthNum) {
  inputComp.setCustomValidity("Error:To search by Provider ID number, enter eighteen digits.");
  inputComp.reportValidity();
  return false;
}else {
  inputComp.setCustomValidity("");
  inputComp.reportValidity();
  return true;
}
},
    getNetworkName: function(component, event, helper, networkId)
    {
    	var networkOptions = component.get('v.networkOptions');
        var networkName = '';
        networkOptions.forEach(function(option,index) { 
            if( option.label == networkId) {
                networkName = option.value;
            }
		});
        return networkName;
	},
searchhelper: function(component, event, helper) {
var taxId = component.get("v.taxId");
var lastName = component.get("v.lastName");
var phoneNumber = component.get("v.phoneNumber");
var firstName = component.get("v.firstName");
var searchPcpOBGYNId = component.get("v.searchPcpOBGYNId");
var returnError = false;
var providerType = component.find('providerTypeId').get("v.value");
var searchProviderId = component.get("v.searchProviderId");
var npi = component.get("v.npi");
var city = component.get("v.city");
var zipCode = component.get("v.zipCode");
var benefitTier = component.get("v.benefitTier");
var selectNetworkStatusRadioValue = component.get("v.selectNetworkStatusRadioValue");
var searchRadioValue = component.get("v.searchRadioValue");
component.set("v.SpinnerOnLoad",false);
var gender = '';
var radius = '';
var classification = '';
var language = '';
        var network = '';
        var networkName = '';
if(searchRadioValue == 'Basic'){
             network = component.get("v.defNetworkId");
             networkName = component.get("v.defNetworkName");
}else{
          network = component.get("v.network");  
          networkName = helper.getNetworkName(component, event, helper, network);
        }
        console.log('>>>Netwok Name : ' + networkName)
        var isNavigateNow = false;
        if(networkName && networkName.toLowerCase().includes('navigatenow'))
        {
            isNavigateNow = true;
}
var searchType = component.get("v.searchType");
var specialty = '';
var claimType = '';
var state;
var isfNameValid;
var islNameValid;
var isPhoneNumberValid;
var isTaxIdValid;
var isNpiIdValid;
var isRadiusValid;
var isZipValid;
var isBenefitValid;
var isproviderIdValid;
//Display field validations based on search type
if(searchType == 'ID') {
  var fncmp = component.find('firstNameId');
  var lncmp = component.find('lastNameId');
  isfNameValid = helper.validateNamesWildCard(component,event,helper,true,fncmp,2);
  islNameValid = helper.validateNamesWildCard(component,event,helper,false,lncmp,4);
  state =  component.find('selStateOptions').find('selstate').get("v.value");
}else if(searchType == 'Name') {
  var fncmp = component.find('firstName');
  var lncmp = component.find('lastName');
  isfNameValid = helper.validateNamesWildCard(component,event,helper,true,fncmp,2);
  islNameValid = helper.validateNamesWildCard(component,event,helper,false,lncmp,4);        
}else if(searchType == 'Specialty') {
  if(component.find('specialityId').get("v.value")!= '--None--' && component.find('specialityId').get("v.value") != 'Select Classification') { 
      specialty = component.find('specialityId').get("v.value"); 
  }
  
  radius = component.get("v.radius");
  if(component.find('claimTypeId').get("v.value") != '--None--'){
      claimType = component.find('claimTypeId').get("v.value");
  }
  if(component.find('classificationId').get("v.value") != '--None--' && component.find('classificationId').get("v.value")!= 'Select Provider Type') {
      classification = component.find('classificationId').get("v.value");
  }
  if(component.find('languageId').get("v.value")!= '--None--') { 
      language = component.find('languageId').get("v.value"); 
  }
  if(component.find('genderId').get("v.value")!= '--None--') { 
      gender = component.find('genderId').get("v.value"); 
  }
}
if(searchType == 'Name' || searchType == 'Specialty') {
  state =  component.find('selStateOptionsSpecialtySearch').find('selstate').get("v.value");
  var zipCmpValue  = component.find('zipCodeId');
  if(!$A.util.isEmpty(zipCode)) {
      isZipValid = helper.validateZipcode(component,event,helper,zipCmpValue,5);
      if (!isZipValid){
          returnError = true;
      }  
  }
  

}
var acceptNewPatent = component.find('acceptNewPatentId').get("v.value");
var benefitCmpValue  = component.find('benefitTierlId');
  isBenefitValid = helper.validateBenefitTier(component,event,helper,benefitCmpValue,benefitTier,selectNetworkStatusRadioValue);
  if (!isBenefitValid){                    
      returnError = true;
  }
var qualityTierRuleId = component.get('v.qualityProviderRuleId');
var qualityTierLevel = component.get('v.isTieredProvider')?'1':null;
var ddpChecked = component.get('v.isDDPChecked');
//display toast messages based on search type

if(searchType == 'ID') {
  //Search with last name without other fields
  if (!$A.util.isEmpty(lastName) && ($A.util.isEmpty(npi) && $A.util.isEmpty(taxId) && $A.util.isEmpty(searchProviderId) && $A.util.isEmpty(searchPcpOBGYNId))){
      helper.fireToast("Error: Invalid Data", "ID search requires at least one of the following: Tax ID, NPI, Provider ID, or PCP/OBGYN ID", component, event, helper);
      returnError = true;
  } 
  //Search with lastname and firstname without other fields
  if (!$A.util.isEmpty(lastName) && !$A.util.isEmpty(firstName) && ($A.util.isEmpty(npi) && $A.util.isEmpty(taxId) && $A.util.isEmpty(searchProviderId) && $A.util.isEmpty(searchPcpOBGYNId))){
      helper.fireToast("Error: Invalid Data", "ID search requires at least one of the following: Tax ID, NPI, Provider ID, or PCP/OBGYN ID", component, event, helper);
      returnError = true;
  }
  //Search with lastname firstname state without other fields
  if (!$A.util.isEmpty(lastName) && !$A.util.isEmpty(firstName) && !$A.util.isEmpty(state) && ($A.util.isEmpty(npi) && $A.util.isEmpty(taxId) && $A.util.isEmpty(searchProviderId) && $A.util.isEmpty(searchPcpOBGYNId))){
      helper.fireToast("Error: Invalid Data", "ID search requires at least one of the following: Tax ID, NPI, Provider ID, or PCP/OBGYN ID", component, event, helper);
      returnError = true;
  } 
  //Search with firstname without other fields
  if (!$A.util.isEmpty(firstName) && ($A.util.isEmpty(npi) && $A.util.isEmpty(taxId) && $A.util.isEmpty(searchProviderId) && $A.util.isEmpty(searchPcpOBGYNId))){
      helper.fireToast("Error: Invalid Data", "ID search requires at least one of the following: Tax ID, NPI, Provider ID, or PCP/OBGYN ID", component, event, helper);
      returnError = true;
  }     
  //Search with firstname state without other fields
  if (!$A.util.isEmpty(firstName) &&  !$A.util.isEmpty(state) &&  ($A.util.isEmpty(npi) && $A.util.isEmpty(taxId) && $A.util.isEmpty(searchProviderId) && $A.util.isEmpty(searchPcpOBGYNId))){
      helper.fireToast("Error: Invalid Data", "ID search requires at least one of the following: Tax ID, NPI, Provider ID, or PCP/OBGYN ID", component, event, helper);
      returnError = true;
  } 
  //Search with state without other fields
  if (!$A.util.isEmpty(state) && ($A.util.isEmpty(npi) && $A.util.isEmpty(taxId) && $A.util.isEmpty(searchProviderId) && $A.util.isEmpty(searchPcpOBGYNId))){
      helper.fireToast("Error: Invalid Data", "ID search requires at least one of the following: Tax ID, NPI, Provider ID, or PCP/OBGYN ID", component, event, helper);
      returnError = true;
  }
  //Search without field
  if ($A.util.isEmpty(lastName) && $A.util.isEmpty(firstName) && $A.util.isEmpty(state) && $A.util.isEmpty(providerType) && $A.util.isEmpty(npi) && $A.util.isEmpty(taxId) && $A.util.isEmpty(searchProviderId) && $A.util.isEmpty(searchPcpOBGYNId)){
      helper.fireToast("Error: Invalid Data", "ID search requires at least one of the following: Tax ID, NPI, Provider ID, or PCP/OBGYN ID", component, event, helper);
      returnError = true;
  } 
  var taxCmpValue  = component.find('taxId');
  if (!$A.util.isEmpty(taxId)){
      isTaxIdValid = helper.validateTaxId(component,event,helper,taxCmpValue,9);
      if (!isTaxIdValid){
          returnError = true;
      }    
  }
  var npiCmpValue  = component.find('npiId');
  if (!$A.util.isEmpty(npi)){
      isNpiIdValid = helper.validateNpiId(component,event,helper,npiCmpValue,10);
      if (!isNpiIdValid){
          returnError = true;
      }    
  }
  var providerCmpValue  = component.find('searchProviderId');
  if (!$A.util.isEmpty(searchProviderId)){
      isproviderIdValid = helper.validateProviderId(component,event,helper,providerCmpValue,18);
      if (!isproviderIdValid){
          returnError = true;
      }    
  }    
  if (!isfNameValid || !islNameValid){                    
      returnError = true;
  }
}else if(searchType == 'Name') {
  
            if(isNavigateNow)
            {
                //Search without lastname
                if ($A.util.isEmpty(lastName)){
                    helper.fireToast("Error: Invalid Data", "Name search requires Last Name or Facility/Group Name", component, event, helper);
                    returnError = true;
                }
            }
            else
            {
  //Search with lastname without other fields
  if (!$A.util.isEmpty(lastName) && ($A.util.isEmpty(firstName) && $A.util.isEmpty(city) && $A.util.isEmpty(state) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(phoneNumber))){
      helper.fireToast("Error: Invalid Data", "Name search requires Last Name or Facility/Group Name and at least one of the following: First Name, City, State, Zip Code, or Phone Number", component, event, helper);
      returnError = true;
  } 
  //Search with firstname  without other fields
  if (!$A.util.isEmpty(firstName) && ($A.util.isEmpty(lastName) && $A.util.isEmpty(city) && $A.util.isEmpty(state) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(phoneNumber))){
      helper.fireToast("Error: Invalid Data", "Name search requires Last Name or Facility/Group Name and at least one of the following: First Name, City, State, Zip Code, or Phone Number", component, event, helper);
      returnError = true;
  }
  //Search with firstname city without other fields
  if (!$A.util.isEmpty(firstName) && !$A.util.isEmpty(city) && ($A.util.isEmpty(lastName) && $A.util.isEmpty(state) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(phoneNumber))){
      helper.fireToast("Error: Invalid Data", "Name search requires Last Name or Facility/Group Name and at least one of the following: First Name, City, State, Zip Code, or Phone Number", component, event, helper);
      returnError = true;
  } 
  //Search with firstname city state without other fields
  if (!$A.util.isEmpty(firstName) && !$A.util.isEmpty(city) && !$A.util.isEmpty(state) && ($A.util.isEmpty(lastName) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(phoneNumber))){
      helper.fireToast("Error: Invalid Data", "Name search requires Last Name or Facility/Group Name and at least one of the following: First Name, City, State, Zip Code, or Phone Number", component, event, helper);
      returnError = true;
  } 
  //Search with firstname city state zipcode without other fields
  if (!$A.util.isEmpty(firstName) && !$A.util.isEmpty(city) && !$A.util.isEmpty(state) && !$A.util.isEmpty(zipCode) && ($A.util.isEmpty(lastName) && $A.util.isEmpty(phoneNumber))){
      helper.fireToast("Error: Invalid Data", "Name search requires Last Name or Facility/Group Name and at least one of the following: First Name, City, State, Zip Code, or Phone Number", component, event, helper);
      returnError = true;
  } 
  //Search with city without other fields
  if (!$A.util.isEmpty(city) && ($A.util.isEmpty(firstName) && $A.util.isEmpty(lastName) && $A.util.isEmpty(state) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(phoneNumber))){
      helper.fireToast("Error: Invalid Data", "Name search requires Last Name or Facility/Group Name and at least one of the following: First Name, City, State, Zip Code, or Phone Number", component, event, helper);
      returnError = true;
  } 
  //Search with city state without other fields
  if (!$A.util.isEmpty(city) && !$A.util.isEmpty(state) && ($A.util.isEmpty(lastName) && $A.util.isEmpty(firstName) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(phoneNumber))){
      helper.fireToast("Error: Invalid Data", "Name search requires Last Name or Facility/Group Name and at least one of the following: First Name, City, State, Zip Code, or Phone Number", component, event, helper);
      returnError = true;
  } 
  //Search with city state zipcode without other fields
  if (!$A.util.isEmpty(city) && !$A.util.isEmpty(state) && !$A.util.isEmpty(zipCode) && ($A.util.isEmpty(lastName) && $A.util.isEmpty(firstName) && $A.util.isEmpty(phoneNumber))){
      helper.fireToast("Error: Invalid Data", "Name search requires Last Name or Facility/Group Name and at least one of the following: First Name, City, State, Zip Code, or Phone Number", component, event, helper);
      returnError = true;
  } 
  //Search with state without other fields
  if (!$A.util.isEmpty(state) && ($A.util.isEmpty(firstName) && $A.util.isEmpty(city) && $A.util.isEmpty(lastName) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(phoneNumber))){
      helper.fireToast("Error: Invalid Data", "Name search requires Last Name or Facility/Group Name and at least one of the following: First Name, City, State, Zip Code, or Phone Number", component, event, helper);
      returnError = true;
  } 
  //Search with state zipcode without other fields
  if (!$A.util.isEmpty(state) && !$A.util.isEmpty(zipCode) && ($A.util.isEmpty(city) && $A.util.isEmpty(lastName) && $A.util.isEmpty(firstName) && $A.util.isEmpty(phoneNumber))){
      helper.fireToast("Error: Invalid Data", "Name search requires Last Name or Facility/Group Name and at least one of the following: First Name, City, State, Zip Code, or Phone Number", component, event, helper);
      returnError = true;
  } 
  //Search with zipcode without other fields
  if (!$A.util.isEmpty(zipCode) && ($A.util.isEmpty(firstName) && $A.util.isEmpty(city) && $A.util.isEmpty(state) && $A.util.isEmpty(lastName) && $A.util.isEmpty(phoneNumber))){
      helper.fireToast("Error: Invalid Data", "Name search requires Last Name or Facility/Group Name and at least one of the following: First Name, City, State, Zip Code, or Phone Number", component, event, helper);
      returnError = true;
  } 
  //Search without field
  if ($A.util.isEmpty(lastName) && $A.util.isEmpty(firstName) && $A.util.isEmpty(state) && $A.util.isEmpty(providerType) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(phoneNumber) && $A.util.isEmpty(city)){
      helper.fireToast("Error: Invalid Data", "Name search requires Last Name or Facility/Group Name and at least one of the following: First Name, City, State, Zip Code, or Phone Number", component, event, helper);
      returnError = true;
  }   
            }
  var phoneCmpValue  = component.find('phoneId');
  if (!$A.util.isEmpty(phoneNumber)){
      isPhoneNumberValid = helper.validatePhoneNumber(component,event,helper,phoneCmpValue,10);
      if (!isPhoneNumberValid){
          returnError = true;
      }  
  }
  if (!isfNameValid || !islNameValid){                    
      returnError = true;
  }
  
  
  
}else if(searchType == 'Specialty') {
  //Search with provider type without other fields
  if (!$A.util.isEmpty(providerType) && ($A.util.isEmpty(classification) && $A.util.isEmpty(specialty) && $A.util.isEmpty(language) && $A.util.isEmpty(gender) && $A.util.isEmpty(city) && $A.util.isEmpty(state) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with provider type classification without other fields
  if (!$A.util.isEmpty(providerType) && !$A.util.isEmpty(classification) && ($A.util.isEmpty(specialty) && $A.util.isEmpty(language) && $A.util.isEmpty(gender) && $A.util.isEmpty(city) && $A.util.isEmpty(state) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with provider type classification specialty without other fields
  if (!$A.util.isEmpty(providerType) && !$A.util.isEmpty(classification) && !$A.util.isEmpty(specialty) && ($A.util.isEmpty(language) && $A.util.isEmpty(gender) && $A.util.isEmpty(city) && $A.util.isEmpty(state) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with provider type language without other fields
  if (!$A.util.isEmpty(providerType) && !$A.util.isEmpty(language) && ($A.util.isEmpty(classification) && $A.util.isEmpty(specialty) && $A.util.isEmpty(gender) && $A.util.isEmpty(city) && $A.util.isEmpty(state) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with provider type language gender without other fields
  if (!$A.util.isEmpty(providerType) && !$A.util.isEmpty(language) && !$A.util.isEmpty(gender) && ($A.util.isEmpty(classification) && $A.util.isEmpty(specialty) && $A.util.isEmpty(city) && $A.util.isEmpty(state) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with provider type gender without other fields
  if (!$A.util.isEmpty(providerType) && !$A.util.isEmpty(gender) && ($A.util.isEmpty(classification) && $A.util.isEmpty(specialty) && $A.util.isEmpty(city) && $A.util.isEmpty(state) && $A.util.isEmpty(language) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }                   
  //Search with classification without other fields
  if (!$A.util.isEmpty(classification) && ($A.util.isEmpty(providerType) && $A.util.isEmpty(specialty) && $A.util.isEmpty(language) && $A.util.isEmpty(gender) && $A.util.isEmpty(city) && $A.util.isEmpty(state) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with classification specialty without other fields
  if (!$A.util.isEmpty(classification) && !$A.util.isEmpty(specialty) && ($A.util.isEmpty(providerType) && $A.util.isEmpty(language) && $A.util.isEmpty(gender) && $A.util.isEmpty(city) && $A.util.isEmpty(state) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with classification specialty language without other fields
  if (!$A.util.isEmpty(classification) && !$A.util.isEmpty(specialty) && !$A.util.isEmpty(language) && ($A.util.isEmpty(providerType) && $A.util.isEmpty(gender) && $A.util.isEmpty(city) && $A.util.isEmpty(state) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with classification specialty language gender without other fields
  if (!$A.util.isEmpty(classification) && !$A.util.isEmpty(specialty) && !$A.util.isEmpty(language) && !$A.util.isEmpty(gender) && ($A.util.isEmpty(providerType) && $A.util.isEmpty(city) && $A.util.isEmpty(state) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with classification specialty language gender city without other fields
  if (!$A.util.isEmpty(classification) && !$A.util.isEmpty(specialty) && !$A.util.isEmpty(language) && !$A.util.isEmpty(gender) && !$A.util.isEmpty(city) && ($A.util.isEmpty(providerType) && $A.util.isEmpty(state) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with classification specialty language gender city state without other fields
  if (!$A.util.isEmpty(classification) && !$A.util.isEmpty(specialty) && !$A.util.isEmpty(language) && !$A.util.isEmpty(gender) && !$A.util.isEmpty(city) && !$A.util.isEmpty(state) && ($A.util.isEmpty(providerType) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with classification specialty language gender city state zipcode without other fields
  if (!$A.util.isEmpty(classification) && !$A.util.isEmpty(specialty) && !$A.util.isEmpty(language) && !$A.util.isEmpty(gender) && !$A.util.isEmpty(city) && !$A.util.isEmpty(state) && !$A.util.isEmpty(zipCode) && ($A.util.isEmpty(providerType) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with classification specialty language gender city state zipcode radius without other fields
  if (!$A.util.isEmpty(classification) && !$A.util.isEmpty(specialty) && !$A.util.isEmpty(language) && !$A.util.isEmpty(gender) && !$A.util.isEmpty(city) && !$A.util.isEmpty(state) && !$A.util.isEmpty(zipCode) && !$A.util.isEmpty(radius) && ($A.util.isEmpty(providerType))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with classification specialty language gender city state zipcode radius claimtype without other fields
  if (!$A.util.isEmpty(classification) && !$A.util.isEmpty(specialty) && !$A.util.isEmpty(language) && !$A.util.isEmpty(gender) && !$A.util.isEmpty(city) && !$A.util.isEmpty(state) && !$A.util.isEmpty(zipCode) && !$A.util.isEmpty(radius) && !$A.util.isEmpty(claimType) && ($A.util.isEmpty(providerType))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with specialty without other fields
  if (!$A.util.isEmpty(specialty) && ($A.util.isEmpty(classification) && $A.util.isEmpty(providerType) && $A.util.isEmpty(language) && $A.util.isEmpty(gender) && $A.util.isEmpty(city) && $A.util.isEmpty(state) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with specialty language without other fields
  if (!$A.util.isEmpty(specialty) && !$A.util.isEmpty(language) && ($A.util.isEmpty(classification) && $A.util.isEmpty(providerType) && $A.util.isEmpty(gender) && $A.util.isEmpty(city) && $A.util.isEmpty(state) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with specialty language gender without other fields
  if (!$A.util.isEmpty(specialty) && !$A.util.isEmpty(language) && !$A.util.isEmpty(gender) && ($A.util.isEmpty(classification) && $A.util.isEmpty(providerType) && $A.util.isEmpty(city) && $A.util.isEmpty(state) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with specialty language gender city without other fields
  if (!$A.util.isEmpty(specialty) && !$A.util.isEmpty(language) && !$A.util.isEmpty(gender) && !$A.util.isEmpty(city) && ($A.util.isEmpty(classification) && $A.util.isEmpty(providerType) &&  $A.util.isEmpty(state) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with specialty language gender city state without other fields
  if (!$A.util.isEmpty(specialty) && !$A.util.isEmpty(language) && !$A.util.isEmpty(gender) && !$A.util.isEmpty(city) && !$A.util.isEmpty(state) && ($A.util.isEmpty(classification) && $A.util.isEmpty(providerType) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with specialty language gender city state zipcode without other fields
  if (!$A.util.isEmpty(specialty) && !$A.util.isEmpty(language) && !$A.util.isEmpty(gender) && !$A.util.isEmpty(city) && !$A.util.isEmpty(state) && !$A.util.isEmpty(zipCode) && ($A.util.isEmpty(classification) && $A.util.isEmpty(providerType) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with specialty language gender city state zipcode radius without other fields
  if (!$A.util.isEmpty(specialty) && !$A.util.isEmpty(language) && !$A.util.isEmpty(gender) && !$A.util.isEmpty(city) && !$A.util.isEmpty(state) && !$A.util.isEmpty(zipCode) && !$A.util.isEmpty(radius)&& ($A.util.isEmpty(classification) && $A.util.isEmpty(providerType))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with specialty language gender city state zipcode radius claimtype without other fields
  if (!$A.util.isEmpty(specialty) && !$A.util.isEmpty(language) && !$A.util.isEmpty(gender) && !$A.util.isEmpty(city) && !$A.util.isEmpty(state) && !$A.util.isEmpty(zipCode) && !$A.util.isEmpty(radius) && !$A.util.isEmpty(claimType) && ($A.util.isEmpty(classification) && $A.util.isEmpty(providerType))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with language without other fields
  if (!$A.util.isEmpty(language) && ($A.util.isEmpty(classification) && $A.util.isEmpty(providerType) && $A.util.isEmpty(specialty) && $A.util.isEmpty(gender) && $A.util.isEmpty(city) && $A.util.isEmpty(state) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with language gender without other fields
  if (!$A.util.isEmpty(language) && !$A.util.isEmpty(gender) && ($A.util.isEmpty(classification) && $A.util.isEmpty(providerType) && $A.util.isEmpty(specialty) && $A.util.isEmpty(city) && $A.util.isEmpty(state) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with language gender city without other fields
  if (!$A.util.isEmpty(language) && !$A.util.isEmpty(gender) && !$A.util.isEmpty(city) && ($A.util.isEmpty(classification) && $A.util.isEmpty(providerType) && $A.util.isEmpty(specialty) && $A.util.isEmpty(state) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with language gender city state without other fields
  if (!$A.util.isEmpty(language) && !$A.util.isEmpty(gender) && !$A.util.isEmpty(city) && !$A.util.isEmpty(state) && ($A.util.isEmpty(classification) && $A.util.isEmpty(providerType) && $A.util.isEmpty(specialty) &&  $A.util.isEmpty(zipCode) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with language gender city state zipcode without other fields
  if (!$A.util.isEmpty(language) && !$A.util.isEmpty(gender) && !$A.util.isEmpty(city) && !$A.util.isEmpty(state) && !$A.util.isEmpty(zipCode) && ($A.util.isEmpty(classification) && $A.util.isEmpty(providerType) && $A.util.isEmpty(specialty) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with language gender city state zipcode radius without other fields
  if (!$A.util.isEmpty(language) && !$A.util.isEmpty(gender) && !$A.util.isEmpty(city) && !$A.util.isEmpty(state)&& !$A.util.isEmpty(zipCode) && !$A.util.isEmpty(radius) && ($A.util.isEmpty(classification) && $A.util.isEmpty(providerType) && $A.util.isEmpty(specialty))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with language gender city state zipcode radius claimtype without other fields
  if (!$A.util.isEmpty(language) && !$A.util.isEmpty(gender) && !$A.util.isEmpty(city) && !$A.util.isEmpty(state) && !$A.util.isEmpty(zipCode) && !$A.util.isEmpty(radius) && !$A.util.isEmpty(claimType) && ($A.util.isEmpty(classification) && $A.util.isEmpty(specialty) &&  $A.util.isEmpty(providerType))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  
  //Search with  gender without other fields
  if (!$A.util.isEmpty(gender) && ($A.util.isEmpty(language) && $A.util.isEmpty(classification) && $A.util.isEmpty(providerType) && $A.util.isEmpty(specialty) && $A.util.isEmpty(city) && $A.util.isEmpty(state) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with gender city without other fields
  if (!$A.util.isEmpty(gender) && !$A.util.isEmpty(city) && ($A.util.isEmpty(language) && $A.util.isEmpty(classification) && $A.util.isEmpty(providerType) && $A.util.isEmpty(specialty) && $A.util.isEmpty(state) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with gender city state without other fields
  if (!$A.util.isEmpty(gender) && !$A.util.isEmpty(city) && !$A.util.isEmpty(state) && ($A.util.isEmpty(language) && $A.util.isEmpty(classification) && $A.util.isEmpty(providerType) && $A.util.isEmpty(specialty) &&  $A.util.isEmpty(zipCode) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with gender city state zipcode without other fields
  if (!$A.util.isEmpty(gender) && !$A.util.isEmpty(city) && !$A.util.isEmpty(state) && !$A.util.isEmpty(zipCode) && ($A.util.isEmpty(language) && $A.util.isEmpty(classification) && $A.util.isEmpty(providerType) && $A.util.isEmpty(specialty) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with gender city state zipcode radius without other fields
  if (!$A.util.isEmpty(gender) && !$A.util.isEmpty(city) && !$A.util.isEmpty(state)&& !$A.util.isEmpty(zipCode) && !$A.util.isEmpty(radius) && ($A.util.isEmpty(language)&& $A.util.isEmpty(classification) && $A.util.isEmpty(providerType) && $A.util.isEmpty(specialty))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with  gender city state zipcode radius claimtype without other fields
  if (!$A.util.isEmpty(gender) && !$A.util.isEmpty(city) && !$A.util.isEmpty(state) && !$A.util.isEmpty(zipCode) && !$A.util.isEmpty(radius) && !$A.util.isEmpty(claimType) && ($A.util.isEmpty(language) && $A.util.isEmpty(classification) && $A.util.isEmpty(specialty) &&  $A.util.isEmpty(providerType))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  
  //Search with city without other fields
  if (!$A.util.isEmpty(city) && ($A.util.isEmpty(gender) && $A.util.isEmpty(language) && $A.util.isEmpty(classification) && $A.util.isEmpty(providerType) && $A.util.isEmpty(specialty) && $A.util.isEmpty(state) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with city state without other fields
  if (!$A.util.isEmpty(city) && !$A.util.isEmpty(state) && ($A.util.isEmpty(gender) && $A.util.isEmpty(language) && $A.util.isEmpty(classification) && $A.util.isEmpty(providerType) && $A.util.isEmpty(specialty) &&  $A.util.isEmpty(zipCode) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
     returnError = true;
  }
  //Search with city state zipcode without other fields
  if (!$A.util.isEmpty(city) && !$A.util.isEmpty(state) && !$A.util.isEmpty(zipCode) && ($A.util.isEmpty(gender) && $A.util.isEmpty(language) && $A.util.isEmpty(classification) && $A.util.isEmpty(providerType) && $A.util.isEmpty(specialty) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with city state zipcode radius without other fields
  if (!$A.util.isEmpty(city) && !$A.util.isEmpty(state)&& !$A.util.isEmpty(zipCode) && !$A.util.isEmpty(radius) && ($A.util.isEmpty(gender)&& $A.util.isEmpty(language)&& $A.util.isEmpty(classification) && $A.util.isEmpty(providerType) && $A.util.isEmpty(specialty))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with city state zipcode radius claimtype without other fields
  if (!$A.util.isEmpty(city) && !$A.util.isEmpty(state) && !$A.util.isEmpty(zipCode) && !$A.util.isEmpty(radius) && !$A.util.isEmpty(claimType) && ($A.util.isEmpty(gender) && $A.util.isEmpty(language) && $A.util.isEmpty(classification) && $A.util.isEmpty(specialty) &&  $A.util.isEmpty(providerType))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }                    
  //Search with state without other fields
  if (!$A.util.isEmpty(state) && ($A.util.isEmpty(city) && $A.util.isEmpty(gender) && $A.util.isEmpty(language) && $A.util.isEmpty(classification) && $A.util.isEmpty(providerType) && $A.util.isEmpty(specialty) &&  $A.util.isEmpty(zipCode) && $A.util.isEmpty(radius))){
      
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with state zipcode without other fields
  if (!$A.util.isEmpty(state) && !$A.util.isEmpty(zipCode) && ($A.util.isEmpty(city) && $A.util.isEmpty(gender) && $A.util.isEmpty(language) && $A.util.isEmpty(classification) && $A.util.isEmpty(providerType) && $A.util.isEmpty(specialty) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with state zipcode radius without other fields
  if (!$A.util.isEmpty(state) && !$A.util.isEmpty(zipCode) && !$A.util.isEmpty(radius) && ($A.util.isEmpty(city) && $A.util.isEmpty(gender)&& $A.util.isEmpty(language) && $A.util.isEmpty(classification) && $A.util.isEmpty(providerType) && $A.util.isEmpty(specialty))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with state zipcode radius claimtype without other fields
  if (!$A.util.isEmpty(state) && !$A.util.isEmpty(zipCode) && !$A.util.isEmpty(radius) && !$A.util.isEmpty(claimType)&& ($A.util.isEmpty(city) && $A.util.isEmpty(gender) && $A.util.isEmpty(language) && $A.util.isEmpty(classification) && $A.util.isEmpty(specialty) &&  $A.util.isEmpty(providerType))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with zipcode without other fields
  if (!$A.util.isEmpty(zipCode) && ($A.util.isEmpty(state) && $A.util.isEmpty(city) && $A.util.isEmpty(gender)&& $A.util.isEmpty(language) && $A.util.isEmpty(classification) && $A.util.isEmpty(providerType) && $A.util.isEmpty(specialty) && $A.util.isEmpty(radius))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with zipcode radius without other fields
  if (!$A.util.isEmpty(zipCode) && !$A.util.isEmpty(radius) && ($A.util.isEmpty(state) && $A.util.isEmpty(city)&& $A.util.isEmpty(gender)&& $A.util.isEmpty(language)&& $A.util.isEmpty(classification) && $A.util.isEmpty(providerType) && $A.util.isEmpty(specialty))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with zipcode radius claimtype without other fields
  if (!$A.util.isEmpty(zipCode) && !$A.util.isEmpty(radius) && !$A.util.isEmpty(claimType) && ($A.util.isEmpty(state) && $A.util.isEmpty(city) && $A.util.isEmpty(gender) && $A.util.isEmpty(language) && $A.util.isEmpty(classification) && $A.util.isEmpty(specialty) &&  $A.util.isEmpty(providerType))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with radius without other fields
  if (!$A.util.isEmpty(radius) && ($A.util.isEmpty(zipCode) && $A.util.isEmpty(state) && $A.util.isEmpty(city) && $A.util.isEmpty(gender) && $A.util.isEmpty(language) && $A.util.isEmpty(classification) && $A.util.isEmpty(providerType) && $A.util.isEmpty(specialty))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }
  //Search with radius claimtype without other fields
  if (!$A.util.isEmpty(radius) && !$A.util.isEmpty(claimType) && ($A.util.isEmpty(zipCode) && $A.util.isEmpty(state) && $A.util.isEmpty(city) && $A.util.isEmpty(gender) && $A.util.isEmpty(language) && $A.util.isEmpty(classification) && $A.util.isEmpty(specialty) &&  $A.util.isEmpty(providerType))){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  }  
  //Search with claimtype without other fields
  if (!$A.util.isEmpty(claimType) && ($A.util.isEmpty(zipCode) && $A.util.isEmpty(state) && $A.util.isEmpty(city) && $A.util.isEmpty(gender) && $A.util.isEmpty(language) && $A.util.isEmpty(classification) && $A.util.isEmpty(specialty) &&  $A.util.isEmpty(providerType) && $A.util.isEmpty(radius))){
     helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  } 
  //Search without fields
  if ($A.util.isEmpty(claimType) && $A.util.isEmpty(zipCode) && $A.util.isEmpty(state) && $A.util.isEmpty(radius) && $A.util.isEmpty(city) && $A.util.isEmpty(providerType) && $A.util.isEmpty(gender) && $A.util.isEmpty(language) && $A.util.isEmpty(classification) && $A.util.isEmpty(specialty)){
      helper.fireToast("Error: Invalid Data", "Specialty search requires Provider Type, Classification, Specialty and at least one of the following: City, State, Zip Code, Language, or Gender", component, event, helper);
      returnError = true;
  } 
  var radiusCmpValue  = component.find('radiusId');
  isRadiusValid = helper.validateRadius(component,event,helper,radiusCmpValue,zipCode);
  if (!isRadiusValid){                    
      returnError = true;
  }
  
  
}

if (returnError)
  return;
var attributeList = component.get("v.attribueList");
if(searchType == 'Specialty') {
  if(component.find('specialityId').get("v.value")!= '--None--' && component.find('specialityId').get("v.value") != 'Select Classification') { 
      specialty = component.find('specialityId').get("v.value"); 
  }
  radius = component.get("v.radius");    
  /**if(component.find('claimTypeId').get("v.value") != '--None--'){
      claimType = component.find('claimTypeId').get("v.value");
      alert(claimType);
  }*/
  if(component.find('classificationId').get("v.value") != '--None--' && component.find('classificationId').get("v.value")!= 'Select Provider Type') {
      classification = component.find('classificationId').get("v.value");
  }
  if(component.find('languageId').get("v.value")!= '--None--') { 
      language = component.find('languageId').get("v.value"); 
  }
  if(component.find('genderId').get("v.value")!= '--None--') { 
      gender = component.find('genderId').get("v.value"); 
  }
}
if(searchType == 'Name' || searchType == 'Specialty') {
  state =  component.find('selStateOptionsSpecialtySearch').find('selstate').get("v.value");
}else if(searchType == 'ID') {
  state =  component.find('selStateOptions').find('selstate').get("v.value");
}
var acceptNewPatent = component.find('acceptNewPatentId').get("v.value"); 
var strNewpatientsInd,strFreeStandingFacl;
if(acceptNewPatent) {
  strNewpatientsInd = 'Y';
}else {
  strNewpatientsInd = '';
}
var practicingStatus = component.find('practicingstatusId').get("v.value");
var networkMap = component.get("v.networkMap");
var freeStandingFacility = component.find('FreeStandFacilityId').get("v.value");
if(freeStandingFacility) {
  strFreeStandingFacl = 'FSF';
}else {
  strFreeStandingFacl = '';
}
var benefitServiceArea;
var serviceType;
var selectedNetwork= '';
if(searchRadioValue == 'Basic' || (searchRadioValue == 'Advanced' && selectNetworkStatusRadioValue == 'INN Only')) {
   benefitServiceArea = component.get("v.benefitServiceArea");
  serviceType = component.get("v.serviceType");											  
   if(serviceType == 'Service Area could not be determined'){
     serviceType = '';
   }else {
       serviceType = component.get("v.serviceType");
   }
   if(network == '' && networkMap!= null) {
      for(var i =0; i< networkMap.length; i++) {
         var ntwArray = networkMap[i].value;
         for(var j =0; j<ntwArray.length; j++) {
           if(networkMap[i].key == benefitTier) {
                  selectedNetwork = selectedNetwork.concat(ntwArray[j].split('_')[0] + '@');
           }
         }
     }
  }
  if(selectedNetwork.length > 0) {
      var selectedNetworkId = selectedNetwork.substring(0, selectedNetwork.length - 1);
      network = selectedNetworkId;
  }
}else {
  benefitServiceArea = '';
  serviceType= '';
  network = '';
}
helper.showResults(component,event, helper,specialty,radius,claimType,classification,language,gender,state,strNewpatientsInd,practicingStatus,strFreeStandingFacl,taxId,lastName,phoneNumber,firstName,searchPcpOBGYNId,providerType,searchProviderId,npi,city,zipCode,network,qualityTierRuleId,qualityTierLevel,benefitTier,serviceType,benefitServiceArea,attributeList,ddpChecked);

//component.set("v.showAndHideResults",true);

},
generateUniqueName: function(component,memId) {
debugger;
var len = 10;
var buf = [],
  chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
  charlen = chars.length,
  length = len || 32;
  
for (var i = 0; i < length; i++) {
  buf[i] = chars.charAt(Math.floor(Math.random() * charlen));
}
var providerGUIkey = buf.join('');
component.set("v.basicAdvancedRadioName", memId+providerGUIkey);
}  
})