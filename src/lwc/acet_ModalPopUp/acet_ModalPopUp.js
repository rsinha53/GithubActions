import { LightningElement,api } from 'lwc';

export default class Acet_ModalPopUp extends LightningElement {
  
  @api showPositive;
  @api showNegative;
  @api positiveButtonLabel;
  @api negativeButtonLabel;
  @api showModal;
  @api buttonLabelContext;
  @api originatorInformation;
  @api modalHeader;
  constructor() {
    super();
    this.showNegative = true;
    this.showPositive = true;
    this.showModal = false;
    
  }
  handlePositive(event) {
    this.dispatchEvent(new CustomEvent('positive'));
    this.template.querySelector("c-acet_-Add-Originator").saveOriginator();
  }
  
  handleNegative() {
    this.dispatchEvent(new CustomEvent('negative'));
  }
  handleClose() {
    this.dispatchEvent(new CustomEvent('close'));
  }
}