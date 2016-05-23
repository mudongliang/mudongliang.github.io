---
layout: post
title: "C++ Virtual Function Example"
date: 2015-05-05
description: ""
category: 
tags: []
---
# CPP - Virtual function - Vtable
部分转载自[http://www.cppblog.com/fwxjj/archive/2007/01/25/17996.html](http://www.cppblog.com/fwxjj/archive/2007/01/25/17996.html)

多态性 (**polymorphism**) 是面向对象编程的基本特征之一。而在 `C++` 中，多态性通过虚函数 (**virtual function**) 来实现。我们来看一段简单的代码：

[Source Code On Github](https://github.com/mudongliang/CppLearn/blob/master/Vtable/testvirtual.cpp)

```c
#include <iostream>
using namespace std;
class Base {
	int a;
	public:
	virtual void fun1() {cout<<"Base::fun1()"<<endl;}
	virtual void fun2() {cout<<"Base::fun2()"<<endl;}
	virtual void fun3() {cout<<"Base::fun3()"<<endl;}
};
class A:public Base {
	int a;
	public:
	void fun1() {cout<<"A::fun1()"<<endl;}
	void fun2() {cout<<"A::fun2()"<<endl;}
};
void foo (Base& obj) {
	obj.fun1();
	obj.fun2();
	obj.fun3();
}
int main() {
	Base b;
	A a;
	foo(b);
	foo(a);
}
```
运行结果为：

```sh
Base::fun1()
Base::fun2()
Base::fun3()
A::fun1()
A::fun2()
Base::fun3()
```

仅通过基类的接口，程序调用了正确的函数，它就好像知道我们输入的对象的类型一样.    
那么，编译器是如何知道正确代码的位置的呢？其实，编译器在编译时并不知道要调用的函数体的正确位置，但它插入了一段能找到正确的函数体的代码。这称之为** 晚捆绑 (late binding)** 或 **运行时捆绑 (runtime binding)** 技术。    
通过`virtual` 关键字创建虚函数能引发晚捆绑，编译器在幕后完成了实现晚捆绑的必要机制。它对每个包含虚函数的类创建一个表(称为`VTABLE`)，用于放置虚函数的地址。在每个包含虚函数的类中，编译器秘密地放置了一个称之为`vpointer`(缩写为`VPTR`)的指针，指向这个对象的`VTABLE`。所以无论这个对象包含一个或是多少虚函数，编译器都只放置一个`VPTR`即可。`VPTR`由编译器在构造函数中秘密地插入的代码来完成初始化，指向相应的`VTABLE`，这样对象就“知道”自己是什么类型了。`VPTR`都在对象的相同位置，常常是对象的开头。这样，编译器可以容易地找到对象的VTABLE并获取函数体的地址。    
如果我们用`sizeof`查看前面`Base`类的长度，我们就会发现，它的长度不仅仅是一个`int`的长度，而是增加了刚好是一个`void`指针的长度（在我的机器里面，一个`int`占4个字节，一个`void`指针占4个字节，这样正好类`Base`的长度为8个字节）。    
每当创建一个包含虚函数的类或从包含虚函数的类派生一个类时，编译器就为这个类创建一个唯一的`VTABLE`。在`VTABLE`中，放置了这个类中或是它的基类中所有虚函数的地址，这些虚函数的顺序都是一样的，所以通过偏移量可以容易地找到所需的函数体的地址。假如在派生类中没有对在基类中的某个虚函数进行**重写(overriding)**，那么还使用基类的这个虚函数的地址(正如上面的程序结果所示)。    
至今为止，一切顺利。下面，我们的试验开始了。    
就目前得知的，我们可以试探着通过自己的代码来调用虚函数，也就是说我们要找寻一下编译器秘密地插入的那段能找到正确函数体的代码的足迹。    
如果我们有一个`Base`指针作为接口，它一定指向一个`Base`或由`Base`派生的对象，或者是`A`，或者是其它什么。这无关紧要，因为`VPTR`的位置都一样，一般都在对象的开头。如果是这样的话，那么包含有虚函数的对象的指针，例如Base指针，指向的位置恰恰是另一个指针——`VPTR`。`VPTR`指向的`VTABLE`其实就是一个函数指针的数组，现在，`VPTR`正指向它的第一个元素，那是一个函数指针。如果`VPTR`向后偏移一个`void`指针长度的话，那么它应该指向了`VTABLE`中的第二个函数指针了。    
这看来就像是一个指针连成的链，我们得从当前指针获取它指向的下一个指针，这样我们才能“顺藤摸瓜”。那么，我来介绍一个函数：

```c
void *getp (void* p){
	return (void*)*(unsigned long*)p;
}
```

我们不考虑它漂亮与否，我们只是试验。getp() 可以从当前指针获取它指向的下一个指针。如果我们能找到函数体的地址，用什么来存储它呢？我想应该用一个函数指针：
typedef void (*fun)();
它与Base中的三个虚函数相似，为了简单我们不要任何输入和返回，我们只要知道它实际上被执行了即可。
然后，我们负责“摸瓜”的函数登场了：

```c
fun getfun (Base* obj, unsigned long off) {
	void *vptr = getp(obj);
	unsigned char *p = (unsigned char *)vptr;
	p += sizeof(void*) * off;
	return (fun)getp(p);
}
```

第一个参数是Base指针，我们可以输入Base或是Base派生对象的指针。第二个参数是VTABLE偏移量，偏移量如果是0那么对应fun1()，如果是1对应fun2()。getfun() 返回的是fun类型函数指针，我们上面定义的那个。可以看到，函数首先就对Base指针调用了一次getp()，这样得到了vptr这个指针，然后用一个 unsigned char指针运算偏移量，得到的结果再次输入getp()，这次得到的就应该是正确的函数体的位置了。
那么它到底能不能正确工作呢？我们修改main() 来测试一下：

[Source Code On Github](https://github.com/mudongliang/CppLearn/blob/master/Vtable/testvirtual1.cpp)

```c
int main() {
	Base *p = new A;
	fun f = getfun(p, 0);
	(*f)();
	f = getfun(p, 1);
	(*f)();
	f = getfun(p, 2);
	(*f)();
	delete p;
	p = NULL;
}
```

激动人心的时刻到来了，让我们运行它！
运行结果为：

```sh
A::fun1()
A::fun2()
Base::fun3()
```	
至此，我们真的成功了。通过我们的方法，我们获取了对象的VPTR，在它的体外执行了它的虚函数。
