public class BillingCalloutService {
    //Implement business and callout logic methods here
    public static void callBillingService(List<Project__c> updatedProjects) {
        List<Id> billableProjectIds = new List<Id>();
        for(Project__c project : updatedProjects) {
            if(project.Status__c == 'Billable') {
                billableProjectIds.add(project.Id);
            }
        }
        if(billableProjectIds.isEmpty() == false) {
            postToBillingService(billableProjectIds);
        }
    }

    @future(callout = True)
    public static void postToBillingService(List<Id> billableProjectIds) {
        List<Project__c> billedProjects = new List<Project__c>();

        ServiceCredentials__c BillingServiceCredential = ServiceCredentials__c.getAll().get(
            'BillingServiceCredential'
        );
        for(Project__c billableProject :
            [
                SELECT
                    Id,
                    ProjectRef__c,
                    Billable_Amount__c
                FROM Project__c
                WHERE Id IN :billableProjectIds
            ]
        ) {
            BillingServiceProxy.project project = new BillingServiceProxy.project();
            project.username = BillingServiceCredential.Username__c;
            project.password = BillingServiceCredential.Password__c;
            project.projectRef = billableProject.ProjectRef__c;
            project.billAmount = billableProject.Billable_Amount__c;

            // Call SOAP Web service to post to Billing Service
            BillingServiceProxy.InvoicesPortSoap11 connection = new BillingServiceProxy.InvoicesPortSoap11();
            String response = connection.billProject(project);
            if(response == 'ok') {
                billableProject.Status__c = 'Billed';
                billedProjects.add(billableProject);
            }
        }
        if(billedProjects.isEmpty() == false) {
            update billedProjects;
        }
    }
}