({
    doInint : function(component, event, helper) {
        console.log('init');
        var a = document.getElementsByClassName('accumulators');
        console.log('a ', a);
        var div = document.createElement("div");
        div.setAttribute('style', 'color:red');
        div.setAttribute('class', 'error_email');
        var span = document.createTextNode("<b>Sit:-</b> <br />nulla est ex deserunt exercitation anim occaecat. Nostrud ullamco deserunt aute id consequat veniam incididunt duis in sint irure nisi.");
        div.appendChild(span);
        a[0].firstChild.firstElementChild.appendChild(div);
    },

    loadNetworkOptions: function (component, event, helper) {
        var opts = [
            { value: "inNet", label: "In-Network" },
            { value: "outNet", label: "Out Of Network" }
        ];
        component.set("v.options", opts);
    },

    planBenifitToggle: function (cmp, event, helper) {
         var isExpand = event.currentTarget.getAttribute("data-Attr");
        console.log('isExpand::'+isExpand);
        if(isExpand == 'false') {
            
        	console.log('v.isExpand callout: ', cmp.get("v.isExpand")); 
            cmp.set("v.isExpand", true);
        	helper.getDataFromServer(cmp, event, helper);
        } else {
            
        console.log('v.isExpand no callout : ', cmp.get("v.isExpand")); 	
            cmp.set("v.isExpand", false);
        }     
    },

    doCollapseChange: function (cmp, event, helper) {
        var oldValue = event.getParam("oldValue");
        var value = event.getParam("value");
        console.log('oldValue : ' + oldValue + '   value : ' + value);
        if(value != undefined && !value){
            cmp.set('v.hasRequestSend', false);
            cmp.set("v.isExpand", false);
        }
        
    },

    toggleHelpTextHover: function(component, event, helper) {
        var innHover = component.get("v.isInnHoverVisible");
        var oonHover = component.get("v.isOnnHoverVisible");
        if('inn' == event.target.dataset.section) {
            component.set("v.isInnHoverVisible", !innHover);
        } else if('onn' == event.target.dataset.section) {
            component.set("v.isOnnHoverVisible", !oonHover);
        }
    }

})