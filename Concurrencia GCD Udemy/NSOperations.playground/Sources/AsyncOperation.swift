import Foundation

// Creamos enum para controlar la máquina de estados
public enum State: String {
    //lo hacemos public para que sea accesible desde otros ficheros
    case Ready, Executing, Finished
    
    fileprivate var keyPath: String {
        return "is" + rawValue
    }
}

open class AsyncOperation: Operation {
    //la hacemos open para que sea pública y además permita sobrecargar los métodos
    public var state = State.Ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    open override var isReady: Bool {
        super.isReady && state == .Ready
    }
    
    open override var isExecuting: Bool {
        state == .Executing
    }
    
    open override var isFinished: Bool {
        state == .Finished
    }
    
    open override var isAsyncronous: Bool {
        true
    }
    
    open override func start() {
        if isCancelled {
            state = .Finished
            return
        }
        main()
        state = .Executing
    }
    
    open override func cancel() {
        state = .Finished
    }
}
