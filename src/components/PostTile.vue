<template>
  <div class="post-tile">
      <div class="post-title">
          <h5>{{ title }}</h5>
      </div>

      <div class="post-date">
          <h6>Posted on: {{ date }}</h6>
      </div>

        <router-link :to="{ name: 'Post', params: { id: id }}"><div class="btn btn-primary">Read</div></router-link>
  </div>
</template>

<script>
export default {
    name: 'PostTile',
    props: {
        id: Number,
        title: String,
        date: String,
    }
}
</script>

<style>
.post-tile {
    border-left: 2px dashed purple;
    padding-left: 20px;
    margin-bottom: 2rem;
}
.post-title {
    font-style: italic;
}

</style>