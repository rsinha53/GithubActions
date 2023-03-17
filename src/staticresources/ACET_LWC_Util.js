
(function() {
    function validateRequiredOnLoad(domValue){
          let requiredIndicatorYes = domValue.template.querySelectorAll(
            '[data-required="true"]'
          );
          let requiredIndicatorNo = domValue.template.querySelectorAll(
            '[data-required="false"]'
          );
          let overrideRequiredField = domValue.template.querySelectorAll(
            '[data-override="true"]'
          );
          console.log("overrideRequiredField");
          console.log(overrideRequiredField);
          requiredIndicatorYes.forEach((element) => {
            let overrideTemp = element.dataset.override;
            if (element.dataset.required == "true" && (element.nodeName == "LIGHTNING-INPUT" || element.nodeName == "LIGHTNING-COMBOBOX")) {
              if(overrideTemp == "true" && overrideTemp != undefined){
                element.required = false;
                if(element.previousElementSibling != null || element.previousElementSibling != undefined){
                  let innerHTMLTemp = element.previousElementSibling.innerHTML;
                  if(element.previousElementSibling.innerHTML.indexOf('<abbr ')<0){
                    element.previousElementSibling.innerHTML = '<abbr lightning-input_input="" title="required" class="slds-required">*</abbr>'+element.previousElementSibling.innerHTML
                  }
                }
              }else{
                element.required = true;  
              }
            }else if(element.dataset.required == "true" && element.nodeName == "SELECT"){
              if(element.previousElementSibling != null || element.previousElementSibling != undefined){
                let innerHTMLTemp = element.previousElementSibling.innerHTML;
                if(element.previousElementSibling.innerHTML.indexOf('<abbr ')<0){
                  element.previousElementSibling.innerHTML = '<abbr lightning-input_input="" title="required" class="slds-required">*</abbr>'+element.previousElementSibling.innerHTML
                }
              }
            }
          });
          requiredIndicatorNo.forEach((element) => {
            if (element.dataset.required == "false") {
              element.required = false;
            }
          });
    }
    window.validateRequiredOnLoad = validateRequiredOnLoad;
    
    function validateEmailField(domValue) {
        console.log("inside validateEmailField");
        let emailValidationIndicator = domValue.template.querySelectorAll(
          '[data-email-validate="true"]'
        );
        const emailRegex = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        emailValidationIndicator.forEach((element) => {
          console.log(element.value);
          let emailValue = element.value;
          if (emailValue.match(emailRegex)) {
            element.setCustomValidity("");
          } else {
            element.setCustomValidity(element.label + " is not valid");
          }
          element.reportValidity();
        });
    }
    window.validateEmailField = validateEmailField;

    function requiredFieldIndicator(domValue) {
      let emailValidationIndicator = domValue.template.querySelectorAll(
        '[data-requiredindicator="true"]'
      );
      emailValidationIndicator.forEach((element) => {
        if (element.dataset.requiredindicator == "true" && element.nodeName == "LIGHTNING-COMBOBOX") {
          console.log("picklist");
          console.log(element);
          element.childNodes.forEach((childElement) =>{
            console.log(childElement);
          });
        }  
      });
      
      
      
  }
  window.requiredFieldIndicator = requiredFieldIndicator;

})();
