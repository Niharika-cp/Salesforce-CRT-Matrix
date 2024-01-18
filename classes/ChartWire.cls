public with sharing class ChartWire{
    @AuraEnabled(cacheable=true)
    public static Map<String,ChartObject__c> getName(){
        try {
            Map<String,ChartObject__c> nameMap = New Map<String,ChartObject__c>();
            List<ChartObject__c> cobj = [SELECT Name,X__c,Y__c,Impact__c,Priority__c, More_Information__c from ChartObject__c ORDER BY Name ASC];
            if(cobj.size() == 0){
                throw new MyException('Error');
            }
            else{
                for(Integer i=0;i<cobj.size();i++){
                    String nm = 'x'+i;
                    nameMap.put(nm,cobj[i]);
                }
                System.debug(nameMap);
                System.debug(nameMap.size());
                return nameMap;
            }   
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /*@AuraEnabled(cacheable=true)
public static Map<String,Decimal> getCount(){
try {
Map<String,Decimal> countMap = New Map<String,Decimal>();
List<ChartObject__c> cobj = [SELECT Name, X__c,Y__c from ChartObject__c ORDER BY Name ASC];
system.debug(cobj);
for(Integer i=0;i<cobj.size();i++){
String nx = 'x'+ i;
String ny = 'y'+ i;
countMap.put(nx,cobj[i].X__c);
countMap.put(ny,cobj[i].Y__c);
}
System.debug(countMap);
System.debug(countMap.size());
return countMap;
} catch (Exception e) {
throw new AuraHandledException(e.getMessage());
}
}*/
    
    @AuraEnabled(cacheable=true)
    public static List<ChartObject__c> getEmpty(){
        try {
            List<String> emptyMap = New List<String>();
            List<ChartObject__c> det = [SELECT Name, X__c, Y__c, Impact__c,Priority__c, More_Information__c from ChartObject__c Where X__c = 0 AND Y__c =0 ORDER BY Name ASC];
            if(det.size() == 0){
                throw new MyException('Error');
            }
            else{
                for(ChartObject__c de : det){
                    String s = de.Name;
                    emptyMap.add(s);
                }
                system.debug(emptyMap);
                return det;
            }
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    public class MyException extends Exception {}
}