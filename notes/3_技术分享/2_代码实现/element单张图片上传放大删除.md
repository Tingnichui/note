```vue
<template>
  <div class="flex-img">
    <div class="el-upload-list el-upload-list--picture-card" v-show="hideShow">
      <div class="el-upload-list__item is-success">
        <img class="flex-img__image" :src="imageUrl">
        <label class="el-upload-list__item-status-label">
          <i class="el-icon-upload-success el-icon-check"></i>
        </label>
        <span class="el-upload-list__item-actions">
          <span @click="handlePictureCardPreview()">
            <i class="el-icon-zoom-in"></i>
          </span>

          <span class="el-upload-list__item-delete" v-show="disabledBoolean ? false:true">
            <i class="el-icon-delete" @click.stop="handleRemove()"></i>
          </span>
        </span>
      </div>
    </div>
    <el-upload class="imageUrl-uploader" :action="action" :show-file-list="false"
               accept="imageUrl/jpeg,imageUrl/jpg,imageUrl/png" :on-success="imageUploadSuccess"
               :before-upload="beforeUpload"
               v-show="!hideShow">
      <i class="el-icon-plus"></i>
    </el-upload>
    <el-dialog :visible.sync="dialogVisible" append-to-body>
      <img width="100%" :src="imageUrl" alt="">
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: "single-file-upload",
  data() {
    return {
      file: this.imageUrl ? this.imageUrl : '',
      imageForm: "",//给父组件传值
      dialogVisible: false,//控制大图预览
    };
  },
  props: {
    action: {
      //父组件传值过来照片回显
      type: String,
      dispatch() {
        return "";
      }
    },
    imageUrl: {
      //父组件传值过来照片回显
      type: String,
      dispatch() {
        return "";
      }
    },
    disabledBoolean: {
      //父组件传过来是编辑，还是查看
      type: Boolean,
      default() {
        return false;
      }
    },
  },
  watch: {
    imageUrl(value) {
      this.imageForm = this.file = value
    },
    imageForm(value) {//当照片地址改变的时候，给父组件传值
      this.$emit('updateImage', value);
    }
  },
  computed: {
    hideShow() {//当图片多于一张的时候，就隐藏上传框
      return this.file
    }
  },
  methods: {
    handlePictureCardPreview() {
      this.dialogVisible = true;
    },
    beforeUpload(file) {
      const imageSize = file.size / 1024 / 1024 < 1;//上传图片大小不超过1M
      if (!imageSize) {
        this.$message.error('上传大小不能超过 1MB!');
      }
      return imageSize;
    },
    //删除照片是清空所有
    handleRemove() {
      this.file = '';
      this.imageForm = "";
    },
    imageUploadSuccess(res, file) {
      // this.imageUrl = URL.createObjectURL(file.raw);
      this.imageForm = res.data.url;
    },

  }
}
</script>

<style lang="scss" scoped>
.flex-img {
  display: flex;
}

.imageUrl-uploader {
  background-color: #fbfdff;
  border: 1px dashed #c0ccda;
  border-radius: 6px;
  -webkit-box-sizing: border-box;
  box-sizing: border-box;
  width: 146px;
  height: 146px;
  cursor: pointer;
  line-height: 146px;
  vertical-align: top;
  text-align: center;
}

.imageUrl-uploader {
  font-size: 28px;
  color: #8c939d;
}

.imageUrl-uploader .el-upload:hover {
  border-color: #409eff;
}

.flex-img__image {
  width: 146px;
  height: 146px;
  border-radius: 6px;
}

.avatar-uploader .el-upload {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}

.avatar-uploader .el-upload:hover {
  border-color: #409eff;
}

.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 178px;
  height: 178px;
  line-height: 178px;
  text-align: center;
}

.avatar {
  width: 178px;
  height: 178px;
  display: block;
}
</style>
```

```vue
import SingleFileUpload from "@/components/CommonForm/single-file-upload.vue";

<SingleFileUpload
:action=uploadAction
:imageUrl="form.classMapIconUrl"
@updateImage="form.classMapIconUrl = $event"
>
</SingleFileUpload>
<SingleFileUpload
:action=uploadAction
:imageUrl="form.classMapIconUrl"
@updateImage="successUpload($event,'classMapIconUrl')"
>
</SingleFileUpload>
```

https://juejin.cn/post/7065533160313847815

