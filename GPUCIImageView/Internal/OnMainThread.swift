import Foundation

func onMainThread(execute work: () -> Swift.Void) {
    if Thread.isMainThread {
        work()
    } else {
        DispatchQueue.main.sync(execute: work)
    }
}
