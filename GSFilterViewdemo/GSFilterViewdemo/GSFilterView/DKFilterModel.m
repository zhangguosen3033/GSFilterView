//
//  DKFilterModel.m
//  Partner
//
//

#import "DKFilterModel.h"
#import "GSFilterCell.h"
#import "GSMacros.h"

@implementation DKFilterModel

- (instancetype)initElement:(NSArray*)array ofType:(DKFilterType)type{
    if (self = [super init]) {
        _elements = array;
        self.type = type;
        self.style = DKFilterViewDefault;
    }
    return self;
}

- (UIView *)getCustomeViewofWidth:(CGFloat)width{
    
    GSFilterCell *sv = [[GSFilterCell alloc] init:self Width:width];
    if (self.style == DKFilterViewDefault) {
        
    }else if(self.style == DKFilterViewStyle1){
        
        sv.buttonNormalColor = GS_HL_COLOR;
        sv.buttonHighlightColor = GS_HL_COLOR;
    }
    return sv;
}

- (NSArray *)getFilterResult;{
    if (self.cachedView && [self.cachedView isKindOfClass:
                            [GSFilterCell class]]){
        GSFilterCell *view = (GSFilterCell *)self.cachedView;
        return [view getSelectedValues];
    }
    return @[];
}
@end
