//
//  SearchTapViewController.m
//  TapIt
//
//  Created by Admin on 7/2/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "SearchTapViewController.h"
#import "SocialTempleteModel.h"

@interface SearchTapViewController ()

@end

@implementation SearchTapViewController
@synthesize mapLocationModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - view life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    objMapDirection = [[MapDirectionViewController alloc] initWithNibName:@"MapDirectionViewController" bundle:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [Flurry logPageView];
    [Flurry logEvent:@"Location View"];
    
    
    [lblDistance setFont:[UIFont fontWithName:FONT_BEBASNEUE size:17]];
    [lblMile setFont:[UIFont fontWithName:FONT_DINREGULAR size:13]];
    [lblName setFont:[UIFont fontWithName:FONT_DINBOLD size:14]];
    [lblAddress setFont:[UIFont fontWithName:FONT_DINREGULAR size:12]];
    
    [lblWaterAccessQue setFont:[UIFont fontWithName:FONT_DINENGSCHRIFTSTD size:13]];
    [lblWaterAccessMode setFont:[UIFont fontWithName:FONT_DINENGSCHRIFTSTD size:13]];
    [lblWaterTypeQue setFont:[UIFont fontWithName:FONT_DINENGSCHRIFTSTD size:13]];
    [lblWaterType setFont:[UIFont fontWithName:FONT_DINENGSCHRIFTSTD size:13]];
    [lblNoteQue setFont:[UIFont fontWithName:FONT_DINENGSCHRIFTSTD size:13]];
    [lblNote setFont:[UIFont fontWithName:FONT_DINENGSCHRIFTSTD size:13]];
    
    [btnCall.titleLabel setFont:[UIFont fontWithName:FONT_DINREGULAR size:12]];
    [btnMap.titleLabel setFont:[UIFont fontWithName:FONT_DINREGULAR size:12]];
     
    
    [lblShareByRefill setFont:[UIFont fontWithName:FONT_DINENGSCHRIFTSTD size:13]];

    //For String
    arrFavorites = [[NSMutableArray alloc] init];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"favoristLocations"] length] == 0)
    {
        strFavoriteID = @"";
    }
    else
    {
        strFavoriteID = [[NSUserDefaults standardUserDefaults] objectForKey:@"favoristLocations"];
        arrFavorites = (NSMutableArray *)[strFavoriteID componentsSeparatedByString:@","];
    }
    [self strFavoriteLocationID];
    
    lblDistance.text = [NSString stringWithFormat:@"%.1f",mapLocationModel.distance];//*0.621371
    lblMile.text = @"mi";
    lblName.text = mapLocationModel.name;
    lblAddress.text = mapLocationModel.address;
    lblWaterAccessMode.text = mapLocationModel.waterAccessMode;
    
    if(mapLocationModel.waterType.length==0)
    {
        lblWaterTypeQue.frame = CGRectMake(12, 35, 280, 0);
        lblWaterType.frame = CGRectMake(12, 35, 280, 0);
        lblWaterType.text = @"";
    }
    else
    {
        lblWaterTypeQue.frame = CGRectMake(12, 49, 280, 15);
        float lblHeight = [self getLableHeight:mapLocationModel.waterType :FONT_DINENGSCHRIFTSTD :13.0];
        lblWaterType.numberOfLines = 0;
        lblWaterType.lineBreakMode = NSLineBreakByClipping;
        lblWaterType.frame = CGRectMake(12, 66, 280, 13*lblHeight);
        lblWaterType.text = mapLocationModel.waterType;
    }
    
    if(mapLocationModel.note.length==0)
    {
        lblNoteQue.frame = CGRectMake(0, lblWaterType.frame.origin.y+lblWaterType.frame.size.height, 280, 0);
        lblNote.frame = CGRectMake(0, lblWaterType.frame.origin.y+lblWaterType.frame.size.height, 280, 0);
        
        lblNote.text = @"";
    }
    else
    {
        lblNoteQue.frame = CGRectMake(12, lblWaterType.frame.origin.y+lblWaterType.frame.size.height+5, 280, 15);
        float lblHeight = [self getLableHeight:mapLocationModel.note :FONT_DINENGSCHRIFTSTD :13.0];
        lblNote.numberOfLines = 0;
        lblNote.lineBreakMode = NSLineBreakByClipping;
        lblNote.frame = CGRectMake(12, lblNoteQue.frame.origin.y+lblNoteQue.frame.size.height+3, 280, 13*lblHeight);
        lblNote.text = mapLocationModel.note;
    }
    viewMiddle.frame = CGRectMake(0, 44, 320, lblNote.frame.origin.y+lblNote.frame.size.height+5);
    viewLast.frame = CGRectMake(0, viewMiddle.frame.origin.y+viewMiddle.frame.size.height+3, 320, 132);
    
    lblCall.text = mapLocationModel.businessPhone;
    imgCall.hidden = NO;
    lblCall.hidden = NO;
    btnCall.hidden = NO;
    if(mapLocationModel.businessPhone.length==0)
    {
        imgCall.hidden = YES;
        lblCall.hidden = YES;
        btnCall.hidden = YES;
    }
    
    //scrView.contentSize = CGSizeMake(320, viewLast.frame.origin.y+viewLast.frame.size.height+10);
    
}
- (void) viewWillDisappear:(BOOL)animated
{
    
}

