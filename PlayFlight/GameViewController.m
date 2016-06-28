//
//  GameViewController.m
//  PlayFlight
//
//  Created by farBen on 15/11/9.
//  Copyright (c) 2015年 pa. All rights reserved.
//

#import "GameViewController.h"
#import "GamePlayReady.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    /*创建skview，，cocos2d里面叫Director（导演），
    这里再把隐藏代码讲一下，就是大多数简单的游戏其实用uiview的动画跟frame可以做出来，但是游戏开发的动画相对比较多，定时器也比较多，用uivew就会容易造成卡屏的现象，
     所以用到的是opengl，最小的帧能够到1/60，当然精灵过多还是会卡屏，那时候就要用opengles重写opengl
     
     */
    SKView * skView = (SKView *)self.view;
    /*显示FPS*/
    skView.showsFPS = YES;
    /*显示精灵个数*/
    skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    /*创建场景，然后跳转到场景*/
    GamePlayReady *scene = [[GamePlayReady alloc]initWithSize:self.view.frame.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}
#pragma mark 这里可以设置游戏的背景音乐，但是考虑场景不同音乐不一样，一般不用
-(void)viewDidLayoutSubviews
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"1_main" ofType:@"mp3"];
    NSURL *url=[NSURL URLWithString:path];
    player=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
//    player.numberOfLoops = -1;
//    [player prepareToPlay];
//    [player play];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
