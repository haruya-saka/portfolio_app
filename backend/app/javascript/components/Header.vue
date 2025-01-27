<template>
  <header>
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
      <div class="container-fluid">
        <button @click="navigateTo(rootPath)" class="navbar-brand btn btn-link">Portfolio App</button>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
          <ul class="navbar-nav">
            <li class="nav-item">
              <button @click="navigateTo(rootPath)" class="nav-link btn btn-link">Home</button>
            </li>
            <li v-if="loggedIn" class="nav-item">
              <button @click="navigateTo(userPath)" class="nav-link btn btn-link">Profile</button>
            </li>
            <li v-if="loggedIn" class="nav-item">
              <button @click="logout" class="nav-link btn btn-link">Logout</button>
            </li>
            <li v-else class="nav-item">
              <button @click="navigateTo(signupPath)" class="nav-link btn btn-link">Signup</button>
            </li>
            <li v-else class="nav-item">
              <button @click="navigateTo(loginPath)" class="nav-link btn btn-link">Login</button>
            </li>
          </ul>
        </div>
      </div>
    </nav>
  </header>
</template>

<script>
export default {
  props: {
    rootPath: String,
    userPath: String,
    signupPath: String,
    loginPath: String,
    logoutPath: String,
    loggedIn: Boolean,
  },
  mounted() {
    console.log('rootPath:', this.rootPath);
    console.log('userPath:', this.userPath);
    console.log('signupPath:', this.signupPath);
    console.log('loginPath:', this.loginPath);
    console.log('logoutPath:', this.logoutPath);
    console.log('loggedIn:', this.loggedIn);
  },
  methods: {
    navigateTo(path) {
      window.location.href = path;
    },
    logout() {
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

</script>
<style scoped>

</style>