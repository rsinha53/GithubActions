({
 // common reusable function for toggle sections
    updateUser: function(cmp, event, helper) {
    
        if(!$A.util.isUndefinedOrNull(cmp.get("v.selectedUser"))&& !$A.util.isEmpty(cmp.get("v.selectedUser"))){
            
            var selectedLookupUser = cmp.get("v.selectedUser");
        var selectedBusinessUnit = cmp.get("v.selectedbusinessUnit");
            cmp.set("v.executeinteraction" ,true) ;
            var interaction = cmp.find("Interactionsection");
            var message = interaction.InteractionscorecardMethod(selectedLookupUser.Name,selectedBusinessUnit);
        
            cmp.set("v.executeclosedInteraction" ,true) ;
            var interaction1 = cmp.find("closedSection");
            var message1 = interaction1.InteractionscorecardMethod(selectedLookupUser.Name,selectedBusinessUnit);
        
             cmp.set("v.executemyOpenCases" ,true) ;
            var interaction2 = cmp.find("openCasesSection");
            var message2 = interaction2.CasescorecardMethod(selectedLookupUser.Name,selectedBusinessUnit);
        
             cmp.set("v.executeclosedCases" ,true) ;
                    var interaction3 = cmp.find("closedCasesSection");
                    var message3 = interaction3.CasescorecardMethod(selectedLookupUser.Name,selectedBusinessUnit);
             cmp.set("v.executeoverdueinteraction" ,true) ;
                    var interaction4 = cmp.find("overdueInteractionsSection");
                    var message4 = interaction4.scorecardMethod(selectedLookupUser.Name,selectedBusinessUnit);
        
            cmp.set("v.executeoverdueCases" ,true) ;
                    var interaction5 = cmp.find("overdueCasesSection");
                    var message5 = interaction5.scorecardMethod(selectedLookupUser.Name,selectedBusinessUnit);
       
             cmp.set("v.executeInteractions" ,true) ;
                    var interaction6 = cmp.find("InteractionsSection");
                    var message6 = interaction6.scorecardMethod(selectedLookupUser.Name,selectedBusinessUnit);
        
            cmp.set("v.executeCases" ,true) ;
                    var interaction7 = cmp.find("CasesSection");
                    var message7 = interaction7.scorecardMethod(selectedLookupUser.Name,selectedBusinessUnit);
        
        }
},
    toggleSection : function(cmp, event, helper) {
        // dynamically get aura:id name from 'data-auraId' attribute
        var sectionAuraId = event.target.getAttribute("data-auraId");
        // get section Div element using aura:id
        var sectionDiv = cmp.find(sectionAuraId).getElement();
        /* The search() method searches for 'slds-is-open' class, and returns the position of the match.
         * This method returns -1 if no match is found.
        */
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open'); 
        
        // -1 if 'slds-is-open' class is missing...then set 'slds-is-open' class else set slds-is-close class to element
        if(sectionState == -1){
            sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
        }else{
            sectionDiv.setAttribute('class' , 'slds-section slds-is-close');
        }
         var selectedLookupUser = cmp.get("v.selectedUser");
        var selectedBusinessUnit = cmp.get("v.selectedbusinessUnit");
        if(sectionAuraId == 'OpenIntSection'){ 
            cmp.set("v.executeinteraction" ,true) ;
            var interaction = cmp.find("Interactionsection");
            var message = interaction.InteractionscorecardMethod(selectedLookupUser.Name,selectedBusinessUnit);
        }
        if(sectionAuraId == 'clsIntSection'){ 
            cmp.set("v.executeclosedInteraction" ,true) ;
            var interaction = cmp.find("closedSection");
            var message = interaction.InteractionscorecardMethod(selectedLookupUser.Name,selectedBusinessUnit);
        }
        if(sectionAuraId == 'openCaseSection'){ 
             cmp.set("v.executemyOpenCases" ,true) ;
            var interaction = cmp.find("openCasesSection");
            var message = interaction.CasescorecardMethod(selectedLookupUser.Name,selectedBusinessUnit);
        }
        if(sectionAuraId == 'clsCaseSection'){ 
             cmp.set("v.executeclosedCases" ,true) ;
                    var interaction = cmp.find("closedCasesSection");
                    var message = interaction.CasescorecardMethod(selectedLookupUser.Name,selectedBusinessUnit);
        }
         if(sectionAuraId == 'overdueIntSection'){ 
             cmp.set("v.executeoverdueinteraction" ,true) ;
                    var interaction = cmp.find("overdueInteractionsSection");
                    var message = interaction.scorecardMethod(selectedLookupUser.Name,selectedBusinessUnit);
        }
        if(sectionAuraId == 'overdueCaseSection'){ 
            cmp.set("v.executeoverdueCases" ,true) ;
                    var interaction = cmp.find("overdueCasesSection");
                    var message = interaction.scorecardMethod(selectedLookupUser.Name,selectedBusinessUnit);
        }
        if(sectionAuraId == 'IntSection'){ 
             cmp.set("v.executeInteractions" ,true) ;
                    var interaction = cmp.find("InteractionsSection");
                    var message = interaction.scorecardMethod(selectedLookupUser.Name,selectedBusinessUnit);
        }
        if(sectionAuraId == 'caseSection'){
            cmp.set("v.executeCases" ,true) ;
                    var interaction = cmp.find("CasesSection");
                    var message = interaction.scorecardMethod(selectedLookupUser.Name,selectedBusinessUnit);
        }
    }
})