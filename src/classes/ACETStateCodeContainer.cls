//Custom class to encapsulate a State Code property for use in select State Code component

public class ACETStateCodeContainer 
{
    // the State Code encapsulated
    public String value {get; set;}
    
    // Constructor - takes the default state code to encapsulate
    public ACETStateCodeContainer(String DefaultValue)
    {
        value = DefaultValue;
    }
}