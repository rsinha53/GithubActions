({
	helperMethod : function() {
		
	},
	queryClaimServices : function(component, event, helper,pagerefaranceobj){
		var claimType = component.get("v.claimType");
		var claimID = component.get("v.claimID");
        var claimEventId = pagerefaranceobj.c__EventID ;
		console.log('insideQueryClaimServices');
		var action;
		if(claimType == "02" || claimType == "2"){
			action = component.get("c.getInstClaimDetail");
			console.log('firing getInstClaimDetail event');
			
		}
		else if(claimType == "03" || claimType == "3"){
			action = component.get("c.getProfClaimDetail");
			console.log('firing getProfClaimDetail event');
		}
		action.setParams({
			claim_Type: claimType,
			claim_ID:claimID,
            claimEventId:claimEventId            
		});
		action.setCallback(this, function(response){
			console.log('inside claim detail callback' + claimID);
			console.log('TESTTESTTEST:' + claimType);
			var state = response.getState();
			if(state === "SUCCESS"){
				var resultString = response.getReturnValue();
				var result = JSON.parse(resultString);
				if(result.Success==true){
					if(result.Response!=null){
						var sectionVsCodes = new Object();
					
					
                       setTimeout(function(){ helper.startMatching(component,event,helper,result);
                                             },1);                        
						if(result.Response.TotalUHCs!=null && result.Response.TotalUHCs.length>0){
							component.set("v.claimTotalsUHC", result.Response.TotalUHCs[0]);
							console.log('claim totals uhc set');
						}
						if(result.Response.TotalCOB!=null && result.Response.TotalCOB.length>0){
							component.set("v.claimTotalsCOB", result.Response.TotalCOB[0]);
							console.log('claim totals cob set');
						}
						if(result.Response.MemberResponsibility!=null && result.Response.MemberResponsibility.length>0){
							component.set("v.memResp", result.Response.MemberResponsibility[0]);
							console.log('member resp set');
						}
						if(result.Response.ProviderResponsibility!=null && result.Response.ProviderResponsibility.length>0){
							component.set("v.provResp", result.Response.ProviderResponsibility[0]);
							console.log('prov resp set');
						}
						if(result.Response.ServiceLines!=null && result.Response.ServiceLines.length>0){
							component.set("v.serviceLines", result.Response.ServiceLines);
							component.set("v.serviceLinesActiveSections", ['ServiceLines']);
							var codes = [];
                            for (var i = 0; i < result.Response.ServiceLines.length; i++) {
                                if (result.Response.ServiceLines[i].Revenue != null) {
                                    codes.push(result.Response.ServiceLines[i].Revenue);
                                }
                                if (result.Response.ServiceLines[i].Procedure != null) {
                                    codes.push(result.Response.ServiceLines[i].Procedure);
                                }
                                if (result.Response.ServiceLines[i].Modifier != null) {
                                    codes.push(result.Response.ServiceLines[i].Modifier);
                                }
                            }
                            sectionVsCodes["serviceLines"] = codes;
                            console.log("encoderPro - serviceLines:" + JSON.stringify(codes));
						}
						if(result.Response.ClaimCode!=null && result.Response.ClaimCode.length>0){
							component.set("v.claimCodes", result.Response.ClaimCode);
							console.log('claim codes set');
							component.set("v.claimCodesActiveSections", ['ClaimCodes']);
						}
						if(result.Response.ClaimDiagnosis!=null && result.Response.ClaimDiagnosis.length>0){
							component.set("v.claimDiagnosis", result.Response.ClaimDiagnosis);
							console.log('claim diagnosis set');
							component.set("v.claimDiagActiveSections", ['ClaimDiag']);
							var codes = [];
                            for (var i = 0; i < result.Response.ClaimDiagnosis.length; i++) {
                                if (result.Response.ClaimDiagnosis[i].DiagnosisCode != null) {
                                    codes.push(result.Response.ClaimDiagnosis[i].DiagnosisCode);
                                }
                            }
                            sectionVsCodes["claimDiagnosis"] = codes;
                            console.log("encoderPro - claimDiagnosis:" + JSON.stringify(codes));
						}
						if(result.Response.ClaimEdits!=null && result.Response.ClaimEdits.length>0){
							component.set("v.clinicalEdits", result.Response.ClaimEdits);
							console.log('claim edits set');
							component.set("v.clinicalEditsActiveSections", ['ClinicalEdits']);
						}
						if(result.Response.ClaimEvents!=null && result.Response.ClaimEvents.length>0){
							component.set("v.claimEventHistory", result.Response.ClaimEvents);
							console.log('claim events set');
							component.set("v.claimEventHistoryActiveSections", ['ClaimEventHist']);
						}
						if(result.Response.SurgicalProcedureCodes!=null && result.Response.SurgicalProcedureCodes.length>0){
							component.set("v.surgicalProcedureCodes", result.Response.SurgicalProcedureCodes);
							console.log('surgical procedure codes set');
							component.set("v.surgicalProcedureCodesActiveSections", ['SurgicalProcedureCodes']);
						}
						if(result.Response.OccurrenceCodes!=null && result.Response.OccurrenceCodes.length>0){
							component.set("v.occurrenceCodes", result.Response.OccurrenceCodes);
							console.log('occurrence codes set');
							component.set("v.occurrenceCodesActiveSections", ['OccurrenceCodes']);
						}
						if(result.Response.OccurrenceSpanCodes!=null && result.Response.OccurrenceSpanCodes.length>0){
							component.set("v.occurrenceSpanCodes", result.Response.OccurrenceSpanCodes);
							console.log('occurrence span codes set');
							component.set("v.occurrenceCodesActiveSections", ['OccurrenceCodes']);
						}
						if(result.Response.claimNotesUser!=null && result.Response.claimNotesUser.length>0){
							component.set("v.claimNotesUser", result.Response.claimNotesUser);
							console.log('user notes set');
							component.set("v.claimNotesUserActiveSections", ['UserNotes']);
						}	
						if(result.Response.claimNotesSystem!=null && result.Response.claimNotesSystem.length>0){
							component.set("v.claimNotesSystem", result.Response.claimNotesSystem);
							console.log('system notes set');
							component.set("v.claimNotesSystemActiveSections", ['SystemNotes']);
                        }
						if(result.Response.PatientInformation!=null && result.Response.PatientInformation){
							component.set("v.inOutPatientInfo", result.Response.PatientInformation);
							console.log('patient info set');
						}						
						var generalInfoObj = {};
						generalInfoObj.GroupNumber = result.Response.GroupNumber;
			            generalInfoObj.ClaimSplitIndicator = result.Response.ClaimSplitIndicator;
			            generalInfoObj.ReceivedDate = result.Response.ReceivedDate;
			            generalInfoObj.BillType = result.Response.BillType;
			            generalInfoObj.SplitClaimNumber = result.Response.ReferenceClaimID;                
			            generalInfoObj.TimelyFilingLimit = result.Response.TimelyFilingLimit;
			            generalInfoObj.AdmitDate = result.Response.AdmitDate;
			            generalInfoObj.ClaimEventType = result.Response.ClaimEventType;
			            generalInfoObj.PatientAccountNumber = result.Response.PatientAccountNumber;
			            generalInfoObj.PatientName = result.Response.PatientName;
			            generalInfoObj.PatientDOB = result.Response.PatientDOB;
			            generalInfoObj.AdmitTime = result.Response.AdmitTime;
			            generalInfoObj.ClaimEventSequenceNumber = result.Response.ClaimEventSequenceNumber;
			            generalInfoObj.SubmissionType = result.Response.SubmissionType;
			            generalInfoObj.DCN = result.Response.DCN;                
			            generalInfoObj.relatedIcns = result.Response.relatedIcns; 
			            generalInfoObj.ClaimProcessed = result.Response.ClaimProcessed; 
						component.set("v.generalInfo", generalInfoObj);
						console.log('general info set');
						
						if (component.get("v.primaryDX") != null) {
                            var codes = [];
                            if (component.get("v.primaryDX") != null) {
                                codes[0] = component.get("v.primaryDX");
                                sectionVsCodes["claimItem"] = codes;
                            }
                            console.log("encoderPro - claimItem:" + JSON.stringify(codes));
                        }
                        
                        console.log("sectionVsCodes >>> " + JSON.stringify(sectionVsCodes));
                        var EPAction = component.get("c.getEncoderProDescription");
                        EPAction.setParams({
                            data: JSON.stringify(sectionVsCodes)
                        });
                        EPAction.setCallback(this, function(response) {
                            //map encoder pro codes
                            var state = response.getState();
//                            console.log('encoder pro status ' + state);
//                            alert(state);
                            if (state === "SUCCESS") {
                                var resultString = response.getReturnValue();
                                console.log('encoder pro results:' + resultString);
                                var results = JSON.parse(resultString);
                                var hoverTimeout;
                                $("td.encoder-pro-code").mouseenter(function(event) {
                                    var codeArray = Object.keys(results.Response);
                                    console.log(codeArray);
                                    for (var i = 0; i < codeArray.length; i++) {
                                        var currentCode = codeArray[i];
                                        if ($(this).text() == currentCode) {
                                            var toolTip = document.createElement("div");
                                            $(toolTip).addClass("eptooltip-modal");
                                            var descArray = results.Response[currentCode];
                                            var descHtml = "<ul style = 'padding:1%'>"
                                            for (var j = 0; j < descArray.length; j++) {
                                                if (JSON.stringify(descArray[j]).indexOf(":") > 0)
                                                    descHtml = descHtml + "<li>" + JSON.stringify(descArray[j]).slice(JSON.stringify(descArray[j]).indexOf(":") + 2, JSON.stringify(descArray[j]).lastIndexOf("\"")) + "</li>";
                                                else
                                                    descHtml = descHtml + "<li>" + JSON.stringify(descArray[j]).slice(1, JSON.stringify(descArray[j]).lastIndexOf("\"")) + "</li>";

                                            }
                                            descHtml = descHtml + "</ul>";
                                            $(toolTip).html(descHtml);
                                            $(this).append(toolTip);
                                            var posX = event.clientX + 10 + 'px';
                                            var posY = event.clientY + 20 + 'px';
                                            console.log(posX + " :: " + posY);
                                            $(toolTip).show();
                                            if (event.relatedTarget != null && event.relatedTarget.tagName == 'DIV') {
                                                $(toolTip).hide();
                                            }
                                            $(toolTip).css("top", posY);
                                            $(toolTip).css("left", posX);
                                        }
                                    }



                                });
                                $("td.encoder-pro-code").mouseleave(function() {
                                    $(this).find(".eptooltip-modal").remove();
                                });
                            }


                        });
                        
//                        setTimeout(function() {
//                        	console.log('launching encoder pro');
                            $A.enqueueAction(EPAction);
//                            console.log('encoder pro launched');
//                        }, 1);
						
					}
					
					
				}
				else{
					//helper.getErrorMsg('GN', result.statusCode, "v.detailServiceErrorMsg", component);
				}
			}
		
		
		});
		$A.enqueueAction(action);		
	},
    startMatching:function(component,event,helper,result){      
        var claimdetaildataresp = component.get("v.pageReferenceobj").c__claimsdetailresult;
      console.log(JSON.stringify(claimdetaildataresp));
        //Genral Info sec 
          helper.matchIndividualdata(component,event,helper,'GroupNumber_geninfo',claimdetaildataresp.GroupNumber); 
          helper.matchIndividualdata(component,event,helper,'PatientName_geninfo',claimdetaildataresp.PatientName); 
          helper.matchIndividualdata(component,event,helper,'ClaimSplitIndicator_geninfo',claimdetaildataresp.ClaimSplitIndicator); 
          helper.matchIndividualdata(component,event,helper,'ReceivedDate_geninfo',claimdetaildataresp.ReceivedDate); 
          helper.matchIndividualdata(component,event,helper,'PatientDOB_geninfo',claimdetaildataresp.PatientDOB); 
          helper.matchIndividualdata(component,event,helper,'SplitClaimNumber_geninfo',claimdetaildataresp.ReferenceClaimID); 
          helper.matchIndividualdata(component,event,helper,'ClaimProcessed_geninfo',claimdetaildataresp.ClaimProcessed); 
          helper.matchIndividualdata(component,event,helper,'PatientAccountNumber_geninfo',claimdetaildataresp.PatientAccountNumber); 
          helper.matchIndividualdata(component,event,helper,'ClaimEventType_geninfo',claimdetaildataresp.ClaimEventType); 
          helper.matchIndividualdata(component,event,helper,'TimelyFilingLimit_geninfo',claimdetaildataresp.TimelyFilingLimit); 
          helper.matchIndividualdata(component,event,helper,'BillType_geninfo',claimdetaildataresp.BillType); 
          helper.matchIndividualdata(component,event,helper,'ClaimEventSequenceNumber_geninfo',claimdetaildataresp.ClaimEventSequenceNumber); 
          helper.matchIndividualdata(component,event,helper,'SubmissionType_geninfo',claimdetaildataresp.SubmissionType); 
          helper.matchIndividualdata(component,event,helper,'AdmitDate_geninfo',claimdetaildataresp.AdmitDate); 
          helper.matchIndividualdata(component,event,helper,'relatedIcns_geninfo',claimdetaildataresp.relatedIcns); 
          helper.matchIndividualdata(component,event,helper,'DCN_geninfo',claimdetaildataresp.DCN); 
          helper.matchIndividualdata(component,event,helper,'AdmitTimeHR_geninfo',claimdetaildataresp.AdmitTime); 
          //total UHC sec 
        if(claimdetaildataresp.TotalUHCs.length>0){
          helper.matchIndividualdata(component,event,helper,'Status_totalsUHC',claimdetaildataresp.TotalUHCs[0].Status); 
          helper.matchIndividualdata(component,event,helper,'Charged_totalsUHC',claimdetaildataresp.TotalUHCs[0].Charged); 
          helper.matchIndividualdata(component,event,helper,'ReimbursementReduction_totalsUHC',claimdetaildataresp.TotalUHCs[0].ReimbursementReduction); 
          helper.matchIndividualdata(component,event,helper,'Allowed_totalsUHC',claimdetaildataresp.TotalUHCs[0].Allowed); 
          helper.matchIndividualdata(component,event,helper,'Penalty_totalsUHC',claimdetaildataresp.TotalUHCs[0].Penalty); 
          helper.matchIndividualdata(component,event,helper,'InterestPaid_totalsUHC',claimdetaildataresp.TotalUHCs[0].InterestPaid); 
          helper.matchIndividualdata(component,event,helper,'NYSurchargePaid_totalsUHC',claimdetaildataresp.TotalUHCs[0].NYSurchargePaid); 
          helper.matchIndividualdata(component,event,helper,'HealthPlanPaid_totalsUHC',claimdetaildataresp.TotalUHCs[0].HealthPlanPaid); 
        }
        //total COB sec 
                if(claimdetaildataresp.TotalCOB.length>0){
          helper.matchIndividualdata(component,event,helper,'Status_totalsCOB',claimdetaildataresp.TotalCOB[0].Status); 
          helper.matchIndividualdata(component,event,helper,'OtherInsuranceType_totalsCOB',claimdetaildataresp.TotalCOB[0].OtherInsuranceType); 
          helper.matchIndividualdata(component,event,helper,'Charged_totalsCOB',claimdetaildataresp.TotalCOB[0].Charged); 
          helper.matchIndividualdata(component,event,helper,'NotCovered_totalsCOB',claimdetaildataresp.TotalCOB[0].NotCovered); 
          helper.matchIndividualdata(component,event,helper,'COBMethod_totalsCOB',claimdetaildataresp.TotalCOB[0].COBMethod); 
          helper.matchIndividualdata(component,event,helper,'Paid_totalsCOB',claimdetaildataresp.TotalCOB[0].Paid); 
          helper.matchIndividualdata(component,event,helper,'MemberResponsibility_totalsCOB',claimdetaildataresp.TotalCOB[0].MemberResponsibility); 
                }
      //Member Resp 
                      if(claimdetaildataresp.MemberResponsibility.length>0){
          helper.matchIndividualdata(component,event,helper,'Copay_memResp',claimdetaildataresp.MemberResponsibility[0].Copay); 
          helper.matchIndividualdata(component,event,helper,'Deductible_memResp',claimdetaildataresp.MemberResponsibility[0].Deductible); 
          helper.matchIndividualdata(component,event,helper,'Coinsurance_memResp',claimdetaildataresp.MemberResponsibility[0].Coinsurance); 
          helper.matchIndividualdata(component,event,helper,'ReimbursementReduction_memResp',claimdetaildataresp.MemberResponsibility[0].ReimbursementReduction); 
          helper.matchIndividualdata(component,event,helper,'Penalty_memResp',claimdetaildataresp.MemberResponsibility[0].Penalty); 
          helper.matchIndividualdata(component,event,helper,'TotalMemberResponsibility_memResp',claimdetaildataresp.MemberResponsibility[0].TotalMemberResponsibility); 
                      }
                          //Prov Resp
                                                if(claimdetaildataresp.ProviderResponsibility.length>0){
               helper.matchIndividualdata(component,event,helper,'TotalProviderResponsibility_provResp',claimdetaildataresp.ProviderResponsibility[0].TotalProviderResponsibility); 
                helper.matchIndividualdata(component,event,helper,'Penalty_provResp',claimdetaildataresp.ProviderResponsibility[0].Penalty); 
                helper.matchIndividualdata(component,event,helper,'ReimbursementReduction_provResp',claimdetaildataresp.ProviderResponsibility[0].ReimbursementReduction); 
                                                }
          //In/Out Patient Information
                                if(claimdetaildataresp.PatientInformation != null){

                helper.matchIndividualdata(component,event,helper,'SurgeryDate_inOut',claimdetaildataresp.PatientInformation.SurgeryDate); 
                helper.matchIndividualdata(component,event,helper,'SemiPrivateRoom_inOut',claimdetaildataresp.PatientInformation.SemiPrivateRoom); 
                helper.matchIndividualdata(component,event,helper,'DRGNumber_inOut',claimdetaildataresp.PatientInformation.DRGNumber); 
                 helper.matchIndividualdata(component,event,helper,'Discharge_inOut',claimdetaildataresp.PatientInformation.Discharge); 

                                }
        debugger;
        
    },
    matchIndividualdata:function(component,event,helper,locationId,inputdata){
        var targetcmp = component.find(locationId);
        if(!$A.util.isEmpty(targetcmp)){
        var targetcmpval = targetcmp.get("v.value");
         
        if((targetcmpval != inputdata) && (targetcmpval != null && inputdata != "")){
              $A.util.addClass(targetcmp, 'highlight');
        }
        }
    }

})