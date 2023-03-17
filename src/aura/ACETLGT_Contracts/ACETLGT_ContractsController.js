({
    showResults : function(component, event, helper) {
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
        var taxId =  component.get("v.taxId");
        var providerTINTypeCode = component.get("v.providerTINTypeCode");
        var addressId = component.get("v.addressId");
        var addressTypeCode = component.get("v.addressTypeCode");
        var providerType = component.get("v.providerType");
        console.log('data from child');
         component.set("v.searchStatusRadio", providerId+GUIkey);
        //helper.checkActive(component,event,helper);
        helper.getDataFromServer(component, event, helper,providerId,taxId,providerTINTypeCode,addressId,addressTypeCode,providerType);
        
    },
    handlecreatedRow_Event:function(component,event, helper) {
        var highlightPanel = component.get("v.highlightPanel");
        var intId = component.get("v.intId");
        var memberId = component.get("v.memberId");
        var grpNum = component.get("v.grpNum");
        var row = event.getParam("row");   
        var data = event.getParam("data");
        var dataIndex = event.getParam("dataIndex");
        var table_id = event.getParam("lgt_dt_table_ID");
        var lgt_dt_Cmp = component.find("ProviderDetailResultsContractsSectionTable_auraid");
        if(!$A.util.isEmpty(lgt_dt_Cmp)) {   
            var Contract_Status = data.Contract_Status ? data.Contract_Status : '';
            if(!component.get("v.isProviderPanelClosed"))
            	helper.setProviderPanelVisibility(component, data); 
            var workspaceAPI = component.find("workspace");
            
            if(Contract_Status == 'A') {
                $(row).children(":nth-child(1)").html('<div id="active_image" class="slds-icon_container_circle slds-icon-action-approval slds-icon_container"><img src="'+$A.get('$Resource.SLDS') + '/assets/icons/action/approval_60.png" style="max-width:14px;"></img></div>');
            }else if(Contract_Status == 'I') {
                $(row).children(":nth-child(1)").html('<div id="non_active_image" class="slds-icon_container_circle slds-icon-action-close slds-icon_container"><img src="'+$A.get('$Resource.SLDS') + '/assets/icons/action/close_60.png" style="max-width:14px;"></img></div>');
            }    
            $(row).find(":nth-child(3)").html("<a id='lnkProviderId' href='javascript:void(0);'>" + data.Network_Name + "</a>");
            $(row).find(":nth-child(3)").on('click', function(e) {
                var providerinfoObj = new Object();
                providerinfoObj.providerId = component.get("v.providerId");
                providerinfoObj.taxId= component.get("v.taxId");
                providerinfoObj.providerTINTypeCode= component.get("v.providerTINTypeCode");
                providerinfoObj.addressId= component.get("v.addressId");
                providerinfoObj.addressTypeCode= component.get("v.addressTypeCode");
                providerinfoObj.providerType = component.get("v.providerType");
                for (var propName in data) { 
                    if (data[propName] === null || data[propName] === undefined) {
                        delete data[propName];
                    }
                }
                workspaceAPI.getEnclosingTabId().then(function(enclosingTabId) {
                    workspaceAPI.openSubtab({
                        parentTabId: enclosingTabId,
                        pageReference: {
                            "type": "standard__component",
                            "attributes": {
                                "componentName": "c__ACETLGT_Contract_Details"
                            },
                            "state": {
                                "c__rowData": JSON.stringify(data),
                                "c__providerinfoObj":JSON.stringify(providerinfoObj),
                                "c__highlightPanel":JSON.stringify(highlightPanel),
                                "c__intId":component.get("v.intId"),
                                "c__memberId":component.get("v.memberId"),
                                "c__grpNum":component.get("v.grpNum"),
                                "c__AutodocKey":component.get("v.AutodocKey"),
                                "c__AutodocKey":component.get("v.AutodocKey"),
                                "c__Ismnf":component.get("v.Ismnf")
                                
                            }
                        }
                    }).then(function(response) {
                        workspaceAPI.getTabInfo({
                            tabId: response
                        }).then(function(tabInfo) {
                            workspaceAPI.setTabLabel({
                                tabId: tabInfo.tabId,
                                label: data.Network_Name+' '+ data.Effective +'-'+ data.Cancel
                            });
                            workspaceAPI.setTabIcon({
                                tabId: tabInfo.tabId,
                                icon: "standard:people",
                                iconAlt: "Contract"
                            });
                        });
                    }).catch(function(error) {
                        console.log(error);
                    });
                });
            });
        }
    },
    handledtcallbackevent:function(component,event,helper){
        debugger;
        component.find('activeallradioRadioid').set("v.disabled",false);
        var contractvalue = component.get("v.contractValue");
        var totalActiveVisibleRows;
        var lgt_dt_table_ID = event.getParam("lgt_dt_table_ID");
        var inactiverowslength = 0;
        var activerowslength = 0;
        var comp =  event.getParam("comp");
        var entrypageinfo ='';
        console.log(lgt_dt_table_ID);
        $(lgt_dt_table_ID+ ' tbody tr').each(function(){
            if(contractvalue =='Active'){
                console.log($(this).find('td:nth-child(1) div'));
                if($(this).find('td:nth-child(2) div').attr('id') =='active_image'){
                   $(this).removeClass('slds-hide'); 
                   $(this).find('td').removeClass('slds-hide');

                    activerowslength =activerowslength+$(this).length; 
                } if($(this).find('td:nth-child(2) div').attr('id') =='non_active_image'){
                  
                  $(this).find('td').addClass('slds-hide');

                    $(this).addClass('slds-hide');
                    inactiverowslength =inactiverowslength+$(this).length; 
                }
                if ($(this).find('td.dataTables_empty').length > 0) {
                    totalActiveVisibleRows = 0;  
                }
                if ($(this).find('td.dataTables_empty').length == 0)  {
                    totalActiveVisibleRows = $(lgt_dt_table_ID+' tbody tr:visible').length;
                }  
            }else if(contractvalue =='All'){
                $(this).find('td').removeClass('slds-hide');
            }
        });
        if(contractvalue == 'Active') {
           component.set("v.contractsheaddertext",' ⚫Active ⚪All');

            console.log('totalDefatotalActiveVisibleRowsultRows' +totalActiveVisibleRows);
            //$(lgt_dt_table_ID+ '_entries_info_div_id').text('Showing ' +totalActiveVisibleRows+ ' entries');
             setTimeout(function() {
                entrypageinfo = 'Showing '+totalActiveVisibleRows+' entries';
                comp.set("v.lgt_dt_entries_info",entrypageinfo);
            }, 1);
        }
        var totalRows = activerowslength+inactiverowslength;         
        var totalHiddenRows = inactiverowslength;
        if(totalRows != 0 && totalRows == totalHiddenRows) {  
            component.find('activeallradioRadioid').set("v.disabled",true);
            component.set("v.contractValue","All");
            component.set("v.contractsheaddertext",' ⚪Active  ⚫All');
            helper.showInactiveContracts(component,event,helper,contractvalue,lgt_dt_table_ID,comp);
        }
                
    },
    initComplete_Event: function(component,event,helper){
        var settings = event.getParam("settings");
        console.log('#'+settings.sTableId);
        var tableId = '#'+settings.sTableId;
        component.set("v.lgt_dt_table_ID",tableId);
    },
    onContractChange : function(component,event,helper) {
        var contractvalue = component.get("v.contractValue");   
        var lgt_dt_table_ID = component.get("v.lgt_dt_table_ID");
        helper.onContractRadioChange(component,event,helper,contractvalue,lgt_dt_table_ID);
    },
    handle_dt_pageNum_Event: function(component, event, helper) {
        var pgnum = event.getParam("pageNumber");
        //alert("====>>"+pgnum);
        component.set("v.page_Number", pgnum);
    },
    
})