public without sharing class ACET_GetCachedAuthTokensBatch implements Database.Batchable < sObject > , Database.AllowsCallouts, Database.Stateful 
{
    public String serviceName;
    public Integer minutesFromNow = 0;
    public Boolean overrideDefaultCheck = true;
    public Map<String, set<String>> mWSOrgList = new Map<String, set<String>>();
    Map<String, Integer> mapJobnameMinsToSchedule = new Map<String, Integer>();
    public Boolean altConstructor = false;
   
    public ACET_GetCachedAuthTokensBatch(String serviceName, Boolean overrideDefaultCheck) 
    {
        this.serviceName = serviceName;
        this.overrideDefaultCheck = overrideDefaultCheck;
    }
    
    public ACET_GetCachedAuthTokensBatch(Map<String, set<String>> mWSOrgList , Boolean overrideDefaultCheck) 
    {
        this.mWSOrgList = mWSOrgList;
        this.overrideDefaultCheck = overrideDefaultCheck;
        altConstructor = true;
    }
    public Database.QueryLocator start(Database.BatchableContext BC) 
    {   
        System.debug('ACET_GetCachedAuthTokensBatch: start: mWSOrgList: '+mWSOrgList);
        if(altConstructor)
        {
            List<String> listService = new List<String>();
            listService.addAll(mWSOrgList.keyset());
            serviceName = listService[0];
            System.debug('altConstructor: serviceName: '+serviceName);
        }
        
        System.debug('@@ ACET_GetCachedAuthTokensBatch: start: serviceName: ' + serviceName);
        String query = 'SELECT Id, Name FROM WebserviceConfigurations__c WHERE Name= \'' + serviceName + '\'';
        System.debug('@@ ACET_GetCachedAuthTokensBatch: start: query: ' + query);
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List < sObject > scope) {
        System.debug('execute: '+scope);
        Integer counter = 1;
        for (sObject s: scope) {            
                mapJobnameMinsToSchedule = callOut(mWSOrgList, overrideDefaultCheck);               
            	System.debug('mapJobMinsToSchedule: '+mapJobnameMinsToSchedule);            
        }
    }

    public void finish(Database.BatchableContext BC) {
        System.debug('@@ ACET_GetCachedAuthTokensBatch: finish: serviceName: ' + serviceName);  
        System.debug('@@ACET_GetCachedAuthTokensBatch: finish: mapJobnameMinsToSchedule.keyset(): ' + mapJobnameMinsToSchedule.keyset());          
        try 
        {
            List<CronTrigger> listCTRecords = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name IN: mapJobnameMinsToSchedule.keyset() AND State != 'DELETED'];
            System.debug('listCTRecords: '+listCTRecords);
            
            for(CronTrigger ct: listCTRecords)
            {
            	System.abortJob(ct.Id);
            }
        } catch (QueryException qe) {
            System.debug('@@ ACET_GetCachedAuthTokensBatch: finish: "no existing batchjob found with this name" qe: ' + qe);
        }
        
        for(String jobname: mapJobnameMinsToSchedule.keyset())
        {	
             String extractOrgname = jobname.substringAfter('-');
             System.debug('extractOrgname: '+extractOrgname);          
              
             Set < String > orgList = new Set <String> ();
             orgList.add(extractOrgname);            
             mWSOrgList.put(serviceName, orgList);             
             Integer minutesFromNow = mapJobnameMinsToSchedule.get(jobname);
             
            if (minutesFromNow == 0)
            {	
               system.debug('Job scheduled: '+jobName);
               System.scheduleBatch(new ACET_GetCachedAuthTokensBatch(mWSOrgList,true), jobName, 1, 1);
            } 
            else 
            {	
                system.debug('Job scheduled: '+jobName);
                System.scheduleBatch(new ACET_GetCachedAuthTokensBatch(mWSOrgList,true), jobName, minutesFromNow, 1);                
            }
        }
           
    }
    public static Map<String, Integer> callOut(Map<String, set<String>> mWebserviceOrgList, Boolean overrideDefaultCheck) {
        ACET_WebserviceCalloutFramework wsCallOut = new ACET_WebserviceCalloutFramework();
        Map<String, HttpResponse> mapWSOrgHttpRes = new Map<String, HttpResponse>();           
        Set < String > orgList = new Set < String > ();
        Map<String, Integer> mapJobnameMinsToSchedule = new Map<String, Integer>();
           
        mapWSOrgHttpRes = wsCallOut.getScheduledAuthToken(mWebserviceOrgList, overrideDefaultCheck);    
        
        System.debug('callOut: mapWSOrgHttpRes: '+mapWSOrgHttpRes);
        
        for(String jobname : mapWSOrgHttpRes.keySet())
        {	            
            Integer minsFromNow = 0;
            HttpResponse httpRes = mapWSOrgHttpRes.get(jobname);
            Integer statusCode = httpRes.getStatusCode();
            if (statusCode == 200) 
            {
                Map < String, Object > oAuthResponseMap = (Map <String, Object > ) JSON.deserializeUntyped(httpRes.getBody());
                Integer secondsFromNow = oAuthResponseMap.containsKey('expires_in') ? (Integer) oAuthResponseMap.get('expires_in') : 0;
                minsFromNow = secondsFromNow / 60;
            }            
            mapJobnameMinsToSchedule.put(jobName, minsFromNow);            
        }  
        
        System.debug('callOut: mapJobnameMinsToSchedule: '+mapJobnameMinsToSchedule);
        return mapJobnameMinsToSchedule;
    }
}

//Run following block of statements in Developer Console to schedule the first Stargate batch job
/* 
Set <String> orgList = new Set <String>();
Map<String, HttpResponse> mapWSOrgHttpRes;
Map<String, set<String>> mWSOrgList = new Map<String, set<String>>();
mWSOrgList.put('StarGateTokenAPI',orgList);
System.scheduleBatch(new ACET_GetCachedAuthTokensBatch(mWSOrgList,false), 'First Job Cache job', 1, 1);
*/