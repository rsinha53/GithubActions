({
   getDataFromServer : function(component,event,helper,providerId,taxId,providerTINTypeCode,addressId,addressTypeCode,providerType) { 
        var action = component.get("c.getProviderContractResults");   
         action.setParams({
            providerId: providerId,
            taxId : taxId,
            providerTINTypeCode: providerTINTypeCode,
            addressId: addressId,
            addressTypeCode:addressTypeCode
        });
       action.setCallback(this, function(a) {
            
           var state = a.getState();
            console.log('----state---'+state);
            //check if result is successfull
            if(state == "SUCCESS"){
                 var responce =  JSON.parse(a.getReturnValue().responce);
                 console.log('responce' +responce);
                if(!$A.util.isEmpty(responce) && !$A.util.isUndefined(responce)){
                        this.processtable(providerType,responce,component,event);
                    }
               }else if(state == "ERROR"){
                
               }
        });
        $A.enqueueAction(action);   
	},
       
    processtable : function(providerType,responce,component,event){
        console.log('responce===>'+responce);
        console.log('providerType'+providerType);
        var lgt_dt_DT_Object = new Object();
        lgt_dt_DT_Object.lgt_dt_PageSize = 50;
        lgt_dt_DT_Object.lgt_dt_SortBy = '2';
        lgt_dt_DT_Object.lgt_dt_SortDir = 'desc';
        lgt_dt_DT_Object.lgt_dt_serviceObj = responce;
        lgt_dt_DT_Object.lgt_dt_lock_headers = "300";
        lgt_dt_DT_Object.lgt_dt_StartRecord =0;
        lgt_dt_DT_Object.lgt_dt_PageNumber =0;
        lgt_dt_DT_Object.lgt_dt_serviceName = 'ACETLGT_FindAgreementsWebservice';
        if(providerType == 'Physician'){
          lgt_dt_DT_Object.lgt_dt_columns = JSON.parse('[{"title":"Active","defaultContent":"","data":"Contract_Status"},{"title":"Network ID","defaultContent":"","data":"Network_ID"},{"title":"Network Name","defaultContent":"","data":"Network_Name"},{"title":"Process Order","defaultContent":"","data":"process_Order_Number"},{"title":"Organization Name","defaultContent":"","data":"organizationName"},{"title":"Pricing Set ID","defaultContent":"","data":"Pricing_Set_ID"},{"title":"Contract ID","defaultContent":"","data":"ContractDetailId"},{"title":"Effective","defaultContent":"","data":"Effective"},{"title":"Cancel","defaultContent":"","data":"Cancel"},{"title":"Accepting New Patients","defaultContent":"","data":"Accepting_New_Patients"},{"title":"Assignment Type","defaultContent":"","data":"ProviderAssignmentType"},{"title":"Provider Assignment","defaultContent":"","data":"providerAssignmentIndicator"}]');
      }
    else if(providerType =='Facility'){
       lgt_dt_DT_Object.lgt_dt_columns = JSON.parse('[{"title":"Active","defaultContent":"","data":"Contract_Status"},{"title":"Network ID","defaultContent":"","data":"Network_ID"},{"title":"Network Name","defaultContent":"","data":"Network_Name"},{"title":"Process Order","defaultContent":"","data":"process_Order_Number"},{"title":"Organization Name","defaultContent":"","data":"organizationName"},{"title":"Pricing Set ID","defaultContent":"","data":"Pricing_Set_ID"},{"title":"Contract ID","defaultContent":"","data":"ContractDetailId"},{"title":"Effective","defaultContent":"","data":"Effective"},{"title":"Cancel","defaultContent":"","data":"Cancel"},{"title":"Provider Assignment","defaultContent":"","data":"providerAssignmentIndicator"}]');
          }
     console.log(JSON.stringify(lgt_dt_DT_Object));
    component.set("v.lgt_dt_DT_Object",JSON.stringify(lgt_dt_DT_Object));  
     var lgt_dt_Cmp = component.find("ProviderDetailResultsContractsSectionTable_auraid");
    lgt_dt_Cmp.tableinit(); 
    },
    onContractRadioChange : function(component,event,helper,contractvalue,lgt_dt_table_ID) {
        debugger;
        var totalVisibleRows;
        var totalAllRows;
        var inactiverowslength = 0;
        var activerowslength = 0;
        console.log(lgt_dt_table_ID);
       if(contractvalue != null && contractvalue != '') {
              $(lgt_dt_table_ID+ ' tbody tr').each(function(){
                    if(contractvalue == 'Active') {
                        var t = document.querySelector('td:nth-child(2) div').innerHTML;
                        console.log(t);
                       if($(this).find('td:nth-child(2) div').attr('id') =='active_image'){
                            $(this).find('td').removeClass('slds-hide');
                            $(this).removeClass('slds-hide');
                           
                       }
                       if($(this).find('td:nth-child(2) div').attr('id') =='non_active_image'){
                          $(this).addClass('slds-hide');
                          $(this).find('td').addClass('slds-hide');

                         
                          
                      }
                      if ($(this).find('td.dataTables_empty').length > 0) {
                           totalVisibleRows = 0;  
                      }
                      if ($(this).find('td.dataTables_empty').length == 0)  {
                         totalVisibleRows = $(lgt_dt_table_ID+' tbody tr:visible').length; 
                      }
                      
                  }else {
                         $(this).find('td').removeClass('slds-hide'); 
                         $(this).removeClass('slds-hide'); 
                         if ($(this).find('td.dataTables_empty').length > 0) {
                         totalAllRows = 0;  
                      }
                      if ($(this).find('td.dataTables_empty').length == 0)  {
                         totalAllRows = $(lgt_dt_table_ID+' tbody tr:visible').length; 
                      }
                    }
                });
       }
                if(contractvalue == 'Active') {
                component.set("v.contractsheaddertext",' ⚫Active ⚪All');
                      console.log('totalVisibleRows' +totalVisibleRows);
                    $(lgt_dt_table_ID+ '_entries_info_div_id').text('Showing ' +totalVisibleRows+ ' entries');

                 }else {
            component.set("v.contractsheaddertext",' ⚪Active  ⚫All');
                    console.log('totalAllRows' +totalAllRows);
                    $(lgt_dt_table_ID+ '_entries_info_div_id').text('Showing ' +totalAllRows+ ' entries');
                 }
             
                debugger;

    },
    showInactiveContracts : function(component,event,helper,contractvalue,lgt_dt_table_ID,comp) {
        var totalAllRows;
        var allrowslength = 0;
        var entrypageinfo = '';
        $(lgt_dt_table_ID+ ' tbody tr').each(function(){
            $(this).find('td').removeClass('slds-hide');
            $(this).removeClass('slds-hide');
            if ($(this).find('td.dataTables_empty').length > 0) {
                  totalAllRows = 0;  
             }
             if ($(this).find('td.dataTables_empty').length == 0)  {
                    allrowslength =allrowslength+$(this).length; 
                    totalAllRows = allrowslength;
              }
        });
        setTimeout(function() {
            entrypageinfo = 'Showing '+totalAllRows+' entries';
            comp.set("v.lgt_dt_entries_info",entrypageinfo);
        }, 1);
        //$(lgt_dt_table_ID+ '_entries_info_div_id').text('Showing ' +totalAllRows+ ' entries');
    },
    
    // US 2513871 boolean attribute for - Provider panel is closed message show/hide
    // 			  						- Submit button disable/enable
    setProviderPanelVisibility : function(component, data) {
        var pcpRole = component.get("v.PCPRole");        
        var memberNetwork;
        var strMemberNetwork;
        
        if(component.get("v.highlightPanel") != null && component.get("v.highlightPanel") != undefined) {
            memberNetwork = component.get("v.highlightPanel").Network;
            if(memberNetwork != null && memberNetwork != undefined) {
                memberNetwork = memberNetwork.split('_')[0];
                strMemberNetwork = memberNetwork.toString().toLowerCase().trim();
            }
        }
        if(pcpRole != null && pcpRole != undefined && (pcpRole == 'PCP / OBGYN' || pcpRole == 'OBGYN / PCP'))
            pcpRole = 'PCP';
        
        if(data != null && data != undefined && data != '') {
            var status = data.Contract_Status;            
            var acceptNewPatients = data.Accepting_New_Patients;
            var prvdAssignmentType = (data.ProviderAssignmentType != null && data.ProviderAssignmentType != undefined && data.ProviderAssignmentType!= '') ? data.ProviderAssignmentType.trim() : '';
			var contrNetwork = data.Network_Name;
            var strContrNetwork;
            if(contrNetwork) {
                var lastIndex = contrNetwork.lastIndexOf(" ");
                contrNetwork = contrNetwork.substring(0, lastIndex);
                strContrNetwork = contrNetwork.toString().toLowerCase();
            }
            if(prvdAssignmentType != null && prvdAssignmentType != '' && pcpRole != null && pcpRole != '')  {         
            if(status == 'A' && pcpRole.trim() == prvdAssignmentType.trim() && acceptNewPatients == 'N' && strContrNetwork == strMemberNetwork){
                component.set("v.isProviderPanelClosed", true);	//	need this attribute too to handle logic in controller.js
                var providerPanelClosed = component.getEvent("providerPanelClosed");
                providerPanelClosed.setParams({
                    "isProviderPanelClosed" : true
                });
                providerPanelClosed.fire(); 
                
            }
          }
        }
    }
})