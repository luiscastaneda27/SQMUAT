trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert) {
    // Create a set to store the IDs of Notification_Process__c records that need to be updated
    Set<Id> notificationIdsToUpdate = new Set<Id>();
    
    // Iterate through the ContentDocumentLinks that were inserted
    for (ContentDocumentLink cdl : Trigger.new) {
        // Check if the linked record is a Notification_Process__c and the file is related to it
        if (cdl.LinkedEntityId.getSObjectType() == Notification_Process__c.sObjectType) {
            notificationIdsToUpdate.add(cdl.LinkedEntityId);
            System.debug('Notification_Process__c record with ID ' + cdl.LinkedEntityId + ' is eligible for update.');
        }
    }

    // Query the Notification_Process__c records and update the Has_Attachment__c field
    List<Notification_Process__c> notificationToUpdate = [SELECT Id FROM Notification_Process__c WHERE Id IN :notificationIdsToUpdate];

    for (Notification_Process__c proc: notificationToUpdate ) {
        proc.Has_Attachment__c = true;
    }

    System.debug('Number of Notification_Process__c records to be updated: ' + notificationToUpdate.size());

    // Perform the update
    update notificationToUpdate ;
    System.debug('Update operation completed.');
}