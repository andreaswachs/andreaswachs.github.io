<template>
  <content-row>
    <h2>Hello, World!</h2>
    <p class="flow-text">Welcome to my personal website</p>

    <p>
      I'm a software development student, with a heart and soul that belongs mainly in back-end development.
      Since starting my studies, I have become increasingly interested in functional programming. I find the
      discrete mathematics field very interesting &mdash; although my performance at the first semester exam
      in discrete mathematics were just passing grades.
    </p>

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
