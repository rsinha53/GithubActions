import { LightningElement,api,track,wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import updateCase from "@salesforce/apex/ETSBE_OneClickController.fps_UpdateCase";
import createCase from "@salesforce/apex/ETSBE_OneClickController.fps_createCase";
import getCaseDetails from "@salesforce/apex/ETSBE_OneClickController.fps_getCaseDetails";
//called acet_util.js to load validation method
import { showErrorToast} from 'c/acet_Utils';
// import standard toast event
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class Acet_CaseCreationUpdation extends NavigationMixin(LightningElement){

    //Variable to get the data from parent object for edit mode
    @api originatorInformation;
    @api groupInformation ;
    @api interactionType ;
    //Attributes to update case 
    @api a_originator;
    @api a_groupNumber;
    @api a_caseId; 
    @api a_interactionType;
    @api requiredFieldIndicator;

    currentPageReference = null; 
    urlStateParameters = null;
    /* Params from Url */
    updateCaseId = null;
    isUpdateCase = null;
    urlType = null;
    
    //Set this to true to show the loading symbol
    isLoading = false;


    /*get case id from page reference */
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
          this.urlStateParameters = currentPageReference.state;
          this.setParametersBasedOnUrl();
		  
       }
    }
 
    setParametersBasedOnUrl() {
       this.updateCaseId = this.urlStateParameters.c__recordId || null;
       this.isUpdateCase = this.urlStateParameters.c__isUpdateCase || null;
       if(this.isUpdateCase){
        this.getCaseDetailValues();
       }
       else{
        this.clearValues ();
       }
    }
    //To display data on explore page from update case
    getCaseDetailValues(){
        getCaseDetails({ 
                caseId :  this.updateCaseId
            })
            .then(result => {
                if (result.length != 0 ) {
                  var dropdownOptions = [];
                  var groupData = [];
                  this.interactionType =result.casedetails.Origin;
                 if(result.originatorDetails[0]){
                    result.originatorDetails[0].Phone_Number__c = (result.originatorDetails[0].Phone_Number__c)?((result.originatorDetails[0].Phone_Number__c.length == 10)?result.originatorDetails[0].Phone_Number__c.substring(0,3) + '-' + result.originatorDetails[0].Phone_Number__c.substring(3,6) + '-' + result.originatorDetails[0].Phone_Number__c.substring(6,result.originatorDetails[0].Phone_Number__c.length):result.originatorDetails[0].Phone_Number__c):'';
                  console.log('phine'+	result.originatorDetails[0].Phone_Number__c);
                   if(result.originatorDetails[0].Originator_Type__c == "Other Originator") {
                        var labelStr = '';
                        if(result.originatorDetails[0].Other_Originator_Type__c == 'Other' && result.originatorDetails[0].Originator_Role__c && result.originatorDetails[0].Originator_Role__c!= 'None') {
                            console.log('other');    
                            labelStr= result.originatorDetails[0].Originator_Role__c;
                        }else {
                            labelStr= result.originatorDetails[0].Other_Originator_Type__c;
                        }
                        dropdownOptions.push({
                            label: labelStr +
                            "   " +
                            result.originatorDetails[0].Last_Name__c +
                            ", " +
                            result.originatorDetails[0].First_Name__c +
                            "   " +
                            result.originatorDetails[0].Phone_Number__c +
                            "   " +
                            result.originatorDetails[0].Email__c , value: JSON.stringify(result.originatorDetails[0])
                        }); 
                        } else if (result.originatorDetails[0].Originator_Type__c == "Group Contact") {
                            dropdownOptions.push({
                            label:
                            result.originatorDetails[0].Originator_Type__c +
                            " , " +
                            result.originatorDetails[0].Policy_Number__c +
                            ", " +
                            result.originatorDetails[0].Last_Name__c +
                            ", " +
                            result.originatorDetails[0].First_Name__c +
                            "   " +
                            result.originatorDetails[0].Phone_Number__c +
                            "   " +
                            result.originatorDetails[0].Email__c,
                           value: JSON.stringify(result.originatorDetails[0])
                        });
                      } else if (result.originatorDetails[0].Originator_Type__c == "Agency/Broker") {
                        dropdownOptions.push({
                          label:
                            result.originatorDetails[0].Originator_Type__c +
                            " , " +
                            result.originatorDetails[0].Reward_Account_Number__c +
                            ", " +
                            result.originatorDetails[0].Last_Name__c +
                            ", " +
                            result.originatorDetails[0].First_Name__c +
                            "   " +
                            result.originatorDetails[0].Phone_Number__c +
                            "   " +
                            result.originatorDetails[0].Email__c,
                          value: JSON.stringify(result.originatorDetails[0])
                        });
                      } else if (result.originatorDetails[0].Originator_Type__c == "General Agent") {
                        dropdownOptions.push({
                          label:
                            result.originatorDetails[0].Originator_Type__c +
                            ",  " +
                            result.originatorDetails[0].Franchise_Code__c +
                            ", " +
                            result.originatorDetails[0].Last_Name__c +
                            ", " +
                            result.originatorDetails[0].First_Name__c +
                            "   " +
                            result.originatorDetails[0].Phone_Number__c +
                            "   " +
                            result.originatorDetails[0].Email__c,
                          value: JSON.stringify(result.originatorDetails[0])
                        });
                      } else {
                        dropdownOptions.push({
                          label:
                            result.originatorDetails[0].Originator_Type__c +
                            "   " +
                            result.originatorDetails[0].Last_Name__c +
                            ", " +
                            result.originatorDetails[0].First_Name__c +
                            "   " +
                            result.originatorDetails[0].Phone_Number__c +
                            "   " +
                            result.originatorDetails[0].Email__c,
                          value: JSON.stringify(result.originatorDetails[0])
                        })
    }
                }
                this.originatorInformation = dropdownOptions.length >0 ? dropdownOptions : '' ;
                if(result.casedetails.Subject_Group_ID__c)
                groupData.push({
                    label: result.casedetails.SourceCode__c+ ' - ' + result.casedetails.Policy__c+ ' - ' + result.casedetails.Subject_Name__c+ ' - ' +result.casedetails.Subject_Group_ID__c+ ' - ' +result.casedetails.Platform__c , value: JSON.stringify(result.casedetails)
                })
                this.groupInformation = groupData.length>0 ? groupData : '';
                
        const interactionType = new CustomEvent("passinteractiontypefromcase", {
        detail: {
                interactionType: this.interactionType,
            groupInformation : this.groupInformation,
            originatorInformation : this.originatorInformation
            
        },
        bubbles: true,
        composed : true
        });
        this.dispatchEvent(interactionType);
    }
     }).catch(error => {
    })
    } 

    clearValues(event) {
        const clearVal = new CustomEvent("clearValuesAfterCaseCreate", {
        detail: {},
        bubbles: true,
        composed : true
        });
        this.dispatchEvent(clearVal);
    }

    
    /**case update */
    handleUpdateCase(event){
        if(!this.originatorInformation) {
            this.showErrorToast('Originator');
        }else if(!this.groupInformation){ 
                this.showErrorToast('Group');
        }else if(!this.interactionType){
            this.showErrorToast('Interaction Type');
        }else {    
    updateCase({ 
        a_originator : this.originatorInformation != null ?this.originatorInformation.selectedValue : '', 
        a_groupNumber : this.groupInformation !=null ?this.groupInformation.groupSelectedValue:'', 
        a_caseId : this.updateCaseId,
        a_interactionType : this.interactionType.selectedValue != undefined ? this.interactionType.selectedValue : this.interactionType
    })
    .then(result => {
        const event = new ShowToastEvent({
            title: 'Case Updated Successfully',
            message: 'Case Updated Successfully',
            variant: 'success'
        });
        this.redirectToPage();
        this.dispatchEvent(event);
       
    })
    .catch(error => {
        const event = new ShowToastEvent({
            title : 'Error',
            message : error+'Error Updating Case. Please Contact System Admin',
            variant : 'error'
        });
        this.dispatchEvent(event);
    });
    }   
    }

    handleCreateCase(event){
        this.isLoading = true;
        console.log('originatorinformation' +this.originatorInformation);
        console.log('group information' +this.groupInformation);
        console.log('interaction type'+this.interactionType);
        if(!this.originatorInformation) {
            this.showErrorToast('Originator');
        }else if(!this.groupInformation){ 
                this.showErrorToast('Group');
        }else if(!this.interactionType){
            this.showErrorToast('Interaction Type');
        }else{
                //validateRequiredFields(this.requiredFieldIndicator);
                if((this.originatorInformation !=undefined || this.originatorInformation != null )
                &&(this.groupInformation != undefined || this.groupInformation != null )
                &&(this.interactionType != undefined || this.interactionType != null )){
                    createCase({ 
                        a_originator : this.originatorInformation.selectedValue, 
                        a_groupNumber : this.groupInformation.groupSelectedValue, 
                        a_interactionType : this.interactionType.selectedValue
                    })
                    .then(result => {
                        this.isLoading = false;
                        if (result.length !=0) {
                        this.updateCaseId = result.Id;  
                        const event = new ShowToastEvent({
                            title: 'Case Created Successfully',
                            message: 'Case Created Successfully',
                            variant: 'success'
                        });
                        this.redirectToPage();
                        this.clearValues();
                        this.dispatchEvent(event);
                    }
                    
                    })
                    .catch(error => {
                        this.isLoading = false;
                        const event = new ShowToastEvent({
                            title : 'Error',
                            message : 'Error Creating Case. Please Contact System Admin',
                            variant : 'error'
                        });
                        this.dispatchEvent(event);
                    })
                
            }       
        }
        
    }

    redirectToPage(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.updateCaseId,
                objectApiName: 'case',
                actionName: 'view'
            }
        });
    }
    
    showErrorToast(fieldValue) {
        this.isLoading = false;
        console.log("inside showErrorToast"+fieldValue);
        let validationMessage = ""
        if(fieldValue == 'Group'){
            validationMessage = "Select a ";
        }else{
            validationMessage = "Select an ";
        }
        const evt = new ShowToastEvent({
            title: 'Error',
            message: validationMessage+fieldValue,
            variant: 'error'
        });
        this.dispatchEvent(evt);
      }
}