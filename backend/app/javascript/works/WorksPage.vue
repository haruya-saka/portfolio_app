<template>
  <div id="works-page">
    <div class="works-container">
      <div class="user-info">
        <img :src="localWorkUser.profile_image_url" alt="Profile Image" class="rounded-circle img-thumbnail mr-3" style="width: 50px; height: 50px;" />
        <h2>{{ localWorkUser.name }}</h2>
        <button v-if="!isCurrentUser" @click="toggleFollow" :class="['btn', isFollowing ? 'btn-secondary' : 'btn-primary', 'ms-3']">
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
            <!-- <button class="delete-button" @click.stop="deleteWork(work.id)">削除</button> -->
          </div>
        </template>
        <div class="work-info">
          <h5>{{ work.title }}</h5>
        </div>
      </div>
      <div class="new-work-link" v-if="isCurrentUser">
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
    workUser: {
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
      localWorkUser: this.workUser,
      works: [],
      localWorks: this.works, // 初期値は props から設定
      isFollowing: false,
    };
  },
  setup() {
    const sessionStore = useSessionStore();
    sessionStore.loadCurrentUser();
    return { sessionStore };
  },
  computed: {
    newWorkPath() {
      return `/users/${this.localWorkUser.id}/works/new`;
    },
    currentUser() {
      console.log('sessionStore:', this.sessionStore);
      return (this.sessionStore && this.sessionStore.currentUser) ? this.sessionStore.currentUser : {};
    },
    isCurrentUser() {
      return this.localWorkUser && this.localWorkUser.id && this.currentUser && this.localWorkUser.id === this.currentUser.id;
    }
  },
  methods: {
    async fetchWorks() {
      try {
        console.log('Fetching works from server...');
        const response = await axios.get(`/users/${this.localWorkUser.id}/works.json`, {
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
      window.location.href = `/users/${this.localWorkUser.id}/works/${workId}`;
    },
    async toggleFollow() {
      try {
        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
        if (this.isFollowing) {
          await axios.delete(`/relationships/${this.localWorkUser.id}`, {
            headers: { 
              'X-CSRF-Token': csrfToken,
              'Accept': 'application/json'
            }
          });
        } else {          // フォロー関係が存在するかどうかを確認
          const checkResponse = await axios.get(`/relationships/find_by_user/${this.localWorkUser.id}`);
          if (!checkResponse.data.is_following) {
            await axios.post('/relationships', {
              followed_id: this.localWorkUser.id
            }, {
              headers: { 
                'X-CSRF-Token': csrfToken,
                'Accept': 'application/json'
              }
            });
          }
        }
        this.isFollowing = !this.isFollowing;
      } catch (error) {
        if (error.response && error.response.status === 500) {
          console.error('フォロー/アンフォローに失敗しました: 重複エントリの可能性があります。', error);
        } else {
          console.error('フォロー/アンフォローに失敗しました:', error);
        }
      }
    },
    async checkFollowing() {
      try {
        if (this.currentUser && this.currentUser.id) {
          const response = await axios.get(`/relationships/find_by_user/${this.localWorkUser.id}`);
          this.isFollowing = response.data.is_following;
        }
      } catch (error) {
        console.error('フォロー状態の確認に失敗しました:', error);
      }
    },
    async deleteWork(workId) {
      try {
        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
        await axios.delete(`/users/${this.localWorkUser.id}/works/${workId}`, {
          headers: { 
            'X-CSRF-Token': csrfToken,
            'Accept': 'application/json'
          }
        });
        this.localWorks = this.localWorks.filter(work => work.id !== workId);
      } catch (error) {
        console.error('作品の削除に失敗しました:', error);
      }
    },
  },
  mounted() {
    console.debug('workspage.vue mounted');
    const worksPageEl = document.getElementById('works-page');
    if (!worksPageEl) {
      console.error('works-page element not found');
      return;
    }
    const rawWorkUserData = worksPageEl.getAttribute('data-user');
    const rawWorksData = worksPageEl.getAttribute('data-works');
    console.debug('Raw user data:', rawWorkUserData);
    console.debug('Raw works data:', rawWorksData);
    try {
      const parsedWorkUser = JSON.parse(rawWorkUserData);
      this.localWorkUser = parsedWorkUser;
      console.debug('Parsed work user:', parsedWorkUser);
    } catch (e) {
      console.error('Failed to parse work user data:', e);
    }
    try {
      const parsedWorks = JSON.parse(rawWorksData);
      this.works = parsedWorks;
      console.debug('Parsed works:', parsedWorks);
    } catch (e) {
      console.error('Failed to parse works data:', e);
    }
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

.user-info .btn-secondary {
  background-color: #6c757d;
  border-color: #6c757d;
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
  position: relative;
  width: 100%;
  height: 200px;
  overflow: hidden;
  display: flex;
  justify-content: center;
  align-items: center;
}

/* 削除ボタン */
.delete-button {
  position: absolute;
  top: 10px;
  right: 10px;
  background: #dc3545;
  color: #fff;
  border: none;
  padding: 0.5rem;
  border-radius: 4px;
  cursor: pointer;
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