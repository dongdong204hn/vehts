//
//  NewViewController.m
//  VOA
//
//  Created by song zhao on 12-2-2.
//  Copyright (c) 2012年 buaa. All rights rese/Users/zhaosong/workplace/VOA/VOA/PlayViewController.xibrved.
//

#import "NewController.h"
#import "database.h"
#import "UIImageView+WebCache.h"

@implementation NewController

@synthesize voasArray;
@synthesize lastId;
@synthesize addNum;
@synthesize pageNum;
//@synthesize isExisitNet;
@synthesize rightCharacter;
@synthesize reloading = _reloading;
@synthesize isiPhone;
@synthesize search;
@synthesize voasTableView;
@synthesize HUD;
@synthesize refreshHeaderView;
@synthesize sharedSingleQueue;
@synthesize notSelect;
//@synthesize flushList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        NSLog(@"%@",nibNameOrNil);

    }

    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - My Action
- (NSOperationQueue *)sharedQueue
{
//    static NSOperationQueue *sharedSingleQueue;
    
    @synchronized(self)
    {
        if (!sharedSingleQueue){
            sharedSingleQueue = [[NSOperationQueue alloc] init];
            [sharedSingleQueue setMaxConcurrentOperationCount:1];
        }
        return sharedSingleQueue;
    }
}

- (void)doReturn
{
    HUD = [[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES] retain];
    HUD.dimBackground = YES;
    HUD.labelText = @"Loading!";    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{  
        
        dispatch_async(dispatch_get_main_queue(), ^{  
            PlayerViewController *play = [PlayerViewController sharedPlayer];//新建新界面的controller实例
            if(play.voa._voaid > 0 )
            {
                play.newFile = NO;
            }else
            {
                play.newFile = YES;
                NSInteger voaid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"lastPlay"] integerValue];
                if (voaid > 0) {
                    play.voa = [VOAView find:voaid];
                    play.contentMode = [[NSUserDefaults standardUserDefaults] integerForKey:@"contentMode"];
                }else
                {
                    play.voa = [VOAView find:20001];
                    play.voa._isRead = @"1";
                    play.contentMode =1;
                }
            }
//            if (play.contentMode == 2) {
//                play.flushList = YES;
//                play.contentMode =1;
//            }
            
            [play setHidesBottomBarWhenPushed:YES];//设置推到新界面时无bottomBar
            [self.navigationController pushViewController:play animated:NO]; 
            [HUD hide:YES];
        });  
    });
}

