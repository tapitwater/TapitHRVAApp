//
//  FavoriteViewController.m
//  TapIt
//
//  Created by Admin on 7/2/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "FavoriteViewController.h"
#import "SearchResultTableCell.h"

@interface FavoriteViewController ()

@end

@implementation FavoriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Favorite", @"Favorite");
        self.tabBarItem.image = [UIImage imageNamed:@"Favorite"];
    }
    return self;
}
#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (void) viewWillAppear:(BOOL)animated
{
    [Flurry logPageView];
    [Flurry logEvent:@"Favorite View"];

    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"favoristLocations"] length] == 0)
    {
        strFavoriteID = @"";
    }
    else
    {
    }
    
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"favoristLocations"];
    if(str.length == 0)
    {
        [session.favoriteLocationList removeAllObjects];
    }
    [tblView reloadData];
}

#pragma mark - Custom Method

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction) mapTabButtonClick:(id)sender
{
    session.myTab1.selectedIndex = 2;
    session.myTab1.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
}

- (void) fetchFavorites  {
    
    @autoreleasepool {
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    }
    
    if(session.favoriteLocationList.count == 0)
    {
        [session.favoriteLocationList removeAllObjects];
        [tblView reloadData];
    }
    else
    {
        // Reload Table Content
        [tblView reloadData];
    }
}

#pragma mark - Table View Datasource Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [session.favoriteLocationList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"SearchResultTableCell";
    SearchResultTableCell *cell = (SearchResultTableCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SearchResultTableCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }

    //Selected Bg
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.selectedBackgroundView = cell.vwSelected;
    
    FavoriteModel *model = [session.favoriteLocationList objectAtIndex:indexPath.row];
    cell.lblDistance.text = [NSString stringWithFormat:@"%.1f",model.distance];
    cell.lblTitle.text = model.name;
    cell.lblAddress.text = model.address;
    
    [cell.lblDistance setFont:[UIFont fontWithName:FONT_BEBASNEUE size:17]];
    [cell.lblMile setFont:[UIFont fontWithName:FONT_DINREGULAR size:13]];
    [cell.lblTitle setFont:[UIFont fontWithName:FONT_DINBOLD size:14]];
    [cell.lblAddress setFont:[UIFont fontWithName:FONT_DINREGULAR size:12]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    objSearchTap = [[SearchTapViewController alloc] initWithNibName:@"SearchTapViewController" bundle:nil];
    objSearchTap.mapLocationModel = [session.favoriteLocationList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:objSearchTap animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
