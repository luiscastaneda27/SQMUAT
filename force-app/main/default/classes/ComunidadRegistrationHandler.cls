global class ComunidadRegistrationHandler implements Auth.RegistrationHandler {


    global User createUser(Id portalId, Auth.UserData data){
        
        String userName = data.email;//.subStringBefore('@') + '@comunidad.com.sbxcs';
        String partnerUserName = data.email;//.subStringBefore('@') + '@comunidad.com.sbxcs';
        
        List<User> userList = [Select Id, Name, Email, UserName From User 
                                      Where ( UserName =: userName OR UserName =: partnerUserName)
                                      AND isActive = true
                                      ];
        User user = new User();
        
        //Sync the user's picture
        String pictureUrl = null;
        if (data.provider == 'Facebook') {
            pictureUrl = 'https://graph.facebook.com/' + data.identifier + '/picture?type=large';
        } else {
            pictureUrl = data.attributeMap.get('picture');
        }
        
        if(userList != null && userList.size() > 0){
            user = userList.get(0);
            return user;
        } else {
            
            if(data.attributeMap.containsKey('sfdc_networkid')) {
                String communityId = data.attributeMap.get('sfdc_networkid');
                // Portal User
                User u = RegistrationHandler.createPortalUser(data);
                
                return u;
            } else {
                // Regular User
                User u = RegistrationHandler.createUser(data);
                
                return u;
            }
        }
    }


    global void updateUser(Id userId, Id portalId, Auth.UserData data){
        
        List<User> userList = [Select Id, Name, Email, UserName From User Where Id =: userId AND isActive = true];
        User u = new User();
        if(userList != null && userList.size() > 0){
            u = userList.get(0);
        }
    }
}