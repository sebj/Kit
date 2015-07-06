
// NSBezierPath+Additions.m

// Seb Jachec

#import "NSBezierPath+Additions.h"

@implementation NSBezierPath (Additions)

- (NSBezierPath*)smoothedPath:(CGFloat)smoothness {
    NSArray *generalizedPoints = [self douglasPeucker:self.points epsilon:4];
    NSArray *splinePoints = [self catmullRomSpline:generalizedPoints segments:smoothness];
    
    NSBezierPath *smoothedPath = [NSBezierPath bezierPath];
    
    //Convert NSArray of point-values to array of NSPoints, in order to append to the path easily
    NSUInteger count = splinePoints.count;
    NSPoint pointArray[count];
    
    for (int i = 0; i < count; ++i)
        pointArray[i] = [splinePoints[i] pointValue];
    
    [smoothedPath appendBezierPathWithPoints:pointArray count:count];
    
    return smoothedPath;
}

//Get every point in the path
//Code from http://stackoverflow.com/a/11277688/447697
- (NSArray*)points {
    NSMutableArray *points = [NSMutableArray array];
    NSBezierPath *flatPath = self.bezierPathByFlatteningPath;
    NSInteger count = flatPath.elementCount;
    NSPoint prev, curr;
    NSInteger i;
    //Strange "-2" compensation. Odd, but appears to work well.
    for (i = 0; i < count-2; i++) {
        // Since we are using a flattened path, no element will contain more than one point
        NSBezierPathElement type = [flatPath elementAtIndex:i associatedPoints:&curr];
        if (i == count) {
            [points insertObject:[NSValue valueWithPoint:prev] atIndex:0];
            
        } else {
            if (type == NSClosePathBezierPathElement) {
                [flatPath elementAtIndex:0 associatedPoints:&curr];
                [points addObject:[NSValue valueWithPoint:curr]];
            } else {
                [points addObject:[NSValue valueWithPoint:curr]];
            }
        }
    }
    return points.copy;
}

//All of code below from Tony Ngo - http://tonyngo.net/smooth-line-drawing-in-ios/
//Tweaked very slightly in places to convert to work on Mac, and to remove Xcode warnings

- (NSArray *)douglasPeucker:(NSArray *)points epsilon:(float)epsilon {
    NSUInteger count = points.count;
    if (count < 3) return points;
    
    //Find the point with the maximum distance
    float dmax = 0;
    int index = 0;
    for(int i = 1; i < count - 1; i++) {
        CGPoint point = [points[i] pointValue];
        CGPoint lineA = [points[0] pointValue];
        CGPoint lineB = [points[count - 1] pointValue];
        float d = [self perpendicularDistance:point lineA:lineA lineB:lineB];
        if (d > dmax) {
            index = i;
            dmax = d;
        }
    }
    
    //If max distance is greater than epsilon, recursively simplify
    NSArray *resultList;
    if (dmax > epsilon) {
        NSArray *recResults1 = [self douglasPeucker:[points subarrayWithRange:NSMakeRange(0, index + 1)] epsilon:epsilon];
        
        NSArray *recResults2 = [self douglasPeucker:[points subarrayWithRange:NSMakeRange(index, count - index)] epsilon:epsilon];
        
        NSMutableArray *tmpList = [NSMutableArray arrayWithArray:recResults1];
        [tmpList removeLastObject];
        [tmpList addObjectsFromArray:recResults2];
        resultList = tmpList;
    } else {
        resultList = @[points[0],points[count-1]];
    }
    
    return resultList;
}

- (float)perpendicularDistance:(CGPoint)point lineA:(CGPoint)lineA lineB:(CGPoint)lineB {
    CGPoint v1 = CGPointMake(lineB.x - lineA.x, lineB.y - lineA.y);
    CGPoint v2 = CGPointMake(point.x - lineA.x, point.y - lineA.y);
    float lenV1 = sqrt(v1.x * v1.x + v1.y * v1.y);
    float lenV2 = sqrt(v2.x * v2.x + v2.y * v2.y);
    float angle = acos((v1.x * v2.x + v1.y * v2.y) / (lenV1 * lenV2));
    return sin(angle) * lenV2;
}

- (NSArray *)catmullRomSpline:(NSArray *)points segments:(int)segments {
    NSUInteger count = points.count;
    if (count < 4)
        return points;
    
    float b[segments][4];
    {
        // precompute interpolation parameters
        float t = 0.0f;
        float dt = 1.0f/(float)segments;
        for (int i = 0; i < segments; i++, t+=dt) {
            float tt = t*t;
            float ttt = tt * t;
            b[i][0] = 0.5f * (-ttt + 2.0f*tt - t);
            b[i][1] = 0.5f * (3.0f*ttt -5.0f*tt +2.0f);
            b[i][2] = 0.5f * (-3.0f*ttt + 4.0f*tt + t);
            b[i][3] = 0.5f * (ttt - tt);
        }
    }
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    {
        int i = 0; // first control point
        [resultArray addObject:points[0]];
        for (int j = 1; j < segments; j++) {
            CGPoint pointI = [points[i] pointValue];
            CGPoint pointIp1 = [points[i+1] pointValue];
            CGPoint pointIp2 = [points[i+2] pointValue];
            float px = (b[j][0]+b[j][1])*pointI.x + b[j][2]*pointIp1.x + b[j][3]*pointIp2.x;
            float py = (b[j][0]+b[j][1])*pointI.y + b[j][2]*pointIp1.y + b[j][3]*pointIp2.y;
            [resultArray addObject:[NSValue valueWithPoint:CGPointMake(px, py)]];
        }
    }
    
    for (int i = 1; i < count-2; i++) {
        // the first interpolated point is always the original control point
        [resultArray addObject:points[i]];
        for (int j = 1; j < segments; j++) {
            CGPoint pointIm1 = [points[i-1] pointValue];
            CGPoint pointI = [points[i] pointValue];
            CGPoint pointIp1 = [points[i+1] pointValue];
            CGPoint pointIp2 = [points[i+2] pointValue];
            float px = b[j][0]*pointIm1.x + b[j][1]*pointI.x + b[j][2]*pointIp1.x + b[j][3]*pointIp2.x;
            float py = b[j][0]*pointIm1.y + b[j][1]*pointI.y + b[j][2]*pointIp1.y + b[j][3]*pointIp2.y;
            [resultArray addObject:[NSValue valueWithPoint:CGPointMake(px, py)]];
        }
    }
    
    {
        NSUInteger i = count-2; // second to last control point
        [resultArray addObject:points[i]];
        for (int j = 1; j < segments; j++) {
            CGPoint pointIm1 = [points[i-1] pointValue];
            CGPoint pointI = [points[i] pointValue];
            CGPoint pointIp1 = [points[i+1] pointValue];
            float px = b[j][0]*pointIm1.x + b[j][1]*pointI.x + (b[j][2]+b[j][3])*pointIp1.x;
            float py = b[j][0]*pointIm1.y + b[j][1]*pointI.y + (b[j][2]+b[j][3])*pointIp1.y;
            [resultArray addObject:[NSValue valueWithPoint:CGPointMake(px, py)]];
        }
    }
    // the very last interpolated point is the last control point
    [resultArray addObject:points[count-1]];
    
    return resultArray;
}

@end
