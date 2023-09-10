## 索引

### 创建

```
PUT /test
```

### 查看

查看所有

```
GET /_cat/indices?v
```

| 表头           | 含义                                                         |
| -------------- | ------------------------------------------------------------ |
| health         | 当前服务器健康状态： green(集群完整) yellow(单点正常、集群不完整) red(单点不正常) |
| status         | 索引打开、关闭状态                                           |
| index          | 索引名                                                       |
| uuid           | 索引统一编号                                                 |
| pri            | 主分片数量                                                   |
| rep            | 副本数量                                                     |
| docs.count     | 可用文档数量                                                 |
| docs.deleted   | 文档删除状态（逻辑删除）                                     |
| store.size     | 主分片和副分片整体占空间大小                                 |
| pri.store.size | 主分片占空间大小                                             |

查看单个索引

```
GET /shopping
```

### 删除

```
DELETE /shopping
```

###  打开/关闭索引

```
POST /my_index/_close

POST /my_index/_open
```

### 查看索引状态

```
# 查看所有的索引状态：
GET /_stats

# 查看指定索引的状态信息：
GET /index1,index2/_stats
```

### 收缩索引

索引的分片数是不可更改的，如要减少分片数可以通过收缩方式收缩为一个新的索引。新索引的分片数必须是原分片数的因子值，如原分片数是8，则新索引的分片数可以为4、2、1 。

什么时候需要收缩索引呢?

最初创建索引的时候分片数设置得太大，后面发现用不了那么多分片，这个时候就需要收缩了

收缩的流程：

先把所有主分片都转移到一台主机上；
在这台主机上创建一个新索引，分片数较小，其他设置和原索引一致；
把原索引的所有分片，复制（或硬链接）到新索引的目录下；
对新索引进行打开操作恢复分片数据；
(可选)重新把新索引的分片均衡到其他节点上。

收缩前的准备工作；

将原索引设置为只读；

将原索引各分片的一个副本重分配到同一个节点上，并且要是健康绿色状态。

> PUT /my_source_index/_settings
> {
>  "settings": {
>   <!-- 指定进行收缩的节点的名称 -->
>   "index.routing.allocation.require._name": "shrink_node_name",
>   <!-- 阻止写，只读 -->
>    "index.blocks.write": true
>  }
> }

进行收缩：

> POST my_source_index/_shrink/my_target_index
> {
>  "settings": {
>   "index.number_of_replicas": 1,
>   "index.number_of_shards": 1,
>   "index.codec": "best_compression"
>  }}

监控收缩过程：
GET _cat/recovery?v
GET _cluster/health

### 拆分索引

当索引的分片容量过大时，可以通过拆分操作将索引拆分为一个倍数分片数的新索引。能拆分为几倍由创建索引时指定的index.number_of_routing_shards 路由分片数决定。这个路由分片数决定了根据一致性hash路由文档到分片的散列空间。

如index.number_of_routing_shards = 30 ，指定的分片数是5，则可按如下倍数方式进行拆分：
5 → 10 → 30 (split by 2, then by 3)
5 → 15 → 30 (split by 3, then by 2)
5 → 30 (split by 6)

为什么需要拆分索引？

当最初设置的索引的分片数不够用时就需要拆分索引了，和压缩索引相反

注意：只有在创建时指定了index.number_of_routing_shards 的索引才可以进行拆分，ES7开始将不再有这个限制。

和solr的区别是，solr是对一个分片进行拆分，es中是整个索引进行拆分。

拆分步骤：

准备一个索引来做拆分：

> PUT my_source_index
> {
>   "settings": {
>     "index.number_of_shards" : 1,
>     <!-- 创建时需要指定路由分片数 -->
>     "index.number_of_routing_shards" : 2
>   }
> }

先设置索引只读：

> PUT /my_source_index/_settings
> {
>  "settings": {
>   "index.blocks.write": true
>  }
> }

做拆分：

