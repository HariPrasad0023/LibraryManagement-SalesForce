trigger AssignPermissionSetOnSelfRegistration on User (after insert) {
    // Define the Permission Set API Name (Update this to match your actual permission set name)
    String permissionSetName = 'Library_Community_User_Permissions';

    // Fetch the Permission Set ID
    PermissionSet permSet;
    try {
        permSet = [SELECT Id FROM PermissionSet WHERE Name = :permissionSetName LIMIT 1];
    } catch (Exception e) {
        System.debug('Error fetching Permission Set: ' + e.getMessage());
        return; // Exit if the permission set is not found
    }

    // List to store permission set assignments
    List<PermissionSetAssignment> permAssignments = new List<PermissionSetAssignment>();

    for (User u : Trigger.new) {
        // Filter only self-registered users (Update this condition if needed)
        if (u.ProfileId == [SELECT Id FROM Profile WHERE Name = 'Library Community User' LIMIT 1].Id) { 
            PermissionSetAssignment psa = new PermissionSetAssignment(
                AssigneeId = u.Id,
                PermissionSetId = permSet.Id
            );
            permAssignments.add(psa);
        }
    }

    // Assign the permission set if there are valid users
    if (!permAssignments.isEmpty()) {
        try {
            insert permAssignments;
        } catch (Exception e) {
            System.debug('Error assigning Permission Set: ' + e.getMessage());
        }
    }
}