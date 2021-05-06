<template>
  <div class="post-tile">
      <div class="post-title">
          <div class="hide-on-med-and-down show-on-medium">
            <h5>{{ title }}</h5>
          </div>
          <div class="hide-on-med-and-up">
             <h6>{{ title }}</h6>
          </div>
      </div>

      <div class="post-date">
          <div class="hide-on-med-and-down show-on-medium">
            <h6>Posted on: {{ date }}</h6>
          </div>
          <div class="hide-on-med-and-up">
            <p class="smaller-text">Posted on: {{ date }}</p>
          </div>
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
.smaller-text {
    font-size: 0.9rem;
}
</style>