import "@rails/actioncable"
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue-next/dist/bootstrap-vue-next.css'
import { createBootstrap } from 'bootstrap-vue-next'
import { createApp } from 'vue'
import { createPinia } from 'pinia'
import { Turbo } from "@hotwired/turbo-rails"
import "@hotwired/stimulus"
import Home from '../home.vue'
import Login from '../session/Login.vue'
import SignupForm from '../components/SignupForm.vue'
import Header from '../components/Header.vue'
import Profile from '../users/Profile.vue'
import EditProfile from '../users/EditProfile.vue'
import WorksPage from '../works/WorksPage.vue'
import WorkShowPage from '../works/WorkShowPage.vue'
import PostWorks from '../works/PostWorks.vue'
import WorksEdit from '../works/WorksEdit.vue'
import Sidebar from '../components/Sidebar.vue'

Turbo.start()

function initializeApp(component, selector, props = {}) {
  const element = document.querySelector(selector)
  if (element) {
    const app = createApp(component, props)
    app.use(createBootstrap())
    app.use(createPinia())
    console.log('Bootstrap has been applied, Pinia registered')
    app.mount(selector)
  }
}

document.addEventListener('turbo:load', () => {
  initializeApp(Home, '#home')
  initializeApp(Login, '#login')
  initializeApp(SignupForm, '#signup-form')

  const headerElement = document.querySelector('#vue-header')
  if (headerElement) {
    const props = {
      rootPath: headerElement.dataset.rootPath,
      userPath: headerElement.dataset.userPath,
      worksPath: headerElement.dataset.worksPath, 
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

  const worksShowElement = document.querySelector('#works-show')
  if (worksShowElement) {
    const user = JSON.parse(worksShowElement.dataset.user)
    const work = JSON.parse(worksShowElement.dataset.work)
    initializeApp(WorkShowPage, '#works-show', { user, work })
  }
  
  const postWorkElement = document.querySelector('#post-work') 
  if (postWorkElement) {
    const user = JSON.parse(postWorkElement.dataset.user)
    initializeApp(PostWorks, '#post-work', { user })
  }

  const worksEditElement = document.querySelector('#works-edit')
  if (worksEditElement) {
    const user = JSON.parse(worksEditElement.dataset.user)
    const work = JSON.parse(worksEditElement.dataset.work)
    initializeApp(WorksEdit, '#works-edit', { user, work })
  }

  const sidebarElement = document.querySelector('#vue-sidebar')
  if (sidebarElement) {
    const props = {
      rootPath: sidebarElement.dataset.rootPath,
      userPath: sidebarElement.dataset.userPath,
      worksPath: sidebarElement.dataset.worksPath, 
      signupPath: sidebarElement.dataset.signupPath,
      loginPath: sidebarElement.dataset.loginPath,
      logoutPath: sidebarElement.dataset.logoutPath,
      loggedIn: sidebarElement.dataset.loggedIn === 'true'
    }
    initializeApp(Sidebar, '#vue-sidebar', props)
  }
})