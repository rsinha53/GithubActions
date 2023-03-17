({
    hFChange:function(component, event, helper, inputValue){
        const displayOrder = event.getSource().get('v.label');
        var fArray=component.get("v.fieldSets");
        const nextIndex = displayOrder+1;
        var selectedValues = [];
        for(var p=0; p<fArray.length; p++){
            if(p!=displayOrder){
                var selVal = fArray[p]["selectedValue"];
                console.log('selVal==>'+selVal);
                if(selVal!=''){
                    selectedValues.push(selVal);   
                }   
            }
        }
        console.log('selectedValues==>'+JSON.stringify(selectedValues));
        if(selectedValues.includes(inputValue)){
            fArray[displayOrder]["selectedValue"]='';   
            var message = '"'+inputValue+'"'+ ' is already selected Please select a different value';
            this.showToast(component, event, 'Error', 'Error', message);
        }
        else{
        	fArray[displayOrder]["selectedValue"]=inputValue;    
        }
        component.set("v.fieldSets",fArray);
        if(nextIndex==fArray.length){
            component.set("v.allfieldsFields", true);
        }else{
            component.set("v.allfieldsFields", false);
        }
    },
    assignFields : function(component, hList, dispOrder){
        var fieldArray=component.get("v.fieldSets");
        for(var j=0; j<fieldArray.length; j++){
            if(dispOrder==fieldArray[j]["displayOrder"]){
                fieldArray[j]["displayList"] = hList;
                break;
            }
        }
        component.set("v.fieldSets",fieldArray);
    },
    getNewList: function(pList, selVal){
        var hList =[];
        for(var q=0;q<pList.length; q++){
            if(pList[q]!=selVal){
                hList.push(pList[q]);   
            }
        }
        return hList;
    },
    prepareFieldMap: function(component, event){
        var fieldsArray = component.get("v.fieldSets");
        var fieldsMap={};
        for(var i=0;i<fieldsArray.length; i++){
            var selectedValue = fieldsArray[i]["selectedValue"];
            fieldsMap[selectedValue] = fieldsArray[i]["fieldApi"];
        }
        return fieldsMap;
    },
    assignFieldsList: function(fields){
        var fieldLsit = [];
        fields.forEach(function(element){
            fieldLsit.push({"fieldLabel":element.Field_Label__c, 
                            "fieldApi":element.Field_API__c,
                            "selectedValue":'',
                            "displayOrder":element.Display_Order__c,
                            "displayList" :[]
                           });
        });
        return fieldLsit;
    },
    validateFields: function(component){
        var isCompleted = false;
        var fArray=component.get("v.fieldSets");
        for(var p=0; p<fArray.length; p++){
            if(fArray[p]["selectedValue"]!='' && fArray[p]["fieldLabel"]!='Provider Comments'){
                isCompleted=true;
                break;
            }
        }
        return isCompleted;
    },
    completeCurrTab: function(component, event, helper){
        var currentTab = component.get("v.singleTab");
        console.log('currentTab==>'+JSON.stringify(currentTab));
        var fieldsMap = helper.prepareFieldMap(component, event);
        for(var i=0; i<currentTab["claimHeader"].length;i++){
            var exField = currentTab["claimHeader"][i]["excelField"];
            if(fieldsMap.hasOwnProperty(exField)){
                currentTab["claimHeader"][i]["spireField"] = fieldsMap[exField];
            }
        }
        currentTab["isOpen"] = false;
        currentTab["completed"] = true;
        
        var tabs = component.get("v.tabList");
        var ind = component.get("v.currentRow");
        tabs[ind] = currentTab;
        component.set("v.tabList",tabs);
        component.set("v.singleTab",currentTab);
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
})