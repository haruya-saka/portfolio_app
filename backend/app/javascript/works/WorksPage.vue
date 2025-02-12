<template>
  <div class="works-container">
    <div v-for="work in localWorks" :key="work.id" class="work-card">
      <template v-if="work.thumbnail_url">
        <div class="img-wrapper">
          <img
            :src="work.thumbnail_url"
            class="img-uniform"
            alt="Work Image"
            @click="goToDetail(work.id)"
            @error="handleImageError(work.thumbnail_url)"
          >
        </div>
      </template>
      <div class="work-info">
        <h5>{{ work.title }}</h5>
        <!-- <button @click.stop="deleteWork(work.id)">削除</button> -->
      </div>
    </div>
    <div class="new-work-link">
      <a :href="newWorkPath" class="btn-link">Post a new work</a>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  props: {
    user: {
      type: Object,
      required: true
    },
    works: {
      type: Array,
      required: true
    }
  },
  data() {
    return {
      localWorks: [] // ローカルな状態として作品リストを管理
    };
  },
  computed: {
    newWorkPath() {
      return `/users/${this.user.id}/works/new`;
    }
  },
  methods: {
    async deleteWork(workId) {
      if (confirm('本当に削除しますか？')) {
        try {
          const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
          await axios.delete(`/users/${this.user.id}/works/${workId}`, {
            headers: {
              'X-CSRF-Token': csrfToken
            }
          });
          this.fetchWorks(); // 作品リストを再取得
        } catch (error) {
          console.error('削除に失敗しました:', error);
        }
      }
    },
    async fetchWorks() {
      try {
        console.log('Fetching works from server...');
        const response = await axios.get(`/users/${this.user.id}/works.json`, { // JSON形式で取得
          headers: {
            'Accept': 'application/json'
          }
        });
        console.log('Response received:', response.data);
        this.localWorks = response.data;
      } catch (error) {
        console.error('作品リストの取得に失敗しました:', error);
      }
    },
    handleImageError(imageUrl) {
      console.error('画像の読み込みに失敗しました:', imageUrl);
    },
    goToDetail(workId) {
      window.location.href = `/users/${this.user.id}/works/${workId}`;
    }
  },
  mounted() {
    this.localWorks = this.works;
    this.fetchWorks();
    window.addEventListener('beforeunload', this.fetchWorks); // ページ遷移時にデータを再取得
  },
  beforeDestroy() {
    window.removeEventListener('beforeunload', this.fetchWorks);
  }
};
</script>

<style scoped>
/* works 全体のコンテナ */
.works-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-top: 2rem;
}

/* 個別の work card */
.work-card {
  width: 300px;
  margin: 1rem 0;
  border: none; /* 黒枠を削除 */
  border-radius: 4px;
  box-shadow: none;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  align-items: center;
}

/* 画像用ラッパー */
.img-wrapper {
  width: 100%;
  height: 200px;
  overflow: hidden;
  display: flex;
  justify-content: center;
  align-items: center;
}

/* 画像のスタイルを統一 */
.img-uniform {
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center;
}

/* workの情報部分 */
.work-info {
  padding: 1rem;
  text-align: center;
}
.work-info h5 {
  margin: 0.5rem 0;
}
.work-info button {
  background: #dc3545;
  color: #fff;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  cursor: pointer;
}

/* 新規作品投稿ボタン */
.new-work-link {
  width: 100%;
  text-align: center;
  margin-top: 2rem;
}
.new-work-link .btn-link {
  text-decoration: none;
  color: #007bff;
  font-size: 1.1rem;
}
</style>