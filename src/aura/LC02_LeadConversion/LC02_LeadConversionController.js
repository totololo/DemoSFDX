({
    doInit: function(component) {
        //calling aura method and getting the casE
        var action = component.get("c.convertLeadAndRedirectToAccountLightning");
        action.setParams({
            "prospectId" : component.get("v.recordId"),
        });
        action.setCallback(this,function(a){
            var cmpTarget = component.find('SpinnerLoading');
            $A.util.addClass(cmpTarget, 'slds-hide');
            if(a.getReturnValue().includes('001'))
            {
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": a.getReturnValue(),
                    "slideDevName": "related"
                });
                navEvt.fire();
            }
            else
            {
                component.set("v.errorMessage", a.getReturnValue());
            }            
        });
        $A.enqueueAction(action);
    }
})