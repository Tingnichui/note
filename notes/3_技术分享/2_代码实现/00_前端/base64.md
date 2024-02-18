解码

```js
  decodeBase64Token(base64Token) {
    try {
      const decodedToken = atob(base64Token);
      return decodedToken;
    } catch (error) {
      console.error("Error decoding token:", error);
      return null;
    }
  }
```

