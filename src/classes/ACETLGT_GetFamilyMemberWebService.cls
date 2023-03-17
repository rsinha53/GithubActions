public class ACETLGT_GetFamilyMemberWebService extends ACETWebService{
    public Map<String,String> coverageTypeVsDescMap;
    private Map<String,String> EligibilityCodeVsStatusMap;
    public Map<String,String> primaryIndicatorVsDescMap;
    private Map<String,String> PlanTypeCodeMap;
    public ACETLGT_GetFamilyMemberWebService(){
        if(!Test.isRunningTest()){
        super('Stargate');
        }   
        coverageTypeVsDescMap = new Map<String,String>();
        coverageTypeVsDescMap.put('1','Commercial');
        coverageTypeVsDescMap.put('2','Government');
        coverageTypeVsDescMap.put('3','Motor Vehicle Accident');
        coverageTypeVsDescMap.put('4','Worker\'s Compensation');
        coverageTypeVsDescMap.put('5','Other');
        
        primaryIndicatorVsDescMap = new Map<String,String>();
        primaryIndicatorVsDescMap.put('P','Primary');
        primaryIndicatorVsDescMap.put('S','Secondary');
        primaryIndicatorVsDescMap.put('T','Teritiary');
        primaryIndicatorVsDescMap.put('U','Unknown');
        
        EligibilityCodeVsStatusMap = new Map<String,String>();
        EligibilityCodeVsStatusMap.put('A','ACTIVE');
        EligibilityCodeVsStatusMap.put('C','COBRA');
        EligibilityCodeVsStatusMap.put('S','SURVINING INSURED');
        EligibilityCodeVsStatusMap.put('T','TEFRA');
        EligibilityCodeVsStatusMap.put('','');
        
        //  US:2141411 - Plan Type changes
        PlanTypeCodeMap = new Map<String,String>();
        PlanTypeCodeMap.put('01','EPO');
        PlanTypeCodeMap.put('02','HMO');
        PlanTypeCodeMap.put('03','Indemnity');
        PlanTypeCodeMap.put('05','POS');
        PlanTypeCodeMap.put('06','PPO');
    }
    public override void getEndpoint(){
        GetEndpointDetail('GetFamilyMembersEndpoint');
    }
    public void getRequestBody(String identifier,String groupNumber,String effectiveDate){
        effectiveDate = String.valueOf(effectiveDate); 
        RequestBody = '{"getFamilyMembershipRequest": {"identifier": "'+identifier+'","identifierType": "SRK","groupNumber": "'+groupNumber+'","membershipEffectiveDate": "'+effectiveDate+'","noTimeBound": "TRUE"}}';  
    	
    } 
    private String getValueAfterStringValidation(String inputStr, String outputStr)
    {
        return String.isBlank(inputStr) ? outputStr : inputStr;
    }
    private void getPCPNameAndId(ACETLGT_GetFamilyMembershipJson2Apex.cls_providers provider, ACETLGT_MemberSearchCoveragesResult.PCPAssignment pcp)
    {
        if(pcp.assignmentLevel.equals('01'))
        {
            pcp.FirstName = getValueAfterStringValidation(provider.firstName, '');  
            pcp.LastName = getValueAfterStringValidation(provider.lastName, '');
            pcp.locationAffiliationID = getValueAfterStringValidation(provider.locationAffiliationID, '');
        }
        else if(pcp.assignmentLevel.equals('02'))
        {
            pcp.organizationName = getValueAfterStringValidation(provider.organizationName, '');
            pcp.organizationId = getValueAfterStringValidation(provider.organizationId, '');
        }
    }
    private void addPCP(ACETLGT_MemberSearchCoveragesResult.PCPAssignment pcp, ACETLGT_MemberSearchCoveragesResult.FamilyMember fm, String memberId, ACETLGT_MemberSearchCoveragesResult memberDetail)
    {
        if(pcp.FirstName != '' && pcp.LastName != '' && pcp.pcpAssignmentType != '' && fm.subscriberIndividualId == memberId)
            memberDetail.PCPAssignments.add(pcp);
        else if(!pcp.organizationName.equals('') && !pcp.organizationId.equals('') && fm.subscriberIndividualId == memberId)
            memberDetail.PCPAssignments.add(pcp);
    }
    public ACETWSCalloutResult getFamilyMembers(String srk,String Esrk, String groupNumber, String effectiveDate,string endDate, string benefitPlanId, ACETLGT_MemberSearchCoveragesResult memberDetail, string memberId){  //
        system.debug('======srk====>>'+srk+endDate);
        
        system.debug('~~~---2---memberId----->>'+memberId);
        
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        if(memberDetail == null){
            memberDetail = new ACETLGT_MemberSearchCoveragesResult();
        }
        
        try{
            getEndpoint();
          
            GetRequestBody(srk, groupNumber, ACETWebServicehelper.formatToYYYYMMDD(effectiveDate));
            HttpResponse response = Send(OAuthConfig);
            system.debug('2323response'+response);
            //response.setStatusCode(500);
            if(response!=null){
                calloutResult.statusCode=response.getStatusCode();
                if(response.getStatusCode() == 200){
                    if(response.getBody() != null){
                        //replace date with date2 as date is a preserved keyword
                        String responseBody = response.getBody().contains('\"date\":')?response.getBody().replace('\"date\":', '\"date2\":'):response.getBody();
                        responseBody = response.getBody().contains('\"type\":')?response.getBody().replace('\"type\":', '\"type_z\":'):response.getBody();
                        responseBody = responseBody.replace('\"id\":', '\"id_z\":');
                        //replace desc with desc2 as desc is a preserved keyword
                        responseBody = response.getBody().contains('\"date\":')?responseBody.replace('\"desc\":', '\"desc2\":'):response.getBody();
                        system.debug('responseBody-->'+responseBody);
                        ACETLGT_GetFamilyMembershipJson2Apex jSON2Apex = (ACETLGT_GetFamilyMembershipJson2Apex)JSON.deserialize(responseBody, ACETLGT_GetFamilyMembershipJson2Apex.class);
                        system.debug('jSON2Apex -->'+jSON2Apex);                    
                        memberDetail.FamilyMembers = new List<ACETLGT_MemberSearchCoveragesResult.FamilyMember>();
                        memberDetail.PCPAssignments = new List<ACETLGT_MemberSearchCoveragesResult.PCPAssignment>();
                        List<ACETLGT_MemberSearchCoveragesResult.COB> amdlstCOB = new List<ACETLGT_MemberSearchCoveragesResult.COB>();
                        List<ACETLGT_GetFamilyMembershipJson2Apex.cls_individual> famMembers = jSON2Apex!=null?jSON2Apex.getFamilyMembershipResponse!=null?jSON2Apex.getFamilyMembershipResponse.individual:null:null;//
                        if(famMembers!=null && famMembers.size()>0){
                            for(ACETLGT_GetFamilyMembershipJson2Apex.cls_individual individual : famMembers){
                                ACETLGT_MemberSearchCoveragesResult.FamilyMember fm = new ACETLGT_MemberSearchCoveragesResult.FamilyMember();
                                if (individual != null && individual.name != null){
                                    fm.FirstName = String.isNotBlank(individual.name.firstName)?individual.name.firstName:'';
                                    fm.LastName = String.isNotBlank(individual.name.lastName)?individual.name.lastName:'';
                                    fm.MiddleInitial =String.isNotBlank(individual.name.middleName)?individual.name.middleName:'';
                                    fm.suffix = String.isNotBlank(individual.name.nameSuffix)?individual.name.nameSuffix:''; 
                                    fm.fullName = fm.FirstName +' ' + fm.MiddleInitial+ ' '+fm.LastName+ ' ' +fm.suffix;
                                }
                                if (individual != null){ 
                                    
                                    if(individual.membership!=null && individual.membership.size()>0 && 
                                       individual.membership[0] != null && individual.membership[0].identifiers!=null && 
                                       individual.membership[0].identifiers.size()>0 && individual.membership[0].identifiers[0] != null)
                                        fm.FamilyId = individual.membership[0].identifiers[0].id ;
                                    fm.Gender = String.isNotBlank(individual.genderCode)?individual.genderCode:'';
                                    fm.DOB = String.isNotBlank(individual.birthDate)?formatDate(individual.birthDate):'';
                                    fm.Age = String.isNotBlank(individual.birthDate)?getAgeFromBirthday(individual.birthDate):'';
                                    fm.Relationship = String.isNotBlank(individual.relationshipCode)?individual.relationshipCode:'';
                                    fm.EID = String.isNotBlank(individual.individualIdentifier)?individual.individualIdentifier:''; //Added by Swetha//
                                    fm.Relationship = String.isNotBlank(fm.Relationship)?ACETRelationshipCodes__c.getValues(fm.Relationship).Description__c:''; //individual.memberShip.eligibilityRelationshipCode.desc2; 
                                }
                                Integer counter = 0;
                                for(Integer i = 0; i < memberDetail.FamilyMembers.size(); i++){
                                    if(fm.FamilyId <= memberDetail.FamilyMembers[i].FamilyId){
                                        counter = i;
                                        break;
                                    }else if(memberDetail.FamilyMembers[i].FamilyId < fm.FamilyId){
                                        counter = i+1;
                                    }
                                }
                                if(counter <= (memberDetail.FamilyMembers.size() - 1) || (counter < memberDetail.FamilyMembers.size()) && memberDetail.FamilyMembers.size() <= 1)
                                    memberDetail.FamilyMembers.add(counter, fm);
                                else
                                    memberDetail.FamilyMembers.add(fm);
                                
                                if(individual.membership!=null && individual.membership.size()>0){
                                    
                                    for(ACETLGT_GetFamilyMembershipJson2Apex.cls_membership membership : individual.membership){
                                        system.debug('----PCPAssignments---->'+memberDetail.PCPAssignments);
                                        for(ACETLGT_GetFamilyMembershipJson2Apex.cls_cob cob : membership.cob){
                                            Date Startdt = null;
                                            Date Enddt = null;
                                            string LastUpdate = null;
                                            try{
                                                if(String.isNotBlank(cob.otherInsuranceVerifyDate)){
                                                    LastUpdate = formatdate(cob.otherInsuranceVerifyDate); 
                                                }
                                            }
                                            catch(Exception e){
                                                System.debug('Exception happened:'+e);   
                                            }
                                            ACETLGT_MemberSearchCoveragesResult.COB cb = new ACETLGT_MemberSearchCoveragesResult.COB();
                                            
                                            if(individual.name!=null){
                                                cb.Name =String.isNotBlank(individual.name.firstName)?individual.name.firstName:'';
                                                cb.Name =String.isNotBlank(individual.name.lastName)?cb.Name+ ' ' + individual.name.lastName:cb.Name;
                                            }
                                            try{
                                                cb.DateOfBirth = (String.isNotBlank(individual.birthDate)&& individual != null)?formatDate(individual.birthDate):'';
                                            }
                                            catch(Exception e){
                                                System.debug('Exception happened:'+e);   
                                            }
                                            if(!String.isEmpty(cb.DateOfBirth)){
                                                Date dob = Date.parse(cb.DateOfBirth);
                                                Integer days = dob.daysBetween(Date.Today());
                                                Integer age = Integer.valueOf(days/365);
                                                cb.Age = String.valueOf(age);
                                                //cb.BenefitType = String.isNotBlank(cob.cobTypeCodeDescription)?cob.cobTypeCodeDescription:'';
                                            }
                                            if(cob!=null){ 
                                                cb.InsuranceType = String.isNotBlank(cob.cobTypeCodeDescription)?cob.cobTypeCodeDescription:'';
                                                cb.IsOtherInsurancePrimary = String.isNotBlank(cob.otherInsurancePrimacyIndicator)?cob.otherInsurancePrimacyIndicator:'';
                                                system.debug('cobEffectiveStartDate' + cob.cobEffectiveStartDate);
                                                system.debug('cobEffectiveEndDate' + cob.cobEffectiveEndDate);
                                                if(String.isNotBlank(cob.cobEffectiveStartDate)){
                                                    Startdt = Date.ValueOf(cob.cobEffectiveStartDate);
                                                    cb.Startdt = formatDate(cob.cobEffectiveStartDate);
                                                }
                                                if( String.isNotBlank(cob.cobEffectiveEndDate)){
                                                    Enddt = Date.ValueOf(cob.cobEffectiveEndDate); 
                                                    cb.Enddt = formatDate(cob.cobEffectiveEndDate);
                                                }
                                                
                                                //cb.Startdt = Startdt;
                                                //cb.Enddt = Enddt;
                                            }
                                            if(membership.coverages!=null && membership.coverages.size()>0){
                                                for(ACETLGT_GetFamilyMembershipJson2Apex.cls_coverages cov : membership.coverages){
                                                    if(cov.bundleOptions!=null && cov.bundleOptions.size()>0){
                                                        for(ACETLGT_GetFamilyMembershipJson2Apex.cls_bundleOptions bun : cov.bundleOptions){
                                                            if(bun.benefits!=null && bun.benefits.size()>0){
                                                                for(ACETLGT_GetFamilyMembershipJson2Apex.cls_benefits benefits : bun.benefits){
                                                                    system.debug('HEREHEREHERE ' + benefits);
                                                                    System.debug('planType : ' + benefits.planType);
                                                                    
                                                                    cb.Relationship = String.isNotBlank(benefits.relationshipDescription)?benefits.relationshipDescription:''; 
                                                                    fm.Relationship =  String.isNotBlank(benefits.relationshipCode)?benefits.relationshipCode:'';  
                                                                    fm.Relationship = String.isNotBlank(fm.Relationship)?ACETRelationshipCodes__c.getValues(fm.Relationship).Description__c:''; //individual.memberShip.eligibilityRelationshipCode.desc2; 
                                                                    
                                                                    fm.subscriberIndividualId = String.isNotBlank(benefits.memberIdCardSerialNumber)?benefits.memberIdCardSerialNumber:'';
                                                                    
                                                                    //Added for US2173853
                                                                    String benefitEndDate = String.isNotBlank(benefits.benefitExpirationDate)?String.valueof(ACETUtility.format(Date.valueof(benefits.benefitExpirationDate))):'';
                                                                    fm.memberStatus = (cov != null && cov.memberStatus != null)?cov.memberStatus:'';
                                                                    if(fm.memberStatus == 'TERM' && benefitEndDate != '12/31/9999'){
                                                                        fm.memberStatus = fm.memberStatus + ' - '+ benefitEndDate;
                                                                    }
                                                                } 
                                                            }
                                                        }
                                                    }
                                                }           
                                            }
                                            
                                            //cb.LastUpdate = LastUpdate;
                                            cb.MemberId = String.isNotBlank(individual.individualIdentifier)?individual.individualIdentifier:'';
                                            if(cob!=null){
                                                cb.MedicareType = String.isNotBlank(cob.coverageType)?cob.coverageType:'';
                                                cb.IsMedicarePrimary = String.isNotBlank(cob.otherInsurancePrimacyIndicator)?cob.otherInsurancePrimacyIndicator:'';   
                                            }
                                            amdlstCOB.add(cb);
                                        }
                                        
                                        string EnrolleeSRK ;
                                        if(membership.identifiers != null && membership.identifiers.size() > 0){
                                            for(ACETLGT_GetFamilyMembershipJson2Apex.cls_identifiers ident : membership.identifiers){
                                                if(ident.type == 'enrolleeSurrogateKey')
                                                    EnrolleeSRK= ident.id;
                                                
                                            }
                                        }
                                        for(ACETLGT_GetFamilyMembershipJson2Apex.cls_coverages coverage : membership.coverages ){
                                            if(coverage.bundleOptions != null && !(coverage.bundleOptions).isEmpty()){
                                                List<ACETLGT_GetFamilyMembershipJson2Apex.cls_bundleOptions> bundleOptions = coverage.bundleOptions;
                                                for(ACETLGT_GetFamilyMembershipJson2Apex.cls_bundleOptions bundleoption : bundleOptions){
                                                    if(bundleoption.benefits != null && !bundleoption.benefits.isEmpty()){
                                                        for(ACETLGT_GetFamilyMembershipJson2Apex.cls_benefits benefit : bundleoption.benefits){
                                                            


                                                            String benefitEffDate = String.isNotBlank(benefit.benefitEffectiveDate)?String.valueof(ACETUtility.format(Date.valueof(benefit.benefitEffectiveDate))):'';
                                                            String benefitEndDate = String.isNotBlank(benefit.benefitExpirationDate)?String.valueof(ACETUtility.format(Date.valueof(benefit.benefitExpirationDate))):'';
                                                          

                                                            system.debug('all dates ====>'+benefitEffDate +'=='+benefitEndDate+'=='+effectiveDate+'=='+endDate+'con1'+benefitPlanId +'=='+ benefit.benefitPlanId+'con2==='+Esrk+'=='+ EnrolleeSRK+'===con3  '+memberId+'=='+ benefit.memberIdCardSerialNumber);
                                                          
                                                                     
                                                            if(benefitPlanId == benefit.benefitPlanId && Esrk == EnrolleeSRK && memberId == benefit.memberIdCardSerialNumber && String.isNotBlank(benefitEffDate)&&String.isNotBlank(benefitEndDate)&& String.isNotBlank(effectiveDate)&&String.isNotBlank(endDate)&&benefitEffDate==effectiveDate && benefitEndDate==endDate){                                                                     
                                                                  
                                                                     system.debug('===got match');
                                                                     memberDetail.planType = (String.isNotBlank(benefit.planType) && PlanTypeCodeMap.containsKey(benefit.planType)) ? PlanTypeCodeMap.get(benefit.planType) : '';    //US2141411
                                                                     memberDetail.MemberId = String.isNotBlank(benefit.memberIdCardSerialNumber)?benefit.memberIdCardSerialNumber:'' ;
                                                                     // Map subscriber ID
                                                                     memberDetail.RelationShip = String.isNotBlank(benefit.relationshipCode)?ACETRelationshipCodes__c.getValues(benefit.relationshipCode).Description__c:'';
                                                                     memberDetail.RelationShipCode = String.isNotBlank(benefit.relationshipCode)?benefit.relationshipCode:'';
                                                                     memberDetail.BenefitPlanId = benefit.benefitPlanId;
                                                                     memberDetail.DOB = fm.DOB;
                                                                     memberDetail.QMSCOIndicator = benefit.indicators != null && benefit.indicators.qmscoindicator != null ? (benefit.indicators.qmscoIndicator.equals('Y') ? 'Yes' : 'No') : 'No';
                                                                     memberDetail.Network = (benefit.networkScheduleID != null)?benefit.networkScheduleID:'';
                                                                     //Field mapping added by Avish for getSubscription webservice User Stroy US652217 field mapping on 06072017
                                                                     memberDetail.BundleOptionID = benefit.benefitBundleOptionId;
                                                                     memberDetail.hsaAvailable = (benefit.indicators != null && benefit.indicators.hsaIndicator != null)?(benefit.indicators.hsaIndicator.equals('Y') ? 'Yes' : 'No'):'No';
                                                                     //Rama:Added to get the coverage level from getMembeship   
                                                                     memberDetail.CoverageLevelCode = (benefit.coverageLevelCode!= Null) && String.isNotBlank(benefit.coverageLevelCode)?benefit.coverageLevelCode:'';                                                      
                                                                     system.debug('CoverageLevelCode***'+memberDetail.CoverageLevelCode);
                                                                     
                                                                     //memberDetail.OriginalEffectiveDate = formatDate(benefit.benefitEffectiveDate);
                                                                     memberDetail.MemberStatus = coverage.memberStatus != null?coverage.memberStatus:'';
                                                                     //Added by Sindhu for group name
                                                                     memberDetail.groupNameValue = coverage.groupName != null?coverage.groupName:'';
                                                                     memberDetail.TerminationDate = (memberDetail.MemberStatus == 'TERM' && benefit.benefitExpirationDate!=null) ?formatDate(benefit.benefitExpirationDate):'';
                                                                     memberDetail.TerminationReason = String.isNotBlank(benefit.cancelReasonTypeCode)?benefit.cancelReasonTypeCode:'';
                                                                     //Added by Avish on 11/15/2017 as a part of US809970
                                                                     memberDetail.EligibilityStatus = (benefit.eligibilityStatusCode != Null) && String.isNotBlank(benefit.eligibilityStatusCode)?EligibilityCodeVsStatusMap.get(benefit.eligibilityStatusCode):'';
                                                                     memberDetail.FundingArragement = String.isNotBlank(benefit.fundingArrangementDescription)?benefit.fundingArrangementDescription:'';
                                                                     
                                                                     ACETLGT_MemberSearchCoveragesResult.CoverageLine pc = new ACETLGT_MemberSearchCoveragesResult.CoverageLine();   
                                                                     pc.SurrogateKey = srk;       
                                                                     pc.EnrolleeSurrogateKey = Esrk;       
                                                                     pc.groupNumber = groupNumber;       
                                                                     pc.EffectiveDate = effectiveDate;       
                                                                     pc.EndDate = '12/31/9999';//endDate;       
                                                                     pc.accumAsOfDate = (memberDetail.TerminationDate == 'TERM')?pc.EndDate:String.valueOf(ACETUtility.format(Date.today()));       
                                                                     pc.benefitBundleOptionId = memberDetail.BundleOptionID;  
                                                                     pc.isActive = false;
                                                                     pc.isTermed = false;
                                                                     pc.Network = memberDetail.Network;
                                                                     pc.memberStatus = memberDetail.MemberStatus;
                                                                     pc.memberId = memberDetail.MemberId;
                                                                     pc.subscriberId = String.isNotBlank(benefit.subscriberIdCardSerialNumber)?benefit.subscriberIdCardSerialNumber:''; 
                                                                     pc.DOB = fm.DOB;
                                                                     pc.Age = fm.Age;
                                                                     pc.CoverageLevelCode = memberDetail.CoverageLevelCode;
                                                                     pc.subjectRelation = memberDetail.RelationShip;
                                                                     pc.subjectRelationCode = memberDetail.RelationShipCode;
                                                                     pc.GroupName = memberDetail.groupNameValue; 
                                                                     pc.hsaPlan = memberDetail.hsaAvailable;
                                                                     memberDetail.PreferredCoverageInfo =pc; 
                                                                     
                                                                     if(benefit.coverageLevelList!=null && !benefit.coverageLevelList.isEmpty()){
                                                                         memberDetail.lstCoverageLineHistory = new List<ACETLGT_MemberSearchCoveragesResult.CoverageLineHistory>();
                                                                         for(ACETLGT_GetFamilyMembershipJson2Apex.cls_coverageLevelList coverageList : benefit.coverageLevelList){
                                                                             ACETLGT_MemberSearchCoveragesResult.CoverageLineHistory clh = new ACETLGT_MemberSearchCoveragesResult.CoverageLineHistory();   
                                                                             clh.covLevelCode = String.isNotBlank(coverageList.covLevelCode)?coverageList.covLevelCode:'';
                                                                             clh.covLevelDesc = String.isNotBlank(coverageList.covLevelDesc)?coverageList.covLevelDesc:'';
                                                                             clh.covLevelEffDate = String.isNotBlank(coverageList.covLevelEffDate)?formatDate(coverageList.covLevelEffDate):'';
                                                                             clh.covLevelExpDate = String.isNotBlank(coverageList.covLevelExpDate)?formatDate(coverageList.covLevelExpDate):'';
                                                                        
                                                                             memberDetail.lstCoverageLineHistory.add(clh);  
                                                                         }
                                                                     }
                                                                     break;
                                                                 }
                                                        }
                                                    }
                                                }
                                            } 
                                        }
                                        //memberDetail.PCPAssignments = new List<ACETLGT_MemberSearchCoveragesResult.PCPAssignment>();
                                        
                                        if(membership.providers != null && membership.providers.size()>0){
                                            for(ACETLGT_GetFamilyMembershipJson2Apex.cls_providers provider : membership.providers){
                                                system.debug('!!!pcp----------ACETMemberDetail---------->'+provider);
                                                ACETLGT_MemberSearchCoveragesResult.PCPAssignment pcp = new ACETLGT_MemberSearchCoveragesResult.PCPAssignment();
                                                pcp.assignmentLevel = getValueAfterStringValidation(provider.assignmentLevel, '');
                                                
                                                pcp.FirstName = '';  
                                                pcp.LastName = '';
                                                pcp.locationAffiliationID = '';
                                                pcp.organizationName = '';
                                                pcp.organizationId = '';
                                                getPCPNameAndId(provider,pcp);
                                                if(provider != null && provider.providerIdentifiers != null){
                                                    for(ACETLGT_GetFamilyMembershipJson2Apex.cls_providerIdentifiers ppi : provider.providerIdentifiers){                              
                                                        if(ppi.type_z == 'NPI'){
                                                            pcp.id = String.isNotBlank(ppi.id_z)?ppi.id_z:'';
                                                            pcp.identifiertype = String.isNotBlank(ppi.type_z)?ppi.type_z:'';  
                                                        }
                                                        if(ppi.type_z == 'LTK' && (pcp.id == null || pcp.id == '')){
                                                            pcp.id = String.isNotBlank(ppi.id_z)?ppi.id_z:'';
                                                            pcp.identifiertype = String.isNotBlank(ppi.type_z)?ppi.type_z:'';  
                                                        }                                  
                                                    } 
                                                }
                                                
                                                
                                                pcp.pcpAssignmentType = String.isNotBlank(provider.assignmentType)?provider.assignmentType:'';
                                                system.debug('----Dates---->'+provider.effectiveDate+'-----Today----->'+Date.Today());
                                                if(provider.expirationDate != null && provider.expirationDate != '')
                                                    pcp.endDate = formatdate(provider.expirationDate);                         
                                                //memberDetail.Network = OIL Gap
                                                if(provider.effectiveDate != null && provider.effectiveDate != '')
                                                    pcp.effectiveDate = formatdate(provider.effectiveDate);
                                                // pcp.effectiveDate = date.parse('2016-01-01 00:00:00');
                                                system.debug('----Dates---->'+pcp.effectiveDate+'-----Today----->'+Date.Today()); 
                                                system.debug('----MemberId---->'+fm.subscriberIndividualId +'-----memberId----->'+memberId);
                                                addPCP(pcp, fm, memberId, memberDetail);
                                                
                                            }
                                            system.debug('----PCPAssignments---->'+memberDetail.PCPAssignments); 
                                        }
                                    }
                                    
                                }                          
                                
                            }
                            
                        }
                        system.debug('~~~fam webservice----->'+memberDetail.familyMembers);
                        system.debug('~~~webservice-BenefitPlanId---->'+memberDetail.BenefitPlanId);
                        system.debug('amdlstCOB'+amdlstCOB);                    
                        memberDetail.lstCOB = amdlstCOB; 
                        system.debug(memberDetail);                                                           
                        calloutResult.Success = true;
                        calloutResult.Message = '';
                        calloutResult.Response = memberDetail;                    
                        
                        
                        
                    }
                }
                else if(response.getStatusCode() == 500){
                    calloutResult.Success = true;                
                    calloutResult.Response = new ACETLGT_MemberSearchCoveragesResult();
                    //calloutResult.Message = ACETWebserviceHelper.getErrorMessageFromCode(response.getStatusCode());
                    system.debug(calloutResult);  
                }
                else{
                    calloutResult.Success = false;                
                    calloutResult.Response = new ACETLGT_MemberSearchCoveragesResult();
                    calloutResult.Message = ACETWebserviceHelper.getErrorMessageFromCode(response.getStatusCode());
                    system.debug(calloutResult);    
                }
            }
            else{//when response is null
                //calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                calloutResult.Success = false;
                calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
                calloutResult.statusCode=999;
            }           
        }catch(Exception e){
            system.debug(e.getStacktraceString());
            //calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999;
            
        }
        
        return calloutResult;    
    } 
    
    // Added by Krishna for Id card request  
    public ACETWSCalloutResult getFamilyMembers(String memberId, ACETLGT_MemberDetail memberDetail){
        
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        if(memberDetail == null){
            memberDetail = new ACETLGT_MemberDetail();
        }
        
        try{
            getEndpoint();
            GetRequestBody(MemberDetail.PreferredCoverage.SurrogateKey, MemberDetail.PreferredCoverage.groupNumber, ACETWebServicehelper.formatToYYYYMMDD(MemberDetail.PreferredCoverage.effectiveDate));
            HttpResponse response = Send(OAuthConfig); 
            if(response!=null){
                //response.setStatusCode(400);
                
                calloutResult.statusCode=response.getStatusCode();
                if(response.getStatusCode() == 200){
                    if(response.getBody() != null){
                        //replace date with date2 as date is a preserved keyword
                        String responseBody = response.getBody().contains('\"date\":')?response.getBody().replace('\"date\":', '\"date2\":'):response.getBody();
                        //replace desc with desc2 as desc is a preserved keyword
                        responseBody = response.getBody().contains('\"desc\":')?responseBody.replace('\"desc\":', '\"desc2\":'):response.getBody();
                        system.debug('responseBody-->'+responseBody);
                        ACETLGT_GetFamilyMembershipJson2Apex  jSON2Apex = (ACETLGT_GetFamilyMembershipJson2Apex)JSON.deserialize(responseBody, ACETLGT_GetFamilyMembershipJson2Apex.class);
                        system.debug('jSON2Apex -->'+jSON2Apex);                    
                        memberDetail.FamilyMembers = new List<ACETLGT_MemberDetail.FamilyMember>();
                        memberDetail.PCPAssignments = new List<ACETLGT_MemberDetail.PCPAssignment>();
                        
                        
                        List<ACETLGT_MemberDetail.COB> amdlstCOB = new List<ACETLGT_MemberDetail.COB>();  
                        List<ACETLGT_GetFamilyMembershipJson2Apex.cls_individual> famMembers = jSON2Apex!=null?jSON2Apex.getFamilyMembershipResponse!=null?jSON2Apex.getFamilyMembershipResponse.individual:null:null;
                        system.debug('-------famMembers---kk----'+famMembers);
                        if(famMembers!=null && famMembers.size()>0){
                            for(ACETLGT_GetFamilyMembershipJson2Apex.cls_individual individual : famMembers){
                                ACETLGT_MemberDetail.FamilyMember fm = new ACETLGT_MemberDetail.FamilyMember();
                                if (individual != null && individual.name != null){
                                    fm.FirstName = String.isNotBlank(individual.name.firstName)?individual.name.firstName:'';
                                    fm.LastName = String.isNotBlank(individual.name.lastName)?individual.name.lastName:'';
                                    fm.MiddleInitial = String.isNotBlank(individual.name.middleName)?individual.name.middleName:'';
                                    fm.suffix = String.isNotBlank(individual.name.nameSuffix)?individual.name.nameSuffix:'';
                                }
                                
                                if (individual != null){ 
                                    if(individual.membership!=null && individual.membership.size()>0 && individual.membership[0] != null 
                                       && individual.membership[0].identifiers!=null && individual.membership[0].identifiers.size()>0 && 
                                       individual.membership[0].identifiers[0] != null)                   
                                        fm.FamilyId = individual.membership[0].identifiers[0].id ;//should be mch    
                                    fm.Gender = String.isNotBlank(individual.genderCode)?individual.genderCode:'';
                                    fm.DOB = String.isNotBlank(individual.birthDate)?formatDate(individual.birthDate):'';
                                    fm.Age = String.isNotBlank(individual.birthDate)?getAgeFromBirthday(individual.birthDate):'';
                                    fm.Relationship = String.isNotBlank(individual.relationshipCode)?individual.relationshipCode:'';
                                    fm.EID = String.isNotBlank(individual.individualIdentifier)?individual.individualIdentifier:''; //Added by Swetha//
                                }
                                
                                fm.Addresses = new List<ACETLGT_MemberDetail.Address>();
                                if(individual.address != null && individual.address.size()>0){
                                    for(ACETLGT_GetFamilyMembershipJson2Apex.cls_address addr : individual.address){
                                        ACETLGT_MemberDetail.Address address = new ACETLGT_MemberDetail.Address();
                                        address.AddressLine1 = String.isNotBlank(addr.addressLine1)?addr.addressLine1:'';    
                                        address.AddressLine2 = String.isNotBlank(addr.addressLine2)?addr.addressLine2:'';
                                        address.City = String.isNotBlank(addr.city)?addr.city:'';
                                        address.State = String.isNotBlank(addr.statecode)?addr.statecode:'';
                                        address.Zip = String.isNotBlank(addr.postalCode)?addr.postalCode:'';   
                                        address.AddressType = String.isNotBlank(addr.typeCode)?addr.typeCode:''; 
                                        address.countryCode = String.isNotBlank(addr.countryCode)?addr.countryCode:'';
                                        fm.Addresses.add(address);
                                    }
                                }
                             
                                if(individual.membership!=null && individual.membership.size()>0){
                                    for(ACETLGT_GetFamilyMembershipJson2Apex.cls_membership membership : individual.membership){
                                        if(membership.coverages!=null && membership.coverages.size()>0){
                                            for(ACETLGT_GetFamilyMembershipJson2Apex.cls_coverages cov : membership.coverages){
                                                fm.memberStatus = (cov != null && cov.memberStatus != null)?cov.memberStatus:'';
                                            }
                                        }
                                        
                                        if(membership.cob!=null && membership.cob.size()>0){
                                            for(ACETLGT_GetFamilyMembershipJson2Apex.cls_cob cob : membership.cob){
                                                
                                                Date Startdt = null;
                                                Date Enddt = null;
                                                string LastUpdate = null;
                                                if(cob!=null && String.isNotBlank(cob.otherInsuranceVerifyDate)){
                                                    LastUpdate = formatdate(cob.otherInsuranceVerifyDate); 
                                                    
                                                }
                                                ACETLGT_MemberDetail.COB cb = new ACETLGT_MemberDetail.COB();
                                                cb.CoverageTypeCode = cob.coverageType;
                                                if(cob!=null && String.isNotBlank(cob.medicareEntitlementReasonCode)){
                                                    if(cob.medicareEntitlementReasonCode == '0'){
                                                        cb.EntitlementReason = 'Age';                                  
                                                    } else if(cob.medicareEntitlementReasonCode == '1'){
                                                        cb.EntitlementReason = 'Disability';
                                                    } else if(cob.medicareEntitlementReasonCode == '2'){
                                                        cb.EntitlementReason = 'End Stage Renal Disease';
                                                    }
                                                }
                                                
                                                //cb.Name = individual.name!=null ?individual.name.firstName + ' ' + individual.name.lastName:'';
                                                
                                                if(individual.name!=null){
                                                    cb.Name =String.isNotBlank(individual.name.firstName)?individual.name.firstName:'';
                                                    cb.Name =String.isNotBlank(individual.name.lastName)?cb.Name+ ' ' + individual.name.lastName:cb.Name;
                                                }
                                                try{
                                                    cb.DateOfBirth = individual!=null?string.isNotBlank(individual.birthDate)?formatDate(individual.birthDate):null:null;
                                                }catch(Exception e){
                                                    System.debug('Exception handled='+e);
                                                } //cb.Age ='';
                                                //cb.BenefitType ='';
                                                if(!String.isEmpty(cb.DateOfBirth)){
                                                    Date dob = Date.parse(cb.DateOfBirth);
                                                    Integer days = dob.daysBetween(Date.Today());
                                                    Integer age = Integer.valueOf(days/365);
                                                    cb.Age = String.valueOf(age);
                                                    cb.BenefitType = String.isNotBlank(cob.cobTypeCodeDescription)?cob.cobTypeCodeDescription:'';  
                                                } 
                                                //Insurance type will be equal to coverage type description 
                                                cb.InsuranceType ='' ;  
                                                cb.otherInsuranceCardholderId ='';
                                                cb.medicareEntitlementType='';
                                                if(coverageTypeVsDescMap!=null && coverageTypeVsDescMap.size()>0 && String.isNotBlank(cob.coverageType))
                                                    cb.InsuranceType =coverageTypeVsDescMap.get(cob.coverageType);
                                                if(cob != null){
                                                    cb.otherInsuranceCardholderId = cob.otherInsuranceCardholderId;
                                                    
                                                    if(cob != null && cob.coverageType == '2' ){
                                                        //medicare entitlement code will come for this value
                                                        cb.medicareEntitlementType = cob.medicareEntitlementType;
                                                    }
                                                    
                                                    cb.COBTypeDesc = cob!=null?(cob.cobTypeCode == 'MD' ? 'Medical Care' : (cob.cobTypeCode == 'RX' ? 'Pharmacy' : '')):'';
                                                    cb.COBTypeDesc = cob.cobTypeCodeDescription;
                                                    cb.OrderOfBenefit ='';
                                                    if(primaryIndicatorVsDescMap!=null && primaryIndicatorVsDescMap.size()>0 
                                                       && cob!=null && String.isNotBlank(cob.otherInsurancePrimacyIndicator))
                                                        cb.OrderOfBenefit = primaryIndicatorVsDescMap.get(cob.otherInsurancePrimacyIndicator);
                                                    cb.InsuranceType = String.isNotBlank(cob.cobTypeCodeDescription)?cob.cobTypeCodeDescription:'';
                                                    
                                                    cb.IsOtherInsurancePrimary = String.isNotBlank(cob.otherInsurancePrimacyIndicator)?cob.otherInsurancePrimacyIndicator:'';
                                                    //system.debug('cobEffectiveStartDate' + cob.cobEffectiveStartDate);
                                                    //system.debug('cobEffectiveEndDate' + cob.cobEffectiveEndDate);
                                                    if(cob!=null && cob.cobEffectiveStartDate != null && String.isNotBlank(cob.cobEffectiveStartDate)){
                                                        Startdt = Date.ValueOf(cob.cobEffectiveStartDate);  
                                                        cb.Startdt = formatDate(cob.cobEffectiveStartDate);
                                                    }
                                                    if(cob!=null && cob.cobEffectiveEndDate != null && String.isNotBlank(cob.cobEffectiveEndDate)){
                                                        Enddt = Date.ValueOf(cob.cobEffectiveEndDate); 
                                                        cb.Enddt = formatDate(cob.cobEffectiveEndDate);
                                                    }
                                                    
                                                    //cb.Startdt = Startdt;
                                                    //cb.Enddt = Enddt;
                                                }
                                                //LastUpdate
                                                if(membership.coverages!=null && membership.coverages.size()>0){
                                                    for(ACETLGT_GetFamilyMembershipJson2Apex.cls_coverages cov : membership.coverages){
                                                        if(cov.bundleOptions != null && cov.bundleOptions.size()>0){  
                                                            for(ACETLGT_GetFamilyMembershipJson2Apex.cls_bundleOptions bun : cov.bundleOptions){
                                                                if(bun.benefits != null && bun.benefits.size()> 0){  
                                                                    for(ACETLGT_GetFamilyMembershipJson2Apex.cls_benefits benefits : bun.benefits){
                                                                        
                                                                        system.debug('HEREHERE2 ' + benefits);
                                                                        
                                                                        cb.Relationship = String.isNotBlank(benefits.relationshipDescription)?benefits.relationshipDescription:'';
                                                                        fm.Relationship =  String.isNotBlank(benefits.relationshipCode)?benefits.relationshipCode:'';  
                                                                        fm.subscriberIndividualId = String.isNotBlank(benefits.memberIdCardSerialNumber)?benefits.memberIdCardSerialNumber:'';
                                                                        fm.FamilyId = String.isNotBlank(benefits.memberIdCardSerialNumber)?benefits.memberIdCardSerialNumber:'';
                                                                        fm.benefitBundleOptionId = String.isNotBlank(benefits.benefitBundleOptionId)?benefits.benefitBundleOptionId:'';
                                                                        
                                                                    }  
                                                                }
                                                                
                                                            }    
                                                            fm.groupNumber =  String.isNotBlank(cov.groupNumber)?cov.groupNumber:'';
                                                        }
                                                    }
                                                }
                                                
                                                cb.LastUpdate = LastUpdate;
                                                system.debug('232323membership.identifiers'+membership);
                                                cb.MemberId = String.isNotBlank(fm.FamilyId)?fm.FamilyId:'';
                                                if(cob!=null){
                                                    cb.MedicareType = String.isNotBlank(cob.coverageType)?cob.coverageType:'';
                                                    cb.IsMedicarePrimary = String.isNotBlank(cob.otherInsurancePrimacyIndicator)?cob.otherInsurancePrimacyIndicator:''; 
                                                    cb.OtherInsuranceCarrierName = String.isNotBlank(cob.OtherInsuranceCarrierName)?cob.OtherInsuranceCarrierName:'';  
                                                }
                                                amdlstCOB.add(cb);
                                            }
                                        }
                                        
                                        
                                        
                                        system.debug('!!!PCD VALLLLLLS !! --------->'+membership.providers );
                                        if(membership.providers != null && membership.providers.size()>0){
                                            for(ACETLGT_GetFamilyMembershipJson2Apex.cls_providers provider : membership.providers){
                                                system.debug('!!!pcp----------ACETMemberDetail---------->'+provider);
                                                ACETLGT_MemberDetail.PCPAssignment pcp = new ACETLGT_MemberDetail.PCPAssignment();
                                                pcp.FirstName = String.isNotBlank(provider.firstName)?provider.firstName:'';  
                                                pcp.LastName = String.isNotBlank(provider.lastName)?provider.lastName:'';
                                                pcp.locationAffiliationID = String.isNotBlank(provider.locationAffiliationID)?provider.locationAffiliationID:'';
                                                
                                                if(provider != null && provider.providerIdentifiers != null){
                                                    for(ACETLGT_GetFamilyMembershipJson2Apex.cls_providerIdentifiers ppi : provider.providerIdentifiers){                              
                                                        if(ppi.type_z == 'NPI'){
                                                            pcp.id = String.isNotBlank(ppi.id_z)?ppi.id_z:'';
                                                            pcp.identifiertype = String.isNotBlank(ppi.type_z)?ppi.type_z:'';  
                                                        }
                                                        if(ppi.type_z == 'LTK' && (pcp.id == null || pcp.id == '')){
                                                            pcp.id = String.isNotBlank(ppi.id_z)?ppi.id_z:'';
                                                            pcp.identifiertype = String.isNotBlank(ppi.type_z)?ppi.type_z:'';  
                                                        }                                  
                                                    } 
                                                }
                                                
                                                
                                                pcp.pcpAssignmentType = String.isNotBlank(provider.assignmentType)?provider.assignmentType:'';
                                                
                                                if(provider.expirationDate != null && provider.expirationDate != '')
                                                    pcp.endDate = formatdate(provider.expirationDate);                         
                                                
                                                if(provider.effectiveDate != null && provider.effectiveDate != '')
                                                    pcp.effectiveDate = formatdate(provider.effectiveDate);
                                                system.debug('----MemberId---->'+fm.subscriberIndividualId +'-----memberId----->'+memberId);
                                                if(pcp.FirstName != '' && pcp.LastName != '' && pcp.pcpAssignmentType != '' && fm.subscriberIndividualId == memberId)
                
                
                                                    memberDetail.PCPAssignments.add(pcp);
                                                
                                            }
                                            system.debug('----PCPAssignments---->'+memberDetail.PCPAssignments); 
                                        }// End of PCP
                                    }                                
                                }     
                                system.debug('fm.Relationship@@@ ' + fm.Relationship);
                                fm.Relationship = String.isNotBlank(fm.Relationship)?ACETRelationshipCodes__c.getValues(fm.Relationship).Description__c:''; //individual.memberShip.eligibilityRelationshipCode.desc2; 
                                
                                Integer counter = 0;
                                for(Integer i = 0; i < memberDetail.FamilyMembers.size(); i++){
                                    if(fm.FamilyId <= memberDetail.FamilyMembers[i].FamilyId){
                                        counter = i;
                                        break;
                                    }else if(memberDetail.FamilyMembers[i].FamilyId < fm.FamilyId){
                                        counter = i+1;
                                    }
                                }
                                if(counter <= (memberDetail.FamilyMembers.size() - 1) || (counter < memberDetail.FamilyMembers.size()) && memberDetail.FamilyMembers.size() <= 1)
                                    memberDetail.FamilyMembers.add(counter, fm);
                                else
                                    memberDetail.FamilyMembers.add(fm);
                            }
                        }
                        system.debug('amdlstCOB'+amdlstCOB);                    
                        memberDetail.lstCOB = amdlstCOB; 
                        system.debug(memberDetail);                                                           
                        calloutResult.Success = true;
                        calloutResult.Message = '';
                        calloutResult.Response = memberDetail;                      
                    }
                    
                }else{                
                    //currently servce returns 500 if no records found
                    //calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                    calloutResult.Success = false;                
                    calloutResult.Response = new ACETLGT_MemberSearchCoveragesResult();
                    calloutResult.Message = ACETWebserviceHelper.getErrorMessageFromCode(response.getStatusCode());
                    system.debug(calloutResult);    
                }
            }
            else{//when response is null
                calloutResult.Success = false;
                calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
                calloutResult.statusCode=999;
            }
        }catch(Exception e){
            system.debug(e.getStacktraceString());
            calloutResult.Success = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            calloutResult.statusCode=999;
            
        }
        
        return calloutResult;    
    }          
    
    //to remove to global util class
    public String formatDate(String dateString){
        try{
            if(String.isBlank(dateString)) return null;
            List<String> dateParts = dateString.split('-');
            if(dateParts.size() == 3){
                String mm = dateParts[1];
                String dd = dateParts[2];
                String yyyy = dateParts[0];
                
                mm = mm.contains('0') && mm.indexOf('0') == 0 ? mm.replace('0','') : mm ; 
                dd = dd.contains('0') && dd.indexOf('0') == 0 ? dd.replace('0','') : dd; 
                
                return mm  + '/' + dd + '/' + yyyy;
            }else{
                return dateString;
            }
        }catch(Exception e){
            System.debug('Exception occured='+e);  
            return null;
        }
    }
    
    public String getAgeFromBirthday(String birthDate){
        try{
            if(String.isBlank(birthDate))return null;
            Date d = Date.valueOf(birthDate);
            return String.valueOf(d.daysBetween(Date.today())/365);
        }catch(Exception e){
            System.debug('Exception occured='+e);  
            return null;
        }
        
    }
    
    public String getMaskedSSN(String ssn){
        if(String.isEmpty(ssn) || ssn.length() < 4) return '';
        
        return 'xxx-xx-' + ssn.substring(ssn.length() - 4);
    }
	
	
    
}