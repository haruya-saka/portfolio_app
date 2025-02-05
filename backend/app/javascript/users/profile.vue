<template>
  <div>
    <div class="d-flex align-items-center">
      <img :src="profileImageUrl" alt="Profile Image" class="rounded-circle img-thumbnail mr-3" style="width: 50px; height: 50px;" />
      <h1>{{ user.name }}</h1>
    </div>

    <a :href="`/users/${user.id}/edit`" class="btn btn-secondary mt-3">プロフィールを編集</a>
  </div>
</template>

<script>
export default {
  props: {
    user: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      profileImageUrl: this.user.profile_image_url
    };
  }
};
</script>

<style scoped>
.img-thumbnail {
  max-width: 100%;
  height: auto;
}
</style>