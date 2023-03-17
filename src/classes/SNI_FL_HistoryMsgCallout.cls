public without sharing class SNI_FL_HistoryMsgCallout {
    @AuraEnabled
    public static SNI_FL_HistoryMessageController.wsReturnWrapper getsingleMsg(String requestType, String personId){
        SNI_FL_HistoryMessageController.wsReturnWrapper retWrap = new SNI_FL_HistoryMessageController.wsReturnWrapper();
        list<SNI_FL_HistoryMessageController.singleHistMsgWrapper> returnMsg =
            new list<SNI_FL_HistoryMessageController.singleHistMsgWrapper>();
        String Fname = userinfo.getFirstName();
        String Lname = userinfo.getLastName();
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = 'HistoricalMessagesAPI';
        if(requestType == 'person'){
            wsCallOutFW.endpointExtraPath = '/messages/member/person-accounts/'+personId+'/v1';
        } else if(requestType == 'family'){
            wsCallOutFW.endpointExtraPath = '/messages/advisor/family-accounts/'+personId+'/v1';
        }
        else if(requestType == 'providers'){
            wsCallOutFW.endpointExtraPath = '/messages/provider/member-affiliations/'+personId+'/v1';
        }
        else if(requestType == 'memberAffiliation'){
           wsCallOutFW.endpointExtraPath = '/messages/provider/member-affiliations/'+personId+'/v1';
        }
        HttpResponse httpResponse = wsCallOutFW.getResponse();
        retWrap.statusCode = httpResponse.getStatusCode();
        if(retWrap.statusCode == 200){
            if(httpResponse.getBody() != null && httpResponse.getBody() != ''){
                String body = httpResponse.getBody();
                if(body.contains('\"message\":\"')){
                    String[] msgSplit = body.split('\"message\":\"');
                    String finalJSON = '';
                    if(msgSplit != null){
                        for(Integer i = 0; i < msgSplit.size(); i++){
                            if(msgSplit[i].contains('"}')){
                                String[] endSplit = msgSplit[i].split('"}');
                                if(endSplit != null){
                                    for(Integer j = 0; j < endSplit.size(); j++){
                                        if(j == 0){
                                            endSplit[j] = endSplit[j].replace('\\','\\\\');
                                            endSplit[j] = endSplit[j].replace('\"','\\\"');
                                            endSplit[j] = endSplit[j].replace('\\\\n','\\n');
                                            endSplit[j] = endSplit[j].replace('\\\\r','\\r');
                                            endSplit[j] = endSplit[j].replace('\\\\b','\\b');
                                            endSplit[j] = endSplit[j].replace('\\\\t','\\t');
                                            finalJSON = finalJSON + '"message":"' + endSplit[j] + '"}';
                                        } else if(j+1 < endSplit.size()){
                                            finalJSON = finalJSON + endSplit[j] + '\"}';
                                        } else {
                                            finalJSON = finalJSON + endSplit[j];
                                        }
                                    }
                                }
                            } else {
                                finalJSON = finalJSON + msgSplit[i];
                            }
                        }
                        body = finalJSON;
                    }
                }
                PersonHistMsg msg = parse(body);
                list<Messages> msgList = new list<Messages>();
                if(msg.result.data[0].messages.size() >= 1){
                    for (Integer i = msg.result.data[0].messages.size()-1; i>= 0; i-- ) {
                        msg.result.data[0].messages[i].message = msg.result.data[0].messages[i].message.replace('\\\"', '\"');
                        msgList.add(msg.result.data[0].messages[i]);
                    }
                }
                for(Messages m:msgList){
                    SNI_FL_HistoryMessageController.singleHistMsgWrapper imsg= new SNI_FL_HistoryMessageController.singleHistMsgWrapper();
                    imsg.authorFirstName = m.authorFirstName;
                    imsg.authorLastName  = m.authorLastName; 
                    list<string> s = m.messageDateTime.split(' ');
                    list<string> sdt = s[0].split('-');
                    list<string> stt = s[1].split(':');
                    sdt.addall(stt);
                    list<integer> ine = new list<integer>();
                    for(string k: sdt){
                        integer a = integer.valueof(k);
                        ine.add(a);
                    }
                    imsg.messageDateTime = Datetime.newInstancegmt(ine[0],ine[1],ine[2],ine[3],ine[4],ine[5]);
                    imsg.message = m.message;
		    Boolean lastNameMatch = false;
                    if(m.authorLastName.length()>1){
                        if(Lname.toLowerCase() == m.authorLastName.toLowerCase()){
                            lastNameMatch = true; 
                        }
                    } else if(m.authorLastName.length() == 1) {
                        if(Lname.left(1).toLowerCase() == m.authorLastName.left(1).toLowerCase()){
                            lastNameMatch = true;
                            //This adds a period at the end of the initial
                            imsg.authorLastName += '.';
                        }
                    }
                    if(Fname.toLowerCase() == m.authorFirstName.toLowerCase() && lastNameMatch == true){
                        imsg.UserChange = '0';
                    }else{
                        imsg.UserChange = '1';
                    }
                    returnMsg.add(imsg);
                }
                retWrap.returnMsg = returnMsg;
            } else {
                retWrap.statusMessage = 'No older messages available.';
            }
        } else if(retWrap.statusCode == 204){
            retWrap.statusMessage = 'No older messages available.';
        } else {
            retWrap.statusMessage = 'There has been an error retrieving your older messages. We are working to resolve the problem now. Please try again later.';
        }
        return retWrap;
    }
    public class providerMessage {
        public provResult result;
    }
    public class provResult {
        public List<provData> data;
    }
    public class provData {
        public List<provMessageThread> messageThreads;
    }
    public class provMessageThread{
        @AuraEnabled
        public String teamFirstName;
        @AuraEnabled
        public String teamLastName;
        @AuraEnabled
        public String lastMessageDateTime;
        @AuraEnabled
        public String memberAffiliationId;
    }
    public static providerMessage parseProvider(String json) {
        return (providerMessage) System.JSON.deserialize(json, providerMessage.class);
    }
    @AuraEnabled
    public static SNI_FL_HistoryMessageController.providerReturnWrapper getProviderAffMessages(String personId, Integer currentPage){
        SNI_FL_HistoryMessageController.providerReturnWrapper retWrap = new SNI_FL_HistoryMessageController.providerReturnWrapper();
        List<SNI_FL_HistoryMessageController.providerMessageWrapper> provWrap = new List<SNI_FL_HistoryMessageController.providerMessageWrapper>();
        ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework();
        wsCallOutFW.serviceName = 'HistoricalMessagesAPI';
        Integer offset = (currentPage - 1)*10;
        wsCallOutFW.endpointExtraPath = '/message-threads/provider/provider-affiliations/'+personId+'/v1?offset=' + offset + '&limit=10';
        HttpResponse httpResponse = wsCallOutFW.getResponse();
        retWrap.hasNext = false;
        retWrap.statusCode = httpResponse.getStatusCode();
        if(retWrap.statusCode == 200){
            if(httpResponse.getBody() != null && httpResponse.getBody() != ''){
                providerMessage prvResult = parseProvider(httpResponse.getBody());
                if(prvResult != null){
                    if(prvResult.result != null){
                        if(prvResult.result.data != null && prvResult.result.data.size() > 0){
                            for(provData dataList:prvResult.result.data){
                                if(dataList.messageThreads != null && dataList.messageThreads.size() > 0){
                                    for(provMessageThread provMsgItem:dataList.messageThreads){
                                        SNI_FL_HistoryMessageController.providerMessageWrapper provMsg = new SNI_FL_HistoryMessageController.providerMessageWrapper();
                                        provMsg.ListauthorName = (provMsgItem.teamFirstName != null && provMsgItem.teamLastName != null)?provMsgItem.teamFirstName + ' ' + provMsgItem.teamLastName:'';
                                        if(provMsgItem.lastMessageDateTime != null){
                                            provMsg.ListDateTime = datetime.valueOfGmt(provMsgItem.lastMessageDateTime);
                                        }
                                        provMsg.memberAffiliationId = (provMsgItem.memberAffiliationId != null)?provMsgItem.memberAffiliationId:'';
                                        provWrap.add(provMsg);
                                    }
                                    if(dataList.messageThreads.size() == 10){
                                        wsCallOutFW.endpointExtraPath = '/message-threads/provider/provider-affiliations/'+personId+'/v1?offset=' + (offset + 10) + '&limit=10';
                                        httpResponse = wsCallOutFW.getResponse();
                                        if(httpResponse.getStatusCode() == 200){
                                            if(httpResponse.getBody() != null && httpResponse.getBody() != ''){
                                                providerMessage prvResult1 = parseProvider(httpResponse.getBody());
                                                if(prvResult1 != null){
                                                    if(prvResult1.result != null){
                                                        if(prvResult1.result.data != null && prvResult1.result.data.size() > 0){
                                                            for(provData dataList1:prvResult1.result.data){
                                                                if(dataList1.messageThreads != null && dataList1.messageThreads.size() > 0){
                                                                    retWrap.hasNext = true;
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                retWrap.statusMessage = 'No older messages available.';
            }
        } else if(retWrap.statusCode == 204){
            retWrap.statusMessage = 'No older messages available.';
        } else {
            retWrap.statusMessage = 'There has been an error retrieving your older messages. We are working to resolve the problem now. Please try again later.';
        }
        retWrap.providerMessages = provWrap;
        return retWrap;
    }    
    public class Status {
		public List<Messages_Z> messages;
	}
	public class Messages {
		public String authorFirstName;
		public String authorLastName;
		public String messageDateTime;
		public String message;
	}
	public class PersonHistMsg {
		public Result result;
		public Status status;
	}
	public class Data {
		public List<Messages> messages;
	}
	public class Messages_Z {
		public String code;
		public String name;
		public String severity;
		public String description;
	}
	public class Result {
		public List<Data> data;
	}
	public static PersonHistMsg parse(String json) {
		return (PersonHistMsg) System.JSON.deserialize(json, PersonHistMsg.class);
	}
}