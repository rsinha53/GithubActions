({
    OpenCaseCommentsReport : function(component, event, helper) {
        var SubjectId = component.get("v.SubjectId");
        var SubjectName = component.get("v.SubjectName");
        var SubjectType = component.get("v.SubjectType");
        
        console.log('~~~'+SubjectId+SubjectName+SubjectType);
        
        var tabName =SubjectName+' Case Comments';
        
        var subjId ='';
        var TaxId ='';
        var SurrogateKey ='';
        var grpId = '';
        var prodId = '';
        var origProd = '';
        var origGrp = '';
        
        if(SubjectType =='Member'){              
            if((/^\s*$/).test(SubjectId)){
                SurrogateKey ='NOT_FOUND';
            }else{
                SurrogateKey =SubjectId; 
            }
            TaxId ='NOT_REQUIRED';
            subjId ='NOT_REQUIRED';
            grpId ='NOT_REQUIRED';
            prodId ='NOT_REQUIRED';
            origProd ='NOT_REQUIRED';
            origGrp ='NOT_REQUIRED';
            
        }
        if(SubjectType =='Group'){
            if((/^\s*$/).test(SubjectId)){
                subjId ='NOT_FOUND';
            }else{
                subjId =SubjectId;
                grpId = SubjectId;
                origProd ='Producer';
                origGrp ='Group/Employer';
            }
            TaxId ='NOT_REQUIRED';
            SurrogateKey ='NOT_REQUIRED';
            prodId ='NOT_REQUIRED';
            
        }
        if(SubjectType =='Producer'){
            if((/^\s*$/).test(SubjectId)){
                subjId ='NOT_FOUND';
            }else{
                subjId =SubjectId; 
                prodId = SubjectId;
                origProd ='Producer';
                
            }
            TaxId ='NOT_REQUIRED';
            SurrogateKey ='NOT_REQUIRED';
            grpId ='NOT_REQUIRED';
            origGrp ='NOT_REQUIRED';
            
        }
        if(SubjectType =='Provider'){
            if((/^\s*$/).test(SubjectId)){
                TaxId ='NOT_FOUND';
            }else{
                TaxId =SubjectId; 
            }
            subjId ='NOT_REQUIRED';
            SurrogateKey ='NOT_REQUIRED';
            grpId ='NOT_REQUIRED';
            prodId ='NOT_REQUIRED';
            origProd ='NOT_REQUIRED';
            origGrp ='NOT_REQUIRED';
            
        }
        
        var url = '?fv0='+encodeURIComponent(subjId)+'&fv2='+encodeURIComponent(SurrogateKey)+'&Fv4='+encodeURIComponent(TaxId)+'&fv6='+encodeURIComponent(grpId)+'&fv8='+encodeURIComponent(origProd)+'&fv10='+encodeURIComponent(origGrp)+'&fv12='+encodeURIComponent(prodId); 
        console.log('---url--'+url);
        
        
        var workspaceAPI = component.find("workspace");
        
        var action = component.get("c.caseCommentsReport");
        action.setParams({});
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            if(state == "SUCCESS"){
                var result = a.getReturnValue();
                if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result)){
                    console.log('CC Report'+JSON.stringify(result));
                    //Open tab
                    workspaceAPI.openSubtab({
                        url: '/lightning/r/Report/'+result.Id+'/view'+url,
                        focus: true
                    }).then(function(response) {
                    
                    workspaceAPI.getTabInfo({
                        tabId: response
                        
                    }).then(function(tabInfo) {
                        
                        workspaceAPI.setTabLabel({
                            tabId: tabInfo.tabId,
                            label: tabName
                        });
                        
                    });
                });
                }
            }
        });
        $A.enqueueAction(action);
        
        
    }
})