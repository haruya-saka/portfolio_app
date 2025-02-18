<template>
  <div class="cropper-modal" v-if="imageUrl">
    <div class="cropper-container">
      <div>
        <label>比率選択:</label>
        <label><input type="radio" value="0.75" :checked="aspectRatio === 0.75" @change="updateAspectRatio(0.75)"> 3:4</label>
        <label><input type="radio" value="1.33" :checked="aspectRatio === 1.33" @change="updateAspectRatio(1.33)"> 4:3</label>
      </div>
      <img :src="imageUrl" ref="cropperImage" class="cropper-image" />
      <button @click="cropCurrent" class="btn btn-success mt-3">Crop & Add</button>
      <button @click="$emit('cancel')" class="btn btn-secondary mt-3">Cancel</button>
    </div>
  </div>
</template>

<script>
import Cropper from 'cropperjs'
import 'cropperjs/dist/cropper.css'

export default {
  props: {
    imageUrl: {
      type: String,
      required: true
    },
    aspectRatio: {
      type: Number,
      default: 0.75
    }
  },
  data() {
    return {
      cropper: null
    };
  },
  mounted() {
    console.log('CropperModal mounted.')
    console.log('Received imageUrl prop:', this.imageUrl)
    console.log('Received aspectRatio prop:', this.aspectRatio)
    this.$nextTick(() => {
      const imageElement = this.$refs.cropperImage;
      this.cropper = new Cropper(imageElement, {
        aspectRatio: this.aspectRatio,
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
  methods: {
    cropCurrent() {
      if (!this.cropper) return;
      this.cropper.getCroppedCanvas().toBlob(blob => {
        const previewUrl = URL.createObjectURL(blob);
        console.log('Cropped image blob:', blob)
        console.log('Preview URL:', previewUrl)
        this.$emit('crop', blob, previewUrl);
        this.cropper.destroy();
        this.cropper = null;
      });
    },
    updateAspectRatio(newRatio) {
      console.log('Aspect ratio updated to:', newRatio)
      this.$emit('update:aspectRatio', newRatio);
      if (this.cropper) {
        this.cropper.setAspectRatio(Number(newRatio));
      }
    }
  },
  watch: {
    imageUrl(newVal) {
      console.log('imageUrl changed:', newVal);
    },
    aspectRatio(newVal) {
      console.log('aspectRatio changed:', newVal);
    }
  }
}
</script>

<style scoped>
.cropper-modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.8); /* 背景色を濃くする */
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000; /* モーダルを前面に表示 */
}

.cropper-container {
  background: #fff;
  padding: 1rem;
  border-radius: 4px;
  text-align: center;
}

.cropper-image {
  max-width: 100%;
  height: auto;
}

.cropper-view-box,
.cropper-crop-box {
  border-radius: 0 !important; /* 四角形にする */
}
</style>
