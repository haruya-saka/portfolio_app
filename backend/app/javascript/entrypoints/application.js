import "@rails/actioncable"
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue-next/dist/bootstrap-vue-next.css'
import { createBootstrap } from 'bootstrap-vue-next'
import { createApp } from 'vue'
import "@hotwired/turbo-rails"
import "@hotwired/stimulus"
import Home from '../home.vue'
import LoginForm from '../components/LoginForm.vue'
import SignupForm from '../components/SignupForm.vue'
import Header from '../components/Header.vue'
// import "@hotwired/stimulus-loading"

function initializeApp(component, selector) {
  const element = document.querySelector(selector)
  if (element) {
    const app = createApp(component)
    app.use(createBootstrap())
    console.log('Bootstrap has been applied')
    app.mount(selector)
  }
}

document.addEventListener('turbo:load', () => {
  initializeApp(Home, '#home')
  initializeApp(LoginForm, '#login-form')
  initializeApp(SignupForm, '#signup-form')
  initializeApp(Header, '#header')
})