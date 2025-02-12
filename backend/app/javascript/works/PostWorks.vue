<template>
  <div id="post-work" data-user='{"id": 1}'>
    <form @submit.prevent="postWork">
      <div>
        <label for="title">Title</label>
        <input type="text" v-model="title" id="title" required>
      </div>
      <div>
        <label for="description">Description</label>
        <textarea v-model="description" id="description" required></textarea>
      </div>
      <div v-if="!isCropping">
        <button type="button" @click="triggerFileSelect">＋ 画像を追加</button>
        <input ref="fileInput" type="file" @change="onFileChange" accept="image/*" style="display:none">
      </div>
      <div v-if="isCropping" class="mt-3">
        <div>
          <label>比率選択:</label>
          <label><input type="radio" value="0.75" v-model="selectedRatio"> 3:4</label>
          <label><input type="radio" value="1.33" v-model="selectedRatio"> 4:3</label>
        </div>
        <div class="cropper-container-wrapper">
          <img :src="currentCropImageUrl" ref="cropperImage" style="width:100%;" />
        </div>
        <button type="button" @click="cropCurrent">Crop & Add</button>
      </div>
      <div v-if="images.length" class="mt-3">
        <div v-for="(img, index) in images" :key="index" style="display:inline-block; margin-right: 10px;">
          <img :src="img.previewUrl" style="max-width: 100px;" />
        </div>
      </div>
      <button type="submit" class="btn btn-primary mt-3">Submit</button>
    </form>
  </div>
</template>

<script>
import Cropper from 'cropperjs'
import 'cropperjs/dist/cropper.css'

export default {
  data() {
    return {
      userId: null,
      title: '',
      description: '',
      selectedRatio: 0.75,
      images: [],
      isCropping: false,
      currentCropImageUrl: null,
      cropper: null,
    };
  },
  created() {
    this.userId = JSON.parse(document.querySelector('#post-work').dataset.user).id;
  },
  methods: {
    triggerFileSelect() {
      this.$refs.fileInput.click();
    },
    onFileChange(event) {
      const file = event.target.files[0];
      if (!file) return;
      this.isCropping = true;
      if (this.cropper) {
        this.cropper.destroy();
      }
      this.currentCropImageUrl = URL.createObjectURL(file);
      this.$nextTick(() => {
        const imageElement = this.$refs.cropperImage;
        this.cropper = new Cropper(imageElement, {
          aspectRatio: Number(this.selectedRatio),
          viewMode: 1,
          autoCropArea: 0.8,
          responsive: true
        });
        setTimeout(() => {
          const containerData = this.cropper.getContainerData();
          const cropBoxWidth = containerData.width * 0.8;
          const cropBoxHeight = cropBoxWidth / this.cropper.options.aspectRatio;
          this.cropper.setCropBoxData({
            left: (containerData.width - cropBoxWidth) / 2,
            top: (containerData.height - cropBoxHeight) / 2,
            width: cropBoxWidth,
            height: cropBoxHeight
          });
        }, 200);
      });
    },
    cropCurrent() {
      if (!this.cropper) return;
      this.cropper.getCroppedCanvas().toBlob(blob => {
        const previewUrl = URL.createObjectURL(blob);
        this.images.push({
          croppedBlob: blob,
          previewUrl: previewUrl
        });
        this.isCropping = false;
        if (this.cropper) {
          this.cropper.destroy();
          this.cropper = null;
        }
        this.currentCropImageUrl = null;
        // ファイル入力の存在をチェックしてからリセット
        if (this.$refs.fileInput) {
          this.$refs.fileInput.value = '';
        }
      });
    },
    async postWork() {
      if (!this.title || !this.description || this.images.length === 0) {
        alert("タイトル、ディスクリプション及び画像が必要です。");
        return;
      }
      const formData = new FormData();
      formData.append('work[title]', this.title);
      formData.append('work[description]', this.description);
      this.images.forEach(img => {
        formData.append('work[images][]', img.croppedBlob);
      });
      try {
        const response = await fetch(`/users/${this.userId}/works`, {
          method: 'POST',
          body: formData,
          headers: {
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
            'Accept': 'application/json'
          }
        });
        if (response.ok) {
          const data = await response.json();
          window.location.href = data.redirect_url;
        } else {
          console.error('Error posting work:', await response.json());
        }
      } catch (error) {
        console.error('Error posting work:', error);
      }
    }
  },
  watch: {
    selectedRatio(newRatio) {
      if (this.cropper) {
        this.cropper.setAspectRatio(Number(newRatio));
      }
    }
  }
};
</script>

<style scoped>
.cropper-container-wrapper {
  width: 80%;
  max-width: 300px;
  margin: auto;
  border: 1px solid #ccc;
  overflow: hidden;
}

.cropper-view-box,
.cropper-crop-box {
  border-radius: 0 !important;
}

:deep(.cropper-view-box),
:deep(.cropper-crop-box),
.cropper-container .cropper-view-box,
.cropper-container .cropper-crop-box {
  border-radius: 0 !important;
}

:deep(.cropper-container),
:deep(.cropper-drag-box),
:deep(.cropper-crop-box) {
  margin: 0 !important;
  padding: 0 !important;
}
</style>