- (void)doSearch
{
    if (isiPhone) {
//        UIDevice *device = [UIDevice currentDevice] ;
        if (kIsLandscapeTest) {
            [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
            [voasTableView setFrame:CGRectMake(0, 44, kScreenHeight, kViewHeight)];
        } else {
            [search setFrame:CGRectMake(0, 0, 320, 44)];
            [voasTableView setFrame:CGRectMake(0, 44, 320, kViewHeight)];
        }
    }else {
        if (kIsLandscapeTest) {
            [search setFrame:CGRectMake(0, 0, 1024, 44)];
            [voasTableView setFrame:CGRectMake(0, 44, 1024, 660)];
        } else {
            [search setFrame:CGRectMake(0, 0, 768, 44)];
            [voasTableView setFrame:CGRectMake(0, 44, 768, 916)];
        }
    }
    self.navigationController.navigationBarHidden = YES;
    [search setHidden:NO];
}

//- (BOOL)isPad {
//	BOOL isPad = NO;
//#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 30200)
//	isPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
//#endif
//	return isPad;
//}


#pragma mark - View lifecycle

/*
 * 获取数据库中数据并存入voasArray，基于此数组数据建立tableView
 */
- (void) viewWillAppear:(BOOL)animated {
//    [self pushToken:@"test song"];//测试发送token
//    [self.voasTableView reloadData];
//    [self viewRorateResize];
    
    kNetTest;
    notSelect = YES;
//    [self catchNetA];
//    NSLog(@"最新");
    [self setTitle:kNewThree];
//    isExisitNet = [self isExistenceNetwork:0];    [self.voasTableView reloadData];//reloadData只能保证tableView重读数据，但是数据的改变要靠自己手动才行。
    [search setPlaceholder:kNewOne];
    self.navigationController.navigationBarHidden = NO;
    [voasTableView setUserInteractionEnabled:YES];
    if (isiPhone) {
//        UIDevice *device = [UIDevice currentDevice] ;
        if (kIsLandscapeTest) {
            [voasTableView setFrame:CGRectMake(0, 0, kScreenHeight, kViewHeight)];
            [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
        } else {
            [voasTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
            [search setFrame:CGRectMake(0, 0, 320, 44)];
        }
        
    }else {
        if (kIsLandscapeTest) {
            [voasTableView setFrame:CGRectMake(0, 0, 1024, kViewHeight)];
            [search setFrame:CGRectMake(0, 0, 1024, 44)];
        } else {
            [voasTableView setFrame:CGRectMake(0, 0, 768, kViewHeight)];
            [search setFrame:CGRectMake(0, 0, 768, 44)];
        }
    }
    [search setBackgroundColor:[UIColor clearColor]];
	[search setHidden:YES];
//    kLandscapeTest;
    //    [self viewRorateResize];
    [voasTableView reloadData];
//    [self viewRorateResize];
//    NSLog(@"w: %f x: %f" , voasTableView.frame.size.width , voasTableView.frame.origin.x);
//    [self.view setNeedsLayout];
//    [self.navigationController.view setNeedsDisplay];
    
}

- (void)viewRorateResize {
    if (isiPhone) {
        if (kIsLandscapeTest) {
            if (self.navigationController.navigationBarHidden) {
//                NSLog(@"nav隐藏");
                [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
                [voasTableView setFrame:CGRectMake(0, 44, kScreenHeight, kViewHeight)];
            } else {
//                NSLog(@"nav显示");
                if (kPlayerIsExist) {
//                    NSLog(@"特殊");
                    [voasTableView setFrame:CGRectMake(0, 30, kScreenHeight, kViewHeight)];
                } else {
                    [voasTableView setFrame:CGRectMake(0, 0, kScreenHeight, kViewHeight)];
                }
            }
        } else {
            if (self.navigationController.navigationBarHidden) {
                [search setFrame:CGRectMake(0, 0, 320, 44)];
                [voasTableView setFrame:CGRectMake(0, 44, 320, kViewHeight)];
            } else {
                if (kPlayerIsExist) {
//                    NSLog(@"特殊");
                    [voasTableView setFrame:CGRectMake(0, 44, 320, kViewHeight)];
                } else {
                    [voasTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
                }
//                [voasTableView setFrame:CGRectMake(0, 0, 320, 372)];
            }
        }
    } else {
        if (kIsLandscapeTest) {
            if (self.navigationController.navigationBarHidden) {
                [search setFrame:CGRectMake(0, 0, 1024, 44)];
                [voasTableView setFrame:CGRectMake(0, 44, 1024, 668)];
            } else {
                if (kPlayerIsExist) {
                    //                    NSLog(@"特殊");
                    [voasTableView setFrame:CGRectMake(0, 30, 1024, 668)];
                } else {
                    [voasTableView setFrame:CGRectMake(0, 0, 1024, 668)];
                }
            }
        } else {
            if (self.navigationController.navigationBarHidden) {
                [search setFrame:CGRectMake(0, 0, 768, 44)];
                [voasTableView setFrame:CGRectMake(0, 44, 768, 916)];
            } else {
                if (kPlayerIsExist) {
                    //                    NSLog(@"特殊");
                    [voasTableView setFrame:CGRectMake(0, 40, 768, 916)];
                } else {
                    [voasTableView setFrame:CGRectMake(0, 0, 768, 916)];
                }
//                [voasTableView setFrame:CGRectMake(0, 0, 768, 916)];
            }
        }
    }
//    [voasTableView reloadData];
}

- (void)viewDidLoad
{
//    NSLog(@"0");
    [super viewDidLoad];
//    isExisitNet = NO;
    
//    if (kNetIsExist) {
//        NSLog(@"很好用的网络判定哦");
//        kNetDisable;
//        if (!kNetIsExist) {
//            NSLog(@"网络真的木有啦");
//        }
//    }
    isiPhone = ![Constants isPad];
    
    voasArray = [[NSMutableArray alloc]init];
    search = [[UISearchBar alloc]  initWithFrame:CGRectMake(0, 0, 320, 44)];
    search.delegate = self;
    search.autoresizesSubviews = YES;
    //    [search setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"title.png"]]];
    search.backgroundColor = [UIColor clearColor];
//    [search setFrame:CGRectMake(0, 0, 320, 30)];
    [search setTintColor:[UIColor colorWithRed:0.427f green:0.753f blue:0.173f alpha:1.0f]];
//    [search setTintColor:[UIColor colorWithRed:0.863f green:0.957f blue:0.827f alpha:1.0f]];
    [self.view addSubview:search];
    [search release];//$$
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(doSearch)];
	self.navigationItem.leftBarButtonItem = editButton;
    [editButton release], editButton = nil;
    
//    UIBarButtonItem *returnButton = [[UIBarButtonItem alloc] initWithTitle:kNewTwo style:UIBarButtonItemStylePlain target:self action:@selector(doReturn)];
    UIBarButtonItem *returnButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"playingBBC.png"] style:UIBarButtonItemStylePlain target:self action:@selector(doReturn)];
//    UIButton * imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    if (isiPhone) {
//        [imgBtn setBackgroundImage:[UIImage imageWithContentsOfFile:
//                                    [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"playingBBC"] ofType:@"png"]] 
//                          forState:UIControlStateNormal];
//    } else {
//        [imgBtn setBackgroundImage:[UIImage imageWithContentsOfFile:
//                                    [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"playingBBCP"] ofType:@"png"]] 
//                          forState:UIControlStateNormal];
//    }
//    
//    [imgBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
//    imgBtn.frame = CGRectMake(0, 0, 30, 25);
//    
//    UIBarButtonItem *returnButton = [[UIBarButtonItem alloc] initWithCustomView:imgBtn];
	self.navigationItem.rightBarButtonItem = returnButton;
    [returnButton release], returnButton = nil;
    
//    UIBarButtonItemStylePlain
//    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] init];
    
//    search.backgroundImage = [UIImage imageNamed:@"searchbg-ipad@2x.png"];
//    [search setKeyboardType:UIKeyboardAppearanceAlert];
//    search.backgroundColor = [UIColor clearColor];
    self.title = kNewThree;
//    HUD = [[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES] retain];
//    HUD.dimBackground = YES;
//    HUD.labelText = kNewFour;
//    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//        
//        dispatch_async(dispatch_get_main_queue(), ^{  
            self.lastId = [VOAView findLastId];
//            isExisitNet = [self isExistenceNetwork:0];
            pageNum = 1;
//            if (isExisitNet) {
//                [self catchIntroduction:0 pages:pageNum pageNum:10 ];
//            }
            self.voasArray = [VOAView findNew:10*(pageNum-1) newVoas:self.voasArray];
            pageNum++;
            addNum = 10;
//            NSLog(@"lastId:%d",lastId);
            [self.voasTableView reloadData];
//            [HUD hide:YES];
//        });  
//    }); 
    if(_refreshHeaderView == nil){
        EGORefreshTableHeaderView *view =[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.voasTableView.bounds.size.height, self.voasTableView.bounds.size.width, self.voasTableView.bounds.size.height)];
        view.delegate = self;
        [self.voasTableView addSubview:view];
        _refreshHeaderView = view;
//        [view release];
    }
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];

}

