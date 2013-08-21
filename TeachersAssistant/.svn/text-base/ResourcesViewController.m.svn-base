//
//  ResourcesViewController.m
//  TeachersAssistant
//
//  Created by Brian Slick on 9/30/11.
//  Copyright 2011 BriTer Ideas LLC. All rights reserved.
//

#import "ResourcesViewController.h"

// Models and other global

// Sub-controllers
#import "FAQViewController.h"

// Views

// Private Constants
#define kLinkKey					@"Link"
#define kTitleKey					@"Title"

#define kCSVTemplateRowKey			@"Email Import CSV Template"

@interface ResourcesViewController ()

// Private Properties
@property (nonatomic, retain) NSArray *sectionKeys;
@property (nonatomic, retain) NSMutableDictionary *sectionContents;

// Notification Handlers
- (void)applicationDidEnterBackground:(NSNotification *)notification;


// UI Response Methods



// Misc Methods
- (void)sendCSVTemplateEmail;

@end

@implementation ResourcesViewController

#pragma mark - Synthesized Properties

// Public
@synthesize mainTableView = ivMainTableView;

// Private
@synthesize sectionKeys = ivSectionKeys;
@synthesize sectionContents = ivSectionContents;

#pragma mark - Dealloc and Memory Methods

- (void)dealloc
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	// Clear delegates and other global references
	
	// Public Properties
	[self setMainTableView:nil];
	
	
	// Private Properties
	[self setSectionKeys:nil];
	[self setSectionContents:nil];
	
	
    [super dealloc];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidUnload
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidUnload];
	
	[self setMainTableView:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Custom Getters and Setters

- (NSArray *)sectionKeys
{
	if (ivSectionKeys == nil)
	{
		ivSectionKeys = [[NSArray alloc] init];
	}
	return ivSectionKeys;
}

- (NSMutableDictionary *)sectionContents
{
	if (ivSectionContents == nil)
	{
		ivSectionContents = [[NSMutableDictionary alloc] init];
	}
	return ivSectionContents;
}

#pragma mark - Initialization and UI Creation Methods


#pragma mark - UIViewController Methods

- (void)viewDidLoad
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    [super viewDidLoad];
	
	[self setTitle:@"Resources"];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillAppear:animated];
	
	[[self navigationController] setToolbarHidden:YES animated:YES];
	
	NSString *faqHeader = @"FAQ";
	
	NSMutableDictionary *faq1 = [NSMutableDictionary dictionary];
	[faq1 setObject:@"Frequently Asked Questions" forKey:kTitleKey];
	
	NSArray *faqs = [NSArray arrayWithObject:faq1];
	
	[[self sectionContents] setObject:faqs forKey:faqHeader];
	
	// Videos
	
	NSString *youtubeHeader = @"Help";
	
	NSMutableDictionary *video1 = [NSMutableDictionary dictionary];
	[video1	setObject:@"http://www.youtube.com/watch?v=kSW4UOInhy0" forKey:kLinkKey];
	[video1 setObject:@"What's New?" forKey:kTitleKey];
	
	NSMutableDictionary *video2 = [NSMutableDictionary dictionary];
	[video2 setObject:@"http://www.youtube.com/watch?v=EQUO4lyksbQ" forKey:kLinkKey];
	[video2 setObject:@"Import/Export" forKey:kTitleKey];
	
	NSMutableDictionary *video3 = [NSMutableDictionary dictionary];
	[video3 setObject:@"http://www.youtube.com/watch?v=XK-OYSBIC6w" forKey:kLinkKey];
	[video3 setObject:@"Overview Video" forKey:kTitleKey];
	
	NSMutableDictionary *video4 = [NSMutableDictionary dictionary];
	[video4 setObject:@"http://www.youtube.com/watch?v=D2kd-APENUs" forKey:kLinkKey];
	[video4 setObject:@"Adding Data" forKey:kTitleKey];
	
	NSMutableDictionary *video5 = [NSMutableDictionary dictionary];
	[video5	setObject:@"http://www.youtube.com/watch?v=gMvZkNFJW2k" forKey:kLinkKey];
	[video5 setObject:@"Deleting Data" forKey:kTitleKey];
	
	NSMutableDictionary *video6 = [NSMutableDictionary dictionary];
	[video6	setObject:@"http://www.youtube.com/watch?v=vB7CUwRAxmY" forKey:kLinkKey];
	[video6 setObject:@"Add Action for Many Students" forKey:kTitleKey];
	
	NSMutableDictionary *video7 = [NSMutableDictionary dictionary];
	[video7	setObject:@"http://www.youtube.com/watch?v=OFdtu6FZK5o" forKey:kLinkKey];
	[video7 setObject:@"Date ranges & Quick Jump" forKey:kTitleKey];
    
    NSMutableDictionary *video8 = [NSMutableDictionary dictionary];
	[video8	setObject:@"http://www.youtube.com/watch?v=dAI18wVnaZ8" forKey:kLinkKey];
	[video8 setObject:@"Randomizer" forKey:kTitleKey];
	
	NSMutableDictionary *video9 = [NSMutableDictionary dictionary];
	[video9	setObject:@"http://www.youtube.com/watch?v=JzTnTH612l8" forKey:kLinkKey];
	[video9 setObject:@"Set Default Action Values" forKey:kTitleKey];
	
	NSMutableDictionary *video10 = [NSMutableDictionary dictionary];
	[video10 setObject:@"http://www.youtube.com/watch?v=i_Obk93-DoE" forKey:kLinkKey];
	[video10 setObject:@"Complete Customization" forKey:kTitleKey];
    
    NSMutableDictionary *video11 = [NSMutableDictionary dictionary];
	[video11 setObject:@"http://www.youtube.com/watch?v=hkMGD5ke2Oc" forKey:kLinkKey];
	[video11 setObject:@"Email Blast" forKey:kTitleKey];
	
	NSMutableDictionary *video12 = [NSMutableDictionary dictionary];
	[video12 setObject:@"http://www.youtube.com/watch?v=x8TSg8CB_Gc" forKey:kLinkKey];
	[video12 setObject:@"Actions w/Points & Colors" forKey:kTitleKey];
	
	NSMutableDictionary *video13 = [NSMutableDictionary dictionary];
	[video13 setObject:@"http://www.youtube.com/watch?v=ChnrSmnehDM" forKey:kLinkKey];
	[video13 setObject:@"PIN Code Security" forKey:kTitleKey];
	
	NSMutableDictionary *video14 = [NSMutableDictionary dictionary];
	[video14 setObject:@"http://www.youtube.com/watch?v=WpCJkK4eqvI" forKey:kLinkKey];
	[video14 setObject:@"Filter & Search" forKey:kTitleKey];
	
	NSMutableDictionary *video15 = [NSMutableDictionary dictionary];
	[video15 setObject:@"http://www.youtube.com/watch?v=vZg39BCzw7Q" forKey:kLinkKey];
	[video15 setObject:@"Change the Default iPad Logo" forKey:kTitleKey];
    
    NSMutableDictionary *video16 = [NSMutableDictionary dictionary];
	[video16 setObject:@"http://www.youtube.com/watch?v=XsNl3hMBWoY" forKey:kLinkKey];
	[video16 setObject:@"Quickly Back Up Data" forKey:kTitleKey];

    
    
	
	NSMutableDictionary *template = [NSMutableDictionary dictionary];
	[template setObject:kCSVTemplateRowKey forKey:kTitleKey];
	
	NSArray *videos = [NSArray arrayWithObjects:video1, video2, video3, video4, video5, video6, video7, video8, video9, video10, video11, video12, video13, video14, video15, video16, template, nil];
	
	[[self sectionContents] setObject:videos forKey:youtubeHeader];
	
	
	// Support
	
	NSString *helpHeader = @"Support/Suggestions";
	
	NSMutableDictionary *help1 = [NSMutableDictionary dictionary];
	[help1 setObject:@"mailto:" forKey:kLinkKey];		// @"mailto:chris@cleveriosapps.com?subject=Teachers-Assistant-App-V5.4"
	[help1 setObject:@"Email" forKey:kTitleKey];
	
	NSMutableDictionary *help2 = [NSMutableDictionary dictionary];
	[help2 setObject:@"http://www.teachersassistantpro.com" forKey:kLinkKey];
	[help2 setObject:@"Home Page" forKey:kTitleKey];
	
	
	NSArray *help = [NSArray arrayWithObjects:help1, help2, nil];
	
	[[self sectionContents] setObject:help forKey:helpHeader];

	
	// Write a review
	
	NSString *rateHeader = @"Write a Review";
	
	NSMutableDictionary *rate1 = [NSMutableDictionary dictionary];
	[rate1 setObject:@"http://itunes.apple.com/us/app/teachers-assistant-pro-track/id391643755?mt=8" forKey:kLinkKey];
	[rate1 setObject:@"Positive Reviews, Please!" forKey:kTitleKey];
	
	
	NSArray *rate = [NSArray arrayWithObjects:rate1, nil];
	
	[[self sectionContents] setObject:rate forKey:rateHeader];
	
	// Social Media
	
	NSString *socialHeader = @"Social Media";
	
	NSMutableDictionary *media1 = [NSMutableDictionary dictionary];
	[media1 setObject:@"http://www.twitter.com/cleveriosapps" forKey:kLinkKey];
	[media1 setObject:@"Twitter" forKey:kTitleKey];
	
	NSMutableDictionary *media2 = [NSMutableDictionary dictionary];
	[media2 setObject:@"http://www.facebook.com/pages/Teachers-Assistant-iPhoneiPad-App-Track-Behavior-and-Classroom-Habits/144086735641352" forKey:kLinkKey];
	[media2 setObject:@"Facebook" forKey:kTitleKey];
	
	
	NSArray *links = [NSArray arrayWithObjects:media1, media2, nil];
	
	[[self sectionContents] setObject:links forKey:socialHeader];
	
	
	[self setSectionKeys:[NSArray arrayWithObjects:faqHeader, youtubeHeader, helpHeader, rateHeader, socialHeader, nil]];
	
	[[self mainTableView] reloadData];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidAppear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidAppear:animated];
	
	
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewWillDisappear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewWillDisappear:animated];
	
	
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)viewDidDisappear:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super viewDidDisappear:animated];
	
	
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

