({
       	init : function(component,event,helper){      
    },
    
    Onloadjquery: function(component,event,helper){
        component.set('v.dataTblId', new Date().getTime());
    },
    handleMouseOver : function(component,event,helper){
        var recId=event.currentTarget.getAttribute("data-recId");
        component.set("v.togglehover",recId);
    },    
    handleMouseOut : function(component,event,helper){
    	component.set("v.togglehover",false);
	},
    navigateToRecord : function(component, event, helper) {
        console.log('navigateto record');        
        var intId = event.currentTarget.getAttribute("data-cId");
        console.log('c id '+intId);
        console.log('-----'+intId);
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
               
            });
        }).catch(function(error) {
            console.log(error);
        });
    },
    
    onPrev: function(component,event,helper) {
        var table = $('#'+component.get("v.dataTblId")).DataTable();
             table.page('previous').draw( 'page' );
    },
    onNext : function(component,event,helper) {
       var table = $('#'+component.get("v.dataTblId")).DataTable();
             table.page('next').draw( 'page' );
    },
    onFirst: function(component,event,helper) {
          var table = $('#'+component.get("v.dataTblId")).DataTable();
             table.page('first').draw( 'page' );
    },
    onLast:function(component,event,helper) {
          var table = $('#'+component.get("v.dataTblId")).DataTable();
             table.page('last').draw( 'page' );
    },
    processMe:function(component,event,helper) {
   var selectdpage = parseInt(event.target.name)-1;
               var table = $('#'+component.get("v.dataTblId")).DataTable();
             table.page(selectdpage).draw( 'page' );
     }
})