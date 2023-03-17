({
    onblur : function(component,event,helper){
        // on mouse leave clear the listOfSeachRecords & hide the search result component
       // debugger;        
        //component.set("v.listOfSearchRecords", null );
        setTimeout(function(){ 

        component.set("v.SearchKeyWord", '');
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
             }, 1000);
    },
    onfocus : function(component,event,helper){        
        // show the spinner,show child search result component and call helper function 
        debugger;
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        component.set("v.listOfSearchRecords", null ); 
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.addClass(forOpen, 'slds-has-focus');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC 
        var getInputkeyWord = '';
        /**var scrollTop = $(window).scrollTop();
        var topOffset = $(".slds-dropdown").offset().top;
        var relativeOffset = topOffset-scrollTop;
        var windowHeight = $(window).height();
        var menuId = component.find('menu');
       if(relativeOffset > windowHeight/2){
               $A.util.addClass(menuId,'topClass');
                    }
                    
      else{
                       $A.util.addClass(menuId,'bottomClass');
                    } */
       var listOfOptions = component.get("v.listOfAllRecords");
        console.log('All Records : ' + component.get("v.listOfAllRecords"));
        if(component.get('v.selectedRadio') == 'All') {
             
       }for(var i =0 ; i< listOfOptions.length; i++) {
             if(listOfOptions[i].label.indexOf('%') >= 0) {
              listOfOptions[i].label = listOfOptions[i].label.replace('%','*');
              console.log('specialty');
              console.log(listOfOptions[i].label);
            }
        }
      
        
        
        helper.searchHelper(component,event,helper,getInputkeyWord);
        //var localId = event.getSource().getLocalId();
        //component.find(localId).focus();
    },
    
    keyPressController : function(component, event, helper) {
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        console.log(getInputkeyWord);
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        
        if(getInputkeyWord.length > 0){
            console.log('enter method');
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,helper,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
        
    },
    keyPressEventController : function(component, event, helper) {
        //debugger;
        if (event.which === 13){                        

            if (component.get("v.listOfSearchRecords") != null && component.get("v.listOfSearchRecords").length == 1){

                $A.util.removeClass(component.find('lookup-pill'), "slds-has-error");        
                component.set("v.benefitError", ""); 
                
                component.set("v.SearchKeyWord",null);                	 
                var listSelectedItems =  component.get("v.lstSelectedRecords");                
                var selectedAccountGetFromEvent = component.get("v.listOfSearchRecords")[0];  
                listSelectedItems.push(selectedAccountGetFromEvent);
                component.set("v.lstSelectedRecords" , listSelectedItems); 
                var forclose = component.find("lookup-pill");
                $A.util.addClass(forclose, 'slds-show');
                $A.util.removeClass(forclose, 'slds-hide');
                
                var forclose = component.find("searchRes");
                $A.util.addClass(forclose, 'slds-is-close');
                $A.util.removeClass(forclose, 'slds-is-open');
            }
         }
        
    },    
    
    
    
    // function for clear the Record Selection 
    clear :function(component,event,helper){
      

        var selectedPillId = event.getSource().get("v.label");
        var selectedPillName = event.getSource().get("v.name");
        var AllPillList = component.get("v.lstSelectedRecords"); 
        var selectedBenefitLangcodes = [];
        var viewBenefitButtonSelectedOptions = [];
        var selectedBenefitCodeList = JSON.parse(JSON.stringify(AllPillList));
        for(var i =0; i <selectedBenefitCodeList.length; i++) {
            viewBenefitButtonSelectedOptions.push(selectedBenefitCodeList[i].value);
        }
        console.log('viewBenefitButtonSelectedOptions' +viewBenefitButtonSelectedOptions);
        for(var i = 0; i < AllPillList.length; i++){
            if(AllPillList[i].label == selectedPillId){
                AllPillList.splice(i, 1);
                component.set("v.lstSelectedRecords", AllPillList);
            }  
        }
        for(var i = 0; i < AllPillList.length; i++){
             selectedBenefitLangcodes.push(AllPillList[i].value);
        }
        console.log('selectedBenefitLangcodes' +selectedBenefitLangcodes);
        var compEvent = component.getEvent("SelectedBenefitKeyEvent");
        debugger;
        compEvent.setParams({"viewBenefitButtonSelectedOptions" : viewBenefitButtonSelectedOptions });
        compEvent.setParams({"selectedBenefitLangcodes" : selectedBenefitLangcodes });
        compEvent.setParams({"selectedBenefitLangcodestring" : selectedPillId });

        compEvent.fire();   
        var selectedRecords = AllPillList.length;
        if(selectedRecords < 20) {
            component.set("v.benefitErrorMessage",""); 
            var maxBenefitsSelected = false;
            component.set("v.maxBenefitsSelected", maxBenefitsSelected);
        }
        component.set("v.SearchKeyWord",null);                            
        component.set("v.listOfSearchRecords", null );      
    },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        $A.util.removeClass(component.find('lookup-pill'), "slds-has-error");        
        component.set("v.benefitError", ""); 
        
        component.set("v.SearchKeyWord",null); 
        
        // get the selected object record from the COMPONENT event 	 
        var listSelectedItems =  component.get("v.lstSelectedRecords");
        if(listSelectedItems.length >= 1)
        {
            listSelectedItems = [];
        }
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        var valueSelected = event.getParam("isSelectValue");
        var selectedBenefitLangcodes = [];
        var selectedBenefitLangOptions = []; 
        for(var i =0; i <listSelectedItems.length; i++) {
            console.log(listSelectedItems[i].value);
            selectedBenefitLangcodes.push(listSelectedItems[i].value);
        }
        if(selectedBenefitLangcodes != null){                 
              for(var i=0;i<selectedBenefitLangcodes.length;i++){
                    if(selectedBenefitLangcodes[i].indexOf(';')>-1){
                         var tempSelectedBenefitLangcodes = selectedBenefitLangcodes[i].split(';');
                         for(var b = 0; b<tempSelectedBenefitLangcodes.length;b++){                                   
                                   selectedBenefitLangOptions.push(b);
                          }  
                   }else{
                          selectedBenefitLangOptions.push(1);
                    }                           
             }
        }
        console.log('count>>>'+selectedBenefitLangOptions);
        console.log('count>>>'+selectedBenefitLangOptions.length);
        if(selectedBenefitLangOptions.length < 20){
           listSelectedItems.push(selectedAccountGetFromEvent);
          component.set("v.lstSelectedRecords" , listSelectedItems);    
        }
        
        else{
                component.set("v.benefitErrorMessage","Maximum number of benefits have been selected (20).");  
                component.set('v.maxBenefitsSelected',!component.get('v.maxBenefitsSelected'));
                $A.util.removeClass(component.find("msgTxtBname"), "slds-hide");
                $A.util.addClass(component.find("msgTxtBname"), "slds-show");  
                return;
        }
        var selectedRecordsList = component.get("v.lstSelectedRecords");
        var planBenefitAutoCompleteCmp = component.find('lookup-pill');
       /** if(component.get('v.selectedRadio') == 'CATEGORY') {
            $A.util.addClass(planBenefitAutoCompleteCmp, 'categoryClass');
        }else {
            $A.util.removeClass(planBenefitAutoCompleteCmp, 'categoryClass');
        }
        if(component.get('v.selectedRadio') == 'Specialty') {
            $A.util.addClass(planBenefitAutoCompleteCmp, 'specialtyClass');
        }else {
            $A.util.removeClass(planBenefitAutoCompleteCmp, 'specialtyClass');
        } */
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        
    },
     handleComponentRadioEvent : function(component, event, helper) {
        debugger;
       
        // get the selected object record from the COMPONENT event 	 
        var listSelectedItems =  component.get("v.listOfAllRecords");
        var selectedAccountGetFromEvent = event.getParam("selectedRadio");
        var specialtyList = [];
        for(var k =0; k < listSelectedItems.length; k++) {
            if(listSelectedItems[k].label.indexOf('%') >= 0){
                 specialtyList.push(listSelectedItems[k].label);
            }
        }
        var specialtyString = specialtyList.join();
       
        
        
        
        
    },
    toggleHelpTextHover: function(component, event, helper) {
        var benefitHover = component.get("v.isBenefitHoverVisible");
        component.set("v.isBenefitHoverVisible", !benefitHover);
        
    }
    
})