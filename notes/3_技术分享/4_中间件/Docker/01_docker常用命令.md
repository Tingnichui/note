# docker容器权限设置

[docker容器权限设置--cap-add | --cap-drop | privileged ](https://www.cnblogs.com/davis12/p/14453690.html)

- privileged，权限全开，不利于宿主机安全
- cap-add/cap-drop，细粒度权限设置，需要什么开什么

---

# docker其他一些命令

[docker限制容器占用内存](https://blog.csdn.net/shenzhen_zsw/article/details/90722333?ops_request_misc=&request_id=&biz_id=102&utm_term=docker%E9%99%90%E5%88%B6%E5%86%85%E5%AD%98&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-6-90722333.142^v67^pc_rank_34_queryrelevant25,201^v3^control_2,213^v2^t3_esquery_v1&spm=1018.2226.3001.4187)

```bash
--memory=256m 或者 -m 256m
```

[docker容器追加命令](https://blog.csdn.net/hty0506/article/details/110929871?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522166964407716782395333536%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=166964407716782395333536&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~baidu_landing_v2~default-2-110929871-null-null.142^v67^pc_rank_34_queryrelevant25,201^v3^control_2,213^v2^t3_esquery_v1&utm_term=docker%20update&spm=1018.2226.3001.4187)

```bash
 docker update [OPTIONS] CONTAINER [CONTAINER…]
 docker update -m 600m --memory-swap 600m nacos
```