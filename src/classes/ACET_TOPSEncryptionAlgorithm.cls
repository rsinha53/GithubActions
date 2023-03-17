public without sharing class ACET_TOPSEncryptionAlgorithm {

    public static String getEncryptedString(String stringToEncrypt) {
        //System.debug('@@ ACET_TOPSEncryptionAlgorithm: getEncryptedString: stringToEncrypt: ' + stringToEncrypt);
        if (stringToEncrypt.length() != 8) {
            return null;
        }
        String encryptedString = '';
        List <String> charactersToEncrypt = stringToEncrypt.toUpperCase().split('');
        List <Tops_Encryption_Mappings__c> topsEncryptionMappings = [SELECT Id, EBCDIC__c, Char_1__c, Char_2__c, Char_3__c, Char_4__c, Char_5__c, Char_6__c, Char_7__c, Char_8__c
            FROM Tops_Encryption_Mappings__c WHERE EBCDIC__c IN: charactersToEncrypt
        ];
        Map <String, Map <String, Object>> ebcdicToCharMap = new Map <String, Map <String, Object>> ();
        for (Tops_Encryption_Mappings__c topsEncryptionMapping: topsEncryptionMappings) {
            ebcdicToCharMap.put(topsEncryptionMapping.EBCDIC__c, topsEncryptionMapping.getPopulatedFieldsAsMap());
        }
        for (Integer i = 0; i < charactersToEncrypt.size(); i++) {
            String charToEncrypt = charactersToEncrypt[i];
            Map <String, Object> fieldsToValue = ebcdicToCharMap.get(charToEncrypt);
            Integer fieldNumber = i + 1;
            encryptedString = encryptedString + fieldsToValue.get('Char_' + fieldNumber + '__c');
        }
        //System.debug('@@ ACET_TOPSEncryptionAlgorithm: getEncryptedString: encryptedString: ' + encryptedString);
        return encryptedString;
    }

    // US3269760 - Thanish - 16th Feb 2021
    public static String getDecryptedString(String stringToDecrypt) {
        Integer startIdx=0; Integer endIdx=2; List<String> charCodes=new List<String>();
        List <Tops_Encryption_Mappings__c> topsEncryptionMappings;
        String retString='';

        while(startIdx<14){
            charCodes.add(stringToDecrypt.substring(startIdx, endIdx));
            startIdx=startIdx+2; endIdx=endIdx+2;
        }
        charCodes.add(stringToDecrypt.substring(startIdx));
        topsEncryptionMappings=[SELECT EBCDIC__c, Char_1__c, Char_2__c, Char_3__c, Char_4__c, Char_5__c, Char_6__c, Char_7__c, Char_8__c FROM Tops_Encryption_Mappings__c
                                WHERE Char_1__c=:charCodes[0] OR Char_2__c=:charCodes[1] OR Char_3__c=:charCodes[2] OR Char_4__c=:charCodes[3] OR Char_5__c=:charCodes[4] OR Char_6__c=:charCodes[5] OR Char_7__c=:charCodes[6] OR Char_8__c=:charCodes[7]];

        for(Integer i=0;i<charCodes.size();i++){
            for(Tops_Encryption_Mappings__c mapping : topsEncryptionMappings){
                String charValue = (String) mapping.get('Char_'+(i+1)+'__c');
                if(charValue==charCodes[i]){
                    retString+=mapping.EBCDIC__c;
                    break;
                }
            }
        }
        return retString;
    }
}