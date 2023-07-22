导出

```javascript
function (titles,rows,fileName) {
	const workBook = xlsx.utils.book_new()
	const workSheet = xlsx.utils.json_to_sheet(rows.map(item => {const obj = {};for (let row of rows) for(var i = 0;i < row.length;i++) obj[titles[i]] = item[i];return obj;}))
	xlsx.utils.book_append_sheet(workBook, workSheet)
	xlsx.writeFile(workBook, (fileName || '导出数据') + '(' + rows.length + ').xlsx', {bookType: 'xlsx'})
}
```