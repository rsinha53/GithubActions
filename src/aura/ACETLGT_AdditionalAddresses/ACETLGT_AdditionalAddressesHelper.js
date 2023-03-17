({
	getDataFromServer : function(component,event,helper,providerType) { 
        var len = 10;
        var buf = [],
            chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
            charlen = chars.length,
            length = len || 32;
            
        for (var i = 0; i < length; i++) {
            buf[i] = chars.charAt(Math.floor(Math.random() * charlen));
        }
        var GUIkey = buf.join('');
        component.set("v.GUIkey",GUIkey);
        var searchProviderId = component.get("v.providerId");
        var taxId = component.get("v.taxId");
        var action = component.get("c.getProviderLookupResults");
             // Setting the apex parameters
            action.setParams({
                providerId : searchProviderId,
                npi : '',
                taxId : taxId,
                lastName : '',  
                firstName : '',
                gender : '',
                specialty: '',
                searchPcpOBGYNId : '',
                PostalPrefixCode : '',
                radius : '',
                City : '',
                StateCode : '',
                PhoneNumber : '',
                networkId : '',
                BenefitServiceArea : '',
                ServiceAreaType : '',
                contractClaimType : '',
                NewPatientIndicator : '',
                languageCode : '',
                ProviderTypeCode : providerType,
                attributelist : '',
                isLookupflow : false,
                FilterByStatus : '',
                PFS : ''
           });
            //Setting the Callback
            action.setCallback(this,function(a){
                //get the response state
                var state = a.getState();
                console.log('----state---'+state);
                //check if result is successfull
                if(state == "SUCCESS"){
                     var result = JSON.parse(a.getReturnValue().service);
                    if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                       component.set('v.doCollapse', true); 
                       helper.processtable(providerType,result,component,event);
                    }
                } else if(state == "ERROR"){
                   	
        		}
                
            });
            
            //adds the server-side action to the queue        
            $A.enqueueAction(action);
        },
       
      processtable : function(providerType,result,component,event){
        var lgt_dt_DT_Object = new Object();
        lgt_dt_DT_Object.lgt_dt_PageSize = JSON.parse(result).PageSize; 
        lgt_dt_DT_Object.lgt_dt_StartRecord =0;
        lgt_dt_DT_Object.lgt_dt_PageNumber=0;
        lgt_dt_DT_Object.lgt_dt_SortBy = -1;
        lgt_dt_DT_Object.lgt_dt_SortDir = '';
        if(providerType =='Physician'){
        lgt_dt_DT_Object.lgt_dt_serviceName = 'ACETLGT_FindHCPWebservice'; 
        }
        else if(providerType =='Facility'){
        lgt_dt_DT_Object.lgt_dt_serviceName = 'ACETLGT_FindHCOWebservice';
        }
        lgt_dt_DT_Object.lgt_dt_columns = JSON.parse('[{"title":"Active","defaultContent":"","data":"addressStatusCode"},{"title":"Address Type","defaultContent":"","data":"addressTypeCode"},{"title":"Address","defaultContent":"","data":"address"},{"title":"County","defaultContent":"","data":"County"},{"title":"Phone","defaultContent":"","data":"phoneNumber"},{"title":"Fax","defaultContent":"","data":"Fax"},{"title":"Email","defaultContent":"","data":"Email"}]');
        console.log('provider lookup' +JSON.stringify(lgt_dt_DT_Object));
        lgt_dt_DT_Object.lgt_dt_serviceObj = result;
        lgt_dt_DT_Object.lgt_dt_lock_headers = "300";
        component.set("v.lgt_dt_DT_Object", JSON.stringify(lgt_dt_DT_Object));
        var lgt_dt_Cmp = component.find("ProviderDetailResultsAddressSectionTable_auraid");
        lgt_dt_Cmp.tableinit();
        }
})