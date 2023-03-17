window._setandgetvalues = (function () {
    var contactDetails = new Map();
    
    return {
        setContactValue: function(uniqueId, contactName, contactNumber,contactExt,contactFirstName,contactLastName) {
            var contactData = {
                "contactName":contactName,
				"contactFirstName":contactFirstName,
				"contactLastName":contactLastName,
                "contactNumber":contactNumber,
                "contactExt":contactExt
            };
            contactDetails.set(uniqueId,contactData);
            return contactDetails;
        },
        
        getContactValue: function(uniqueId) {
            if (contactDetails.get(uniqueId) != null) {
                return contactDetails.get(uniqueId);
            }
            return null;
        }
    };
}());
