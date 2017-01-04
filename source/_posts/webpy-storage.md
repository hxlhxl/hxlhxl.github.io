---
title: webpy-storage
date: 2016-11-06 18:35:27
categories: webpy
toc: true
---

python的魔法方法

# webpy中的一段代码

``` python
class Storage(dict):
    """
    A Storage object is like a dictionary except `obj.foo` can be used
    in addition to `obj['foo']`.

        >>> o = storage(a=1)
        >>> o.a
        1
        >>> o['a']
        1
        >>> o.a = 2
        >>> o['a']
        2
        >>> del o.a
        >>> o.a
        Traceback (most recent call last):
            ...
        AttributeError: 'a'

    """
    def __getattr__(self, key):
        try:
            return self[key]
        except KeyError as k:
            raise AttributeError(k)

    def __setattr__(self, key, value):
        self[key] = value

    def __delattr__(self, key):
        try:
            del self[key]
        except KeyError as k:
            raise AttributeError(k)

    def __repr__(self):
        return '<Storage ' + dict.__repr__(self) + '>'

storage = Storage

config = storage()

config.a = 1
config["c"] = 3
print config.a
config["b"] = 2
del config["b"]
print config
print config.c

```

# 解释

![](http://lilyzt.com/hexo/image/heap/1.png)



# 为什么



这是为什么呢？为什么设置了setattr、getattr和delattr以及repr方法之后就能使用字典的方式赋值了呢？为什么上图中以字典方式赋值的方式没有作为 对象 instance的成员呢？到底是为什么呢？

```python
In [1]: class A:
   ...:     pass
   ...:

In [2]: a = A()

In [3]: a.int = 1

In [4]: a.int
Out[4]: 1

In [5]: a["floag"] = 1.1
---------------------------------------------------------------------------
AttributeError                            Traceback (most recent call last)
<ipython-input-5-c9f7b25444be> in <module>()
----> 1 a["floag"] = 1.1

AttributeError: A instance has no attribute '__setitem__'

```

**操他妈** 原来这个鬼类继承了 dict类。浪费时间，草
