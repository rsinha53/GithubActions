({doInit: function(component, event, helper) {
        helper.getBusinessUnitValues(component,event,helper);
           setTimeout(function(){ helper.getMaterialForms(component,event,helper);
                     },1);
},
	clearQuantity : function(component, event, helper) {
    
	var buttonval = event.getSource().get("v.value");
var elements = document.getElementsByClassName(buttonval+'_inputcls');
          for (var i=0; i<elements.length; i++) {
              if(elements[i].value != ''){
                elements[i].value ='';
              }
        }
        //not working for individual sections
//        alert($("div.autodocTableView[data-auto-doc-section-key='" + buttonval + "']").find("input").length);
         //$("div.autodocTableView[data-auto-doc-section-key='" + buttonval + "']").find("input").prop("checked", false);
         $("div.autodocTableView[data-auto-doc-section-key='" + buttonval + "']").find("input").prop("checked", false);
//         alert('here');
                //$("input").prop("checked", false);
              helper.getselectedformshelper(component,event,helper);
	},
    onChangeBussinessUnit: function(component, event, helper) {
        helper.getMaterialForms(component,event,helper);
    },
  getselectedforms :function(component, event, helper) {
          var inputval = parseInt(event.target.value);
      if(inputval <= 0){
event.target.value ='';
      }else if(inputval > 99 ){
          event.target.value ='';

      }
      helper.getselectedformshelper(component,event,helper);
      },
  inputquantitykeyup :function(component,event,helper){
     var inputval = parseInt(event.target.value);
      if(inputval <= 0){
event.target.value ='';
      }else if(inputval > 99 ){
          event.target.value ='';

      }
  },
  startAutodoc:function(component,event,helper){
//  alert('here');
     setTimeout(function(){
            var tabKey = component.get("v.AutodocKey");
//            alert("tabKey"+tabKey);
            if(window.lgtAutodoc != undefined)
            	window.lgtAutodoc.initAutodoc(tabKey);
            //alert("Done");
            //var MemberdetailFromGroup = component.get("v.MemberdetailFromGroup").enrollmentMethod;
            //alert("Done-1");
            //var orgType = component.get("v.originatorType");
            //console.log("SSS Coverage Benefit" + MemberdetailFromGroup);
//        	component.set("v.Spinner", false);
//            alert('done');
            
        },1);
//        alert('here2');
  },
  Onclickdocument:function(component,event,helper){
      var docurl = event.currentTarget.getAttribute("data-docurl");
      //alert(docurl);
      window.open(docurl, '_blank', 'toolbars=0,width=1200,height=800,left=0,top=0,scrollbars=1,resizable=1');

  } 
})