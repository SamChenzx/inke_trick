//
//  SamTickersView.m
//  inke
//
//  Created by Sam on 12/27/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import "SamTickersView.h"
#import "SamTickers.h"

@interface SamTickersView () <UIScrollViewDelegate,UIPageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) UIImageView *leftImageView, *middleImageView, *rightImageView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger scrollerViewWidth, scrollerViewHeight;

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSOperationQueue *queue;

@property (nonatomic, strong) NSString *localEtag;
@property (nonatomic, strong) NSString *localLastModified;

@end

@implementation SamTickersView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSOperationQueue *)queue {
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

-(NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc]init];
    }
    return _dataList;
}

-(NSMutableArray *)images
{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

+(instancetype) loadTickersView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
//    [self setupImageViews];
    
    
    [self initUI];
}

- (void) initUI
{
    // prepare scrollView
    self.scrollerViewWidth = kScreenWidth;
    self.scrollerViewHeight = 125;
    self.scrollView.delegate = self;
    
    // image views
    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.scrollView.frame.size.height)];
    self.middleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, self.scrollView.frame.size.height)];
    self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth, self.scrollView.frame.size.height)];
    // add image views
    [self.scrollView addSubview:self.leftImageView];
    [self.scrollView addSubview:self.middleImageView];
    [self.scrollView addSubview:self.rightImageView];
    // init pageControl
    self.isPageControl = NO;
    [self initPageControl];
}

- (void)initPageControl
{
    if(self.isPageControl)
    {
        [self.pageControl setHidden:NO];
        self.pageControl.numberOfPages = self.dataList.count;
        self.pageControl.userInteractionEnabled = YES;
        [self.pageControl addTarget:self action:@selector(pageControl:event:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.pageControl setHidden:YES];
    }
}

- (void)pageControl:(UIPageControl *)pageController event:(UIEvent *)touchs{
    UITouch *touch = [[touchs allTouches] anyObject];
    CGPoint p = [touch locationInView:_pageControl];
    [_pageControl setCurrentPage:(int ) p.x/15];
    [_scrollView setContentOffset:CGPointMake(_pageControl.currentPage*kScreenWidth, 0)];
    _currentIndex = _pageControl.currentPage;
}

- (void)startTimer
{
    if (self.dataList.count <= 1) {
        return;
    } else {
        if (self.timer) {
            [self stopTimer];
        } else {
            self.timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(autoRollingImages) userInfo:nil repeats:YES];
             [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    }
}


- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)updateForImagesAndLinks:(NSMutableArray *)resourceArray
{
    if (resourceArray.count) {
//        NSLog(@"%s",__FUNCTION__);
        
        [self.dataList removeAllObjects];
        [self.images removeAllObjects];
        [self.dataList addObjectsFromArray:resourceArray];
        
        for (NSInteger i = 0; i < self.dataList.count; i++) {
            id object = self.dataList[i];
            if ([object isKindOfClass:[UIImage class]]) {
                [self.images addObject:object];
                
            } else if ([object isKindOfClass:[SamTickers class]]) {

                [self.images addObject:[UIImage imageNamed:@"default_tickers_empty"]];
                [self downloadImageWithURLString:((SamTickers*)object).image atIndex:i];
                if (self.images.count > 1) {
                    self.isPageControl = YES;
                } else {
                    self.isPageControl = NO;
                }
                [self initPageControl];
                [self reloadImages];
            }
        }
    }
}

- (void)downloadImageWithURLString:(NSString *)urlString atIndex:(NSInteger)index
{
    if (![urlString hasPrefix:@"http://img2.inke.cn"]) {
        urlString = [@"http://img2.inke.cn/" stringByAppendingString:urlString];
    }
    /*
     UIImageView *imageVIew = [[UIImageView alloc]init];
     [imageVIew downloadImage:urlString placeholder:@"default_tickers_empty" success:^(UIImage *image) {
     [self.images setObject:imageVIew.image atIndexedSubscript:index];
     } failed:^(NSError *error) {
     NSLog(@"%@",error);
     } progress:^(CGFloat progress) {
     NSLog(@"%f",progress);
     }];
     */
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
    self.localEtag = [[NSUserDefaults standardUserDefaults] objectForKey:urlString];
    if (self.localEtag != nil) {
        [request setValue:self.localEtag forHTTPHeaderField:@"If-None-Match"];
    }

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//        NSLog(@"statusCode == %@", @(httpResponse.statusCode));
        if (httpResponse.statusCode == 304) {
            NSCachedURLResponse *cacheResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
            data = cacheResponse.data;
        }
        // get and record Etag
        self.localEtag = httpResponse.allHeaderFields[@"Etag"];
//        NSLog(@"self.localEtag:%@", self.localEtag);
        if ([[NSUserDefaults standardUserDefaults] objectForKey:urlString] == nil) {
            [[NSUserDefaults standardUserDefaults] setObject:self.localEtag forKey:urlString];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if ([UIImage imageWithData:data].size.width >= 250) {
            [self.images setObject:[UIImage imageWithData:data] atIndexedSubscript:index];
        } else {
            //[self.images removeObjectAtIndex:index];
        }
        
        if (index == 0) {
            NSLog(@"Finish download images in block!");
            // init pageControl
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.images.count > 1) {
                    self.isPageControl = YES;
                } else {
                    self.isPageControl = NO;
                }
                [self initPageControl];
                [self reloadImages];
            });
        }
    }];
    [task resume];
}

