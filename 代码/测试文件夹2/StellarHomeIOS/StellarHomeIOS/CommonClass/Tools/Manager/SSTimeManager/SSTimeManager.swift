import UIKit
class SSTimeManager: NSObject {
    static let shared = SSTimeManager.init()
    let disposeBag = DisposeBag()
    var secoundsCount = 0
    let gcdTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
    var enterBackGroupDate:Date?
    lazy var sendFeedbackCountDownTask:SSTimeTask = {
        let downTask = SSTimeManager.shared.addTaskWith(timeInterval: 1, isRepeat: true, action: { task in
            if task.repeatCount >= 60{
                task.isStop = true
                task.repeatCount = 0
            }
        })
        downTask.isStop = true
        return downTask
    }()
    var taskArray = [SSTimeTask]()
    private var currentId = -1
    override init() {
        super.init()
        setupTimer()
        NotificationCenter.default.rx.notification (UIApplication.willResignActiveNotification)
            .subscribe({ [weak self] (nitify) in
                self?.enterBackGroupDate = Date()
        }).disposed(by: disposeBag)
        NotificationCenter.default.rx.notification (UIApplication.didBecomeActiveNotification)
            .subscribe({ [weak self] (nitify) in
                if self?.enterBackGroupDate != nil{
                    let backgroundTime = Date().timeIntervalSince(self?.enterBackGroupDate ?? Date())
                    for task in self?.taskArray ?? [SSTimeTask](){
                        if task.isStop == false{
                            let addCount = Int(backgroundTime) / task.timerInterval
                            task.repeatCount += addCount
                        }
                    }
                }
        }).disposed(by: disposeBag)
    }
    func setupTimer(){
        gcdTimer.schedule(deadline: .now(), repeating: .seconds(1))
        gcdTimer.setEventHandler(handler: {
            DispatchQueue.main.async {
                self.secoundsCount += 1
                self.doAllTask()
            }
        })
        gcdTimer.resume()
    }
    func doAllTask(){
        for task in taskArray {
            if taskNeedToBeDone(task: task){
                task.repeatCount += 1
                task.taskBlock?(task)
            }
            if task != sendFeedbackCountDownTask{
                if task.repeatCount >= 1 && task.isRepeat == false{
                    taskArray = taskArray.filter({ (remTask) -> Bool in
                        if remTask == task{
                            return false
                        }else{
                            return true
                        }
                    })
                }
            }
        }
    }
    func taskNeedToBeDone(task:SSTimeTask) -> Bool{
        if task.isStop == true{
            return false
        }
        let taskSetupTimeCount = secoundsCount - task.startCount
        if taskSetupTimeCount < 0 {
            return false
        }
        if taskSetupTimeCount % task.timerInterval == 0 {
            return true
        }else{
            return false
        }
    }
    func addTaskWith(timeInterval:Int,isRepeat:Bool,action:@escaping (SSTimeTask) -> Void) -> SSTimeTask{
        let newTask = SSTimeTask().setup(id: currentId, timerInterval: timeInterval, startCount:secoundsCount , isRepeat: isRepeat, action: action)
        taskArray.append(newTask)
        return newTask
    }
    func removeTask(task:SSTimeTask){
        taskArray = taskArray.filter{$0 != task}
    }
    func removeTask(id:Int){
        taskArray = taskArray.filter{$0.id != id}
    }
    func removeAllTasks(){
        taskArray.removeAll()
    }
}