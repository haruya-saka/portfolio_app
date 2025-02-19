<template>
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
    <div class="new-work-link">
      <a :href="newWorkPath" class="btn-link">Post a new work</a>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      user: {},
      currentUser: {}, // currentUserを追加
      localWorks: [], // ローカルな状態として作品リストを管理
      isFollowing: false
    };
  },
  computed: {
    newWorkPath() {
      return `/users/${this.user.id}/works/new`;
    },
    isCurrentUser() {
      return this.user.id === this.currentUser.id;
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
    },
    async toggleFollow() {
      try {
        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
        if (this.isFollowing) {
          await axios.delete(`/relationships/${this.user.id}`, {
            headers: {
              'X-CSRF-Token': csrfToken
            }
          });
        } else {
          await axios.post('/relationships', {
            followed_id: this.user.id
          }, {
            headers: {
              'X-CSRF-Token': csrfToken
            }
          });
        }
        this.isFollowing = !this.isFollowing;
      } catch (error) {
        console.error('フォロー/アンフォローに失敗しました:', error);
      }
    },
    async checkFollowing() {
      try {
        const response = await axios.get(`/users/${this.currentUser.id}/following`);
        this.isFollowing = response.data.some(following => following.id === this.user.id);
      } catch (error) {
        console.error('フォロー状態の確認に失敗しました:', error);
      }
    }
  },
  mounted() {
    const homeEl = document.getElementById('home');
    const currentUserData = homeEl?.dataset.currentUser;
    if (currentUserData) {
      this.currentUser = JSON.parse(currentUserData);
      console.log('Current user data:', this.currentUser);
    }
    const worksPageEl = document.getElementById('works-page');
    const userData = worksPageEl?.dataset.user;
    const worksData = worksPageEl?.dataset.works;
    if (userData) {
      this.user = JSON.parse(userData);
      console.log('User data:', this.user);
    }
    if (worksData) {
      this.localWorks = JSON.parse(worksData);
      console.log('Works data:', this.localWorks);
    }
    if (!currentUserData) {
      // currentUser の情報がない場合は、ログインユーザーは閲覧対象のユーザーと同じとみなす
      this.currentUser = this.user;
      console.log('No currentUser data found; assuming self.');
    }
    this.fetchWorks();
    if (!this.isCurrentUser) {
      this.checkFollowing();
    }
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