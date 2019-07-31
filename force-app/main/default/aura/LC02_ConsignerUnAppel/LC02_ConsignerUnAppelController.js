({
    doInit: function(component) {
        //calling aura method and getting the casE
        var action = component.get("c.getCaseStatus");
        action.setParams({
            "caseId" : component.get("v.RecordId"),
        });
        action.setCallback(this,function(a){
            //check if result is successfull
            var state = a.getState();   
            component.set('v.currentCaseStatus',a.getReturnValue());
            var statusRetrieved = component.get("v.currentCaseStatus");
            if(!statusRetrieved.includes($A.get("$Label.c.DA_Termin_e_Traduite"))){}
            else
            {
                alert($A.get("$Label.c.DA_ErreurChoixStatut"));
                sforce.one.navigateToURL("/"+component.get("v.RecordId"), true);
            }
        });     
        $A.enqueueAction(action);
        
        
    },
    consignerUnappel : function(component, event, helper)  {
        var ouiRelaisRepond = document.getElementById("radio-6");
        var nonRelaisRepond = document.getElementById("radio-7");
        var appelInterrompu = document.getElementById("radio-8");
        
        if(ouiRelaisRepond.checked == true)
        {
            component.set("v.SelectedRadioBoxValue",ouiRelaisRepond.value);
            helper.consignerUnappelHelper(component, event, helper);
        }
        else if(nonRelaisRepond.checked == true)
        {
            component.set("v.SelectedRadioBoxValue",nonRelaisRepond.value);
            helper.consignerUnappelHelper(component, event, helper);
        }
            else if(appelInterrompu.checked == true)
            {
                component.set("v.SelectedRadioBoxValue",appelInterrompu.value);
                helper.consignerUnappelHelper(component, event, helper);
            }
        
    },
    
    closeDA : function(component, event)  { 
        //window.location.href = "https://pickup--dev.lightning.force.com/one/one.app#/sObject/"+component.get("v.RecordId");
        sforce.one.navigateToURL("/"+component.get("v.RecordId"), true);
    }
    
})