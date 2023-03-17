({
	createAddInfoData : function(component) {
        
        var card = new Object();
        card.componentName = "Additional Info/Policy";
        card.componentOrder = 5;
        card.type = "card";
        card.noOfColumns = "slds-size_12-of-12";
        
        var cardData = [];
        var cardDataDtl1 = {};
        cardDataDtl1.checked = false;
        cardDataDtl1.defaultChecked = false;
        cardDataDtl1.fieldType = "outputText";
        //cardDataDtl1.fieldName = "Code";
        cardDataDtl1.fieldValue = "Code: GDPIN";
        cardDataDtl1.isReportable = true;
        cardDataDtl1.showCheckbox = true;
        cardData.push(cardDataDtl1);
        
        var cardDataDtl2 = {};
        cardDataDtl2.checked = false;
        cardDataDtl2.defaultChecked = false;
        cardDataDtl2.fieldType = "unescapedHtml";
        cardDataDtl2.fieldValue = "Policy: <a href=\"url\">Policy345678uy5655</a> ";
        cardDataDtl2.isReportable = true;
        cardDataDtl2.showCheckbox = true;
        cardData.push(cardDataDtl2);
        
        var cardDataDtl3 = {};
        cardDataDtl3.checked = false;
        cardDataDtl3.defaultChecked = false;
        cardDataDtl3.fieldType = "outputText";
        cardDataDtl3.fieldValue = "Description: GDPIN - 001 Proc 99239 is included in the global period of HxProc 47562 on Claim ID- Ext/Int Line ID   AX87050607001-001/9 on date of service 20200129";
        cardDataDtl3.isReportable = true;
        cardDataDtl3.showCheckbox = true;
        cardData.push(cardDataDtl3);
        
        card.cardData =cardData; 
        
        
        component.set("v.cardAutoDocData",card);
		
	}
})