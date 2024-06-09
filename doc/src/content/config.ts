import { defineCollection, z } from "astro:content"

const prefabCollection = defineCollection({
    type: 'content',
    schema: z.object({
        name: z.string(),
    }),
})

export const collections = {
    prefabs: prefabCollection,
}