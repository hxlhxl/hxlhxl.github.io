---
title: webpy-init_mapping
date: 2016-11-07 09:00:31
tags: 
categories: webpy
toc: true
---

application中的初始化路由的一段代码

# application的初始化路由

``` python
class application:
	def __init__(self, mapping=(), fvars={}, autoreload=None):
		self.init_mapping(self,mapping)	# mapping默认为空元祖
	def init_mapping(self, mapping):
		self.mapping = list(utils.group(mapping, 2))
```

utils.py
``` python
def group(seq, size):
    """
    Returns an iterator over a series of lists of length size from iterable.

        >>> list(group([1,2,3,4], 2))
        [[1, 2], [3, 4]]
        >>> list(group([1,2,3,4,5], 2))
        [[1, 2], [3, 4], [5]]
    """
    def take(seq, n):
        for i in range(n):
            yield next(seq)		# 这里一次yield函数并没有执行完，而会把整个for循环结束，这样在yield的时候就会返回两个数字，而这两个数字是以generator的形式存储的，所以在死循环中会使用list来消除

    if not hasattr(seq, 'next'):
        seq = iter(seq)		# 把seq对象转换为能够使用generator的模式;这里非常重要，这是为什么seq每次经过take方法之后，它的内容会减少size个！
    while True:
        x = list(take(seq, size))
        if x:
            yield x
        else:
            break
```

# 关于yield generator
函数在遇到return时跳出，如果把return换做yield，同样的，函数依然会在yield退出;只不过在调用函数后，函数的返回值将会是一个generator；

## 如何使用generator
使用for循环遍历即可

``` python
def fib(n):
	i,a,b = 0,0,1
	while (i <= n):
		yield b
		a,b = b,a+b
		i += 1
g = fib(100)
for i in g:
	print i
	
# 以上等价于
x = fib(100)
try:
	while True:
		print x.next()	# 等价于next(g)
except StopIteration:
	pass
```
在fib(100)之后，返回生成器g，在for循环中本质上是调用了g的next方法；在每一个yield之后，当前的yield都会保存上一次yield的状态。因此就能一次打印1，1，2，3，5，...；正是因为仅仅保存上次的状态，而不用使用 传统的 迭代方法，那样会造成栈溢出，这样的fib函数可以计算非常大的数量,。


# 关于__iter__

``` python
# generator
def uc_gen(text):
    for char in text:
        yield char.upper()

# generator expression
def uc_genexp(text):
    return (char.upper() for char in text)

# iterator protocol
"""
这里的uc_iter类实现了__iter__和__next__方法，那么，这个对象就是可迭代的，也就是可以直接使用for循环遍历实例本身的
"""
class uc_iter():
    def __init__(self, text):
        self.text = text
        self.index = 0
    def __iter__(self):
        return self
    def __next__(self):
        try:
            result = self.text[self.index].upper()
        except IndexError:
            raise StopIteration
        self.index += 1
        return result

# getitem method
class uc_getitem():
    def __init__(self, text):
        self.text = text
    def __getitem__(self, index):
        result = self.text[index].upper()
        return result
```



# 参考
[Understanding Generators in Python](http://stackoverflow.com/a/1756156/5810739)
[Build a Basic Python Iterator](http://stackoverflow.com/a/7542261/5810739)