({
    onInit: function (cmp, event, helper) {

        var RequiredInfo = cmp.get('v.RequiredInfo'); 
        var Modifier = { ModifierCode: '', ModifierDesc: '' };
        RequiredInfo.ModifierData.push(Modifier);
        cmp.set('v.Modifier', Modifier);
        cmp.set('v.RequiredInfo', RequiredInfo);

    },

    alphanumericAndNoSpecialCharacters: function (cmp, event, helper) {
        helper.keepAlphanumericAndNoSpecialCharacters(cmp, event);
    },

    bindValues: function (cmp, event, helper) {

        var RequiredInfo = cmp.get('v.RequiredInfo');
        var Modifier = cmp.get('v.Modifier');
        var index = cmp.get('v.index');
        RequiredInfo.ModifierData[index] = Modifier;
        cmp.set('v.RequiredInfo', RequiredInfo);

    }

})