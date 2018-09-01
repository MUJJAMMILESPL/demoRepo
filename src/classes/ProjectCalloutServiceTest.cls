@isTest
private class ProjectCalloutServiceTest {
  //Implement mock callout tests here
  @isTest
  public static void testSuccessProject() {
      ServiceTokens__c token = new ServiceTokens__c();
      token.Name = 'ProjectServiceToken';
      token.Token__c = 'asguas-sasjkdhask-djksfhjksdf';
      insert token;

      Account account = new Account();
      account.Name = 'ABC Corp.';
      insert account;

      Opportunity opp = new Opportunity();
      opp.Name = 'New Project Opportunity';
      opp.AccountId = account.Id;
      opp.StageName = 'Closed Won';
      opp.Type = 'New Project';
      opp.Amount = 100;
      opp.CloseDate = System.today();

      Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
      Test.startTest();
        insert opp;
      Test.stopTest();
      Opportunity updatedOpp = [Select StageName FROM Opportunity WHERE Id = : opp.Id];
      System.assertEquals('Submitted Project', updatedOpp.StageName);
  }

  @isTest
  public static void testFailureProject() {
      ServiceTokens__c token = new ServiceTokens__c();
      token.Name = 'ProjectServiceToken';
      token.Token__c = 'asguas-sasjkdhask-djksfhjksdf';
      insert token;

      Account account = new Account();
      account.Name = 'ABC Corp.';
      insert account;

      Opportunity opp = new Opportunity();
      opp.Name = 'New Project Opportunity';
      opp.AccountId = account.Id;
      opp.StageName = 'Closed Won';
      opp.Type = 'New Project';
      opp.Amount = 100;
      opp.CloseDate = System.today();

      Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
      Test.startTest();
        insert opp;
      Test.stopTest();
      Opportunity updatedOpp = [Select StageName FROM Opportunity WHERE Id = : opp.Id];
      System.assertEquals('Resubmit Project', updatedOpp.StageName);
  }
}