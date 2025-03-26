// show.html.erbにマウント

<template>
  <div class="profile-container">
    <div class="d-flex align-items-center">
      <a v-if="isCurrentUser" :href="`/users/${user.id}/edit`" class="settings-icon">
        <img src="@/icons/setting.png" alt="Settings" />
      </a>
      <img :src="profileImageUrl" alt="Profile Image" class="profile-image" />
      <div>
        <h1>{{ user.name }}</h1>
        <p v-if="user.description">{{ user.description }}</p>
      </div>
    </div>
    <div class="follow-info">
    <p>
      <button @click="openModal('following')">
        フォロー中<strong>{{ user.following_count }}</strong>人
      </button>
    </p>
    <p>
      <button @click="openModal('followers')">
        フォロワー<strong>{{ user.followers_count }}</strong>人
      </button>
    </p>
    <p>
      投稿<strong>{{ worksCount }}</strong>件
    </p>
    </div>
    <FollowModal
      v-if="showModal"
      :items="items"
      :type="modalType"
      :visible="showModal"
      @close="showModal = false" 
    />
  </div>
</template>

<script>
import FollowModal from '../Relationships/FollowModal.vue'; 
import { useSessionStore } from '../stores/sessionStore';
import { useWorksStore } from '../stores/worksStore';

export default {
  components: { FollowModal },
  props: {
    user: {
      type: Object,
      required: true
    }
  },
  setup() {
    const sessionStore = useSessionStore();
    const worksStore = useWorksStore();

    // 必要なデータをロード
    sessionStore.loadCurrentUser();
    worksStore.fetchWorksForUser(sessionStore.currentUser?.id);

    return { sessionStore, worksStore };
  },
  data() {
    return {
      profileImageUrl: this.user.profile_image_url,
      showModal: false,
      modalType: '',
      items: [],
      isCurrentUser: false, 
    };
  },
  computed: {
    worksCount() {
      return this.worksStore?.works?.length || 0;
    }
  },
  methods: {
    async openModal(type) {
      this.modalType = type;
      let response;
      if (type === 'following') {
        response = await fetch(`/users/${this.user.id}/following`);
      } else {
        response = await fetch(`/users/${this.user.id}/followers`);
      }
      const data = await response.json();
      this.items = type === 'following' ? data.following : data.followers;
      this.showModal = true;
    },
    async checkCurrentUser() {
      const sessionStore = useSessionStore();
      await sessionStore.loadCurrentUser();
      const currentUserId = sessionStore.currentUser ? Number(sessionStore.currentUser.id) : null;
      const userId = Number(this.user.id);
      this.isCurrentUser = currentUserId === userId;
      console.log('Updated isCurrentUser:', { currentUserId, userId, isCurrentUser: this.isCurrentUser });
    }
  },
  async mounted() {
    console.log('Received user object:', this.user); // userオブジェクトを出力
    await this.checkCurrentUser();
  }
};
</script>

<style>
.profile-container {
  display: flex;
  flex-direction: column;
  margin-top: 50px;
  margin-left: 30px; /* 左に余白を追加 */
}
.d-flex {
  align-items: center;
  position: relative;
}
.settings-icon {
  position: absolute;
  right: 5vw; /* 画面右端に配置 */
  top: 50%;
  transform: translateY(-50%);
}
.settings-icon img {
  width: 24px;
  height: 24px;
}
.profile-image {
  width: 100px; /* サイズを大きく変更 */
  height: 100px; /* サイズを大きく変更 */
  border-radius: 50%; /* 丸い形状を維持 */
  object-fit: cover; /* 画像を中央に収める */
  margin-right: 20px; /* 右側に余白を追加 */
}
.follow-info {
  display: flex; /* 横並びにする */
  gap: 1rem; /* 各項目の間隔を調整 */
  margin-top: 1rem;
}
.follow-info p {
  margin: 0;
}
button {
  background: none;
  border: none;
  color: black; /* 文字色を黒に変更 */
  cursor: pointer;
  padding: 0;
  font-size: inherit;
}
</style>