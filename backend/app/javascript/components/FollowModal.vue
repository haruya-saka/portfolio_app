<template>
  <div v-if="visible" class="modal-overlay">
    <div class="modal-content">
      <h2>{{ title }}</h2>
      <ul>
        <li v-for="item in items" :key="item.id">
          <a :href="`/users/${item.id}`">{{ item.name }}</a>
        </li>
      </ul>
      <button @click="$emit('close')">閉じる</button>
    </div>
  </div>
</template>

<script>
export default {
  name: "FollowModal",
  props: {
    userId: Number,
    type: String,
    visible: Boolean
  },
  data() {
    return {
      items: []
    }
  },
  computed: {
    title() {
      return this.type === 'following' ? 'フォロー中' : 'フォロワー';
    }
  },
  watch: {
    visible(val) {
      if (val) {
        this.fetchData();
      }
    }
  },
  methods: {
    async fetchData() {
      try {
        const res = await fetch(`/users/${this.userId}/${this.type}`, {
          headers: { 'Accept': 'application/json' }
        });
        const data = await res.json();
        this.items = this.type === 'following' ? data.following : data.followers;
      } catch (err) {
        console.error(err);
      }
    }
  }
}
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex; justify-content: center; align-items: center;
}
.modal-content {
  background: #fff;
  padding: 1rem;
  border-radius: 8px;
  width: 300px;
}
</style>
