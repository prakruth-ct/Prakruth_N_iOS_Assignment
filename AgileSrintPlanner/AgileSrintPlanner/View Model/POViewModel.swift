import Foundation
import Firebase
import FirebaseDatabase
import FirebaseUI

class POViewModel {
    
    private var firebase = FirebaseManager()
    var projectDetails: [ProjectDetails]?
    var projectMembers: [ProjectMembers]?
    let headings = ["Title", "Domain", "Description"]
    let sectionHeading = ["Project Description", "Product Backlogs", "Team"]
    var editCondition = false
    var projectRolePicked: String?
    
    //API Call to firebase to add a new project
    //title: Title of Project; domain: Domain of project to be worked on; descp: Small description of the project; completion: Completion Handler
    func addNewProject(title: String, domain: String, descp: String, poName: String, completion: @escaping (() -> Void)) {
        firebase.addNewProjectByPO(title: title, domain: domain, descp: descp, poName: poName, completion: completion)
    }
    
    //API Call to firebase to fetch all project detals
    //completion: Completion Handler
    func getProjectDetailsFromFM(completion: @escaping (() -> Void)) {
        var detailsArr: [ProjectDetails] = []
        firebase.getProjectDetails { [weak self] (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot],
                  let weakSelf = self else { return }

            for child in snapshot {
                let title = child.childSnapshot(forPath: Constants.FirebaseConstants.projectMembers).childSnapshot(forPath: Constants.FirebaseConstants.projectTitle).value as? String ?? ""
                let domain = child.childSnapshot(forPath: Constants.FirebaseConstants.projectMembers).childSnapshot(forPath: Constants.FirebaseConstants.projectDomain).value as? String ?? ""
                let descp = child.childSnapshot(forPath: Constants.FirebaseConstants.projectMembers).childSnapshot(forPath: Constants.FirebaseConstants.projectDescription
                    ).value as? String ?? ""
                var teamMembers: [TeamMember] = []
                guard let member = child.childSnapshot(forPath: Constants.FirebaseConstants.ProjectTable.members).children.allObjects as? [DataSnapshot] else { return }
                for eachMember in member {
                    teamMembers.append(TeamMember(name: eachMember.value as? String ?? "", role: eachMember.key))
                }
                let projectStructure = ProjectDetails(data: Data(title: title, domain: domain, descp: descp), teamMember: teamMembers)
                detailsArr.append(projectStructure)
            }
            weakSelf.projectDetails = detailsArr
            completion()
        }
    }
    
    //API Call to firebase to get project details of current user
    //email: Current signed in user; completion: Completion Handle
    func getProjectDetailsForUserWith(email: String, completion: @escaping (() -> Void)) {
        var detailsArr: [ProjectDetails] = []
        firebase.getProjectDetails { [weak self] (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot],
                let weakSelf = self else { return }
            
            for child in snapshot {
                guard let member = child.childSnapshot(forPath: Constants.FirebaseConstants.ProjectTable.members).children.allObjects as? [DataSnapshot] else { return }
                
                if weakSelf.isUserPartOfTeam(email: email, projects: child.childSnapshot(forPath: Constants.FirebaseConstants.projectMembers).childSnapshot(forPath: Constants.FirebaseConstants.projectTitle), teamMembers: member) {
                    let title = child.childSnapshot(forPath: Constants.FirebaseConstants.projectMembers).childSnapshot(forPath: Constants.FirebaseConstants.projectTitle).value as? String ?? ""
                    let domain = child.childSnapshot(forPath: Constants.FirebaseConstants.projectMembers).childSnapshot(forPath: Constants.FirebaseConstants.projectDomain).value as? String ?? ""
                    let descp = child.childSnapshot(forPath: Constants.FirebaseConstants.projectMembers).childSnapshot(forPath: Constants.FirebaseConstants.projectDescription
                        ).value as? String ?? ""
                    var teamMembers: [TeamMember] = []
                    for eachMember in member {
                        teamMembers.append(TeamMember(name: eachMember.value as? String ?? "", role: eachMember.key))
                    }
                    let projectStructure = ProjectDetails(data: Data(title: title, domain: domain, descp: descp), teamMember: teamMembers)
                    detailsArr.append(projectStructure)
                }
            }
            weakSelf.projectDetails = detailsArr
            completion()
        }
    }
    
    //Function to check if user is part of a team
    //email: Current User; projects: List of all projects; teamMembers: all Team members of the project
    func isUserPartOfTeam(email: String, projects: DataSnapshot, teamMembers: [DataSnapshot]) -> Bool {
        for member in teamMembers {
            if member.value as? String == email {
                return true
            }
        }
        return false
    }
    
    func updateDetailsOfProject(title: String, updateDetails: [String], members: [String : String], completion: @escaping (() -> Void)) {
        firebase.updateDetailsOfProject(projectName: title, updates: updateDetails, members: members, completion: completion)
    }
    
    /// Removes the project from firebase table
    ///
    /// - Parameter projectName: name of project
    func removeProject(projectName: String) {
        firebase.deleteChild(name: projectName)
    }
    
    func addNewTeamMember(projectName: String, teamMember: [String : String], completion: @escaping (() -> Void)) {
        firebase.addNewTeamMemberToProject(projectName: projectName, member: teamMember, completion: completion)
    }
    
    func addDeveloper(projectName: String, teamMember: [String : String], completion: @escaping (() -> Void)) {
        firebase.addNewDeveloper(projectName: projectName, member: teamMember, completion: completion)
    }
}
