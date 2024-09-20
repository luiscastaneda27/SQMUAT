global class SQM_LightningForgotPassController {

    @AuraEnabled
    public static String forgotPassword(String username, String checkEmailUrl) {

    	//List<User> usuarios = [SELECT Id FROM User WHERE UserName =: username AND IsActive = true];
        //System.debug('empty->'+usuarios.isEmpty());

        System.debug('username->'+username);
        System.debug('checkEmailUrl->'+checkEmailUrl);

        List<Account> cuentas = [SELECT Id FROM Account WHERE PersonEmail =: username];
        System.debug('vacio->'+cuentas.isEmpty());

    	if (!cuentas.isEmpty()){
	        try {
	            Site.forgotPassword(username);
	            ApexPages.PageReference checkEmailRef = new PageReference(checkEmailUrl);
	            if(!Site.isValidUsername(username)) {
                    System.debug(Label.Site.invalid_email);
	                return Label.Site.invalid_email;
	            }
	            aura.redirect(checkEmailRef);
	            return null;
	        }
	        catch (Exception ex) {
	            return ex.getMessage();
	        }
	    }else{
            System.debug('no hay registros');
	    	return 'La dirección de correo especificada no esta registrada. Por favor, registre su cuenta';
	    }
    }

}