> POST my_source_index/_split/my_target_index
> {
>  "settings": {
>   <!--新索引的分片数需符合拆分规则-->
>   "index.number_of_shards": 2
>  }
> }

监控拆分过程：
GET _cat/recovery?v
GET _cluster/health

### 别名滚动指向新创建的索引

对于有时效性的索引数据，如日志，过一定时间后，老的索引数据就没有用了。我们可以像数据库中根据时间创建表来存放不同时段的数据一样，在ES中也可用建多个索引的方式来分开存放不同时段的数据。比数据库中更方便的是ES中可以通过别名滚动指向最新的索引的方式，让你通过别名来操作时总是操作的最新的索引。

ES的rollover index API 让我们可以根据满足指定的条件（时间、文档数量、索引大小）创建新的索引，并把别名滚动指向新的索引。

注意：这时的别名只能是一个索引的别名。

Rollover Index 示例：

创建一个名字为logs-0000001 、别名为logs_write 的索引：

> PUT /logs-000001
> {
>  "aliases": {
>   "logs_write": {}
>  }
> }

添加1000个文档到索引logs-000001，然后设置别名滚动的条件

> POST /logs_write/_rollover
> {
>  "conditions": {
>   "max_age":  "7d",
>   "max_docs": 1000,
>   "max_size": "5gb"
>  }
> }

说明：
如果别名logs_write指向的索引是7天前（含）创建的或索引的文档数>=1000或索引的大小>= 5gb，则会创建一个新索引 logs-000002，并把别名logs_writer指向新创建的logs-000002索引
Rollover Index 新建索引的命名规则：
如果索引的名称是-数字结尾，如logs-000001，则新建索引的名称也会是这个模式，数值增1。

如果索引的名称不是-数值结尾，则在请求rollover api时需指定新索引的名称



