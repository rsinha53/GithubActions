({
    
     doInit : function (component, event, helper) {
    	 helper.getUserInfo(component);
         
	},
            
    closeModal : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();   
    },
    
	handleSave: function(component, event, helper) {
        
        let Salutation = component.find("Salutation").get("v.value");
        let FirstName = component.find("FirstName").get("v.value");
        let LastName = component.find("LastName").get("v.value");
        let Email = component.find("Email").get("v.value");
        if(!LastName){
            helper.showToast(component, 'error', 'ERROR', 'LastName required');
            return;
        }
        let regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;  
  		if(Email){
       		 if(!Email.match(regExpEmailformat)){
				  helper.showToast(component, 'error', 'ERROR', 'Please Enter a Valid Email Address');
             }else{
                  helper.createAccount(component,Salutation,FirstName,LastName,Email);  
             }
        }else{
             helper.createAccount(component,Salutation,FirstName,LastName,Email);  
        }
       
        

	}   
    
})