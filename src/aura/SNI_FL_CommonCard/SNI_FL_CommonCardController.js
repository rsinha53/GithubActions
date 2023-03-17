({
	getItems : function(component, event, helper) {
		var fields = component.get('v.subFields').split(',');
        var fobj = [];
        var index = 0;
        fields.forEach(function(obj){
            var object = component.get('v.cardObject.' + obj);
            fobj.push({value: object,key:obj});
            index++;
        });
        component.set('v.FieldObjs',fobj);
	}
})