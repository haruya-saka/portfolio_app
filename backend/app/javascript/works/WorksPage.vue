<template>
  <div id="works-page">
    <div class="works-container">
      <div class="user-info">
        <img :src="user.profile_image_url" alt="Profile Image" class="rounded-circle img-thumbnail mr-3" style="width: 50px; height: 50px;" />
        <h2>{{ user.name }}</h2>
        <button v-if="!isCurrentUser" @click="toggleFollow" class="btn btn-primary ml-3">
          {{ isFollowing ? 'Unfollow' : 'Follow' }}
        </button>
      </div>
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
      <div v-if="isCurrentUser" class="new-work-link">
        <a :href="newWorkPath" class="btn-link">Post a new work</a>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import { computed } from 'vue'
import { useSessionStore } from '../stores/sessionStore'

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
      user: {},
      works: [],
      localWorks: this.works, // 初期値は props から設定
      isFollowing: false,
      sessionStore: useSessionStore() // セッションストアを初期化
    };
  },
  computed: {
    newWorkPath() {
      return `/users/${this.user.id}/works/new`;
    },
    currentUser() {
      return this.sessionStore.currentUser; // セッションストアから取得
    },
    isCurrentUser() {
      return this.user && this.user.id && this.currentUser && this.user.id === this.currentUser.id;
    }
  },
  methods: {
    async fetchWorks() {
      try {
        console.log('Fetching works from server...');
        const response = await axios.get(`/users/${this.user.id}/works.json`, {
          headers: { 'Accept': 'application/json' }
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
    },
    async toggleFollow() {
      try {
        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
        if (this.isFollowing) {
          await axios.delete(`/relationships/${this.user.id}`, {
            headers: { 'X-CSRF-Token': csrfToken }
          });
        } else {
          await axios.post('/relationships', {
            followed_id: this.user.id
          }, {
            headers: { 'X-CSRF-Token': csrfToken }
          });
        }
        this.isFollowing = !this.isFollowing;
      } catch (error) {
        console.error('フォロー/アンフォローに失敗しました:', error);
      }
    },
    async checkFollowing() {
      try {
        // currentUser がある場合のみ状態確認
        if (this.currentUser && this.currentUser.id) {
          const response = await axios.get(`/users/${this.currentUser.id}/following`);
          this.isFollowing = response.data.some(following => following.id === this.user.id);
        }
      } catch (error) {
        console.error('フォロー状態の確認に失敗しました:', error);
      }
    }
  },
  mounted() {
    console.debug('workspage.vue mounted');
    this.sessionStore.loadCurrentUser(); // セッションストアからユーザー情報をロード
    console.debug('currentUser in mounted:', this.currentUser);
    const worksPageEl = document.getElementById('works-page');
    if (!worksPageEl) {
      console.error('works-page element not found');
      return;
    }
    const rawUserData = worksPageEl.getAttribute('data-user');
    const rawWorksData = worksPageEl.getAttribute('data-works');
    console.debug('Raw user data:', rawUserData);
    console.debug('Raw works data:', rawWorksData);
    try {
      const parsedUser = JSON.parse(rawUserData);
      this.user = parsedUser;
      console.debug('Parsed user:', parsedUser);
    } catch (e) {
      console.error('Failed to parse user data:', e);
    }
    try {
      const parsedWorks = JSON.parse(rawWorksData);
      this.works = parsedWorks;
      console.debug('Parsed works:', parsedWorks);
    } catch (e) {
      console.error('Failed to parse works data:', e);
    }
    // すでに currentUser はグローバルストアからロード済みとして利用
    this.fetchWorks();
    if (!this.isCurrentUser) this.checkFollowing();
    window.addEventListener('beforeunload', this.fetchWorks);
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

/* ユーザー情報 */
.user-info {
  display: flex;
  align-items: center;
  margin-bottom: 2rem;
}

.user-info img {
  margin-right: 1rem;
}

.user-info h2 {
  margin: 0;
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