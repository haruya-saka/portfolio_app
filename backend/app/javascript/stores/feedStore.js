import { ref } from 'vue';

export const feed = ref([]);

export const fetchFeed = async () => {
  try {
    const response = await fetch('/feed');
    const data = await response.json();
    // 各 feed アイテムの user プロパティに profile_image があれば profile_image_url にマッピング
    data.forEach(item => {
      if (item.user && item.user.profile_image && !item.user.profile_image_url) {
        item.user.profile_image_url = item.user.profile_image;
      }
    });
    feed.value = data;
  } catch (error) {
    console.error("フィードの取得に失敗しました", error);
  }
};
