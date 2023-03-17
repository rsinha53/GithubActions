({
    onInit : function(component,event,helper){
        //Setting up colum information
        component.set("v.accountColums",
                      [
                          {
                              label : 'FirstName',
                              fieldName : 'accountName',
                              type : 'url',
                              typeAttributes:{label:{fieldName:'FirstName'},target:'_blank'}
                          },
                          {
                              label : 'LastName',
                              fieldName : 'accountName1',
                              type : 'url',
                              typeAttributes:{label:{fieldName:'LastName'},target:'_blank'}
                          },
                          {
                              label : 'Email',
                              fieldName : 'PersonEmail',
                              type : 'email',
                          },
                          
                      ]);
                          // Call helper to set the data for account table
                          helper.getData(component);
                          },
                          
                          
                          })