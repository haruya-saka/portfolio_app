import "@rails/actioncable"
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue-next/dist/bootstrap-vue-next.css'
import { createBootstrap } from 'bootstrap-vue-next'
import { createApp } from 'vue'
import { Turbo } from "@hotwired/turbo-rails"
import "@hotwired/stimulus"
import Home from '../home.vue'
import LoginForm from '../components/LoginForm.vue'
import SignupForm from '../components/SignupForm.vue'
import Header from '../components/Header.vue'
import Profile from '../users/Profile.vue'
import EditProfile from '../users/EditProfile.vue'
import WorksPage from '../works/WorksPage.vue'
import PostWorks from '../works/PostWorks.vue'

Turbo.start()

function initializeApp(component, selector, props = {}) {
  const element = document.querySelector(selector)
  if (element) {
    const app = createApp(component, props)
    app.use(createBootstrap())
    console.log('Bootstrap has been applied')
    app.mount(selector)
  }
}

document.addEventListener('turbo:load', () => {
  initializeApp(Home, '#home')
  initializeApp(LoginForm, '#login-form')
  initializeApp(SignupForm, '#signup-form')

  const headerElement = document.querySelector('#vue-header')
  if (headerElement) {
    const props = {
      rootPath: headerElement.dataset.rootPath,
      userPath: headerElement.dataset.userPath,
      signupPath: headerElement.dataset.signupPath,
      loginPath: headerElement.dataset.loginPath,
      logoutPath: headerElement.dataset.logoutPath,
      loggedIn: headerElement.dataset.loggedIn === 'true'
    }
    initializeApp(Header, '#vue-header', props)
  }

  const profileElement = document.querySelector('#profile')
  if (profileElement) {
    const user = JSON.parse(profileElement.dataset.user)
    initializeApp(Profile, '#profile', { user })
  }

  const editProfileElement = document.querySelector('#edit-profile') 
  if (editProfileElement) {
    const user = JSON.parse(editProfileElement.dataset.user)
    initializeApp(EditProfile, '#edit-profile', { user })
  }

  const worksElement = document.querySelector('#works-page') 
  if (worksElement) {
    const user = JSON.parse(worksElement.dataset.user)
    const works = JSON.parse(worksElement.dataset.works)
    initializeApp(WorksPage, '#works-page', { user, works })
  }
  
  const postWorkElement = document.querySelector('#post-work') 
  if (postWorkElement) {
    const user = JSON.parse(postWorkElement.dataset.user)
    initializeApp(PostWorks, '#post-work', { user })
  }
})