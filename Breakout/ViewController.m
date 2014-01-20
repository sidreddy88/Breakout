//
//  ViewController.m
//  Breakout
//
//  Created by Siddharth Sukumar on 1/16/14.
//  Copyright (c) 2014 Siddharth Sukumar. All rights reserved.
//


#import "ViewController.h"
#import "PaddleView.h"
#import "BallView.h"
#import "BlockView.h"

@interface ViewController () <UIAlertViewDelegate>
{
    IBOutlet UILabel *timerDisplay;
    IBOutlet BallView *ballView;
    IBOutlet PaddleView *paddleView;
    
    PaddleView *secondPaddleView;
    
    IBOutlet UILabel *numberOfLivesLeft;
    UIDynamicAnimator *dynamicAnimator;
    UIPushBehavior *pushBehavior;
    UICollisionBehavior *collisionBehavior;
    UIDynamicItemBehavior *paddleDynamicBehavior;
    UIDynamicItemBehavior *ballDynamicBehavior;
    UIDynamicItemBehavior *blockDynamicBehavior;
    
    
    UIPushBehavior *pushBehaviorForAdvancedLevel;
    UIPushBehavior *secondPaddlePushBehavior;
    UICollisionBehavior *collisionBehaviorForAdvancedLevel;
    UIDynamicAnimator *dynamicAnimatorForAdvancedLevel;
    UIDynamicItemBehavior *secondPaddleDynamicBehavior;
    
    UISnapBehavior *snapBallBehavior;
    BOOL ballHitTheGround;
    int numberOfLives;
    
    UIAlertView *startGamePlayMode;
    UIAlertView *difficultyLevelGamePlayMode;
    
    BOOL currentGameIsAAdvancedGame;
    
    
    
    


    IBOutlet UILabel *score;
    
    
    int numberOfBricksInTheGame;
    int timeLeft;
}
@property (nonatomic, strong) NSTimer *timer;
@property int playerScore;
@end

@implementation ViewController
@synthesize timer, playerScore;;


#define NUMBER_ROWS 6
#define NUMBER_COLS 1


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self screenWithOptionsBeforeTheGameBegins];
    
}

- (void) settingInitialValuesForBeginnerAndIntermediateLevel{
    
    numberOfBricksInTheGame = NUMBER_COLS * NUMBER_ROWS;
    timeLeft = 5;
    numberOfLives = 3;
    playerScore = 0;
    numberOfLivesLeft.text = [NSString stringWithFormat:@"Lives: %i", numberOfLives];
    
    timerDisplay.textColor = [UIColor redColor];
    
    timerDisplay.text = [NSString stringWithFormat:@"%i", timeLeft];
    
    dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    pushBehavior = [[UIPushBehavior alloc]initWithItems:@[ballView] mode:UIPushBehaviorModeInstantaneous];
    collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[ballView,paddleView]];
//    collisionBehavior.collisionDelegate = self;
    
    paddleDynamicBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[paddleView]];
    paddleDynamicBehavior.allowsRotation = NO;
    paddleDynamicBehavior.density = 10000000.0;
    paddleDynamicBehavior.elasticity = 1.0;
    paddleDynamicBehavior.friction = 0.0;
    paddleDynamicBehavior.resistance = 0.0;
    
    
    [dynamicAnimator addBehavior:paddleDynamicBehavior];
    
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    [dynamicAnimator addBehavior:collisionBehavior];
}
- (void) settingInitialValuesForAdvancedLevel {
    
    secondPaddleView = [[PaddleView alloc] initWithFrame: CGRectMake (0, 320, 80.0, 10.0)];
    [self.view addSubview:secondPaddleView];
    secondPaddleView.backgroundColor = [UIColor greenColor];

    
    numberOfBricksInTheGame = NUMBER_COLS * NUMBER_ROWS;
    timeLeft = 5;
    numberOfLives = 3;
    playerScore = 0;
    numberOfLivesLeft.text = [NSString stringWithFormat:@"Lives: %i", numberOfLives];
    
    timerDisplay.textColor = [UIColor redColor];
    
    timerDisplay.text = [NSString stringWithFormat:@"%i", timeLeft];
    
    dynamicAnimatorForAdvancedLevel = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    pushBehavior = [[UIPushBehavior alloc]initWithItems:@[ballView] mode:UIPushBehaviorModeInstantaneous];
    collisionBehaviorForAdvancedLevel = [[UICollisionBehavior alloc] initWithItems:@[ballView,paddleView, secondPaddleView]];
    //    collisionBehavior.collisionDelegate = self;
    
    paddleDynamicBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[paddleView]];
    paddleDynamicBehavior.allowsRotation = NO;
    paddleDynamicBehavior.density = 10000000.0;
    paddleDynamicBehavior.elasticity = 1.0;
    paddleDynamicBehavior.friction = 0.0;
    paddleDynamicBehavior.resistance = 0.0;
    
    secondPaddlePushBehavior = [[UIPushBehavior alloc]initWithItems:@[secondPaddleView] mode:UIPushBehaviorModeInstantaneous];
    secondPaddlePushBehavior.pushDirection = CGVectorMake(1.0, 0.0);
    secondPaddlePushBehavior.active = YES;
    secondPaddlePushBehavior.magnitude = 1000;
    
    [dynamicAnimatorForAdvancedLevel addBehavior:secondPaddlePushBehavior];
    
    
    [dynamicAnimatorForAdvancedLevel addBehavior:paddleDynamicBehavior];

    
    secondPaddleDynamicBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[secondPaddleView]];
    secondPaddleDynamicBehavior.allowsRotation = NO;
    secondPaddleDynamicBehavior.density = 10000000.0;
    secondPaddleDynamicBehavior.elasticity = 1.0;
    secondPaddleDynamicBehavior.friction = 0.0;
    secondPaddleDynamicBehavior.resistance = 0.0;

    
    
    collisionBehaviorForAdvancedLevel.collisionMode = UICollisionBehaviorModeEverything;
    collisionBehaviorForAdvancedLevel.translatesReferenceBoundsIntoBoundary = YES;
    
    [dynamicAnimatorForAdvancedLevel addBehavior:collisionBehaviorForAdvancedLevel];


    
}
 


