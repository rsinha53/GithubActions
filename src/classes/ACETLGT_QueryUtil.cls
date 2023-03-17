/**
 * query helper class to provide select * query
 *
*/
public class ACETLGT_QueryUtil {
	/**
	 * query sobject based on object name and id
	*/
	public static sObject query(Id sObjectId, String sObjectName){		
		List<sObject> objs=query(new List<String>{sObjectId},sObjectName,null,null);
		return objs.size()>0?objs[0]:null;		
	}
	
	/**
	 * query sobjects based on object name and object ids or filters
	*/
	public static List<sObject> query(List<Id> sObjectIds, String sObjectName, String filters, String orderBy){
		String sql = buildQueryString(sObjectIds,sObjectName,filters,orderBy);		
		return Database.query(sql);			
	}
		
	private static String buildQueryString(List<Id> sObjectIds, String sObjectName, String filters, String orderBy){
		Map<String,schema.sObjectField> fieldTypeMap=Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();
		
		String sql='select id';
		for(String fn:fieldTypeMap.keyset()){				
			if(fn.toLowerCase()!='id'){		
				Schema.DescribeFieldResult dfr = fieldTypeMap.get(fn).getDescribe();	
				//skip compound fileds	
				if(dfr.getType() != Schema.Displaytype.Location && dfr.getType()!= Schema.Displaytype.Address){	
					//query Id and name for referenced parent object									
					if(dfr.getType() == Schema.Displaytype.Reference && dfr.getRelationshipName() != null){
						sql = sql + ',' + dfr.getRelationshipName() + '.Name';						
					}else{
						sql=sql + ',' + fn;	
					}																													
				}											
			}					
		}		
		
		sql=sql + ' from ' + sObjectName;
		sql=sql.remove('ConnectionReceived.Name,ConnectionSent.Name,');
		String ids = '';
		if(sObjectIds !=null && sObjectIds.size() > 0){			
	        for(String id : sobjectIds){
	            if(ids == ''){
	                ids = '(' + '\'' + id + '\'';
	            }else{
	                ids = ids + ',' + '\'' + id + '\'';
	            }
	        }
	        if(ids != '') ids = ids + ')';		       	
		}
		
		if(ids != ''){
			sql = sql + ' where Id IN' + ids;
			if(filters != null){
				sql = sql + ' and (' + filters + ')';	
			}
		}else{
			if(filters != null){
				sql = sql + ' where (' + filters + ')';
			}
		}
		
		if(orderBy != null){
			sql = sql + ' order by ' + orderBy;
		}
		
		return sql;
	} 
	
	/**
	 * return quoted id string used in query
	*/
	public static String getQuotedIds(List<String> idList){
		String ids = '(';
		if(idList !=null && idList.size() > 0){			
	        for(String id : idList){
	            if(ids == '('){
	                ids = ids + '\'' + id + '\'';
	            }else{
	                ids = ids + ',' + '\'' + id + '\'';
	            }
	        }	        		       
		}
		ids = ids + ')';	
		return ids;	
	}    
	
	
	public static String consructCustomFieldQuery(String ObjectName,List<String> exculdeList,List<String> assignmentFiledList){
		String assignmentFiled = 'SELECT ';
         Integer i = 0;
         if(assignmentFiledList == null){
        		assignmentFiledList = new List<String> ();
         }
        for(Schema.SObjectField fldSchema : Schema.getGlobalDescribe().get(ObjectName).getDescribe().fields.getMap().values()){
             Schema.DescribeFieldResult fld = fldSchema.getDescribe();  
             String fieldName = fld.getName();
             if(fld.isCustom() ){
                
                if(!isListContains(exculdeList ,fieldName)){ 
                    assignmentFiledList.add(fieldName);
                }
                 if(i ++ > 0){
                     assignmentFiled += ',';    
                  }
                 assignmentFiled += fieldName;
                 
           }
         }
          assignmentFiled += ' FROM ' + ObjectName ;
          
          return assignmentFiled;
	}
	

/*
		To check current field is avliable in execlude list.
	 */
    private static boolean isListContains(List<String> listOfString,String findString){
        for(String st:listOfString) {
            if(st.equals(findString)){
                return true;
            }
        }
        return false;
    }

 /*
  Fetch all the field for select criteria and owner name 
 */
    public static String getCustomFieldQuery(String ObjectName){
		String assignmentFiled = 'SELECT ';
         Integer i = 0;
         
        for(Schema.SObjectField fldSchema : Schema.getGlobalDescribe().get(ObjectName).getDescribe().fields.getMap().values()){
             Schema.DescribeFieldResult fld = fldSchema.getDescribe();  
             String fieldName = fld.getName();
              if(i ++ > 0){
                     assignmentFiled += ',';    
                  }
                 assignmentFiled += fieldName;
          }
         assignmentFiled  +=', owner.name';
          assignmentFiled += ' FROM ' + ObjectName ;
          
          return assignmentFiled;
	}

	/*
	 Construct query paramter
	 */
	public static String getQueryValue(List<Id> ids) {
	 	String value='';
	 	for(Id keyFieldId:ids){
	 		value += getQueryValue(keyFieldId) + ',';
	 	}
	 	return value.removeEnd(',');
	 }

	 /*
	   String values is constructed for Query parameter
	  */
	  public static String getQueryValue(String value){
	 	return value == null ? null :'\'' + String.escapeSingleQuotes((String) value) + '\'';
	 }
}