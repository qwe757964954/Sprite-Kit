//
//  GamePlayFlight.m
//  PlayFlight
//
//  Created by farBen on 15/11/9.
//  Copyright (c) 2015年 pa. All rights reserved.
//
#define Width self.view.frame.size.width
#define Height self.view.frame.size.height



#import "GamePlayFlight.h"
/*物理引擎参数*/
static const uint32_t projectileCategory     =  0x1 << 0;
static const uint32_t monsterCategory        =  0x1 << 1;

@implementation GamePlayFlight
-(void)didMoveToView:(SKView *)view {
    
    
    
    
    self.backgroundColor=[SKColor yellowColor];
    count=0;
    [self CreateFlightNode];
   
    [self CreateBulletNode];
    [self CreateLableNode];
    /*定时创建怪物*/
    SKAction *makeRocks = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(CreateMonsterNode) onTarget:self],
                                                [SKAction waitForDuration:1 withRange:1]
                                                ]];
    [self runAction:[SKAction repeatActionForever:makeRocks]];
    /*定时创建子弹*/
    SKAction *makeBullets = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(CreateBulletNode) onTarget:self],
                                                [SKAction waitForDuration:0.3 withRange:0]
                                                ]];
    [self runAction:[SKAction repeatActionForever:makeBullets]];
    /*将场景添加到物理引擎当中，并设置名字*/
