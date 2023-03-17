import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import fetchexternalIdData from '@salesforce/apex/ACET_ExternalIdSearchController.fetchexternalIdData';
import fetchexternalIdDatabyORS from '@salesforce/apex/ACET_ExternalIdSearchController.fetchexternalIdDatabyORS';
import getOfficeOptions from '@salesforce/apex/ACET_ExternalIdSearchController.getOfficeOptions';
import getDepartmentOptions from '@salesforce/apex/ACET_ExternalIdSearchController.getDepartmentOptions';
import getTeamOptions from '@salesforce/apex/ACET_ExternalIdSearchController.getTeamOptions';
import getAssociateOptions from '@salesforce/apex/ACET_ExternalIdSearchController.getAssociateOptions'
const columns = [
    { label: 'ORIGINATOR TYPE', fieldName: 'originator_type', type: 'text', sortable: true, hideDefaultActions:true},
    { label: 'CREATED DATE', fieldName: 'Created_Date', type: 'date', sortable: true, hideDefaultActions:true},
    { label: 'SUBJECT', fieldName: 'Subject_name',  type: 'text', sortable: true, hideDefaultActions:true },
    { label: 'EXTERNAL ID', type: 'button', typeAttributes: {variant: 'base', label: { fieldName: 'External_Id'}, name: 'externalid'}, sortable: true, hideDefaultActions:true},
    { label: 'ID TYPE', fieldName: 'External_IdType',  type: 'text', sortable: true, hideDefaultActions:true },
    { label: 'MEMBER ID', fieldName: 'Member_Id',  type: 'text', sortable: true, hideDefaultActions:true },
    { label: 'TAX ID', fieldName: 'Tax_Id',  type: 'text', sortable: true, hideDefaultActions:true },
    { label: 'TOPIC REASON', fieldName: 'Topic_Reason',  type: 'text', sortable: true, hideDefaultActions:true }
    
];

export default class ACET_ExternalIdSearch extends LightningElement {
    @api fsourcecode;
    externalidtype;
    searchtype;
    searchtypelabel;
    searchtypevalue;
    fromdate;
    todate;
    @track associateofficeid;
    @track associateDepartmentid;
    @track associateTeamid;
    @track associateid;
    @track associateOfficeOptions;
    @track associateDepartmentOptions;
    @track associateTeamOptions;
    @track associateIdOptions;
    @track associateIdOfficeIDMapOptions;
    error;
    extenalidresults=[];
    isRendered=false;
    @track displaylist=[];
    
    //Pagination
    pagesize = 50;
    firstdisablecheck=true;
    nextdisablecheck=true;
    currentpagenumber=1;
    pagenumbers=0;

    searchtypeselection = false;
    advocatetype = false;
    taxtype = false;
    orstype = false;
    datesview = false;
    columns = columns;
    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedColumn;
    sortedBy;
    results=false;
    noresults=false;
    searchcheck=false;
    novalidationissues=false;
    externalidtypeselect=false;
    loaded=true;

    onHandleSort(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
    
        let isReverse = this.sortDirection === 'asc' ? 1 : -1;
        
        /*if (this.sortedBy == 'External_Id' || this.sortedBy == 'Member_Id' || this.sortedBy == 'Tax_Id') {
            this.extenalidresults.sort(function(a,b){
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a>b) - (b>a));
            }); 
        }else if(this.sortedBy == 'Created_Date'){
            this.extenalidresults.sort(function(a,b){
                var dateA = new Date(key(a)).getTime();
                var dateB = new Date(key(b)).getTime();
                return reverse * (dateA > dateB ? 1 : -1);
            });
        }else{
            this.extenalidresults.sort(function(a,b){ 
                var a = key(a) ? key(a).toLowerCase() : '';
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a>b) - (b>a));
            });    
        }*/
        
        this.sortedColumn = this.sortedBy;
        this.extenalidresults = JSON.parse(JSON.stringify(this.extenalidresults)).sort((a, b) => {
            a = a[this.sortedBy] ? a[this.sortedBy] : ''; // Handle null values
            b = b[this.sortedBy] ? b[this.sortedBy] : '';

            return a > b ? 1 * isReverse : -1 * isReverse;
        });
        var firstsize = (this.currentpagenumber-1)*this.pagesize;
        var lastsize = firstsize+this.pagesize;
        this.displaylist=[];
        for(var i=firstsize; i<lastsize; i++){
            this.displaylist.push(this.extenalidresults[i]);
        }
        
       //this.displaylist = this.extenalidresults;
    }
    
