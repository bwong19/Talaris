import CareKit

enum GaitTest: String {
    case tug = "Timed Up and Go"
    case sixmwt = "Six Minute Walk Test"
    case mctsib = "Sway Test"
}

class CarePlanData: NSObject {
    let carePlanStore: OCKCarePlanStore
    
    init(carePlanStore: OCKCarePlanStore) {
        self.carePlanStore = carePlanStore
        
        let tugTest = OCKCarePlanActivity
            .assessment(withIdentifier: GaitTest.tug.rawValue,
                        groupIdentifier: nil,
                        title: "Timed Up and Go (TUG)",
                        text: "This test measures speed",
                        tintColor: UIColor.green,
                        resultResettable: true,
                        schedule: CarePlanData.dailyScheduleRepeating(occurencesPerDay: 1), optional: false)
        
        let sixmwtTest = OCKCarePlanActivity
            .assessment(withIdentifier: GaitTest.sixmwt.rawValue,
                        groupIdentifier: nil,
                        title: "Six Minute Walk Test (6MWT)",
                        text: "This test measures endurance",
                        tintColor: UIColor.orange,
                        resultResettable: true,
                        schedule: CarePlanData.dailyScheduleRepeating(occurencesPerDay: 1), optional: false)
        
        let mctsibTest = OCKCarePlanActivity
            .assessment(withIdentifier: GaitTest.mctsib.rawValue,
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
