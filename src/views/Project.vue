<template>
  <content-row>
    <div v-if="loading" class="center-align loader-spinner">
      <div class="preloader-wrapper big active">
        <div class="spinner-layer spinner-blue-only">
          <div class="circle-clipper left">
            <div class="circle"></div>
          </div>
          <div class="gap-patch">
            <div class="circle"></div>
          </div>
          <div class="circle-clipper right">
            <div class="circle"></div>
          </div>
        </div>
      </div>
    </div>
    <div v-else v-html="body"></div>
  </content-row>
</template>

<script>
import { useRoute } from "vue-router";
import ProjectsFileList from "@/assets/projects/projects.json";
import Marked from "marked";
import ContentRow from "../components/ContentRow.vue";

export default {
  components: { ContentRow },
  data() {
    return {
      projectName: useRoute().params.name,
      fileName: ProjectsFileList[useRoute().params.name].filename,
      body: "Loading...",
      loading: true,
    };
  },
  created() {
    const renderer = {
      list(body) {
        return `<ul class="collection">${body}</ul>`
      },
      listitem(text) {
        return `<li class="collection-item">${text}</li>`
      }
    }

    Marked.use({renderer})



    let response = fetch(`/projects/${this.fileName}`);
    response
      .then((data) => data.text())
      .then((text) => {
        if (text.startsWith("<!DOC"))
          this.body = `Could not find the file describing this project (/projects/${this.filename})`;
        else this.body = Marked(text);
      })
      .catch((this.body = "error!!"))
      .finally(() => {
        this.loading = false;
      });
  },
  mounted() {
    
  }
};
</script>

<style>
ul.collection {
  list-style-type: circle;
}
li {
  list-style-type: circle;
}
</style>