//
//  DetalheVeiculoViewController.swift
//  ListaVeiculosMoobie2
//
//  Created by Joel Sene on 24/08/17.
//  Copyright © 2017 Vinicius Santos Ricci. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreData
import SystemConfiguration

class DetalheVeiculoViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var tabelaFibe : UILabel!
    @IBOutlet weak var modelo : UILabel!
    @IBOutlet weak var ano : UILabel!
    @IBOutlet weak var taxa : UILabel!
    @IBOutlet weak var marca : UILabel!
    @IBOutlet weak var preco : UILabel!
    @IBOutlet weak var labelTabelaFibe : UILabel!
    @IBOutlet weak var labelAno : UILabel!
    @IBOutlet weak var labelTaxa : UILabel!
    @IBOutlet weak var labelMarca : UILabel!
    @IBOutlet weak var labelPreco : UILabel!
    
    var anoSelecionado : String!
    var fibeSeleciondo : String!
    var modeloSelecionado : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        labelTabelaFibe.isHidden = true
      
        labelAno.isHidden = true
        labelTaxa.isHidden = true
        labelMarca.isHidden = true
        labelPreco.isHidden = true
        tabelaFibe.isHidden = true
        modelo.isHidden = true
        ano.isHidden = true
        taxa.isHidden = true
        marca.isHidden = true
        preco.isHidden = true
        
        buscarDetalhes()
        
        navigationItem.title = "Detalhes Veiculos"
        
        let seletorSalvar : Selector = #selector(save)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "imageSalvar"), style: .plain, target: self, action: seletorSalvar)
        navigationController?.navigationBar.tintColor = UIColor.black
    }

    
    
    func buscarDetalhes() {
        
        
        if verificaSeTemInternet() == true {
            
            
            guard let url = URL(string: "https://fipe-api.herokuapp.com/cars/" + fibeSeleciondo + "/" + anoSelecionado) else {
                print("Url conversion issue.")
                return
            }
            
            var request = URLRequest(url: url)
            
            request.httpMethod = "GET"
            
            var teamJSON: [String: AnyObject]?
            
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                // Check if data was received successfully
                if error == nil && data != nil {
                    do {
                        
                        var teste = JSON(data: data!)
                        
                        //  let teamJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject]
                        
                        
                        print(teste)
                        
                        for item in teste.arrayValue {
                            print(item["marca"].stringValue)
                            
                            let detalheModelo = DetalheModelo()
                            let fibeServer = item["codigo_fipe"].stringValue
                            let modeloServer = item["modelo"].stringValue
                            let marcaServer = item["marca"].stringValue
                            let anoServer = item["ano"].stringValue
                            let valorServer = item["valor"].stringValue
                            let taxaServer = item["taxa"].stringValue
                            
                            
                            
                            
                            detalheModelo.codigoFibe = fibeServer
                            detalheModelo.marca = marcaServer
                            detalheModelo.modelo = modeloServer
                            detalheModelo.ano = anoServer
                            detalheModelo.taxa = taxaServer
                            detalheModelo.valor = valorServer
                            
                            
                            
                            
                            self.startAnimating()
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                                
                                NVActivityIndicatorType.ballZigZag
                                NVActivityIndicatorPresenter.sharedInstance.setMessage("Buscando detalhes do modelo ...")
                                
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute: {
                                    
                                    
                                    self.stopAnimating()
                                    
                                    self.labelTabelaFibe.isHidden = false
                                   
                                    self.labelAno.isHidden = false
                                    self.labelTaxa.isHidden = false
                                    self.labelMarca.isHidden = false
                                    self.labelPreco.isHidden = false
                                    self.tabelaFibe.isHidden = false
                                    self.modelo.isHidden = false
                                    self.ano.isHidden = false
                                    self.taxa.isHidden = false
                                    self.marca.isHidden = false
                                    self.preco.isHidden = false

                                    
                                    self.marca.text = detalheModelo.marca
                                    self.preco.text = detalheModelo.valor
                                    self.taxa.text = detalheModelo.taxa
                                    self.modelo.text = detalheModelo.modelo
                                    self.ano.text = detalheModelo.ano
                                    self.tabelaFibe.text = detalheModelo.codigoFibe
                                    
                                    
                                    
                                   
                                })
                                
                            })
                            
                            
                            
                        }
                        
                        
                        
                        //let JSONString = String(data: data!, encoding: String.Encoding.utf8)
                        // print(JSONString!)
                        
                        
                    }catch let error as NSError {
                        print(error)
                        
                        
                        self.stopAnimating()
                        let tentarNovamente = UIAlertAction(title: "ok", style: .default, handler: { (UIAlertAction) in
                            
                            
                        })
                        
                        
                        
                        let alertVC = UIAlertController(title: "Erro de conexão com o servidor", message: "Há problemas para conectar com o servidor", preferredStyle: .alert)
                        alertVC.addAction(tentarNovamente)
                        
                        self.present(alertVC, animated: true, completion: nil)
                    }
                    
                    
                    
                    
                }
                
                
            }).resume()
        }
        else {
            
            let tentarNovamente = UIAlertAction(title: "Tentar Novamente", style: .default, handler: { (UIAlertAction) in
                
                self.buscarDetalhes()
            })
            
            let cancelar = UIAlertAction(title: "Cancelar", style: .default, handler: { (UIAlertAction) in
                
                self.dismiss(animated: true, completion: nil)
                
            })
            
            let alertVC = UIAlertController(title: "sem conexão", message: "Não há conexão com a internet", preferredStyle: .alert)
            alertVC.addAction(tentarNovamente)
            alertVC.addAction(cancelar)
            self.present(alertVC, animated: true, completion: nil)
            
        }
        
        
    }
    
    
    func save() {
        
        self.salvarNoDispositivo(codigofibe: tabelaFibe.text!, marca: marca.text!, ano: ano.text!, modelo: modelo.text!, valor: preco.text!, taxa: taxa.text!)
        
        
        
        self.startAnimating()
        DispatchQueue.main.asyncAfter(deadline:
        DispatchTime.now()) {
            
            NVActivityIndicatorType.ballBeat
            NVActivityIndicatorPresenter.sharedInstance.setMessage("Salvando Veiculo")
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute: {
                
                self.stopAnimating()
                
                self.performSegue(withIdentifier: "carroSalvoController", sender: nil)
            })
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "carroSalvoController" {
            
             let nav = segue.destination as! UINavigationController
             nav.topViewController as! CarrosSalvosTableViewController
        }
    }

    
    func salvarNoDispositivo(codigofibe: String, marca: String, ano: String, modelo: String, valor : String, taxa: String) -> String{
        
        var message = String()
        
        //let carroParaSalvar : NSMutableArray = []
        
        // carroParaSalvar.add(["codigoFibe": detalheModeloView.labelTabelaFibe.text])
        // carroParaSalvar.add(["taxa": detalheModeloView.labelTabelaFibe.text] )
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if #available(iOS 10.0, *) {
            let context = appDelegate.persistentContainer.viewContext
            
            
            
            let salvarDados = NSEntityDescription.insertNewObject(forEntityName: "CarrosSalvos", into: context)
            
            salvarDados.setValue(codigofibe, forKey: "codigoFibe")
            salvarDados.setValue(marca, forKey: "marca")
            salvarDados.setValue(modelo, forKey: "modelo")
            salvarDados.setValue(ano, forKey: "ano")
            salvarDados.setValue(taxa, forKey: "taxa")
            salvarDados.setValue(valor, forKey: "valor")
            
            
            do{
                try context.save()
                
            }
            catch {
                return "Erro ao salvar temporariamente os dados no telefone"
            }
            
            
            
        }else {
            
            let context2 = appDelegate.managedObjectContext
            
            
            
            let salvarDados = NSEntityDescription.insertNewObject(forEntityName: "CarrosSalvos", into: context2)
            
            salvarDados.setValue(codigofibe, forKey: "codigoFibe")
            salvarDados.setValue(marca, forKey: "marca")
            salvarDados.setValue(modelo, forKey: "modelo")
            salvarDados.setValue(ano, forKey: "ano")
            salvarDados.setValue(taxa, forKey: "taxa")
            salvarDados.setValue(valor, forKey: "valor")
            
            
            do{
                try context2.save()
                
            }
            catch {
                return "Erro ao salvar temporariamente os dados no telefone"
            }
            
        }
        
        return message
        
    }
    
    func verificaSeTemInternet() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
