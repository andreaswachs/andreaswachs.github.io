<template>
  <content-row>
      <h1>Projects</h1>
      <p class="flow-text">
          Here is a list of things that I like to show off.
      </p>

      <h2>
          Elixir
      </h2>

      <p class="flow-text">
          <router-link :to="{ name: 'Project', params: { name: 'eads'}}"> Algorithms and Data Structures</router-link>
      </p>
  </content-row>
</template>

<script>
import ContentRow from '../components/ContentRow.vue'
export default {
  components: { ContentRow },
    mounted() {
        console.log("gooo")
    }
}
</script>

<style>

</style>