({
openmemberdetailpage : function(component,event,helper,resultresp,caseobj,Interaction,oUser,CoveragesresultWrapper) {
    var srk=  caseobj.Surrogate_Key__c;
    var isOnshore;
    if(oUser.Agent_Type__c == 'Offshore'){
        isOnshore = 'false';
    }
    isOnshore = 'true';
                                    var selCoverageLines;

                        for(var j = 0; j < CoveragesresultWrapper.length; j++){
                            if(CoveragesresultWrapper[j].Id == caseobj.ID__c){
                                selCoverageLines = CoveragesresultWrapper[j].CoverageLines;
                            }
                        }
    if(resultresp.statusCode == '200'){

                        if(resultresp.Response && resultresp.Response.length > 0){

                            var msr;
                for(var i = 0; i < resultresp.Response.length; i++){
                    if(resultresp.Response[i].SurrogateKey == srk){
                        msr = resultresp.Response[i];
                        
                    }
                }
    
                            if(msr){
                                debugger;
var IsMember =  true;
var Name = msr.FirstName+' '  +  msr.LastName;
              var address =msr.Address +','+msr.City+','+msr.State+','+msr.Zip; 
              var skeys = [];
                for(i in msr.SurrogateKeys){
                    var skey = msr.SurrogateKeys[i];
                    skeys.push(skey);
                }
                var memSRK = skeys.join(',');
                console.log('String memSRK'+ memSRK);
  var workspaceAPI = component.find("workspace");
                workspaceAPI.openTab({
                    pageReference: {
                        "type": "standard__component",
                        "attributes": {
                            "componentName": "c__ACETLGT_MemberDetail"
                        },
                        "state": {
                            "c__Name" : Name,
                            "c__lastName" : msr.LastName,
                            "c__firstName" : msr.FirstName,
                            "c__sc" : msr.SourceCode,
                            "c__gen" : msr.Gender,
                            "c__addr" : address,
                            "c__fullssn" : window.btoa(msr.SSNum),
                            "c__Id" : msr.Id,
                            "c__scr" : msr.SCRId,
                            "c__SRK" : msr.SurrogateKey,
                            "c__SRKKeyChain" : memSRK,
                           "c__grpnum" : caseobj.Subject_Group_ID__c,
                            "c__subjectdob" : msr.DOB,
                            "c__IsMember" : IsMember,
                            "c__individualIdentifier" : msr.individualIdentifier,
                            "c__InteractionType" : Interaction.Interaction_Type__c,
                            "c__InteractionId" : Interaction.Id,
                            "c__Interaction" : Interaction,
                            "c__InteractionOrigType" : Interaction.Originator_Type__c,
                            "c__isOnshore":isOnshore,
                            "c__usInfo": oUser,
                            "c__affiliationIndicator" : false,
                            "c__fasttrackflow":true,
                            "c__coverages" : window.btoa(JSON. stringify(selCoverageLines)),
                            "c__orgid":Interaction.Originator__c,
                             "c__fastrrackflow":'yes',
                            "c__calltopicnamefastrack":caseobj.Topic__c
                        
                        }
                },
                focus: true
            }).then(function(response) {
                
                workspaceAPI.getTabInfo({
                    tabId: response
                    
                }).then(function(tabInfo) {
                    
                    workspaceAPI.setTabLabel({
                        tabId: tabInfo.tabId,
                        label: 'Detail-'+msr.LastName
                    });
                    workspaceAPI.setTabIcon({
                        tabId: tabInfo.tabId,
                        icon: "standard:people",
                        iconAlt: "Member"
                    });
                    
                });
            }).catch(function(error) {
                    console.log(error);
            });
                                        debugger;

                        }      
                        }else{
                            
                        }
    }
    
    
}
})