#import "REAColorNode.h"
#import "REANodesManager.h"
#import <React/RCTConvert.h>
#import "REAUtils.h"
#import <React/RCTLog.h>

@implementation REAColorNode {
  NSNumber *_redNodeId;
  NSNumber *_greenNodeId;
  NSNumber *_blueNodeId;
  NSNumber *_alphaNodeId;
}

- (instancetype)initWithID:(REANodeID)nodeID config:(NSDictionary<NSString *,id> *)config
{
  if ((self = [super initWithID:nodeID config:config])) {
    _redNodeId = [RCTConvert NSNumber:config[@"r"]];
    REA_LOG_ERROR_IF_NIL(_redNodeId, @"Reanimated: Red argument passed to cond node is either of wrong type or is missing.");
    _greenNodeId = [RCTConvert NSNumber:config[@"g"]];
    REA_LOG_ERROR_IF_NIL(_redNodeId, @"Reanimated: Green argument passed to cond node is either of wrong type or is missing.");
    _blueNodeId = [RCTConvert NSNumber:config[@"b"]];
    REA_LOG_ERROR_IF_NIL(_redNodeId, @"Reanimated: Blue argument passed to cond node is either of wrong type or is missing.");
    _alphaNodeId = [RCTConvert NSNumber:config[@"a"]];
    REA_LOG_ERROR_IF_NIL(_redNodeId, @"Reanimated: Alpha argument passed to cond node is either of wrong type or is missing.");
  }
  return self;
}

- (id)evaluate
{
  double r = [[[self.nodesManager findNodeByID:_redNodeId] value] doubleValue];
  double g = [[[self.nodesManager findNodeByID:_greenNodeId] value] doubleValue];
  double b = [[[self.nodesManager findNodeByID:_blueNodeId] value] doubleValue];
  double a = [[[self.nodesManager findNodeByID:_alphaNodeId] value] doubleValue];
        
  double color = round(a * 255) * (1 << 24) + (r * (1 << 16)) + (g * (1 << 8)) + b;
    
  return @(color);
}

@end