    get firstval(){
        return (((this.currentpagenumber-1)*this.pagesize)+1);
    }

    get lastval(){
        if((this.currentpagenumber*this.pagesize)>this.extenalidresults.length){
            return this.extenalidresults.length;
        }else{
            this.currentpagenumber*this.pagesize;
        }
    }

    get totalsize(){
        return this.extenalidresults.length;
    }

    get externalidoptions() {
        return [
            { label: 'ORS', value: 'ORS' }
        ];
    }

    connectedCallback(){
        if(this.fsourcecode==='CO' || this.fsourcecode==='CS'){
            this.externalidtype='ORS';
            this.externalidtypeselect = true;
        }
    }

    renderedCallback() {
        if(this.template.querySelector('lightning-datatable') && this.template.querySelector('lightning-datatable')!=null){
            let style = document.createElement('style');
            style.innerText = '.slds-th__action{font-family: Salesforce Sans, Arial, sans-serif; font-size: 0.75rem; color: rgb(62, 62, 60); letter-spacing: .0625rem;}';
            this.template.querySelector('lightning-datatable').appendChild(style);
            let stylecol = document.createElement('style');
            stylecol.innerText = '.slds-resizable__handle{display:none;}';
            this.template.querySelector('lightning-datatable').appendChild(stylecol);
            
        }
    }
    
    get searchtypeoptions() {
        return [
            { label: 'EEID', value: 'ALTERNATE_ID' },
            { label: 'Claim #', value: 'CLAIM_ID' },
            { label: 'Tax Id', value: 'PROVIDER_TAX_ID' },
            { label: 'ORS #', value: 'ORS' },
            { label: 'Advocate', value: 'ASSOCIATE_ID' }
        ];
    }

    externalidchange(event){
        this.externalidtype = event.detail.value;
        this.externalidtypeselect = true;
    }

    searchbychange(event){
        this.searchtype = event.detail.value;
        this.taxtype = false;
        this.advocatetype = false;
        this.orstype = false;
        this.datesview = false;
        this.searchtypeselection = false;
        if(this.searchtype){
          this.searchtypeselection = true;
        }
        if(this.searchtype==='ALTERNATE_ID'){
            this.searchtypelabel = 'EEID';
            this.datesview = true;
        }else if(this.searchtype==='CLAIM_ID'){
            this.searchtypelabel = 'Claim #';
            this.datesview = true;
        }else if(this.searchtype==='PROVIDER_TAX_ID'){
            this.searchtypelabel = 'Tax ID';
            this.datesview = true;
            this.taxtype = true;
        }else if(this.searchtype==='ASSOCIATE_ID'){
            this.advocatetype = true;
            this.datesview = true;
            this.getAssociateOfficeOptions();
            this.associateofficeid = '';
            this.associateDepartmentid = '';
            this.associateTeamid = '';
            this.associateid = '';
            this.associateIdOptions = [];
        } else if (this.searchtype === 'ORS') {
            this.searchtypelabel = 'ORS #';
            this.orstype = true;
        }
        this.searchtypevalue = '';
        this.fromdate=null;
        this.todate=null;
       
    }
   
    searchtypevaluechange(event){
        this.searchtypevalue = event.detail.value;        
    }

    handleOnBlur(event){
        if(this.searchtype==='PROVIDER_TAX_ID' && (!this.searchtypevalue || this.searchtypevalue!=null)){
            this.template.querySelector("lightning-input[data-id=taxidval]").setCustomValidity('');
            this.template.querySelector("lightning-input[data-id=taxidval]").reportValidity();
        }else if(this.searchtype==='ORS' && (!this.searchtypevalue || this.searchtypevalue!=null)){
            this.template.querySelector("lightning-input[data-id=orsidval]").setCustomValidity('');
            this.template.querySelector("lightning-input[data-id=orsidval]").reportValidity();
        }else if((this.todate && this.fromdate) && (this.todate >= this.fromdate)){
            this.template.querySelector("lightning-input[data-id=todate]").setCustomValidity('');
            this.template.querySelector("lightning-input[data-id=todate]").reportValidity();
        }else if(!this.todate){
            this.template.querySelector("lightning-input[data-id=todate]").setCustomValidity('');
            this.template.querySelector("lightning-input[data-id=todate]").reportValidity();
        }
    }

