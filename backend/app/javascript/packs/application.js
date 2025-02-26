// ...existing imports and code...
const store = new Vuex.Store({
  state: {
    // currentUserにwindow.currentUserが存在しなければ空オブジェクトを設定
    currentUser: window.currentUser || {}
  },
  getters: {
    // currentUserへのアクセス用getterを追加
    currentUser: state => state.currentUser
  }
  // ...existing code...
});

// ...existing code...
new Vue({
  el: '#app',
  store,
  // ...existing code...
});