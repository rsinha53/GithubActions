({
	doInit : function(component, event,handler) {
        
        //if(component.find("covDet") != undefined && component.find("covDet").getElement() != undefined)
        //component.find("covDet").getElement().focus();
                
        setTimeout(function(){
            var tabKey = component.get("v.AutodocKey");
            //alert("tabKey"+tabKey);
            window.lgtAutodoc.initAutodoc(tabKey);
            //alert("Done");
            //var MemberdetailFromGroup = component.get("v.MemberdetailFromGroup").enrollmentMethod;
            //alert("Done-1");
            //var orgType = component.get("v.originatorType");
            //console.log("SSS Coverage Benefit" + MemberdetailFromGroup);
        	component.set("v.Spinner", false);
            
            
        },1);
        
        //acet.autodoc.startAutodoc();
        //alert('---In cov details---');
        //window.lgtAutodoc.initAutodoc();
        //window.lgtAutodoc.initAutodoc();
        
        //helper.showSpinner2(component,event,helper);
        //setTimeout(function(){
            //window.utilMethods.method1();
        	//window.lgtAutodoc.initAutodoc();
        //},1);
        //helper.hideSpinner2(component,event,helper);
        
        //console.log('~~~Event~~~memberDetail~2~~>>'+memberDetail);
    }
})