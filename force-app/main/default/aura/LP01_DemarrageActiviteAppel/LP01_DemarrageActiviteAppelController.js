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
            component.set('v.accountID', a.getReturnValue().AccountId)
            component.set('v.currentCaseStatus',a.getReturnValue().Status);
            var statusRetrieved = component.get("v.currentCaseStatus");
            if(statusRetrieved.includes('1') || statusRetrieved.includes('2') || statusRetrieved.includes('3') || statusRetrieved.includes('4') || statusRetrieved.includes('5')){}
            else if(statusRetrieved.includes('6'))
            {
                component.set('v.ShowAppelPassageAppeSuivant', false);
            }
                else 
                {
                    alert($A.get("$Label.c.DA_ErreurChoixStatut"));
                    sforce.one.navigateToURL("/"+component.get("v.RecordId"), true);
                }
        });     
        $A.enqueueAction(action);

        
    },
    onSaveJoinable : function(component, event, helper)  {
        var passageAppelSuivant = document.getElementById("radio-3");
        var demandeExclusion = document.getElementById("radio-4");
        var finDuSuivi = document.getElementById("radio-5");
        
        // check if traitement interrompu
        if(component.get("v.historiqueObj.Traitement_interrompu__c") == true)
        {
            
            helper.Save(component, event, helper);
            //sforce.one.navigateToURL("/"+component.get("v.RecordId"), true);
            //window.location.reload();
            //window.location.href = "https://pickup--dev.lightning.force.com/one/one.app#/sObject/"+component.get("v.RecordId");
        }
        // check if traitement non interrompu
        else
        {
            var enteredCompteRenduValidation = false;
            var enteredResultatdappelValidation = false;
            // check if Resultat d appel est coche
            if(passageAppelSuivant.checked == true)
            {
                component.set("v.SelectedRadioBoxValue1",passageAppelSuivant.value);
            }
            else if(demandeExclusion.checked == true)
            {
                component.set("v.SelectedRadioBoxValue1 ",demandeExclusion.value);
            }
                else if(finDuSuivi.checked == true)
                {
                    component.set("v.SelectedRadioBoxValue1",finDuSuivi.value);
                }
            //check if Compte Rendu is empty
            /*if((component.get("v.historiqueObj.Compte_rendu__c")) == null || component.get("v.historiqueObj.Compte_rendu__c")== '')
            {
                component.set('v.RequiredFieldCompteRendu', 'Veuillez remplir ce champ');
                enteredCompteRenduValidation = true;
            }*/
            //check if Resultat d appel is empty
            if((component.get("v.SelectedRadioBoxValue1")) == null || component.get("v.SelectedRadioBoxValue1	")== '')
            {
                component.set('v.RequiredFieldRadio1', $A.get("$Label.c.DA_ChoisirOption"));
                enteredResultatdappelValidation = true;
            }
            if(enteredResultatdappelValidation != true)//if(enteredCompteRenduValidation != true && enteredResultatdappelValidation != true)
            {
                helper.Save(component, event, helper);
               // window.location.href = "https://pickup--dev.lightning.force.com/one/one.app#/sObject/"+component.get("v.RecordId")+"/view";
                //sforce.one.navigateToURL("/"+component.get("v.RecordId"), true);
            }
        }
    },
    goToNextPage : function(component, event, helper)  {
        var ouiRelaisRepond = document.getElementById("radio-6");
        var nonRelaisRepond = document.getElementById("radio-7");
        ouiRelaisRepond.checked == true
        if(ouiRelaisRepond.checked == true)
        {
            component.set("v.SelectedRadioBoxValue",ouiRelaisRepond.value);
            helper.goToNextPage2(component, event, helper);
            var showScndPannel = component.set('v.ShowFirstPanel', false);
            var btn = event.getSource();
        }
        else if(nonRelaisRepond.checked == true)
        {
            component.set("v.SelectedRadioBoxValue",nonRelaisRepond.value);
            helper.goToNextPage2(component, event, helper);
            sforce.one.navigateToURL("/"+component.get("v.RecordId"), true);
            window.location.reload();
        }
            else{
                var requiredField = component.set('v.RequiredFieldRadio',  $A.get("$Label.c.DA_ChoisirOption"));
            }
    },
    onChkb : function(component, event){
        var passageAppelSuivant = document.getElementById("radio-3");
        var demandeExclusion = document.getElementById("radio-4");
        var finDuSuivi = document.getElementById("radio-5");

        var selectedName = event.getSource().get("v.name");
        var selectedValue = event.getSource().get("v.value");
        if(selectedValue == true)
        {
            if(selectedName == $A.get("$Label.c.DA_InterrompuLbl") && selectedValue == true)
            {
                component.set("v.SelectedChechBoxValue",selectedName);
                component.set('v.ShowPlanifierUnAppel', true);
                component.set('v.ShowDatePlanifierUnAppel', true);
                passageAppelSuivant.checked = false;
                demandeExclusion.checked = false;
                finDuSuivi.checked = false;
            } else if(selectedName == $A.get("$Label.c.DA_PlannifierRappelLbl") && selectedValue == true)
            {
                component.set("v.SelectedChechBoxValue",selectedName);
            }
        }
        else{
            if(selectedName == $A.get("$Label.c.DA_InterrompuLbl") && selectedValue == false)
            {
                component.set("v.SelectedChechBoxValue",'false '+selectedName);
                component.set('v.ShowPlanifierUnAppel', false);
                component.set('v.ShowDatePlanifierUnAppel', false);
            } 
        }
    },
    onChkb1 : function(component, event){
        var selectedName = event.getSource().get("v.name");
        var selectedValue = event.getSource().get("v.value");
        if(selectedValue == true)
        {
            component.set("v.SelectedChechBoxValue1",selectedName);
        }
        else{
            if(selectedName == $A.get("$Label.c.DA_PlannifierRappelLbl") && selectedValue == false)
            {
                component.set("v.SelectedChechBoxValue1",'false '+selectedName);
            }
        }
    },
    onRadio1: function(component, event) {
		//var selectedName = event.getSource().get("v.name");//api value of picklist value
        //var selectedValue = event.getSource().get("v.value");
        //alert(selectedValue);
        //component.set("v.SelectedRadioBoxValue1",selectedName);
        component.find("checkbox1").set("v.value", false);
        component.find("checkbox2").set("v.value", false);
        component.set('v.historiqueObj.Date_Du_Rappel__c', '');
        component.set('v.ShowPlanifierUnAppel', false);
        component.set('v.ShowDatePlanifierUnAppel', false);
        
    },
    onRadio: function(component, event) {
        var selectedName = event.getSource().get("v.name");
        var selectedValue = event.getSource().get("v.value");//api value of picklist value
        component.set("v.SelectedRadioBoxValue",selectedName);
    },
    
    clearSelection : function(component, event, helper){
        //blur -> uncheck the selected radio button
        event.getSource().set("v.value", false);
    },
    
    closeDA : function(component, event)  { 
        //window.location.href = "https://pickup--dev.lightning.force.com/one/one.app#/sObject/"+component.get("v.RecordId");
        sforce.one.navigateToURL("/"+component.get("v.RecordId"), true);
        window.location.reload();
    }
    
})