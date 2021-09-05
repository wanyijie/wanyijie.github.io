---
summary: "接触golang有些时间了，以前磕磕碰碰的勉强写过几个小程序，最近工作又亲近golang，就想着再回头巩固一下，曾经遇到过几次的问题又再次遇到了，golang的函数定义格式是这样的："
tags:
    - wangyijie
    - golang
categories:
    - Development
    - Opetration
---
接触golang有些时间了，以前磕磕碰碰的勉强写过几个小程序，最近工作又亲近golang，就想着再回头巩固一下，曾经遇到过几次的问题又再次遇到了，golang的函数定义格式是这样的：
```
func function_name( [parameter list] ) [return_types] {
   函数体
}
```
函数体之上的哪一行总共分为三个部分，依次是声明关键字，函数名和参数，返回值。函数名和参数是一个整体所以归为一组方便识别的，有时会遇到一些异类的形式，今天就遇到这样的：
```
func fib() func() int {
	a, b := 0, 1
	return func() int {
		a, b = b, a+b
		return a
	}
}
```
比常见的多了一段，让人有点蒙圈了，再回顾到**闭包**的知识点才解决此困惑，说一下我自己对闭包的总结，闭包就是函数返回一个**匿名函数**，看一个例子：
```
package main

import "fmt"

func returnNum() func() (int, int)  {
	return func() (int, int) {
		return 0, 1
	}
}
func main()  {
	q := returnNum()
	a, b := q()
	
	fmt.Println(a, b)
}
```
在强类型语言里面，函数返回值类型是不可少的，闭包误导人的地方就在于它的返回值定义，返回一个匿名函数，函数得注明返回值，返回值和函数名之间习惯上会加空格，这就造成闭包的形式有别于普通函数，上面这个闭包**双返回值**也是有些耐人寻味的。少见多怪，主要还是因为我是个业余玩家。
####还有方法：结构体方法，对象方法也是初学者不易理解的。
