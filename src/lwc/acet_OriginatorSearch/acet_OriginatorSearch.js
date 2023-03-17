import { LightningElement, track, wire, api } from "lwc";
import findOriginator from "@salesforce/apex/ETSBE_OneClickController.findOriginator";
import searchOriginatorSolaris from "@salesforce/apex/ETSBE_OneClickController.searchOriginatorSolaris";
export default class Acet_OriginatorSearch extends LightningElement {
  
  // The code for Originator Combobox starts here, it contains variables and methods specific to it
  @track recordsList;
  @track dropdownOptions;
  @track searchKey = "";
  @api selectedValue;
  @api selectedLabel;
  @api objectApiName;
  @api lookupLabel;
  @track message;
  @track isValueSelected;
  @track blurTimeout;
  @track boxClass = "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
  @track inputClass = "";
  @track validateOriginator;
  @track selectedOriginator;
  @track selectedKey;
  @track navigatorIndex ;
  @api isAddNewButton;
  lookupErrorMessage = "Originator needs to be updated with valid information.";

  constructor(){
    super();
    this.template.addEventListener('newOriginatorEvent', this.newOriginatorEvent.bind(this));
    this.template.addEventListener('clearOriginatorAfterCaseCreate', this.handleresetall.bind(this));    
  }
  newOriginatorEvent(event){
      console.log('-----assignNewOriginatorEvent-----');
      console.log('-----assignNewOriginatorEvent-----'+event.detail.originatorData);
      console.log('-----assignNewOriginatorEvent-----'+event.detail.originatorjson);
      this.selectedLabel= event.detail.originatorData;
      this.selectedValue= event.detail.originatorjson;
      this.isValueSelected = true;
      this.isEditDisabled = false;
      this.isAddNewButton = true;
      this.closeModal();
      this.onSeletedRecordUpdate();
      this.validateSolarisOriginator();
  }
   @api
  displayValues(originatorInformation){
      
      if(originatorInformation !=null && originatorInformation != '' && originatorInformation != undefined){
      this.selectedLabel = originatorInformation[0].label;
      this.selectedValue = originatorInformation[0].value;
      this.isEditDisabled = false;
      this.isValueSelected= true;
      } 
      else{
        this.selectedLabel = '';
        this.selectedValue = '';
      }
     // if(originatorInformation && originatorInformation[0].label != null)
      
      console.log(this.selectedLabel);
  }
  onRecordSelection(event) {
    console.log("000" + event.target.dataset.key);
    this.selectedValue = event.target.dataset.key; //value
    this.selectedLabel = event.target.dataset.name; //label
    this.isAddNewButton = false;
    console.log('selectedValue');
    console.log( this.selectedValue);
    this.searchKey = "";
    this.isValueSelected = true;
    this.boxClass =
    "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
    this.onSeletedRecordUpdate();
    this.validateSolarisOriginator();
    this.isEditDisabled = false;
  } 
  
  handleKeyChange(event) {
    const searchKey = event.target.value;
    this.searchKey = searchKey;
    this.boxClass =
      "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus slds-is-open";
    this.inputClass = "slds-has-focus";
    this.getLookupResult();  
    var isEnterKey = event.keyCode === 13;
    this.navigatorIndex = 0;
    if(isEnterKey) {
      console.log('isEnterKey'+isEnterKey);
      if(this.recordsList && this.recordsList.length > 0) {
        this.selectedLabel = this.recordsList[this.navigatorIndex].label;
        this.selectedValue = this.recordsList[this.navigatorIndex].value;
        this.isAddNewButton = false;
        console.log(this.recordsList[this.navigatorIndex].label);
        console.log(this.selectedLabel);
        this.searchKey = "";
        this.isValueSelected = true;  
        this.boxClass =  
       "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
        this.onSeletedRecordUpdate();
        this.validateSolarisOriginator();
        this.isEditDisabled = false;
      }
    }
  }

