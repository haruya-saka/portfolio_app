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
    <a :href="`/users/${user.id}/edit`" class="btn btn-secondary mt-3">プロフィールを編集</a>
    <FollowModal 
      v-if="showModal" 
      :visible="showModal" 
      :type="modalType" 
      :items="modalItems" 
      @close="closeModal" />
  </div>
</template>

<script>
import FollowModal from '../Relationships/FollowModal.vue'
export default {
  components: { FollowModal },
  props: { user: { type: Object, required: true } },
  data() {
    return {
      profileImageUrl: this.user.profile_image_url,
      showModal: false,
      modalType: '', // 'following' or 'followers'
      modalItems: [] // API から取得したデータ
    };
  },
  methods: {
    async openModal(type) {
      this.modalType = type;
      try {
        console.log("Fetching", type, "data for user", this.user.id);
        const res = await fetch(`/users/${this.user.id}/${type}`, {
          headers: { 'Accept': 'application/json' }
        });
        const data = await res.json();
        console.log("Received data:", data);
        this.modalItems = type === 'following' ? data.following : data.followers;
      } catch (err) {
        console.error("Error fetching data:", err);
      }
      this.showModal = true;
    },
    closeModal() {
      this.showModal = false;
      this.modalItems = [];
    }
  },
  mounted() {
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