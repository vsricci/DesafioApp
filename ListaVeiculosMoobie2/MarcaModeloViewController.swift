//
//  MarcaModeloViewController.swift
//  ListaVeiculosMoobie2
//
//  Created by Joel Sene on 24/08/17.
//  Copyright © 2017 Vinicius Santos Ricci. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import SystemConfiguration
import IQKeyboardManagerSwift
class MarcaModeloViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, NVActivityIndicatorViewable, UITextFieldDelegate {

    @IBOutlet weak var marcaTextfield = UITextField()
    @IBOutlet weak var modeloTextfield = UITextField()
    @IBOutlet weak var botaoDetalhes : UIButton!
    
    var listaMarca = [Marca]()
    var listaModelo = [Modelo]()
    var codigoFibeSelecionado : String!
    var anoSelecionado : String!
    var marcaPicker = UIPickerView()
    var modeloPicker = UIPickerView()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        buscaMarcaVeiculos()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        marcaPicker.dataSource = self
        marcaPicker.delegate = self
        marcaTextfield?.inputView = marcaPicker
        
        modeloPicker.dataSource = self
        modeloPicker.delegate = self
        modeloTextfield?.inputView = modeloPicker
        
        navigationItem.title = "Escolha o Veiculo"
        let seletorDetalhes : Selector = #selector(detalhes)
        botaoDetalhes.addTarget(self, action: seletorDetalhes, for: .touchUpInside)
        
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.blue
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: "donePicker")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        //let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: "donePicker")
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
       // modeloTextfield?.inputAccessoryView = toolBar
        marcaTextfield?.inputAccessoryView = toolBar
        modeloTextfield?.inputAccessoryView = toolBar
        // Do any additional setup after loading the view.
    }
    
    
    //ocultar o teclado quando clica fora dele
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }
    
     func donePicker() {
        
        marcaTextfield?.resignFirstResponder()
        modeloTextfield?.resignFirstResponder()
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var valor = 0
        if pickerView == marcaPicker {
            valor = listaMarca.count
            
        }
        if pickerView == modeloPicker {
            
            valor = listaModelo.count
        }
        
        return valor
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var valor = String()
        if pickerView == marcaPicker {
            valor = listaMarca[row].marca
            //self.marcModeloView.marcaTextField.text = valor
            
        }
        if pickerView == modeloPicker {
            
            valor = listaModelo[row].modelo
        }
        
        return valor
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if pickerView == marcaPicker {
            marcaTextfield?.text = listaMarca[row].marca
            
            
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                self.listaModelo.removeAll()
                
                self.buscarModeloVeiculos(marca: (self.marcaTextfield?.text!)!)
               self.modeloPicker.reloadAllComponents()
                
                
                
            })
            
            
            
            
        }
        if pickerView == modeloPicker {
            
            modeloTextfield?.text = listaModelo[row].modelo
            
            
            anoSelecionado = listaModelo[row].ano
            codigoFibeSelecionado = listaModelo[row].codigoFipe
            
            
        }
        
        
        
        
    }
    
    func buscaMarcaVeiculos() {
        
        if verificaSeTemInternet() == true {
            
            guard let url = URL(string: "https://fipe-api.herokuapp.com/cars/brand") else {
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
                            
                            let marcas = Marca()
                            let marca = item["marca"].stringValue
                            marcas.marca = marca
                            
                            
                            self.startAnimating()
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                                
                                NVActivityIndicatorType.ballZigZag
                                NVActivityIndicatorPresenter.sharedInstance.setMessage("buscando marcas de veiculos...")
                                
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute: {
                                    
                                    
                                    self.stopAnimating()
                                    self.listaMarca.append(marcas)
                                    self.marcaTextfield?.text = self.listaMarca[0].marca
                                    
                                })
                                
                            })
                            
                        }
                        
                        
                        
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
                
                self.buscaMarcaVeiculos()
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
    
    
    func buscarModeloVeiculos(marca : String){
        
        
        if verificaSeTemInternet() == true {
            
            let urlstring = "https://fipe-api.herokuapp.com/cars/brand/" + "\(marca)"
            print(urlstring)
            
           guard let url = URL(string: "https://fipe-api.herokuapp.com/cars/brand/" + "\(marca)") else {
            
            let tentarNovamente = UIAlertAction(title: "ok", style: .default, handler: { (UIAlertAction) in
                
                
            })
            
            
            
            let alertVC = UIAlertController(title: "Tente outro veiculo", message: "Veiculo atualmente indisponivel", preferredStyle: .alert)
            alertVC.addAction(tentarNovamente)
            
            self.present(alertVC, animated: true, completion: nil)

            
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
                            
                            let modelos = Modelo()
                            let fibe = item["codigo_fipe"].stringValue
                            let modelo = item["modelo"].stringValue
                            let ano = item["ano"].stringValue
                            
                            
                            modelos.codigoFipe = fibe
                            modelos.modelo = modelo
                            modelos.ano = ano
                            
                            self.startAnimating()
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                                
                                NVActivityIndicatorType.ballZigZag
                                NVActivityIndicatorPresenter.sharedInstance.setMessage("Buscando modelos de caroos...")
                                
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute: {
                                    
                                    
                                    self.stopAnimating()
                                    
                                    self.listaModelo.append(modelos)
                                    self.modeloPicker.isUserInteractionEnabled = true
                                    self.modeloTextfield?.text = self.listaModelo[0].modelo
                                    self.anoSelecionado = self.listaModelo[0].ano
                                    self.codigoFibeSelecionado = self.listaModelo[0].codigoFipe
                                    
                                    
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
                
                self.buscaMarcaVeiculos()
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
    
    func detalhes() {
        
        let detalhesModeloVC = UIStoryboard(name: "DetalheVeiculo", bundle: nil).instantiateViewController(withIdentifier: "detalheVeiculoController") as! DetalheVeiculoViewController
        detalhesModeloVC.anoSelecionado = anoSelecionado
        detalhesModeloVC.fibeSeleciondo = codigoFibeSelecionado
        detalhesModeloVC.modeloSelecionado = modeloTextfield?.text
        
        
        self.navigationController?.pushViewController(detalhesModeloVC, animated: true)
        
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
