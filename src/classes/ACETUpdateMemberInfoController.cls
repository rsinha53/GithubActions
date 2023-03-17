public with sharing class ACETUpdateMemberInfoController extends ACETErrorHandler {
    
    public Contact Subject { get; set; }
    public Interaction__c Interaction { get; set; }
    public Case dummycaseObj {get;set;}
    public String memberID { get; set; }
    public string comments{get;set;}
    public ACETCallTopicsDataWrapper wrapper {get;set;}
    public string surrogateKey {get; set;}
    //public List<ACETMemberSearchResult> Results{get;set;}
    public ACETMemberDetail MemberDetail {get;set;}
    public Integer phoneNumber{get; set;}
    public ACETMemberDetail MemberDetailRequest {get;set;}
    public List<PhoneWrapper> phoneWrprList{get;set;}
    public List<emailWrapper> emailWrpr{get;set;}
    public List<addInfoWrapper> addInfoWrpr{get;set;}

    public String scrId { get; set; }
    public String ssn { get; set; }
    public String cptin { get; set; }
    public String groupId { get; set; }
    public String relationshipCode { get; set; }
    public String firstName { get; set; }
    public String LastName { get; set; }
    public String MiddleName { get; set; }
    public String nameSuffix { get; set; }
    public String gender { get; set; }
    public String dob { get; set; }
    public String MemberAddress { get; set;}
    public List<ACETMemberDetail.Phone> phoneList   ;
    public ACETHighlightsPanelAdditionalInfo AdditionalInfo {get;set;}
    //public String ErrorMessage {get;set;}
    public Boolean isClickedUpdate {get;set;}
    public Boolean updated {get;set;}
    public Boolean isSubscriber {get;set;}
    public boolean notResearchUser {get;set;}
    public String hpAdditionInfoStr {get{
        return JSON.serialize(AdditionalInfo);
    }set;}
    public boolean isSuccess{get;set;}
    public boolean isFailed{get;set;}
    public boolean isPhoneChecked{get;set;}
    public boolean checkEmail{get;set;}
    public boolean isShow{get;set;}
    public Boolean isClickedLaunchCirrus{get;set;}
    public string phones{get;set;}
    public string email{get;set;}
    public string updateTypeStr{get;set;}
    public String swivelcirrusBtn_URL {get; set;}
    public Integer rowToRemove {get;set;}
    public Integer removeInfoRow{get;set;}
    public String enrollmentmehtod{get;set;}
    public String elementToRemove{get;set;}
    public ACETUpdateMemberInfoController()
    {
        updated =  False;
        checkEmail = false;
        isShow = false;
        memberId = ApexPages.currentPage().getParameters().get('Id');
        phoneList = new List<ACETMemberDetail.Phone>();
        scrId = ApexPages.currentPage().getParameters().get('scrId');
        ssn = ApexPages.currentPage().getParameters().get('ssnId');
        elementToRemove='';
        groupId = ApexPages.currentPage().getParameters().get('grpno');
        relationshipCode  = ApexPages.currentPage().getParameters().get('rl');
        firstName = ApexPages.currentPage().getParameters().get('fn');
        LastName = ApexPages.currentPage().getParameters().get('ln');
        enrollmentmehtod= ApexPages.currentPage().getParameters().get('enrollmentMethod');
        String s = string.valueOf(System.now());
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(s));
        String uniqueString = EncodingUtil.convertToHex(hash).substring(0,20);
        PhoneWrapper phWrap = new PhoneWrapper();
        phWrap.uniqueId = uniqueString;

        phoneWrprList = new List<PhoneWrapper>();
        phoneWrprList.add(phWrap);
        emailWrpr = new List<emailWrapper>();
        String sb = string.valueOf(System.now());

        Blob hashc = Crypto.generateDigest('MD5', Blob.valueOf(sb));
        String uniqueStringc = EncodingUtil.convertToHex(hashc);
        addInfoWrapper infoWrap = new addInfoWrapper();
        infoWrap.uniqueId = uniqueStringc;

        System.debug(uniqueString);
        addInfoWrpr = new List<addInfoWrapper>();
        addInfoWrpr.add(infoWrap);
        nameSuffix = '';
        MiddleName = '';
        gender = ApexPages.currentPage().getParameters().get('gn');
        dob = ApexPages.currentPage().getParameters().get('dob');
        //added by bhanu : It was giving null pointer at line 248 for Member flow : From where this is getting populated??
        isSubscriber = false;
        //addInfoRow();

        wrapper = new ACETCallTopicsDataWrapper();
        wrapper.CaseObj.Topic__c = label.ACETCallTopicUpdateMemberDetail;
        wrapper.AutodocComment = comments;
        surrogateKey = ApexPages.currentPage().getParameters().get('SRK');
        if (!String.isEmpty(surrogateKey)){
            wrapper.surrogateKey = surrogateKey;
        }
        //String additionalInfoStr = apexpages.currentpage().getparameters().get('additionalInfo');
        //wrapper.AdditionalInfo = (ACETHighlightsPanelAdditionalInfo)json.deserialize(additionalInfoStr,ACETHighlightsPanelAdditionalInfo.class);
        //AdditionalInfo = new ACETHighlightsPanelAdditionalInfo();
    }

    public pagereference updateMember(){
       // isClickedUpdate = true;
        phoneList = new List<ACETMemberDetail.Phone>();
        system.debug('-----------phoneWrprList---->'+phoneWrprList);
        list<PhoneWrapper> pwList = new list<PhoneWrapper>();
        pwList.addAll(phoneWrprList);

        for(PhoneWrapper pw:phoneWrprList){
            ACETMemberDetail.Phone phnew = new ACETMemberDetail.Phone();
            if(pw.phone.PhoneNumberType == 'Home')
                phnew.PhoneNumberType = 'H';
            if(pw.phone.PhoneNumberType == 'Work')
                phnew.PhoneNumberType = 'W';
            if(pw.phone.PhoneNumberType == 'Mobile')
                phnew.PhoneNumberType = 'M';
            if(pw.phone.PhoneNumberType == 'Fax')
                phnew.PhoneNumberType = 'F';
            if(pw.phone.primaryIndicator == 'Yes')
                phnew.primaryIndicator = 'true';
            if(pw.phone.primaryIndicator == 'No')
                phnew.primaryIndicator = 'false';

            phnew.phoneNumber = pw.phone.phoneNumber;
            phnew.WorkExt = pw.phone.WorkExt!=null?pw.phone.WorkExt:'';
            //pw.phone.PrimaryIndicator = pw.PrimaryIndicator;
            phoneList.add(phnew);
        }

        system.debug('-----------phoneList---->'+phoneList);
        system.debug('-----------emailWrpr---->'+emailWrpr);
        ACETUpdateIndividualWebService updIndividual = new ACETUpdateIndividualWebService();
        ACETWSCalloutResult callOutResult;
        //ACETWSCalloutResult callOutResult = updIndividual.updateMembers('98090568000','' ,'2268479', 'Smyth','Christine','', '','827228793','F','1964-10-14','18', '', '','', null,'','','','','');
        if(emailWrpr.size() > 0 && emailWrpr != null){
            emailWrpr[0].emailTypeStr = emailWrpr[0].emailTypeStr == 'Primary'? 'true' : 'false' ;
            callOutResult = updIndividual.updateMembers(memberID,scrId ,groupId, lastname,firstName,middleName, nameSuffix, ssn, gender, dob,relationshipCode, emailWrpr[0].emailTypeStr , emailWrpr[0].Email, 'EML' , phoneList,'','','','','','','','');
        }else
            callOutResult = updIndividual.updateMembers(memberID,scrId ,groupId, lastname,firstName,middleName, nameSuffix, ssn, gender, dob,relationshipCode, '' , '', '' , phoneList,'','','','','','','','');
        system.debug('-----------callOutResult---->'+callOutResult);
        /*
        List<ACETMemberDetail.Phone> phoneList = new List<ACETMemberDetail.Phone>();
        for(PhoneWrapper pwObj: phoneWrprList){
            if(pwObj.selected){
                 phoneList.add(pwObj.phone);
                 isPhoneChecked = true;

            }
        }
        if(!phoneList.isEmpty())
        {
            MemberDetailRequest.Phones = phoneList;
        }

        system.debug('####MemberDetailRequestAfter'+MemberDetailRequest);
        */

        // Calling Webservice  twice to update Member Information and fetch the details
        if(callOutResult.success == true)
        {
            isSuccess = true;
            isFailed = false;
            phoneWrprList  = pwList ;
            updated = true;
            for(phoneWrapper pw:phoneWrprList){
                pw.isAddedNewRow=false;
            }
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, 'Details updated Successfully!'));//Code Commented By Chandan
             setErrorMsg('GN'+callOutResult.statusCode,null); //200-->Update Successful

            isClickedUpdate = true; 

        }
        else
        {
            isClickedUpdate = true;
            isSuccess = false;
            isFailed = true;
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, callOutResult.Message ));
      //if(callOutResult.statusCode!=207)//As 207 wont come in Update Member Page
              setErrorMsg('GN'+callOutResult.statusCode,null); 
      
        
        }
        dummyCaseObj = new Case();

        return null;

    }

    //Service call to OIL to fetch enrolled member data
    //This function calls FindMemberservice to obtain EID / membership key and then GetMembership to retrieve demographics data
    public void memberData(){
        system.debug('####Inside getmemberdata ' );
        system.debug('-----------phoneWrprList-2--->'+phoneWrprList);
        string interactionId = ApexPages.currentPage().getParameters().get('interactionId');
        string memberId = ApexPages.currentPage().getParameters().get('Id');
        phones = ApexPages.currentPage().getParameters().get('phn');

        email = ApexPages.currentPage().getParameters().get('email');
        Interaction = ACETProviderUtility.GetInteractionByID(InteractionId);

        MemberDetail = new ACETMemberDetail();

        //MemberDetail = ACETGetMemberUtility.queryMemberDetail(memberId );

        //system.debug('@@@MemberDetail '+MemberDetail );

        system.debug('@@@email '+email );
        String s = string.valueOf(System.now());
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(s));
        String uniqueString = EncodingUtil.convertToHex(hash).substring(0,20);
        PhoneWrapper phWrap = new PhoneWrapper();
        phWrap.uniqueId = uniqueString;

        phoneWrprList = new List<PhoneWrapper>();
       // phoneWrprList.add(phWrap);
        phones = '{ "phone" :'+phones+'}';
        system.debug('@@@Phones '+phones );
        /*
        List<ACETMemberDetail.Phone> phoneInfo = (List<ACETMemberDetail.Phone>)JSON.deserialize(phones, List<ACETMemberDetail.Phone>.class);
        system.debug('@@@phoneInfo : '+ phoneInfo );
        if(Phones != null){
            for(ACETMemberDetail.Phone p : MemberDetail.Phones){
                if(p.phoneNumberType == 'Home'){
                    phoneWrprList.add(new PhoneWrapper(p));
                }
            }
        }
        */
        JSONParser parser = JSON.createParser(phones);

        ACETMemberDetail.Phone phoneRec = new ACETMemberDetail.Phone();
        while (parser.nextToken() != null) {

            system.debug('------------->'+parser +'<---------->'+ parser.getText());
            system.debug('------------->'+phoneWrprList+'------>'+phoneRec);

            boolean check ;
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                (parser.getText() == 'PrimaryIndicator')) {
                // Get the value.
                parser.nextToken();
                // Compute the grand total price for all invoices.
                //phoneRec.primaryIndicator = parser.getText();
                if(parser.getText() == 'Primary')
                    phoneRec.primaryIndicator = 'Yes';
                else if(parser.getText() != 'null')
                    phoneRec.primaryIndicator = 'No';

            }
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                (parser.getText() == 'PhoneNumberType')) {
                // Get the value.
                parser.nextToken();
                // Compute the grand total price for all invoices.
                if(parser.getText() != 'null')
                    phoneRec.PhoneNumberType = parser.getText();
            }
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                (parser.getText() == 'WorkExt')) {
                parser.nextToken();
                if(parser.getText() != 'null'){
                    phoneRec.WorkExt = parser.getText();

                }
            }
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                (parser.getText() == 'PhoneNumber')) {
                // Get the value.
                parser.nextToken();
                // Compute the grand total price for all invoices.
                if(parser.getText() != 'null'){
                    phoneRec.PhoneNumber = parser.getText();
                    phoneWrprList.add(new PhoneWrapper(phoneRec,False,False));
                    phoneRec = new ACETMemberDetail.Phone();
                }
            }
        }
        Boolean check = False;
        for(PhoneWrapper pw : phoneWrprList){
            if(pw.phone.PhoneNumberType != '' && pw.phone.PhoneNumberType != null){
                String sc = string.valueOf(System.now())+pw.phone.PhoneNumber;
                Blob hashc = Crypto.generateDigest('MD5', Blob.valueOf(sc));
                String uniqueStringc = EncodingUtil.convertToHex(hashc).substring(0,20);
                pw.uniqueId = uniqueStringc;

                if(phoneWrprList.size()== 1 ){
                    pw.makeReadOnly = true;

                    pw.makePrimaryIndiReadOnly = true;
                }else{
                    if(!Check){
                        pw.makeReadOnly = True;
                        pw.makePrimaryIndiReadOnly = False;
                        check = true ;
                    }else{
                        pw.makeReadOnly = true ;
                        pw.makePrimaryIndiReadOnly = False;
                    }
                }
                pw.makeReadOnly = true;
            }

        }

        email = email.replaceAll('"','');
        emailWrpr = new List<emailWrapper>();

        if(email != 'null'){
            emailWrpr.add(new emailWrapper(email));
        } else
            checkEmail = false;
        system.debug('------------READY----->'+phoneWrprList+'----emailWrpr------> '+emailWrpr );


        addInfoWrpr = new List<addInfoWrapper>();
        addInfoWrapper infoWrap = new addInfoWrapper(updateTypeStr);
        String sb = string.valueOf(System.now());

        Blob hashc = Crypto.generateDigest('MD5', Blob.valueOf(sb));
        String uniqueStringc = EncodingUtil.convertToHex(hashc);
        infoWrap.uniqueId = uniqueStringc;

        System.debug(uniqueString);
        if(updateTypeStr != 'null'){
            addInfoWrpr.add(infoWrap);
        }
    }

    public void getAdditionalUpdates()
    {
        isShow = true;
    }

    public List<SelectOption> getPhoneNumberType(){
        List<SelectOption> phoneNumberType= new List<SelectOption>();
        phoneNumberType.add(new SelectOption('Fax','Fax'));
        phoneNumberType.add(new SelectOption('Home','Home'));
        phoneNumberType.add(new SelectOption('Mobile','Mobile'));
        phoneNumberType.add(new SelectOption('Work','Work'));
        return phoneNumberType;

    }

    public List<SelectOption> getEmailType()
    {
        List<SelectOption> EmailType= new List<SelectOption>();
        EmailType.add(new SelectOption('Primary','Primary'));
        return EmailType;

    }

    public void addPhRow(){
         ACETMemberDetail.Phone obj = new ACETMemberDetail.Phone();
         String s = string.valueOf(System.now());
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(s));
        String uniqueString = EncodingUtil.convertToHex(hash).substring(0,20);
        System.debug('phoneWrprList@@@ ' + phoneWrprList + ' @@Size@@ ' + phoneWrprList.size());


        map<Integer,String> selectedValueMap =new map<Integer,String>();

        if(selectedValueMap!=null){ // && phoneWrprList.size()>0
            integer i=0;
         for(PhoneWrapper pw :phoneWrprList){
             //phoneNumberTypeList.add(pw.phone.PhoneNumberType);
             selectedValueMap.put(i,pw.phone.PhoneNumberType);//getRestPhoneType(pw.phone.PhoneNumberType);
             i++;
         }
        }
         //PhoneWrapper pWrap = new PhoneWrapper(obj,False,False);
         PhoneWrapper pWrap = new PhoneWrapper(obj,False,False,selectedValueMap);
         pWrap.uniqueId = uniqueString;
         pWrap.isAddedNewRow=true;

         for(PhoneWrapper pw :phoneWrprList){
             pw.makePrimaryIndiReadOnly = False;
         }
         phoneWrprList.add(pWrap);
     }

     public void addEmailRow(){
         String eml='';
         String emlTypStr='';
         emailWrapper eWrap = new emailWrapper(eml);
         emailWrpr.add(eWrap);
         checkEmail = true;
     }
     public void addInfoRow()
     {
        String s = string.valueOf(System.now());

        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(s));
        String uniqueString = EncodingUtil.convertToHex(hash).substring(0,20);
        addInfoWrapper infoWrap = new addInfoWrapper(updateTypeStr);
        infoWrap.uniqueId = uniqueString;
        System.debug(uniqueString);
        addInfoWrpr.add(infoWrap);
     }

     public class PhoneWrapper{

         public ACETMemberDetail.Phone Phone{get;set;}
         //public Boolean selected{get;set;}
         public Boolean makeReadOnly{get;set;}
         public Boolean makePrimaryIndiReadOnly{get;set;}
         public string PhoneNumberType{get;set;}
         public string uniqueId{get;set;}
         //public string PrimaryIndicator{get;set;}
          public boolean hm =true;
          public boolean wr =true;//{get;set;}
          public boolean mob =true;//{get;set;}
          public boolean fax =true;//{get;set;}

         public map<Integer,String> selectedValueMap =new map<Integer,String>();
         //public Integer rowNumber;


         public Boolean isAddedNewRow{get;set;} //Added for US822050
         public List<SelectOption> getPrimaryIndicator()
            {
                List<SelectOption> PrimaryIndicator = new List<SelectOption>();
                PrimaryIndicator.add(new SelectOption('No','No'));
                PrimaryIndicator.add(new SelectOption('Yes','Yes'));

                return PrimaryIndicator;

            }
        public List<SelectOption> getPhoneNumberTypeOption(){
          List<SelectOption> phoneNumberType= new List<SelectOption>();
         system.debug('selectedValueMap='+selectedValueMap);
         for(Integer key:selectedValueMap.keySet()){
             String Type=selectedValueMap.get(key);
             if(Type == 'Home')
               this.hm = false;
             if(Type == 'Work')
                this.wr=false;
             if(Type == 'Mobile')
                 this.mob=false;
             if(Type == 'Fax')
                 this.fax=false;
         }
        system.debug('phoneNumberType='+phoneNumberType);
        System.debug('fax='+fax);
        System.debug('hm='+hm);
        System.debug('mob='+mob);
        System.debug('wr='+wr);
        if(fax)
           phoneNumberType.add(new SelectOption('Fax','Fax'));
        if(hm)
          phoneNumberType.add(new SelectOption('Home','Home'));
        if(mob)
          phoneNumberType.add(new SelectOption('Mobile','Mobile'));
        if(wr)
          phoneNumberType.add(new SelectOption('Work','Work'));

         return phoneNumberType;

         }
         public PhoneWrapper()
         {}
          public PhoneWrapper(ACETMemberDetail.Phone phonedetail,Boolean RdOnly,Boolean indi,map<Integer,String> sMap){
             Phone = phonedetail;
             makeReadOnly = RdOnly;
             //selected = False;
             PhoneNumberType = phonedetail.PhoneNumberType;
             //WorkExt=phonedetail.WorkExt;
             //primaryIndicator = phonedetail.primaryIndicator;
             makePrimaryIndiReadOnly = indi;
             this.selectedValueMap=sMap;

         }

         public PhoneWrapper(ACETMemberDetail.Phone phonedetail,Boolean RdOnly,Boolean indi){
             Phone = phonedetail;
             makeReadOnly = RdOnly;
             //selected = False;
             PhoneNumberType = phonedetail.PhoneNumberType;
             //primaryIndicator = phonedetail.primaryIndicator;
             makePrimaryIndiReadOnly = indi;
         }

     }
     public class emailWrapper{
         public string email{get;set;}
         public string emailTypeStr{get;set;}
         public Boolean selected{get;set;}

         public emailWrapper(string eml){
             email= eml;
             emailTypeStr = 'Primary';
             selected = false;
         }

     }

     public class addInfoWrapper{
         public string updateTypeStr{get;set;}
         public Boolean selected{get;set;}
         public string uniqueId{get;set;}
         public List<SelectOption> getUpdateType()
            {
                List<SelectOption> UpdateType = new List<SelectOption>();
                UpdateType.add(new SelectOption('--None--','--None--'));
                UpdateType.add(new SelectOption('Date of Birth','Date of Birth'));
                UpdateType.add(new SelectOption('Gender','Gender'));
                UpdateType.add(new SelectOption('Language Spoken','Language Spoken'));
                UpdateType.add(new SelectOption('Language Written','Language Written'));
                UpdateType.add(new SelectOption('Member Address','Member Address'));
                UpdateType.add(new SelectOption('First Name','First Name'));
                UpdateType.add(new SelectOption('Middle Name','Middle Name'));
                UpdateType.add(new SelectOption('Last Name','Last Name')); 
                UpdateType.add(new SelectOption('Suffix','Suffix'));
                UpdateType.add(new SelectOption('SSN','SSN'));
                
                return UpdateType;

            }
         public addInfoWrapper()
         {

         }
         public addInfoWrapper(string add){
             selected = false;
             updateTypeStr = add;
         }

     }
     //Added for US822050
     public void removePhoneRow(){
       system.debug('rowToRemove@@ ' + rowToRemove);
        elementToRemove=phoneWrprList.get(rowToRemove).phone.PhoneNumberType;
        phoneWrprList.remove(rowToRemove);
        for(PhoneWrapper pw :phoneWrprList){
            for(Integer i:pw.selectedValueMap.keyset()){
                String value=pw.selectedValueMap.get(i);
                if(value==elementToRemove){
                    pw.selectedValueMap.remove(i);
                    if(value=='Fax')
                       pw.fax=true;
                    if(value=='Home')
                        pw.hm=true;
                    if(value=='Mobile')
                        pw.mob=true;
                    if(value=='Work')
                        pw.wr=true;
                }
            }
        }
    }
    public void removeAddInfoRow(){
        addInfoWrpr.remove(removeInfoRow);
       }

}