```java
WebClient webClient = new WebClient(BrowserVersion.FIREFOX);
webClient.getOptions().setCssEnabled(false);//关闭css
webClient.getOptions().setJavaScriptEnabled(true);//开启js
webClient.getOptions().setRedirectEnabled(true);//重定向
webClient.getOptions().setThrowExceptionOnScriptError(false);//关闭js报错
webClient.getOptions().setTimeout(50000);//超时时间
webClient.getCookieManager().setCookiesEnabled(true);//允许cookie
webClient.setAjaxController(new NicelyResynchronizingAjaxController());//设置支持AJAX
webClient.getOptions().setThrowExceptionOnFailingStatusCode(false);//关闭404报错
HtmlPage page = webClient.getPage("https://xxxx.com/login");
HtmlForm loginForm = page.getFormByName("loginForm");
//输入账号
HtmlInput aName = loginForm.getInputByName("aName");
aName.setValueAttribute(username);
//点击控件后键盘输入密码
HtmlElement sipBox1 = page.getHtmlElementById("SIPBox1");
sipBox1.type(password);
//此处获取cookie
CookieManager cookieManager = webClient.getCookieManager();
Cookie cookie = cookieManager.getCookie("JSESSIONID");
loginCookie =cookie.toString();
//输入验证码,验证码保存在本地(使用cookie去获取的验证码无法登录，原因不止，故保存为临时文件)
File file = File.createTempFile(DateUtils.format(new Date(),"yyyyMMdd_HHmmss") + new Random().nextInt(100), ".png");
HtmlImage imc = (HtmlImage) page.getElementById("imc");
imc.saveAs(file);
Map<String, String> dama = damaPlugins.dama3(FileUtixxxls.readFileToByteArray(file));
if(!"0000".equals(dama.get("code"))) {
    LogUtils.error("xxx，登录获取打码失败，" + dama);
    tkbService.sendNotifyMsgByWX(Constants.WX_MSG_NAME_DATA_ERRO, 1090067, "合利宝打码", dama);
    return null;
}
HtmlInput avCode = loginForm.getInputByName("avCode");
avCode.setValueAttribute(dama.get("value"));
file.delete();
//选择checkBox
List<HtmlRadioButtonInput> productType = loginForm.getRadioButtonsByName("productType");
for (HtmlRadioButtonInput r : productType){
    if (r.getDefaultValue().equals("NEWPOS")){
        r.click();
        break;
    }
}
//点击登录
HtmlElement submitButton = page.getHtmlElementById("submit_Button");
submitButton.click();
//无法自动跳转，主动去跳转页面查看是否登录成功
HtmlPage page1 = webClient.getPage("https://promote-agent.helipay.com/promote-business-agent/toMain");
webClient.close();
if (page1.getUrl().equals(page.getUrl())){
    LogUtils.error("HLBPlugins.getLoginSession，合利宝未成功登录");
    return null;
}
redis.set(key, loginCookie, 30, TimeUnit.DAYS);
return loginCookie;
```

