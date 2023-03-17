@isTest
public class JSON2ApexOrgSearchTest {

public static testMethod void JSON2ApexOrgSearch_TestMethod(){

    JSON2ApexOrgSearch apex = new JSON2ApexOrgSearch();
    JSON2ApexOrgSearch.Meta met = new JSON2ApexOrgSearch.Meta();
    //JSON2ApexOrgSearch.Profile pro = new JSON2ApexOrgSearch.Profile();
    met.profile = new List<String>();
    met.profile.add('Test');
    JSON2ApexOrgSearch.Address addr = new JSON2ApexOrgSearch.Address();
    //JSON2ApexOrgSearch.Address add = new JSON2ApexOrgSearch.Address();
    addr.type = 'Physical';
    addr.line = new List<String>();
    addr.line.add('2320 Line addr');
    addr.city = 'Test';
    addr.state = 'Test';
    addr.postalCode = 'Test';
    addr.rank = 1;
     JSON2ApexOrgSearch.Coding codg = new JSON2ApexOrgSearch.Coding();
        codg.system_Z  = 'Test';
        codg.code    = 'Test';
        codg.display    = 'Test';

      JSON2ApexOrgSearch.Type tp = new JSON2ApexOrgSearch.Type();
      tp.coding = new List<JSON2ApexOrgSearch.Coding>();
      tp.coding.add(codg);

    JSON2ApexOrgSearch.ValueMetadata valm = new JSON2ApexOrgSearch.ValueMetadata();
        valm.modifiedDateTime  ='Test';
        valm.validated  =true;
        valm.valid   =true;
        valm.cleansed   =true;
        valm.sourceSystemCd   ='Test';

    JSON2ApexOrgSearch.Search srch = new JSON2ApexOrgSearch.Search();
        srch.mode  ='Test';
        srch.score  = 1.0;

    JSON2ApexOrgSearch.Characteristic char2 = new JSON2ApexOrgSearch.Characteristic();
        char2.name    ='Test';
        char2.value    ='Test';

    JSON2ApexOrgSearch.Period prd = new JSON2ApexOrgSearch.Period();
        prd.active = true;

    JSON2ApexOrgSearch.EventCoding evecd = new JSON2ApexOrgSearch.EventCoding();
        evecd.code   ='Test';
        evecd.display   ='Test';

    JSON2ApexOrgSearch.Focus foc = new JSON2ApexOrgSearch.Focus ();
       foc.reference    ='Test';
    
        JSON2ApexOrgSearch.Extension ext = new JSON2ApexOrgSearch.Extension();
            ext.url    ='Test';
            ext.valueBoolean    =true;
            ext.valueMetadata  = valm;
        
        JSON2ApexOrgSearch.Code cd = new JSON2ApexOrgSearch.Code();
        cd.coding = new List<JSON2ApexOrgSearch.EventCoding>();
            cd.coding.add(evecd);
            cd.text  = 'Test';
        JSON2ApexOrgSearch.Qualification qual = new JSON2ApexOrgSearch.Qualification();
         qual.code   = cd;
    
        JSON2ApexOrgSearch.Specialty spc = new JSON2ApexOrgSearch.Specialty();
        spc.extension = new List<JSON2ApexOrgSearch.Extension>();
            spc.extension.add(ext); 
            spc.coding = new List<JSON2ApexOrgSearch.Coding>();
            spc.coding.add(codg);   
        

        
        JSON2ApexOrgSearch.Telecom tel = new JSON2ApexOrgSearch.Telecom();
            tel.system_Z   ='Test';
            tel.value   ='Test';

     JSON2ApexOrgSearch.Identifier iden = new JSON2ApexOrgSearch.Identifier();
        iden.type  = tp;
        iden.value    ='Test';
        iden.characteristic = new List<JSON2ApexOrgSearch.Characteristic>();
        iden.characteristic.add(char2);
        iden.period  = prd;
         JSON2ApexOrgSearch.Resource resc = new JSON2ApexOrgSearch.Resource();
         JSON2ApexOrgSearch.Entry  ent = new JSON2ApexOrgSearch.Entry();
         JSON2ApexOrgSearch.Response resp = new JSON2ApexOrgSearch.Response();
       ent.resource = resc;
        ent.search = srch;
        ent.response = resp;

        JSON2ApexOrgSearch.Outcome outc = new JSON2ApexOrgSearch.Outcome();
        outc.resourceType = 'Test';
        outc.id = 'Test';
        outc.meta = met;
        outc.entry = new List<JSON2ApexOrgSearch.Entry>();
        outc.entry.add(ent); 
        
        resp.status  = 'Test';
        resp.outcome = outc;
        JSON2ApexOrgSearch.Source src = new JSON2ApexOrgSearch.Source();
        src.endpoint    ='Test';
   
        resc.resourceType  = 'Test';
        resc.identifier = new List<JSON2ApexOrgSearch.Identifier>();
        resc.identifier.add(iden);
        resc.telecom = new List<JSON2ApexOrgSearch.Telecom>();
        resc.telecom.add(tel);
        resc.singleAddress  = addr;
        resc.address = new List<JSON2ApexOrgSearch.Address>();
        resc.address.add(addr);
        //public List<Name> name  
        resc.name  = 'Test';
        resc.gender  = 'Test';
        resc.qualification = new List<JSON2ApexOrgSearch.Qualification>();
        resc.qualification.add(qual);
        resc.specialty = new List<JSON2ApexOrgSearch.Specialty>();
        resc.specialty.add(spc);
       resc.eventCoding  = evecd;
        resc.source   = src;
        resc.focus = new List<JSON2ApexOrgSearch.Focus>();
        resc.focus.add(foc);
        resc.status  = 'Test';
        resc.outcome = outc;
        
    }
    public static testMethod void JSON2ApexPracSearch_TestMethod(){

    JSON2ApexPracSearch apex = new JSON2ApexPracSearch();
    JSON2ApexPracSearch.Meta met = new JSON2ApexPracSearch.Meta();
    //JSON2ApexPracSearch.Profile pro = new JSON2ApexPracSearch.Profile();
    met.profile = new List<String>();
    met.profile.add('Test');
    JSON2ApexPracSearch.Address addr = new JSON2ApexPracSearch.Address();
    //JSON2ApexPracSearch.Address add = new JSON2ApexPracSearch.Address();
    addr.type = 'Physical';
    addr.line = new List<String>();
    addr.line.add('2320 Line addr');
    addr.city = 'Test';
    addr.state = 'Test';
    addr.postalCode = 'Test';
    addr.rank = 1;
     JSON2ApexPracSearch.Coding codg = new JSON2ApexPracSearch.Coding();
        codg.system_Z  = 'Test';
        codg.code    = 'Test';
        codg.display    = 'Test';

      JSON2ApexPracSearch.Type tp = new JSON2ApexPracSearch.Type();
      tp.coding = new List<JSON2ApexPracSearch.Coding>();
      tp.coding.add(codg);


    JSON2ApexPracSearch.Search srch = new JSON2ApexPracSearch.Search();
        srch.mode  ='Test';
        srch.score  = 1.0;

    JSON2ApexPracSearch.Characteristic char2 = new JSON2ApexPracSearch.Characteristic();
        char2.name    ='Test';
        char2.value    ='Test';

    JSON2ApexPracSearch.Period prd = new JSON2ApexPracSearch.Period();
        prd.active = true;

    JSON2ApexPracSearch.EventCoding evecd = new JSON2ApexPracSearch.EventCoding();
        evecd.code   ='Test';
        evecd.display   ='Test';

    JSON2ApexPracSearch.Focus foc = new JSON2ApexPracSearch.Focus ();
       foc.reference    ='Test';
    
        JSON2ApexPracSearch.Extension ext = new JSON2ApexPracSearch.Extension();
            ext.url    ='Test';
            ext.valueBoolean    =true;
            
        
        JSON2ApexPracSearch.Code cd = new JSON2ApexPracSearch.Code();
        cd.coding = new List<JSON2ApexPracSearch.EventCoding>();
            cd.coding.add(evecd);
           
        JSON2ApexPracSearch.Qualification qual = new JSON2ApexPracSearch.Qualification();
         qual.code   = cd;
    
        JSON2ApexPracSearch.Specialty spc = new JSON2ApexPracSearch.Specialty();
        spc.extension = new List<JSON2ApexPracSearch.Extension>();
            spc.extension.add(ext); 
            spc.coding = new List<JSON2ApexPracSearch.Coding>();
            spc.coding.add(codg);   
        

        
        JSON2ApexPracSearch.Telecom tel = new JSON2ApexPracSearch.Telecom();
            tel.system_Z   ='Test';
            tel.value   ='Test';

     JSON2ApexPracSearch.Identifier iden = new JSON2ApexPracSearch.Identifier();
        iden.type  = tp;
        iden.value    ='Test';
        iden.characteristic = new List<JSON2ApexPracSearch.Characteristic>();
        iden.characteristic.add(char2);
        iden.period  = prd;
         JSON2ApexPracSearch.Resource resc = new JSON2ApexPracSearch.Resource();
         JSON2ApexPracSearch.Entry  ent = new JSON2ApexPracSearch.Entry();
         JSON2ApexPracSearch.Response resp = new JSON2ApexPracSearch.Response();
       ent.resource = resc;
        ent.search = srch;
        ent.response = resp;

        JSON2ApexPracSearch.Outcome outc = new JSON2ApexPracSearch.Outcome();
        outc.resourceType = 'Test';
        outc.id = 'Test';
        outc.meta = met;
        outc.entry = new List<JSON2ApexPracSearch.Entry>();
        outc.entry.add(ent); 
        
        resp.status  = 'Test';
        resp.outcome = outc;
        JSON2ApexPracSearch.Given gv = new JSON2ApexPracSearch.Given();
        gv.extension = new List<JSON2ApexPracSearch.Extension>();
        gv.extension.add(ext);
        JSON2ApexPracSearch.Name nm = new JSON2ApexPracSearch.Name();
        nm.use = 'Test';
        nm.family = 'Test';
        nm.given = new List<String>();
        nm.x_given = new List<JSON2ApexPracSearch.Given>();
        
        
        resc.resourceType  = 'Test';
        resc.identifier = new List<JSON2ApexPracSearch.Identifier>();
        resc.identifier.add(iden);
        resc.telecom = new List<JSON2ApexPracSearch.Telecom>();
        resc.telecom.add(tel);
        resc.singleAddress  = addr;
        resc.address = new List<JSON2ApexPracSearch.Address>();
        resc.address.add(addr);
        resc.name  = new List<JSON2ApexPracSearch.Name>();
        //resc.name  = 'Test';
        resc.gender  = 'Test';
        resc.qualification = new List<JSON2ApexPracSearch.Qualification>();
        resc.qualification.add(qual);
        resc.specialty = new List<JSON2ApexPracSearch.Specialty>();
        resc.specialty.add(spc);
       resc.eventCoding  = evecd;
        //resc.source   = src;
        resc.focus = new List<JSON2ApexPracSearch.Focus>();
        resc.focus.add(foc);
        //resc.status  = 'Test';
        //resc.outcome = outc;
        
    }
    
  
}