import { defineStore } from 'pinia';

export const useFavoritesStore = defineStore('favorites', {
  state: () => ({
    favorites: {}
  }),
  actions: {
    async toggleFavorite(workId) {
      const isFavorited = this.favorites[workId];
      try {
        const response = await fetch(`/works/${workId}/favorites`, {
          method: isFavorited ? 'DELETE' : 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
          }
        });
        const data = await response.json();
        if (data.success) {
          this.favorites[workId] = !isFavorited;
        } else {
          console.error('Error:', data.errors);
          alert(`エラーが発生しました: ${data.errors.join(', ')}`);
        }
      } catch (error) {
        console.error('Error:', error);
        alert('エラーが発生しました。もう一度お試しください。');
      }
    },
    setFavorites(favorites) {
      this.favorites = favorites;
    }
  }
});
