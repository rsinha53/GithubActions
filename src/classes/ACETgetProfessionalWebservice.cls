public Class ACETgetProfessionalWebservice extends ACETWebservice{
    public override void getEndpoint(){
        GetEndpointDetail('GetProfessionalEndpoint');
    }
    public ACETgetProfessionalWebservice() {
        super('Stargate');
    }
    private void GetRequestBody(String claimType, String claimId){          
        RequestBody = '{"getProfessionalClaimRequest": {"claimType": "'+ claimType + '","claimID": "' + claimId + '"}}';     
    } 
    
    public override void GetMethod(){
        Method = 'POST';
    }
    
    public override void GetHeaders(ISL_Webservice_Config__c OAuthConfig){
        
        if (WSConfigurations.containsKey('OILHttpHeaderAccept')){
            Headers.put('accept',WSConfigurations.get('OILHttpHeaderAccept').Value__c );
        }
        if (WSConfigurations.containsKey('OILHttpHeaderScope')){
            Headers.put('scope', WSConfigurations.get('OILHttpHeaderScope').Value__c);
        }
        if (WSConfigurations.containsKey('OILHttpHeaderActor')){
            Headers.put('actor', WSConfigurations.get('OILHttpHeaderActor').Value__c);
        }
        Headers.put('Content-Type', 'application/json');
        Headers.put('authorization', 'Bearer ' + OAuthConfig.Value__c);                   
    }
    
    public ACETWSCalloutResult getProfessionalClaimsWS(String claimType, String claimId){      
       ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
       ACETClaimDetail claimDetail = new ACETClaimDetail(); 
       
       try{
           GetEndpoint();
           GetRequestBody(claimType, claimId);
           GetMethod();
           HttpResponse Response = Send(OAuthConfig);
           oACETWSCalloutResult.statusCode = Response.getStatusCode();
           system.debug(LoggingLevel.INFO, 'Respone--->'+Response.getBody());
           if (Response.getStatusCode() == 200){
                AcetGetProfessionalJSON2Apex json2apex = AcetGetProfessionalJSON2Apex.parse(Response.getBody());
                system.debug(json2apex);
                
                AcetGetProfessionalJSON2Apex.ProfessionalClaim prof = json2apex.GetProfessionalClaimResponse.professionalClaim;
                  
                //Summary
                claimDetail.GroupNumber = prof.susbcriber.memberGroupNumber;
                claimDetail.ReceivedDate = ACETWebserviceHelper.formatDateFromDashToSlash(prof.claimReceiptDate);
                claimDetail.TimelyFilingLimit = prof.timelyFilingLimitDays;
                claimDetail.patientAccountNumber = prof.patientAccountNumber;
                //claimDetail.ClaimProcessed = '';//prof.claimProcessed;
                claimDetail.patientName = prof.patient.name.firstName+' '+prof.patient.name.lastName;
                claimDetail.patientDOB = ACETWebserviceHelper.formatDateFromDashToSlash(prof.patient.birthdate);
                //claimDetail.BillType = prof.billTypeCode.code;
                //claimDetail.AdmitDate = ACETWebserviceHelper.formatDateFromDashToSlash(prof.admitDate);
                //claimDetail.AdmitTime = prof.admitTimeHour;
                claimDetail.ClaimSplitIndicator = prof.claimSplitIndicator;
                if(prof.relatedIcns!=null){
                    claimDetail.relatedIcns = '';
                    for(String icn : prof.relatedIcns){
                        if(claimDetail.relatedIcns.length()>0){
                            claimDetail.relatedIcns += ', ';
                        }
                        claimDetail.relatedIcns += icn;
                    }
                }
                if(prof.referenceClaimID!=null && prof.referenceClaimID.size()>0){
                    claimDetail.ReferenceClaimID = prof.referenceClaimID[0]; 
                }              
                if(prof.ClaimSubmissionType!=null){
                    claimDetail.SubmissionType = prof.ClaimSubmissionType.description;
                    system.debug('submissiontype description--->' + prof.ClaimSubmissionType.description + ',--->' + claimDetail.SubmissionType);
                } 
                else{
                    claimDetail.SubmissionType = '';
                }
                if(prof.claimEvent != null && prof.claimEvent.size() > 0 && prof.claimEvent[0].claimEventType != null){
                    integer i = 0;
                    claimDetail.ClaimEvents = new List<ACETClaimDetail.ClaimEvent>();
                    for(AcetGetProfessionalJSON2Apex.ClaimEvent p: prof.claimEvent)
                    {
                        ACETClaimDetail.ClaimEvent ce = new ACETClaimDetail.ClaimEvent();
                        ce.EventSequenceNumber = p.claimEventSeqnum;
                        ce.claimEventAdjudicationDateTime = ACETWebserviceHelper.formatDateFromDashToSlash(p.claimEventAdjudicationDateTime);
                        ce.EventType = p.claimEventType.description;
                        ce.EventID = p.claimEventId;
                        claimDetail.ClaimEvents.add(ce);
                            
                        if(integer.valueof(p.claimEventSeqnum) > i)
                        {
                            i = integer.valueof(p.claimEventSeqnum);
                            claimDetail.ClaimEventType =p.claimEventType.description;
                            claimDetail.ClaimEventSequenceNumber = p.claimEventSeqNum;
                            claimDetail.ClaimProcessed = ACETWebserviceHelper.formatDateFromDashToSlash(p.claimEventAdjudicationDateTime);
                            if(p.claimDocument!=null && p.claimDocument.size() > 0 && p.claimDocument[0].documentId != null){
                                claimDetail.DCN = p.claimDocument[0].documentId;
                            } 
                            else{
                                claimDetail.DCN = '';
                            }
                        }
                    }
                    //sort list of claim events, remove current event from event history list
                    if(claimDetail.ClaimEvents!=null && claimDetail.ClaimEvents.size()>0){
                        claimDetail.ClaimEvents.sort();
                        claimDetail.ClaimEvents.remove(claimDetail.ClaimEvents.size()-1);
                    }
                    //claimDetail.ClaimEventType = prof.claimEvent[0].claimEventType.description;
                    //claimDetail.ClaimEventSequenceNumber = prof.claimEvent[0].claimEventSeqNum; 
                    //claimDetail.ClaimProcessed = ACETWebserviceHelper.formatDateFromDashToSlash(prof.claimEvent[0].claimEventAdjudicationDateTime);
                }
                    
                
                //if(prof.serviceLine != null && prof.serviceLine.size() > 0){
                    //claimDetail.ReferralNumber = prof.serviceLine[0].referralNumber;
                //}
                
                //Total UHC
                claimDetail.TotalUHCs = new List<ACETClaimDetail.TotalUHC>();
                ACETClaimDetail.TotalUHC totalUHC = new ACETClaimDetail.TotalUHC();
                if(prof.claimUHCTotals != null){
                    if(prof.adjudicatedCOBLevel != null){
                        totalUHC.Status = prof.adjudicatedCOBLevel.description;
                    }
                    totalUHC.Charged = prof.claimUHCTotals.claimTotalBilledChargeAmount;
                    totalUHC.ReimbursementReduction = prof.claimUHCTotals.claimTotalReimbursementReductionAmount;                   
                    totalUHC.Allowed = prof.claimUHCTotals.claimTotalAllowedAmount;
                    totalUHC.Penalty = prof.claimUHCTotals.claimTotalPenaltyAmount;
                    totalUHC.InterestPaid = prof.claimUHCTotals.claimTotalInterestAmount;
                    totalUHC.NYSurchargePaid = prof.claimUHCTotals.claimTotalStateSurchargeAmount;
                    totalUHC.HealthPlanPaid = prof.claimUHCTotals.claimTotalPaidAmount;
                    claimDetail.TotalUHCs.add(totalUHC);
                }
                    
                //Member Responsibility 
                claimDetail.MemberResponsibility = new List<ACETClaimDetail.MemberResponsibility>();
                ACETClaimDetail.MemberResponsibility memberResponsibility = new ACETClaimDetail.MemberResponsibility(); 
                if(prof.claimUHCTotals != null){
                    memberResponsibility.Deductible = prof.claimUHCTotals.claimTotalDeductibleAmount;
                    memberResponsibility.Copay = prof.claimUHCTotals.totalCopayAmount;
                    memberResponsibility.Coinsurance = prof.claimUHCTotals.claimTotalCoinsuranceAmount;
                  //memberResponsibility.ReimbursementReduction = prof.claimUHCTotals.claimTotalReimbursementReductionAmount;
                    memberResponsibility.ReimbursementReduction = prof.claimUHCTotals.claimTotalMemberReimbursementReductionAmount;
                    memberResponsibility.Penalty = prof.claimUHCTotals.claimTotalMemberPenaltyAmount;
                    memberResponsibility.TotalMemberResponsibility = prof.claimUHCTotals.totalPatientResponsibilityAmount;
                    
                    claimDetail.MemberResponsibility.add(memberResponsibility);
                }
                    
                
                //Provider Responsibility
                claimDetail.ProviderResponsibility = new List<ACETClaimDetail.ProviderResponsibility>();
                ACETClaimDetail.ProviderResponsibility ProviderResponsibility = new ACETClaimDetail.ProviderResponsibility();                
                if(prof.claimUHCTotals != null){
                 // ProviderResponsibility.ReimbursementReduction = prof.claimUHCTotals.claimTotalReimbursementReductionAmount;
                    ProviderResponsibility.ReimbursementReduction = prof.claimUHCTotals.claimTotalProviderReimbursementReductionAmount;
                    ProviderResponsibility.Penalty = prof.claimUHCTotals.claimTotaProviderPenaltyAmount;
                    ProviderResponsibility.TotalProviderResponsibility = prof.claimUHCTotals.claimTotalUHCProvWriteOffAmount;
                    ProviderResponsibility.TotalWriteOff = prof.claimUHCTotals.claimTotalUHCProvWriteOffAmount;
                    claimDetail.ProviderResponsibility.add(ProviderResponsibility);
                }
                
                //Total COB
                claimDetail.TotalCOB = new List<ACETClaimDetail.TotalCOB>();
                if(prof.otherPayer != null){
                    for(AcetGetProfessionalJSON2Apex.OtherPayer op : prof.otherPayer){
                        ACETClaimDetail.TotalCOB tc = new ACETClaimDetail.TotalCOB();
                        if(op.payerResponsibilitySequenceCode != null) tc.Status = op.payerResponsibilitySequenceCode.description;  
                        if(op.insuranceTypeCode != null) tc.OtherInsuranceType = op.insuranceTypeCode.description;
                        if(prof.claimUHCTotals != null) tc.Charged = prof.claimUHCTotals.claimTotalBilledChargeAmount;                      
                        //tc.Allowed = ???
                        tc.NotCovered = op.claimTotalOtherPayerNotCoveredAmount;
                        tc.Paid = op.claimTotalOtherPayerPaidAmount;
                        tc.MemberResponsibility = op.claimTotalOtherPayerPatientResponsibilityAmount;
                        if(prof.serviceLine != null && prof.serviceLine.size() > 0){
                            if(prof.serviceLine[0].cobMethod != null) tc.COBMethod = prof.serviceLine[0].cobMethod.description;
                        }
                        claimDetail.TotalCOB.add(tc);
                    }   
                }
                //Claim Code   
                claimDetail.ClaimCode = new List<ACETClaimDetail.ClaimCode>();
                if(prof.serviceLine != null) {
                    for(AcetGetProfessionalJSON2Apex.ServiceLine sl : prof.serviceLine) {
                        
                        if(sl.serviceRemarks !=null){
                        for(AcetGetProfessionalJSON2Apex.ClaimRemarks serviceRemarks: sl.serviceRemarks) { 
                            ACETClaimDetail.ClaimCode cc = new ACETClaimDetail.ClaimCode();
                            
                            cc.serviceLineID = String.isNotEmpty(sl.claimServiceLineID)?sl.claimServiceLineID:'';
                            cc.RevenueCode = (sl.revenueCode != null && sl.revenueCode.code != null && String.isNotEmpty(sl.revenueCode.code))?sl.revenueCode.code:'';
                            cc.RevenueDescription = (sl.revenueCode != null && sl.revenueCode.description!= null && String.isNotEmpty(sl.revenueCode.description))?sl.revenueCode.description:'';
                            cc.ProcedureCode = (sl.procedureCode != null && String.isNotEmpty(sl.procedureCode.code.code))?sl.procedureCode.code.code:''; 
                            cc.ProcedureDescription = (sl.procedureCode != null && String.isNotEmpty(sl.procedureCode.code.description))?sl.procedureCode.code.description:''; 

                            if(sl.benefitPlan != null && sl.benefitPlan.benefitCode != null){
                                cc.BenefitCode = sl.benefitPlan.benefitCode.code;
                                cc.BenefitDescription = sl.benefitPlan.benefitCode.description;
                            }
                            else {
                                cc.BenefitCode = '';
                                cc.BenefitDescription = '';
                            }
                            if(serviceRemarks.remarkCode != null) {
                                cc.RemarkCode = String.isNotEmpty(serviceRemarks.remarkCode.code)?serviceRemarks.remarkCode.code:'';
                                cc.RemarkDescription = String.isNotEmpty(serviceRemarks.remarkCode.description)?serviceRemarks.remarkCode.description:'';
                            }
                            cc.RemarkCodeMemberDescription = serviceRemarks.remarkCodeMemberDesc != null ? serviceRemarks.remarkCodeMemberDesc : serviceRemarks.remarkCodeMemberProviderDesc;
                            cc.RemarkCodeProviderDescription = serviceRemarks.remarkCodeProviderDesc != null ? serviceRemarks.remarkCodeProviderDesc: serviceRemarks.remarkCodeMemberProviderDesc;
                            
                            if(sl.carcAdjustments != null && sl.carcAdjustments.adjustments!= null && sl.carcAdjustments.adjustments.size() > 0 && sl.carcAdjustments.adjustments[0].code != null){
                                cc.CARCCode = sl.carcAdjustments.adjustments[0].code.code;
                                cc.CARCDescription = sl.carcAdjustments.adjustments[0].code.description;
                            }
                            else {
                                cc.CARCCode = '';
                                cc.CARCDescription = '';
                            }
                            
                            if(sl.serviceRemarks != null && sl.serviceRemarks.size() > 0 && sl.serviceRemarks[0].rarcCode != null){
                                cc.RARCCode = sl.serviceRemarks[0].rarcCode.code;
                                cc.RARCDescription = sl.serviceRemarks[0].rarcCode.description;
                            }
                            else {
                                cc.RARCCode = '';
                                cc.RARCDescription = '';
                            }
                            System.debug('claimDetail::::::'+claimDetail.ClaimCode);
                            if(serviceRemarks.remarkCode.code != System.Label.ACETClaimRemarkCode){
                            claimDetail.ClaimCode.add(cc);
                            }
                        }
                       }
                    }
                    //claimDetail.ClaimCode.sort();
                    //System.debug('claimDetail::::::'+claimDetail.ClaimCode);
                }
                /*if(prof.serviceLine != null){
                    for(AcetGetProfessionalJSON2Apex.ServiceLine sl : prof.serviceLine) {
                        ACETClaimDetail.ClaimCode cc = new ACETClaimDetail.ClaimCode();
                        
                        if(sl.claimServiceLineID != null) {
                            cc.serviceLineID = sl.claimServiceLineID;
                        }
                        
                        if(sl.revenueCode != null){
                             cc.RevenueCode = sl.revenueCode.code;
                             cc.RevenueDescription = sl.revenueCode.description;
                        }
                                                
                        if(sl.procedureCode != null && sl.procedureCode.code != null){
                            cc.ProcedureCode = sl.procedureCode.code.code;
                            cc.ProcedureDescription = sl.procedureCode.code.description;
                        }
                        
                        if(sl.benefitClaimAccumulator != null && sl.benefitClaimAccumulator.size() > 0 && sl.benefitClaimAccumulator[0].benefitCode != null){
                            cc.BenefitCode = sl.benefitClaimAccumulator[0].benefitCode.code;
                            cc.BenefitDescription = sl.benefitClaimAccumulator[0].benefitCode.description;
                        }
                        // Remark code Split - starts
                        if(sl.serviceRemarks != null && sl.serviceRemarks.size() > 0 && sl.serviceRemarks[0].remarkCode != null){
                            cc.RemarkCode = ' ';
                            cc.RemarkDescription = ' ';
                            cc.RemarkCodeMemberDescription = ' ';
                            cc.RemarkCodeProviderDescription = ' ';
                            for(AcetGetProfessionalJSON2Apex.ClaimRemarks serviceRem: sl.serviceRemarks) {                     
                                cc.RemarkCode = cc.RemarkCode+serviceRem.remarkCode.code+'\r\n';
                                String remarkDescription = (serviceRem.remarkCode.description != null)?serviceRem.remarkCode.description:'';
                                String RemarkCodeMemberDescription = (serviceRem.remarkCodeMemberDesc != null)?serviceRem.remarkCodeMemberDesc :'';
                                String RemarkCodeProviderDescription = (serviceRem.remarkCodeProviderDesc != null)?serviceRem.remarkCodeProviderDesc :'';
                                
                                cc.RemarkDescription = cc.RemarkDescription+remarkDescription+'\r\n';
                                cc.RemarkCodeMemberDescription = cc.RemarkCodeMemberDescription+RemarkCodeMemberDescription+'\r\n';
                                cc.RemarkCodeProviderDescription = cc.RemarkCodeProviderDescription+RemarkCodeProviderDescription+'\r\n';
                        
                            }                       
                            //cc.RemarkCode = sl.serviceRemarks[0].remarkCode.code;
                            //cc.RemarkDescription = sl.serviceRemarks[0].remarkCode.description;
                            //cc.RemarkCodeMemberDescription = (sl.serviceRemarks[0].remarkCodeMemberDesc != null)?sl.serviceRemarks[0].remarkCodeMemberDesc:'';
                            //cc.RemarkCodeProviderDescription = (sl.serviceRemarks[0].remarkCodeProviderDesc != null)?sl.serviceRemarks[0].remarkCodeProviderDesc:'';
                        }
                        //End
                        if(sl.carcAdjustments != null && sl.carcAdjustments.adjustments!= null && sl.carcAdjustments.adjustments.size() > 0 && sl.carcAdjustments.adjustments[0].code != null){
                            cc.CARCCode = sl.carcAdjustments.adjustments[0].code.code;
                            cc.CARCDescription = sl.carcAdjustments.adjustments[0].code.description;
                        }
                        
                        if(sl.serviceRemarks != null && sl.serviceRemarks.size() > 0 && sl.serviceRemarks[0].rarcCode != null){
                            cc.RARCCode = sl.serviceRemarks[0].rarcCode.code;
                            cc.RARCDescription = sl.serviceRemarks[0].rarcCode.description;
                        }
                        claimDetail.ClaimCode.add(cc);
                    }
                    claimDetail.ClaimCode.sort();
                }*/
                                                 
                //Service Line   
                claimDetail.ServiceLines = new List<ACETClaimDetail.ServiceLine>();
                claimDetail.ClaimEdits = new List<ACETClaimDetail.ClaimEdit>(); 
                if(prof.serviceLine != null){
                    for(AcetGetProfessionalJSON2Apex.ServiceLine sl : prof.serviceLine){
                        ACETClaimDetail.ServiceLine serviceLine = new ACETClaimDetail.ServiceLine();
                        if(sl.claimServiceLineID != null) {
                            serviceLine.ServiceLineCode = sl.claimServiceLineID;
                        } 
                        if(sl.serviceLineStatusCode != null)
                        {
                            serviceLine.Status = sl.serviceLineStatusCode.description;
                        }
                        if(sl.serviceLineUHCAmounts != null)
                        {
                            serviceLine.Charged = sl.serviceLineUHCAmounts.serviceBilledChargeAmount;
                            serviceLine.Copay = sl.serviceLineUHCAmounts.serviceCopayAmount;
                            serviceLine.Coinsurance = sl.serviceLineUHCAmounts.serviceCoinsuranceAmount;
                        }
                        if(sl.serviceNetworkIndicator != null){
                            serviceLine.BenefitLevel = sl.serviceNetworkIndicator.code;
                        }
                        if(sl.alphaParentLineNum != null)
                        {
                            if(sl.alphaParentLineNum.size() > 0){
                            serviceLine.alphaParentLineNum = json.serialize(sl.alphaParentLineNum);
                            serviceLine.alphaParentLineNum = serviceLine.alphaParentLineNum.replace('[','');
                            serviceLine.alphaParentLineNum = serviceLine.alphaParentLineNum.replace(']','');
                            serviceLine.alphaParentLineNum = serviceLine.alphaParentLineNum.replace('"','');
                            }
                            
                        }
                        serviceLine.PlaceofService = sl.placeofServiceCode;
                        
                        if(sl.revenueCode != null){
                            serviceLine.Revenue = sl.revenueCode.code;
                        }
                        
                        if(sl.procedureCode != null){
                            if(sl.procedureCode.code != null) serviceLine.Procedure = sl.procedureCode.code.code;   
                            if(sl.procedureCode.hpcscptModifierCode != null && sl.procedureCode.hpcscptModifierCode.size() > 0){
                                 serviceLine.Modifier = sl.procedureCode.hpcscptModifierCode[0].code;
                            }                                                       
                        } 
                        
                        if(sl.benefitClaimAccumulator != null && sl.benefitClaimAccumulator.size() > 0 && sl.benefitClaimAccumulator[0].benefitCode != null){
                            serviceLine.Benefit = sl.benefitClaimAccumulator[0].benefitCode.code;
                        }
                        system.debug('Webservice011');                                
                        if(sl.serviceRemarks != null && sl.serviceRemarks.size() > 0 && sl.serviceRemarks[0].remarkCode != null){
                            serviceLine.Remark = sl.serviceRemarks[0].remarkCode.code;
                        }
                        
                        if(sl.carcAdjustments !=null && sl.carcAdjustments.adjustments != null && sl.carcAdjustments.adjustments.size() > 0 && sl.carcAdjustments.adjustments[0].code != null){
                            serviceLine.CARC = sl.carcAdjustments.adjustments[0].code.code;
                            serviceLine.Adjustment = sl.carcAdjustments.adjustments[0].amount;
                        }
                        
                        if(sl.diagnosisCodePointer != null && sl.diagnosisCodePointer.size() >= 4){
                            serviceLine.DxPointer = sl.diagnosisCodePointer[0] + ' ' + sl.diagnosisCodePointer[1] + ' ' + sl.diagnosisCodePointer[2] + ' ' + sl.diagnosisCodePointer[3];
                        }                       
                        
                        if(sl.serviceRemarks != null && sl.serviceRemarks.size() > 0 && sl.serviceRemarks[0].rarcCode != null){
                            serviceLine.RARC = sl.serviceRemarks[0].rarcCode.code;  
                        }
                        if(sl.qualityTierValue != null){
                       if(sl.qualityTierValue =='1' || sl.qualityTierValue =='01'){
                             serviceLine.qualityTierValue = sl.qualityTierValue;   
                         }else{
                          serviceLine.qualityTierValue = 'N/A';    
                         }   
                         }else{
                          serviceLine.qualityTierValue = 'N/A';  
                         }                              
                        serviceLine.Units = sl.serviceUnitCount;
                        serviceLine.StartDate = ACETWebserviceHelper.formatDateFromDashToSlash(sl.serviceFirstDateofService);
                        serviceLine.EndDate = ACETWebserviceHelper.formatDateFromDashToSlash(sl.serviceLastDateofService);
                        
                        if(sl.serviceLineUHCAmounts != null){
                            serviceLine.Allowed = sl.serviceLineUHCAmounts.serviceAllowedAmount;
                            serviceLine.Deductible = sl.serviceLineUHCAmounts.serviceDeductibleAmount;
                            serviceLine.ReimbursementReduction = sl.serviceLineUHCAmounts.serviceReimbursementReductionAmount;
                            serviceLine.Penalty = sl.serviceLineUHCAmounts.servicePenaltyAmount;
                            serviceLine.Paid = sl.serviceLineUHCAmounts.servicePaidAmount;                                                                              
                        }
                        
                        if(sl.benefitPlan != null){
                            serviceLine.Percent = sl.benefitPlan.planCoinsurancePercent;  
                        }   
                        system.debug('Webservice013');                                
                        serviceLine.Authorization = (sl.authorizationNumber != null)?sl.authorizationNumber:'';
                        serviceLine.ReferralNumber = (sl.referralNumber!= null)?sl.referralNumber:'';
                        claimDetail.ServiceLines.add(serviceLine);  
                        

                            if(sl.cesmnemonic!=null){
                            system.debug('sl.cesmnemonic.size>>>>'+sl.cesMnemonic.size());
                            if(prof.cesMnemonic==null){
                                prof.cesMnemonic = new List<AcetGetProfessionalJSON2Apex.CesMnemonic>();
                            }
                            system.debug('prof.cesMnemonic>>>>'+prof.cesMnemonic);
                            
                            if(prof.cesMnemonic!=null && sl.cesMnemonic!=null && sl.cesMnemonic.size() > 0){
                                for(AcetGetProfessionalJSON2Apex.CesMnemonic cesm : sl.cesMnemonic){
                                    //prof.cesMnemonic.add(cesm);
                                    ACETClaimDetail.ClaimEdit ce = new ACETClaimDetail.ClaimEdit();
                                    if(cesm.cesMnemonicCode != null){
                                         ce.EditType = cesm.cesMnemonicCode.code;
                                         system.debug('CLAIMEDITS>>>>EDITTYPE'+cesm.cesMnemonicCode.code);
                                         system.debug('CLAIMEDITS>>>>EDITDESC'+cesm.cesMnemonicCode.description);
                                         ce.EditDescription = cesm.cesMnemonicCode.description;
                                    }
                                    system.debug('CLAIMEDITS>>>>EDITACTION'+cesm.cesRemarkText);
                                    ce.EditAction = cesm.cesRemarkText;
                                    ce.ServiceLine = sl.claimServiceLineID;
                                    claimDetail.ClaimEdits.add(ce);
                                }
                            }
                        }                                                                               
                    }
                    //claimDetail.ServiceLines.sort();
                }
                     
                //Claim Diagnosis
                claimDetail.ClaimDiagnosis = new List<ACETClaimDetail.ClaimDiagnosis>();                
                if(prof.diagnosisCode != null && prof.diagnosisCode.size() > 0){
                    for(AcetGetProfessionalJSON2Apex.DiagnosisCode diag : prof.diagnosisCode){
                        ACETClaimDetail.ClaimDiagnosis cd= new ACETClaimDetail.ClaimDiagnosis(); 
                        cd.SequenceNumber = diag.sequenceNumber;   
                        if(diag.code != null){
                            cd.DiagnosisCode = diag.code.code;
                            cd.DiagnosisDescription = diag.code.description; 
                        } 
                        cd.POA = diag.claimPresentOnAdmissionsIndicator;                    
                        claimDetail.ClaimDiagnosis.add(cd);
                    }
                }
                    system.debug('Webservice008');                                
                 
               //Claim Edits
                /* claimDetail.ClaimEdits = new List<ACETClaimDetail.ClaimEdit>();              
                 if(prof.cesMnemonic != null && prof.cesMnemonic.size() > 0){
                    for(AcetGetProfessionalJSON2Apex.CesMnemonic cesm : prof.cesMnemonic){
                        system.debug('CLAIMEDITS>>>>'+cesm);
                        
                        ACETClaimDetail.ClaimEdit ce = new ACETClaimDetail.ClaimEdit();
                        if(cesm.cesMnemonicCode != null){
                             ce.EditType = cesm.cesMnemonicCode.code;
                             system.debug('CLAIMEDITS>>>>EDITTYPE'+cesm.cesMnemonicCode.code);
                             system.debug('CLAIMEDITS>>>>EDITDESC'+cesm.cesMnemonicCode.description);
                             ce.EditDescription = cesm.cesMnemonicCode.description;
                        }
                        system.debug('CLAIMEDITS>>>>EDITACTION'+cesm.cesRemarkText);
                        ce.EditAction = cesm.cesRemarkText;
                        claimDetail.ClaimEdits.add(ce);
                    }
                }*/
                                                    
                //Cause Code
                claimDetail.CauseCode = new List<ACETClaimDetail.CauseCode>();
                ACETClaimDetail.CauseCode causeCode = new ACETClaimDetail.CauseCode();
                if(prof.claimCauseCode != null){
                    if(prof.claimCauseCode != null){
                        causeCode.CauseCode = prof.claimCauseCode.code;
                        causeCode.CauseDescription = prof.claimCauseCode.description; 
                    }
                    claimDetail.CauseCode.add(causeCode);
                }           
                
                claimDetail.claimNotesUser = new List<ACETClaimDetail.claimNote>();
                claimDetail.claimNotesSystem = new List<ACETClaimDetail.claimNote>();
                if(prof.claimNotes != null){
                    for(AcetGetProfessionalJSON2Apex.claimNotes CN : prof.claimNotes){
                        ACETClaimDetail.claimNote newCN = new ACETClaimDetail.claimNote();  
                        newCN.noteTypeCode = CN.noteTypeCode;
                        newCN.noteTypeText = CN.noteTypeText;
                        newCN.notesCreatedBy = CN.notesCreatedBy;
                        newCN.notesCreatedDate = CN.notesCreatedDate;
                        if(newCN.noteTypeCode == 'U'){
                            claimDetail.claimNotesUser.add(newCN);
                        }
                        else if(newCN.noteTypeCode == 'S'){
                            claimDetail.claimNotesSystem.add(newCN);
                        }
                    }
                    claimDetail.claimNotesUser.sort();
                    claimDetail.claimNotesSystem.sort();
                }

                
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = claimDetail;
                
                system.debug('claimDetail:');
                system.debug(claimDetail);
               
           }else{
                oACETWSCalloutResult = ParseFailureResponse(Response);
                oACETWSCalloutResult.Message = 'Problem with getProfessionalClaim Webservice:' + oACETWSCalloutResult.Message;
                oACETWSCalloutResult.statusCode = Response.getStatusCode();
           }
       }
       Catch(Exception ex){
           system.debug(LoggingLevel.INFO, 'Exception in getProfessionalClaim Webservice. Details: ' + ex+'at line '+ex.getLineNumber()); 
           oACETWSCalloutResult.Success = false;
           oACETWSCalloutResult.Message = 'Problem with getProfessionalClaim Webservice:' + ex.getMessage();
           oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        //system.debug('**oACETWSCalloutResult**'+oACETWSCalloutResult);
        return oACETWSCalloutResult;
    }
    
     
    public String formatDatetime(String dateTimeString){        
        if(!String.isEmpty(dateTimeString)){
            List<String> dtParts = dateTimeString.split('T');
            if(dtParts.size() == 2){
                String dateString = dtParts[0];
                String timeString = dtParts[1];
                
                List<String> dateParts = dateString.split('-');               
                if(dateParts.size() == 3){
                    String mm = dateParts[1];
                    String dd = dateParts[2];
                    String yyyy = dateParts[0];
                    
                    mm = mm.contains('0') && mm.indexOf('0') == 0 ? mm.replace('0','') : mm ; 
                    dd = dd.contains('0') && dd.indexOf('0') == 0 ? dd.replace('0','') : dd; 
                    
                    if(timeString.length() > = 8){                       
                        return mm  + '/' + dd + '/' + yyyy + ' ' + timeString.substring(0,8);
                    }
                }
                
            }
        }
        return dateTimeString;
    }
    public String FormatRecpt (String  recipient){
    
       if(!String.isEmpty(recipient)){
       
       recipient= recipient.replaceAll('\"[^\"]*\":null',''); //basic removeal of null values
        

       }
     return recipient;
    }
    public String formatStartDate(String dateString){
        if(dateString == null) return null;
        list<String> dateParts = dateString.split('-');
        if(dateParts.size() == 3){
            String mm = dateParts[1];
            String dd = dateParts[2].length() !=2 ? '0'+dateParts[2] : dateParts[2];
            String yyyy = dateParts[0];
            return mm  + '/' + dd + '/' + yyyy;
        }else{
            return dateString;
        }
    }
    public String formatEndDate(String dateString){
        if(dateString == null) return null;
        list<String> dateParts = dateString.split('/');
        if(dateParts.size() == 3){
            String mm =  dateParts[0].length() !=2 ? '0'+dateParts[0] : dateParts[0];
            String dd = dateParts[1].length() !=2 ? '0'+dateParts[1] : dateParts[1];
            String yyyy = dateParts[2];
            return mm  + '/' + dd + '/' + yyyy;
        }else{
            return dateString;
        }
    }
}