- (void) screenWithOptionsBeforeTheGameBegins {
    
    startGamePlayMode = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Start a new game" otherButtonTitles:nil, nil];
    startGamePlayMode.tag = 0;
    [startGamePlayMode show];
    
    difficultyLevelGamePlayMode = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: @"Beginner", @"Intermediate", @"Advanced",nil];
    difficultyLevelGamePlayMode.tag = 1;
    
    

    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 0){
        [difficultyLevelGamePlayMode show];
    }
    
    if (alertView.tag == 1) {
        if (buttonIndex == 0){
            currentGameIsAAdvancedGame = NO;
            [self settingInitialValuesForBeginnerAndIntermediateLevel];
            [self beginnerLevelGame];
            
        } else if (buttonIndex == 1){
            currentGameIsAAdvancedGame = NO;
            [self settingInitialValuesForBeginnerAndIntermediateLevel];
            [self intermediateLevelGame];
            
        } else if (buttonIndex == 2) {
            currentGameIsAAdvancedGame = YES;
            [self settingInitialValuesForAdvancedLevel];
            [self advancedLevelGame];
            ;
            
        }
        
     }
    
}



- (void) beginnerLevelGame {
    
    pushBehavior.pushDirection = CGVectorMake(0.5, 0.5);
    pushBehavior.magnitude = 5;
    pushBehavior.active = NO;
    
    [dynamicAnimator addBehavior:pushBehavior];
    
    ballDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[ballView]];
    ballDynamicBehavior.allowsRotation = NO;
    ballDynamicBehavior.elasticity = 1.0;
    ballDynamicBehavior.friction = 0.0;
    ballDynamicBehavior.resistance = 0.0;
    ballDynamicBehavior.density = 100;
    
    [dynamicAnimator addBehavior:ballDynamicBehavior];
    
    [self addBlocksForBeginnerAndIntermediateLevel];
    [self startTimer];
    

    
}

- (void) intermediateLevelGame {
    
    pushBehavior.pushDirection = CGVectorMake(0.5, 0.5);
    pushBehavior.magnitude = 7;
    pushBehavior.active = NO;
    
    [dynamicAnimator addBehavior:pushBehavior];
    
    ballDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[ballView]];
    ballDynamicBehavior.allowsRotation = NO;
    ballDynamicBehavior.elasticity = 1.0;
    ballDynamicBehavior.friction = 0.0;
    ballDynamicBehavior.resistance = 0.0;
    ballDynamicBehavior.density = 100;
    
    [dynamicAnimator addBehavior:ballDynamicBehavior];

    [self addBlocksForBeginnerAndIntermediateLevel];
    [self startTimer];
    
}


