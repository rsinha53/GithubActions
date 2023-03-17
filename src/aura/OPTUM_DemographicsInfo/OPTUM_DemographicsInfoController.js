({ 
    doInit: function(component, event, helper) {
       helper.phonenumberFormat(component, event, helper);
       helper.AddressLines(component, event, helper);
       helper.HomeAddressLines(component, event, helper);
       //Added by Iresh, Field mapping-Primary phone indicator: US3083536
       helper.PhonePreferred(component, event, helper);
    },
   // Added by Sanjay for US3150934: Update Demographics - Validation
   openModal: function(component, event, helper) {
       helper.populateData(component, event, helper);
   },
   // Added by Sanjay for US3150934: Update Demographics - Validation
   closeModal: function(component, event, helper) {
       component.set("v.isOpen", false);
   },
   // Added by Sanjay for US3150934: Update Demographics - Validation
   save: function(component, event, helper) {
       helper.saveData(component, event, helper);
   },
   //Added by prasad -US3296038: Preferred Phone update
   handleChange : function(component, event, helper) {
    var radioGrpValue = component.get("v.value");
   }
})