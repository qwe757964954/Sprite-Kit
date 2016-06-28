//
//  GamePlayReady.m
//  PlayFlight
//
//  Created by farBen on 15/11/9.
//  Copyright (c) 2015年 pa. All rights reserved.
//
#define Width self.view.frame.size.width
#define Height self.view.frame.size.height
#import "GamePlayReady.h"
#import "GamePlayFlight.h"
@implementation GamePlayReady

#pragma mark 注意这里就类似viewdidlod，所有的场景都是最先进入这个方法
-(void)didMoveToView:(SKView *)view {
    
    
    /*应用开发的uivew这里叫SKSpriteNode（中文：精灵。。。实际就是图片、文字、颜色都可以作为精灵）*/
    SKSpriteNode *backNode=[self CreateBackNode];
    [self addChild:backNode];
    SKSpriteNode *startNode=[self CreateStartNode];
    [self addChild:startNode];
    SKSpriteNode *pesonNode=[self CreatePesonNode];
    [self addChild:pesonNode];
    SKSpriteNode *logoNode=[self CreateLogoNode];
    [self addChild:logoNode];
    SKSpriteNode *grilNode=[self CreateGrilNode];
    [self addChild:grilNode];
//    [self CreatSnowNode];
    
    /*游戏开发用的最多的就是action，类似于应用开发的animotion有（移动、旋转、动画帧、缩放、放音乐、纹理、等等等等）*/
    SKAction *soudAck=[SKAction playSoundFileNamed:@"1_main.mp3" waitForCompletion:YES];
    
    [self runAction:[SKAction repeatActionForever:soudAck]];
    
    
    
}
-(void)CreatSnowNode
{
    SKEmitterNode *snow = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"snow" ofType:@"sks"]];
    snow.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(self.frame));
    [self addChild:snow];
}
-(SKSpriteNode *)CreateBackNode
{
    SKSpriteNode *backNode=[[SKSpriteNode alloc]initWithImageNamed:@"background0"];
    /*注意游戏开发并没有frame只有CGPoint,大小一般都是游戏的大小，如果你要它的size要用action去改变他的size*/
    backNode.position=CGPointMake(Width/2, Height/2);
    return backNode;
}
-(SKSpriteNode *)CreateGrilNode
{
    SKSpriteNode *girlNode=[[SKSpriteNode alloc]initWithImageNamed:@"background0"];
    /*注意游戏开发并没有frame只有CGPoint,大小一般都是游戏的大小，如果你要它的size要用action去改变他的size*/
    girlNode.position=CGPointMake(25, 45);
    
    SKTexture *w01 = [SKTexture textureWithImageNamed:@"walkR01"];
    SKTexture *w02 = [SKTexture textureWithImageNamed:@"walkR02"];
    SKTexture *w03 = [SKTexture textureWithImageNamed:@"walkR03"];
    SKTexture *w04 = [SKTexture textureWithImageNamed:@"walkR04"];
    SKTexture *w05 = [SKTexture textureWithImageNamed:@"walkR05"];
    SKAction *resizeToWH = [SKAction resizeToWidth:50 height:90 duration:0];
    [girlNode runAction:resizeToWH];
    SKAction *move=[SKAction moveToX:Width-25 duration:30];
    
    [girlNode runAction:move completion:^{
        SKAction *move2=[SKAction moveToX:25 duration:30];
        [girlNode runAction:move2];
    }];
    SKAction *animation = [SKAction animateWithTextures:@[w01, w02, w03, w04, w05] timePerFrame:0.1];
    SKAction *action = [SKAction repeatActionForever:animation];
    
    [girlNode runAction:action];
    
    return girlNode;
}
-(SKSpriteNode *)CreateStartNode
{
    SKSpriteNode *backNode=[[SKSpriteNode alloc]initWithImageNamed:@"btn_battle_1"];
    backNode.position=CGPointMake(Width/2, Height/2);
    return backNode;
}
-(SKSpriteNode *)CreatePesonNode
{
    SKSpriteNode *backNode=[[SKSpriteNode alloc]initWithImageNamed:@"img_head-_shenmiren"];
    backNode.position=CGPointMake(200, 200);
    return backNode;
}
-(SKSpriteNode *)CreateLogoNode
{
    SKSpriteNode *backNode=[[SKSpriteNode alloc]initWithImageNamed:@"i174"];
    backNode.position=CGPointMake(200, Height-100);
    /*这里就是改变精灵size的方法*/
    SKAction *resizeToWH = [SKAction resizeToWidth:300 height:180 duration:1];
    [backNode runAction:[SKAction sequence:@[resizeToWH]]];
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.2];
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.2];
    SKAction *ack=[SKAction sequence:@[fadeOut,fadeIn]];
    [backNode runAction:[SKAction repeatActionForever:ack]];
    return backNode;
}
/*手势方法*/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    SKScene *FlightScene=[[GamePlayFlight alloc]initWithSize:self.size];
    SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
    [self.view presentScene:FlightScene transition:doors];
}
@end
