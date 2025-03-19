<template>
  <aside class="bg-light vh-100 mt-4" style="width: 15%;">
    <nav class="d-flex flex-column p-3 nav-custom">
      <button @click="navigateTo(rootPath)" class="navbar-brand btn btn-link mb-3">Portfolio App</button>
      <button @click="navigateTo(rootPath)" class="btn btn-link text-start d-flex align-items-center">
        <img src="@/icons/home_icon.png" alt="Home Icon" class="me-2" style="width: 20px; height: 20px;" />
        Home
      </button>
      <button v-if="loggedIn" @click="navigateTo(userPath)" class="btn btn-link text-start d-flex align-items-center">
        <img src="@/icons/profile_icon.png" alt="Profile Icon" class="me-2" style="width: 20px; height: 20px;" />
        Profile
      </button>
      <button v-if="loggedIn" @click="navigateTo(worksPath)" class="btn btn-link text-start d-flex align-items-center">
        <img src="@/icons/works.png" alt="Works Icon" class="me-2" style="width: 20px; height: 20px;" />
        Works
      </button>
      <button v-if="loggedIn" @click="logout" class="btn btn-link text-start d-flex align-items-center">
        <img src="@/icons/logout.png" alt="Logout Icon" class="me-2" style="width: 20px; height: 20px;" />
        Logout
      </button>
      <button v-else @click="navigateTo(signupPath)" class="btn btn-link text-start">Signup</button>
      <button v-else @click="navigateTo(loginPath)" class="btn btn-link text-start">Login</button>
    </nav>
  </aside>
</template>

<script>
export default {
  props: {
    rootPath: String,
    userPath: String,
    worksPath: String, 
    signupPath: String,
    loginPath: String,
    logoutPath: String,
    loggedIn: Boolean,
  },
  methods: {
    navigateTo(path) {
      window.location.href = path;
    },
    logout() {
      if (confirm('ログアウトしますか？')) {
        fetch(this.logoutPath, {
          method: 'DELETE',
          headers: {
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
          }
        }).then(() => {
          window.location.href = this.rootPath;
        });
      }
    }
  }
}
</script>

<style scoped>
/* 必要に応じてスタイルを追加 */
nav.nav-custom button {
  font-size: 1.2rem; /* 文字サイズを大きく */
  margin-bottom: 10px; /* 縦間隔を広く */
  color: black !important; /* 青色を黒文字に */
  text-decoration: none !important; /* アンダーラインを消す */
}

img {
  display: inline-block;
}
</style>
