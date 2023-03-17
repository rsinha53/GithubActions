({
    initialize: function(component, event, helper){
        helper.showSpinner(component,event);
        var action = component.get("c.getLobValues");
        action.setParams({"caseRecId":component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log("result==>"+JSON.stringify(result));
                component.set("v.lobList",result.lobList);
                component.set("v.caseRecordTypeName",result.caseRectypeName);
                component.set("v.rpRectypeId",result.rpRecordtypeId);
            }
            helper.hideSpinner(component,event);
        });
        $A.enqueueAction(action);
    },
    handleLobChange: function(component, event, helper){
        helper.showSpinner(component,event);
        component.set("v.selectedCategory","");
        component.set("v.CategoryList",[]);
        component.set("v.selectedSubCategory","");
        component.set("v.SubCategoryList",[]);
        var selectedLob = event.getSource().get("v.value");
        
        var action = component.get("c.getCategoryValues");
        action.setParams({"lobValue":selectedLob});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.CategoryList",result);
            }
            helper.hideSpinner(component,event);
        });
        $A.enqueueAction(action);
    },
    handleCategoryChange: function(component, event, helper){
        
        helper.showSpinner(component,event);
        component.set("v.selectedSubCategory","");
        component.set("v.SubCategoryList",[]);
        var selCategory = component.get("v.selectedCategory");
            
        var action = component.get("c.getSubCategoryValues");
        action.setParams({"categoryValue":selCategory});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.SubCategoryList",result);
            }
            helper.hideSpinner(component,event);
        });
        $A.enqueueAction(action);
    },
    handleSubCategoryChange: function(component, event, helper){
        helper.showSpinner(component,event);
        var selSubCategory =component.get("v.selectedSubCategory");
        console.log("selectedSubCategory from here==>"+selSubCategory);
        helper.hideSpinner(component,event);
    },
    runQuery: function(component, event, helper){
        helper.showSpinner(component,event);
        var lobVar = component.get("v.selectedLob");
        var categoryVar = component.get("v.selectedCategory");
        var subCategoryVar = component.get("v.selectedSubCategory");
        var gSearchStrVar = component.get("v.globalSearchStr");
        var globalSearch = (gSearchStrVar !=null && gSearchStrVar !='' && gSearchStrVar.length>1) ? true : false;
        
        if((lobVar!='' && lobVar!='') || globalSearch==true){
            
            component.set("v.activeSections",['A','B']);
            component.set("v.hideListSectionFirstTime",false);
            
            var action = component.get("c.getProverMatrixRecs");
            action.setParams({
                "lob" : lobVar,
                "category" : categoryVar,
                "subCategory" : subCategoryVar,
                "globalStr" : gSearchStrVar,
                "isGlobalSearch" : globalSearch
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    var result = response.getReturnValue();
                    result.forEach(function(record){
                        record.linkName = '/'+record.Id;
                        record.Name='View';
                        record.variantValue = 'base';
                    });
					var resulJson = JSON.stringify(result);
                    console.log('resulJson==>'+resulJson);
                    if(result!=null && result!= undefined && result.length>0){
                        helper.initaitePagination(component, event, helper, result);
                    }else{
                        component.set("v.errMEssage", "No Records to display to the search criteria");
                        component.set("v.data",null);
                    }
                    helper.hideSpinner(component,event);
                }
                else{
                    component.set("v.errMEssage", "There was a error while retriving the data");
                    component.set("v.data",null);
                    helper.hideSpinner(component,event);
                }
                component.set("v.rLob",lobVar);
                component.set("v.rCategory",categoryVar);
                component.set("v.rSCategory",subCategoryVar);
                component.set("v.rGlobalSearch",gSearchStrVar);
            });
            $A.enqueueAction(action);
        } 
        else{
            component.set("v.activeSections",['A']);
            component.set("v.hideListSectionFirstTime",true);
            helper.hideSpinner(component,event);
            var title="Warning"
            var type="warning";
            var message = "Please provide proper search criteria to perform search";
            helper.showToast(component, event, title, type,message);
        }
    },
    onNext: function(component, event, helper){        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber+1);
        helper.buildData(component, helper);
    },
    onPrev: function(component, event, helper){        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber-1);
        helper.buildData(component, helper);
    },
    processMe: function(component, event, helper){
        component.set("v.currentPageNumber", parseInt(event.target.name));
        helper.buildData(component, helper);
    },
    onFirst: function(component, event, helper){        
        component.set("v.currentPageNumber", 1);
        helper.buildData(component, helper);
    },
    onLast: function(component, event, helper){        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.buildData(component, helper);
    },
    reset: function(component, event, helper){
        component.set("v.activeSections",['A']);
        component.set("v.hideListSectionFirstTime",true);
        component.set("v.selectedLob","");
        component.set("v.selectedCategory","");
        component.set("v.selectedSubCategory","");
        component.set("v.globalSearchStr","");
        
        component.set("v.rLob",'');
        component.set("v.rCategory",'');
        component.set("v.rSCategory",'');
        component.set("v.rGlobalSearch",'');
        
        var title="Success"
        var type="success";
        var message = "Reset Successfull";
        helper.showToast(component, event, title, type,message);
    },
    handleRowAction: function (component, event, helper){
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'selectRecord':
                helper.openRecord(component, event, row.Id);
                break;
            case 'CreateRP':
                //helper.openAction(component, event, row.Id);
                helper.openPopOver(component, event, row.Id);
                break;
        }
    },
    closeAction: function(component, event, helper){
        helper.closePopUp(component, event);
    },
})