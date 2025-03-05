import { defineStore } from 'pinia'
import axios from 'axios'

export const useWorksStore = defineStore('works', {
	state: () => ({
		works: []
	}),
	actions: {
		async fetchWorksForUser(userId) {
			try {
				const response = await axios.get(`/users/${userId}/works.json`, {
					headers: { 'Accept': 'application/json' }
				});
				 // APIから返されたfavorite_countをそのまま利用する
				this.works = response.data;
			} catch (error) {
				console.error('作品データの取得に失敗しました:', error);
			}
		}
	}
});
