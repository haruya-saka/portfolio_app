<template>
  <div class="modal" tabindex="-1" role="dialog" style="display: block;" @click.self="closeModal">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">プロフィール画像を変更</h5>
        </div>
        <div class="modal-body">
          <div class="pi-form-group">
            <label for="profileImage">新しいプロフィール画像を選択</label>
            <input type="file" id="profileImage" @change="onFileChange" class="form-control-file" />
          </div>
          <div v-if="imageUrl" class="cropper-container">
            <img ref="image" :src="imageUrl" alt="Profile Image" />
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" @click="closeModal">キャンセル</button>
          <button type="button" class="btn btn-primary" @click="confirmImage">選択</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Cropper from 'cropperjs';
import 'cropperjs/dist/cropper.css';

export default {
  data() {
    return {
      profileImage: null,
      imageUrl: null,
      cropper: null
    };
  },
  methods: {
    onFileChange(event) {
      const file = event.target.files[0];
      if (file) {
        this.imageUrl = URL.createObjectURL(file);
        this.$nextTick(() => {
          if (this.cropper) {
            this.cropper.destroy();
            this.cropper = null;
          }
          this.cropper = new Cropper(this.$refs.image, {
            aspectRatio: 1,
            viewMode: 1,
            scalable: true,
            zoomable: true,
            minContainerWidth: 500,
            minContainerHeight: 500,
            center: true,
            cropBoxResizable: false,
          });
        });
      }
    },
    confirmImage() {
      if (!this.cropper) {
        alert('プロフィール画像を選択してください');
        return;
      }

      const canvas = this.cropper.getCroppedCanvas({
        width: 100,
        height: 100,
      });
      canvas.toBlob((blob) => {
        const imageUrl = URL.createObjectURL(blob);
        this.$emit('image-selected', { blob, imageUrl });
        this.closeModal();
      });
    },
    closeModal() {
      this.$emit('close');
    }
  }
};
</script>


<style>
.modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
}
.modal-dialog {
  max-width: 600px;
  width: 90%;
  margin: 0 auto;
}
.modal-content {
  display: flex;
  flex-direction: column;
  align-items: center;
}
.modal-body {
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
}
.pi-form-group {
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
}
.cropper-container {
  position: relative;
  width: 100%;
  height: 500px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-top: 20px;
}
.cropper-container img {
  max-width: 100%;
  max-height: 100%;
  object-fit: cover;
}
.cropper-view-box,
.cropper-face {
  border-radius: 50%;
  cursor: grab;
  outline: initial;
}

.cropper-face:active {
  cursor: grabbing;
}
</style>