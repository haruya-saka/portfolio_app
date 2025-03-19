<template>
  <div class="feed-container">
    <div v-if="feed.length">
      <ul class="list-unstyled">
        <li v-for="item in feed" :key="item.title" class="feed-item border-bottom pb-3 mb-3">
          <div class="user-info d-flex align-items-center mb-2">
            <img :src="item.user.profile_image_url" alt="Profile Image" class="rounded-circle img-thumbnail me-3" style="width: 50px; height: 50px;" />
            <a :href="`/users/${item.user.id}/works`">{{ item.user.name }}</a>
          </div>
          <div class="image-container bg-black d-flex align-items-center justify-content-center mb-2">
            <a v-if="item.thumbnail_url" :href="`/users/${item.user.id}/works/${item.id}`">
              <img :src="item.thumbnail_url" alt="画像" class="feed-image img-fluid" />
            </a>
            <div v-else class="no-image"></div>
          </div>
          <p>{{ item.title || 'タイトル未定義' }}</p>
          <img 
            :src="favorites[item.id] ? likedIcon : likeIcon" 
            alt="Favorite Icon" 
            class="favorite-icon mt-2" 
            @click="toggleFavorite(item.id)" 
          />
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
import likedIcon from '@/icons/liked.png';
import likeIcon from '@/icons/like.png';

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
      favorites: favoritesStore.favorites,
      likedIcon, 
      likeIcon  
    }
  }
})
</script>

<style scoped>
.feed-container {
  max-width: 30vw;
  margin: 0 auto;
  max-height: 80vh; /* ビューポート高さの80%に変更 */
  overflow-y: auto;
}

ul {
  list-style: none;
  padding-inline-start: 0;
}

.feed-item {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.user-info {
  margin-bottom: 0.5rem;
}

.img-fluid {
  max-width: 100%;
  height: auto;
}

/* いいねアイコンのスタイル */
.favorite-icon {
  width: 24px;
  height: 24px;
  cursor: pointer;
}

.image-container {
  width: 100%;
  margin-bottom: 0.5rem;
}

.feed-image {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
}
.no-image {
  width: 100%;
  height: 100%;
}
</style>
