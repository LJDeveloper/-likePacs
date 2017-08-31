//
//  ViewController.m
//  similarPacs
//
//  Created by 静东 on 17/8/30.
//  Copyright © 2017年 沸腾医疗. All rights reserved.
//
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width) //屏幕宽度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)//屏幕高度

#import "ViewController.h"

@interface ViewController ()
{
    UIImageView *dicomImage;
    UIButton    *moveBtn;
    UIButton    *brightBtn;
    CGFloat     brightCount;
    CGFloat     pkCount;
    UIButton    *restBtn;
    UIButton    *bigBtn;
    CGFloat     bigSize;
    UIButton    *playBtn;
    UIImage     *oriImage;
    NSTimer     *timer;
    int         playCount;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor blackColor];
    UIView *imgbg = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-100)];
    imgbg.layer.masksToBounds = YES;
    imgbg.layer.borderWidth = 1;
    imgbg.layer.borderColor = [UIColor yellowColor].CGColor;
    [self.view addSubview:imgbg];
    
    dicomImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT-64-100)];
    dicomImage.image = [UIImage imageNamed:@"o023.jpg"];
    dicomImage.contentMode = UIViewContentModeScaleAspectFit;
    [imgbg addSubview:dicomImage];
    
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGRAct:)];
    [dicomImage setUserInteractionEnabled:YES];
    [dicomImage addGestureRecognizer:panGR];
    
    UIPinchGestureRecognizer *pinchGR = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGRAct:)];
    [dicomImage setUserInteractionEnabled:YES];
    [dicomImage addGestureRecognizer:pinchGR];
    
    //复位
    restBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 35, 35)];
    restBtn.backgroundColor = [UIColor whiteColor];
    [restBtn setImage:[UIImage imageNamed:@"fuwei.png"] forState:UIControlStateNormal];
    restBtn.layer.masksToBounds = YES;
    restBtn.layer.cornerRadius = 4;
    [restBtn addTarget:self action:@selector(handleRestAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:restBtn];
    
    //移动
    moveBtn = [[UIButton alloc]initWithFrame:CGRectMake(50+20, 20, 35, 35)];
    moveBtn.backgroundColor = [UIColor lightGrayColor];
    [moveBtn setImage:[UIImage imageNamed:@"shou.png"] forState:UIControlStateNormal];
    moveBtn.layer.masksToBounds = YES;
    moveBtn.layer.cornerRadius = 4;
    moveBtn.selected = NO;
    [moveBtn addTarget:self action:@selector(handleMoveAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moveBtn];
    
    //亮度
    brightBtn = [[UIButton alloc]initWithFrame:CGRectMake(100+20, 20, 35, 35)];
    brightBtn.backgroundColor = [UIColor lightGrayColor];
    [brightBtn setImage:[UIImage imageNamed:@"liangdu.png"] forState:UIControlStateNormal];
    brightBtn.layer.masksToBounds = YES;
    brightBtn.layer.cornerRadius = 4;
    brightBtn.selected = NO;
    [brightBtn addTarget:self action:@selector(handleBrightAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:brightBtn];
    
    //放大缩小
    bigBtn = [[UIButton alloc]initWithFrame:CGRectMake(150+20, 20, 35, 35)];
    bigBtn.backgroundColor = [UIColor lightGrayColor];
    [bigBtn setImage:[UIImage imageNamed:@"big.png"] forState:UIControlStateNormal];
    bigBtn.layer.masksToBounds = YES;
    bigBtn.layer.cornerRadius = 4;
    bigBtn.selected = NO;
    [bigBtn addTarget:self action:@selector(handleBigAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bigBtn];
    
    //播放
    playBtn = [[UIButton alloc]initWithFrame:CGRectMake(200+20, 20, 35, 35)];
    playBtn.backgroundColor = [UIColor lightGrayColor];
    [playBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    playBtn.layer.masksToBounds = YES;
    playBtn.layer.cornerRadius = 4;
    playBtn.selected = NO;
    [playBtn addTarget:self action:@selector(handleplayAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
    
    //底部导航
    UIScrollView *bottomScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-100, SCREEN_WIDTH, 100)];
    bottomScroll.showsHorizontalScrollIndicator = NO;
    bottomScroll.bounces = NO;
    bottomScroll.contentSize = CGSizeMake(80*7, 100);
    [self.view addSubview:bottomScroll];
    
    for (int i = 0; i<6; i++) {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10+90*i, 10, 80, 80)];
        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"o0%d.jpg",23+i]];
        image.contentMode = UIViewContentModeScaleAspectFit;
        [bottomScroll addSubview:image];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10+90*i, 10, 80, 80)];
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1;
        if (i == 0) {
            btn.layer.borderColor = [UIColor yellowColor].CGColor;
        }else
        {
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(handleBottomAction:) forControlEvents:UIControlEventTouchUpInside];
        [bottomScroll addSubview:btn];
        
    }
    
    
    
    
    
    //原始图像
    oriImage = [UIImage imageNamed:@"o023.jpg"];
    brightCount = 0.0;
    pkCount = 1.0;
    bigSize = 1;
    playCount = 0;
    
    
}
//复位
- (void)handleRestAction
{
    dicomImage.frame = CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT-64-100);
    dicomImage.image = oriImage;
    brightCount = 0.0;
    pkCount = 1.0;
    bigSize = 1;
    [timer invalidate];
    timer = nil;
    
    moveBtn.selected = NO;
    moveBtn.backgroundColor = [UIColor lightGrayColor];
    brightBtn.selected = NO;
    brightBtn.backgroundColor = [UIColor lightGrayColor];
    bigBtn.selected = NO;
    bigBtn.backgroundColor = [UIColor lightGrayColor];
    playBtn.selected = NO;
    playBtn.backgroundColor = [UIColor lightGrayColor];

}
//拖动
- (void)handleMoveAction
{
    brightBtn.selected = NO;
    brightBtn.backgroundColor = [UIColor lightGrayColor];
    bigBtn.selected = NO;
    bigBtn.backgroundColor = [UIColor lightGrayColor];
    playBtn.selected = NO;
    playBtn.backgroundColor = [UIColor lightGrayColor];
    if (moveBtn.selected == NO) {
        moveBtn.selected = YES;
        moveBtn.backgroundColor = [UIColor yellowColor];
    }else
    {
        moveBtn.selected = NO;
        moveBtn.backgroundColor = [UIColor lightGrayColor];
    }
}
//亮度调节
-(void)handleBrightAction
{
    moveBtn.selected = NO;
    moveBtn.backgroundColor = [UIColor lightGrayColor];
    bigBtn.selected = NO;
    bigBtn.backgroundColor = [UIColor lightGrayColor];
    playBtn.selected = NO;
    playBtn.backgroundColor = [UIColor lightGrayColor];
    if (brightBtn.selected == NO) {
        brightBtn.selected = YES;
        brightBtn.backgroundColor = [UIColor yellowColor];
    }else
    {
        brightBtn.selected = NO;
        brightBtn.backgroundColor = [UIColor lightGrayColor];
    }
    
}
//放大缩小
- (void)handleBigAction
{
    
    moveBtn.selected = NO;
    moveBtn.backgroundColor = [UIColor lightGrayColor];
    brightBtn.selected = NO;
    brightBtn.backgroundColor = [UIColor lightGrayColor];
    playBtn.selected = NO;
    playBtn.backgroundColor = [UIColor lightGrayColor];
    if (bigBtn.selected == NO) {
        bigBtn.selected = YES;
        bigBtn.backgroundColor = [UIColor yellowColor];
    }else
    {
        bigBtn.selected = NO;
        bigBtn.backgroundColor = [UIColor lightGrayColor];
    }
    
}
//播放
- (void)handleplayAction
{
    moveBtn.selected = NO;
    moveBtn.backgroundColor = [UIColor lightGrayColor];
    brightBtn.selected = NO;
    brightBtn.backgroundColor = [UIColor lightGrayColor];
    bigBtn.selected = NO;
    bigBtn.backgroundColor = [UIColor lightGrayColor];

    if (playBtn.selected == NO) {
        playBtn.selected = YES;
        playBtn.backgroundColor = [UIColor yellowColor];
        //定时器
        timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(play) userInfo:nil repeats:YES];
       
    }else
    {
        playBtn.selected = NO;
        playBtn.backgroundColor = [UIColor lightGrayColor];
        [timer invalidate];
        timer = nil;
    }
}
- (void)play
{
    
    if (playCount ==6) {
        playCount = 0;
    }else
    {
        playCount = playCount +1;
    }
    for (int i=0; i<6; i++)
    {
        UIButton *button = (UIButton *)[self.view viewWithTag:1000+i];
        if (i==playCount) {
            button.layer.borderColor = [UIColor yellowColor].CGColor;
            oriImage = [UIImage imageNamed:[NSString stringWithFormat:@"o0%d.jpg",23+i]];
            dicomImage.frame = CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT-64-100);
            dicomImage.image = oriImage;
            brightCount = 0.0;
            pkCount = 1.0;
            bigSize = 1;
        }else
        {
            
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }
    }

}
//触摸
- (void)panGRAct: (UIPanGestureRecognizer *)rec{
    
    
    CGPoint point = [rec translationInView:self.view];
//    NSLog(@"%f,%f",point.x,point.y);
    if (moveBtn.selected == YES) {
        rec.view.center = CGPointMake(rec.view.center.x + point.x, rec.view.center.y + point.y);
        [rec setTranslation:CGPointMake(0, 0) inView:self.view];
    }
    if (brightBtn.selected == YES) {
        CGFloat xLength = point.x/10000;
        
        CGFloat yLength =point.y/10000;
        brightCount = brightCount+xLength;
        pkCount = pkCount + yLength;
        
        if (fabs(point.x) > fabs(point.y)) {
//            NSLog(@"x:%f",brightCount);
            dicomImage.image = [self getBrighterImage:oriImage level:brightCount];
        }
        if(fabs(point.x) < fabs(point.y))
        {
           NSLog(@"y:%f",pkCount);
            dicomImage.image = [self getContrastImage:oriImage level:pkCount];
        }
    }
    if (bigBtn.selected == YES)
    {
        bigSize = bigSize + point.y/10000;
        dicomImage.frame = CGRectMake(0, 0, SCREEN_WIDTH*bigSize, (SCREEN_HEIGHT-64-100)*bigSize);
        dicomImage.center = CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT-64-100)/2);
    }
    
    
}
// 捏合手势
- (void)pinchGRAct:(UIPinchGestureRecognizer *)sender
{
    if (bigBtn.selected == YES) {
        dicomImage.frame = CGRectMake(0, 0, SCREEN_WIDTH*bigSize*sender.scale, (SCREEN_HEIGHT-64-100)*bigSize*sender.scale);
        dicomImage.center = CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT-64-100)/2);
