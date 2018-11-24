//
//  ViewController.swift
//  ARExp
//
//  Created by Arthur Melo on 19/11/18.
//  Copyright © 2018 Arthur Melo. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    let drone = Drone()
    let posicaoInicial = SCNVector3(0, 0, -0.6)
    let velocidadeDeMovimento: CGFloat = 0.05
    let velocidadeDeRotacao: CGFloat = 0.2
    let duracaoDaAnimacao: TimeInterval = 0.2

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarCena()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configurarSessao()
        adicionarDrone()
    }
    
    func adicionarDrone() {
        drone.carregarModelo()
        drone.position = posicaoInicial
        drone.rotation = SCNVector4Zero
        sceneView.scene.rootNode.addChildNode(drone)
    }
    
    func configurarCena() {
        let cena = SCNScene()
        sceneView.scene = cena
    }
    
    func configurarSessao() {
        let configuracaoDaSessao = ARWorldTrackingConfiguration()
        sceneView.session.run(configuracaoDaSessao)
    }
    
    @IBAction func subirDrone(_ sender: UILongPressGestureRecognizer) {
        let acao = SCNAction.moveBy(x: 0, y: velocidadeDeMovimento, z: 0, duration: duracaoDaAnimacao)
        executar(acao: acao, sender: sender)
    }
    
    @IBAction func moverParaEsquerda(_ sender: UILongPressGestureRecognizer) {
        let x = -deltas().cos
        let z = deltas().sin
        moverDrone(x: x, z: z, sender: sender)
    }
    
    @IBAction func moverParaDireita(_ sender: UILongPressGestureRecognizer) {
        let x = deltas().cos
        let z = -deltas().sin
        moverDrone(x: x, z: z, sender: sender)
    }
    
    @IBAction func descerDrone(_ sender: UILongPressGestureRecognizer) {
        let acao = SCNAction.moveBy(x: 0, y: -velocidadeDeMovimento, z: 0, duration: duracaoDaAnimacao)
        executar(acao: acao, sender: sender)
    }
    
    @IBAction func avancarDrone(_ sender: UILongPressGestureRecognizer) {
        let x = -deltas().sin
        let z = -deltas().cos
        moverDrone(x: x, z: z, sender: sender)
    }
    
    @IBAction func rotacionarEsquerda(_ sender: UILongPressGestureRecognizer) {
        rotacionarDrone(yRadiano: velocidadeDeRotacao, sender: sender)
    }
    
    @IBAction func rotacionarDireita(_ sender: UILongPressGestureRecognizer) {
        rotacionarDrone(yRadiano: -velocidadeDeRotacao, sender: sender)
    }
    
    @IBAction func recuarDrone(_ sender: UILongPressGestureRecognizer) {
        let x = deltas().sin
        let z = deltas().cos
        moverDrone(x: x, z: z, sender: sender)
    }
    
    private func rotacionarDrone(yRadiano: CGFloat, sender: UILongPressGestureRecognizer) {
        let acao = SCNAction.rotateBy(x: 0, y: yRadiano, z: 0, duration: duracaoDaAnimacao)
        executar(acao: acao, sender: sender)
    }
    
    private func moverDrone(x: CGFloat, z: CGFloat, sender: UILongPressGestureRecognizer) {
        let acao = SCNAction.moveBy(x: x, y: 0, z: z, duration: duracaoDaAnimacao)
        executar(acao: acao, sender: sender)
    }
    
    private func executar(acao: SCNAction, sender: UILongPressGestureRecognizer) {
        let loop = SCNAction.repeatForever(acao)
        if sender.state == .began {
            drone.runAction(loop)
        } else if sender.state == .ended {
            drone.removeAllActions()
        }
    }
    
    private func deltas() -> (sin: CGFloat, cos: CGFloat) {
        return (sin: velocidadeDeMovimento * CGFloat(sin(drone.eulerAngles.y)), cos: velocidadeDeMovimento * CGFloat(cos(drone.eulerAngles.y)))
    }
}
