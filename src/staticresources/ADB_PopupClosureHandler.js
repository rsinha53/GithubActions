window.addEventListener("beforeunload", function (e) {
  var confirmationMessage = "\Are you sure you want to close the Dashboard?";

  (e || window.event).returnValue = confirmationMessage; //Gecko + IE
  return confirmationMessage;                            //Webkit, Safari, Chrome
});