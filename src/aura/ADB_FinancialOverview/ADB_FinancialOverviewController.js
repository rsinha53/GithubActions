({
doInit : function(component, event, helper) {
},

showHover: function(component, event, helper) {
    //console.log('hit');
    var hoverValue = component.get("v.isHoverVisible");
    if(hoverValue==false){
        component.set('v.isHoverVisible',true);
    }
    else{
        component.set('v.isHoverVisible',false); 
    }
    component.set('v.hoverRow', parseInt(event.target.dataset.index));
    component.set('v.hoverCol', parseInt(event.target.dataset.column));
},

hoverOver_currentYR : function(component, event, helper){
    //component.set("v.isCurrentYR",true);
},

hoverOut_currentYR : function(component, event, helper){
    //component.set("v.isCurrentYR",false);
},

hoverOver_priorYBal : function(component, event, helper){
    //component.set("v.isPriorYBal",true);
},

hoverOut_priorYBal : function(component, event, helper){
    //component.set("v.isPriorYBal",false);
},

hoverOver_accCBal : function(component, event, helper){
    
},

hoverOut_accCBal : function(component, event, helper){
    
},
    
onListChange : function(component, event, helper){
       
    
   /* var shortName = component.get("v.FinOverviewData.account[0].accountTypeCode");
    console.log('short name in FInOver'+shortName);
    if(shortName != undefined || shortName != null || shortName != ""){
     component.set("v.AccShortName",shortName);
     helper.assignAccountName(component, event, helper);
    }*/
     //helper.assignAccountName(component, event, helper);
},
    
onRowClick : function(component, event, helper){
    
    //Remove Existing Highlighted Class
    var x = document.querySelectorAll(".tableRowHighlight");
    var i;
    for (i = 0; i < x.length; i++) {
        x[i].classList.remove("tableRowHighlight");
        
    }
    
    //Add highlighted class to selected row
    event.currentTarget.className += " tableRowHighlight";
    
    
    //Account Name of selected Account
    var accName = event.currentTarget.dataset.id;
    
    //Selected Account Details
    var accNum = event.currentTarget.dataset.accnum;
    var accAuthUser = event.currentTarget.dataset.accauthuser;
    var accInvBal = event.currentTarget.dataset.accinvbal; 
	var accSysCode = '';
    var transData = component.get("v.TransactionsAccountsData")
    if(transData !=null){
        transData.forEach(function(tdata){
            if(tdata.accountType == accName || (tdata.accountType == 'HRA' && accName == 'HRAAP')||(tdata.accountType == 'FSA' && accName == 'FSA LIM')|| (tdata.accountType == 'FSA DC' && accName == 'FSADC') || (tdata.accountType == 'FSA' && accName == 'FSAHC') || (tdata.accountType == 'FSA' && accName == 'FSALP')){
                accSysCode = tdata.accountCode;
            }
        });
    }
    
    //Set Selected Accout Details
    component.set("v.accNum", accNum);
    component.set("v.accAuthUser", accAuthUser);
    component.set("v.accInvBal", accInvBal);
    component.set("v.accSysCode", accSysCode);
    
    
    component.set("v.AccShortName",accName);
    console.log('account name selected'+accName);
    helper.assignAccountName(component, event, helper);
    
    var totalCYbal = component.get("v.FinOverviewData.totalCurrentYrBalance");
   // var hsaCYbal = ;
},



})