- (void) advancedLevelGame {
    
    secondPaddlePushBehavior = [[UIPushBehavior alloc]initWithItems:@[secondPaddleView] mode:UIPushBehaviorModeInstantaneous];
    secondPaddlePushBehavior.pushDirection = CGVectorMake(1.0, 0.0);
    secondPaddlePushBehavior.magnitude = 1000;
    
    [dynamicAnimatorForAdvancedLevel addBehavior:secondPaddleDynamicBehavior];

    
    pushBehavior.pushDirection = CGVectorMake(0.5, 0.5);
    pushBehavior.magnitude = 7;
    pushBehavior.active = NO;
    
    [dynamicAnimator addBehavior:pushBehavior];
    
    secondPaddlePushBehavior.active = YES;
    
    
    ballDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[ballView]];
    ballDynamicBehavior.allowsRotation = NO;
    ballDynamicBehavior.elasticity = 1.0;
    ballDynamicBehavior.friction = 0.0;
    ballDynamicBehavior.resistance = 0.0;
    ballDynamicBehavior.density = 75;
    
    [dynamicAnimator addBehavior:ballDynamicBehavior];

    [self addBlocksForAdvancedLevel];
    [self startTimer];

    
}


- (void) startTimer {
    
    
    timerDisplay.alpha = 1.0;
    timeLeft = 5;
    timerDisplay.text = [NSString stringWithFormat:@"%i", timeLeft];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target: self selector:@selector(countDown) userInfo:nil repeats:YES];
    
}
- (void) countDown {
    
    timeLeft -= 1;
     timerDisplay.text = [NSString stringWithFormat:@"%i", timeLeft];
    timerDisplay.textColor = [UIColor redColor];

    
    if (timeLeft <= 0){
        timerDisplay.alpha = 0;

        // this is if the ball hits the ground
        
        pushBehavior.active = YES;
        [timer invalidate];

        
       if (ballHitTheGround){
            [self resetBall];
        }
        
       
        
    }
}


- (void) resetBall{
    ballHitTheGround = NO;
    [dynamicAnimator removeBehavior:snapBallBehavior];
 

    
}
- (void) restartGame {
    

    ballView.center = CGPointMake(160.0, 284.0);
    
    [self makingTheBallToStop];
    
    [paddleDynamicBehavior removeItem:paddleView];
    [pushBehavior removeItem:ballView];
    
//    [pushBehavior removeItem:paddleView];
    
    if (currentGameIsAAdvancedGame) {
    
    [collisionBehaviorForAdvancedLevel removeAllBoundaries];
    [dynamicAnimatorForAdvancedLevel removeAllBehaviors];
    [secondPaddlePushBehavior removeItem:secondPaddleView];
        [pushBehaviorForAdvancedLevel removeItem:secondPaddleView];
        
    } else {
        
        [collisionBehavior removeAllBoundaries];
        [dynamicAnimator removeAllBehaviors];
        
    }
    for (BlockView *block in self.view.subviews) {
        if ([block isKindOfClass:[BlockView class]]){
            [block removeFromSuperview];

        }
    }

    [self screenWithOptionsBeforeTheGameBegins];


//    [self viewDidLoad];
    
    
    
}



- (void) addBlocksForBeginnerAndIntermediateLevel {
    
    
    
  
    int brickX = 0;
    int brickY = 60;
    
    for (int j=0; j < NUMBER_COLS; j++)
    {
        brickX = 0;
        
        for (int i=0; i < NUMBER_ROWS; i++)
        {
            NSLog(@"%s", __PRETTY_FUNCTION__);
            
            BlockView *block = [[BlockView alloc] initWithFrame: CGRectMake (brickX, brickY, 50.0, 10.0)];
            blockDynamicBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[block]];
            [self.view addSubview:block];
            block.backgroundColor = [UIColor whiteColor];
            [collisionBehavior addItem:block];
            [blockDynamicBehavior addItem:block];

            
            blockDynamicBehavior.allowsRotation = NO;
            blockDynamicBehavior.elasticity = 1.0;
            blockDynamicBehavior.friction = 0.0;
            blockDynamicBehavior.resistance = 0.0;
            blockDynamicBehavior.density = 100000.0;
            [dynamicAnimator addBehavior:blockDynamicBehavior];
            block.backgroundColor = [UIColor greenColor];
            
            // for the top two levels of blocks, three hits are necessary for them to disappear
            if (j == 0 ||  j == 1) {
                block.numberOfHitsNecessaryForDissapearing = 3;
            } else if (j == 2 || j == 3){
                block.numberOfHitsNecessaryForDissapearing = 2;
            } else {
                block.numberOfHitsNecessaryForDissapearing = 1;
            }
            
            
            brickX += 54;
            
        }

        brickY += 14;
    }
    
    collisionBehavior.collisionDelegate = self;
}

