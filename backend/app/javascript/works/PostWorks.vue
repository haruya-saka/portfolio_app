<template>
  <WorkForm :user="user" :work="work" :submit-button-text="'Submit'" :submit-form="postWork" />
</template>

<script>
import WorkForm from './WorkForm.vue'

export default {
  components: {
    WorkForm
  },
  props: {
    user: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      work: {
        title: '',
        description: '',
        work_images: []
      }
    };
  },
  methods: {
    async postWork() {
      if (!this.work.title || !this.work.description || this.work.work_images.length === 0) {
        alert("タイトル、ディスクリプション及び画像が必要です。");
        return;
      }
      const formData = new FormData();
      formData.append('work[title]', this.work.title);
      formData.append('work[description]', this.work.description);
      this.work.work_images.forEach(img => {
        formData.append('work[images][]', img.croppedBlob);
      });
      try {
        const response = await fetch(`/users/${this.user.id}/works`, {
          method: 'POST',
          body: formData,
          headers: {
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
            'Accept': 'application/json'
          }
        });
        if (response.ok) {
          const data = await response.json();
          window.location.href = data.redirect_url;
        } else {
          console.error('Error posting work:', await response.json());
        }
      } catch (error) {
        console.error('Error posting work:', error);
      }
    }
  }
}
</script>