global class SQM_EnviarEncuestasBatch implements Database.Batchable<sObject> {
    public List<Id> listContactId;
    
    //envio
    ConnectApi.SurveyInvitationEmailInput surveyInput = new ConnectApi.SurveyInvitationEmailInput();
    List<String> emailCon;
    Survey idSurvey;
    EmailTemplate plantilla;
    OrgWideEmailAddress correo;
    Id communityId;
    List<Survey> lastsurveyList;
    
    
    public SQM_EnviarEncuestasBatch(List<Id> lista) {
		listContactId = lista;
        plantilla = [SELECT Id, Name FROM EmailTemplate WHERE Name = 'Embed_a_Survey_Link'];
        system.debug('plantilla->'+plantilla);
        correo = [SELECT Id, Address FROM OrgWideEmailAddress WHERE DisplayNaME = 'SF.ServiceCloud@sqm.com'];
        system.debug('correo->'+correo);
        communityId = [select Id from Network where Name = 'Portal SQM'].Id;
        system.debug('communityId->'+communityId);
        lastsurveyList = [SELECT Id, Name, TotalVersionsCount, ActiveVersionId FROM Survey WHERE DeveloperName = 'nps_sqm_survey_v2' order by TotalVersionsCount ASC];
        system.debug('lastsurveyList->'+lastsurveyList);
        
	}
    
    global Iterable<sObject> start(Database.BatchableContext bc) {
        return [SELECT Id, email from contact where id in :listContactId];
    }
    
    global void execute(Database.BatchableContext bc, List<contact> listaContactos) {
        //llamar a la encuesta
        
		List<String>ListContEmails = new List<String>();
        //buscar version de encuesta
        Survey lastSurvey = lastsurveyList[0];
        List<SurveyInvitation> sinvList = new List<SurveyInvitation>();
        
        for(contact obj : listaContactos){
            System.debug('id->'+obj.Id+' - mail->'+obj.email);
            ListContEmails.add(obj.Id);
            //enviar correo con encuesta y crear registro de invitación
            SurveyInvitation SInv = New SurveyInvitation();
            Sinv.CommunityId = communityId;
            SInv.Name = String.valueOf(system.today());
            SInv.OptionsCollectAnonymousResponse = false;
            SInv.OptionsAllowGuestUserResponse = true;
            SInv.SurveyId = lastSurvey.Id;
            sinvList.add(SInv);
            
        }
        insert sinvList;
        
        surveyInput.recipients = ListContEmails;
        surveyInput.isPersonalInvitation = true;
		surveyInput.fromEmailAddress = correo.Address;
        surveyInput.emailTemplateId = plantilla.Id;
        surveyInput.allowGuestUserResponse = true;
        surveyInput.allowParticipantsAccessTheirResponse = true;
        surveyInput.collectAnonymousResponse = false;
        try{
            if(!Test.isRunningTest()){
            	ConnectApi.Surveys.sendSurveyInvitationEmail(lastSurvey.Id, surveyInput);    
            }            
        }catch(Exception e){
            system.debug(e.getMessage());
            system.debug(e.getStackTraceString());
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        system.debug('Proceso finalizado');
    }
    
}