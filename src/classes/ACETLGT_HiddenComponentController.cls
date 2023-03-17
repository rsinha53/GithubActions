public without sharing class ACETLGT_HiddenComponentController {
    
    @AuraEnabled
    public static void createCacheInSF(string allTabInfo){
        system.debug('----allTabInfo--->>'+allTabInfo);
        cache.Session.put('local.acetqa.LightningConsole', allTabInfo);
        system.debug('----BOOL--->>'+cache.Session.contains('local.acetqa.LightningConsole'));
        if (cache.Session.contains('local.acetqa.LightningConsole')) {
            String cachedLightningConsoleValue = (String)Cache.Session.get('local.acetqa.LightningConsole');
        }
    }
}