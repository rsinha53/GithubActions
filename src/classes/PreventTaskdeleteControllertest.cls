@istest
private class PreventTaskdeleteControllertest {
private static testmethod void PreventTaskdeleteController() {
      RecordType rType = [Select Id, Name From RecordType Where sObjectType='Task' AND name='SAE Provider'];
      Account acc = new Account();
      acc.Name = 'Test Account';
      insert acc;

      Contact cont = new Contact();
      cont.FirstName='Test';
      cont.LastName='Test';
      cont.Accountid= acc.id;
      insert cont;

     Case c = new Case();
     c.AccountId = acc.Id;
     c.ContactId = cont.Id;
     c.Type = 'My Type';
     c.Status = 'My Status';
     insert c;

     Task t = new Task();
     t.OwnerId = userinfo.getuserId();
     t.WhatId = c.Id;
	 t.subject = 'Email Response';
	 t.RecordTypeId = rType.Id;
     insert t;

     ApexPages.currentPage().getParameters().put('id',t.id);
     ApexPages.StandardController sc = new ApexPages.StandardController(t);
     PreventTaskdeleteController tesk = new PreventTaskdeleteController(sc);

   }
 }