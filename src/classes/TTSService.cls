@RestResource(urlMapping = '/TTSInfo/v1')
global with sharing class TTSService {
	
    @HttpGet
	global static String doGet() {
        
        List<TTS_Access__c> ttsList = [SELECT Topic__c, Type__c, Subtype__c, Limit_To_Roles__c, Limit_To_Profiles__c, TTSAccessExternalID__c, Id FROM TTS_Access__c];

        // Creating a map of TTSAcces object as the key, with the relavant Entitlement and Routing configurations as list of values
   		Map<Id, TTSWrapper> enAsgnMap = new Map<Id, TTSWrapper>();

        for(TTS_Access__c tts : ttsList) {
          TTSWrapper wrp = new TTSWrapper();
          wrp.ttsId = tts.Id;
          wrp.externalId = tts.TTSAccessExternalID__c;
          wrp.topic = tts.Topic__c;
          wrp.type = tts.Type__c;
          wrp.subType = tts.Subtype__c;
          wrp.profile = tts.Limit_To_Profiles__c;
          wrp.roles = tts.Limit_To_Roles__c;
          enAsgnMap.put(tts.Id, wrp);
        }
        
        List<EntitlementAssignment__c> entAssign = [SELECT TTS_Access__r.Topic__c, TTS_Access__r.Type__c, TTS_Access__r.Subtype__c, TTS_Access__r.Limit_To_Profiles__c, TTS_Access__r.Limit_To_Roles__c, TTS_Access__r.Id, TTS_Access__r.TTSAccessExternalID__c, EntitlementName__r.name FROM EntitlementAssignment__c where TTS_Access__r.Id != null];
		List<Routing_Configuration__c> routConf = [SELECT TTS_Access__r.Topic__c, TTS_Access__r.Type__c, TTS_Access__r.Subtype__c, TTS_Access__r.Limit_To_Profiles__c, TTS_Access__r.Limit_To_Roles__c, Queue_Name__c, Onshore_Restriction__c, Priority__c,  TTS_Access__r.Id, TTS_Access__r.TTSAccessExternalID__c, Id FROM Routing_Configuration__c where TTS_Access__r.Id != null];
       
        for(EntitlementAssignment__c easn : entAssign) {
            if(enAsgnMap.get(easn.TTS_Access__r.id) == null) {
                
                TTSWrapper ttsW = new TTSWrapper();
                
                ttsW.ttsId = easn.TTS_Access__r.id;
                ttsW.externalId = easn.TTS_Access__r.TTSAccessExternalID__c;
                ttsW.topic = easn.TTS_Access__r.Topic__c;
                ttsW.type = easn.TTS_Access__r.Type__c;
                ttsW.subType = easn.TTS_Access__r.Subtype__c;
                ttsW.profile = easn.TTS_Access__r.Limit_To_Profiles__c;
                ttsW.roles = easn.TTS_Access__r.Limit_To_Roles__c;
                
                List<EntitlementWrapper> entitleList = new List<EntitlementWrapper>();
                EntitlementWrapper entWrp = new EntitlementWrapper();
                entWrp.entitlementId = easn.EntitlementName__r.id;
                entWrp.entitlementName = easn.EntitlementName__r.name;
                entWrp.externalId = easn.TTS_Access__r.TTSAccessExternalID__c;
                entWrp.ttsId = easn.TTS_Access__r.Id;
                entitleList.add(entWrp);
                ttsW.entitlements = entitleList;
                
				enAsgnMap.put(easn.TTS_Access__r.id, ttsW);
                
            } else {
                TTSWrapper ttsW = enAsgnMap.get(easn.TTS_Access__c);
                List<EntitlementWrapper> entitleList = null;
                if(ttsW.entitlements == null) {
                    entitleList = new List<EntitlementWrapper>();
                    ttsW.entitlements = entitleList;
                }
                entitleList = ttsW.entitlements;
				EntitlementWrapper entWrp = new EntitlementWrapper();
                entWrp.entitlementId = easn.EntitlementName__r.id;
                entWrp.entitlementName = easn.EntitlementName__r.name;
                entWrp.externalId = easn.TTS_Access__r.TTSAccessExternalID__c;
                entWrp.ttsId = easn.TTS_Access__r.Id;
                entitleList.add(entWrp);
                ttsW.entitlements = entitleList;
                
                enAsgnMap.put(easn.TTS_Access__r.id, ttsW);
            }
        }

        for(Routing_Configuration__c easn : routConf) {
            if(enAsgnMap.get(easn.TTS_Access__r.id) == null) {
                TTSWrapper ttsW = new TTSWrapper();
                
                ttsW.ttsId = easn.TTS_Access__r.id;
                ttsW.externalId = easn.TTS_Access__r.TTSAccessExternalID__c;
                ttsW.topic = easn.TTS_Access__r.Topic__c;
                ttsW.type = easn.TTS_Access__r.Type__c;
                ttsW.subType = easn.TTS_Access__r.Subtype__c;
                ttsW.profile = easn.TTS_Access__r.Limit_To_Profiles__c;
                ttsW.roles = easn.TTS_Access__r.Limit_To_Roles__c;
            
				List<QueueWrapper> queueList = new List<QueueWrapper>();
            	QueueWrapper qwrp = new QueueWrapper();
            	qwrp.queueId = easn.Id;
            	qwrp.queueName = easn.Queue_Name__c;
                qwrp.priority = easn.Priority__c;
            	qwrp.onshoreRestriction = easn.Onshore_Restriction__c;
                qwrp.externalId = easn.TTS_Access__r.TTSAccessExternalID__c;
                qwrp.ttsId = easn.TTS_Access__r.Id;
            	queueList.add(qwrp);
            	ttsW.queue = queueList;
                
            } else {
                
				TTSWrapper ttsW = enAsgnMap.get(easn.TTS_Access__r.id);
                List<QueueWrapper> queueList = null;
                if(ttsW.queue == null) {
                    queueList = new List<QueueWrapper>();
                    ttsW.queue = queueList;
                }
                queueList = ttsW.queue;
                
                QueueWrapper qwrp = new QueueWrapper();
            	qwrp.queueId = easn.Id;
            	qwrp.queueName = easn.Queue_Name__c;
                qwrp.priority = easn.Priority__c;
            	qwrp.onshoreRestriction = easn.Onshore_Restriction__c;
                qwrp.externalId = easn.TTS_Access__r.TTSAccessExternalID__c;
                qwrp.ttsId = easn.TTS_Access__r.Id;
                queueList.add(qwrp);
                ttsW.queue = queueList;
                
                enAsgnMap.put(easn.TTS_Access__r.id, ttsW);
            }

        }
        List<String> test = new List<String>();
        
        TTSMaster master = new TTSMaster();
        master.ttsWrp = enAsgnMap.values();
        
		return JSON.serialize(master);

	}
}