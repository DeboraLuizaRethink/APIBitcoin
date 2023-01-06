//
//  ViewController.swift
//  APIBitCoin
//
//  Created by Debora Luiza on 04/01/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var botaoAtualizar: UIButton!
    @IBOutlet weak var precoBitCoin: UILabel!
    
    @IBAction func atualizarPreco(_ sender: Any) {
        self.recuperarPrecoBitCoin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.recuperarPrecoBitCoin()
    }
    
    func formatarPreco(preco: NSNumber) -> String{
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.locale = Locale(identifier: "pt_BR")
        
        if let precoFinal = nf.string(from: preco){
            return precoFinal
        }
        
        return "0,00"
    }
    
    func recuperarPrecoBitCoin(){
        
        self.botaoAtualizar.setTitle("Atualizando...", for: .normal)
        
        if let url = URL(string: "https://blockchain.info/ticker") {
            let tarefa = URLSession.shared.dataTask(with: url) { (dados, requisicao, erro) in
                
                if erro == nil {
                    if let dadosRetorno = dados{
                        
                        do{
                            if let objetoJson = try JSONSerialization.jsonObject(with: dadosRetorno , options:[]) as? [String: Any]{
                                
                                if let brl = objetoJson["BRL"] as? [String: Any] {
                                    if let preco = brl["buy"] as? Double{
                                        let precoFormatado = self.formatarPreco(preco: NSNumber(value: preco))
                                        
                                        DispatchQueue.main.async(execute: {
                                            self.precoBitCoin.text = "R$ " + precoFormatado
                                            self.botaoAtualizar.setTitle("Atualizar", for: .normal)
                                        })
                                        
                                    }
                                }
                               
                            }
                            
                        }catch{
                            print("Erro")
                        }
                    }
                }else{
                    print("Erro ao fazer a consulta do preço")
                }
            }
            tarefa.resume()
        }
    }
}
