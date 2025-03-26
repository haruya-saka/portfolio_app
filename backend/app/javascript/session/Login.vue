<template>
  <div class="container d-flex flex-column justify-content-center align-items-center vh-100">
    <p class="message text-center mb-5">{{ message }}</p>
    <div class="content text-center w-100">
      <LoginForm />
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue'
import LoginForm from './LoginForm.vue'

export default defineComponent({
  name: 'Login',
  components: {
    LoginForm,
  },
  setup() {
    const message = "Portfolio App";

    return {
      message
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

.feed-wrapper {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
}
</style>