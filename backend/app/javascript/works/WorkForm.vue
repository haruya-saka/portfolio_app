<template>
  <div class="work-detail">
    <div class="left-panel">
      <div class="content">
        <input v-model="work.title" class="editable-title" placeholder="Title" />
        <textarea v-model="work.description" class="editable-description" placeholder="Description"></textarea>
      </div>
    </div>
    <div class="right-panel">
      <div class="images">
        <div v-for="(img, index) in work.work_images" :key="index" class="image-wrapper" style="position: relative;">
          <div class="img-container">
            <img :src="img.image_url" class="img-uniform" :alt="`Image ${index + 1}`" @contextmenu.prevent="removeImage(index)">
            <!-- 編集時のみ表示: オプションボタン -->
            <button v-if="submitButtonText === 'Update'" @click="toggleOptions(index)" class="option-btn" style="position: absolute; top: 2px; right: 2px; background: none; border: none;">
              <img src="/workspace/backend/app/javascript/icons/option.png" alt="Options" style="width: 20px; height: 20px;">
            </button>
            <!-- オプションメニュー -->
            <div v-if="submitButtonText === 'Update' && optionVisibleIndex === index" class="option-menu" style="position: absolute; top: 25px; right: 2px; background: white; border: 1px solid #ccc; z-index: 10;">
              <button @click="handleDeleteExisting(index)" style="display: block;">削除</button>
              <button @click="cropExisting(index)" style="display: block;">トリミング</button>
            </div>
          </div>
        </div>
        <div v-for="(img, index) in newImages" :key="`new-${index}`" class="image-wrapper" style="position: relative;">
          <div class="img-container">
            <img :src="img.previewUrl" class="img-uniform" :alt="`New Image ${index + 1}`">
            <!-- 編集時のみ表示: オプションボタン (新規画像) -->
            <button v-if="submitButtonText === 'Update'" @click="toggleNewOptions(index)" class="option-btn" style="position: absolute; top: 2px; right: 2px; background: none; border: none;">
              <img src="/workspace/backend/app/javascript/icons/option.png" alt="Options" style="width: 20px; height: 20px;">
            </button>
            <!-- オプションメニュー (新規画像) -->
            <div v-if="submitButtonText === 'Update' && optionVisibleNewIndex === index" class="option-menu" style="position: absolute; top: 25px; right: 2px; background: white; border: 1px solid #ccc; z-index: 10;">
              <button @click="handleDeleteNew(index)" style="display: block;">削除</button>
              <button @click="cropNew(index)" style="display: block;">トリミング</button>
            </div>
          </div>
        </div>
        <div class="image-wrapper">
          <div class="img-container add-image" @click="triggerFileSelect" v-if="!isCropping">
            ＋
          </div>
          <input ref="fileInput" type="file" @change="onFileChange" accept="image/*" style="display:none">
          <div v-if="isCropping" class="cropper-container">
            <div class="cropper-image-wrapper">
              <img :src="currentCropImageUrl" ref="cropperImage" class="cropper-image" />
            </div>
            <div class="cropper-controls-buttons">
              <div class="cropper-controls">
                <label>比率選択:</label>
                <label><input type="radio" value="0.75" :checked="selectedRatio === 0.75" @change="updateAspectRatio(0.75)"> 3:4 (縦長)</label>
                <label><input type="radio" value="1.33" :checked="selectedRatio === 1.33" @change="updateAspectRatio(1.33)"> 4:3 (横長)</label>
              </div>
              <div class="cropper-buttons">
                <button @click="cropCurrent" class="btn btn-success mt-3">Crop & Add</button>
                <button @click="cancelCrop" class="btn btn-secondary mt-3">Cancel</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <button @click="submitForm(work, newImages)" class="btn btn-primary mt-3">{{ submitButtonText }}</button>
  </div>
</template>

<script>
import Cropper from 'cropperjs'
import 'cropperjs/dist/cropper.css'

