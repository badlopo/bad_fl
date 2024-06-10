/// <reference path="../.astro/types.d.ts" />
/// <reference types="astro/client" />

declare global {
    interface FrontMatterData {
        /**
         * 组件名称
         */
        name: string
        /**
         * 组件示例gist的id
         */
        gistId?: string
        /**
         * 源码地址
         */
        sourceUrl?: string
    }
}
