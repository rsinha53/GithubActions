/**
 * Author: Kavinda Inusha
 * Description : Utility service to invoke any Stargate web service
 * AuraEnabled : False
 * Created Date : 25 June 2020
 */
public class ACET_ProperUseWebService {

    static final Integer RESPONSE_SUCCESS_CODE = 200;     
    static final String PROPERUSE_RESOURCE = 'properUseAPI';  
    static final String PROPERUSE_JWT_CONFIG = 'ACETStargateJWTToken';

    public static Map<String, Object> getjwToken(String strJWTConfigName, String strAlgorithm){
        
        Map<String, Object> mapJWTConfig = new Map<String, Object>();
		String jwToken = '';
		Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
		String OrgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);
		String masterLabel = OrgName + '_' + strJWTConfigName; 
        
        List<ADB_JWT_Config__mdt> jwtConfigs = [SELECT Id, JWT_Key__c, JWT_Secret__c, Is_Mock_Data__c
		                                        FROM ADB_JWT_Config__mdt
		                                        WHERE MasterLabel = :masterLabel];
		if (!jwtConfigs.isEmpty()){
            ADBJWTGenerator jwt = new ADBJWTGenerator(strAlgorithm);
			String privateKey = jwtConfigs[0].JWT_Secret__c;
			String iss = jwtConfigs[0].JWT_Key__c;
			jwt.privateKey = EncodingUtil.base64Encode(Blob.valueOf(privateKey));
			jwt.iss = iss;
            jwtoken = jwt.issue();
            mapJWTConfig.put('jwtoken', jwtoken);
            mapJWTConfig.put('ismockdata',  jwtConfigs[0].Is_Mock_Data__c);
        }
         
