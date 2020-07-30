<template lang="pug">
  div
    h2.page__subTitle.demo__responseTitle Response
    pre.json(v-bind:class="{ demo__responseError: error }" v-html="formattedResponse")
</template>
<script>
export default {
  props: {
    response: {
      type: Object,
      default: () => {},
    },
    error: {
      type: Boolean,
      default: false,
    },
  },
  computed: {
    formattedResponse: function() {
      return JSON.stringify(this.response, null, 4);
    },
  },
};
</script>
