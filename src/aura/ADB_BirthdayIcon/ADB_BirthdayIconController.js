({
	getMemberBirthDate : function(component){
        var birthday = component.get("v.dateOfBirth");
        if(birthday != null && birthday !=undefined){
            
            var result = new Date();
            var currentYear = result.getFullYear();
            
            result.setDate(result.getDate() - 7);
            var firstdayYear = $A.localizationService.formatDate(result, "YYYY");
            var firstday = $A.localizationService.formatDate(result, "MM-dd");
            
            result.setDate(result.getDate() + 21);
            var lastdayYear = $A.localizationService.formatDate(result, "YYYY");
            var lastday = $A.localizationService.formatDate(result, "MM-dd");
            
            var bdy = $A.localizationService.formatDate(birthday, "MM-dd");
            
            var intcurrentYear = parseInt(currentYear);
            var intFirstdayYear = parseInt(firstdayYear);
            var intLastdayYear = parseInt(lastdayYear);
            var intBdy = parseInt(bdy.replace("-",""));
            var intFirstday = parseInt(firstday.replace("-",""));
            var intLastday = parseInt(lastday.replace("-",""));
            
            if((intcurrentYear == intFirstdayYear) && (intcurrentYear == intLastdayYear)){
                if (intBdy >= intFirstday && intLastday >= intBdy ){
                    component.set("v.isBdyIconDisplay",true);
                }else{
                    component.set("v.isBdyIconDisplay",false);
                }
            }else{
                if (intBdy >= intFirstday && intBdy <= 1231){
                    component.set("v.isBdyIconDisplay",true);
                }else if (intLastday >= intBdy && intBdy >= 101){
                    component.set("v.isBdyIconDisplay",true);
                } else{
                    component.set("v.isBdyIconDisplay",false);
                }
            }
            
        }
    },
    
})