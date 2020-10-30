//
//  CYInAppPurchaseController.m
//  MyDemo_OC
//
//  Created by zcy on 2020/10/9.
//  Copyright © 2020 CY. All rights reserved.
//

#import "CYInAppPurchaseController.h"
#import "CYInAppPurchase.h"

@interface CYInAppPurchaseController ()<UITableViewDelegate, UITableViewDataSource, CYInAppPurchaseDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation CYInAppPurchaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view addSubview:self.myTableView];
    });
    
    [self maopaopaixu];
    [self xuanzepaixu];
    [self charupaixu];
    [self shellSort];
    [self guibingpaixu];
    [self kuaisupaixu];
}

#pragma mark - delegate
#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELLID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", self.dataArr[indexPath.row]);
    
    // 暂时写死商品
    NSString *productIdentifier = @"com.ryan.soulHunter01";
    [CYInAppPurchase sharedInstance].delegate = self;
    [[CYInAppPurchase sharedInstance] identifyCanMakePayments:@[productIdentifier]];
    
}

#pragma mark CYInAppPurchaseDelegate

- (BOOL)isProductIdentifierAvailable:(nonnull NSString *)productIdentifier {
    return YES;
}

-(void)updatedTransactions:(CYPaymentTransactionState)state {
    NSLog(@"------updatedState:%lu", (unsigned long)state);
}

- (void)buySuccess:(SKPaymentTransaction *)transaction {
    NSLog(@"buySuccess");
//    [MBProgressHUD showText:@"购买成功"];
}

- (void)buyFailed:(NSError *)errorInfo {
    NSLog(@"buyFailed");
//    [MBProgressHUD showText:@"购买失败"];
}


// 链表反转
//  递归法
//- (void)reverseListNode(listNode *)headNode {
//    if(headNode == nil || headNode->next = nil){
//        return headNode;
//    }else {
//        listNode *newNode = [self reverseListNode:headNode->next];
//        headNode->next->next = headNode;
//        headNode-next = nil;
//        return headNode;
//    }
//}

// 迭代法
//struct ListNode * reverseListNode(ListNode *)head {
//    if (head == nil || head->next == nil){
//        return head;
//    }
//    listNode *node1 = head
//    listNode *node2 = head->next
//    listNode *node3 = head->next->next
//
//    while(node2){
//        node3 = node2->next
//        node2->next = node1
//        node1 = node2
//        node2 = node3
//    }
//
//    head->next = nil
//    return head
//}


// 十大经典排序 https://www.cnblogs.com/onepixel/articles/7674659.html
/// 冒泡排序是一种简单的排序算法。它重复地走访过要排序的数列，一次比较两个元素，如果它们的顺序错误就把它们交换过来。走访数列的工作是重复地进行直到没有再需要交换，也就是说该数列已经排序完成。这个算法的名字由来是因为越小的元素会经由交换慢慢“浮”到数列的顶端。
- (void)maopaopaixu {// 1、冒泡排序
    NSMutableArray *arr = [@[@8,@3,@4,@2,@9,@5,@6] mutableCopy];
    NSInteger num = arr.count;
    int tmp = 0;
    for (int i = 0; i<num-1; i++) {
        for (int j = 0; j<num-1-i; j++) {
            if ([arr[j] intValue] > [arr[j+1] intValue]) {
                tmp = [arr[j+1] intValue];
                arr[j+1] = arr[j];
                arr[j] = [NSNumber numberWithInt:tmp];
            }
        }
    }
    
    NSLog(@"MaoPaoArr:%@", arr);
}

