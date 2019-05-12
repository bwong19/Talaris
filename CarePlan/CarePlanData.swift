import CareKit

enum GaitTestType: String {
    case tug = "Timed Up and Go"
    case sixmwt = "Six Minute Walk Test"
    case mctsib = "Sway Test"
}

class CarePlanData: NSObject {
    private let carePlanStore: OCKCarePlanStore
    
    // dummy data
    let contacts = [OCKContact(contactType: .careTeam,
                               name: "Columbus Ohio",
                               relation: "Therapist",
                               tintColor: nil,
                               phoneNumber: CNPhoneNumber(stringValue: "888-555-5235"),
                               messageNumber: CNPhoneNumber(stringValue: "888-555-5235"),
                               emailAddress: "columbus@example.com",
                               monogram: "CO",
                               image: UIImage(named: "Contact-ON")),
                    OCKContact(contactType: .careTeam,
                               name: "Dr Hershel Greene",
                               relation: "Physician",
                               tintColor: nil,
                               phoneNumber: CNPhoneNumber(stringValue: "888-555-2351"),
                               messageNumber: CNPhoneNumber(stringValue: "888-555-2351"),
                               emailAddress: "dr.hershel@example.com",
                               monogram: "HG",
                               image: UIImage(named: "Contact-ON"))]

    
    init(carePlanStore: OCKCarePlanStore) {
        self.carePlanStore = carePlanStore
        
        let tugTest = OCKCarePlanActivity
            .assessment(withIdentifier: GaitTestType.tug.rawValue,
                        groupIdentifier: nil,
                        title: "Timed Up and Go (TUG)",
                        text: "This test measures speed",
                        tintColor: UIColor.green,
                        resultResettable: true,
                        schedule: CarePlanData.dailyScheduleRepeating(occurencesPerDay: 1), optional: false)
        
        let sixmwtTest = OCKCarePlanActivity
            .assessment(withIdentifier: GaitTestType.sixmwt.rawValue,
                        groupIdentifier: nil,
                        title: "Six Minute Walk Test (6MWT)",
                        text: "This test measures endurance",
                        tintColor: UIColor.orange,
                        resultResettable: true,
                        schedule: CarePlanData.dailyScheduleRepeating(occurencesPerDay: 1), optional: false)
        
        let mctsibTest = OCKCarePlanActivity
            .assessment(withIdentifier: GaitTestType.mctsib.rawValue,
                        groupIdentifier: nil,
                        title: "Sway Test (mCTSIB)",
                        text: "This test measures balance",
                        tintColor: UIColor.orange,
                        resultResettable: true,
                        schedule: CarePlanData.dailyScheduleRepeating(occurencesPerDay: 1), optional: false)
        
        super.init()
        
        for activity in [tugTest, sixmwtTest, mctsibTest] {
            add(activity: activity)
        }
    }
    
    class func dailyScheduleRepeating(occurencesPerDay: UInt) -> OCKCareSchedule {
        return OCKCareSchedule.dailySchedule(withStartDate: DateComponents.firstDateOfCurrentWeek,
                                             occurrencesPerDay: occurencesPerDay)
    }
    
    func add(activity: OCKCarePlanActivity) {
        // 1
        carePlanStore.activity(forIdentifier: activity.identifier) {
            [weak self] (success, fetchedActivity, error) in
            guard success else { return }
            guard let strongSelf = self else { return }
            // 2
            if let _ = fetchedActivity { return }
            
            // 3
            strongSelf.carePlanStore.add(activity, completion: { _,_  in })
        }
    }
    

    
}
