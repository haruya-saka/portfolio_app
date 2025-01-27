<template>
  <div class="container mt-5">
    <div class="row justify-content-center">
      <div class="col-md-8">
        <form @submit.prevent="submitForm">
          <div class="mb-4">
            <label for="email" class="form-label">Email address</label>
            <input
              type="email"
              id="email"
              v-model="email"
              class="form-control form-control-sm"
              required
              placeholder="Enter your email"
            />
          </div>
          <div class="mb-4">
            <label for="password" class="form-label">Password</label>
            <input
              type="password"
              id="password"
              v-model="password"
              class="form-control form-control-sm"
              required
              placeholder="Enter your password"
            />
          </div>
          <button type="submit" class="btn btn-primary btn-sm w-100">Login</button>
        </form>
        <div class="mt-4 text-center position-relative">
          <hr>
          <span class="position-absolute top-50 start-50 translate-middle bg-white px-2">または</span>
        </div>
        <div class="mt-3 text-center">
          <a :href="forgotPasswordPath">パスワードを忘れた場合</a>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      email: '',
      password: '',
      forgotPasswordPath: '/passwords/new', // ルートに応じて変更
      csrfToken: '' // CSRF トークンを保存するためのデータプロパティを追加
    };
  },
  mounted() {
    // コンポーネントがマウントされた後に CSRF トークンを取得
    this.csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  },
methods: {
  submitForm() {
    axios.post('/session', {
      session : {
        email_address: this.email,
        password: this.password
      }
    }, {
      headers: {
        'X-CSRF-Token': this.csrfToken // 取得した CSRF トークンを使用
      }
    })
    .then(response => {
      if (response.data.redirect_url) {
        window.location.href = response.data.redirect_url;
      }
    })
    .catch(error => {
      // エラー時の処理
      alert('Invalid email or password');
    });
  }
}
};
</script>

<style scoped>
.container {
  max-width: 400px;
}
</style>