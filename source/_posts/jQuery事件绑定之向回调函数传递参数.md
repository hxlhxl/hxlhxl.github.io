---
title: jQuery事件绑定之向回调函数传递参数
date: 2016-11-08 20:15:16
tags: JavaScript jQuery
categories: JavaScript
toc: true
---

如何向jQuery事件绑定中的回调函数传递参数呢？

# 一个典型的错误

``` javascript
var utils = {
  getenv: function (jq_btn) {
    // 这里要传入的是jq对象,不能使用$(this),因为在对象中$(this)表示的是对象本身,不再是jq中的DOM对象
    var chenv = jq_btn.attr("id");
    alert("begin get list");
    getQidmergelist(qid,chenv);
    alert("get list ok");
    $("#chooseQidenv").modal('hide');
  }
};		


$.each($("#chooseQidenv .modal-body button"),function(index,value) {
       $(value).on("click",utils.getenv($(this)));
});
```

以上，是想在chooseQidenv下的所有button上绑定 点击事件，然而这个事件中的回调函数必须传递jq对象，要不然在getenv中使用$(this)这个$(this)就表示的是utils这个对象本身，而不是jQ中的DOM对象

而上面的这种写法，有一个致命的错误，那就是对$(value) DOM绑定click事件的时候，直接调用了getenv函数，原本是想向其传递参数，最后却成为了调用。这会导致一些奇怪的结果。在这里就是还没有点击按钮，按钮事件就已经发生产生了查询结果。



# 正确的写法



``` javascript
		$.each($("#chooseQidenv .modal-body button"),function (index, value) {
			$(value).on("click", function () {
				utils.getenv($(this));
			})
		});
```

上面使用的是一个匿名函数，然后通过这个匿名函数向回调函数传递了想要的参数。



当然也可以使用jQuery中的**bind**方法



``` javascript
$(document).ready(function() {
    $("#myTextbox").bind("blur", [ $("#myTextBox"), $("#Select1")], validateText);
})
function validateText(event) {
  textBox  = event.data[0];
  dropdown = event.data[1];
}
```





[pass arguments to event handlers in jQuery](http://stackoverflow.com/a/979344/5810739)

[bind](http://stackoverflow.com/a/1230284/5810739)

