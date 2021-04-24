public with sharing class SubToDoTriggerHandler {
    public static void handleAfterUpdate (Set<Id> setIds) {
        if(!RecursionCheck.isSubToDoUpdated()) {
            SubToDoHelper.subToDoUpdate(setIds);
        }
    }
    public static void handleAfterInsert (Set<Id> setIds) {
        if(!RecursionCheck.isSubToDoInserted()) {
            SubToDoHelper.subToDoInsert(setIds);
        }
    }
    public static void handleAfterDelete (List<Sub_ToDo__c> lstSubToDo) {
        if(!RecursionCheck.isSubToDoDeleted()) {
            Set<String> setExternalId = new Set<String>();
            for (Sub_ToDo__c subToDo : lstSubToDo) {
                setExternalId.add(subToDo.External_Id__c);
            }
            SubToDoHelper.subToDoDelete(setExternalId);
        }
    }
}