  removeRecordOnLookup(event) {
    this.searchKey = "";
    this.selectedLabel = "";
    this.selectedValue = "";
    this.recordsList = null;
    this.isValueSelected = false;
    this.isEditDisabled = true;
    this.isAddNewButton = false;
    this.boxClass =
    "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
    this.onSeletedRecordUpdate();
  }
  getLookupResult() {
    findOriginator({ searchField: this.searchKey})
      .then((result) => {
        var dropdownOptions = [];
        if (result.length === 0 && this.searchKey == "") {
          this.recordsList = [];
        } else {
          console.log("result", JSON.stringify(result));
          // console.log('=='+result[0].First_Name__c);
          console.log(result.length);
          for (var i = 0; i < result.length; i++) {
            if (result[i].Originator_Type__c == "Other Originator") {
              var labelStr = '';
              if(result[i].Other_Originator_Type__c == 'Other' && result[i].Originator_Role__c && result[i].Originator_Role__c!= 'None') {
                 console.log('other');
                 labelStr= result[i].Originator_Role__c;
              }else {
                 labelStr= result[i].Other_Originator_Type__c;
              }
              labelStr+= "   " +result[i].Last_Name__c +", " +result[i].First_Name__c +
              "   " +result[i].Phone_Number__c +
             "   " +result[i].Email__c   
              dropdownOptions.push({
                label:labelStr,
                value: JSON.stringify(result[i])
              });
            } else if (result[i].Originator_Type__c == "Group Contact") {
              dropdownOptions.push({
                label:
                  result[i].Originator_Type__c +
                  " , " +
                  result[i].Policy_Number__c +
                  ", " +
                  result[i].Last_Name__c +
                  ", " +
                  result[i].First_Name__c +
                  "   " +
                  result[i].Phone_Number__c +
                  "   " +
                  result[i].Email__c,
                value: JSON.stringify(result[i])
              });
            } else if (result[i].Originator_Type__c == "Agency/Broker") {
              dropdownOptions.push({
                label:
                  result[i].Originator_Type__c +
                  " , " +
                  result[i].Reward_Account_Number__c +
                  ", " +
                  result[i].Last_Name__c +
                  ", " +
                  result[i].First_Name__c +
                  "   " +
                  result[i].Phone_Number__c +
                  "   " +
                  result[i].Email__c,
                value: JSON.stringify(result[i])
              });
            } else if (result[i].Originator_Type__c == "General Agent") {
              dropdownOptions.push({
                label:
                  result[i].Originator_Type__c +
                  ",  " +
                  result[i].Franchise_Code__c +
                  ", " +
                  result[i].Last_Name__c +
                  ", " +
                  result[i].First_Name__c +
                  "   " +
                  result[i].Phone_Number__c +
                  "   " +
                  result[i].Email__c,
                value: JSON.stringify(result[i]) 
              });
            } else {
              dropdownOptions.push({
                label:
                  result[i].Originator_Type__c +
                  "   " +
                  result[i].Last_Name__c +
                  ", " +
                  result[i].First_Name__c +
                  "   " +
                  result[i].Phone_Number__c +
                  "   " +
                  result[i].Email__c,
                value: JSON.stringify(result[i])
              });
            }
          }
          console.log("dropdown", dropdownOptions);
          this.recordsList = dropdownOptions;
          this.message = "";
        }
        if(dropdownOptions.length == 0) {
          this.recordsList = undefined;
          console.log('dropdown options is not defined');
        }
        this.error = undefined;
      })
      .catch((error) => {
        this.error = error;
        this.recordsList = undefined;
      });
  }