//    SKPhysicsBody *body = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
//    self.scene.name = @"boundary";
//    self.physicsBody = body;
    
    /*物理引擎代理*/
    self.physicsWorld.contactDelegate = self;
    /*添加背景音乐*/
    SKAction *soudAck=[SKAction playSoundFileNamed:@"music_2.mp3" waitForCompletion:YES];
    
    [self runAction:[SKAction repeatActionForever:soudAck]];
    
}
-(void)CreateLableNode
{
    
  
    
    NSString *str=[NSString stringWithFormat:@"数量：%d",count];
    lableNode=[SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    lableNode.text=str;
    lableNode.fontSize = 24;
    lableNode.color=[SKColor blackColor];
    lableNode.position=CGPointMake(Width-100, Height-20);
    [self addChild:lableNode];
}

#pragma mark 创建背景精灵
-(SKSpriteNode *)CreateBackNode
{
    SKSpriteNode *backNode=[[SKSpriteNode alloc]initWithImageNamed:@"bg1_0"];
    backNode.position=CGPointMake(Width/2, Height/2);
    return backNode;
}



#pragma mark 创建怪物精灵
-(void)CreateMonsterNode
{
    /*随机计算怪物的名字*/
    int min = 1;
    int max = 5;
    int rangeY = max - min;
    int actualY = (arc4random() % rangeY) + min;
    NSString *NodeName=[NSString stringWithFormat:@"i%d",actualY];
    NSLog(@"%@",NodeName);
    SKSpriteNode *monsterNode=[[SKSpriteNode alloc]initWithImageNamed:NodeName];
    /*将怪物添加到物理引擎当中，并设置参数*/
    monsterNode.physicsBody=[SKPhysicsBody bodyWithCircleOfRadius:monsterNode.size.height/2];
    /*高精度计算*/
    monsterNode.physicsBody.usesPreciseCollisionDetection = YES;
    /*重力感应参数*/

    monsterNode.physicsBody.dynamic = NO;
    /*碰撞参数*/
    monsterNode.physicsBody.categoryBitMask = monsterCategory; // 3
    monsterNode.physicsBody.contactTestBitMask = projectileCategory; // 4
    monsterNode.physicsBody.collisionBitMask = 0; // 5
    
    
    
    [self addChild:monsterNode];
    /*随机计算怪物的位置*/
        int minX = monsterNode.size.height / 2;
    int maxX = Width - monsterNode.size.width / 2;
    int rangeX = maxX - minX;
    int actualX = (arc4random() % rangeX) + minX;
    /*设置怪物的位置*/
    monsterNode.position=CGPointMake(actualX, Height-monsterNode.size.height/2);
    /*创建怪物的action*/
    SKAction *moveAct=[SKAction moveToY:0 duration:actualY];
    SKAction *remove=[SKAction removeFromParent];
    
    [monsterNode runAction:[SKAction sequence:@[moveAct,remove]]];
    
    
}
#pragma mark 创建飞机精灵
-(void)CreateFlightNode
{
    _flightNode=[[SKSpriteNode alloc]initWithImageNamed:@"i70"];
    _flightNode.position=CGPointMake(Width/2, _flightNode.size.height / 2);
    flightPoint=_flightNode.position;
    /*旋转到指定的角度,因为我拿到的素材是反的飞机*/
    SKAction *rotateTo = [SKAction rotateToAngle:3.14 duration:0.5];
    [_flightNode runAction:[SKAction sequence:@[rotateTo]]];
    [self addChild:_flightNode];
    
    
}
#pragma mark 创建子弹精灵
-(void)CreateBulletNode
{
    SKSpriteNode *BulletNode=[[SKSpriteNode alloc]initWithImageNamed:@"i29"];
    /*同怪物物理碰撞*/
    BulletNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:BulletNode.size];
    BulletNode.physicsBody.categoryBitMask = projectileCategory;
    BulletNode.physicsBody.contactTestBitMask = monsterCategory;
    BulletNode.physicsBody.collisionBitMask = 0;
    BulletNode.physicsBody.usesPreciseCollisionDetection = YES;
    /*设置子弹的位置*/
    BulletNode.position=CGPointMake(_flightNode.position.x, _flightNode.position.y*2+BulletNode.size.height/2);
    /*执行的action*/
    SKAction *moveTo=[SKAction moveToY:Height duration:0.5];
    SKAction *scound=[SKAction playSoundFileNamed:@"bullet.mp3" waitForCompletion:NO];
    SKAction *remove=[SKAction removeFromParent];
    [BulletNode runAction:[SKAction sequence:@[scound,moveTo,remove]]];
    /*添加到场景*/
    [self addChild:BulletNode];
    
}
#pragma mark 定时器使用方法
//-(void)update:(NSTimeInterval)currentTime
//{
//    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
//    self.lastUpdateTimeInterval = currentTime;
//    if (timeSinceLast > 1) { // more than a second since last update
//        timeSinceLast = 30.0 / 60.0;
//        self.lastUpdateTimeInterval = currentTime;
//    }
//    [self CreateMonsterNode];
//    [self updateWithTimeSinceLastUpdate:timeSinceLast];
//}
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
   
  
//        [self CreateBulletNode];
 
    
    
}
#pragma mark 手势点击移动飞机

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    /*注意，一般都会用这个获取手势*/
    UITouch *touch=[touches anyObject];
    CGPoint location = [touch locationInNode:self];
    /*让飞机移动到手势的位置上*/
    SKAction *action=[SKAction moveTo:CGPointMake(location.x, location.y) duration:0.2];
    
    [_flightNode runAction:action];
}

#pragma mark 物理碰撞回调方法
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    // 1
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // 2
    if ((firstBody.categoryBitMask & projectileCategory) != 0 &&
        (secondBody.categoryBitMask & monsterCategory) != 0)
    {
        [self projectile:(SKSpriteNode *) firstBody.node didCollideWithMonster:(SKSpriteNode *) secondBody.node];
    }
}
#pragma mark 物理碰撞后该执行的方法
- (void)projectile:(SKSpriteNode *)projectile didCollideWithMonster:(SKSpriteNode *)monster {
    NSLog(@"kit it");
    count++;
    if (lableNode!=nil) {
        [lableNode removeFromParent];
    }
    [self CreateLableNode];
    SKAction *soudAck=[SKAction playSoundFileNamed:@"15_baozha1.mp3" waitForCompletion:YES];
    
    [self runAction:soudAck];
    [projectile removeFromParent];
    [monster removeFromParent];
}
@end
