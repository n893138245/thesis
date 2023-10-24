import UIKit
class SSTimeTask: NSObject {
    var id = 0
    var timerInterval = 0
    var taskBlock:((SSTimeTask)->Void)? = nil
    var isRepeat = false
    var isStop = false
    var startCount = 0
    var repeatCount = 0
    func setup(id:Int,timerInterval:Int,startCount:Int,isRepeat:Bool,action:@escaping ((SSTimeTask)->Void)) -> SSTimeTask{
        self.isStop = false
        self.id = id
        self.timerInterval = timerInterval
        self.startCount = startCount
        self.isRepeat = isRepeat
        self.repeatCount = 0
        self.taskBlock = {task in
            action(task)
        }
        return self
    }
}