window._setAndGetInteractionOverviewStatus = (function() {
    var interactionOverviewStatus = false;
    return {
        setValue: function(inputValue) {
            interactionOverviewStatus = true;
            return interactionOverviewStatus;
        },
        
        getValue: function() {
            debugger;
            return interactionOverviewStatus;
        }
    };
}());