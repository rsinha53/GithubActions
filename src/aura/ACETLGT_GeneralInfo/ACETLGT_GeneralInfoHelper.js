({
	updatecallersubdetails : function(cmp, event, helper, memberchange, memId) {
        var originatorId = cmp.get("v.OriginatorId");
        var familylist = cmp.get("v.familymemberlist");
		for(var i=0; i<familylist.length; i++){
            if(!memberchange){
                if(familylist[i].SFrecId===originatorId){
                    var callerdetails = {};
                    callerdetails.FirstName = familylist[i].FirstName;
                    callerdetails.LastName = familylist[i].LastName;
                    callerdetails.Gender = familylist[i].Gender;
                    callerdetails.DOB = familylist[i].DOB;
                    callerdetails.MembId = familylist[i].subscriberIndividualId;
                    callerdetails.PolicyId = familylist[i].groupNumber;
                    callerdetails.Relation = familylist[i].Relationship;
                    cmp.set("v.callerdetails",callerdetails);    
                }                 
           }
            if(familylist[i].subscriberIndividualId==memId && (memberchange || cmp.get("v.subjectdetails")==null || cmp.get("v.subjectdetails")==undefined)){
                var subjdetails = {};
                subjdetails.FirstName = cmp.get("v.firstName");
                subjdetails.LastName = cmp.get("v.lastName");
                subjdetails.Gender = cmp.get("v.memGen");
                subjdetails.DOB = cmp.get("v.memDOB");
                subjdetails.MembId = memId;
                subjdetails.PolicyId = cmp.get("v.grpNum");
                subjdetails.Relation = familylist[i].Relationship;
                cmp.set("v.subjectdetails",subjdetails);
            }
        }
        
	},
})