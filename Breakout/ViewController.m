//
//  ViewController.m
//  Breakout
//
//  Created by Siddharth Sukumar on 1/16/14.
//  Copyright (c) 2014 Siddharth Sukumar. All rights reserved.
//

// Problems - I cant figure out how to reset the ball, call the timer and then make the ball move after the timer reaches zero[ When the ball hits the ground]. It seems like the the two methods in resetBall go together

#import "ViewController.h"
#import "PaddleView.h"
#import "BallView.h"
#import "BlockView.h"

@interface ViewController () 
{
    IBOutlet UILabel *timerDisplay;
    IBOutlet BallView *ballView;
    IBOutlet PaddleView *paddleView;
    
    UIDynamicAnimator *dynamicAnimator;
    UIPushBehavior *pushBehavior;
    UICollisionBehavior *collisionBehavior;
    UISnapBehavior *snapBallBehavior;
    BOOL ballHitTheGround;


    IBOutlet UILabel *score;
    
    
    int numberOfBricksInTheGame;
    int timeLeft;
}
@property (nonatomic, strong) NSTimer *timer;
@property int playerScore;
@end

@implementation ViewController
@synthesize timer, playerScore;;






- (void)viewDidLoad
{
    [super viewDidLoad];
    
    numberOfBricksInTheGame = 2;
    timeLeft = 5;
    
    timerDisplay.textColor = [UIColor redColor];
    
    timerDisplay.text = [NSString stringWithFormat:@"%i", timeLeft];
    
   
    
    UIDynamicItemBehavior *paddleDynamicBehavior;
    UIDynamicItemBehavior *ballDynamicBehavior;
    
    dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    pushBehavior = [[UIPushBehavior alloc]initWithItems:@[ballView,paddleView] mode:UIPushBehaviorModeInstantaneous];
    collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[ballView,paddleView]];
    collisionBehavior.collisionDelegate = self;
    
    paddleDynamicBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[paddleView]];
    paddleDynamicBehavior.allowsRotation = NO;
    paddleDynamicBehavior.density = 10000.0;
    paddleDynamicBehavior.elasticity = 1.0;
    paddleDynamicBehavior.friction = 0.0;
    paddleDynamicBehavior.resistance = 0.0;

    
    [dynamicAnimator addBehavior:paddleDynamicBehavior];
    
    pushBehavior.pushDirection = CGVectorMake(0.5, 0.5);
    pushBehavior.magnitude = 5;
    pushBehavior.active = NO;
    
    [dynamicAnimator addBehavior:pushBehavior];
    
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    [dynamicAnimator addBehavior:collisionBehavior];
    
    ballDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[ballView]];
    ballDynamicBehavior.allowsRotation = NO;
    ballDynamicBehavior.elasticity = 1.0;
    ballDynamicBehavior.friction = 0.0;
    ballDynamicBehavior.resistance = 0.0;
    ballDynamicBehavior.density = 100;

    [dynamicAnimator addBehavior:ballDynamicBehavior];
    
    [self addBlocks];
    [self startTimer];
    

}

- (void) startTimer {
    
    
    timerDisplay.alpha = 1.0;
    timeLeft = 5;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target: self selector:@selector(countDown) userInfo:nil repeats:YES];
    
}
- (void) countDown {
    
    timeLeft -= 1;
     timerDisplay.text = [NSString stringWithFormat:@"%i", timeLeft];
    timerDisplay.textColor = [UIColor redColor];

    
    if (timeLeft <= 0){
        timerDisplay.alpha = 0;

        // this is if the ball hits the ground
        
       if (ballHitTheGround){
            [self resetBall];
        }
        
       pushBehavior.active = YES;
       [timer invalidate];
        
      
    
        
    }
}


- (void) resetBall{
    ballHitTheGround = NO;
    [dynamicAnimator removeBehavior:snapBallBehavior];
 

    
}
- (void) restartGame {
    
    ballView.center = CGPointMake(160.0, 284.0);
    
    [self makingTheBallToStop];

    [self viewDidLoad];
    
}


- (void) addBlocks {
    
    UIDynamicItemBehavior *blockDynamicBehavior;
    
    int brickX = 0;
    int brickY = 60;
    
    for (int j=0; j < 1; j++)
    {
        brickX = 0;
        
        for (int i=0; i < 2; i++)
        {
            BlockView *block = [[BlockView alloc] initWithFrame: CGRectMake (brickX, brickY, 50.0, 10.0)];
            [self.view addSubview:block];
            block.backgroundColor = [UIColor whiteColor];
            [collisionBehavior addItem:block];
            [blockDynamicBehavior addItem:block];

            blockDynamicBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[block]];
            blockDynamicBehavior.allowsRotation = NO;
            blockDynamicBehavior.elasticity = 1.0;
            blockDynamicBehavior.friction = 0.0;
            blockDynamicBehavior.resistance = 0.0;
            blockDynamicBehavior.density = 100000.0;
            [dynamicAnimator addBehavior:blockDynamicBehavior];
            
            if (j == 0){
                block.backgroundColor = [UIColor greenColor];
            } else if (j == 1 || j == 2){
                block.backgroundColor = [UIColor orangeColor];
            } else if (j == 3  || j == 4){
                block.backgroundColor = [UIColor blueColor];
            } else if (j == 5 || j ==6){
                block.backgroundColor = [UIColor redColor];
            }
            
            brickX += 54;
        }
        [dynamicAnimator addBehavior:blockDynamicBehavior];
        brickY += 14;
    }
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    
    if (p.y > 560 )
    {
       ballView.center = CGPointMake(160.0, 284.0);

        ballHitTheGround = YES;
    
        [self makingTheBallToStop];
        [self startTimer];
 
        
        
    }
    
    if (pushBehavior.magnitude < 4 && [item isKindOfClass:[BallView class]])
    {
        pushBehavior.magnitude = 5;
    }
}

- (void) makingTheBallToStop {
    
    
    snapBallBehavior = [[UISnapBehavior alloc] initWithItem:ballView snapToPoint:CGPointMake(160.0, 284.0)];
    pushBehavior.active = NO;
    [dynamicAnimator addBehavior:snapBallBehavior];
    [dynamicAnimator updateItemUsingCurrentState:ballView];
    
}


-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
    if ([item2 isKindOfClass:[BlockView class]])
    {
        [collisionBehavior removeItem:item2];
        ((BlockView *)item2).alpha = 0;
        numberOfBricksInTheGame--;
        playerScore += 50;
        score.text = [NSString stringWithFormat:@"Score :%i", playerScore];
    } else if ([item1 isKindOfClass:[BlockView class]])
    {
        [collisionBehavior removeItem:item1];
        ((BlockView *)item1).alpha = 0;
        numberOfBricksInTheGame--;
        playerScore += 50;
        score.text = [NSString stringWithFormat:@"Score :%i", playerScore];
        
    }
    
    
    BOOL gameOver = [self shouldStartAgain];
    if (gameOver){

        [self restartGame];
        
    }
}




- (BOOL) shouldStartAgain {
   
    BOOL gameOver = NO;
    if (numberOfBricksInTheGame == 0){
        gameOver = YES;
    }
    return gameOver;
}


-(IBAction)dragPaddle:(UIPanGestureRecognizer *)panGestureRecognizer
{
    paddleView.center = CGPointMake([panGestureRecognizer locationInView:self.view].x,  paddleView.center.y);
    [dynamicAnimator updateItemUsingCurrentState:paddleView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