- (void)reloadImages
{
//    if ([self.delegate respondsToSelector:@selector(sizeForTickersView)]) {
//        CGSize size = [self.delegate sizeForTickersView];
//       // self.scrollerViewWidth = size.width;
//        self.scrollerViewHeight = size.height;
//    }
    
    if ([[self.images firstObject] isKindOfClass:[UIImage class]]) {
        CGSize size = ((UIImage *)[self.images firstObject]).size;
      //  self.scrollerViewWidth = size.width;
        if (size.width > kScreenWidth) {
            self.scrollerViewHeight = size.height*(kScreenWidth/size.width);
        } else {
            self.scrollerViewHeight = 125;
        }
    }

    self.frame = CGRectMake(0, 0, self.scrollerViewWidth, self.scrollerViewHeight);
    self.scrollView.bounds = CGRectMake(0, 0, self.scrollerViewWidth, self.scrollerViewHeight);
    self.scrollView.contentSize = CGSizeMake(self.scrollerViewWidth*3, 0);
    self.scrollView.contentOffset = CGPointMake(self.scrollerViewWidth, 0);
    [self.leftImageView setHeight:self.scrollerViewHeight];
    [self.middleImageView setHeight:self.scrollerViewHeight];
    [self.rightImageView setHeight:self.scrollerViewHeight];
    
    // prepare imageViews
    if (self.isPageControl) {
        self.leftImageView.image = [self.images lastObject];
        self.middleImageView.image = [self.images firstObject];
        self.rightImageView.image = self.images[1];
        [self startTimer];
    } else if (self.images.count) {
        self.middleImageView.image = [self.images firstObject];
    } else {
        self.middleImageView.image = [UIImage imageNamed:@"default_tickers_empty"];
    }
}

- (void)rollingImages:(UIScrollView*)scrollView
{
    CGFloat offset = scrollView.contentOffset.x;
    if (self.images.count) {
        if (offset >= 2*kScreenWidth)
        {
            // slides to the middle imageView
            scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
            _currentIndex++;
            self.leftImageView.image = self.middleImageView.image;
            self.middleImageView.image = self.rightImageView.image;
            if (_currentIndex == self.images.count - 1)
            {
                self.rightImageView.image = [self.images firstObject];
                
            } else if (_currentIndex == self.images.count)
            {
                self.rightImageView.image = self.images[1];
                _currentIndex = 0;
                
            } else
            {
                self.rightImageView.image = self.images[_currentIndex+1];
                
            }
            self.pageControl.currentPage = _currentIndex;
        }
        else if (offset <= 0)
        {
            // slides to the middle imageView
            scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
            _currentIndex--;
            self.rightImageView.image = self.middleImageView.image;
            self.middleImageView.image = self.leftImageView.image;
            
            if (_currentIndex == 0)
            {
                self.leftImageView.image = [self.images lastObject];
                
            } else if (_currentIndex == -1)
            {
                self.leftImageView.image = self.images[self.images.count-2];
                _currentIndex = self.images.count-1;
                
            } else
            {
                self.leftImageView.image = self.images[_currentIndex-1];
                
            }
            self.pageControl.currentPage = _currentIndex;
        }
    }
}

- (void)autoRollingImages
{
    [self.scrollView setContentOffset:CGPointMake(2*kScreenWidth, 0) animated:YES];
    [self rollingImages:self.scrollView];
}

-(NSString *)LinkAtCurrentPageIndex
{
    
    return ((SamTickers *)self.dataList[self.pageControl.currentPage]).link;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

#pragma mark ScrollView Delegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self rollingImages:scrollView];
}

@end
