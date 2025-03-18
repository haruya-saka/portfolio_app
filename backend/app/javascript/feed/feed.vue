<template>
  <div class="feed-container">
    <h2>フィード</h2>
    <div v-if="feed.length">
      <ul>
        <li v-for="item in feed" :key="item.title" class="feed-item">
          <!-- ユーザー情報(画像と名前) -->
          <div class="user-info">
            <img :src="item.user.profile_image_url" alt="Profile Image" class="rounded-circle img-thumbnail mr-3" style="width: 50px; height: 50px;" />
            <a :href="`/users/${item.user.id}/works`">{{ item.user.name }}</a>
          </div>
          <p>タイトル: {{ item.title || 'タイトル未定義' }}</p>
          <!-- 画像クリックでWorks詳細ページへ -->
          <a v-if="item.thumbnail_url" :href="`/users/${item.user.id}/works/${item.id}`">
            <img :src="item.thumbnail_url" alt="画像" class="img-fluid" />
          </a>
          <!-- いいねボタン追加 -->
          <button @click="toggleFavorite(item.id)">
            {{ favorites[item.id] ? 'いいね解除' : 'いいね' }}
          </button>
        </li>
      </ul>
    </div>
    <div v-else>
      <p>フィードがありません</p>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, onMounted, ref } from 'vue'
import { fetchFeed, feed } from '../stores/feedStore'
import { useFavoritesStore } from '../stores/favoritesStore'

export default defineComponent({
  name: 'Feed',
  setup() {
    const favoritesStore = useFavoritesStore();
    const toggleFavorite = (workId: number) => {
      favoritesStore.toggleFavorite(workId);
    };

    onMounted(async () => {
      await fetchFeed();
      // feed APIの各フィードアイテムにis_favorited属性が含まれていることを前提にfavoritesをセットする
      feed.value.forEach(item => {
        favoritesStore.favorites[item.id] = item.is_favorited;
      });
      console.log("初期いいね状態:", favoritesStore.favorites);
    });

    return {
      feed,
      toggleFavorite,
      favorites: favoritesStore.favorites
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

ul {
  list-style: none;
  padding-inline-start: 0;
}

.feed-item {
  margin-bottom: 20px;
}

.img-fluid {
  max-width: 100%;
  height: auto;
}
</style>
