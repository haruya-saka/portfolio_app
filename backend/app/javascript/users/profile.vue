<template>
  <div>
    <div class="d-flex align-items-center">
      <img :src="profileImageUrl" alt="Profile Image" class="rounded-circle img-thumbnail mr-3" style="width: 50px; height: 50px;" />
      <h1>{{ user.name }}</h1>
    </div>
    <div class="follow-info">
      <p>
        <button @click="openModal('following')">
          フォロー: {{ user.following_count }}
        </button>
      </p>
      <p>
        <button @click="openModal('followers')">
          フォロワー: {{ user.followers_count }}
        </button>
      </p>
    </div>
    <!-- プロフィール編集ボタン: 自分自身のページでのみ表示 -->
    <a v-if="isCurrentUser" :href="`/users/${user.id}/edit`" class="btn btn-secondary mt-3">プロフィールを編集</a>
    <FollowModal v-if="showModal" :userId="user.id" :type="modalType" :visible="showModal" @close="showModal = false" />
  </div>
</template>

<script>
import FollowModal from '../Relationships/FollowModal.vue'
import { useSessionStore } from '../stores/sessionStore'

export default {
  components: { FollowModal },
  props: {
    user: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      profileImageUrl: this.user.profile_image_url,
      showModal: false,
      modalType: ''
    };
  },
  computed: {
    isCurrentUser() {
      const sessionStore = useSessionStore();
      return sessionStore.currentUser && sessionStore.currentUser.id === this.user.id;
    }
  },
  methods: {
    openModal(type) {
      this.modalType = type;
      this.showModal = true;
    }
  },
  mounted() {
    const sessionStore = useSessionStore();
    sessionStore.loadCurrentUser(); // 追加: currentUser を読み込む
    console.log('User data in Profile:', this.user);
    console.log('User keys:', Object.keys(this.user));
    console.log('Following count:', this.user.following_count);
    console.log('Followers count:', this.user.followers_count);
  }
};
</script>

<style scoped>
.img-thumbnail {
  max-width: 100%;
  height: auto;
}
.follow-info {
  margin-top: 1rem;
}
button {
  background: none;
  border: none;
  color: blue;
  cursor: pointer;
  padding: 0;
  font-size: inherit;
}
</style>