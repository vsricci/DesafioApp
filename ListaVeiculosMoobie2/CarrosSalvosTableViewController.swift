//
//  CarrosSalvosTableViewController.swift
//  ListaVeiculosMoobie2
//
//  Created by Joel Sene on 24/08/17.
//  Copyright © 2017 Vinicius Santos Ricci. All rights reserved.
//

import UIKit
import CoreData
class CarrosSalvosTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var listaCarrosSalvos = [Carro]()
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var semDados : UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        verifica()
        
            }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let indexPath = tableView?.indexPathForSelectedRow {
            tableView?.deselectRow(at: indexPath, animated: animated)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60

        navigationItem.title = "Carros Salvos"
        let seletorVerCarros : Selector = #selector(verCarros)
        let seletorPerfil : Selector = #selector(verPerfil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "imageCarro"), style: .plain, target: self, action: seletorVerCarros)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "imagePerfil"), style: .plain, target: self, action: seletorPerfil)
        navigationController?.navigationBar.tintColor = UIColor.black
        
        mostrarDados()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listaCarrosSalvos.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! CarroSalvoTableViewCell

        
        
        cell.modeloLabel.text = listaCarrosSalvos[indexPath.row].modelo
        cell.botaoExcluir.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.teste(_:))))
        

        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = listaCarrosSalvos[indexPath.row]
        
        irParaDetalhesSalvos(item: item)
    }
    
    func irParaDetalhesSalvos(item : Carro) {
        
        let detalhesSalvosVC =  UIStoryboard(name: "DetalheVeiculoSalvo", bundle: nil).instantiateViewController(withIdentifier: "detalheVeiculoSalvoController") as! DetalheVeiculoSalvoViewController
        
        detalhesSalvosVC.listaDetalhesSalvos = item
        
        self.navigationController?.pushViewController(detalhesSalvosVC, animated: true)
        
    }
    
    
    func mostrarDados() {
        
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if #available(iOS 10.0, *) {
            let context = appDelegate.persistentContainer.viewContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CarrosSalvos")
            request.returnsObjectsAsFaults = false
            
            do{
                let results = try context.fetch(request)
                
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject]
                    {
                        //let chave = result.value(forKey: "chaveIntegracao") as? String
                        let codigoFibe = result.value(forKey: "codigoFibe") as? String
                        let marca = result.value(forKey: "marca") as? String
                        let modelo = result.value(forKey: "modelo") as? String
                        let valor = result.value(forKey: "valor") as? String
                        let taxa = result.value(forKey: "taxa") as? String
                        let ano = result.value(forKey: "ano") as? String
                        
                        
                        let carroSalvo = Carro()
                        
                        carroSalvo.modelo = modelo
                        carroSalvo.ano = ano
                        carroSalvo.marca = marca
                        carroSalvo.taxa = Int(taxa!)
                        carroSalvo.valor = Int(valor!)
                        carroSalvo.codigo = codigoFibe
                        
                        //DispatchQueue.main.async {
                        
                        self.listaCarrosSalvos.append(carroSalvo)
                        tableView.reloadData()
                        
                        // verifica()
                        
                        //    }
                        
                        
                        
                        
                        
                        
                    }
                }
                
            }
            catch{
                
                
            }
        }
            
        else {
            
            let context = appDelegate.managedObjectContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CarrosSalvos")
        }
    }
    
    
    
    func teste(_ sender: UITapGestureRecognizer) {
        
        
        let touch = sender.location(in: tableView)
        
        if let indexPath = tableView.indexPathForRow(at: touch) {
            
            let itens = listaCarrosSalvos[indexPath.row]
            
            
            excluirDadosSalvos(carro: itens.modelo)
            
        }
        
    }
    
    func verifica() {
        
        
        if listaCarrosSalvos.count > 0 {
            
            tableView.isHidden = false
            semDados.isHidden = true
        }
            
        else {
            
           tableView.isHidden = true
        semDados.isHidden = false
        }
        
        
        
    }
    
    func verCarros() {
        
        let marcaModeloVC = UIStoryboard(name: "MarcaModelo", bundle: nil).instantiateViewController(withIdentifier: "marcaModeloController") as! MarcaModeloViewController
        
        self.navigationController?.pushViewController(marcaModeloVC, animated: true)
        
    }
    
    func excluirDadosSalvos(carro: String){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if #available(iOS 10.0, *) {
            let context = appDelegate.persistentContainer.viewContext
            
            
            
            
            let moc = context
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CarrosSalvos")
            // let fetchRequest : NSFetchRequest<CarrosSalvos> = CarrosSalvos.fetchRequest()
            
            
            fetchRequest.predicate = NSPredicate.init(format: "modelo beginswith[c] %@", "\(carro)")
            fetchRequest.returnsObjectsAsFaults = false
            do{
                let fetchResults = try appDelegate.managedObjectContext.fetch(fetchRequest)
                if fetchResults.count>0 {
                    appDelegate.managedObjectContext.delete(fetchResults[0] as! NSManagedObject)
                    tableView.reloadData()
                } else {
                    // no data
                }
            }catch{
                //error
            }
            let result = try? moc.fetch(fetchRequest)
            
            
            let resultData = result as! [CarrosSalvos]
            
            for object in resultData {
                moc.delete(object)
            }
            
            do {
                try moc.save()
                print("deletado o carro!")
                
                // verifica()
                listaCarrosSalvos.removeAll()
                
                
               // DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                
                    self.mostrarDados()
                self.viewWillAppear(true)
                    
                    // self.carroSalvoView.tableView.reloadData()
               // })
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                
            }
            
        }
            
        else {
            
            let context = appDelegate.managedObjectContext
            
            let moc = context
            let fetchRequest : NSFetchRequest<CarrosSalvos> = CarrosSalvos.fetchRequest()
            fetchRequest.predicate = NSPredicate.init(format: "modelo")
            let result = try? moc.fetch(fetchRequest)
            
            
            let resultData = result as! [CarrosSalvos]
            
            for object in resultData {
                moc.delete(object)
            }
            
            do {
                try moc.save()
                print("deletado o carro!")
                
                listaCarrosSalvos.removeAll()
                self.tableView.reloadData()
                mostrarDados()
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                
            }
        }
    }
    
    func verPerfil() {
        
        self.performSegue(withIdentifier: "perfilController", sender: nil)
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "perfilController" {
            
            let nav = segue.destination as! UINavigationController
            nav.topViewController as! PerfilViewController
        }
    }
    

    

   

}
