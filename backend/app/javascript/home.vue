<template>
  <div class="container d-flex flex-column justify-content-center align-items-center vh-100">
    <p class="message text-center mb-5">{{ message }}</p>
    <div class="content text-center w-100" style="max-width: 400px;">
      <LoginForm v-if="!user" />
      <div v-else>
        <p>Welcome, {{ user.name }}</p>
          <!-- ログイン時にfeedコンポーネントを表示 -->
        <div v-if="user">
          <Feed />
        </div>
        <button class="btn btn-primary btn-sm" @click="logout">Logout</button>
      </div>
      <div class="signup mt-4" v-if="!user">
        アカウントをお持ちでないですか？
        <button class="btn btn-primary btn-sm" @click="goToSignup">登録する</button>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue'
import LoginForm from './components/LoginForm.vue'
import Feed from './feed/feed.vue'

export default defineComponent({
  name: 'home',
  components: {
    LoginForm,
    Feed
  },
  setup() {
    const message = "Portfolio App";
    const user = ref(null);

    const goToSignup = () => {
      window.location.href = '/signup';
    };

    const logout = async () => {
      await fetch('/logout', {
        method: 'DELETE',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        }
      });
      window.location.href = '/';
    };

    // カレントユーザー情報を取得
    const userData = document.getElementById('home')?.dataset.user;
    if (userData) {
      user.value = JSON.parse(userData);
    }

    return {
      message,
      user,
      goToSignup,
      logout
    }
  }
})
</script>

<style scoped>
.message {
  font-size: 2em;
}

button {
  padding: 10px 20px;
  font-size: 1em;
  cursor: pointer;
}
</style>