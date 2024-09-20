@isTest
private class SQM_LightningComunidadTest {

	// test auto registro
	
	@isTest static void test_method_one() {
		// todos los datos correctos

		String nombre ='Nombre';
		String apellido = 'Apellido';
		String email = 'correo@correo.test';
		String password = '123456';
		String confirma = '123456';
		String cuenta = '';
		String urlFin = '';
		String camposEx = null;
		String urlInicio = '';
		Boolean incluyePass = true;
        string language = 'Spanish';

		String resultado = SQM_LightningSelfRegController.selfRegister(nombre,apellido,email,password,confirma,cuenta,urlFin,camposEx,urlInicio,incluyePass,language);

		System.debug('resultado->'+resultado);
	}

	@isTest static void test_method_two() {
		// sin apellidos

		String nombre ='Nombre';
		String apellido = '';
		String email = 'correo@correo.test';
		String password = '123456';
		String confirma = '123456';
		String cuenta = '';
		String urlFin = '';
		String camposEx = null;
		String urlInicio = '';
		Boolean incluyePass = false;
        string language = 'Spanish';

		String resultado = SQM_LightningSelfRegController.selfRegister(nombre,apellido,email,password,confirma,cuenta,urlFin,camposEx,urlInicio,incluyePass,language);
		System.debug('resultado->'+resultado);
	}

	@isTest static void test_method_three() {
		// cuenta ya existe

		Id tipoCuenta = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
		Id tipoContacto = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contacto Comunidad').getRecordTypeId();

		Account cuentaPersona = new Account();
		cuentaPersona.FirstName = 'Nombre';
		cuentaPersona.LastName = 'Apellido';
		cuentaPersona.PersonEmail = 'correo@correo.test';
		insert cuentaPersona;

		String nombre ='Nombre';
		String apellido = 'Apellido';
		String email = 'correo@correo.test';
		String password = '123456ABC';
		String confirma = '123456ABC';
		String cuenta = '';
		String urlFin = '';
		String camposEx = null;
		String urlInicio = '';
		Boolean incluyePass = false;
        string language = 'Spanish';

		String resultado = SQM_LightningSelfRegController.selfRegister(nombre,apellido,email,password,confirma,cuenta,urlFin,camposEx,urlInicio,incluyePass,language);

		System.debug('resultado->'+resultado);
	}

	@isTest static void test_method_four() {
		// sin correo

		String nombre ='Nombre';
		String apellido = 'Apellido';
		String email = '';
		String password = '123456';
		String confirma = '123456';
		String cuenta = '';
		String urlFin = '';
		String camposEx = null;
		String urlInicio = '';
		Boolean incluyePass = false;
        String language = 'Spanish';

		String resultado = SQM_LightningSelfRegController.selfRegister(nombre,apellido,email,password,confirma,cuenta,urlFin,camposEx,urlInicio,incluyePass,language);

		System.debug('resultado->'+resultado);
	}

	@isTest static void test_method_five() {
		// incluye password

		String nombre ='Nombre';
		String apellido = 'Apellido';
		String email = 'correo@especial.test';
		String password = '123456';
		String confirma = '123456';
		String cuenta = '';
		String urlFin = '';
		String camposEx = null;
		String urlInicio = '';
		Boolean incluyePass = true;
        String language = 'Spanish';

		String resultado = SQM_LightningSelfRegController.selfRegister(nombre,apellido,email,password,confirma,cuenta,urlFin,camposEx,urlInicio,incluyePass,language);
        SQM_LightningSelfRegController controller = new SQM_LightningSelfRegController();
		System.debug('resultado->'+resultado);
	}
    
	@isTest static void test_method_six() {
		// incluye password distintas

		String nombre ='Nombre';
		String apellido = 'Apellido';
		String email = 'correo@especial.test';
		String password = '123456';
		String confirma = '1234567';
		String cuenta = '';
		String urlFin = '';
		String camposEx = null;
		String urlInicio = '';
		Boolean incluyePass = true;
        String language = 'Spanish';

		String resultado = SQM_LightningSelfRegController.selfRegister(nombre,apellido,email,password,confirma,cuenta,urlFin,camposEx,urlInicio,incluyePass,language);
		System.debug('resultado->'+resultado);
	}

