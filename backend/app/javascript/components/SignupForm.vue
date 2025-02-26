<template>
  <div class="container mt-5">
    <div v-if="flash.notice" class="alert alert-success">{{ flash.notice }}</div>
    <div v-if="flash.alert" class="alert alert-danger">{{ flash.alert }}</div>
    <div class="card">
      <div class="card-header">
        <h2>SignUp</h2>
      </div>
      <div class="card-body">
        <form @submit.prevent="submitForm">
          <div class="mb-3">
            <label for="name" class="form-label">Name</label>
            <input type="text" v-model="name" class="form-control" required autofocus autocomplete="name" />
          </div>

          <div class="mb-3">
            <label for="email_address" class="form-label">Email address</label>
            <input type="email" v-model="email_address" class="form-control" required autocomplete="email" />
          </div>

          <div class="mb-3">
            <label for="password" class="form-label">Password</label>
            <input type="password" v-model="password" class="form-control" required autocomplete="new-password" />
          </div>

          <div class="mb-3">
            <label for="password_confirmation" class="form-label">Password confirmation</label>
            <input type="password" v-model="password_confirmation" class="form-control" required autocomplete="new-password" />
          </div>

          <div>
            <button type="submit" class="btn btn-primary">Sign up</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>
<script>
import axios from 'axios';

export default {
  data() {
    return {
      name: '',
      email_address: '',
      password: '',
      password_confirmation: '',
      csrfToken: '',
      flash: {
        notice: '',
        alert: ''
      }
    };
  },
  mounted() {
    this.csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  },
  methods: {
    async submitForm() {
      console.log('Submitting form with:', {
        name: this.name,
        email_address: this.email_address,
        password: this.password,
        password_confirmation: this.password_confirmation
      });

      try {
        const response = await axios.post('/signup', {
          user: {
            name: this.name,
            email_address: this.email_address,
            password: this.password,
            password_confirmation: this.password_confirmation
          }
        }, {
          headers: {
            'X-CSRF-Token': this.csrfToken,
            'Accept': 'application/json'
          }
        });

        console.log('Response:', response);
        this.flash.alert = ''; // 失敗メッセージをクリア
        this.flash.notice = 'Signed up successfully';
        console.log('Flash notice:', this.flash.notice);

        const responseData = response.data;
        window.location.href = responseData.redirect_url; // プロフィールページにリダイレクト
      } catch (error) {
        console.log('Error:', error.response);
        this.flash.notice = ''; // 成功メッセージをクリア
        if (error.response && error.response.data && error.response.data.alert) {
          this.flash.alert = error.response.data.alert;
        } else {
          this.flash.alert = 'Sign up failed';
        }
        console.log('Flash alert:', this.flash.alert);
      }
    }
  }
};
</script>

<style scoped>
.container {
  max-width: 600px;
}
</style>