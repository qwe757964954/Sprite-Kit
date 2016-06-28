//
//  GamePlayFlight.h
//  PlayFlight
//
//  Created by farBen on 15/11/9.
//  Copyright (c) 2015年 pa. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GamePlayFlight : SKScene<SKPhysicsContactDelegate>
{
    CGPoint flightPoint;
    SKLabelNode *lableNode;
    int count;
}
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property(nonatomic)SKSpriteNode *flightNode;
@end