- (void)viewDidUnload
{
    self.voasTableView = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    NSLog(@"检测");
//    [voasTableView reloadData];
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    NSLog(@"转向");
//    kLandscapeTest;
//    [voasTableView reloadData];
//    [self viewRorateResize];
//    [self.view setNeedsLayout];//关键函数 保证界面的整齐
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    kLandscapeTest;
//    NSLog(@" 、、转向");
    [self.voasTableView reloadData];
    [self viewRorateResize];
}

- (void)dealloc {
    [self.voasTableView release], voasTableView = nil;
    [self.voasArray release], voasArray = nil;
    [self.sharedSingleQueue release], sharedSingleQueue = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
-(void)reloadTableViewDataSource{
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    
//    NSLog(@"isExisitNet:%d",isExisitNet);
    if (kNetIsExist) {
//        NSLog(@"开始刷新");
        
        [self catchIntroduction:20000 pages:1 pageNum:10 ];
        
//        pageNum = 1;
//        NSArray *voas = [[NSArray alloc] init];
//        //    NSLog(@"获取生词到:%d",nowUserId);
//        voas = [VOAView findNew:10*(pageNum-1) newVoas:self.voasArray];;
//        [voasArray removeAllObjects];
//        for (id fav in voas) {
//            [voasArray addObject:fav];
//        }
//        pageNum++;
//        addNum = 10;
//        [voas release], voas = nil;
        
//        [self.voasArray removeAllObjects];
//        [self catchIntroduction:0 pages:1 pageNum:10 ];
//        pageNum = 1;
//        self.voasArray = [VOAView findNew:10*(pageNum-1) newVoas:self.voasArray];
//        pageNum++;
//        addNum = 10;
        
    }
    _reloading =YES;
//    [self doneLoadingTableViewData];
}
-(void)doneLoadingTableViewData{
    //  model should call this when its done loading
    if (_reloading) {
        _reloading =NO;
        
        if (kNetIsExist) {
            //        NSLog(@"结束刷新");
            
            [self.voasArray removeAllObjects];
            pageNum = 1;
            self.voasArray = [VOAView findNew:10*(pageNum-1) newVoas:self.voasArray];
            pageNum++;
            addNum = 10;
            [self.voasTableView reloadData];
        }
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.voasTableView];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
//    NSThread * thread = [[NSThread alloc] initWithTarget:self selector:@selector(reloadTableViewDataSource) object:nil];
//    [thread start];
//    [self catchNetA];
    kNetTest;
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:6.0];
}
-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
}
-(NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return[NSDate date]; // should return date data source was last changed
}

#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView //明确cell数目
 numberOfRowsInSection:(NSInteger)section {
    return [voasArray count]+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
//    NSLog(@"刷新列表");
    if ([indexPath row]<[voasArray count]) {
        static NSString *FirstLevelCell= @"NewCell";
//        static NSString *FirstLevelCellTwo= @"NewCellTwo";
        VOAView *voa = [self.voasArray objectAtIndex:row];
        
//        NSLog(@"-----cell id:%d",voa._voaid);
        VoaViewCell *cell =  (VoaViewCell*)[tableView dequeueReusableCellWithIdentifier:FirstLevelCell];

//        VoaViewCell *cell =  nil;
//        if (kIsLandscapeTest) {
//            cell = (VoaViewCell*)[tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
//        } else {
//            cell = (VoaViewCell*)[tableView dequeueReusableCellWithIdentifier:FirstLevelCellTwo];
//        }
        
        if (!cell) {
//            NSLog(@"新建cell");
            if (isiPhone) {

                if (kIsLandscapeTest) {

                    cell = (VoaViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"VoaViewCellLS"
                                                                        owner:self
                                                                      options:nil] objectAtIndex:0];
                } else {
                    
                    cell = (VoaViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"VoaViewCell"
                                                                        owner:self
                                                                      options:nil] objectAtIndex:0];
                }
                
            }else {
                if (kIsLandscapeTest) {
                    
                    cell = (VoaViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"VoaViewCellLS-iPad"
                                                                        owner:self
                                                                      options:nil] objectAtIndex:0];
                } else {
                    
                    cell = (VoaViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"VoaViewCell-iPad"
                                                                        owner:self
                                                                      options:nil] objectAtIndex:0];
                }
                
            }
        }
//        NSLog(@"voa._title:%@" ,voa._title);
        cell.myTitle.text = voa._title;
        cell.myDate.text = voa._creatTime;
        //--------->设置内容换行
        [cell.myTitle setLineBreakMode:UILineBreakModeClip];
        //--------->设置最大行数
        [cell.myTitle setNumberOfLines:3];
        NSURL *url = [NSURL URLWithString: voa._pic];
        if (isiPhone) {
            [cell.myImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"acquiesceBBC.png"]];
        } else {
            [cell.myImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"acquiesceBBCP.png"]];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        NSLog(@"readmy:%@",voa._isRead);
        if ([VOAView isRead:voa._voaid]) {
//            [cell.readImg setImage:[UIImage imageNamed:@"detailRead-ipad.png"]];
            [cell.myTitle setTextColor:[UIColor colorWithRed:0.702 green:0.702 blue:0.702 alpha:1]];
            [cell.myDate setTextColor:[UIColor colorWithRed:0.702 green:0.702 blue:0.702 alpha:1]];
        }else
        {
//            [cell.myTitle setTextColor:[UIColor redColor]];
//            [cell.myDate setTextColor:[UIColor redColor]];
//            [cell.readImg setImage:[UIImage imageNamed:@"detail-ipad.png"]];
        }
        if ([VOAFav isCollected:voa._voaid]) {
            [cell.localImg setHidden:NO];
        }
