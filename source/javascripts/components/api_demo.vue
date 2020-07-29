<template lang="pug">
  div
    span {{method}}
    APIForm(v-bind:args="this.args")
</template>
<script>
import APIForm from "./api_form.vue";

export default {
  components: {
    APIForm: APIForm,
  },
  props: {
    args: {
      type: Array,
    },
    method: {
      type: String,
    },
  },
};
</script>
