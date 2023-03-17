({
    sortBy : function(component, field) {
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField");
        if(sortField == "CreatedDate"){
            var  records = component.get("v.ProactiveRPlist"); 
        } else {
            records = component.get("v.RPlist");
        }
        
        sortAsc = sortField != field || !sortAsc;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1? 0: (sortAsc?-1:1)*(t2?1:-1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        if(sortField == "CreatedDate"){
            component.set("v.ProactiveRPlist", records);
        } else {
            component.set("v.RPlist", records);
        }               
    },
    getProactiveRPRec : function(component,event){
        var action = component.get('c.getProactiveRPRec');
        action.setCallback(this, function (actionResult) {
            var state = actionResult.getState();
            console.log('state-->'+ state);
            if (state === "SUCCESS") {
                var successData = actionResult.getReturnValue();
                console.log('successData-->'+ successData);
                component.set("v.ProactiveRPlist",successData);              
                component.set("v.displayTable",true);
                if( successData.length == 0 && component.get("v.userRole") == "PIR - Proactive Action" ){
                    console.log('inside display error -- Proactive');
                    component.set("v.displayError",true);
                }
                console.log('Proactive user role-->'+ component.get("v.userRole"));
                
            }
        });
        $A.enqueueAction(action);
    },
    getUserDetail : function(component,event){
        var action = component.get("c.getUserDetails");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.userDetails",result);
                console.log('-result-'+ JSON.stringify(result) );
                console.log('-role-'+ result.UserRoleId);
                
                if(result.UserRoleId != undefined && result.UserRole.Name == 'PIR - Proactive Action' ){
                    component.set("v.pipUser",true);
                }else{
                    component.set("v.fastUser",true);
                }
            }
        });
        $A.enqueueAction(action);
    },
    getReactiveRPRec : function(component,event){
        var action = component.get('c.resolutionData');
        action.setCallback(this, function (actionResult) {
            var state = actionResult.getState();
            
            if (state === "SUCCESS") {
                var successData = actionResult.getReturnValue();
                console.log('Reactive successData--'+JSON.stringify(successData));
                console.log('Reactive successData len--'+successData.length);
                component.set("v.RPlist",successData.resolutionList);
                component.set("v.userRole",successData.UserRoleName);
                component.set("v.displayTable",true);
                if( successData.length == 0){
                    console.log('inside display error -- Reactive');
                    component.set("v.displayError",true);
                }
                console.log('Reactive user role-->'+ component.get("v.userRole"));
                
            }
        });
        $A.enqueueAction(action);
    }
    
})