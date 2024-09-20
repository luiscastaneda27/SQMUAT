@isTest(SeeAllData=True)
public class SQM_EnviarEncuestaNPSTest {
    @isTest
    public static void test1(){
        
        Account cuenta = new Account(
          Name = 'Marcelo Cuenta Empresa 01',                            // Account Name
          Account_Date_Last_Transactions__c = System.today(),  // Account Date Last Transactions
          TaxID__c = 'qweqweqwe',                                          // TaxID
          Rating = 'C',                                                    // Rating
          CChEN_Valido__c = false,                                         // CChEN Valid
          Compliance_Status__c = 'New'                                    // Compliance Status
        );
        insert cuenta;
        
        Contact contacto = new Contact(
          AccountId = cuenta.Id,              // Account Name
          Email = 'seidor364@gmail.com',          // Email
          Account_NPS__c = 'NPS',                 // Account NPS
          LastName = 'Prueba'
        );
        insert contacto;
        
        List<Contact> lista = new List<Contact>();
        lista.add(contacto);
        List<List<Contact>> lista2 = new List<List<Contact>>();
        lista2.add(lista);
        SQM_EnviarEncuestaNPS.enviarEncuesta(lista2);
    }
}