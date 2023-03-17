import { LightningElement, track, wire, api } from 'lwc'; 
//import { validateRequiredFields } from 'c/acet_Utils';
import ACET_LWC_Util from "@salesforce/resourceUrl/ACET_LWC_Util";
import { loadScript } from "lightning/platformResourceLoader";
import searchGroup from "@salesforce/apex/ETSBE_OneClickController.searchGroup";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Acet_GroupSearch extends LightningElement {


    @api lookupLabel;
    @api interactionType;
    @api groupSelectedValue;
    @api groupSelectedLabel;
    @track groupSearchResults;
    @track dropdownOptions;
    @api searchGroupNum;
    @track boxClass = "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
    @track inputClass = "";
    @track isGroupValueSelected;
    interactionTypeOptions = [
        {value: 'Phone Call', label: 'Phone Call'},
        {value: 'Email', label: 'Email'},
        {value: 'Fax', label: 'Fax'},
        {value: 'Mail', label: 'Mail'},
        {value: 'Meeting', label: 'Meeting'}
    ];
    
    @api
    displayValues(interaction,groupInformation){
        
        const startSelect = this.template.querySelector('.slds-select');
        if (startSelect)
        startSelect.value = interaction;
        if(groupInformation != '' && groupInformation != null &&groupInformation != undefined){
        this.groupSelectedValue = groupInformation[0].value;
        this.groupSelectedLabel = groupInformation[0].label;
        this.isGroupValueSelected= true;
        }
        else{
        this.groupSelectedValue = '';
        this.groupSelectedLabel = '';
        }
    }
    renderedCallback(){
       // if(this.passInteractiontypeFromCase != '')
        //this.interactionType = this.passInteractiontypeFromCase;
        //validateRequiredOnLoad(this);
        //Use the below code to call methods from static resource file
        loadScript(this,ACET_LWC_Util)
        .then(() => window.requiredFieldIndicator(this))
        .catch((error) => console.log(error));

        //passing the entire template for the onload validation of interaction type 
        const passTemplate = new CustomEvent("passtemplate", {
        detail: this.template
        });
        this.dispatchEvent(passTemplate);
    }
    //Clear button functionality
    @api
    onSeletedRecordClear() {
        this.groupSelectedLabel = '';
        this.groupSelectedValue = '';
        this.isGroupValueSelected = false;
        this.searchGroupNum = '';
        let requiredIndicatorYes = this.template.querySelectorAll(
            '[data-required="true"]'
          );
        requiredIndicatorYes.forEach((element) => {
            if(element.dataset.required == "true" && element.nodeName == "SELECT"){
                element.selectedIndex = 0; 
            }
        });
        
      }
     
        
    //Clear button functionality Ends Here.
    
    @api 
    handleChange(event) {
        console.log(event);
        const interactionType = new CustomEvent("passinteractiontype", {
        detail: {
            selectedValue: event.target.value,
            selectedLabel: event.target.label
        }
        });
        this.dispatchEvent(interactionType);
    }
   
    
    searchForGroup(event){
        this.searchGroupNum = event.target.value;
        console.log('searchgroup' +this.searchGroupNum);
        if(this.searchGroupNum && !this.searchGroupNum.includes('-')){
        	var groupSearchAPIBool = false;
			var groupAPIResults;
            console.log('1. groupSearchAPIBool == ' + groupSearchAPIBool);
			    searchGroup({ groupId: this.searchGroupNum})
                .then((result) => {
	                	console.log('2. groupSearchAPIBool == ' + groupSearchAPIBool);
                        groupSearchAPIBool = true;
                        console.log(result);
                        if(result) {
		                    if(result.length>0){
		                    	console.log('API RESULTS: ' + result);
								console.log('result length' +result.length);
		                        var results = JSON.parse(result);
								groupAPIResults = results;
		                    }
	                    	if(groupAPIResults){
                                console.log(groupAPIResults);
                                console.log(groupAPIResults.length);
	                    		var dropdownOptions = [];
	                            for (var i = 0; i < groupAPIResults.length; i++) {
	                                  dropdownOptions.push({
                                        label: groupAPIResults[i].sourceCode + ' - ' + groupAPIResults[i].policyNumber + ' - ' + groupAPIResults[i].groupName + ' - ' + groupAPIResults[i].groupId+' - ' + groupAPIResults[i].platform,
                                        value: JSON.stringify(groupAPIResults[i])
	                                });
	                            }
	                            if(groupAPIResults.length == 0){ 
	                                this.showGroupErrorToast();
									this.groupSearchResults = [];
	                            }else if(groupAPIResults.length > 15){
                                    const event = new ShowToastEvent({
                                        title: 'Error',
                                        message: 'Criteria has yielded more than 15 results.  Refine your search criteria.',
                                        variant: 'error'
                                    });
                                    this.dispatchEvent(event);
	                            	this.groupSearchResults = [];
	                            } 
								if(groupAPIResults.length > 1){
	                            	console.log('DROPDOWN: ' + JSON.stringify(dropdownOptions));
                                    this.boxClass =
                                          "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus slds-is-open";
                                    this.inputClass = "slds-has-focus";
                                    this.groupSearchResults = dropdownOptions;
	                            } else if(groupAPIResults.length == 1){
	                            	this.groupSearchResults = [];
	                                if(groupAPIResults.length > 0){
	                                    if(groupAPIResults[0].groupId != null && groupAPIResults[0].groupName != null){
	                                        var groupLabel = '';
                                            groupLabel = groupAPIResults[0].sourceCode + ' - ' + groupAPIResults[0].policyNumber + ' - ' + groupAPIResults[0].groupName + ' - ' + groupAPIResults[0].groupId+' - ' + groupAPIResults[0].platform;
                                            this.groupSelectedLabel = groupLabel;
                                            this.groupSelectedValue =  JSON.stringify(groupAPIResults[0]);
                                            this.isGroupValueSelected = true;
                                            this.groupSeletedRecordUpdate();
                                        }
                                        console.log('groupSelectedLabel'+this.groupSelectedLabel);
	                                }
	                                
	                            }
	                        }
					    }else{
                            this.showGroupErrorToast();
                            this.groupSelectedLabel = '';
                            this.groupSelectedValue = '';
                            this.groupSeletedRecordUpdate();
                       }                  
	            })
				.catch((error) => {
					this.error = error;
					this.groupSearchResults = undefined;
				  });
        }else if(!this.searchGroupNum){
            this.boxClass ="slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
        }
    }
    onRecordSelection(event) {
        console.log("000" + event.target.dataset.key);
        this.groupSelectedValue = event.target.dataset.key; //value
        this.groupSelectedLabel = event.target.dataset.name; //label
        this.searchGroupNum = "";
        this.isGroupValueSelected = true;
        this.boxClass =
        "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
        this.groupSeletedRecordUpdate();
      } 
      removeRecordOnLookup(event) {
        this.searchGroupNum = "";
        this.groupSelectedLabel = "";
        this.groupSelectedValue = "";
        this.groupSearchResults = null;
        this.isGroupValueSelected = false;
        this.boxClass =
        "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
        this.groupSeletedRecordUpdate();
      }
    groupSeletedRecordUpdate() {
        console.log("inside new group event");
        const passGroupData= new CustomEvent("passgroupdata", {
            detail: {
                groupSelectedValue: this.groupSelectedValue,
                groupSelectedLabel: this.groupSelectedLabel
              }
        });
        this.dispatchEvent(passGroupData);
    }
      showGroupErrorToast() {
        const event = new ShowToastEvent({
            title: 'Error',
            message: 'Search criteria returned no matches.',
            variant: 'error'
        });
        this.dispatchEvent(event);
    }
   /* passinteractiontypefromcase(event){

        this.interactionType = event.detail.selectedValue; 
        console.log("event.detail.selectedValue");
        console.log(event.detail.selectedValue);
    }*/

}