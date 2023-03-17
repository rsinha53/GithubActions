({
   handleExpand: function(cmp, event, helper) {
        var panelExpanded = cmp.get('v.panelExpanded');
        if (panelExpanded) {
            cmp.set('v.panelExpanded', false);
        } else {
            cmp.set('v.panelExpanded', true);
        }

        //window.localStorage.setItem('highPanel', 'hideSave');
    },
    doInit: function(cmp, event, helper) {
		
        
        console.log("values hglt:: "+cmp.get("v.highlightPanelValues"));
     // var hlghtdata = cmp.get("v.highlightPanelValues");
    //    console.log('-------hlghtdata.IsMemberNotfound-------'+hlghtdata.IsMemberNotfound);
     //   if(hlghtdata!=undifiend && hlghtdata!=null){
     //       cmp.set("v.Ismnf",hlghtdata.IsMemberNotfound);
    //    }

        //setTimeout(function(){
        	//window.lgtAutodoc.initAutodoc();
        //},1);
        var ShowComments = cmp.get("v.ShowComments");
        //alert("---0---");
        if(ShowComments){
            setTimeout(function(){
                var pageKey = cmp.get("v.AutodocKey");
                var pageClass = cmp.get("v.pageFeature");
                //alert("---1---"+pageKey);
                if(window.lgtAutodoc != undefined){
                    window.lgtAutodoc.createCommentsbox(pageKey,pageClass);
                }
            },2000);
        }
    }, 

    handleHighlighValues: function(component, event, helper){

        console.log("old value: " + event.getParam("oldValue"));
        console.log("current value: " + event.getParam("value"));
        console.log("current : "+JSON.stringify(event.getParam("value")));
        component.set("v.highlightPanelValues2", event.getParam("value"));
        //component.set("v.highlightPanelValues", event.getParam("value"));
    }
})