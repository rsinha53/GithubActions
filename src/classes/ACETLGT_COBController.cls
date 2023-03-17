public class ACETLGT_COBController extends ACETErrorHandler{


    @AuraEnabled public List < ACETLGT_MemberDetail.COB > cobList;

    @AuraEnabled public List < ACETLGT_MemberDetail.FamilyMember > FamilyMembers;

    public class familyMembsResultWrapper {
        @AuraEnabled public ACETLGT_MemberDetail resultWrapper {
            get;
            set;
        }
        @AuraEnabled public String ErrorMessage {get;set;}
        @AuraEnabled public List < ACETLGT_MemberDetail.COB > resultCommercial {
            get;
            set;
        }
        @AuraEnabled public List < ACETLGT_MemberDetail.COB > resultGovernment {
            get;
            set;
        }
    }


        public List < ACETLGT_MemberDetail.COB > commercialcobList;

        public List < ACETLGT_MemberDetail.COB > governmentcobList;



    @AuraEnabled
    public static familyMembsResultWrapper getFamilyMembershipResults(String srk, string groupNumber, String effectiveDate, string memberId) {

        List <ACETLGT_MemberDetail.COB > commercialcobList = new List <ACETLGT_MemberDetail.COB >();
        List <ACETLGT_MemberDetail.COB > governmentcobList = new List <ACETLGT_MemberDetail.COB >();

        familyMembsResultWrapper detWrap = new familyMembsResultWrapper();
        ACETLGT_MemberDetail resultwrap = new ACETLGT_MemberDetail();
        ACETLGT_MemberDetail memberDetail = new ACETLGT_MemberDetail();
        ACETLGT_GetFamilyMemberWebService getFamMemService = new ACETLGT_GetFamilyMemberWebService();
        ACETWSCalloutResult CalloutResult = null;

        memberDetail.SurrogateKey = srk;
        memberDetail.PreferredCoverage = new ACETLGT_MemberDetail.CoverageLine();
        memberDetail.PreferredCoverage.groupNumber = groupNumber;
        memberDetail.PreferredCoverage.effectiveDate = effectiveDate;
        memberDetail.PreferredCoverage.SurrogateKey = srk;


        CalloutResult = getFamMemService.getFamilyMembers(memberId, memberdetail);
        system.debug('~~~After callout' + CalloutResult);

        if (CalloutResult != null && CalloutResult.Success == true) {
            resultwrap = (ACETLGT_MemberDetail) CalloutResult.Response;



            //call child 
            commercialcobList = childconsolefunction(resultwrap,'Comm');
            governmentcobList = childconsolefunction(resultwrap,'Gov');


        //system.debug('~~~resultwrap------' + resultwrap);
        system.debug('~~~resultwrap COB------' + commercialcobList);
        system.debug('~~~resultwrap GOV ------' + governmentcobList);

        detWrap.resultWrapper = resultwrap;
        
        detWrap.resultCommercial = commercialcobList;
        detWrap.resultGovernment = governmentcobList;

        return detWrap;

        }
        else{
            detWrap.resultWrapper = new ACETLGT_MemberDetail();
            detWrap.resultCommercial = commercialcobList;
            detWrap.resultGovernment = governmentcobList;
            if(CalloutResult!= null && CalloutResult.statusCode == 400)
                detWrap.ErrorMessage = setLightningErrorMsg('GN400B');
            else
                detWrap.ErrorMessage = setLightningErrorMsg('GN'+CalloutResult.statusCode );
            return detWrap;
        }
    }

    //Commercial
    public static List < ACETLGT_MemberDetail.COB > childconsolefunction(ACETLGT_MemberDetail MemberDetail, String insType) {

        List < ACETLGT_MemberDetail.COB > returnedList = new List < ACETLGT_MemberDetail.COB> ();
        List < ACETLGT_MemberDetail.COB > finalCobList = new List < ACETLGT_MemberDetail.COB> ();

        List < ACETLGT_MemberDetail.FamilyMember > FamilyMembers = new List < ACETLGT_MemberDetail.FamilyMember >();
        List < ACETLGT_MemberDetail.COB > cobList = new List < ACETLGT_MemberDetail.COB >();


        try {
            if (MemberDetail != null) {
                if (MemberDetail.FamilyMembers != null) {
                    FamilyMembers = MemberDetail.FamilyMembers;
                }

                if (MemberDetail.lstCOB != null) {
                    cobList = MemberDetail.lstCOB;
                }
                System.debug('Family Members !! - >'+FamilyMembers);

                finalCobList = new List < ACETLGT_MemberDetail.COB > ();

                Map < String, ACETLGT_MemberDetail.COB > mapCom = new Map < String, ACETLGT_MemberDetail.COB > ();
                Map < String, ACETLGT_MemberDetail.COB > mapGov = new Map < String, ACETLGT_MemberDetail.COB > ();

                if (cobList != null && cobList.size() > 0) {
                    for (ACETLGT_MemberDetail.COB cobItem: cobList) {
                        if (String.isNotBlank(insType) && insType == 'Comm' && String.isNotBlank(cobItem.CoverageTypeCode) && (cobItem.CoverageTypeCode == '1' || cobItem.CoverageTypeCode == '3' || cobItem.CoverageTypeCode == '4' || cobItem.CoverageTypeCode == '5')) {
                            finalCobList.add(cobItem);
                            if (String.isNotBlank(cobItem.MemberId) && !mapCom.containsKey(cobItem.MemberId)) {
                                mapCom.put(cobItem.memberId, cobitem);
                            }
                        }

                        if  (String.isNotBlank(insType) && insType == 'Gov' && String.isNotBlank(cobItem.CoverageTypeCode) && cobItem.CoverageTypeCode == '2') {
                            finalCobList.add(cobItem);

                            if (String.isNotBlank(cobItem.MemberId) && !mapGov.containsKey(cobItem.MemberId)) {
                                mapGov.put(cobItem.memberId, cobitem);
                            }
                        }
                    }

                    System.debug('mapCobList ::: -> '+mapCom);
                    System.debug('mapCobList ::: -> '+mapGov);

                    System.debug('finalCobList ::: -> '+finalCobList);


                    if (FamilyMembers != null && mapCom != null || mapGov != null) {
                        //returnedList = addFamilyMemberstoCoblist(mapCob, insType); 
                        System.debug('inText ::: -> ');
                        System.debug('inTextFamMember ::: -> '+FamilyMembers);
                        try {
                            if (String.isNotBlank(insType) && insType == 'Comm') {
                                if (FamilyMembers != null && FamilyMembers.size() > 0) {
                                    for (ACETLGT_MemberDetail.FamilyMember famMembers: FamilyMembers) {
                                        System.debug('inTextFamMember Comm::: -> '+mapCom);
                                        if (String.isNotBlank(famMembers.FamilyId) && mapCom.containsKey(famMembers.FamilyId)) {
                                            System.debug('inComm ::: -> ');
                                            ACETLGT_MemberDetail.COB cob = new ACETLGT_MemberDetail.COB();
                                            cob.MemberId = famMembers.FamilyId;
                                            cob.Name = String.isNotBlank(famMembers.FirstName) ? famMembers.FirstName : '';
                                            cob.Name = String.isNotBlank(famMembers.LastName) ? cob.Name + ' ' + famMembers.LastName : cob.Name;
                                            cob.Age = famMembers.Age;
                                            cob.Relationship = famMembers.Relationship;
                                            cob.DateOfBirth = famMembers.DOB;
                                            returnedList.add(cob);
                                        }
                                    }
                                }
                            }
                            if (String.isNotBlank(insType) && insType == 'Gov') {
                                if (FamilyMembers != null && FamilyMembers.size() > 0) {
                                    for (ACETLGT_MemberDetail.FamilyMember famMembers: FamilyMembers) {
                                        System.debug('inGovFamMember ::: -> '+mapGov);
                                        if (String.isNotBlank(famMembers.FamilyId) && mapGov.containsKey(famMembers.FamilyId)) {
                                            System.debug('inGov ::: -> ');
                                            ACETLGT_MemberDetail.COB cob = new ACETLGT_MemberDetail.COB();
                                            cob.MemberId = famMembers.FamilyId;
                                            cob.Name = String.isNotBlank(famMembers.FirstName) ? famMembers.FirstName : '';
                                            cob.Name = String.isNotBlank(famMembers.LastName) ? cob.Name + ' ' + famMembers.LastName : cob.Name;
                                            cob.Age = famMembers.Age;
                                            cob.Relationship = famMembers.Relationship;
                                            cob.DateOfBirth = famMembers.DOB;
                                            returnedList.add(cob);
                                        }
                                    }
                                }
                            }
                        } catch (Exception e) {
                            system.debug(LoggingLevel.INFO, 'Some error has occurred : ' + e.getStackTraceString());
                        }
                    }


                }

                system.debug('The returned List :: ' + returnedList);
            }
        } catch (Exception e) {
           
        }

        System.debug('Family Members !! - >'+returnedList);
        return returnedList;
    }


}