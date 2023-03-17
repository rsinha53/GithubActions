({
    searchHelper : function(component,event,getInputkeyWord) {
        // Calling Apex Method
        var action = component.get('c.retrieveFamilyLinkProviderData');
        //set paramerters
        action.setParams({
            "inObjectParameters":{
                'objectName' : component.get('v.objectName'),
                'searchString' : getInputkeyWord,
                'label': component.get("v.label"),
                'selectedProviderAffliation':component.get("v.SelectedProgram")!=null?component.get("v.SelectedProgram"):null
            }
        });
            
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Records Found... message on screen. 
                if (storeResponse && storeResponse.length == 0) {
                    component.set("v.Message", "No match found with '" + getInputkeyWord + "'");
                    component.set('v.listOfSearchRecords', []);
                } else {
                    component.set("v.Message", '');
                    // set searchResult list with return value from server.
                }
                
                component.set("v.listOfSearchRecords", this.splitArray(storeResponse));
            }
        });

        // enqueue the Action  
        $A.enqueueAction(action);

    },

    splitArray:function(arr){
        let newArray = new Array();
        let advisors = new Array();
        let providerusers = new Array();
        let providerTeam = new Array();

        arr.forEach(element => {
            if(element.userType=="A"){
                advisors.push(element);
            
            }else if(element.userType=="PU"){
                providerusers.push(element);
            }else{
                providerTeam.push(element);
            }
        });

        newArray.push(this.groupArray(this.sortArray(advisors)));
        newArray.push(this.groupArray(this.sortArray(providerusers)));
        newArray.push(this.groupArray(this.sortArray(providerTeam)));
        
        
        return newArray.flat();

      
        
    },

    sortArray:function(arr){
        arr.sort((a,b)=>{
                            
            let val1 = a.label.toLowerCase(),
            val2 =b.label.toLowerCase();

            if(val1 < val2){
                return -1;
        
            }else if(val1 > val2){
                    return 1;
            }else{
                    return 0;
            }

        });
        return arr;
    },

    groupArray:function(arr){
        arr.map(val=>{
           
            if(val.userType=="A"){
                val.label=val.label.concat('(Advisor)');
                
            }else if(val.userType=="PU"){
                val.label=val.label.concat('(Provider)');
                
            }else{
                val.label=val.label.concat('(Provider Team)');
                
            }
        });
        
        
        return arr;
    }
})