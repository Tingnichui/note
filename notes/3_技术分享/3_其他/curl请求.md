## GET

```shell
curl http://baidu.com
```

```shell
crul "http://172.16.134.9:1153/mp_mcss/vcn-image.do?mode=2&fileUuid=92dc1c25980d4a1c9b59d928a092e478"
```

## POST

```shell
curl -X POST http://localhost:8080/ais-orca-inm-intf/test/res
```

```shell
curl -X POST "www.test.com/login" -d "username=user1&password=123"
```

```shell
curl -X POST -H "Content-Type: application/json" -d '{"code": "5f36a0d6-f9df-4827-a798-8f6ce4f588d5"}' http://localhost:8000/ai-sys-plus/system/manage/v1/check/code
```

将json写成文件发送请求

```shell
curl  -v -X POST -H "Content-Type:application/json"  http://172.24.7.63:36963/VIID/MotorVehicles -d  @data.json
```

## 参考文章

1. [Linux中使用curl命令发送带参数的get请求和post请求](https://blog.csdn.net/finghting321/article/details/105733140)
2. [Linux命令发送Http的get或post请求](https://blog.csdn.net/zxy987872674/article/details/80091625)