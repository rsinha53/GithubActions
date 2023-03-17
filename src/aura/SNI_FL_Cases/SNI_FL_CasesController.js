({
    //Vamsi
    doInit : function(component, event, helper) {
        if(screen.width < 500){
            component.set('v.isSmallScreen', true);
        }
    },

    //Change the data in list when click my cases tab
    //Author : Nanthu - ACDC
    viewMyCases : function(component, event, helper){
        component.set("v.selectedTab", "My Cases");

        var allCaseView = component.find('allCaseView');
        $A.util.addClass(allCaseView, 'inactive');
        $A.util.removeClass(allCaseView, 'active');

        var myCaseView = component.find('myCaseView');
        $A.util.addClass(myCaseView, 'active');
        $A.util.removeClass(myCaseView, 'inactive');

        var userRecord = component.get("v.userRecord");
        var cases = component.get("v.listOfCases");
        var selectedView = component.get("v.selectedView");

        if(selectedView == "Grid View"){
            var openCases = [];
            var closeCases = [];
            component.set("v.listOfOpenCases",openCases);
            component.set("v.listOfClosedCases",closeCases);

            for(let index in cases){
                if(cases[index].caseAboutUserID == userRecord.ContactId){
                    if(cases[index].caseStatus != 'Closed'){
                        openCases.push(cases[index]);           
                    }else{
                        closeCases.push(cases[index]);
                    }
                }
            }
            component.set("v.listOfOpenCases",openCases);
            component.set("v.listOfClosedCases",closeCases);
        } else {
            var individualSortOrder = [];
            component.set("v.listOfSortOrder", individualSortOrder);

            const result = cases.reduce((total, value) => {
                total[value.caseAboutUser] = (total[value.caseAboutUser] || 0) + 1;
                return total;
            }, {});

            for (let value of Object.keys(result)) {
                if(value == userRecord.Name){
                    var openCases = [];
                    var closeCases = [];
                   
                    for(let index in cases){
                        if(cases[index].caseAboutUser == value){
                            if(cases[index].caseStatus != 'Closed'){
                                openCases.push(cases[index]);           
                            }else{
                                closeCases.push(cases[index]);
                            }
                        }
                    } 
                    let finalObj = {
                        "userName":value,
                        "openCases":openCases,
                        "closeCases":closeCases,
                    };
                    individualSortOrder.push(finalObj);
                }
            }
            component.set("v.listOfSortOrder", individualSortOrder);
        }
        
    },

    //Change the data in list when click All cases tab
    //Author : Nanthu - ACDC
    viewAllCases : function(component, event, helper){
        component.set("v.selectedTab", "All Cases");

        var myCaseView = component.find('myCaseView');
        $A.util.addClass(myCaseView, 'inactive');
        $A.util.removeClass(myCaseView, 'active');

        var allCaseView = component.find('allCaseView');
        $A.util.addClass(allCaseView, 'active');
        $A.util.removeClass(allCaseView, 'inactive');

        var cases = component.get("v.listOfCases");
        var selectedView = component.get("v.selectedView");

        if(selectedView == "Grid View"){
            var openCases = [];
            var closeCases = [];
            component.set("v.listOfOpenCases",openCases);
            component.set("v.listOfClosedCases",closeCases);

            for(let index in cases){
                if(cases[index].caseStatus != 'Closed'){
                    openCases.push(cases[index]);           
                }else{
                    closeCases.push(cases[index]);
                }
            }
            component.set("v.listOfOpenCases",openCases);
            component.set("v.listOfClosedCases",closeCases);
        } else {
            var individualSortOrder = [];
            component.set("v.listOfSortOrder", individualSortOrder);

            const result = cases.reduce((total, value) => {
                total[value.caseAboutUser] = (total[value.caseAboutUser] || 0) + 1;
                return total;
            }, {});

            for (let value of Object.keys(result)) {
                var openCases = [];
                var closeCases = [];
               
                for(let index in cases){
                    if(cases[index].caseAboutUser == value){
                        if(cases[index].caseStatus != 'Closed'){
                            openCases.push(cases[index]);           
                        }else{
                            closeCases.push(cases[index]);
                        }
                    }
                } 
                let finalObj = {
                    "userName":value,
                    "openCases":openCases,
                    "closeCases":closeCases,
                };
                individualSortOrder.push(finalObj);
            }
            component.set("v.listOfSortOrder", individualSortOrder);
        }
    },

    //Change the data in list when click grid view
    //Author : Nanthu - ACDC
    gridViewCases : function(component, event, helper){
        component.set("v.selectedView", "Grid View");

        var individualView = component.find('individualView');
        $A.util.addClass(individualView, 'inactive');
        $A.util.removeClass(individualView, 'active');

        var gridView = component.find('gridView');
        $A.util.addClass(gridView, 'active');
        $A.util.removeClass(gridView, 'inactive');

        var cases = component.get("v.listOfCases");
        var selectedTab = component.get("v.selectedTab");

        if(selectedTab == "All Cases"){
            var openCases = [];
            var closeCases = [];
            component.set("v.listOfOpenCases",openCases);
            component.set("v.listOfClosedCases",closeCases);

            for(let index in cases){
                if(cases[index].caseStatus != 'Closed'){
                    openCases.push(cases[index]);           
                }else{
                    closeCases.push(cases[index]);
                }
            }
            component.set("v.listOfOpenCases",openCases);
            component.set("v.listOfClosedCases",closeCases);
        } else {
            var userRecord = component.get("v.userRecord");
            var openCases = [];
            var closeCases = [];
            component.set("v.listOfOpenCases",openCases);
            component.set("v.listOfClosedCases",closeCases);

            for(let index in cases){
                if(cases[index].caseAboutUserID == userRecord.ContactId){
                    if(cases[index].caseStatus != 'Closed'){
                        openCases.push(cases[index]);           
                    }else{
                        closeCases.push(cases[index]);
                    }
                }
            }
            component.set("v.listOfOpenCases",openCases);
            component.set("v.listOfClosedCases",closeCases);
        }
    },

    //Change the data in list when click individual view
    //Author : Nanthu - ACDC
    individualViewCases : function(component, event, helper){
        component.set("v.selectedView", "Individual View");

        var gridView = component.find('gridView');
        $A.util.addClass(gridView, 'inactive');
        $A.util.removeClass(gridView, 'active');

        var individualView = component.find('individualView');
        $A.util.addClass(individualView, 'active');
        $A.util.removeClass(individualView, 'inactive');

        var cases = component.get("v.listOfCases");
        var selectedTab = component.get("v.selectedTab");
      
        const result = cases.reduce((total, value) => {
            total[value.caseAboutUser] = (total[value.caseAboutUser] || 0) + 1;
            return total;
        }, {});

        if(selectedTab == "All Cases"){
            var individualSortOrder = [];
            component.set("v.listOfSortOrder", individualSortOrder);

            for (let value of Object.keys(result)) {
                var openCases = [];
                var closeCases = [];
               
                for(let index in cases){
                    if(cases[index].caseAboutUser == value){
                        if(cases[index].caseStatus != 'Closed'){
                            openCases.push(cases[index]);           
                        }else{
                            closeCases.push(cases[index]);
                        }
                    }
                } 
                let finalObj = {
                    "userName":value,
                    "openCases":openCases,
                    "closeCases":closeCases,
                };
                individualSortOrder.push(finalObj);
            }
            component.set("v.listOfSortOrder", individualSortOrder);

        } else {
            var userRecord = component.get("v.userRecord");
            var individualSortOrder = [];
            component.set("v.listOfSortOrder", individualSortOrder);

            for (let value of Object.keys(result)) {
                if(value == userRecord.Name){
                    var openCases = [];
                    var closeCases = [];
                   
                    for(let index in cases){
                        if(cases[index].caseAboutUser == value){
                            if(cases[index].caseStatus != 'Closed'){
                                openCases.push(cases[index]);           
                            }else{
                                closeCases.push(cases[index]);
                            }
                        }
                    } 
                    let finalObj = {
                        "userName":value,
                        "openCases":openCases,
                        "closeCases":closeCases,
                    };
                    individualSortOrder.push(finalObj);
                }
            }
            component.set("v.listOfSortOrder", individualSortOrder);
        }
    },

    //Retrieves list of case which are open and close that are related to the 
    //familyLink user and users who signed ROI
    //Author: Sameera Silva ACDC
    retrieveCaseData:function(component,event,helper){
        
        var logedInUserID = $A. get("$SObjectType.CurrentUser.Id");
        var familyAccountId = component.get("v.selectFamilyId");
        helper.getListOfCases(component,event,logedInUserID,familyAccountId);
    },
    
    /*loading the case comment modal - web view*/
    //Author: Pavithra Fernando ACDC
    viewCaseComments : function(component, event, helper) {                   
        var ctarget = event.currentTarget; 
        var selectCase = ctarget.dataset.value;         
        component.set("v.selectedCase",selectCase);
        component.set("v.IsOpenCaseComment",true);
        var isOpen = component.get("v.IsOpenCaseComment");

    },
    
    /*loading the case comment modal - mobile view*/
    //Author: Pavithra Fernando ACDC
    mobileViewCaseComments: function(component, event, helper) {   
        try{
            var ctarget = event.currentTarget;
            var selectCase = ctarget.dataset.value;
            component.set("v.selectedCase",selectCase);
            component.set("v.IsOpenCaseComment",true);
        }catch(e){
            console.error('ERROR ## ' + e);
        }
       
    },
    
    /*loading the case attachment modal - web and mobile view*/
    //Author: Pavithra Fernando ACDC
    viewCaseAttachments: function(component, event, helper) {   
        try{
            var ctarget = event.currentTarget; 
            var selectCase = ctarget.dataset.value;   
            console.log('selectCase - '+ selectCase);
            component.set("v.selectedCase",selectCase);
            component.set("v.IsOpenCaseAttachment",true);

        }catch(e){
            console.error('ERROR ## ' + e);
        }
       
    },
})