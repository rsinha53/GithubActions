({
    onInit : function(cmp) {
        let today = new Date();
        cmp.set("v.hoverClassName", 'hoverClass'+today.getTime());
         //US2598259 - View Authorizations - Add MD to Claim Remark Code Hover - Durga -START
        let descList =[
            'AN - Process based on provider\'s network status. The admitting physician is paid based on the provider\'s network status.' ,
            'AS - Process services at the INN/higher benefit level. All non-network health care providers will be reimbursed at the network level based on billed charges or the repriced amount.',
            'DC - Services do not meet coverage requirements for one of the following reasons: \r\n- The requested services are not covered based on a medical policy \r\n- Member does not active coverage. \r\n- The services ares not covered by the members plan.  \r\n- There is no benefit for the service or the service is excluded from coverage.',
            'DI - Services denied for lack of information received.',
            'DM - Services not medically necessary.',
            'DS - Services are covered and/or medically necessary but have not been approved to be performed in the location (site) requested.',
            'MD - The inpatient stay was deemed not medically necessary.' ,
            'OS - Process services at the OON/lower benefit level. All providers will be reimbursed at the OON level of benefits, regardless of the provider\'s network status.',
            'SS - Process based on claim comments.',
            'ZZ - Prior Authorization/Notification Cancelled.' ];
             cmp.set('v.descList',descList);
            //US2598259 - View Authorizations - Add MD to Claim Remark Code Hover - Durga -END
    },

	// Purpose - To show or hide hover popup depending on its current state.
	// US2300701 Enhancement View Authorizations and Notifications - Inpatient/Outpatient Details UI (Specific Fields)  - Sarma - 17/01/2020
	togglePopup : function(cmp, event) {
		let showPopup = event.currentTarget.getAttribute("data-popupId");
		cmp.find(showPopup).toggleVisibility();
	},

    // US2331435 - Enhancement View Authorizations and Notifications - Claim Codes - Sarma - 05/02/2020 
    onscroll:function(cmp, event) {
		var cls = cmp.get("v.hoverClassName");
        let comp = document.querySelector('.'+cls);
        var rect = comp.getBoundingClientRect();
        
        var width = screen.width - 100;
        var x =  width - rect.left;
        cmp.set('v.xCoordinate', x);
       
	},

    onDatachange: function(cmp, event, helper) {
        helper.setTableData(cmp);
    }

})