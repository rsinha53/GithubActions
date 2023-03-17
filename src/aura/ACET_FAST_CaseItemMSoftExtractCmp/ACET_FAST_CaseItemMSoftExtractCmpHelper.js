({
    loadData: function(component, event, resp){
        component.set('v.metaData',resp.fieldSets);
        console.log('resp.fileJson==>'+JSON.stringify(resp.fileJson));
        console.log('resp.fileJson.transformedOutput==>'+JSON.stringify(resp.fileJson.transformedOutput));
        var fTabList = resp.fileJson.transformedOutput;
        var tabNames = this.getTablist(component, event, fTabList);
        
        component.set('v.caseNumber', resp.caseNuber); 
        component.set('v.file', resp.fileJson);
        component.set('v.tabList',tabNames);
        component.set('v.tabsSize',tabNames.length);
        this.toggleFieldMapping(component, event);
    },
    toggleFieldMapping : function(component, event) {
		var isFieldMap = component.get("v.isFieldMapping");
        if(isFieldMap){
            component.set("v.isFieldMapping",false);
        }else{
            component.set("v.isFieldMapping",true);
        }
	},
    closePopUpWindow: function(component, event){
        $A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:refreshView').fire();
    },
    getTablist: function(component, event, tabArray){
        var tabs =[];
        console.log('tabArray==>'+JSON.stringify(tabArray));
        tabArray.forEach(function(element , index ){
            tabs.push({"tabName":element.tabName, "Id":index, 
                       "completed":false, "isOpen":false, 
                       "skipTab": false, "claimHeader":element.claimHeader});
        });
        if(tabs.length>0){
            tabs[0]["isOpen"] = true;
        }
        return tabs;
    },
    showToast: function(component, event, title,type,message ){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message
        });
        toastEvent.fire();
    },
    showSpinner: function(component, event){
        var spinner = component.find("dropdown-spinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function(component, event){
        var spinner = component.find("dropdown-spinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    getskippedTabNames: function(component, event){
        var tList = component.get("v.tabList");
        var skippedTabNames =[];
        tList.forEach(function(element){
            if(element.skipTab==true){
                skippedTabNames.push(element.tabName);
            }
        });
        return skippedTabNames;
    },
    assignSkipTabs: function(component, event, fileJSon){
        var skippedTabNames = this.getskippedTabNames(component, event);
        fileJSon.transformedOutput.forEach(function(element){
            element.isSkipped=false;
            if(skippedTabNames.includes(element.tabName)){
                element.isSkipped=true;
            }
        });
        return fileJSon;
    },
    validateTabs: function(fJson){
        console.log('fJson==>'+JSON.stringify(fJson));
        var atleaseOneTabCompleted= false;
        fJson.transformedOutput.forEach(function(element){
            if(element.isSkipped == false){
                atleaseOneTabCompleted = true;
            }
        });
        console.log('atleaseOneTabCompleted==>'+atleaseOneTabCompleted);
        return atleaseOneTabCompleted;
    }
})