public class ACETGetFamilyMemberWebService extends ACETWebService{
  
    public Map<String,String> coverageTypeVsDescMap;
    public Map<String,String> primaryIndicatorVsDescMap;
    private Map<String,String> EligibilityCodeVsStatusMap;//US2962032
    public Map<String, String> PlanTypeCodeMap {get; set;}
    public ACETGetFamilyMemberWebService(){
         if(!Test.isRunningTest()){
        super('Stargate');
        }        coverageTypeVsDescMap = new Map<String,String>();
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
        
        EligibilityCodeVsStatusMap = new Map<String,String>();//US2962032 key value mapping moved from getmember 
        EligibilityCodeVsStatusMap.put('A','ACTIVE');
        EligibilityCodeVsStatusMap.put('C','COBRA');
        EligibilityCodeVsStatusMap.put('S','SURVIVING INSURED');
        EligibilityCodeVsStatusMap.put('T','TEFRA');
        EligibilityCodeVsStatusMap.put('','');
        
        PlanTypeCodeMap = new Map<String,String>();//US2962032 key value mapping moved from getmember 
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
    
   public ACETWSCalloutResult getHouseHoldData(String memberId, String surrogateKey, String groupNumber, String effectiveDate,String bundleOptionId,String benefitPlanId){
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        ACETHouseHoldWrapper houseHoldDataWrapper = new ACETHouseHoldWrapper();
        ACETHouseHoldWrapper.HouseHold houseObj;
        ACETHouseHoldWrapper.addressInfo houseAddObj;
        List<ACETHouseHoldWrapper.HouseHold> houseHoldLine = new List<ACETHouseHoldWrapper.HouseHold>();
       try{
           getEndpoint();
           GetRequestBody(surrogateKey, groupNumber, ACETWebServicehelper.formatToYYYYMMDD(effectiveDate));
           HttpResponse response = Send(OAuthConfig);
           system.debug('3333response'+response);
           String responseStr = response!=null?response.getBody():'';
           if(String.isNotBlank(responseStr)){
            calloutResult.statusCode=response.getStatusCode();
            if(response.getStatusCode() == 200){
                
                    //replace date with date2 as date is a preserved keyword
                    String responseBody = response.getBody().contains('\"date\":')?response.getBody().replace('\"date\":', '\"date2\":'):response.getBody();
                    
                    //replace desc with desc2 as desc is a preserved keyword
                    responseBody = response.getBody().contains('\"date\":')?responseBody.replace('\"desc\":', '\"desc2\":'):response.getBody();
                    system.debug('responseBody-->'+responseBody);
                    ACETFamilyMembershipJson2Apex jSON2Apex = (ACETFamilyMembershipJson2Apex)JSON.deserialize(responseBody, ACETFamilyMembershipJson2Apex.class);
                    String EnrolleeSRK;
                    List<ACETFamilyMembershipJson2Apex.cls_individual> famMembers = jSON2Apex!=null?jSON2Apex.getFamilyMembershipResponse!=null?jSON2Apex.getFamilyMembershipResponse.individual:null:null;//

                    if(famMembers!=null && famMembers.size()>0){
                      System.debug('famMembers='+famMembers.size());
                      for(ACETFamilyMembershipJson2Apex.cls_individual individual : famMembers){
                        
                        ACETMemberDetail.FamilyMember fm = new ACETMemberDetail.FamilyMember();
                        houseObj = new ACETHouseHoldWrapper.HouseHold();
                        if (individual != null && individual.name != null){
                            
                            houseObj.PolicyId=String.isNotBlank(groupNumber)?groupNumber:'';
                            houseObj.firstName = String.isNotBlank(individual.name.firstName)?individual.name.firstName:'';
                            houseObj.lastName =  String.isNotBlank(individual.name.lastName)?individual.name.lastName:'';
                            //fm.suffix = String.isNotBlank(individual.name.nameSuffix)?individual.name.nameSuffix:'';   
                            //fm.MiddleInitial =String.isNotBlank(individual.name.middleName)?individual.name.middleName:''; //Do we need to consider middle name too
                            houseObj.fullName = houseObj.firstName + ' ' + houseObj.lastName;
                            //houseObj.isMainMember = true; //Need to have a logic to know whethere its a subscriber 
                        }
                          if (individual != null){ 
                            if(individual.membership!=null && individual.membership.size()>0 && individual.membership[0] != null 
                                && individual.membership[0].identifiers!=null && individual.membership[0].identifiers.size()>0 && 
                               individual.membership[0].identifiers[0] != null)      
                            //is the below one member id?
                            //fm.FamilyId = individual.membership[0].identifiers[0].id ;//should be mch    
                            houseObj.gender = String.isNotBlank(individual.genderCode)?individual.genderCode:'';
                             System.debug('individual.birthDate='+individual.birthDate);
                            houseObj.dob = String.isNotBlank(individual.birthDate)?AcetUtility.formatDate(individual.birthDate):'';
                            System.debug('houseObj.dob='+houseObj.dob);
                              
                            
                        }
                        //We are getting only one address from link -so taking the last one here
                        //fm.Addresses = new List<ACETMemberDetail.Address>();
                        if(individual.address != null && individual.address.size()>0){
                            for(ACETFamilyMembershipJson2Apex.cls_address addr : individual.address){
                                houseAddObj = new ACETHouseHoldWrapper.addressInfo();
                                houseAddObj.street  = String.isNotBlank(addr.addressLine1)?addr.addressLine1:'';    
                                //address.AddressLine2 = String.isNotBlank(addr.addressLine2)?addr.addressLine2:'';
                                houseAddObj.city  = String.isNotBlank(addr.city)?addr.city:'';
                                houseAddObj.state  = String.isNotBlank(addr.statecode)?addr.statecode:'';
                                houseAddObj.zip  = String.isNotBlank(addr.postalCode)?addr.postalCode:'';   
                                //address.AddressType = String.isNotBlank(addr.typeCode)?addr.typeCode:''; 
                                houseAddObj.country = String.isNotBlank(addr.countryCode)?addr.countryCode:'';
                                //fm.Addresses.add(address);
                            }
                        }
                        String relationshipCode='';
                        if(individual.membership!=null && individual.membership.size()>0){
                            for(ACETFamilyMembershipJson2Apex.cls_membership membership : individual.membership){
                                if(membership.coverages!=null && membership.coverages.size()>0){
                                    for(ACETFamilyMembershipJson2Apex.cls_coverages cov : membership.coverages){
                                        if(cov.bundleOptions != null && cov.bundleOptions.size()>0){  
                                            for(ACETFamilyMembershipJson2Apex.cls_bundleOptions bun : cov.bundleOptions){
                                               if(bun.benefits != null && bun.benefits.size()> 0){  
                                                  for(ACETFamilyMembershipJson2Apex.cls_benefits benefits : bun.benefits){
                                                        string benefitBundleOptionId = String.isNotBlank(benefits.benefitBundleOptionId)?benefits.benefitBundleOptionId:'';
                                                        String benPlanId= String.isNotBlank(benefits.benefitPlanId)?benefits.benefitPlanId:'';
                                                        if(bundleOptionId==benefitBundleOptionId && benPlanId==benefitPlanId){
                                                           relationshipCode=  String.isNotBlank(benefits.relationshipCode)?benefits.relationshipCode:'';  
                                                           //is relationship code or relarionship value
                                                          //houseObj.relationship = String.isNotBlank(benefits.relationshipDescription)?benefits.relationshipDescription:'';                                                     
                                                        }

                                                  }
                                               }
                                            }
                                        }
                                    }
                               
                                }
                            }
                         
                        }
                          houseObj.relationship  = String.isNotBlank(relationshipCode)?ACETRelationshipCodes__c.getValues(relationshipCode).Description__c:'';
                          houseObj.isMainMember = String.isNotBlank(relationshipCode) && relationshipCode=='18'?True:False; 
                          houseObj.memberId =String.isNotBlank(memberId)?memberId:'';
                          houseObj.address = houseAddObj ;

                          houseHoldLine.add(houseObj);
                      }
                      houseHoldDataWrapper.houseHoldList = houseHoldLine;
                      system.debug('houseHoldLine Size### ' +houseHoldLine.size());
                      system.debug('houseHoldLine### ' +houseHoldLine);
                    }
                  calloutResult.Success = true;
                  calloutResult.Message = '';
                  calloutResult.Response = houseHoldDataWrapper;
				  calloutResult.statusCode = 200;
            }else{
                calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                calloutResult.Success = false;
                calloutResult.Message = ACETUtility.getErrorMessage('GN500');
            }
           }else{
               System.debug('response is blank');
               calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
               calloutResult.Success = false;
               calloutResult.Message = ACETUtility.getErrorMessage('GN500');
               calloutResult.statusCode = 999;
           }
       }catch(Exception e){
            System.debug('Exception happened:'+e);
            system.debug(e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = ACETUtility.getErrorMessage('GN500');
            calloutResult.statusCode=999;
       }
       return calloutResult;
   }
   public ACETWSCalloutResult getFamilyMembers(String memberId, ACETMemberDetail memberDetail){
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        if(memberDetail == null){
            memberDetail = new ACETMemberDetail();
        }
        
        try{
                getEndpoint();
                GetRequestBody(MemberDetail.PreferredCoverage.SurrogateKey, MemberDetail.PreferredCoverage.groupNumber, ACETWebServicehelper.formatToYYYYMMDD(MemberDetail.PreferredCoverage.effectiveDate));
            HttpResponse response = Send(OAuthConfig);
        
           if(response!=null){
            calloutResult.statusCode=response.getStatusCode();
            if(response.getStatusCode() == 200){
                if(response.getBody() != null){
                    String EnrolleeSRK;
                    //replace date with date2 as date is a preserved keyword
                    String responseBody = response.getBody().contains('\"date\":')?response.getBody().replace('\"date\":', '\"date2\":'):response.getBody();
                    
                    //replace desc with desc2 as desc is a preserved keyword
                    responseBody = response.getBody().contains('\"date\":')?responseBody.replace('\"desc\":', '\"desc2\":'):response.getBody();
                    system.debug('responseBody-->'+responseBody);
                    ACETFamilyMembershipJson2Apex jSON2Apex = (ACETFamilyMembershipJson2Apex)JSON.deserialize(responseBody, ACETFamilyMembershipJson2Apex.class);
                    memberDetail.FamilyMembers = new List<ACETMemberDetail.FamilyMember>();
                    List<ACETMemberDetail.COB> amdlstCOB = new List<ACETMemberDetail.COB>();
                    List<ACETFamilyMembershipJson2Apex.cls_individual> famMembers = jSON2Apex!=null?jSON2Apex.getFamilyMembershipResponse!=null?jSON2Apex.getFamilyMembershipResponse.individual:null:null;//
                    if(famMembers!=null && famMembers.size()>0){
                      for(ACETFamilyMembershipJson2Apex.cls_individual individual : famMembers){
                        ACETMemberDetail.FamilyMember fm = new ACETMemberDetail.FamilyMember();
                        if (individual != null && individual.name != null){
                            fm.FirstName = String.isNotBlank(individual.name.firstName)?individual.name.firstName:'';
                            fm.LastName = String.isNotBlank(individual.name.lastName)?individual.name.lastName:'';
                            fm.MiddleInitial =String.isNotBlank(individual.name.middleName)?individual.name.middleName:'';
                            fm.suffix = String.isNotBlank(individual.name.nameSuffix)?individual.name.nameSuffix:'';   
                        }
                        if(individual.membership!=null && individual.membership.size()>0 && 
                           individual.membership[0] != null && individual.membership[0].identifiers!=null && 
                           individual.membership[0].identifiers.size()>0 && individual.membership[0].identifiers[0] != null)
                            for(ACETFamilyMembershipJson2Apex.cls_identifiers ident : individual.membership[0].identifiers){
                                     if(ident.type == 'enrolleeSurrogateKey'){
                                         EnrolleeSRK= ident.id;
  
                                     }
                                            }
                            fm.FamilyId = individual.membership[0].identifiers[0].id ;
                        fm.Gender = String.isNotBlank(individual.genderCode)?individual.genderCode:'';
                        fm.DOB = String.isNotBlank(individual.birthDate)?formatDate(individual.birthDate):'';
                        fm.Age = String.isNotBlank(individual.birthDate)?getAgeFromBirthday(individual.birthDate):'';
                        fm.Relationship = String.isNotBlank(individual.relationshipCode)?individual.relationshipCode:'';
                        fm.EID = String.isNotBlank(individual.individualIdentifier)?individual.individualIdentifier:''; //Added by Swetha//
                        Integer counter = 0;
                        for(Integer i = 0; i < memberDetail.FamilyMembers.size(); i++){
                 if(fm.FamilyId <= memberDetail.FamilyMembers[i].FamilyId){
                   counter = i;
                   break;
                 }else if(memberDetail.FamilyMembers[i].FamilyId < fm.FamilyId){
                   counter = i+1;
                 }
                        }
                        if(counter <= (memberDetail.FamilyMembers.size() - 1) || (counter < memberDetail.FamilyMembers.size()) && memberDetail.FamilyMembers.size() <= 1){
                 memberDetail.FamilyMembers.add(counter, fm);
              } else {
                 memberDetail.FamilyMembers.add(fm);
              }
                            //Khoushik adding code for Coordination Of Benefits
                       if(individual.membership!=null && individual.membership.size()>0){
                        for(ACETFamilyMembershipJson2Apex.cls_membership membership : individual.membership){
                            for(ACETFamilyMembershipJson2Apex.cls_cob cob : membership.cob){
                              Date Startdt = null;
                              Date Enddt = null;
                              Date LastUpdate = null;
                              try{
                                      if(String.isNotBlank(cob.otherInsuranceVerifyDate)){
                                          LastUpdate = Date.ValueOf(cob.otherInsuranceVerifyDate); 
                                      }
                              }
                              catch(Exception e){
                                 System.debug('Exception happened:'+e);   
                              }
                              ACETMemberDetail.COB cb = new ACETMemberDetail.COB();
                              //cb.Name = individual.name!=null ?individual.name.firstName + ' ' + individual.name.lastName:'';
                              
                              if(individual.name!=null){
                                  cb.Name =String.isNotBlank(individual.name.firstName)?individual.name.firstName:'';
                                  cb.Name =String.isNotBlank(individual.name.lastName)?cb.Name+ ' ' + individual.name.lastName:cb.Name;
                              }
                               try{
                              cb.DateOfBirth = String.isNotBlank(individual.birthDate)?formatDate(individual.birthDate):'';
                               }
                              catch(Exception e){
                                 System.debug('Exception happened:'+e);   
                              }
                              if(!String.isEmpty(cb.DateOfBirth)){
                                Date dob = Date.parse(cb.DateOfBirth);
                                Integer days = dob.daysBetween(Date.Today());
                                        Integer age = Integer.valueOf(days/365);
                            cb.Age = String.valueOf(age);
                                
                              }
                              if(cob!=null){ 
                               cb.InsuranceType = String.isNotBlank(cob.cobTypeCodeDescription)?cob.cobTypeCodeDescription:'';
                               cb.IsOtherInsurancePrimary = String.isNotBlank(cob.otherInsurancePrimacyIndicator)?cob.otherInsurancePrimacyIndicator:'';
                               //system.debug('cobEffectiveStartDate' + cob.cobEffectiveStartDate);
                               //system.debug('cobEffectiveEndDate' + cob.cobEffectiveEndDate);
                               if(cob!=null && cob.cobEffectiveStartDate != null && String.isNotBlank(cob.cobEffectiveStartDate)){
                                    Startdt = Date.ValueOf(cob.cobEffectiveStartDate);  
                               }
                               if(cob!=null && cob.cobEffectiveEndDate != null && String.isNotBlank(cob.cobEffectiveEndDate)){
                                    Enddt = Date.ValueOf(cob.cobEffectiveEndDate);  
                              }
                               
                               cb.Startdt = Startdt;
                               cb.Enddt = Enddt;
                              }
                              //LastUpdate
                              if(membership.coverages!=null && membership.coverages.size()>0){
                               for(ACETFamilyMembershipJson2Apex.cls_coverages cov : membership.coverages){
                                if(cov.bundleOptions!=null && cov.bundleOptions.size()>0){
                                 for(ACETFamilyMembershipJson2Apex.cls_bundleOptions bun : cov.bundleOptions){
                                  if(bun.benefits!=null && bun.benefits.size()>0){
                                    for(ACETFamilyMembershipJson2Apex.cls_benefits benefits : bun.benefits){
            //the below is based on the assumption that all bundles under this coverage have the same coverage date, in the future if the bundles can be separated, this will show the incorrect status
                                                        String benefitEffDate = String.isNotBlank(benefits.benefitEffectiveDate)?String.valueof(Date.valueof(benefits.benefitEffectiveDate).format()):'';
                                                        String benefitEndDate = String.isNotBlank(benefits.benefitExpirationDate)?String.valueof(Date.valueof(benefits.benefitExpirationDate).format()):'';
                                                        Date newEffectiveDate = Date.newInstance(Integer.valueOf(memberDetail.PreferredCoverage.EffectiveDate.split('/')[2]), Integer.valueOf(memberDetail.PreferredCoverage.EffectiveDate.split('/')[0]), Integer.valueOf(memberDetail.PreferredCoverage.EffectiveDate.split('/')[1]));
                                                        if(memberDetail.PreferredCoverage != null && memberDetail.PreferredCoverage.EndDate != null){
                                                            Date newEndDate = Date.newInstance(Integer.valueOf(memberDetail.PreferredCoverage.EndDate.split('/')[2]), Integer.valueOf(memberDetail.PreferredCoverage.EndDate.split('/')[0]), Integer.valueOf(memberDetail.PreferredCoverage.EndDate.split('/')[1]));
                                                        }  
                                                        
                                                        //the below is based on the assumption that all bundles under this coverage have the same coverage date, in the future if the bundles can be separated, this will show the incorrect status
                                                      //temp commented out for prod defect 11/25/19
                                                      
                                                        fm.termDateStr = '';
                                                        if(fm.MemberStatus == 'TERM' && benefitEndDate != '12/31/9999'){
                                                          fm.termDateStr = benefitEndDate;
                                                        }
                                                        fm.MemberId = String.isNotBlank(benefits.memberIdCardSerialNumber)?benefits.memberIdCardSerialNumber:'';
							cb.MemberId = String.isNotBlank(benefits.memberIdCardSerialNumber)?benefits.memberIdCardSerialNumber:'';
                                        /*if(benefits.coverageLastUpdateDate != null){
                                            LastUpdate = Date.ValueOf(benefits.coverageLastUpdateDate.substring(0,4)+ '-' + benefits.coverageLastUpdateDate.substring(4,6) + '-' + benefits.coverageLastUpdateDate.substring(6,8)); 
                                            system.debug('benefits.coverageLastUpdateDate'+benefits.coverageLastUpdateDate);
                                            system.debug('LastUpdate '+LastUpdate);
                                        }*/
                                        cb.Relationship = String.isNotBlank(benefits.relationshipDescription)?benefits.relationshipDescription:''; 
                                         //Added by Pavan
                                        fm.Relationship =  String.isNotBlank(benefits.relationshipCode)?benefits.relationshipCode:'';  
                                        fm.subscriberIndividualId = String.isNotBlank(benefits.memberIdCardSerialNumber)?benefits.memberIdCardSerialNumber:'';
                                        //US2962032 start
                                               if(memberDetail.PreferredCoverage!=null && memberDetail.PreferredCoverage.benefitPlanId == benefits.benefitPlanId && memberDetail.PreferredCoverage.coverageMemberId == benefits.memberIdCardSerialNumber && ((Date.ValueOf(newEffectiveDate) >= Date.valueof(benefits.benefitEffectiveDate) && benefitEffDate !='' && String.isNotBlank(benefits.benefitEffectiveDate) && benefitEndDate == '12/31/9999')||
                                                             (benefitEndDate != '' && String.isNotBlank(benefits.benefitExpirationDate)&& benefitEndDate != '12/31/9999' && Date.valueof(benefits.benefitEffectiveDate) <= Date.ValueOf(newEffectiveDate) && Date.ValueOf(newEffectiveDate) <= Date.valueof(benefits.benefitExpirationDate) ))){
                                                     system.debug('got match');
                                                     memberDetail.MemberId = String.isNotBlank(benefits.memberIdCardSerialNumber)?benefits.memberIdCardSerialNumber:'' ;
                                                     if(String.isBlank(memberDetail.MemberId) ){
                                                         calloutResult.statusCode=212;//212-->Note that all information may not have loaded on the page. Continue to service the call following your normal protocols
                                                     }
                                                     memberDetail.RelationShip = String.isNotBlank(benefits.relationshipCode)?ACETRelationshipCodes__c.getValues(benefits.relationshipCode).Description__c:'';
                                                     memberDetail.RelationShipCode = String.isNotBlank(benefits.relationshipCode)?benefits.relationshipCode:'';
                                                     memberDetail.BenefitPlanId = String.isNotBlank(benefits.benefitPlanId)?benefits.benefitPlanId:'';
                                                     if(String.isBlank(memberDetail.benefitPlanId) ){
                                                        calloutResult.statusCode=212;//212-->Note that all information may not have loaded on the page. Continue to service the call following your normal protocols
                                                     }
                                                     memberDetail.QMSCOIndicator = benefits.indicators != null && benefits.indicators.qmscoindicator != null ? (benefits.indicators.qmscoIndicator.equals('Y') ? 'Yes' : 'No') : 'No';
                                                     //Field mapping added by Avish for getSubscription webservice User Stroy US652217 field mapping on 06072017
                                                     memberDetail.BundleOptionID = String.isNotBlank(benefits.benefitBundleOptionId)?benefits.benefitBundleOptionId:'';     
                                                     memberDetail.hsaAvailable = (benefits.indicators != null && benefits.indicators.hsaIndicator != null)?(benefits.indicators.hsaIndicator.equals('Y') ? 'Yes' : 'No'):'No';
                                                     memberDetail.CoverageLevelCode = (benefits.coverageLevelCode!= Null) && String.isNotBlank(benefits.coverageLevelCode)?benefits.coverageLevelCode:'';                                                          
                                                     system.debug('CoverageLevelCode***'+memberDetail.CoverageLevelCode);
                                                     memberDetail.Network = (benefits.networkScheduleID != null)?benefits.networkScheduleID:'';
                                                     memberDetail.MemberStatus = String.isNotBlank(cov.memberStatus)?cov.memberStatus:'';
                                                     memberDetail.TerminationReason = String.isNotBlank(benefits.cancelReasonTypeCode)?benefits.cancelReasonTypeCode:'';
                                                     memberDetail.EligibilityStatus = (benefits.eligibilityStatusCode != Null) && String.isNotBlank(benefits.eligibilityStatusCode)?((EligibilityCodeVsStatusMap.get(benefits.eligibilityStatusCode) == 'COBRA' || EligibilityCodeVsStatusMap.get(benefits.eligibilityStatusCode) == 'SURVIVING INSURED')?EligibilityCodeVsStatusMap.get(benefits.eligibilityStatusCode):''):'';
                                                     memberDetail.PlanType = (benefits.planType != Null) && String.isNotBlank(benefits.planType)?PlanTypeCodeMap.get(benefits.planType):'';
                                                     memberDetail.FundingArragement = String.isNotBlank(benefits.fundingArrangementDescription)?benefits.fundingArrangementDescription:'';
                                                     if(benefits.coverageLevelList!=null && !benefits.coverageLevelList.isEmpty()){
                                                     memberDetail.lstCoverageLineHistory = new List<ACETMemberDetail.CoverageLineHistory>();
                                                         for(ACETFamilyMembershipJson2Apex.cls_coverageLevelList coverageList : benefits.coverageLevelList){
                                                             ACETMemberDetail.CoverageLineHistory clh = new ACETMemberDetail.CoverageLineHistory();   
                                                             clh.covLevelCode = String.isNotBlank(coverageList.covLevelCode)?coverageList.covLevelCode:'';
                                                             clh.covLevelDesc = String.isNotBlank(coverageList.covLevelDesc)?coverageList.covLevelDesc:'';
                                                             string effd = coverageList.covLevelEffDate;
                                                             string exd = coverageList.covLevelExpDate;
                                                             if(String.isNotBlank(effd))
                                                                 clh.covLevelEffDate = Date.newInstance(Integer.valueOf(effd.split('-')[0]), Integer.valueOf(effd.split('-')[1]), Integer.valueOf(effd.split('-')[2]));
                                                             if(String.isNotBlank(exd))
                                                                 clh.covLevelExpDate= Date.newInstance(Integer.valueOf(exd.split('-')[0]), Integer.valueOf(exd.split('-')[1]), Integer.valueOf(exd.split('-')[2]));
                                                             memberDetail.lstCoverageLineHistory.add(clh); 
                                                         }
                                                     }
                                                     break;
                                                 }
                                        //US2962032 end                 
                                    } 
                                   }
                                  }
                                 }
                                }   
                                   //US2962032 Start
                                  system.debug('----------Membership.providers---------->'+Membership.providers);
								if(membership.providers != null && membership.providers.size()>0){
                                
                             memberDetail.PCPAssignments = new List<ACETMemberDetail.PCPAssignment>();
                             for(ACETFamilyMembershipJson2Apex.cls_providers provider : Membership.providers ){
                                 ACETMemberDetail.PCPAssignment pcp = new ACETMemberDetail.PCPAssignment();
                                 pcp.FirstName = String.isNotBlank(provider.firstName)?provider.firstName:'';  
                                 pcp.LastName = String.isNotBlank(provider.lastName)?provider.lastName:'';
                                 pcp.pcpAssignmentType = String.isNotBlank(provider.assignmentType)?provider.assignmentType:'';
                                 pcp.locationAffiliationID = String.isNotBlank(provider.locationAffiliationID)?provider.locationAffiliationID:''; //27109358 - Added by Avish 09/10/2018
                                 if(provider.providerIdentifiers != null){
                                     for(ACETFamilyMembershipJson2Apex.cls_providerIdentifiers ppi : provider.providerIdentifiers){                              
                                         if(ppi.type == 'NPI'){
                                             pcp.id = String.isNotBlank(ppi.id)?ppi.id:'';
                                             pcp.identifiertype = String.isNotBlank(ppi.type)?ppi.type:'';  
                                         }
                                         if(ppi.type == 'LTK' && (pcp.id == null || pcp.id == '')){
                                             pcp.id = String.isNotBlank(ppi.id)?ppi.id:'';
                                             pcp.identifiertype = String.isNotBlank(ppi.type)?ppi.type:''; 
                                         }                                   
                                     }
                                 }
                                 system.debug('----Dates---->'+provider.effectiveDate+'-----Today----->'+Date.Today());
                                 if(provider.expirationDate != null && provider.expirationDate != ''){
                                     pcp.endDate = formatdate(provider.expirationDate); 
                                     pcp.isActive = isActive(provider.expirationDate);         
                                 }               
                                 //memberDetail.Network = OIL Gap
                                 if(provider.effectiveDate != null && provider.effectiveDate != '')
                                     pcp.effectiveDate = formatdate(provider.effectiveDate);
                                 //  pcp.effectiveDate = date.parse('05/05/2017');
                                 system.debug('----Dates---->'+pcp.effectiveDate+'-----Today----->'+Date.Today());
                                 if(!String.IsEmpty(provider.firstName) && !String.IsEmpty(provider.lastName) && !String.IsEmpty(provider.assignmentType) && !String.IsEmpty(provider.effectiveDate) && !String.IsEmpty(provider.expirationDate) && fm.subscriberIndividualId == memberId){
                                     memberDetail.PCPAssignments.add(pcp);   
                                 }

                             }
                                  //US2962032 end 
                              }
                              }
                              cb.LastUpdate = LastUpdate;
                              //cb.MemberId = String.isNotBlank(individual.individualIdentifier)?individual.individualIdentifier:'';
                             if(cob!=null){
                              cb.MedicareType = String.isNotBlank(cob.coverageType)?cob.coverageType:'';
                              cb.IsMedicarePrimary = String.isNotBlank(cob.otherInsurancePrimacyIndicator)?cob.otherInsurancePrimacyIndicator:'';   
                              }
                              amdlstCOB.add(cb);
                            }
                           }
                                                           
                          }                           
                        
                      }
                        
                    }
                      system.debug('amdlstCOB'+amdlstCOB);                    
                     memberDetail.lstCOB = amdlstCOB; 
                    system.debug(memberDetail);                                                           
                    calloutResult.Success = true;
                    calloutResult.Message = '';
                    calloutResult.Response = memberDetail;                    
                
                        
                                     
                }
                
            }else if(response.getStatusCode() == 500){                
                //currently servce returns 500 if no records found
                calloutResult.MessageSeverity = ApexPages.Severity.INFO;
                calloutResult.Success = true;                
                calloutResult.Response = new ACETMemberDetail();
                system.debug(calloutResult);    
             }
            }
            else{//when response is null
                calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                calloutResult.Success = false;
                calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
                calloutResult.statusCode=999;
             }           
            }catch(Exception e){
                    system.debug(e.getStacktraceString());
                    calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                    calloutResult.Success = false;
                    calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
                    calloutResult.statusCode=999;

           }
        
        return calloutResult;    
    } 
    
    //to remove to global util class.
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
    
    public ACETWSCalloutResult findMembers(String memberId,String firstname, String lastName, String dob,String zip, String state , String filterBy){
        //ToDo: implement service with more filters
        return null;    
    }
     public Continuation StartRequest(String memberId, ACETMemberDetail MemberDetail, String CallbackMethodName, Continuation oContinuation)
    {   
        if(memberDetail == null){
            memberDetail = new ACETMemberDetail();
        }
         getEndpoint();
         GetRequestBody(MemberDetail.PreferredCoverage.SurrogateKey, MemberDetail.PreferredCoverage.groupNumber, ACETWebServicehelper.formatToYYYYMMDD(MemberDetail.PreferredCoverage.effectiveDate));
        oContinuation = AddHttpRequest(OAuthConfig, CallbackMethodName, oContinuation);
        return oContinuation;         
    }
     public ACETWSCalloutResult ProcessResponse(String HttpRequestLabel, ACETMemberDetail memberDetail){

        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        if(memberDetail == null){
            memberDetail = new ACETMemberDetail();
        }
        
        try{
           HttpResponse response = GetHttpResponse(HttpRequestLabel);     
           if(response!=null){
           
            calloutResult.statusCode=response.getStatusCode();
            if(response.getStatusCode() == 200){
                if(response.getBody() != null){
                    //replace date with date2 as date is a preserved keyword
                    String responseBody = response.getBody().contains('\"date\":')?response.getBody().replace('\"date\":', '\"date2\":'):response.getBody();
                    //replace desc with desc2 as desc is a preserved keyword
                    responseBody = response.getBody().contains('\"desc\":')?responseBody.replace('\"desc\":', '\"desc2\":'):response.getBody();
                    system.debug('responseBody-->'+responseBody);
                    ACETFamilyMembershipJson2Apex jSON2Apex = (ACETFamilyMembershipJson2Apex)JSON.deserialize(responseBody, ACETFamilyMembershipJson2Apex.class);
                    memberDetail.FamilyMembers = new List<ACETMemberDetail.FamilyMember>();
                    List<ACETMemberDetail.COB> amdlstCOB = new List<ACETMemberDetail.COB>();  
                    List<ACETFamilyMembershipJson2Apex.cls_individual> famMembers = jSON2Apex!=null?jSON2Apex.getFamilyMembershipResponse!=null?jSON2Apex.getFamilyMembershipResponse.individual:null:null;
                    if(famMembers!=null && famMembers.size()>0){
                      for(ACETFamilyMembershipJson2Apex.cls_individual individual : famMembers){
                        ACETMemberDetail.FamilyMember fm = new ACETMemberDetail.FamilyMember();
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
                        
                        fm.Addresses = new List<ACETMemberDetail.Address>();
                        if(individual.address != null && individual.address.size()>0){
                            for(ACETFamilyMembershipJson2Apex.cls_address addr : individual.address){
                                ACETMemberDetail.Address address = new ACETMemberDetail.Address();
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
                        //Khoushik adding code for Coordination Of Benefits
                        if(individual.membership!=null && individual.membership.size()>0){
                          for(ACETFamilyMembershipJson2Apex.cls_membership membership : individual.membership){
        if(membership.coverages!=null && membership.coverages.size()>0){
                              for(ACETFamilyMembershipJson2Apex.cls_coverages cov : membership.coverages){
                                  fm.memberStatus = (cov != null && cov.memberStatus != null)?cov.memberStatus:'';
                              }
        }
          if(membership.cob!=null && membership.cob.size()>0){
                            for(ACETFamilyMembershipJson2Apex.cls_cob cob : membership.cob){
                                
                              Date Startdt = null;
                              Date Enddt = null;
                              Date LastUpdate = null;
                              if(cob!=null && String.isNotBlank(cob.otherInsuranceVerifyDate)){
                                LastUpdate = Date.ValueOf(cob.otherInsuranceVerifyDate); 
                              }
                              ACETMemberDetail.COB cb = new ACETMemberDetail.COB();
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
                            }
                              if(cb.DateOfBirth != null && cb.DateOfBirth != '' ){
                                  Date dob = Date.parse(cb.DateOfBirth);
                                  Integer days = dob.daysBetween(Date.Today());
                                  Integer age = Integer.valueOf(days/365);
                                  cb.Age = String.valueOf(age);
                                  cb.BenefitType = String.isNotBlank(cob.cobTypeCodeDescription)?cob.cobTypeCodeDescription:'';  
                              } 
                          
                              if(coverageTypeVsDescMap!=null && coverageTypeVsDescMap.size()>0 && String.isNotBlank(cob.coverageType))
                                  cb.InsuranceType =coverageTypeVsDescMap.get(cob.coverageType);
                              if(cob != null){
                                    cb.otherInsuranceCardholderId = cob.otherInsuranceCardholderId;
                                }                                                             
                              if(cob != null && cob.coverageType == '2' ){
                                //medicare entitlement code will come for this value
                                cb.medicareEntitlementType = cob.medicareEntitlementType;
                              }
                              
                              cb.COBTypeDesc = cob!=null?(cob.cobTypeCode == 'MD' ? 'Medical Care' : (cob.cobTypeCode == 'RX' ? 'Pharmacy' : '')):'';
                             // cb.COBTypeDesc = //cob.cobTypeCodeDescription;
                             cb.OrderOfBenefit ='';
                             if(primaryIndicatorVsDescMap!=null && primaryIndicatorVsDescMap.size()>0 
                                && cob!=null && String.isNotBlank(cob.otherInsurancePrimacyIndicator))
                                   cb.OrderOfBenefit = primaryIndicatorVsDescMap.get(cob.otherInsurancePrimacyIndicator);
                             cb.IsOtherInsurancePrimary = cob!=null?String.isNotBlank(cob.otherInsurancePrimacyIndicator)?cob.otherInsurancePrimacyIndicator:'':'';
                             //system.debug('cobEffectiveStartDate' + cob.cobEffectiveStartDate);
                             //system.debug('cobEffectiveEndDate' + cob.cobEffectiveEndDate);
                              if(cob!=null && cob.cobEffectiveStartDate != null && String.isNotBlank(cob.cobEffectiveStartDate)){
                                    Startdt = Date.ValueOf(cob.cobEffectiveStartDate);  
                              }
                              if(cob!=null && cob.cobEffectiveEndDate != null && String.isNotBlank(cob.cobEffectiveEndDate)){
                                    Enddt = Date.ValueOf(cob.cobEffectiveEndDate);  
                              }
                               
                              cb.Startdt = Startdt;
                              cb.Enddt = Enddt;
                              //LastUpdate
                              if(membership.coverages!=null && membership.coverages.size()>0){
                               for(ACETFamilyMembershipJson2Apex.cls_coverages cov : membership.coverages){
                                if(cov.bundleOptions != null && cov.bundleOptions.size()>0){  
                                for(ACETFamilyMembershipJson2Apex.cls_bundleOptions bun : cov.bundleOptions){
                                   if(bun.benefits != null && bun.benefits.size()> 0){  
                                    for(ACETFamilyMembershipJson2Apex.cls_benefits benefits : bun.benefits){
                                                        String benefitEffDate = String.isNotBlank(benefits.benefitEffectiveDate)?String.valueof(Date.valueof(benefits.benefitEffectiveDate).format()):'';
                                                        String benefitEndDate = String.isNotBlank(benefits.benefitExpirationDate)?String.valueof(Date.valueof(benefits.benefitExpirationDate).format()):'';
                                                        Date newEffectiveDate = Date.newInstance(Integer.valueOf(memberDetail.PreferredCoverage.EffectiveDate.split('/')[2]), Integer.valueOf(memberDetail.PreferredCoverage.EffectiveDate.split('/')[0]), Integer.valueOf(memberDetail.PreferredCoverage.EffectiveDate.split('/')[1]));
                                                        if(memberDetail.PreferredCoverage != null && memberDetail.PreferredCoverage.EndDate != null){
                                                            Date newEndDate = Date.newInstance(Integer.valueOf(memberDetail.PreferredCoverage.EndDate.split('/')[2]), Integer.valueOf(memberDetail.PreferredCoverage.EndDate.split('/')[0]), Integer.valueOf(memberDetail.PreferredCoverage.EndDate.split('/')[1]));
                                                        }    
                                                        system.debug('Effective'+newEffectiveDate+'//'+benefitEffDate+'//Ben End'+benefitEndDate);
                                                                                                   //the below is based on the assumption that all bundles under this coverage have the same coverage date, in the future if the bundles can be separated, this will show the incorrect status
                                                      fm.termDateStr = '';
                                                        if(fm.MemberStatus == 'TERM' && benefitEndDate != '12/31/9999'){
                                                          fm.termDateStr = benefitEndDate;
                                                        }
                                                        fm.MemberId = String.isNotBlank(benefits.memberIdCardSerialNumber)?benefits.memberIdCardSerialNumber:'';
                                                        cb.MemberId = String.isNotBlank(benefits.memberIdCardSerialNumber)?benefits.memberIdCardSerialNumber:'';
                   
                                        system.debug('HEREHERE2 ' + benefits);
                                        
                              cb.Relationship = String.isNotBlank(benefits.relationshipDescription)?benefits.relationshipDescription:'';
                                      system.debug('benefits.relationshipCode--->'+benefits.relationshipCode);
                                        fm.Relationship =  String.isNotBlank(benefits.relationshipCode)?benefits.relationshipCode:'';  
                                        fm.subscriberIndividualId = String.isNotBlank(benefits.memberIdCardSerialNumber)?benefits.memberIdCardSerialNumber:'';
                                        fm.FamilyId = String.isNotBlank(benefits.memberIdCardSerialNumber)?benefits.memberIdCardSerialNumber:'';
                                        fm.benefitBundleOptionId = String.isNotBlank(benefits.benefitBundleOptionId)?benefits.benefitBundleOptionId:'';
          
                                                                                     
                                           if(memberDetail.PreferredCoverage!=null && memberDetail.PreferredCoverage.EffectiveDate!=null && memberDetail.PreferredCoverage.EndDate!=null){                                                 

                                               Date EffDate = Date.newInstance(Integer.valueOf(memberDetail.PreferredCoverage.EffectiveDate.split('/')[2]), Integer.valueOf(memberDetail.PreferredCoverage.EffectiveDate.split('/')[0]), Integer.valueOf(memberDetail.PreferredCoverage.EffectiveDate.split('/')[1]));
                                               Date EndDate = Date.newInstance(Integer.valueOf(memberDetail.PreferredCoverage.EndDate.split('/')[2]), Integer.valueOf(memberDetail.PreferredCoverage.EndDate.split('/')[0]), Integer.valueOf(memberDetail.PreferredCoverage.EndDate.split('/')[1]));
                                               Date benEffDate = Date.newInstance(Integer.valueOf(ACETWebserviceHelper.formatDateFromDashToSlash(benefits.benefitEffectiveDate).split('/')[2]), Integer.valueOf(ACETWebserviceHelper.formatDateFromDashToSlash(benefits.benefitEffectiveDate).split('/')[0]), Integer.valueOf(ACETWebserviceHelper.formatDateFromDashToSlash(benefits.benefitEffectiveDate).split('/')[1]));
                                               Date benEndDate =Date.newInstance(Integer.valueOf(ACETWebserviceHelper.formatDateFromDashToSlash(benefits.benefitExpirationDate).split('/')[2]), Integer.valueOf(ACETWebserviceHelper.formatDateFromDashToSlash(benefits.benefitExpirationDate).split('/')[0]), Integer.valueOf(ACETWebserviceHelper.formatDateFromDashToSlash(benefits.benefitExpirationDate).split('/')[1]));
                                            if(memberDetail.PreferredCoverage.benefitPlanId == benefits.benefitPlanId && memberDetail.PreferredCoverage.coverageMemberId == benefits.memberIdCardSerialNumber && EffDate==benEffDate && EndDate==benEndDate){                                                                     
           
                                                     memberDetail.MemberId = String.isNotBlank(benefits.memberIdCardSerialNumber)?benefits.memberIdCardSerialNumber:'' ;
                                                     if(String.isBlank(memberDetail.MemberId) ){
                                                         calloutResult.statusCode=212;//212-->Note that all information may not have loaded on the page. Continue to service the call following your normal protocols
                                                     }
                                                                 
                                                     memberDetail.RelationShip = String.isNotBlank(benefits.relationshipCode)?ACETRelationshipCodes__c.getValues(benefits.relationshipCode).Description__c:'';
                                                     memberDetail.RelationShipCode = String.isNotBlank(benefits.relationshipCode)?benefits.relationshipCode:'';
                                                     memberDetail.BenefitPlanId = String.isNotBlank(benefits.benefitPlanId)?benefits.benefitPlanId:'';
                                                     if(String.isBlank(memberDetail.benefitPlanId) ){
                                                        calloutResult.statusCode=212;//212-->Note that all information may not have loaded on the page. Continue to service the call following your normal protocols
                                                     }
                                                     memberDetail.QMSCOIndicator = benefits.indicators != null && benefits.indicators.qmscoindicator != null ? (benefits.indicators.qmscoIndicator.equals('Y') ? 'Yes' : 'No') : 'No';
                                                     //Field mapping added by Avish for getSubscription webservice User Stroy US652217 field mapping on 06072017
                                                     memberDetail.BundleOptionID = String.isNotBlank(benefits.benefitBundleOptionId)?benefits.benefitBundleOptionId:'';     
                                                     memberDetail.hsaAvailable = (benefits.indicators != null && benefits.indicators.hsaIndicator != null)?(benefits.indicators.hsaIndicator.equals('Y') ? 'Yes' : 'No'):'No';
                                                        //Rama:Added to get the coverage level from getMembeship   
                                                     memberDetail.CoverageLevelCode = (benefits.coverageLevelCode!= Null) && String.isNotBlank(benefits.coverageLevelCode)?benefits.coverageLevelCode:'';                                                          
                                                     system.debug('CoverageLevelCode***'+memberDetail.CoverageLevelCode);
                                                     memberDetail.Network = (benefits.networkScheduleID != null)?benefits.networkScheduleID:'';
                                                     memberDetail.MemberStatus = String.isNotBlank(cov.memberStatus)?cov.memberStatus:'';
                                                     memberDetail.TerminationReason = String.isNotBlank(benefits.cancelReasonTypeCode)?benefits.cancelReasonTypeCode:'';
                                                     //Added by Avish on 11/15/2017 as a part of US809970
                                                     memberDetail.EligibilityStatus = (benefits.eligibilityStatusCode != Null) && String.isNotBlank(benefits.eligibilityStatusCode)?((EligibilityCodeVsStatusMap.get(benefits.eligibilityStatusCode) == 'COBRA' || EligibilityCodeVsStatusMap.get(benefits.eligibilityStatusCode) == 'SURVIVING INSURED')?EligibilityCodeVsStatusMap.get(benefits.eligibilityStatusCode):''):'';
                                                     memberDetail.PlanType = (benefits.planType != Null) && String.isNotBlank(benefits.planType)?PlanTypeCodeMap.get(benefits.planType):'';
                                                     memberDetail.FundingArragement = String.isNotBlank(benefits.fundingArrangementDescription)?benefits.fundingArrangementDescription:'';
                                                     if(benefits.coverageLevelList!=null && !benefits.coverageLevelList.isEmpty()){
                                                     memberDetail.lstCoverageLineHistory = new List<ACETMemberDetail.CoverageLineHistory>();
                                                         for(ACETFamilyMembershipJson2Apex.cls_coverageLevelList coverageList : benefits.coverageLevelList){
                                                             ACETMemberDetail.CoverageLineHistory clh = new ACETMemberDetail.CoverageLineHistory();   
                                                             clh.covLevelCode = String.isNotBlank(coverageList.covLevelCode)?coverageList.covLevelCode:'';
                                                             clh.covLevelDesc = String.isNotBlank(coverageList.covLevelDesc)?coverageList.covLevelDesc:'';
                                                             string effd = coverageList.covLevelEffDate;
                                                             string exd = coverageList.covLevelExpDate;
                                                             if(String.isNotBlank(effd))
                                                                 clh.covLevelEffDate = Date.newInstance(Integer.valueOf(effd.split('-')[0]), Integer.valueOf(effd.split('-')[1]), Integer.valueOf(effd.split('-')[2]));
                                                             if(String.isNotBlank(exd))
                                                                 clh.covLevelExpDate= Date.newInstance(Integer.valueOf(exd.split('-')[0]), Integer.valueOf(exd.split('-')[1]), Integer.valueOf(exd.split('-')[2]));
                                                             memberDetail.lstCoverageLineHistory.add(clh); 
                                                             //memberDetail.GatedPlan = 'sjain';//coverageList.GatedPlan;
                                                         }
                                                     }
                                                     break;
                                                 }
					   }
                                        //US2962032 end 
                                                
                                    }  
                                   }
                                    
                                }    
                                fm.groupNumber =  String.isNotBlank(cov.groupNumber)?cov.groupNumber:'';
                                }
                               }
                                  //US2962032 Start
                                  system.debug('----------Membership.providers---------->'+Membership.providers);
                                   if(memberDetail.PCPAssignments == null || memberDetail.PCPAssignments.size()==0) //DE381695: PGA 1817 - PCP not displaying correctly in ACET Classic
                                 {
                             memberDetail.PCPAssignments = new List<ACETMemberDetail.PCPAssignment>();
                             for(ACETFamilyMembershipJson2Apex.cls_providers provider : Membership.providers ){
                                 ACETMemberDetail.PCPAssignment pcp = new ACETMemberDetail.PCPAssignment();

                                 pcp.FirstName = String.isNotBlank(provider.firstName)?provider.firstName:'';  
                                 pcp.LastName = String.isNotBlank(provider.lastName)?provider.lastName:'';
                                 pcp.pcpAssignmentType = String.isNotBlank(provider.assignmentType)?provider.assignmentType:'';
                                 pcp.locationAffiliationID = String.isNotBlank(provider.locationAffiliationID)?provider.locationAffiliationID:''; //27109358 - Added by Avish 09/10/2018
                                 if(provider.providerIdentifiers != null){


                                     for(ACETFamilyMembershipJson2Apex.cls_providerIdentifiers ppi : provider.providerIdentifiers){                              
                                         if(ppi.type == 'NPI'){
                                             pcp.id = String.isNotBlank(ppi.id)?ppi.id:'';
                                             pcp.identifiertype = String.isNotBlank(ppi.type)?ppi.type:'';  
                                         }
                                         if(ppi.type == 'LTK' && (pcp.id == null || pcp.id == '')){
                                             pcp.id = String.isNotBlank(ppi.id)?ppi.id:'';
                                             pcp.identifiertype = String.isNotBlank(ppi.type)?ppi.type:''; 
                                         }                                   
                                     }
                                 }
                            
                                 system.debug('----Dates---->'+provider.effectiveDate+'-----Today----->'+Date.Today());
                                 if(provider.expirationDate != null && provider.expirationDate != ''){
                                     pcp.endDate = formatdate(provider.expirationDate); 
                                     pcp.isActive = isActive(provider.expirationDate);         
                                 }               
                                 //memberDetail.Network = OIL Gap
                                 if(provider.effectiveDate != null && provider.effectiveDate != '')
                                     pcp.effectiveDate = formatdate(provider.effectiveDate);
                                 //  pcp.effectiveDate = date.parse('05/05/2017');
                                 system.debug('----Dates---->'+pcp.effectiveDate+'-----Today----->'+Date.Today());
                                 if(!String.IsEmpty(provider.firstName) && !String.IsEmpty(provider.lastName) && !String.IsEmpty(provider.assignmentType) && !String.IsEmpty(provider.effectiveDate) && !String.IsEmpty(provider.expirationDate) && fm.subscriberIndividualId == memberDetail.MemberId){
                                     memberDetail.PCPAssignments.add(pcp);   
                                 }

                             }
                                  //US2962032 end 
                              }
                              }
                              cb.LastUpdate = LastUpdate;
                              system.debug('232323membership.identifiers'+membership);
                              //cb.MemberId = String.isNotBlank(individual.individualIdentifier)?individual.individualIdentifier:'';
                             if(cob!=null){
                              cb.MedicareType = String.isNotBlank(cob.coverageType)?cob.coverageType:'';
                              cb.IsMedicarePrimary = String.isNotBlank(cob.otherInsurancePrimacyIndicator)?cob.otherInsurancePrimacyIndicator:''; 
                              cb.OtherInsuranceCarrierName = String.isNotBlank(cob.OtherInsuranceCarrierName)?cob.OtherInsuranceCarrierName:'';  
                              }
                              amdlstCOB.add(cb);
                             }
                            }
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
                        if(counter <= (memberDetail.FamilyMembers.size() - 1) || (counter < memberDetail.FamilyMembers.size()) && memberDetail.FamilyMembers.size() <= 1){
                 memberDetail.FamilyMembers.add(counter, fm);
              } else {
                 memberDetail.FamilyMembers.add(fm);
              }
                      }
                      }
                      system.debug('amdlstCOB'+amdlstCOB);                    
                     memberDetail.lstCOB = amdlstCOB; 
                    system.debug(memberDetail);                                                           
                    calloutResult.Success = true;
                    calloutResult.Message = '';
                    calloutResult.Response = memberDetail;                      
                
                        
                                   
                }
                
            }else {
                calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                calloutResult.Success = false;                
                calloutResult.Response = memberDetail;
                calloutResult.Message = ACETWebserviceHelper.getErrorMessageFromCode(response.getStatusCode());
             }
            }
            else{//when response is coming null
                 calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                 calloutResult.Success = false;
                 calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
                 calloutResult.statusCode=999;
             }
            }catch(Exception e){
                    system.debug(e);
                    calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
                    calloutResult.Success = false;
                    calloutResult.Message = 'Web Service or External System is temporarily unavailable.'+e.getStackTraceString() + e.getMessage();
                    calloutResult.statusCode=999;

           }
        
        return calloutResult;    
    }   
     public boolean isActive(String expdate){
        if(!String.IsEmpty(expdate)){
            system.debug('expdate' + expdate);
            Date d = Date.valueOf(expdate);
            return d > date.today();
        }
        else
        {
            return false;

        }       
    } 
}