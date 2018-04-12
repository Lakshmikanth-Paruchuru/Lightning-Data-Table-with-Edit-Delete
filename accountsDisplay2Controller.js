({
	handleComponentEvent : function(component, event, helper) {
        var receiveinfo = event.getParam("sendId");
                var receivebool = event.getParam("bool");
        		//component.set("v.edit2",true);
        component.set("v.edit3",receivebool);
        component.set("v.getrecord",receiveinfo);
	},
    goback : function(component, event, helper){
        component.set("v.edit3",false);
        component.set("v.edit2",true);

    }
})