//        if (voa._hotFlg.integerValue == 1) {
//            [cell.hotImg setHidden:NO];
////            NSLog(@"hot:1");
//        }
        
        return cell;
    }else
    {
        if ([indexPath row]==[voasArray count]) {
            static NSString *SecondLevelCell= @"NewCellOne";
            UITableViewCell *cellTwo = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:SecondLevelCell];
//            if (addNum > 0) {
//                if (!cellTwo) {
//                    //                cellTwo = [[UITableViewCell alloc]init];
//                    //                cellTwo = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SecondLevelCell] autorelease];
//                    if (isiPhone) {
//                        cellTwo = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SecondLevelCell] autorelease];
//                    }else {
//                        cellTwo = (VoaViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"VoaImageCell-iPad" 
//                                                                               owner:self 
//                                                                             options:nil] objectAtIndex:0];
//                    }
//                }
//                [cellTwo setSelectionStyle:UITableViewCellSelectionStyleNone];
//                //                cellTwo.imageView.contentMode = UIViewContentModeScaleToFill; 
//                //                if (isiPhone) {
//                [cellTwo.imageView setImage:[UIImage imageNamed:@"load.png"]];
//                //                } else {
//                //                    [cellTwo.imageView setImage:[UIImage imageNamed:@"load-ipad.png"]];
//                //                }
//            } else {
//                [cellTwo setHidden:YES];
//            }
            if (!cellTwo) {
//                cellTwo = [[UITableViewCell alloc]init];
//                cellTwo = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SecondLevelCell] autorelease];
                if (isiPhone) {
                    cellTwo = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SecondLevelCell] autorelease];
                    cellTwo.autoresizesSubviews = YES;
                    cellTwo.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                }else {
                    cellTwo = (VoaViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"VoaImageCell-iPad" 
                                                                        owner:self 
                                                                      options:nil] objectAtIndex:0];
                }
            }
            [cellTwo setSelectionStyle:UITableViewCellSelectionStyleNone];
//            NSLog(@"cell width:%f",cellTwo.frame.size.width);
//            if (isiPhone) {
//                [cellTwo setFrame:CGRectMake(0, 0, 320, 28)];
//                [cellTwo.imageView setFrame:CGRectMake(0, 0, 320, 28)];
//            } else {
//                [cellTwo setFrame:CGRectMake(0, 0, 768, 28)];
//                [cellTwo.imageView setFrame:CGRectMake(0, 0, 768, 28)];
//            }
//            NSLog(@"cell width after:%f",cellTwo.frame.size.width);
            if (addNum == 10) {
//                cellTwo.imageView.contentMode = UIViewContentModeScaleToFill; 
                if (isiPhone) {
                    [cellTwo.imageView setImage:[UIImage imageNamed:@"load.png"]];
                } 
            } else {
                [cellTwo setHidden:YES];
            }
//            NSLog(@"width:%f",cellTwo.imageView.frame.size.width);
            return cellTwo;
        }else
        {
            if ([indexPath row]==[voasArray count]+1) {
//                NSLog(@"enter");
                static NSString *ThirdLevelCell= @"NewCellTwo";
                UITableViewCell *cellThree = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:ThirdLevelCell];
                if (!cellThree) {
                    cellThree = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ThirdLevelCell] autorelease];
//                    cellThree = [[UITableViewCell alloc]init];
                }
//                UITableViewCell *cellThree = [[UITableViewCell alloc]init];
                [cellThree setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cellThree setHidden:YES];
                if (row>lastId) {
                    
                } else
                {
//                    NSLog(@"重新加载");
                    if (kNetIsExist) {
//                        NSLog(@"lastId:%d",lastId);
                        if (addNum>0) {
//                            NSLog(@"联网重新加载");
                            [self catchIntroduction:20000 pages:pageNum pageNum:10];
                        }
                    }else {
                        NSMutableArray *addArray = [[NSMutableArray alloc]init];
                        addArray = [VOAView findNew:10*(pageNum-1) newVoas:addArray];
                        pageNum ++;
                        addNum = 0;
                        for (VOAView *voaOne in addArray) {
                            [self.voasArray addObject:voaOne];
                            addNum++;
                        }
                        [addArray release],addArray = nil;
                        [self.voasTableView reloadData];
                    }
//                    NSLog(@"lastId2:%d",lastId);
//                    NSMutableArray *addArray = [[NSMutableArray alloc]init];
//                    addArray = [VOAView findNew:10*(pageNum-1) newVoas:addArray];
//                    pageNum ++; 
//                    addNum = 0;
//                    for (VOAView *voaOne in addArray) {
//                        [self.voasArray addObject:voaOne];
//                        addNum++;
//                    }
//                    [addArray release],addArray = nil;
//                    [self.voasTableView reloadData];
                }            
                return cellThree;        
            }
        }
    }
    return nil;
}

#pragma mark -
#pragma mark Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIDevice *device = [UIDevice currentDevice] ;
    if (kIsLandscapeTest) {
//        NSLog(@"横向");
        return (([indexPath row]<[voasArray count]))?(isiPhone?165.0f:280.0f):(([indexPath row]==[voasArray count]+1)?1.0f:(isiPhone?32.0f:48.0f));
    }
