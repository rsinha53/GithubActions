public class ACET_ClaimRelatedDocumentController {
    static List<AttachmentsResponseData> AttachmentsList {get;set;}
    static List<ACET_ClaimRelatedDocument_JSON2Apex.recordsList> recordsListResult {get;set;}
    public class AttachmentsResponseData{
        @AuraEnabled public String ReceivedDate {get;set;}
        @AuraEnabled public String DocID {get;set;}
		@AuraEnabled public String fln {get;set;}										 
        @AuraEnabled public String Type {get;set;}
        @AuraEnabled public String PageCount {get;set;}
        @AuraEnabled public String CheckNumber {get;set;}
        @AuraEnabled public String ClaimNumber {get;set;}
        @AuraEnabled public String externalID {get;set;}
        @AuraEnabled public String letterID {get;set;}
		@AuraEnabled public Map<String,String> feildMap {get;set;}														  
    }
    public class SearchResultWrapper{
        @AuraEnabled public List<AttachmentsResponseData>  AttachmentsData {get;set;}
        @AuraEnabled public Integer totalRecords {get;set;}
        @AuraEnabled public Boolean isSuccess {get;set;}
        @AuraEnabled public String errorMessage {get;set;}
    }
    public static Boolean isClaimNotOnFile = false;

    public static List<AttachmentsResponseData> getClaimsImages(ACET_ClaimRelatedDocument_JSON2Apex result, string Indexname){
        AttachmentsList = new List<AttachmentsResponseData>();
        recordsListResult = new List<ACET_ClaimRelatedDocument_JSON2Apex.recordsList>();
        recordsListResult = result.recordsList;
        system.debug('recordsListResult'+recordsListResult);
        for(ACET_ClaimRelatedDocument_JSON2Apex.recordsList res : recordsListResult){
            Map<String,String> feildmap= new Map<String,String>();
            feildmap.put('docClass',Indexname);
            AttachmentsResponseData AttResData = new AttachmentsResponseData();
            integer size = res.attributes.size();
            if(size > 0){
                for(Integer i = 0; i < size; i++){
                    if(Indexname=='u_keyed_claim' || Indexname=='u_edi_claim' || Indexname=='u_clm_corsp_lwso_doc'){
                        
                        if(res.attributes[i].labelName == 'u_received_dt'){
                            AttResData.ReceivedDate= res.attributes[i].value!='' ? convertToDateFormat(res.attributes[i].value) :'--';
                        }
                        if(Indexname=='u_keyed_claim'){
                            AttResData.Type= 'Paper';
                        }
                        if(Indexname=='u_edi_claim'){
                            AttResData.Type= 'Electronic';
                        }
                        if(Indexname=='u_clm_corsp_lwso_doc'){
                            AttResData.Type= '--';
                        }
                    }else if(Indexname=='u_tops_purge'){
                        if(res.attributes[i].labelName == 'u_orig_creation_date'){
                            AttResData.ReceivedDate= res.attributes[i].value!='' ? convertToDateFormat(res.attributes[i].value) :'--';
                        }
                        if(Indexname=='u_tops_purge' || Indexname=='u_clm_corsp_lwso_doc'){
                            AttResData.Type= '--';
                        }
                    }
                    if(res.attributes[i].labelName == 'u_gbl_doc_id'){
                        AttResData.DocID= res.attributes[i].value!='' ? res.attributes[i].value :'--';
                    }
                    if(res.attributes[i].labelName == 'r_page_cnt'){
                        AttResData.PageCount= res.attributes[i].value!='' ? res.attributes[i].value :'--';
                    }
			if(res.attributes[i].value!=''){
                        feildmap.put(res.attributes[i].labelName,res.attributes[i].value);
                    }                         
                }
                AttResData.feildMap=feildmap;
                AttachmentsList.add(AttResData);
            }
        }
        system.debug('ClaimImages List @@@'+AttachmentsList);
        return AttachmentsList;
    }
    
    public static List<AttachmentsResponseData> getAttachmentInfo(ACET_ClaimRelatedDocument_JSON2Apex result, string Indexname){
        AttachmentsList = new List<AttachmentsResponseData>();
        recordsListResult = new List<ACET_ClaimRelatedDocument_JSON2Apex.recordsList>();
        recordsListResult = result.recordsList;
        Map<string,string> transmissionMap = new Map<string,string>(); 
        Map<string,string> typeMap = new Map<string,string>(); 
        List<ACET_Claims_Docs_Report_Type__mdt> reportList = [SELECT ID,ACET_Report__c,ACET_Report_Code__c,ACET_Report_Definition__c from ACET_Claims_Docs_Report_Type__mdt];
        for(ACET_Claims_Docs_Report_Type__mdt r : reportList){
            if(r.ACET_Report__c == 'Report Type Code'){
                typeMap.put(r.ACET_Report_Code__c,r.ACET_Report_Definition__c);
            }else{
                transmissionMap.put(r.ACET_Report_Code__c,r.ACET_Report_Definition__c);
            }
        }
        for(ACET_ClaimRelatedDocument_JSON2Apex.recordsList res : recordsListResult){
            AttachmentsResponseData AttResData = new AttachmentsResponseData();
			Map<String,String> feildmap= new Map<String,String>();
            feildmap.put('docClass','u_prov_attch');													  
            string transmissionDefinition = '';
            string typeDefinition = '';
            integer size = res.attributes.size();
            if(size > 0){
                for(Integer i = 0; i < size; i++){
                    if(res.attributes[i].labelName == 'u_orig_creation_date'){
                        AttResData.ReceivedDate= res.attributes[i].value!='' ? convertToDateFormat(res.attributes[i].value) :'--';
                    }
                    if(res.attributes[i].labelName == 'u_gbl_doc_id'){
                        AttResData.DocID= res.attributes[i].value!='' ? res.attributes[i].value :'--';
                    }
					
                    if(res.attributes[i].labelName == 'u_dcc_fln'){
                        AttResData.DocID= res.attributes[i].value!='' ? res.attributes[i].value :'--';
                    }						 
                    if(res.attributes[i].labelName == 'r_page_cnt'){
                        AttResData.PageCount= res.attributes[i].value!='' ? res.attributes[i].value :'--';
                    }
                    if(res.attributes[i].labelName == 'u_rpt_transms_cd'){
                        if(res.attributes[i].value != Null && res.attributes[i].value!=''){
                            transmissionDefinition = transmissionMap.get(res.attributes[i].value);
                        }
                    }
                    if(res.attributes[i].labelName == 'u_rpt_typ_cd'){
                        if(res.attributes[i].value != Null && res.attributes[i].value!=''){
                            typeDefinition = typeMap.get(res.attributes[i].value);
                        }
                    }
					if(res.attributes[i].labelName == 'u_tkt_nbr' && res.attributes[i].value!=''){
                        feildmap.put('u_tkt_nbr',res.attributes[i].value);
                    }
                    if(res.attributes[i].labelName == 'u_tin' && res.attributes[i].value!=''){
                        feildmap.put('u_tin',res.attributes[i].value);
                    }
                    if(res.attributes[i].labelName == 'u_clm_nbr' && res.attributes[i].value!=''){
                        feildmap.put('u_clm_nbr',res.attributes[i].value);
                    }
                    if(res.attributes[i].labelName == 'u_dcc_fln' && res.attributes[i].value!=''){
                        feildmap.put('u_dcc_fln',res.attributes[i].value);
                    }
                    if(res.attributes[i].labelName == 'u_gbl_doc_id' && res.attributes[i].value!=''){
                        String value=res.attributes[i].value;
                        feildmap.put('u_gbl_doc_id',value.substringBefore('|'));
                    }
                    
                    		  
                    if(!isClaimNotOnFile){
                                            AttResData.Type= transmissionDefinition+'-'+typeDefinition;
                                        }else{
                                            AttResData.Type= 'Provider Attachments';
                                        }
                }
                system.debug('feildmap>>'+feildmap);
				AttResData.feildMap=feildmap;							 
                AttachmentsList.add(AttResData);
            }
            
        }
        system.debug('Attachments List @@@'+AttachmentsList);
        return AttachmentsList;
    }
    public static List<AttachmentsResponseData> getProviderRemittanceInfo(ACET_ClaimRelatedDocument_JSON2Apex result,string Indexname){
        AttachmentsList = new List<AttachmentsResponseData>();
        recordsListResult = new List<ACET_ClaimRelatedDocument_JSON2Apex.recordsList>();
        recordsListResult = result.recordsList;
        string ReceivedDateLabel='';
        if(Indexname == 'u_eps_prov_eob' || Indexname == 'u_unet_gflx_eob'){
            ReceivedDateLabel = 'u_eob_dt';
        }else if(Indexname == 'u_cosmos_pra' || Indexname == 'u_cosmos_pra_ub'){
            ReceivedDateLabel = 'u_orig_creation_date';
        }
        for(ACET_ClaimRelatedDocument_JSON2Apex.recordsList res : recordsListResult){
            AttachmentsResponseData AttResData = new AttachmentsResponseData();
			Map<String,String> feildmap= new Map<String,String>();
            feildmap.put('docClass',Indexname);													  
            integer size = res.attributes.size();
            if(size > 0){
                for(Integer i = 0; i < size; i++){
                    if(res.attributes[i].labelName == ReceivedDateLabel){
                        AttResData.ReceivedDate = res.attributes[i].value!='' ? convertToDateFormat(res.attributes[i].value) :'--';
                    }
                    if(res.attributes[i].labelName == 'u_gbl_doc_id'){
                        AttResData.DocID= res.attributes[i].value!='' ? res.attributes[i].value :'--';
                    }
                    if(res.attributes[i].labelName == 'r_page_cnt'){
                        AttResData.PageCount= res.attributes[i].value!='' ? res.attributes[i].value :'--';
                    }
                    if(res.attributes[i].labelName == 'u_check_nbr'){
                        AttResData.CheckNumber= res.attributes[i].value!='' ? res.attributes[i].value :'--';
                    }
					if(res.attributes[i].labelName == 'u_claim_nbr' && res.attributes[i].value!=''){
                        feildmap.put('u_claim_nbr_EOB',res.attributes[i].value);
                    }
                    if(res.attributes[i].labelName == 'u_tin' && res.attributes[i].value!=''){
                        feildmap.put('u_tin_cosmos',res.attributes[i].value);
                    }
                    if(res.attributes[i].labelName == 'u_member_id' && res.attributes[i].value!=''){
                        feildmap.put('u_member_id_PRA',res.attributes[i].value);
                    }
                    
                    
                    if(res.attributes[i].value!=''){
                        feildmap.put(res.attributes[i].labelName,res.attributes[i].value);
                    }	 
                }
				AttResData.feildMap=feildmap;						 
                AttachmentsList.add(AttResData);
            }
            
        }
        system.debug('getProviderRemittance List @@@'+AttachmentsList);
        return AttachmentsList;
    }
    public static List<AttachmentsResponseData> getClaimLettersInfo(ACET_ClaimRelatedDocument_JSON2Apex result,string Indexname){
        AttachmentsList = new List<AttachmentsResponseData>();
        recordsListResult = new List<ACET_ClaimRelatedDocument_JSON2Apex.recordsList>();
        recordsListResult = result.recordsList;
        string claimNumberLabel='';
        string letterIDLabel='';
        string TypeLabel='';
        if(Indexname == 'u_mli_elgs'){
            claimNumberLabel = 'u_icn_nbr';
            letterIDLabel='u_ltr_gen_req_id';
            TypeLabel='u_subject';
        }else if(Indexname == 'u_nasc_salsa_ltr'){
            letterIDLabel='u_letter_id';
        }
        else if(Indexname == 'u_cos_clmltr_mem_doc' || Indexname == 'u_cos_clmltr_prov_doc'){
            claimNumberLabel = 'u_clm_nbr';
            letterIDLabel='u_ltr_id';
            TypeLabel='u_ltr_typ';
        }
        for(ACET_ClaimRelatedDocument_JSON2Apex.recordsList res : recordsListResult){
            Map<String,String> feildmap= new Map<String,String>();
            feildmap.put('docClass',Indexname);
            AttachmentsResponseData AttResData = new AttachmentsResponseData();
            integer size = res.attributes.size();
            if(size > 0){
                for(Integer i = 0; i < size; i++){
                    if(res.attributes[i].labelName == 'u_gbl_doc_id'){
                        AttResData.DocID= res.attributes[i].value!='' ? res.attributes[i].value :'--';
                    }
                    if(Indexname == 'u_nasc_salsa_ltr' || Indexname == 'u_ovat_mapd_ltr'){
                        AttResData.ClaimNumber= '--'; 
                        AttResData.Type='--';
                    }else{
                        if(res.attributes[i].labelName == claimNumberLabel){
                            AttResData.ClaimNumber= res.attributes[i].value!='' ? res.attributes[i].value :'--';
                        }
                        if(res.attributes[i].labelName == TypeLabel){
                            if(!isClaimNotOnFile){
                            AttResData.Type= res.attributes[i].value!='' ? res.attributes[i].value :'--';
                            }else{
                                if(Indexname == 'u_cos_clmltr_mem_doc'){
                                    AttResData.Type= 'COSOMOS Claim Letter Member';
                                }
                                if(Indexname == 'u_cos_clmltr_prov_doc'){
                                    AttResData.Type= 'COSOMOS Claim Letter Provider';
                                }
                            }
                        }
                    }
                    if(Indexname == 'u_ovat_mapd_ltr'){
                        AttResData.letterID='--';
                    }else{
                        if(res.attributes[i].labelName == letterIDLabel){
                            AttResData.letterID= res.attributes[i].value!='' ? res.attributes[i].value :'--';
                        } 
                    }
                    if(res.attributes[i].labelName == 'r_page_cnt'){
                        AttResData.PageCount= res.attributes[i].value!='' ? res.attributes[i].value :'--';
                    }
                    if(res.attributes[i].labelName == 'u_orig_creation_date'){
                        AttResData.ReceivedDate= res.attributes[i].value!='' ? convertToDateFormat(res.attributes[i].value) :'--';
                    }
                    if(res.attributes[i].value!=''){
                        feildmap.put(res.attributes[i].labelName,res.attributes[i].value);
                    }
                    AttResData.externalID= '--';
                }
                AttResData.feildMap=feildmap;
                AttachmentsList.add(AttResData);
            }
            
        }
        system.debug('getClaimLetters List @@@'+AttachmentsList);
        return AttachmentsList;
    }     
    public static List<AttachmentsResponseData> getMemberEOBInfo(ACET_ClaimRelatedDocument_JSON2Apex result,string Indexname){
         AttachmentsList = new List<AttachmentsResponseData>();
         recordsListResult = new List<ACET_ClaimRelatedDocument_JSON2Apex.recordsList>();
        recordsListResult = result.recordsList;
        string ReceivedDateLabel='';
        if(Indexname == 'u_cosmos_eob' || Indexname == 'u_cosmos_eob_ub' || Indexname == 'u_mber_eob'){
            ReceivedDateLabel = 'u_eob_dt';
        }else if(Indexname == 'u_mr_partc_eob'){
            ReceivedDateLabel = 'u_orig_creation_date';
        }
        for(ACET_ClaimRelatedDocument_JSON2Apex.recordsList res : recordsListResult){
			Map<String,String> feildmap= new Map<String,String>();
            feildmap.put('docClass',Indexname);													  
            AttachmentsResponseData AttResData = new AttachmentsResponseData();
            integer size = res.attributes.size();
            if(size > 0){
                for(Integer i = 0; i < size; i++){
                    if(res.attributes[i].labelName == ReceivedDateLabel){
                        AttResData.ReceivedDate= res.attributes[i].value!='' ? convertToDateFormat(res.attributes[i].value) :'--';
                    }
                    if(res.attributes[i].labelName == 'u_gbl_doc_id'){
                        AttResData.DocID= res.attributes[i].value!='' ? res.attributes[i].value :'--';
                    }
                    if(res.attributes[i].labelName == 'r_page_cnt'){
                        AttResData.PageCount= res.attributes[i].value!='' ? res.attributes[i].value :'--';
                    }
					if(res.attributes[i].labelName == 'u_policy_nbr' && (Indexname != 'u_cosmos_eob' && Indexname != 'u_cosmos_eob_ub') && res.attributes[i].value!=''){
                        feildmap.put('u_policy_nbr_EOB',res.attributes[i].value);
                    }
                    if(res.attributes[i].labelName == 'u_claim_nbr' && (Indexname != 'u_cosmos_eob_ub') && res.attributes[i].value!=''){
                        feildmap.put('u_claim_nbr_EOB',res.attributes[i].value);
                    }
                    if(res.attributes[i].labelName == 'u_policy_nbr' && res.attributes[i].value!=''){
                        feildmap.put('u_policy_nbr_COSE',res.attributes[i].value);
                    }
                    if(res.attributes[i].value!=''){
                        feildmap.put(res.attributes[i].labelName,res.attributes[i].value);
                    }	 
                }
				AttResData.feildMap=feildmap;
                AttachmentsList.add(AttResData);
            }
            
        }
        system.debug('getMemberEOBInfo List @@@'+AttachmentsList);
        return AttachmentsList;
    }

    public static string convertToDateFormat(string str2DatetimeFormat){
        list<string> lstSplit = str2DatetimeFormat.split('-');
        list<string> lstSplitFormat = lstSplit[2].split('T');
        list<string> lsttimeformat = lstSplitFormat[1].split(':');
        
        string finalDateFormat = lstSplit[1]+'/'+lstSplitFormat[0]+'/'+lstSplit[0];
        return finalDateFormat;
    }
}