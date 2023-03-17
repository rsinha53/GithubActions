({
	getAuditDetailsList : function(component){
        var claimNo=component.get("v.claimNo");
		var tableDetails = new Object();
		var i=0;
		tableDetails.type = "table";
        tableDetails.autodocHeaderName = "Audit Details: "+ claimNo;
        tableDetails.componentName = "Audit Details: "+ claimNo;
        tableDetails.componentOrder = 14;
		tableDetails.showComponentName = false;
		tableDetails.tableHeaders = [
			"AUDIT #", "DEV CODE","AI CODE","DEPT","INFO RECV'D","SOURCE","IDENTIFIER","ACTION","USER","UPDATED"
		];
		tableDetails.tableBody = [];
		for(i=1; i<=3;i++){
			let row = {
				"checked" : false,
				"uniqueKey" : i,
				"rowColumnData" : [
					{
						"isOutputText" : true,
						"fieldLabel" : "AUDIT #",
						"fieldValue" : "-",
						"key" : i
					},
                    {
						"isOutputText" : true,
						"fieldLabel" : "DEV CODE",
						"fieldValue" : "-",
						"key" : i
					},
                    {
						"isOutputText" : true,
						"fieldLabel" : "AI CODE",
						"fieldValue" : "-",
						"key" : i
					},
                    {
						"isOutputText" : true,
						"fieldLabel" : "DEPT",
						"fieldValue" : "-",
						"key" : i
					},
                    {
						"isOutputText" : true,
						"fieldLabel" : "INFO RECV'D",
						"fieldValue" : "-",
						"key" : i
					},
                    {
						"isOutputText" : true,
						"fieldLabel" : "SOURCE",
						"fieldValue" : "-",
						"key" : i
					},
                    {
						"isOutputText" : true,
						"fieldLabel" : "IDENTIFIER",
						"fieldValue" : "-",
						"key" : i
					},
                    {
						"isOutputText" : true,
						"fieldLabel" : "ACTION",
						"fieldValue" : "-",
						"key" : i
					},
                   {
						"isOutputText" : true,
						"fieldLabel" : "USER",
						"fieldValue" : "-",
						"key" : i
					},


					{
						"isOutputText" : true,
						"fieldLabel" : "UPDATED",
						"fieldValue" : "-",
						"key" : i
					}]
				}
			tableDetails.tableBody.push(row);
		}

        console.log("inside helper of Audit Details: "+ tableDetails);
		component.set("v.auditDetailsList", tableDetails);
	}
})