    associateofficechange(event){
        this.associateofficeid = event.detail.value;
        // Get relevant department options
        this.getAssociateDepartmentOptions();
        this.associateDepartmentOptions = [];
        this.associateDepartmentid = '';
        this.associateTeamOptions = [];
        this.associateTeamid = '';
        this.associateid = '';
        this.associateIdOptions = [];
    }

    associateDepartmentchange(event){
        this.associateDepartmentid = event.detail.value;
        this.associateTeamOptions = [];
        this.associateTeamid = '';
        this.associateIdOptions = [];
        this.associateid = '';
        this.getAssociateTeamOptions();
    }

    associateTeamchange(event){
        this.associateTeamid = event.detail.value;
        // Get relevant associate name options
        this.associateIdOptions = [];
        this.associateid = '';
        this.getAssociateIdOptions();
    }

    associateidchange(event){
        this.associateid = event.detail.value;
    }

    fromdatechange(event){
        this.fromdate = event.detail.value;
    }

    todatechange(event){
        this.todate = event.detail.value;
        if((this.todate && this.fromdate) && (this.todate < this.fromdate)){
            this.template.querySelector("lightning-input[data-id=todate]").setCustomValidity('Enter a date after the from date.');
            this.template.querySelector("lightning-input[data-id=todate]").reportValidity();
        }else{
            this.template.querySelector("lightning-input[data-id=todate]").setCustomValidity('');
            this.template.querySelector("lightning-input[data-id=todate]").reportValidity();
        }
    }

    handleClear() {
        this.externalidtype = '';
        this.externalidtypeselect = false;
        this.todate = '';
        this.fromdate = '';
        this.searchtype = '';
        this.searchtypelabel = '';
        this.searchtypevalue = '';
        this.error = '';
        this.searchtypeselection = false;
        this.advocatetype = false;
        this.taxtype = false;
        this.orstype = false;
        this.datesview = false;
    }

    handleSearch() {
        if(!this.todate && this.fromdate){
            this.todate = this.fromdate;
        }else if(this.todate && !this.fromdate){
            this.fromdate = this.todate;
        }
        this.validation();
        if(!this.novalidationissues){
            this.loaded=false;
            if(this.searchtype==='ORS'){
                this.fetchexternaldataors(); 
            }else{
                this.fetchexternaldata();
            }
       }
        
    }