		return mapJWTConfig;
    }

    public static void callProperUseService() {

        try {

            String endpoint = ADBWebService.getEndPoint(PROPERUSE_RESOURCE);
            system.debug('endpoint :: '+endpoint);
            String method = 'GET';
            Map<String, ACETOrgInstanceURLToOrgNameMap__c> OrgInstance2OrgNameMap = ACETOrgInstanceURLToOrgNameMap__c.getAll();
            String OrgName = Test.isRunningTest() ? 'dev' : ACETUtility.GetOrgName(OrgInstance2OrgNameMap);  
            
            Map<String, Object> mapJWTConfig = ACET_ProperUseWebService.getjwToken(PROPERUSE_JWT_CONFIG, 'HS256'); 
            
            String JwToken = (String)mapJWTConfig.get('jwtoken');
            system.debug('New JwToken ::: '+JwToken);
            Map<String, String> headers = new map<String, String> {
                'Authorization' => 'Bearer '+ JwToken ,
                'Content-Type' => 'application/json'
            };

            Boolean IsStaticResourseData = (Boolean)mapJWTConfig.get('ismockdata');
            System.debug('IsStaticResourseData :: '+IsStaticResourseData);
            HttpResponse response;

            if(IsStaticResourseData) {
                String searchparameter = 'ProperUseAPIResource';
                response = SAEUtils.getResponse(searchparameter);
            } else {
                response = ADBWebService.sendRequest(null, headers, endpoint, method);
            }
        
            String respStr = '';
            if(response.getStatusCode() == RESPONSE_SUCCESS_CODE) { 
                ACET_ProperUseWebService.proccessResponse(response.getBody());
            }

        } catch (Exception e) {
            System.debug(Logginglevel.ERROR, 'ACET_ProperUseWebService - callProperUseService():' + e.getStackTraceString());
            system.debug('Error ::'+e.getCause());
            system.debug('Error ::'+e.getMessage());
        }

    }

    public static void proccessResponse(String json){
        
        ACET_ProperUseDTO p = (ACET_ProperUseDTO) System.JSON.deserialize(json, ACET_ProperUseDTO.class);       
        Integer i=0;
        Map<String, String> newMap = new Map<String, String>();
        			   	
        for (ACET_ProperUseDTO.definedObligations val: p.ProperUse.DefinedObligations){
            
            Map<Object, Object> EIKeyToLevelsMap = new Map<Object, Object>();  
            Map<Object, Object> MRKeyToLevelsMap = new Map<Object, Object>();
            Map<Object, Object> LOBToValuesMap = new Map<Object, Object>();
            String globalJsonstring;
            
            if (val.ObligationSource == 'MORL'){
                
                for (ACET_ProperUseDTO.obligationRecords var: val.ObligationRecords){                    
					 i++;                  
                    //Prepare the Levels
                    String level7 = var.DataUseObligations.Level7;
                    String level5 = var.DataUseObligations.Level5;
                    String level3 = var.DataUseObligations.Level3;
                    
                    String finLevels = 'L7:'+level7+',L5:'+level5+',L3:'+level3;
                    
                    
                    List<String> pNumberList = var.RecordIdentifiers.PolicyNumbers;
                    List<String> pGroupList = var.RecordIdentifiers.GroupNumbers;
                    List<String> pDivList = var.RecordIdentifiers.DivisionNumbers;
                    
                    //system.debug('List Vals ::'+pNumberList+'_'+pGroupList+'_'+pDivList);
                                        
                    //For E&I : We dont need to consider Divs                       
                    //if (pDivList != null && pDivList.size() == 0){
                    if (pDivList == null){
                        
                        if (pNumberList != null){
                            for (String pn_ei: pNumberList){
                                
                                //Handle mulitiple group numbers for E&I
                                if (pGroupList != null && pGroupList.size() > 0){
                                    for (String gn_ei: pGroupList){                                      
                                        EIKeyToLevelsMap.put(pn_ei+'_'+gn_ei, finLevels);
                                    } 
                                }else{
                                    EIKeyToLevelsMap.put(pn_ei, finLevels);
                                }                       
                                
                            }
                    	}
                        
                    }else{
                        //For M&R : We dont need to consider policy Numbers
                        if (pGroupList != null){
                            for (String gn_mr: pGroupList){
                                
                                if (pDivList != null){
                                    for(String dv_mr: pDivList){                                
                                        MRkeyToLevelsMap.put(gn_mr+'_'+dv_mr, finLevels);
                                    }
                            	}
                                
                            }
                    	}
                    } 
                    
                }
                //Prepare the global map
                
                if (EIKeyToLevelsMap.keySet().size() > 0)
                	LOBToValuesMap.put('EI', SYSTEM.JSON.serialize(EIKeyToLevelsMap));
                
                if (MRkeyToLevelsMap.keySet().size() > 0){
                    String TT = SYSTEM.JSON.serialize(MRkeyToLevelsMap);
                    LOBToValuesMap.put('MR', SYSTEM.JSON.serialize(MRkeyToLevelsMap));
                }    
                
                system.debug('EI Vals :: '+EIKeyToLevelsMap.keySet().size());
                system.debug('MR Vals :: '+MRkeyToLevelsMap.keySet().size());
                system.debug('Fin Val ::'+i);
                
                if (LOBToValuesMap.keySet().size() > 0)
                	globalJsonstring = SYSTEM.JSON.serialize(LOBToValuesMap); 
                
                //Create static Resource 
                
                string name = 'ProperUseProcessedData';
                StaticResource responseJSONSR = [SELECT Id, Body FROM StaticResource WHERE Name = :name limit 1];        

                string contentType = 'application/json';
                string body = globalJsonstring;

    			// The static resource is expected to be base64 encoded.
                string base64EncodedBody = EncodingUtil.base64Encode(Blob.valueof(body)); 
                
                HttpRequest req = new HttpRequest();
                //req.setEndpoint( URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v29.0/tooling/sobjects/StaticResource');
                req.setEndpoint( URL.getSalesforceBaseUrl().toExternalForm() + 
                    '/services/data/v29.0/tooling/sobjects/StaticResource/'+ responseJSONSR.Id +'?_HttpMethod=PATCH');
                req.setMethod('POST');
                req.setHeader('Content-Type', 'application/json'); 
                req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
                // JSON formatted body
                req.setBody(
                    '{"Name":"'+name+'"'+
                    ',"ContentType":"'+contentType+'"'+
                    ',"Body":"'+base64EncodedBody+'"'+
                    ',"CacheControl":"Public"}'
                    );
        
                Http http = new Http();
                HttpResponse res = http.send(req); 
            }  
        }
        
	}
    
}