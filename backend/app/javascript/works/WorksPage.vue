<template>
  <div>
    <h1>{{ user.name }}'s Works</h1>
    <ul>
      <li v-for="work in localWorks" :key="work.id">
        <h2>{{ work.title }}</h2>
        <p>{{ work.description }}</p>
        <img :src="work.image_url" alt="Work Image" v-if="work.image_url">
        <button @click="deleteWork(work.id)">削除</button>
      </li>
    </ul>
    <a :href="newWorkPath">Post a new work</a>
  </div>
</template>

<script>
import axios from 'axios';

// リクエストインターセプター
axios.interceptors.request.use(request => {
  console.log('Starting Request', request);
  return request;
});

// レスポンスインターセプター
axios.interceptors.response.use(response => {
  console.log('Response:', response);
  return response;
});

export default {
  props: {
    user: {
      type: Object,
      required: true
    },
    works: {
      type: Array,
      required: true
    }
  },
  data() {
    return {
      localWorks: [] // ローカルな状態として作品リストを管理
    };
  },
  computed: {
    newWorkPath() {
      return `/users/${this.user.id}/works/new`;
    }
  },
  methods: {
    async deleteWork(workId) {
      if (confirm('本当に削除しますか？')) {
        try {
          const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
          await axios.delete(`/users/${this.user.id}/works/${workId}`, {
            headers: {
              'X-CSRF-Token': csrfToken
            }
          });
          this.fetchWorks(); // 作品リストを再取得
        } catch (error) {
          console.error('削除に失敗しました:', error);
        }
      }
    },
    async fetchWorks() {
      try {
        console.log('Fetching works from server...');
        const response = await axios.get(`/users/${this.user.id}/works`, {
          headers: {
            'Accept': 'application/json'
          }
        });
        console.log('Response received:', response.data);
        this.localWorks = response.data; // 作品リストを直接更新
      } catch (error) {
        console.error('作品リストの取得に失敗しました:', error);
      }
    }
  },
  mounted() {
    this.localWorks = this.works; // 初期データをローカルな状態にコピー
    this.fetchWorks(); // コンポーネントがマウントされたときに作品リストを取得
  }
};
</script>

<style scoped>
/* 必要に応じてスタイルを追加 */
</style>