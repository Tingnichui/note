```java

	/**
	 * 将multipartfile转换为file
	 * @param multipartFile
	 * @return
	 * @throws IOException
	 */
	private File getTempFile(MultipartFile multipartFile) throws IOException {
		String fileName = multipartFile.getOriginalFilename();
		String suffixName = fileName.substring(fileName.lastIndexOf("."));
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss");
		Random r = new Random();
		StringBuilder tempName = new StringBuilder();
		tempName.append(sdf.format(new Date())).append(r.nextInt(100));
		String prefix = tempName.toString();
		File file = File.createTempFile(prefix, suffixName);
		multipartFile.transferTo(file);
		return file;
	}
```

