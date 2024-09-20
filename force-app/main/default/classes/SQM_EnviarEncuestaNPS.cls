public class SQM_EnviarEncuestaNPS {
    
    @InvocableMethod(label = 'enviarEncuesta')
	public static void enviarEncuesta(List<List<Contact>> listContactos) {
        List<Id> listContactId = new List<Id>();
        for(List<Contact> listObj : listContactos){
			for(Contact obj : listObj){
                listContactId.add(obj.Id);
            }
        }
		SQM_EnviarEncuestasBatch encuesta = new SQM_EnviarEncuestasBatch(listContactId);
		Id batchId = Database.executeBatch(encuesta);
	}

}