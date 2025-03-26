<template>
  <div class="container d-flex flex-column justify-content-center align-items-center vh-100">
    <p class="message text-center mb-5">{{ message }}</p>
    <div class="content text-center w-100">
      <LoginForm v-if="!user" />
      <div v-else>
        <!-- ログイン時にfeedコンポーネントを表示 -->
        <div v-if="user" class="feed-wrapper">
          <Feed />
        </div>
      </div>
      <div class="mt-4 text-center position-relative">
        <hr>
        <span class="position-absolute top-50 start-50 translate-middle bg-white px-2">または</span>
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
import LoginForm from './session/LoginForm.vue'
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
  font-size: 2rem;
}

button {
  padding: 0.5rem 1rem;
  font-size: 1rem;
  cursor: pointer;
}

.container {
  max-width: 400px;
}

/* Feedコンポーネントを中央揃え */
.feed-wrapper {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
}
</style>