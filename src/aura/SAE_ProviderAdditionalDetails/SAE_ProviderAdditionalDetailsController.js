({
    additionalDetailsChange : function(cmp, event, helper) {
		// setTimeout(function () {
    //         var tabKey = cmp.get("v.AutodocKey")+'additionalDetails';
    //         window.lgtAutodoc.initAutodoc(tabKey);
    //     }, 1);
		helper.hideAdditionalDetailsSpinner(cmp);
    },

    toggleSection: function (component, event, helper) {
      var sectionAuraId = event.target.getAttribute("data-auraId");
      var sectionDiv = component.find(sectionAuraId).getElement();

      var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');

      if (sectionState == -1) {
          sectionDiv.setAttribute('class', 'slds-section slds-is-open');
      } else {
          sectionDiv.setAttribute('class', 'slds-section slds-is-close');
      }
    },

    togglePopup : function(cmp, event) {
      let showPopup = event.currentTarget.getAttribute("data-popupId");
      cmp.find(showPopup).toggleVisibility();
  },
})