//    NSLog(@"纵向");
    return (([indexPath row]<[voasArray count]))?(isiPhone?110.0f:210.0f):(([indexPath row]==[voasArray count]+1)?1.0f:(isiPhone?28.0f:48.0f));
}

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self catchNetA];
    kNetTest;
    if (search.isFirstResponder) {
        [self.search resignFirstResponder];
        NSString *searchWords =  [self.search text];
        if (searchWords.length == 0) {
        }else
        {
            self.navigationController.navigationBarHidden = NO;
            if (isiPhone) {
//                UIDevice *device = [UIDevice currentDevice] ;
                if (kIsLandscapeTest) {
                    [voasTableView setFrame:CGRectMake(0, 0, kScreenHeight, 220)];
                    [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
                } else {
                    [voasTableView setFrame:CGRectMake(0, 0, 320, 372)];
                    [search setFrame:CGRectMake(0, 0, 320, 44)];
                }
                
            }else {
                if (kIsLandscapeTest) {
                    [search setFrame:CGRectMake(0, 0, 1024, 44)];
                    [voasTableView setFrame:CGRectMake(0, 0, 1024, 660)];
                } else {
                    [search setFrame:CGRectMake(0, 0, 768, 44)];
                    [voasTableView setFrame:CGRectMake(0, 0, 768, 916)];
                }
            }
            
            [search setHidden:YES];
            search.text = @"";
            SearchViewController *searchController = [SearchViewController alloc];
            searchController.searchWords = searchWords;
            searchController.searchFlg = 0;
            searchController.contentMode = 1;
            [self.navigationController pushViewController:searchController animated:YES];
            [searchController release], searchController = nil;
        }
    }else{
        if (!search.isHidden) {
            self.navigationController.navigationBarHidden = NO;
            if (isiPhone) {
//                UIDevice *device = [UIDevice currentDevice] ;
                if (kIsLandscapeTest) {
                    [voasTableView setFrame:CGRectMake(0, 0, kScreenHeight, kViewHeight)];
                    [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
                } else {
                    [voasTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
                    [search setFrame:CGRectMake(0, 0, 320, 44)];
                }
            }else {
                if (kIsLandscapeTest) {
                    [search setFrame:CGRectMake(0, 0, 1024, 44)];
                    [voasTableView setFrame:CGRectMake(0, 0, 1024, 660)];
                } else {
                    [search setFrame:CGRectMake(0, 0, 768, 44)];
                    [voasTableView setFrame:CGRectMake(0, 0, 768, 916)];
                }
            }
            [search setHidden:YES];
            search.text = @"";
        }else{
            if ([indexPath row]<[voasArray count]) {
                if (notSelect) {
                    notSelect = NO;
                    [voasTableView setUserInteractionEnabled:NO];
                    NSUInteger row = [indexPath row];
                    VOAView *voa = [self.voasArray objectAtIndex:row];
//                    PlayerViewController *player = [PlayerViewController sharedPlayer];
//                    if(player.voa._voaid == voa._voaid)
//                    {
//                        player.newFile = NO;
//                    }else
//                    {
//                        player.contentMode = 1;
//                        player.newFile = YES;
//                        player.voa = voa;
//                    }
//                    [player setHidesBottomBarWhenPushed:YES];
//                    [self.navigationController  pushViewController:player animated:YES];
                    if ([voa._pic isEqualToString:@""] || [voa._pic isEqualToString:@"null"] || voa._pic == nil) {
                        [VOAView deleteByVoaid:voa._voaid];
//                        NSLog(@"内容不全");
                        [self.voasTableView reloadData];
                    } else {
//                        NSLog(@"内容:%i",voa._voaid);
                        if ([VOADetail isExist:voa._voaid] || [self isExistenceNetwork:1]) {
                            if ([VOADetail isExist:voa._voaid] ) {
                                //                                NSLog(@"文章有");
                            }
                            //                            NSLog(@"能点");
                            HUD = [[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES] retain];
                            HUD.dimBackground = YES;
                            HUD.labelText = @"Loading!";
                            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    VOADetail *myDetail = [VOADetail find:voa._voaid];
                                    if (!myDetail) {
                                        //                                    NSLog(@"内容不全-%d",voa._voaid);
                                        rightCharacter = NO;
                                        if (kNetIsExist) {
                                            [VOADetail deleteByVoaid: voa._voaid];
                                            //                                        NSLog(@"voaid:%i",voa._voaid);
                                            [self catchDetails:voa];
                                        }else {
                                           
                                        }
                                    }else {
                                        [myDetail release];
                                        rightCharacter = YES;
                                    }//获取所选的cell的数据
                                    if (rightCharacter) {
                                        //                                    NSLog(@"内容完整-%d",voa._voaid);
                                        //                                if ([VOADetail find:voa._voaid]) {
                                        PlayerViewController *play = [PlayerViewController sharedPlayer];//新建新界面的controller实例
//                                        play.isExisitNet = isExisitNet;
                                        if(play.voa._voaid == voa._voaid)
                                        {
                                            play.newFile = NO;
                                        }else
                                        {
                                            play.newFile = YES;
                                            play.voa = voa;
                                        }
                                        voa._isRead = @"1";//保证界面上显示已读
                                        
                                        if (play.contentMode != 1) {
                                            play.flushList = YES;
                                            play.contentMode =1;
                                        }
                                        [play setHidesBottomBarWhenPushed:YES];//设置推到新界面时无bottomBar
                                        [self.navigationController pushViewController:play animated:NO];
                                        [HUD hide:YES];
                                        //                                }
                                    }else {
                                        //                                    NSLog(@"没内容");
                                        notSelect = YES;
                                        [voasTableView setUserInteractionEnabled:YES];
                                        [HUD hide:YES];
//                                        UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:kColFour message:kNewFive delegate:self cancelButtonTitle:kWordFour otherButtonTitles:nil ,nil];
//                                        [addAlert show];
//                                        [addAlert release];
//                                        [voasTableView setUserInteractionEnabled:YES];
                                    }
                                    
                                });
                                
                            });
                        }
                        else
                        {
                            notSelect = YES;
                            [voasTableView setUserInteractionEnabled:YES];
                        }
                    }
                    
                    //                NSLog(@"PIC:%@,MP3:%@",voa._pic,voa._sound);
                    /*if ([voa._pic isEqualToString:@""] || [voa._pic isEqualToString:@"null"] || voa._pic == nil) {
                        [VOAView deleteByVoaid:voa._voaid];
                        [self.voasTableView reloadData];
                    } else {
                        if ([VOADetail isExist:voa._voaid] || [self isExistenceNetwork:1]) {
                            if ([VOADetail isExist:voa._voaid] ) {
//                                NSLog(@"文章有");
                            }
//                            NSLog(@"能点");
                            HUD = [[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES] retain];
                            HUD.dimBackground = YES;
                            HUD.labelText = @"Loading!";  
                            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{  
                                
                                dispatch_async(dispatch_get_main_queue(), ^{  
                                    VOADetail *myDetail = [VOADetail find:voa._voaid];
                                    if (!myDetail) {
                                        //                                    NSLog(@"内容不全-%d",voa._voaid);
                                        rightCharacter = NO;
                                        if (isExisitNet) {
                                            [VOADetail deleteByVoaid: voa._voaid];
                                            //                                        NSLog(@"voaid:%i",voa._voaid);
                                            [self catchDetails:voa];
                                        }else {
                                            
                                        }
                                    }else {
                                        [myDetail release];
                                        rightCharacter = YES;
                                    }//获取所选的cell的数据
                                    if (rightCharacter) {
                                        //                                    NSLog(@"内容完整-%d",voa._voaid);
                                        //                                if ([VOADetail find:voa._voaid]) {
                                        PlayViewController *play = [PlayViewController sharedPlayer];//新建新界面的controller实例
                                        play.isExisitNet = isExisitNet;
                                        if(play.voa._voaid == voa._voaid)
                                        {
                                            play.newFile = NO;
                                        }else
                                        {
                                            play.newFile = YES;
                                            play.voa = voa;
                                        }
                                        voa._isRead = @"1";//保证界面上显示已读
                                        
                                        play.contentMode =1;
                                        [play setHidesBottomBarWhenPushed:YES];//设置推到新界面时无bottomBar
                                        [self.navigationController pushViewController:play animated:NO];
                                        [HUD hide:YES];
                                        //                                }
                                    }else {
                                        //                                    NSLog(@"没内容");
                                        [HUD hide:YES];
                                        UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:kColFour message:kNewFive delegate:self cancelButtonTitle:kWordFour otherButtonTitles:nil ,nil];
                                        [addAlert show];
                                        [addAlert release];
                                        [voasTableView setUserInteractionEnabled:YES];
                                    }
                                    
                                    
                                });  
                            }); 
                        }
                        else
                        {
                            [voasTableView setUserInteractionEnabled:YES];
                        }
                    }*/
                }
            }
             
        }
    }
}

