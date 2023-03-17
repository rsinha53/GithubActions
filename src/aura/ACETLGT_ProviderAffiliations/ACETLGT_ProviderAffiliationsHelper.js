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
        var providerId = component.get("v.providerId");
        var action = component.get("c.getProviderAffiliationResults");
             // Setting the apex parameters
            action.setParams({
                providerId : providerId,
                ProviderTypeCode : providerType
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
                       this.processtable(providerType,result,component,event);
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
        lgt_dt_DT_Object.lgt_dt_SortBy = -1;
        lgt_dt_DT_Object.lgt_dt_SortDir = '';
        lgt_dt_DT_Object.lgt_dt_serviceObj = result;
        lgt_dt_DT_Object.lgt_dt_lock_headers = "300";
        lgt_dt_DT_Object.lgt_dt_StartRecord =0;
        lgt_dt_DT_Object.lgt_dt_PageNumber=0;
        if(providerType =='Physician'){
        lgt_dt_DT_Object.lgt_dt_serviceName = 'ACETLGT_FindHCPAffiliationsWebservice';
        lgt_dt_DT_Object.lgt_dt_columns = JSON.parse('[{"title":"Affiliation","defaultContent":"","data":"affiliation"},{"title":"Provider ID","defaultContent":"","data":"providerId"},{"title":"Affiliation Effective Date","defaultContent":"","data":"effective"}]');
        }
        else if(providerType =='Facility'){
        lgt_dt_DT_Object.lgt_dt_serviceName = 'ACETLGT_FindHCOAffiliationsWebservice';
        lgt_dt_DT_Object.lgt_dt_columns = JSON.parse('[{"title":"Name","defaultContent":"","data":"affiliation"},{"title":"Provider ID","defaultContent":"","data":"providerId"},{"title":"Primary Specialty","defaultContent":"","data":"PrimarySpeciality"},{"title":"Affiliation Effective Date","defaultContent":"","data":"effective"}]');
        }   
        component.set("v.lgt_dt_DT_Object", JSON.stringify(lgt_dt_DT_Object));
        var lgt_dt_Cmp = component.find("ProviderDetailResultsAffiliationSectionTable_auraid");
        lgt_dt_Cmp.tableinit();
        }
})