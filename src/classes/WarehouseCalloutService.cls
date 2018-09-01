public with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    // complete this method to make the callout (using @future) to the
    // REST endpoint and update equipment on hand.
    @future(Callout = true)
    public static void runWarehouseEquipmentSync(){
        List<Product2> equipmentsToUpsert = new List<Product2>();

        Http h = new Http();
        HttpRequest req = new Httprequest();
        req.setEndpoint(WAREHOUSE_URL);
        req.setMethod('GET');
        HttpResponse resp = h.send(req);
        if(resp.getStatusCode() == 200) {
            String response = resp.getBody();
            List<WarehouseCalloutService.EquipmentData> eqipments = (List<WarehouseCalloutService.EquipmentData>)JSON.deserialize(
                response,
                List<WarehouseCalloutService.EquipmentData>.class
            );
            for(WarehouseCalloutService.EquipmentData equipmentData : eqipments) {
                Product2 equipment = new Product2();
                equipment.Name = equipmentData.Name;
                equipment.Replacement_Part__c = equipmentData.replacement;
                equipment.Current_Inventory__c = equipmentData.quantity;
                equipment.Maintenance_Cycle__c = equipmentData.maintenanceperiod;
                equipment.Lifespan_Months__c = equipmentData.lifespan;
                equipment.Warehouse_SKU__c = equipmentData.sku;
                equipment.Cost__c = equipmentData.cost;
                equipmentsToUpsert.add(equipment);
            }
            if(equipmentsToUpsert.isEmpty() == false) {
                upsert equipmentsToUpsert Warehouse_SKU__c;
            }
        }
    }


    public class EquipmentData {
        String id;
        Boolean replacement;
        Integer quantity;
        String name;
        Integer maintenanceperiod;
        Integer lifespan;
        Decimal cost;
        String sku;
    }
}