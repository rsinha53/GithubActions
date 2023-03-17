({
    leaveHandler: function(event) {
            event.returnValue = "Are you sure you want to leave? All changes will be lost!";

    },
    preventLeaving: function() {

        window.addEventListener("beforeunload", this.leaveHandler);
    },
    allowLeaving: function() {
        window.removeEventListener("beforeunload", this.leaveHandler);

    }
})