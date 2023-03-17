public class ACET_BenefitTherapyWebService {

    public ACETWSCalloutResult getBenefit(String patientKey, String policyId) {
        ACETWSCalloutResult calloutResult = new ACETWSCalloutResult();

        try {
            //Request Params
            Map < String, String > requestParamsMap = new Map < String, String > ();
            requestParamsMap.put('patientKey', String.isNotBlank(patientKey) ? patientKey : '');
            requestParamsMap.put('policyId', String.isNotBlank(policyId) ? policyId : '');

            // calling webservice using webservice framework
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
            wsCallOutFW.serviceName = 'LinkBenefitTherapyService';
            wsCallOutFW.requestParamsMap = requestParamsMap;
            wsCallOutFW.encodeURLParameters = true;

            //get Response
            HttpResponse response = wsCallOutFW.getResponse();

            //Status Code
            Integer statusCode = response.getStatusCode();

            if (statusCode == 200) {
                ACET_CopayCoInsuranceResponceJSON2Apex therapyWrapper = ACET_CopayCoInsuranceResponceJSON2Apex.parse(response.getBody());
                Map < String, ACET_CopayCoInsuranceResult.copayCoInsurance > therapyMap = new Map < String, ACET_CopayCoInsuranceResult.copayCoInsurance > ();
                if (therapyWrapper != null && therapyWrapper.CopayCoInsuranceDetails != null && therapyWrapper.CopayCoInsuranceDetails.individual != null) {
                    ACET_CopayCoInsuranceResponceJSON2Apex.Individual individualWrap = therapyWrapper.CopayCoInsuranceDetails.individual;
                    if (individualWrap != null) {
                        //INN Data
                        if (individualWrap.inNetwork != null && individualWrap.inNetwork.found) {
                            List < ACET_CopayCoInsuranceResponceJSON2Apex.Services > services = new List < ACET_CopayCoInsuranceResponceJSON2Apex.Services > ();
                            services = individualWrap.inNetwork.services;
                            for (ACET_CopayCoInsuranceResponceJSON2Apex.Services ser: services) {
                                therapyMap = getBenefitMap(ser, therapyMap, 'INN');
                            }
                        }

                        //OON Data
                        if (individualWrap.outOfNetwork != null && individualWrap.outOfNetwork.found) {
                            List < ACET_CopayCoInsuranceResponceJSON2Apex.Services > services = new List < ACET_CopayCoInsuranceResponceJSON2Apex.Services > ();
                            services = individualWrap.outOfNetwork.services;
                            for (ACET_CopayCoInsuranceResponceJSON2Apex.Services ser: services) {
                                therapyMap = getBenefitMap(ser, therapyMap, 'OON');
                            }
                        }

                        //Tier1 Data
                        if (individualWrap.inNetworkTier1 != null && individualWrap.inNetworkTier1.found) {
                            List < ACET_CopayCoInsuranceResponceJSON2Apex.Services > services = new List < ACET_CopayCoInsuranceResponceJSON2Apex.Services > ();
                            services = individualWrap.inNetworkTier1.services;
                            for (ACET_CopayCoInsuranceResponceJSON2Apex.Services ser: services) {
                                therapyMap = getBenefitMap(ser, therapyMap, 'Tier 1');
                            }
                        }

                        //Tier2 Data
                        if (individualWrap.inNetworkTier2 != null && individualWrap.inNetworkTier2.found) {
                            List < ACET_CopayCoInsuranceResponceJSON2Apex.Services > services = new List < ACET_CopayCoInsuranceResponceJSON2Apex.Services > ();
                            services = individualWrap.inNetworkTier2.services;
                            for (ACET_CopayCoInsuranceResponceJSON2Apex.Services ser: services) {
                                therapyMap = getBenefitMap(ser, therapyMap, 'Tier 2');
                            }
                        }

                        //Tier1 Preferred Data
                        if (individualWrap.inNetworkTier1PreferredLab != null && individualWrap.inNetworkTier1PreferredLab.found) {
                            List < ACET_CopayCoInsuranceResponceJSON2Apex.Services > services = new List < ACET_CopayCoInsuranceResponceJSON2Apex.Services > ();
                            services = individualWrap.inNetworkTier1PreferredLab.services;
                            for (ACET_CopayCoInsuranceResponceJSON2Apex.Services ser: services) {
                                therapyMap = getBenefitMap(ser, therapyMap, 'Tier 1 Preferred');
                            }
                        }
                    }

                    //Forming Benefits List
                    List < ACET_CopayCoInsuranceResult.CopayCoInsurance > benefitObjList = new List < ACET_CopayCoInsuranceResult.CopayCoInsurance > ();
                    if (!therapyMap.isEmpty()) {
                        for (ACET_CopayCoInsuranceResult.CopayCoInsurance benefit: therapyMap.values()) {
                            benefitObjList.add(benefit);
                        }
                        calloutResult.Success = true;
                        calloutResult.Message = 'Success';
                        calloutResult.statusCode = statusCode;
                        calloutResult.Response = benefitObjList;
                    } else {
                        calloutResult.Message = 'Webservice or External system is currently not available';
                        calloutResult.statusCode = statusCode;
                        calloutResult.Response = '';
                    }
                } else {
                    calloutResult.Message = 'Webservice or External system is currently not available';
                    calloutResult.statusCode = statusCode;
                    calloutResult.Response = '';
                }
            } else {
                calloutResult.Message = 'Webservice or External system is currently not available';
                calloutResult.statusCode = statusCode;
                calloutResult.Response = '';
                calloutResult.Success = false;
            }
        } catch (Exception e) {
            system.debug('##Exception:: ' + e.getStackTraceString());
            calloutResult.MessageSeverity = ApexPages.Severity.ERROR;
            calloutResult.Success = false;
            calloutResult.Message = 'Webservice or External system is currently not available';
            calloutResult.statusCode = 999;
        }
        return calloutResult;
    }

    //getNotes
    private static List < String > getNotesList(List < String > messagesList) {
        List < String > notesList = new List < String > ();
        for (String msg: messagesList) {
            notesList.add(msg);
        }
        return notesList;
    }

    //get Benefit Info
    private static Map < String, ACET_CopayCoInsuranceResult.CopayCoInsurance > getBenefitMap(ACET_CopayCoInsuranceResponceJSON2Apex.Services serviceRec, Map < String, ACET_CopayCoInsuranceResult.CopayCoInsurance > therapyMap, String coverageLevel) {

        //BenefitAllowed List
        List < ACET_CopayCoInsuranceResponceJSON2Apex.BenefitsAllowedFrequency > benefitsAllowedList = new List < ACET_CopayCoInsuranceResponceJSON2Apex.BenefitsAllowedFrequency > ();
        benefitsAllowedList = serviceRec.benefitsAllowedFrequency;
        // US3786086 - Thanish - 17th Aug 2021
        //populating Limit fields
        String rehabLimit = '--';
        String habLimit = '--';
        String cochlearRehabLimit = '--';
        String cochlearHabLimit = '--';
        Boolean combinedAcc = false;
        for (ACET_CopayCoInsuranceResponceJSON2Apex.BenefitsAllowedFrequency lstAllowed: benefitsAllowedList) {
            for (String msg: lstAllowed.messages) {
                //Post Cochlear Limit
                if (serviceRec.service == 'speechTherapy' && lstAllowed.messages.contains('POST COCHLEAR')) {
                    if (lstAllowed.messages.contains('REHABILITATIVE')) {
                        cochlearRehabLimit = String.valueOf(lstAllowed.visits);
                    }
                    else if (lstAllowed.messages.contains('HABILITATIVE')) {
                        cochlearHabLimit = String.valueOf(lstAllowed.visits);
                    }
                    break;
                }
                //Rehab Limit
                else if (msg.containsIgnoreCase('REHABILITATIVE')) {
                    rehabLimit = String.valueOf(lstAllowed.visits);
                }
                //Hab Limit
                else if (msg.containsIgnoreCase('HABILITATIVE')) {
                    habLimit = String.valueOf(lstAllowed.visits);
                }
            }
            //Combined Accumulation
            if(lstAllowed.combined) {
                combinedAcc = true;
            }
        }

        //Benefit Remaining list
        List < ACET_CopayCoInsuranceResponceJSON2Apex.BenefitsAllowedFrequency > benefitsRemainingList = new List < ACET_CopayCoInsuranceResponceJSON2Apex.BenefitsAllowedFrequency > ();
        benefitsRemainingList = serviceRec.benefitsRemainingFrequency;
        //populating remaining fields
        String rehabRemaining = '--';
        String habRemaining = '--';
        String cochlearRehabRem = '--';
        String cochlearHabRem = '--';
        String mskRemaining = '--';
        for (ACET_CopayCoInsuranceResponceJSON2Apex.BenefitsAllowedFrequency lstRemaining: benefitsRemainingList) {
            for (String msg: lstRemaining.messages) {
                //Post Cochlear Remaining
                if (serviceRec.service == 'speechTherapy' && lstRemaining.messages.contains('POST COCHLEAR')) {
                    if (lstRemaining.messages.contains('REHABILITATIVE')) {
                        cochlearRehabRem = String.valueOf(lstRemaining.visits);
                    }
                    else if (lstRemaining.messages.contains('HABILITATIVE')) {
                        cochlearHabRem = String.valueOf(lstRemaining.visits);
                    }
                    break;
                }
                //Rehab Remaining
                else if (msg.containsIgnoreCase('REHABILITATIVE')) {
                    rehabRemaining = String.valueOf(lstRemaining.visits);
                }
                //Hab Remaining
                else if (msg.containsIgnoreCase('HABILITATIVE')) {
                    habRemaining = String.valueOf(lstRemaining.visits);
                }
                else if (serviceRec.service != 'speechTherapy' && msg.containsIgnoreCase('MUSCULOSKELETAL')) {
                    //MSK Remaining
                    mskRemaining = String.valueOf(lstRemaining.visits);
                }
            }
        }

        //populating Notes
        List < String > notesList = new List < String > ();
        notesList.addall(getNotesList(serviceRec.messages.benefitsAllowed.message));
        notesList.addall(getNotesList(serviceRec.messages.benefitsRemaining.message));

        // Benefit Name
        String benefitName = serviceRec.text != null ? serviceRec.text : serviceRec.service;
        //Benefit Code
        String benefitCode = serviceRec.serviceCode;

        //Forming Network Data
        ACET_CopayCoInsuranceResult.InNetwork network = new ACET_CopayCoInsuranceResult.InNetwork();
        network.coverageLevel = coverageLevel;
        network.habLimit = habLimit;
        network.habRemaining = habRemaining;
        network.mskRemaining = mskRemaining;
        network.rehablimit = rehablimit;
        network.rehabRemaining = rehabRemaining;
        network.cochlearHabLimit = cochlearHabLimit;
        network.cochlearHabRem = cochlearHabRem;
        network.cochlearRehabLimit = cochlearRehabLimit;
        network.cochlearRehabRem = cochlearRehabRem;

        //Forming Individual Data
        ACET_CopayCoInsuranceResult.Individual individualObj = new ACET_CopayCoInsuranceResult.Individual();
        if (coverageLevel.equalsIgnoreCase('INN')) {
            individualObj.inNetwork = network;
        } else if (coverageLevel.equalsIgnoreCase('OON')) {
            individualObj.outNetwork = network;
        } else if (coverageLevel.equalsIgnoreCase('Tier 1')) {
            individualObj.tier1 = network;
        } else if (coverageLevel.equalsIgnoreCase('Tier 2')) {
            individualObj.tier2 = network;
        } else if (coverageLevel.equalsIgnoreCase('Tier 1 Preferred')) {
            individualObj.tier1Preferred = network;
        }

        //MSK Availability
        individualObj.isMskAvailable = String.isNotBlank(network.mskRemaining) ? true : false;

        //Forming Benefit Object
        ACET_CopayCoInsuranceResult.CopayCoInsurance benefitObj = new ACET_CopayCoInsuranceResult.CopayCoInsurance();
        benefitObj.combinedAcc = combinedAcc;
        benefitObj.notesList = notesList;
        benefitObj.serviceCode = benefitCode;
        benefitObj.serviceName = benefitName;
        benefitObj.individual = individualObj;

        //Checking Map
        if (!therapyMap.containskey(benefitCode)) {
            therapyMap.put(benefitCode, benefitObj);
        } else {
            benefitObj = therapyMap.get(benefitCode);
            benefitObj.notesList.addall(notesList);
            if (coverageLevel.equalsIgnoreCase('INN')) {
                benefitObj.individual.inNetwork = network;
            } else if (coverageLevel.equalsIgnoreCase('OON')) {
                benefitObj.individual.outNetwork = network;
            } else if (coverageLevel.equalsIgnoreCase('Tier 1')) {
                benefitObj.individual.tier1 = network;
            } else if (coverageLevel.equalsIgnoreCase('Tier 2')) {
                benefitObj.individual.tier2 = network;
            } else if (coverageLevel.equalsIgnoreCase('Tier 1 Preferred')) {
                benefitObj.individual.tier1Preferred = network;
            }
        }
        return therapyMap;
    }
}