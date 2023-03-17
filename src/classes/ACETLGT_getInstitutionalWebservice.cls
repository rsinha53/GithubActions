public class ACETLGT_getInstitutionalWebservice extends ACETWebservice{

    public List<String> SearchParameters ;
    
    public override void GetEndpoint()
    {
        GetEndpointDetail('getInstitutionalClaimsEndpoint');
    }
    public ACETLGT_getInstitutionalWebservice() {
       
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
        RequestBody = GetRequestBody('GetInstitutionalClaimsRequest',SearchParameters);
        system.debug('RequestBody is '+RequestBody);
    }
    
    public ACETWSCalloutResult GetInstitutionalClaimsWS(String claimType, String claimId){
        SearchParameters = new String[] {claimType,claimId};
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
                ACETgetInstitutionalJson2Apex json2apex = (ACETgetInstitutionalJson2Apex)JSON.deserialize(Response.getBody(), ACETgetInstitutionalJson2Apex.class);
                //Summary  
                ACETgetInstitutionalJson2Apex.InstitutionalClaim inst = json2apex.getInstitutionalClaimResponse.institutionalClaim;
                system.debug('inst is '+inst);
                claimDetail.GroupNumber = inst.subscriber.memberGroupNumber;
                claimDetail.ReceivedDate = ACETWebserviceHelper.formatDateFromDashToSlash(inst.claimReceiptDate);
                claimDetail.TimelyFilingLimit = inst.timelyFilingLimitDays;
                claimDetail.patientAccountNumber = inst.patientAccountNumber;
                claimDetail.patientName = inst.patient.name.firstName+' '+inst.patient.name.lastName;
                claimDetail.patientDOB = ACETWebserviceHelper.formatDateFromDashToSlash(inst.patient.birthdate);
                if(inst.relatedIcns!=null){
                    claimDetail.relatedIcns = '';
                    for(String icn : inst.relatedIcns){
                        if(claimDetail.relatedIcns.length()>0){
                            claimDetail.relatedIcns += ', ';
                        }
                        claimDetail.relatedIcns += icn;
                    }
                }
                if(inst.billTypeCode != null){
                claimDetail.BillType = inst.billTypeCode.code;}
                claimDetail.AdmitDate = ACETWebserviceHelper.formatDateFromDashToSlash(inst.admitDate);
                claimDetail.AdmitTime = inst.admitTimeHour;
                claimDetail.ClaimSplitIndicator = inst.claimSplitIndicator;
                if(inst.referenceClaimID!=null && inst.referenceClaimID.size()>0){
                    claimDetail.ReferenceClaimID = inst.referenceClaimID[0]; 
                }
                if(inst.ClaimSubmissionType!=null){
                    claimDetail.SubmissionType = inst.ClaimSubmissionType.description;
                    system.debug('submissiontype description--->' + inst.ClaimSubmissionType.description + ',--->' + claimDetail.SubmissionType);
                } 
                else{
                    claimDetail.SubmissionType = '';
                }               
                if(inst.claimEvent != null && inst.claimEvent.size() > 0 && inst.claimEvent[0].claimEventType != null){
                    integer i = 0;
                    system.debug('inst.claimEvent is '+inst.claimEvent);
                    claimDetail.ClaimEvents = new List<ACETClaimDetail.ClaimEvent>();
                    for(AcetGetInstitutionalJSON2Apex.ClaimEvent ins: inst.claimEvent)
                    {
                        ACETClaimDetail.ClaimEvent ce = new ACETClaimDetail.ClaimEvent();
                        ce.claimEventAdjudicationDateTime = ACETWebserviceHelper.formatDateFromDashToSlash(ins.claimEventAdjudicationDateTime);
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
                if(inst.claimUHCTotals != null){
                    if(inst.adjudicatedCOBLevel != null){
                        totalUHC.Status = inst.adjudicatedCOBLevel.description;
                    }
                    totalUHC.Charged = inst.claimUHCTotals.claimTotalBilledChargeAmount;
                    totalUHC.ReimbursementReduction = inst.claimUHCTotals.claimTotalReimbursementReductionAmount;
                    totalUHC.Allowed = inst.claimUHCTotals.claimTotalAllowedAmount;
                    totalUHC.Penalty = inst.claimUHCTotals.claimTotalPenaltyAmount;
                    totalUHC.InterestPaid = inst.claimUHCTotals.claimTotalInterestAmount;
                    totalUHC.NYSurchargePaid = inst.claimUHCTotals.claimTotalStateSurchargeAmount;
                    totalUHC.HealthPlanPaid = inst.claimUHCTotals.claimTotalPaidAmount;
                    claimDetail.TotalUHCs.add(totalUHC);
                }
                
                //Member Responsibility 
                claimDetail.MemberResponsibility = new List<ACETClaimDetail.MemberResponsibility>();
                ACETClaimDetail.MemberResponsibility memberResponsibility = new ACETClaimDetail.MemberResponsibility(); 
                system.debug('inst.claimUHCTotals@@@ ' + inst.claimUHCTotals);
                if(inst.claimUHCTotals != null){
                    memberResponsibility.Deductible = inst.claimUHCTotals.claimTotalDeductibleAmount;
                    memberResponsibility.Copay = inst.claimUHCTotals.totalCopayAmount;
                    memberResponsibility.Coinsurance = inst.claimUHCTotals.claimTotalCoinsuranceAmount;
                  //memberResponsibility.ReimbursementReduction = inst.claimUHCTotals.claimTotalReimbursementReductionAmount;
                    memberResponsibility.ReimbursementReduction = inst.claimUHCTotals.claimTotalMemberReimbursementReductionAmount;
                    memberResponsibility.Penalty = inst.claimUHCTotals.claimTotalMemberPenaltyAmount;
                    memberResponsibility.TotalMemberResponsibility = inst.claimUHCTotals.totalPatientResponsibilityAmount;
                  //memberResponsibility.TotalProviderResponsibility = inst.claimUHCTotals.claimTotalUHCProvWriteOffAmount;
                    claimDetail.MemberResponsibility.add(memberResponsibility);
                }
                   
                                
                //Provider Responsibility
                claimDetail.ProviderResponsibility = new List<ACETClaimDetail.ProviderResponsibility>();
                ACETClaimDetail.ProviderResponsibility ProviderResponsibility = new ACETClaimDetail.ProviderResponsibility();                
                if(inst.claimUHCTotals != null){
                  //ProviderResponsibility.ReimbursementReduction = inst.claimUHCTotals.claimTotalReimbursementReductionAmount; 
                    ProviderResponsibility.ReimbursementReduction = inst.claimUHCTotals.claimTotalProviderReimbursementReductionAmount;
                    ProviderResponsibility.Penalty = inst.claimUHCTotals.claimTotaProviderPenaltyAmount;
                    ProviderResponsibility.TotalWriteOff = inst.claimUHCTotals.claimTotalUHCProvWriteOffAmount;
                    ProviderResponsibility.TotalProviderResponsibility = inst.claimUHCTotals.claimTotalUHCProvWriteOffAmount;
                    claimDetail.ProviderResponsibility.add(ProviderResponsibility);
                }
                
                //Total COB 
                claimDetail.TotalCOB = new List<ACETClaimDetail.TotalCOB>();
                if(inst.otherPayer != null){
                    for(ACETgetInstitutionalJson2Apex.OtherPayer op : inst.otherPayer){
                        ACETClaimDetail.TotalCOB tc = new ACETClaimDetail.TotalCOB();
                        if(op.payerResponsibilitySequenceCode != null) tc.Status = op.payerResponsibilitySequenceCode.description;  
                        if(op.insuranceTypeCode != null) tc.OtherInsuranceType = op.insuranceTypeCode.description;
                        if(inst.claimUHCTotals != null) tc.Charged = inst.claimUHCTotals.claimTotalBilledChargeAmount;                      
                        //tc.Allowed = ???
                        tc.NotCovered = op.claimTotalOtherPayerNotCoveredAmount;
                        tc.Paid = op.claimTotalOtherPayerPaidAmount;
                        tc.MemberResponsibility = op.claimTotalOtherPayerPatientResponsibilityAmount;
                        if(inst.serviceLine != null && inst.serviceLine.size() > 0){
                            if(inst.serviceLine[0].cobMethod != null) tc.COBMethod = inst.serviceLine[0].cobMethod.description;
                        }                                                
                        claimDetail.TotalCOB.add(tc);
                    }   
                }
                
                //Claim Code   
                claimDetail.ClaimCode = new List<ACETClaimDetail.ClaimCode>();
                   if(inst.serviceLine != null && inst.serviceLine.size() > 0) {
               
                     for(ACETgetInstitutionalJson2Apex.ServiceLine sl : inst.serviceLine) {
                           if (sl.serviceRemarks !=null){
                        for(ACETgetInstitutionalJson2Apex.serviceRemarks serviceRemarks: sl.serviceRemarks) { 
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
                            if(serviceRemarks.remarkCode.code != System.Label.ACETClaimRemarkCode){
                            claimDetail.ClaimCode.add(cc);
                            }
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
                if(inst.serviceLine != null){
                    for(ACETgetInstitutionalJson2Apex.ServiceLine sl : inst.serviceLine){
                        ACETClaimDetail.ServiceLine serviceLine = new ACETClaimDetail.ServiceLine();
                        if(sl.claimServiceLineID != null) {
                            serviceLine.ServiceLineCode = sl.claimServiceLineID;
                        }
                        if(sl.serviceLineStatusCode
                           != null)
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
                           system.debug('qualityTierValue--->'+sl.qualityTierValue);
                       if(sl.qualityTierValue != null){  
                       if(sl.qualityTierValue =='1' || sl.qualityTierValue =='01'){
                             serviceLine.qualityTierValue = sl.qualityTierValue;   
                         }else{
                          serviceLine.qualityTierValue = 'N/A';    
                         }
                          }else{
                          serviceLine.qualityTierValue = 'N/A';
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
                            if(inst.cesMnemonic==null){
                                inst.cesMnemonic = new List<ACETgetInstitutionalJson2Apex.CesMnemonic>();
                            }
                            system.debug('prof.cesMnemonic>>>>'+inst.cesMnemonic);
                            
                            if(inst.cesMnemonic!=null && sl.cesMnemonic!=null && sl.cesMnemonic.size() > 0){
                                for(ACETgetInstitutionalJson2Apex.CesMnemonic cesm : sl.cesMnemonic){
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
                if(inst.diagnosisCode != null && inst.diagnosisCode.size() > 0){
                    for(ACETgetInstitutionalJson2Apex.DiagnosisCode diag : inst.diagnosisCode){
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
                claimDetail.PatientInformation.SurgeryDate = ACETWebserviceHelper.formatDateFromDashToSlash(inst.surgeryDate);
                //if(inst.serviceLine != null && inst.serviceLine.size() > 0){
                    //claimDetail.PatientInformation.SemiPrivateRoom = inst.serviceLine[0].semiPrivateRoomRate; ///mulitple service line?
                //}
                //is drgNumber a list?
                //if(inst.drgNumber != null){
                    //claimDetail.PatientInformation.DRGNumber = inst.drgNumber.code;
                //}
                claimDetail.PatientInformation.Discharge = inst.dischargeDate;
                
                //Surgical ProcedureCode
                claimDetail.SurgicalProcedureCodes = new List<ACETClaimDetail.SurgicalProcedureCode>();
                if(inst.surgicalProcedure != null && inst.surgicalProcedure.size() > 0){
                    for(ACETgetInstitutionalJson2Apex.AdjudicatedCOBLevel surg : inst.surgicalProcedure){
                        ACETClaimDetail.SurgicalProcedureCode sp = new ACETClaimDetail.SurgicalProcedureCode();
                        sp.ProcedureCode = surg.code;
                        sp.ProcedureDescription = surg.description;
                        claimDetail.SurgicalProcedureCodes.add(sp); 
                    }
                }
                
                //Occurrence Code
                claimDetail.OccurrenceCodes = new List<ACETClaimDetail.OccurrenceCode>();
                if(inst.occurrenceCode != null && inst.occurrenceCode.size() > 0){
                    for(ACETgetInstitutionalJson2Apex.OccurrenceCode occu : inst.occurrenceCode){
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
                if(inst.occurenceSpanCode != null && inst.occurenceSpanCode.size() > 0){
                    for(ACETgetInstitutionalJson2Apex.occurenceSpanCode occu : inst.occurenceSpanCode){
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
                if(inst.claimCauseCode != null){
                    if(inst.claimCauseCode != null){
                        causeCode.CauseCode = inst.claimCauseCode.code;
                        causeCode.CauseDescription = inst.claimCauseCode.description;    
                    }        
                    claimDetail.CauseCode.add(causeCode);
                }
                
                claimDetail.claimNotesUser = new List<ACETClaimDetail.claimNote>();
                claimDetail.claimNotesSystem = new List<ACETClaimDetail.claimNote>();
                if(inst.claimNotes != null){
                    for(ACETgetInstitutionalJson2Apex.claimNotes CN : inst.claimNotes){
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
                
               // system.debug('claimDetail:');
                system.debug(claimDetail);
                
                oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.INFO;
                oACETWSCalloutResult.Success = true;                
                oACETWSCalloutResult.Response = claimDetail;
                oACETWSCalloutResult.Message = '';  
            }
            else{
                oACETWSCalloutResult = ParseFailureResponse(Response); 
                oACETWSCalloutResult.Message = 'Problem with GetInstitutionalClaims Webservice: ' + oACETWSCalloutResult.Message;          
                oACETWSCalloutResult.statusCode = Response.getStatusCode();
            }
            
        }
        catch(Exception ex){
            system.debug(LoggingLevel.INFO, 'Exception in GetInstitutionalClaims Webservice,Message: ' + ex.getMessage()+'at line '+ex.getLineNumber()); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = 'Problem with GetInstitutionalClaims Webservice: ' + ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        system.debug('oACETWSCalloutResult--->'+oACETWSCalloutResult);
        return oACETWSCalloutResult;
    }
    
}