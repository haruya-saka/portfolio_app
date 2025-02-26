<template>
  <div class="feed-container">
    <h2>フィード</h2>
    <div v-if="feed.length">
      <ul>
        <li v-for="item in feed" :key="item.id" class="feed-item">
          <p>ID: {{ item.id }}</p>
          <!-- ユーザー名クリックでプロフィールページへ -->
          <p>ユーザー名: <a :href="`/users/${item.user.id}`">{{ item.user.name }}</a></p>
          <p>タイトル: {{ item.title || 'タイトル未定義' }}</p>
          <p>投稿日: {{ item.created_at }}</p>
          <!-- 画像クリックでWorks詳細ページへ -->
          <a v-if="item.thumbnail_url" :href="`/users/${item.user.id}/works/${item.id}`">
            <img :src="item.thumbnail_url" alt="画像" class="img-fluid" />
          </a>
        </li>
      </ul>
    </div>
    <div v-else>
      <p>フィードがありません</p>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue'

export default defineComponent({
  name: 'Feed',
  setup() {
    const feed = ref([]);

    onMounted(() => {
      fetch('/feed')
        .then(response => response.json())
        .then(data => {
          feed.value = data;
        })
        .catch(error => {
          console.error("フィードの取得に失敗しました", error);
        });
    });

    return {
      feed
    }
  }
})
</script>

<style scoped>
.feed-container {
  max-width: 600px;
  margin: 0 auto;
  max-height: 500px;
  overflow-y: auto;
  padding: 10px;
}

.feed-item {
  margin-bottom: 20px;
}

/* Bootstrapが利用できない場合は以下のように画像サイズを調整 */
.img-fluid {
  max-width: 100%;
  height: auto;
}
</style>
