import { defineStore } from 'pinia';

export const useSessionStore = defineStore('session', {
  state: () => ({
    currentUser: null
  }),
  actions: {
    loadCurrentUser() {
      const meta = document.querySelector('meta[name="current-user"]');
      console.debug("loadCurrentUser: meta tag", meta, meta && meta.content);
      if (!meta || !meta.content || meta.content === 'undefined') {
        console.warn('Meta tag for current user is missing or invalid.');
        this.currentUser = null;
        return;
      }
      try {
        this.currentUser = JSON.parse(meta.content);
        console.debug("loadCurrentUser: Parsed currentUser", this.currentUser);
      } catch (error) {
        console.error('Error parsing current user data:', error);
        this.currentUser = null;
      }
    }
  }
});
