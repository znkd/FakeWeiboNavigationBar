//
//  InteractionViewController.m
//  FakeWeiboNavigationBar
//
//  Created by zhangnan on 14/12/19.
//  Copyright (c) 2014年 zhangnan. All rights reserved.
//

#import "InteractionViewController.h"

@interface InteractionViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    UISegmentedControl* saleKind;
    UITableView* dataTableView;
    UIPanGestureRecognizer* panGesture;
    //YES:正常状态
    BOOL expended;
}
@end


static CGPoint oldPoint = {0,0};

@implementation InteractionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect rect = self.navigationController.navigationBar.frame;
    
    NSArray* segmentedArr = @[@"kind1",@"kind2",@"kind3",@"kind4"];
    saleKind = [[UISegmentedControl alloc]initWithItems:segmentedArr];
    saleKind.frame = CGRectMake(0, rect.origin.y+rect.size.height, rect.size.width, 40);
    saleKind.selectedSegmentIndex = 1;
    
    [self.view addSubview:saleKind];
    
    CGRect rect2 = CGRectMake(0, saleKind.frame.origin.y+saleKind.frame.size.height, SCREENWIDTH, SCREENHEIGHT-(saleKind.frame.origin.y+saleKind.frame.size.height));
    dataTableView = [[UITableView alloc]initWithFrame:rect2 style:UITableViewStylePlain];
    
    dataTableView.delegate = self;
    dataTableView.dataSource = self;
    
    panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panHandler:)];
    
    [dataTableView addGestureRecognizer:panGesture];
    
    panGesture.delegate = self;
    
    [self.view addSubview:dataTableView];

    expended = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)panHandler:(UIGestureRecognizer*)recg
{
    UIPanGestureRecognizer* currentRecg = (UIPanGestureRecognizer*)recg;
    CGPoint curPoint = [currentRecg translationInView:[dataTableView superview]];
    
    if (recg.state == UIGestureRecognizerStateBegan) {
        oldPoint = curPoint;
        return ;
    }
    
    if (recg.state == UIGestureRecognizerStateChanged) {
        CGFloat y = curPoint.y - oldPoint.y;
        
        //navigationbar
        CGRect rect = self.navigationController.navigationBar.frame;
        rect.origin.y += y;
        
        if (rect.origin.y < -rect.size.height) {
            rect.origin.y = -rect.size.height;
        } else if (rect.origin.y > 20) {
            rect.origin.y = 20;
        }
        
        self.navigationController.navigationBar.frame = rect;
        
        //segmentedcontrol
        CGRect rectSaleKind = saleKind.frame;
        rectSaleKind.origin.y += y;
        
        if (rectSaleKind.origin.y < 20) {
            rectSaleKind.origin.y = 20;
        }else if (rectSaleKind.origin.y > (self.navigationController.navigationBar.frame.size.height+20)){
            rectSaleKind.origin.y = self.navigationController.navigationBar.frame.size.height+20;
        }
        
        saleKind.frame = rectSaleKind;
        
        //tableview frame change
        CGRect rectTableView = dataTableView.frame;
        rectTableView.origin.y = saleKind.frame.origin.y + saleKind.frame.size.height;

        
        if (y<0 && (dataTableView.frame.origin.y <= (20+saleKind.frame.size.height))) {
            rectTableView.size.height = SCREENHEIGHT - (saleKind.frame.origin.y+saleKind.frame.size.height);
        }else if (y<0 && (dataTableView.frame.origin.y <= (saleKind.frame.size.height+self.navigationController.navigationBar.frame.size.height+20))){
            rectTableView.size.height -= y;
        }else if (y>0 && (dataTableView.frame.origin.y >= (saleKind.frame.size.height+self.navigationController.navigationBar.frame.size.height+20))){
            rectTableView.size.height = SCREENHEIGHT - (saleKind.frame.size.height+self.navigationController.navigationBar.frame.size.height+20);
        }else if (y>0 && (dataTableView.frame.origin.y >= (20+saleKind.frame.size.height))){
            rectTableView.size.height -= y;
        }else {
        }
        
        dataTableView.frame = rectTableView;
        
        oldPoint = curPoint;
    }
    
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifierString = @"DataCellName";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifierString];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierString];
        cell.backgroundColor = [UIColor redColor];
        //tableView.tintColor = [UIColor blueColor];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%lditem",(indexPath.row+1)];
    
    return cell;
}
@end
