public class ACETStateController {
    public String State {get;set;}
    public ACETStateController(){ 
        if(ApexPages.currentPage().getParameters().get('ST') != null && ApexPages.currentPage().getParameters().get('ST') != '')
            State = ApexPages.currentPage().getParameters().get('ST') ;
    }   
    public List<SelectOption> getStateOptions(){                        
        List<SelectOption> stateOptions = new List<SelectOption>();   
             
        stateOptions.add(new SelectOption('', '--None--'));
        stateOptions.add(new SelectOption('AK', 'AK'));
        stateOptions.add(new SelectOption('AL', 'AL'));
        stateOptions.add(new SelectOption('AR', 'AR'));
        stateOptions.add(new SelectOption('AZ', 'AZ'));
        stateOptions.add(new SelectOption('CA', 'CA'));
        stateOptions.add(new SelectOption('CO', 'CO'));
        stateOptions.add(new SelectOption('CT', 'CT'));
        stateOptions.add(new SelectOption('DC', 'DC'));
        stateOptions.add(new SelectOption('DE', 'DE'));
        stateOptions.add(new SelectOption('FL', 'FL'));
        stateOptions.add(new SelectOption('GA', 'GA'));
        stateOptions.add(new SelectOption('HI', 'HI'));
        stateOptions.add(new SelectOption('IA', 'IA'));
        stateOptions.add(new SelectOption('ID', 'ID'));
        stateOptions.add(new SelectOption('IL', 'IL'));
        stateOptions.add(new SelectOption('IN', 'IN'));
        stateOptions.add(new SelectOption('KS', 'KS'));
        stateOptions.add(new SelectOption('KY', 'KY'));
        stateOptions.add(new SelectOption('LA', 'LA'));
        stateOptions.add(new SelectOption('MA', 'MA'));
        stateOptions.add(new SelectOption('MD', 'MD'));
        stateOptions.add(new SelectOption('ME', 'ME'));
        stateOptions.add(new SelectOption('MI', 'MI'));
        stateOptions.add(new SelectOption('MN', 'MN'));
        stateOptions.add(new SelectOption('MO', 'MO'));
        stateOptions.add(new SelectOption('MS', 'MS'));
        stateOptions.add(new SelectOption('MT', 'MT'));
        stateOptions.add(new SelectOption('NC', 'NC'));
        stateOptions.add(new SelectOption('ND', 'ND'));
        stateOptions.add(new SelectOption('NE', 'NE'));
        stateOptions.add(new SelectOption('NH', 'NH')); 
        stateOptions.add(new SelectOption('NJ', 'NJ'));
        stateOptions.add(new SelectOption('NM', 'NM'));
        stateOptions.add(new SelectOption('NV', 'NV'));
        stateOptions.add(new SelectOption('NY', 'NY'));
        stateOptions.add(new SelectOption('OH', 'OH'));
        stateOptions.add(new SelectOption('OK', 'OK'));
        stateOptions.add(new SelectOption('OR', 'OR'));
        stateOptions.add(new SelectOption('PA', 'PA'));
        stateOptions.add(new SelectOption('PR', 'PR'));
        stateOptions.add(new SelectOption('RI', 'RI'));
        stateOptions.add(new SelectOption('SC', 'SC'));
        stateOptions.add(new SelectOption('SD', 'SD'));
        stateOptions.add(new SelectOption('TN', 'TN'));
        stateOptions.add(new SelectOption('TX', 'TX'));
        stateOptions.add(new SelectOption('UT', 'UT'));
        stateOptions.add(new SelectOption('VA', 'VA'));
        stateOptions.add(new SelectOption('VT', 'VT'));
        stateOptions.add(new SelectOption('WA', 'WA'));
        stateOptions.add(new SelectOption('WI', 'WI'));
        stateOptions.add(new SelectOption('WV', 'WV'));
        stateOptions.add(new SelectOption('WY', 'WY'));        
        return stateOptions;
    }
}