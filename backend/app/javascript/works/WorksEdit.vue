<template>
  <WorkForm :user="user" :work="work" :submit-button-text="'Update'" :submit-form="updateWork" />
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
    },
    work: {
      type: Object,
      required: true
    }
  },
  mounted() {
    console.log('WorksEdit mounted.')
    console.log('Received user prop:', this.user)
    console.log('Received work prop:', this.work)
  },
  methods: {
    async updateWork(work, newImages) {
      console.log('updateWork called with:', work, newImages)
      const formData = new FormData();
      formData.append('work[title]', work.title);
      formData.append('work[description]', work.description);
      newImages.forEach(img => {
        formData.append('work[images][]', img.croppedBlob);
      });
      try {
        const response = await fetch(`/users/${this.user.id}/works/${work.id}`, {
          method: 'PUT',
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
          console.error('Error updating work:', await response.json());
        }
      } catch (error) {
        console.error('Error updating work:', error);
      }
    }
  }
}
</script>
