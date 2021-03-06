//
//  GameScene.swift
//  photoshader
//
//  Created by taiki.ogasawara on 2016/05/19.
//  Copyright (c) 2016年 TAIKI OGASAWARA. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: SKScene {
    
    var imageSprite : SKSpriteNode? = nil;
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(myLabel)
    }
    
    var count = 0;
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            if(count%2 == 0) {
                let shader = SKShader(fileNamed: "shader.fsh")
                let spriteSize = sprite.calculateAccumulatedFrame();
                let uniformSpriteSize = SKUniform(name: "sprite_size", floatVector2: GLKVector2Make(Float(spriteSize.width), Float(spriteSize.height)));
                shader.addUniform(uniformSpriteSize);
                sprite.shader = shader;
            }
            
            self.addChild(sprite)
            
            count += 1;
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    func setImage(tex: SKTexture) {
        
        if let s = imageSprite {
            s.removeFromParent();
        }
        
        imageSprite = SKSpriteNode(texture: tex);
        if let s = imageSprite {
            s.position = self.view!.center;
            
            let shader = SKShader(fileNamed: "shader.fsh")
            let spriteSize = s.calculateAccumulatedFrame();
            let uniformSpriteSize = SKUniform(name: "sprite_size", floatVector2: GLKVector2Make(Float(spriteSize.width), Float(spriteSize.height)));
            shader.addUniform(uniformSpriteSize);
            s.shader = shader;

            self.addChild(s);
        }
        else {
            imageSprite = nil;
        }
    }
}
