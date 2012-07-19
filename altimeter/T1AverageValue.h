//
//  T1AverageValue.h
//  Inklet
//
//  Created by Peter Skinner on 3/12/10.
//  Copyright 2010 Ten One Design. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface T1AverageValue : NSObject {
	float values[20];
	int next;
	int lastDepth;
	float lastValue;
}

// use this one.  for pens, 10 is a good depth //
- (float)averageValueWithValue:(float)value depth:(int)depth;

// this weights values differently //
- (float)nonlinearAverageValueWithValue:(float)value depth:(int)depth;

// if it changed a lot, it has a heavier weight.  1500 is factor used by above //
- (float)nonlinearAverageValueWithValue:(float)value depth:(int)depth factor:(int)factor;

// this is the master function //
- (float)averageValueWithValue:(float)value weight:(int)weight depth:(int)depth;
@end
