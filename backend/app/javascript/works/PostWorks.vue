<template>
  <div id="post-work" data-user='{"id": 1}'>
    <form @submit.prevent="postWork">
      <div>
        <label for="title">Title</label>
        <input type="text" v-model="title" id="title" required>
      </div>
      <div>
        <label for="description">Description</label>
        <textarea v-model="description" id="description" required></textarea>
      </div>
      <div>
        <label for="image">Image</label>
        <input type="file" @change="onFileChange" id="image" required>
      </div>
      <button type="submit">Submit</button>
    </form>
  </div>
</template>

<script>
export default {
  data() {
    return {
      userId: null,
      title: '',
      description: '',
      image: null
    };
  },
  created() {
    this.userId = JSON.parse(document.querySelector('#post-work').dataset.user).id;
    console.log('User ID:', this.userId); // デバッグ用
  },
  methods: {
    onFileChange(event) {
      this.image = event.target.files[0];
    },
    async postWork() {
      console.log('postWork called'); // デバッグ用
      const formData = new FormData();
      formData.append('work[title]', this.title);
      formData.append('work[description]', this.description);
      formData.append('work[image]', this.image);

      try {
        const response = await fetch(`/users/${this.userId}/works`, {
          method: 'POST',
          body: formData,
          headers: {
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
          }
        });

        if (response.ok) {
          const data = await response.json();
          console.log('Success:', data); // デバッグ
          window.location.href = data.redirect_url; 
        } else {
          console.error('Error posting work:', await response.json());
        }
      } catch (error) {
        console.error('Error posting work:', error);
      }
    }
  }
};
</script>

<style scoped>
/* 必要に応じてスタイルを追加 */
</style>