  onSeletedRecordUpdate() {
    const passEventr = new CustomEvent("recordselection", {
      detail: {
        selectedValue: this.selectedValue,
        selectedLabel: this.selectedLabel,
        isAddNewButton: this.isAddNewButton
      }
    });
    this.dispatchEvent(passEventr);
  }
  validateSolarisOriginator() {
    var selectedOriginator = JSON.parse(this.selectedValue);
    console.log('selectedoriginator');
    console.log(selectedOriginator);
    this.validateOriginator =true;
	 if (
      selectedOriginator.Originator_Type__c == "Agency/Broker" ||
      selectedOriginator.Originator_Type__c == "General Agent" ||
      selectedOriginator.Originator_Type__c == "Group Contact"
    ) {
      /**  if(selOrig.Originator_Type__c == 'Group Contact'){ 
       var stringArray = selLabel.split(',');    
       component.set("v.searchGroupPolicyNum",stringArray[1]);
   } */
    console.log("ENTERING SOLARIS VALIDATE" +selectedOriginator);
    if(selectedOriginator.Originator_Type__c == 'Agency/Broker' && ((selectedOriginator.Reward_Account_Number__c == null || selectedOriginator.Reward_Account_Number__c == undefined || selectedOriginator.Reward_Account_Number__c == '') 
    || (selectedOriginator.Agency_Broker_Name__c == null || selectedOriginator.Agency_Broker_Name__c == undefined || selectedOriginator.Agency_Broker_Name__c == ''))){
      this.validateOriginator =false;
      console.log('agency');
      this.showRequiredIndicator();
    } else if(selectedOriginator.Originator_Type__c == 'General Agent' && (selectedOriginator.Franchise_Code__c == null || selectedOriginator.Franchise_Code__c == undefined || selectedOriginator.Franchise_Code__c == '')){
          this.validateOriginator =false;
          console.log('general agent');
          this.showRequiredIndicator();
    } else if(selectedOriginator.Originator_Type__c == 'Group Contact' && ((selectedOriginator.Group_Number__c == null || selectedOriginator.Group_Number__c == undefined || selectedOriginator.Group_Number__c == '') 
    || (selectedOriginator.Policy_Number__c == null || selectedOriginator.Policy_Number__c == undefined || selectedOriginator.Policy_Number__c == ''))){
        this.validateOriginator =false;
        console.log('group');
        this.showRequiredIndicator();
  } else {
    console.log('entering');
    searchOriginatorSolaris({ 
      editSfId: selectedOriginator.Id,
      editFirstName: selectedOriginator.First_Name__c,
      editLastName: selectedOriginator.Last_Name__c,
      editPhone: selectedOriginator.Phone_Number__c,
      editPhoneExt: selectedOriginator.Phone_Ext__c,
      editEmail: selectedOriginator.Email__c,
      editOriginatorType: selectedOriginator.Originator_Type__c,
      editAgencyBroker: selectedOriginator.Agency_Broker_Name__c,
      editRewardAccount: selectedOriginator.Reward_Account_Number__c,
      editGeneralAgency: selectedOriginator.General_Agency__c,
      editFranchiseCode: selectedOriginator.Franchise_Code__c,
      editGroupName: selectedOriginator.Group_Name__c,
      editGroupNum: selectedOriginator.Group_Number__c,
      editPolicyNum: selectedOriginator.Policy_Number__c,
      editOtherOrigType: selectedOriginator.Other_Originator_Type__c })  
    .then((result) => {
      console.log('SOLARIS RESPONSE: ' + JSON.stringify(result));
      var allResults = [];
      allResults = result;
      console.log('ALLRESULTS0: ' +JSON.stringify(allResults));
      var tableResults = [];
      var foundMatch = false;
          if(allResults.length > 0 && allResults[0][0] == 'Too Many Results'){
                  //error message here
                this.validateOriginator =false;
                this.showRequiredIndicator();
          } else {
                  if(selectedOriginator.Originator_Type__c == 'Agency/Broker'){
                      for(var i = 0; i < allResults.length; i++){
                          if(allResults[i].length == 2){
                              var tableData = {
                                  'rewardAccountNumber':allResults[i][0],
                                  'rewardAccountName':allResults[i][1]
                              }
                              tableResults.push(tableData);
                              //look through table, and compare with entered fields, if both don't match, show table
                              for(var j = 0; j < tableResults.length; j++){
                                  if(tableResults[i].rewardAccountNumber == selectedOriginator.Reward_Account_Number__c && tableResults[i].rewardAccountName == selectedOriginator.Agency_Broker_Name__c){
                                      foundMatch = true;
                                      this.validateOriginator = true;
                                      this.showRequiredIndicator();
                                  }
                              }
                              console.log('agency' +this.validateOriginator);
                          }
                     }
                  } else if(selectedOriginator.Originator_Type__c == 'General Agent'){
                      console.log('ALLRESULTS: ' +JSON.stringify(allResults));
                      console.log('ALLRESULTS: ' + allResults.length);
                      for(var i = 0; i < allResults.length; i++){
                          if(allResults[i].length == 2){
                              var tableData = {
                                  'franchiseCode':allResults[i][0],
                                  'generalAgencyName':allResults[i][1]
                              }
                              tableResults.push(tableData);
                              //look through table, and compare with entered fields, if both don't match, show table
                              for(var j = 0; j < tableResults.length; j++){
                                  if(tableResults[i].franchiseCode == selectedOriginator.Franchise_Code__c && tableResults[i].generalAgencyName == selectedOriginator.General_Agency__c){
                                      foundMatch = true;
                                      this.validateOriginator = true;
                                      this.showRequiredIndicator();
                                  }
                              }
                              console.log('agent' +this.validateOriginator);
                          }
                      }
                  } else if(selectedOriginator.Originator_Type__c == 'Group Contact'){
                      console.log('ALLRESULTS: ' +JSON.stringify(allResults));
                      console.log('ALLRESULTS: ' + allResults.length);
                      console.log('group');
                      for(var i = 0; i < allResults.length; i++){
                          if(allResults[i].length == 3){
                              var tableData = {
                                  'groupName':allResults[i][0],
                                  'groupNumber':allResults[i][1],
                                  'policyNumber':allResults[i][2]
                              }
                              tableResults.push(tableData);
                              //look through table, and compare with entered fields, if both don't match, show table
                              for(var j = 0; j < tableResults.length; j++){
                                  if(tableResults[i].groupName == selectedOriginator.Group_Name__c && tableResults[i].groupNumber == selectedOriginator.Group_Number__c && tableResults[i].policyNumber == selectedOriginator.Policy_Number__c){
                                      foundMatch = true;
                                      this.validateOriginator = true;
                                      this.showRequiredIndicator();
                               }
                            }
                            console.log('group'+this.validateOriginator+'found'+foundMatch);
                         }
                     }
                 }
                  if(foundMatch == false){
                      this.validateOriginator =false;
                      console.log('match' +this.validateOriginator);
                      this.showRequiredIndicator();
               }
          }
          this.error = undefined;
    }) 
    .catch((error) => {  
      this.error = error;  
      this.validateOriginator = false; 
      this.showRequiredIndicator(); 
     }); 
   } 
  }else {
    this.validateOriginator = true;
  }
} 
showRequiredIndicator() {
  console.log('validateoriginator' +this.validateOriginator);
  if(!this.validateOriginator) {
    console.log('originator is not valid');
    this.boxClass = "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-error";
  }else {
    console.log('originator valid');
    this.boxClass = "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
  }
}
  // The code for Originator combox ends here
  // Modal code starts here, it contains the variables and methods
  showModal = false;
  showNegativeButton;
  showPositiveButton = true;
  showNegativeButton = true;
  positiveButtonLabel = "Save";
  negativeButtonLabel = "Cancel";
  modalHeader = "Add New";
  isEditDisabled=true;
  //Variable to know the context of the click, if edit or new mode
  buttonLabel;
  //Variable to get the data from parent object for edit mode
  originatorInformation;

