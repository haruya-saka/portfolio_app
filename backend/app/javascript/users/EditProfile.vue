<template>
  <div>
    <div class="d-flex align-items-center">
      <img :src="temporaryImageUrl || user.profile_image_url" alt="Profile Image" class="rounded-circle img-thumbnail mr-3" style="width: 50px; height: 50px;" />
      <h1>{{ user.name }}</h1>
    </div>
    <button @click="showModal = true" class="btn btn-secondary ml-3">プロフィール画像を変更</button>
    <form @submit.prevent="updateProfile" class="mt-3">
      <div class="form-group">
        <label for="name">名前</label>
        <input type="text" id="name" v-model="form.name" class="form-control" />
      </div>
      <div class="form-group">
        <label for="description">自己紹介</label>
        <textarea id="description" v-model="form.description" class="form-control"></textarea>
      </div>
      <button type="submit" class="btn btn-primary mt-2">プロフィールを更新</button>
    </form>

    <!-- モーダル -->
    <ProfileImage v-if="showModal" @close="showModal = false" @image-selected="onImageSelected" />
  </div>
</template>

<script>
import ProfileImage from './ProfileImage.vue';

export default {
  components: {
    ProfileImage
  },
  props: {
    user: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      form: {
        name: '',
        email: '',
        profileImage: null,
        description: ''
      },
      showModal: false,
      temporaryImageUrl: null
    };
  },
  created() {
    this.form.name = this.user.name || '';
    this.form.email = this.user.email || '';
    this.form.description = this.user.description || '';
  },
  methods: {
    onImageSelected({ blob, imageUrl }) {
      this.form.profileImage = blob;
      this.temporaryImageUrl = imageUrl;
    },
    async updateProfile() {
      const formData = new FormData();
      if (this.form.name) {
        formData.append('user[name]', this.form.name);
      }
      if (this.form.email) {
        formData.append('user[email]', this.form.email);
      }
      if (this.form.description) {
        formData.append('user[description]', this.form.description);
      }
      if (this.form.profileImage) {
        formData.append('user[profile_image]', this.form.profileImage);
      }

      try {
        const response = await fetch(`/users/${this.user.id}`, {
          method: 'PATCH',
          body: formData,
          headers: {
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
          }
        });

        if (!response.ok) {
          const errorData = await response.json();
          throw new Error(errorData.errors.join(', '));
        }

        const responseData = await response.json();
        window.location.href = responseData.redirect_url;
      } catch (error) {
        console.error(error);
      }
    }
  }
};
</script>

<style>
</style>