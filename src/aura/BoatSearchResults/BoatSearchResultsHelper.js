({
	onSearch : function(component, boatType) {
		var action = component.get("c.getBoats");
        alert('boatType : '+boatType);
        action.setParams({ boatTypeId : boatType});
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('\n response.getReturnValue() : ', response.getReturnValue());
                component.set("v.boats", response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // Add the server-side action to the queue.
        $A.enqueueAction(action);
	}
})