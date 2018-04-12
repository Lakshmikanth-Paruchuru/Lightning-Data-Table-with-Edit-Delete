({
	doInit : function(component, event, helper) {
		var action = component.get("c.getAccounts");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS")
            {
                component.set("v.accounts",response.getReturnValue());
            }
            
        })
        $A.enqueueAction(action);
	},
    handleClick: function(component,event,helper){
        var get = event.target.id;
        var getevent = component.getEvent("message");
        getevent.setParams({
            'sendId' : get,
            'bool'   : true
        });
        getevent.fire();
       // component.set("v.visible",false);
    },

    Edit: function(component,event,helper){
     var editRec = component.set("v.edit",true);
     component.set("v.viewedit",event.target.id);
    // component.set("v.accounts",event.target.id);
     
    },
    saveRecord: function(component,event,helper){
      
       component.find("edit").get("e.recordSave").fire();
        location.reload();
        component.set("v.edit",false);
    },
    closeModel: function(component,event,helper){
        component.set("v.edit",false);
    },
    Del: function(component,event,helper){
        if(confirm('Are you sure?')){
             var action = component.get("c.delteAccountById");
        action.setParams({accid:event.target.id});
        action.setCallback(this, function(response) {
        	component.set("v.accounts",response.getReturnValue());
        });
        $A.enqueueAction(action);
        }
    }
    
})