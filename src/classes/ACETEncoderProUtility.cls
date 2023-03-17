/**
 * @name         :  ACETEncoderProUtility
 * @description  :  Helper for EncoderPro Webservice.
 * @author       :  Bhanu Jain
 * @createddate  :  14/11/2017
 **/


public without sharing class ACETEncoderProUtility{
    public static List<ACETEncoderProConfig__c> EPConfigs = ACETEncoderProConfig__c.getAll().values();

    /**
     * @name         :   getEncoderProValues
     * @description  :   This method/action will fetch the EncoderPro configuration
     * @param        :   void   
     * @return       :   void
     * @author       :  Bhanu Jain
     * @createddate  :  14/11/2017
     * @lastmodifiedby:  
     **/    
    public static Map<String,String> getEncoderProValues(){
        Map<String,String> codeTypeVsRegex = new Map<String,String>();
        for(ACETEncoderProConfig__c eachConfig : EPConfigs)  {
            if(eachConfig.type__c == 'CODETYPE'){
                codeTypeVsRegex.put(eachConfig.name,eachConfig.value__c);
            }
        }   
        return codeTypeVsRegex;
    }

    /**
     * @name         :   getCodeTypes
     * @description  :   Will bring all code types associated with code
     * @param        :   String code   
     * @return       :   List<String> codeTypeList
     * @author       :  Bhanu Jain
     * @createddate  :  14/11/2017
     * @lastmodifiedby:  
     **/    
    /*public static List<String> getCodeTypes(String code){
        Map<String,String> codeTypeVsRegex = getEncoderProValues();
        List<String> codeTypes = new List<String>();
        system.debug('codeTypeVsRegex >>>>  '+codeTypeVsRegex);
        for(String codeType : codeTypeVsRegex.keySet()){
            String patternStr = codeTypeVsRegex.get(codeType).unescapejava();
            Boolean matched = Pattern.matches(patternStr, code);
            system.debug(codeType + '#####'+ code);
            if(matched){
                codeTypes.add(codeType.replace('_REGEX','').toLowerCase()); 
                system.debug('matched !!!');
            }
            else{
                System.debug('Not Matched!');
            }
        }
        return codeTypes;
    }*/

    /**
     * @name         :   getCodeTypes
     * @description  :   Will bring all code types associated with each code
     * @param        :   List<String> codeList
     * @return       :   Map<String,List<String>> codeVsCodeTypesMap
     * @author       :  Bhanu Jain
     * @createddate  :  14/11/2017
     * @lastmodifiedby:  
     **/
    public static Map<String,List<String>> getCodeTypes(List<String> codeList){
        Map<String,String> codeTypeVsRegex = getEncoderProValues();
        Map<String,List<String>> codeVsCodeTypesMap = new Map<String,List<String>>();
        for(String codeType : codeTypeVsRegex.keySet()){
            String patternStr = codeTypeVsRegex.get(codeType).unescapejava();
            for(String code : codeList){
                Boolean matched = Pattern.matches(patternStr, code);
                if(matched){
                    if(codeVsCodeTypesMap.get(code) == null){
                        codeVsCodeTypesMap.put(code, new List<String>());
                    }
                    codeVsCodeTypesMap.get(code).add(codeType.replace('_REGEX','').toLowerCase());
                }
                else{
                    System.debug('Not Matched!');
                }
            }
        }
        return codeVsCodeTypesMap;
    }
    /**
     * @name         :   getCodeDescriptionType
     * @description  :   Will bring the type of the code description
     * @param        :   void
     * @return       :   String codeDesctype
     * @author       :  Bhanu Jain
     * @createddate  :  14/11/2017
     * @lastmodifiedby:  
     **/
    public static String getCodeDescriptionType(){
        String codeDesctype;
        for(ACETEncoderProConfig__c eachConfig : EPConfigs)  {
            if(eachConfig.type__c == 'DESCTYPE'){
                codeDesctype = eachConfig.value__c;

            }
        }
        return codeDesctype;    
    }
    /**
     * @name         :   getBasicAuthenticationBase64
     * @description  :   Will bring base 64 encoded athentication
     * @param        :   void
     * @return       :   String basicAuthBlobEncoded
     * @author       :  Bhanu Jain
     * @createddate  :  14/11/2017
     * @lastmodifiedby:  
     **/
    public static String getBasicAuthenticationBase64(){
        String userName ;
        String password ;
        for(ACETEncoderProConfig__c eachConfig : EPConfigs)  {
            if(eachConfig.type__c == 'USERNAME'){
                userName = eachConfig.value__c;
            }
            if(eachConfig.type__c == 'PASSWORD'){
                password = eachConfig.value__c;
            }       
        }   
        Blob basicAuthBlob = Blob.valueOf(userName + ':' + password);
        String basicAuthBlobEncoded = EncodingUtil.base64Encode(basicAuthBlob);

        return basicAuthBlobEncoded;
    }
}