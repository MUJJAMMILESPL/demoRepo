@RestResource(urlMapping = '/project')
global class ProjectRESTService {
    //Implement service logic here

    @HttpPost
    global static String postProjectData(
        String ProjectRef,
        String ProjectName,
        String OpportunityId,
        Date StartDate,
        Date EndDate,
        Double Amount,
        String Status
    ) {
        String responseText;
        Project__c project = new Project__c();
        project.ProjectRef__c = ProjectRef;
        project.Name = ProjectName;
        project.Opportunity__c = OpportunityId;
        project.Start_Date__c = StartDate;
        project.End_Date__c = EndDate;
        project.Billable_Amount__c = Amount;
        project.Status__c = Status;

        Opportunity parentOpp = new Opportunity();
        parentOpp.Id = OpportunityId;
        parentOpp.DeliveryInstallationStatus__c = 'In Progress';
        Savepoint sp = Database.setSavepoint();
        try {
            Upsert project ProjectRef__c;
            update parentOpp;
            responseText = 'OK';
        } catch(DMLException ex) {
            responseText = ex.getMessage();
            Database.rollback(sp);
        }
        return responseText;
    }
}