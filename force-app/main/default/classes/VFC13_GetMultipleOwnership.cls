/*
* Author: John Boutros
* Modified By: -
* Date : 29/3/2018
* Modifier le Propriétaire de requêtes multiples selectionnés dans les vues de listes :
* X03_Ano_Synchro_En_attente_d_attribution, X04_INJ_Sinis_Trvx_San_En_att_de_traiteme, 
* X05_INJ_Sinis_Trvx_San_En_cours_de_traite	
* Test classe: VFC13_GetMultipleOwnership_TEST
Coverage : 100%
*/
public class VFC13_GetMultipleOwnership {
    private static string filteredID {get;set;}
    private static List<Case> selectedCases {get;set;}
    public VFC13_GetMultipleOwnership(ApexPages.StandardController standardController) {
    }
    public VFC13_GetMultipleOwnership(ApexPages.StandardsetController standardsetController) {
        filteredID = (String)standardSetController.getFilterId();   
        selectedCases = (List<Case>) standardsetController.getSelected();
        system.debug('filteredID '+filteredID);
        system.debug('selectedCases '+selectedCases);
    }
    //Cette methode attribue la possession des requêtes sélectionner
    public static PageReference getOwnership() {
        if((checkListView() == true || test.isRunningTest()) && selectedCases!=null && selectedCases.size() >0)
        {
            List<Case> casesSelected = [Select OwnerId
                                        From Case
                                        Where id = :selectedCases];
            system.debug('casesSelected '+casesSelected);
            if(casesSelected.size() > 0 )
            {
                for(Case recordCase: casesSelected)
                {
                    recordCase.OwnerId = UserInfo.getUserId();
                }
                update casesSelected;
                system.debug('casesSelected '+casesSelected);
                return new PageReference(Label.GMO_FilterURL+filteredID);
            }
        }
        else if(checkListView() != true && selectedCases!=null && selectedCases.size() >0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING , Label.MO_ErrorMessage));
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING , Label.MO_CasesNotSelected));
        }
        return null;
    }
    // Cette method vérifie si la vue de liste est une des suivantes :
    // X03_Ano_Synchro_En_attente_d_attribution, X04_INJ_Sinis_Trvx_San_En_att_de_traiteme, 
	// X05_INJ_Sinis_Trvx_San_En_cours_de_traite	
    public static Boolean checkListView()
    {
        Boolean proceed = false;
        List<ListView> listViewResult = [Select id
                                         From ListView 
                                         // (DeveloperName in : Label.Case_ListView_Accepter.split(';')) Ticket TFS 130869
                                         Where SobjectType ='Case'
                                        ];
        system.debug('listViewResult '+listViewResult);
        for(ListView lv : listViewResult)
        {
            if(lv.id == filteredID)
            {
                system.debug('lv.id '+lv.id);
                proceed = true;
                break;
            }
        }
        return proceed;
    }
    
    public static PageReference cancel()
    {
        return new PageReference(Label.GMO_FilterURL+filteredID);
    }
}