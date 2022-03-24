//
//  UIViewController+ViewControllerResizeScroll.h
//  WTNavigationExample
//
//  Created by Mac on 27/4/2564 BE.
//  Copyright © 2564 BE wtanuw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewControllerResizeScroll: UITableViewController<UITableViewDelegate,UITableViewDataSource>
+ (UINavigationController*)navigationControllerWithStoryboard;
@end

NS_ASSUME_NONNULL_END
