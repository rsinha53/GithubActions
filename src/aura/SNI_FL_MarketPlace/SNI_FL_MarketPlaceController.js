({
	ShowDetails : function(component, event, helper) {
        if(document.getElementById("marketplaceDetails").style.display == 'none' || document.getElementById("marketplaceDetails").style.display == ''){
            
            document.getElementById("comingSoonDiv").style.display = 'none';
            document.getElementById("comingSoonMob").style.display = 'none';
            
            var cmpList = document.getElementsByClassName("marketplaceDetails");
            for(var i=0; i<= cmpList.length; i++){
                cmpList[i].style.display = 'inherit';
            }
        }else{
            document.getElementById("comingSoonDiv").style.display = 'block';
            document.getElementById("comingSoonMob").style.display = 'block';
            
            var cmpList = document.getElementsByClassName("marketplaceDetails");
            for(var i=0; i<= cmpList.length; i++){
                cmpList[i].style.display = 'none';
            }
        }
	},
    ShowSiteDetails : function(component, event, helper) {
    	window.open('https://PicnicHealth.com/uhc', '_blank');
    }
    
})