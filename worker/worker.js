onmessage = function(event){
	console.log("分线程接收主线程数据: " + event.data);
	let result = fib(event.data);
	postMessage(result);
	// this 是worker全局变量
	console.log(this);
}
// 分线程中，全局对象不是window,所以不能在分线程中更新界面
// 消息不能同时处理,只能一个一个处理
function fib(n){
	return n<=2?1:fib(n-1)+fib(n-2)
}
