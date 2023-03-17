/**
* Author: Sai Kolluru
* Description : Controller class to be used by Dahsboard-->Tools and Resources card to get data Urls for all external links
* Date Created: 06/08/2020
*/
public without sharing class ADBContactHistoryController{
    //	to get the member engagement history by icue id or xrefId
    @AuraEnabled
    public static ADBMemEngagementUIWrapper getMemEngagementHistory(String xrefId){
        ADBMemEngagementUIWrapper wrapper = new ADBMemEngagementUIWrapper();
        try{
            String req = '{ "memberVO":{ "sourceMemberID" : "' + xrefId + '" } }';
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBMemEngagementHistoryEndpoint',req,null);
            HttpResponse response = wsCallOutFW.getResponse();						
            if(response!=null && response.getStatusCode()==200)
            	wrapper = prepareHistoryUI((ADBMemEngagementHistoryWrapper)JSON.deserialize(response.getBody(), ADBMemEngagementHistoryWrapper.class));
            else
                wrapper.systemErrorMsg = response.getStatus();
            System.debug('history res : ' + wrapper);
        }catch(Exception e){
            System.debug('ERROR at ADBContactHistoryController.getMemEngagementHistory : ' + e.getMessage());
            wrapper = new ADBMemEngagementUIWrapper();
            wrapper.systemErrorMsg = e.getMessage();
        }
        return wrapper;
    }
    
    //	to get the detail of a given engagement
    @AuraEnabled
    public static ADBMemEngagementDetailsWrapper getMemEngagementDetails(String engagementId){
        ADBMemEngagementDetailsWrapper detailWrapper = new ADBMemEngagementDetailsWrapper();
        try{
            String req = '{ "engagementVO":{ "engagementID" : "' + engagementId + '" } }';
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBMemEngagementDetailsEndpoint',req,null);
            HttpResponse response = wsCallOutFW.getResponse();
            if(response != null && response.getStatusCode()==200)
                detailWrapper = prepareDetailUI((ADBMemEngagementDetailsWrapper)JSON.deserialize(response.getBody(), ADBMemEngagementDetailsWrapper.class));
            else
                detailWrapper.systemErrorMsg = response.getStatus();

            ADBMemEngagementDetailsWrapper notes = getMemNotes(engagementId);
            detailWrapper.response = notes.response;
            detailWrapper.notesErrorMsg = notes.notesErrorMsg;
            System.debug('detail res: ' + detailWrapper);
        }catch(Exception e){
			System.debug('ERROR at ADBContactHistoryController.getMemEngagementDetails : ' + e.getMessage() + ' : ' + e.getStackTraceString());
            detailWrapper = new ADBMemEngagementDetailsWrapper();
            detailWrapper.systemErrorMsg = e.getMessage();
        }
        return detailWrapper;
    }
    
    //	get the engagement notes
    private static ADBMemEngagementDetailsWrapper getMemNotes(String engId){
        ADBMemEngagementDetailsWrapper wr = new ADBMemEngagementDetailsWrapper();
        try{
            Map<String, String> params = new Map<String, String>();
            params.put('engageID', engId);
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBMemEngagementNotesEndpoint',null,params);
            HttpResponse response = wsCallOutFW.getResponse();
            if(response != null && response.getStatusCode()==200){
                //	Checking if there are multiple notes or a single note(comes as a list or single object)
                String res = response.getBody();
                Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(res);
                Map<String, Object> resMap = (Map<String, Object>)responseMap.get('response');
                Map<String, Object> resBodyMap = (Map<String, Object>)resMap.get('responseBody');
                Map<String, Object> memAttrMap = (Map<String, Object>)resBodyMap.get('memberAttributes');
                System.debug('responseBody : ' + memAttrMap.get('noteDetails'));
                Boolean isList = (memAttrMap.get('noteDetails') instanceof List<Object>);

                if(isList)
                    res = res.replace('noteDetails', 'lstNoteDetails');

                wr = (ADBMemEngagementDetailsWrapper)JSON.deserialize(res, ADBMemEngagementDetailsWrapper.class);
            }else
                wr.notesErrorMsg = System.Label.ADB_No_Mem_Eng_Notes;
        }catch(Exception e){
		wr.notesErrorMsg = System.Label.ADB_No_Mem_Eng_Notes;
            System.debug('ERROR at ADBContactHistoryController.getMemNotes : ' + e.getMessage() + ' : ' + e.getStackTraceString());
        }
        return wr;
    }

    //	prepare the UI wrapper from engagement history response
    private static ADBMemEngagementUIWrapper prepareHistoryUI(ADBMemEngagementHistoryWrapper resp){
        ADBMemEngagementUIWrapper wrapper = new ADBMemEngagementUIWrapper();
        Map<String, String> types = getTypeMapping();	//getting all the type code to value translation
        Map<String, String> communications = getCommunicationMapping();	//getting all the communication code to value translation
        if(null!=resp && null!=resp.engagementHistorySummaryList){
            String[] openDateParts;
            String[] endDateParts;
            wrapper.histories = new List<ADBMemEngagementUIWrapper.History>();
            for(ADBMemEngagementHistoryWrapper.engagementHistorySummaryList summary : resp.engagementHistorySummaryList){
                ADBMemEngagementUIWrapper.History history = new ADBMemEngagementUIWrapper.History();
                ADBMemEngagementHistoryWrapper.EngagementVO ev = summary.engagementVO;
                
                if(null!=ev.startDateTime){
                    openDateParts = getDatePortionsByTimestamp(ev.startDateTime, ev.userTimeZone).split('\\|');
        			Datetime dt = Datetime.newInstance(ev.startDateTime);
                    if(null!=openDateParts){
                        history.openedDate = openDateParts[0];
                        history.openedTime = openDateParts[1];
                        history.openedDateTime = ev.startDateTime;
                    }
                }
                if(null!=ev.endDateTime){
                    endDateParts = getDatePortionsByTimestamp(ev.endDateTime, ev.userTimeZone).split('\\|');
                    if(null!=endDateParts){
                        history.closedDate = endDateParts[0];
                        history.closedTime = endDateParts[1];
                        history.closedDateTime = ev.endDateTime;
                    }
                }
                history.status = (ev.statusOpen) ? 'Open' : ((ev.statusClosed) ? 'Closed' : '');
                history.createdBy = ev.createUserID;
                history.type = (types.containsKey(summary.channelSourceType)) ? types.get(summary.channelSourceType) : '';
                history.communication = (communications.containskey(summary.engageCmnctCategoryType)) ? communications.get(summary.engageCmnctCategoryType) : '';
                history.engagementId = ev.engagementID;
                wrapper.histories.add(history);
            }
        }else
            wrapper.systemErrorMsg = System.Label.ADB_ContactHistryNoDataMsg;
        return wrapper;
    }
    
    //	prepare the UI wrapper from engagement detail response
    private static ADBMemEngagementDetailsWrapper prepareDetailUI(ADBMemEngagementDetailsWrapper resp){
        if(resp!=null && resp.engagementDetails!=null && resp.engagementDetails.communicationTransactionList!=null &&
          !resp.engagementDetails.communicationTransactionList.isEmpty()){
            ADBMemEngagementDetailsWrapper.CommunicationTransactionVO cvo = resp.engagementDetails.communicationTransactionList.get(0).communicationTransactionVO;
            List<ADBMEType__mdt> md = [SELECT Type_Value__c FROM ADBMEType__mdt WHERE Type_Code__c =: cvo.channelSourceType LIMIT 1];
            if(!md.isEmpty())
            	resp.engagementDetails.engagementVO.engagementStatusType = md[0].Type_Value__c;

            List<ADBMECategory__mdt> ctgry = [SELECT Value__c FROM ADBMECategory__mdt WHERE Code__c =: cvo.engageCmnctCategoryType];
            if(!ctgry.isEmpty())
                resp.engagementDetails.engagementVO.engagementCategoryType = ctgry[0].Value__c;
        }
        return resp;
    }

    private static String getDatePortionsByTimestamp(Long t, String timeZone){
        Datetime dt = Datetime.newInstance(t);        
        //	Once the ICUE is able to confirm the time conversion logic, timezone in below code need to be replaced with
        //	the value coming in the response
        String convDate = dt.format('MM/dd/yyyy hh:mm:ss aa', timeZone);
        return convDate.replaceFirst(' ', '|');
    }

    //	get the ChannelSourceType translation to populate dashboard UI
    private static Map<String, String> getTypeMapping(){
        Map<String, String> mpTypes = new Map<String, String>();
        for(ADBMEType__mdt md : [SELECT Type_Code__c, Type_Value__c FROM ADBMEType__mdt])
            mpTypes.put(md.Type_Code__c, md.Type_Value__c);

        return mpTypes;
    }

    //	get the engageCmnctCategoryType translation to populate dashboard UI
    private static Map<String, String> getCommunicationMapping(){
        Map<String, String> mpComm = new Map<String, String>();
        for(ADBMECategory__mdt md : [SELECT Code__c, Value__c FROM ADBMECategory__mdt])
            mpComm.put(md.Code__c, md.Value__c);

        return mpComm;
    }
}