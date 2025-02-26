<template>
  <div v-if="visible" class="modal-overlay">
    <div class="modal-content">
      <h2>{{ title }}</h2>
      <ul>
        <li v-for="item in items" :key="item.id" class="list-item">
          <img :src="item.profile_image_url" alt="Profile Image" class="rounded-circle" style="width: 40px; height: 40px; margin-right: 10px;" />
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
    visible: Boolean,
    type: String,
    items: { type: Array, default: () => [] }
  },
  computed: {
    title() {
      return this.type === 'following' ? 'フォロー中' : 'フォロワー'
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
.list-item {
  display: flex;
  align-items: center;
  margin-bottom: 0.5rem;
  padding-right: 2rem;
}
</style>
