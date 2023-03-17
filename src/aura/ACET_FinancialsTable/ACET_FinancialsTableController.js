({
    valueChangeSet1 : function(cmp, event, helper)
    {
        var c1=cmp.get('v.crsAplOopSignVal');

        var c2=cmp.get('v.crsAplCopySignVal');
        var c3=cmp.get('v.crsAplCoreSignVal');
        
        if(c1 != undefined && c1 != null && c1 >= 0 && c1 <= 7)
        {
            var crsOop=["No cross application applies","Cross dual to normal and normal to dual","Cross apply dual to normal, but NOT normal to dual","Cross apply normal to dual, but not dual to normal","Cross apply for Tier 1, normal and dual","Cross apply for Tier 1 to normal and normal to Tier 1","Cross apply for Tier 1 to normal but not normal to Tier 1","Cross apply normal to Tier 1 but not Tier 1 to normal"];
            var c1Str=c1>0?'Y':'N';
            cmp.set('v.hoverMsg',crsOop[c1]);
            cmp.set('v.crsAplOopVal',c1Str);
        }
        else if(c2 != undefined && c2 != null && c2 >= 0 && c2 <= 7)
        {
            var crsCopy=["No Cross apply","Cross apply Out of Network to In-Network and In-Network to Out of Network","Cross apply  Out of Network to In-Network but NOT In-Network to Out of Network","Cross apply In-Network to Out of Network but NOT Out of Network to In-Network","Cross apply for Tier 1, In-Network and Out of Network","Cross apply Tier 1 to In-Network and In-Network to Tier 1","Cross apply for Tier 1 to In-Network but NOT In-Network to Tier 1","Cross apply In-Network to Tier 1 but NOT Tier 1 to In-Network"];
            var c2Str=c2>0?'Y':'N';
            cmp.set('v.hoverMsg',crsCopy[c2]);
            cmp.set('v.crsAplCopyVal',c2Str);
            
        }
            else if(c3 != undefined && c3 != null && c3 >= 0 && c3 <= 7)
            {
                var crsCore=["No Cross apply","Cross apply Out of Network to In-Network and In-Network to Out of Network","Cross apply  Out of Network to In-Network but NOT In-Network to Out of Network","Cross apply In-Network to Out of Network but NOT Out of Network to In-Network","Cross apply for Tier 1, In-Network and Out of Network","Cross apply Tier 1 to In-Network and In-Network to Tier 1","Cross apply for Tier 1 to In-Network but NOT In-Network to Tier 1","Cross apply In-Network to Tier 1 but NOT Tier 1 to In-Network"];
                var c3Str=c3>0?'Y':'N';
                cmp.set('v.hoverMsg',crsCore[c3]);
                cmp.set('v.crsAplCoreVal',c3Str);
            }
    },
    
    handleSelectCheckBox: function (cmp, event) {
        var financialCardDetails = cmp.get("v.financialCardDetails");
        _autodoc.setAutodoc(cmp.get("v.autodocUniqueId"),cmp.get("v.autodocUniqueIdCmp"), financialCardDetails);
    },
    // US3507751 - Save Case Consolidation
    handleAutodocRefresh: function(cmp, event, helper) {
        if (event.getParam("autodocUniqueId") == cmp.get("v.autodocUniqueId")) {
            cmp.set("v.headerChecked", false);
        }
    },
})