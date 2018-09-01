@isTest
private class BillingCalloutServiceTest {
  //Implement mock callout tests here
    @TestSetup
    public static void insertSetting() {
        ServiceCredentials__c cred = new ServiceCredentials__c();
        cred.Name = 'BillingServiceCredential';
        cred.Username__c = 'drs';
        cred.Password__c = 'sdf';
        insert cred;
    }

    @isTest
    static void testSuccessBillableProject() {
        Opportunity opp = new Opportunity();
        opp.Name = 'test Opportunity';
        opp.CloseDate = System.today();
        opp.StageName = 'Closed Won';
        insert opp;

        List<Project__c> allprojects = new List<Project__c>();
        for(Integer i = 0; i < 50; i++) {
            Project__c project = new Project__c();
            project.ProjectRef__c = 'PROJ-' + i;
            project.Name = 'Test Dummy Project Name';
            project.Opportunity__c = opp.Id;
            allprojects.add(project);
        }
        insert allprojects;

        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
        Test.startTest();
            for(Project__c project : allprojects) {
                project.Status__c = 'Billable';
            }
            update allprojects;
        Test.stopTest();
        List<Project__c> billedprojects = [SELECT Id FROM Project__c WHERE Status__c = 'Billed'];
        System.assertEquals(50, billedprojects.size());
    }

    @isTest
    static void testfailureBillableProject() {
        Opportunity opp = new Opportunity();
        opp.Name = 'test Opportunity';
        opp.CloseDate = System.today();
        opp.StageName = 'Closed Won';
        insert opp;

        List<Project__c> allprojects = new List<Project__c>();
        for(Integer i = 0; i < 50; i++) {
            Project__c project = new Project__c();
            project.ProjectRef__c = 'PROJ-'+i;
            project.Name = 'Test Dummy Project Name';
            project.Opportunity__c = opp.Id;
            allprojects.add(project);
        }
        insert allprojects;

        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
        Test.startTest();
            for(Project__c project : allprojects) {
                project.Status__c = 'Billable';
            }
            update allprojects;
        Test.stopTest();
        List<Project__c> billedprojects = [SELECT Id FROM Project__c WHERE Status__c = 'Billed'];
        System.assertEquals(0, billedprojects.size());
    }
}