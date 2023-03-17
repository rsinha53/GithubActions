({
    onInit : function(component,event,helper){
        //Setting up colum information
        component.set("v.accountColums",
                      [
                          {
                              label : 'TeamName',
                              fieldName : 'accountName',
                              type : 'url',
                              typeAttributes:{label:{fieldName:'Team_Name__c'},target:'_blank'}
                          },
                     ]);
                          // Call helper to set the data for account table
                          helper.getData(component);
                          },
                          
                          
                          })