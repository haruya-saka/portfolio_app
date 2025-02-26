<template>
  <div>
    <h2>ユーザー一覧</h2>
    <ul>
      <li v-for="user in users" :key="user.id">
        <a :href="`/users/${user.id}/works`">{{ user.name }}</a>
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  data() {
    return {
      users: []
    };
  },
  async created() {
    const response = await fetch('/users.json');
    const users = await response.json();
    this.users = users.sort((a, b) => b.id - a.id);
  }
};
</script>

<style scoped>
ul {
  list-style-type: none;
  padding: 0;
}

li {
  padding: 0.5rem 0;
}

a {
  text-decoration: none;
  color: #007bff;
}

a:hover {
  text-decoration: underline;
}
</style>
