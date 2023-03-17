({
    doInit : function(component, event, helper) {
       
        var orientation = (screen.orientation || {}).type || screen.mozOrientation || screen.msOrientation;
         
        var birthDate = component.get('v.birthdate');
        component.find('birthDateId').set("v.value", birthDate);
        if(  ( (orientation === "portrait-secondary" || orientation === "portrait-primary")  &&  screen.width < 500) || ( (orientation === "landscape-secondary" || orientation === "landscape-primary")  &&  screen.height < 500)  ){
            console.log('add family small screen--------');
            component.set('v.isSmallScreen', true);
        }
        else if(screen.width < 680){
            console.log('add family small screen no orientation--------');
                         component.set('v.isSmallScreen', true);
        }
    },
    
    handleBlur : function(component,event,helper){
         console.log(component.get('v.birthdate'));
         console.log(component.find('birthDateId').get("v.value"));
         var britdate = component.find('birthDateId').get("v.value");
         console.log(britdate);
         var dobcmp = component.find("birthDateId");
         //dobcmp.setCustomValidity('') ;
         var chckvalididty = dobcmp.get("v.validity");
         console.log(chckvalididty.valid);
         if(chckvalididty.valid){
            if($A.util.isEmpty(britdate)){
               birthDateCmp.setCustomValidity("Birthdate cannot be blank.");
               console.log(britdate); 
              //  isValid = false;
            }else{
                dobcmp.setCustomValidity('') ;
               component.set('v.birthdate',component.find('birthDateId').get("v.value"));
            }
        }
        else{
          console.log('Please');
            dobcmp.setCustomValidity('Your entry does not match the allowed format M/D/YYYY');
        }
        birthDateCmp.reportValidity();
        },
    
    addMember : function(component, event, helper) {
        var isValid = true;
        var firstNameCmp = component.find('firstNameId');
        var firstName = component.get('v.firstName');
        var lastNameCmp = component.find('lastNameId');
        var lastName = component.get('v.lastName');
        var birthDateCmp = component.find('birthDateId');
        var birthDate = component.get('v.birthdate');
        
        console.log('addMember--firstName--'+birthDate);
        if($A.util.isEmpty(firstName)){
            firstNameCmp.setCustomValidity("First Name cannot be blank.");
            isValid = false;
        }
        else{
            firstNameCmp.setCustomValidity("");
        }
        firstNameCmp.reportValidity();
        if($A.util.isEmpty(lastName)){
            lastNameCmp.setCustomValidity("Last Name cannot be blank.");
            isValid = false;
        }
        else{
            lastNameCmp.setCustomValidity("");
        }
        lastNameCmp.reportValidity();
        var britdate = component.find('birthDateId').get("v.value");
        console.log(britdate);
        var dobcmp = component.find("birthDateId");
            dobcmp.setCustomValidity('') ;
            var chckvalididty = dobcmp.get("v.validity");
            console.log(chckvalididty.valid);
        if(chckvalididty.valid){
            if($A.util.isEmpty(britdate)){
               birthDateCmp.setCustomValidity("Birthdate cannot be blank.");
               console.log(britdate); 
                isValid = false;
            }else{
               component.set('v.birthdate',component.find('birthDateId').get("v.value"));
            }
           
        }
        else{
            dobcmp.setCustomValidity('Your entry does not match the allowed format M/D/YYYY');
                isValid = false;
        }
        birthDateCmp.reportValidity();
        birthDate = component.get('v.birthdate');
        if(isValid){
            console.log('addMember--isValid---');
            console.log('addMember--birthDate---'+birthDate);
            var familyId = component.get('v.familyId');
            var action = component.get("c.getCareTeamMembers");
            action.setParams({
                "firstName" : firstName,
                "lastName" : lastName,
                "dateOfBirth" : birthDate,
                "famId" : familyId,
                "memId" :component.get('v.memId')
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log('addMember--state---'+state);
                if(state === "SUCCESS") {
                    console.log('Add member SUCCESS--');
                    var evt = $A.get("e.c:SNI_FL_RefreshCmp");
                    evt.setParams({ 
                        "isRefresh" : true
                    });
                    evt.fire();
                  //component.destroy();
                }
            })
            $A.enqueueAction(action);
            
        }
    },
    closeWarning: function(component, event, helper) {
        var evt = $A.get("e.c:SNI_FL_RefreshCmp");
        evt.setParams({ 
            "isRefresh" : false
        });
        evt.fire();
        component.destroy();
    }
})