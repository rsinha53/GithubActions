window.onload = function(){
	managePROpenSubtab();
}
function managePROpenSubtab() {
	//First find the ID of the primary tab to put the new subtab in
	sforce.console.getEnclosingPrimaryTabId(openSubtab);
}
var openSubtab = function openSubtab(result){
	primaryTabId = result.id;
	updatePrimaryId(primaryTabId);
	sforce.console.setTabTitle('Manage PR')
}
function managePRCloseSubtab() { 
	//First find the ID of the current tab to close it
	sforce.console.getEnclosingTabId(closeSubtab);
}
var closeSubtab = function closeSubtab(result) {
	//Now that we have the tab ID, we can close it
	var tabId = result.id;
	sforce.console.closeTab(tabId);
}
var currentOperation;
function refreshPrimaryTabById(operation) {
	currentOperation = operation;
	sforce.console.getEnclosingPrimaryTabId(refershPrimTab());        
};
var refershPrimTab = function refershPrimTab(result){
	sforce.console.refreshPrimaryTabById(primaryTabId, true);
	if (currentOperation === 'save') {
		setTimeout(function(){
			handleCancelEvent();
		}, 5000);
	}
}
function showMask(){
    $(".pr-mask").css("display", "block");
}
function hideMask(){
    $(".pr-mask").css("display", "none");
}
function handleCancelEvent() {
	if (sforce.console.isInConsole()) {
		managePRCloseSubtab();
		return false;
	} else {
		return true;
	}
}