export default {
  components: {},
  props: {
    user: {
      type: Object,
      default: null
    },
    work: {
      type: Object,
      default: () => ({
        title: '',
        description: '',
        work_images: []
      })
    },
    submitButtonText: {
      type: String,
      default: 'Submit'
    },
    submitForm: {
      type: Function,
      required: true
    }
  },
  data() {
    return {
      selectedRatio: 0.75,
      isCropping: false,
      currentCropImageUrl: null,
      newImages: [],
      cropper: null,
      optionVisibleIndex: null,      // for work.work_images
      optionVisibleNewIndex: null,   // for newImages
      croppingTarget: null           // { type: 'existing' or 'new', index: Number }
    };
  },
  mounted() {
    console.log('WorkForm mounted.')
    console.log('Received user prop:', this.user)
    console.log('Received work prop:', this.work)
  },
  methods: {
    triggerFileSelect() {
      this.$refs.fileInput.click();
    },
    onFileChange(event) {
      const file = event.target.files[0];
      if (!file) return;
      this.isCropping = true;
      this.currentCropImageUrl = URL.createObjectURL(file);
      console.log('File selected:', file)
      console.log('Current crop image URL:', this.currentCropImageUrl)
      this.$nextTick(() => {
        const imageElement = this.$refs.cropperImage;
        this.cropper = new Cropper(imageElement, {
          aspectRatio: this.selectedRatio,
          viewMode: 1,
          autoCropArea: 0.8,
          responsive: true
        });
      });
    },
    cropCurrent() {
      if (!this.cropper || !this.croppingTarget) return;
      this.cropper.getCroppedCanvas().toBlob(blob => {
        const previewUrl = URL.createObjectURL(blob);
        console.log('Cropped image blob:', blob)
        console.log('Preview URL:', previewUrl)
        if (this.croppingTarget.type === 'existing') {
          // 既存画像の場合：croppedBlobも保存する
          this.work.work_images.splice(this.croppingTarget.index, 1, { image_url: previewUrl, croppedBlob: blob });
        } else if (this.croppingTarget.type === 'new') {
          // 新規画像の場合：croppedBlobを保存する
          this.newImages.splice(this.croppingTarget.index, 1, { croppedBlob: blob, previewUrl: previewUrl });
        }
        this.croppingTarget = null;
        this.isCropping = false;
        this.currentCropImageUrl = null;
        if (this.$refs.fileInput) {
          this.$refs.fileInput.value = '';
        }
        this.cropper.destroy();
        this.cropper = null;
      });
    },
    cancelCrop() {
      this.isCropping = false;
      this.currentCropImageUrl = null;
      if (this.$refs.fileInput) {
        this.$refs.fileInput.value = '';
      }
      if (this.cropper) {
        this.cropper.destroy();
        this.cropper = null;
      }
    },
    removeImage(index) {
      this.work.work_images.splice(index, 1);
    },
    updateAspectRatio(newRatio) {
      this.selectedRatio = newRatio;
      if (this.cropper) {
        this.cropper.setAspectRatio(Number(newRatio));
      }
    },
    toggleOptions(index) {
      this.optionVisibleIndex = this.optionVisibleIndex === index ? null : index;
    },
    handleDeleteExisting(index) {
      this.removeImage(index);
      this.optionVisibleIndex = null;
    },
    cropExisting(index) {
      this.croppingTarget = { type: 'existing', index: index };
      this.currentCropImageUrl = this.work.work_images[index].image_url;
      this.isCropping = true;
      this.optionVisibleIndex = null;
      this.$nextTick(() => {
        const imageElement = this.$refs.cropperImage;
        this.cropper = new Cropper(imageElement, {
          aspectRatio: this.selectedRatio,
          viewMode: 1,
          autoCropArea: 0.8,
          responsive: true
        });
      });
    },
    toggleNewOptions(index) {
      this.optionVisibleNewIndex = this.optionVisibleNewIndex === index ? null : index;
    },
    handleDeleteNew(index) {
      this.newImages.splice(index, 1);
      this.optionVisibleNewIndex = null;
    },
    cropNew(index) {
      this.croppingTarget = { type: 'new', index: index };
      this.currentCropImageUrl = this.newImages[index].previewUrl;
      this.isCropping = true;
      this.optionVisibleNewIndex = null;
      this.$nextTick(() => {
        const imageElement = this.$refs.cropperImage;
        this.cropper = new Cropper(imageElement, {
          aspectRatio: this.selectedRatio,
          viewMode: 1,
          autoCropArea: 0.8,
          responsive: true
        });
      });
    }
  }
}
</script>

<style>
.work-detail {
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: flex-start;
  gap: 1rem;
  padding: 1rem;
}

.left-panel {
  flex: 3;
  display: flex;
  justify-content: center;
  align-items: center;
  position: sticky;
  top: 0;
  height: 100vh;
}

.content {
  text-align: center;
}

.editable-title {
  width: 100%;
  font-size: 2rem;
  text-align: center;
  border: none;
  border-bottom: 1px solid #ccc;
}

.editable-description {
  width: 100%;
  height: 150px;
  font-size: 1rem;
  border: 1px solid #ccc;
  border-radius: 4px;
  padding: 0.5rem;
}

.right-panel {
  flex: 7;
  display: flex;
  flex-direction: column;
  align-items: center;
  overflow-y: auto;
  max-height: 80vh;
  scrollbar-width: none;
  -ms-overflow-style: none;
}

.right-panel::-webkit-scrollbar {
  display: none;
}

.images {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
}

.image-wrapper {
  width: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.img-container {
  width: 70%;
  height: auto;
  overflow: hidden;
  display: flex;
  justify-content: center;
  align-items: center;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.img-uniform {
  width: 100%;
  height: auto;
  object-fit: contain;
  object-position: center;
}

.add-image {
  cursor: pointer;
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 2rem;
  /* color: #007bff;
  border: 2px dashed #007bff; */
}

.cropper-container {
  position: relative;
  width: 100%;
  max-width: 500px;
  margin: 1rem auto;
  text-align: center;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.cropper-image-wrapper {
  width: 100%;
}

.cropper-image {
  width: 100%;
  height: auto;
}

.cropper-controls-buttons {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-top: 1rem;
}

.cropper-controls {
  margin-top: 1rem;
}

.cropper-buttons {
  display: flex;
  justify-content: center;
  gap: 1rem;
  margin-top: 1rem;
  flex-direction: row;
}

.cropper-view-box,
.cropper-crop-box,
.cropper-face {
  border-radius: 0 !important; /* 四角形にする */
}

</style>