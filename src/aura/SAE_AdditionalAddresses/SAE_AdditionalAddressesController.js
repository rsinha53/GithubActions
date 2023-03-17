({
    onInit: function (component, event, helper) {
        var providerType = component.get("v.providerType");

        if (providerType == "Physician") {
            component.set("v.addressColumns", [{
                    label: 'ADDRESS TYPE',
                    fieldName: 'AddressType',
                    type: 'text',
                    sortable: true
                },
                {
                    label: "ACTIVE",
                    cellAttributes: {
                        iconName: {
                            fieldName: 'ActiveClass',
                            title: 'Active'
                        }
                    },
                    initialWidth: 120
                },
                {
                    label: 'ADDRESS',
                    fieldName: 'Address',
                    type: 'text',
                    sortable: true,
                    initialWidth: 320
                },
                {
                    label: 'COUNTY',
                    fieldName: 'Country',
                    type: 'text',
                    sortable: true,
                    initialWidth: 220
                },
                {
                    label: 'PHONE',
                    fieldName: 'PhoneNumber',
                    type: 'text',
                    sortable: true,
                    initialWidth: 120
                },
                {
                    label: 'FAX',
                    fieldName: 'FAXNumber',
                    type: 'text',
                    sortable: true,
                    initialWidth: 120
                },
                {
                    label: 'EMAIL',
                    fieldName: 'Email',
                    type: 'text',
                    sortable: true
                }
            ]);
        } else if (providerType == "Facility") {
            component.set("v.addressColumns", [{
                    label: 'ADDRESS TYPE',
                    fieldName: 'AddressType',
                    type: 'text',
                    sortable: true
                },
                {
                    label: "ACTIVE",
                    cellAttributes: {
                        iconName: {
                            fieldName: 'ActiveClass'
                        },
                        iconAlternativeText: 'Active'
                    },
                    initialWidth: 120
                },
                {
                    label: 'FREESTANDING FACILITY',
                    fieldName: 'IsFreeStandingFacility',
                    type: 'text',
                    sortable: true
                },
                {
                    label: 'ADDRESS',
                    fieldName: 'Address',
                    type: 'text',
                    sortable: true
                },
                {
                    label: 'COUNTY',
                    fieldName: 'Country',
                    type: 'text',
                    sortable: true
                },
                {
                    label: 'PHONE',
                    fieldName: 'PhoneNumber',
                    type: 'text',
                    sortable: true
                },
                {
                    label: 'FAX',
                    fieldName: 'FAXNumber',
                    type: 'text',
                    sortable: true
                },
                {
                    label: 'EMAIL',
                    fieldName: 'Email',
                    type: 'text',
                    sortable: true
                }
            ]);
        }

        // US1807554 - Filter function - Thanish - 20th August 2019
        var columns = component.get("v.addressColumns");
        var items = [];
        for (var i = 0; i < columns.length; i++) {
            var item = {
                "label": columns[i].label,
                "value": columns[i].fieldName
            };
            items.push(item);
        }
        component.set("v.filterOptions", items);
    },

    //Method gets called by onsort action,
    handleSort: function (component, event, helper) {
        //Returns the field which has to be sorted
        var sortBy = event.getParam("fieldName");
        //returns the direction of sorting like asc or desc
        var sortDirection = event.getParam("sortDirection");
        //Set the sortBy and SortDirection attributes
        component.set("v.sortBy", sortBy);
        component.set("v.sortDirection", sortDirection);
        var data = component.get("v.filteredData");
        //function to return the value stored in the field
        var key = function (a) {
            return a[sortBy];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;

        // to handel number/currency type fields 
        if (sortBy == 'NumberOfEmployees') {
            data.sort(function (a, b) {
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a > b) - (b > a));
            });
        } else { // to handel text type fields 
            data.sort(function (a, b) {
                var a = key(a) ? key(a).toLowerCase() : ''; //To handle null values , uppercase records during sorting
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a > b) - (b > a));
            });
        }
        //set sorted data to accountData attribute
        component.set("v.filteredData", data);
    },
    // US1807554 - Filter function - Thanish - 20th August 2019
    filter: function (component, event, helper) {
        var addressData = component.get("v.addressData");
        var filteredData = [];
        var filterString = component.find("searchBox").get("v.value").toUpperCase();
        var filterOptions = component.get("v.filterOptions");

        if (filterString.length > 0) {
            // Traverse the list of records
            for (var i = 0; i < addressData.length; i++) {
                // Traverse the columns of a record
                for (var j = 0; j < filterOptions.length; j++) {
                    // Filter
                    // US1816890 - Sanka
                    if (addressData[i][filterOptions[j].value] != null) {
                        var txt = addressData[i][filterOptions[j].value].toUpperCase();
                        if (txt.indexOf(filterString) > -1) {
                            filteredData.push(addressData[i]);
                            break;
                        }
                    }
                }
            }
            component.set("v.filteredData", filteredData);
        } else {
            component.set("v.filteredData", addressData);
        }
    },

    comboBoxChange: function (component, event, helper) {
        component.set("v.filterColumn", component.find("columnComboBox").get("v.value"));
    },

    // US1816890 - Sanka
    providerIdChange: function (component, event, helper) {
        helper.getProviderData(component, event, helper, 0);
    },

    scriptsLoaded: function (component, event, helper) {
        console.log('loaded');
    },

    getNext: function (component, event, helper) {
        var nextNumber = component.get("v.currentPageBlock") + 1;
        component.set("v.currentPageBlock", nextNumber);
        helper.getNextPageSet(component);
    },

    getPrevious: function (component, event, helper) {
        var prevNumber = component.get("v.currentPageBlock") - 1;
        component.set("v.currentPageBlock", prevNumber);
        helper.getNextPageSet(component);
    },

    gotoPage: function (component, event, helper) {
        var selectedNumber = parseInt(event.target.name);
        component.set("v.currentPageNumber", selectedNumber);
        var pageOffset = component.get("v.pageOffset");
        var reqBottom = (selectedNumber - 1) * pageOffset;
        helper.getProviderData(component, event, helper, reqBottom);
    },

    gotoFirst: function (component, event, helper) {
        component.set("v.currentPageNumber", 1);
        component.set("v.currentPageBlock", 1);
        helper.getProviderData(component, event, helper, 0);
    },

    gotoLast: function (component, event, helper) {
        var selectedNumber = component.get("v.totalPages");
        component.set("v.currentPageNumber", selectedNumber);
        var pageOffset = component.get("v.pageOffset");
        var reqBottom = (selectedNumber - 1) * pageOffset;
        var currentPageBlock = component.get("v.lastPageBlock");
        component.set("v.currentPageBlock", currentPageBlock);

        helper.getProviderData(component, event, helper, reqBottom);
    },

})