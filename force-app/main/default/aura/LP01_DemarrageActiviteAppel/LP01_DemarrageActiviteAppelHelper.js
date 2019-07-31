({
    Save : function(component, event, helper){ //Créer et enregistrer les lignes
        var action = component.get("c.insertCompteRendu");

        action.setParams({
            "SelectedRadioBoxValue" : component.get("v.SelectedRadioBoxValue"),
            "SelectedChechBoxValue" : component.get("v.SelectedChechBoxValue"),
            "SelectedChechBoxValue1" : component.get("v.SelectedChechBoxValue1"),
            "SelectedRadioBoxValue1" : component.get("v.SelectedRadioBoxValue1"),
            "CompteRenduValue" : component.get("v.CompteRenduValue"),
            "ContactValue" : component.get("v.selectedLookUpRecord").Id,
            "SelectedDateValue" : component.get("v.SelectedDateValue"),
            "CaseStatus" : component.get("v.currentCaseStatus"),
            "CaseIDRetrieved" : component.get("v.RecordId"),
            "historiqueObj": component.get("v.historiqueObj"),
            "isContactWrong" : JSON.stringify(component.get("v.selectedLookUpRecord")),
        });
        
        action.setCallback(this,function(a){
            if(a.getReturnValue() == 'Success')
            {
                //check if result is successfull
                var state = a.getState(); 
                window.setTimeout(sforce.one.navigateToURL("/"+component.get("v.RecordId"), true), 30000);
                
                //sforce.one.navigateToURL("/"+component.get("v.RecordId"), true);
                //window.location.reload(true);
            }
            else if (Boolean((String(a.getReturnValue()) == 'Fail' 
                              && Boolean(component.get("v.historiqueObj.Traitement_interrompu__c")) == true
                              && String(JSON.stringify(component.get("v.selectedLookUpRecord")) != '{}')) ))
            {
            }
        });      
        $A.enqueueAction(action);
    },
    goToNextPage2 : function(component, event, helper){ //Créer et enregistrer les lignes
        var action = component.get("c.goToNextPage2");
        action.setParams({
            "SelectedRadioBoxValue" : component.get("v.SelectedRadioBoxValue"),
            "CaseStatus" : component.get("v.currentCaseStatus"),
            "CaseIDRetrieved" : component.get("v.RecordId")
        });
        action.setCallback(this,function(a){
            //check if result is successfull
            var state = a.getState();   
            component.set("v.historiqueObj", a.getReturnValue());
            //set contact ID 
            var attribute1 = component.get("v.historiqueObj.Contact_Name__c");
            var attribute2 = component.get("v.accountID");
            var childComponent = component.find('child');
            childComponent.myMethod(attribute1, attribute2);
        });     
        $A.enqueueAction(action);
    },
     clearSelection : function(component, event){
        //blur -> uncheck the selected radio button
        event.getSource().set("v.value", false);
    }

    
})