/// 表现最稳定的排序算法之一，因为无论什么数据进去都是O(n^2)的时间复杂度，所以用到它的时候，数据规模越小越好。唯一的好处可能就是不占用额外的内存空间了吧。理论上讲，选择排序可能也是平时排序一般人想到的最多的排序方法了吧。
- (void)xuanzepaixu {// 2、选择排序
    NSMutableArray *arr = [@[@8,@3,@4,@2,@9,@5,@6] mutableCopy];
    NSInteger num = arr.count;
    int minInter = 0;
    int tmp;
    
    for (int i = 0; i<num-1; i++) {
        minInter = i;
        for (int j = i+1; j<num; j++) {
            if ([arr[j] intValue] < [arr[minInter] intValue]) {
                minInter = j;
            }
        }
        tmp = [arr[i] intValue];
        arr[i] = arr[minInter];
        arr[minInter] = [NSNumber numberWithInt:tmp];
    }
    NSLog(@"KuaiSuArr:%@", arr);

}

/// 插入排序在实现上，通常采用in-place排序（即只需用到O(1)的额外空间的排序），因而在从后向前扫描过程中，需要反复把已排序元素逐步向后挪位，为最新元素提供插入空间。
- (void)charupaixu {// 3、插入排序
    NSMutableArray *arr = [@[@8,@3,@4,@2,@9,@5,@6] mutableCopy];

    int preIndex, currentNum;
    for (int a = 1; a<arr.count; a++) {
        preIndex = a-1;
        currentNum = [arr[a] intValue];
        while (preIndex >=0 && [arr[preIndex] intValue] > currentNum) {
            arr[preIndex+1] = arr[preIndex];
            preIndex--;
        }
        arr[preIndex+1] = [NSNumber numberWithInt:currentNum];
    }
    
    NSLog(@"ChaRuArr:%@", arr);

}
/**
 先将整个待排序的记录序列分割成为若干子序列分别进行直接插入排序，具体算法描述：

 选择一个增量序列t1，t2，…，tk，其中ti>tj，tk=1；
 按增量序列个数k，对序列进行k 趟排序；
 每趟排序，根据对应的增量ti，将待排序列分割成若干长度为m 的子序列，分别对各子表进行直接插入排序。仅增量因子为1 时，整个序列作为一个表来处理，表长度即为整个序列的长度。
 */
- (void)shellSort {// 4、希尔排序 O(n^1.3)
    NSMutableArray *arr = [@[@8,@3,@4,@2,@9,@5,@6] mutableCopy];

//    NSInteger num = arr.count;
//
//    for (int a = floorf(num/2.0); a>0; a = floorf(a/2.0)) {
//        for (int i = a; i<num; i++) {
//            int j = i;
//            int currentNum = [arr[i] intValue];
//            while (j-a >= 0 && currentNum<[arr[j-a] intValue]) {
//                arr[j] = arr[j-a];
//                j = j-a;
//            }
//            arr[j] = [NSNumber numberWithInt:currentNum];
//            NSLog(@"shellArr1:%@ ---a:%d", arr, a);
//        }
//    }
    
    
    NSInteger num = arr.count;
    
    for (int a = (int)num / 2; a>0; a = a / 2) {
        for (int i=a; i<num; i++) {
            int j = i;
            int currentNum = [arr[i] intValue];
            while (j-a>=0 && currentNum < [arr[j-a] intValue]) {
                arr[j] = arr[j-a];
                j= j-a;
            }
            arr[j] = [NSNumber numberWithInt:currentNum];
//            NSLog(@"shellArr1:%@ ---a:%d", arr, a);
        }
    }
    NSLog(@"shellArr:%@", arr);
    
}
/// 将已有序的子序列合并，得到完全有序的序列；即先使每个子序列有序，再使子序列段间有序。若将两个有序表合并成一个有序表，称为2-路归并。
/// 归并排序是一种稳定的排序方法。和选择排序一样，归并排序的性能不受输入数据的影响，但表现比选择排序好的多，因为始终都是O(nlogn）的时间复杂度。代价是需要额外的内存空间。
- (void)guibingpaixu {// 5、归并排序
    NSMutableArray *arr = [@[@8,@3,@4,@2,@9,@5,@6] mutableCopy];

    arr = [self mergeSort:arr];
    NSLog(@"guibingArr:%@", arr);

}

