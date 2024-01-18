trigger DuplicateTrigger on Resource__c (before insert) {
    if(trigger.isBefore){
        set<String> Emailset = new set<String>();
        set<String> mobileset = new set<String>();
       // set<String> linkedinset = new set <String>();
        list<Resource__c> olddataofResource = [Select id,Email__c,Mobile__c from Resource__c where CreatedDate >=Last_n_Days:90];
        for(Resource__c olddata:olddataofResource){
            Emailset.add(olddata.Email__c);
            mobileset.add(olddata.Mobile__c);
            //linkedinset.add(olddata.LinkedIn_URL__c);
        }
        for(Resource__c rescheck: trigger.new){
            if(Emailset.contains(rescheck.Email__c) || mobileset.contains(rescheck.Mobile__c)/*|| linkedinset.contains(rescheck.LinkedIn_URL__c)*/){
              rescheck.addError('Record Cannot be Created');  
            }
        }
    }
}