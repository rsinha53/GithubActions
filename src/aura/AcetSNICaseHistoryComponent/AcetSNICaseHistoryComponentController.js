({

    init: function(component, event, helper) {
       
         var len = 10;
        var buf = [],
            chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
            charlen = chars.length,
            length = len || 32;
            
        for (var i = 0; i < length; i++) {
            buf[i] = chars.charAt(Math.floor(Math.random() * charlen));
        }
        var GUIkey = buf.join('');
        component.set('v.dataTblId', GUIkey);
         helper.showResults(component,helper);
    },
    /*
    handleMouseOver : function(component,event,helper){
       
        var recId=event.currentTarget.getAttribute("data-recId")
        component.set("v.togglehover",recId);
     },
     handleMouseOut : function(component,event,helper){

              component.set("v.togglehover",false);
              
              },
    
     */         
    navigateToRecord : function(component, event, helper) {
        //console.log('navigateto record');        
        var intId = event.currentTarget.getAttribute("data-cId");
        //console.log('c id '+intId);
        
        //console.log('-----'+intId);
        //var navLink = component.find("navLink");
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openSubtab({
            pageReference: {
                type: 'standard__recordPage',
                attributes: {
                    actionName: 'view',
                    objectApiName: 'case',
                    recordId : intId  
                },
            },
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                tabId: response
                
            }).then(function(tabInfo) {
                /*workspaceAPI.setTabLabel({
                        tabId: tabInfo.tabId,
                        label: 'Detail-'+lastName
                    });
                    workspaceAPI.setTabIcon({
                        tabId: tabInfo.tabId,
                        icon: "standard:people",
                        iconAlt: "Member"
                    });*/
            });
        }).catch(function(error) {
            console.log(error);
        });
    },
    
    onPrev: function(component,event,helper) {
        $(document).ready(function() {
        var table = $('#'+component.get("v.dataTblId")).DataTable();
             table.page('previous').draw( 'page' );
            });
    },
    onNext : function(component,event,helper) {
        $(document).ready(function() {
       var table = $('#'+component.get("v.dataTblId")).DataTable();
             table.page('next').draw( 'page' );
            });
    },
    onFirst: function(component,event,helper) {
        $(document).ready(function() {
          var table = $('#'+component.get("v.dataTblId")).DataTable();
             table.page('first').draw( 'page' );
            });
    },
    onLast:function(component,event,helper) {
        $(document).ready(function() {
          var table = $('#'+component.get("v.dataTblId")).DataTable();
             table.page('last').draw( 'page' );
            });
    },
    processMe:function(component,event,helper) {
   var selectdpage = parseInt(event.target.name)-1;
        					$(document).ready(function() {
                                var table = $('#'+component.get("v.dataTblId")).DataTable();
                                table.page(selectdpage).draw( 'page' );
                            });
               
             
     }
})