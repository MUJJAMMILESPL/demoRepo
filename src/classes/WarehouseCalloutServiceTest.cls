@isTest
private class WarehouseCalloutServiceTest {
  // implement your mock callout test here
    @isTest
    public static void testEquipmentInsert() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
        	WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();
        List<Product2> allProducts = [Select Id from Product2 WHERE Warehouse_SKU__c = '100003'];
        System.assertEquals(1, allProducts.size());
    }
    
    @isTest
    public static void testEquipmentUpdate() {
        Product2 equipment = new Product2();
        equipment.Name = 'Test product';
        equipment.Warehouse_SKU__c = '100003';
        insert equipment;

        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
        	WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();
        List<Product2> allProducts = [Select Id, Name from Product2 WHERE Warehouse_SKU__c = '100003'];
        System.assertEquals(1, allProducts.size());
        System.assertEquals('Generator 1000 kW', allProducts[0].Name);
    }
}