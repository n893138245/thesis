import class Foundation.Operation
import class Foundation.OperationQueue
import class Foundation.BlockOperation
import Dispatch
public class OperationQueueScheduler: ImmediateSchedulerType {
    public let operationQueue: OperationQueue
    public let queuePriority: Operation.QueuePriority
    public init(operationQueue: OperationQueue, queuePriority: Operation.QueuePriority = .normal) {
        self.operationQueue = operationQueue
        self.queuePriority = queuePriority
    }
    public func schedule<StateType>(_ state: StateType, action: @escaping (StateType) -> Disposable) -> Disposable {
        let cancel = SingleAssignmentDisposable()
        let operation = BlockOperation {
            if cancel.isDisposed {
                return
            }
            cancel.setDisposable(action(state))
        }
        operation.queuePriority = self.queuePriority
        self.operationQueue.addOperation(operation)
        return cancel
    }
}