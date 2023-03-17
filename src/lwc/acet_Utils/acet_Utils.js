export function validateRequiredOnLoad(domValue) {
    let requiredIndicatorYes = domValue.template.querySelectorAll(
      '[data-required="true"]'
    );
    let requiredIndicatorNo = domValue.template.querySelectorAll(
      '[data-required="false"]'
    );
    requiredIndicatorYes.forEach((element) => {
      if (element.dataset.required == "true") {
        element.required = true;
      }
    });
    requiredIndicatorNo.forEach((element) => {
      if (element.dataset.required == "false") {
        element.required = false;
      }
    });
  }
export  function validateRequiredFields(domValue) {
  if(domValue!= null || domValue != undefined){
    if(domValue.template != null || domValue.template != undefined){
      let requiredIndicatorYes = domValue.template.querySelectorAll(
        '[data-required="true"]'
      );
      requiredIndicatorYes.forEach((element) => {
        if (!element.value) {
          if (element.dataset.required == "true") {
            element.setCustomValidity("Complete this field.");
          } else {
            element.setCustomValidity(""); // clear previous value
          }
          element.reportValidity();
        } else {
          element.setCustomValidity(""); // clear previous value
          element.reportValidity();
        }
      });  
    }else{
      let requiredIndicatorYes = domValue.querySelectorAll(
        '[data-required="true"]'
      );
      requiredIndicatorYes.forEach((element) => {
        if (!element.value) {
          if (element.dataset.required == "true") {
            element.setCustomValidity("Complete this field.");
          } else {
            element.setCustomValidity(""); // clear previous value
          }
          element.reportValidity();
        } else {
          element.setCustomValidity(""); // clear previous value
          element.reportValidity();
        }
      });  
    }
  }
  
    
}
export function validateEmailField(domValue) {
    let emailValidationIndicator = domValue.template.querySelectorAll(
      '[data-email-validate="Yes"]'
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