public with sharing class ToDoHelper {  
    @future (callout=true)
    public static void toDoUpdate(Set<Id> setIds) {
        for(ToDo__c toDo : [SELECT Id, Name, Status__c, Priority__c, Description__c, Category__c,
                           External_Id__c FROM ToDo__c WHERE Id IN : setIds]) {
            ToDoWebService.NewToDoRequestWrapper newToDo = new ToDoWebService.NewToDoRequestWrapper();
            newToDo.name = toDo.Name;
            newToDo.status = toDo.Status__c;
            newToDo.priority = toDo.Priority__c;
            newToDo.description = toDo.Description__c;
            newToDo.category = toDo.Category__c;
            newToDo.externalId = toDo.External_Id__c;
            ToDoWebService.updateToDo(newToDo);
        }
    }

    @future (callout=true)
    public static void toDoInsert(Set<Id> setIds) {
        List<ToDo__c> lstToDo = [SELECT Id, Name, Status__c, Priority__c, Description__c, Category__c,
                                External_Id__c FROM ToDo__c WHERE Id IN : setIds];
        for(ToDo__c toDo : lstToDo) {
            String uniqueId = GenerationOfUUID.getUUID();
            toDo.External_Id__c = uniqueId;
            ToDoWebService.NewToDoRequestWrapper newToDo = new ToDoWebService.NewToDoRequestWrapper();
            newToDo.name = toDo.Name;
            newToDo.status = toDo.Status__c;
            newToDo.priority = toDo.Priority__c;
            newToDo.description = toDo.Description__c;
            newToDo.category = toDo.Category__c;
            newToDo.externalId = uniqueId;
            ToDoWebService.addToDo(newToDo);
        } 
        RecursionCheck.setToDoUpdated(True);
        update lstToDo; 
    }

    @future (callout=true)
    public static void toDoDelete(Set<String> setExternalId) {
        if (!setExternalId.isEmpty()) {
            for(String externalId : setExternalId) {
                system.debug(externalId);
                ToDoWebService.deleteToDo(externalId);
            }
        }
    }
}