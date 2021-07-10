<template>
  <content-row>
    <div class="about">
      <h2>Who am I?</h2>

      <div class="row valign-wrapper">
        <div class="col s0 m2 hide-on-med-and-down show-on-medium">
          <img src="images/headshot.png" class="responsive-img circle" />
        </div>

        <div class="col s12 m10">
          <p>
            I'm a software development student, with a heart and soul that
            belongs mainly in back-end development. Since starting my studies, I
            have become increasingly interested in functional programming. I
            find the discrete mathematics field very interesting &mdash;
            although certainly not a naturally gifted mathematics student.
          </p>
        </div>
      </div>
    </div>
  </content-row>
</template>
<script>
import ContentRow from "../components/ContentRow.vue";

export default {
  components: { ContentRow },
};
</script>