> POST /my_alias/_rollover/my_new_index_name
> {
>  "conditions": {
>   "max_age":  "7d",
>   "max_docs": 1000,
>   "max_size": "5gb"
>  }

在名称中使用Date math（时间表达式）

> 

如果你希望生成的索引名称中带有日期，如logstash-2016.02.03-1 ，则可以在创建索引时采用时间表达式来命名：

>  \# PUT /<logs-{now/d}-1> with URI encoding:
> PUT /%3Clogs-%7Bnow%2Fd%7D-1%3E
> {
>  "aliases": {
>   "logs_write": {}
>  }
> }
> PUT logs_write/_doc/1
> {
>  "message": "a dummy log"
> }
> POST logs_write/_refresh
> \# Wait for a day to pass
> POST /logs_write/_rollover
> {
>  "conditions": {
>   "max_docs":  "1"
>  }
> }

Rollover时可对新的索引作定义：

> PUT /logs-000001
> {
>  "aliases": {
>   "logs_write": {}
>  }
> }
> POST /logs_write/_rollover
> {
>  "conditions" : {
>   "max_age": "7d",
>   "max_docs": 1000,
>   "max_size": "5gb"
>  },
>  "settings": {
>   "index.number_of_shards": 2
>  }
> }

Dry run 实际操作前先测试是否达到条件：

> POST /logs_write/_rollover?dry_run
> {
>  "conditions" : {
>   "max_age": "7d",
>   "max_docs": 1000,
>   "max_size": "5gb"
>  }
> }

说明：
测试不会创建索引，只是检测条件是否满足
注意：rollover是你请求它才会进行操作，并不是自动在后台进行的。你可以周期性地去请求它。

## 文档

### 创建

创建文档

```
POST /test/_doc
{
    "title":"小米手机",
    "category":"小米",
    "images":"http://www.gulixueyuan.com/xm.jpg",
    "price":3999.00
}
```

创建文档时指定id

```
POST /test/_doc/1
{
    "title":"小米手机",
    "category":"小米",
    "images":"http://www.gulixueyuan.com/xm.jpg",
    "price":3999.00
}
```

### 修改

全量修改

```
POST /test/_doc/1
{
    "title":"update1",
    "category":"小米",
    "images":"http://www.gulixueyuan.com/xm.jpg",
    "price":3999.00
}
```

局部修改

```
POST /test/_update/1
{
	"doc": {
		"title":"局部修改",
		"category":"小米"
	}
}
```

### 删除

删除

```
DELETE /test/_doc/1
```

### 查询

主键查询

```
GET /test/_doc/1
```

全查询

```
GET /test/_doc/_search
```

URL带参查询

```
GET /test/_search?q=category:华为
```

请求体带参查询

```
GET /test/_search
{
	"query":{
		"match":{
			"category":"华为"
		}
	}
}
```

带请求体方式的查找所有内容

```
GET /test/_search
{
	"query":{
		"match_all":{}
	}
}
```

查询指定字段

```
GET /test/_search
{
	"query":{
		"match_all":{}
	},
	"_source":["title"]
}
```

分页查询

```
GET /test/_search
{
	"query":{
		"match_all":{}
	},
	"from":0,
	"size":2
}
```

查询排序

```
GET /test/_search
{
	"query":{
		"match_all":{}
	},
	"sort":{
		"price":{
			"order":"desc"
		}
	}
}
```

多条件查询

```
# 找出小米牌子，价格为3999元
GET /test/_search
{
	"query":{
		"bool":{
			"must":[{
				"match":{
					"category":"小米"
				}
			},{
				"match":{
					"price":3999.00
				}
			}]
		}
	}
}
```

```
# 小米和华为的牌子
GET /test/_search
{
	"query":{
		"bool":{
			"should":[{
				"match":{
					"category":"小米"
				}
			},{
				"match":{
					"price":3999.00
				}
			}]
		}
	}
}
```

范围查询

```
# 小米和华为的牌子，价格大于2000元的手机
GET /test/_search
{
	"query":{
		"bool":{
			"should":[{
				"match":{
					"category":"小米"
				}
			},{
				"match":{
					"category":"华为"
				}
			}],
            "filter":{
            	"range":{
                	"price":{
                    	"gt":2000
                	}
	            }
    	    }
		}
	}
}

```

全文检索

```
# 搜索引擎那样，如品牌输入“小华”，返回结果带回品牌有“小米”和华为的
GET /test/_search
{
	"query":{
		"match":{
			"category" : "小华"
		}
	}
}
```

完全匹配

```
GET /test/_search
{
	"query":{
		"match_phrase":{
			"category" : "为"
		}
	}
}
```

高亮查询

```
GET /test/_search
{
	"query":{
		"match_phrase":{
			"category" : "为"
		}
	},
    "highlight":{
        "fields":{
            "category":{}//<----高亮这字段
        }
    }
}
```

聚合查询

> 聚合允许使用者对 es 文档进行统计分析，类似与关系型数据库中的 group by，当然还有很多其他的聚合，例如取最大值max、平均值avg等等。

```
# 按price字段进行分组
GET /test/_search
{
	"aggs":{//聚合操作
		"price_group":{//名称，随意起名
			"terms":{//分组
				"field":"price"//分组字段
			}
		}
	}
}
# 不附带原始数据的结果
GET /test/_search
{
	"aggs":{
		"price_group":{
			"terms":{
				"field":"price"
			}
		}
	},
    "size":0
}
```

```
# 对所有手机价格求平均值
GET /test/_search
{
	"aggs":{
		"price_avg":{
			"avg":{
				"field":"price"
			}
		}
	},
    "size":0
}
```

## 映射关系

> 数据库(database)中的表结构(table)

创建

```
PUT /test/_mapping
{
    "properties": {
        "title":{
        	"type": "text",
        	"index": true
        },
        "category":{
        	"type": "keyword",
        	"index": true
        }
    }
}
```

查询

```
GET /test/_mapping
```

