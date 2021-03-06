//
//  KMMasterViewController.m
//  BlockPatternExampleNoArc
//
//  Created by Kim Hunter on 11/11/12.
//  Copyright (c) 2012 Kim Hunter. All rights reserved.
//

#import "KMMasterViewController.h"

#import "KMDetailViewController.h"
#import "UIColor+BlockPattern.h"

#define BG_RedCheck             @"Red Checkers"
#define BG_RedCircles           @"Red Circles"
#define BG_VerticalStripes      @"Vertical Stripes"
#define ObjectsArray            @[BG_RedCheck, BG_RedCircles, BG_VerticalStripes]



@interface KMMasterViewController () {
    NSArray *_objects;
}
@end

@implementation KMMasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
        _objects = [ObjectsArray retain];
    }
    return self;
}
							
- (void)dealloc
{
    [_detailViewController release];
    [_objects release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }


    NSString *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *object = _objects[indexPath.row];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    if (!self.detailViewController) {
	        self.detailViewController = [[[KMDetailViewController alloc] initWithNibName:@"KMDetailViewController_iPhone" bundle:nil] autorelease];
	    }
	    self.detailViewController.detailItem = object;
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    } else {
        self.detailViewController.detailItem = object;
    }
    [self setBackgroundForCellSelectionText:object];
}

#pragma mark - HOW TO USE BlockPattern Extension

- (void)setBackgroundForCellSelectionText:(NSString *)selectedText
{
    UIColor *backgroundColor = [UIColor grayColor];
    
    if ([selectedText isEqualToString:BG_RedCheck])
    {
        CGRect patternFrame = CGRectMake(0.0, 0.0, 20.0, 20.0);

        backgroundColor = [UIColor colorPatternWithSize:patternFrame.size andDrawingBlock:[[^(CGRect bnds, CGContextRef c) {
            CGContextSetFillColorWithColor(c, [[UIColor whiteColor] CGColor]);
            CGContextFillRect(c, patternFrame);
            CGContextSetFillColorWithColor(c, [[UIColor redColor] CGColor]);
            CGRect checkFrame = CGRectApplyAffineTransform(patternFrame, CGAffineTransformMakeScale(0.5, 0.5));
            CGContextFillRect(c, checkFrame);
            CGContextFillRect(c, CGRectApplyAffineTransform(checkFrame, CGAffineTransformMakeTranslation(CGRectGetWidth(checkFrame), CGRectGetHeight(checkFrame))));
        } copy] autorelease]];
    }
    else if([selectedText isEqualToString:BG_RedCircles])
    {
        backgroundColor = [UIColor colorPatternWithSize:CGSizeMake(20.0, 20.0) andDrawingBlock:^(CGRect bnds, CGContextRef c) {
            CGContextSetFillColorWithColor(c, [[UIColor redColor] CGColor]);
            CGContextFillEllipseInRect(c, bnds);
        }];
    }
    else if ([selectedText isEqualToString:BG_VerticalStripes])
    {
        backgroundColor = [UIColor colorPatternWithSize:CGSizeMake(8.0,1.0) andDrawingBlock:^(CGRect bnds, CGContextRef c) {
            CGContextSetFillColorWithColor(c, [[UIColor colorWithRed:212/255.0 green:217/255.0 blue:226/255.0 alpha:1.0] CGColor]);
            CGContextFillRect(c, CGRectMake(0.0, 0.0, 8.0, 1.0));
            CGContextSetFillColorWithColor(c, [[UIColor colorWithRed:209/255.0 green:213/255.0 blue:223/255.0 alpha:1.0] CGColor]);
            CGContextFillRect(c, CGRectMake(5.0, 0.0, 3.0, 1.0));
        }];
    }
    
    self.detailViewController.view.backgroundColor = backgroundColor;
    
}


@end
