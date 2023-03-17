public class Utils {
    
    public static String getQueryParam(String key, String defaultValue) {
                key = toSafeValue(key, '');
        if(''.equals(key)) return defaultValue;
        return toSafeValue(ApexPages.currentPage().getParameters().get(key), defaultValue);
    }
    
    public static String toSafeValue(String s, String value) {
        s = s == null ? '' : s.trim();
        return ''.equals(s) ? value : s;
    }
    
    public static Map<String,String> convertReqURLToReqParamMap(String sURL)
    {	
        system.debug('Util:convertReqURLToReqMap:sURL= '+sURL);
        sURL = sURL.removeStart('?');	
		system.debug('new sURL= '+sURL);
        Map<String,String> mapReqURL = new Map<String,String>();        
        
        if(String.isNotBlank(sURL))
        {
            List<String> listURL = sURL.split('&');        
            system.debug('listURL= '+listURL);        
            for(String token: listURL)
            {	
                system.debug('token: '+token);
                Integer idx = token.indexOf('=');
                system.debug('idx: '+idx);               
                if(idx!=-1)
                {
                    String skey = token.subStringBefore('=');
                    system.debug('sKey: '+skey);                    
                    String sValue = token.subStringAfter('=');
                    system.debug('before sValue: '+sValue);
                    if(sValue.equalsIgnoreCase('M%R'))   sValue='M&R';
                    if(sValue.equalsIgnoreCase('E%I'))	 sValue='E&I';
                    system.debug('after sValue: '+sValue);
                    mapReqURL.put(skey,svalue);
                }
            }    
    		system.debug('mapReqURL: '+mapReqURL); 
		}        
        return mapReqURl;        
    }

}