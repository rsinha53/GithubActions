({
    doInit: function (cmp, event, helper) {
        helper.createDropDownList(cmp, event, helper);
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

    // US3474282 - Thanish - 15th Jul 2021 - removed unwanted code

    onTopicClick: function (cmp, event, helper) {
        var topicList = cmp.find('topicResults');
        $A.util.addClass(topicList, 'slds-is-open');
        $A.util.removeClass(topicList, 'slds-is-close');

        setTimeout(function () {
            var topicElement = document.getElementById(cmp.get("v.autodocUniqueId") + cmp.get("v.claimNo") + "topicResults");
            topicElement.scrollIntoView({
                behavior: "smooth",
                block: "start",
                inline: "nearest"
            });
        }, 100);
    },

    onTopicOut: function (cmp, event, helper) {
        var topicList = cmp.find('topicResults');
        $A.util.removeClass(topicList, 'slds-is-open');
        $A.util.addClass(topicList, 'slds-is-close');
    },

    // US3474282 - Thanish - 15th Jul 2021
    clear: function (cmp, event) {
        var selectedName = event.getSource().get("v.name");

        var selectedTopicList = cmp.get("v.selectedTopicList");
        var filtered = selectedTopicList.filter(function (value) {
            return value.fieldName != selectedName;
        });
        cmp.set("v.selectedTopicList", filtered);

        var topicList = cmp.get("v.topicList");
        for (var i = 0; i < topicList.length; i++) {
            if (topicList[i].fieldName == selectedName) {
                topicList[i].isSelected = false;
                break;
            }
        }
        cmp.set("v.topicList", topicList);
    },

    selectTopic: function (cmp, event, helper) {
        var selectedIndex = event.currentTarget.getAttribute("data-index");
        var topics = cmp.get("v.topicList");
        topics[selectedIndex].isSelected = true;
        cmp.set("v.topicList", topics);

        var selectedTopicList = cmp.get("v.selectedTopicList");
        selectedTopicList.unshift(topics[selectedIndex]); // US3474282 - Thanish - 15th Jul 2021
        cmp.set("v.selectedTopicList", selectedTopicList);

        // console.log(JSON.stringify(cmp.get("v.topicList")));
        console.log('selectedTopicList: ' + JSON.stringify(cmp.get("v.selectedTopicList")));
    },

    // US3474282 - Thanish - 15th Jul 2021
    handleOpenTopic: function (cmp, event, helper) {
        var openedTopicList = cmp.get("v.openedTopicList");
        var selectedTopicList = cmp.get("v.selectedTopicList");

        if (openedTopicList.length > 0) {
            for (var i = selectedTopicList.length - 1; i >= 0; i--) {
                if (!openedTopicList.includes(selectedTopicList[i])) {
                    openedTopicList.unshift(selectedTopicList[i]);
                }
            }

        } else {
            openedTopicList = selectedTopicList;
        }

        cmp.set("v.openedTopicList", openedTopicList);
        for (var i = 0; i < openedTopicList.length; i++) {
            helper.autodocOpenedTopic(cmp, event, helper, openedTopicList[i]);
        }

        setTimeout(function () {
            document.getElementById(cmp.get("v.autodocUniqueId") + cmp.get("v.claimNo") + "openedTopicsSection").scrollIntoView({
                behavior: 'smooth',
                block: 'center',
                inline: 'nearest'
            });
        }, 100);
    }
})