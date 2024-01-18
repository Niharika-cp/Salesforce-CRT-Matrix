trigger updatedescription on Change_Request__c (after insert) {
    if (updatedescriptionHandler.shouldRun()) {
        for (Change_Request__c record : Trigger.new) {
            snow_updatedescription.updatedescription(record.Id);
        }
    }
}