    validation(){
        if(this.externalidtype && !this.searchtype){
            const evt = new ShowToastEvent({
                title: 'We hit a snag.',
                message: 'Search criteria must include External ID Type + Search By type.',
                variant: 'error',
            });
            this.dispatchEvent(evt);
            this.novalidationissues = true;
        }else if(!this.externalidtype || !this.searchtype){
            const evt = new ShowToastEvent({
                title: 'We hit a snag.',
                message: 'Search criteria must include External ID Type + Search By type.',
                variant: 'error',
            });
            this.dispatchEvent(evt);
            this.novalidationissues = true;
        }else if(this.externalidtype && this.searchtype==='ORS' && !this.searchtypevalue){
            const evt = new ShowToastEvent({
                title: 'We hit a snag.',
                message: 'Search criteria must include External ID Type + Search By + ORS #.',
                variant: 'error',
            });
            this.dispatchEvent(evt);
            this.novalidationissues = true;
        }else if(this.externalidtype && this.searchtype==='ORS' && this.searchtypevalue && this.searchtypevalue.length!=15){
            this.template.querySelector("lightning-input[data-id=orsidval]").setCustomValidity('Enter 15 characters.');
            this.template.querySelector("lightning-input[data-id=orsidval]").reportValidity();
            this.novalidationissues = true;
        }else if(this.externalidtype && this.searchtype==='PROVIDER_TAX_ID' && !this.searchtypevalue){
            const evt = new ShowToastEvent({
                title: 'We hit a snag.',
                message: 'Search criteria must include External ID Type + Search By + TAX ID',
                variant: 'error',
            });
            this.dispatchEvent(evt);
            this.novalidationissues = true;
        }else if(this.externalidtype && this.searchtype==='PROVIDER_TAX_ID' && this.searchtypevalue && !this.searchtypevalue.match('^\\d+$')){
            this.template.querySelector("lightning-input[data-id=taxidval]").setCustomValidity('Enter a numeric value.');
            this.template.querySelector("lightning-input[data-id=taxidval]").reportValidity();
            this.novalidationissues = true;
        }else if(this.externalidtype && this.searchtype==='PROVIDER_TAX_ID' && this.searchtypevalue && this.searchtypevalue.length!=9){
            this.template.querySelector("lightning-input[data-id=taxidval]").setCustomValidity('Enter 9 digits.');
            this.template.querySelector("lightning-input[data-id=taxidval]").reportValidity();
            this.novalidationissues = true;
        }else if(this.externalidtype && this.searchtype==='ALTERNATE_ID' && !this.searchtypevalue){
            const evt = new ShowToastEvent({
                title: 'We hit a snag.',
                message: 'Search criteria must include External ID Type + Search By + EEID.',
                variant: 'error',
            });
            this.dispatchEvent(evt);
            this.novalidationissues = true;
        }// US3516993:External ID search (provider snapshot) - Search by Claim # - Krish - 1st June 2021 - START
        else if(this.externalidtype && this.searchtype==='CLAIM_ID' && !this.searchtypevalue){
            const evt = new ShowToastEvent({
                title: 'We hit a snag.',
                message: 'Search criteria must include External ID Type + Search By + Claim #',
                variant: 'error',
            });
            this.dispatchEvent(evt);
            this.novalidationissues = true;
        } // US3516993:External ID search (provider snapshot) - Search by Claim # - Krish - 1st June 2021 - END
        else if(this.externalidtype && this.searchtype==='ASSOCIATE_ID' && (!this.associateofficeid || !this.associateid)){
            const evt = new ShowToastEvent({
                title: 'We hit a snag.',
                message: 'Search criteria must include External ID Type + Search By + Office + Department + Team + Associate Name/ID',
                variant: 'error',
            });
            this.dispatchEvent(evt);
            this.novalidationissues = true;
        } // US3516993:External ID search (provider snapshot) - Search by Advocate - Krish - 1st June 2021 - END
        else if((this.todate && this.fromdate) && (this.todate < this.fromdate)){
            this.template.querySelector("lightning-input[data-id=todate]").setCustomValidity('Enter a date after the from date.');
            this.template.querySelector("lightning-input[data-id=todate]").reportValidity();
            this.novalidationissues = true;
        }else{
            this.novalidationissues = false;
        }
    }

    fetchexternaldata(){
        fetchexternalIdData({ searchtype: this.searchtype, searchvalue: this.searchtypevalue, fromdate: this.fromdate, todate: this.todate, officeId: this.associateofficeid, associateId: this.associateid})
            .then((result) => {
                if (result) {
                    let externalidreslist = [];
                    let displaylistcount = 0;
                    let displayvallist = [];
                    result.forEach(idresult => {
                        if(idresult.error){
                            if(idresult.errortype==='error'){
                                const evt = new ShowToastEvent({
                                    title: 'We hit a snag.',
                                    message: idresult.errormsg,
                                    variant: 'error',
                                });
                                this.dispatchEvent(evt);
                            }else if(idresult.errortype==='info'){
                                const evt = new ShowToastEvent({
                                    title: 'Information!',
                                    message: idresult.errormsg,
                                    variant: 'warning',
                                });
                                this.dispatchEvent(evt);
                            }
                        }else{
                            let externalidres = {};   
                            externalidres.Id=displaylistcount;            
                            externalidres.originator_type = idresult.OriginatorType;
                            externalidres.Created_Date = idresult.CreatedDate;
                            externalidres.Subject_name = idresult.Subject;
                            externalidres.External_Id = idresult.ID;
                            externalidres.External_IdType = idresult.IDType;
                            externalidres.Topic_Reason = idresult.TopicReason;
                            externalidres.Member_Id = idresult.memberId;
                            externalidres.Tax_Id = idresult.taxId;
                            externalidreslist.push(externalidres);
                            if(displaylistcount<this.pagesize){
                                displayvallist.push(externalidres);
                            }
                            displaylistcount=displaylistcount+1;
                        }
                    });
                                        
                    this.extenalidresults = externalidreslist;     
                    if(this.extenalidresults && this.extenalidresults.length>0){
                      var totalcount = this.extenalidresults.length;
                      this.pagenumbers =  Math.ceil(totalcount/this.pagesize);
                      this.results=true;
                      this.noresults=false;
                      if(this.extenalidresults.length>this.pagesize){
                        this.nextdisablecheck=false;
                      }
                    }else{
                        this.noresults=true;
                        this.results=false;
                    }

                    this.displaylist = displayvallist;
                    this.error = undefined;
                }else{
                    this.noresults=true;
                    this.results=false;
                    this.displaylist = [];
                    this.extenalidresults = [];
                }
                this.searchcheck = true;
                this.loaded=true; 
            })
            .catch((error) => {
                this.error = error;
                this.extenalidresults = undefined;
            });
    }

