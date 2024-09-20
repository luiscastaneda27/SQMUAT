@isTest
private class AsignacionCasoComunidad_Test {
	
	@isTest static void test_method_one() {
		
		Id tipoCuenta = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
		Id tipoContacto = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contacto Comunidad').getRecordTypeId();
		Id tipoCaso = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Comunidad').getRecordTypeId();
		//Id tipoOtroCaso = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Others').getRecordTypeId();

		Account cuentaTest = new Account();
		cuentaTest.RecordTypeId = tipoCuenta;
		cuentaTest.FirstName = 'Nombre';
		cuentaTest.LastName = 'Apellido';
		cuentaTest.PersonEmail = 'correo@correo.cl';
		insert cuentaTest;

		Case casoTest = new Case();
		casoTest.Subject = 'Test';
		casoTest.Description = 'Test';
		casoTest.AccountId = cuentaTest.Id;
		casoTest.Telefono_movil__c = '12345678';
		casoTest.Pais__c = 'Chile';
		insert casoTest;

	}
	
}