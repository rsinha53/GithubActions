public class ACETLGT_CirrusControllerLoad {
    
    /*@AuraEnabled
    public static void setMemberId(string MemberId, string landingPageinCirrus, string subjectTyp, string topicName, string groupId) {
        system.debug('>>'+MemberId);
        system.debug('~~~setmem'+MemberId+landingPageinCirrus+subjectTyp+topicName+groupId);
        //this.MemberId = MemberId;
        CIRRUSURL = GenerateCIRRUSURL(MemberId,landingPageinCirrus,subjectTyp,topicName,groupId);
    }*/
    
    /*
    public String getMemberId(){
        return MemberId; 
    }
    
    string GroupId='';
    public void setGroupId(string GroupId) {
        system.debug('>>'+GroupId);
        system.debug('~~~setgrp'+MemberId+landingPageinCirrus+subjectTyp+topicName+groupId);
        this.GroupId= GroupId;
    }
    
    public String getGroupId(){
        return GroupId; 
    }
	*/
    

    public static String GenerateCIRRUSURL(String MemberId, String landingPage, String subjectType,String topic, String groupId) {
      system.debug(LoggingLevel.INFO, '~~~MemberId@@@ ' + MemberId+subjectType);
        groupId=(groupId!=null)?groupId:'';
        if(subjectType == 'Group/Employer' && landingPage == 'memberDetail'){
            if(topic == 'Enroll Subscriber')
                    landingPage = 'memberEntry';
                else
            landingPage = 'memberGroup';
        }/*else{
            
            landingPage = 'memberDetail';
        }*/
        system.debug('~~~method'+landingPage+MemberId+subjectType+topic+groupId);
      
        string URLEncodeData;
        String OrgInstanceURL = String.valueof(URL.getSalesforceBaseUrl().toExternalForm()); 
        String OrgName = ACETUtility.GetOrgName();
        System.debug('OrgName::'+OrgName);
      
        System.debug('All::'+ACETOrgNameToSwivelEndpointMap__c.getall().values());
        System.debug('dev one::'+ACETOrgNameToSwivelEndpointMap__c.getValues('d1_CIRRUSWrapURL'));
        System.debug('dev one::'+ACETOrgNameToSwivelEndpointMap__c.getValues(OrgName + '_CIRRUSWrapURL'));        
        ACETOrgNameToSwivelEndpointMap__c CIRRUSWrapMap = new ACETOrgNameToSwivelEndpointMap__c();        
        CIRRUSWrapMap =  ACETOrgNameToSwivelEndpointMap__c.getValues(OrgName + '_CIRRUSWrapURL');
        System.debug('CIRRUSWrapMap.Swivel_Endpoint__c::'+ CIRRUSWrapMap.Swivel_Endpoint__c);        
        String CIRRUSWrapURL = CIRRUSWrapMap.Swivel_Endpoint__c;
        ACETWrapEncryptionKey__c ACETWrapEncryptionKey = ACETWrapEncryptionKey__c.getValues(OrgName + '_CirrusEncryptionKey');
        String EncryptionKey = ACETWrapEncryptionKey.Key__c;
        String AlgorithmName = ACETWrapEncryptionKey.Algorithm_Name__c;
        system.debug(LoggingLevel.INFO, 'OrgInstanceURL: ' + OrgInstanceURL + ', CIRRUSWrapURL: ' + CIRRUSWrapURL + ', EncryptionKey: ' + EncryptionKey);
        String tempUrl = CIRRUSWrapURL ;
        String CIRRUSQS = String.format(CIRRUSWrapURL , new List<String>{MemberId,groupId,landingPage}); 
        system.debug('CIRRUSQS:::'+CIRRUSQS ); 
        
        Integer AppSourceIdx = CIRRUSQS.indexOf('affiliationExternalID=');
        String CIRRUSQSTemplateEnc = CIRRUSQS.right(CIRRUSQS.length() - AppSourceIdx);
        
        system.debug('~~~'+AppSourceIdx +'~~~'+CIRRUSQSTemplateEnc );
        String CIRRUSQSEncrypted = ACETURLEncryptionUtility.GetEncryptedValue(EncryptionKey, AlgorithmName, CIRRUSQSTemplateEnc);
        system.debug(LoggingLevel.INFO, 'CIRRUSQS: ' + CIRRUSQS + ', CIRRUSQSEncrypted: ' + CIRRUSQSEncrypted);
        list<string> relayStateEncode = CIRRUSQS.split('RelayState=');
        system.debug(':::Take First'+relayStateEncode+'::::'+relayStateEncode[1].split('affiliationExternalID='));
        URLEncodeData =  EncodingUtil.urlEncode (CIRRUSQSEncrypted, 'UTF-8');
        URLEncodeData = relayStateEncode[1].split('affiliationExternalID=')[0] + URLEncodeData ;
        system.debug(':::'+URLEncodeData );
        CIRRUSWrapURL = OrgInstanceURL + relayStateEncode[0]+'RelayState=' + EncodingUtil.urlEncode(URLEncodeData , 'UTF-8');
        system.debug('CIRRUSWrapURL:::'+CIRRUSWrapURL);
        return CIRRUSWrapURL;
    
    }

}