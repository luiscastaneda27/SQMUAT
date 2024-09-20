global class RegistrationHandler {
    
    public static User createPortalUser(Auth.UserData data){
    
        //We have a community id, so create a user with community access
        //TODO: Get an actual account
        RecordType recordPersona = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount'];
        //Account a = [SELECT Id FROM account WHERE name='Burlington Textiles Corp of America' Limit 1];
        //Contact c = new Contact();
        //c.accountId = a.Id;
        //c.email = data.email;
        //c.firstName = data.firstName;
        //c.lastName = data.lastName;
        //insert(c);
        List<Profile> IdAdmin = [SELECT Id,Name FROM Profile WHERE Name = 'System Administrator' OR Name = 'Administrador del sistema'];
        User propietario = [SELECT Id FROM User WHERE ProfileId =: IdAdmin[0].Id AND IsActive=true LIMIT 1];

        Account nuevaCuenta = new Account();
        nuevaCuenta.RecordTypeId = recordPersona.Id;
        nuevaCuenta.FirstName = data.firstName;
        nuevaCuenta.LastName = data.lastName;
        nuevaCuenta.PersonEmail = data.email;
        nuevaCuenta.OwnerId = propietario.Id;
        insert(nuevaCuenta);

        Contact contactoNuevaCuenta = [SELECT Id FROM Contact WHERE AccountId =: nuevaCuenta.Id];

        System.debug('&&&& data \n '+data);
        User u = new User();
        Profile p = [SELECT Id FROM profile WHERE name='SQM Comunidad'];
        u.username = data.email;
        //u.username = data.email.substringBefore('@') + '@comunidad.com.sbxcs';
        u.email = data.email;
        u.lastName = data.lastName;
        u.firstName = data.firstName;
        String alias = data.email.substringBefore('@');
        //Alias must be 8 characters or less
        if(alias.length() > 8) {
            alias = alias.substring(0, 8);
        }
        u.alias = alias;
        u.languagelocalekey = 'es';
        u.localesidkey = 'es_CL';
        u.emailEncodingKey = 'UTF-8';
        u.timeZoneSidKey = 'America/Santiago';
        u.profileId = p.Id;
        //u.contactId = nuevaCuenta.PersonContact.Id;
        u.contactId = contactoNuevaCuenta.Id;

        return u;
    }
    
    public static User createUser(Auth.UserData data){
        //This is not a community, so create a regular standard user
        User u = new User();
        Profile p = [SELECT Id FROM profile WHERE name='Standard User'];
        
        u.username = data.email;
        //u.username = data.email.subStringBefore('@') + '@comunidad.com.sbxcs';
        u.email = data.email;
        u.lastName = data.lastName;
        u.firstName = data.firstName;
        String alias = u.username;
        //Alias must be 8 characters or less
        if(alias.length() > 8) {
            alias = alias.substring(0, 8);
        }
        u.alias = alias;
        u.languagelocalekey = 'es';
        u.localesidkey = 'es_CL';
        u.emailEncodingKey = 'UTF-8';
        u.timeZoneSidKey = 'America/Santiago';
        u.profileId = p.Id;
        
        return u;
    }
    
}