  closeModal() {
    this.showModal = false;
  }
  handleOrginatorRespone(event) {
   // this.originatorInformation = event.detail; // ravi commented..
  }
  showModalPopup(event) {
    this.buttonLabel = event.target.label;
    console.log('add orginator showModalPopup ');
    if(this.buttonLabel) {
      this.recordsList = null;
      //this.isValueSelected = false;
      this.boxClass =
      "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
    }
    if(this.buttonLabel == 'Edit'){
      this.modalHeader = 'Edit';
      console.log('add orginator selectedValue 1 ');
      console.log(this.selectedValue);
      console.log('add orginator selectedValue 2 ');
      this.originatorInformation = this.selectedValue;
    }
    else{
      this.modalHeader = 'Add New';
    }
    this.showModal = true;
  }
  //Modal code ends here

  //clear button functionality
  //Clear Originator Field Label Value.
  @api
  handleresetall(){
    console.log('CLear button clicked and changed ');
    this.selectedLabel = '';
    this.selectedValue = '';
    this.isValueSelected = false;
    this.isEditDisabled = true;
    this.searchKey = '';
    this.isAddNewButton = false;
    this.onSeletedRecordUpdate();
    this.boxClass =
    "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
    const event =new CustomEvent('handleresetall',{
      abc:''
    })
    this.dispatchEvent(event);
    }
  //Clear button method ends here
  
}