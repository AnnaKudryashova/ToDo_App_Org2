public with sharing class SubToDoHelper {
    @future (callout=true)
    public static void subToDoUpdate(Set<Id> setIds) {
        for(Sub_ToDo__c subToDo : [SELECT Id, Name, Description__c, Is_Done__c,
                                  External_Id__c FROM Sub_ToDo__c WHERE Id IN : setIds]) {
            SubToDoWebService.NewSubToDoRequestWrapper newSubToDo = new SubToDoWebService.NewSubToDoRequestWrapper();
            newSubToDo.name = subToDo.Name;
            newSubToDo.isDone = subToDo.Is_Done__c;
            newSubToDo.description = subToDo.Description__c;
            newSubToDo.externalId = subToDo.External_Id__c;
            SubToDoWebService.updateSubToDo(newSubToDo);
        }
    }

    @future (callout=true)
    public static void subToDoInsert(Set<Id> setIds) {
        list<ToDo__c> lstToDo = [SELECT External_Id__c FROM ToDo__c];
        list<Sub_ToDo__c> lstSubToDo = [SELECT Id, Name, Description__c, Is_Done__c,
                                        External_Id__c, ToDo__c FROM Sub_ToDo__c WHERE Id IN : setIds];
        for(Sub_ToDo__c subToDo : lstSubToDo) {
            String uniqueId = GenerationOfUUID.getUUID();
            subToDo.External_Id__c = uniqueId;
            SubToDoWebService.NewSubToDoRequestWrapper newSubToDo = new SubToDoWebService.NewSubToDoRequestWrapper();
            newSubToDo.name = subToDo.Name;
            newSubToDo.isDone = subToDo.Is_Done__c;
            newSubToDo.description = subToDo.Description__c;
            for(ToDo__c toDo : lstToDo) {
                if (toDo.Id == subToDo.ToDo__c) {
                    newSubToDo.masterExternalId = toDo.External_Id__c;
                }
            }
            newSubToDo.externalId = subToDo.External_Id__c;
            SubToDoWebService.addSubToDo(newSubToDo);
        }
        RecursionCheck.setSubToDoUpdated(True);
        update lstSubToDo; 
    }

    @future (callout=true)
    public static void subToDoDelete(Set<String> setExternalId) {
        if (!setExternalId.isEmpty()) {
            for(String externalId : setExternalId) {
                system.debug(externalId);
                SubToDoWebService.deleteSubToDo(externalId);
            }
        }
    }
}