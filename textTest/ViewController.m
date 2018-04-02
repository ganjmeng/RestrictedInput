//
//  ViewController.m
//  textTest
//
//  Created by GANMENG on 2018/4/2.
//  Copyright © 2018年 感觉萌. All rights reserved.
//

#import "ViewController.h"

#define MaxNumberOfDescriptionChars 8 //为汉字字符个数

@interface ViewController ()<UITextFieldDelegate>
{
    CGFloat _subLength;
    
}
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextFieldTextDidChangeNotification object:self.textField];
}

- (CGFloat)configTextCountWithStr:(NSString *)s
{
    int i;CGFloat n=[s length],l=0,a=0,b=0;
    CGFloat wLen=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[s characterAtIndex:i];//按顺序取出单个字符
        if(isblank(c)){//判断字符串为空或为空格
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
        wLen=l+(CGFloat)((CGFloat)(a+b)/2.0);
//        NSLog(@"wLen--%f",wLen);
        if (wLen>=MaxNumberOfDescriptionChars-0.5&&wLen<MaxNumberOfDescriptionChars+0.5) {//设定这个范围是因为，当输入了15英文，即7.5个字符，后面还能输1字母，但不能输1中文
            _subLength=l+a+b;//_subLen是要截取字符串的位置
        }
        
    }
    if(a==0 && l==0)
    {
        _subLength=0;
        return 0;//只有isblank
    }
    else{
        
        return wLen;//长度，中文占1，英文等能转ascii的占0.5
    }
}


// 监听文本改变
-(void)textViewEditChanged:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
//    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式  警告可以换成[[UIApplication sharedApplication]textInputMode].primaryLanguage
//    NSUInteger maxLength = MaxNumberOfDescriptionChars;//加上自动定位的地址，上限是10个汉字
//    NSUInteger currentLength = [self lengthWidthWith:toBeString];
    
//    //过滤空格
//    NSString *tem = [[textField.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
//    if (![textField.text isEqualToString:tem]) {
//        
//    }
//
//    //过滤表情
//    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:0 error:nil];
//
//    NSString *noEmojiStr = [regularExpression stringByReplacingMatchesInString:textField.text options:0 range:NSMakeRange(0, textField.text.length) withTemplate:@""];
//
//    if (![noEmojiStr isEqualToString:textField.text]) {
//
//        textField.text = noEmojiStr;
//
//    }
   
    
    NSString *toBeString = textField.text;

//    if ([lang isEqualToString:@"zh-Hans"]) {
        // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            CGFloat ascLen=[self configTextCountWithStr:toBeString];//没高亮，获取长度
            if (_subLength==0) {
                _subLength=toBeString.length;
            }
            if (ascLen > MaxNumberOfDescriptionChars) {
                self.textField.text = [toBeString substringToIndex:_subLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{ }
//    }
//    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
//    else{
//        // 简体中文输入，包括简体拼音，健体五笔，简体手写
//        UITextRange *selectedRange = [textField markedTextRange];
//        //获取高亮部分
//        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//
//        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//        if (!position) {
//
//            CGFloat ascLen=[self countW:toBeString];//没高亮，获取长度
//            if (_subLen==0) {
//                _subLen=toBeString.length;
//            }
//            if (ascLen > MaxNumberOfDescriptionChars) {
//                self.textField.text = [toBeString substringToIndex:_subLen];
//            }
//        }
//        // 有高亮选择的字符串，则暂不对文字进行统计和限制
//        else{ }
//    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if ([string isEqualToString:@""])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (self.textField == textField)
    {
        if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
            
            return NO;//限制emoji表情输入
            
        }
        
        NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];//此处是限制空格输入
        
        if (![string isEqualToString:tem]) {
            
            return NO;//限制空格输入

        }
        
        CGFloat ascLen=[self configTextCountWithStr:toBeString];//没高亮，获取长度
        if (_subLength==0) {
            _subLength=toBeString.length;
        }
        if (ascLen > MaxNumberOfDescriptionChars) {
            self.textField.text = [toBeString substringToIndex:_subLength];
            return NO;
        }
//        NSUInteger maxLength = MaxNumberOfDescriptionChars;//设置文字上限
//        if ([toBeString length] > maxLength) {
//            textField.text = [toBeString substringToIndex:maxLength];
//            return NO;
//        }
    }
    return YES;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
