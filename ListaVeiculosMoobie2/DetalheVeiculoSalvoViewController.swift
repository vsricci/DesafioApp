//
//  DetalheVeiculoSalvoViewController.swift
//  ListaVeiculosMoobie2
//
//  Created by Joel Sene on 24/08/17.
//  Copyright © 2017 Vinicius Santos Ricci. All rights reserved.
//

import UIKit

class DetalheVeiculoSalvoViewController: UIViewController {

    
    @IBOutlet weak var tabelaFibe : UILabel!
    @IBOutlet weak var modelo : UILabel!
    @IBOutlet weak var ano : UILabel!
    @IBOutlet weak var taxa : UILabel!
    @IBOutlet weak var marca : UILabel!
    @IBOutlet weak var preco : UILabel!
    @IBOutlet weak var labelTabelaFibe : UILabel!
    @IBOutlet weak var labelModelo : UILabel!
    @IBOutlet weak var labelAno : UILabel!
    @IBOutlet weak var labelTaxa : UILabel!
    @IBOutlet weak var labelMarca : UILabel!
    @IBOutlet weak var labelPreco : UILabel!
    var listaDetalhesSalvos = Carro()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "Detalhe Veiculo Salvo"
        mostraDadosSelecionados()
    }
    
    func mostraDadosSelecionados(){
        
        
        marca.text = listaDetalhesSalvos.marca
        preco.text = String(listaDetalhesSalvos.valor)
        taxa.text = String(listaDetalhesSalvos.taxa)
        modelo.text = listaDetalhesSalvos.modelo
        ano.text = listaDetalhesSalvos.ano
        tabelaFibe.text = listaDetalhesSalvos.codigo
        
        
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
