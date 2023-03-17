public without sharing class ADBAncillaryController {
    //Integration : Ancillary
    @AuraEnabled
    public static ADBECPAncillaryDataWrapper getAncillaryDetails (String memberId){
        ADBAncillaryWrapper wrapper;
        ADBECPAncillaryDataWrapper ancList = new ADBECPAncillaryDataWrapper();
        try{
            // generating the request body : Retrieve Grapghql from Static resources.
            List<String> values = new List<String>{memberId}; 
                StaticResource requestTemplate = [SELECT body FROM StaticResource WHERE Name = 'ADBAncillaryAPIRequest'];    
            
            String strBody = requestTemplate.Body.toString();
            System.debug('strBody : ' + strBody);
            
            //inject value and replace '~' with '{' (Opening bracket) and inject String value to requestTemplate body    
            String body = String.format(strBody, values).replaceAll('~', '{');  
            System.debug('template after replacing with actual values : ' + body);
            
            ACET_WebserviceCalloutFramework wsCallOutFW = new ACET_WebserviceCalloutFramework('ADBAncillaryDataEndpoint',body,null);
            HttpResponse response = wsCallOutFW.getResponse(); 
            // Checking the status code is success
            if(response.getStatusCode() == 200 || response.getStatusCode() == 400) {
                system.debug('response for Ancillary data'+response.getBody());
                String resp = response.getBody();
                
                wrapper = (ADBAncillaryWrapper) JSON.deserialize(resp, ADBAncillaryWrapper.class);
                system.debug('wrapper ++'+wrapper);
                ancList = prepareECPAncillaryData(wrapper);
                system.debug('ancList++'+ ancList);
            }else{
                system.debug('Ancillary Response code && Response body if not 200 ::' + response.getStatusCode() +'-'+ response.getBody()); 
            }
            
        }catch(Exception e){
            system.debug('Ancillary Service Exception ::' + e.getMessage());
        }
        //--block for mocking purpose starts
        /*StaticResource mockTemplate = [SELECT body FROM StaticResource WHERE Name = 'ADBAncillaryTestData'];
		String resp = mockTemplate.Body.toString();
		wrapper = (ADBAncillaryWrapper) JSON.deserialize(resp, ADBAncillaryWrapper.class);
		ancList = prepareECPAncillaryData(wrapper);*/
        //--block for mocking purpose starts
        
        return ancList;
    }
    //By:Nadeem
    //Reason:Extract Ancillary Data from Response
    @AuraEnabled
    public static ADBECPAncillaryDataWrapper prepareECPAncillaryData(ADBAncillaryWrapper response) {
        
        ADBECPAncillaryDataWrapper ancList = new ADBECPAncillaryDataWrapper();
        List<ADBECPAncillaryDataWrapper.AncillaryData> adata = new List<ADBECPAncillaryDataWrapper.AncillaryData>();
        if((response != null)&&(response.data != null)&&(response.data.mbrshp != null)){
            for(ADBAncillaryWrapper.Mbrshp acnt:response.data.mbrshp){
                for(ADBAncillaryWrapper.Mbr_covs adw :acnt.mbr_covs){
                    
                    ADBECPAncillaryDataWrapper.AncillaryData awrap = new ADBECPAncillaryDataWrapper.AncillaryData();
                    if(String.isNotBlank(adw.carr_nm) && adw.carr_nm != 'Waive'){
                    awrap.carrierName = (adw.carr_nm != null)?String.valueOf(adw.carr_nm):'';
                    awrap.covRefTypeDesc = (adw.cov_typ_ref_cd!= null && adw.cov_typ_ref_cd.ref_desc != null)?String.valueOf(adw.cov_typ_ref_cd.ref_desc):'';
                    awrap.effDate = String.isNotBlank(String.ValueOf(adw.cov_eff_dt)) ? cleanDate(String.ValueOf((Date.valueOf(String.ValueOf(adw.cov_eff_dt))).format())): ''; 
                    if(String.isBlank(String.ValueOf(adw.cov_end_dt)) || adw.cov_end_dt == 'null' || adw.cov_end_dt == '9999-12-31')
                        awrap.endDate = '12/31/9999';
                    else
                        awrap.endDate = cleanDate(String.ValueOf((Date.valueOf(String.ValueOf(adw.cov_end_dt))).format()));
                    awrap.planName = (adw.mbr_cov_phmds != null && adw.mbr_cov_phmds[0] != null)?adw.mbr_cov_phmds[0].pln_nm:'';
                    adata.add(awrap);
                    }
                }
            }
        }
        ancList.ancillData = adata;
        System.debug('Ancillary List VALUE :: ' + ancList);
        return ancList;
    }
    
    
    public static String cleanDate(String theDate){
        String [] s = theDate.split('/');
        String newDate= '';
        String newMonth= '';
        String newDay= '';
        if(s[0].length() == 1){
            newMonth = '0'+s[0];
        }else{
            newMonth = s[0];
        }
        if(s[1].length() == 1){
            newDay = '0'+s[1];
        }else{
            newDay = s[1];
        }
        newDate = newMonth+'/'+newDay+'/'+s[2];
        return newDate;
    }
}