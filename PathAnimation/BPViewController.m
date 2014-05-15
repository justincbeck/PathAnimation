//
//  BPViewController.m
//  PathAnimation
//
//  Created by Justin C. Beck on 5/15/14.
//  Copyright (c) 2014 BeckProduct. All rights reserved.
//

#import "BPViewController.h"

@interface BPViewController ()
{
    BOOL _animating;
    CAKeyframeAnimation *_pathAnimation;
    CABasicAnimation *_alphaUpAnimation;
    CABasicAnimation *_alphaDownAnimation;
}

@property (weak, nonatomic) IBOutlet UIView *theObject;
@property (weak, nonatomic) IBOutlet UIButton *theButton;
@property (weak, nonatomic) IBOutlet UIView *theView;

@end

@implementation BPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _theObject.clipsToBounds = NO;
    _theObject.backgroundColor = [UIColor blackColor];
    _theObject.layer.cornerRadius = 3.0;
    
    [_theView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_theView.layer setBorderWidth:6.0];
    [_theView.layer setCornerRadius:50.0];
    
    CGMutablePathRef circularPath = CGPathCreateMutable();
    CGRect pathRect = CGRectMake(_theObject.frame.origin.x - 43.0, _theObject.frame.origin.y + 5.0, 93.0, 93.0);
    CGPathAddEllipseInRect(circularPath, NULL, pathRect);
    
    _pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    _pathAnimation.calculationMode = kCAAnimationPaced;
    _pathAnimation.repeatCount = INFINITY;
    _pathAnimation.duration = 1.5;
    _pathAnimation.path = circularPath;
    
    _alphaUpAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    _alphaUpAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    _alphaUpAnimation.toValue = [NSNumber numberWithFloat:1.0];
    _alphaUpAnimation.repeatCount = 0.0;
    _alphaUpAnimation.duration = 0.15;
    _alphaUpAnimation.removedOnCompletion = NO;
    _alphaUpAnimation.fillMode = kCAFillModeBoth;
    _alphaUpAnimation.additive = NO;
    
    _alphaDownAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    _alphaDownAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    _alphaDownAnimation.toValue = [NSNumber numberWithFloat:0.0];
    _alphaDownAnimation.repeatCount = 0.0;
    _alphaDownAnimation.duration = 0.15;
    _alphaDownAnimation.removedOnCompletion = NO;
    _alphaDownAnimation.fillMode = kCAFillModeBoth;
    _alphaDownAnimation.additive = NO;
    
    [_theObject.layer addAnimation:_pathAnimation forKey:@"position"];
    
    CGPathRelease(circularPath);
    
    [self controlAnimation:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)controlAnimation:(id)sender
{
    if (_animating)
    {
        [[[self theObject] layer] addAnimation:_alphaDownAnimation forKey:@"opacityDown"];
    }
    else
    {
        [[[self theObject] layer] addAnimation:_alphaUpAnimation forKey:@"opacityUp"];
    }
    
    _animating = !_animating;
    
    [[self theButton] setTitle:_animating ? @"STOP" : @"GO" forState:UIControlStateNormal];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [_theObject.layer animationForKey:@"opacityDown"])
    {
        [[self theObject] setAlpha:0.0];
        [[[self theObject] layer] removeAnimationForKey:@"opacityDown"];
    }
    else if (anim == [_theObject.layer animationForKey:@"opacityUp"])
    {
        [[self theObject] setAlpha:1.0];
        [[[self theObject] layer] removeAnimationForKey:@"opacityUp"];
    }
}

@end