#pragma mark -
#pragma mark UISearchBar Delegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSString *searchWords =  [searchBar text];
    if (searchWords.length == 0) {
    }else
    {
        self.navigationController.navigationBarHidden = NO;
        if (isiPhone) {
//            UIDevice *device = [UIDevice currentDevice] ;
            if (kIsLandscapeTest) {
                [voasTableView setFrame:CGRectMake(0, 0, kScreenHeight, kViewHeight)];
                [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
            } else {
                [voasTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
                [search setFrame:CGRectMake(0, 0, 320, 44)];
            }
        }else {
            if (kIsLandscapeTest) {
                [search setFrame:CGRectMake(0, 0, 1024, 44)];
                [voasTableView setFrame:CGRectMake(0, 0, 1024, 660)];
            } else {
                [search setFrame:CGRectMake(0, 0, 768, 44)];
                [voasTableView setFrame:CGRectMake(0, 0, 768, 916)];
            }
        }
        [search setHidden:YES];
        HUD = [[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES] retain];
        HUD.dimBackground = YES;
        HUD.labelText = @"Loading!";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{  
            dispatch_async(dispatch_get_main_queue(), ^{  
                searchBar.text = @"";
                SearchViewController *searchController = [[SearchViewController alloc]init];
                searchController.searchWords = searchWords;
                searchController.searchFlg = 200;
                searchController.contentMode = 1;
                [self.navigationController pushViewController:searchController animated:YES];
                [searchController release], searchController = nil;
                [HUD hide:YES];
            });  
        });
    }

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.navigationController.navigationBarHidden = NO;
    if (isiPhone) {
//        UIDevice *device = [UIDevice currentDevice] ;
        if (kIsLandscapeTest) {
            [voasTableView setFrame:CGRectMake(0, 0, kScreenHeight, kViewHeight)];
            [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
        } else {
            [voasTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
            [search setFrame:CGRectMake(0, 0, 320, 44)];
        }
    }else {
        if (kIsLandscapeTest) {
            [search setFrame:CGRectMake(0, 0, 1024, 44)];
            [voasTableView setFrame:CGRectMake(0, 0, 1024, 660)];
        } else {
            [search setFrame:CGRectMake(0, 0, 768, 44)];
            [voasTableView setFrame:CGRectMake(0, 0, 768, 916)];
        }
    }
    [search setHidden:YES];
    search.text = @"";
    
}

#pragma mark - Http connect
- (void)pushToken:(NSString *) token
{
    NSString *url = [NSString stringWithFormat:@"http://apps.iyuba.com/voa/phoneToken.jsp?token=%@&appID=558115664",token];
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate = self;
    [request setUsername:@"token"];
    [request startAsynchronous];
}

- (void)catchIntroduction:(NSInteger)maxid pages:(NSInteger)pages pageNum:(NSInteger)pageNumOne{
    NSOperationQueue *myQueue = [self sharedQueue];
    NSString *url = [NSString stringWithFormat:@"http://voa.iyuba.com/voa/titleApi.jsp?maxid=%d&type=iOS&format=xml&pages=%d&pageNum=%d&parentID=200",maxid,pages,pageNumOne];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setUsername:@"new"];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [myQueue addOperation:request];
}

//- (void)catchNetA
//{
//    NSString *url = @"http://www.baidu.com";
////    ASIHTTPRequest * request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
//    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
//    request.delegate = self;
//    [request setUsername:@"catchnet"];
//    [request startAsynchronous];
//}

- (void)catchDetails:(VOAView *) voaid
{
    NSString *url = [NSString stringWithFormat:@"http://voa.iyuba.com/voa/textApi.jsp?voaid=%d&format=xml",voaid._voaid];
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate = self;
    [request setUsername:@"detail"];
    [request setTag:voaid._voaid];
    [request startSynchronous];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
//    isExisitNet = NO;
    kNetDisable;
//    NSLog(@"没网");
    if ([request.username isEqualToString:@"detail"])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:kColFour message:kNewSix delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        [HUD hide:YES];
        [self.voasTableView setUserInteractionEnabled:YES];
    }
//    else {
////            if ([request.username isEqualToString:@"catchnet"]) {
//                //                NSLog(@"无网络");
//        
////            }
//    }
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
//        if ([request.username isEqualToString:@"new"]) {
    kNetDisable;
    NSMutableArray *addArray = [[NSMutableArray alloc]init];
    addArray = [VOAView findNew:10*(pageNum-1) newVoas:addArray];
    pageNum ++; 
    addNum = 0;
    for (VOAView *voaOne in addArray) {
        [self.voasArray addObject:voaOne];
        addNum++;
    }
    [addArray release],addArray = nil;
    
    [self.voasTableView reloadData];
//        }
}

