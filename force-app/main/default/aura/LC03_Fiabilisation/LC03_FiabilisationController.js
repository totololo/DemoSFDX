({
    doInit : function(component, event, helper) {
        var url = '/apex/VFP05_Fiabilisation?id='+component.get('v.recordId');
        component.set('v.url', url);
        window.addEventListener("message", function(event) {
            if(event.data.includes('closePopup') )
            {
                $A.get("e.force:closeQuickAction").fire();
            }
        }, false);
    }
})