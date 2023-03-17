/**
* Author: Madhura Priyadarshana
* Description : Generating JWT for a given client and information
* AuraEnabled : False
* Created Date : 21 August 2019
*/
public without sharing class ADBJWTGenerator {

    public String alg {get;set;}
    public String iss {get;set;}
    public String sub {get;set;}
    public String aud {get;set;}
    public String exp {get;set;}
    public String iat {get;set;}
    public Map<String,String> claims {get;set;}
    public Integer validFor {get;set;}
    public String cert {get;set;}
    public String pkcs8 {get;set;}
    public String privateKey {get;set;}
    
    //  algorithms to be used for the encryption
    public static final String HS256 = 'HS256';
    public static final String RS256 = 'RS256';
    public static final String NONE = 'none';

    
    public ADBJWTGenerator(String alg) {
        this.alg = alg;
        this.validFor = 3500;   //  access token will be valid for next 1 hour
    }
    
    //  Returns a JWT(JSON Web Token)
    public String issue() {
    
        String jwt = '';
    
        JSONGenerator header = JSON.createGenerator(false);
        header.writeStartObject();
        header.writeStringField('alg', this.alg);
        header.writeStringField('type', 'JWT');
        header.writeEndObject();
        String encodedHeader = base64URLencode(Blob.valueOf(header.getAsString()));
            
        JSONGenerator body = JSON.createGenerator(false);
        body.writeStartObject();
        body.writeStringField('iss', this.iss);
        //  commented out for now till engage with other stargate services to see if below attributes are needed
        //body.writeStringField('sub', this.sub);
        //body.writeStringField('aud', this.aud);
        //body.writeNumberField('iat', rightNow);
        Long rightNow = (dateTime.now().getTime()/1000)+1;        
        body.writeNumberField('exp', (rightNow + validFor));
        if (claims != null) {
            for (String claim : claims.keySet()) {
                body.writeStringField(claim, claims.get(claim));
            }
        }
        body.writeEndObject();
        
        jwt = encodedHeader + '.' + base64URLencode(Blob.valueOf(body.getAsString()));
        
        if ( this.alg == HS256 ) {
            Blob key = EncodingUtil.base64Decode(privateKey);
            Blob signature = Crypto.generateMac('hmacSHA256',Blob.valueof(jwt),key);
            jwt += '.' + base64URLencode(signature);  
        } else if ( this.alg == RS256 ) {
            Blob signature = null;
            
            if (cert != null ) {
                signature = Crypto.signWithCertificate('rsa-sha256', Blob.valueOf(jwt), cert);
            } else {
                Blob privateKey = EncodingUtil.base64Decode(pkcs8);
                signature = Crypto.sign('rsa-sha256', Blob.valueOf(jwt), privateKey);
            }
            jwt += '.' + base64URLencode(signature);  
        } else if ( this.alg == NONE ) {
            jwt += '.';
        }
        
        return jwt;    
    }
    

    //  encode a given blob for base 64 and rearrange it so that it
    //  produces a proper encoding string
    public String base64URLencode(Blob input){ 
        String output = encodingUtil.base64Encode(input);
        output = output.replace('+', '-');
        output = output.replace('/', '_');
        
        //  removing unwanted = signs at the end
        while ( output.endsWith('=')){
            output = output.subString(0,output.length()-1);
        }
        return output;
    }
}