#pragma mark - Custom Method

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (float) getLableHeight : (NSString *) strOfLbl : (NSString *) strFontStyle : (float) fontSize
{
    UILabel *lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 280, 15)];
    lblTemp.font = [UIFont fontWithName:strFontStyle size:fontSize];
    lblTemp.numberOfLines = 0;
    lblTemp.lineBreakMode = NSLineBreakByClipping;
    [lblTemp setText:strOfLbl];
    
    CGRect frame = lblTemp.frame;
    frame.size.width = 280.0f;
    frame.size = [lblTemp sizeThatFits:frame.size];
    lblTemp.frame = frame;
    CGFloat lineHeight = lblTemp.font.leading;
    float linesInLabel = floor(frame.size.height/lineHeight);
    
    return linesInLabel;
}

- (void) fetchSocialTempletText  {
    if(session.isInternetReachable == YES)
    {
        
        NSMutableArray *socialTempletList = [session getSocialTemplet];
        if(session.isResponseSuccess)
        {
            for (int i = 0; i < socialTempletList.count; i++)
            {
                SocialTempleteModel *model = [socialTempletList objectAtIndex:i];
                if ([model.media isEqualToString:@"Facebook"])
                {
                    strFBText = model.templet;
                }
                else if ([model.media isEqualToString:@"Tweeter"])
                {
                    strTwitterText= model.templet;
                }
            }
        }
    }
}

- (void) strFavoriteLocationID
{
    [btnFavorite setImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
    
    for (int i=0; i < [arrFavorites count]; i++)
    {
        int arrId = [[arrFavorites objectAtIndex:i] intValue];
        if(mapLocationModel.ID ==arrId)
        {
            [btnFavorite setImage:[UIImage imageNamed:@"favorite_Selected.png"] forState:UIControlStateNormal];
            return;
        }
    }
}

- (IBAction) favoriteButtonClick:(id)sender
{
    [self setFavoriteLocationId];
}

- (void) setFavoriteLocationId
{
    UIImage *img = [btnFavorite imageForState:UIControlStateNormal];
    if([img isEqual:[UIImage imageNamed:@"favorite_Selected.png"]])
    {
        strFavoriteID = [[NSUserDefaults standardUserDefaults] objectForKey:@"favoristLocations"];
        arrFavorites = (NSMutableArray *)[strFavoriteID componentsSeparatedByString:@","];
        arrFavorites = [arrFavorites mutableCopy];
        for (int i = 0; i < arrFavorites.count; i++)
        {
            if([[arrFavorites objectAtIndex:i]intValue]==mapLocationModel.ID)
            {
                [arrFavorites removeObjectAtIndex:i];
                if(arrFavorites.count >0)
                {
                    strFavoriteID = @"";
                    for(int i = 0; i < arrFavorites.count; i++)
                    {
                        if([strFavoriteID isEqualToString:@""])
                        {
                            strFavoriteID = [arrFavorites objectAtIndex:i];
                        }
                        else
                        {
                            strFavoriteID = [NSString stringWithFormat:@"%@,%@",strFavoriteID,[arrFavorites objectAtIndex:i]];
                        }
                    }
                }
                else
                {
                    strFavoriteID = @"";
                }
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:strFavoriteID forKey:@"favoristLocations"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [btnFavorite setImage:[UIImage imageNamed:@"favorite.png"] forState:UIControlStateNormal];
    }
    else
    {
        if([strFavoriteID isEqualToString:@""])
        {
            strFavoriteID = [NSString stringWithFormat:@"%d",mapLocationModel.ID];
        }
        else
        {
            strFavoriteID = [NSString stringWithFormat:@"%@,%@",strFavoriteID,[NSString stringWithFormat:@"%d",mapLocationModel.ID]];
        }
        [[NSUserDefaults standardUserDefaults] setObject:strFavoriteID forKey:@"favoristLocations"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [btnFavorite setImage:[UIImage imageNamed:@"favorite_Selected.png"] forState:UIControlStateNormal];
    }
    [self performSelectorOnMainThread:@selector(getFavoriteLocationList) withObject:nil waitUntilDone:YES];
}

- (void) getFavoriteLocationList
{
    if(session.isInternetReachable == YES)
    {
        [session getFavoriteLocationList];
    }
}

- (IBAction) backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Call Mothod

- (IBAction) callButtonClick:(id)sender
{    
    [session callNumber:mapLocationModel.businessPhone];
}

#pragma mark - Map View Mothod

- (IBAction) mapDirectionButtonClick:(id)sender
{
    objMapDirection.strAddress = mapLocationModel.name;
    objMapDirection.latEnd = mapLocationModel.latitude;
    objMapDirection.lonEnd = mapLocationModel.longitude;

    [self.navigationController pushViewController:objMapDirection animated:YES];
}

#pragma mark 

- (IBAction) facebookButtonClick:(id)sender
{
    [self fetchSocialTempletText];
    [self facebookPost];
}

- (IBAction) twitterButtonClick:(id)sender
{
    [self fetchSocialTempletText];
    [self twitterPost];
}

- (void) facebookPost
{
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {

                [Flurry logEvent:@"Facebook_Post_Cancelled"];
            
            } else {

                [Flurry logEvent:@"Facebook_Post_Done"];
            }
            
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        
        //Adding the Text to the facebook post value from iOS
        strFBText = [strFBText stringByReplacingOccurrencesOfString:@"***LOCATIONNAME***!" withString:mapLocationModel.name];
        [controller setInitialText:strFBText];
    
        [self presentViewController:controller animated:YES completion:Nil];
}



- (void) twitterPost
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {

                [Flurry logEvent:@"Twitter_Post_Cancelled"];
                
            } else {

                [Flurry logEvent:@"Twitter_Post_Done"];
            }
            
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        
        strTwitterText = [strTwitterText stringByReplacingOccurrencesOfString:@"***LOCATIONNAME***!" withString:mapLocationModel.name];
        [controller setInitialText:strTwitterText];
        [self presentViewController:controller animated:YES completion:Nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
