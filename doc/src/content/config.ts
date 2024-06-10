import { defineCollection, z } from "astro:content"

const prefabCollection = defineCollection({
    type: 'content',
    schema: z.object({
        name: z.string(),
        gistId: z.string().optional(),
        sourceUrl: z.string().optional(),
    }),
})

export const collections = {
    prefabs: prefabCollection,
}