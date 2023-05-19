## 实现原理

### 主要流程

```mermaid
graph LR;
    自定义流程图-->部署-->设置审批-->激活-->用户发起审批-->按照流程图顺序进行审批;
```

### 主要

- **RepositoryService**——提供了在编辑和发布审批流程的api，主要是模型管理和流程定义的业务api
- **RuntimeService**——处理正在运行的流程，比如发起、删除、挂起流程等等
- **TaskService**——对流程实例的各个节点的审批处理，比如流转的节点审批、任务授权

## 参考文章

[flowable工作流所有业务概念](https://blog.csdn.net/qq_20143059/article/details/120502642) 

[一文看懂开源工作流引擎 Flowable](https://medium.com/@herbertchang/%E4%B8%80%E6%96%87%E7%9C%8B%E6%87%82%E5%BC%80%E6%BA%90%E5%B7%A5%E4%BD%9C%E6%B5%81%E5%BC%95%E6%93%8E-flowable-f1f371e7069d) 