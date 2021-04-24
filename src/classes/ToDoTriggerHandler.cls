public with sharing class ToDoTriggerHandler {
    public static void handleAfterUpdate (Set<Id> setIds) { 
        if(!RecursionCheck.isToDoUpdated()) {
            ToDoHelper.toDoUpdate(setIds);
        }
    }
    public static void handleAfterInsert (Set<Id> setIds) {
        if(!RecursionCheck.isToDoInserted()) {
            ToDoHelper.toDoInsert(setIds);
        }
    }
    public static void handleAfterDelete (List<ToDo__c> lstToDo) {
        if(!RecursionCheck.isToDoDeleted()) {
            Set<String> setExternalId = new Set<String>();
            for (ToDo__c toDo : lstToDo) {
                setExternalId.add(toDo.External_Id__c);
            }
            ToDoHelper.toDoDelete(setExternalId);
        }
    }
}