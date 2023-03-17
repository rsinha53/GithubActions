public class ACET_RoutingScreenController {
    @AuraEnabled
    public static ORSRoutingWrapper getRoutingInfo() {
        ORSRoutingWrapper wrapper = new ORSRoutingWrapper();
        List < string > lstTeamQkLst = new List < string > ();
        Map < String, ORS_Routing_Information__mdt > orsMap = new Map < String, ORS_Routing_Information__mdt > ();
        List < ORS_Routing_Information__mdt > mdtList = new List < ORS_Routing_Information__mdt > ();
        List < ORS_Routing_Information__mdt > orsInfoList = [SELECT Label,Subtype__c,Type__c,Department_API__c, Advocate_Role__c, Department__c, Office_API__c, Office__c, Team_API__c,
            Team_Quick_List__c, Team__c, Topic__c, Line_of_Business__c FROM ORS_Routing_Information__mdt
        ];
        for (ORS_Routing_Information__mdt orsInfo: orsInfoList) {
            if (!lstTeamQkLst.contains(orsInfo.Label)) {
                mdtList.add(orsInfo);
                lstTeamQkLst.add(orsInfo.Label);
            }
            orsMap.put(orsInfo.Label, orsInfo);
        }
        wrapper.mdtList = mdtList;
        wrapper.orsMap = orsMap;
        return wrapper;
    }

    @AuraEnabled
    public static ORSRoutingWrapper getSAEReasonCodes() {
        ORSRoutingWrapper wrapper = new ORSRoutingWrapper();
        List < string > issue = new List < string > ();
        Map < String, SAE_Reason_Codes__mdt > reasonCodeMap = new Map < String, SAE_Reason_Codes__mdt > ();
        List < SAE_Reason_Codes__mdt > reasonCodeList = new List < SAE_Reason_Codes__mdt > ();
        List < SAE_Reason_Codes__mdt > reasonsInfoList = [SELECT Id, DeveloperName, MasterLabel, Topic__c, Type__c, Subtype__c, Category__c,
            Reason__c, Issue__c, Category_API__c, Reason_API__c, Label FROM SAE_Reason_Codes__mdt
        ];
        for (SAE_Reason_Codes__mdt Info: reasonsInfoList) {
            if (!issue.contains(Info.Issue__c)) {
                reasonCodeList.add(Info);
                issue.add(Info.Issue__c);
            }
            reasonCodeMap.put(Info.Issue__c, Info);
        }
        wrapper.reasonCodeList = reasonCodeList;
        wrapper.reasonCodeMap = reasonCodeMap;
        return wrapper;
    }

    public class ORSRoutingWrapper {
        @AuraEnabled public List < ORS_Routing_Information__mdt > mdtList {
            get;
            set;
        }
        @AuraEnabled public Map < String, ORS_Routing_Information__mdt > orsMap {
            get;
            set;
        }
        @AuraEnabled public List < SAE_Reason_Codes__mdt > reasonCodeList {
            get;
            set;
        }
        @AuraEnabled public Map < String, SAE_Reason_Codes__mdt > reasonCodeMap {
            get;
            set;
        }
    }

    //To create acet case - Sravan
    @AuraEnabled
    public static string saveCase(String strRecord, Boolean isProvider) {
        String caseId = SAECaseCreationController.saveTTSCase(strRecord, isProvider);
        return caseId;
    }

    //To cretae ors case - Sravan
    @AuraEnabled
    public static string saveOrsCase(String strRecord, String caseId) {
        // Thanish - Bug fix - 25th Jun 2020
        List < SAECaseCreationController.ORSResultWrapper > orsId = SAECaseCreationController.CreateORSRecord(strRecord, caseId);
        return '';
    }


    @AuraEnabled
    public static string saveFacetsCase(String strRecord, String caseId) {
        return (String) SAECaseCreationController.createFacetsRecord(strRecord, caseId);
        //return '';
    }

    //Verify whether provider has a delegated Speciality
    @AuraEnabled
    public static Boolean getDelegatedProviderData(String speciality) {
        System.debug('speciality::' + speciality);
        List < ACET_DelegatedSpeciality__mdt > delegatedList = new List < ACET_DelegatedSpeciality__mdt > ();
        delegatedList = [SELECT Speciality__c FROM ACET_DelegatedSpeciality__mdt WHERE Speciality__c =: speciality];
        if (!delegatedList.isEmpty()) {
            return true;
        }
        return false;
    }

    @AuraEnabled
    public static List<SAE_Speciality__mdt> getRoutedDelatedData(){
        List<SAE_Speciality__mdt> lstSpecialities = new List<SAE_Speciality__mdt>();
        lstSpecialities = [Select id, Delegated_Specialty__c, Specialty_Short_Description__c, Specialty_Values__c from SAE_Speciality__mdt Where Delegated_Specialty__c = 'Yes'];
        return lstSpecialities;
    }

    @AuraEnabled(continuation=true)
    public static Object createORSCaseForClaimsResolved(String strRecord, String caseId , List<UniquePolicyToClaims> resolvedCaseClaims,Boolean allUnresolvedResolvedFlg) {
        try{
            System.debug('resolved claim received '+ JSON.serialize(resolvedCaseClaims));
            System.debug('Using existing ACET Case '+ caseId + ' to create ORS Cases');

            List<SAETTSCaseWrapper> strRecordList ;

            //US3463210 - Sravan
            SAETTSCaseWrapper caseWrapper = (SAETTSCaseWrapper) JSON.deserialize(strRecord, SAETTSCaseWrapper.class);

            List < Case > caseRecord = [SELECT id, CaseNumber,Type__c, Subtype__c, Status, Case_Items_Unresolved__c, Case_Items_Complete__c,
                    ORS_Issue_ID__c, Originator_Type__c FROM Case WHERE id =: caseId
                ];

            strRecordList = getORSClaimResolved(resolvedCaseClaims,strRecord,allUnresolvedResolvedFlg);

             List < SAE_Reason_Codes__mdt > saeReasonCodes = [SELECT Category_API__c, Reason_API__c
                        FROM SAE_Reason_Codes__mdt WHERE
                        Topic__c =: strRecordList[0].AddInfoTopic AND
                        Type__c =: strRecordList[0].ttsType AND
                        Subtype__c =: strRecordList[0].ttsSubType
                    ];



            //US3644559
            Map<String,SAECaseCreationController.ORSResultWrapper> orsResultMap = new Map<String,SAECaseCreationController.ORSResultWrapper>();//US3644559
            Map<String,String> policyOrsMap = new Map<String,String>();

            Continuation con = new Continuation(120);
            con.continuationMethod = 'processResponseResolved';

             Map<String,StateInfo> requestLServiceMap=new Map<String,StateInfo>();

            for (Integer i =0; i<strRecordList.size(); i++ ){

                System.debug('Setting up Continuation object');
                SAECaseCreationController.StateInfo saeCtrStateInfo = (SAECaseCreationController.StateInfo) SAECaseCreationController.CreateORSRecordClaim(strRecordList[i],caseRecord,saeReasonCodes);

                StateInfo stateInfo = createState( strRecordList[i],caseRecord[0],caseId, saeCtrStateInfo.isResolved, null);
                stateInfo.resolvedCaseClaims = resolvedCaseClaims ;
                requestLServiceMap.put(con.addHttpRequest(saeCtrStateInfo.httpRequest),stateInfo );
            }

            System.debug('requestLServiceMap '+ requestLServiceMap);

            con.state = requestLServiceMap;

            return con;
         }
        catch( Exception ex){
         	return null;
        }
    }


    @AuraEnabled(continuation=true)
    public static Object processResponseResolved(List<String> labels, Object state) {

        System.debug('In Process Response Resolved');
        ORSResultWrapper result=new ORSResultWrapper();
        Map<String,StateInfo> requestLServiceMap=(Map<String, StateInfo>)state;
        system.debug('requestLServiceMap'+requestLServiceMap);
        List<Object> output=new List<Object>();

        //US3644559
        Map<String,SAECaseCreationController.ORSResultWrapper> orsResultMap = new Map<String,SAECaseCreationController.ORSResultWrapper>();//US3644559
		Map<String,String> policyOrsMap = new Map<String,String>();
       List<ResolvedORSClaimResult> resolvedORSClaimResults = new List<ResolvedORSClaimResult>();


        Integer counter = 0;


        SAETTSCaseWrapper caseWrapper ;
        List<UniquePolicyToClaims> resolvedCaseClaims;
        Case caseRecord ;
        for(String each:requestLServiceMap.keySet()){
            HttpResponse response = Continuation.getResponse(each);

            system.debug('response '+response);
            system.debug('response body'+response.getBody());
            StateInfo stateInfo = requestLServiceMap.get(each);
            String policyNumber = stateInfo.policyNumber;
            String claimNumber = stateInfo.claimNumber;
            Boolean isResolved = stateInfo.isResolved ;
            if(counter == 0){
                result.caseId=stateInfo.AcetCaseId;
                caseWrapper = new SAETTSCaseWrapper();
                caseWrapper.claimNumber =	stateInfo.claimNumber;
                caseWrapper.policyNumber =stateInfo.policyNumber;
                caseWrapper.AddInfoOrginSubType = stateInfo.AddInfoOrginSubType;
                caseWrapper.TaxId 	 = stateInfo.TaxId;
                caseWrapper.mnf 	= stateInfo.mnf;
                caseWrapper.mnfExternalId = stateInfo.mnfExternalId;
                caseWrapper.providerNotFound = stateInfo.providerNotFound;
                caseWrapper.pnfExternalId  = stateInfo.pnfExternalId;

                resolvedCaseClaims = stateInfo.resolvedCaseClaims;
            }


             SAECaseCreationController.ORSResultWrapper res = SAECaseCreationController.createORSRecordClaimResponse(response,policyNumber,claimNumber, isResolved);
             ResolvedORSClaimResult resolvedORSClaimResult = new ResolvedORSClaimResult();
             UniquePolicyToClaims uniquePolicy = resolvedCaseClaims[counter];
             resolvedORSClaimResult.memberId = uniquePolicy.memberId;
             resolvedORSClaimResult.policyType = uniquePolicy.policyType;
             resolvedORSClaimResult.groupNo = uniquePolicy.groupNo;
             resolvedORSClaimResult.result = res;
             resolvedORSClaimResults.add(resolvedORSClaimResult);
             //US3644559 - Sravan - Start
                orsResultMap.put(res.orsReturnId,res);
             policyOrsMap.put(res.relatedGroupNumber,res.orsReturnId);
             //US3644559 - Sravan - End
             String returnId = res.orsReturnId;

            counter ++ ;


        }

         result.resolvedORSClaimResults =resolvedORSClaimResults;
        return result;

    }




    @AuraEnabled(continuation=true)
    public static Object createORSCaseForClaimsUnresolved(String strRecord, String caseId ,List<Claim> claims, ClaimAddDetails claimAddDetails ) {

        try{
            System.debug('Using existing ACET Case '+ caseId + ' to create ORS Cases');


            List<SAETTSCaseWrapper> strRecordList ;

            //create multiple ors cases

            strRecordList = getORSClaimsListUnresolved(claims,strRecord, claimAddDetails);

            List < Case > caseRecord = [SELECT id, CaseNumber, Status,Type__c, Subtype__c, Case_Items_Unresolved__c, Case_Items_Complete__c,
                    ORS_Issue_ID__c, Originator_Type__c FROM Case WHERE id =: caseId
                ];

            List < SAE_Reason_Codes__mdt > saeReasonCodes = [SELECT Category_API__c, Reason_API__c
                        FROM SAE_Reason_Codes__mdt WHERE
                        Topic__c =: strRecordList[0].AddInfoTopic AND
                        Type__c =: strRecordList[0].ttsType AND
                        Subtype__c =: strRecordList[0].ttsSubType AND
                        Issue__c =: strRecordList[0].issueId
                    ];


            String finalOrsIssueID = caseRecord[0].ORS_Issue_ID__c ;

            Continuation con = new Continuation(120);
            con.continuationMethod = 'processResponseUnresolved';

             Map<String,StateInfo> requestLServiceMap=new Map<String,StateInfo>();
            for (Integer i =0; i<strRecordList.size(); i++ ){

                System.debug('Setting up Continuation object');
                SAECaseCreationController.StateInfo saeCtrStateInfo = (SAECaseCreationController.StateInfo)SAECaseCreationController.CreateORSRecordClaim(strRecordList[i],caseRecord,saeReasonCodes);
                StateInfo stateInfo = createState( strRecordList[i],caseRecord[0],caseId, saeCtrStateInfo.isResolved, finalOrsIssueID);
                requestLServiceMap.put(con.addHttpRequest(saeCtrStateInfo.httpRequest),stateInfo );
             }
            System.debug('Setting up State object');
             System.debug('requestLServiceMap '+ requestLServiceMap);
            con.state = requestLServiceMap;
            return con;
            }
        catch(Exception ex){
            return null;
        }
    }


    @AuraEnabled(continuation=true)
    public static Object processResponseUnresolved(List<String> labels, Object state) {

        System.debug('In Process Response Unresolved');
        ORSResultWrapper result=new ORSResultWrapper();
        Map<String,StateInfo> requestLServiceMap=(Map<String, StateInfo>)state;
        system.debug('requestLServiceMap'+requestLServiceMap);
        List<Object> output=new List<Object>();

        //US3644559
        Map<String,SAECaseCreationController.ORSResultWrapper> orsResultMap = new Map<String,SAECaseCreationController.ORSResultWrapper>();//US3644559
		Map<String,String> policyOrsMap = new Map<String,String>();
        List<UnresolvedORSClaimResult> unresolvedORSClaimResults = new List<UnresolvedORSClaimResult>();
        //String finalOrsIssueID = '';

        Integer counter = 0;


        SAETTSCaseWrapper caseWrapper ;
        //Case caseRecord ;
        for(String each:requestLServiceMap.keySet()){
            HttpResponse response = Continuation.getResponse(each);

            system.debug('response '+response);
            system.debug('response body'+response.getBody());
            StateInfo stateInfo = requestLServiceMap.get(each);
            String policyNumber = stateInfo.policyNumber;
            String claimNumber = stateInfo.claimNumber;
            Boolean isResolved = stateInfo.isResolved ;
            if(counter == 0){
                result.caseId=stateInfo.AcetCaseId;
                caseWrapper = new SAETTSCaseWrapper();
                caseWrapper.claimNumber =	stateInfo.claimNumber;
                caseWrapper.policyNumber =stateInfo.policyNumber;
                caseWrapper.AddInfoOrginSubType = stateInfo.AddInfoOrginSubType;
                caseWrapper.TaxId 	 = stateInfo.TaxId;
                caseWrapper.mnf 	= stateInfo.mnf;
                caseWrapper.mnfExternalId = stateInfo.mnfExternalId;
                caseWrapper.providerNotFound = stateInfo.providerNotFound;
                caseWrapper.pnfExternalId  = stateInfo.pnfExternalId;
            }
            counter ++ ;
            SAECaseCreationController.ORSResultWrapper res = SAECaseCreationController.createORSRecordClaimResponse(response,policyNumber,claimNumber, isResolved);
            String returnId = res.orsReturnId;
            UnresolvedORSClaimResult unresolvedORSClaimResult =new UnresolvedORSClaimResult();
            unresolvedORSClaimResult.claimId = claimNumber;
            unresolvedORSClaimResult.result = res;
            orsResultMap.put(res.orsReturnId,res);
            policyOrsMap.put(res.relatedGroupNumber,res.orsReturnId);
            unresolvedORSClaimResults.add(unresolvedORSClaimResult);

        }

        result.unresolvedORSClaimResults =unresolvedORSClaimResults;


        return result;
    }

    public static StateInfo createState(SAETTSCaseWrapper caseWrapper, Case caseRecord, String caseId,  Boolean isResolved, String finalOrsIssueId   ){

		StateInfo stateInfo = new StateInfo ();

		stateInfo.claimNumber = caseWrapper.claimNumber;
		stateInfo.policyNumber = caseWrapper.policyNumber;
		stateInfo.AddInfoOrginSubType = caseWrapper.AddInfoOrginSubType;
		stateInfo.TaxId = caseWrapper.TaxId;
		stateInfo.mnf = caseWrapper.mnf;
		stateInfo.mnfExternalId = caseWrapper.mnfExternalId;
		stateInfo.providerNotFound = caseWrapper.providerNotFound;
		stateInfo.pnfExternalId = caseWrapper.pnfExternalId;
		stateInfo.acetCaseId = caseId;
		stateInfo.isResolved = isResolved;
		return stateInfo;

	}


    @AuraEnabled
    public static List<ACET_SelectAssociateWS.SelectAssociateOutput> callSelectAssociateAPI(String officeId,String departmentCode,String teamCode) {
        ACET_SelectAssociateWS.SelectAssociateInput input=new ACET_SelectAssociateWS.SelectAssociateInput();

        input.officeId=officeId;
        input.departmentCode=departmentCode;
        input.teamCode=teamCode;
        List<ACET_SelectAssociateWS.SelectAssociateOutput> associates = ACET_SelectAssociateWS.callSelectAssociate(input);
        System.debug(' @@ACET_RoutingScreenController : associateNames ::'+associates);

        if(associates == null){
            associates=new List<ACET_SelectAssociateWS.SelectAssociateOutput>();
        }else if(associates.size()<1){
            ACET_SelectAssociateWS.SelectAssociateOutput res=new ACET_SelectAssociateWS.SelectAssociateOutput();
            res.associateName='--None--';
            res.associateId='';
            associates.add(res);
        }

		return associates;
    }




    private static List<SAETTSCaseWrapper>  getORSClaimResolved (List<UniquePolicyToClaims> resolvedClaims, String strRecord, Boolean allUnresolvedResolvedFlg){

         List<SAETTSCaseWrapper> strRecordList = new List<SAETTSCaseWrapper>();

         for (Integer j =0; j< resolvedClaims.size() ; j++){

             SAETTSCaseWrapper caseWrapper = (SAETTSCaseWrapper) JSON.deserialize(strRecord, SAETTSCaseWrapper.class);
             caseWrapper.claimCaseStatus ='C';
             caseWrapper.SubjectGroupId = resolvedClaims[j].groupNo;
			 caseWrapper.policyNumber = resolvedClaims[j].groupNo;
             List<Claim> claims =  resolvedClaims[j].claims;
             List < String > orsClmCaseComments = new List < String > ();
             //Send claims Ids in comment section
             String claimCommentValue= '';

             if(allUnresolvedResolvedFlg){
                 claimCommentValue+= 'ONE OR MORE OF THE FOLLOWING DID NOT MEET ROUTING CRITERIA: ';
             }

             for(Integer i = 0; i < claims.size(); i++ ){
                 if(i==0){
                    claimCommentValue+= 'External ID -' + claims[i].claimId ;
                    caseWrapper.claimNumber =claims[i].claimId;
                     if(claims[i].serviceDate!=null &&  claims[i].serviceDate!='' && claims[i].serviceDate != 'No Matching Results Found'){
                        List<String> serviceDates = claims[i].serviceDate.split(' ');
                        List<String> serviceDateBeginBroken = serviceDates[0].split('/');
                        String serviceDateBegin = serviceDateBeginBroken[2]+ '-'+ serviceDateBeginBroken[0]+ '-'+ serviceDateBeginBroken[1];

                        caseWrapper.serviceDate= serviceDateBegin;
                     }
                 }
                 else{
                    claimCommentValue+= ', External ID -'+ claims[i].claimId;
                 }

         	}


            List<String> formattedOrsCommentList  = formatCommentToORSFormat(claimCommentValue);
            caseWrapper.claimComments = formattedOrsCommentList;
            System.debug('Preparing to one ORS case for all resolved Claims ' + claims + ' for unique combination member Id -'
                         + resolvedClaims[j].memberId + ', group No -'+ resolvedClaims[j].groupNo + ', policy type' + resolvedClaims[j].policyType);
            strRecordList.add(caseWrapper);

         }

         return strRecordList;

    }


    // TBD create multiple ORS case for unresolved claims
    private static List<SAETTSCaseWrapper>  getORSClaimsListUnresolved (List<Claim> claims, String strRecord, ClaimAddDetails  claimAddDetails ){

         List<SAETTSCaseWrapper> strRecordList = new List<SAETTSCaseWrapper>();

		 for(Integer i = 0; i < claims.size(); i++ ){

            String  orsClmCaseComments ='';
         	SAETTSCaseWrapper caseWrapper = (SAETTSCaseWrapper) JSON.deserialize(strRecord, SAETTSCaseWrapper.class);
            caseWrapper.claimCaseStatus ='O';
            caseWrapper.SubjectGroupId  = claims[i].groupNo ;
            caseWrapper.policyNumber = claims[i].groupNo ;
            System.debug('claim Add Details received '+ JSON.serialize(claimAddDetails));
            orsClmCaseComments +=  createCommentLinesForORS('Comments', claimAddDetails.additionalReqDtl.Commentvalue);

            System.debug('claim received from getORSClaimsListUnresolved method '+ JSON.serialize(claims));
             //TBD: Add issue, Contact Number
             if(claimAddDetails.demographicInfo.issue !=null && String.isNotEmpty(claimAddDetails.demographicInfo.issue))
             	orsClmCaseComments += ', '+createCommentLinesForORS('ISSUE', claimAddDetails.demographicInfo.issue);

             if(claimAddDetails.demographicInfo.phone !=null && String.isNotEmpty(claimAddDetails.demographicInfo.phone))
             	orsClmCaseComments += ', '+ createCommentLinesForORS('CONTACT NUMBER', claimAddDetails.demographicInfo.phone);

              if(claimAddDetails.demographicInfo.hours !=null && String.isNotEmpty(claimAddDetails.demographicInfo.hours))
             	orsClmCaseComments += ', '+ createCommentLinesForORS('HOURS OF OPERATION', claimAddDetails.demographicInfo.hours);
             //if(claimAddDetails.demographicInfo.issue == 'Stop Pay and Reissue' || claimAddDetails.demographicInfo.issue == 'TRACR Request' && claims[i].paymentNoInput !=null){
             //if(claims[i].paymentNoInput !=null)
                orsClmCaseComments += ', '+ getCommentsForORS('PAYMENT #', claims[i].paymentNoInput,claimAddDetails.demographicInfo.issue);
             //}
             if(claims[i].claimId !=null)
             	orsClmCaseComments += ', '+ createCommentLinesForORS('CLAIM #', claims[i].claimId);
             if(claims[i].serviceDate !=null && String.isNotEmpty(claims[i].serviceDate))
             	orsClmCaseComments += ', '+ createCommentLinesForORS('SERVICE DATES', claims[i].serviceDate);

             orsClmCaseComments += getCommentsForORS('PAY LOC/ENGINE',claims[i].engCode,claimAddDetails.demographicInfo.issue);
             orsClmCaseComments += getCommentsForORS('FLN/DCC',claims[i].flndcc,claimAddDetails.demographicInfo.issue);
             /*if(claimAddDetails.demographicInfo.issue == 'Corrected Keying Request' || claimAddDetails.demographicInfo.issue == 'Initial Keying Request'){
             	orsClmCaseComments += ', '+ createCommentLinesForORS('PAY LOC/ENGINE', claims[i].engCode);
             	orsClmCaseComments += ', '+ createCommentLinesForORS('FLN/DCC', claims[i].flndcc);
             }*/
             if(claims[i].providerStatus !=null && String.isNotEmpty(claims[i].providerStatus))
                orsClmCaseComments += ', '+ createCommentLinesForORS('PROVIDER STATUS', claims[i].providerStatus);
             if(claims[i].benfitLevel !=null && String.isNotEmpty(claims[i].benfitLevel))
                 orsClmCaseComments += ', '+ createCommentLinesForORS('BENEFIT LEVEL', claims[i].benfitLevel);
              if(claims[i].expectedAllowed!=null && String.isNotEmpty(claims[i].expectedAllowed))
                 orsClmCaseComments += ', '+ createCommentLinesForORS('EXPECTED ALLOWED $', claims[i].expectedAllowed);
			if(claims[i].RODreason !=null && String.isNotEmpty(claims[i].RODreason))
             	orsClmCaseComments += ', '+ createCommentLinesForORS('REASON', claims[i].RODreason);
            if(claims[i].CheckValue !=null && String.isNotEmpty(claims[i].CheckValue))
             	orsClmCaseComments += ', '+ createCommentLinesForORS('CHECK #', claims[i].CheckValue);
             if(claims[i].DateValue !=null && String.isNotEmpty(claims[i].DateValue) && claims[i].DateValue!= 'Invalid Date')
             	orsClmCaseComments += ', '+ createCommentLinesForORS('DATE CHECK SENT', claims[i].DateValue);
             if(claims[i].overPayValue !=null && String.isNotEmpty(claims[i].overPayValue))
             	orsClmCaseComments += ', '+ createCommentLinesForORS('OVERPAYMENT REASON GIVEN', claims[i].overPayValue);
             if(claims[i].ReasonValue !=null && String.isNotEmpty(claims[i].ReasonValue))
             	orsClmCaseComments += ', '+ createCommentLinesForORS('REASON FOR REVIEW BEING REQUESTED', claims[i].ReasonValue);
             if(claims[i].originalClaim !=null && String.isNotEmpty(claims[i].originalClaim))
             	orsClmCaseComments += ', '+ createCommentLinesForORS('ORIGINAL CLAIM/FLN #', claims[i].originalClaim);
             if(claims[i].correctedClaim !=null && String.isNotEmpty(claims[i].correctedClaim))
             	orsClmCaseComments += ', '+ createCommentLinesForORS('CORRECTED CLAIM/FLN #', claims[i].correctedClaim);
             if(claimAddDetails.demographicInfo.issue == 'Timely Filing Discrepancy'){
                 if(claims[i].receivedDate !=null && String.isNotEmpty(claims[i].receivedDate))
                     orsClmCaseComments += ', '+ createCommentLinesForORS('RECEIVED DATE', claims[i].receivedDate);

                 if(claims[i].tflDate !=null && String.isNotEmpty(claims[i].tflDate))
                     orsClmCaseComments += ', '+ createCommentLinesForORS('TFL DATE', claims[i].tflDate);

             }
			if(claimAddDetails.demographicInfo.issue == 'Paid Correctly, Pre-Appeal Reconsideration'){
             	orsClmCaseComments += ', '+ createCommentLinesForORS('',System.Label.ACET_Paid_Correctly);
             }
             if(claimAddDetails.demographicInfo.issue == 'Pend Status'){
                if(claims[i].receivedDate !=null && String.isNotEmpty(claims[i].receivedDate)){
                    orsClmCaseComments += ', '+ createCommentLinesForORS('RECEIVED DATE', claims[i].receivedDate);
                }
                orsClmCaseComments += ', '+ createCommentLinesForORS('REASON','Claim Pended Over TAT');
            }

             if(claims[i].uhcErrorValue !=null && String.isNotEmpty(claims[i].uhcErrorValue))
             	orsClmCaseComments += ', '+ createCommentLinesForORS('UHC ERROR', claims[i].uhcErrorValue);

             if(claims[i].FLNValue !=null && String.isNotEmpty(claims[i].FLNValue))
             	orsClmCaseComments += ', '+ createCommentLinesForORS('FLN #', claims[i].FLNValue);

              if(claims[i].matchingRefereal !=null && String.isNotEmpty(claims[i].matchingRefereal))
             	orsClmCaseComments +=', '+ createCommentLinesForORS('MATCHING REFERRAL', claims[i].matchingRefereal);

             //comments for Misquote of Information start
             if(claimAddDetails.demographicInfo.issue == 'MISQUOTE OF INFORMATION'){
                 if(claims[i].charged !=null && String.isNotEmpty(claims[i].charged))
                orsClmCaseComments += ', '+ createCommentLinesForORS('CHARGED', claims[i].charged);

             if(claims[i].underAmmount !=null && String.isNotEmpty(claims[i].underAmmount))
                orsClmCaseComments += ', '+ createCommentLinesForORS('UNDER $ 7,000?', claims[i].underAmmount);

             if(claims[i].PCMValue !=null && String.isNotEmpty(claims[i].PCMValue))
                 orsClmCaseComments += ', '+ createCommentLinesForORS('PAE CRITERIA MET', claims[i].PCMValue);

             if(claims[i].sourceValue !=null && String.isNotEmpty(claims[i].sourceValue))
                 orsClmCaseComments += ', '+ createCommentLinesForORS('SOURCE', claims[i].sourceValue);

             if(claims[i].FLNNumber !=null && String.isNotEmpty(claims[i].FLNNumber))
                 orsClmCaseComments += ', '+ createCommentLinesForORS('FLN #', claims[i].FLNNumber);

             if(claims[i].externalID !=null && String.isNotEmpty(claims[i].externalID))
                 orsClmCaseComments += ', '+ createCommentLinesForORS('EXTERNAL ID', claims[i].externalID);

             if(claims[i].MISInfo !=null && String.isNotEmpty(claims[i].MISInfo))
                 orsClmCaseComments += ', '+ createCommentLinesForORS('MISQUOTED INFORMATION', claims[i].MISInfo);

             }
             //comments for Misquote of Information End

              //comments for Additional Information Received start
             if(claimAddDetails.demographicInfo.issue == 'Additional Information Received'){
                 if(claims[i].AIRreason !=null && String.isNotEmpty(claims[i].AIRreason))
                 orsClmCaseComments += ', '+ createCommentLinesForORS('REASON', claims[i].AIRreason);

                 if(claims[i].AIRFLNValue !=null && String.isNotEmpty(claims[i].AIRFLNValue))
                 orsClmCaseComments += ', '+ createCommentLinesForORS('FLN #', claims[i].AIRFLNValue);

                 if(claims[i].AIRFLNDateValue !=null && String.isNotEmpty(claims[i].AIRFLNDateValue))
                 orsClmCaseComments += ', '+ createCommentLinesForORS('RECEIVED DATE OF FLN', claims[i].AIRFLNDateValue);

                 if(claims[i].AIRLUDateValue !=null && String.isNotEmpty(claims[i].AIRLUDateValue))
                 orsClmCaseComments += ', '+ createCommentLinesForORS('LAST UPDATED DATE', claims[i].AIRLUDateValue);

                 if(claims[i].AIRPDNDateValue !=null && String.isNotEmpty(claims[i].AIRPDNDateValue))
                 orsClmCaseComments += ', '+ createCommentLinesForORS('PROCESSED DATE', claims[i].AIRPDNDateValue);
             }
             //comments for Additional Information Received End

             if(claims[i].matchingSRN !=null && String.isNotEmpty(claims[i].matchingSRN))
             	orsClmCaseComments += ', '+ createCommentLinesForORS('MATCHING SRN', claims[i].matchingSRN);


             if(claims[i].types !=null && String.isNotEmpty(claims[i].types))
             	orsClmCaseComments += ', '+ createCommentLinesForORS('TYPE', claims[i].types);

             if( claims[i].cashed !=null && String.isNotEmpty( claims[i].cashed))
             	orsClmCaseComments += ', '+ createCommentLinesForORS('CASHED', claims[i].cashed);

             if(claims[i].reason !=null && String.isNotEmpty(claims[i].reason))
            	orsClmCaseComments += ', '+ createCommentLinesForORS('REASON',claims[i].reason);
             if(claimAddDetails.demographicInfo.issue == 'Eligibility Issue'){
                 if(claims[i].coverageLevel !=null && String.isNotEmpty(claims[i].coverageLevel))
                     orsClmCaseComments += ', '+ createCommentLinesForORS('COVERAGE LEVEL', claims[i].coverageLevel);

                 if(claims[i].eligibilityDates !=null && String.isNotEmpty(claims[i].eligibilityDates))
                     orsClmCaseComments += ', '+ createCommentLinesForORS('ELIGIBILITY DATES', claims[i].eligibilityDates);

             }

             if(claims[i].eReasonValue !=null && String.isNotEmpty(claims[i].eReasonValue))
             	orsClmCaseComments += ', '+ createCommentLinesForORS('REASON',claims[i].eReasonValue);

             if(claimAddDetails.demographicInfo.MethofDelValue !=null && String.isNotEmpty(claimAddDetails.demographicInfo.MethofDelValue))
            	orsClmCaseComments += ', '+ createCommentLinesForORS('METHOD OF DELIVERY', claimAddDetails.demographicInfo.MethofDelValue);

             if(claimAddDetails.demographicInfo.firstNameValue !=null && String.isNotEmpty(claimAddDetails.demographicInfo.firstNameValue))
            	orsClmCaseComments += ', '+ createCommentLinesForORS('FIRST NAME', claimAddDetails.demographicInfo.firstNameValue);

             if(claimAddDetails.demographicInfo.lastNameValue !=null && String.isNotEmpty(claimAddDetails.demographicInfo.lastNameValue))
             	orsClmCaseComments += ', '+ createCommentLinesForORS('LAST NAME', claimAddDetails.demographicInfo.lastNameValue);

             if(claimAddDetails.demographicInfo.addressValue !=null && String.isNotEmpty(claimAddDetails.demographicInfo.addressValue))
             	orsClmCaseComments += ', '+ createCommentLinesForORS('ADDRESS', claimAddDetails.demographicInfo.addressValue);

             if(claimAddDetails.demographicInfo.cityValue !=null && String.isNotEmpty(claimAddDetails.demographicInfo.cityValue))
             	orsClmCaseComments += ', '+ createCommentLinesForORS('CITY', claimAddDetails.demographicInfo.cityValue);

             if( claimAddDetails.demographicInfo.stateValue !=null && String.isNotEmpty( claimAddDetails.demographicInfo.stateValue))
             	orsClmCaseComments += ', '+ createCommentLinesForORS('STATE', claimAddDetails.demographicInfo.stateValue);

             if(claimAddDetails.demographicInfo.zipCodeValue !=null && String.isNotEmpty(claimAddDetails.demographicInfo.zipCodeValue))
             	orsClmCaseComments += ', '+ createCommentLinesForORS('ZIP CODE', claimAddDetails.demographicInfo.zipCodeValue);

             /*if(claims[i].checkAmount !=null && String.isNotEmpty(claims[i].checkAmount))
             	orsClmCaseComments += ', '+ createCommentLinesForORS('CASHED AMOUNT', claims[i].checkAmount);
             if(claims[i].CheckDate !=null && String.isNotEmpty(claims[i].CheckDate))
             	orsClmCaseComments += ', '+ createCommentLinesForORS('CHECK DATE', claims[i].CheckDate);
             if(claims[i].ChashDate !=null && String.isNotEmpty(claims[i].ChashDate))
             	orsClmCaseComments += ', '+ createCommentLinesForORS('CASHED DATE', claims[i].ChashDate);*/
             orsClmCaseComments += getCommentsForORS('CASHED AMOUNT',claims[i].checkAmount,claimAddDetails.demographicInfo.issue);
             orsClmCaseComments += getCommentsForORS('CHECK DATE',claims[i].CheckDate,claimAddDetails.demographicInfo.issue);
             orsClmCaseComments += getCommentsForORS('CASHED DATE',claims[i].ChashDate,claimAddDetails.demographicInfo.issue);
             System.debug('orsClmCaseComments-->'+orsClmCaseComments);
             if(claimAddDetails.demographicInfo.fax !=null && String.isNotEmpty(claimAddDetails.demographicInfo.fax) && claimAddDetails.demographicInfo.MethofDelValue == 'FAXED')
             	orsClmCaseComments += ', '+ createCommentLinesForORS('FAX', claimAddDetails.demographicInfo.fax);

             if(claimAddDetails.additionalReqDtl.isEscalatedValue !=null && String.isNotEmpty(claimAddDetails.additionalReqDtl.isEscalatedValue))
             	orsClmCaseComments += ', '+ createCommentLinesForORS('IS THIS AN ESCALATED REQUEST?', claimAddDetails.additionalReqDtl.isEscalatedValue);



             if(claimAddDetails.additionalReqDtl.escalationReason !=null && String.isNotEmpty(claimAddDetails.additionalReqDtl.escalationReason))
             	orsClmCaseComments += ', '+ createCommentLinesForORS('ESCALATION REASON', claimAddDetails.additionalReqDtl.escalationReason);

             if(claimAddDetails.additionalReqDtl.priorExternalId !=null && String.isNotEmpty(claimAddDetails.additionalReqDtl.priorExternalId))
             	orsClmCaseComments += ', '+ createCommentLinesForORS('Prior External ID\'s', claimAddDetails.additionalReqDtl.priorExternalId);
             //TBD: Add does not know
             if(claimAddDetails.additionalReqDtl.doesNotKnow!=null &&  claimAddDetails.additionalReqDtl.doesNotKnow)
             	orsClmCaseComments +=  ', '+ createCommentLinesForORS('Expected Payment Amount', 'Does Not Know');
             else
             	orsClmCaseComments +=  ', '+ createCommentLinesForORS('Expected Payment Amount', claimAddDetails.additionalReqDtl.expPaymentValue);

             String days=claimAddDetails.additionalReqDtl.days ? 'Bus' : 'Cal';
             if(claimAddDetails.additionalReqDtl.tatProvided !=null && String.isNotEmpty(claimAddDetails.additionalReqDtl.tatProvided))
             	orsClmCaseComments +=  ', '+ createCommentLinesForORS('TAT PROVIDED', claimAddDetails.additionalReqDtl.tatProvided +' '+days);

             if(claims[i].claimId !=null)
             	orsClmCaseComments +=  ', '+ createCommentLinesForORS('EXTERNAL ID', claims[i].claimId);



             List<String> formattedOrsCommentList  = formatCommentToORSFormat(orsClmCaseComments);


            caseWrapper.claimComments = formattedOrsCommentList;
            caseWrapper.claimNumber=claims[i].claimId;
            System.debug('Ketki log: ACET_RoutingScreenController: officeAPI :: '+ClaimAddDetails.sendToInfo.officeAPI);
            System.debug('Ketki log: ACET_RoutingScreenController: departmentAPI :: '+ClaimAddDetails.sendToInfo.departmentAPI);
            System.debug('Ketki log: ACET_RoutingScreenController: teamAPI :: '+ClaimAddDetails.sendToInfo.teamAPI);
            System.debug('Ketki log: ACET_RoutingScreenController: individual :: '+ClaimAddDetails.sendToInfo.individual);

            caseWrapper.officeAPI=ClaimAddDetails.sendToInfo.officeAPI;
            caseWrapper.departmentAPI=ClaimAddDetails.sendToInfo.departmentAPI;
            caseWrapper.teamAPI=ClaimAddDetails.sendToInfo.teamAPI;
            if(ClaimAddDetails.sendToInfo.individual !='Select'){
                caseWrapper.associateId=ClaimAddDetails.sendToInfo.individual;
            }


            List<String> serviceDates = claims[i].serviceDate.split(' ');
            List<String> serviceDateBeginBroken = serviceDates[0].split('/');
            String serviceDateBegin = serviceDateBeginBroken[2]+ '-'+ serviceDateBeginBroken[0]+ '-'+ serviceDateBeginBroken[1];

            caseWrapper.serviceDate= serviceDateBegin;

            System.debug('Preparing to create ORS case for unresolved Claim' + claims[i].claimId);
            strRecordList.add(caseWrapper);
         }

        return strRecordList;

    }
    public Static String getCommentsForORS(String Name, String value, String ORSComments){
		String strORSComments;

        if(String.isNotBlank(value) && value != null && value != '--'){
        	strORSComments=  ', '+ createCommentLinesForORS(Name, value);
        }
        if((ORSComments =='Corrected Keying Request' || ORSComments =='Initial Keying Request') && (Name =='PAY LOC/ENGINE' || Name =='FLN/DCC')){
            strORSComments=  ', '+ createCommentLinesForORS(Name, value);
        }else if(ORSComments =='TRACR Request' && value != '--'){
        	strORSComments=  ', '+ createCommentLinesForORS(Name, value);
        }
        return strORSComments;
    }

    private static String createCommentLinesForORS(String Name, String Value  ){
        if(value == null)
            value = '';
        String fullComment = (Name == 'Comments') ? Value  : Name + '-' + Value+'\n';
        //String fullComment = Name + '-' + Value + ' ';
        return fullComment;
    }

     private static List<String> formatCommentToORSFormat(String fullComment ){

         List<String> orsComments = new List<String>();
         if (fullComment != null) {
                    Integer length = fullComment.length();
                    if (length > 71) {
                        Integer noOfIterations = (Integer) length / 71;
                        for (Integer i = 0; i <= noOfIterations; i++) {
                            if (length > (i * 71) + 71) {
                                orsComments.add(fullComment.subString(i * 71, (i * 71) + 71));
                            } else {
                                orsComments.add(fullComment.subString(i * 71, length));
                            }
                        }
                    } else {
                        orsComments.add(fullComment);
                    }
                }
        return orsComments;
    }

	//US3644559 - Sravan - Start
	public static void createCaseItems(Map<String,SAECaseCreationController.ORSResultWrapper> orsResultMap,SAETTSCaseWrapper caseWrapper,Case caseRecord,String caseId,Map<String,String> policyOrsmap){
		String extID = ' ';
        Boolean skip = false;
        List<Case_Item__c> caseItems = new  List<Case_Item__c>();
        List<String> resolvedCaseItems = new List<String>();
        List<String> unResolvedCaseItems = new List<String>();
        Map<String,SAETTSCaseWrapper.ACETCaseItem> relatedCaseItemsMap = new Map<String,SAETTSCaseWrapper.ACETCaseItem>();
        Map<String,Map<String,SAETTSCaseWrapper.ACETCaseItem>> allrelatedCaseItemMap = new Map<String,Map<String,SAETTSCaseWrapper.ACETCaseItem>>();
        extID = getExtId(caseWrapper);
        system.debug('Related Case Items Map'+ caseWrapper.allrelatedCaseItemMap);
        if(caseWrapper.AddInfoOrginSubType == 'Claims Project 20+ Claims'){
            relatedCaseItemsMap =  getRelatedCaseItemMap(caseWrapper);
            skip = true;
        }
        if(relatedCaseItemsMap != null && !relatedCaseItemsMap.isEmpty()){
            for(SAETTSCaseWrapper.ACETCaseItem caseItem :  relatedCaseItemsMap.Values()){
                Case_Item__c ci = new Case_Item__c();
				ci.Case__c = caseId;
				ci.ExternalID__c = caseItem.uniqueKey;
				ci.tax_id__c = extID;
				ci.Resolved__c = true;
                ci.Resolved_Reason__c = getResolvedReason(true);
                ci.Ext_Record_Status__c = getOrsStatus(true);
				ci.Type__c = caseRecord.Type__c;
				ci.Subtype__c = caseRecord.subtype__c;
				ci.Ext_Record_ID__c = policyOrsmap.get(caseWrapper.policyNumber);
				ci.Group_Number__c = orsResultMap.get(policyOrsmap.get(caseWrapper.policyNumber)).relatedGroupNumber;
				caseItems.add(ci);
             }
        }
        if(orsResultMap != null && !orsResultMap.isEmpty() && !skip){
            for(String orsId : orsResultMap.keySet()){
                Case_Item__c ci = new Case_Item__c();
				ci.Case__c = caseId;
				ci.ExternalID__c = orsResultMap.get(orsId).relatedclaimNumber;
				ci.tax_id__c = extID;
				ci.Resolved__c = orsResultMap.get(orsId).isResolved;
                ci.Resolved_Reason__c = getResolvedReason(orsResultMap.get(orsId).isResolved);
                ci.Ext_Record_Status__c = getOrsStatus(orsResultMap.get(orsId).isResolved);
				ci.Type__c = caseRecord.Type__c;
				ci.Subtype__c = caseRecord.subtype__c;
				ci.Ext_Record_ID__c = orsId;
				ci.Group_Number__c = orsResultMap.get(orsId).relatedGroupNumber;
				caseItems.add(ci);
            }
        }

        if(caseItems != null && !caseItems.isEmpty()){
            try{
            insert caseItems;
        }
            catch(Exception ex){

            }
        }

	}


    //Ketki continuation
    @AuraEnabled
	public static void createCaseItemsClaims( String strRecord, String caseId ,Boolean allUnresolvedResolvedFlg){

        List < Case > caseRecord = [SELECT id, CaseNumber, Status,Type__c, Subtype__c, Case_Items_Unresolved__c, Case_Items_Complete__c,
                    ORS_Issue_ID__c, Originator_Type__c FROM Case WHERE id =: caseId
        ];
    	SAETTSCaseWrapper caseWrapper = (SAETTSCaseWrapper) JSON.deserialize(strRecord, SAETTSCaseWrapper.class);

        Map<String,Map<String,SAETTSCaseWrapper.ACETCaseItem>> allrelatedCaseItemMap = new Map<String,Map<String,SAETTSCaseWrapper.ACETCaseItem>>();
        String extID = getExtId(caseWrapper);
        allrelatedCaseItemMap = caseWrapper.allrelatedCaseItemMap;

        List<Case_Item__c> caseItems = new List<Case_Item__c>();
        for (String key : allrelatedCaseItemMap.keySet()) {
    		Map<String,SAETTSCaseWrapper.ACETCaseItem> caseItemMap = allrelatedCaseItemMap.get(key);

            for (String key1 : caseItemMap.keySet()) {
             SAETTSCaseWrapper.ACETCaseItem caseItem =    caseItemMap.get(key1);

                Case_Item__c ci = new Case_Item__c();
				ci.Case__c = caseId;
				ci.ExternalID__c = caseItem.uniqueKey;
				ci.tax_id__c = extID;
				ci.Resolved__c = caseItem.isResolved;
                ci.Resolved_Reason__c = getResolvedReason(true);
                ci.Ext_Record_Status__c = getOrsStatus(true);
				ci.Type__c = caseRecord[0].Type__c;
				ci.Subtype__c = caseRecord[0].subtype__c;
				ci.Ext_Record_ID__c = caseItem.orsReturnId;
				ci.Group_Number__c = key;
				caseItems.add(ci);

            }
		}

        if(caseItems != null && !caseItems.isEmpty()){
            insert caseItems;
        }

         if(allUnresolvedResolvedFlg){
            caseRecord[0].Status ='Closed';
            update caseRecord;
        }

	}


	public static String getResolvedReason(Boolean isResolved){
		String resolvedReason = '';
		if(isResolved){
			resolvedReason =  'Resolved';
		}
		else{
			resolvedReason = '';
		}
		return resolvedReason;
    }

    public static String getOrsStatus(Boolean isResolved){
        String orsStatus= '';
		if(isResolved){
			orsStatus =  'Close';
		}
		else{
			orsStatus = 'Open';
		}
		return orsStatus;
    }

    public static String getExtId(SAETTSCaseWrapper caseWrapper){
        String extId = '';
        if (!String.isEmpty(caseWrapper.TaxId)) {
            extId = caseWrapper.TaxId;
        }
        if (caseWrapper.mnf == 'mnf') {
            extId = caseWrapper.mnfExternalId;
        }
        if (caseWrapper.providerNotFound) {
            extId = caseWrapper.pnfExternalId;
        }
       return extId;
    }

    public static Map<String,SAETTSCaseWrapper.ACETCaseItem> getRelatedCaseItemMap(SAETTSCaseWrapper caseWrapper){
        Map<String,Map<String,SAETTSCaseWrapper.ACETCaseItem>> allrelatedCaseItemMap = new Map<String,Map<String,SAETTSCaseWrapper.ACETCaseItem>>();
        Map<String,SAETTSCaseWrapper.ACETCaseItem> relatedCaseItemsMap = new Map<String,SAETTSCaseWrapper.ACETCaseItem>();
        allrelatedCaseItemMap = caseWrapper.allrelatedCaseItemMap;
        if(allrelatedCaseItemMap != null && !allrelatedCaseItemMap.isEmpty()){
            relatedCaseItemsMap = allrelatedCaseItemMap.get(caseWrapper.policyNumber);
        }
        return relatedCaseItemsMap;
    }

    @AuraEnabled
    public static void insertCaseItems(String caseId, String caseWrapper){
         SAECaseCreationController.insertCaseItems(caseId,caseWrapper);
    }
	//US3644559 - Sravan - End



    public class UniquePolicyToClaims {
        @AuraEnabled public String policyType {get;set;}
        @AuraEnabled public String memberId {get;set;}
        @AuraEnabled public String groupNo {get;set;}
        @AuraEnabled public List<Claim> claims {get;set;}

    }


    public class Claim {
        @AuraEnabled public String paymentNoInput {get;set;}
        @AuraEnabled public String claimId {get;set;}
        @AuraEnabled public String ServiceDate {get;set;}
        @AuraEnabled public String types {get;set;}
        @AuraEnabled public String cashed {get;set;}
        @AuraEnabled public String matchingSRN {get;set;}
        @AuraEnabled public String matchingRefereal {get;set;}

        @AuraEnabled public String charged {get;set;}
        @AuraEnabled public String underAmmount {get;set;}
        @AuraEnabled public String PCMValue {get;set;}
        @AuraEnabled public String sourceValue {get;set;}
        @AuraEnabled public String FLNNumber {get;set;}
        @AuraEnabled public String MISInfo {get;set;}
        @AuraEnabled public String externalID {get;set;}

        @AuraEnabled public String reason {get;set;}

        @AuraEnabled public String eReasonValue {get;set;}
        @AuraEnabled public String coverageLevel {get;set;}
        @AuraEnabled public String eligibilityDates {get;set;}


        @AuraEnabled public String receivedDate {get;set;}
        @AuraEnabled public String tflDate {get;set;}
        @AuraEnabled public String uhcErrorValue {get;set;}
        @AuraEnabled public String FLNValue {get;set;}
        @AuraEnabled public String RODreason {get;set;}
        @AuraEnabled public String CheckValue {get;set;}
        @AuraEnabled public String DateValue {get;set;}
        @AuraEnabled public String overPayValue {get;set;}
        @AuraEnabled public String ReasonValue {get;set;}
        @AuraEnabled public String originalClaim {get;set;}
        @AuraEnabled public String correctedClaim {get;set;}
        @AuraEnabled public String providerStatus {get;set;}
        @AuraEnabled public String benfitLevel {get;set;}
        @AuraEnabled public String expectedAllowed {get;set;}
        @AuraEnabled public String AIRreason {get;set;}
        @AuraEnabled public String AIRFLNValue {get;set;}
        @AuraEnabled public String AIRFLNDateValue {get;set;}
        @AuraEnabled public String AIRLUDateValue {get;set;}
        @AuraEnabled public String AIRPDNDateValue {get;set;}
		@AuraEnabled public String engCode {get;set;}
        @AuraEnabled public String flndcc {get;set;}
        @AuraEnabled public String checkAmount {get;set;}
        @AuraEnabled public String CheckDate {get;set;}
        @AuraEnabled public String ChashDate {get;set;}
        @AuraEnabled public String groupNo {get;set;}

    }

    public class ClaimAddDetails {
        @AuraEnabled public DemographicInfo demographicInfo {get;set;}
        @AuraEnabled public AdditionalReqDtl additionalReqDtl {get;set;}
        @AuraEnabled public SendToInfo sendToInfo {get;set;}
    }

    public class SendToInfo {
        @AuraEnabled public String officeAPI  {get;set;}
        @AuraEnabled public String departmentAPI  {get;set;}
        @AuraEnabled public String teamAPI  {get;set;}
        @AuraEnabled public String individual  {get;set;}
     }

    public class DemographicInfo {

        @AuraEnabled public String firstNameValue  {get;set;}
        @AuraEnabled public String lastNameValue  {get;set;}
        @AuraEnabled public String addressValue  {get;set;}
        @AuraEnabled public String cityValue  {get;set;}
        @AuraEnabled public String stateValue  {get;set;}
        @AuraEnabled public String zipCodeValue  {get;set;}
        @AuraEnabled public String phone  {get;set;}
        @AuraEnabled public String issue  {get;set;}
        @AuraEnabled public String methofDelValue  {get;set;}
        @AuraEnabled public String fax  {get;set;}
        @AuraEnabled public String hours  {get;set;}

    }

     public class AdditionalReqDtl {

        @AuraEnabled public String escalationReason  {get;set;}
        @AuraEnabled public String isEscalatedValue  {get;set;}
        @AuraEnabled public String priorExternalId  {get;set;}
        @AuraEnabled public String expPaymentValue  {get;set;}
        @AuraEnabled public String tatProvided  {get;set;}
        @AuraEnabled public Boolean days  {get;set;}
         @AuraEnabled public Boolean doesNotKnow{get;set;}
        @AuraEnabled public String Commentvalue  {get;set;}
    }


    public class ORSResultWrapper {
        @AuraEnabled public String caseId;
        @AuraEnabled public Map<String, SAECaseCreationController.ORSResultWrapper> orsClaimResults;
        @AuraEnabled public List<ResolvedORSClaimResult> resolvedORSClaimResults;
 		@AuraEnabled public List<UnresolvedORSClaimResult> unresolvedORSClaimResults;
    }


     public class ResolvedORSClaimResult {
          @AuraEnabled public String memberId;
          @AuraEnabled public String policyType;
          @AuraEnabled public String groupNo;
          @AuraEnabled public SAECaseCreationController.ORSResultWrapper result;
     }

    public class UnresolvedORSClaimResult {
          @AuraEnabled public String claimId;
          @AuraEnabled public SAECaseCreationController.ORSResultWrapper result;
    }
     public class SelectAssociateOutput {
        @AuraEnabled public String associateName {get;set;}
        @AuraEnabled public String associateId {get;set;}
    }


    public class StateInfo {
        public String claimNumber  { get; set; }
	    public String policyNumber  { get; set; }
        public String AddInfoOrginSubType  { get; set; }
   		public String TaxId  { get; set; }
        public String mnf  { get; set; }
        public String mnfExternalId  { get; set; }
        public Boolean providerNotFound  { get; set; }
        public String pnfExternalId  { get; set; }
        String acetCaseID { get; set; }
        Boolean isResolved { get; set; }
        public List<UniquePolicyToClaims> resolvedCaseClaims{ get; set; }
	}

}