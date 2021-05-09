<template>
    <main>
        <h3>Posts archive</h3>
        <p class="flow-text">Here is a list of posts that I've made. Search by text, with <kbd>CTRL+F</kbd> or <kbd>CMD+F</kbd></p>
 
        <h4>Posts</h4>
        <div v-for="post in sortedPosts" :key="post.id">
            <post-tile :id="post.id" :title="post.title" :date="post.date" />
        </div>
    </main>
</template>

<script>
import Posts from "@/assets/posts/posts.json";
import PostTile from "../components/PostTile.vue";

export default {
  components: { PostTile },

  data: () => {
    return {
      Posts,
    };
  },
  computed: {
    sortedPosts: function() {
      return this.Posts.filter(() => true).sort((p1, p2) => p1.id < p2.id ? 1 : -1)
    }
  }
};
</script>

<style>
img[src$="centered"] {
  display:block;
  margin: 0 auto;
}
</style>