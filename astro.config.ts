import { defineConfig } from 'astro/config'
import mdx from '@astrojs/mdx'
import mermaid from 'astro-mermaid'
import sitemap from '@astrojs/sitemap'
import remarkMath from 'remark-math'
import remarkDirective from 'remark-directive'
import rehypeKatex from 'rehype-katex'
import remarkEmbeddedMedia from './src/plugins/remark-embedded-media.mjs'
import remarkReadingTime from './src/plugins/remark-reading-time.mjs'
import rehypeCleanup from './src/plugins/rehype-cleanup.mjs'
import rehypeImageProcessor from './src/plugins/rehype-image-processor.mjs'
import rehypeCopyCode from './src/plugins/rehype-copy-code.mjs'
import remarkTOC from './src/plugins/remark-toc.mjs'
import { themeConfig } from './src/config'
import path from 'path'
import cloudflare from '@astrojs/cloudflare'

export default defineConfig({
  adapter: cloudflare({
    imageService: process.env.NODE_ENV === 'development' ? 'passthrough' : 'cloudflare-binding',
    prerenderEnvironment: 'node'
  }),
  output: 'static',
  site: themeConfig.site.website,
  markdown: {
    shikiConfig: {
      theme: 'css-variables',
      wrap: false
    },
    remarkPlugins: [remarkMath, remarkDirective, remarkEmbeddedMedia, remarkReadingTime, remarkTOC],
    rehypePlugins: [rehypeKatex, rehypeCleanup, rehypeImageProcessor, rehypeCopyCode]
  },
  integrations: [
    mermaid({
      autoTheme: true,
      theme: 'neutral'
    }),
    mdx(),
    sitemap()
  ],
  vite: {
    resolve: {
      alias: {
        '@': path.resolve('./src')
      }
    }
  },
  devToolbar: {
    enabled: false
  }
})