- (void)requestFinished:(ASIHTTPRequest *)request{
//    isExisitNet = YES;
    kNetEnable;
    if ([request.username isEqualToString:@"catchnet"]) {
        //        NSLog(@"有网络");
        notSelect = YES;
        [voasTableView setUserInteractionEnabled:YES];
        return;
    }
//    rightCharacter = NO;
    NSData *myData = [request responseData];
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:myData options:0 error:nil];
    if ([request.username isEqualToString:@"detail"]) {
        NSArray *items = [doc nodesForXPath:@"data/voatext" error:nil];
        if (items) {
            
            for (DDXMLElement *obj in items) {
                rightCharacter = YES;
//                NSLog(@"222");
                VOADetail *newVoaDetail = [[VOADetail alloc] init];
                newVoaDetail._voaid = request.tag ;
                //                    NSLog(@"id:%d",newVoaDetail._voaid);
                newVoaDetail._paraid = [[[obj elementForName:@"ParaId"] stringValue]integerValue];
                newVoaDetail._idIndex = [[[obj elementForName:@"IdIndex"] stringValue]integerValue];             
                newVoaDetail._timing = [[[obj elementForName:@"Timing"] stringValue]integerValue];
                newVoaDetail._sentence = [[[[obj elementForName:@"Sentence"] stringValue]stringByReplacingOccurrencesOfString:@"\"" withString:@"”"]stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
                newVoaDetail._imgWords = [[[obj elementForName:@"ImgWords"] stringValue]stringByReplacingOccurrencesOfString:@"\"" withString:@"”"];
                newVoaDetail._imgPath = [[obj elementForName:@"ImgPath"] stringValue];
                newVoaDetail._sentence_cn = [[[[[obj elementForName:@"sentence_cn"] stringValue]stringByReplacingOccurrencesOfString:@"\"" withString:@"”"] stringByReplacingOccurrencesOfString:@"<b>" withString:@""] stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
                if ([newVoaDetail insert]) {
                    //                        NSLog(@"插入%d成功",newVoaDetail._voaid);
                }
                [newVoaDetail release],newVoaDetail = nil;
            }
            
        } 
        [doc release],doc = nil;
    }  else if ([request.username isEqualToString:@"token"]) {
            NSString *returnData = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
//            NSLog(@"token返回:%@", returnData);
            for (NSString *matchOne in [returnData componentsMatchedByRegex:@"\\d"]) {
                //        NSLog(@"request:%i",[matchOne integerValue]);
                if ([matchOne integerValue] > 0) {
//                    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"pushToken"];
//                    NSLog(@"da");
                } else {
//                    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"pushToken"];
//                    NSLog(@"xiao");
                }
            }
            [returnData release],returnData = nil;
        
        [doc release],doc = nil;
    }
//    [request release], request = nil;
}

- (void)requestDone:(ASIHTTPRequest *)request
{
//    if ([request.username isEqualToString:@"catchnet"]) {
////        NSLog(@"有网络");
//        isExisitNet = YES;
////        [request release],request = nil;
//        return;
//    }
//    NSLog(@"1111");
    kNetEnable;
    NSData *myData = [request responseData];
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:myData options:0 error:nil];
    if ([request.username isEqualToString:@"new" ]) {
        /////解析
//        NSArray *items = [doc nodesForXPath:@"data" error:nil];
//        if (items) {
//            for (DDXMLElement *obj in items) {
//                NSInteger total = [[[obj elementForName:@"total"] stringValue] integerValue] ;
//                NSLog(@"total:%d",total);
//            }
//        }
        
        NSArray *items = [doc nodesForXPath:@"data/voatitle" error:nil];
        if (items) {
            BOOL flushList = NO;
            for (DDXMLElement *obj in items) {
                VOAView *newVoa = [[VOAView alloc] init];
                newVoa._voaid = [[[obj elementForName:@"voaid"] stringValue] integerValue] ;
                if (lastId<newVoa._voaid) {
                    lastId = newVoa._voaid;
                }
                newVoa._title = [[obj elementForName:@"Title"] stringValue];
//                NSLog(@"title：%@", newVoa._title );
                newVoa._descCn = [[[obj elementForName:@"DescCn"] stringValue] stringByReplacingOccurrencesOfString:@"\"" withString:@"”"];
                newVoa._title_Cn = [[[obj elementForName:@"Title_cn"] stringValue] isEqualToString: @" null"] ? nil :[[obj elementForName:@"Title_cn"] stringValue];
                newVoa._category = [[obj elementForName:@"Category"] stringValue];
                newVoa._sound = [[obj elementForName:@"Sound"] stringValue];
                newVoa._url = [[obj elementForName:@"Url"] stringValue];
                newVoa._pic = [[obj elementForName:@"Pic"] stringValue];
                newVoa._creatTime = [[obj elementForName:@"CreatTime"] stringValue];
                newVoa._publishTime = [[obj elementForName:@"PublishTime"] stringValue] == @" null" ? nil :[[obj elementForName:@"PublishTime"] stringValue];
                newVoa._readCount = [[obj elementForName:@"ReadCount"] stringValue];
                newVoa._hotFlg = [[obj elementForName:@"HotFlg"] stringValue];
                newVoa._isRead = @"0";
                if ([VOAView isExist:newVoa._voaid] == NO) {
                    [newVoa insert];
//                    NSLog(@"插入%d成功",newVoa._voaid);
//                    [self catchDetails:newVoa];
//                    [self catchWords:newVoa._voaid];
//                    [self catchQue:newVoa._voaid];
                    flushList = YES;
                }else {
//                    NSLog(@"已有");
                }
                [newVoa release],newVoa = nil;
            }
            if (flushList) {
                PlayerViewController *player = [PlayerViewController sharedPlayer];
//                if (player.playMode == 3) {
                    player.flushList = YES;  
//                }
                flushList = NO;
            }
            NSMutableArray *addArray = [[NSMutableArray alloc]init];
//            addArray = [VOAView findNew:10*(pageNum-1) newVoas:addArray];
            [VOAView findNew:10*(pageNum-1) newVoas:addArray];
            pageNum ++; 
            addNum = 0;
            for (VOAView *voaOne in addArray) {
                [self.voasArray addObject:voaOne];
                addNum++;
            }
//            NSLog(@"插入%d成功",addNum);
            [addArray release],addArray = nil;
            [self.voasTableView reloadData];
        }
        else{
        }
        
        [self doneLoadingTableViewData];//下拉刷新获取数据后立即结束刷新
    }
    [doc release],doc = nil;
//    [request release], request = nil;
}

