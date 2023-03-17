import { LightningElement, api,wire } from "lwc";

//use below imports to import the static resource and script and style loader of static resource
import ACET_LWC_Util from "@salesforce/resourceUrl/ACET_LWC_Util";
import { loadScript } from "lightning/platformResourceLoader";
// import getOrgFieldsetFields from '@salesforce/apex/acet_testcls.getOrgFieldsetFields';
import getOrgFieldsetFields from '@salesforce/apex/ETSBE_OneClickController.getOrgFieldsetFields';
import searchOriginatorSolaris from "@salesforce/apex/ETSBE_OneClickController.searchOriginatorSolaris";
import submitAdd from "@salesforce/apex/ETSBE_OneClickController.submitAdd";
import submitEdit from "@salesforce/apex/ETSBE_OneClickController.submitEdit";

export default class Acet_AddOriginator extends LightningElement {
  orginatorOptions;
  @api buttonLabelContext;
  @api originatorInformation;
  selOrgVal = "";
 // disableOrgTypeonEdit = false;
  //add this variable to check if a field is required
  fieldRequiredCheck = false;
  fieldsetFields;
  renderOnce;
  solarisResults=[];
  solarisTableColumns=[];
  isSolarisResultDisplay=false;
  validateOriginator;
  editedRecordId ;
  solarisErrorDisplay;
  solarisErrorMessage;
  isValidation=true;
  constructor() {
     super();
    
  }
  @wire(getOrgFieldsetFields) 
       FieldSetresult({ error, data }) {
        if (data) {
          if(this.buttonLabelContext == 'Edit'){
             console.log('originatorInformation---1-');
            console.log(this.originatorInformation);
            console.log('originatorInformation---2-');
            let editedData = this.originatorInformation;
           // editedData = editedData.replace('",', ';');
           editedData = editedData.replace(/",/g, ';');
            editedData = editedData.replace(/[{}'"]+/g, '');
            var orgVal = '';
            let selOrig = new Map();
            var otherOrgType = '';
            console.log(editedData);
            console.log('originatorInformation---3-');

            if(editedData.indexOf(';') != -1){
              var editedDataSplitcomma = editedData.split(';');
              for( var j=0; j < editedDataSplitcomma.length ; j++){
                if(editedDataSplitcomma[j].indexOf(':') != -1){
                  var editedDataSplitcolon = editedDataSplitcomma[j].split(':');
                  if(editedDataSplitcolon.length == 2){
                    if(editedDataSplitcolon[1].trim() == 'undefined')
                       selOrig.set(editedDataSplitcolon[0].trim(),null);
                    else
                    selOrig.set(editedDataSplitcolon[0].trim(),editedDataSplitcolon[1].trim());
                    if(editedDataSplitcolon[0] == 'Originator_Type__c'){
                      orgVal = editedDataSplitcolon[1].trim();
                    }
                      if(editedDataSplitcolon[0] == 'Other_Originator_Type__c'){
                        otherOrgType = editedDataSplitcolon[1].trim();
                      }
                    }
                  }
                }
              }
              this.editedRecordId = selOrig.get('Id');
              let tempAllRecords = Object.assign([], data);
              var fieldNames = data[0].hiddenFields;
              let selectedOriginator =new Map();
              for(var n=0;n<data.length;n++){
                  let tempRec = Object.assign({}, tempAllRecords[n]);
				          if(tempRec.apiName == 'Phone_Ext__c' ){
                    tempRec.name = 'Extension';
                  }
                  else  if(tempRec.apiName == 'Other_Originator_Type__c' ){
                    tempRec.name = 'Type';
                  }
                  if(tempRec.apiName == 'Originator_Type__c' ){
                    tempRec.isDisable = true;
                  }
                  
                  if(tempRec.apiName != '' && tempRec.apiName != null && selOrig.has(tempRec.apiName)){
                    tempRec.value = selOrig.get(tempRec.apiName);
                    selectedOriginator.set(tempRec.apiName,tempRec.value);// for solaris validation
                    if(tempRec.apiName == 'Originator_Type__c'){
                      var picklst = [];
                      picklst.push(selOrig.get(tempRec.apiName));
                      tempRec.picklistValues = picklst;
                    }
                    if(tempRec.apiName == 'Other_Originator_Type__c'){
                      var picklst = [];
                      picklst.push(selOrig.get(tempRec.apiName));
                      for(var i =0; i< tempRec.picklistValues.length; i++ ) {
                        if(tempRec.picklistValues[i] != picklst[0]) {
                          picklst.push(tempRec.picklistValues[i]);
                        }
                      }
                      tempRec.picklistValues = picklst;
                    }
                    if(tempRec.apiName == 'Originator_Role__c'){
                      var picklst = [];
                      if(selOrig.get(tempRec.apiName)) {
                        picklst.push(selOrig.get(tempRec.apiName));
                        for(var i =0; i< tempRec.picklistValues.length; i++ ) {
                          if(tempRec.picklistValues[i] != picklst[0]) {
                            picklst.push(tempRec.picklistValues[i]);
                          }
                        }
                        tempRec.picklistValues = picklst;
                      }
                    }
                  }
                  else{
                    tempRec.value = '';
                  }
                  console.log('orgVal' +orgVal+'otherOrgType' +otherOrgType);
                  if( (orgVal == 'Agency/Broker' &&  (tempRec.apiName == 'Agency_Broker_Name__c' ||
                  tempRec.apiName == 'Reward_Account_Number__c' )) ||
                 (orgVal == 'General Agent' &&  (tempRec.apiName == 'General_Agency__c' ||
                 tempRec.apiName == 'Franchise_Code__c' )) ||
                  (orgVal == 'Group Contact' &&  (tempRec.apiName == 'Group_Name__c' ||
                  tempRec.apiName == 'Group_Number__c' || tempRec.apiName == 'Policy_Number__c'  ))||
                  (orgVal == 'Other Originator' && tempRec.apiName == 'Other_Originator_Type__c') ||
                  (orgVal == 'Other Originator' && otherOrgType == 'Other' && tempRec.apiName == 'Originator_Role__c')
                  ){
                    console.log(tempRec);
                    tempRec.isVisible=true;
                }
                else{
                    if( fieldNames.includes(tempRec.apiName) ){
                        tempRec.isVisible=false;
                    }
                }
                tempAllRecords[n] = tempRec;
            }
            this.fieldsetFields = tempAllRecords;
           // this.disableOrgTypeonEdit = true;
            this.solarisValidationOnEdit(orgVal,selectedOriginator); // solaris validation on edit
          
          }
          else{ // new record
            let tempAllRecords = Object.assign([], data);
            for(var k=0;k<data.length;k++){
              let tempRec = Object.assign({}, tempAllRecords[k]);
              if(tempRec.apiName == 'Phone_Ext__c' ){
                tempRec.name = 'Extension';
              }
              else  if(tempRec.apiName == 'Other_Originator_Type__c' ){
                tempRec.name = 'Type';
              }
              if(tempRec.apiName == 'Originator_Type__c' ){
                tempRec.isDisable = false;
              }
              tempAllRecords[k] = tempRec;
            }
            this.fieldsetFields = tempAllRecords;
          }
         
        }
  }
  
  renderedCallback() {
    //Use the below code to call methods from static resource file
    loadScript(this, ACET_LWC_Util)
      .then(() => window.validateRequiredOnLoad(this))
      .catch((error) => console.log(error));
  }
  @api
  saveOriginator(){
    var orgType=true;
    var otherOrgType=true;
    let selOrig = new Map();
    for(var i=0;i<this.fieldsetFields.length;i++){
        selOrig.set(this.fieldsetFields[i].apiName,this.fieldsetFields[i].value);
        if(this.fieldsetFields[i].apiName=='Originator_Type__c' && this.fieldsetFields[i].value==undefined){
          this.orgType = false;
        }
        if(this.fieldsetFields[i].apiName=='Other_Originator_Type__c' && this.fieldsetFields[i].value==undefined){
          this.otherOrgType = false;
        }
    }
    this.validateRequiredFields(orgType,otherOrgType);
  if(this.isValidation==true){
    if(this.buttonLabelContext != 'Edit'){
    submitAdd({
     editSfId: null,
     editFirstName: selOrig.get('First_Name__c'),
     editLastName: selOrig.get('Last_Name__c'),
     editPhone: selOrig.get('Phone_Number__c'),
     editPhoneExt: selOrig.get('Phone_Ext__c'),
     editEmail: selOrig.get('Email__c'),
     editOriginatorType: selOrig.get('Originator_Type__c'),
     editAgencyBroker: selOrig.get('Agency_Broker_Name__c'),
     editRewardAccount: selOrig.get('Reward_Account_Number__c'),
     editGeneralAgency: selOrig.get('General_Agency__c'),
     editFranchiseCode: selOrig.get('Franchise_Code__c'),
     editGroupName: selOrig.get('Group_Name__c'),
     editGroupNum: selOrig.get('Group_Number__c'),
     editPolicyNum: selOrig.get('Policy_Number__c'),
     editOtherOrigType: selOrig.get('Other_Originator_Type__c'),
     editOtherOrigRole: selOrig.get('Originator_Role__c')
      
          
      })
      .then(result=>{
        var labelStr='';
              if (result.Originator_Type__c == "Other Originator") {
                  if(result.Other_Originator_Type__c == 'Other' && result.Originator_Role__c && result.Originator_Role__c!= 'None') {
                    labelStr= result.Originator_Role__c;
                 }else {
                  labelStr= result.Other_Originator_Type__c;
                 }
                  labelStr+= "   " +result.Last_Name__c +", " +result.First_Name__c +
                  //"   " +result.Phone_Number__c +
                  "   " +selOrig.get('Phone_Number__c')+
                  "   " +result.Email__c;
            } else if (result.Originator_Type__c == "Group Contact") {
                labelStr= result.Originator_Type__c +
                  " " +result.Last_Name__c +
                  ", " +result.First_Name__c +
                  //"   " +result.Phone_Number__c +
                  "   " +selOrig.get('Phone_Number__c')+
                  "   " +result.Email__c;
            } else if (result.Originator_Type__c == "Agency/Broker") {
                labelStr=result.Originator_Type__c +
                  "  " +result.Last_Name__c +
                  ", " +result.First_Name__c +
                  //"   " +result.Phone_Number__c +
                  "   " +selOrig.get('Phone_Number__c')+
                  "   " +result.Email__c;
            } else if (result.Originator_Type__c == "General Agent") {
                labelStr=result.Originator_Type__c +
                  " " +result.Last_Name__c +
                  ", " +result.First_Name__c +
                  //"   " +result.Phone_Number__c +
                  "   " +selOrig.get('Phone_Number__c')+
                  "   " +result.Email__c;
            } else {
                labelStr=result.Originator_Type__c +
                  "   " +result.Last_Name__c +
                  ", " +result.First_Name__c +
                  //"   " +result.Phone_Number__c +
                  "   " +selOrig.get('Phone_Number__c')+
                  "   " +result.Email__c;
            }
        result.Phone_Number__c  = this.formatPhoneNumber(result.Phone_Number__c);
        const selectEvent = new CustomEvent ('newOriginatorEvent', {
            detail:{
            originatorData: labelStr,
            originatorjson: JSON.stringify(result)
            },bubbles: true,composed : true
        });
        this.dispatchEvent(selectEvent);
    })
    .catch(error=>{
            this.error=error;
    })
  }
  else{
    let selOrig = new Map();
    let selOrgType = '';
    var selValue = '';
    var selOtherOrgType;
    for(var i=0;i<this.fieldsetFields.length;i++){
      if(this.fieldsetFields[i].apiName == 'Originator_Type__c'){
        selOrgType = this.fieldsetFields[i].value;
      }
      if(this.fieldsetFields[i].apiName == 'Other_Originator_Type__c'){
        selOtherOrgType = this.fieldsetFields[i].value;
      }
      if(selValue == ''){
           selValue =  '{"Id":"'+this.editedRecordId+'","'+this.fieldsetFields[i].apiName+'":"'+this.fieldsetFields[i].value+'"';
      }
      else{
           selValue = selValue+',"'+this.fieldsetFields[i].apiName+'":"'+this.fieldsetFields[i].value+'"';
      }
      selOrig.set(this.fieldsetFields[i].apiName,this.fieldsetFields[i].value);
    }
    if(selValue != ''){
      selValue = selValue + '}';
    }
    submitEdit({
     editSfId: this.editedRecordId,
     editFirstName: selOrig.get('First_Name__c'),
     editLastName: selOrig.get('Last_Name__c'),
     editPhone: selOrig.get('Phone_Number__c'),
     editPhoneExt: selOrig.get('Phone_Ext__c'),
     editEmail: selOrig.get('Email__c'),
     editOriginatorType: selOrig.get('Originator_Type__c'),
     editAgencyBroker: selOrig.get('Agency_Broker_Name__c'),
     editRewardAccount: selOrig.get('Reward_Account_Number__c'),
     editGeneralAgency: selOrig.get('General_Agency__c'),
     editFranchiseCode: selOrig.get('Franchise_Code__c'),
     editGroupName: selOrig.get('Group_Name__c'),
     editGroupNum: selOrig.get('Group_Number__c'),
     editPolicyNum: selOrig.get('Policy_Number__c'),
     editOtherOrigType: selOrig.get('Other_Originator_Type__c'),
     editOtherOrigRole: selOrig.get('Originator_Role__c')
     })
      .then(result=>{
  
              var labelStr='';
              if (selOrgType == "Other Originator") {
                if(selOtherOrgType == 'Other' && selOrig.get('Originator_Role__c') && selOrig.get('Originator_Role__c') != 'None') {
                  labelStr= selOrig.get('Originator_Role__c');
                }else {
                  labelStr= selOrig.get('Other_Originator_Type__c');
                }
                  labelStr+=
                    "   " +selOrig.get('Last_Name__c') +", " +selOrig.get('First_Name__c') +
                    "   " +selOrig.get('Phone_Number__c') +
                    "   " +selOrig.get('Email__c');
              } else if (selOrgType == "Group Contact") {
                  labelStr= selOrig.get('Originator_Type__c') +
                    " , " +selOrig.get('Policy_Number__c') +
                    ", " +selOrig.get('Last_Name__c') +
                    ", " +selOrig.get('First_Name__c') +
                    "   " +selOrig.get('Phone_Number__c') +
                    "   " +selOrig.get('Email__c');
              } else if (selOrgType == "Agency/Broker") {
                  labelStr= selOrig.get('Originator_Type__c') +
                    " , " +selOrig.get('Reward_Account_Number__c') +
                    ", " +selOrig.get('Last_Name__c') +
                    ", " +selOrig.get('First_Name__c') +
                    "   " +selOrig.get('Phone_Number__c') +
                    "   " +selOrig.get('Email__c');
              } else if (selOrgType == "General Agent") {
                  labelStr=selOrig.get('Originator_Type__c') +
                    ",  " +selOrig.get('Franchise_Code__c') +
                    ", " +selOrig.get('Last_Name__c') +
                    ", " +selOrig.get('First_Name__c') +
                    "   " +selOrig.get('Phone_Number__c') +
                    "   " +selOrig.get('Email__c');
              } else {
                  labelStr=selOrig.get('Originator_Type__c') +
                    "   " +selOrig.get('Last_Name__c') +
                    ", " +selOrig.get('First_Name__c') +
                    "   " +selOrig.get('Phone_Number__c') +
                    "   " +selOrig.get('Email__c');
              }
            const selectEvent = new CustomEvent ('newOriginatorEvent', {
              detail:{
              originatorData: labelStr,
              originatorjson: selValue
              },bubbles: true,composed : true
          });
          this.dispatchEvent(selectEvent);
      })
      .catch(error=>{
              this.error=error;
      })
    }
   } 
  }
    
  checkValueExist(apiField1,apiField2){
     var field1 = false;var field2 = false;
     debugger;
     for(var i=0;i<this.fieldsetFields.length;i++){
         let tempRec = Object.assign({}, this.fieldsetFields[i]);
         if( tempRec.apiName == apiField1){
             if(tempRec.value == undefined || tempRec.value =='' || tempRec.value =='null'){
                field1 = false;
             }
             else{
                 field1 = true;
                 break;
             }
         }
         else if(apiField2 != null && tempRec.apiName == apiField2){
             if(tempRec.value == undefined || tempRec.value ==''  || tempRec.value =='null'){
                field2 = false;
             }
             else{
                 field2 = true;
                 break;
             }
         }
     }
     if(field1 || field2){
       return true;
     }
     else{
         return false;
     }
  }
  solarisValidationOnEdit(selectedOrgType,selectedOriginator){
        if (
          selectedOrgType == "Agency/Broker" ||
          selectedOrgType == "General Agent" ||
          selectedOrgType == "Group Contact"
        ) {
               
               this.solarisResults=[];
               this.solarisTableColumns=[];
               this.isSolarisResultDisplay=false;
               this.solarisErrorMessage = '';
               this.solarisErrorDisplay = false;
               
                  if( selectedOrgType == "Agency/Broker"){
                    this.solarisErrorMessage = 'Enter a valid Rewards Account Number and Agency/Broker Name.';
                  }
                  else if(selectedOrgType == "General Agent"){
                    this.solarisErrorMessage = 'Enter a valid Franchise Code.';
                  }
                  else if(selectedOrgType == "Group Contact"){
                     this.solarisErrorMessage = 'Enter a valid Group Number or Policy Number.';
                  }
                  searchOriginatorSolaris({ 
                       editSfId: null,
                       editFirstName: selectedOriginator.get('First_Name__c'),
                       editLastName: selectedOriginator.get('Last_Name__c'),
                       editPhone: selectedOriginator.get('Phone_Number__c'),
                       editPhoneExt: selectedOriginator.get('Phone_Ext__c'),
                       editEmail: selectedOriginator.get('Email__c'),
                       editOriginatorType: selectedOriginator.get('Originator_Type__c'),
                       editAgencyBroker: selectedOriginator.get('Agency_Broker_Name__c'),
                       editRewardAccount: selectedOriginator.get('Reward_Account_Number__c'),
                       editGeneralAgency: selectedOriginator.get('General_Agency__c'),
                       editFranchiseCode: selectedOriginator.get('Franchise_Code__c'),
                       editGroupName: selectedOriginator.get('Group_Name__c'),
                       editGroupNum: selectedOriginator.get('Group_Number__c'),
                       editPolicyNum: selectedOriginator.get('Policy_Number__c'),
                       editOtherOrigType: selectedOriginator.get('Other_Originator_Type__c')
                   })  
                     .then((result) => {
                       if(result.length > 0){
                       var allResults = [];
                       allResults = result;
                       var tableResults = [];
                       var foundMatch = false;
                           if(allResults.length > 0 && allResults[0][0] == 'Too Many Results'){
                                 this.validateOriginator =false;
                           } else {
                                   if(selectedOriginator.get('Originator_Type__c') == 'Agency/Broker'){
                                       for(var i = 0; i < allResults.length; i++){
                                           tableResults=[];
                                           if(allResults[i].length == 2){
                                              tableResults.push(allResults[i][1],allResults[i][0]);
                                              this.solarisResults.push({value:tableResults, key:'AgencyBroker'+i});
                                              if(allResults[i][0] == selectedOriginator.get('Reward_Account_Number__c') && allResults[i][1] == selectedOriginator.get('Agency_Broker_Name__c')){
                                                foundMatch = true;
                                               } 
                                          }
                                      }
                                      this.solarisTableColumns.push('Reward Account Name','Reward Account Number');
                                   } else if(selectedOriginator.get('Originator_Type__c') == 'General Agent'){
                                       for(var i = 0; i < allResults.length; i++){
                                           tableResults=[];
                                           if(allResults[i].length == 2){
                                              tableResults.push(allResults[i][1],allResults[i][0]);
                                               this.solarisResults.push({value:tableResults, key:'GeneralAgency'+i});
                                               if(allResults[i][1] == selectedOriginator.get('Franchise_Code__c') && allResults[i][0] == selectedOriginator.get('General_Agency__c')){
                                                 foundMatch = true;
                                               }
                                          }
                                       }
                                       
                                       this.solarisTableColumns.push('General Agency Name','Franchise Code');
    
                                   } else if(selectedOriginator.get('Originator_Type__c') == 'Group Contact'){
                                       for(var i = 0; i < allResults.length; i++){
                                           tableResults=[];
                                           if(allResults[i].length == 3){
                                              tableResults.push(allResults[i][0],allResults[i][1],allResults[i][2]);
                                               this.solarisResults.push({value:tableResults, key:'GroupContact'+i});
                                               if(allResults[i][0] == selectedOriginator.get('Group_Name__c') && allResults[i][1] == selectedOriginator.get('Group_Number__c') && allResults[i][2] == selectedOriginator.get('Policy_Number__c')){
                                                   foundMatch = true;
                                                  // this.validateOriginator = true;
                                               }
                                          }
                                      }
                                      this.solarisTableColumns.push('Group Name','Group Number','Policy Number');
                                  }
                                    if(foundMatch){
                                       //this.validateOriginator =false;
                                       this.isSolarisResultDisplay=false;
                                    }
                                    else{
                                      this.isSolarisResultDisplay=true;
                                    }
                                    
                           }
                        }
                        else{
                          //console.log('show solaris error---');
                          this.solarisErrorMessage = 'No results found. '+this.solarisErrorMessage;
                          this.solarisErrorDisplay = true;
                        }
                     }) 
                     .catch((error) => {  
                       this.error = error;  
                       //this.validateOriginator = false;  
                      });  
               
           }     
        
  }
  
  
  handleFocusOut(event){
     this.setValue(event.target.name,event.target.value,'','','','');
     if(event.target.name == 'Agency_Broker_Name__c' || event.target.name == 'Reward_Account_Number__c' || event.target.name == 'Franchise_Code__c' 
        || event.target.name == 'Group_Number__c' || event.target.name == 'Policy_Number__c' ){
             var callSolaris = false;
             this.solarisResults=[];
             this.solarisTableColumns=[];
             this.isSolarisResultDisplay=false;
             this.solarisErrorMessage = '';
             this.solarisErrorDisplay = false;
             if( event.target.name == 'Agency_Broker_Name__c' || event.target.name == 'Reward_Account_Number__c'){
                this.solarisErrorMessage = 'Enter a valid Rewards Account Number and Agency/Broker Name.';
                if(! this.checkValueExist('Agency_Broker_Name__c','Reward_Account_Number__c') ){
                  // event.target.setCustomValidity("Enter a valid Rewards Account Number and Agency/Broker Name.");
                  // event.target.reportValidity();
                  //this.solarisErrorMessage = 'Enter a valid Rewards Account Number and Agency/Broker Name.';
                  this.solarisErrorDisplay = true;
                  
                }
                else{
                    callSolaris = true;
                }                
              }
             else if(event.target.name ==  'Franchise_Code__c'){
                this.solarisErrorMessage = 'Enter a valid Franchise Code.';
                 if(! this.checkValueExist('Franchise_Code__c',null) ){
                     this.solarisErrorDisplay = true;
                 }
                 else{
                     callSolaris = true;
                 } 
             }
             else if((event.target.name == 'Group_Number__c' || event.target.name == 'Policy_Number__c' )){
                 this.solarisErrorMessage = 'Enter a valid Group Number or Policy Number.';
                 if(! this.checkValueExist('Group_Number__c','Policy_Number__c') ){
                    this.solarisErrorDisplay = true;
                 }
                 else{
                    callSolaris = true;
                 }
                  
             }
             if(callSolaris){
                 let selectedOriginator =new Map();
                 for(var i=0;i<this.fieldsetFields.length;i++){
                     selectedOriginator.set(this.fieldsetFields[i].apiName,this.fieldsetFields[i].value);
                 }
                 searchOriginatorSolaris({ 
                     editSfId: null,
                     editFirstName: selectedOriginator.get('First_Name__c'),
                     editLastName: selectedOriginator.get('Last_Name__c'),
                     editPhone: selectedOriginator.get('Phone_Number__c'),
                     editPhoneExt: selectedOriginator.get('Phone_Ext__c'),
                     editEmail: selectedOriginator.get('Email__c'),
                     editOriginatorType: selectedOriginator.get('Originator_Type__c'),
                     editAgencyBroker: selectedOriginator.get('Agency_Broker_Name__c'),
                     editRewardAccount: selectedOriginator.get('Reward_Account_Number__c'),
                     editGeneralAgency: selectedOriginator.get('General_Agency__c'),
                     editFranchiseCode: selectedOriginator.get('Franchise_Code__c'),
                     editGroupName: selectedOriginator.get('Group_Name__c'),
                     editGroupNum: selectedOriginator.get('Group_Number__c'),
                     editPolicyNum: selectedOriginator.get('Policy_Number__c'),
                     editOtherOrigType: selectedOriginator.get('Other_Originator_Type__c')
                 })  
                   .then((result) => {
                     if(result.length > 0){
                     var allResults = [];
                     allResults = result;
                     var tableResults = [];
                     var foundMatch = false;
                         if(allResults.length > 0 && allResults[0][0] == 'Too Many Results'){
                               this.validateOriginator =false;
                         } else {
                                 if(selectedOriginator.get('Originator_Type__c') == 'Agency/Broker'){
                                     for(var i = 0; i < allResults.length; i++){
                                         tableResults=[];
                                         if(allResults[i].length == 2){
                                            tableResults.push(allResults[i][1],allResults[i][0]);
                                             this.solarisResults.push({value:tableResults, key:'AgencyBroker'+i});
                                             //look through table, and compare with entered fields, if both don't match, show table
											    if(allResults[i][0] == selectedOriginator.get('Reward_Account_Number__c') && allResults[i][1] == selectedOriginator.get('Agency_Broker_Name__c')){
                                              foundMatch = true;
                                             }
                                             /*for(var j = 0; j < tableResults.length; j++){
                                                 if(tableResults[i].rewardAccountNumber == selectedOriginator.get('Reward_Account_Number__c') && tableResults[i].rewardAccountName == selectedOriginator.get('Agency_Broker_Name__c')){
                                                     foundMatch = true;
                                                    // this.validateOriginator = true;
                                                 }
                                             }*/
                                        }
                                    }
                                    this.solarisTableColumns.push('Reward Account Name','Reward Account Number');
                                 } else if(selectedOriginator.get('Originator_Type__c') == 'General Agent'){
                                     for(var i = 0; i < allResults.length; i++){
                                         tableResults=[];
                                         if(allResults[i].length == 2){
                                            tableResults.push(allResults[i][1],allResults[i][0]);
                                             this.solarisResults.push({value:tableResults, key:'GeneralAgency'+i});
                                             //look through table, and compare with entered fields, if both don't match, show table
											 if(allResults[i][0] == selectedOriginator.get('Franchise_Code__c') && allResults[i][1] == selectedOriginator.get('General_Agency__c')){
                                              foundMatch = true;
                                             }
                                          }
                                     }
                                     
                                     this.solarisTableColumns.push('General Agency Name','Franchise Code');
  
                                 } else if(selectedOriginator.get('Originator_Type__c') == 'Group Contact'){
                                     for(var i = 0; i < allResults.length; i++){
                                         tableResults=[];
                                         if(allResults[i].length == 3){
                                            tableResults.push(allResults[i][0],allResults[i][1],allResults[i][2]);
                                             this.solarisResults.push({value:tableResults, key:'GroupContact'+i});
											 if(allResults[i][0] == selectedOriginator.get('Group_Name__c') && allResults[i][1] == selectedOriginator.get('Group_Number__c') && allResults[i][2] == selectedOriginator.get('Policy_Number__c')){
                                                 foundMatch = true;
                                             }
                                        }
                                    }
                                    this.solarisTableColumns.push('Group Name','Group Number','Policy Number');
                                }
                                console.log('foundMatch----'+foundMatch);
                                if(foundMatch){
                                  this.isSolarisResultDisplay=false;
                                }
                               else{
                                 this.isSolarisResultDisplay=true;
                               }
                                  
                         }
                      }
                      else{
                        //console.log('show solaris error---');
                        this.solarisErrorMessage = 'No results found. '+this.solarisErrorMessage;
                        this.solarisErrorDisplay = true;
                      }
                   }) 
                   .catch((error) => {  
                     this.error = error;  
                     this.validateOriginator = false;  
                    });  
             }
             
         }
         
  }
  handleSolarisRowClick(event){
    
     var rowValues = event.currentTarget.getAttribute("data-values");
     var typeOfOrgValue = event.currentTarget.getAttribute("data-key");
     if(typeOfOrgValue.indexOf('AgencyBroker') != -1){
        if(rowValues.indexOf(',') != -1){
         var index = rowValues.lastIndexOf(",");
         this.setValue('Reward_Account_Number__c', rowValues.substring(index+1, rowValues.length) ,'Agency_Broker_Name__c',rowValues.substring(0, index),'','');
        }
     }
     else if(typeOfOrgValue.indexOf('GeneralAgency') != -1){
         if(rowValues.indexOf(',') != -1){
          var index = rowValues.lastIndexOf(",");
          this.setValue('General_Agency__c',  rowValues.substring(0, index) ,'Franchise_Code__c',rowValues.substring(index+1, rowValues.length),'','');
         }
      }
      else if(typeOfOrgValue.indexOf('GroupContact') != -1){
         if(rowValues.indexOf(',') != -1){
          var splitFieldVals = rowValues.split(",");
          var grpName = '' ;
          for(var m =0 ; m <splitFieldVals.length-2;m++){
             grpName = grpName+splitFieldVals[m];
          }
         this.setValue('Group_Name__c', grpName ,'Group_Number__c',splitFieldVals[splitFieldVals.length-2],'Policy_Number__c',splitFieldVals[splitFieldVals.length-1]);
         }
      }
     this.solarisResults=[];
     this.solarisTableColumns=[];
     this.isSolarisResultDisplay=false;
  }
  
  handleKeyDown(event){
   
  }
  formatPhoneNumber(phnNumber){
    if(phnNumber != null && phnNumber != '' && phnNumber.length == 10){
      phnNumber = phnNumber.substr(0,3)+'-'+phnNumber.substr(3,3)+'-'+phnNumber.substr(6,9);
    }
    return phnNumber;
  }
  handleKeyPress(event){
     var keyCd = event.keyCode;
     var str = String.fromCharCode(keyCd);
     if(event.target.name == 'Phone_Number__c' || event.target.name == 'Reward_Account_Number__c' || event.target.name == 'Franchise_Code__c'){
         
         if(/^[0-9]/g.test(str)){
             return true;    
         } else {
             event.preventDefault();
             return false;
         }
     }
     else if(event.target.name == 'First_Name__c' || event.target.name == 'Last_Name__c'){
        
         //check for dash and apostrophe
         if( keyCd == 45  ||  keyCd == 39 || keyCd == 32 ){
             return true;
         } else if(/^[a-zA-Z]/g.test(str)){
             return true;
         } else {
             event.preventDefault();
             return false;
         }
     }
     else if( event.target.name == 'Group_Number__c' || event.target.name == 'Policy_Number__c'){
        
        if(/^[A-Za-z0-9]/g.test(str)){
            return true;
        } else {
            event.preventDefault();
            return false;
        }
      }
     
  }
  handleBlur(event){
     if(event.target.name == 'Email__c'){
         var custEmailVal = event.target.value;
         event.target.setCustomValidity("");
         if(custEmailVal != undefined && custEmailVal != null && custEmailVal != '') {
             var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/; 
             if(!(custEmailVal.match(regExpEmailformat))) {
                 event.target.setCustomValidity("You have entered an invalid format.");
                 return false;
             }
         } else {
             return true;    
         }
         event.target.reportValidity();
     }
    
  }
  handleKeyUp(event){
     
     if(event.target.name == 'Phone_Number__c'){
         var fieldValue = event.target.value;
         fieldValue = fieldValue.replace(/\D/g,'');
         var newValue = '';
         var count = 0;
         while(fieldValue.length > 3) {
             if(count < 2) {
                 newValue += fieldValue.substr(0, 3) + '-';
                 fieldValue = fieldValue.substr(3);
                 count++;
             }
             if(count == 2) {
                 break;
             }			
         }
         newValue += fieldValue;
         if(newValue.length > 12){
             newValue = newValue.substr(0,12);
         }
         event.target.value = newValue;
    }      
  }
  
  handleChange(event){
      
      this.setValue(event.target.name,event.target.value,'','','','');
      var fieldNames = this.fieldsetFields[0].hiddenFields;
      let tempAllRecords = Object.assign([], this.fieldsetFields);
      var selVal,selectedOtherType;
     if(event.target.name == 'Originator_Type__c'){
         this.isSolarisResultDisplay=false;
         this.solarisResults=[];
         this.solarisTableColumns=[];
         this.solarisErrorMessage = '';
         this.solarisErrorDisplay = false;
         selVal = event.target.value;
        for(var i=0;i<this.fieldsetFields.length;i++){
             let tempRec = Object.assign({}, tempAllRecords[i]);
  
             if( (selVal == 'Agency/Broker' &&  (tempRec.apiName == 'Agency_Broker_Name__c' ||
             tempRec.apiName == 'Reward_Account_Number__c' )) ||
            (selVal == 'General Agent' &&  (tempRec.apiName == 'General_Agency__c' ||
            tempRec.apiName == 'Franchise_Code__c' )) ||
             (selVal == 'Group Contact' &&  (tempRec.apiName == 'Group_Name__c' ||
             tempRec.apiName == 'Group_Number__c' || tempRec.apiName == 'Policy_Number__c'  )) ||
             (selVal == 'Other Originator' &&  tempRec.apiName == 'Other_Originator_Type__c')
             ){
               console.log(tempRec); 
              tempRec.isVisible=true;
             }
             else{
                 if( fieldNames.includes(tempRec.apiName) ){
                     tempRec.isVisible=false;
                 }
             }
             
             if( (selVal == 'Agency/Broker' &&  fieldNames.includes(tempRec.apiName) && tempRec.apiName != 'Agency_Broker_Name__c' &&
             tempRec.apiName != 'Reward_Account_Number__c' ) ||
            (selVal == 'General Agent' && fieldNames.includes(tempRec.apiName) && tempRec.apiName != 'General_Agency__c' &&
            tempRec.apiName != 'Franchise_Code__c' ) ||
             (selVal == 'Group Contact' &&  fieldNames.includes(tempRec.apiName) && tempRec.apiName != 'Group_Name__c' &&
             tempRec.apiName != 'Group_Number__c' && tempRec.apiName != 'Policy_Number__c'  ) ||
             (selVal == 'None' &&  fieldNames.includes(tempRec.apiName))||
             (selVal == 'Other Originator' &&  tempRec.apiName == 'Other_Originator_Type__c')
             ){
                 tempRec.value=null;
             }
            
             tempAllRecords[i] = tempRec;
         }
         this.fieldsetFields = tempAllRecords;
         this.renderOnce = true;
     }
     if(event.target.name == 'Other_Originator_Type__c'){
        selectedOtherType = event.target.value;
        for(var i=0;i<this.fieldsetFields.length;i++){
          let tempRec = Object.assign({}, tempAllRecords[i]);
          if(selectedOtherType == 'Other' &&  tempRec.apiName == 'Originator_Role__c'){
              tempRec.isVisible=true;
          }
          else{
              if(tempRec.apiName != 'Other_Originator_Type__c'  && fieldNames.includes(tempRec.apiName) ){
                  tempRec.isVisible=false;
              }
          }
          if(selectedOtherType != 'Other' && fieldNames.includes(tempRec.apiName) && tempRec.apiName == 'Originator_Role__c'){
              tempRec.value=null;
          }
          tempAllRecords[i] = tempRec;
      }
      this.fieldsetFields = tempAllRecords;
      this.renderOnce = true;
    }
    
  }
  setValue(fieldName1,selVal1,fieldName2,selVal2,fieldName3,selVal3){
      let tempAllRecords = Object.assign([], this.fieldsetFields);
      for(var i=0;i<this.fieldsetFields.length;i++){
          let tempRec = Object.assign({}, tempAllRecords[i]);
          if(tempRec.apiName == fieldName1){
              tempRec.value = selVal1;
          }
          else if(fieldName2 != '' &&  tempRec.apiName == fieldName2){
             tempRec.value = selVal2;
          }
          else if(fieldName3 != '' &&  tempRec.apiName == fieldName3){
             tempRec.value = selVal3;
          }
          tempAllRecords[i] = tempRec;
      }
      this.fieldsetFields = tempAllRecords;
    }
    /* Validations start */
    validatePhone(event) {
      var keyCode = event.keyCode;
      var str = String.fromCharCode(keyCode);
      //check for dash and apostrophe
      if (keyCode == 45) {
        return true;
      } else if (/^[0-9]/g.test(str)) {
        return true;
      } else {
        event.preventDefault();
        return false;
      }
    }
    
    validateRequiredFields(orgType,otherOrgType) {
      this.isValidation= true;
      const innerHTMLSelect ='<div lightning-input_input="" id="help-message-258" data-help-message="" role="alert" class="slds-form-element__help slds-color-code">Complete this field.</div>';
      let requiredIndicatorYes = this.template.querySelectorAll('[data-required="true"]');
      requiredIndicatorYes.forEach((element) => {
        if (!element.value) {
          if (element.dataset.required == "true") {
            if (element.dataset.required == "true" && element.nodeName == "LIGHTNING-INPUT") {
              element.setCustomValidity("Complete this field.");
              element.required = true;
              element.reportValidity();
              this.isValidation= false;
            }
          } else {
            this.isValidation= true;
            element.setCustomValidity(""); // clear previous value
          }
          element.reportValidity();
          this.isValidation= false;
        }else if(element.value=="None" && element.nodeName == "SELECT"){
          if(element.name.indexOf("Other_Originator_Type__c")==0){
            element.parentNode.parentNode.className = "slds-form-element slds-has-error";   
            element.parentNode.nextElementSibling.className = "slds-form-element__help";
            element.parentNode.nextElementSibling.innerHTML = "Select a Type.";
            this.isValidation= false;
          }else if(element.name.indexOf("Originator_Type__c")==0){
            element.parentNode.parentNode.className = "slds-form-element slds-has-error";   
            element.parentNode.nextElementSibling.className = "slds-form-element__help";
            element.parentNode.nextElementSibling.innerHTML = "Must Select an Originatory Type.";
            this.isValidation= false;
          }
          this.isValidation= false;
        }else {
          if(element.nodeName == "SELECT"){
            element.parentNode.parentNode.className = "slds-form-element";   
            element.parentNode.nextElementSibling.className = "slds-form-element__help slds-hide-elements";
          }
          else{
          element.setCustomValidity(""); // clear previous value
          element.reportValidity();
          }
          if(element.nodeName == "LIGHTNING-INPUT"){
              if(  element.name == "Phone_Number__c" && element.value.length <12 ){
                element.setCustomValidity("Must enter ten digit phone number.");
                element.reportValidity();
                this.isValidation= false;
              }
              else if(element.name == "Email__c"){
                var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/; 
                if(!(element.value.match(regExpEmailformat))) {
                    element.setCustomValidity("You have entered an invalid format.");
                    element.reportValidity();
                    this.isValidation= false;
                }
              }
           } 
      }
      });
    }
}