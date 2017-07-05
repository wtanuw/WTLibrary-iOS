//
//  WTViewController.m
//  WTLibrary-iOS
//
//  Created by wtanuw on 07/05/2017.
//  Copyright (c) 2017 wtanuw. All rights reserved.
//

#import "WTViewController.h"
#import "WTGoogleDriveManager.h"
#import "WTDropboxManager.h"
//#import <GoogleSignIn/GoogleSignIn.h>
//#import "GoogleSignIn/GoogleSignIn.h"

@interface WTViewController ()
    
    @end

@implementation WTViewController
    
- (void)viewDidLoad
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
    }
    
- (void)didReceiveMemoryWarning
    {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }
    
-(void)shfk
    {
        [WTGoogleDriveManager sharedManager];
        [WTDropboxManager sharedManager];
    }

@end
