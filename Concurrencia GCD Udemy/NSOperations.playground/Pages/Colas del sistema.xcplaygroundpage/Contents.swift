import UIKit
import PlaygroundSupport


// El sistema tiene dos colas: la current o actual, y la main o principal (donde se ejecuta la interfaz de usuario)
// Veamos un ejemplo con un activityIndicator dentro de un viewcontroller, que simplemente muestra la ruedita dando vueltas
// Añadiremos un sleep que pare el proceso, pero afecta a la vista principal así que hay que hacerlo en el hilo principal

class ViewController: UIViewController {
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
        operacion()
    }
    
    func operacion() {
        let queue = OperationQueue.current
        let blockOperation = BlockOperation { [weak self] in
            sleep(10)
            OperationQueue.main.addOperation {
                self?.activityIndicator.stopAnimating()
            }
        }
        queue?.addOperation(blockOperation)
    }
}

PlaygroundPage.current.liveView = ViewController()
