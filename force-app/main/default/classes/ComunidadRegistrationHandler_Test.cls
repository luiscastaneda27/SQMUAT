@isTest
private class ComunidadRegistrationHandler_Test {
	static testMethod void testCreateAndUpdateUser() {

		ComunidadRegistrationHandler handler = new ComunidadRegistrationHandler();

		Auth.UserData sampleData = new Auth.UserData('testId', 'testFirst', 'testLast',
		'testFirst testLast', 'testuser2021@example.org', null, 'testuserlong', 'en_US', 'facebook',
		null, new Map<String, String>{'language' => 'en_US'});

		User u = handler.createUser(null, sampleData);

		System.assertEquals('testuser2021@example.org', u.userName);
		System.assertEquals('testuser2021@example.org', u.email);
		System.assertEquals('testLast', u.lastName);
		System.assertEquals('testFirst', u.firstName);
		System.assertEquals('testuser', u.alias);
		insert(u);
		
		String uid = u.id;

		sampleData = new Auth.UserData('testNewId', 'testNewFirst', 'testNewLast',
		'testNewFirst testNewLast', 'testuser2021@example.org', null, 'testnewuserlong', 'en_US', 'facebook',
		null, new Map<String, String>{});

		handler.updateUser(uid,null, sampleData);

		User updatedUser = [SELECT userName, email, firstName, lastName, alias FROM user WHERE id=:uid];

		System.assertEquals('testuser2021@example.org', updatedUser.userName);
		System.assertEquals('testuser2021@example.org', updatedUser.email);
		System.assertEquals('testLast', updatedUser.lastName);
		System.assertEquals('testFirst', updatedUser.firstName);
		System.assertEquals('testuser', updatedUser.alias);
	}

	static testMethod void testCreateAndUpdateUser2() {

		ComunidadRegistrationHandler handler = new ComunidadRegistrationHandler();

		Auth.UserData sampleData = new Auth.UserData('testId', 'testFirst', 'testLast',
		'testFirst testLast', 'testuser2021@example.org', null, 'testuserlong', 'en_US', 'google',
		null, new Map<String, String>{'language' => 'en_US'});

		User u = handler.createUser(null, sampleData);

		System.assertEquals('testuser2021@example.org', u.userName);
		System.assertEquals('testuser2021@example.org', u.email);
		System.assertEquals('testLast', u.lastName);
		System.assertEquals('testFirst', u.firstName);
		System.assertEquals('testuser', u.alias);
		insert(u);
		
		String uid = u.id;

		sampleData = new Auth.UserData('testNewId', 'testNewFirst', 'testNewLast',
		'testNewFirst testNewLast', 'testuser2021@example.org', null, 'testnewuserlong', 'en_US', 'google',
		null, new Map<String, String>{});

		handler.updateUser(uid,null, sampleData);

		User updatedUser = [SELECT userName, email, firstName, lastName, alias FROM user WHERE id=:uid];

		System.assertEquals('testuser2021@example.org', updatedUser.userName);
		System.assertEquals('testuser2021@example.org', updatedUser.email);
		System.assertEquals('testLast', updatedUser.lastName);
		System.assertEquals('testFirst', updatedUser.firstName);
		System.assertEquals('testuser', updatedUser.alias);
	}

	static testMethod void testCreateAndUpdateUser3() {

		ComunidadRegistrationHandler handler = new ComunidadRegistrationHandler();

		Id IdPortal = [SELECT Id,Name FROM Site WHERE Name = 'Portal_SQM'].Id;

		Auth.UserData sampleData = new Auth.UserData('testId', 'testFirst', 'testLast',
		'testFirst testLast', 'testuser2021@example.org', null, 'testuserlong', 'en_US', 'google',
		null, new Map<String, String>{'language' => 'en_US','sfdc_networkid'=>IdPortal});

		User u = handler.createUser(IdPortal, sampleData);

		System.assertEquals('testuser2021@example.org', u.userName);
		System.assertEquals('testuser2021@example.org', u.email);
		System.assertEquals('testLast', u.lastName);
		System.assertEquals('testFirst', u.firstName);
		System.assertEquals('testuser', u.alias);
		insert(u);
		
		String uid = u.id;

		sampleData = new Auth.UserData('testNewId', 'testNewFirst', 'testNewLast',
		'testNewFirst testNewLast', 'testuser2021@example.org', null, 'testnewuserlong', 'en_US', 'google',
		null, new Map<String, String>{});

		handler.updateUser(uid,null, sampleData);

		User updatedUser = [SELECT userName, email, firstName, lastName, alias FROM user WHERE id=:uid];

		System.assertEquals('testuser2021@example.org', updatedUser.userName);
		System.assertEquals('testuser2021@example.org', updatedUser.email);
		System.assertEquals('testLast', updatedUser.lastName);
		System.assertEquals('testFirst', updatedUser.firstName);
		System.assertEquals('testuser', updatedUser.alias);
	}
}