	// test olvide password

	@isTest static void test_method_seven() {
		// sin cuenta

		String usuario ='correo@correo.test';
		String urlCheck = 'www';

		String resultado = SQM_LightningForgotPassController.forgotPassword(usuario,urlCheck);
		System.debug('resultado->'+resultado);
	}

	@isTest static void test_method_eight() {
		// con cuenta

		Id tipoCuenta = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
		Id tipoContacto = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contacto Comunidad').getRecordTypeId();

		Account cuentaPersona = new Account();
		cuentaPersona.FirstName = 'Nombre';
		cuentaPersona.LastName = 'Apellido';
		cuentaPersona.PersonEmail = 'correo@correo.test';
		insert cuentaPersona;

		String usuario ='correo@correo.test';
		String urlCheck = 'www';

		String resultado = SQM_LightningForgotPassController.forgotPassword(usuario,urlCheck);
		System.debug('resultado->'+resultado);
	}

	@isTest static void test_method_nine() {
		// usuario erroneo

		String usuario ='correo@correo,test';
		String urlCheck = 'www';

		String resultado = SQM_LightningForgotPassController.forgotPassword(usuario,urlCheck);
		System.debug('resultado->'+resultado);
	}
    
    @isTest static void test_method_ten() {
		// incluye password

		String nombre ='Nombre';
		String apellido = 'Apellido';
		String email = 'correo@especial.test';
		String password = '123456';
		String confirma = '123456';
		String cuenta = '';
		String urlFin = '';
		String camposEx = null;
		String urlInicio = '';
		Boolean incluyePass = false;
        String language = 'Spanish';

		String resultado = SQM_LightningSelfRegController.selfRegister(nombre,apellido,email,password,confirma,cuenta,urlFin,camposEx,urlInicio,incluyePass,language);
        SQM_LightningSelfRegController controller = new SQM_LightningSelfRegController();
		System.debug('resultado->'+resultado);
	}
 
    @isTest static void test_method_eleven() {
		// incluye password
		
		String nombre ='Nombre';
		String apellido = 'Apellido';
		String email = 'correo@especial.test';
		String password = '123456';
		String confirma = '123456';
		String cuenta = '';
		String urlFin = '';
        //String camposEx = '{"data": [{"s": "a", "i": 1}]}';
		String camposEx = '';
		
		List<Map<String,Object>> extraFields = new List<Map<String,Object>>();
        Schema.FieldSet fieldSet = Schema.SObjectType.User.fieldSets.getMap().get('Idioma');
        if (fieldSet != null) {
            for (Schema.FieldSetMember f : fieldSet.getFields()) {
                Map<String, Object> fieldDetail = new Map<String, Object>();
                fieldDetail.put('dbRequired', f.getDBRequired());
                fieldDetail.put('fieldPath', f.getFieldPath());
                fieldDetail.put('label', f.getLabel());
                fieldDetail.put('required', f.getRequired());
                fieldDetail.put('type', f.getType());
                fieldDetail.put('value', '');   // client will populate
                extraFields.add(fieldDetail);
        }}
		camposEx=JSON.serialize(extraFields);
		String urlInicio = '';
		Boolean incluyePass = false;
        String language = 'Spanish';

		String resultado = SQM_LightningSelfRegController.selfRegister(nombre,apellido,email,password,confirma,cuenta,urlFin,camposEx,urlInicio,incluyePass,language);
        SQM_LightningSelfRegController controller = new SQM_LightningSelfRegController();
		System.debug('resultado->'+resultado);
	}

	@isTest static void test_method_twelve() {
		List<Map<String,Object>> extraFields = SQM_LightningSelfRegController.getExtraFields('Idioma');
		System.assertEquals(true, extraFields.size() > 0);
	}

}