- (void)setEditing:(BOOL)editing
		  animated:(BOOL)animated
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[super setEditing:editing animated:animated];
	
	[[self mainTableView] setEditing:editing animated:animated];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - Notification Handlers

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	if ([self modalViewController] != nil)
	{
		[self dismissModalViewControllerAnimated:NO];
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UI Response Methods



#pragma mark - Misc Methods

- (void)sendCSVTemplateEmail
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationDidEnterBackground:)
												 name:UIApplicationDidEnterBackgroundNotification 
											   object:nil];

	[ImportCSVViewController emailTemplateCSVFileFromViewController:self];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSInteger sections = [[self sectionKeys] count];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return sections;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSString *header = [[self sectionKeys] objectAtIndex:section];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return header;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSString *key = [[self sectionKeys] objectAtIndex:section];
	NSArray *contents = [[self sectionContents] objectForKey:key];
	
	NSInteger rows = [contents count];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	NSString *key = [[self sectionKeys] objectAtIndex:[indexPath section]];
	NSArray *contents = [[self sectionContents] objectForKey:key];
	NSDictionary *rowContents = [contents objectAtIndex:[indexPath row]];
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
	
	[[cell textLabel] setText:[rowContents objectForKey:kTitleKey]];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
	return cell;
}

#pragma mark -
#pragma mark UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSString *key = [[self sectionKeys] objectAtIndex:[indexPath section]];
	
	if ([key isEqualToString:@"FAQ"])
	{
		FAQViewController *faqViewController = [[FAQViewController alloc] init];
		UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:faqViewController];
		
		[self presentModalViewController:navController animated:YES];
		
		[navController release], navController = nil;
		[faqViewController release], faqViewController = nil;
	}
	else
	{
		NSArray *contents = [[self sectionContents] objectForKey:key];
		NSDictionary *rowContents = [contents objectAtIndex:[indexPath row]];
		
		NSString *rowTitle = [rowContents objectForKey:kTitleKey];
		
		if ([rowTitle isEqualToString:kCSVTemplateRowKey])
		{
			[self sendCSVTemplateEmail];
		}
		else
		{
			NSString *linkString = [rowContents objectForKey:kLinkKey];
			
			if ([linkString hasPrefix:@"mailto:"])		// Support email
			{
				DataController *dataController = [DataController sharedDataController];
				
				if ([dataController isIPadVersion])
				{
					[dataController sendSupportEmailFromViewController:[self splitViewController]];
				}
				else
				{
					[dataController sendSupportEmailFromViewController:[self navigationController]];
				}
			}
			else 
			{
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[rowContents objectForKey:kLinkKey]]];
			}
			
			
		}
	}
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

#pragma mark -
#pragma mark MFMailComposeViewController Delegate Methods

- (void)mailComposeController:(MFMailComposeViewController *)controller
		  didFinishWithResult:(MFMailComposeResult)result
						error:(NSError *)error 
{   
	NSLog(@">>> Entering %s <<<", __PRETTY_FUNCTION__);
	
    switch (result)
    {
		case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
		default:
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Error"
															message:@"Unknown error. Your mail was not sent."
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
			[alert show];
			[alert release], alert = nil;
		}
			break;
    }
	
    [self dismissModalViewControllerAnimated:YES];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIApplicationDidEnterBackgroundNotification 
												  object:nil];
	
	NSLog(@"<<< Leaving %s >>>", __PRETTY_FUNCTION__);
}

@end
