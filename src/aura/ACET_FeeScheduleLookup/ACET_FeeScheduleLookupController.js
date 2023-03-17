({
	onInit: function(cmp, event, helper){
        
        let today = new Date();
        cmp.set("v.cmpId", today.getTime());
		helper.populatePOSValues(cmp);
		helper.addInputRows(cmp, 5);
        // DE442475 - Thanish - 17th May 2012
		cmp.set("v.excessRowsErrorLink", "https://kmead.uhc.com/verintkm/jumppage.html?displayByRefName=providercalladvocatenetworkmanagement");
		// US3394407
		var isClaims = cmp.get("v.isClaims");
		if(isClaims){
			helper.addInputRowsUB(cmp,5);
		}
    
		// US3468218
		if(cmp.get("v.isClaims")){
			helper.autofillClaimToFeeSchedule(cmp); // DE451739: the Market #/Table, etc are not populating - Krish - 9th July 2021
			 // helper.callContractService(cmp); // DE451739: This returns nothing because there is no data in the rows to be sent in request so commenting
		}else if(!$A.util.isEmpty(cmp.get("v.contractData"))){
			cmp.set("v.feeScheduleData", cmp.get("v.contractData").feeScheduleData);
		}
        // Start of US3472990 - Team Blinkers -Bala
        helper.billType(cmp);
        
        if(cmp.get("v.claimType")==='P' && cmp.get("v.networkStatus")==='O'){
            cmp.set("v.radioSelection", "HCFA");
        }
        else if(cmp.get("v.claimType")==='P' && cmp.get("v.networkStatus")==='I'){
		// US3464932
		cmp.set("v.radioSelection", "HCFA");
        //helper.callFeeSchedule(cmp);
        }else if(cmp.get("v.claimType")==='I' || cmp.get("v.claimType")==='H'){
          cmp.set("v.radioSelection", "UB04"); 
        }
        // End of US3472990 - Team Blinkers -Bala 
        
    },
    doneRendering: function(cmp, event, helper) {
    if(!cmp.get("v.isDoneRendering")){
       cmp.set("v.isDoneRendering", true);
        if(cmp.get("v.radioSelection")){
          helper.callFeeSchedule(cmp);
        }
        }
    },
	onHCFASelected: function(cmp){
		cmp.set("v.radioSelection", "HCFA");
		cmp.set("v.radioSelectionInpatientOutpatient", "");
	},
    //Team Blinkers: Vishal Badoni- 10 May 2021 
	onUB04Selected: function(cmp){
		cmp.set("v.radioSelection", "UB04");
	},
    //Vishal Change- US355327 Start
     mouseOver : function(component, event){
        var selectedItem = event.currentTarget;
        var Name = selectedItem.dataset.record;
        var currDiv = component.find(Name);
        /*$A.util.addClass(currDiv,'hide');
        $A.util.removeClass(currDiv,'show'); */
        var lastChar = Name.charAt(Name.length - 1); 
        var currDiv1 = component.find(Name+lastChar); 
        $A.util.addClass(currDiv1,'show');
        $A.util.removeClass(currDiv1,'hide');
    },
    mouseOut : function(component, event){
        var selectedItem = event.currentTarget;
        var Name = selectedItem.dataset.record;
        var currDiv = component.find(Name);
        if(Name == 'div1'){
            var lastChar = Name.charAt(Name.length - 1); 
            var currDiv1 = component.find(Name+lastChar); 
            $A.util.addClass(currDiv1,'hide');
            $A.util.removeClass(currDiv1,'show');
        }else{
        $A.util.addClass(currDiv,'hide');
        $A.util.removeClass(currDiv,'show');
        }
        // var str = Name;
        // str = str.slice(0, -1);
        // var currDiv1 = component.find(str);
        // $A.util.addClass(currDiv1,'show');
        // $A.util.removeClass(currDiv1,'hide');
    },
    //Vishal Change- US355327 End
    onInpatient: function(cmp){
        cmp.set("v.radioSelectionInpatientOutpatient", "Inpatient");
    },
    onOutpatient: function(cmp){
        cmp.set("v.radioSelectionInpatientOutpatient", "Outpatient");
    },
	onClickOK: function(component, event, helper) {
        
      component.set("v.outpPop", false);
      document.getElementById('ocr').click();
   },
    ////Team Blinkers: Vishal Change - 12 May 2021
    handleAllowedAmount: function(cmp,event, helper){
        helper.setUBO4Card(cmp,cmp.get("v.isAllowedAmountChecked"), cmp.get("v.claimnumber"), cmp.get("v.allowedAmountValue"));
    },
    validateCheck: function(cmp,event, helper){
        var amount = event.getSource().get("v.value");
        if(amount){
           cmp.set("v.isAllowedAmountChecked", true); 
        }else{
            cmp.set("v.isAllowedAmountChecked", false);
        }
       
    },
	onRowCopy: function(cmp, event, helper){
		var index = parseInt(event.currentTarget.getAttribute("data-index"));
		var inputRows = cmp.get("v.inputRows");
		var showError = true;

		for(var i=0; i<inputRows.length; i++){
			if($A.util.isEmpty(inputRows[i].start) && $A.util.isEmpty(inputRows[i].end) && $A.util.isEmpty(inputRows[i].pos) &&
			   $A.util.isEmpty(inputRows[i].cptOrHcpc) && $A.util.isEmpty(inputRows[i].modifier) && $A.util.isEmpty(inputRows[i].dx) &&
			    $A.util.isEmpty(inputRows[i].count) && $A.util.isEmpty(inputRows[i].billedAmnt)){

				var row = {
					start: inputRows[index].start,
					end: inputRows[index].end,
					pos: inputRows[index].pos,
					cptOrHcpc: inputRows[index].cptOrHcpc,
					modifier: inputRows[index].modifier,
					dx: inputRows[index].dx,
					type: inputRows[index].type,
					count: inputRows[index].count,
					billedAmnt: inputRows[index].billedAmnt,
					serviceCalled: false
				};
				inputRows[i] = row;
				cmp.set("v.inputRows", inputRows);
				showError = false;
				break;
			}
		}
		if(showError){
			cmp.set("v.showNoEmptyRowsError", true);
		}
	},

	onRowClear: function(cmp, event, helper){
		var index = parseInt(event.currentTarget.getAttribute("data-index"));
		var inputRows = cmp.get("v.inputRows");
		inputRows[index] = helper.clearInputRow(inputRows[index]);
		cmp.set("v.inputRows", inputRows);
		helper.reportValidityOfEmptyRow(cmp, index);
	},

	onAllClear: function(cmp, event, helper){
		var inputRows = cmp.get("v.inputRows");

		for(var i=0; i<inputRows.length; i++){
			inputRows[i] = helper.clearInputRow(inputRows[i]);
		}
		cmp.set("v.inputRows", inputRows);
		for(var j=0; j<inputRows.length; j++){
			helper.reportValidityOfEmptyRow(cmp, j);
		}
		cmp.set("v.showExcessRowsError", false);
		cmp.set("v.showNoEmptyRowsError", false);
	},

	onAddRows: function(cmp, event, helper){
		var input = cmp.find("noOfRows");
		if(input.checkValidity()){
			var noOfRows = parseInt(input.get("v.value"));
			helper.addInputRows(cmp, noOfRows);
			cmp.set("v.showNoEmptyRowsError", false);
		}
	},

	onReset: function(cmp, event, helper){
		var resetRows = [];
		var inputRows = cmp.get("v.inputRows");
		for(var i=0; i<5; i++){
			resetRows.push(helper.clearInputRow(inputRows[i]));
		}
		cmp.set("v.inputRows", resetRows);
		for(var j=0; j<resetRows.length; j++){
			helper.reportValidityOfEmptyRow(cmp, j);
		}
		cmp.find("noOfRows").set("v.value", "");
		cmp.find("noOfRows").reportValidity();
		cmp.set("v.showExcessRowsError", false);
		cmp.set("v.showNoEmptyRowsError", false);
	},
	
	onSearch: function(cmp,event,helper){
		// if(helper.reportValidity(cmp)){
		// 	helper.callFeeSchedule(cmp);
		// }	
		helper.callFeeSchedule(cmp);	
	},

	// US3394407
	onSearchUB: function(cmp,event,helper){
		//helper.callFeeSchedule(cmp);
	},
	onResetUB: function(cmp, event, helper){
		var resetRows = [];
		var inputRows = cmp.get("v.us04OutpatientInputRows");
		for(var i=0; i<5; i++){
			resetRows.push(helper.clearInputRow(inputRows[i]));
		}
		cmp.set("v.us04OutpatientInputRows", resetRows);
		for(var j=0; j<resetRows.length; j++){
			helper.reportValidityOfEmptyRow(cmp, j);
		}
		cmp.find("noOfRowsUB").set("v.value", "");
		cmp.find("noOfRowsUB").reportValidity();
		cmp.set("v.showExcessRowsError", false);
		cmp.set("v.showNoEmptyRowsError", false);
	},
	onAddRowsUB: function(cmp, event, helper){
		var input = cmp.find("noOfRowsUB");
		if(input.checkValidity()){
			var noOfRows = parseInt(input.get("v.value"));
			helper.addInputRowsUB(cmp, noOfRows);
			cmp.set("v.showNoEmptyRowsError", false);
		}
	},

	onRowCopyUB: function(cmp, event, helper){
		var index = parseInt(event.currentTarget.getAttribute("data-index"));
		var inputRows = cmp.get("v.us04OutpatientInputRows");
		var showError = true;

		for(var i=0; i<inputRows.length; i++){
			if($A.util.isEmpty(inputRows[i].start) && $A.util.isEmpty(inputRows[i].end) && $A.util.isEmpty(inputRows[i].revCode) &&
			   $A.util.isEmpty(inputRows[i].cptOrHcpc) && $A.util.isEmpty(inputRows[i].modifier) && $A.util.isEmpty(inputRows[i].primaryDx) &&
			   $A.util.isEmpty(inputRows[i].addlDx) && $A.util.isEmpty(inputRows[i].rxNdc) &&
			   $A.util.isEmpty(inputRows[i].count) && $A.util.isEmpty(inputRows[i].billedAmnt)){

				var row = {
					start: inputRows[index].start,
					end: inputRows[index].end,
					revCode: inputRows[index].revCode,
					cptOrHcpc: inputRows[index].cptOrHcpc,
					modifier: inputRows[index].modifier,
					primaryDx: inputRows[index].primaryDx,
					addlDx: inputRows[index].addlDx,
					rxNdc: inputRows[index].rxNdc,
					type: inputRows[index].type,
					count: inputRows[index].count,
					billedAmnt: inputRows[index].billedAmnt,
					serviceCalled: false
				};
				inputRows[i] = row;
				cmp.set("v.us04OutpatientInputRows", inputRows);
				showError = false;
				break;
			}
		}
		if(showError){
			cmp.set("v.showNoEmptyRowsError", true);
		}
	},

	onRowClearUB: function(cmp, event, helper){
		var index = parseInt(event.currentTarget.getAttribute("data-index"));
		var inputRows = cmp.get("v.us04OutpatientInputRows");
		inputRows[index] = helper.clearInputRowUB(inputRows[index]);
		cmp.set("v.us04OutpatientInputRows", inputRows);
		helper.reportValidityOfEmptyRow(cmp, index);
	},

	onAllClearUB: function(cmp, event, helper){
		var inputRows = cmp.get("v.us04OutpatientInputRows");
		
		for(var i=0; i<inputRows.length; i++){
			inputRows[i] = helper.clearInputRowUB(inputRows[i]);
		}
		cmp.set("v.us04OutpatientInputRows", inputRows);
		
		for(var j=0; j<inputRows.length; j++){
			helper.reportValidityOfEmptyRow(cmp, j);
		}
		cmp.set("v.showExcessRowsError", false);
		cmp.set("v.showNoEmptyRowsError", false);
	},

	onCommit: function (cmp, event, helper) {
		var index = parseInt(event.getSource().get("v.name"));
		var inputRows = cmp.get("v.inputRows");
		inputRows[index].serviceCalled = false;
		cmp.set("v.inputRows", inputRows);
	}

})