- (void) addBlocksForAdvancedLevel {
    
    

    
    int brickX = 0;
    int brickY = 60;
    
    
    for (int j=0; j < 5; j++)
    {
        brickX = 0;
        
        for (int i=0; i < 6; i++)
        {
            NSLog(@"%s", __PRETTY_FUNCTION__);
            
            BlockView *block = [[BlockView alloc] initWithFrame: CGRectMake (brickX, brickY, 50.0, 10.0)];
            blockDynamicBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[block]];
            [self.view addSubview:block];
            block.backgroundColor = [UIColor whiteColor];
            [collisionBehavior addItem:block];
            [blockDynamicBehavior addItem:block];
            
            
            blockDynamicBehavior.allowsRotation = NO;
            blockDynamicBehavior.elasticity = 1.0;
            blockDynamicBehavior.friction = 0.0;
            blockDynamicBehavior.resistance = 0.0;
            blockDynamicBehavior.density = 100000.0;
            [dynamicAnimator addBehavior:blockDynamicBehavior];
            block.backgroundColor = [UIColor greenColor];
            
            // for the top two levels of blocks, three hits are necessary for them to disappear
            if (j == 0 ||  j == 1) {
                block.numberOfHitsNecessaryForDissapearing = 3;
            } else if (j == 2 || j == 3){
                block.numberOfHitsNecessaryForDissapearing = 2;
            } else {
                block.numberOfHitsNecessaryForDissapearing = 1;
            }
            
            
            brickX += 54;
            
        }
        
        brickY += 28;
    }

    
    
       collisionBehavior.collisionDelegate = self;
}


    
/*
    for (int j=0; j < NUMBER_COLS; j++)
    {
        brickX = 0;
        
        for (int i=0; i < NUMBER_ROWS; i++)
        {
            NSLog(@"%s", __PRETTY_FUNCTION__);
            
            BlockView *block = [[BlockView alloc] initWithFrame: CGRectMake (brickX, brickY, 50.0, 10.0)];
            blockDynamicBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[block]];
            [self.view addSubview:block];
            block.backgroundColor = [UIColor whiteColor];
            [collisionBehavior addItem:block];
            [blockDynamicBehavior addItem:block];
            
            
            blockDynamicBehavior.allowsRotation = NO;
            blockDynamicBehavior.elasticity = 1.0;
            blockDynamicBehavior.friction = 0.0;
            blockDynamicBehavior.resistance = 0.0;
            blockDynamicBehavior.density = 100000.0;
            [dynamicAnimator addBehavior:blockDynamicBehavior];
            block.backgroundColor = [UIColor greenColor];

            
            // for the top two levels of blocks, three hits are necessary for them to disappear
            if (j == 0 ||  j == 1) {
                block.numberOfHitsNecessaryForDissapearing = 3;
            } else if (j == 2 || j == 3){
                block.numberOfHitsNecessaryForDissapearing = 2;
            } else {
                block.numberOfHitsNecessaryForDissapearing = 1;
            }
            
            brickX += 54;
            
        }
        
        brickY += 14;
    }
    
    collisionBehavior.collisionDelegate = self;
    
    
  */
    


- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    
    if (p.y > 560 )
    {
       ballView.center = CGPointMake(160.0, 284.0);

        ballHitTheGround = YES;
    
        [self makingTheBallToStop];
                numberOfLives--;
        numberOfLivesLeft.text = [NSString stringWithFormat:@"Lives: %i", numberOfLives];
        if (numberOfLives == 0) {
            [self restartGame];
        } else {
            [self startTimer];

        }
 
        
        
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
        BlockView *block = (BlockView *)item2;
        block.numberOfHitsNecessaryForDissapearing--;
        
        if (block.numberOfHitsNecessaryForDissapearing == 2){
            block.backgroundColor = [UIColor blueColor];
        } else if ( block.numberOfHitsNecessaryForDissapearing == 1) {
            block.backgroundColor = [UIColor redColor];
        }
        
        if (block.numberOfHitsNecessaryForDissapearing == 0){
            
            
            [collisionBehavior removeItem:block];
            [blockDynamicBehavior removeItem:block];
            
            
            
            block.alpha = 0;
//        ((BlockView *)item2).alpha = 0;
            numberOfBricksInTheGame--;
            playerScore += 50;
            score.text = [NSString stringWithFormat:@"Score :%i", playerScore];
            
        }
    
    } else if ([item1 isKindOfClass:[BlockView class]])
    {
        BlockView *block = (BlockView *)item2;
        block.numberOfHitsNecessaryForDissapearing--;
        
        if (block.numberOfHitsNecessaryForDissapearing == 2){
            block.backgroundColor = [UIColor blueColor];
        } else if ( block.numberOfHitsNecessaryForDissapearing == 1) {
            block.backgroundColor = [UIColor redColor];
        }
        
        if (block.numberOfHitsNecessaryForDissapearing == 0){
        
        
        [collisionBehavior removeItem:block];
        [blockDynamicBehavior removeItem:block];

        block.alpha = 0;
//        ((BlockView *)item1).alpha = 0;
        numberOfBricksInTheGame--;
        playerScore += 50;
        score.text = [NSString stringWithFormat:@"Score :%i", playerScore];
        }
        
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
