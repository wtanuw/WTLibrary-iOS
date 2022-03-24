//
//  ViewController1.m
//  WTNavigationExample
//
//  Created by Mac on 16/4/2564 BE.
//  Copyright © 2564 BE wtanuw. All rights reserved.
//

#import "ViewControllerSub.h"
#import "WTLVResizableNavigationController.h"
#import "WTLVResizableNavigationBar.h"
#import "WTNavigationBar.h"
#import "LVResizableNavigationController.h"
#import "PPRevealSideViewController.h"
#import "ViewController.h"

@interface ViewControllerSub ()

@property (nonatomic,weak) IBOutlet UITextView *textView;
@property (nonatomic,weak) IBOutlet UIButton *button;
@property (nonatomic,weak) IBOutlet UILabel *label;


@property (nonatomic,strong) NSString *number;
@property (nonatomic,strong) UIColor *backgroundColor;


@property (nonatomic,weak) IBOutlet UIView *subHeader;
@property (nonatomic,strong) UIColor *navigationBarColor;
@property (nonatomic,assign) CGFloat navigationHeight;

@end

@implementation ViewControllerSub

+ (instancetype)viewControllerWithStoryboard
{
    id vct = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"vct"];
    
    [((ViewControllerSub*)vct) view1];
    return vct;
}
+ (instancetype)viewControllerWithStoryboard:(int)number
{
    id vct = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"vct"];
    switch (number)
    {
        case 1:
            [((ViewControllerSub*)vct) view1];
        break;
        case 2:
            [((ViewControllerSub*)vct) view2];
        break;
        case 3:
            [((ViewControllerSub*)vct) view3];
        break;
        case 4:
            [((ViewControllerSub*)vct) view4];
        break;
        default:
            [((ViewControllerSub*)vct) view1];
        break;
    }
    return vct;
}
+ (UINavigationController*)wtNavigationViewControllerWithStoryboard
{
    id nvct = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"wtlv"];
    
    [((ViewControllerSub*)(((UINavigationController*)nvct).viewControllers[0])) view2];
    return nvct;
}
+ (UINavigationController*)lvNavigationControllerWithStoryboard
{
    id nvct = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"lv"];
    [((ViewControllerSub*)(((UINavigationController*)nvct).viewControllers[0])) view3];
    return nvct;
}
+ (UINavigationController*)codeNavigationViewControllerWithStoryboard
{
    id vct = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"vct"];
    WTLVResizableNavigationController *nvct = [[WTLVResizableNavigationController alloc] initWithRootViewController:vct];
    [((ViewControllerSub*)vct) view4];
    return nvct;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    [self view3];
    return self;
}
- (void)view1
{
    self.number = @"1";
    self.backgroundColor = [UIColor redColor];
    self.navigationBarColor = [UIColor blueColor];
    self.navigationHeight = 44;
}
- (void)view2
{
    self.number = @"2";
    self.backgroundColor = [UIColor blueColor];
    self.navigationBarColor = [UIColor greenColor];
    self.navigationHeight = 90;
}
- (void)view3
{
    self.number = @"3";
    self.backgroundColor = [UIColor greenColor];
    self.navigationBarColor = [UIColor yellowColor];
    self.navigationHeight = 90;
}
- (void)view4
{
    self.number = @"4";
    self.backgroundColor = [UIColor yellowColor];
    self.navigationBarColor = [UIColor redColor];
    self.navigationHeight = 500;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateView];
}

- (void)updateView
{
    self.label.text = [NSString stringWithFormat:@"view:  %@",self.number];
    [self.button setTitle:[NSString stringWithFormat:@"push:  %@",self.number] forState:UIControlStateNormal];
    self.view.backgroundColor = self.backgroundColor;
    ;
    self.additionalSafeAreaInsets = UIEdgeInsetsMake([self resizableNavigationBarControllerNavigationBarHeight] - 44 , 0, 0, 0);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.additionalSafeAreaInsets = UIEdgeInsetsMake([self resizableNavigationBarControllerNavigationBarHeight] , 0, 0, 0);
}

- (IBAction)pushButtonPressed:(id)sender
{
    if (self.navigationController) {
        id vct = [ViewControllerSub viewControllerWithStoryboard:1];
        [self.navigationController pushViewController:vct animated:YES];
        
    }
}

- (IBAction)push2ButtonPressed:(id)sender
{
    if (self.navigationController) {
        id vct = [ViewControllerSub viewControllerWithStoryboard:2];
        [self.navigationController pushViewController:vct animated:YES];
        
    }
}

- (IBAction)push3ButtonPressed:(id)sender
{
    if (self.navigationController) {
        id vct = [ViewControllerSub viewControllerWithStoryboard:3];
        [self.navigationController pushViewController:vct animated:YES];
        
    }
}

- (IBAction)push4ButtonPressed:(id)sender
{
//    if (self.navigationController) {
//        id vct = [ViewControllerSub viewControllerWithStoryboard:4];
//        [self.navigationController pushViewController:vct animated:YES];
//
//    }

    [[NSNotificationCenter defaultCenter] postNotificationName:nRevealShowRightNotification object:nil];
}

- (IBAction)popButtonPressed:(id)sender
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (IBAction)popToRootButtonPressed:(id)sender
{
    if (self.navigationController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}

- (IBAction)buttonPressed:(id)sender
{
    UIButton *bt = (UIButton*)sender;
    int rand = RANDOM_BOUNDARY(1, 4);
    if (bt.tag>0) {
        rand = bt.tag;
    }
    
    switch (rand) {
        case 1:
        [[NSNotificationCenter defaultCenter] postNotificationName:nRevealShowTopNotification object:nil];
            break;
        case 2:
        [[NSNotificationCenter defaultCenter] postNotificationName:nRevealShowLeftNotification object:nil];
            break;
        case 3:
        [[NSNotificationCenter defaultCenter] postNotificationName:nRevealShowBottomNotification object:nil];
            break;
        case 4:
        [[NSNotificationCenter defaultCenter] postNotificationName:nRevealShowRightNotification object:nil];
            break;
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@implementation ViewControllerSub(lv)

- (UIView *)resizableNavigationBarControllerSubHeaderView
{
    if (self.subHeader) {
        return self.subHeader;
    }
    return nil;
}

- (CGFloat)resizableNavigationBarControllerNavigationBarHeight
{
    return self.navigationHeight;
}

- (UIColor *)resizableNavigationBarControllerNavigationBarTintColor
{
    return self.navigationBarColor;
}

@end
