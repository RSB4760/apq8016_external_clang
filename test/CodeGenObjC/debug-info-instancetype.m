// RUN: %clang_cc1 -emit-llvm -g -triple x86_64-apple-darwin10 %s -o - | FileCheck %s
// rdar://problem/13359718
// Substitute the actual type for a method returning instancetype.
@interface NSObject
+ (id)alloc;
- (id)init;
- (id)retain;
@end

@interface Foo : NSObject
+ (instancetype)defaultFoo;
@end

@implementation Foo
+(instancetype)defaultFoo {return 0;}
// CHECK: ![[FOO:[0-9]+]] = !MDCompositeType(tag: DW_TAG_structure_type, name: "Foo"
// CHECK: !MDSubprogram(name: "+[Foo defaultFoo]"
// CHECK-SAME:          line: [[@LINE-3]]
// CHECK-SAME:          type: ![[TYPE:[0-9]+]]
// CHECK: ![[TYPE]] = !MDSubroutineType(types: ![[RESULT:[0-9]+]])
// CHECK: ![[RESULT]] = !{![[FOOPTR:[0-9]+]],
// CHECK: ![[FOOPTR]] = !MDDerivedType(tag: DW_TAG_pointer_type
// CHECK-SAME:                         baseType: ![[FOO]]
@end


int main (int argc, const char *argv[])
{
  Foo *foo = [Foo defaultFoo];
  return 0;
}
