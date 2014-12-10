//
//  InfoViewController.m
//  TapIt
//
//  Created by Admin on 7/2/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "InfoViewController.h"
#import "InfoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "InfoAboutModel.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Info", @"Info");
        self.tabBarItem.image = [UIImage imageNamed:@"Info"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrayInfo = [[NSMutableArray alloc] init];
}


- (void) viewWillAppear:(BOOL)animated
{
    [Flurry logPageView];
    [Flurry logEvent:@"Info View"];
    //[Flurry logError:@"ERROR_NAME" message:@"ERROR_MESSAGE" exception:e];

    //[self performSelectorOnMainThread:@selector(getInfoAbout) withObject:nil waitUntilDone:YES];
    [arrayInfo removeAllObjects];
    arrayInfo = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getInfoAbout];
    });
}

#pragma mark  - Custom Method

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void) getInfoAbout
{
    NSLog(@"Session = %@", session);
    if(session.isInternetReachable == YES)
    {
        [self fetchInfoAbout];
    }
}

- (IBAction) mapTabButtonClick:(id)sender
{
    session.myTab1.selectedIndex = 2;
    session.myTab1.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
}

- (void) urlButtonClick : (UIButton *) sender
{
    InfoAboutModel *model = [arrayInfo objectAtIndex:sender.tag];
    
    [session openWebURL:model.linkUrl];
}

- (void) fetchInfoAbout  {
    
    arrayInfo = [session getInfoAbout];
    if(arrayInfo.count != 0)
    {
        [tblView reloadData];
    }
}
#pragma mark - Table View Datasource Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [arrayInfo count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoAboutModel *model = [arrayInfo objectAtIndex:indexPath.row];
    
    UILabel *lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 300, 13)];
    lblTemp.font = [UIFont fontWithName:FONT_DINREGULAR size:12];
    lblTemp.numberOfLines = 0;
    lblTemp.lineBreakMode = NSLineBreakByClipping;
    [lblTemp setText:model.detail];
    
    CGRect frame = lblTemp.frame;
    frame.size.width = 300.0f;
    frame.size = [lblTemp sizeThatFits:frame.size];
    lblTemp.frame = frame;
    CGFloat lineHeight = lblTemp.font.leading;
    float linesInLabel = floor(frame.size.height/lineHeight);
    
    return 55+((linesInLabel)*15) + 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"InfoCell";
    InfoCell *cell = (InfoCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"InfoCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    InfoAboutModel *model = [arrayInfo objectAtIndex:indexPath.row];
    
    NSString *strUrl = model.imageUrl;
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *url = [NSURL URLWithString:strUrl];
    cell.imgLogo.contentMode = UIViewContentModeScaleAspectFit;
    cell.imgLogo.frame = CGRectMake(10, 5, 300, 45);
    [cell.imgLogo setImageWithURL:url];
    
    float imgY = cell.imgLogo.frame.origin.y + cell.imgLogo.frame.size.height+5;
    cell.lblDetail.frame = CGRectMake(10, imgY, 300, 13);
    cell.lblDetail.numberOfLines = 0;
    cell.lblDetail.lineBreakMode = NSLineBreakByClipping;
    [cell.lblDetail setFont:[UIFont fontWithName:FONT_DINREGULAR size:12]];
    [cell.lblDetail setText:model.detail];
    CGRect frame = cell.lblDetail.frame;
    frame.size.width = 300.0f;
    frame.size = [cell.lblDetail sizeThatFits:frame.size];
    cell.lblDetail.frame = frame;
    
    float lblUrlY = cell.lblDetail.frame.origin.y + cell.lblDetail.frame.size.height + 10;
    cell.btnUrl.frame = CGRectMake(10, lblUrlY, 300, 30);
    [cell.btnUrl setTitle:model.linkUrl forState:UIControlStateNormal];
    cell.btnUrl.tag = indexPath.row;
    [cell.btnUrl.titleLabel setFont:[UIFont fontWithName:FONT_DINREGULAR size:12]];
    [cell.btnUrl addTarget:self action:@selector(urlButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    float viewY = cell.btnUrl.frame.origin.y + cell.btnUrl.frame.size.height+10;
    cell.viewSepreateLine.frame = CGRectMake(10, viewY, 300, 1);
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
