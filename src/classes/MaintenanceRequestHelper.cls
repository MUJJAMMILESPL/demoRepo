public class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Case> newCases){
        List<Case> closedRequests = new List<Case>();
        List<Case> newRoutineRequest = new List<Case>();
        for(Case currentcase : newCases) {
            if(currentCase.Status == 'Closed' && (currentCase.Type == 'Repair' || currentCase.Type == 'Routine Maintenance')) {
                closedRequests.add(currentCase);
            }
        }
        for(Case currentCase : [Select
                                	Id,
                                	Equipment__c,
                                	Vehicle__c,
                                	Subject,
                                	(Select
                                     	Id,
                                     	Equipment__r.Maintenance_Cycle__c
                                     	FROM Work_Parts__r 
                                     	ORDER BY Equipment__r.Maintenance_Cycle__c DESC
                                     	Limit 1)
                                FROM Case
                                WHERE Id IN :closedRequests]
        ) {
            Integer dueDaysFromToday = currentCase.Work_Parts__r.isEmpty() == false && currentCase.Work_Parts__r[0].Equipment__r.Maintenance_Cycle__c <> null ?
                Integer.valueOf(currentCase.Work_Parts__r[0].Equipment__r.Maintenance_Cycle__c) :
            	0;
            Case routineRequest = new Case();
            routineRequest.Equipment__c = currentCase.Equipment__c;
            routineRequest.Vehicle__c = currentCase.Vehicle__c;
            routineRequest.Date_Reported__c = System.today();
            routineRequest.Date_Due__c = System.today().addDays(dueDaysFromToday);
            routineRequest.Type = 'Routine Maintenance';
            routineRequest.Status = 'New';
            routineRequest.Subject = currentCase.Subject;
            newRoutineRequest.add(routineRequest);     
        }
        if(newRoutineRequest.isEmpty() == false) {
            insert newRoutineRequest;
        }
    }        
    
}