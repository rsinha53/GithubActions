({
	toggleCaseComment: function(cmp, event) {
        var caseCommentBox = cmp.find('caseCommentBoxNew');
        // get section Div element using aura:id
        var sectionDiv = cmp.find('caseCommentBoxNew').getElement();
        /* The search() method searches for 'slds-is-open' class, and returns the position of the match.
         * This method returns -1 if no match is found.
        */
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open'); 
         // -1 if 'slds-is-open' class is missing...then set 'slds-is-open' class else set slds-is-close class to element
        if(sectionState == -1){
           $A.util.toggleClass(caseCommentBox, 'slds-is-open');
        }else{
           $A.util.toggleClass(caseCommentBox, 'slds-is-closed');
        }
    }
})