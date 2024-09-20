public without sharing class NotificationGroupSendController {

    /**
     * @description Wrapper Class for Input Params for Notification Group Methods
     */
    public class RequestSimpleWrapper {
        @InvocableVariable(label='Organization-Wide Email Address Name')
        public String orgWideEmailAddressName;
        @InvocableVariable(label='Template Name')
        public String templateName;
        @InvocableVariable(label='Related Notification Group Id')
        public String whatId;
        @InvocableVariable(label='Parent Notification Process Id')
        public String parentWhatId;
        @InvocableVariable(label='List of Notification Task for sending Email')
        public List<Notification_Task__c> listOfNotificationTask;
    }
    
    /**
     * @description Wrapper Class for Input Params for Sending Email
     */
    public class RequestParamWrapper {
        @InvocableVariable(label='To Addresses')
        public String[] toAddresses;
        @InvocableVariable(label='Cc Addresses')
        public String[] ccAddresses;
        @InvocableVariable(label='Bcc Addresses')
        public String[] bccAddresses;
        @InvocableVariable(label='Set email sender to Bcc *Default is false')
        public Boolean bccSender;
        @InvocableVariable(label='Organization-Wide Email Address Id')
        public String orgWideEmailAddressId;
        @InvocableVariable(label='Sender Name *Cannot be set if the orgWideEmailAddressId is set')
        public String senderDisplayName;
		@InvocableVariable(label='Sender Email *Cannot be set if the orgWideEmailAddressId is set')
        public String senderEmailAddress;
        @InvocableVariable(label='Template Id')
        public String templateId;
        @InvocableVariable(label='Subject')
        public String subject;
        @InvocableVariable(label='Text Body')
        public String plainTextBody;
        @InvocableVariable(label='Html Body')
        public String htmlBody;
        @InvocableVariable(label='Use the sender email signature *Default is true')
        public Boolean useSignature;
        @InvocableVariable(label='File Ids *ContentVersionId, AttchmentId or DocumentId')
        public String[] fileIds;
        @InvocableVariable(label='Related Record Id')
        public String whatId;
        @InvocableVariable(label='Target Object Id(Contact, Lead, User) *Required if template Id is set')
        public String targetObjectId;
        @InvocableVariable(label='Set targetObjectId as recipient *Default is true')
        public Boolean treatTargetObjectAsRecipient;
        @InvocableVariable(label='Save As Activity *Save to targetObjectId and whatId records, default is true')
        public Boolean saveAsActivity;
    }

    /**
     * @description Wrapper Class for Output Params 
     */
    public class ResponseParamWrapper {
        @InvocableVariable(label='Send result *true=success、false=failure')
        public Boolean isSuccess;
        @InvocableVariable(label='Error message')
        public String errorMessage;
        @InvocableVariable(label='What Id Sent')
        public Id[] whatIds;
    }

    /**
     * Send Email
     * @description Send single email with attachments
     * @param requests Email parameters
     * @return Result of sending email
     */
    @InvocableMethod(label='Send Email (Send email to All Notification Group)')
    public static List<ResponseParamWrapper> sendEmailToNotificationGroup(List<RequestSimpleWrapper> requests) {
        List<ResponseParamWrapper> response;
        try {
            RequestSimpleWrapper req = requests[0];
            // We process the Id for each param
            Id templateId = [SELECT Id, Name 
                             FROM EmailTemplate 
                             WHERE Name =: req.templateName
                             LIMIT 1]?.Id;
            Id orgWideAddressId = [SELECT Id, DisplayName 
                             FROM OrgWideEmailAddress 
                             WHERE DisplayName =: req.orgWideEmailAddressName
                             LIMIT 1]?.Id;
            //Id notificacionProcessId = [SELECT Id, Notification_Process__c 
            //                            FROM Notification_Group__c 
            //                            WHERE Id =: req.whatId]?.Notification_Process__c;
            Id notificacionProcessId = req.parentWhatId;
            //List<Notification_Task__c> allNotificationTasks = [SELECT Id, Name, Notification_Account__c, Notification_Group__c, Status__c  
            //                                                   FROM Notification_Task__c 
            //                                                   WHERE Notification_Group__c =: req.whatId
            //                                                   AND Status__c = 'Created'];
            // Process the notification tasks
            List<Notification_Task__c> allNotificationTasks = req.listOfNotificationTask;
            Map<Id, Notification_Task__c> mapAllNotificationTasks = new Map<Id, Notification_Task__c>();
            for (Notification_Task__c notification : allNotificationTasks) {
                mapAllNotificationTasks.put(notification.Notification_Account__c, notification);
            }
            // Process the notification contacs related to notification tasks
            List<Notification_Contact__c> allNotificationContacts = [SELECT Id, Name, Notification_Account__c, Notification_Contact__c, Notification_Email__c, Notification_Group__c, Notification_Group__r.Owner.Name
                                                                     FROM Notification_Contact__c
                                                                     WHERE Notification_Group__c = :req.whatId
                                                                     AND Notification_Account__c IN :mapAllNotificationTasks.keyset()];
            Map<Id, List<Notification_Contact__c>> mapAllContacts = new Map<Id, List<Notification_Contact__c>>();
            for (Notification_Contact__c contact : allNotificationContacts) {
                List<Notification_Contact__c> listOfContacts = mapAllContacts.containsKey(contact.Notification_Account__c) ? 
                    mapAllContacts.get(contact.Notification_Account__c) : new List<Notification_Contact__c>();
                listOfContacts.add(contact);
                mapAllContacts.put(contact.Notification_Account__c, listOfContacts);
            }
            // Process the attachments related to the Notification Process
            List<ContentDocumentLink> filesFromCDL = [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.LatestPublishedVersionId, Visibility, ContentDocument.Title, ContentDocument.createdDate, ContentDocument.FileType 
                                      FROM ContentDocumentLink 
                                      WHERE LinkedEntityId =: notificacionProcessId];
            List<Id> filesId = new List<Id>();
            for (ContentDocumentLink cdl : filesFromCDL) {
                filesId.add(cdl.ContentDocument.LatestPublishedVersionId);
            }
            // Process all the emails that is needed to send
            List<Messaging.SingleEmailMessage> listAllEmails = new List<Messaging.SingleEmailMessage>();
            for(Id accId : mapAllContacts.keyset()){
                List<Notification_Contact__c> allContactsForAccount = mapAllContacts.get(accId);
                for(Notification_Contact__c notificationContact : allContactsForAccount) {
                    Id whatId = mapAllNotificationTasks.get(accId)?.Id;
                    Id contactId = notificationContact.Notification_Contact__c;
                    Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(templateId, 
                                                                                            contactId, 
                                                                                            whatId);
                    RequestParamWrapper param = new RequestParamWrapper();
                    param.toAddresses = null;
                    param.ccAddresses = null;
                    param.bccAddresses = null;
                    param.bccSender = null;
                    param.orgWideEmailAddressId = orgWideAddressId;
                    param.senderDisplayName = (orgWideAddressId == null) ? notificationContact.Notification_Group__r.Owner.Name : null;
					param.senderEmailAddress = (orgWideAddressId == null) ? req.orgWideEmailAddressName : null;
                    param.templateId = templateId;
                    param.subject = null;
                    param.plainTextBody = null;
                    param.htmlBody = null;
                    param.useSignature = false;
                    param.fileIds = filesId;
                    param.whatId = whatId;
                    param.targetObjectId = contactId;
                    param.treatTargetObjectAsRecipient = true;
                    param.saveAsActivity = true;
                    
                    mail = prepareEmail(mail, new RequestParamWrapper[] {param});
                    listAllEmails.add(mail);
                }
            }
            
            // send all the emails     
            response = sendEmail(listAllEmails);
        
        } catch (Exception e) {
            ResponseParamWrapper exceptionResponse = new ResponseParamWrapper();
            exceptionResponse.isSuccess = false;
            exceptionResponse.errorMessage = 'Controller Exception: ' + e.getMessage() + '| StackTrace: ' + e.getStackTraceString();
            exceptionResponse.whatIds = null;
            response = new List<ResponseParamWrapper> {exceptionResponse};
        }
        
        // resturn the response
        return response;
    }
    
    /**
     * PrepareEmail
     * @description Prepare single email with attachments
     * @param requests Email parameters
     * @return Email
     */
    private static Messaging.SingleEmailMessage prepareEmail(Messaging.SingleEmailMessage pMail, List<RequestParamWrapper> requests) {
        RequestParamWrapper req = requests[0];        
        Messaging.SingleEmailMessage mail = pMail;

        //Recipient
        mail.setToAddresses(req.toAddresses);
        mail.setCcAddresses(req.ccAddresses);
        mail.setBccAddresses(req.bccAddresses);
        if(req.bccSender != null){
            mail.setBccSender(req.bccSender);
        }

        //Sender
        if(!String.isBlank(req.orgWideEmailAddressId)){
            mail.setOrgWideEmailAddressId(req.orgWideEmailAddressId);
        }
        else{
            mail.setSenderDisplayName(req.senderDisplayName);
			mail.setReplyTo(req.senderEmailAddress);
        }
       
        //Subject and body
        if(!String.isBlank(req.templateId)){
            mail.setTemplateId(req.templateId);
        }
        else{
            mail.setSubject(req.subject);
            mail.setHtmlBody(req.htmlBody);
            mail.setPlainTextBody(req.plainTextBody);
        }

        //Use the sender email signature
        if(req.useSignature != null){
            mail.setUseSignature(req.useSignature);
        }

        //Attachment
        if(req.fileIds != null) {
            mail.setEntityAttachments(req.fileIds);   
        }

        //Related record Id
        mail.setWhatId(req.whatId);

        //Target object record Id (Contact, Lead, User)
        mail.setTargetObjectId(req.targetObjectId);

        //Set the target object Id (Contact, Lead, User) as the recipient
        if(req.treatTargetObjectAsRecipient != null){
            mail.setTreatTargetObjectAsRecipient(req.treatTargetObjectAsRecipient);
        }

        //Save email to activity
        if(req.saveAsActivity != null){
            mail.setSaveAsActivity(req.saveAsActivity);
        }
        
        return mail;
    }
    
    /**
     * Send Email
     * @description Send email received in the param
     * @param List of Email to send
     * @return Result of sending email
     */
    private static List<ResponseParamWrapper> sendEmail(Messaging.SingleEmailMessage[] listOfEmail) {
        //Send email
        ResponseParamWrapper response = new ResponseParamWrapper();
        Messaging.SendEmailResult[] sendResults = Messaging.sendEmail(listOfEmail, true);
        
        // process the response
        response.isSuccess = sendResults[0].success;
        if (response.isSuccess) {     
            //System.debug('The email was sent successfully.'); 
            response.whatIds = new List<Id>();
            for(Messaging.SingleEmailMessage mail : listOfEmail) {
                response.whatIds.add(mail.getWhatId());
            }
        } else { 
            response.errorMessage = 'The email failed to send: ' + sendResults[0].errors[0].message;
            response.whatIds = null;
        } 

        return new List<ResponseParamWrapper> {response};
    }
}