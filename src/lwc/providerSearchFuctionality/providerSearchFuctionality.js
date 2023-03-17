import { LightningElement,track,wire,api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import searchresults from '@salesforce/apex/ProviderSearchController.searchProvider';
import addDetails from '@salesforce/apex/ProviderSearchController.createAssociateRecords';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import radioStyle from '@salesforce/resourceUrl/radioStyle';
import labelvalue from '@salesforce/label/c.Provider_Record_Navigation';
//import { loadStyle } from 'lightning/platformResourceLoader'; 
export default class ProviderSearchFuctionality extends NavigationMixin(LightningElement) {
    @api recordId;
    @track url;
    @track page=1;
    @track startingRecord=1;
    @track endingRecord=0;
    //@track pageSize=10;
    @track totalRecordCount=0;
    @track isPgChng=false;
   // @track totalPages=0;
    disabledPreviousButton=true;
    disabledNextButton=true;




    pageSizeOptions = [5, 10, 25, 50, 75, 100]; //Page size options
    records = []; //All records available in the data table
    columns = []; //columns information available in the data table
    totalRecords = 0; //Total no.of records
    pageSize=50; //No.of records to be displayed per page
    totalPages; //Total no.of pages
    pageNumber = 1; //Page number    
    recordsToDisplay = []; //Records to be displayed on the page
    
    get bDisableFirst() {
        return this.pageNumber == 1;
    }
    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }

    firstName=''; 
    lastName='';
    name='';
     Tin='';
     address='';
     City='';
     State='';
     value=null;
     Zipcode='';
     Phonenumber='';
     radio='';
     radio1='';
     Providercheck=true;
     @api parentId;
     Facilitycheck=false;    
     @track data= [];  
     @track value='';
    isLoading=false;
    checked=true;
    checkedvalue=false;
    @track hideCoulmn;
    @track selectedRow=[];
    @track searchMap = [];
    @track searchdata=[];
    @track fetcheddata= [];
    @track showdata=[];
    addbtn=true;
    searchbtn=true;
    pagebtn=false;
    @track columns = [
       // { label: 'NPI ID', fieldName: 'NPI',type: 'text' },
        { label: 'Name', fieldName: 'Name',type: 'text'  },

        {
            fieldName: 'Address',
            fieldName: 'Address',
            label: 'Address',
            type: 'text',
            
             },
        
        { label: 'Phone', fieldName: 'Phone', type: 'text' },
        { label: 'Tin', fieldName: 'Tin', type: 'text' }
    ];
  
    get options1() {
        return [
            { label: "Provider", value: "Provider" },
            { label: "Facility", value: "Facility" }          
            
        ];
    }
 
  
    get options() {
        return [
            
            { label: 'AK', value: 'AK' },
            { label: 'AL', value: 'AL' },
            { label: 'AR', value: 'AR' },
            { label: 'AZ', value: 'AZ' },
            { label: 'CA', value: 'CA' },
            { label: 'CO', value: 'CO' },
            { label: 'CT', value: 'CT' },
            { label: 'DC', value: 'DC' },
            { label: 'DE', value: 'DE' },
            { label: 'FL', value: 'FL' },
            { label: 'GA', value: 'GA' },
            { label: 'HI', value: 'HI' },
            { label: 'IA', value: 'IA' },
            { label: 'ID', value: 'ID' },
            { label: 'IL', value: 'IL' },
            { label: 'IN', value: 'IN' },
            { label: 'KS', value: 'KS' },
            { label: 'KY', value: 'KY' },
            { label: 'LA', value: 'LA' },
            { label: 'MA', value: 'MA' },
            { label: 'MD', value: 'MD' },
            { label: 'ME', value: 'ME' },
            { label: 'MI', value: 'MI' },
            { label: 'MN', value: 'MN' },
            { label: 'MO', value: 'MO' },
            { label: 'MS', value: 'MS' },
            { label: 'MT', value: 'MT' },
            { label: 'NC', value: 'NC' },
            { label: 'ND', value: 'ND' },
            { label: 'NE', value: 'NE' },
            { label: 'NH', value: 'NH' },
            { label: 'NJ', value: 'NJ' },
            { label: 'NM', value: 'NM' },
            { label: 'NV', value: 'NV' },
            { label: 'NY', value: 'NY' },
            { label: 'OH', value: 'OH' },
            { label: 'OK', value: 'OK' },
            { label: 'OR', value: 'OR' },
            { label: 'PA', value: 'PA' },
            { label: 'PR', value: 'PR' },
            { label: 'RI', value: 'RI' },
            { label: 'SC', value: 'SC' },
            { label: 'SD', value: 'SD' },
            { label: 'TN', value: 'TN' },
            { label: 'TX', value: 'TX' },
            { label: 'UT', value: 'UT' },
            { label: 'VA', value: 'VA' },
            { label: 'VT', value: 'VT' },
            { label: 'WA', value: 'WA' },
            { label: 'WI', value: 'WI' },
            { label: 'WV', value: 'WV' },
            { label: 'WY', value: 'WY' }
        ];
    }
    

    getSelectedRecords(event){        
        this.selectedRow=event.detail.selectedRows;
        console.log('selected Data'+JSON.stringify(this.selectedRow));      
     if(this.selectedRow.length >=1){
        this.addbtn=false;
     }else{
        this.addbtn=true;
     }

    }  

    handleFirstName(event){
        this.firstName=event.target.value;      
       this.searchbtn=false;
    }
    handleLastname(event){
        this.lastName=event.target.value;  
        this.searchbtn=false;     
    }
    handleName(event){
        this.name=event.target.value;  
        this.searchbtn=false;     
    }
    handleTin(event){
        this.Tin=event.target.value; 
        this.searchbtn=false;     
    }
    handleAddress(event){
        this.address=event.target.value;       
    }
    handleCity(event){
        this.City=event.target.value; 
        this.searchbtn=false;    
    }
    
    handleState(event){
        this.State=event.target.value; 
        this.searchbtn=false;      
    }
    handleZipcode(event){
        this.Zipcode=event.target.value;      
    }
    handlePhonenumber(event){
        this.Phonenumber=event.target.value;
        this.searchbtn=false;
       
    }
    handleRadio1(event){
        this.firstName ='';
        this.lastName=' ';
        this.Tin='';
        this.address='';
        this.City='';
        this.State=null;
        this.Zipcode='';
        this.Phonenumber='';
        this.name='';
        this.showdata=[];
        this.pagebtn=false; 
        this.radio1=event.target.value;
        console.log('facility Radio check'+this.radio1);
        this.Facilitycheck=true;  
        this.Providercheck=false;
        this.checkedvalue=true;
       this.checked=false;
       this.pageNumber=1;
       console.log('PageNumber'+this.pageNumber);

        
    }
    handleRadio(event){
        this.firstName ='';
        this.lastName=' ';
        this.Tin='';
        this.address='';
        this.City='';
        this.State=null;
        this.Zipcode='';
        this.Phonenumber='';
        this.name='';
        this.showdata=[];
        this.pagebtn=false;    
        this.radio=event.target.label;
        console.log('Radio Check'+this.radio);
        this.Providercheck=true;
        this.Facilitycheck=false;
         this.checked=true;
         this.checkedvalue=false;
         this.pageNumber=1;
         console.log('PageNumber'+this.pageNumber);
        
      
    }

    handleSearch(){
        console.log('checking!@@@',this.Providercheck);      
        let searchResObj={};
        let searchobjdata=[]; 
        this.showdata=[]; 
        this.fetcheddata= [];  
        this.pagebtn=false;   
       if( this.Providercheck==true){
        searchResObj.FirstName=this.firstName ;
        searchResObj.LastName=this.lastName;
        console.log('mapName',searchResObj.FirstName);       
    }else{
        searchResObj.Name=this.name;
    }
        searchResObj.TIN=this.Tin;
        searchResObj.Address=this.address;
        searchResObj.City=this.City;
        searchResObj.State=this.State;
        searchResObj.ZipCode=this.Zipcode;
        searchResObj.PhoneNumber=this.Phonenumber;

        searchobjdata.push(searchResObj);         
        console.log('map',searchobjdata);
        this.isLoading=true;       
        this.pagebtn=false;
        console.log('checking',this.recordId);    
        if(!this.isPgChng)  
        this.pageNumber = 1;
        else
        this.isPgChng = false;
        searchresults({searchParams:searchobjdata,pageNumber:this.pageNumber,isPractitioner:this.Providercheck})
        .then((result) => {          
                console.log('Response'+JSON.stringify(result));
            this.totalRecords = result.totalCount;
            
             console.log('Response12'+result.Response.length);
           //  console.log('ResponseTAX'+result.Response.TAX);
             if(result.Response.length > 0){
                this.pagebtn=true;
             }
           
            for(var i=0;i<result.Response.length;i++){
               // console.log('In Loop',result.Response[i].Code[i].value);
                var obj={
                Name:result.Response[i].fullName,
                Address:result.Response[i].address,
                Phone:result.Response[i].phone,
                Tin: result.Response[i].taxId,
                NPI:result.Response[i].NPI ,
                EPIMID:result.Response[i].EPIMID ,
                State:result.Response[i].state,
                City:result.Response[i].city,
                Zipcode:result.Response[i].zipCode,
                Speciality:result.Response[i].speciality

                }
                this.fetcheddata.push(obj); 
               
            
               // console.log('Table Data1@@'+JSON.stringify(this.fetcheddata));        
                //this.searchdata=this.fetcheddata;                
            }          
            //console.log('Table Data1@@@'+fetcheddata.length);
            this.showdata=this.fetcheddata;
            this.paginationHelper();
            console.log('Table Data1@@@'+JSON.stringify(this.showdata));            
           
            this.error=undefined;
            this.isLoading=false;
       
        })
       .catch((error) => {  
        this.error = error; 
        this.isLoading=false;
       }); 
    
    }
    previousPage() {
        this.pageNumber = this.pageNumber - 1;
        this.isPgChng = true;
        console.log('PageNumber'+this.pageNumber);
        this.handleSearch();
    }
    nextPage() {
        this.pageNumber = this.pageNumber + 1;
        this.isPgChng = true;
        console.log('PageNumber'+this.pageNumber);
        this.handleSearch();
    }
  

    
    // JS function to handel pagination logic 
    paginationHelper() {
        this.recordsToDisplay = [];
        // calculate total pages
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        console.log('total Pages'+totalPages);
        // set page number 
      
        //this.showdata=this.recordsToDisplay;
       
       
    }

    handleClear(){

        this.firstName ='';
        this.lastName='';
        this.Tin='';
        this.address='';
        this.City='';
        this.State=null;
        this.Zipcode='';
        this.Phonenumber='';
        this.name='';
        this.showdata=[];
        this.pagebtn=false;
        this.value=null;
        this.pageNumber=1;
        this.template.querySelectorAll('lightning-combobox').forEach(each => {
            each.value = null;
        });
       

    }
    closeAction() {
        var st1=''
        st1=labelvalue;
            st1+=this.parentId;
            st1+='/view';
                console.log('Navigate'+st1);
       window.location.href=st1;
     }
     handleAdd(){
        var st='';
        console.log('selected'+JSON.stringify(this.selectedRow));
        console.log('parent id'+this.parentId);
       
      addDetails({ selectedRecords:this.selectedRow,ParentId:this.parentId})
        .then((result) => {
            console.log('selected Data Result',this.parentId);
           
            const event = new ShowToastEvent({
                title: 'Success',
                message: 'Created Record Successfully',
                variant: 'success'
                
            });
            this.dispatchEvent(event);


            st=labelvalue;
            st+=this.parentId;
            st+='/view';
                console.log('Navigate'+st);
       window.location.href=st;
     })
     .catch((error) => {  
        this.error = error; 
        
       });

      
    }

}