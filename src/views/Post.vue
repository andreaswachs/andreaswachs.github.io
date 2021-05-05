<template>
  <div v-if="error != null">
    <div class="warning">{{ error }}</div>  
  </div>
  <div v-else class="post">
    <div class="header">
      <div class="title">
        <h3>{{ post.title }}</h3>
      </div>
      <div class="date">
        <p class="flow-text blue-grey-text text-lighten-1">
          Posted on {{ post.date }}
        </p>
      </div>
    </div>
    <div class="body">
      <span v-html="body"></span>
    </div>
  </div>
</template>

<script>
import Posts from "@/assets/posts/posts.json";
import Marked from "marked";
import renderMathInElement from "katex/dist/contrib/auto-render.js";
import hljs from "highlight.js/lib/core"
import java from "highlight.js/lib/languages/java"
import elixir from "highlight.js/lib/languages/elixir"
import haskell from "highlight.js/lib/languages/haskell"
import javascript from "highlight.js/lib/languages/javascript"



export default {
  data: () => {
    return {
      loading: true,
      post: null,
      error: null,
      body: null,
    };
  },
  created() {
    this.fetchData();
  },
  methods: {
    fetchData() {
      this.error = this.post = null;
      this.loading = true;
      const id = this.$route.params.id;

      let found = false;
      for (let post of Posts) {
        if (post.id == id) {
          this.post = post;
          found = true;
          break;
        }
      }

      if (found) {
        let response = fetch(`/posts/${this.post.id}.md`);
        response
          .then((data) => data.text())
          .then((text) => {
            if (text.startsWith("<!DOC")) this.body = "Unknown post";
            else this.body = Marked(text);
          })
          .catch((this.body = "error!!"));
      } else {
        this.error = "Post not found."
      }
    },
  },
  updated: function () {
    renderMathInElement(document.body, {
      delimiters: [
        { left: "$$", right: "$$", display: true },
        { left: "$", right: "$", display: false },
        { left: "\\(", right: "\\)", display: false },
        { left: "\\[", right: "\\]", display: true },
      ],
      // • rendering keys, e.g.:
      throwOnError: false,
    });
    hljs.registerLanguage('java', java)
    hljs.registerLanguage('haskell', haskell)
    hljs.registerLanguage('elixir', elixir)
    hljs.registerLanguage('javascript', javascript)
    hljs.highlightAll()
  },
};
</script>

<style>
.header {
  border-left: 2px dotted purple;
  padding-left: 20px;
}

div.title {
  font-style: italic;
}

div.date {
  font-weight: 200;
}
</style>