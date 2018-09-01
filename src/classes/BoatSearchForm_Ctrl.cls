public class BoatSearchForm_Ctrl {
	@auraEnabled
    public Static List<BoatType__c> getAllBoatTypes() {
        return [SELECT Id, Name FROM BoatType__c];
    }
}