//        NSLog(@"++++%f",sender.scale);
    }
    
}
//亮度对比度
- (UIImage*) getBrighterImage:(UIImage *)originalImage level:(CGFloat )level

{
    UIImage
    *brighterImage;
    
    CIContext
    *context = [CIContext contextWithOptions:nil];
    
    CIImage
    *inputImage = [CIImage imageWithCGImage:originalImage.CGImage];
    
    
    
    CIFilter
    *lighten = [CIFilter filterWithName:@"CIColorControls"];
    
    [lighten
     setValue:inputImage forKey:kCIInputImageKey];
    
    //    饱和度：就把inputBrightness改成inputDateration
    
    //    对比度：就把inputBrightness改成inputSaturation
    [lighten
     setValue:@(level)
     forKey:@"inputBrightness"];
    
    
    
    CIImage
    *result = [lighten valueForKey:kCIOutputImageKey];
    
    CGImageRef
    cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    brighterImage
    = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    return brighterImage;
}
//对比度
- (UIImage*) getContrastImage:(UIImage *)originalImage level:(CGFloat )level

{
    UIImage
    *brighterImage;
    
    CIContext
    *context = [CIContext contextWithOptions:nil];
    
    CIImage
    *inputImage = [CIImage imageWithCGImage:originalImage.CGImage];
    
    
    
    CIFilter
    *lighten = [CIFilter filterWithName:@"CIColorControls"];
    
    [lighten
     setValue:inputImage forKey:kCIInputImageKey];
    
    //    饱和度：就把inputBrightness改成inputDateration
    
    //    对比度：就把inputBrightness改成inputSaturation
    [lighten
     setValue:@(level)
     forKey:@"inputContrast"];
    
    
    
    CIImage
    *result = [lighten valueForKey:kCIOutputImageKey];
    
    CGImageRef
    cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    brighterImage
    = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    return brighterImage;
}
//点击底部导航
- (void)handleBottomAction:(UIButton *)sender
{
    playCount = (int)(sender.tag - 1000);
    for (int i=0; i<6; i++) {
        if (i==sender.tag - 1000) {
            sender.layer.borderColor = [UIColor yellowColor].CGColor;
            oriImage = [UIImage imageNamed:[NSString stringWithFormat:@"o0%d.jpg",23+i]];
            dicomImage.frame = CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT-64-100);
            dicomImage.image = oriImage;
            brightCount = 0.0;
            pkCount = 1.0;
            bigSize = 1;
        }else
        {
            UIButton *button = (UIButton *)[self.view viewWithTag:1000+i];
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