    fetchexternaldataors(){
        fetchexternalIdDatabyORS({ searchtype: this.searchtype, searchvalue: this.searchtypevalue})
            .then((result) => {
                if (result) {
                    let externalidreslist = [];
                    let displaylistcount = 0;
                    let displayvallist = [];
                    result.forEach(idresult => {
                        if(idresult.error){
                            if(idresult.errortype==='error'){
                                const evt = new ShowToastEvent({
                                    title: 'We hit a snag.',
                                    message: idresult.errormsg,
                                    variant: 'error',
                                });
                                this.dispatchEvent(evt);
                            }else if(idresult.errortype==='info'){
                                const evt = new ShowToastEvent({
                                    title: 'Information!',
                                    message: idresult.errormsg,
                                    variant: 'warning',
                                });
                                this.dispatchEvent(evt);
                            }
                        }else{
                            let externalidres = {};  
                            externalidres.Id=displaylistcount;                     
                            externalidres.originator_type = idresult.OriginatorType;
                            externalidres.Created_Date = idresult.CreatedDate;
                            externalidres.Subject_name = idresult.Subject;
                            externalidres.External_Id = idresult.ID;
                            externalidres.External_IdType = idresult.IDType;
                            externalidres.Topic_Reason = idresult.TopicReason;
                            externalidres.Member_Id = idresult.memberId;
                            externalidres.Tax_Id = idresult.taxId;
                            externalidreslist.push(externalidres);
                            if(displaylistcount<this.pagesize){
                                displayvallist.push(externalidres);
                            }
                            displaylistcount=displaylistcount+1;
                        }
                    });
                    this.extenalidresults = externalidreslist;
                    
                    if(this.extenalidresults && this.extenalidresults.length>0){
                        var totalcount = this.extenalidresults.length;
                        this.pagenumbers =  Math.ceil(totalcount/this.pagesize);
                        this.results=true;
                        this.noresults=false;
                        if(this.extenalidresults.length>this.pagesize){
                            this.nextdisablecheck=false;
                        }
                    }else{
                        this.noresults=true;
                        this.results=false;
                    }

                    this.displaylist = displayvallist;
                    this.error = undefined;
                }else{
                    this.noresults=true;
                    this.results=false;
                    this.displaylist = [];
                    this.extenalidresults = [];
                }
                this.searchcheck = true;
                this.loaded=true;
            })
            .catch((error) => {
                this.error = error;
                this.extenalidresults = undefined;
            });
    }

