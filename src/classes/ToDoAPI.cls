@RestResource(urlMapping='/ToDo/*')
global with sharing class ToDoAPI {
	@HttpDelete
    global static void doDelete() {
        RecursionCheck.setToDoDeleted(true);
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String externalId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        List<ToDo__c> toDo = [SELECT Id FROM ToDo__c WHERE External_Id__c = :externalId];
        if (!toDo.isEmpty()) {
            delete toDo;
        }
    }
 
    @HttpPost
    global static String doPost(String name, String status, String priority, String description, String category, String externalId) {
        RecursionCheck.setToDoInserted(true);
        ToDo__c toDo = new ToDo__c();
        toDo.Name = name;
        toDo.Status__c = status;
        toDo.Priority__c = priority;
        toDo.Description__c = description;
        toDo.Category__c = category;
        toDo.External_Id__c = externalId;
        insert toDo;
        return toDo.Id;
    }

    @HttpPut
    global static String doUpdate(String name, String status, String priority, String description, String category, String externalId) {
        RecursionCheck.setToDoUpdated(true);
        ToDo__c toDo = [SELECT Name, Status__c, Priority__c, Description__c, Category__c
                       FROM ToDo__c WHERE External_Id__c = : externalId];
        if(toDo != null) {
            toDo.Name = name;
            toDo.Status__c = status;
            toDo.Priority__c = priority;
            toDo.Description__c = description;
            toDo.Category__c = category;
            update toDo;
        }
        return toDo.Id;
    }
}