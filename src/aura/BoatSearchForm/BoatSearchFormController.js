({
	init : function(component, event, helper) {
		helper.getAllBoatTypes(component);
        var createRecordEvent = $A.get("e.force:createRecord");
        console.log('createRecordEvent : '+createRecordEvent);
        if(createRecordEvent) {
            component.set("v.canCreateRecord", true);
        }
	},
    createNewBoatRecord : function(component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        var selectedBoatType = component.find("selectBoatType").get("v.value");
        createRecordEvent.setParams({
            "entityApiName": "Boat__c",
            "defaultFieldValues": {
                'BoatType__c' : selectedBoatType
            }
        });
        createRecordEvent.fire();
    }
})