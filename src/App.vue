<template>

  <content-row class="site-header z-depth-5">
    <!-- This is the image at the top of the page -->
  </content-row>

  <div class="navbar-container">
    <nav class="nav-wrapper grey lighten-3">
      <div class="container">
        <!-- we can add a brand logo in the navbar -->
        <router-link to="/" class="left brand-logo black-text">
          <div class="valign-wrapper">
            <i class="material-icons">code</i>
            <span class="small-text hide-on-med-and-down">Andreas Wachs Hjalager - a personal website</span>
          </div>
        </router-link>

        <!-- we add the "hide-on-med-and-down" class to the div below -->
        <div class="right black-text">
          <ul>
            <li><router-link class="black-text" to="/" >Home</router-link></li>
            <li><router-link class="black-text" to="/posts">Posts</router-link></li>
            <li><router-link class="black-text" to="/projects">Projects</router-link></li>
            <li><router-link class="black-text" to="/about">About</router-link></li>
          </ul>
        </div>
      </div>
    </nav>
  </div>

  <content-row>
    <router-view />
  </content-row>
</template>

<script>
import ContentRow from './components/ContentRow.vue';

export default {
  components: { ContentRow },
};
</script>

<style>
@import url('https://fonts.googleapis.com/css2?family=Playfair+Display&display=swap');

.navbar-container {
    font-family: 'Playfair Display', serif;
    line-height: 8.5rem;
    font-weight: 400;
    color: #272727;
    text-decoration: none;
    margin: 0;
    -webkit-margin-before: 0;
    -webkit-margin-after: 0;
    -webkit-margin-start: 0;
}
.small-text {
  font-size: 1.2rem;
}
.left.brand-logo {
  margin-left:20px;
}
.site-header {
  background-image: url(/images/pexels-chait-goli-cropped.jpg);
  background-size: cover;
  min-height: 160px;
  border: none;
}

.navbar-container {
  margin-top: -20px;
}

body {
  font-size: 1.3rem;
}
ul {
  list-style: disc inside;
}
</style>
