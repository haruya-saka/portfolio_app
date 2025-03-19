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
    async postWork(work, newImages) {
      if (!work.title || !work.description || newImages.length === 0) {
        alert("タイトル、ディスクリプション及び画像が必要です。");
        return;
      }
      const formData = new FormData();
      formData.append('work[title]', work.title);
      formData.append('work[description]', work.description);
      newImages.forEach(img => {
        formData.append('work[work_images][]', img.croppedBlob);
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