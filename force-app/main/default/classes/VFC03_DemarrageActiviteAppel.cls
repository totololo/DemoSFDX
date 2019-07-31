/*
* Class to fill the Questionnaire of DA
* @author: Lea Zoghbi
* @date: 09/01/2017
* @Test: VFC03_DemarrageActiviteAppel_Test
*/
public with sharing class VFC03_DemarrageActiviteAppel {
      	
    public boolean btnDisable{get;set;}
    public boolean btnDisableRedirect{get;set;}
    
    private final Case requeteDA;
    public String requeteId{get;set;}
    
    
    //function parameter
    public string questionId {get; set;}
    //List of wrapper to display on VF Page
    public list<wrapperQuestion> listWrapperQuestions {get; set;}
    
    private map<string, wrapperQuestion> mapQuestions {get; set;}
    
    //The bilan (questionnaire rempli linked to the case, created per questionnaire)
    public Questionnaire_Rempli__c questRempli {get; set;}
    public string commentaire {get; set;}
    
    //Do not display the questions if no questionnaire exists or case Id not passed in parameter or if status is not correct
    public boolean renderQuestionnaire {get; set;}
    
    //Checkbox, when checked, it saves the questionnaire temporarily: on every load it is always false
    public boolean interrompu {get; set;}
    
    //Questionnaire that have MP and status like the one on case
    public Questionnaire__c questionnaire {get; set;}
    public boolean isBilan {get; set;}
    public boolean secondBlock {get;set;}
    public boolean isJoinable {get; set;}
    public boolean isSortie {get; set;}
    
    public boolean inConsole{get;set;}
    
    //To fill the select list
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
		options.add(new SelectOption(Label.DA_ReponseOk,Label.DA_ReponseOk)); 
        if(!isBilan){
            options.add(new SelectOption(Label.DA_ReponseRevu,Label.DA_ReponseRevu));
        }else{
            options.add(new SelectOption(Label.DA_ReponseKo,Label.DA_ReponseKo)); 
        }
        return options; 
    }
    
    //Constructor
    public VFC03_DemarrageActiviteAppel(ApexPages.StandardController controller) {
        inConsole = false;
        //get from the standard controller the case id
        string caseId = controller.getId();
        renderQuestionnaire = false;
        btnDisable = false;
        btnDisableRedirect = false;
        isBilan= false;
        isJoinable = true;
        secondBlock = false;
        isSortie = false;
        if(!string.isBlank(caseId)){
            //get the case
            requeteDA = [select id, Status, Macroprofil_de_reference__c, Point_relais_ne_repond_pas__c, Operateur__c, ContactId, AccountId,Date_de_rappel_planifiee__c,Tech_Is_Manual_Modif__c
                         from Case 
                         where id =: caseId];
            
            //If the case exists and is whithin the status that are permitted to fill the questionnaire continue else display error
            if(requeteDA != null){
                requeteId = (String) requeteDA.Id; 
                string sortie = apexpages.currentpage().getparameters().get('isSortie');
                if(!string.isBlank(sortie) && sortie.toLowerCase() == 'true'){
                    isSortie = true;
                }
                list<Questionnaire__c> listQuestionnaire;
                if(!isSortie){
                    //select questionnaire with MP= to that on case and status = to that on case and same for operateur
                    listQuestionnaire = [select id, Name, Macroprofil__c, Statut_de_la_requete__c, Operateur__c, Bilan__c, 
                                         (select id, Name,  Question__c, Type_de_question__c, Reponses_suggerees__c from Questions__r Order by Tech_Question_Order__c asc)
                                         from Questionnaire__c
                                         where Macroprofil__c =: requeteDA.Macroprofil_de_reference__c and Statut_de_la_requete__c =: requeteDA.Status and  Operateur__c =: requeteDA.Operateur__c ];
                    
                }else{
                    //select questionnaire = demande de sortie
                    listQuestionnaire = [select id, Name, Macroprofil__c, Statut_de_la_requete__c, Operateur__c, Bilan__c,
                                         (select id, Name,  Question__c, Type_de_question__c, Reponses_suggerees__c from Questions__r Order by Tech_Question_Order__c asc)
                                         from Questionnaire__c
                                         where RecordTypeId =: system.label.DA_RT_DemandeDeSortie_Questionnaire];
                    
                     
                }
 					
                //if it does not exist display error, else continue
                if(listQuestionnaire != null && listQuestionnaire.size() > 0){ 
                    questionnaire = listQuestionnaire[0];
                    isBilan = string.isNotBlank(questionnaire.Bilan__c)? true: false; 
                    //list of questions with this questionnaire
                    list<Questions__c> listQuestions = questionnaire.Questions__r;
                    listWrapperQuestions = new list<wrapperQuestion>();
                    mapQuestions = new map<string, wrapperQuestion>();                  
                    //select on questionnaire rempli having the questionnaire selected above
                    list<Questionnaire_Rempli__c> listQuestionnaireRempli = [ select id, Questionnaire__c, Requete__c, Traitement_interrompu__c, Commentaire__c, 
                                                                             Planifier_un_rappel__c, RecordTypeId, Compte__c, Nom_du_contact__c, Motif_de_sortie_du_DA__c, Reference_de_l_ancien_PUDO__c
                                                                             from Questionnaire_Rempli__c
                                                                             where Requete__c=:requeteDA.Id and Questionnaire__c =: questionnaire.Id];
                    interrompu = false; //always loaded as false 
                    map<string, Reponse__c> mapQuestionReponse = new map <string, Reponse__c>();
                    //if questionnaire rempli exists (case of interompu) -> load all reponse already created
                    if(listQuestionnaireRempli.size() > 0 ){
                        questRempli = listQuestionnaireRempli[0];
                        commentaire = questRempli.Commentaire__c;
                        questRempli.Planifier_un_rappel__c = null; 
                        list<Reponse__c> listReponse = [ select id, Question__c, Question__r.Name, Question__r.Question__c, Question__r.Type_de_question__c, 
                                                        Question__r.Reponses_suggerees__c, Questionnaire_rempli__c, OK__c, KO__c, Revu__c , Question__r.Tech_Question_Order__c
                                                        from Reponse__c
                                                        where Questionnaire_rempli__c=: questRempli.Id
                                                        order by Question__r.Tech_Question_Order__c asc]; 
                        if(listReponse.size() > 0 && questRempli.Traitement_interrompu__c){ 
                            for(Reponse__c reponse : listReponse){
                                
                                //add map question reponse to use it later in case a new question was added to 
                                //questionaire after interrompu of a certain questionaire rempli
                                mapQuestionReponse.put(reponse.Question__c, reponse);
                                
                                //fill the reponse to the wrapper
                                wrapperQuestion wrapQuest = new wrapperQuestion();
                                wrapQuest.Id = reponse.Question__c;
                                wrapQuest.numero = reponse.Question__r.Name;
                                wrapQuest.question = reponse.Question__r.Question__c;
                                wrapQuest.type = (string.isNotBlank(reponse.Question__r.Type_de_question__c) && reponse.Question__r.Type_de_question__c == Label.DA_Primordiale) ? reponse.Question__r.Type_de_question__c : '';
                                
                                //A replace is required to display the test 
                                wrapQuest.repsuggere = reponse.Question__r.Reponses_suggerees__c.replace('\n', '<br/>') ;                                
                                
                                //based on the checkboxes fill the select list of the page
                                if(reponse.OK__c){
                                    wrapQuest.reponse = Label.DA_ReponseOk;
                                }else if(reponse.KO__c){
                                    wrapQuest.reponse = Label.DA_ReponseKo;
                                }else if(reponse.Revu__c){
                                    wrapQuest.reponse = Label.DA_ReponseRevu;
                                }else{
                                    wrapQuest.reponse = '';
                                }
                                mapQuestions.put(reponse.Question__c, wrapQuest);
                            }
                        }
                    }else{
                      	questRempli = new Questionnaire_Rempli__c();
                        questRempli.Compte__c = requeteDA.AccountId;
                        questRempli.Questionnaire__c = questionnaire.Id; 
            			questRempli.Requete__c = requeteDA.Id;
                    }
                    
                    //In any case loop over the questions linked to the questionnaire selected previously
                    //If already added from response skip adding it else create a new instance
                    //of the wrapper object from the questions object
                    for(Questions__c quest : listQuestions){
                        if(!mapQuestionReponse.containsKey(quest.Id)){
                            wrapperQuestion wrapQuest = new wrapperQuestion();
                            wrapQuest.Id = quest.Id;
                            wrapQuest.numero = quest.Name;
                            wrapQuest.question = quest.Question__c;
                            wrapQuest.type = (string.isNotBlank(quest.Type_de_question__c) && quest.Type_de_question__c == Label.DA_Primordiale) ? quest.Type_de_question__c : '';
                            wrapQuest.repsuggere = quest.Reponses_suggerees__c.replace('\n', '<br/>') ;                                
                            wrapQuest.reponse = ''; //initially empty
                            mapQuestions.put(quest.Id, wrapQuest);
                        }
                    }
                    //fill the list from the map of wrapper instances already created
                    listWrapperQuestions = mapQuestions.values();
                    
                    //if the list of wrapper instances is greater than 0. render the questions pageblock
                    if(listWrapperQuestions.size() > 0){
                        renderQuestionnaire = true;
                    }
                }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.DA_QuestionnaireNonValide);
                    ApexPages.addMessage(myMsg);
                }
            }else{
                requeteId = null;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.DA_RequeteNonValide);
                ApexPages.addMessage(myMsg);
            }
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.DA_RequeteNonValide);
            ApexPages.addMessage(myMsg);
        }
    }
    
    // Method to save the questionnaire (as interrompu)
    public void interrompuSave(){
        //call the update and/or creation of the questionnaire rempli and reponse objects
        //send to method status interrompu
         
        fillQuestionnaire(true);
       
        createTask(requeteDA.Id,  requeteDA.ContactId, Label.DA_TacheTraitementInterrompu, Label.DA_Tache_StatutTraite, questRempli.Planifier_un_rappel__c);
              
        //update field for view
        requeteDA.Planifier_un_rappel__c = questRempli.Planifier_un_rappel__c != null ? true : false;
        requeteDA.Date_de_rappel_planifiee__c = questRempli.Planifier_un_rappel__c != null ? questRempli.Planifier_un_rappel__c : null;
        requeteDA.Traitement_interrompu__c = true;
        requeteDA.Point_relais_ne_repond_pas__c = true;
        update requeteDA;
    }
    
    // Method to save the questionnaire (final save)
    public void definitiveSave(){  
        try {
            //call the update and/or creation of the questionnaire rempli and reponse objects
            //send to method status interrompu as false 
            fillQuestionnaire(false);  
            //update the status of the requete to the next level based on the order set in the map at the beginning
            upgradeStatus();
        }catch(Exception e) {
            String errorMessage = Label.DA_Exception;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage);
            ApexPages.addMessage(myMsg);
        }
        
    }
    
    // Method to save the questionnaire (final save)
    public PageReference save(){ 
        PageReference retVal = null;
        try {
            String url = '';
            Date dateRappel = questRempli.Planifier_un_rappel__c;
            if(dateRappel < Date.today()) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.DA_DatePlannifier);
                ApexPages.addMessage(myMsg);
                return null; 
            } 
            //check if interrompu
            if(interrompu){
                interrompuSave();
            }else{
                definitiveSave();
            }
             
            //redirect to requete if not final sortie
            if(isSortie && !interrompu){ 
                url = '/' + questRempli.Id;
                if(inConsole){
                    url += '?isdtp=vw';
                }
                retVal = new PageReference(url);
            }else{
                url = '/' + requeteDA.Id;
                if(inConsole){
                    url += '?isdtp=vw';
                }
                retVal = new PageReference(url);
            } 
            btnDisable = true;
        }catch(Exception e) {
            btnDisable = false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            ApexPages.addMessage(myMsg);
        } 
        return retVal;
    }
    
    //Method that is common to interromopu and final save
    public void fillQuestionnaire(boolean isInterrompu){ 
        //if questionnaire rempli (bilan) is null => neer interrupted => create it with the isInterrompu depending from 
        //where it is coming (button or checkbox)  
        questRempli.Traitement_interrompu__c = isInterrompu;
        System.debug('|||gho questRempli.Traitement_interrompu__c : ' + questRempli.Traitement_interrompu__c);
        questRempli.Commentaire__c = commentaire;
        if(isSortie){
            questRempli.RecordTypeId = Label.DA_RT_DemandeDeSortie_QuestionnaireRempli;
        }    
        System.debug('|||gho questRempli : ' + questRempli);
        upsert questRempli; 
        
        list<Reponse__c> listReponseModified = new list<Reponse__c>();
        //Get the reponse to check if already interrompu => update reponse else create
        list<Reponse__c> listReponse = [select Id, KO__c, OK__c, Question__c, Questionnaire_rempli__c, Revu__c, Type_de_question__c
                                        from Reponse__c
                                        where Questionnaire_Rempli__c =: questRempli.Id];
        
        map<string, Reponse__c> mapQuestionReponse  = new map<string, Reponse__c>();
        if(listReponse.size() >0){
            for(Reponse__c reponse : listReponse){
                //map to check whether the question of this Questionnaire REmpli is already created
                mapQuestionReponse.put(reponse.Question__c, reponse);
            }
        }
        string questionId ='';
        //loop on all wrapper objects
        for(wrapperQuestion wrapQuest : listWrapperQuestions){
            questionId = wrapQuest.id;
            Reponse__c reponse = new Reponse__c();
            
            //from the map check if reponse already created, and update the reponse instance 
            //else create a new instance, fill all fields and create the record
            if(mapQuestionReponse != null && mapQuestionReponse.containsKey(questionId)){
                reponse = mapQuestionReponse.get(questionId);
            }
            reponse.Type_de_question__c = wrapQuest.type;
            //since master detail fill them only on insert
            if(string.isBlank(reponse.Question__c)){
                reponse.Question__c =wrapQuest.Id;
            }
            //since master detail fill them only on insert
            if(string.isBlank(reponse.Questionnaire_rempli__c)){
                reponse.Questionnaire_rempli__c = questRempli.Id;
            }
            
            //fill the 3 answer options that are boolean based on the select list
            if(!string.isBlank(wrapQuest.reponse)){
                if(wrapQuest.reponse.toLowerCase() == Label.DA_ReponseOk){
                    reponse.OK__c = true;
                    reponse.KO__c = false;
                    reponse.Revu__c = false;
                }else if(wrapQuest.reponse.toLowerCase() == Label.DA_ReponseKo){
                    reponse.OK__c = false;
                    reponse.KO__c = true;
                    reponse.Revu__c = false;
                }else if(wrapQuest.reponse.toLowerCase() == Label.DA_ReponseRevu){
                    reponse.OK__c = false;
                    reponse.KO__c = false;
                    reponse.Revu__c = true;
                }
            }
            listReponseModified.add(reponse);
        }
        //upsert the list
        
        if(listReponseModified.size() > 0){ 
            upsert listReponseModified; 
        }
    }
    //upgrade status to the next level
    public void upgradeStatus(){
        boolean bUpgrade = false;
        boolean doUpdate = false;
        if(requeteDA != null){
            string currentStatusStr = requeteDA.Status; 
            if(!isBilan && !isSortie){ 
                if(currentStatusStr.isNumeric()){
                    integer currentStatusInt = integer.valueof(currentStatusStr); 
                    requeteDA.Status = string.valueof(currentStatusInt + 1);
                    doUpdate = true;
                    bUpgrade = true;
                }
            }
            else if(isSortie && !interrompu){ 
                 requeteDA.Status = Label.DA_StatutEnAttenteDemandeSortie;
                 doUpdate = true;   
            }
            if(requeteDA.Date_de_rappel_planifiee__c != null) { 
                requeteDA.Traitement_interrompu__c = false;
                requeteDA.Planifier_un_rappel__c = false;
                requeteDA.Date_de_rappel_planifiee__c = null;
                if(!doUpdate){
                    doUpdate = true;
                }
            }
            if(requeteDA.Tech_Is_Manual_Modif__c) {
                requeteDA.Tech_Is_Manual_Modif__c = false;
            }else {
                requeteDA.Tech_Is_Manual_Modif__c = true;
            }
            
            if(doUpdate) { 
                try { 
                    // the status of the case is modified by another PB before this code.
                    // Avoid retun back to previous status
                    Case updatedRequete = [select id , status 
                                           from case 
                                           where id =: requeteDA.Id
                                          ]; 
                    if(updatedRequete.Status != requeteDA.Status && !bUpgrade){
                        requeteDA.Status = updatedRequete.Status;
                    }
                    update requeteDA;
                }catch(Exception e) {
                    System.debug('|||gho Exception : ' + e.getMessage());
                }
                 
                
            }  
        }
    }
    
    //cancel and return to the case
    public PageReference cancel(){ 
        if(requeteDA != null){ 
            String url = '/' + requeteDA.Id; 
            if(inConsole) {
                url += '?isdtp=vw';
            }   
            return new PageReference(url); 
        }else{ 
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.DA_RequeteNonValide);
            ApexPages.addMessage(myMsg);
            return null;
        }
    }
 
    
    public void clearSelection(){
        wrapperQuestion question = new wrapperQuestion(); 
        if(mapQuestions.containsKey(questionId)){
            question = mapQuestions.get(questionId);  
            question.reponse = '';
        }
        mapQuestions.put(questionId , question);
        listWrapperQuestions = new list<wrapperQuestion>();
        listWrapperQuestions = mapQuestions.values();
    }
     public void fillSelection(){
        wrapperQuestion question = new wrapperQuestion();
        string answer = '';
        if(mapQuestions.containsKey(questionId)){
            question = mapQuestions.get(questionId);
            answer = question.reponse;
        }
    }
    //display questionnaire 
    public PageReference redirectToQuestionnaire(){
        if(!isJoinable){
            btnDisableRedirect = true; 
            //update field for view
            requeteDA.Point_relais_ne_repond_pas__c = true;
            update requeteDA;
            
            //create tache non-joinable 
            createTask(requeteDA.id, requeteDA.ContactId,Label.DA_Tache_NeRepondPas, Label.DA_Tache_StatutTraite, null);
            String url = '/' + requeteDA.Id;
            if(inConsole) {
               url += '?isdtp=vw';
            } 
            return new PageReference(url);
        } else {
            secondBlock = true;
        }
        return null;
    }
    
    //function to create task
    public void createTask(string whatId, string whoId, string subject, string status, datetime datePlannifiable){
        Task tacheToInsert = new Task();
        tacheToInsert.WhatId = whatId;
		tacheToInsert.WhoId = whoId;
        tacheToInsert.Subject = subject;
        tacheToInsert.status = status;
        if(datePlannifiable != null){
            tacheToInsert.ActivityDate = date.newinstance(datePlannifiable.year(),datePlannifiable.month(),datePlannifiable.day()) ;
            tacheToInsert.IsReminderSet = true;
            tacheToInsert.ReminderDateTime = datePlannifiable;
        }else{
            tacheToInsert.ActivityDate = date.today();
        }
        tacheToInsert.OwnerId = UserInfo.getUserId();
        insert tacheToInsert;
    }
    
    //wrapper class for question to display on the VF page
    public class wrapperQuestion {
        public string id {get; set;}
        public string numero {get; set;}
        public string question {get; set;}
        public string type {get; set;}
        public string repsuggere {get; set;}
        public string reponse {get; set;}
    }
    
}