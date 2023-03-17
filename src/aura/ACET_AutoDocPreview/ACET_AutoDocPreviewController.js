({
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    },
    
    submitDetails: function(component, event, helper) {
        // Set isModalOpen attribute to false
        //Add your code to call apex method or do some processing
        component.set("v.isModalOpen", false);
    },
    
    onLoad: function(component)
    {

        //localStorage.removeItem("rowCheckHold");

        var pagefeature = component.get("v.pagefeature");
        setTimeout(function(){
            var inputF = document.getElementById("autodocHiddenPreview");
            inputF.value = "";
            var pagenum = component.get("v.pageNumber");
            if (pagenum != undefined)
            {
                window.lgtAutodoc.storePaginationData(pagenum,component.get("v.AutodocKey"));
            }
            window.lgtAutodoc.previewAutoDoc(pagefeature, component.get("v.AutodocKey"));
            
            var autodocHidden = document.getElementById("autodocHiddenPreview").value;
            var newhtml = autodocHidden.replace(/100%/g,"auto").replace(/640px/g,"auto");
            document.getElementById("autoContent").innerHTML = newhtml; 
            //removing search: text from autodoc vishnu
            if(newhtml.includes('dataTables_filter') && newhtml.includes('Search:'))
            {
                $("#autoContent .dataTables_filter").html('');
            }
            component.set("v.showSpinner" , false);
            
            if(window.jQuery)
            {
                $("#autoContent tr").removeClass("highlight");
                $("#autoContent span").removeClass("cobra-background");
                $("#autoContent p").removeClass("yellowBg link_field_value");
                $("#autoContent a").replaceWith(function(){
                    return $("<span>" + $(this).html() + "</span>");
                });
                $("#autoContent table").width("100%");
                $("#autoContent span").remove(".tooltiptext");
                $("#autoContent div").removeClass("tooltip");
                $("#autoContent .hideField").removeClass("hideField");
                $("#autoContent").find(".autodoc").remove();
            }
            
        }, 500);
    }
})