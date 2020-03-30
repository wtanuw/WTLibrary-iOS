//
//  ViewController.m
//  WTStoreKitExample
//
//  Created by imac on 4/9/19.
//  Copyright © 2019 wtanuw. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

//@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *array;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"restore" style:UIBarButtonItemStylePlain target:self action:@selector(restoreButtonPressed:)];
    self.navigationItem.rightBarButtonItem = barButton;
    
    
    [WTStoreKit sharedManager].storeDelegate = self;
    
    [[WTStoreKit sharedManager] addSubScriptionProductIdentifier:@"monthlysub" withSharedSecretPassword:@"873d18e72f0b4098b1a8abf726208d7f"];
    [[WTStoreKit sharedManager] requestProduct:
     [NSSet setWithArray:@[
                           //                           @"klang2.product000",
                           //                           @"klang2.product000nothost",
                           @"monthlysub",
                           @"item1",
                           @"info.acetech.RealEstateManagement.item2",
                           @"info.acetech.realestate.item3",
                           @"klang2.product001",@"klang2.product002",@"klang2.product003",
                           @"klang2.product004",@"klang2.product005",@"klang2.product006",
                           @"klang2.product007",@"klang2.product008",@"klang2.product009",
                           @"klang2.product010",@"klang2.product011",@"klang2.product012",
                           @"klang2.product013",@"klang2.product014",@"klang2.product015",
                           @"klang2.product016",@"klang2.product017",@"klang2.product018",
                           @"klang2.product019",@"klang2.product020",@"klang2.product021",
                           @"klang2.product022",@"klang2.product023",@"klang2.product024",
                           @"klang2.product025",@"klang2.product026",@"klang2.product027",
                           @"klang2.product028",@"klang2.product029",@"klang2.product030",
                           ]]
     ];
}

- (IBAction)restoreButtonPressed:(id)sender
{
    [[WTStoreKit sharedManager] restoreTransactions];
}

#pragma mark - UITableViewDataSource Require

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"data"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"data"];
    }
    
    WTStoreProduct *storeProduct = [_array objectAtIndex:indexPath.row];
    
    cell.textLabel.text = storeProduct.productIdentifier;
    
    return cell;
}

#pragma mark - UITableViewDataSource Optional

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 1;
}
#pragma mark -

- (void)WTStoreKitProductFetchComplete:(NSArray<WTStoreProduct*>*)productsInformation
{
    self.array = productsInformation;
    [self.tableView reloadData];
    
}

- (void)WTStoreKitRestoreProduct:(NSString *)productIdentifier fromTransaction:(SKPaymentTransaction *)transaction successWithValid:(BOOL)valid
{
    
}


@end
