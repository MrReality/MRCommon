//
//  ViewController.m
//  test
//
//  Created by shiyuanqi on 2017/5/4.
//  Copyright © 2017年 lrz. All rights reserved.
//

#import "ViewController.h"
#import "MRCommon.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *str = @"\n周杰伦 - 稻香\n\n词/曲:周杰伦\n对这个世界如果你有太多的抱怨\n跌倒了 就不敢继续往前走\n为什麼 人要这麼的脆弱 堕落\n请你打开电视看看 多少人\n为生命在努力勇敢的走下去\n我们是不是该知足\n珍惜一切就算没有拥有\n\n还记得你说家是唯一的城堡\n随著稻香河流继续奔跑\n微微笑 小时候的梦我知道\n不要哭让萤火虫带著你逃跑\n乡间的歌谣永远的依靠\n童年的纸飞机 现在终於飞回我手里\n\n所谓的那快乐 赤脚在田里追蜻蜓追到累了\n偷摘水果被蜜蜂给叮到怕了\n谁在偷笑呢\n我靠著稻草人吹著风唱著歌睡著了\n哦 哦 午后吉它在虫鸣中更清脆\n哦 哦 阳光洒在路上就不怕心碎\n珍惜一切 就算没有拥有 @冻僵的企鹅 @残夜 @流月 #说点什么呢# #这是一个话题#\n 15711112222 \nhttp://www.baidu.com @hhhh #ddd# 约我：123456@qq.com 18612365478 :zuqiu: :smile: :cry: 18926667777   http://t.cn/Ry4UXdF //@我是呆毛芳子蜀黍w:这是什么鬼？";
    
    NSMutableArray *emails = [MRCommonString findEmailRangeWithString:str];
    for (NSTextCheckingResult *result in emails) {
        NSLog(@"%@", [str substringWithRange:result.range]);
    }
    NSLog(@"----------------------------");
    
    NSMutableArray *ats = [MRCommonString findAtRangeWithString:str];
    for (NSTextCheckingResult *result in ats) {
        NSLog(@"%@", [str substringWithRange:result.range]);
    }
    NSLog(@"----------------------------");

    NSMutableArray *topics = [MRCommonString findTopicRangeWithString:str];
    for (NSTextCheckingResult *result in topics) {
        NSLog(@"%@", [str substringWithRange:result.range]);
    }
    NSLog(@"----------------------------");
    
    NSMutableArray *urls = [MRCommonString findURLRangeWithString:str];
    for (NSTextCheckingResult *result in urls) {
        NSLog(@"%@", [str substringWithRange:result.range]);
    }
    NSLog(@"----------------------------");
    
    NSMutableArray *phones = [MRCommonString findPhoneRangeWithString:str];
    for (NSTextCheckingResult *result in phones) {
        NSLog(@"%@", [str substringWithRange:result.range]);
    }
    NSLog(@"----------------------------");
}



@end
