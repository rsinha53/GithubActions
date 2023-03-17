public class ACETProfessionalClaimHistoryWebservice extends ACETWebservice{

    public List<String> SearchParameters ;    
    public override void GetEndpoint()
    {
        GetEndpointDetail('ProfessionalClaimHistoryEndpoint');
    }
    public ACETProfessionalClaimHistoryWebservice() {
        super('Stargate');
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
        system.debug('OAuthConfig.Value__c is '+OAuthConfig.Value__c);
        Headers.put('authorization', 'Bearer ' + OAuthConfig.Value__c);
    }
    
    public void GetRequestBody(){
        RequestBody = GetRequestBody('professionalClaimHistoryRequest',SearchParameters);
        system.debug('RequestBody is '+RequestBody);
    }
    
    public ACETWSCalloutResult ProfessionalClaimHistoryWS(String claimType, String claimId, String claimEventId){
        SearchParameters = new String[] {claimType, claimId, claimEventId};
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        ACETClaimDetail claimDetail = new ACETClaimDetail(); 
        
        try{
            GetEndpoint();
            GetRequestBody();
            GetMethod();
            HttpResponse Response = Send(OAuthConfig);
            system.debug('Status code is '+Response.getStatusCode()+'body is '+Response.getBody());
            oACETWSCalloutResult.statusCode = Response.getStatusCode();
            if (Response.getStatusCode() == 200){                             
                ACETProfessionalClaimHistoryJson2Apex json2apex = (ACETProfessionalClaimHistoryJson2Apex)JSON.deserialize(Response.getBody(), ACETProfessionalClaimHistoryJson2Apex.class);
                //Summary  
                ACETProfessionalClaimHistoryJson2Apex.ProfessionalClaim prof = json2apex.professionalClaimHistoryResponse.professionalClaim[0];
                system.debug('prof is '+prof);
                claimDetail.GroupNumber = prof.subscriber.memberGroupNumber;
                claimDetail.ReceivedDate = ACETWebserviceHelper.formatDateFromDashToSlash(prof.claimReceiptDate);
                claimDetail.TimelyFilingLimit = prof.timelyFilingLimitDays;
                claimDetail.patientAccountNumber = prof.patientAccountNumber;
                claimDetail.patientName = prof.patient.name.firstName+' '+prof.patient.name.lastName;
                claimDetail.patientDOB = ACETWebserviceHelper.formatDateFromDashToSlash(prof.patient.birthdate);
                if(prof.billTypeCode != null){
                claimDetail.BillType = prof.billTypeCode.code;}
                claimDetail.AdmitDate = ACETWebserviceHelper.formatDateFromDashToSlash(prof.admitDate);
                claimDetail.AdmitTime = prof.admitTimeHour;
                claimDetail.ClaimSplitIndicator = prof.claimSplitIndicator;

                   if(prof.relatedIcns!=null){
                  claimDetail.relatedIcns = '';
                  for(String icn : prof.relatedIcns){
                    if(claimDetail.relatedIcns.length()>0){
                      claimDetail.relatedIcns += ', ';
                    }
                    claimDetail.relatedIcns += icn;
                  }
                }                if(prof.referenceClaimID!=null && prof.referenceClaimID.size()>0){
                    claimDetail.ReferenceClaimID = prof.referenceClaimID[0]; 
                }
                if(prof.ClaimSubmissionType!=null){
                    claimDetail.SubmissionType = prof.ClaimSubmissionType.description;
                    system.debug('submissiontype description--->' + prof.ClaimSubmissionType.description + ',--->' + claimDetail.SubmissionType);
                } 
                else{
                    claimDetail.SubmissionType = '';
                }               
                if(prof.claimEvent != null && prof.claimEvent.claimEventType != null){
                    integer i = 0;
                    system.debug('prof.claimEvent is '+prof.claimEvent);
                    ACETProfessionalClaimHistoryJson2Apex.ClaimEvent ins = prof.claimEvent;
                    claimDetail.ClaimEvents = new List<ACETClaimDetail.ClaimEvent>();
                    ACETClaimDetail.ClaimEvent ce = new ACETClaimDetail.ClaimEvent();
                    ce.EventSequenceNumber = ins.claimEventSeqnum;
                    ce.EventType = ins.claimEventType.description;
                    ce.EventID = ins.claimEventId;
                    system.debug('ce is '+ce);
                    claimDetail.ClaimEvents.add(ce);
                    
                    if(integer.valueof(ins.claimEventSeqnum) > i)
                    {
                        i = integer.valueof(ins.claimEventSeqnum);
                        claimDetail.ClaimEventType = ins.claimEventType.description;
                        claimDetail.ClaimEventSequenceNumber = ins.claimEventSeqNum; 
                        claimDetail.ClaimProcessed = ACETWebserviceHelper.formatDateFromDashToSlash(ins.claimEventAdjudicationDateTime);
                        if(ins.claimDocument!=null && ins.claimDocument.size() > 0 && ins.claimDocument[0].documentId != null){
                            claimDetail.DCN = ins.claimDocument[0].documentId;
                        } 
                        else{
                            claimDetail.DCN = '';
                        }
                    }
                    //sort list of claim events, remove current event from event history list
                    if(claimDetail.ClaimEvents!=null && claimDetail.ClaimEvents.size()>0){
                        claimDetail.ClaimEvents.sort();
                        claimDetail.ClaimEvents.remove(claimDetail.ClaimEvents.size()-1);
                    }
                }                
                
                //if(inst.serviceLine != null && inst.serviceLine.size() > 0){
                    //claimDetail.ReferralNumber = inst.serviceLine[0].referralNumber;
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
                    //memberResponsibility.ReimbursementReduction = inst.claimUHCTotals.claimTotalReimbursementReductionAmount;
                    memberResponsibility.ReimbursementReduction = prof.claimUHCTotals.claimTotalMemberReimbursementReductionAmount;
                    memberResponsibility.Penalty = prof.claimUHCTotals.claimTotalMemberPenaltyAmount;
                    memberResponsibility.TotalMemberResponsibility = prof.claimUHCTotals.totalPatientResponsibilityAmount;
                    claimDetail.MemberResponsibility.add(memberResponsibility);
                }
                                
                //Provider Responsibility
                claimDetail.ProviderResponsibility = new List<ACETClaimDetail.ProviderResponsibility>();
                ACETClaimDetail.ProviderResponsibility ProviderResponsibility = new ACETClaimDetail.ProviderResponsibility();                
                if(prof.claimUHCTotals != null){
                    //ProviderResponsibility.ReimbursementReduction = inst.claimUHCTotals.claimTotalReimbursementReductionAmount;
                    ProviderResponsibility.ReimbursementReduction = prof.claimUHCTotals.claimTotalProviderReimbursementReductionAmount;
                    //ProviderResponsibility.Penalty = '';
                    ProviderResponsibility.Penalty = prof.claimUHCTotals.claimTotaProviderPenaltyAmount;
                    ProviderResponsibility.TotalProviderResponsibility = prof.claimUHCTotals.claimTotalUHCProvWriteOffAmount;
                    claimDetail.ProviderResponsibility.add(ProviderResponsibility);
                }
                
                //Total COB 
                claimDetail.TotalCOB = new List<ACETClaimDetail.TotalCOB>();
                if(prof.otherPayer != null){
                    for(ACETProfessionalClaimHistoryJson2Apex.OtherPayer op : prof.otherPayer){
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
                   if(prof.serviceLine != null && prof.serviceLine.size() > 0) {
               
                     for(ACETProfessionalClaimHistoryJson2Apex.ServiceLine sl : prof.serviceLine) {
                           if (sl.serviceRemarks !=null){
                        for(ACETProfessionalClaimHistoryJson2Apex.serviceRemarks serviceRemarks: sl.serviceRemarks) { 
                            system.debug('serviceRemarks is is '+serviceRemarks);    
                            ACETClaimDetail.ClaimCode cc = new ACETClaimDetail.ClaimCode();
                            
                            cc.serviceLineID = (sl.claimServiceLineID != null && String.isNotEmpty(sl.claimServiceLineID))?sl.claimServiceLineID:'';
                            cc.RevenueCode = (sl.revenueCode != null && sl.revenueCode.code != null && String.isNotEmpty(sl.revenueCode.code))?sl.revenueCode.code:'';
                            cc.RevenueDescription = (sl.revenueCode != null && sl.revenueCode.description!= null && String.isNotEmpty(sl.revenueCode.description))?sl.revenueCode.description:'';
                            boolean proCodeSuccess = false;
                            if(sl.procedureCode!=null){
                                if(sl.procedureCode.code!=null){
                                    if(sl.procedureCode.code.code!=null){
                                        if(String.isNotEmpty(sl.procedureCode.code.code)){
                                            cc.ProcedureCode = sl.procedureCode.code.code;
                                            proCodeSuccess = true;
                                        }
                                    }
                                }
                            }
                            if(!proCodeSuccess){
                                cc.ProcedureCode = '';
                            }
                            //cc.ProcedureCode = (sl.procedureCode != null && sl.procedureCode.code!=null && String.isNotEmpty(sl.procedureCode.code.code))?sl.procedureCode.code.code:'';                            cc.ProcedureDescription = (sl.procedureCode != null && String.isNotEmpty(sl.procedureCode.code.description))?sl.procedureCode.code.description:''; 
                        
                            cc.RemarkCodeMemberDescription = serviceRemarks.remarkCodeMemberDesc != null ? serviceRemarks.remarkCodeMemberDesc : serviceRemarks.remarkCodeMemberProviderDesc;
                            cc.RemarkCodeProviderDescription = serviceRemarks.remarkCodeProviderDesc != null ? serviceRemarks.remarkCodeProviderDesc: serviceRemarks.remarkCodeMemberProviderDesc;
                                                        
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
                            claimDetail.ClaimCode.add(cc);
                        }
                    }
                  }  
                 
                    //claimDetail.ClaimCode.sort();
                }
                /*if(inst.serviceLine != null){
                    for(ACETgetInstitutionalJson2Apex.ServiceLine sl : inst.serviceLine){
                        ACETClaimDetail.ClaimCode cc = new ACETClaimDetail.ClaimCode();
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
                        
                        if(sl.serviceRemarks != null && sl.serviceRemarks.size() > 0 && sl.serviceRemarks[0].remarkCode != null){                       
                            cc.RemarkCode = sl.serviceRemarks[0].remarkCode.code;
                            cc.RemarkDescription = sl.serviceRemarks[0].remarkCode.description;
                        }
                        
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
                }*/
                
                //Service Line   
                claimDetail.ServiceLines = new List<ACETClaimDetail.ServiceLine>();
                claimDetail.ClaimEdits = new List<ACETClaimDetail.ClaimEdit>();
                if(prof.serviceLine != null){
                    for(ACETProfessionalClaimHistoryJson2Apex.ServiceLine sl : prof.serviceLine){
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
                        
                        if(sl.serviceRemarks != null && sl.serviceRemarks.size() > 0 && sl.serviceRemarks[0].remarkCode != null){
                            serviceLine.Remark = sl.serviceRemarks[0].remarkCode.code;
                        }
                        
                        if(sl.carcAdjustments !=null && sl.carcAdjustments.adjustments != null && sl.carcAdjustments.adjustments.size() > 0 && sl.carcAdjustments.adjustments[0].code != null){
                            serviceLine.CARC = sl.carcAdjustments.adjustments[0].code.code;
                            serviceLine.Adjustment = sl.carcAdjustments.adjustments[0].amount;
                        }
                        
                        if(sl.serviceRemarks != null && sl.serviceRemarks.size() > 0 && sl.serviceRemarks[0].rarcCode != null){
                            serviceLine.RARC = sl.serviceRemarks[0].rarcCode.code;  
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
                                                
                        serviceLine.Authorization = sl.authorizationNumber; 
                        serviceLine.ReferralNumber = sl.referralNumber;
                        claimDetail.ServiceLines.add(serviceLine);
                        
                        
                        
                        if(sl.cesmnemonic!=null){
                            system.debug('sl.cesmnemonic.size>>>>'+sl.cesMnemonic.size());
                            if(prof.cesMnemonic==null){
                                prof.cesMnemonic = new List<ACETProfessionalClaimHistoryJson2Apex.CesMnemonic>();
                            }
                            system.debug('prof.cesMnemonic>>>>'+prof.cesMnemonic);
                            
                            if(prof.cesMnemonic!=null && sl.cesMnemonic!=null && sl.cesMnemonic.size() > 0){
                                for(ACETProfessionalClaimHistoryJson2Apex.CesMnemonic_Z cesm : sl.cesMnemonic){
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
                    for(ACETProfessionalClaimHistoryJson2Apex.DiagnosisCode diag : prof.diagnosisCode){
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
                
               /* //Claim Edit
                claimDetail.ClaimEdits = new List<ACETClaimDetail.ClaimEdit>();
                if(inst.cesMnemonic != null && inst.cesMnemonic.size() > 0){
                    for(ACETgetInstitutionalJson2Apex.CesMnemonic cesm : inst.cesMnemonic){
                        ACETClaimDetail.ClaimEdit ce = new ACETClaimDetail.ClaimEdit();
                        if(cesm.cesMnemonicCode != null){
                            ce.EditType = cesm.cesMnemonicCode.code;
                            ce.EditDescription = cesm.cesMnemonicCode.description;  
                        }
                        ce.EditAction = cesm.cesRemarkText;
                        claimDetail.ClaimEdits.add(ce);
                    }
                }
                */
                
                //PatientIn formation 
                claimDetail.PatientInformation = new ACETClaimDetail.PatientInformation(); 
                claimDetail.PatientInformation.SurgeryDate = ACETWebserviceHelper.formatDateFromDashToSlash(prof.surgeryDate);
                //if(inst.serviceLine != null && inst.serviceLine.size() > 0){
                    //claimDetail.PatientInformation.SemiPrivateRoom = inst.serviceLine[0].semiPrivateRoomRate; ///mulitple service line?
                //}
                //is drgNumber a list?
                //if(inst.drgNumber != null){
                    //claimDetail.PatientInformation.DRGNumber = inst.drgNumber.code;
                //}
                claimDetail.PatientInformation.Discharge = prof.dischargeDate;
                
                //Surgical ProcedureCode
                claimDetail.SurgicalProcedureCodes = new List<ACETClaimDetail.SurgicalProcedureCode>();
                if(prof.surgicalProcedure != null && prof.surgicalProcedure.size() > 0){
                    for(ACETProfessionalClaimHistoryJson2Apex.AdjudicatedCOBLevel surg : prof.surgicalProcedure){
                        ACETClaimDetail.SurgicalProcedureCode sp = new ACETClaimDetail.SurgicalProcedureCode();
                        sp.ProcedureCode = surg.code;
                        sp.ProcedureDescription = surg.description;
                        claimDetail.SurgicalProcedureCodes.add(sp); 
                    }
                }
                
                //Occurrence Code
                claimDetail.OccurrenceCodes = new List<ACETClaimDetail.OccurrenceCode>();
                if(prof.occurrenceCode != null && prof.occurrenceCode.size() > 0){
                    for(ACETProfessionalClaimHistoryJson2Apex.OccurrenceCode occu : prof.occurrenceCode){
                        ACETClaimDetail.OccurrenceCode oc = new ACETClaimDetail.OccurrenceCode();
                        if(occu.code != null){
                            oc.OccurrenceCode = occu.code.code;
                            oc.OccurrenceDescription = occu.code.description;   
                        }
                        oc.OccurrenceDate = ACETWebserviceHelper.formatDateFromDashToSlash(occu.fromDate);  
                        claimDetail.OccurrenceCodes.add(oc);
                    }
                }
                
                //Occurrence Span Code
                claimDetail.OccurrenceSpanCodes = new List<ACETClaimDetail.OccurrenceSpanCode>();
                if(prof.occurenceSpanCode != null && prof.occurenceSpanCode.size() > 0){
                    for(ACETProfessionalClaimHistoryJson2Apex.occurenceSpanCode occu : prof.occurenceSpanCode){
                        ACETClaimDetail.OccurrenceSpanCode oc = new ACETClaimDetail.OccurrenceSpanCode();
                        if(occu.code != null){
                            oc.OccurrenceSpanCode = occu.code.code;
                            oc.OccurrenceSpanDescription = occu.code.description; 
                        }
                        oc.OccurrenceSpanStartDate = ACETWebserviceHelper.formatDateFromDashToSlash(occu.fromDate); 
                        oc.OccurrenceSpanEndDate = ACETWebserviceHelper.formatDateFromDashToSlash(occu.throughDate);
                        claimDetail.OccurrenceSpanCodes.add(oc);
                    }
                }
                     
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
                
               // system.debug('claimDetail:');
                system.debug(claimDetail);
                
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.INFO;
                oACETWSCalloutResult.Success = true;                
                oACETWSCalloutResult.Response = claimDetail;
                oACETWSCalloutResult.Message = '';  
            }
            else{
                oACETWSCalloutResult = ParseFailureResponse(Response); 
                oACETWSCalloutResult.statusCode = Response.getStatusCode();
                oACETWSCalloutResult.Message = 'Problem with ProfessionalClaimHistory Webservice: ' + oACETWSCalloutResult.Message;               
                if(Response.getStatusCode() == 500){
                    oACETWSCalloutResult.Message = 'Unexpected error occurred. Please try again. If problem persists, please contact the help desk.';
                }  
            }
            
        }
        catch(Exception ex){
            system.debug(LoggingLevel.INFO, 'Exception in ProfessionalClaimHistory Webservice,Message: ' + ex.getMessage()+'at line '+ex.getLineNumber()); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = 'Problem with ProfessionalClaimHistory Webservice: ' + ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        system.debug('oACETWSCalloutResult--->'+oACETWSCalloutResult);
        return oACETWSCalloutResult;
    }
    
}