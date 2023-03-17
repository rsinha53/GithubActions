function systemUnavailableListener(checkBoxId) {
        $(checkBoxId).on("change", function() {
            if ($(this).is(":checked")) {
                $(".requiredInput").removeClass('requiredInput');
                $(".errorMsg").remove();
            } else {
                var isOtherSelected = checkIfOtherIsSelected($("[id*='callTypeCategories']:checked"));
                if (isOtherSelected) {
                    addRequiredFieldIndicator("[id$='comments']");
                }
            }
            addRequiredFieldIndicator("[id$='callTypeCategories']");
        });
    }

    function checkCallTypeOther(callTypeCheckBoxId) {
       $(callTypeCheckBoxId).on("change", function() {
		   var isOtherSelected = checkIfOtherIsSelected($("[id*='callTypeCategories']:checked"));
               if (isOtherSelected) {
                   var status = SystemUnavilablestatus();
                   if (!status) {
                       addRequiredFieldIndicator("[id$='comments']");
                   }
               } else {
                   $(".requiredInput").removeClass('requiredInput');
				   $(".errorMsg").remove();
                   addRequiredFieldIndicator("[id$='callTypeCategories']");
               }
       });
   }

    function addRequiredFieldIndicator(elemId) {
        var status = SystemUnavilablestatus("[id$='sysUnavailableChkb']");
        if (!status) {
            $(elemId).wrap('<div class="requiredInput"></div>').parent().prepend('<div class="requiredBlock"></div>');
        }
    }

    function SystemUnavilablestatus(elemId) {
        var isSystemUnavailable = $(elemId).prop("checked");
        return isSystemUnavailable;
    }

    var checkIfOtherIsSelected = function(allChecks) {
        var otherFound = false;
        for (var i = 0, iLen = allChecks.length; i < iLen; i++) {
            if ($(allChecks[i]).val() === "Other") {
                otherFound = true;
                break;
            }
        }
        return otherFound;
    };

    function validate(saveBtn) {
        var errorMsg = "You must enter a value.";
        var returnFlag = true;
        var callTypeValue = $("[id*='callTypeCategories:']:checked").map(function() {
            return this.value;
        }).get();
        var status = SystemUnavilablestatus("[id$='sysUnavailableChkb']");

        if (status) {
            $(".errorMsg").remove();
            returnFlag = true;
            return returnFlag;
        }
        
        else{
            $(".errorMsg").remove();
            if (callTypeValue == null || callTypeValue == '') {
                displayErrorMessage(errorMsg,"[id$='callTypeCategories']");
                returnFlag = false;
            } 
            else if ($.inArray('Other', callTypeValue) > -1) {
                if ($.trim($("[id$='comments']").val()) == '' || $("[id$='comments']").val().length < 1) {
                    displayErrorMessage(errorMsg,"[id$='comments']");
                    returnFlag = false;
                }
            }
        }
        return returnFlag;
    }

    function displayErrorMessage(errorMsg,elementId){
         $(elementId).parent().append('<div class = "errorMsg" ><strong>Error:</strong> ' + errorMsg + '</div>');
    }