- (NSMutableArray *)mergeSort:(NSMutableArray *)arr {
    NSInteger num = arr.count;
    if (num < 2) {
        return arr;
    }
    int middle = (int)num / 2;
    NSMutableArray *leftArr = [NSMutableArray arrayWithArray:[arr subarrayWithRange:NSMakeRange(0, middle)]];
    NSMutableArray *rightArr = [NSMutableArray arrayWithArray:[arr subarrayWithRange:NSMakeRange(middle, arr.count-middle)]];
    return [self merget:[self mergeSort:leftArr] rightArr:[self mergeSort:rightArr]];
    
}

- (NSMutableArray *)merget:(NSMutableArray *)leftArr rightArr:(NSMutableArray *)rightArr {
    NSMutableArray *arr = [NSMutableArray array];
    while (leftArr.count>0 && rightArr.count > 0) {
        int leftNum = [leftArr[0] intValue];
        int rightNum = [rightArr[0] intValue];
        if (leftNum <= rightNum) {
            [arr addObject:[NSNumber numberWithInt:leftNum]];
            [leftArr removeObject:[NSNumber numberWithInt:leftNum]];
        }else {
            [arr addObject:[NSNumber numberWithInt:rightNum]];
            [rightArr removeObject:[NSNumber numberWithInt:rightNum]];
        }
    }
    
    while (leftArr.count > 0) {
        int leftNum = [leftArr[0] intValue];
        [arr addObject:[NSNumber numberWithInt:leftNum]];
        [leftArr removeObject:[NSNumber numberWithInt:leftNum]];
    }
    
    while (rightArr.count > 0) {
        int rightNum = [rightArr[0] intValue];
        [arr addObject:[NSNumber numberWithInt:rightNum]];
        [rightArr removeObject:[NSNumber numberWithInt:rightNum]];
    }
    
    return arr;
}

/**
 从数列中挑出一个元素，称为 “基准”（pivot）；
 重新排序数列，所有元素比基准值小的摆放在基准前面，所有元素比基准值大的摆在基准的后面（相同的数可以到任一边）。在这个分区退出之后，该基准就处于数列的中间位置。这个称为分区（partition）操作；
 递归地（recursive）把小于基准值元素的子数列和大于基准值元素的子数列排序。
 */
- (void)kuaisupaixu {// 6、快速排序
    NSMutableArray *arr = [@[@8,@3,@4,@2,@9,@5,@6] mutableCopy];

    arr = [self quickSort:arr left:0 right:arr.count-1];
    NSLog(@"kuaisuArr:%@", arr);
}

- (NSMutableArray *)quickSort:(NSMutableArray *)arr left:(NSInteger)leftNum right:(NSInteger)rightNum {
//    NSInteger num = arr.count;
    NSInteger partitionIndex = 0;
//    if (!leftNum) {
//        leftNum = 0;
//    }
//    if (!rightNum) {
//        rightNum = num-1;
//    }
    
    if (leftNum < rightNum) {
        partitionIndex = [self partition:arr left:leftNum right:rightNum];
        [self quickSort:arr left:leftNum right:partitionIndex-1];
        [self quickSort:arr left:partitionIndex+1 right:rightNum];
    }
    return arr;
}

- (NSInteger)partition:(NSMutableArray *)arr left:(NSInteger)leftNum right:(NSInteger)right {
    NSInteger pivot = leftNum;
    NSInteger index = pivot+1;
    
    for (NSInteger i = index; i<=right; i++) {
        if (arr[i] < arr[pivot]) {
            [self swap:arr i:i j:index];
            index++;
        }
    }
    [self swap:arr i:pivot j:index-1];
    return index-1;
}

- (void)swap:(NSMutableArray *)arr i:(NSInteger)i j:(NSInteger)j {
    NSNumber *tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
}


#pragma mark - setters && getters

- (NSArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = @[@"1.0", @"2.0", @"3.0",];
    }
    return _dataArr;
}

- (UITableView *)myTableView {
    if (_myTableView == nil) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        
    }
    return _myTableView;
}

@end


