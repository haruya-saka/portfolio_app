<template>
  <aside class="bg-light vh-100 mt-4 ms-5" style="width: 15%;">
    <nav class="d-flex flex-column p-3 nav-custom">
      <button @click="navigateTo(rootPath)" class="navbar-brand btn btn-link mb-3">Portfolio App</button>
      <div class="button-container">
        <button v-if="loggedIn" @click="navigateTo(rootPath)" class="btn btn-link text-start d-flex align-items-center">
          <img src="@/icons/home.png" alt="Home Icon" class="me-2" style="width: 20px; height: 20px;" />
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
        <button v-if="loggedIn && computedWorkId" @click="goToEdit" class="btn btn-link text-start d-flex align-items-center">
          <img src="@/icons/work_edit.png" alt="Works Icon" class="me-2" style="width: 20px; height: 20px;" />
          Edit Work
        </button>
        <button v-if="loggedIn" @click="logout" class="btn btn-link text-start d-flex align-items-center">
          <img src="@/icons/logout.png" alt="Logout Icon" class="me-2" style="width: 20px; height: 20px;" />
          Logout
        </button>
        <button v-if="!loggedIn" @click="navigateTo(loginPath)" class="btn btn-link text-start d-flex align-items-center">
          <img src="@/icons/login.png" alt="Login Icon" class="me-2" style="width: 20px; height: 20px;" />
          Login
        </button>
        <button v-if="!loggedIn" @click="navigateTo(signupPath)" class="btn btn-link text-start d-flex align-items-center">
          <img src="@/icons/signup.png" alt="Signup Icon" class="me-2" style="width: 20px; height: 20px;" />
          Signup
        </button>
      </div>
    </nav>
  </aside>
</template>

<script>
import { useSessionStore } from '../stores/sessionStore'
export default {
  props: {
    rootPath: String,
    userPath: String,
    worksPath: String,
    signupPath: String,
    loginPath: String,
    logoutPath: String,
    loggedIn: Boolean,
    user: {
      type: Object,
      default: null
    }
  },
  data() {
    return {
      currentPath: window.location.pathname,
      sessionStore: useSessionStore()
    }
  },
  computed: {
    currentUser() {
      return this.sessionStore.currentUser;
    },
    computedWorkId() {
      if (!this.currentUser) {
        console.log('computedWorkId: No session user available');
        return null;
      }
      // URL例: /users/{userId}/works/{workId}
      const regex = /^\/users\/(\d+)\/works\/(\d+)/;
      const m = this.currentPath.match(regex);
      if (m) {
        const urlUserId = m[1];
        const workId = m[2];
        if (urlUserId === String(this.currentUser.id)) {
          console.log(`computedWorkId: User matches. workId = ${workId}`);
          return workId;
        } else {
          console.log(`computedWorkId: User mismatch. URL userId ${urlUserId} vs session userId ${this.currentUser.id}`);
          return null;
        }
      } else {
        console.log(`computedWorkId: Regex did not match. currentPath: ${this.currentPath}`);
        return null;
      }
    }
  },
  watch: {
    computedWorkId(newVal) {
      console.log('Watcher: computedWorkId changed to', newVal);
    }
  },
  methods: {
    navigateTo(path) {
      window.location.href = path;
    },
    goToEdit() {
      // 現在のパス末尾に '/edit' を重複して追加しないようにする
      const basePath = this.currentPath.replace(/\/edit$/, '');
      window.location.href = `${basePath}/edit`;
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
    },
    updatePath() {
      this.currentPath = window.location.pathname;
    }
  },
  mounted() {
    // 追加: セッションユーザー情報をロード
    this.sessionStore.loadCurrentUser();
    // ロード後の currentUser を確認（非同期対策のためsetTimeoutで遅延を入れる）
    setTimeout(() => {
      console.log('Mounted: currentUser =', this.currentUser);
      console.log('Mounted: currentPath =', this.currentPath);
    }, 0);
    window.addEventListener('popstate', this.updatePath);
  },
  beforeUnmount() {
    window.removeEventListener('popstate', this.updatePath);
  }
}
</script>

<style scoped>
nav.nav-custom button {
  font-size: 1.2rem;
  margin-bottom: 10px;
  color: black !important;
  text-decoration: none !important;
}

img {
  display: inline-block;
}

.button-container {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}
</style>
