<template>
  <content-row>
    <h2>Hello, World!</h2>
    
    <p>
      I've created this site to publish posts on various programming/CS topics, where I find something interesting to share.
      This site is a personal product after taking my 2nd semester course 
      <em>Systematic Development of User Interfaces</em> at the IT University of Copenhagen.
    </p>
  </content-row>
</template>

<script>
import ContentRow from '../components/ContentRow.vue'
// @ is an alias to /src

export default {
  name: 'Home',
  components: {
    ContentRow
  }
}
</script>

<style scoped>

</style>
