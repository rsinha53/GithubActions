({
  doIInit: function(component, event, helper) {
    window.setTimeout(
      $A.getCallback(function() {
        helper.refreshHelper(component, event, helper);
      }), 10000
    );
  },
  refresh: function(component, event, helper) {
    helper.refreshHelper(component, event, helper);
    var workspaceAPI = component.find("workspace");
    var subtabId = component.get("v.subtabId");
    if (!$A.util.isUndefinedOrNull(subtabId)) {
      workspaceAPI.closeTab({
        tabId: subtabId
      });
      component.set("v.subtabId", null);
    }
  },
  handleSetActiveSection: function(cmp, event, helper) {
    var activeSectionName = cmp.find("demographicssec").get('v.activeSectionName');
    var autodoccompleted = cmp.get("v.autodoccompleted");
    if (!$A.util.isEmpty(activeSectionName) && autodoccompleted == false) {
      cmp.set("v.autodoccompleted", true);
      var tabKey = 'demographicssec' + cmp.get("v.AutodocKey");
      window.lgtAutodoc.initAutodoc(tabKey);
    }

  },
  onclickedit: function(component, event, helper) {
    var workspaceAPI = component.find("workspace");
    var subtabId = component.get("v.subtabId");
    if ($A.util.isUndefinedOrNull(subtabId)) {
      helper.launchepmpHelper(component, event, helper);
    } else {
      workspaceAPI.focusTab({
        tabId: subtabId
      }).catch(function(error) {
        console.log('subtabIderror' + error);
        if (error == 'Error: focusTab() - Could not focus tab.') {
          helper.launchepmpHelper(component, event, helper);
        }
      });

    }

  }
})