-(BOOL) isExistenceNetwork:(NSInteger)choose
{
    UIAlertView *myalert = nil;
    switch (choose) {
        case 0:
            
            break;
        case 1:
            if (kNetIsExist) {
                
            }else {
                myalert = [[UIAlertView alloc] initWithTitle:kInfoTwo message:kRegNine delegate:nil cancelButtonTitle:kFeedbackFive otherButtonTitles:nil,nil];
                [myalert show];
                [myalert release];
            }
            break;
        default:
            break;
    }    
	return kNetIsExist;
}

//-(BOOL) isExistenceNetwork:(NSInteger)choose
//{
//	BOOL isExistenceNetwork;
//	Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
//    switch ([r currentReachabilityStatus]) {
//        case NotReachable:
//			isExistenceNetwork=FALSE;
//            break;
//        case ReachableViaWWAN:
//			isExistenceNetwork=TRUE;
//            break;
//        case ReachableViaWiFi:
//			isExistenceNetwork=TRUE;     
//            break;
//    }
//	if (!isExistenceNetwork) {
//        UIAlertView *myalert = nil;
//        switch (choose) {
//            case 0:
//                
//                break;
//            case 1:
//                myalert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您还没有网络连接,请收听本地中新闻" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
//                [myalert show];
//                [myalert release];
//                break;
//            default:
//                break;
//        }
//	}
//	return isExistenceNetwork;
//}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!search.isHidden) {
        self.navigationController.navigationBarHidden = NO;
        if (isiPhone) {
//            UIDevice *device = [UIDevice currentDevice] ;
            if (kIsLandscapeTest) {
                [voasTableView setFrame:CGRectMake(0, 0, kScreenHeight, kViewHeight)];
                [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
            } else {
                [voasTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
                [search setFrame:CGRectMake(0, 0, 320, 44)];
            }
        }else {
            if (kIsLandscapeTest) {
                [search setFrame:CGRectMake(0, 0, 1024, 44)];
                [voasTableView setFrame:CGRectMake(0, 0, 1024, 660)];
            } else {
                [search setFrame:CGRectMake(0, 0, 768, 44)];
                [voasTableView setFrame:CGRectMake(0, 0, 768, 916)];
            }
        }
        [search setHidden:YES];
        search.text = @"";
    }
}

//#pragma mark - debug
//#ifdef _FOR_DEBUG_  
//-(BOOL) respondsToSelector:(SEL)aSelector {  
//    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);  
//    return [super respondsToSelector:aSelector];  
//}  
//#endif 

@end
