({
    memberResults : function(cmp, event, helper) {
        debugger;
        var memberResults = event.getParam('providerResults');
        var findIndWSFlag = event.getParam('findIndividualFlag');
        var flowType = event.getParam('flowType');
        var memberID = event.getParam('memberID');
        var providerSearchFlag = event.getParam('providerSearchFlag');
        var isOtherFlag = event.getParam('isOtherFlag');
        if(flowType == 'Member'){
            cmp.set("v.memberResults",memberResults);
            cmp.set("v.findIndividualWSFlag",findIndWSFlag);
            cmp.set("v.memberID",memberID);
            console.log(cmp.get("v.memberResults"));
            cmp.set("v.memberResultsOriginal",memberResults);
            cmp.set("v.disolveResults",true);
            cmp.set("v.providerSearchFlag",providerSearchFlag);
            cmp.set("v.isOtherFlag",isOtherFlag);
            cmp.set("v.contactName",event.getParam('contactName'));
            cmp.set("v.contactNumber",event.getParam('contactNumber'));
            cmp.set("v.providerId",event.getParam('providerId')); 
            cmp.set("v.interactionCard",event.getParam('interactionCard'));
            cmp.set("v.providerFlow",event.getParam('providerFlow'));
        }
    },
    searchResults : function(cmp,event,helper){
        debugger;
     	var filterResults;
        if(event.getParam('providerResults') != null){
            filterResults  = event.getParam('providerResults');
        }
        var searchKeyWord = event.getParam('searchKeyWord');
        console.log("searchKey"+searchKeyWord);
        var tempArray = [];
        if(filterResults != null){
            if(!$A.util.isEmpty(searchKeyWord)){
            for(var i in filterResults){
                var sourceCode;
                var Name;
                var DOB;
                
                sourceCode = filterResults[i].sourceSysCode;
                Name = filterResults[i].fullName;
                DOB = filterResults[i].birthDate;                                 
               
                if(sourceCode.includes(searchKeyWord.toUpperCase()) || Name.includes(searchKeyWord.toUpperCase()) || DOB.includes(searchKeyWord.toUpperCase())){
               
                    tempArray.push(filterResults[i]);
                    var searchPrvResults = cmp.get("v.memberResults");
                    searchPrvResults = tempArray;
                    cmp.set("v.memberResults",searchPrvResults);
                }
            }
            }else {
            	cmp.set("v.memberResults",cmp.get("v.memberResultsOriginal"));
            }
        }
	}
})