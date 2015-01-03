//
//  RKFullNameSpec.m
//  Tests
//
//  Created by Sam Symons on 2015-01-03.
//
//

SpecBegin(RKFullName);

NSString *validFullName = @"t1_12345";
NSString *invalidFullname = @"12345";

describe(@"initialization", ^{
    it(@"should set the fullName property", ^{
        RKFullName *fullName = [[RKFullName alloc] initWithFullName:validFullName];
        expect(fullName.fullName).to.equal(validFullName);
    });
});

describe(@"identifier", ^{
    it(@"should return the identifier of the full name if the full name is valid", ^{
        RKFullName *fullName = [[RKFullName alloc] initWithFullName:validFullName];
        expect([fullName identifier]).to.equal(@"12345");
    });
    
    it(@"should return nil if the full name is invalid", ^{
        RKFullName *fullName = [[RKFullName alloc] initWithFullName:invalidFullname];
        expect([fullName identifier]).to.beNil();
    });
});

describe(@"isValid", ^{
    it(@"should return YES if the full name is valid", ^{
        RKFullName *fullName = [[RKFullName alloc] initWithFullName:validFullName];
        expect([fullName isValid]).to.beTruthy();
    });
    
    it(@"should return NO if the full name is invalid", ^{
        RKFullName *fullName = [[RKFullName alloc] initWithFullName:invalidFullname];
        expect([fullName isValid]).to.beFalsy();
    });
});

SpecEnd
