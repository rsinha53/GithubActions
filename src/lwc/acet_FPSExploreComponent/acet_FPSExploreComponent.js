import { LightningElement,api,track,wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import { validateRequiredFields } from 'c/acet_Utils';
 
export default class Acet_FPSExploreComponent extends NavigationMixin(LightningElement){

   
    //groupInformation = '0000000';
    @api interactionType ;
    @api originatorInformation;
    @api selectedValue;
    @api searchGroupNum;
    requiredFieldIndicator;
    @api groupInformation;
    @api invalidGroup;
    @api isAddNewButton;
    @api isGroupValueSelected;

    constructor(){
        super();
        this.template.addEventListener('passinteractiontypefromcase', this.passinteractiontypefromcase.bind(this));
        this.template.addEventListener('clearValuesAfterCaseCreate', this.resetvaluesAfterCase.bind(this));    
    }

    handleOrginatorRespone(event){
        if(event.detail && event.detail.selectedLabel && event.detail.selectedValue){
            this.originatorInformation = event.detail;
            var selLabel = this.originatorInformation.selectedLabel;
            console.log('selLabel'+selLabel);
           if(this.originatorInformation.selectedValue) {
              var selectedOriginator = JSON.parse(this.originatorInformation.selectedValue);
             if(!this.originatorInformation.isAddNewButton && selectedOriginator.Originator_Type__c && selectedOriginator.Originator_Type__c == 'Group Contact' && !this.groupInformation){ 
                var stringArray = selLabel.split(',');  
                console.log('stringArray' +stringArray);
                this.searchGroupNum = stringArray[1];
                this.groupInformation = '';
                this.isGroupValueSelected = false;
                console.log('searchGroupNum' + this.searchGroupNum );
              }else {
                 this.searchGroupNum = '';
               }
            }
        }else {
            this.originatorInformation = '';
        }
    }
    handleInteractionType(event){

        this.interactionType = event.detail; 
        console.log("event.detail.selectedValue");
        console.log(event.detail.selectedValue);
    }

    //Clear button functionality
    handlevaluepass(evt){
        console.log("Clear Method Starting");   
        this.resetvalues();
   
    }
     resetvalues(){
        this.template.querySelector("c-acet_-Group-Search").onSeletedRecordClear();
        this.searchGroupNum = '';
        this.groupInformation = '';
        this.interactionType = '';
        this.originatorInformation = '';
    }
    //Clear button functionality ends here

    //required field validation
    handleTemplateData(event){
        this.requiredFieldIndicator = event.detail;
    }
    handleGroupResponse(event){
        if(event.detail && event.detail.groupSelectedLabel && event.detail.groupSelectedValue ){
            this.groupInformation = event.detail;
        }else{
            this.groupInformation = '';
        }
       console.log('group in explorere'+this.groupInformation);
    }
    passinteractiontypefromcase(event){
        this.interactionType = event.detail.interactionType;
        this.originatorInformation = event.detail.originatorInformation;
        this.groupInformation = event.detail.groupInformation;
        this.template.querySelector("c-acet_-Group-Search").displayValues(this.interactionType,this.groupInformation); 
        this.template.querySelector("c-acet_-Originator-Search").displayValues(this.originatorInformation);
    }
    resetvaluesAfterCase(){
    this.template.querySelector('c-acet_-Originator-Search').handleresetall();

    }
    
}