    onFirst(){
        this.currentpagenumber = 1;
        this.displaylist =[];
        for(var i=0; i<this.pagesize; i++){
            this.displaylist.push(this.extenalidresults[i]);
        }
        this.nextdisablecheck = false;
        this.firstdisablecheck = true;
    }
    onLast(){
        this.currentpagenumber = this.pagenumbers;
        this.displaylist =[];
        var firstsize = (this.currentpagenumber-1)*this.pagesize;
        for(var i=firstsize; i<this.extenalidresults.length; i++){
            this.displaylist.push(this.extenalidresults[i]);
        }
        this.nextdisablecheck = true;
        this.firstdisablecheck = false;
    }
    onPrev(){
        this.currentpagenumber = this.currentpagenumber - 1;
        this.displaylist =[];
        var firstsize = (this.currentpagenumber-1)*this.pagesize;
        var lastsize = firstsize+this.pagesize;
        for(var i=firstsize; i<lastsize; i++){
            this.displaylist.push(this.extenalidresults[i]);
        }
        if(firstsize==0){
            this.firstdisablecheck = true;
            this.nextdisablecheck = false;
        }
    }
    onNext(){
        this.currentpagenumber = this.currentpagenumber + 1;
        this.displaylist =[];
        var firstsize = (this.currentpagenumber-1)*this.pagesize;
        var lastsize = firstsize+this.pagesize;
        if(lastsize>this.extenalidresults.length){
            lastsize = this.extenalidresults.length;
            this.nextdisablecheck = true;
            this.firstdisablecheck = false;
        }
        for(var i=firstsize; i<lastsize; i++){
            this.displaylist.push(this.extenalidresults[i]);
        }
    }
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'externalid':
                this.navigateservicerequestdetail(row);
                break;
            default:
        }
    }

    navigateservicerequestdetail(data){
        const selectedEvent = new CustomEvent('externalidselect', { detail: {extid: data.External_Id, extidtype: data.External_IdType }});
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }    

    searchtable(event){
        var searchval = event.detail.value;
        searchval = searchval.toLowerCase();
        this.displaylist = [];
        for(var i=0; i<this.extenalidresults.length; i++){
            if(this.extenalidresults[i].originator_type.toLowerCase().includes(searchval) || this.extenalidresults[i].Subject_name.toLowerCase().includes(searchval)
             || this.extenalidresults[i].External_Id.toLowerCase().includes(searchval) || this.extenalidresults[i].External_IdType.toLowerCase().includes(searchval) || this.extenalidresults[i].Topic_Reason.toLowerCase().includes(searchval)){
                
                this.displaylist.push(this.extenalidresults[i]);
            }
        }
    }

    // US3520457: External ID search (Provider Snapshot) - Search by Advocate - Krish - 16th June 2021
    getAssociateOfficeOptions(){
        getOfficeOptions()
            .then((result) => {
                if (result) {
                    this.associateOfficeOptions = [];
                    for(var i=0; i<result.length; i++){
                        this.associateOfficeOptions.push({label: result[i], value: result[i]});
                    }
                }else{
                    console.log('Failed to get Office Options');
                }
            })
            .catch((error) => {
                this.error = error;
                //this.extenalidresults = undefined;
            });
    }

        getAssociateDepartmentOptions(){
            getDepartmentOptions({office: this.associateofficeid})
            .then((result) => {
                if (result) {
                    this.associateDepartmentOptions = [];
                    for(var i=0; i<result.length; i++){
                        this.associateDepartmentOptions.push({label: result[i], value: result[i]});
                    }
                }else{
                    console.log('error');
                }
            })
            .catch((error) => {
                this.error = error;
                //this.extenalidresults = undefined;
            });
        }

        getAssociateTeamOptions(){
            getTeamOptions({office: this.associateofficeid, department: this.associateDepartmentid})
            .then((result) => {
                if (result) {
                    this.associateTeamOptions = [];
                    for(var i=0; i<result.length; i++){
                        this.associateTeamOptions.push({label: result[i], value: result[i]});
                    }
                }else{
                    console.log('error');
                }
            })
            .catch((error) => {
                this.error = error;
            });

        }

        getAssociateIdOptions(){
            getAssociateOptions({office: this.associateofficeid, department: this.associateDepartmentid, team: this.associateTeamid})
            .then((result) => {
                if (result) {
                    this.associateIdOptions = [];
                    this.associateIdOfficeIDMapOptions = [];
                    for(var i=0; i<result.length; i++){
                        this.associateIdOptions.push({label: result[i].associateId+ ' - '+result[i].associateName, value: result[i].associateId+ ' '+result[i].associateName});
                        this.associateIdOfficeIDMapOptions.push({label: result[i].associateId+ ' - '+result[i].associateOfficeId, value: result[i].associateId+ ' '+result[i].associateOfficeId});
                    }
                }else{
                    console.log('error');
                }
            })
            .catch((error) => {
                this.error = error;
            });
        }
}