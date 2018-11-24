//
//  Drone.swift
//  ARExp
//
//  Created by Arthur Melo on 19/11/18.
//  Copyright © 2018 Arthur Melo. All rights reserved.
//

import SceneKit

class Drone: SCNNode {
    func carregarModelo() {
        guard let objetoVirtual = SCNScene(named: "Drone.scn") else { return }
        let no = SCNNode()
        for noFilho in objetoVirtual.rootNode.childNodes {
            no.addChildNode(noFilho)
        }
        addChildNode(no)
    }
}
