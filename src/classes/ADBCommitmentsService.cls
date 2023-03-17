public without sharing class ADBCommitmentsService {
    // method to call actual commitments service - Sunil
    @AuraEnabled
    public static ADBCommitmentsUIWrapper callCommitmentsService(String xrefId){
        ADBCommitmentsServiceResponseWrapper rw = new ADBCommitmentsServiceResponseWrapper();
        ADBCommitmentsUIWrapper wrapper = new ADBCommitmentsUIWrapper();
        wrapper.commitments = new List<ADBCommitmentsUIWrapper.commitments>();
        List<ADBCommitmentsUIWrapper.commitments> overTwelveMonthData = new List<ADBCommitmentsUIWrapper.commitments>();
        wrapper.tweleveMonthDataAvailable = false;
        ADBMCommitmentsServiceRequestWrapper request = new ADBMCommitmentsServiceRequestWrapper();
        request.memberDetailRequest = new ADBMCommitmentsServiceRequestWrapper.memberDetailRequest();
        request.memberDetailRequest.requestHeader = new ADBMCommitmentsServiceRequestWrapper.requestHeader();
        request.memberDetailRequest.icueUserCDxRefIdentifierType = new ADBMCommitmentsServiceRequestWrapper.icueUserCDxRefIdentifierType();
        request.memberDetailRequest.requestHeader.applicationName = 'ACET';
        request.memberDetailRequest.icueUserCDxRefIdentifierType.cdxRefId = xrefId;
        String serializedBody = JSON.serialize(request);
        system.debug('serialzed body'+ serializedBody);
        try {
            // Call commitments service
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBCommitmentsServiceEndpoint', serializedBody,null);
            HttpResponse response = wsCallOutFW.getResponse();
            system.debug('response - Commitments Service'+response.getBody());
            if(response.getStatusCode() == 200){
                //	Handling the single vs list of memberContacts response format
                String res = response.getBody();
                Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(res);
                System.debug('commitments result : ' + responseMap);
                Map<String, Object> commitmentsResponse = (Map<String, Object>)responseMap.get('memberAssignmentsResponse');
                System.debug('Commitments Response : ' + commitmentsResponse.get('memberAssignments'));
				if(null != commitmentsResponse.get('memberAssignments')){														 
                Boolean isList = (commitmentsResponse.get('memberAssignments') instanceof List<Object>);
                if(isList) {
                    rw = ADBCommitmentsServiceResponseWrapper.parse(res);
                    if(rw!=null && rw.memberAssignmentsResponse !=null && rw.memberAssignmentsResponse.memberAssignments!= null){
                        Date comparingDate;
                        for(Integer i=0; i < rw.memberAssignmentsResponse.memberAssignments.size(); i++){
                            comparingDate = null;	//	resetting the date for next iteration
                            ADBCommitmentsUIWrapper.commitments commitments= new ADBCommitmentsUIWrapper.commitments();
                            commitments.create_Date = (String)rw.memberAssignmentsResponse.memberAssignments[i].createDate;
                            commitments.commitment =(rw.memberAssignmentsResponse.memberAssignments[i].assignmentDescriptor!=null && rw.memberAssignmentsResponse.memberAssignments[i].assignmentDescriptor.contains('-'))?rw.memberAssignmentsResponse.memberAssignments[i].assignmentDescriptor.substringAfter('-'):rw.memberAssignmentsResponse.memberAssignments[i].assignmentDescriptor;
                            commitments.due_Date = (String)rw.memberAssignmentsResponse.memberAssignments[i].dueDate;
                            //	Checking for 12 month period
                            if(String.isNotBlank(commitments.create_Date)) {
                                Date tempDate = Date.valueOf(commitments.create_Date);
                                String strTempDate = tempDate.format();
                                comparingDate = Date.parse(strTempDate);
                            }
                            if(comparingDate != NULL && comparingDate.daysBetween(Date.today()) <= 365) {
                                wrapper.commitments.add(commitments);	//	add if within the year
                            } else {
                                overTwelveMonthData.add(commitments);	//	collect any over 12 month data for UI messaging
                            }
                        }
                    }
                }
                else{
                    res = res.replace('"memberAssignments"', '"singleMemberAssignment"');
                    System.debug('new res : ' + res);
                    rw = ADBCommitmentsServiceResponseWrapper.parse(res);
                    System.debug('singleObject : ' + rw);
                    Date comparingDate;
                    ADBCommitmentsUIWrapper.commitments commitments= new ADBCommitmentsUIWrapper.commitments();
                    commitments.create_Date = (String)rw.memberAssignmentsResponse.singleMemberAssignment.createDate;
                    commitments.commitment =(rw.memberAssignmentsResponse.singleMemberAssignment.assignmentDescriptor!= null && rw.memberAssignmentsResponse.singleMemberAssignment.assignmentDescriptor.contains('-') == true)?rw.memberAssignmentsResponse.singleMemberAssignment.assignmentDescriptor.substringAfter('-'):rw.memberAssignmentsResponse.singleMemberAssignment.assignmentDescriptor;
                    commitments.due_Date = (String)rw.memberAssignmentsResponse.singleMemberAssignment.dueDate;
                    //	Checking for 12 month period
                    if(String.isNotBlank(commitments.create_Date)) {
                        Date tempDate = Date.valueOf(commitments.create_Date);
                        String strTempDate = tempDate.format();
                        comparingDate = Date.parse(strTempDate);
                    }
                    if(comparingDate != NULL && comparingDate.daysBetween(Date.today()) <= 365) {
                        wrapper.commitments.add(commitments);	//	add if within the year
                    } else {
                        overTwelveMonthData.add(commitments);	//	collect any over 12 month data for UI messaging
                    }
                }
                //	12 month period message configuration
                if(wrapper.commitments != null && wrapper.commitments.isEmpty() && overTwelveMonthData != null && !overTwelveMonthData.isEmpty()) {
                    wrapper.tweleveMonthDataAvailable = true;
                }
            } else{
                    system.debug('exception erros-->'+(Map<String,Object>)commitmentsResponse.get('responseHeader'));
                    if(null != commitmentsResponse.get('responseHeader')){
                        Map<String,Object> errObj = (Map<String,Object>)commitmentsResponse.get('responseHeader');
                        if(errObj.get('serviceCallStatusCode') != null && errObj.get('serviceCallStatus') != null){
                            system.debug('final error'+errObj.get('serviceCallStatus'));
                            wrapper.systemErrorMsg = (String)errObj.get('serviceCallStatus');
                        }
                    }
                }
            }else{
                system.debug('in error block');
                wrapper.systemErrorMsg = response.getStatus();
            }
        }
        catch(Exception ex) {
            System.debug('ERROR : Commitments Service : ' + ex.getMessage());
        }
        return wrapper;
    }  
}