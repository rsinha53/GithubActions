public class SAEGetMemberProviderWebService {
    
    public static ACETWSCalloutResult processResponse(HttpResponse response) {
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();
        calloutResult.statusCode = response.getStatusCode();
        String responseStr = response.getBody();
        System.debug('@@ SAEGetMemberProviderWebService: response.getStatusCode(): ' + response.getStatusCode());
        System.debug('@@ SAEGetMemberProviderWebService: processResponse: ' + responseStr);
        
        
        if (responseStr != null && String.isNotBlank(responseStr) && response.getStatusCode() == 200) {
            //calloutResult.statusCode=response.getStatusCode();
            calloutResult.statusCode = response.getStatusCode();
            
            SAEMemberProviderSearchCoveragesResult returnReponse = new SAEMemberProviderSearchCoveragesResult();
            
            SAEEligibilityResponseJSON2Apex json2Apex = SAEEligibilityResponseJSON2Apex.parse(responseStr);
            List < SAEEligibilityResponseJSON2Apex.MemberPolicies > memberpolicies = new List < SAEEligibilityResponseJSON2Apex.MemberPolicies > ();
            
            //Highlight logic related variables
            Date currentDate = null;
            Map<String, Date> activeMedicalPolicyMap = new Map<String, Date>();
            Map<String, Date> activeNonMedicalPolicyMap = new Map<String, Date>();
            Map<String, Date> inactiveMedicalPolicyMap = new Map<String, Date>();
            Map<String, Date> inactiveMedicalPolicyWithEnddateMap = new Map<String, Date>();
            Map<String, Date> inactiveNonMedicalPolicyMap = new Map<String, Date>();
            
            
            if (json2Apex != null) {
                system.debug('json2Apex.memberPolicies@@ ' + json2Apex.memberPolicies);
                
                List < SAEMemberProviderSearchCoveragesResult.CoverageLine > policyLine = new List < SAEMemberProviderSearchCoveragesResult.CoverageLine > ();
                if (json2Apex.memberPolicies != null) {
                    
                    SAEMemberProviderSearchCoveragesResult.CoverageLine coverageline;
                    memberpolicies = json2Apex.memberPolicies;
                    String transactionId = null;
                    
                    for (SAEEligibilityResponseJSON2Apex.MemberPolicies policies: memberpolicies) {
                        coverageline = new SAEMemberProviderSearchCoveragesResult.CoverageLine();
                        //US2137922: Added by Ravindra start
                        SAEMemberProviderSearchCoveragesResult.PatientInfo patientInfo = new SAEMemberProviderSearchCoveragesResult.PatientInfo();
                        System.debug('@@ coverageline before: ');
                        if (policies.patientInfo != null) {
                            for (SAEEligibilityResponseJSON2Apex.PatientInfo pat: policies.patientInfo) {
                                System.debug('@@ coverageline inside pat: ' + pat);
                                if (pat.searched == 'true') {
                                    System.debug('@@ coverageline inside concat: ' + pat.firstName + ' ' + pat.middleName + ' ' + pat.lastName);
                                    patientInfo.fullName = pat.firstName + ' ' + pat.middleName + ' ' + pat.lastName;
                                    patientInfo.firstName = pat.firstName;//US3814287
                                    patientInfo.Age = String.isNotBlank(pat.dateOfBirth) ? SAEUtils.getAgeFromBirthDate(pat.dateOfBirth) : '';
                                    patientInfo.dob = String.isNotBlank(pat.dateOfBirth) ? SAEUtils.formatDate(pat.dateOfBirth)+','+patientInfo.Age : '';
                                    patientInfo.gender = pat.gender;
                                    //patientInfo.groupNumber = pat.GroupNumber;
                                    System.debug('@@ coverageline inside: ');
                                    //Code for Address mappings
                                    patientInfo.AddressLine1 = pat.addressLine1;
                                    patientInfo.AddressLine2 = pat.addressLine2;
                                    patientInfo.City = pat.city;
                                    patientInfo.State = pat.state;
                                    patientInfo.Zip = pat.zip.substring(0, 5);
                                    if (String.isNotBlank(policies.policyInfo.memberId)) {
                                        patientInfo.MemberId = policies.policyInfo.memberId;
                                    }
                                    // US1741780 Tech Story: Benefit and Coverage Benefit Limits - Sarma
                                    patientInfo.patientKey = String.isNotBlank(pat.patientKey) ? pat.patientKey : '';
                                    // US3089172	Plan Benefits: Benefit Check with PA Button Search DataPopulation - Sarma - 18/12/2020
                                    patientInfo.relationship = String.isNotBlank(pat.relationship) ? pat.relationship : '';
                                    // Policy switching
                                    List<String> dobStr = String.isNotBlank(pat.dateOfBirth) ? pat.dateOfBirth.split('-') : new List<String>();
                                    String dayStr = '';
                                    if(dobStr.size() > 0){
                                        dayStr = dobStr[1]+dobStr[2]+dobStr[0];
                                    }
                                    patientInfo.xRefId = pat.firstName+pat.lastName+dayStr+policies.policyInfo.memberId+policies.insuranceInfo.groupNumber;
                                    patientInfo.xRefIdORS = pat.firstName+policies.policyInfo.memberId+'0'+policies.insuranceInfo.groupNumber;
                                    patientInfo.dobVal = String.isNotBlank(pat.dateOfBirth) ? SAEUtils.formatDate(pat.dateOfBirth) : '';

                                    coverageline.patientInfo = patientInfo;
                                    System.debug('@@ coverageline inside patientInfo: ' + patientInfo);
                                    System.debug('@@ coverageline inside coverageline: ' + coverageline);
                                    break;
                                }
                            }
                        }
                        //US2611720 _vishnu
                        SAEMemberProviderSearchCoveragesResult.FinanciDeOutalFlags finDeOutFlg =new SAEMemberProviderSearchCoveragesResult.FinanciDeOutalFlags();
                        SAEMemberProviderSearchCoveragesResult.DeductibleInfo deductInfo = new SAEMemberProviderSearchCoveragesResult.DeductibleInfo();
                        SAEMemberProviderSearchCoveragesResult.individual indivudalInfo = new SAEMemberProviderSearchCoveragesResult.individual();
                        SAEMemberProviderSearchCoveragesResult.individual familyInfo = new SAEMemberProviderSearchCoveragesResult.individual();
                        SAEMemberProviderSearchCoveragesResult.inNetwork inNetworkInfo = new SAEMemberProviderSearchCoveragesResult.inNetwork();
                        SAEMemberProviderSearchCoveragesResult.inNetwork inNetworkTier1Info = new SAEMemberProviderSearchCoveragesResult.inNetwork();
                        SAEMemberProviderSearchCoveragesResult.inNetwork outOfNetworkInfo = new SAEMemberProviderSearchCoveragesResult.inNetwork();
                        
                        //OOP
                        SAEMemberProviderSearchCoveragesResult.OutofPocketInfo oOPInfo = new SAEMemberProviderSearchCoveragesResult.OutofPocketInfo();
                        SAEMemberProviderSearchCoveragesResult.individual oopindivudalInfo = new SAEMemberProviderSearchCoveragesResult.individual();
                        SAEMemberProviderSearchCoveragesResult.individual oopfamilyInfo = new SAEMemberProviderSearchCoveragesResult.individual();
                        SAEMemberProviderSearchCoveragesResult.inNetwork oopinNetworkInfo = new SAEMemberProviderSearchCoveragesResult.inNetwork();
                        SAEMemberProviderSearchCoveragesResult.inNetwork oopinNetworkTier1Info = new SAEMemberProviderSearchCoveragesResult.inNetwork();
                        SAEMemberProviderSearchCoveragesResult.inNetwork oopoutOfNetworkInfo = new SAEMemberProviderSearchCoveragesResult.inNetwork();
                        
                        if (policies.DeductibleInfo != null) {
                            if(policies.DeductibleInfo.individual != null){
                                indivudalInfo.found = policies.DeductibleInfo.individual.found;
                                finDeOutFlg.deindividualFlg=policies.DeductibleInfo.individual.found;
                                if(policies.DeductibleInfo.individual.inNetwork != null){
                                    inNetworkInfo.found = policies.DeductibleInfo.individual.inNetwork.found;
                                    finDeOutFlg.deIndInnFlg=policies.DeductibleInfo.individual.inNetwork.found;
                                    inNetworkInfo.customerNetworkTier1 = policies.DeductibleInfo.individual.inNetwork.customerNetworkTier1;
                                    inNetworkInfo.metYtdAmount = policies.DeductibleInfo.individual.inNetwork.metYtdAmount;
                                    inNetworkInfo.planAmount = policies.DeductibleInfo.individual.inNetwork.planAmount;
                                    inNetworkInfo.planAmountFrequency = policies.DeductibleInfo.individual.inNetwork.planAmountFrequency;
                                    inNetworkInfo.remainingAmount = policies.DeductibleInfo.individual.inNetwork.remainingAmount;
                                }
                                if(policies.DeductibleInfo.individual.inNetworkTier1 != null){
                                    inNetworkTier1Info.found = policies.DeductibleInfo.individual.inNetworkTier1.found;
                                    finDeOutFlg.deIndTier1Flg=policies.DeductibleInfo.individual.inNetworkTier1.customerNetworkTier1;//DE350660
                                    inNetworkTier1Info.customerNetworkTier1 = policies.DeductibleInfo.individual.inNetworkTier1.customerNetworkTier1;
                                    inNetworkTier1Info.metYtdAmount = policies.DeductibleInfo.individual.inNetworkTier1.metYtdAmount;
                                    inNetworkTier1Info.planAmount = policies.DeductibleInfo.individual.inNetworkTier1.planAmount;
                                    inNetworkTier1Info.planAmountFrequency = policies.DeductibleInfo.individual.inNetworkTier1.planAmountFrequency;
                                    inNetworkTier1Info.remainingAmount = policies.DeductibleInfo.individual.inNetworkTier1.remainingAmount;
                                }
                                if(policies.DeductibleInfo.individual.outOfNetwork != null){
                                    outOfNetworkInfo.found = policies.DeductibleInfo.individual.outOfNetwork.found;
                                    finDeOutFlg.deIndOonFlg=policies.DeductibleInfo.individual.outOfNetwork.found;
                                    outOfNetworkInfo.customerNetworkTier1 = policies.DeductibleInfo.individual.outOfNetwork.customerNetworkTier1;
                                    outOfNetworkInfo.metYtdAmount = policies.DeductibleInfo.individual.outOfNetwork.metYtdAmount;
                                    outOfNetworkInfo.planAmount = policies.DeductibleInfo.individual.outOfNetwork.planAmount;
                                    outOfNetworkInfo.planAmountFrequency = policies.DeductibleInfo.individual.outOfNetwork.planAmountFrequency;
                                    outOfNetworkInfo.remainingAmount = policies.DeductibleInfo.individual.outOfNetwork.remainingAmount;
                                }
                                indivudalInfo.inNetwork = inNetworkInfo;
                                indivudalInfo.inNetworkTier1 = inNetworkTier1Info;
                                indivudalInfo.outOfNetwork = outOfNetworkInfo;
                            }
                            
                            if(policies.DeductibleInfo.family != null){
                                familyInfo.found = policies.DeductibleInfo.family.found;
                                finDeOutFlg.deFamilyFlg=policies.DeductibleInfo.family.found;
                                if(policies.DeductibleInfo.family.inNetwork != null){
                                    inNetworkInfo.found = policies.DeductibleInfo.family.inNetwork.found;
                                    finDeOutFlg.deFlmInnFlg=policies.DeductibleInfo.family.inNetwork.found;
                                    inNetworkInfo.customerNetworkTier1 = policies.DeductibleInfo.family.inNetwork.customerNetworkTier1;
                                    inNetworkInfo.metYtdAmount = policies.DeductibleInfo.family.inNetwork.metYtdAmount;
                                    inNetworkInfo.planAmount = policies.DeductibleInfo.family.inNetwork.planAmount;
                                    inNetworkInfo.planAmountFrequency = policies.DeductibleInfo.family.inNetwork.planAmountFrequency;
                                    inNetworkInfo.remainingAmount = policies.DeductibleInfo.family.inNetwork.remainingAmount;
                                }
                                if(policies.DeductibleInfo.family.inNetworkTier1 != null){
                                    inNetworkTier1Info.found = policies.DeductibleInfo.family.inNetworkTier1.found;
                                    finDeOutFlg.deFlmTier1Flg= policies.DeductibleInfo.family.inNetworkTier1.customerNetworkTier1;//DE350660
                                    inNetworkTier1Info.customerNetworkTier1 = policies.DeductibleInfo.family.inNetworkTier1.customerNetworkTier1;
                                    inNetworkTier1Info.metYtdAmount = policies.DeductibleInfo.family.inNetworkTier1.metYtdAmount;
                                    inNetworkTier1Info.planAmount = policies.DeductibleInfo.family.inNetworkTier1.planAmount;
                                    inNetworkTier1Info.planAmountFrequency = policies.DeductibleInfo.family.inNetworkTier1.planAmountFrequency;
                                    inNetworkTier1Info.remainingAmount = policies.DeductibleInfo.family.inNetworkTier1.remainingAmount;
                                }
                                if(policies.DeductibleInfo.family.outOfNetwork != null){
                                    outOfNetworkInfo.found = policies.DeductibleInfo.family.outOfNetwork.found;
                                    finDeOutFlg.deFlmOonFlg= policies.DeductibleInfo.family.outOfNetwork.found;
                                    outOfNetworkInfo.customerNetworkTier1 = policies.DeductibleInfo.family.outOfNetwork.customerNetworkTier1;
                                    outOfNetworkInfo.metYtdAmount = policies.DeductibleInfo.family.outOfNetwork.metYtdAmount;
                                    outOfNetworkInfo.planAmount = policies.DeductibleInfo.family.outOfNetwork.planAmount;
                                    outOfNetworkInfo.planAmountFrequency = policies.DeductibleInfo.family.outOfNetwork.planAmountFrequency;
                                    outOfNetworkInfo.remainingAmount = policies.DeductibleInfo.family.outOfNetwork.remainingAmount;
                                }
                                familyInfo.inNetwork = inNetworkInfo;
                                familyInfo.inNetworkTier1 = inNetworkTier1Info;
                                familyInfo.outOfNetwork = outOfNetworkInfo;
                            }
                            deductInfo.found = policies.DeductibleInfo.found;
                            finDeOutFlg.deductibleInfoFlg=policies.DeductibleInfo.found;
                            deductInfo.nonMainPlan = policies.DeductibleInfo.nonMainPlan;
                            deductInfo.message = policies.DeductibleInfo.message;
                            deductInfo.inAndOutOfNetworkOnly = policies.DeductibleInfo.inAndOutOfNetworkOnly;
                            deductInfo.individual = indivudalInfo;
                            deductInfo.family = familyInfo;
                        }
                        coverageline.deductibleInfo = deductInfo;
                        
                        //Adding for provider Lookup changes
                        if (policies.outOfPocketInfo != null) {
                            if(policies.outOfPocketInfo.individual != null){
                                oopindivudalInfo.found = policies.outOfPocketInfo.individual.found;
                                if(policies.outOfPocketInfo.individual.inNetwork != null){
                                    oopinNetworkInfo.found = policies.outOfPocketInfo.individual.inNetwork.found;
                                    oopinNetworkInfo.customerNetworkTier1 = policies.outOfPocketInfo.individual.inNetwork.customerNetworkTier1;
                                    oopinNetworkInfo.metYtdAmount = policies.outOfPocketInfo.individual.inNetwork.metYtdAmount;
                                    oopinNetworkInfo.planAmount = policies.outOfPocketInfo.individual.inNetwork.planAmount;
                                    oopinNetworkInfo.planAmountFrequency = policies.outOfPocketInfo.individual.inNetwork.planAmountFrequency;
                                    oopinNetworkInfo.remainingAmount = policies.outOfPocketInfo.individual.inNetwork.remainingAmount;
                                }
                                if(policies.outOfPocketInfo.individual.inNetworkTier1 != null){
                                    oopinNetworkTier1Info.found = policies.outOfPocketInfo.individual.inNetworkTier1.found;
                                    oopinNetworkTier1Info.customerNetworkTier1 = policies.outOfPocketInfo.individual.inNetworkTier1.customerNetworkTier1;
                                    oopinNetworkTier1Info.metYtdAmount = policies.outOfPocketInfo.individual.inNetworkTier1.metYtdAmount;
                                    oopinNetworkTier1Info.planAmount = policies.outOfPocketInfo.individual.inNetworkTier1.planAmount;
                                    oopinNetworkTier1Info.planAmountFrequency = policies.outOfPocketInfo.individual.inNetworkTier1.planAmountFrequency;
                                    oopinNetworkTier1Info.remainingAmount = policies.outOfPocketInfo.individual.inNetworkTier1.remainingAmount;
                                }
                                if(policies.outOfPocketInfo.individual.outOfNetwork != null){
                                    oopoutOfNetworkInfo.found = policies.outOfPocketInfo.individual.outOfNetwork.found;
                                    oopoutOfNetworkInfo.customerNetworkTier1 = policies.outOfPocketInfo.individual.outOfNetwork.customerNetworkTier1;
                                    oopoutOfNetworkInfo.metYtdAmount = policies.outOfPocketInfo.individual.outOfNetwork.metYtdAmount;
                                    oopoutOfNetworkInfo.planAmount = policies.outOfPocketInfo.individual.outOfNetwork.planAmount;
                                    oopoutOfNetworkInfo.planAmountFrequency = policies.outOfPocketInfo.individual.outOfNetwork.planAmountFrequency;
                                    oopoutOfNetworkInfo.remainingAmount = policies.outOfPocketInfo.individual.outOfNetwork.remainingAmount;
                                }
                                oopindivudalInfo.inNetwork = inNetworkInfo;
                                oopindivudalInfo.inNetworkTier1 = inNetworkTier1Info;
                                oopindivudalInfo.outOfNetwork = outOfNetworkInfo;
                            }
                            
                            if(policies.outOfPocketInfo.family != null){
                                oopfamilyInfo.found = policies.outOfPocketInfo.family.found;
                                if(policies.outOfPocketInfo.family.inNetwork != null){
                                    oopinNetworkInfo.found = policies.outOfPocketInfo.family.inNetwork.found;
                                    oopinNetworkInfo.customerNetworkTier1 = policies.outOfPocketInfo.family.inNetwork.customerNetworkTier1;
                                    oopinNetworkInfo.metYtdAmount = policies.outOfPocketInfo.family.inNetwork.metYtdAmount;
                                    oopinNetworkInfo.planAmount = policies.outOfPocketInfo.family.inNetwork.planAmount;
                                    oopinNetworkInfo.planAmountFrequency = policies.outOfPocketInfo.family.inNetwork.planAmountFrequency;
                                    oopinNetworkInfo.remainingAmount = policies.outOfPocketInfo.family.inNetwork.remainingAmount;
                                }
                                if(policies.outOfPocketInfo.family.inNetworkTier1 != null){
                                    oopinNetworkTier1Info.found = policies.outOfPocketInfo.family.inNetworkTier1.found;
                                    oopinNetworkTier1Info.customerNetworkTier1 = policies.outOfPocketInfo.family.inNetworkTier1.customerNetworkTier1;
                                    oopinNetworkTier1Info.metYtdAmount = policies.outOfPocketInfo.family.inNetworkTier1.metYtdAmount;
                                    oopinNetworkTier1Info.planAmount = policies.outOfPocketInfo.family.inNetworkTier1.planAmount;
                                    oopinNetworkTier1Info.planAmountFrequency = policies.outOfPocketInfo.family.inNetworkTier1.planAmountFrequency;
                                    oopinNetworkTier1Info.remainingAmount = policies.outOfPocketInfo.family.inNetworkTier1.remainingAmount;
                                }
                                if(policies.outOfPocketInfo.family.outOfNetwork != null){
                                    oopoutOfNetworkInfo.found = policies.outOfPocketInfo.family.outOfNetwork.found;
                                    oopoutOfNetworkInfo.customerNetworkTier1 = policies.outOfPocketInfo.family.outOfNetwork.customerNetworkTier1;
                                    oopoutOfNetworkInfo.metYtdAmount = policies.outOfPocketInfo.family.outOfNetwork.metYtdAmount;
                                    oopoutOfNetworkInfo.planAmount = policies.outOfPocketInfo.family.outOfNetwork.planAmount;
                                    oopoutOfNetworkInfo.planAmountFrequency = policies.outOfPocketInfo.family.outOfNetwork.planAmountFrequency;
                                    oopoutOfNetworkInfo.remainingAmount = policies.outOfPocketInfo.family.outOfNetwork.remainingAmount;
                                }
                                oopfamilyInfo.inNetwork = oopinNetworkInfo;
                                oopfamilyInfo.inNetworkTier1 = oopinNetworkTier1Info;
                                oopfamilyInfo.outOfNetwork = oopoutOfNetworkInfo;
                            }
                            oOPInfo.found = policies.outOfPocketInfo.found;
                            oOPInfo.nonMainPlan = policies.outOfPocketInfo.nonMainPlan;
                            oOPInfo.message = policies.outOfPocketInfo.message;
                            oOPInfo.inAndOutOfNetworkOnly = policies.outOfPocketInfo.inAndOutOfNetworkOnly;
                            oOPInfo.individual = oopindivudalInfo;
                            oOPInfo.family = oopfamilyInfo;
                        }
                        coverageline.outOfPocketInfo = oOPInfo;
                        
                        //US2611720 _vishnu
                        if (policies.outOfPocketInfo != null)
						{
                            if(policies.outOfPocketInfo.individual != null){
                                finDeOutFlg.outindividualFlg = policies.outOfPocketInfo.individual.found;
                                if(policies.outOfPocketInfo.individual.inNetwork != null){
                                    finDeOutFlg.outIndInnFlg= policies.outOfPocketInfo.individual.inNetwork.found;
                              	}
                                if(policies.outOfPocketInfo.individual.inNetworkTier1 != null){
                                    finDeOutFlg.outIndTier1Flg = policies.outOfPocketInfo.individual.inNetworkTier1.customerNetworkTier1;//DE350660
                                    }
                                if(policies.outOfPocketInfo.individual.outOfNetwork != null){
                                    finDeOutFlg.outIndOonFlg=policies.outOfPocketInfo.individual.outOfNetwork.found;
                                    }

                            }
                            if(policies.outOfPocketInfo.family != null){
                                finDeOutFlg.outFamilyFlg= policies.outOfPocketInfo.family.found;
                                if(policies.outOfPocketInfo.family.inNetwork != null){
                                    finDeOutFlg.outFlmInnFlg=policies.outOfPocketInfo.family.inNetwork.found;
                                }
                                if(policies.outOfPocketInfo.family.inNetworkTier1 != null){
                                    finDeOutFlg.outFlmTier1Flg=policies.outOfPocketInfo.family.inNetworkTier1.customerNetworkTier1;//DE350660
                                }
                                if(policies.outOfPocketInfo.family.outOfNetwork != null){
                                    finDeOutFlg.outFlmOonFlg = policies.outOfPocketInfo.family.outOfNetwork.found;
                                  }

                            }
                            finDeOutFlg.outofpocketInfoFlg=policies.outOfPocketInfo.found;

                        }
                        coverageline.finDeOutFlgs = finDeOutFlg;


                        //end vihnu
                        System.debug('@@ coverageline after: ');
                        //US2137922: Added by Ravindra end
                        //coverageline.highlightedPolicy = true;
                        // US1730904 - Financial Benefits
                        // Sanka Dharmasena - 20-06-2019
                        SAEMemberProviderSearchCoveragesResult.FinancialsWrapper fWrapper = SAEGetMemberProviderWebService.CreateFinancialWrappers(policies);
                        coverageline.financialWrapper = fWrapper;
                        // End
                        
                        String plan = '';
                        String planInsType = '';
                        String startDate = '';
                        String endDate = '';
                        transactionId = policies.transactionId;
                        coverageline.transactionId = policies.transactionId;
                        
                        system.debug('transactionId:::' + transactionId);
                        system.debug('org::' + JSON.serialize(transactionId));
                        system.debug('Tran Length:::' + transactionId.length());
                        
                        coverageline.nonMedicalPolicyBoolean = policies.policyInfo.nonMedicalPolicyBoolean;
                        // US1741780 Tech Story: Benefit and Coverage Benefit Limits
                        coverageline.policyId = String.isNotBlank(policies.policyInfo.id) ? policies.policyInfo.id : '';
                        if (policies.policyInfo != null) {

                            if(policies.policyInfo.eligibilityDates != null) {
                                SAEMemberProviderSearchCoveragesResult.EligibilityDates eligibilityDates = new SAEMemberProviderSearchCoveragesResult.EligibilityDates();
                                eligibilityDates.startDate = String.isNotBlank(policies.policyInfo.eligibilityDates.startDate) ? SAEUtils.formatDate(policies.policyInfo.eligibilityDates.startDate) : '';
                                eligibilityDates.endDate = String.isNotBlank(policies.policyInfo.eligibilityDates.endDate) ? SAEUtils.formatDate(policies.policyInfo.eligibilityDates.endDate) : '';
                            	coverageline.eligibilityDates = eligibilityDates;
                            } // US3816957

                            if (policies.policyInfo.nonMedicalPolicyBoolean == true) {
                                plan = 'Non Medical';
                            } else {
                                plan = 'Medical';
                            }
                            // US2356238 - new val for create Auth
                            if(policies.policyInfo.coverageType != null){
                                coverageline.actualCoverageType =  String.isNotBlank(policies.policyInfo.coverageType) ? policies.policyInfo.coverageType : '';
                            }
                            if (policies.policyInfo.planDates != null) {
                                
                                startDate = String.isNotBlank(policies.policyInfo.planDates.startDate) ? policies.policyInfo.planDates.startDate : '';
                                endDate = String.isNotBlank(policies.policyInfo.planDates.endDate) ? policies.policyInfo.planDates.endDate : '';
                                //coverageline.eligibleDates = formatDate(startDate)+' - '+formatDate(endDate);
                                coverageline.eligibleDates = SAEUtils.formatDate(startDate) + ' - ' + SAEUtils.formatDate(endDate);
                                
                                //Set eligible dates in financial benefits
                                // US1861461 - Sanka Dharmasena
                                if (!coverageline.financialWrapper.yearType.equals('Calendar Year')) {
                                    coverageline.financialWrapper.displayYear = coverageline.eligibleDates;
                                }
                                
                                if(String.isNotBlank(startDate)){
                                    coverageline.EffectiveDate = SAEUtils.formatDate(startDate); 
                                }
                                if(String.isNotBlank(endDate)){
                                    //US2061732 - Added by Avish
                                    coverageline.EndDate = SAEUtils.formatDate(endDate);  
                                    system.debug('coverageline.EndDate@@@ ' + coverageline.EndDate);
                                    Date endDateTerm = Date.valueOf(endDate.replace('/','-')).addDays(90);
                                    Date date_today = system.today();
                                    if(endDateTerm < date_today){
                                        coverageline.termedFlag = true;
                                    }else{
                                        coverageline.termedFlag = false;
                                    }
                                    //US2061732 - Ends
                                }else{
                                    coverageline.termedFlag = false;
                                }
                            }
                            
                            if (String.isNotBlank(policies.policyInfo.policyStatus)) {
                                //if(policies.policyInfo.policyStatus.contains('Active') || policies.policyInfo.policyStatus.contains('active')){
                                if (policies.policyInfo.policyStatus.toLowerCase().subString(0, 6) == 'future') {
                                    coverageline.planStatus = 'future';
                                } else if (policies.policyInfo.policyStatus.toLowerCase().subString(0, 6) == 'active') {
                                    coverageline.planStatus = 'true';
                                } else
                                    coverageline.planStatus = 'false';
                            }
                            // US1772441 Pilot - Enhancement - Member snapshot - Policies section - No plan status - 26/11/2019 - Sarma
                            // New logic to determine the policy status when policy status null from service
                            else{
                                if (policies.policyInfo.planDates != null) {
                                    
                                    startDate = String.isNotBlank(policies.policyInfo.planDates.startDate) ? policies.policyInfo.planDates.startDate : '';
                                    endDate = String.isNotBlank(policies.policyInfo.planDates.endDate) ? policies.policyInfo.planDates.endDate : '';
                                    
                                    if(String.isNotBlank(startDate) && String.isNotBlank(endDate)){
                                        Date date_start = Date.valueOf(startDate.replace('/','-'));
                                        Date date_end = Date.valueOf(endDate.replace('/','-'));
                                        Date date_today = system.today();
                                        
                                        if(date_end < date_today){
                                            coverageline.planStatus = 'false';     
                                        } else if(date_start > date_today){
                                            coverageline.planStatus = 'future';
                                        } else{
                                            coverageline.planStatus = 'true';       
                                        }
                                        System.debug('Into status null & date not null '+ coverageline.planStatus);
                                        
                                    }
                                }    
                            }

                            // US2974242

                            if(String.isNotBlank(policies.policyInfo.graceMessageByState)) {
                                coverageline.strGraceMessageByState = policies.policyInfo.graceMessageByState;
                            }

                            if(String.isNotBlank(policies.policyInfo.gracePaidThrough)) {
                                coverageline.strGracePaidThrough = policies.policyInfo.gracePaidThrough;
                            }

                            if(String.isNotBlank(policies.policyInfo.gracePeriodMonth)) {
                                coverageline.strGracePeriodMonth = policies.policyInfo.gracePeriodMonth;
                            }
                            
                            if (String.isNotBlank(policies.policyInfo.memberId)) {
                                returnReponse.MemberId = policies.policyInfo.memberId;
                            }
                            
                        }
                        if (policies.referralInfo != null) {
                            if (String.isNotBlank(policies.referralInfo.referralIndicator)) {
                                if (policies.referralInfo.referralIndicator == 'N') {
                                    coverageline.referral = 'No';
                                } else if (policies.referralInfo.referralIndicator == 'Y') {
                                    coverageline.referral = 'Yes';
                                }
                            }
                            //US3584388
                             coverageline.cosmosDelegatedEntity = 'No';
                            if(policies.referralInfo.cosmosDelegatedEntity != null && string.isNotBlank(policies.referralInfo.cosmosDelegatedEntity)){//US3583813 - Sravan
                                coverageline.cosmosDelegatedEntity = policies.referralInfo.cosmosDelegatedEntity;
                            }
                        }
                        if (policies.insuranceInfo != null) {
                            planInsType = String.isNotBlank(policies.insuranceInfo.insuranceType) ? policies.insuranceInfo.insuranceType : '';
                            //wrapper.policy = String.isNotBlank(policies.insuranceInfo.planDescription)?policies.insuranceInfo.planDescription:'';
                            //wrapper.plan = plan + ' - ' + planInsType;
                            coverageline.CoverageType = plan + ' - ' + planInsType;
                            coverageline.insuranceTypeCode = policies.insuranceInfo.insuranceTypeCode;
                            coverageline.administeredByUhc = policies.insuranceInfo.administeredByUhc;
                            coverageline.paidThroughDate = policies.insuranceInfo.paidThroughDate != null ? SAEUtils.formatDate(policies.insuranceInfo.paidThroughDate) : '';
                            coverageline.PolicyName = String.isNotBlank(policies.insuranceInfo.planDescription) ? policies.insuranceInfo.planDescription : '';
                            coverageline.GroupNumber = String.isNotBlank(policies.insuranceInfo.groupNumber) ? policies.insuranceInfo.groupNumber : '';
                            coverageline.lineOfBusiness = String.isNotBlank(policies.insuranceInfo.lineOfBusiness)?policies.insuranceInfo.lineOfBusiness:'';//US3116511 TTAP Vishnu
                            //Prepare Address to be added on the Policy Details
                            List < String > addressList = new List < String > ();
                            if(policies.insuranceInfo.addressLine1 != null && policies.insuranceInfo.addressLine1 != '')
                            {
                                coverageline.addressLine1 = policies.insuranceInfo.addressLine1;
                            }
                            if(policies.insuranceInfo.city != null && policies.insuranceInfo.city != '')
                            {
                                coverageline.city = policies.insuranceInfo.city;
                            }
                            if(policies.insuranceInfo.state != null && policies.insuranceInfo.state != '')
                            {
                                coverageline.state = policies.insuranceInfo.state;
                            }
                            if(policies.insuranceInfo.zip != null && policies.insuranceInfo.zip != '')
                            {
                                //US1842940 Display the first 5 digits of the ZIP
                                coverageline.zip = policies.insuranceInfo.zip.substring(0,5);
                            }
                            
                        }
                        
                        if (policies.primaryCarePhysicianInfo != null) {
                            //List<SAEMemberProviderSearchCoveragesResult.PCPAssignment> pcpLst = new List<SAEMemberProviderSearchCoveragesResult.PCPAssignment>();
                            SAEMemberProviderSearchCoveragesResult.PCPAssignment pcp = new SAEMemberProviderSearchCoveragesResult.PCPAssignment();
                            
                            pcp.FirstName = String.isNotBlank(policies.primaryCarePhysicianInfo.firstName) ? policies.primaryCarePhysicianInfo.firstName : '';
                            pcp.middleName = String.isNotBlank(policies.primaryCarePhysicianInfo.middleName) ? policies.primaryCarePhysicianInfo.middleName : '';
                            pcp.LastName = String.isNotBlank(policies.primaryCarePhysicianInfo.lastName) ? policies.primaryCarePhysicianInfo.lastName : '';
                            pcp.fullName = pcp.FirstName + ' ' + pcp.middleName + ' ' + pcp.LastName;
                            
                            // US2099074
                            pcp.Street1 = policies.primaryCarePhysicianInfo.addressLine1;
                            pcp.Street2 = policies.primaryCarePhysicianInfo.addressLine2;
                            pcp.State = policies.primaryCarePhysicianInfo.state;
                            pcp.Zip = policies.primaryCarePhysicianInfo.zip;
                            // End
                            
                            //pcpLst.add(pcp);
                            //returnReponse.PCPAssignments = pcpLst;
                            System.debug('noPCP1::' +policies.primaryCarePhysicianInfo.firstName);
                            if(pcp.FirstName != '' || pcp.middleName != '' || pcp.LastName != ''){
                                pcp.providerPCP = pcp.fullName;
                            }else{
                                pcp.providerPCP = 'No PCP on file.';
                            }
                            coverageline.pcpAssignment = pcp;
                            
                        }
                        
                        //Add the highlighted logic for current policies for given criteria. US1689046
                        if (coverageline.planStatus == 'true' && plan == 'Medical' && String.isNotBlank(startDate)) {
                            activeMedicalPolicyMap.put(transactionId, date.valueOf(startDate));
                            
                        } else if (coverageline.planStatus == 'false' && plan == 'Non Medical' && String.isNotBlank(startDate)) {
                            inactiveNonMedicalPolicyMap.put(transactionId, date.valueOf(startDate));
                            
                        } else if (coverageline.planStatus == 'true' && plan == 'Non Medical' && String.isNotBlank(startDate)) {
                            activeNonMedicalPolicyMap.put(transactionId, date.valueOf(startDate));
                            
                        } else if ((coverageline.planStatus == 'false' || coverageline.planStatus == 'future') && plan == 'Medical') {
                            if (startDate != '' && startDate != null)
                                inactiveMedicalPolicyMap.put(transactionId, date.valueOf(startDate));
                            if (endDate != '' && endDate != null)
                                inactiveMedicalPolicyWithEnddateMap.put(transactionId, date.valueOf(endDate));
                        }
                        
                        policyLine.add(coverageline);

                        if (policies.patientInfo != null) {
                            for (SAEEligibilityResponseJSON2Apex.PatientInfo pat: policies.patientInfo) {
                                returnReponse.fullName = pat.firstName + ' ' + pat.middleName + ' ' + pat.lastName;
                                returnReponse.dob = String.isNotBlank(pat.dateOfBirth) ? SAEUtils.formatDate(pat.dateOfBirth) : '';
                                returnReponse.Age = String.isNotBlank(pat.dateOfBirth) ? SAEUtils.getAgeFromBirthday(pat.dateOfBirth) : '';
                                returnReponse.gender = pat.gender;
                                
                                //Code for Address mappings
                                List < SAEMemberProviderSearchCoveragesResult.Address > adrLst = new List < SAEMemberProviderSearchCoveragesResult.Address > ();
                                SAEMemberProviderSearchCoveragesResult.Address addrObj = new SAEMemberProviderSearchCoveragesResult.Address();
                                addrObj.AddressLine1 = pat.addressLine1;
                                addrObj.AddressLine2 = pat.addressLine2;
                                addrObj.City = pat.city;
                                addrObj.State = pat.state;
                                //US1842940 - Restrict ZIP for first 5 digits
                                addrObj.Zip = pat.zip.substring(0, 5);
                                adrLst.add(addrObj);
                                returnReponse.Addresses = adrLst;
                                //Address code ends here
                            }
                        }
                    }
                    
                    
                    //Run Highlight logic
                    
                    //activeMedicalPolicyMap, activeNonMedicalPolicyMap, inactiveMedicalPolicyMap, inactiveNonMedicalPolicyMap
                    system.debug('activeMedicalPolicyMap:::' + activeMedicalPolicyMap.size());
                    system.debug('activeNonMedicalPolicyMap:::' + activeNonMedicalPolicyMap.size());
                    system.debug('inactiveMedicalPolicyMap:::' + inactiveMedicalPolicyMap.size());
                    system.debug('inactiveNonMedicalPolicyMap:::' + inactiveNonMedicalPolicyMap.size());
                    system.debug('inactiveMedicalPolicyWithEnddateMap:::' + inactiveMedicalPolicyWithEnddateMap.size());
                    
                    Date mostRecentDate = null;
                    String highlightedPolicyId = null;
                    
                    //Please check DD for the scenario mentioned below within '<>' characters
                    //<3> Active Medical Policy - Most recent one
                    if (!activeMedicalPolicyMap.isEmpty()) {
                        
                        for (String s: activeMedicalPolicyMap.keySet()) {
                            if (mostRecentDate == null && highlightedPolicyId == null) {
                                mostRecentDate = activeMedicalPolicyMap.get(s);
                                highlightedPolicyId = s;
                                //break;
                            } else if (activeMedicalPolicyMap.get(s) > mostRecentDate) {
                                mostRecentDate = activeMedicalPolicyMap.get(s);
                                highlightedPolicyId = s;
                                //break;
                            }
                        }
                    }else
                        
                        //<4> If there is no Active Medical Policy, then highlight the most recent Active Policy
                        if (activeMedicalPolicyMap.isEmpty() && highlightedPolicyId == null) {
                            
                            /* 05/27 : We will only consider "Active Non-Modical" Policies
                            * <4> and <5> are almost the same
                            */
                            
                            for (String s: activeNonMedicalPolicyMap.keySet()) {
                                if (mostRecentDate == null && highlightedPolicyId == null) {
                                    mostRecentDate = activeNonMedicalPolicyMap.get(s);
                                    highlightedPolicyId = s;
                                } else if (activeNonMedicalPolicyMap.get(s) > mostRecentDate) {
                                    mostRecentDate = activeNonMedicalPolicyMap.get(s);
                                    highlightedPolicyId = s;
                                }
                            }
                            // DE418894 - Policy Highlight logic is not working when all Inactive Medical - 08/03/2021 - Sarma
                            if(highlightedPolicyId == null){
                                for (String s: inactiveMedicalPolicyMap.keySet()) {
                                    if ((mostRecentDate == null && highlightedPolicyId == null) || inactiveMedicalPolicyMap.get(s) > mostRecentDate) {
                                        mostRecentDate = inactiveMedicalPolicyMap.get(s);
                                        highlightedPolicyId = s;
                                    }
                                }
                            }
                            // DE418894 Ends

                        }else
                            
                            //<5> If there are more than one Active non Medical policies - chose first one
                            //<6> If there are no Active policies - highlight the most recent Past Medical Policy. Have to consider the EndDate
                            if (activeMedicalPolicyMap.isEmpty() && activeNonMedicalPolicyMap.isEmpty() && highlightedPolicyId == null) {
                                
                                for (String s: inactiveMedicalPolicyWithEnddateMap.keySet()) {
                                    if (mostRecentDate == null && highlightedPolicyId == null) {
                                        mostRecentDate = inactiveMedicalPolicyWithEnddateMap.get(s);
                                        highlightedPolicyId = s;
                                        //break;
                                    } else if (inactiveMedicalPolicyWithEnddateMap.get(s) > mostRecentDate) {
                                        mostRecentDate = inactiveMedicalPolicyWithEnddateMap.get(s);
                                        highlightedPolicyId = s;
                                        //break;
                                    }
                                }
                                
                                //To Capture future scenarios
                                if (highlightedPolicyId == null) {
                                    for (String s: inactiveMedicalPolicyMap.keySet()) {
                                        if (mostRecentDate == null && highlightedPolicyId == null) {
                                            mostRecentDate = inactiveMedicalPolicyMap.get(s);
                                            highlightedPolicyId = s;
                                            //break;
                                        } else if (inactiveMedicalPolicyMap.get(s) > mostRecentDate) {
                                            mostRecentDate = inactiveMedicalPolicyMap.get(s);
                                            highlightedPolicyId = s;
                                            //break;
                                        }
                                    }
                                    
                                }
                                
                            }else
                                
                                //<7> If no past Medical Policy Found, then chose any from the past, preferebly first one returns. This considers anything. Most of the time inactiveNoneMedicalPolicies
                                
                                if (!inactiveNonMedicalPolicyMap.isEmpty() && highlightedPolicyId == null) {
                                    
                                    for (String s: inactiveNonMedicalPolicyMap.keySet()) {
                                        highlightedPolicyId = s;
                                        break;
                                    }
                                }
                    
                    system.debug('mostRecentDate:::' + mostRecentDate);
                    system.debug('highlightedPolicyId:::' + highlightedPolicyId);
                    //Set the highlighted Policy matching the transaction Id
                    for (SAEMemberProviderSearchCoveragesResult.CoverageLine p: policyLine) {
                        
                        if (highlightedPolicyId == p.transactionId) {
                            p.highlightedPolicy = true;
                            break;
                        }
                    }
                    
                    returnReponse.CoverageLines = policyLine;
                    calloutResult.Success = true;
                    calloutResult.Message = '';
                    //      System.debug('!!!!!!!!!!!!!!!!!!!'+memberDetail );
                    calloutResult.Response = returnReponse;
                    system.debug('returnReponse.PCPAssignments@@@ ' + returnReponse.PCPAssignments);
                }
            }
        } else {
            System.debug('@@ SAEGetMemberProviderWebService_R: inside else: ');
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = 'Web Service or External System is temporarily unavailable.';
            // US1813580 - Error Message Translation - Begin
            //Sanka Dharmasena - 12/06/2019
            calloutResult.statusCode = response.getStatusCode();
            Map<String, Object> httpResponseJSON = (Map<String, Object>) JSON.deserializeUntyped(responseStr);
            String faultCode = (String) httpResponseJSON.get('faultCode');
            System.debug('@@@ fault code 400: ' + faultCode);
            if(response.getStatusCode() == 400)
            {                    
                if (faultCode != null && (faultCode.containsIgnoreCase('AAA:58') || faultCode.containsIgnoreCase('AAA:72') 
                                          || faultCode.containsIgnoreCase('AAA:73') || faultCode.containsIgnoreCase('AAA:76') || 
                                          faultCode.containsIgnoreCase('AAA:79'))) { // == 'AAA:72'
                                              //calloutResult.Message = SAEMemberProviderWS.getErrorMessage('AAA:72');
                                              calloutResult.Message = (String) httpResponseJSON.get('message') + '(' + faultCode + ')';
                                          }else if (faultCode != null && (faultCode.containsIgnoreCase('ED270UG'))){ /** US1964362  Added by Avish 11/25/2019**/
                                              calloutResult.Message = SAEMemberProviderWS.getErrorMessage(faultCode) + '(' + faultCode + ')';                       
                                          }else if (faultCode != null && (faultCode.containsIgnoreCase('AAA:Fault Code'))){
                                              String[] faultCodeMsg = faultCode.split(':');
                                              String[] faultCodeMsg2 = faultCodeMsg[1].split(' ');
                                              String faultCodeOrignal = faultCodeMsg[0]+faultCodeMsg2[0]+faultCodeMsg2[1];
                                              System.debug('@@@ fault code 400: ' + faultCode);
                                              calloutResult.Message = SAEMemberProviderWS.getErrorMessage(faultCodeOrignal) + '(' + faultCode + ')';   
                                              System.debug('@@@ fault code Message: ' + SAEMemberProviderWS.getErrorMessage(faultCodeOrignal));
                                          }else if (faultCode != null && (faultCode.containsIgnoreCase('ED270IP'))){
                                              calloutResult.Message = (String) httpResponseJSON.get('message') + '(' + faultCode + ')';//SAEMemberProviderWS.getErrorMessage(faultCode);                       
                                          }else if (faultCode != null && (faultCode.containsIgnoreCase('ED270BP'))){
                                              calloutResult.Message = (String) httpResponseJSON.get('message') + '(' + faultCode + ')'; //SAEMemberProviderWS.getErrorMessage(faultCode);                       
                                          }else if (faultCode != null && (faultCode.containsIgnoreCase('ED270BR'))){
                                              calloutResult.Message = (String) httpResponseJSON.get('message') + '(' + faultCode + ')';//SAEMemberProviderWS.getErrorMessage(faultCode);                       
                                          }                    
                else {
                    calloutResult.Message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN400);
                }
                calloutResult.statusCode = response.getStatusCode();
            }else if(response.getStatusCode() == 404)
            {
                if (faultCode != null && (faultCode.containsIgnoreCase('AEFNND'))){ 
                    calloutResult.Message = SAEMemberProviderWS.getErrorMessage(faultCode) + '(' + faultCode + ')';
                }else{
                    calloutResult.Message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN404) + '(' + faultCode + ')';
                }
                calloutResult.statusCode = response.getStatusCode();
            }else if(response.getStatusCode() == 406){
                if (faultCode != null && (faultCode.containsIgnoreCase('ED270IA'))){ 
                    calloutResult.Message = SAEMemberProviderWS.getErrorMessage(faultCode) + '(' + faultCode + ')';
                }
                calloutResult.statusCode = response.getStatusCode();
            }
            else if(response.getStatusCode() == 424){
                if (faultCode != null && (faultCode.containsIgnoreCase('ED270UR'))){
                    calloutResult.Message = SAEMemberProviderWS.getErrorMessage(faultCode) + '(' + faultCode + ')';
                }else if (faultCode != null && (faultCode.containsIgnoreCase('AAA:42'))){
                    String[] faultCodeMsg = faultCode.split(':');
                    String temp = faultCodeMsg[0]+faultCodeMsg[1];
                    system.debug('temp>>> ' + temp);
                    calloutResult.Message = SAEMemberProviderWS.getErrorMessage(temp) + '(' + faultCode + ')';
                }
                calloutResult.statusCode = response.getStatusCode();
            }
            else if(response.getStatusCode() == 500)
            {
                if (faultCode != null && (faultCode.containsIgnoreCase('ED270SE') || 
                                          faultCode.containsIgnoreCase('ED270UE') || faultCode.containsIgnoreCase('AEFNEE'))){ 
                                              calloutResult.Message = SAEMemberProviderWS.getErrorMessage(faultCode) + '(' + faultCode + ')';  
                                              calloutResult.statusCode = response.getStatusCode();                     
                                          }else{
                                              calloutResult.Message = SAEMemberProviderWS.getErrorMessage(SAEConstants.GN500A) + '(' + faultCode + ')';
                                              calloutResult.statusCode = 999;
                                          }
                
            }else {
                calloutResult.Message = SAEMemberProviderWS.getErrorMessage('GN500A') + '(' + faultCode + ')';
                calloutResult.statusCode = 999;
            }
            // End
            //calloutResult.statusCode=999;
        }
        System.debug('@@ SAEGetMemberProviderWebService_R: calloutResult: ' + calloutResult);
        return calloutResult;
    }
    
    // US1730904 - Financials PHS In-Network
    // Sanka Dharmasena - 21-06-2019
    public static SAEMemberProviderSearchCoveragesResult.FinancialsWrapper CreateFinancialWrappers(SAEEligibilityResponseJSON2Apex.MemberPolicies policy)
    {
        String yearType = '';
        String displayYear = '';
        
        SAEMemberProviderSearchCoveragesResult.Financials tierOne = new SAEMemberProviderSearchCoveragesResult.Financials();
        SAEMemberProviderSearchCoveragesResult.Financials inNetwork = new SAEMemberProviderSearchCoveragesResult.Financials();
        SAEMemberProviderSearchCoveragesResult.Financials outNetwork = new SAEMemberProviderSearchCoveragesResult.Financials();
        
        // INN/OON/Tier1 Deductibles
        if(policy.deductibleInfo.found)
        {
            //In network - Individual
            if(policy.deductibleInfo.individual.inNetwork.found)
            {
                inNetwork.dedFound = true;
                inNetwork.deductible = SAEGetMemberProviderWebService.valueFormate (policy.deductibleInfo.individual.inNetwork.planAmount);
                inNetwork.dedSatisfied = SAEGetMemberProviderWebService.valueFormate (policy.deductibleInfo.individual.inNetwork.metYtdAmount);
                inNetwork.dedAmountRem = SAEGetMemberProviderWebService.valueFormate (policy.deductibleInfo.individual.inNetwork.remainingAmount);
                inNetwork.dedPrecentage = SAEGetMemberProviderWebService.checkAndCall(inNetwork.deductible,inNetwork.dedAmountRem,inNetwork.dedSatisfied);
                if(String.isEmpty(yearType))
                {
                    yearType = policy.deductibleInfo.individual.inNetwork.planAmountFrequency;
                }
            }
            else
            {
                inNetwork.dedFound = false;
            }
            // In Network - Family
            if(policy.deductibleInfo.family.inNetwork.found)
            {
                inNetwork.dedFoundFam = true;
                inNetwork.deductibleFam = SAEGetMemberProviderWebService.valueFormate(policy.deductibleInfo.family.inNetwork.planAmount);
                inNetwork.dedSatisfiedFam = SAEGetMemberProviderWebService.valueFormate(policy.deductibleInfo.family.inNetwork.metYtdAmount);
                inNetwork.dedAmountRemFam = SAEGetMemberProviderWebService.valueFormate(policy.deductibleInfo.family.inNetwork.remainingAmount);
                inNetwork.dedFamPrecentage = SAEGetMemberProviderWebService.checkAndCall(inNetwork.deductibleFam,inNetwork.dedAmountRemFam,inNetwork.dedSatisfiedFam);
                
                if(String.isEmpty(yearType))
                {
                    yearType = policy.deductibleInfo.family.inNetwork.planAmountFrequency;
                }
            }
            else
            {
                inNetwork.dedFoundFam = false;
            }
            //OON Individual
            if(policy.deductibleInfo.individual.outOfNetwork.found)
            {
                outNetwork.dedFound = true;
                outNetwork.deductible = SAEGetMemberProviderWebService.valueFormate(policy.deductibleInfo.individual.outOfNetwork.planAmount);
                outNetwork.dedSatisfied = SAEGetMemberProviderWebService.valueFormate(policy.deductibleInfo.individual.outOfNetwork.metYtdAmount);
                outNetwork.dedAmountRem = SAEGetMemberProviderWebService.valueFormate(policy.deductibleInfo.individual.outOfNetwork.remainingAmount);
                outNetwork.dedPrecentage = SAEGetMemberProviderWebService.checkAndCall(outNetwork.deductible,outNetwork.dedAmountRem,outNetwork.dedSatisfied);
                
                if(String.isEmpty(yearType))
                {
                    yearType = policy.deductibleInfo.individual.outOfNetwork.planAmountFrequency;
                }
            }
            else
            {
                outNetwork.dedFound = false;
            }
            // OON - Family
            if(policy.deductibleInfo.family.outOfNetwork.found)
            {
                outNetwork.dedFoundFam = true;
                outNetwork.deductibleFam = SAEGetMemberProviderWebService.valueFormate(policy.deductibleInfo.family.outOfNetwork.planAmount);
                outNetwork.dedSatisfiedFam = SAEGetMemberProviderWebService.valueFormate(policy.deductibleInfo.family.outOfNetwork.metYtdAmount);
                outNetwork.dedAmountRemFam = SAEGetMemberProviderWebService.valueFormate(policy.deductibleInfo.family.outOfNetwork.remainingAmount);
                outNetwork.dedFamPrecentage = SAEGetMemberProviderWebService.checkAndCall(outNetwork.deductibleFam,outNetwork.dedAmountRemFam,outNetwork.dedSatisfiedFam);
                
                if(String.isEmpty(yearType))
                {
                    yearType = policy.deductibleInfo.family.outOfNetwork.planAmountFrequency;
                }
            }
            else
            {
                outNetwork.dedFoundFam = false;
            }
            // Tier_One - Individual
            if(policy.deductibleInfo.individual.inNetworkTier1.found)
            {
                tierOne.dedFound = true;
                tierOne.deductible = SAEGetMemberProviderWebService.valueFormate(policy.deductibleInfo.individual.inNetworkTier1.planAmount);
                tierOne.dedSatisfied = SAEGetMemberProviderWebService.valueFormate(policy.deductibleInfo.individual.inNetworkTier1.metYtdAmount);
                tierOne.dedAmountRem = SAEGetMemberProviderWebService.valueFormate(policy.deductibleInfo.individual.inNetworkTier1.remainingAmount);
                tierOne.dedPrecentage =SAEGetMemberProviderWebService.checkAndCall(tierOne.deductible,tierOne.dedAmountRem,tierOne.dedSatisfied);
                
                if(String.isEmpty(yearType))
                {
                    yearType = policy.deductibleInfo.individual.inNetworkTier1.planAmountFrequency;
                }
            }
            else
            {
                tierOne.dedFound = false;
            }
            // Tier_One - Family
            if(policy.deductibleInfo.family.inNetworkTier1.found)
            {
                tierOne.dedFoundFam = true;
                tierOne.deductibleFam = SAEGetMemberProviderWebService.valueFormate(policy.deductibleInfo.family.inNetworkTier1.planAmount);
                tierOne.dedSatisfiedFam = SAEGetMemberProviderWebService.valueFormate(policy.deductibleInfo.family.inNetworkTier1.metYtdAmount);
                tierOne.dedAmountRemFam = SAEGetMemberProviderWebService.valueFormate(policy.deductibleInfo.family.inNetworkTier1.remainingAmount);
                tierOne.dedFamPrecentage = SAEGetMemberProviderWebService.checkAndCall(tierOne.deductibleFam,tierOne.dedAmountRemFam,tierOne.dedSatisfiedFam);
                
                if(String.isEmpty(yearType))
                {
                    yearType = policy.deductibleInfo.family.inNetworkTier1.planAmountFrequency;
                }
            }
            else
            {
                tierOne.dedFoundFam = false;
            }
        }
        else
        {
            inNetwork.dedFound = false;
            inNetwork.dedFoundFam = false;
            outNetwork.dedFound = false;
            outNetwork.dedFoundFam = false;
            tierOne.dedFound = false;
            tierOne.dedFoundFam = false;
        }
        //INN/OON/Tier1 Out-of-Pocket
        if(policy.outOfPocketInfo.found)
        {
            // In-network - Individual
            if(policy.outOfPocketInfo.individual.inNetwork.found)
            {
                inNetwork.outOPFound = true;
                inNetwork.outOP = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketInfo.individual.inNetwork.planAmount);
                inNetwork.outOPRemAmount = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketInfo.individual.inNetwork.remainingAmount);
                inNetwork.outOPSatisfied = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketInfo.individual.inNetwork.metYtdAmount);
                inNetwork.oopPrecentage = SAEGetMemberProviderWebService.checkAndCall(inNetwork.outOP,inNetwork.outOPRemAmount,inNetwork.outOPSatisfied);
                
                //Table Values
                //inNetwork.OOP_Limit_2 = inNetwork.outOP;
                //inNetwork.OOP_Limit_2_Satisfied = inNetwork.outOPSatisfied;
                
                if(String.isEmpty(yearType))
                {
                    yearType = policy.outOfPocketInfo.individual.inNetwork.planAmountFrequency;
                }
            }
            else
            {
                inNetwork.outOPFound = false;
            }
            // INN - Family
            if(policy.outOfPocketInfo.family.inNetwork.found)
            {
                inNetwork.outOPFoundFam = true;
                inNetwork.outOPFam = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketInfo.family.inNetwork.planAmount);
                inNetwork.outOPRemAmountFam = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketInfo.family.inNetwork.remainingAmount);
                inNetwork.outOPSatisfiedFam = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketInfo.family.inNetwork.metYtdAmount);
                inNetwork.oopFamPrecentage = SAEGetMemberProviderWebService.checkAndCall(inNetwork.outOPFam,inNetwork.outOPRemAmountFam,inNetwork.outOPSatisfiedFam);
                
                //Table Values
                //inNetwork.OOP_Limit_2_Family = inNetwork.outOPFam;
                //inNetwork.OOP_Limit_2_Satisfied_Family = inNetwork.outOPSatisfiedFam;
                
                if(String.isEmpty(yearType))
                {
                    yearType = policy.outOfPocketInfo.family.inNetwork.planAmountFrequency;
                }
            }
            else
            {
                inNetwork.outOPFoundFam = false;
            }
            // OON - Individual
            if(policy.outOfPocketInfo.individual.outOfNetwork.found)
            {
                outNetwork.outOPFound = true;
                outNetwork.outOP = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketInfo.individual.outOfNetwork.planAmount);
                outNetwork.outOPRemAmount = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketInfo.individual.outOfNetwork.remainingAmount);
                outNetwork.outOPSatisfied = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketInfo.individual.outOfNetwork.metYtdAmount);
                outNetwork.oopPrecentage = SAEGetMemberProviderWebService.checkAndCall(outNetwork.outOP,outNetwork.outOPRemAmount,outNetwork.outOPSatisfied);
                
                //Table Values
                //outNetwork.OOP_Limit_2 = outNetwork.outOP;
                //outNetwork.OOP_Limit_2_Satisfied = outNetwork.outOPSatisfied;
                
                if(String.isEmpty(yearType))
                {
                    yearType = policy.outOfPocketInfo.individual.outOfNetwork.planAmountFrequency;
                }
            }
            else
            {
                outNetwork.outOPFound = false;
            }
            // OON - Family
            if(policy.outOfPocketInfo.family.outOfNetwork.found)
            {
                outNetwork.outOPFoundFam = true;
                outNetwork.outOPFam = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketInfo.family.outOfNetwork.planAmount);
                outNetwork.outOPRemAmountFam = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketInfo.family.outOfNetwork.remainingAmount);
                outNetwork.outOPSatisfiedFam = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketInfo.family.outOfNetwork.metYtdAmount);
                outNetwork.oopFamPrecentage = SAEGetMemberProviderWebService.checkAndCall(outNetwork.outOPFam,outNetwork.outOPRemAmountFam,outNetwork.outOPSatisfiedFam);
                
                //Table Values
                //outNetwork.OOP_Limit_2_Family = outNetwork.outOPFam;
                //outNetwork.OOP_Limit_2_Satisfied_Family = outNetwork.outOPSatisfiedFam;
                
                if(String.isEmpty(yearType))
                {
                    yearType = policy.outOfPocketInfo.family.outOfNetwork.planAmountFrequency;
                }
            }
            else
            {
                outNetwork.outOPFoundFam = false;
            }
            // Tier_One - Individual
            if(policy.outOfPocketInfo.individual.inNetworkTier1.found)
            {
                tierOne.outOPFound = true;
                tierOne.outOP = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketInfo.individual.inNetworkTier1.planAmount);
                tierOne.outOPSatisfied = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketInfo.individual.inNetworkTier1.metYtdAmount);
                tierOne.outOPRemAmount = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketInfo.individual.inNetworkTier1.remainingAmount);
                tierOne.oopPrecentage = SAEGetMemberProviderWebService.checkAndCall(tierOne.outOP,tierOne.outOPRemAmount,tierOne.outOPSatisfied);
                
                //Table Values
                //tierOne.OOP_Limit_2 = tierOne.outOP;
                //tierOne.OOP_Limit_2_Satisfied = tierOne.outOPSatisfied;
                
                if(String.isEmpty(yearType))
                {
                    yearType = policy.outOfPocketInfo.individual.inNetworkTier1.planAmountFrequency;
                }
            }
            else
            {
                tierOne.outOPFound = false;
            }
            // Tier_One - Family
            if(policy.outOfPocketInfo.family.inNetworkTier1.found)
            {
                tierOne.outOPFoundFam = true;
                tierOne.outOPFam = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketInfo.family.inNetworkTier1.planAmount);
                tierOne.outOPSatisfiedFam = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketInfo.family.inNetworkTier1.metYtdAmount);
                tierOne.outOPRemAmountFam = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketInfo.family.inNetworkTier1.remainingAmount);
                tierOne.oopFamPrecentage = SAEGetMemberProviderWebService.checkAndCall(tierOne.outOPFam,tierOne.outOPRemAmountFam,tierOne.outOPSatisfiedFam);
                
                //Table Values
                //tierOne.OOP_Limit_2_Family = tierOne.outOPFam;
                //tierOne.OOP_Limit_2_Satisfied_Family = tierOne.outOPSatisfiedFam;
                
                if(String.isEmpty(yearType))
                {
                    yearType = policy.outOfPocketInfo.family.inNetworkTier1.planAmountFrequency;
                }
            }
            else
            {
                tierOne.outOPFoundFam = false;
            }
        }
        else
        {
            inNetwork.outOPFound = false;
            inNetwork.outOPFoundFam = false;
            outNetwork.outOPFound = false;
            outNetwork.outOPFoundFam = false;
            tierOne.outOPFound = false;
            tierOne.outOPFoundFam = false;
        }
        //
        if(policy.outOfPocketMaxInfo.found)
        {
            //INN - Individual
            if(policy.outOfPocketMaxInfo.individual.inNetwork.found)
            {
                inNetwork.OOP_Limit_2_Found = true;
                inNetwork.OOP_Limit_2 = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketMaxInfo.individual.inNetwork.planAmount);
                inNetwork.OOP_Limit_2_Satisfied = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketMaxInfo.individual.inNetwork.metYtdAmount);
                inNetwork.OOP_Limit_2_Rem = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketMaxInfo.individual.inNetwork.remainingAmount);
                inNetwork.OOP_Limit_2_Precentage = SAEGetMemberProviderWebService.checkAndCall(inNetwork.OOP_Limit_2,inNetwork.OOP_Limit_2_Rem,inNetwork.OOP_Limit_2_Satisfied);
                
                if(String.isEmpty(yearType))
                {
                    yearType = policy.outOfPocketMaxInfo.individual.inNetwork.planAmountFrequency;
                }
            }
            else
            {
                inNetwork.OOP_Limit_2_Found = false;
            }
            //INN - Family
            if(policy.outOfPocketMaxInfo.family.inNetwork.found)
            {
                inNetwork.OOP_Limit_2_Found_Family = true;
                inNetwork.OOP_Limit_2_Family = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketMaxInfo.family.inNetwork.planAmount);
                inNetwork.OOP_Limit_2_Satisfied_Family = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketMaxInfo.family.inNetwork.metYtdAmount);
                inNetwork.OOP_Limit_2_Rem_Family = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketMaxInfo.family.inNetwork.remainingAmount);
                inNetwork.OOP_Limit_2_Precentage_Family = SAEGetMemberProviderWebService.checkAndCall(inNetwork.OOP_Limit_2_Family,inNetwork.OOP_Limit_2_Rem_Family,inNetwork.OOP_Limit_2_Satisfied_Family);
                
                if(String.isEmpty(yearType))
                {
                    yearType = policy.outOfPocketMaxInfo.family.inNetwork.planAmountFrequency;
                }
            }
            else
            {
                inNetwork.OOP_Limit_2_Found_Family = false;
            }
            // OON - Individual
            if(policy.outOfPocketMaxInfo.individual.outOfNetwork.found)
            {
                outNetwork.OOP_Limit_2_Found = true;
                outNetwork.OOP_Limit_2 = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketMaxInfo.individual.outOfNetwork.planAmount);
                outNetwork.OOP_Limit_2_Satisfied = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketMaxInfo.individual.outOfNetwork.metYtdAmount);
                outNetwork.OOP_Limit_2_Rem = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketMaxInfo.individual.outOfNetwork.remainingAmount);
                outNetwork.OOP_Limit_2_Precentage = SAEGetMemberProviderWebService.checkAndCall(outNetwork.OOP_Limit_2,outNetwork.OOP_Limit_2_Rem,outNetwork.OOP_Limit_2_Satisfied);
                
                if(String.isEmpty(yearType))
                {
                    yearType = policy.outOfPocketMaxInfo.individual.outOfNetwork.planAmountFrequency;
                }
            }
            else
            {
                outNetwork.OOP_Limit_2_Found = false;
            }
            // OON - Family
            if(policy.outOfPocketMaxInfo.family.outOfNetwork.found)
            {
                outNetwork.OOP_Limit_2_Found_Family = true;
                outNetwork.OOP_Limit_2_Family = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketMaxInfo.family.outOfNetwork.planAmount);
                outNetwork.OOP_Limit_2_Satisfied_Family = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketMaxInfo.family.outOfNetwork.metYtdAmount);
                outNetwork.OOP_Limit_2_Rem_Family = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketMaxInfo.family.outOfNetwork.remainingAmount);
                outNetwork.OOP_Limit_2_Precentage_Family = SAEGetMemberProviderWebService.checkAndCall(outNetwork.OOP_Limit_2_Family,outNetwork.OOP_Limit_2_Rem_Family,outNetwork.OOP_Limit_2_Satisfied_Family);
                
                if(String.isEmpty(yearType))
                {
                    yearType = policy.outOfPocketMaxInfo.family.outOfNetwork.planAmountFrequency;
                }
            }
            else
            {
                outNetwork.OOP_Limit_2_Found_Family = false;
            }
            // Tier1 - Individual
            if(policy.outOfPocketMaxInfo.individual.inNetworkTier1.found)
            {
                tierOne.OOP_Limit_2_Found = true;
                tierOne.OOP_Limit_2 = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketMaxInfo.individual.inNetworkTier1.planAmount);
                tierOne.OOP_Limit_2_Satisfied = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketMaxInfo.individual.inNetworkTier1.metYtdAmount);
                tierOne.OOP_Limit_2_Rem = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketMaxInfo.individual.inNetworkTier1.remainingAmount);
                tierOne.OOP_Limit_2_Precentage = SAEGetMemberProviderWebService.checkAndCall(tierOne.OOP_Limit_2,tierOne.OOP_Limit_2_Rem,tierOne.OOP_Limit_2_Satisfied);
                
                if(String.isEmpty(yearType))
                {
                    yearType = policy.outOfPocketMaxInfo.individual.inNetworkTier1.planAmountFrequency;
                }
            }
            else
            {
                tierOne.OOP_Limit_2_Found = false;
            }
            // Tier1 - Family
            if(policy.outOfPocketMaxInfo.family.inNetworkTier1.found)
            {
                tierOne.OOP_Limit_2_Found_Family = true;
                tierOne.OOP_Limit_2_Family = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketMaxInfo.family.inNetworkTier1.planAmount);
                tierOne.OOP_Limit_2_Satisfied_Family = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketMaxInfo.family.inNetworkTier1.metYtdAmount);
                tierOne.OOP_Limit_2_Rem_Family = SAEGetMemberProviderWebService.valueFormate(policy.outOfPocketMaxInfo.family.inNetworkTier1.remainingAmount);
                tierOne.OOP_Limit_2_Precentage_Family = SAEGetMemberProviderWebService.checkAndCall(tierOne.OOP_Limit_2_Family,tierOne.OOP_Limit_2_Rem_Family,tierOne.OOP_Limit_2_Satisfied_Family);
                
                if(String.isEmpty(yearType))
                {
                    yearType = policy.outOfPocketMaxInfo.family.inNetworkTier1.planAmountFrequency;
                }
            }
            else
            {
                tierOne.OOP_Limit_2_Found_Family = false;
            }
        }
        else
        {
            inNetwork.OOP_Limit_2_Found = false;
            inNetwork.OOP_Limit_2_Found_Family = false;
            outNetwork.OOP_Limit_2_Found = false;
            outNetwork.OOP_Limit_2_Found_Family = false;
            tierOne.OOP_Limit_2_Found = false;
            tierOne.OOP_Limit_2_Found_Family = false;
        }
        if(policy.copayMaxInfo.found)
        {
            //INN - INd
            if (policy.copayMaxInfo.individual.inNetwork.found)
            {
                inNetwork.CopayMax_Found = true;
                inNetwork.CopayMax = SAEGetMemberProviderWebService.valueFormate(policy.copayMaxInfo.individual.inNetwork.planAmount);
                inNetwork.CopayMax_Satisfied = SAEGetMemberProviderWebService.valueFormate(policy.copayMaxInfo.individual.inNetwork.metYtdAmount);
                inNetwork.CopayMax_Remaining =  SAEGetMemberProviderWebService.valueFormate(policy.copayMaxInfo.individual.inNetwork.remainingAmount);
                inNetwork.CopayMax_Precentage = SAEGetMemberProviderWebService.checkAndCall(inNetwork.CopayMax,inNetwork.CopayMax_Remaining,inNetwork.CopayMax_Satisfied);
                
                if(String.isEmpty(yearType))
                {
                    yearType = policy.copayMaxInfo.individual.inNetwork.planAmountFrequency;
                }
            }
            else
            {
                inNetwork.CopayMax_Found = false;
            }
            // INN - Family
            if (policy.copayMaxInfo.family.inNetwork.found)
            {
                inNetwork.CopayMax_Found_Family = true;
                inNetwork.CopayMax_Family = SAEGetMemberProviderWebService.valueFormate(policy.copayMaxInfo.individual.inNetwork.planAmount);
                inNetwork.CopayMax_Satisfied_Family = SAEGetMemberProviderWebService.valueFormate(policy.copayMaxInfo.individual.inNetwork.metYtdAmount);
                inNetwork.CopayMax_Remaining_Family =  SAEGetMemberProviderWebService.valueFormate(policy.copayMaxInfo.individual.inNetwork.remainingAmount);
                inNetwork.CopayMax_Precentage_Family = SAEGetMemberProviderWebService.checkAndCall(inNetwork.CopayMax_Family,inNetwork.CopayMax_Remaining_Family,inNetwork.CopayMax_Satisfied_Family);
                
                if(String.isEmpty(yearType))
                {
                    yearType = policy.copayMaxInfo.individual.inNetwork.planAmountFrequency;
                }
            }
            else
            {
                inNetwork.CopayMax_Found_Family = false;
            }
            // OON - Ind
            if (policy.copayMaxInfo.individual.outOfNetwork.found)
            {
                outNetwork.CopayMax_Found = true;
                outNetwork.CopayMax = SAEGetMemberProviderWebService.valueFormate(policy.copayMaxInfo.individual.outOfNetwork.planAmount);
                outNetwork.CopayMax_Satisfied = SAEGetMemberProviderWebService.valueFormate(policy.copayMaxInfo.individual.outOfNetwork.metYtdAmount);
                outNetwork.CopayMax_Remaining =  SAEGetMemberProviderWebService.valueFormate(policy.copayMaxInfo.individual.outOfNetwork.remainingAmount);
                outNetwork.CopayMax_Precentage = SAEGetMemberProviderWebService.checkAndCall(outNetwork.CopayMax,outNetwork.CopayMax_Remaining,outNetwork.CopayMax_Satisfied);
                
                if(String.isEmpty(yearType))
                {
                    yearType = policy.copayMaxInfo.individual.outOfNetwork.planAmountFrequency;
                }
            }
            else
            {
                outNetwork.CopayMax_Found = false;
            }
            //OON - Fam
            if (policy.copayMaxInfo.family.outOfNetwork.found)
            {
                outNetwork.CopayMax_Found_Family = true;
                outNetwork.CopayMax_Family = SAEGetMemberProviderWebService.valueFormate(policy.copayMaxInfo.family.outOfNetwork.planAmount);
                outNetwork.CopayMax_Satisfied_Family = SAEGetMemberProviderWebService.valueFormate(policy.copayMaxInfo.family.outOfNetwork.metYtdAmount);
                outNetwork.CopayMax_Remaining_Family =  SAEGetMemberProviderWebService.valueFormate(policy.copayMaxInfo.family.outOfNetwork.remainingAmount);
                outNetwork.CopayMax_Precentage_Family = SAEGetMemberProviderWebService.checkAndCall(outNetwork.CopayMax_Family,outNetwork.CopayMax_Remaining_Family,outNetwork.CopayMax_Satisfied_Family);
                
                if(String.isEmpty(yearType))
                {
                    yearType = policy.copayMaxInfo.family.outOfNetwork.planAmountFrequency;
                }
            }
            else
            {
                outNetwork.CopayMax_Found_Family = false;
            }
            //Tier1 - Ind
            if (policy.copayMaxInfo.individual.inNetworkTier1.found)
            {
                tierOne.CopayMax_Found = true;
                tierOne.CopayMax = SAEGetMemberProviderWebService.valueFormate(policy.copayMaxInfo.individual.inNetworkTier1.planAmount);
                tierOne.CopayMax_Satisfied = SAEGetMemberProviderWebService.valueFormate(policy.copayMaxInfo.individual.inNetworkTier1.metYtdAmount);
                tierOne.CopayMax_Remaining =  SAEGetMemberProviderWebService.valueFormate(policy.copayMaxInfo.individual.inNetworkTier1.remainingAmount);
                tierOne.CopayMax_Precentage = SAEGetMemberProviderWebService.checkAndCall(tierOne.CopayMax,tierOne.CopayMax_Remaining,tierOne.CopayMax_Satisfied);
                
                if(String.isEmpty(yearType))
                {
                    yearType = policy.copayMaxInfo.individual.inNetworkTier1.planAmountFrequency;
                }
            }
            else
            {
                tierOne.CopayMax_Found = false;
            }
            //Tier1 - Family
            if (policy.copayMaxInfo.family.inNetworkTier1.found)
            {
                tierOne.CopayMax_Found_Family = true;
                tierOne.CopayMax_Family = SAEGetMemberProviderWebService.valueFormate(policy.copayMaxInfo.family.inNetworkTier1.planAmount);
                tierOne.CopayMax_Satisfied_Family = SAEGetMemberProviderWebService.valueFormate(policy.copayMaxInfo.family.inNetworkTier1.metYtdAmount);
                tierOne.CopayMax_Remaining_Family =  SAEGetMemberProviderWebService.valueFormate(policy.copayMaxInfo.family.inNetworkTier1.remainingAmount);
                tierOne.CopayMax_Precentage_Family = SAEGetMemberProviderWebService.checkAndCall(tierOne.CopayMax_Family,tierOne.CopayMax_Remaining_Family,tierOne.CopayMax_Satisfied_Family);
                
                if(String.isEmpty(yearType))
                {
                    yearType = policy.copayMaxInfo.family.inNetworkTier1.planAmountFrequency;
                }
            }
            else
            {
                tierOne.CopayMax_Found_Family = false;
            }
        }
        else
        {
            inNetwork.CopayMax_Found = false;
            inNetwork.CopayMax_Found_Family = false;
            outNetwork.CopayMax_Found = false;
            outNetwork.CopayMax_Found_Family = false;
            tierOne.CopayMax_Found = false;
            tierOne.CopayMax_Found_Family = false;
        }
        
        if(String.isEmpty(yearType))
        {
            yearType = 'Calendar Year';
        }
        else
        {
            yearType = yearType.trim().replace('(', '').replace(')', '');
        }
        
        if(yearType.equals('Calendar Year'))
        {
            String defaultYear = '01/01/' + System.today().year() + ' - ' + '12/31/' + System.today().year();
            if(policy.policyInfo != null)
            {
                if(policy.policyInfo.planDates != null)
                {
                    String policyYear = '';
                    String startDate = '';
                    startDate = String.isNotBlank(policy.policyInfo.planDates.startDate) ? policy.policyInfo.planDates.startDate : '';
                    List<String> splitDates = startDate.split('-');
                    if(splitDates.size() > 0)
                    {
                        policyYear = splitDates.get(0);
                    }
                    
                    displayYear = '01/01/' + policyYear + ' - ' + '12/31/' + policyYear;
                }
            }
            else
            {
                displayYear = defaultYear;
            }
        }
        
        //US1901028	- Member CDHP Integration - Sarma - 29/08/2019  : start
        Boolean isHra = false;
        Double hraVal = 0.0;
        if((policy.insuranceInfo.hraBalance) != null && (policy.insuranceInfo.hraBalance) != ''){
            isHra = true;
            hraVal =  Double.valueOf(policy.insuranceInfo.hraBalance);
        } else{isHra = false;}
        //US1901028	- Member CDHP Integration : End
        
        SAEMemberProviderSearchCoveragesResult.FinancialsWrapper returnResponse = new SAEMemberProviderSearchCoveragesResult.FinancialsWrapper();
        returnResponse.inNetwork = inNetwork;
        returnResponse.onNetwork = outNetwork;
        returnResponse.tierOne = tierOne;
        returnResponse.yearType = yearType;
        returnResponse.displayYear = displayYear;
        //US1901028 - Member CDHP Integration - Sarma - 29/08/2019
        returnResponse.isHra = isHra;
        returnResponse.hraVal = hraVal;
        
        return returnResponse;
    }
    
    // Sanka Dharmasena
    // Calculate Financial precentages
    public static Double calculatePrecentage(Double met, Double allAmt)
    {
        Double returnPrec = 0.0;
        if(allAmt == 0.0)
        {
            return returnPrec;
        }
        else
        {
            returnPrec = (met/allAmt)*100;
        }
        
        return returnPrec;
    }
    Public Static Decimal valueFormate(String strValue)
    {

        return (String.isNotBlank(strValue) && Decimal.valueOf(strValue)>0)
        ?Decimal.valueOf(strValue).scale()<=2?Decimal.valueOf(strValue).setScale(2, RoundingMode.CEILING)
        :Decimal.valueOf(strValue.substringBefore('.')+'.'+strValue.substringAfterLast('.').substring(0, 2))
        :0.00;
    }
    Public Static Decimal checkAndCall(Decimal total,Decimal remAmt,Decimal satisfied)
	{
		//DE421490
        return (total >=0.1 && satisfied >=0.1 && remAmt>=0)?
        (Decimal.valueOf(SAEGetMemberProviderWebService.calculatePrecentage(Double.valueOf(satisfied), Double.valueOf(total))))
        :0.00;
	}
}