/* Author 		: Yorgo Nabhan
* Date 			: 2017-9-28
* Description 	: This Class is made to test the TacheBeforeDelete Trigger and Its Ap01_Task Class 
*/


@istest
public without sharing class AP01_Task_Test {
    
    @testsetup
    public static void createuser()
    {
        //Create User
        User newUser = Utils_TestMethods.createUser('Yorgo', 'Nabhan', 'yorgo.nabhan@ei-technologies.com', 'yorgo.nabhan@ei-technologies.com');
        newUser.FirstName = 'Yorgo';
        newUser.LastName  = 'Nabhan';
        newUser.LocaleSidKey = 'fr_FR';
        newUser.Username = 'yorgo.nabhan@ei-technologie.com';
        newUser.Email = 'yorgo.nabhan@ei-technologie.com';
        newUser.Alias = 'ynab';
        newUser.CommunityNickname = 'nabhan.yorgo';
        newUser.EmailEncodingKey = 'ISO-8859-1';
        newUser.ProfileId = '00e580000015APr';
        
        newUser.LanguageLocaleKey = 'fr';
        newUser.Operateur__c = 'PUS_FR';
        newUser.TimeZoneSidKey = 'Europe/Paris';
        newUser.UserRoleId='00E58000000c5amEAA';
        newUser.IsActive = true;
        //NewUser.UserRoleId=r.Id;
        insert newUser;
    }
    
    static testMethod void testService()
    {        
        User NewUser=[SELECT id, IsActive FROM USER Where UserName = 'yorgo.nabhan@ei-technologie.com' LIMIT 1];
        
        //Create Contact
        Contact c = Utils_TestMethods.CreateContact('c1');
        Insert c;
        
        //Create Macroprofil
        Macroprofil__c m1 = Utils_TestMethods.CreateMacroprofil('m1');
        Macroprofil__c m2 = Utils_TestMethods.CreateMacroprofil('m2');
        Macroprofil__c m3 = Utils_TestMethods.CreateMacroprofil('m3');
        insert new List<Macroprofil__c>{m1, m2, m3};
            
            
            //Create Services
            Service__c s1 = Utils_TestMethods.CreateService('s1');
        Service__c s2 = Utils_TestMethods.CreateService('s2');
        Service__c s3 = Utils_TestMethods.CreateService('s3');
        insert new List<Service__c>{s1, s2, s3};
            
            //Create Transporteurs
            Transporteur__c t1 = Utils_TestMethods.CreateTransporteur('t1');
        Transporteur__c t2 = Utils_TestMethods.CreateTransporteur('t2');
        Transporteur__c t3 = Utils_TestMethods.CreateTransporteur('t3');
        Insert new List<Transporteur__c>{t1, t2, t3};
            
            //Create Macroprofil Service
            Macroprofil_Service__c ms1 = Utils_TestMethods.CreateMacroprofilService(m1,s1);
        Macroprofil_Service__c ms2 = Utils_TestMethods.CreateMacroprofilService(m2,s2);
        Macroprofil_Service__c ms3 = Utils_TestMethods.CreateMacroprofilService(m2,s3);
        Insert new List<Macroprofil_Service__c>{ms1,ms2,ms3};    
            
            //Create Macroprofil Tranporteur
            Macroprofil_Transporteur__c mt1 = Utils_TestMethods.CreateMacroprofilTransporteur(m1,t1);
        Macroprofil_Transporteur__c mt2 = Utils_TestMethods.CreateMacroprofilTransporteur(m2,t2);
        Macroprofil_Transporteur__c mt3 = Utils_TestMethods.CreateMacroprofilTransporteur(m2,t3);
        Insert new List<Macroprofil_Transporteur__c>{mt1, mt2, mt3}; 
            
            
            
            //Create Account
            
            Account account= Utils_TestMethods.CreateAccount(c,m1, 'a1');
        insert account;
        
        //Create Task
        system.debug(newUser);
        System.debug(account);
        Task newtask= new Task(Subject='Task Test',WhatId=account.id,Priority='Elevée',Status='Ouvert');
        newtask.OwnerId=newUser.id;
        insert newtask;
        
        System.runAs(newUser){  
            Test.startTest();
            try
            {
                delete newtask;
            }
            catch(Exception ex)
            {
                
            }
            Test.stopTest();
        }
    }
}