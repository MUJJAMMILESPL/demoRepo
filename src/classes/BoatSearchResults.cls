public class BoatSearchResults {
	/**
	 * Methode to return All boats across the provided boatType record.
	 * If 'boatTypeId' is empty then It returns all boats from the system
	 */
    @auraEnabled
    public static List<Boat__c> getBoats(String boatTypeId) {
        String query = 'SELECT Id, Name, Picture__c, Length__c, Contact__r.Name FROM Boat__c ';
        if(String.isNotBlank(boatTypeId)) {
            query += 'WHERE BoatType__c = \'' + String.escapeSingleQuotes(boatTypeId) + '\'';
        }
        return (List<Boat__c>) Database.query(query);
    }
}