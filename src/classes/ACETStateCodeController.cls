//Controller for ACETStateCode component
public class ACETStateCodeController 
{
    public String StateCode 
    { 
        get; 
        set
        {
            StateCode = value;
            UpdateContainer();
        } 
    }
    
    public ACETStateCodeContainer stateCodeContainer; 
        
    // the options for the State Code select list
    public List<SelectOption> StateCodes { get; set; }
                                    
    public ACETStateCodeController()
    {
        StateCodes = new List<SelectOption>();
        StateCodes.add(new SelectOption('', '--None--'));
        StateCodes.add(new SelectOption('AL', 'AL'));
        StateCodes.add(new SelectOption('AK', 'AK'));
        StateCodes.add(new SelectOption('AZ', 'AZ'));
        StateCodes.add(new SelectOption('AR', 'AR'));
        StateCodes.add(new SelectOption('CA', 'CA'));
        StateCodes.add(new SelectOption('CO', 'CO'));
        StateCodes.add(new SelectOption('CT', 'CT'));
        StateCodes.add(new SelectOption('DE', 'DE'));
        StateCodes.add(new SelectOption('DC', 'DC'));
        StateCodes.add(new SelectOption('FL', 'FL'));
        StateCodes.add(new SelectOption('GA', 'GA'));
        StateCodes.add(new SelectOption('HI', 'HI'));
        StateCodes.add(new SelectOption('ID', 'ID'));
        StateCodes.add(new SelectOption('IL', 'IL'));
        StateCodes.add(new SelectOption('IN', 'IN'));
        StateCodes.add(new SelectOption('IA', 'IA'));
        StateCodes.add(new SelectOption('KS', 'KS'));
        StateCodes.add(new SelectOption('KY', 'KY'));
        StateCodes.add(new SelectOption('LA', 'LA'));
        StateCodes.add(new SelectOption('ME', 'ME'));
        StateCodes.add(new SelectOption('MD', 'MD'));
        StateCodes.add(new SelectOption('MA', 'MA'));
        StateCodes.add(new SelectOption('MI', 'MI'));
        StateCodes.add(new SelectOption('MN', 'MN'));
        StateCodes.add(new SelectOption('MS', 'MS'));
        StateCodes.add(new SelectOption('MO', 'MO'));
        StateCodes.add(new SelectOption('MT', 'MT'));
        StateCodes.add(new SelectOption('NE', 'NE'));
        StateCodes.add(new SelectOption('NV', 'NV'));
        StateCodes.add(new SelectOption('NH', 'NH')); 
        StateCodes.add(new SelectOption('NJ', 'NJ'));
        StateCodes.add(new SelectOption('NM', 'NM'));
        StateCodes.add(new SelectOption('NY', 'NY'));
        StateCodes.add(new SelectOption('NC', 'NC'));
        StateCodes.add(new SelectOption('ND', 'ND'));
        StateCodes.add(new SelectOption('OH', 'OH'));
        StateCodes.add(new SelectOption('OK', 'OK'));
        StateCodes.add(new SelectOption('OR', 'OR'));
        StateCodes.add(new SelectOption('PA', 'PA'));
        StateCodes.add(new SelectOption('PR', 'PR'));
        StateCodes.add(new SelectOption('RI', 'RI'));
        StateCodes.add(new SelectOption('SC', 'SC'));
        StateCodes.add(new SelectOption('SD', 'SD'));
        StateCodes.add(new SelectOption('TN', 'TN'));
        StateCodes.add(new SelectOption('TX', 'TX'));
        StateCodes.add(new SelectOption('UT', 'UT'));
        StateCodes.add(new SelectOption('VT', 'VT'));
        StateCodes.add(new SelectOption('VA', 'VA'));
        StateCodes.add(new SelectOption('WA', 'WA'));
        StateCodes.add(new SelectOption('WV', 'WV'));
        StateCodes.add(new SelectOption('WI', 'WI'));
        StateCodes.add(new SelectOption('WY', 'WY'));
    }   
    
    public ACETStateCodeContainer getStateCodeContainer()
    {
        return stateCodeContainer;
    }
    
    public void setStateCodeContainer(ACETStateCodeContainer sc)
    {
        stateCodeContainer = sc;
        StateCode = String.isBlank(sc.value) ? '' : sc.value;
        
    }
    
    // the user has changed State Code picklist values, so update
    // the State Code encapsulated by the StateCode property
    private void UpdateContainer()
    {
        stateCodeContainer.value = StateCode;
    }
}