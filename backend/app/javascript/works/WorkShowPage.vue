<template>
  <div class="work-detail">
    <div class="left-panel">
      <div class="content">
        <h2>{{ work.title }}</h2>
        <p>{{ work.description }}</p>
      </div>
    </div>
    <div class="right-panel">
      <div class="images">
        <div v-for="(img, index) in work.work_images" :key="index" class="image-wrapper">
          <div class="img-container">
            <img :src="img.image_url" class="img-uniform" :alt="`Image ${index + 1}`">
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
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
    }
  },
  mounted() {
    console.log('WorkShowPage mounted.')
    console.log('Received user prop:', this.user)
    console.log('Received work prop:', this.work)
  }
}
</script>

<style scoped>
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

.right-panel {
  flex: 7;
  display: flex;
  flex-direction: column;
  align-items: center;
  overflow-y: auto; /* スクロール対応 */
  max-height: 80vh;
  scrollbar-width: none; /* Firefox用 */
  -ms-overflow-style: none; /* IE/Edge用 */
}

.right-panel::-webkit-scrollbar {
  display: none; /* Chrome/Safari用 */
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
  width: 70%; /* 横幅を7割に変更 */
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

@media (max-width: 768px) {
  .work-detail {
    flex-direction: column;
  }
  .left-panel, .right-panel {
    flex: 1;
  }
  .right-panel {
    max-height: none;
  }
}
</style>
