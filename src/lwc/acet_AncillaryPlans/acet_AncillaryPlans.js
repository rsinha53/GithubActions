import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAncillaryPlansData from '@salesforce/apex/ACETLGT_AncillaryPlansController.getAncillaryPlansData';
export default class Acet_AncillaryPlans extends LightningElement {

    @api groupnumber;
    @api benefitbundleid;
    @api identifier;
    @api membersearch=false;
    @api effectivedate;
    @api enddate;
    @api asofdate;

    error;
    @track outputResults = [];
    spinner=false;
    noresults=false;
    loaddata = false;
    connectedCallback(){
        this.spinner = true;
        let ancillarydata = {};
        ancillarydata.groupNumber = this.groupnumber;
        ancillarydata.benefitBundleOptionId = this.benefitbundleid;
        ancillarydata.identifier = this.identifier;
        ancillarydata.membersearch = this.membersearch;
        ancillarydata.effectivedate = this.effectivedate;
        ancillarydata.enddate = this.enddate;
        ancillarydata.asofdate = this.asofdate;
        getAncillaryPlansData({ancillData: JSON.stringify(ancillarydata)})
        .then((result) => {
            if(result){
                var resp = result.response;
                var jsonresponse = JSON.parse(resp);
                console.log('@@ancillary Plans Response'+JSON.stringify(jsonresponse));
                if (jsonresponse.Success) {
                    var output = jsonresponse.Response.searchResult.searchOutput;
                    
                    if(output.benefitBundle && output.benefitBundle.length>0){
                        var plans = output.benefitBundle[0].plan;
                        console.log('@@ancillary Plans'+JSON.stringify(plans));
                        if(plans && plans.length>0){
                            for(var i=0; i<plans.length; i++){
                                let outputwrap = {};
                                outputwrap.planname = plans[i].planName;
                                outputwrap.plantype = plans[i].planType;
                                
                                outputwrap.planlanguage = plans[i].planLanguage;
                                var incentives = plans[i].incentives;
                                let incentivewraplist = [];
                                if(incentives){
                                    for(var k=0; k<incentives.length; k++){
                                        let incentivewrap = {};
                                        var reward = plans[i].incentives[k].rewardMethod;
                                        if(reward==='01'){
                                            incentivewrap.rewardmethod = 'Spending Account';
                                        }else if(reward==='02'){
                                            incentivewrap.rewardmethod = 'Cost Share Check';
                                        }else if(reward==='03'){
                                            incentivewrap.rewardmethod = 'Cost Share Gift Card';
                                        }else if(reward==='04'){
                                            incentivewrap.rewardmethod = 'ACH / Direct Deposit';
                                        }
                                        incentivewrap.dailyrewardamount = plans[i].incentives[k].dailyMaxRewardAmount;
                                        incentivewrap.annualrewardamount = plans[i].incentives[k].annualMaxRewardAmount;
                                        incentivewrap.effectivedate = plans[i].incentives[k].effectiveDate;
                                        incentivewrap.expirationdate = plans[i].incentives[k].expirationDate;
                                        var calculation = plans[i].incentives[k].calculationBasis;
                                        if(calculation==='01'){
                                            incentivewrap.calculationbasis = 'Date Certain';
                                        }else if(calculation==='02'){
                                            incentivewrap.calculationbasis = 'On Renewal';
                                        }
                                        incentivewraplist.push(incentivewrap);
                                    }
                                }
                                if(incentivewraplist.length>0){
                                    outputwrap.incentivecheck = true;
                                    outputwrap.incentives = incentivewraplist;
                                }else{
                                    outputwrap.incentivecheck = false;
                                }
                                outputwrap.accordioncheck = false;
                                this.outputResults.push(outputwrap);
                            }
                            this.noresults = false;
                            this.loaddata = true;
                        }else{
                            this.noresults = true;
                            this.loaddata = true;
                        }
                    }else{
                        this.noresults = true;
                        this.loaddata = true;
                    }
                }else if(jsonresponse.statusCode==404){
                    const evt = new ShowToastEvent({
                        title: 'We hit a snag.',
                        message: 'No Ancillary Plans exist for the selected Member.',
                        variant: 'error',
                    });
                    this.dispatchEvent(evt);
                    this.noresults = true;
                }else{
                    const evt = new ShowToastEvent({
                        title: 'We hit a snag.',
                        message: jsonresponse.Message,
                        variant: 'error',
                    });
                    this.dispatchEvent(evt);
                    this.noresults = true;
                }
                this.spinner = false;
                this.loaddata = true;
            }
        })
        .catch((error) => {
            this.error = error;
            this.spinner = false;
            this.noresults = true;
            this.loaddata = true;
        });
    }

    toggle(event){
        this.loaddata = false;
        var op = event.target.value;
        if(this.outputResults[op].accordioncheck){
            this.outputResults[op].accordioncheck = false;
        }else{
            this.outputResults[op].accordioncheck = true;
        }
        this.loaddata = true;
    }
}