@isTest
private class ProjectRESTServiceTest {
  //Implement Apex REST service tests here
    @isTest
    static void testProjectInsert() {
        Opportunity opp = new Opportunity();
        opp.Name = 'test Opportunity';
        opp.CloseDate = System.today();
        opp.StageName = 'Closed Won';
        insert opp;

        Test.starttest();
            String response = ProjectRESTService.postProjectData(
              'PROJ-1',
              'Test Project Name',
              opp.Id,
              System.today(),
              System.today().addDays(30),
              100,
              'Billable');
        Test.stopTest();
        System.assertEquals('OK', response);
        Opportunity updatedOpp = [SELECT DeliveryInstallationStatus__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('In progress', updatedOpp.DeliveryInstallationStatus__c);
        List<Project__c> projects = [SELECT Id FROM Project__c WHERE Opportunity__c = : opp.Id];
        SYstem.assertEquals(1, projects.size());
    }

    @isTest
    static void testProjectUpdate() {
        Opportunity opp = new Opportunity();
        opp.Name = 'test Opportunity';
        opp.CloseDate = System.today();
        opp.StageName = 'Closed Won';
        insert opp;

        Project__c project = new Project__c();
        project.ProjectRef__c = 'PROJ-1';
        project.Name = 'Test Dummy Project Name';
        project.Opportunity__c = opp.Id;
        insert project;

        Test.starttest();
            String response = ProjectRESTService.postProjectData(
              'PROJ-1',
              'Test Project Name',
              opp.Id,
              System.today(),
              System.today().addDays(30),
              100,
              'Billable');
        Test.stopTest();
        System.assertEquals('OK', response);
        Opportunity updatedOpp = [SELECT DeliveryInstallationStatus__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('In progress', updatedOpp.DeliveryInstallationStatus__c);
        List<Project__c> projects = [SELECT Id, Start_Date__c FROM Project__c WHERE Opportunity__c = : opp.Id];
        System.assertEquals(1, projects.size());
        System.assertEquals(System.today(), projects[0].Start_Date__c);
    }

    @isTest
    static void testProjectException() {
        Test.starttest();
            String response = ProjectRESTService.postProjectData(
              'PROJ-1',
              'Test Project Name',
              null,
              System.today(),
              System.today().addDays(30),
              100,
              'Billable');
        Test.stopTest();
        System.assertNotEquals('OK', response);
    }
}