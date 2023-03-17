({
    doInit : function(component, event, helper) {
        console.log(component.get("v.pageReference").state);
        var callTopic = component.get("v.pageReference").state.c__cseTopic;
        var intType= component.get("v.pageReference").state.c__intType;
        var intId = component.get("v.pageReference").state.c__intId;
        var restrictReason = component.get("v.pageReference").state.c__isRestrict;
        var srk = component.get("v.pageReference").state.c__srk;
        var hgltJSON = component.get("v.pageReference").state.c__highlightsPanelInfo;
        if(helper.isJSON(component,event, hgltJSON)){
            hgltJSON = JSON.parse(hgltJSON);
        }
        if(hgltJSON=="null" || hgltJSON=="undefined" || hgltJSON==""){
            hgltJSON = null;
        }
        var hgltInfo = hgltJSON;
        console.log('=====Misdirect before creating case'+intType+intId+srk+restrictReason+hgltInfo);
        var opts = [
            { "class": "optionClass", label: "None", value: "", selected: !restrictReason },
            { "class": "optionClass", label: "ADP Transfer", value: "ADP Transfer"},
            { "class": "optionClass", label: "Briova Rx", value: "Briova Rx" },
            { "class": "optionClass", label: "Client Services", value: "Client Services" },
            { "class": "optionClass", label: "Cosmos", value: "Cosmos"},
            { "class": "optionClass", label: "CSP Facets", value: "CSP Facets" },
            { "class": "optionClass", label: "DCSM Transfer", value: "DCSM Transfer" },
            { "class": "optionClass", label: "Dental Plan", value: "Dental Plan"},
            { "class": "optionClass", label: "Evicore", value: "Evicore" },
            { "class": "optionClass", label: "Global Restricted", value: "Global Restricted", selected: restrictReason },
            { "class": "optionClass", label: "Health Pass Transfer", value: "Health Pass Transfer"},
            { "class": "optionClass", label: "Member Service", value: "Member Service"},
            { "class": "optionClass", label: "NYSNA", value: "NYSNA" },
            { "class": "optionClass", label: "Optum Chiro", value: "Optum Chiro" },
            { "class": "optionClass", label: "Optum Infertility", value: "Optum Infertility"},
            { "class": "optionClass", label: "Optum KRS", value: "Optum KRS" },
            { "class": "optionClass", label: "Optum PT/OT", value: "Optum PT/OT" },
            { "class": "optionClass", label: "Optum Rx", value: "Optum Rx"},
            { "class": "optionClass", label: "Optum Transplant", value: "Optum Transplant" },
            { "class": "optionClass", label: "Orthonet", value: "Orthonet" },
            { "class": "optionClass", label: "Pharmacy RX Other", value: "Pharmacy RX Other" },
            { "class": "optionClass", label: "Platinum Broker Transfer", value: "Platinum Broker Transfer" },
            { "class": "optionClass", label: "Prime", value: "Prime"},
            { "class": "optionClass", label: "Provider Relations", value: "Provider Relations" },
            { "class": "optionClass", label: "Pulse", value: "Pulse" },
            { "class": "optionClass", label: "UHG Restricted", value: "UHG Restricted"},
            { "class": "optionClass", label: "UNET", value: "UNET"},
            { "class": "optionClass", label: "United Behavioral Health", value: "United Behavioral Health" },
            { "class": "optionClass", label: "Vision Plan", value: "Vision Plan" },
            { "class": "optionClass", label: "Wrong Carrier", value: "Wrong Carrier"},
            { "class": "optionClass", label: "Other", value: "Other" }
        ];
        
        component.find("InputSelectDynamic").set("v.options", opts);
        
        helper.createMisdirectCase(component,event,helper,intType,intId, srk, callTopic,hgltInfo );
    },
    saveMisdirectCase : function(component, event, helper) {
        var callTopic = component.get("v.pageReference").state.c__cseTopic;
        helper.closeViewAuthTabs(component,event,helper);
        helper.saveMisdirectCase(component,event,helper,callTopic);
        
    },
    clear : function(component, event, helper) {
        console.log('clear');
        component.set("v.comments",'');
        component.set("v.reason",'None');
        component.find('InputSelectDynamic').set("v.errors", null);
        
    }
    
})