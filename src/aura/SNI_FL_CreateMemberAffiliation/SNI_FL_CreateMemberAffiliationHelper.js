({
    fetchInitData : function(component) {
        return new Promise(function(resolve, reject){
            var action = component.get("c.getData_NewMemberAffiliation");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === 'SUCCESS') {
                    resolve(response.getReturnValue());
                } else reject(response.getError());
            });
            $A.enqueueAction(action);
        });
    },
    
    getUserInfo: function(component,result){
        var action = component.get("c.isFecPro");
        action.setCallback(this, function(response) {
            if(component.isValid() && response !==null && response.getState()=='SUCCESS'){
            var isFecPro=response.getReturnValue();
                if(isFecPro === false){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'You do not have permission to Enroll Member',   
                        key: 'info_alt',
                        type: 'error',
                        mode: 'sticky'
                    });
                    toastEvent.fire();
                    $A.get('e.force:closeQuickAction').fire();
                }else{
                     component.set('v.isFecPro',isFecPro);
                }             
                
            }
	});
     $A.enqueueAction(action);
    },
    assignValues : function(component, result) {
        var programs = [];
        for(var key in result){
            console.log('key: '+key);
            if(key){
                if(key === 'RecordTypeId') {
                    component.set("v.RecordTypeId", result[key]);
                    continue;
                }
                programs.push({value:key, key:result[key]});
            }
            component.set("v.programs", programs);            
        }
        console.log('programs: '+JSON.stringify(component.get("v.programs")));
        console.log('RecordtypeId: '+component.get("v.RecordTypeId"));        
    },
    
    createAccount : function(component, populationSelected, programId){
        var programValue = component.get("v.programValue");
        var strIdProgram = component.get("v.programs").filter(x => x.value === programValue).map(x => x.key);
        var programValue = component.get("v.programValue");
        var populationSelected = component.find("population").get("v.value");
        var providergroup =   component.find("providergroup").get("v.value");
        var DateOfBirth = component.get("v.accountRecord")!=null?component.get("v.accountRecord").PersonBirthdate:null;
        var Name = component.get("v.accountRecord")!=null?component.get("v.accountRecord").Id:null;
        var providerAffiliation = component.find("providerAffiliation").get("v.value");
        var action = component.get("c.createAccount");
        action.setParams({
            programValue: programValue,
            populationSelected : populationSelected,
            providergroup : String(providergroup),
            strIdProgram:String(strIdProgram),
            DateOfBirth:DateOfBirth,
            strCurrentId:String(Name),
            providerAffiliation : String(providerAffiliation)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state'+state);
            if(state === 'SUCCESS') {
                let result = response.getReturnValue();                
                console.log('result: '+JSON.stringify(result));
                if(result.includes('A record already exists for this Member')){
                    var toastEvent = $A.get("e.force:showToast");
                    var memrecid = result.substring(result.length - 19, result.length);
                    var baseurl ='https://'+window.location.hostname+memrecid;
                    toastEvent.setParams({
                         mode: 'pester',
                         message: 'This is a required message',
                         messageTemplate: 'Duplicate records are not permitted.{0}{1} to view the existing account.',
                         messageTemplateData: ['', {
                         url: baseurl,
                         label: 'Click here',
                         }],duration:' 10000'});
   						 toastEvent.fire();
                }else{
                    let resultParsed = JSON.parse(result);
                this.showToast(component, 'success', 'SUCCESS', 'Created New Member Affiliation');
                $A.get("e.force:closeQuickAction").fire(); 
                }
                
            } else {
                let error = response.getError();
                console.log('Error Occured: ' + JSON.stringify(error));               
                this.showToast(component, 'error', 'ERROR', 'Error Creation New Member Affiliation. Please try again.: '+  JSON.stringify(error));
                $A.get("e.force:closeQuickAction").fire();      
            }
        });
        $A.enqueueAction(action);     
        
    },
    showToast : function(component, type, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },
})