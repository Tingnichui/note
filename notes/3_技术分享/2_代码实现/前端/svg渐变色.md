## svg渐变色

```html
<span>
  <svg width="20px" height="27px" viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg">
    <defs>
      <linearGradient id="gradient" x1="0%" y1="100%" x2="0%" y2="0%">
        <stop offset="0%" stop-color="#2995F7"/>
        <stop offset="100%" stop-color="#A9D4FC"/>
      </linearGradient>
    </defs>
    <path fill="url(#gradient)"
          d="M386.56 473.568C327.104 433.28 288 365.152 288 288 288 164.384 388.384 64 512 64 635.616 64 736 164.384 736 288 736 365.152 696.896 433.28 637.44 473.568 751.776 522.4 832 635.904 832 768L832 896 192 896 192 768C192 635.904 272.224 522.4 386.56 473.568Z"></path>
  </svg>
</span>
```

