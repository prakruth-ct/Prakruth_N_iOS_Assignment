enum Roles: String {
    case developer = "dev"
    case projectManager = "PM"
    case productOwner = "PO"
}

class Constants {
    struct  UserDefaults {
        static let currentUser = "currentUser"
        static let role = "role"
    }
    
    struct  StickiesColor {
        static let yellow = ""
        static let blue = ""
        static let green = ""
        static let pink = ""
        static let purple = ""
        static let grey = ""
    }
    
    struct ProjectDescription {
        static let rowsInDescription = 3
        static let numberOfSections = 3
        static let rowsInBacklogs = 1
        static let rowsInTeam = 1
        enum Sections: Int {
            case description = 0
            case backlogs = 1
            case team = 2
        }
    }
}
