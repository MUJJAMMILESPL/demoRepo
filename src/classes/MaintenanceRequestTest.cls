@istest
public class MaintenanceRequestTest {
    @istest
    public static void newMaintenanceRequestTest() {
        Vehicle__c vehicle = new Vehicle__c();
        vehicle.Name = 'BMW';
        insert vehicle;
        
        Product2 equipment = new Product2();
        equipment.Name = 'Prod 1';
        equipment.Replacement_Part__c = true;
        equipment.Current_Inventory__c = 10;
        equipment.Maintenance_Cycle__c = 2;
        equipment.Lifespan_Months__c = 12;
        equipment.Warehouse_SKU__c = '100';
        equipment.Cost__c = 500;
        insert equipment;
        List<Case> requests = new List<Case>();
        for(Integer i = 0; i < 300; i++) {
            Case c = new Case();
            c.Subject = 'Repair test ' + i;
            c.Date_Reported__c = System.today();
            c.Status = 'New';
            c.Type = 'other';
            c.Vehicle__c = vehicle.Id;
            c.Equipment__c = equipment.Id;
            requests.add(c);
        }
        
        insert requests;
        Test.startTest();
            for(Case c : requests) {
                c.Type = 'Repair';
                c.Status = 'Closed';
            }
        	update requests;
        Test.stopTest();
        List<Case> allRequests = [Select Id FROM Case WHERE Vehicle__c = :vehicle.Id];
        System.assertEquals(600, allRequests.size(), 'new maintainance request not created');
    }
    
    @istest
    public static void newMaintenanceRequestWorkOrderTest() {
        Vehicle__c vehicle = new Vehicle__c();
        vehicle.Name = 'BMW';
        insert vehicle;
        
        Product2 equipment = new Product2();
        equipment.Name = 'Prod 1';
        equipment.Replacement_Part__c = true;
        equipment.Current_Inventory__c = 10;
        equipment.Maintenance_Cycle__c = 2;
        equipment.Lifespan_Months__c = 12;
        equipment.Warehouse_SKU__c = '100';
        equipment.Cost__c = 500;
        insert equipment;
        Case c = new Case();
        c.Subject = 'Repair test';
        c.Date_Reported__c = System.today();
        c.Status = 'New';
        c.Type = 'other';
        c.Vehicle__c = vehicle.Id;
        c.Equipment__c = equipment.Id;        
        insert c;
        Work_Part__c wp = new Work_Part__c();
        wp.Equipment__c = equipment.id;
        wp.Maintenance_Request__c = c.Id;
        insert wp;
        Test.startTest();
            c.Type = 'Repair';
            c.Status = 'Closed';
        	update c;
        Test.stopTest();
        List<Case> allRequests = [Select Id FROM Case WHERE Vehicle__c = :vehicle.Id];
        System.assertEquals(2, allRequests.size(), 'new maintainance request not created');
        List<Case> nextMaintainanceRequests = [Select Id FROM Case WHERE Vehicle__c = :vehicle.Id AND Date_Due__c > :System.Today()];
        System.assert(nextMaintainanceRequests.isEmpty() == false);
    }
}