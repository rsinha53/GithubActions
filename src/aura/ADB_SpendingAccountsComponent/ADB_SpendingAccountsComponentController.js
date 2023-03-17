({
    // Open CAMS URL 
    camsUrl: function (component, event, helper) {
        helper.openCAMSUrl(component, event, helper);
    },
    doInit: function (component, event, helper) {
        helper.checkUserAccess(component, event, helper);
    },
    onClickMore: function (component, event, helper) {
       component.set("v.isMoreButtonVisible",false);
       component.set("v.isMoreClicked",true);
        
    },
    onClickLess: function (component, event, helper) {
       component.set("v.isMoreButtonVisible",true);
       component.set("v.isMoreClicked",false);
    }
})