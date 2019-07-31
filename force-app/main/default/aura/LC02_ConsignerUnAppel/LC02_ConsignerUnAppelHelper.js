({
	consignerUnappelHelper : function(component, event, helper){ //Créer et enregistrer les lignes
        var action = component.get("c.consignerUnappelController");
        action.setParams({
            "SelectedRadioBoxValue" : component.get("v.SelectedRadioBoxValue"),
            "CaseIDRetrieved" : component.get("v.RecordId"), 
        });
        action.setCallback(this,function(a){
            //check if result is successfull
            var state = a.getState();  
            window.setTimeout(sforce.one.navigateToURL("/"+component.get("v.RecordId"), true),3000);
            
 
        });     
        $A.enqueueAction(action);
    }
})