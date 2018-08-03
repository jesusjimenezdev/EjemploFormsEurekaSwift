import UIKit
import Eureka
import CoreLocation

class ViewController: FormViewController {
    
    var usuario: String = ""
    var password: String = ""
    var fecha: Date? = nil
    var telefono: String = ""
    var genero: String = ""
    var opcion: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section("Registro") // Creacion de un formulario
            <<< TextRow() { row in
                row.title = "Usuario"
                row.placeholder = "Nombre de usuario"
                }.onChange({ (row) in
                    self.usuario = row.value!
                })
        
            <<< PasswordRow() { row in
                row.title = "Password"
                row.placeholder = "Password"
                }.onChange({ (row) in
                    self.password = row.value!
                })
        
            <<< DateRow() {
                $0.title = "Fecha de nacimiento"
                $0.value = Date()
                }.onChange({ (row) in
                    self.fecha = row.value!
                })
        
        +++ Section("Datos personales") // Creamos otra seccion dentro del formulario
        
            <<< PhoneRow() {
                $0.title = "Teléfono"
                $0.placeholder = "Escribe tu movil"
                }.onChange({ (row) in
                    self.telefono = row.value!
                })
        
            <<< PushRow<String>() {
                $0.title = "Género"
                $0.options = ["Femenino", "Masculino", "Otro"]
                $0.value = "Vacío"
                $0.selectorTitle = "Selecciona una opción"
                }.onChange({ (row) in
                    self.genero = row.value!
                })
        
            <<< CheckRow() { row in
                row.title = "Opcion"
                row.value = true
                }.onChange({ (row) in
                    self.opcion = row.value!
                })
            
            <<< ActionSheetRow<String>() {
                $0.title = "ActionSheetRow"
                $0.selectorTitle = "Elige un número"
                $0.options = ["Uno","Dos","Tres"]
                $0.value = "Uno"
            }
            
            <<< ImageRow(){
                $0.title = "ImageRow"
            }
            
            <<< LocationRow(){
                $0.title = "LocationRow"
                $0.value = CLLocation(latitude: -34.91, longitude: -56.1646)
            }
                    
        +++ Section("") // Creamos otra seccion dentro del formulario
        
            <<< ButtonRow { row in
                row.title = "Guardar"
                }.onCellSelection({ (cell, row) in
                    print("Usuario: \(self.usuario) - Password: \(self.password) - Fecha: \(String(describing: self.fecha!))")
                })
        
        form +++
            MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
                               header: "Múltiples TextField",
                               footer: "Agrega una nueva fila con un nuevo item al final") {
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Añadir nuevo elemento"
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow() {
                                        $0.placeholder = "Nombre del elemento"
                                    }
                                }
                                $0 <<< NameRow() {
                                    $0.placeholder = "Nombre del elemento"
                                }
        }
        
        // Ocultando y mostrando elementos
        form +++ Section()
            <<< SwitchRow("switchRowTag"){
                $0.title = "Mostrar mensaje"
            }
            <<< LabelRow(){
                
                $0.hidden = Condition.function(["switchRowTag"], { form in
                    return !((form.rowBy(tag: "switchRowTag") as? SwitchRow)?.value ?? false)
                })
                $0.title = "Switch esta activo!"
        }
        
            <<< SegmentedRow<String>("segments"){
                $0.options = ["Deporte", "Musica", "Peliculas"]
                $0.value = "Peliculas"
            }
            +++ Section(){
                $0.tag = "deporte_s"
                $0.hidden = "$segments != 'Deporte'" // .Predicate(NSPredicate(format: "$segments != 'Sport'"))
            }
            <<< TextRow(){
                $0.title = "¿Cual es tu jugador de futbol favorito?"
                //$0.cell.titleLabel?.font = UIFont(name: "San Francisco", size: 10.0)
            }
            
            <<< TextRow(){
                $0.title = "¿Cual es tu entrenador favorito?"
            }
            
            <<< TextRow(){
                $0.title = "¿Cual es tu equipo favorito?"
            }
            
            +++ Section(){
                $0.tag = "musica_s"
                $0.hidden = "$segments != 'Musica'"
            }
            <<< TextRow(){
                $0.title = "¿Cual es tu estilo de musica?"
            }
            
            <<< TextRow(){
                $0.title = "¿Cuál es tu cantante favorito?"
            }
            <<< TextRow(){
                $0.title = "¿Cuántos cds tienes?"
            }
            
            +++ Section(){
                $0.tag = "peliculas_s"
                $0.hidden = "$segments != 'Peliculas'"
            }
            <<< TextRow(){
                $0.title = "¿Cuál es tu actor favorito?"
            }
            
            <<< TextRow(){
                $0.title = "¿Cuál es tu película favorita?"
            }
            
            +++ Section()
            
            <<< SwitchRow("Mostrar fila siguiente"){
                $0.title = $0.tag
            }
            <<< SwitchRow("Mostrar la siguiente sección"){
                $0.title = $0.tag
                $0.hidden = .function(["Mostrar fila siguiente"], { form -> Bool in
                    let row: RowOf<Bool>! = form.rowBy(tag: "Mostrar fila siguiente")
                    return row.value ?? false == false
                })
            }
            
            +++ Section(footer: "Esta sección se muestra solo cuando el interruptor 'Mostrar fila siguiente' está habilitado"){
                $0.hidden = .function(["Mostrar la siguiente sección"], { form -> Bool in
                    let row: RowOf<Bool>! = form.rowBy(tag: "Mostrar la siguiente sección")
                    return row.value ?? false == false
                })
            }
            <<< TextRow() {
                $0.placeholder = "Voy a desaparecer pronto!"
        }

    }
}

