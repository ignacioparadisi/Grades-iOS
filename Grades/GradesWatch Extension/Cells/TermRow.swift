//
//  TermCell.swift
//  GradesWatch Extension
//
//  Created by Ignacio Paradisi on 7/26/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import WatchKit
import SpriteKit

class TermRow: NSObject {
    
    @IBOutlet weak var termNameLabel: WKInterfaceLabel!
    @IBOutlet weak var chartScene: WKInterfaceSKScene!
    
    func configure(with term: Term) {
        termNameLabel.setText(term.name)
        
        let scene = SKScene(size: CGSize(width: 40, height: 40))
        scene.scaleMode = .aspectFit
        chartScene.presentScene(scene)
        
        let fraction: CGFloat = 0.75
        let path = UIBezierPath(arcCenter: .zero,
                                radius: 50,
                                startAngle: 0,
                                endAngle: 2 * .pi * fraction,
                                clockwise: true).cgPath
        
        let shapeNode = SKShapeNode(path: path)
        shapeNode.strokeColor = .blue
        shapeNode.fillColor = .clear
        shapeNode.lineWidth = 4
        shapeNode.lineCap = .round
        shapeNode.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        scene.addChild(shapeNode)
        
        print("Configuring cell")
    }
    
}
