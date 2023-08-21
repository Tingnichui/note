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

