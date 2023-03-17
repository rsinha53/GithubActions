let strNewPassword, strConfirmPassword;
var j$ = jQuery.noConflict();
j$(document).ready(function() {
	//j$("[id$=idTopsPassword]").mask("********");
	
});
function toggleMainDiv() {
	if(document.getElementById('idChevronUp') != null && document.getElementById('idChevronUp').classList.contains('toggleClass') === true) {
		document.getElementById('idChevronUp').classList.remove('toggleClass');
	} else {
		document.getElementById('idChevronUp').classList.add('toggleClass');
	}
	if(document.getElementById('idChevronDown') != null && document.getElementById('idChevronDown').classList.contains('toggleClass') === true) {
		document.getElementById('idChevronDown').classList.remove('toggleClass');
	} else {
		document.getElementById('idChevronDown').classList.add('toggleClass');
	}
	
	if(document.getElementById('idMainDiv') != null && document.getElementById('idMainDiv').classList.contains('toggleClass') === true) {
		document.getElementById('idMainDiv').classList.remove('toggleClass');
	} else {
		document.getElementById('idMainDiv').classList.add('toggleClass');
	}
}

function togglePasswordError() {
	if(document.getElementById('idPasswordError') != null && document.getElementById('idPasswordError').classList.contains('slds-hide') === true) {
		document.getElementById('idPasswordError').classList.remove('slds-hide');
	} 
}

function closePasswordError() {
	if(document.getElementById('idPasswordError') != null && document.getElementById('idPasswordError').classList.contains('slds-hide') === false) {
		document.getElementById('idPasswordError').classList.add('slds-hide');
	}         	
}

function validatePassword() {
	var j$ = jQuery.noConflict();
	let strNewPassword = j$('[id$=idNewPwd]').val();
	let strConfrimPassword =j$('[id$=idConfirmPwd]').val();
	let maxNumberofChars = 8;
	let regularExpression  = /^(?=.*[0-9])(?=.*[!@#$*()])[a-zA-Z0-9!@#$*()]{8,8}$/;
	
	if((strNewPassword === '' || strNewPassword === null || strConfrimPassword === '' || strConfrimPassword === null) || validateSame()) {
		j$('[id$=idErrorMessage]').removeClass('slds-hide'); 
		return;
	} else {
		j$('[id$=idErrorMessage]').addClass('slds-hide');
	}
	
	if(strNewPassword.length < maxNumberofChars || strNewPassword.length > maxNumberofChars){
		togglePasswordError();
		return false;
	}
	
	if(!regularExpression.test(strNewPassword)) {
		togglePasswordError();
		return false;
	}
	//Call Update Password ActionFunction
	callUpdatePassword();
	
}

function validateSame() {
	var boolShowError = false;
	var j$ = jQuery.noConflict();
	let strNPassword = j$('[id$=idNewPwd]').val();
	let strConPassword =j$('[id$=idConfirmPwd]').val();
	if(strNPassword !== '' && strNPassword !== null && strConPassword !== '' && strConPassword !== null && strNPassword !== strConPassword) {
		j$('[id$=idErrorMessage]').removeClass('slds-hide'); 
		boolShowError = true;
	} else {
		j$('[id$=idErrorMessage]').addClass('slds-hide');
		boolShowError = false;
	}
	return boolShowError;
}

function callComplete(idUserid) {
	if(idUserid !== '' && idUserid !== null && idUserid !== 'undefined' ) {
		j$('[id$=idSucessMessage]').removeClass('slds-hide'); 
	} else {
		// Do Nothing
	}
}