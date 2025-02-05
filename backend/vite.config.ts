import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import vue from '@vitejs/plugin-vue'
import Components from 'unplugin-vue-components/vite'
import { BootstrapVueNextResolver } from 'bootstrap-vue-next'

export default defineConfig({
    plugins: [
        RubyPlugin(),
        vue(),
        Components({
            resolvers: [BootstrapVueNextResolver()],
        }),
    ],
    logLevel: 'info',
})