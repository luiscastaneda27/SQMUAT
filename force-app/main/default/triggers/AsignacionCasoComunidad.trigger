trigger AsignacionCasoComunidad on Case (after insert) {

    Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Comunidad').getRecordTypeId();

    Set<Id> caseIdSet = new Set<Id>();
    for(Case c : trigger.new) {

        if (c.RecordTypeId == devRecordTypeId){
            caseIdSet.add(c.Id);
        }
    }

    List<Case> caseList = new List<Case>();

    Database.DMLOptions dmo = new Database.DMLOptions();
    dmo.AssignmentRuleHeader.useDefaultRule = true;

    for(Case c : [SELECT Id FROM Case WHERE Id IN: caseIdSet]) {
        c.setOptions(dmo);
        caseList.add(c);
    }

    update caseList;
}