//
//  T1AverageValue.m
//  Inklet
//
//  Created by Peter Skinner on 3/12/10.
//  Copyright 2010 Ten One Design. All rights reserved.
//

#import "T1AverageValue.h"


@implementation T1AverageValue

- (float)averageValueWithValue:(float)value weight:(int)weight depth:(int)depth {
	float sum = 0;
//	NSLog(@"average with value: %f, weight: %d, depth: %d",value,weight,depth);
	for (int i=0;i<weight;++i) {
//		if (depth==2 || depth==8 || 1) {NSLog(@"add value: %f",value);}
		values[next]=value;
		next = (next + 1) % 20;
	}
	lastValue = value;
	
	if (depth == -1) {	// signal to reset array
//		NSLog(@"clearing!");
		for (int i=0;i<20;i++) {
			values[i] = 0;
		}
		next = 0;
		return 0;
	}
	
	int zeroCount = 0;
	int index;
	if (depth>lastDepth) {	// clear out old values when using new depth
//		if (depth==2 || depth==8 || 1) {NSLog(@"clearing due to depth change!");}

		for (int i=lastDepth; i<depth; i++) {
			index = (next-i-2);
			if (index<0) {
				index+=20;
			}
			values[index] = 0;
		}
	}
	lastDepth = depth;
	
	// sum the array, and count the zeroes
	for (int i = 0; i < (depth); ++i) {	// unsafe for depth > array size (20)
		index = (next-i-1);
		if (index<0) {
			index+=20;
		}
		if (values[index]==0) {
			zeroCount++;
		}
//		if (depth==2 || depth==8 || 1) {NSLog(@"sum: %f",values[index]);}
		sum+=values[index];
	}
	if (zeroCount==depth) {
		return 0;
	}
//	if (depth==2 || depth==8) {NSLog(@"sum: %f zeroCount: %d",sum,zeroCount);}
	return sum/(depth-zeroCount);
}

- (float)averageValueWithValue:(float)value depth:(int)depth{ 
	return [self averageValueWithValue:value weight:1 depth:depth];
}

- (float)nonlinearAverageValueWithValue:(float)value depth:(int)depth{
	return [self nonlinearAverageValueWithValue:value depth:depth factor:1500];
}
- (float)nonlinearAverageValueWithValue:(float)value depth:(int)depth factor:(int)factor {
	int weight = abs(floorf((value - lastValue)*factor))+1;	// 60 works
	//	NSLog(@"lastValue: %f, value: %f, weight: %d",lastValue,value,weight);
	//	if (weight>=depth) {
	//		NSLog(@"undamped" );
	//	}
	//	if (depth>weight) {
	//		NSLog(@"damped");
	//	}
	return [self averageValueWithValue:value weight:weight depth:depth];
}
@end
