({
    updateRecords: function(component, event, isNext) {
        var claimsList = component.get('v.claimsList');
        var defaultRecords = component.get('v.defaultRecords');
        var numStart = component.get('v.numStart');
        var recCount = Object.keys(claimsList).length;
        var filteredClaims = [];
        var numEnd = 0;
        var isChangedData = false;
        if (isNext) {
            for (var i = numStart; i < (numStart + defaultRecords); i++) {
                if (recCount > i) {
                    isChangedData = true;
                    filteredClaims.push(claimsList[i]);
                    component.set('v.numStart', (component.get('v.numStart') + 1));
                } else {
                    break;
                }
            }
            if (isChangedData) {
                component.set('v.filteredClaims', filteredClaims);
            }
        } else {
            var filteredCount = Object.keys(component.get('v.filteredClaims')).length;
            numStart = (numStart - filteredCount);
            var filteredClaims = [];;
            var index = ((numStart - defaultRecords));
            for (var i = index; i < numStart; i++) {
                if (claimsList[index] != undefined) {
                    isChangedData = true;
                    filteredClaims.push(claimsList[i]);
                } else {
                    break;
                }
            }
            if (isChangedData) {
                component.set('v.numStart', numStart);
                component.set('v.filteredClaims', filteredClaims);
            }
        }
    },

    sortHelper: function(component, event, sortFieldName) {
        var currentDir = component.get("v.arrowDirection");
        if (currentDir == 'arrowdown') {
            component.set("v.arrowDirection", 'arrowup');
            component.set("v.isAsc", true);
        } else {
            component.set("v.arrowDirection", 'arrowdown');
            component.set("v.isAsc", false);
        }
    },
    //US1974673: Bharat added start
    sortData : function(component,fieldName,sortDirection){
        var data = component.get("v.claimsList");
        console.log('data====>'+JSON.stringify(data));
        console.log('fieldName====>'+fieldName);
        //function to return the value stored in the field
        var key = function(a) { return a[fieldName]; }
        if(sortDirection == 'arrowup') {
            component.set("v.arrowDirection", 'arrowdown');
        }else{
            component.set("v.arrowDirection", 'arrowup');
        }
        sortDirection = component.get("v.arrowDirection");
        var reverse = sortDirection == 'arrowdown' ? 1: -1;

        // to handel number/currency type fields
        // Fixing exception
        if (fieldName == 'ClaimNumber' || fieldName == 'ID') {
            data.sort(function(a,b){
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a>b) - (b>a));
            });
        }
        else{// to handel text type fields
            data.sort(function(a,b){
                var a = key(a) ? key(a).toLowerCase() : '';//To handle null values , uppercase records during sorting
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a>b) - (b>a));
            });
        }
        //set sorted data to accountData attribute
        component.set("v.claimsList",data);
    },



    ClaimsearchResults: function(cmp,event,helper){
        cmp.set("v.claimSearchFlag",false);
        var value = event.getSource().get("v.value").toLowerCase();
        console.log('searchvale===>'+value);
        var claimsList = cmp.get("v.claimsList");
        var varClaimsFullList = cmp.get("v.claimsFullList");
        if(value == undefined || value == ''){
            console.log('value is null');
            cmp.set('v.claimsList', claimsList);

            this.resetPages(cmp,helper);
            this.buildData(cmp, helper);
            return;
        }
        var claimLsttemp = [];
        for (var i = 0; i < varClaimsFullList.length; i++) {
                    console.log('data tablen inside');


         if((varClaimsFullList[i].claimNumber != null && varClaimsFullList[i].claimNumber != '') && varClaimsFullList[i].claimNumber.toLowerCase().indexOf(value) != -1 ||
                (varClaimsFullList[i].taxID != null && varClaimsFullList[i].taxID != '') && varClaimsFullList[i].taxID.toLowerCase().indexOf(value) != -1 ||
                (varClaimsFullList[i].providerID != null && varClaimsFullList[i].providerID != '') && varClaimsFullList[i].providerID.toLowerCase().indexOf(value) != -1 ||
               	(varClaimsFullList[i].providerName != null && varClaimsFullList[i].providerName != '') && varClaimsFullList[i].providerName.toLowerCase().indexOf(value) != -1 ||
               	(varClaimsFullList[i].DOSStart != null && varClaimsFullList[i].DOSStart != '') && varClaimsFullList[i].DOSStart.toLowerCase().indexOf(value) != -1 ||
                (varClaimsFullList[i].DOSEnd != null && varClaimsFullList[i].DOSEnd != '') && varClaimsFullList[i].DOSEnd.toLowerCase().indexOf(value) != -1 ||
                (varClaimsFullList[i].charged != null && varClaimsFullList[i].charged != '') && varClaimsFullList[i].charged.toLowerCase().indexOf(value) != -1 ||
                (varClaimsFullList[i].receivedDate != null && varClaimsFullList[i].receivedDate != '') && varClaimsFullList[i].receivedDate.toLowerCase().indexOf(value) != -1 ||
                (varClaimsFullList[i].status != null && varClaimsFullList[i].status != '') && varClaimsFullList[i].status.toLowerCase().indexOf(value) != -1 ||
				(varClaimsFullList[i].processDate != null && varClaimsFullList[i].processDate != '') && varClaimsFullList[i].processDate.toLowerCase().indexOf(value) != -1) {
                claimLsttemp.push(varClaimsFullList[i]);
            }
        }
        if(claimLsttemp.length > 0){
            console.log('claim lenght checkinmg');
            cmp.set('v.claimsList', claimLsttemp);
      }else{
           console.log('claim lenght checkinmg is zero');
           cmp.set('v.claimsList', []);
           cmp.set("v.claimSearchFlag",true);
        }

        this.resetPages(cmp,helper);
        this.buildData(cmp, helper);
    },

    resetPages: function(cmp,helper){
        console.log('reset pages in sdie');
        if (Math.ceil(cmp.get('v.claimsList').length / cmp.get("v.pageSize")) == 0) {
            cmp.set("v.totalPages", 1);
        } else {
            cmp.set("v.totalPages", Math.ceil(cmp.get('v.claimsList').length / cmp.get("v.pageSize")));
        }
        //DE318080 - Ends
        cmp.set("v.currentPageNumber", 1);
       cmp.set("v.sortDirection", "desc");
        cmp.set("v.sortBy", "CaseNumber");
    },


    			   //US1918617 :Venkat added 151 to 238

      buildData : function(cmp, event,helper) {


       var data = [];
        var pageNumber = cmp.get("v.currentPageNumber");
        var pageSize = cmp.get("v.pageSize");
        var claimsLst = cmp.get("v.claimsList");
          cmp.set("v.totalPages", Math.ceil(claimsLst.length/cmp.get("v.pageSize")));
        console.log('page Number'+ pageNumber);
        console.log('all claimlist data in build'+ cmp.get("v.totalPages"));

        if(pageNumber == 1){
            var endNumber = claimsLst.length > pageSize ? pageSize : claimsLst.length;
            cmp.set("v.currentEndNumber", endNumber);
            cmp.set("v.currentStartNumber", 1);
        }
                    var x = (pageNumber-1)*pageSize;

        //creating data-table data
        for(; x<(pageNumber)*pageSize; x++){
            if(claimsLst[x]){
            	data.push(claimsLst[x]);
            }
        }

  var tempObj = {
            "claimNumber":'',
            "taxID": '',
            "providerID": '',
            "providerName": '',
            "DOSStart": '',
            "DOSEnd":'',
            "charged": '',
            "receivedDate":'',
            "status": '',
            "processDate":''
        };
        var newClaimLstTemp = [];
        for(var i = 0; i < data.length;i++){
            tempObj = new Object();
            tempObj.claimNumber = data[i].claimNumber;
            tempObj.taxID = data[i].taxID;
            tempObj.providerID = data[i].providerID;
            tempObj.providerName = data[i].providerName;
            tempObj.DOSStart = data[i].DOSStart;
            tempObj.DOSEnd=data[i].DOSEnd;
            tempObj.charged = data[i].charged;
            tempObj.status = data[i].status;
            tempObj.receivedDate = data[i].receivedDate;
            tempObj.processDate = data[i].processDate;
            console.log('temporary records '+tempObj);

            newClaimLstTemp.push(tempObj);
        }
        cmp.set("v.data", newClaimLstTemp);

                     cmp.set("v.claimSearchFlag",false);


      this.generatePageList(cmp, pageNumber);

    },
        generatePageList : function(cmp, pageNumber){
        pageNumber = parseInt(pageNumber);
        var pageList = [];
          console.log('generate page list'+pageNumber);
        var totalPages = cmp.get("v.totalPages");
              //  var totalPages = cmp.get("v.totalPages");

        if(totalPages > 1){
            if(totalPages <= 10){
                var counter = 2;
                for(; counter < (totalPages); counter++){
                    pageList.push(counter);
                }
            } else{
                if(pageNumber < 5){
                    pageList.push(2, 3, 4, 5, 6);
                } else{
                    if(pageNumber>(totalPages-5)){
                        pageList.push(totalPages-5, totalPages-4, totalPages-3, totalPages-2, totalPages-1);
                    } else{
                        pageList.push(pageNumber-2, pageNumber-1, pageNumber, pageNumber+1, pageNumber+2);
                    }
                }
            }
        }
        cmp.set("v.pageList", pageList);
    },

    //US1974673: Bharat end


    /*selectRow: function (component, event, helper) {
       var row = event.currentTarget.getAttribute("data-row-index");
        console.log('row#', row);
        $('#tr'+row).find('input:checkbox').each(function() {
       	this.checked = (!this.checked);
        });
    },*/

})