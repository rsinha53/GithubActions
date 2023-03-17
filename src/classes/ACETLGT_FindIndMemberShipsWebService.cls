public class ACETLGT_FindIndMemberShipsWebService extends ACETWebService{ 
    
    //set endpoints
    public override void getEndpoint(){
        GetEndpointDetail('SearchMembersCoveragesEndpoint');       
    }
    public ACETLGT_FindIndMemberShipsWebService() {
        super('Stargate');
    }
    //create request body
    public void getRequestBody(String memberId, String firstname, String lastName, String dob,String state, String zip){
        
        RequestBody =   '{"findIndividualMembershipsRequest": {"searchId": "'+memberId+'","searchTypeCode": "","firstName": "'+firstname+'","lastName": "'+lastName+'",'
            +'"birthDate": "'+dob+'",'
            +'"stateCode": "'+state+'",' 
            +'"postalCode": "'+zip+'",'
            +'"effectiveStartDate": "1800-01-01",'
            +'"effectiveEndDate": "9999-12-31"'
            
            +'}'
            +'}';                                          
    } 
    
    public String getBenefitEffectiveDate(String effectiveDate, String LatestCOStartDate){
        
        String benEffDate='';
        if(String.isNotBlank(effectiveDate) && String.isNotBlank(LatestCOStartDate)){
            if( Date.Parse(effectiveDate) >= Date.Parse(LatestCOStartDate))
                benEffDate = effectiveDate ;
            Else
                benEffDate = (LatestCOStartDate!= null)?LatestCOStartDate:'';
        }else{
            benEffDate = '';
        }
        return benEffDate;
    }                
    public String getBenefitEndDate(String endDate, String LatestCOEndDate){
        String benEndDate ='';
        if (endDate == '12/31/9999' )
            benEndDate = (LatestCOEndDate != null)?LatestCOEndDate:'';	
        else {
            if(String.isNotBlank(endDate) && String.isNotBlank(LatestCOEndDate)){
                
                if(date.parse(endDate)  >= date.parse(LatestCOEndDate))
                    benEndDate=(LatestCOEndDate != null)?LatestCOEndDate:'';
                else
                    benEndDate=endDate ;
            }else{
                benEndDate = '';
            }
        } 
        return benEndDate;
        
    } 
    
    Public class LatestCOdates{
        public String LatestCOStartDate{get;set;}
        public String LatestCOEndDate{get;set;}
        Public String customerPurchaseId {get;set;}
    }
    Public LatestCOdates getLatestCODates(list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions> acpvlist, String endDate){
        LatestCOdates lcd= new LatestCOdates();
        system.debug('@@@endDate'+endDate+'//');
        if(acpvlist != null){
            if(acpvlist.size() == 1){
                lcd.LatestCOStartDate = acpvlist[0].contractOptionStartDate;
                lcd.LatestCOEndDate =  acpvlist[0].contractOptionEndDate;
                lcd.customerPurchaseId = acpvlist[0].customerPurchaseId;
            }
            else if(acpvlist.size() > 1){
                for(ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions resacpv:acpvlist){
                    if(Date.Parse(resacpv.contractOptionStartDate) <= Date.today() && Date.today() <=Date.Parse(resacpv.contractOptionEndDate)){
                        lcd.LatestCOStartDate = resacpv.contractOptionStartDate;
                        lcd.LatestCOEndDate = resacpv.contractOptionEndDate;
                        lcd.customerPurchaseId =  resacpv.customerPurchaseId;
                        break;
                    } else if(Date.Parse(resacpv.contractOptionStartDate) >= Date.today() ){
                        lcd.LatestCOStartDate = resacpv.contractOptionStartDate;
                        lcd.LatestCOEndDate = resacpv.contractOptionEndDate;
                        lcd.customerPurchaseId =  resacpv.customerPurchaseId;
                    }else if(endDate!=''&& endDate != '12/31/9999' && Date.Parse(resacpv.contractOptionEndDate) <= Date.today() && Date.Parse(resacpv.contractOptionStartDate) <= Date.Parse(endDate) && Date.Parse(endDate) <= Date.Parse(resacpv.contractOptionEndDate) ){
                        lcd.LatestCOStartDate = resacpv.contractOptionStartDate;
                        lcd.LatestCOEndDate = resacpv.contractOptionEndDate  ; 
                        lcd.customerPurchaseId =  resacpv.customerPurchaseId;
                    }
                    
                }
                system.debug('$$$latest CO check'+ lcd.LatestCOStartDate+'///'+lcd.LatestCOEndDate );
            }
        }
        else{
            lcd.LatestCOStartDate = '';
            lcd.LatestCOEndDate = ''  ; 
            
        }
        
        return lcd;
    }
    //To get Specialty Benefits
    Public List<ACETLGT_MemberSearchCoveragesResult.SpecialtyBenefits> getSpecialtyBenefits(ACETLGT_FindIndMembershipsJSON2Apex.Coverages cov){
        List<ACETLGT_MemberSearchCoveragesResult.SpecialtyBenefits> specBenList = new List<ACETLGT_MemberSearchCoveragesResult.SpecialtyBenefits>();   
        system.debug('Inside Specialty Benefits');                            
        ACETLGT_MemberSearchCoveragesResult.SpecialtyBenefits sb = new ACETLGT_MemberSearchCoveragesResult.SpecialtyBenefits(); 
        sb.contractOptionTypeCode = (cov.contractOptionTypeDescription!= null)?cov.contractOptionTypeDescription:'';
        sb.planOptionID = (cov.benefit != null && cov.benefit.planOptionID!= null)?cov.benefit.planOptionID:'';
        // US3434065 - Use Membership dates instead of contract option dates
        sb.contractOptionStartDate = String.isNotBlank(cov.membershipEffectiveDate)?formatDate(cov.membershipEffectiveDate):'';
        sb.contractOptionEndDate = String.isNotBlank(cov.membershipExpirationDate)?formatDate(cov.membershipExpirationDate):'';
        sb.isActive = isActiveCoverage(sb.contractOptionStartDate, sb.contractOptionEndDate);
        sb.isFuture = (sb.contractOptionStartDate != null && Date.Parse(sb.contractOptionStartDate) > Date.today() )? True : False;
        sb.isTermed = (sb.contractOptionEndDate != null && sb.contractOptionEndDate != '' && sb.contractOptionEndDate != '12/31/9999' && Date.Parse(sb.contractOptionEndDate) < Date.today() )? True : False;
        specBenList.add(sb);
        system.debug('$$$Spec Benefits'+specBenList);
        return specBenList;
    }
    //logic for callout
    public ACETWSCalloutResult findMemberWS(String memberId, String firstname, String lastName, String dob,String state, String zip,String intType){
        boolean preferredFound = false;
        boolean dualCoverage = false;
        //US1871358 : Add Member Id
        Boolean isMemberIdSearch = true;
        List<String> mchIdList = new List<String>();
        
        
        ACETMemberDetail memberDetail;
        if(memberDetail == null){
            memberDetail = new ACETMemberDetail();  
        } 
        ACETWSCalloutResult searchResult = new ACETWSCalloutResult();
        List<ACETLGT_MemberSearchCoveragesResult> memberSearchResult;
        
        try{
            ServiceName = 'FindIndividualMembershipService';
            getEndpoint();
            getRequestBody(memberId,firstname,lastName,dob,state,zip);                          
            
            HttpResponse response;  
            response = Send(OAuthConfig);                       
            if(response!=null){
                system.debug(response.getStatusCode());
                searchResult.statusCode=response.getStatusCode();       
                
                if(response.getStatusCode() == 200){ 
                    system.debug(response.getBody());                            
                    if(response.getBody() != null){
                        //replace date with date2 as date is preserved keyword
                        String responseBody = response.getBody().replace('\"type\":', '\"type_Z\":');
                        system.debug('responseBody:::'+responseBody);
                     ACETLGT_FindIndMembershipsJSON2Apex ACTFMJSON2Apex = (ACETLGT_FindIndMembershipsJSON2Apex)JSON.deserialize(responseBody, ACETLGT_FindIndMembershipsJSON2Apex.class);

                       // ACETLGT_FindIndMembershipsJSON2Apex ACTFMJSON2Apex = (ACETLGT_FindIndMembershipsJSON2Apex)JSON.deserialize(resp.replace('\"type\":', '\"type_Z\":'), ACETLGT_FindIndMembershipsJSON2Apex.class);
                        memberSearchResult = new List<ACETLGT_MemberSearchCoveragesResult>();
                        List<ACETLGT_FindIndMembershipsJSON2Apex.Individuals> members = ACTFMJSON2Apex.findIndividualMembershipsResponse.individuals;
                        integer randomSRK = 123;
                        
                        //US1871358 : For SSN search - get the second MCH id and display
                        //For Member Id search - compare the MemberId with MCH id and only if matches - use that value
                        if(members!=null && members.size()>0){
                            //check whether it is ID search or Name/SSN search
                            if (memberId != null && memberId != ''){
                                if (memberId.length() != 11)
                                    isMemberIdSearch = false;
                                else
                                    isMemberIdSearch = true;
                                
                            }else
                                isMemberIdSearch = false;
                            
                            for(ACETLGT_FindIndMembershipsJSON2Apex.Individuals m : members){
                                String dateToCompare;
                                //Assigning searched Individual details
                                ACETLGT_MemberSearchCoveragesResult sr = new ACETLGT_MemberSearchCoveragesResult();
                                sr.AffiliationIndicator = false;	//US1840846
                                sr.intType = (!String.isBlank(intType))?intType:'';
                                sr.individualIdentifier = m.individualIdentifier;
                                sr.LastName = m.name != null && m.name.lastName != null ? m.name.lastName : '' ;
                                sr.FirstName = m.name != null && m.name.FirstName != null ? m.name.FirstName : '';
                                sr.MiddleInitial = m.name != null && m.name.middleName != null ? m.name.middleName : '';
                                sr.fullName = (sr.MiddleInitial != '')?(sr.FirstName+' '+sr.MiddleInitial+' '+sr.LastName):(sr.FirstName+' '+sr.LastName); 
                                    sr.Gender = (m.genderCode != null)?m.genderCode:'';
                                sr.DOB = !String.isEmpty(m.birthDate) ? formatDate(m.birthDate) : sr.DOB;
                                sr.SSNum = m.socialSecurityNumber;
                                sr.SSN = !String.isEmpty(m.socialSecurityNumber) ? 'xxx-xx-'+ m.socialSecurityNumber.substring(5,9) : '';
                                sr.Address='';
                                sr.Address= sr.Address+ ((m.address!= Null && m.address.addressline1!= Null && m.address.addressline1!= '')?m.address.addressline1:'');                    
                                sr.Address= sr.Address+ ((m.address!= Null && m.address.city!=Null && m.address.city!= '')?', '+m.address.city:'');
                                sr.Address= sr.Address+ ((m.address!= Null && m.address.statecode!=Null && m.address.statecode!= '')?', '+m.address.statecode:'');            
                                sr.Address= sr.Address+ ((m.address!= Null && m.address.postalCode!=Null && m.address.postalCode!= '')?', '+m.address.postalCode:'');
                                sr.Address= sr.Address.removeStart(',');  
                                
                                sr.City = m.address != null ? m.address.city : sr.city; 
                                sr.State = m.address != null ? m.address.statecode : sr.State;
                                sr.Zip = m.address != null ? m.address.postalCode : sr.Zip;
                                
                                sr.SourceCode = '';
                                system.debug('========OUTSIDE=====>>'+ sr);
                                if(m.memberships != null ){
                                    Integer coverageCount = 0;
                                    Integer InactiveCoverages = 0;
                                    Set<String> sourceCodeSet = new Set<String>();
                                    sr.CoverageLines = new List<ACETLGT_MemberSearchCoveragesResult.CoverageLine>();   
                                    sr.MedicalCoverageLines = new List<ACETLGT_MemberSearchCoveragesResult.CoverageLine>();   
                                    sr.PharmacyCoverageLines = new List<ACETLGT_MemberSearchCoveragesResult.CoverageLine>();   
                                    List<ACETLGT_MemberSearchCoveragesResult.CoverageLine> covLines = new List<ACETLGT_MemberSearchCoveragesResult.CoverageLine>();
                                    sr.specialtyBenefits = new List<ACETLGT_MemberSearchCoveragesResult.SpecialtyBenefits>();   
                                    
                                    //US1871358 : Start : Retrieve MembershipId logic
                                    for (ACETLGT_FindIndMembershipsJSON2Apex.memberships membership: m.memberships) {
                                        
                                        if(membership.sourceSysCode != null && membership.sourceSysCode == 'CR'){ 
                                            if(membership != null && membership.Identifiers != null){
                                                for (ACETLGT_FindIndMembershipsJSON2Apex.Identifiers identifiers: membership.Identifiers) {                                            
                                                    if (identifiers.type_Z == 'MCH') {  
                                                        //For SSN search
                                                        mchIdList.add(identifiers.id);
                                                        //For MemberId search
                                                        if (memberId != '' && memberId != null && isMemberIdSearch){
                                                            //if (memberId.substring(0,9) == identifiers.id.substring(0,9)){
                                                            if (memberId == identifiers.id){
                                                                sr.selectedMemberId = identifiers.id;
                                                            }
                                                        }
                                                        
                                                    } 
                                                } 
                                            }
                                        }                                    
                                    }
                                    
                                    if (!mchIdList.isEmpty() && (sr.selectedMemberId == null || sr.selectedMemberId == '')){  
                                        string tempMemId = (!String.isBlank(memberId))?memberId.substring(0,8):'';
                                        for(string mchid: mchIdList){
                                            string tempMCHId = mchid.substring(0,8);
                                            if(tempMemId == tempMCHId){
                                                sr.selectedMemberId = mchid ;
                                            }
                                        }
                                        if(sr.selectedMemberId == null || sr.selectedMemberId == ''){
                                            sr.selectedMemberId = mchIdList.get(mchIdList.size()-1);
                                        }
                                    }   
                                    
                                    system.debug('sr.selectedMemberId::'+sr.selectedMemberId);
                                    //US1871358 : End
                                    
                                    //Membership sections starts here
                                    for (ACETLGT_FindIndMembershipsJSON2Apex.memberships membership: m.memberships) {
                                        system.debug('========Membership111=====>>'+ membership);
                                        //Collect all SRK's in a keychain
                                        if(membership.sourceSysCode != null ){    
                                            if(membership.enrolleeSystemSpecificIdentifiers != null){
                                                for (ACETLGT_FindIndMembershipsJSON2Apex.Identifiers memIdentifiers: membership.enrolleeSystemSpecificIdentifiers) {
                                                    
                                                    if (memIdentifiers.type_Z == 'enrolleeSurrogateKey') {
                                                        sr.SurrogateKeys.add(memIdentifiers.id);
                                                        //sr.EnrolleeSurrogateKey = memIdentifiers.id;
                                                        //system.debug('---------sr.EnrolleeSurrogateKey----->'+sr.EnrolleeSurrogateKey);
                                                    }
                                                }
                                            }
                                        }
                                        if(membership.sourceSysCode != null && membership.sourceSysCode == 'CR'){    
                                            if(membership.enrolleeSystemSpecificIdentifiers != null){
                                                for (ACETLGT_FindIndMembershipsJSON2Apex.Identifiers memIdentifiers: membership.enrolleeSystemSpecificIdentifiers) {
                                                    
                                                    if (memIdentifiers.type_Z == 'enrolleeSurrogateKey') {
                                                        //sr.SurrogateKeys.add(memIdentifiers.id);
                                                        sr.EnrolleeSurrogateKey = memIdentifiers.id;
                                                        system.debug('---------sr.EnrolleeSurrogateKey----->'+sr.EnrolleeSurrogateKey);
                                                    }
                                                }
                                            }
                                            if(membership.identifiers != null){
                                                
                                                for (ACETLGT_FindIndMembershipsJSON2Apex.Identifiers identifiers: membership.identifiers) {
                                                    
                                                    if (identifiers.type_Z == 'MCH') {
                                                        sr.IDs.add(identifiers.id);
                                                        //sr.ID = identifiers.id;
                                                        if(identifiers.id == sr.selectedMemberId)
                                                            sr.ID = identifiers.id; 
                                                    }   
                                                    
                                                    if (identifiers.type_Z == 'SCR') {
                                                        sr.IDs.add(identifiers.id);
                                                        if(String.isNotBlank(memberId) &&  !(memberId.trim()).equalsIgnoreCase(m.socialSecurityNumber.trim()) ){
                                                            System.debug('It came here@@@ for SCR');
                                                            if(String.isNotBlank(Identifiers.id) && (memberId.trim().substring(0,memberId.trim().length()-2)).equalsIgnoreCase((Identifiers.id.trim()).substring(0,Identifiers.id.trim().length()-2))){
                                                                sr.SCRID = Identifiers.id;  
                                                            } 
                                                        }
                                                        else{ 
                                                            sr.SCRID = Identifiers.id;
                                                        }
                                                    }                                  
                                                }
                                            }
                                        }
                                        
                                        if(membership.enrolleeSystemSpecificIdentifiers!=null && !membership.enrolleeSystemSpecificIdentifiers.isEmpty()){
                                            for(ACETLGT_FindIndMembershipsJSON2Apex.Identifiers eachIdentifier:membership.enrolleeSystemSpecificIdentifiers){
                                                if(eachIdentifier.type_Z =='enrolleeIndividualIdentifier'){
                                                    sr.EID = eachIdentifier.id;
                                                    break;
                                                }
                                            }
                                        }
                                        
                                        boolean isSelf=false;
                                        boolean isEnrollee=false;
                                        //Specialty Benefits - Standalone Dental and Vision plan collection
                                        if(membership != null && membership.coverages != null){
                                            
                                            membership.coverages.sort();
                                            for(ACETLGT_FindIndMembershipsJSON2Apex.Coverages c : membership.coverages){
                                            	if(membership.sourceSysCode != null && membership.sourceSysCode == 'CR' && (c.coverageType == 'V' && c.contractOptionTypeCode == 'VS') || (c.coverageType == 'D' && c.contractOptionTypeCode == 'DN')){
                                                    List<ACETLGT_MemberSearchCoveragesResult.SpecialtyBenefits> sb = new List<ACETLGT_MemberSearchCoveragesResult.SpecialtyBenefits>();
                                                    sb = getSpecialtyBenefits(c);
                                                    sr.specialtyBenefits.addAll(sb);
                                                }
                                            }
                                            system.debug('!!!specialtyBenefits final'+sr.specialtyBenefits);
                                        }
                                        if(membership != null && membership.coverages != null){
                                            
                                            membership.coverages.sort();
                                            for(ACETLGT_FindIndMembershipsJSON2Apex.Coverages c : membership.coverages){
                                                ACETLGT_MemberSearchCoveragesResult.CoverageLine cl = new ACETLGT_MemberSearchCoveragesResult.CoverageLine();
                                                
                                                cl.riderOnlyIndicator = (c.benefit != null && c.benefit.riderOnlyIndicator!= null)?c.benefit.riderOnlyIndicator:'';
                                                cl.CoverageTypeCode = (c.coverageType!= null)?c.coverageType:'';
                                                cl.bookOfBusinessTypeCode = (c.benefit!=null && c.benefit.bookOfBusinessTypeCode!=null)?c.benefit.bookOfBusinessTypeCode:'';
                                                
                                                if(cl.riderOnlyIndicator == 'N' || cl.riderOnlyIndicator == 'Y' && cl.CoverageTypeCode == 'RX'){
                                                    cl.pharmacyIndicator = 'No';
                                                    cl.isEnrollee =false;
                                                    cl.CoverageType = (c.coverageTypeDescription!=null)?c.coverageTypeDescription:'';
                                                    cl.CoverageTypeCode = (c.coverageType!= null)?c.coverageType:'';
                                                    cl.CoverageLevel = (c.coverageLevelCode!= null)?c.coverageLevelCode:'';
                                                    cl.EffectiveDate = String.isNotBlank(c.membershipEffectiveDate)?formatDate(c.membershipEffectiveDate):'';
                                                    cl.EndDate = String.isNotBlank(c.membershipExpirationDate)?formatDate(c.membershipExpirationDate):''; 
                                                    cl.PolicyNumber = (c.legacyAttributes!=null && c.legacyAttributes.policyNumber != null)?c.legacyAttributes.policyNumber:'';
                                                    cl.GroupName = (c.GroupName!= null)?c.GroupName:'';
                                                    cl.GroupNumber = (c.groupNumber!= null)?c.groupNumber:'';
                                                    
                                                    cl.Product = (c.product!=null && c.product.productName!= null)?c.product.productName:'';
                                                    cl.ProductType = (c.product!=null && c.product.productType!=null)?c.product.productType:'';
                                                    cl.relationShipCode=(c.relationshipCode!= null)?c.relationshipCode:'';
                                                    //cl.memberId = sr.ID;     //Abhinav
                                                    if(c.relationshipCode=='18'){
                                                        isSelf=True;
                                                    }
                                                    
                                                    if(membership.identifiers!=null){
                                                        for(ACETLGT_FindIndMembershipsJSON2Apex.Identifiers identifierDtl : membership.identifiers){
                                                            if(identifierDtl.type_Z == 'MCH'){
                                                                cl.memberId = identifierDtl.id; 
                                                                if(identifierDtl.id == sr.ID || identifierDtl.id == memberId){  //Check Condition  Abhinav modified
                                                                    cl.isEnrollee=True;
                                                                }   
                                                                
                                                            }  
                                                        }
                                                    } // End of identifiers
                                                    
                                                    Date todaydate = (Date) date.today();
                                                    Date EffectiveDate = String.isNotBlank(c.membershipEffectiveDate)?(Date) date.parse(formatDate(c.membershipEffectiveDate)):null;
                                                    if(EffectiveDate!=null){
                                                        if(todaydate <= EffectiveDate)
                                                            cl.DaysGap =  todaydate.daysBetween(EffectiveDate ) ;
                                                        else
                                                            cl.DaysGap =  EffectiveDate.daysBetween(todaydate) ;
                                                    }
                                                    
                                                    cl.SourceCode = (membership.sourceSysCode != null)?membership.sourceSysCode:'';
                                                    cl.isActive = isActiveCoverage(cl.EffectiveDate, cl.EndDate);
                                                    cl.isFuture = (cl.EffectiveDate != null && Date.Parse(cl.EffectiveDate) > Date.today() )? True : False;
                                                    cl.isTermed = (cl.EndDate != null && cl.EndDate != '' && cl.EndDate!='12/31/9999' && Date.Parse(cl.EndDate) < Date.today() )? True : False;
                                                    /*cl.accumAsOfDate = (cl.isTermed?cl.EndDate:(cl.isFuture?cl.EffectiveDate:String.ValueOf(todaydate)));
*/
                                                    cl.benefitPlanId = (c.benefit != null && c.benefit.benefitPlanId != null)?c.benefit.benefitPlanId:'';
                                                    
                                                    //FIM Enhancement - Abhinav Balla
                                                    cl.benefitPlanName= (c.benefit != null && c.benefit.benefitPlanName!= null)?c.benefit.benefitPlanName:'';
                                                    cl.planOptionID= (c.benefit != null && c.benefit.planOptionID!= null)?c.benefit.planOptionID:'';
                                                    cl.riderOnlyIndicator = (c.benefit != null && c.benefit.riderOnlyIndicator!= null)?c.benefit.riderOnlyIndicator:'';
                                                    system.debug('$$$$$'+cl.planOptionID+cl.riderOnlyIndicator);
                                                    list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions> acpvlist = new list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions>();
                                                    /*Collect all the active customer purchase versions*/
													cl.activeCPs = new list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions>();																				
                                                    if(c.benefit!= null && c.benefit.customerPurchase != null){
                                                        for(ACETLGT_FindIndMembershipsJSON2Apex.CustomerPurchase cp : c.benefit.customerPurchase){
                                                            if(cp.customerPurchaseVersions != null){
                                                                system.debug('$$$$$ Inside CP');
                                                                
                                                                for(ACETLGT_FindIndMembershipsJSON2Apex.CustomerPurchaseVersions cpv : cp.customerPurchaseVersions ){
                                                                    if(cpv.customerPurchaseStatusDescription == 'Active'){
                                                                        ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions acpv = new ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions();
                                                                        system.debug('$$$$$ InsideActive CPV');
                                                                        
                                                                        acpv.contractOptionStartDate = String.isNotBlank(cpv.contractOptionStartDate)?formatDate(cpv.contractOptionStartDate):'' ;
                                                                        acpv.contractOptionEndDate = String.isNotBlank(cpv.contractOptionEndDate)?formatDate(cpv.contractOptionEndDate):'';
                                                                        acpv.customerPurchaseId = String.isNotBlank(cp.customerPurchaseId)?cp.customerPurchaseId:'' ;
                                                                        
                                                                        acpvlist.add(acpv);
																		cl.activeCPs.add(acpv);
                                                                    }
                                                                }
                                                            }
                                                            
                                                        }
                                                        system.debug('$$$Active CP Versions'+acpvlist);
                                                    }
                                                    
                                                    system.debug('$$$CP Versions'+acpvlist.size());
                                                    /*Find the latest contract option when there are multiple customer purchases coming back*/
                                                    LatestCODates lcd = new LatestCODates();
                                                    lcd = getLatestCODates(acpvlist,cl.EndDate);
                                                    
                                                    cl.LatestCOStartDate = lcd.LatestCOStartDate;
                                                    cl.LatestCOEndDate =  lcd.LatestCOEndDate;
                                                    cl.customerPurchaseId = lcd.customerPurchaseId;

                                                    /*To find the Benefit timeline based on Member and contract option dates*/
                                                    cl.BenEffectiveDate = getBenefitEffectiveDate(cl.EffectiveDate,cl.LatestCOStartDate);
                                                    cl.BenEndDate = getBenefitEndDate(cl.EndDate,cl.LatestCOEndDate);
                                                    
                                                    system.debug('$$$Check '+cl.BenEffectiveDate+'//'+cl.BenEndDate +'///'+cl.EffectiveDate+'??'+cl.LatestCOStartDate+'///'+cl.EndDate+'??'+cl.LatestCOEndDate);
                                                    if(String.isNotBlank(cl.BenEffectiveDate) && String.isNotBlank(cl.BenEndDate)){
                                                        cl.accumAsOfDate = (cl.isTermed?cl.BenEndDate:(cl.isFuture?cl.BenEffectiveDate:String.ValueOf(Date.today())));
                                                    }
                                                    system.debug('$$$Check status of benefit'+cl.isActive+'//'+cl.isFuture+'//'+cl.isTermed);
                                                    cl.isPreferred = False;  
                                                    
                                                    string coverageBenefitPlanId;
                                                    coverageBenefitPlanId = (cl.benefitPlanId != null && cl.benefitPlanId != '' )?(cl.benefitPlanId.length()>=2?cl.benefitPlanId.toLowerCase().subString(0,2):''):'';
                                                    system.debug('------------>'+membership.sourceSysCode.equalsIgnoreCase('CR')+'===========>'+ c.coverageTypeDescription.equalsIgnoreCase('MEDICAL')+'------->'+cl.isActive+'--------->'+ coverageBenefitPlanId );
                                                    //Check if Dual coverage exists 
                                                    if(membership.sourceSysCode.equalsIgnoreCase('CR') && c.coverageTypeDescription.equalsIgnoreCase('MEDICAL') && cl.isActive && (coverageBenefitPlanId != 'mr') ){ 
                                                        
                                                        coverageCount += 1;
                                                    }else if(membership.sourceSysCode.equalsIgnoreCase('CR') && c.coverageTypeDescription.equalsIgnoreCase('MEDICAL') && !cl.isActive && (coverageBenefitPlanId != 'mr') ){ 
                                                        
                                                        InactiveCoverages += 1;
                                                    }
                                                    
                                                }
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                    Boolean prefferedCovfound = false; 
                                    for (ACETLGT_FindIndMembershipsJSON2Apex.memberships membership: m.memberships) {
                                        system.debug('========Membership222=====>>'+ membership);
                                        if(membership.sourceSysCode != null){
                                            sourceCodeSet.add(membership.sourceSysCode);
                                            if(sr.SourceCode == '')
                                                sr.SourceCode = membership.sourceSysCode; 
                                            else
                                                sr.sourceCode = (sr.SourceCode.contains(membership.sourceSysCode)?sr.sourceCode:(sr.SourceCode  +','+ membership.sourceSysCode));
                                            
                                            system.debug('>>>'+sr.sourceCode);
                                        }
                                        
                                        //Collect all SRK's in a keychain
                                        if(membership.sourceSysCode != null ){    
                                            if(membership.enrolleeSystemSpecificIdentifiers != null){
                                                for (ACETLGT_FindIndMembershipsJSON2Apex.Identifiers memIdentifiers: membership.enrolleeSystemSpecificIdentifiers) {
                                                    
                                                    if (memIdentifiers.type_Z == 'enrolleeSurrogateKey') {
                                                        sr.SurrogateKeys.add(memIdentifiers.id);
                                                        //sr.EnrolleeSurrogateKey = memIdentifiers.id;
                                                        //system.debug('---------sr.EnrolleeSurrogateKey----->'+sr.EnrolleeSurrogateKey);
                                                    }
                                                }
                                            }
                                        }
                                        if(membership.sourceSysCode != null && membership.sourceSysCode == 'CR'){    
                                            if(membership.enrolleeSystemSpecificIdentifiers != null){
                                                for (ACETLGT_FindIndMembershipsJSON2Apex.Identifiers memIdentifiers: membership.enrolleeSystemSpecificIdentifiers) {
                                                    
                                                    if (memIdentifiers.type_Z == 'enrolleeSurrogateKey') {
                                                        //sr.SurrogateKeys.add(memIdentifiers.id);   
                                                        sr.EnrolleeSurrogateKey = memIdentifiers.id;
                                                        //system.debug('---------sr.EnrolleeSurrogateKey----->'+sr.EnrolleeSurrogateKey);
                                                    }
                                                }
                                            }
                                            if(membership.identifiers != null){
                                                for (ACETLGT_FindIndMembershipsJSON2Apex.Identifiers identifiers: membership.identifiers) {
                                                    
                                                    if (identifiers.type_Z == 'MCH') {
                                                        sr.IDs.add(identifiers.id);
                                                        if(identifiers.id == sr.selectedMemberId)
                                                            sr.ID = identifiers.id;  
                                                    }   
                                                    
                                                    if (identifiers.type_Z == 'SCR') {
                                                        sr.IDs.add(identifiers.id);
                                                        if(String.isNotBlank(memberId) &&  !(memberId.trim()).equalsIgnoreCase(m.socialSecurityNumber.trim()) ){
                                                            System.debug('It came here@@@ for SCR');
                                                            if(String.isNotBlank(Identifiers.id) && (memberId.trim().substring(0,memberId.trim().length()-2)).equalsIgnoreCase((Identifiers.id.trim()).substring(0,Identifiers.id.trim().length()-2))){
                                                                sr.SCRID = Identifiers.id;  
                                                            } 
                                                        }
                                                        else{ 
                                                            sr.SCRID = Identifiers.id;
                                                        }
                                                    }                                  
                                                }
                                            }
                                            
                                            
                                        }
                                        
                                        if(membership.enrolleeSystemSpecificIdentifiers!=null && !membership.enrolleeSystemSpecificIdentifiers.isEmpty()){
                                            for(ACETLGT_FindIndMembershipsJSON2Apex.Identifiers eachIdentifier:membership.enrolleeSystemSpecificIdentifiers){
                                                if(eachIdentifier.type_Z =='enrolleeIndividualIdentifier'){
                                                    sr.EID = eachIdentifier.id;
                                                    break;
                                                }
                                            }
                                        }
                                        
                                        boolean isSelf=false;
                                        boolean isEnrollee=false;
                                        
                                        // Choose for preferred coverage
                                        // start if - coverages
                                        if(membership != null && membership.coverages != null){
                                            //if only inactive coverages found and non dual coverage scenario
                                            if(coverageCount < 1 && InactiveCoverages < 2){
                                                membership.coverages.sort();
                                                //if(prefferedCovfound == false ){
                                                for(ACETLGT_FindIndMembershipsJSON2Apex.Coverages c : membership.coverages){
                                                    ACETLGT_MemberSearchCoveragesResult.CoverageLine cl = new ACETLGT_MemberSearchCoveragesResult.CoverageLine();
                                                    cl.riderOnlyIndicator = (c.benefit != null && c.benefit.riderOnlyIndicator!= null)?c.benefit.riderOnlyIndicator:'';
                                                    cl.CoverageTypeCode = (c.coverageType!= null)?c.coverageType:'';
                                                    cl.bookOfBusinessTypeCode = (c.benefit!=null && c.benefit.bookOfBusinessTypeCode!=null)?c.benefit.bookOfBusinessTypeCode:'';
                                                    
                                                    if(cl.riderOnlyIndicator == 'N' || cl.riderOnlyIndicator == 'Y' && cl.CoverageTypeCode == 'RX'){
                                                        cl.pharmacyIndicator = 'No';
                                                        cl.isEnrollee =false;
                                                        cl.CoverageType = (c.coverageTypeDescription!=null)?c.coverageTypeDescription:'';
                                                        cl.CoverageTypeCode = (c.coverageType!= null)?c.coverageType:'';
                                                        cl.CoverageLevel = (c.coverageLevelCode!= null)?c.coverageLevelCode:'';
                                                        cl.EffectiveDate = String.isNotBlank(c.membershipEffectiveDate)?formatDate(c.membershipEffectiveDate):'';
                                                        cl.EndDate = String.isNotBlank(c.membershipExpirationDate)?formatDate(c.membershipExpirationDate):''; 
                                                        cl.PolicyNumber = (c.legacyAttributes!=null && c.legacyAttributes.policyNumber != null)?c.legacyAttributes.policyNumber:'';
                                                        cl.GroupName = (c.GroupName!= null)?c.GroupName:'';
                                                        cl.GroupNumber = (c.groupNumber!= null)?c.groupNumber:'';
                                                        cl.Product = (c.product!=null && c.product.productName!= null)?c.product.productName:'';
                                                        cl.ProductType = (c.product!=null && c.product.productType!=null)?c.product.productType:'';
                                                        cl.relationShipCode=(c.relationshipCode!= null)?c.relationshipCode:'';
                                                        
                                                        if(c.relationshipCode=='18'){
                                                            isSelf=True;
                                                        }
                                                        
                                                        if(membership.identifiers!=null){
                                                            for(ACETLGT_FindIndMembershipsJSON2Apex.Identifiers identifierDtl : membership.identifiers){
                                                                if(identifierDtl.type_Z == 'MCH'){
                                                                    cl.memberId = identifierDtl.id;
                                                                    if(identifierDtl.id == sr.selectedMemberId){  //Check Condition
                                                                        cl.isEnrollee=True;
                                                                    }   
                                                                }                                                        }
                                                        } // End of identifiers
                                                        
                                                        Date todaydate = (Date) date.today();
                                                        Date EffectiveDate = String.isNotBlank(c.membershipEffectiveDate)?(Date) date.parse(formatDate(c.membershipEffectiveDate)):null;
                                                        if(EffectiveDate!=null){
                                                            if(todaydate <= EffectiveDate)
                                                                cl.DaysGap =  todaydate.daysBetween(EffectiveDate ) ;
                                                            else
                                                                cl.DaysGap =  EffectiveDate.daysBetween(todaydate) ;
                                                        }
                                                        cl.SourceCode = (membership.sourceSysCode != null)?membership.sourceSysCode:'';
                                                        cl.isActive = isActiveCoverage(cl.EffectiveDate, cl.EndDate);
                                                        cl.isFuture = Date.Parse(cl.EffectiveDate) > Date.today() ? True : False;
                                                        cl.isTermed = (cl.EndDate != null && cl.EndDate != '' && cl.EndDate!='12/31/9999' && Date.Parse(cl.EndDate) < Date.today() )? True : False;
                                                        cl.accumAsOfDate = (cl.isTermed?cl.EndDate:(cl.isFuture?cl.EffectiveDate:String.ValueOf(todaydate)));
                                                        cl.benefitPlanId = (c.benefit != null && c.benefit.benefitPlanId != null)?c.benefit.benefitPlanId:'';
                                                        
                                                        //FIM Enhancement - Abhinav Balla
                                                        cl.benefitPlanName= (c.benefit != null && c.benefit.benefitPlanName!= null)?c.benefit.benefitPlanName:'';
                                                        cl.planOptionID= (c.benefit != null && c.benefit.planOptionID!= null)?c.benefit.planOptionID:'';
                                                        cl.riderOnlyIndicator = (c.benefit != null && c.benefit.riderOnlyIndicator!= null)?c.benefit.riderOnlyIndicator:'';
                                                        system.debug('$$$$$'+cl.planOptionID+cl.riderOnlyIndicator);
                                                        list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions> acpvlist = new list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions>();
                                                        /*Collect all the active customer purchase versions*/
														 cl.activeCPs = new list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions>();																				
                                                        if(c.benefit!= null && c.benefit.customerPurchase != null){
                                                            for(ACETLGT_FindIndMembershipsJSON2Apex.CustomerPurchase cp : c.benefit.customerPurchase){
                                                                if(cp.customerPurchaseVersions != null){
                                                                    system.debug('$$$$$ Inside CP');
                                                                    
                                                                    for(ACETLGT_FindIndMembershipsJSON2Apex.CustomerPurchaseVersions cpv : cp.customerPurchaseVersions ){
                                                                        if(cpv.customerPurchaseStatusDescription == 'Active'){
                                                                            ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions acpv = new ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions();
                                                                            system.debug('$$$$$ InsideActive CPV');
                                                                            
                                                                            acpv.contractOptionStartDate = String.isNotBlank(cpv.contractOptionStartDate)?formatDate(cpv.contractOptionStartDate):'' ;
                                                                            acpv.contractOptionEndDate = String.isNotBlank(cpv.contractOptionEndDate)?formatDate(cpv.contractOptionEndDate):'';
                                                                            acpv.customerPurchaseId = String.isNotBlank(cp.customerPurchaseId)?cp.customerPurchaseId:'' ;
                                                                            
                                                                            acpvlist.add(acpv);
																			cl.activeCPs.add(acpv);
                                                                        }
                                                                    }
                                                                }
                                                                
                                                            }
                                                            system.debug('$$$Active CP Versions'+acpvlist);
                                                        }
                                                        
                                                        system.debug('$$$CP Versions'+acpvlist.size());
                                                        /*Find the latest contract option when there are multiple customer purchases coming back*/
                                                        LatestCODates lcd = new LatestCODates();
                                                        lcd = getLatestCODates(acpvlist,cl.EndDate);
                                                        
                                                        cl.LatestCOStartDate = lcd.LatestCOStartDate;
                                                        cl.LatestCOEndDate =  lcd.LatestCOEndDate;
                                                        cl.customerPurchaseId = lcd.customerPurchaseId;
 
                                                        /*To find the Benefit timeline based on Member and contract option dates*/
                                                        cl.BenEffectiveDate = getBenefitEffectiveDate(cl.EffectiveDate,cl.LatestCOStartDate);
                                                        cl.BenEndDate = getBenefitEndDate(cl.EndDate,cl.LatestCOEndDate);
                                                        
                                                        
                                                        system.debug('$$$Check 2'+cl.BenEffectiveDate+'//'+cl.BenEndDate +'///'+cl.EffectiveDate+'??'+cl.LatestCOStartDate+'///'+cl.EndDate+'??'+cl.LatestCOEndDate);
                                                        
                                                        cl.isPreferred = False;                                 
                                                        string coverageBenefitPlanId;
                                                        coverageBenefitPlanId = (cl.benefitPlanId != null && cl.benefitPlanId != '' )?(cl.benefitPlanId.length()>=2?cl.benefitPlanId.toLowerCase().subString(0,2):''):'';
                                                        system.debug('------------>'+membership.sourceSysCode.equalsIgnoreCase('CR')+'===========>'+ c.coverageTypeDescription.equalsIgnoreCase('MEDICAL')+'------->'+cl.isActive+'--------->'+ coverageBenefitPlanId );
                                                        //Preferred Coverage 
                                                        if(membership.sourceSysCode.equalsIgnoreCase('CR') && c.coverageTypeDescription.equalsIgnoreCase('MEDICAL') && (coverageBenefitPlanId != 'mr') && cl.isEnrollee ){ 
                                                            cl.isPreferred= isPreferredCoverage(membership.sourceSysCode, c.coverageTypeDescription, true, c.membershipEffectiveDate, dateToCompare,cl.benefitPlanId,cl.GroupNumber  );                                                           
                                                            if( dateToCompare == null || cl.isPreferred){
                                                                dateToCompare = c.membershipEffectiveDate; //dateToCompare == null ||
                                                            }
                                                            //InactiveCoverages += 1;
                                                            if(cl.isPreferred){
                                                                sr.groupNumberValue = cl.GroupNumber;
                                                                prefferedCovfound = true;
                                                            }
                                                            
                                                        }
                                                        
                                                        if(c.subscriberSystemSpecificIdentifiers != null){
                                                            
                                                            if(!c.subscriberSystemSpecificIdentifiers.isEmpty() ){ 
                                                                for(ACETLGT_FindIndMembershipsJSON2Apex.Identifiers sssi : c.subscriberSystemSpecificIdentifiers){
                                                                    if(sssi.type_z == 'subscriberSurrogateKey'){
                                                                        cl.SurrogateKey = sssi.id; 
                                                                        system.debug('---------cl.SurrogateKey----->'+cl.SurrogateKey);
                                                                        cl.EnrolleeSurrogateKey = sr.EnrolleeSurrogateKey;
                                                                        system.debug('---------cl.EnrolleeSurrogateKey----->'+cl.EnrolleeSurrogateKey);
                                                                    }
                                                                    
                                                                }
                                                            }
                                                        } 
                                                        if(cl.CoverageTypeCode == 'RX')
                                                            sr.PharmacyCoverageLines.add(cl);
                                                        else if(cl.CoverageTypeCode == 'M')
                                                            sr.MedicalCoverageLines.add(cl);
                                                        system.debug('----cl---->>'+cl.isPreferred);
                                                        
                                                    }  // Rider If 
                                                }
                                                //}
                                                
                                            }
                                            //if only inactive coverages found and dual coverage scenario
                                            else if(coverageCount < 1 && InactiveCoverages > 1){
                                                
                                                system.debug('=======>>>>'+membership.coverages);
                                                membership.coverages.sort();
                                                system.debug('=======>>>>'+membership.coverages);
                                                for(ACETLGT_FindIndMembershipsJSON2Apex.Coverages c : membership.coverages){
                                                    ACETLGT_MemberSearchCoveragesResult.CoverageLine cl = new ACETLGT_MemberSearchCoveragesResult.CoverageLine();
                                                    cl.riderOnlyIndicator = (c.benefit != null && c.benefit.riderOnlyIndicator!= null)?c.benefit.riderOnlyIndicator:'';
                                                    cl.CoverageTypeCode = (c.coverageType!= null)?c.coverageType:'';
                                                    cl.bookOfBusinessTypeCode = (c.benefit!=null && c.benefit.bookOfBusinessTypeCode!=null)?c.benefit.bookOfBusinessTypeCode:'';
                                                    if(cl.riderOnlyIndicator == 'N' || cl.riderOnlyIndicator == 'Y' && cl.CoverageTypeCode == 'RX'){
                                                        cl.pharmacyIndicator = 'No';
                                                        cl.isEnrollee =false;
                                                        cl.CoverageType = (c.coverageTypeDescription!=null)?c.coverageTypeDescription:'';
                                                        cl.CoverageTypeCode = (c.coverageType!= null)?c.coverageType:'';
                                                        cl.CoverageLevel = (c.coverageLevelCode!= null)?c.coverageLevelCode:'';
                                                        cl.EffectiveDate = String.isNotBlank(c.membershipEffectiveDate)?formatDate(c.membershipEffectiveDate):'';
                                                        cl.EndDate = String.isNotBlank(c.membershipExpirationDate)?formatDate(c.membershipExpirationDate):''; 
                                                        cl.PolicyNumber = (c.legacyAttributes!=null && c.legacyAttributes.policyNumber != null)?c.legacyAttributes.policyNumber:'';
                                                        cl.GroupName = (c.GroupName!= null)?c.GroupName:'';
                                                        cl.GroupNumber = (c.groupNumber!= null)?c.groupNumber:'';
                                                        cl.Product = (c.product!=null && c.product.productName!= null)?c.product.productName:'';
                                                        cl.ProductType = (c.product!=null && c.product.productType!=null)?c.product.productType:'';
                                                        cl.relationShipCode=(c.relationshipCode!= null)?c.relationshipCode:'';
                                                        if(c.relationshipCode=='18'){
                                                            isSelf=True;
                                                        }
                                                        
                                                        if(membership.identifiers!=null){
                                                            for(ACETLGT_FindIndMembershipsJSON2Apex.Identifiers identifierDtl : membership.identifiers){
                                                                if(identifierDtl.type_Z == 'MCH'){
                                                                    cl.memberId = identifierDtl.id;
                                                                    if(identifierDtl.id == sr.selectedMemberId ){  //Check Condition
                                                                        cl.isEnrollee=True;
                                                                    }   
                                                                }
                                                                
                                                            }
                                                        } // End of identifiers
                                                        
                                                        Date todaydate = (Date) date.today();
                                                        Date EffectiveDate = String.isNotBlank(c.membershipEffectiveDate)?(Date) date.parse(formatDate(c.membershipEffectiveDate)):null;
                                                        if(EffectiveDate!=null){
                                                            if(todaydate <= EffectiveDate)
                                                                cl.DaysGap =  todaydate.daysBetween(EffectiveDate ) ;
                                                            else
                                                                cl.DaysGap =  EffectiveDate.daysBetween(todaydate) ;
                                                        }
                                                        cl.SourceCode = (membership.sourceSysCode != null)?membership.sourceSysCode:'';
                                                        cl.isActive = isActiveCoverage(cl.EffectiveDate, cl.EndDate);
                                                        cl.isFuture = Date.Parse(cl.EffectiveDate) > Date.today() ? True : False;
                                                        cl.isTermed = (cl.EndDate != null && cl.EndDate != '' && cl.EndDate!='12/31/9999' && Date.Parse(cl.EndDate) < Date.today() )? True : False;
                                                        cl.accumAsOfDate = (cl.isTermed?cl.EndDate:(cl.isFuture?cl.EffectiveDate:String.ValueOf(todaydate)));
                                                        cl.benefitPlanId = (c.benefit != null && c.benefit.benefitPlanId != null)?c.benefit.benefitPlanId:'';
                                                        
                                                        //FIM Enhancement - Abhinav Balla
                                                        cl.benefitPlanName= (c.benefit != null && c.benefit.benefitPlanName!= null)?c.benefit.benefitPlanName:'';
                                                        cl.planOptionID= (c.benefit != null && c.benefit.planOptionID!= null)?c.benefit.planOptionID:'';
                                                        cl.riderOnlyIndicator = (c.benefit != null && c.benefit.riderOnlyIndicator!= null)?c.benefit.riderOnlyIndicator:'';
                                                        system.debug('$$$$$'+cl.planOptionID+cl.riderOnlyIndicator);
                                                        list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions> acpvlist = new list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions>();
                                                        /*Collect all the active customer purchase versions*/
														cl.activeCPs = new list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions>();																				
                                                        if(c.benefit!= null && c.benefit.customerPurchase != null){
                                                            for(ACETLGT_FindIndMembershipsJSON2Apex.CustomerPurchase cp : c.benefit.customerPurchase){
                                                                if(cp.customerPurchaseVersions != null){
                                                                    system.debug('$$$$$ Inside CP');
                                                                    
                                                                    for(ACETLGT_FindIndMembershipsJSON2Apex.CustomerPurchaseVersions cpv : cp.customerPurchaseVersions ){
                                                                        if(cpv.customerPurchaseStatusDescription == 'Active'){
                                                                            ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions acpv = new ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions();
                                                                            system.debug('$$$$$ InsideActive CPV');
                                                                            
                                                                            acpv.contractOptionStartDate = String.isNotBlank(cpv.contractOptionStartDate)?formatDate(cpv.contractOptionStartDate):'' ;
                                                                            acpv.contractOptionEndDate = String.isNotBlank(cpv.contractOptionEndDate)?formatDate(cpv.contractOptionEndDate):'';
                                                                            acpv.customerPurchaseId = String.isNotBlank(cp.customerPurchaseId)?cp.customerPurchaseId:'' ;
                                                                            
                                                                            acpvlist.add(acpv);
																			cl.activeCPs.add(acpv);
                                                                        }
                                                                    }
                                                                }
                                                                
                                                            }
                                                            system.debug('$$$Active CP Versions'+acpvlist);
                                                        }
                                                        
                                                        system.debug('$$$CP Versions'+acpvlist.size());
                                                        /*Find the latest contract option when there are multiple customer purchases coming back*/
                                                        LatestCODates lcd = new LatestCODates();
                                                        lcd = getLatestCODates(acpvlist,cl.EndDate);
                                                        system.debug('ldc----->'+lcd);
                                                        cl.LatestCOStartDate = lcd.LatestCOStartDate;
                                                        cl.LatestCOEndDate =  lcd.LatestCOEndDate;
                                                        cl.customerPurchaseId = lcd.customerPurchaseId;
                                                        /*To find the Benefit timeline based on Member and contract option dates*/
                                                        cl.BenEffectiveDate = getBenefitEffectiveDate(cl.EffectiveDate,cl.LatestCOStartDate);
                                                        cl.BenEndDate = getBenefitEndDate(cl.EndDate,cl.LatestCOEndDate);
                                                        
                                                        
                                                        system.debug('$$$Check 3'+cl.BenEffectiveDate+'//'+cl.BenEndDate +'///'+cl.EffectiveDate+'??'+cl.LatestCOStartDate+'///'+cl.EndDate+'??'+cl.LatestCOEndDate);
                                                        
                                                        cl.isPreferred = False;                                 
                                                        string coverageBenefitPlanId;
                                                        coverageBenefitPlanId = (cl.benefitPlanId != null && cl.benefitPlanId != '' )?(cl.benefitPlanId.length()>=2?cl.benefitPlanId.toLowerCase().subString(0,2):''):'';
                                                        system.debug('------------>'+membership.sourceSysCode.equalsIgnoreCase('CR')+'===========>'+ c.coverageTypeDescription.equalsIgnoreCase('MEDICAL')+'------->'+cl.isActive+'--------->'+ coverageBenefitPlanId );
                                                        //Preferred Coverage 
                                                        if(membership.sourceSysCode.equalsIgnoreCase('CR') && c.coverageTypeDescription.equalsIgnoreCase('MEDICAL') && (coverageBenefitPlanId != 'mr') && cl.isEnrollee ){ 
                                                            cl.isPreferred= isPreferredCoverageForNoActive(membership.sourceSysCode, c.coverageTypeDescription, true, c.membershipEffectiveDate, dateToCompare,cl.benefitPlanId,cl.GroupNumber  );                                                           
                                                            if( dateToCompare == null || cl.isPreferred){
                                                                dateToCompare = c.membershipEffectiveDate; //dateToCompare == null ||
                                                            }
                                                            //InactiveCoverages += 1;
                                                            if(cl.isPreferred){
                                                                sr.groupNumberValue = cl.GroupNumber;
                                                                prefferedCovfound = true;
                                                            }
                                                            
                                                        }
                                                        
                                                        if(c.subscriberSystemSpecificIdentifiers != null){
                                                            
                                                            if(!c.subscriberSystemSpecificIdentifiers.isEmpty() ){ 
                                                                for(ACETLGT_FindIndMembershipsJSON2Apex.Identifiers sssi : c.subscriberSystemSpecificIdentifiers){
                                                                    if(sssi.type_z == 'subscriberSurrogateKey'){
                                                                        cl.SurrogateKey = sssi.id; 
                                                                        system.debug('---------cl.SurrogateKey----->'+cl.SurrogateKey);
                                                                        cl.EnrolleeSurrogateKey = sr.EnrolleeSurrogateKey;
                                                                        system.debug('---------cl.EnrolleeSurrogateKey----->'+cl.EnrolleeSurrogateKey);
                                                                    }
                                                                }
                                                            }
                                                        } 
                                                        if(cl.CoverageTypeCode == 'RX')
                                                            sr.PharmacyCoverageLines.add(cl);
                                                        else if(cl.CoverageTypeCode == 'M')
                                                            sr.MedicalCoverageLines.add(cl);
                                                        system.debug('----cl---->>'+cl.isPreferred);
                                                        
                                                    }//Rider If
                                                }
                                                //}
                                                
                                            }
                                            //if active dual coverage found scenario
                                            else if(coverageCount > 1){
                                                sr.AffiliationIndicator = true;
                                                membership.coverages.sort();
                                                //if(prefferedCovfound == false ){
                                                for(ACETLGT_FindIndMembershipsJSON2Apex.Coverages c : membership.coverages){
                                                    ACETLGT_MemberSearchCoveragesResult.CoverageLine cl = new ACETLGT_MemberSearchCoveragesResult.CoverageLine();
                                                    cl.riderOnlyIndicator = (c.benefit != null && c.benefit.riderOnlyIndicator!= null)?c.benefit.riderOnlyIndicator:'';
                                                    cl.CoverageTypeCode = (c.coverageType!= null)?c.coverageType:'';
                                                    cl.bookOfBusinessTypeCode = (c.benefit!=null && c.benefit.bookOfBusinessTypeCode!=null)?c.benefit.bookOfBusinessTypeCode:'';
                                                    if(cl.riderOnlyIndicator == 'N' || cl.riderOnlyIndicator == 'Y' && cl.CoverageTypeCode == 'RX'){
                                                        cl.pharmacyIndicator = 'No';
                                                        cl.isEnrollee =false;
                                                        cl.CoverageType = (c.coverageTypeDescription!=null)?c.coverageTypeDescription:'';
                                                        cl.CoverageTypeCode = (c.coverageType!= null)?c.coverageType:'';
                                                        cl.CoverageLevel = (c.coverageLevelCode!= null)?c.coverageLevelCode:'';
                                                        cl.EffectiveDate = String.isNotBlank(c.membershipEffectiveDate)?formatDate(c.membershipEffectiveDate):'';
                                                        cl.EndDate = String.isNotBlank(c.membershipExpirationDate)?formatDate(c.membershipExpirationDate):''; 
                                                        cl.PolicyNumber = (c.legacyAttributes!=null && c.legacyAttributes.policyNumber != null)?c.legacyAttributes.policyNumber:'';
                                                        cl.GroupName = (c.GroupName!= null)?c.GroupName:'';
                                                        cl.GroupNumber = (c.groupNumber!= null)?c.groupNumber:'';
                                                        cl.Product = (c.product!=null && c.product.productName!= null)?c.product.productName:'';
                                                        cl.ProductType = (c.product!=null && c.product.productType!=null)?c.product.productType:'';
                                                        cl.relationShipCode=(c.relationshipCode!= null)?c.relationshipCode:'';
                                                        if(c.relationshipCode=='18'){
                                                            isSelf=True;
                                                        }
                                                        
                                                        if(membership.identifiers!=null){
                                                            for(ACETLGT_FindIndMembershipsJSON2Apex.Identifiers identifierDtl : membership.identifiers){
                                                                system.debug('----identifierDtl.id----'+identifierDtl.id +'-----sr.SCRId-----'+sr.SCRId +'-----memberId---->'+memberId);
                                                                if(identifierDtl.type_Z == 'MCH'){
                                                                    cl.memberId = identifierDtl.id;
                                                                    system.debug('----identifierDtl.id----'+identifierDtl.id +'-----sr.Id-----'+sr.ID +'-----memberId---->'+memberId);
                                                                    if(identifierDtl.id == sr.selectedMemberId ){  //Check Condition
                                                                        system.debug('----identifierDtl.id----'+identifierDtl.id +'-----sr.SCRId-----'+sr.ID +'-----memberId---->'+memberId);
                                                                        cl.isEnrollee=True;
                                                                    }   
                                                                }
                                                            }
                                                        } // End of identifiers
                                                        
                                                        Date todaydate = (Date) date.today();
                                                        Date EffectiveDate = String.isNotBlank(c.membershipEffectiveDate)?(Date) date.parse(formatDate(c.membershipEffectiveDate)):null;
                                                        if(EffectiveDate!=null){
                                                            if(todaydate <= EffectiveDate)
                                                                cl.DaysGap =  todaydate.daysBetween(EffectiveDate ) ;
                                                            else
                                                                cl.DaysGap =  EffectiveDate.daysBetween(todaydate) ;
                                                        }
                                                        cl.SourceCode = (membership.sourceSysCode != null)?membership.sourceSysCode:'';
                                                        cl.isActive = isActiveCoverage(cl.EffectiveDate, cl.EndDate);
                                                        cl.isFuture = Date.Parse(cl.EffectiveDate) > Date.today() ? True : False;
                                                        cl.isTermed = (cl.EndDate != null && cl.EndDate != '' && cl.EndDate!='12/31/9999' && Date.Parse(cl.EndDate) < Date.today() )? True : False;
                                                        cl.accumAsOfDate = (cl.isTermed?cl.EndDate:(cl.isFuture?cl.EffectiveDate:String.ValueOf(todaydate)));
                                                        cl.benefitPlanId = (c.benefit != null && c.benefit.benefitPlanId != null)?c.benefit.benefitPlanId:'';
                                                        
                                                        //FIM Enhancement - Abhinav Balla
                                                        cl.benefitPlanName= (c.benefit != null && c.benefit.benefitPlanName!= null)?c.benefit.benefitPlanName:'';
                                                        cl.planOptionID= (c.benefit != null && c.benefit.planOptionID!= null)?c.benefit.planOptionID:'';
                                                        cl.riderOnlyIndicator = (c.benefit != null && c.benefit.riderOnlyIndicator!= null)?c.benefit.riderOnlyIndicator:'';
                                                        system.debug('$$$$$'+cl.planOptionID+cl.riderOnlyIndicator);
                                                        list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions> acpvlist = new list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions>();
														 cl.activeCPs = new list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions>();																				
                                                        /*Collect all the active customer purchase versions*/
                                                        if(c.benefit!= null && c.benefit.customerPurchase != null){
                                                            for(ACETLGT_FindIndMembershipsJSON2Apex.CustomerPurchase cp : c.benefit.customerPurchase){
                                                                if(cp.customerPurchaseVersions != null){
                                                                    system.debug('$$$$$ Inside CP');
                                                                    
                                                                    for(ACETLGT_FindIndMembershipsJSON2Apex.CustomerPurchaseVersions cpv : cp.customerPurchaseVersions ){
                                                                        if(cpv.customerPurchaseStatusDescription == 'Active'){
                                                                            ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions acpv = new ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions();
                                                                            system.debug('$$$$$ InsideActive CPV');
                                                                            
                                                                            acpv.contractOptionStartDate = String.isNotBlank(cpv.contractOptionStartDate)?formatDate(cpv.contractOptionStartDate):'' ;
                                                                            acpv.contractOptionEndDate = String.isNotBlank(cpv.contractOptionEndDate)?formatDate(cpv.contractOptionEndDate):'';
                                                                            acpv.customerPurchaseId = String.isNotBlank(cp.customerPurchaseId)?cp.customerPurchaseId:'' ;
                                                                            
                                                                            acpvlist.add(acpv);
																			  cl.activeCPs.add(acpv);
                                                                        }
                                                                    }
                                                                }
                                                                
                                                            }
                                                            system.debug('$$$Active CP Versions'+acpvlist);
                                                        }
                                                        
                                                        system.debug('$$$CP Versions'+acpvlist.size());
                                                        /*Find the latest contract option when there are multiple customer purchases coming back*/
                                                        LatestCODates lcd = new LatestCODates();
                                                        lcd = getLatestCODates(acpvlist,cl.EndDate);
                                                        
                                                        cl.LatestCOStartDate = lcd.LatestCOStartDate;
                                                        cl.LatestCOEndDate =  lcd.LatestCOEndDate;
                                                        cl.customerPurchaseId = lcd.customerPurchaseId;

                                                        /*To find the Benefit timeline based on Member and contract option dates*/
                                                        cl.BenEffectiveDate = getBenefitEffectiveDate(cl.EffectiveDate,cl.LatestCOStartDate);
                                                        cl.BenEndDate = getBenefitEndDate(cl.EndDate,cl.LatestCOEndDate);
                                                        system.debug('$$$Check 4'+cl.BenEffectiveDate+'//'+cl.BenEndDate +'///'+cl.EffectiveDate+'??'+cl.LatestCOStartDate+'///'+cl.EndDate+'??'+cl.LatestCOEndDate);
                                                        
                                                        cl.isPreferred = False;                                 
                                                        string coverageBenefitPlanId;
                                                        coverageBenefitPlanId = (cl.benefitPlanId != null && cl.benefitPlanId != '' )?(cl.benefitPlanId.length()>=2?cl.benefitPlanId.toLowerCase().subString(0,2):''):'';
                                                        system.debug('------------>'+membership.sourceSysCode.equalsIgnoreCase('CR')+'===========>'+ c.coverageTypeDescription.equalsIgnoreCase('MEDICAL')+'------->'+cl.isActive+'--------->'+ coverageBenefitPlanId );
                                                        //Preferred Coverage 
                                                        if(membership.sourceSysCode.equalsIgnoreCase('CR') && c.coverageTypeDescription.equalsIgnoreCase('MEDICAL') && coverageBenefitPlanId != 'mr' && cl.isEnrollee ){ 
                                                            cl.isPreferred= isPreferredCoverageForDualMedical(membership.sourceSysCode, c.coverageTypeDescription, true, c.membershipEffectiveDate, dateToCompare,cl.benefitPlanId,cl.GroupNumber  );                                                           
                                                            if( dateToCompare == null || cl.isPreferred){
                                                                dateToCompare = c.membershipEffectiveDate; //dateToCompare == null ||
                                                            }
                                                            
                                                        }
                                                        
                                                        if(cl.isPreferred){
                                                            sr.groupNumberValue = cl.GroupNumber;
                                                            prefferedCovfound = true;
                                                        }
                                                        if(c.subscriberSystemSpecificIdentifiers != null){
                                                            
                                                            if(!c.subscriberSystemSpecificIdentifiers.isEmpty() ){ 
                                                                for(ACETLGT_FindIndMembershipsJSON2Apex.Identifiers sssi : c.subscriberSystemSpecificIdentifiers){
                                                                    if(sssi.type_z == 'subscriberSurrogateKey'){
                                                                        cl.SurrogateKey = sssi.id; 
                                                                        system.debug('---------cl.SurrogateKey----->'+cl.SurrogateKey);
                                                                        cl.EnrolleeSurrogateKey = sr.EnrolleeSurrogateKey;
                                                                        system.debug('---------cl.EnrolleeSurrogateKey----->'+cl.EnrolleeSurrogateKey);
                                                                    }
                                                                }
                                                            }
                                                        } 
                                                        if(cl.CoverageTypeCode == 'RX')
                                                            sr.PharmacyCoverageLines.add(cl);
                                                        else if(cl.CoverageTypeCode == 'M')
                                                            sr.MedicalCoverageLines.add(cl);
                                                        system.debug('----cl---->>'+cl.isPreferred);
                                                    }// Rider If
                                                }
                                                
                                            }
                                            //default scenario
                                            else{
                                                membership.coverages.sort();
                                                for(ACETLGT_FindIndMembershipsJSON2Apex.Coverages c : membership.coverages){
                                                    ACETLGT_MemberSearchCoveragesResult.CoverageLine cl = new ACETLGT_MemberSearchCoveragesResult.CoverageLine();
                                                    cl.riderOnlyIndicator = (c.benefit != null && c.benefit.riderOnlyIndicator!= null)?c.benefit.riderOnlyIndicator:'';
                                                    cl.CoverageTypeCode = (c.coverageType!= null)?c.coverageType:'';
                                                    cl.bookOfBusinessTypeCode = (c.benefit!=null && c.benefit.bookOfBusinessTypeCode!=null)?c.benefit.bookOfBusinessTypeCode:'';
                                                    if(cl.riderOnlyIndicator == 'N' || cl.riderOnlyIndicator == 'Y' && cl.CoverageTypeCode == 'RX'){
                                                        cl.pharmacyIndicator = 'No';
                                                        cl.isEnrollee =false;
                                                        cl.CoverageType = (c.coverageTypeDescription!=null)?c.coverageTypeDescription:'';
                                                        cl.CoverageTypeCode = (c.coverageType!= null)?c.coverageType:'';
                                                        cl.CoverageLevel = (c.coverageLevelCode!= null)?c.coverageLevelCode:'';
                                                        cl.EffectiveDate = String.isNotBlank(c.membershipEffectiveDate)?formatDate(c.membershipEffectiveDate):'';
                                                        cl.EndDate = String.isNotBlank(c.membershipExpirationDate)?formatDate(c.membershipExpirationDate):''; 
                                                        cl.PolicyNumber = (c.legacyAttributes!=null && c.legacyAttributes.policyNumber != null)?c.legacyAttributes.policyNumber:'';
                                                        cl.GroupName = (c.GroupName!= null)?c.GroupName:'';
                                                        cl.GroupNumber = (c.groupNumber!= null)?c.groupNumber:'';
                                                        cl.Product = (c.product!=null && c.product.productName!= null)?c.product.productName:'';
                                                        cl.ProductType = (c.product!=null && c.product.productType!=null)?c.product.productType:'';
                                                        cl.relationShipCode=(c.relationshipCode!= null)?c.relationshipCode:'';
                                                        if(c.relationshipCode=='18'){
                                                            isSelf=True;
                                                        }
                                                        
                                                        if(membership.identifiers!=null){
                                                            for(ACETLGT_FindIndMembershipsJSON2Apex.Identifiers identifierDtl : membership.identifiers){
                                                                
                                                                if(identifierDtl.type_Z == 'MCH'){
                                                                    cl.memberId = identifierDtl.id;
                                                                    system.debug('------CHECK------>'+identifierDtl.id+'-------->'+ sr.SCRId+'------>'+memberId);
                                                                    if(identifierDtl.id == sr.selectedMemberId){  //Check Condition
                                                                        cl.isEnrollee=True;
                                                                    }   
                                                                }
                                                                
                                                            }
                                                        } // End of identifiers
                                                        
                                                        Date todaydate = (Date) date.today();
                                                        Date EffectiveDate = String.isNotBlank(c.membershipEffectiveDate)?(Date) date.parse(formatDate(c.membershipEffectiveDate)):null;
                                                        if(EffectiveDate!=null){
                                                            if(todaydate <= EffectiveDate)
                                                                cl.DaysGap =  todaydate.daysBetween(EffectiveDate ) ;
                                                            else
                                                                cl.DaysGap =  EffectiveDate.daysBetween(todaydate) ;
                                                        }
                                                        cl.SourceCode = (membership.sourceSysCode != null)?membership.sourceSysCode:'';
                                                        cl.isActive = isActiveCoverage(cl.EffectiveDate, cl.EndDate);
                                                        cl.isFuture = Date.Parse(cl.EffectiveDate) > Date.today() ? True : False;
                                                        cl.isTermed = (cl.EndDate != null && cl.EndDate != '' && cl.EndDate!='12/31/9999' && Date.Parse(cl.EndDate) < Date.today() )? True : False;
                                                        cl.accumAsOfDate = (cl.isTermed?cl.EndDate:(cl.isFuture?cl.EffectiveDate:String.ValueOf(todaydate)));
                                                        cl.benefitPlanId = (c.benefit != null && c.benefit.benefitPlanId != null)?c.benefit.benefitPlanId:'';
                                                        
                                                        //FIM Enhancement - Abhinav Balla
                                                        cl.benefitPlanName= (c.benefit != null && c.benefit.benefitPlanName!= null)?c.benefit.benefitPlanName:'';
                                                        cl.planOptionID= (c.benefit != null && c.benefit.planOptionID!= null)?c.benefit.planOptionID:'';
                                                        cl.riderOnlyIndicator = (c.benefit != null && c.benefit.riderOnlyIndicator!= null)?c.benefit.riderOnlyIndicator:'';
                                                        system.debug('$$$$$'+cl.planOptionID+cl.riderOnlyIndicator);
                                                        list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions> acpvlist = new list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions>();
														cl.activeCPs = new list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions>();													 
                                                        /*Collect all the active customer purchase versions*/
                                                        if(c.benefit!= null && c.benefit.customerPurchase != null){
                                                            for(ACETLGT_FindIndMembershipsJSON2Apex.CustomerPurchase cp : c.benefit.customerPurchase){
                                                                if(cp.customerPurchaseVersions != null){
                                                                    system.debug('$$$$$ Inside CP');
                                                                    
                                                                    for(ACETLGT_FindIndMembershipsJSON2Apex.CustomerPurchaseVersions cpv : cp.customerPurchaseVersions ){
                                                                        if(cpv.customerPurchaseStatusDescription == 'Active'){
                                                                            ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions acpv = new ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions();
                                                                            system.debug('$$$$$ InsideActive CPV');
                                                                            
                                                                            acpv.contractOptionStartDate = String.isNotBlank(cpv.contractOptionStartDate)?formatDate(cpv.contractOptionStartDate):'' ;
                                                                            acpv.contractOptionEndDate = String.isNotBlank(cpv.contractOptionEndDate)?formatDate(cpv.contractOptionEndDate):'';
                                                                            acpv.customerPurchaseId = String.isNotBlank(cp.customerPurchaseId)?cp.customerPurchaseId:'' ;
                                                                            
                                                                            acpvlist.add(acpv);
																			cl.activeCPs.add(acpv);
                                                                        }
                                                                    }
                                                                }
                                                                
                                                            }
                                                            system.debug('$$$Active CP Versions'+acpvlist);
                                                        }
                                                        
                                                        system.debug('$$$CP Versions'+acpvlist.size());
                                                        /*Find the latest contract option when there are multiple customer purchases coming back*/
                                                        LatestCODates lcd = new LatestCODates();
                                                        lcd = getLatestCODates(acpvlist,cl.EndDate);
                                                        
                                                        cl.LatestCOStartDate = lcd.LatestCOStartDate;
                                                        cl.LatestCOEndDate =  lcd.LatestCOEndDate;
                                                        cl.customerPurchaseId = lcd.customerPurchaseId;
 
                                                        /*To find the Benefit timeline based on Member and contract option dates*/
                                                        cl.BenEffectiveDate = getBenefitEffectiveDate(cl.EffectiveDate,cl.LatestCOStartDate);
                                                        cl.BenEndDate = getBenefitEndDate(cl.EndDate,cl.LatestCOEndDate);
                                                        
                                                        
                                                        
                                                        
                                                        system.debug('$$$Check 5 else'+cl.BenEffectiveDate+'//'+cl.BenEndDate +'///'+cl.EffectiveDate+'??'+cl.LatestCOStartDate+'///'+cl.EndDate+'??'+cl.LatestCOEndDate);
                                                        
                                                        cl.isPreferred = False;                                 
                                                        string coverageBenefitPlanId;
                                                        coverageBenefitPlanId = (cl.benefitPlanId != null && cl.benefitPlanId != '' )?(cl.benefitPlanId.length()>=2?cl.benefitPlanId.toLowerCase().subString(0,2):''):'';
                                                        system.debug('------------>'+membership.sourceSysCode.equalsIgnoreCase('CR')+'===========>'+ c.coverageTypeDescription.equalsIgnoreCase('MEDICAL')+'------->'+cl.isActive+'--------->'+ coverageBenefitPlanId +'-------->'+isSelf +'------->'+cl.isEnrollee);
                                                        //Preferred Coverage 
                                                        if(membership.sourceSysCode.equalsIgnoreCase('CR') && c.coverageTypeDescription.equalsIgnoreCase('MEDICAL') && (coverageBenefitPlanId != 'mr') &&  cl.isEnrollee ){ 
                                                            cl.isPreferred= isPreferredCoverage(membership.sourceSysCode, c.coverageTypeDescription, cl.isActive , c.membershipEffectiveDate, dateToCompare,cl.benefitPlanId,cl.GroupNumber  );                                                           
                                                            if( dateToCompare == null || cl.isPreferred){
                                                                dateToCompare = c.membershipEffectiveDate; //dateToCompare == null ||
                                                            }
                                                            if(cl.isPreferred){
                                                                sr.groupNumberValue = cl.GroupNumber;
                                                                prefferedCovfound = true;
                                                                system.debug('-------PREFERRED COV----->');
                                                            }
                                                        }
                                                        
                                                        
                                                        if(c.subscriberSystemSpecificIdentifiers != null){
                                                            
                                                            if(!c.subscriberSystemSpecificIdentifiers.isEmpty() ){ 
                                                                for(ACETLGT_FindIndMembershipsJSON2Apex.Identifiers sssi : c.subscriberSystemSpecificIdentifiers){
                                                                    if(sssi.type_z == 'subscriberSurrogateKey'){
                                                                        cl.SurrogateKey = sssi.id; 
                                                                        system.debug('---------cl.SurrogateKey----->'+cl.SurrogateKey);
                                                                        cl.EnrolleeSurrogateKey = sr.EnrolleeSurrogateKey;
                                                                        system.debug('---------cl.EnrolleeSurrogateKey----->'+cl.EnrolleeSurrogateKey);
                                                                    }
                                                                }
                                                            }
                                                        } 
                                                        if(cl.isPreferred){
                                                            sr.groupNumberValue = cl.GroupNumber;
                                                            prefferedCovfound = true;
                                                        }
                                                        if(cl.CoverageTypeCode == 'RX')
                                                            sr.PharmacyCoverageLines.add(cl);
                                                        else if(cl.CoverageTypeCode == 'M')
                                                            sr.MedicalCoverageLines.add(cl);
                                                        
                                                    }//Rider If
                                                }
                                                //}
                                                
                                            }
                                            
                                            
                                        }//End if - coverages
                                        
                                    }
                                    if(prefferedCovfound == false){
                                        sr.CoverageLines = new List<ACETLGT_MemberSearchCoveragesResult.CoverageLine>();   
                                        sr.PharmacyCoverageLines = new List<ACETLGT_MemberSearchCoveragesResult.CoverageLine>();   
                                        sr.MedicalCoverageLines = new List<ACETLGT_MemberSearchCoveragesResult.CoverageLine>();   
                                        for (ACETLGT_FindIndMembershipsJSON2Apex.memberships membership: m.memberships) {
                                            // Discuss
                                            system.debug('========Membership333=====>>'+ membership);
                                            if(membership.sourceSysCode != null){
                                                sourceCodeSet.add(membership.sourceSysCode);
                                                if(sr.SourceCode == ''){
                                                    sr.SourceCode = membership.sourceSysCode; 
                                                }
                                                else{
                                                    sr.sourceCode = (sr.SourceCode.contains(membership.sourceSysCode)?sr.sourceCode:(sr.SourceCode  +','+ membership.sourceSysCode));
                                                }
                                                system.debug('>>>'+sr.sourceCode);
                                            }
                                            
                                            
                                            if(membership.sourceSysCode != null){    
                                                if(membership.enrolleeSystemSpecificIdentifiers != null){
                                                    for (ACETLGT_FindIndMembershipsJSON2Apex.Identifiers memIdentifiers: membership.enrolleeSystemSpecificIdentifiers) {
                                                        
                                                        if (memIdentifiers.type_Z == 'enrolleeSurrogateKey') {
                                                            sr.SurrogateKeys.add(memIdentifiers.id);   
                                                            //sr.EnrolleeSurrogateKey = memIdentifiers.id;
                                                            //system.debug('---------sr.EnrolleeSurrogateKey----->'+sr.EnrolleeSurrogateKey);
                                                        }
                                                    }
                                                }
                                            }
                                            if(membership.sourceSysCode != null && membership.sourceSysCode == 'CR'){    
                                                if(membership.enrolleeSystemSpecificIdentifiers != null){
                                                    for (ACETLGT_FindIndMembershipsJSON2Apex.Identifiers memIdentifiers: membership.enrolleeSystemSpecificIdentifiers) {
                                                        
                                                        if (memIdentifiers.type_Z == 'enrolleeSurrogateKey') {
                                                            //sr.SurrogateKeys.add(memIdentifiers.id);
                                                            sr.EnrolleeSurrogateKey = memIdentifiers.id;
                                                            system.debug('---------sr.EnrolleeSurrogateKey----->'+sr.EnrolleeSurrogateKey);
                                                        }
                                                    }
                                                }
                                                if(membership.identifiers != null){
                                                    //List<ACETLGT_MemberSearchCoveragesResult.CoverageLine> covLines = new List<ACETLGT_MemberSearchCoveragesResult.CoverageLine>();  
                                                    for (ACETLGT_FindIndMembershipsJSON2Apex.Identifiers identifiers: membership.identifiers) {
                                                        
                                                        if (identifiers.type_Z == 'MCH') {
                                                            sr.IDs.add(identifiers.id);
                                                            if(identifiers.id == sr.selectedMemberId)
                                                                sr.ID = identifiers.id;  
                                                        }   
                                                        
                                                        //sr.SCRID   
                                                        if (identifiers.type_Z == 'SCR') {
                                                            sr.IDs.add(identifiers.id);
                                                            if(String.isNotBlank(memberId) &&  !(memberId.trim()).equalsIgnoreCase(m.socialSecurityNumber.trim()) ){
                                                                System.debug('It came here@@@ for SCR');
                                                                if(String.isNotBlank(Identifiers.id) && (memberId.trim().substring(0,memberId.trim().length()-2)).equalsIgnoreCase((Identifiers.id.trim()).substring(0,Identifiers.id.trim().length()-2))){
                                                                    sr.SCRID = Identifiers.id;  
                                                                } 
                                                            }
                                                            else{ 
                                                                sr.SCRID = Identifiers.id;
                                                            }
                                                        }                                  
                                                    }
                                                }
                                                
                                                
                                            }
                                            
                                            if(membership.enrolleeSystemSpecificIdentifiers!=null && !membership.enrolleeSystemSpecificIdentifiers.isEmpty()){
                                                for(ACETLGT_FindIndMembershipsJSON2Apex.Identifiers eachIdentifier:membership.enrolleeSystemSpecificIdentifiers){
                                                    if(eachIdentifier.type_Z =='enrolleeIndividualIdentifier'){
                                                        sr.EID = eachIdentifier.id;
                                                        break;
                                                    }
                                                }
                                            }
                                            
                                            boolean isSelf=false;
                                            boolean isEnrollee=false;
                                            
                                            
                                            if(membership != null && membership.coverages != null){
                                                
                                                
                                                if(coverageCount < 1 && InactiveCoverages < 2){
                                                    membership.coverages.sort();
                                                    for(ACETLGT_FindIndMembershipsJSON2Apex.Coverages c : membership.coverages){
                                                        ACETLGT_MemberSearchCoveragesResult.CoverageLine cl = new ACETLGT_MemberSearchCoveragesResult.CoverageLine();
                                                        cl.riderOnlyIndicator = (c.benefit != null && c.benefit.riderOnlyIndicator!= null)?c.benefit.riderOnlyIndicator:'';
                                                        cl.CoverageTypeCode = (c.coverageType!= null)?c.coverageType:'';
                                                        cl.bookOfBusinessTypeCode = (c.benefit!=null && c.benefit.bookOfBusinessTypeCode!=null)?c.benefit.bookOfBusinessTypeCode:'';
                                                    
                                                        if(cl.riderOnlyIndicator == 'N' || cl.riderOnlyIndicator == 'Y' && cl.CoverageTypeCode == 'RX'){
                                                            cl.pharmacyIndicator = 'No';
                                                            cl.isEnrollee =false;
                                                            cl.CoverageType = (c.coverageTypeDescription!=null)?c.coverageTypeDescription:'';
                                                            cl.CoverageTypeCode = (c.coverageType!= null)?c.coverageType:'';
                                                            cl.CoverageLevel = (c.coverageLevelCode!= null)?c.coverageLevelCode:'';
                                                            cl.EffectiveDate = String.isNotBlank(c.membershipEffectiveDate)?formatDate(c.membershipEffectiveDate):'';
                                                            cl.EndDate = String.isNotBlank(c.membershipExpirationDate)?formatDate(c.membershipExpirationDate):''; 
                                                            cl.PolicyNumber = (c.legacyAttributes!=null && c.legacyAttributes.policyNumber != null)?c.legacyAttributes.policyNumber:'';
                                                            cl.GroupName = (c.GroupName!= null)?c.GroupName:'';
                                                            cl.GroupNumber = (c.groupNumber!= null)?c.groupNumber:'';
                                                            cl.Product = (c.product!=null && c.product.productName!= null)?c.product.productName:'';
                                                            cl.ProductType = (c.product!=null && c.product.productType!=null)?c.product.productType:'';
                                                            cl.relationShipCode=(c.relationshipCode!= null)?c.relationshipCode:'';
                                                            if(c.relationshipCode=='18'){
                                                                isSelf=True;
                                                            }
                                                            
                                                            if(membership.identifiers!=null){
                                                                for(ACETLGT_FindIndMembershipsJSON2Apex.Identifiers identifierDtl : membership.identifiers){
                                                                    if(identifierDtl.type_Z == 'MCH'){
                                                                        cl.memberId = identifierDtl.id; 
                                                                        if(identifierDtl.id == sr.selectedMemberId){  //Check Condition
                                                                            cl.isEnrollee=True;
                                                                        }   
                                                                    }
                                                                    
                                                                }
                                                            } // End of identifiers
                                                            
                                                            Date todaydate = (Date) date.today();
                                                            Date EffectiveDate = String.isNotBlank(c.membershipEffectiveDate)?(Date) date.parse(formatDate(c.membershipEffectiveDate)):null;
                                                            if(EffectiveDate!=null){
                                                                if(todaydate <= EffectiveDate)
                                                                    cl.DaysGap =  todaydate.daysBetween(EffectiveDate ) ;
                                                                else
                                                                    cl.DaysGap =  EffectiveDate.daysBetween(todaydate) ;
                                                            }
                                                            cl.SourceCode = (membership.sourceSysCode != null)?membership.sourceSysCode:'';
                                                            cl.isActive = isActiveCoverage(cl.EffectiveDate, cl.EndDate);
                                                            cl.isFuture = Date.Parse(cl.EffectiveDate) > Date.today() ? True : False;
                                                            cl.isTermed = (cl.EndDate != null && cl.EndDate != '' && cl.EndDate!='12/31/9999' && Date.Parse(cl.EndDate) < Date.today() )? True : False;
                                                            cl.accumAsOfDate = (cl.isTermed?cl.EndDate:(cl.isFuture?cl.EffectiveDate:String.ValueOf(todaydate)));
                                                            cl.benefitPlanId = (c.benefit != null && c.benefit.benefitPlanId != null)?c.benefit.benefitPlanId:'';
                                                            //FIM Enhancement - Abhinav Balla
                                                            cl.benefitPlanName= (c.benefit != null && c.benefit.benefitPlanName!= null)?c.benefit.benefitPlanName:'';
                                                            cl.planOptionID= (c.benefit != null && c.benefit.planOptionID!= null)?c.benefit.planOptionID:'';
                                                            cl.riderOnlyIndicator = (c.benefit != null && c.benefit.riderOnlyIndicator!= null)?c.benefit.riderOnlyIndicator:'';
                                                            system.debug('$$$$$'+cl.planOptionID+cl.riderOnlyIndicator);
                                                            list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions> acpvlist = new list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions>();
                                                            /*Collect all the active customer purchase versions*/
															cl.activeCPs = new list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions>();																							  
                                                            if(c.benefit!= null && c.benefit.customerPurchase != null){
                                                                for(ACETLGT_FindIndMembershipsJSON2Apex.CustomerPurchase cp : c.benefit.customerPurchase){
                                                                    if(cp.customerPurchaseVersions != null){
                                                                        system.debug('$$$$$ Inside CP');
                                                                        
                                                                        for(ACETLGT_FindIndMembershipsJSON2Apex.CustomerPurchaseVersions cpv : cp.customerPurchaseVersions ){
                                                                            if(cpv.customerPurchaseStatusDescription == 'Active'){
                                                                                ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions acpv = new ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions();
                                                                                system.debug('$$$$$ InsideActive CPV');
                                                                                
                                                                                acpv.contractOptionStartDate = String.isNotBlank(cpv.contractOptionStartDate)?formatDate(cpv.contractOptionStartDate):'' ;
                                                                                acpv.contractOptionEndDate = String.isNotBlank(cpv.contractOptionEndDate)?formatDate(cpv.contractOptionEndDate):'';
                                                                                acpv.customerPurchaseId = String.isNotBlank(cp.customerPurchaseId)?cp.customerPurchaseId:'' ;
                                                                                
                                                                                acpvlist.add(acpv);
																				 cl.activeCPs.add(acpv);
                                                                            }
                                                                        }
                                                                    }
                                                                    
                                                                }
                                                                system.debug('$$$Active CP Versions'+acpvlist);
                                                            }
                                                            
                                                            system.debug('$$$CP Versions'+acpvlist.size());
                                                            /*Find the latest contract option when there are multiple customer purchases coming back*/
                                                            LatestCODates lcd = new LatestCODates();
                                                            lcd = getLatestCODates(acpvlist,cl.EndDate);
                                                            
                                                            cl.LatestCOStartDate = lcd.LatestCOStartDate;
                                                            cl.LatestCOEndDate =  lcd.LatestCOEndDate;
                                                            cl.customerPurchaseId = lcd.customerPurchaseId;
 
                                                            /*To find the Benefit timeline based on Member and contract option dates*/
                                                            cl.BenEffectiveDate = getBenefitEffectiveDate(cl.EffectiveDate,cl.LatestCOStartDate);
                                                            cl.BenEndDate = getBenefitEndDate(cl.EndDate,cl.LatestCOEndDate);
                                                            
                                                            
                                                            system.debug('$$$Check II 1'+cl.BenEffectiveDate+'//'+cl.BenEndDate +'///'+cl.EffectiveDate+'??'+cl.LatestCOStartDate+'///'+cl.EndDate+'??'+cl.LatestCOEndDate);
                                                            
                                                            cl.isPreferred = False;                                 
                                                            string coverageBenefitPlanId;
                                                            coverageBenefitPlanId = (cl.benefitPlanId != null && cl.benefitPlanId != '' )?(cl.benefitPlanId.length()>=2?cl.benefitPlanId.toLowerCase().subString(0,2):''):'';
                                                            system.debug('------------>'+membership.sourceSysCode.equalsIgnoreCase('CR')+'===========>'+ c.coverageTypeDescription.equalsIgnoreCase('MEDICAL')+'------->'+cl.isActive+'--------->'+ coverageBenefitPlanId );
                                                            //Preferred Coverage 
                                                            if(membership.sourceSysCode.equalsIgnoreCase('CR') && c.coverageTypeDescription.equalsIgnoreCase('MEDICAL') && (coverageBenefitPlanId != 'mr') && cl.isEnrollee){ 
                                                                cl.isPreferred= isPreferredCoverage(membership.sourceSysCode, c.coverageTypeDescription, true, c.membershipEffectiveDate, dateToCompare,cl.benefitPlanId,cl.GroupNumber  );                                                           
                                                                if( dateToCompare == null || cl.isPreferred){
                                                                    dateToCompare = c.membershipEffectiveDate; //dateToCompare == null ||
                                                                }
                                                                //InactiveCoverages += 1;
                                                                if(cl.isPreferred){
                                                                    sr.groupNumberValue = cl.GroupNumber;
                                                                    prefferedCovfound = true;
                                                                    system.debug('-------PREFERRED COV-2---->');
                                                                }
                                                                
                                                            }
                                                            
                                                            if(c.subscriberSystemSpecificIdentifiers != null){
                                                                
                                                                if(!c.subscriberSystemSpecificIdentifiers.isEmpty() ){ 
                                                                    for(ACETLGT_FindIndMembershipsJSON2Apex.Identifiers sssi : c.subscriberSystemSpecificIdentifiers){
                                                                        if(sssi.type_z == 'subscriberSurrogateKey'){
                                                                            cl.SurrogateKey = sssi.id; 
                                                                            system.debug('---------cl.SurrogateKey----->'+cl.SurrogateKey);
                                                                            cl.EnrolleeSurrogateKey = sr.EnrolleeSurrogateKey;
                                                                            system.debug('---------cl.EnrolleeSurrogateKey----->'+cl.EnrolleeSurrogateKey);
                                                                        }
                                                                        
                                                                    }
                                                                }
                                                            } 
                                                            if(cl.CoverageTypeCode == 'RX')
                                                                sr.PharmacyCoverageLines.add(cl);
                                                            else if(cl.CoverageTypeCode == 'M')
                                                                sr.MedicalCoverageLines.add(cl);
                                                            system.debug('----cl---->>'+cl.isPreferred);
                                                        }// Rider If
                                                    }
                                                    
                                                }
                                                else if(coverageCount < 1 && InactiveCoverages > 1){
                                                    membership.coverages.sort();
                                                    for(ACETLGT_FindIndMembershipsJSON2Apex.Coverages c : membership.coverages){
                                                        ACETLGT_MemberSearchCoveragesResult.CoverageLine cl = new ACETLGT_MemberSearchCoveragesResult.CoverageLine();
                                                        cl.riderOnlyIndicator = (c.benefit != null && c.benefit.riderOnlyIndicator!= null)?c.benefit.riderOnlyIndicator:'';
                                                        cl.CoverageTypeCode = (c.coverageType!= null)?c.coverageType:'';
                                                        cl.bookOfBusinessTypeCode = (c.benefit!=null && c.benefit.bookOfBusinessTypeCode!=null)?c.benefit.bookOfBusinessTypeCode:'';
                                                    
                                                        if(cl.riderOnlyIndicator == 'N' || cl.riderOnlyIndicator == 'Y' && cl.CoverageTypeCode == 'RX'){
                                                            cl.pharmacyIndicator = 'No';
                                                            cl.isEnrollee =false;
                                                            cl.CoverageType = (c.coverageTypeDescription!=null)?c.coverageTypeDescription:'';
                                                            cl.CoverageTypeCode = (c.coverageType!= null)?c.coverageType:'';
                                                            cl.CoverageLevel = (c.coverageLevelCode!= null)?c.coverageLevelCode:'';
                                                            cl.EffectiveDate = String.isNotBlank(c.membershipEffectiveDate)?formatDate(c.membershipEffectiveDate):'';
                                                            cl.EndDate = String.isNotBlank(c.membershipExpirationDate)?formatDate(c.membershipExpirationDate):''; 
                                                            cl.PolicyNumber = (c.legacyAttributes!=null && c.legacyAttributes.policyNumber != null)?c.legacyAttributes.policyNumber:'';
                                                            cl.GroupName = (c.GroupName!= null)?c.GroupName:'';
                                                            cl.GroupNumber = (c.groupNumber!= null)?c.groupNumber:'';
                                                            cl.Product = (c.product!=null && c.product.productName!= null)?c.product.productName:'';
                                                            cl.ProductType = (c.product!=null && c.product.productType!=null)?c.product.productType:'';
                                                            cl.relationShipCode=(c.relationshipCode!= null)?c.relationshipCode:'';
                                                            if(c.relationshipCode=='18'){
                                                                isSelf=True;
                                                            }
                                                            
                                                            if(membership.identifiers!=null){
                                                                for(ACETLGT_FindIndMembershipsJSON2Apex.Identifiers identifierDtl : membership.identifiers){
                                                                    if(identifierDtl.type_Z == 'MCH'){
                                                                        cl.memberId = identifierDtl.id; 
                                                                        if(identifierDtl.id == sr.SCRId ){  //Check Condition
                                                                            cl.isEnrollee=True;
                                                                        }   
                                                                    }
                                                                }
                                                            } // End of identifiers
                                                            
                                                            Date todaydate = (Date) date.today();
                                                            Date EffectiveDate = String.isNotBlank(c.membershipEffectiveDate)?(Date) date.parse(formatDate(c.membershipEffectiveDate)):null;
                                                            if(EffectiveDate!=null){
                                                                if(todaydate <= EffectiveDate)
                                                                    cl.DaysGap =  todaydate.daysBetween(EffectiveDate ) ;
                                                                else
                                                                    cl.DaysGap =  EffectiveDate.daysBetween(todaydate) ;
                                                            }
                                                            cl.SourceCode = (membership.sourceSysCode != null)?membership.sourceSysCode:'';
                                                            cl.isActive = isActiveCoverage(cl.EffectiveDate, cl.EndDate);
                                                            cl.isFuture = Date.Parse(cl.EffectiveDate) > Date.today() ? True : False;
                                                            cl.isTermed = (cl.EndDate != null && cl.EndDate != '' && cl.EndDate!='12/31/9999' && Date.Parse(cl.EndDate) < Date.today() )? True : False;
                                                            cl.accumAsOfDate = (cl.isTermed?cl.EndDate:(cl.isFuture?cl.EffectiveDate:String.ValueOf(todaydate)));
                                                            cl.benefitPlanId = (c.benefit != null && c.benefit.benefitPlanId != null)?c.benefit.benefitPlanId:'';
                                                            
                                                            //FIM Enhancement - Abhinav Balla
                                                            cl.benefitPlanName= (c.benefit != null && c.benefit.benefitPlanName!= null)?c.benefit.benefitPlanName:'';
                                                            cl.planOptionID= (c.benefit != null && c.benefit.planOptionID!= null)?c.benefit.planOptionID:'';
                                                            cl.riderOnlyIndicator = (c.benefit != null && c.benefit.riderOnlyIndicator!= null)?c.benefit.riderOnlyIndicator:'';
                                                            system.debug('$$$$$'+cl.planOptionID+cl.riderOnlyIndicator);
                                                            list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions> acpvlist = new list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions>();
                                                            /*Collect all the active customer purchase versions*/
															 cl.activeCPs = new list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions>();												
                                                            if(c.benefit!= null && c.benefit.customerPurchase != null){
                                                                for(ACETLGT_FindIndMembershipsJSON2Apex.CustomerPurchase cp : c.benefit.customerPurchase){
                                                                    if(cp.customerPurchaseVersions != null){
                                                                        system.debug('$$$$$ Inside CP');
                                                                        
                                                                        for(ACETLGT_FindIndMembershipsJSON2Apex.CustomerPurchaseVersions cpv : cp.customerPurchaseVersions ){
                                                                            if(cpv.customerPurchaseStatusDescription == 'Active'){
                                                                                ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions acpv = new ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions();
                                                                                system.debug('$$$$$ InsideActive CPV');
                                                                                
                                                                                acpv.contractOptionStartDate = String.isNotBlank(cpv.contractOptionStartDate)?formatDate(cpv.contractOptionStartDate):'' ;
                                                                                acpv.contractOptionEndDate = String.isNotBlank(cpv.contractOptionEndDate)?formatDate(cpv.contractOptionEndDate):'';
                                                                                acpv.customerPurchaseId = String.isNotBlank(cp.customerPurchaseId)?cp.customerPurchaseId:'' ;
                                                                                
                                                                                acpvlist.add(acpv);
																				      cl.activeCPs.add(acpv);
                                                                            }
                                                                        }
                                                                    }
                                                                    
                                                                }
                                                                system.debug('$$$Active CP Versions'+acpvlist);
                                                            }
                                                            
                                                            system.debug('$$$CP Versions'+acpvlist.size());
                                                            /*Find the latest contract option when there are multiple customer purchases coming back*/
                                                            LatestCODates lcd = new LatestCODates();
                                                            lcd = getLatestCODates(acpvlist,cl.EndDate);
                                                            
                                                            cl.LatestCOStartDate = lcd.LatestCOStartDate;
                                                            cl.LatestCOEndDate =  lcd.LatestCOEndDate;
                                                            cl.customerPurchaseId = lcd.customerPurchaseId;

                                                            /*To find the Benefit timeline based on Member and contract option dates*/
                                                            cl.BenEffectiveDate = getBenefitEffectiveDate(cl.EffectiveDate,cl.LatestCOStartDate);
                                                            cl.BenEndDate = getBenefitEndDate(cl.EndDate,cl.LatestCOEndDate);
                                                            
                                                            system.debug('$$$CheckII 2 '+cl.BenEffectiveDate+'//'+cl.BenEndDate +'///'+cl.EffectiveDate+'??'+cl.LatestCOStartDate+'///'+cl.EndDate+'??'+cl.LatestCOEndDate);
                                                            
                                                            cl.isPreferred = False;                                 
                                                            string coverageBenefitPlanId;
                                                            coverageBenefitPlanId = (cl.benefitPlanId != null && cl.benefitPlanId != '' )?(cl.benefitPlanId.length()>=2?cl.benefitPlanId.toLowerCase().subString(0,2):''):'';
                                                            system.debug('------------>'+membership.sourceSysCode.equalsIgnoreCase('CR')+'===========>'+ c.coverageTypeDescription.equalsIgnoreCase('MEDICAL')+'------->'+cl.isActive+'--------->'+ coverageBenefitPlanId );
                                                            //Preferred Coverage 
                                                            if(membership.sourceSysCode.equalsIgnoreCase('CR') && c.coverageTypeDescription.equalsIgnoreCase('MEDICAL') && (coverageBenefitPlanId != 'mr') && cl.isEnrollee  ){ 
                                                                cl.isPreferred= isPreferredCoverageForNoActive(membership.sourceSysCode, c.coverageTypeDescription, true, c.membershipEffectiveDate, dateToCompare,cl.benefitPlanId,cl.GroupNumber  );                                                           
                                                                if( dateToCompare == null || cl.isPreferred){
                                                                    dateToCompare = c.membershipEffectiveDate; //dateToCompare == null ||
                                                                }
                                                                //InactiveCoverages += 1;
                                                                if(cl.isPreferred){
                                                                    sr.groupNumberValue = cl.GroupNumber;
                                                                    prefferedCovfound = true;
                                                                    system.debug('-------PREFERRED COV-2---->');
                                                                }
                                                                
                                                            }
                                                            
                                                            if(c.subscriberSystemSpecificIdentifiers != null){
                                                                
                                                                if(!c.subscriberSystemSpecificIdentifiers.isEmpty() ){ 
                                                                    for(ACETLGT_FindIndMembershipsJSON2Apex.Identifiers sssi : c.subscriberSystemSpecificIdentifiers){
                                                                        if(sssi.type_z == 'subscriberSurrogateKey'){
                                                                            cl.SurrogateKey = sssi.id; 
                                                                            system.debug('---------cl.SurrogateKey----->'+cl.SurrogateKey);
                                                                            cl.EnrolleeSurrogateKey = sr.EnrolleeSurrogateKey;
                                                                            system.debug('---------cl.EnrolleeSurrogateKey----->'+cl.EnrolleeSurrogateKey);
                                                                        }
                                                                    }
                                                                }
                                                            } 
                                                            if(cl.CoverageTypeCode == 'RX')
                                                                sr.PharmacyCoverageLines.add(cl);
                                                            else if(cl.CoverageTypeCode == 'M')
                                                                sr.MedicalCoverageLines.add(cl);
                                                            system.debug('----cl---->>'+cl.isPreferred);
                                                            
                                                        }//Rider If
                                                    }
                                                    
                                                }
                                                else if(coverageCount > 1){
                                                    sr.AffiliationIndicator = true;
                                                    membership.coverages.sort();
                                                    for(ACETLGT_FindIndMembershipsJSON2Apex.Coverages c : membership.coverages){
                                                        ACETLGT_MemberSearchCoveragesResult.CoverageLine cl = new ACETLGT_MemberSearchCoveragesResult.CoverageLine();
                                                        cl.riderOnlyIndicator = (c.benefit != null && c.benefit.riderOnlyIndicator!= null)?c.benefit.riderOnlyIndicator:'';
                                                        cl.CoverageTypeCode = (c.coverageType!= null)?c.coverageType:'';
                                                        cl.bookOfBusinessTypeCode = (c.benefit!=null && c.benefit.bookOfBusinessTypeCode!=null)?c.benefit.bookOfBusinessTypeCode:'';
                                                        if(cl.riderOnlyIndicator == 'N' || cl.riderOnlyIndicator == 'Y' && cl.CoverageTypeCode == 'RX'){
                                                            cl.pharmacyIndicator = 'No';
                                                            cl.isEnrollee =false;
                                                            cl.CoverageType = (c.coverageTypeDescription!=null)?c.coverageTypeDescription:'';
                                                            cl.CoverageTypeCode = (c.coverageType!= null)?c.coverageType:'';
                                                            cl.CoverageLevel = (c.coverageLevelCode!= null)?c.coverageLevelCode:'';
                                                            cl.EffectiveDate = String.isNotBlank(c.membershipEffectiveDate)?formatDate(c.membershipEffectiveDate):'';
                                                            cl.EndDate = String.isNotBlank(c.membershipExpirationDate)?formatDate(c.membershipExpirationDate):''; 
                                                            cl.PolicyNumber = (c.legacyAttributes!=null && c.legacyAttributes.policyNumber != null)?c.legacyAttributes.policyNumber:'';
                                                            cl.GroupName = (c.GroupName!= null)?c.GroupName:'';
                                                            cl.GroupNumber = (c.groupNumber!= null)?c.groupNumber:'';
                                                            cl.Product = (c.product!=null && c.product.productName!= null)?c.product.productName:'';
                                                            cl.ProductType = (c.product!=null && c.product.productType!=null)?c.product.productType:'';
                                                            cl.relationShipCode=(c.relationshipCode!= null)?c.relationshipCode:'';
                                                            if(c.relationshipCode=='18'){
                                                                isSelf=True;
                                                            }
                                                            
                                                            if(membership.identifiers!=null){
                                                                for(ACETLGT_FindIndMembershipsJSON2Apex.Identifiers identifierDtl : membership.identifiers){
                                                                    system.debug('----identifierDtl.id----'+identifierDtl.id +'-----sr.SCRId-----'+sr.SCRId +'-----memberId---->'+memberId);
                                                                    if(identifierDtl.type_Z == 'MCH'){
                                                                        cl.memberId = identifierDtl.id; 
                                                                        system.debug('----identifierDtl.id----'+identifierDtl.id +'-----sr.SCRId-----'+sr.SCRId +'-----memberId---->'+memberId);
                                                                        if(identifierDtl.id == sr.SCRId){  //Check Condition
                                                                            system.debug('----identifierDtl.id----'+identifierDtl.id +'-----sr.SCRId-----'+sr.SCRId +'-----memberId---->'+memberId);
                                                                            cl.isEnrollee=True;
                                                                        }   
                                                                    }
                                                                }
                                                            } // End of identifiers
                                                            
                                                            Date todaydate = (Date) date.today();
                                                            Date EffectiveDate = String.isNotBlank(c.membershipEffectiveDate)?(Date) date.parse(formatDate(c.membershipEffectiveDate)):null;
                                                            if(EffectiveDate!=null){
                                                                if(todaydate <= EffectiveDate)
                                                                    cl.DaysGap =  todaydate.daysBetween(EffectiveDate ) ;
                                                                else
                                                                    cl.DaysGap =  EffectiveDate.daysBetween(todaydate) ;
                                                            }
                                                            cl.SourceCode = (membership.sourceSysCode != null)?membership.sourceSysCode:'';
                                                            cl.isActive = isActiveCoverage(cl.EffectiveDate, cl.EndDate);
                                                            cl.isFuture = Date.Parse(cl.EffectiveDate) > Date.today() ? True : False;
                                                            cl.isTermed = (cl.EndDate != null && cl.EndDate != '' && cl.EndDate!='12/31/9999' && Date.Parse(cl.EndDate) < Date.today() )? True : False;
                                                            cl.accumAsOfDate = (cl.isTermed?cl.EndDate:(cl.isFuture?cl.EffectiveDate:String.ValueOf(todaydate)));
                                                            cl.benefitPlanId = (c.benefit != null && c.benefit.benefitPlanId != null)?c.benefit.benefitPlanId:'';
                                                            //FIM Enhancement - Abhinav Balla
                                                            cl.benefitPlanName= (c.benefit != null && c.benefit.benefitPlanName!= null)?c.benefit.benefitPlanName:'';
                                                            cl.planOptionID= (c.benefit != null && c.benefit.planOptionID!= null)?c.benefit.planOptionID:'';
                                                            cl.riderOnlyIndicator = (c.benefit != null && c.benefit.riderOnlyIndicator!= null)?c.benefit.riderOnlyIndicator:'';
                                                            system.debug('$$$$$'+cl.planOptionID+cl.riderOnlyIndicator);
                                                            list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions> acpvlist = new list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions>();
															cl.activeCPs = new list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions>();												
                                                            /*Collect all the active customer purchase versions*/
                                                            if(c.benefit!= null && c.benefit.customerPurchase != null){
                                                                for(ACETLGT_FindIndMembershipsJSON2Apex.CustomerPurchase cp : c.benefit.customerPurchase){
                                                                    if(cp.customerPurchaseVersions != null){
                                                                        system.debug('$$$$$ Inside CP');
                                                                        
                                                                        for(ACETLGT_FindIndMembershipsJSON2Apex.CustomerPurchaseVersions cpv : cp.customerPurchaseVersions ){
                                                                            if(cpv.customerPurchaseStatusDescription == 'Active'){
                                                                                ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions acpv = new ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions();
                                                                                system.debug('$$$$$ InsideActive CPV');
                                                                                
                                                                                acpv.contractOptionStartDate = String.isNotBlank(cpv.contractOptionStartDate)?formatDate(cpv.contractOptionStartDate):'' ;
                                                                                acpv.contractOptionEndDate = String.isNotBlank(cpv.contractOptionEndDate)?formatDate(cpv.contractOptionEndDate):'';
                                                                                acpv.customerPurchaseId = String.isNotBlank(cp.customerPurchaseId)?cp.customerPurchaseId:'' ;
                                                                                
                                                                                acpvlist.add(acpv);
																				 cl.activeCPs.add(acpv);
                                                                            }
                                                                        }
                                                                    }
                                                                    
                                                                }
                                                                system.debug('$$$Active CP Versions'+acpvlist);
                                                            }
                                                            
                                                            system.debug('$$$CP Versions'+acpvlist.size());
                                                            /*Find the latest contract option when there are multiple customer purchases coming back*/
                                                            LatestCODates lcd = new LatestCODates();
                                                            lcd = getLatestCODates(acpvlist,cl.EndDate);
                                                            
                                                            cl.LatestCOStartDate = lcd.LatestCOStartDate;
                                                            cl.LatestCOEndDate =  lcd.LatestCOEndDate;
                                                            cl.customerPurchaseId = lcd.customerPurchaseId;

                                                            /*To find the Benefit timeline based on Member and contract option dates*/
                                                            cl.BenEffectiveDate = getBenefitEffectiveDate(cl.EffectiveDate,cl.LatestCOStartDate);
                                                            cl.BenEndDate = getBenefitEndDate(cl.EndDate,cl.LatestCOEndDate);
                                                            
                                                            
                                                            system.debug('$$$Check II 3'+cl.BenEffectiveDate+'//'+cl.BenEndDate +'///'+cl.EffectiveDate+'??'+cl.LatestCOStartDate+'///'+cl.EndDate+'??'+cl.LatestCOEndDate);
                                                            
                                                            cl.isPreferred = False;                                 
                                                            string coverageBenefitPlanId;
                                                            coverageBenefitPlanId = (cl.benefitPlanId != null && cl.benefitPlanId != '' )?(cl.benefitPlanId.length()>=2?cl.benefitPlanId.toLowerCase().subString(0,2):''):'';
                                                            system.debug('------------>'+membership.sourceSysCode.equalsIgnoreCase('CR')+'===========>'+ c.coverageTypeDescription.equalsIgnoreCase('MEDICAL')+'------->'+cl.isActive+'--------->'+ coverageBenefitPlanId );
                                                            //Preferred Coverage 
                                                            if(membership.sourceSysCode.equalsIgnoreCase('CR') && c.coverageTypeDescription.equalsIgnoreCase('MEDICAL') && (coverageBenefitPlanId != 'mr' &&  cl.isEnrollee ) ){ 
                                                                cl.isPreferred= isPreferredCoverageForDualMedical(membership.sourceSysCode, c.coverageTypeDescription, true, c.membershipEffectiveDate, dateToCompare,cl.benefitPlanId,cl.GroupNumber  );                                                           
                                                                if( dateToCompare == null || cl.isPreferred){
                                                                    dateToCompare = c.membershipEffectiveDate; //dateToCompare == null ||
                                                                }
                                                                //coverageCount += 1;
                                                                
                                                            }
                                                            
                                                            if(cl.isPreferred){
                                                                sr.groupNumberValue = cl.GroupNumber;
                                                                prefferedCovfound = true;
                                                                system.debug('-------PREFERRED COV-3---->');
                                                            }
                                                            if(c.subscriberSystemSpecificIdentifiers != null){
                                                                
                                                                if(!c.subscriberSystemSpecificIdentifiers.isEmpty() ){ 
                                                                    for(ACETLGT_FindIndMembershipsJSON2Apex.Identifiers sssi : c.subscriberSystemSpecificIdentifiers){
                                                                        if(sssi.type_z == 'subscriberSurrogateKey'){
                                                                            cl.SurrogateKey = sssi.id; 
                                                                            system.debug('---------cl.SurrogateKey----->'+cl.SurrogateKey);
                                                                            cl.EnrolleeSurrogateKey = sr.EnrolleeSurrogateKey;
                                                                            system.debug('---------cl.EnrolleeSurrogateKey----->'+cl.EnrolleeSurrogateKey);
                                                                        }
                                                                    }
                                                                }
                                                            } 
                                                            if(cl.CoverageTypeCode == 'RX')
                                                                sr.PharmacyCoverageLines.add(cl);
                                                            else if(cl.CoverageTypeCode == 'M')
                                                                sr.MedicalCoverageLines.add(cl);
                                                            system.debug('----cl---->>'+cl.isPreferred);
                                                            
                                                        }//Rider If
                                                    }
                                                    
                                                }
                                                else{
                                                    membership.coverages.sort();
                                                    for(ACETLGT_FindIndMembershipsJSON2Apex.Coverages c : membership.coverages){
                                                        ACETLGT_MemberSearchCoveragesResult.CoverageLine cl = new ACETLGT_MemberSearchCoveragesResult.CoverageLine();
                                                        cl.riderOnlyIndicator = (c.benefit != null && c.benefit.riderOnlyIndicator!= null)?c.benefit.riderOnlyIndicator:'';
                                                        cl.CoverageTypeCode = (c.coverageType!= null)?c.coverageType:'';
                                                        cl.bookOfBusinessTypeCode = (c.benefit!=null && c.benefit.bookOfBusinessTypeCode!=null)?c.benefit.bookOfBusinessTypeCode:'';
                                                        if(cl.riderOnlyIndicator == 'N' || cl.riderOnlyIndicator == 'Y' && cl.CoverageTypeCode == 'RX'){
                                                            cl.pharmacyIndicator = 'No';
                                                            cl.isEnrollee =false;
                                                            cl.CoverageType = (c.coverageTypeDescription!=null)?c.coverageTypeDescription:'';
                                                            cl.CoverageTypeCode = (c.coverageType!= null)?c.coverageType:'';
                                                            cl.CoverageLevel = (c.coverageLevelCode!= null)?c.coverageLevelCode:'';
                                                            cl.EffectiveDate = String.isNotBlank(c.membershipEffectiveDate)?formatDate(c.membershipEffectiveDate):'';
                                                            cl.EndDate = String.isNotBlank(c.membershipExpirationDate)?formatDate(c.membershipExpirationDate):''; 
                                                            cl.PolicyNumber = (c.legacyAttributes!=null && c.legacyAttributes.policyNumber != null)?c.legacyAttributes.policyNumber:'';
                                                            cl.GroupName = (c.GroupName!= null)?c.GroupName:'';
                                                            cl.GroupNumber = (c.groupNumber!= null)?c.groupNumber:'';
                                                            cl.Product = (c.product!=null && c.product.productName!= null)?c.product.productName:'';
                                                            cl.ProductType = (c.product!=null && c.product.productType!=null)?c.product.productType:'';
                                                            cl.relationShipCode=(c.relationshipCode!= null)?c.relationshipCode:'';
                                                            if(c.relationshipCode=='18'){
                                                                isSelf=True;
                                                            }
                                                            
                                                            if(membership.identifiers!=null){
                                                                for(ACETLGT_FindIndMembershipsJSON2Apex.Identifiers identifierDtl : membership.identifiers){
                                                                    if(identifierDtl.type_Z == 'MCH'){
                                                                        cl.memberId = identifierDtl.id; 
                                                                        if(identifierDtl.id == sr.selectedMemberId){  //Check Condition
                                                                            cl.isEnrollee=True;
                                                                        }   
                                                                    }  
                                                                    
                                                                }
                                                            } // End of identifiers
                                                            
                                                            Date todaydate = (Date) date.today();
                                                            Date EffectiveDate = String.isNotBlank(c.membershipEffectiveDate)?(Date) date.parse(formatDate(c.membershipEffectiveDate)):null;
                                                            if(EffectiveDate!=null){
                                                                if(todaydate <= EffectiveDate)
                                                                    cl.DaysGap =  todaydate.daysBetween(EffectiveDate ) ;
                                                                else
                                                                    cl.DaysGap =  EffectiveDate.daysBetween(todaydate) ;
                                                            }
                                                            cl.SourceCode = (membership.sourceSysCode != null)?membership.sourceSysCode:'';
                                                            cl.isActive = isActiveCoverage(cl.EffectiveDate, cl.EndDate);
                                                            cl.isFuture = Date.Parse(cl.EffectiveDate) > Date.today() ? True : False;
                                                            cl.isTermed = (cl.EndDate != null && cl.EndDate != '' && cl.EndDate!='12/31/9999' && Date.Parse(cl.EndDate) < Date.today() )? True : False;
                                                            cl.accumAsOfDate = (cl.isTermed?cl.EndDate:(cl.isFuture?cl.EffectiveDate:String.ValueOf(todaydate)));
                                                            cl.benefitPlanId = (c.benefit != null && c.benefit.benefitPlanId != null)?c.benefit.benefitPlanId:'';
                                                            
                                                            //FIM Enhancement - Abhinav Balla
                                                            cl.benefitPlanName= (c.benefit != null && c.benefit.benefitPlanName!= null)?c.benefit.benefitPlanName:'';
                                                            cl.planOptionID= (c.benefit != null && c.benefit.planOptionID!= null)?c.benefit.planOptionID:'';
                                                            cl.riderOnlyIndicator = (c.benefit != null && c.benefit.riderOnlyIndicator!= null)?c.benefit.riderOnlyIndicator:'';
                                                            system.debug('$$$$$'+cl.planOptionID+cl.riderOnlyIndicator);
                                                            list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions> acpvlist = new list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions>();
                                                            /*Collect all the active customer purchase versions*/
																cl.activeCPs = new list<ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions>();		
                                                            if(c.benefit!= null && c.benefit.customerPurchase != null){
                                                                for(ACETLGT_FindIndMembershipsJSON2Apex.CustomerPurchase cp : c.benefit.customerPurchase){
                                                                    if(cp.customerPurchaseVersions != null){
                                                                        system.debug('$$$$$ Inside CP');
                                                                        
                                                                        for(ACETLGT_FindIndMembershipsJSON2Apex.CustomerPurchaseVersions cpv : cp.customerPurchaseVersions ){
                                                                            if(cpv.customerPurchaseStatusDescription == 'Active'){
                                                                                ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions acpv = new ACETLGT_MemberSearchCoveragesResult.ActiveCPVersions();
                                                                                system.debug('$$$$$ InsideActive CPV');
                                                                                
                                                                                acpv.contractOptionStartDate = String.isNotBlank(cpv.contractOptionStartDate)?formatDate(cpv.contractOptionStartDate):'' ;
                                                                                acpv.contractOptionEndDate = String.isNotBlank(cpv.contractOptionEndDate)?formatDate(cpv.contractOptionEndDate):'';
                                                                                acpv.customerPurchaseId = String.isNotBlank(cp.customerPurchaseId)?cp.customerPurchaseId:'' ;
                                                                                
                                                                                acpvlist.add(acpv);
																				     cl.activeCPs.add(acpv);
                                                                            }
                                                                        }
                                                                    }
                                                                    
                                                                }
                                                                system.debug('$$$Active CP Versions'+acpvlist);
                                                            }
                                                            
                                                            system.debug('$$$CP Versions'+acpvlist.size());
                                                            /*Find the latest contract option when there are multiple customer purchases coming back*/
                                                            LatestCODates lcd = new LatestCODates();
                                                            lcd = getLatestCODates(acpvlist,cl.EndDate);
                                                            
                                                            cl.LatestCOStartDate = lcd.LatestCOStartDate;
                                                            cl.LatestCOEndDate =  lcd.LatestCOEndDate;
                                                            cl.customerPurchaseId = lcd.customerPurchaseId;

                                                            /*To find the Benefit timeline based on Member and contract option dates*/
                                                            cl.BenEffectiveDate = getBenefitEffectiveDate(cl.EffectiveDate,cl.LatestCOStartDate);
                                                            cl.BenEndDate = getBenefitEndDate(cl.EndDate,cl.LatestCOEndDate);
                                                            
                                                            system.debug('$$$Check II 4'+cl.BenEffectiveDate+'//'+cl.BenEndDate +'///'+cl.EffectiveDate+'??'+cl.LatestCOStartDate+'///'+cl.EndDate+'??'+cl.LatestCOEndDate);
                                                            
                                                            cl.isPreferred = False;                                 
                                                            string coverageBenefitPlanId;
                                                            coverageBenefitPlanId = (cl.benefitPlanId != null && cl.benefitPlanId != '' )?(cl.benefitPlanId.length()>=2?cl.benefitPlanId.toLowerCase().subString(0,2):''):'';
                                                            system.debug('------------>'+membership.sourceSysCode.equalsIgnoreCase('CR')+'===========>'+ c.coverageTypeDescription.equalsIgnoreCase('MEDICAL')+'------->'+cl.isActive+'--------->'+ coverageBenefitPlanId );
                                                            //Preferred Coverage 
                                                            if(membership.sourceSysCode.equalsIgnoreCase('CR') && c.coverageTypeDescription.equalsIgnoreCase('MEDICAL') && (coverageBenefitPlanId != 'mr') && cl.isEnrollee ){ 
                                                                cl.isPreferred= isPreferredCoverage(membership.sourceSysCode, c.coverageTypeDescription, true , c.membershipEffectiveDate, dateToCompare,cl.benefitPlanId,cl.GroupNumber  );                                                           
                                                                if( dateToCompare == null || cl.isPreferred){
                                                                    dateToCompare = c.membershipEffectiveDate; //dateToCompare == null ||
                                                                }
                                                                if(cl.isPreferred){
                                                                    sr.groupNumberValue = cl.GroupNumber;
                                                                    prefferedCovfound = true;
                                                                    system.debug('-------PREFERRED COV-4---->');
                                                                }
                                                                //coverageCount += 1;
                                                            }
                                                            
                                                            if(c.subscriberSystemSpecificIdentifiers != null){
                                                                
                                                                if(!c.subscriberSystemSpecificIdentifiers.isEmpty() ){ 
                                                                    for(ACETLGT_FindIndMembershipsJSON2Apex.Identifiers sssi : c.subscriberSystemSpecificIdentifiers){
                                                                        if(sssi.type_z == 'subscriberSurrogateKey'){
                                                                            cl.SurrogateKey = sssi.id; 
                                                                            system.debug('---------cl.SurrogateKey----->'+cl.SurrogateKey);
                                                                            cl.EnrolleeSurrogateKey = sr.EnrolleeSurrogateKey;
                                                                            system.debug('---------cl.EnrolleeSurrogateKey----->'+cl.EnrolleeSurrogateKey);
                                                                        }
                                                                    }
                                                                }
                                                            } 
                                                            if(cl.isPreferred){
                                                                sr.groupNumberValue = cl.GroupNumber;
                                                                prefferedCovfound = true;
                                                            }
                                                            if(cl.CoverageTypeCode == 'RX')
                                                                sr.PharmacyCoverageLines.add(cl);
                                                            else if(cl.CoverageTypeCode == 'M')
                                                                sr.MedicalCoverageLines.add(cl);
                                                            
                                                            //system.debug('----cl---->>'+covLines);
                                                            
                                                        }//Rider If
                                                        
                                                    }
                                                }  
                                                
                                            }//End if - coverages
                                            
                                        }
                                        
                                    }
                                    
                                    sr.SurrogateKey = (sr.EnrolleeSurrogateKey != null)?sr.EnrolleeSurrogateKey:'';
                                    system.debug('----v.SRK----->>'+sr.SurrogateKey); 
                                }
                                randomSRK ++;
                                system.debug('232323 SurrogateKeys:::'+sr.SurrogateKeys);   
                                
                                system.debug('Covcovcov RX:::'+sr.PharmacyCoverageLines);   
                                system.debug('Covcovcov MED:::'+sr.MedicalCoverageLines);   
                                
                                if(sr.MedicalCoverageLines.size() > 0){
                                    for(ACETLGT_MemberSearchCoveragesResult.CoverageLine mhc:sr.MedicalCoverageLines) {
                                        system.debug(':::'+mhc.effectiveDate+mhc.GroupNumber);
                                        ACETLGT_MemberSearchCoveragesResult.CoverageLine temp = new ACETLGT_MemberSearchCoveragesResult.CoverageLine();
                                        if(sr.PharmacyCoverageLines.size() > 0){
                                            for(ACETLGT_MemberSearchCoveragesResult.CoverageLine phc:sr.PharmacyCoverageLines) {
                                                system.debug(':::'+mhc.effectiveDate+mhc.GroupNumber);
                                                system.debug(':::'+phc.effectiveDate+phc.GroupNumber);
                                                if(phc.GroupNumber != mhc.GroupNumber){
                                                    system.debug('Inside No Rx for the group ::: NOT matched');
                                                    temp = mhc;
                                                    temp.pharmacyIndicator = 'No';
                                                }
                                                else{
							if(phc.EffectiveDate == mhc.EffectiveDate){
								system.debug(':::MATCHED');
								temp=mhc;
								temp.pharmacyIndicator = 'Yes';
								break;
							}else{
								system.debug(':::Same Group No Rx:: NOT MATCHED');
								temp = mhc;
								temp.pharmacyIndicator = 'No';
							}
						}
                                            }
                                            sr.CoverageLines.add(temp);
                                        }
                                        else{
                                            ACETLGT_MemberSearchCoveragesResult.CoverageLine tmp = new ACETLGT_MemberSearchCoveragesResult.CoverageLine();
                                                    tmp = mhc;
                                                    tmp.pharmacyIndicator = 'No';
                                            		system.debug('????? Adding without Rx indicator'+tmp);
                                                    sr.CoverageLines.add(tmp);
                                        }
                                    }
                                    
                                }
                                
                                
                                system.debug('Covcovcov FInal:::'+sr.CoverageLines);   
                                
                                sr.CoverageLines.sort();
                                memberSearchResult.add(sr);
                                
                            }
                            
                            system.debug('>>>'+memberSearchResult.size());
                            SYSTEM.DEBUG(memberSearchResult[0]);
                            
                            
                            searchResult.Success = true;
                            searchResult.Message = '';
                            searchResult.Response = memberSearchResult;
                        }
                        
                    }                 
                }else if(response.getStatusCode() == 404){                
                    searchResult.Success = false;                
                    searchResult.Response = new List<ACETLGT_MemberSearchCoveragesResult>();
                    searchResult.Message = 'Search criteria returned no matches.';                
                    searchResult.recordCount = '0';                
                    system.debug(searchResult);                
                }else {
                    searchResult = ParseFailureResponse(response); 
                    searchResult.Message = 'Problem with FindIndividual Webservice: ' + searchResult.Message;                              
                    //searchResult.MessageSeverity = ApexPages.Severity.ERROR;
                    searchResult.Success = false;                                                             
                    searchResult.recordCount = '0';                
                    system.debug(searchResult);                
                }
                
            }
            else{//when response is null
                //searchResult.MessageSeverity = ApexPages.Severity.ERROR;
                searchResult.Success = false;
                searchResult.Message = 'Web Service or External System is temporarily unavailable.';
                searchResult.recordCount = '0';
                searchResult.statusCode=999;
            }
            //End
        }catch(Exception e){
            system.debug(e.getStackTraceString());
            //searchResult.MessageSeverity = ApexPages.Severity.ERROR;
            searchResult.Success = false;
            searchResult.Message = 'Web Service or External System is temporarily unavailable.';
            searchResult.recordCount = '0';
            searchResult.statusCode=999;       
            
        }
        
        return searchResult;        
        
    }
    
    //to be moved to global util class, used for formatting the date to be sent over request
    public String formatDate(String dateString){
        try{
            if(dateString == null) return null;
            
            List<String> dateParts = dateString.split('-');
            if(dateParts!=null && dateParts.size() == 3){
                String mm = dateParts[1];
                String dd = dateParts[2];
                String yyyy = dateParts[0];
                
                mm = mm.contains('0') && mm.indexOf('0') == 0 ? mm.replace('0','') : mm ; 
                dd = dd.contains('0') && dd.indexOf('0') == 0 ? dd.replace('0','') : dd; 
                
                return mm  + '/' + dd + '/' + yyyy;
            }else{
                return dateString;
            }
        }
        catch(Exception e){
            System.debug('Exception occured='+e);
            return null;
        }
    }  
    //method to choose preffered coverage
    private boolean isPreferredCoverage(String sourceCode, String coverageType, boolean isActive, String effDateStr, String dateToCompare,String planBenefitIdCov, string groupNumber){ //, String relationshipCode
        try{  
            system.debug(sourceCode+' --::-- '+coverageType+' :: '+isActive+ ' :: '+effDateStr +' :: '+dateToCompare); //' :: '+relationshipCode
            String covBenefitPlanId,GroupFlowGroupNum;
            string fromGroupDetail = '1';//apexPages.currentpage().getparameters().get('fromGroupDetail');
            string URL = '';
            system.debug('URL@@@ ' + URL);
            if(String.isNotBlank(URL)){
                /*integer strStart = URL.indexOf('groupFlowGroupNumber%22%3A%22');
                integer strEnd = URL.indexOf('groupFlowGroupName');
                system.debug('-------URL-----'+URL);
                system.debug('-------strpos -----'+strStart+'==='+strEnd);
                if(strStart != -1 && strEnd != -1 )
                    GroupFlowGroupNum = URL.substring(strStart + 29 , strEnd - 9);
                else
                    GroupFlowGroupNum = '';
                system.debug('-----GroupFlowGroupNum-----'+ GroupFlowGroupNum);*/
            }
            if(planBenefitIdCov != null && planBenefitIdCov != '' )
                covBenefitPlanId = (planBenefitIdCov.length() >= 2 )?planBenefitIdCov.toLowerCase().subString(0,2):'';
            if(fromGroupDetail != null && fromGroupDetail != '' && GroupFlowGroupNum != null && GroupFlowGroupNum != '' ){
                /*if( sourceCode.equalsIgnoreCase('CR') && coverageType.equalsIgnoreCase('MEDICAL') && isActive && (covBenefitPlanId != 'mr') && groupNumber == GroupFlowGroupNum){ //relationshipCode.equalsIgnoreCase('18') &&
                    Date effDate =  effDateStr != null && effDateStr != '9999-12-31'? Date.parse(ACETLGT_Utility.formatDateFromDashToSlash(effDateStr)) : null;
                    Date tempDate=  dateToCompare != null && dateToCompare != '9999-12-31'? Date.parse(ACETLGT_Utility.formatDateFromDashToSlash(dateToCompare)) : null;
                    if(tempDate == null){
                        return true;
                    }else if(effDate > tempDate){
                        system.debug('----TRUE ------');
                        return false;
                    }
                    
                }*/
            }else if( sourceCode.equalsIgnoreCase('CR') && coverageType.equalsIgnoreCase('MEDICAL') && isActive && (covBenefitPlanId != 'mr') ){ //relationshipCode.equalsIgnoreCase('18') &&
                Date effDate =  effDateStr != null && effDateStr != '9999-12-31'? Date.parse(ACETLGT_Utility.formatDateFromDashToSlash(effDateStr)) : null;
                Date tempDate=  dateToCompare != null && dateToCompare != '9999-12-31'? Date.parse(ACETLGT_Utility.formatDateFromDashToSlash(dateToCompare)) : null;
                
                if(tempDate == null){
                    return true;
                }else if(effDate > tempDate){
                    system.debug('----TRUE ------');
                    return true;
                }else if(tempDate == effDate){
                    system.debug('----TRUE ------');
                    return true;
                }
                
            }
            return false; 
        }catch(Exception e){
            return false;
        }
    }
    private boolean isPreferredCoverageForDualMedical(String sourceCode, String coverageType, boolean isActive, String effDateStr, String dateToCompare,String planBenefitIdCov, string groupNumber){ //, String relationshipCode
        try{  
            system.debug(sourceCode+' --::-- '+coverageType+' :: '+isActive+ ' :: '+effDateStr +' :: '+dateToCompare); //' :: '+relationshipCode
            String covBenefitPlanId,GroupFlowGroupNum;
            string fromGroupDetail = '1';//apexPages.currentpage().getparameters().get('fromGroupDetail');
            string URL = '';
            system.debug('URL@@@ ' + URL);
            if(String.isNotBlank(URL)){
                /*integer strStart = URL.indexOf('groupFlowGroupNumber%22%3A%22');
                integer strEnd = URL.indexOf('groupFlowGroupName');
                system.debug('-------URL-----'+URL);
                system.debug('-------strpos -----'+strStart+'==='+strEnd);
                if(strStart != -1 && strEnd != -1 )
                    GroupFlowGroupNum = URL.substring(strStart + 29 , strEnd - 9);
                else
                    GroupFlowGroupNum = '';
                system.debug('-----GroupFlowGroupNum-----'+ GroupFlowGroupNum);*/
            }
            if(planBenefitIdCov != null && planBenefitIdCov != '' )
                covBenefitPlanId = (planBenefitIdCov.length() >= 2 )?planBenefitIdCov.toLowerCase().subString(0,2):'';
            if(fromGroupDetail != null && fromGroupDetail != '' && GroupFlowGroupNum != null && GroupFlowGroupNum != '' ){
                /*if( sourceCode.equalsIgnoreCase('CR') && coverageType.equalsIgnoreCase('MEDICAL') && isActive && (covBenefitPlanId != 'mr') && groupNumber == GroupFlowGroupNum){ //relationshipCode.equalsIgnoreCase('18') &&
                    Date effDate =  effDateStr != null && effDateStr != '9999-12-31'? Date.parse(ACETLGT_Utility.formatDateFromDashToSlash(effDateStr)) : null;
                    Date tempDate=  dateToCompare != null && dateToCompare != '9999-12-31'? Date.parse(ACETLGT_Utility.formatDateFromDashToSlash(dateToCompare)) : null;
                    if(tempDate == null){
                        return true;
                    }else if(effDate > tempDate){
                        system.debug('----TRUE ------');
                        return false;
                    }
                    
                }*/
            }else if( sourceCode.equalsIgnoreCase('CR') && coverageType.equalsIgnoreCase('MEDICAL') && isActive && (covBenefitPlanId != 'mr') ){ //relationshipCode.equalsIgnoreCase('18') &&
                Date effDate =  effDateStr != null && effDateStr != '9999-12-31'? Date.parse(ACETLGT_Utility.formatDateFromDashToSlash(effDateStr)) : null;
                Date tempDate=  dateToCompare != null && dateToCompare != '9999-12-31'? Date.parse(ACETLGT_Utility.formatDateFromDashToSlash(dateToCompare)) : null;
                if(tempDate == null){
                    return true;//true;
                }else if(effDate > tempDate){
                    system.debug('----TRUE ------');
                    return false;
                }else if(effDate == tempDate){
                    system.debug('----TRUE ------');
                    return true;
                }
                
            }
            return false; 
        }catch(Exception e){
            return false;
        }
    }
    private boolean isPreferredCoverageForNoActive(String sourceCode, String coverageType, boolean isActive, String effDateStr, String dateToCompare,String planBenefitIdCov, string groupNumber){ 
        try{  
            system.debug(sourceCode+' --::-- '+coverageType+' :: '+isActive+ ' :: '+effDateStr +' :: '+dateToCompare); //' :: '+relationshipCode
            String covBenefitPlanId,GroupFlowGroupNum;
            string fromGroupDetail = '1';//apexPages.currentpage().getparameters().get('fromGroupDetail');
            string URL = '';
            system.debug('URL@@@ ' + URL);
            if(String.isNotBlank(URL)){
                /*integer strStart = URL.indexOf('groupFlowGroupNumber%22%3A%22');
                integer strEnd = URL.indexOf('groupFlowGroupName');
                system.debug('-------URL-----'+URL);
                system.debug('-------strpos -----'+strStart+'==='+strEnd);
                if(strStart != -1 && strEnd != -1 )
                    GroupFlowGroupNum = URL.substring(strStart + 29 , strEnd - 9);
                else
                    GroupFlowGroupNum = '';
                system.debug('-----GroupFlowGroupNum-----'+ GroupFlowGroupNum);*/
            }
            if(planBenefitIdCov != null && planBenefitIdCov != '' )
                covBenefitPlanId = (planBenefitIdCov.length() >= 2 )?planBenefitIdCov.toLowerCase().subString(0,2):'';
            if(fromGroupDetail != null && fromGroupDetail != '' && GroupFlowGroupNum != null && GroupFlowGroupNum != '' ){
                /*if( sourceCode.equalsIgnoreCase('CR') && coverageType.equalsIgnoreCase('MEDICAL') && isActive && (covBenefitPlanId != 'mr') && groupNumber == GroupFlowGroupNum){ //relationshipCode.equalsIgnoreCase('18') &&
                    Date effDate =  effDateStr != null && effDateStr != '9999-12-31'? Date.parse(ACETLGT_Utility.formatDateFromDashToSlash(effDateStr)) : null;
                    Date tempDate=  dateToCompare != null && dateToCompare != '9999-12-31'? Date.parse(ACETLGT_Utility.formatDateFromDashToSlash(dateToCompare)) : null;
                    if(tempDate == null){
                        return true;
                    }else if(effDate > tempDate){
                        system.debug('----TRUE ------');
                        return true;
                    }
                    
                }*/
            }else if( sourceCode.equalsIgnoreCase('CR') && coverageType.equalsIgnoreCase('MEDICAL') && isActive && (covBenefitPlanId != 'mr') ){ //relationshipCode.equalsIgnoreCase('18') &&
                Date effDate =  effDateStr != null && effDateStr != '9999-12-31'? Date.parse(ACETLGT_Utility.formatDateFromDashToSlash(effDateStr)) : null;
                Date tempDate=  dateToCompare != null && dateToCompare != '9999-12-31'? Date.parse(ACETLGT_Utility.formatDateFromDashToSlash(dateToCompare)) : null;
                if(tempDate == null){
                    return true;//true;
                }else if(effDate > tempDate){
                    system.debug('----TRUE ------');
                    return false;
                }else if(effDate == tempDate){
                    system.debug('----TRUE ------');
                    return false;
                }
                
            }
            return false; 
        }catch(Exception e){
            return false;
        }
    }
    /*private boolean isActiveCoverage(String effDateStr, String endDateStr,String test){
        try{
            Date effDate =  Date.parse(ACETLGT_Utility.formatDateFromDashToSlash(effDateStr));
            if(Integer.valueOf(endDateStr.split('-')[0]) >= effdate.year()){
                return true;
            }
            
            Date endDate =  Date.parse(ACETLGT_Utility.formatDateFromDashToSlash(endDateStr));
            if(Date.today() > effDate && Date.today() <= endDate ){
                return true;
            }
            return false;
        }catch(Exception e){
            return false;
        }
    } */
    //method to check for active coverage
    public Boolean isActiveCoverage(String EffectiveDate, String EndDate){
        if(String.isEmpty(EffectiveDate) || String.isEmpty(EndDate)) return false; 
        
        Date objEffectiveDate = Date.newInstance(Integer.valueOf(EffectiveDate.split('/')[2]), Integer.valueOf(EffectiveDate.split('/')[0]), Integer.valueOf(EffectiveDate.split('/')[1]));
        Date objEndDate = Date.newInstance(Integer.valueOf(EndDate.split('/')[2]), Integer.valueOf(EndDate.split('/')[0]), Integer.valueOf(EndDate.split('/')[1]));
        
        return (Date.today() >= objEffectiveDate) && (Date.today() <= objEndDate);
    }             
    /*public Integer calculateDaysGap(Date EffectiveDate, Date EndDate){
        
        Integer daysEff;
        Integer daysEnd;
        
        
        daysEff = EffectiveDate.daysBetween(Date.today()) ;
        
        daysEnd = EndDate.daysBetween(Date.today()) ;
        
        if(daysEff > daysEnd)
            return daysEnd;
        else
            return daysEff; 
        
    }
    public class ActiveCovg implements Comparable{
        public String groupnumber{get;set;}
        public Date objeffectivedate{get;set;}
        public Date objenddate{get;set;}
        public ACETMemberDetail.CoverageLine covg{get;set;}
        
        public Integer compareTo(Object compareTo){
            ActiveCovg compareToAct = (ActiveCovg)compareTo;
            
            if(objenddate > compareToAct.objenddate){
                return 1;
            }
            return -1;
        }
    }
    public class FutureCovg implements Comparable{
        public String groupnumber{get;set;}
        public Date objeffectivedate{get;set;}
        public Date objenddate{get;set;}
        public ACETMemberDetail.CoverageLine covg{get;set;}
        
        public Integer compareTo(Object compareTo){
            FutureCovg compareToFut = (FutureCovg)compareTo;
            
            if(objeffectivedate > compareToFut.objeffectivedate){
                return 1;
            }
            return -1;
        }
    }
    public class TermedCovg implements Comparable{
        public String groupnumber{get;set;}
        public Date objeffectivedate{get;set;}
        public Date objenddate{get;set;}
        public ACETMemberDetail.CoverageLine covg{get;set;}
        
        public Integer compareTo(Object compareTo){
            TermedCovg compareToTerm = (TermedCovg)compareTo;
            
            if(objenddate < compareToTerm.objenddate){
                return 1;
            }
            return -1;
        }
    }*/

    public static ACETWSCalloutResult findIndividualMembershipDashboard(String memId){
        String reqBody =   '{"findIndividualMembershipsRequest": {"searchId": "'+memId+'","searchTypeCode": "","firstName": "","lastName": "",'
            			+'"birthDate": "","stateCode": "","postalCode": "","effectiveStartDate": "1800-01-01","effectiveEndDate": "9999-12-31"}}';

        system.debug('$$$$$$'+reqBody);
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('FindIndividualMemberships',reqBody,null);
        System.debug('history controller  : ' + wsCallOutFW);
        HttpResponse response = wsCallOutFW.getResponse();

        ACETWSCalloutResult coResult= new ACETWSCalloutResult();
        coResult.responseBody = response.getBody();
        coResult.statusCode = response.getStatusCode();
        return coResult;

    }
}