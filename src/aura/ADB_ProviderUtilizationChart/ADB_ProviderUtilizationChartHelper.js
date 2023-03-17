({
    getProviderUtilizationChart: function(component, event, helper){
        var claimValueList = [];
        var formattedClaimList = [];
        var finalClaimList = [];
        var auditClaimList = [];
        var similarClaimValues = [];
        var finalClaimValList = [];
        var inList = [], oonList = [], tierList = [];
        var inValueCount = [], inWindowList = [], inclaimCount=[];
        var oonValueCount = [], oonWindowList = [], oonclaimCount=[];
        var tierValueCount = [], trWindowList = [], tierclaimCount=[];
        var claimsList = component.get("v.mediClaimDetails");
        // Remove Pharmacy Claims
        if (claimsList != undefined && claimsList.length != 0) {
            for (var key in claimsList){
                var claimType = claimsList[key].claimType;
                var claimStatus = claimsList[key].claimStatus;
                if(claimStatus != 'Incomplete'){
                    if((claimType == 'PHYSICIAN')||(claimType == 'HOSPITAL')||(claimType == 'MEDICAL')){
                        claimValueList.push(claimsList[key]);
                    }
                }
            }
        } 
        // Sort by processedDate
        if (claimValueList != undefined && claimValueList.length != 0) {   
            claimValueList.sort(function(a, b){
                if(a.processedDate <= b.processedDate) { return -1; }
                if(a.processedDate > b.processedDate) { return 1; }
                return 0;
            });
            
            // Check reproduced Claims and return Claims
            for(var key in claimValueList){
                var formattedAuditControlNumber = claimValueList[key].formattedAuditControlNumber;
                var totalCharged = claimValueList[key].totalCharged;
                
                // Add Unique Claims
                if(formattedClaimList.indexOf(formattedAuditControlNumber) === -1){
                    finalClaimList.push(claimValueList[key]);
                    formattedClaimList.push(formattedAuditControlNumber); 
                }else {
                    // Remove return claims
                    if(totalCharged.includes("-")){
                        var lstClaimIndex = formattedClaimList.indexOf(formattedAuditControlNumber);
                        formattedClaimList.splice(lstClaimIndex, 1);
                        finalClaimList.splice(lstClaimIndex, 1);    
                    }
                }
            }
            // Remove Claims with multiple pages
            for (var key in finalClaimList){
                var auditControlNumber = finalClaimList[key].auditControlNumber;
                if(similarClaimValues.indexOf(auditControlNumber) === -1){
                    similarClaimValues.push(auditControlNumber);
                    finalClaimValList.push(finalClaimList[key]);
                }
            }   
        }
        // Divide Claims into INN, OON and Tier 1 
        if (finalClaimValList != undefined && finalClaimValList.length != 0) {
            for (var key in finalClaimValList){
                var totalPatientResponsibility = finalClaimValList[key].totalPatientResponsibility;
                if(finalClaimValList[key].providerTier =='In Network'){
                    inList.push(finalClaimValList[key]);
                }else if(finalClaimValList[key].providerTier =='Out of Network'){
                    oonList.push(finalClaimValList[key]);
                }else{
                    tierList.push(finalClaimValList[key]);
                }
            }
        }
        
        // Sort OON Network list  
        if (oonList != undefined && oonList.length != 0) {   
            for(var key in oonList){
                var count = 0;
                var providerName = oonList[key].providerName;
                var providerTaxId = oonList[key].providerTaxId;
                var provSpecialty = oonList[key].providerSpecialty;
                var claimType = oonList[key].claimType;
                if(claimType == 'PHYSICIAN'){
                    providerName = 'Dr. '+providerName;
                }
                if(oonValueCount.indexOf(providerTaxId) === -1){
                    //  get count for selected providerTaxId;
                    for(var i = 0; i < oonList.length; ++i){
                        if(oonList[i].providerTaxId == providerTaxId){
                            count++;
                        }
                    }
                    // insert providerName and count into list
                    oonValueCount.push(providerTaxId);
                    if (oonWindowList != undefined) {
                        oonWindowList.sort(function(a, b){
                            if(a.providerName < b.providerName) { return -1; }
                            if(a.providerName > b.providerName) { return 1; }
                            return 0;
                        });
                        oonWindowList.push({'title':'Out of Network','proName':providerName,'proType':provSpecialty,'proCount':count});
                    }
                }
            }
        }
        // Sort Teir Network list  
        if (tierList != undefined && tierList.length != 0) {  
            for(var key in tierList){
                var count = 0;
                var providerName = tierList[key].providerName;
                var providerTaxId = tierList[key].providerTaxId;
                var provSpecialty = tierList[key].providerSpecialty;
                var claimType = tierList[key].claimType;
                if(claimType == 'PHYSICIAN'){
                    providerName = 'Dr. '+providerName;
                }
                if(tierValueCount.indexOf(providerTaxId) === -1){
                    //  get count for selected providerTaxId;
                    for(var i = 0; i < tierList.length; ++i){
                        if(tierList[i].providerTaxId == providerTaxId){
                            count++;
                        }
                    }
                    // insert providerName and count into list
                    tierValueCount.push(providerTaxId);
                    if (trWindowList != undefined) {
                        trWindowList.sort(function(a, b){
                            if(a.providerName < b.providerName) { return -1; }
                            if(a.providerName > b.providerName) { return 1; }
                            return 0;
                        });
                        trWindowList.push({'title':'Tier 1','proName':providerName,'proType':provSpecialty,'proCount':count});
                    }
                }												 
            }
        }
        // Sort IN Network list   
        if (inList != undefined && inList.length != 0) {  
            for(var key in inList){
                var count = 0;
                var providerName = inList[key].providerName; 
                var providerTaxId = inList[key].providerTaxId; 
                var provSpecialty = inList[key].providerSpecialty;
                var claimType = inList[key].claimType;
                if(claimType == 'PHYSICIAN'){
                    providerName = 'Dr. '+providerName;
                }
                if(inValueCount.indexOf(providerTaxId) === -1){
                    //  get count for selected providerTaxId;
                    for(var i = 0; i < inList.length; ++i){
                        if(inList[i].providerTaxId == providerTaxId){
                            count++;
                        }
                    }
                    // insert providerName and count into list
                    inValueCount.push(providerTaxId);
                    if (inWindowList != undefined) {
                        inWindowList.sort(function(a, b){
                            if(a.providerName < b.providerName) { return -1; }
                            if(a.providerName > b.providerName) { return 1; }
                            return 0;
                        });
                        inWindowList.push({'title':'In Network','proName':providerName,'proType':provSpecialty,'proCount':count});
                    }
                }
            }
        }
        
        var oonVal = (oonList != undefined && oonList.length != 0) ? oonList.length : 0;
        var inVal = (inList != undefined && inList.length != 0) ? inList.length : 0;
        var tierVal = (tierList != undefined && tierList.length != 0) ? tierList.length : 0;
        var oonValCnt = (oonValueCount != undefined && oonValueCount.length != 0) ? oonValueCount.length : 0;
        var inValCnt = (inValueCount != undefined && inValueCount.length != 0) ? inValueCount.length : 0;
        var tierValCnt = (tierValueCount != undefined && tierValueCount.length != 0) ? tierValueCount.length : 0;
        var data = [oonVal, inVal, tierVal];
        
        // to check the count of Out of Network and hide the flag on condition
        var oonCount = oonVal;
        if(oonCount < 1){
            component.set("v.showOONFlag", false); 
        } 
        
        if((oonVal > 0) || (inVal > 0) || (tierVal > 0)){
            component.set("v.isChartDisplay", true);
            window.setTimeout(
                $A.getCallback(function() {
                    var ctx = document.getElementById("myChart");
                    var myChart = new Chart(ctx, {
                        type: 'doughnut',
                        data: {
                            labels:['Out of Network','In Network','Tier 1'],
                            datasets: [{
                                data: data,
                                // color of segements in the chart //'RGB(21, 137, 238)'
                                backgroundColor: [
                                    'RGB(255, 240, 63)', 
                                    'RGB(75, 202, 129)',
                                    'RGB(51, 153, 255)',
                                ],
                                    // border color for the segments
                                    borderColor: [
                                    'RGB(0, 0, 0)',
                                    'RGB(0, 0, 0)',
                                    'RGB(0, 0, 0)'
                                ],
                                borderWidth: 1,
                            }]
                        },
                        options: {
                            responsive: true,
                            rotation: 0.12 * Math.PI,
                            reverse: true,
                            showTooltips: false,
                            tooltips: {enabled: false},
                            hover: {mode: null},                        
                            cutoutPercentage: 50,
                            legend: { 
                                display: false
                            },
                            plugins: {
                                // displays label on the segment 
                                labels: {
                                    fontColor: 'RGB(0, 0, 0)',
                                    fontStyle: "bold",
                                    render: function(args){
                                        // to show the percentage and value on the graph segments
                                        var label = args.label;
                                        var labelshort = '';
                                        if(label =='Tier 1'){
                                            labelshort = 'Tier 1';
                                        }else if(label =='Out of Network'){
                                            labelshort = 'OON';
                                        }else if(label =='In Network'){
                                            labelshort = 'INN';
                                        }
                                        return labelshort + '\n'+args.percentage + '%' + '\n(' + args.value + ')';
                                    }
                                }, 
                            },
                        },
                    });
                    
                    ctx.onclick = function(e) {
                        var slice = myChart.getElementAtEvent(e);
                        if (!slice.length) return; // return if not clicked on slice
                        var label = slice[0]._model.label;
                        component.set("v.openPUChartWindow",true);
                        switch (label) {
                            case 'In Network': 
                                component.set("v.providerDetailList",inWindowList);
                                component.set("v.puWindowTitle",'In Network');
                                component.set("v.isNetworkStatusVisible",false);
                                break;
                            case 'Out of Network':
                                component.set("v.providerDetailList",oonWindowList);
                                component.set("v.puWindowTitle",'Out of Network');
                                component.set("v.isNetworkStatusVisible",false);
                                break;
                            case 'Tier 1':
                                component.set("v.providerDetailList",trWindowList);
                                component.set("v.puWindowTitle",'Tier 1');
                                component.set("v.isNetworkStatusVisible",false);
                                break;
                        }
                    }
                    var text1 = document.getElementById('text1');
                    text1.addEventListener("click", function (e) {
                        component.set("v.openPUChartWindow",true);
                        let windowList = trWindowList.concat(inWindowList);
                        let fullWindowList = windowList.concat(oonWindowList);
                        
                        component.set("v.providerDetailList",fullWindowList);
                        component.set("v.puWindowTitle",'');
                        component.set("v.isNetworkStatusVisible",true);
                    });
                    // function for displaying center text
                    Chart.pluginService.register({
                        beforeDraw: function(myChart) {
                            var width = myChart.width;
                            var height = myChart.height;
                            var ctx = myChart.ctx;
                            ctx.restore();
                            var fontSize = (height / 142).toFixed(2);
                            ctx.font = fontSize + "em sans-serif";
                            ctx.textBaseline = "middle";
                            var text = inVal + oonVal + tierVal;
                            var text2 =  'Visits';
                            var textX = Math.round((width - ctx.measureText(text).width) / 2);
                            var textY = height / 2.2;
                            var text2X = Math.round((width - ctx.measureText(text).width) / 2.20);
                            var text2Y = height / 1.8;
                            
                            var d = Math.min(width, height);
                            var a = d / 2;
                            text1.style.left = (((width - a) / 2 - 1)|0) + "px";
                            text1.style.top = (((height - a) / 2 - 1)|0) + "px";
                            text1.style.width = a + "px";
                            text1.style.height = a + "px";
                            
                            ctx.fillText(text, textX, textY);
                            ctx.fillText(text2, text2X, text2Y);
                            ctx.save();
                        }
                    })
                }), 2500
            )
        }
    }
})