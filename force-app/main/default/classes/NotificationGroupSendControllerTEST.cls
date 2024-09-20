@isTest
public class NotificationGroupSendControllerTEST {
    static {
        // section to initialize static values
    }

    @testSetup 
    static void setupMethod() {
        // insert the client
        Account acc = new Account (
            Name = 'Test Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Empresa').getRecordTypeId(),
            CurrencyIsoCode = 'USD'
        );
        insert acc;
        
        // insert the contact
        Contact c = new Contact (
            LastName = 'Test Contact',
            CurrencyIsoCode = 'USD',
            AccountId = acc.id,
            Email = 'a@a.cl'
        );
        insert c;

        String name = 'DummyUser';
        Id profileId = [SELECT Id FROM Profile WHERE Name =: 'System Administrator'].Id;
        User userTM = new User(
            Username = name + 'TechUser' + '@sqm.com',
            ProfileId = profileId,
            LastName = name,
            FirstName = name,
            Alias = name.substring(0, Math.min(name.length(), 6)),
            Email = name + String.valueOf(Math.abs(Crypto.getRandomLong())) + '@sqm.com',
            TimeZoneSidKey = 'America/New_York',
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LocaleSidKey = 'en_CA'
        );        
        insert userTM;
        
        User userOwner = new User(
            Username = name + 'Owner' + '@sqm.com',
            ProfileId = profileId,
            LastName = name,
            FirstName = name,
            Alias = name.substring(0, Math.min(name.length(), 6)),
            Email = name + String.valueOf(Math.abs(Crypto.getRandomLong())) + '@sqm.com',
            TimeZoneSidKey = 'America/New_York',
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LocaleSidKey = 'en_CA'
        );        
        insert userOwner;
        
        // insert notification Process
        Notification_Process__c np = new Notification_Process__c(
            Type__c = 'Simple',
            Change_date__c = Date.today(),
            Description__c = 'test',
        	Ownerid = userOwner.Id,
        	Technical_Manager__c = userTM.Id);
        insert np;
        
        // insert notification group
        Notification_Group__c ng = new Notification_Group__c(
            Name = 'Notification Group',
            Notification_Process__c = np.Id,
            Type__c = 'Simple'
        );
        insert ng;
        
        // insert Notification task
        Notification_Task__c nt = new Notification_Task__c(
            Name = 'Notification Task',
            Notification_Account__c = acc.Id,
            Notification_Group__c = ng.Id,
            Type__c = 'Simple'
        );
        insert nt;
            
        // insert Notification Contact
        Notification_Contact__c nc = new Notification_Contact__c(
            Notification_Account__c = acc.Id,
            Notification_Contact__c = c.Id,
            Name = 'Notification Contact',
            Notification_Group__c = ng.Id
        );
        insert nc;
        
        // insert the file
        ContentVersion cv = new ContentVersion();
        cv.ContentLocation = 'S';
        cv.ContentDocumentId = null;
        cv.VersionData = Blob.valueOf('Content File'); 
        cv.Title = 'FileTest';
        cv.PathOnClient = 'FileTest';
        insert cv;
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        cdl.LinkedEntityId = np.Id; 
        cdl.ShareType = 'V';
        insert cdl;
        
        System.runAs(new User(Id = UserInfo.getUserId())) {
            //  insert the template
            EmailTemplate e = new EmailTemplate(
                Name = 'TestTemplate',
                DeveloperName = 'test',
                FolderId = UserInfo.getUserId(),
                TemplateType = 'Text',
                Subject = 'Invoice',
                Body = 'Please find the attached invoice.',
                IsActive = true
            );
            insert e;
        }
    }
    
    /**
    *  @Description: Test the call for the service 
    *  @Autor:       LEC , Deloitte, lcastanedad@deloitte.com
    *  @Date:        26/12/2022
    */
    @isTest
    public static void testControllerWithSuccess(){
        NotificationGroupSendController.RequestSimpleWrapper request = new NotificationGroupSendController.RequestSimpleWrapper();
        request.orgWideEmailAddressName = 'Contacto SQM';
        request.templateName = 'TestTemplate';
        request.whatId = [SELECT Id FROM Notification_Group__c WHERE Name = 'Notification Group' LIMIT 1]?.Id;
        request.parentWhatId = [SELECT Notification_Process__c FROM Notification_Group__c WHERE Name = 'Notification Group' LIMIT 1]?.Notification_Process__c;
        request.listOfNotificationTask = [SELECT Id, Comments__c, Customer_Acceptance__c, Notification_Account__c, Notification_Group__c, Name, Status__c, Type__c FROM Notification_Task__c WHERE Notification_Group__c = :request.whatId];

        Test.startTest();
        List<NotificationGroupSendController.ResponseParamWrapper> response = NotificationGroupSendController.sendEmailToNotificationGroup(new NotificationGroupSendController.RequestSimpleWrapper[] {request});
        
        // we assert buy what governor limits say 
        Test.stopTest();
        
        System.assertEquals(response[0].isSuccess, true, 'Response is False!');
    }

    /**
    *  @Description: Test the controller  with data failure result
    *  @Autor:       LEC , Deloitte, lcastanedad@deloitte.com
    *  @Date:        26/12/2022
    */
    @isTest
    public static void testControllerWithDataFailure(){        
        NotificationGroupSendController.RequestSimpleWrapper request = new NotificationGroupSendController.RequestSimpleWrapper();
        request.orgWideEmailAddressName = 'Contacto SQM';
        request.templateName = 'TestTemplate';
        request.whatId = NULL;
        request.parentWhatId = NULL;
        request.listOfNotificationTask = NULL;

        Test.startTest();
        List<NotificationGroupSendController.ResponseParamWrapper> response = NotificationGroupSendController.sendEmailToNotificationGroup(new NotificationGroupSendController.RequestSimpleWrapper[] {request});
        
        Test.stopTest();

        System.assertEquals(response[0].isSuccess, false, 'Response is True!');
    }
}