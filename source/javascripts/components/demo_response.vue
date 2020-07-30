<template lang="pug">
  div
    h2.page__subTitle.demo__responseTitle Response
    pre.json(v-bind:class="{ demo__responseError: error }" v-html="formattedResponse")
</template>
<script>
export default {
  props: {
    response: {
      type: [Object, String],
      default: () => {},
    },
    error: {
      type: Boolean,
      default: false,
    },
  },
  computed: {
    formattedResponse: function() {
      if (typeof this.response === "object") {
        return JSON.stringify(this.response, null, 4);
      } else {
        return this.response;
      }
    },
  },
};
</script>
