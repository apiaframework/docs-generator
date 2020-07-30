<template lang="pug">
  div
    APIForm(v-bind:args="this.args" v-on:submit="formSubmitted")
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
    url: {
      type: Object,
    },
  },
  methods: {
    formSubmitted: function(values) {
      const url = this.generateURL(values);
      console.log(values);
    },
    generateURL: function(values) {
      let pathWithArgs = this.url.path;
      const matches = Array.from(
        this.url.path.matchAll(/\:(\w+)/g),
        (m) => m[0]
      );
      const urlArgs = matches.forEach((urlArg) => {
        const argName = urlArg.substr(1);
        let argValue = null;
        Object.values(values[argName]).forEach((val) => {
          if (val) {
            argValue = val;
          }
        });
        if (argValue) {
          pathWithArgs = pathWithArgs.replace(urlArg, argValue);
          delete values[argName];
        }
      });

      return `https://${this.url.host}${this.url.namespace}/${pathWithArgs}`;
    },
  },
};
</script>
