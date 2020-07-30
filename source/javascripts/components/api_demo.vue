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
    protocol: {
      type: String,
      default: "https",
    },
  },
  methods: {
    formSubmitted: function(values) {
      const token = values.token;
      delete values.token;
      fetch(this.generateURL(values), {
        method: this.method,
        body: this.method === "GET" ? null : JSON.stringify(values),
        headers: {
          "Content-type": this.method === "GET" ? null : "application/json",
          Authorization: token ? `Bearer ${token}` : null,
        },
      })
        .then((response) => {
          return response.json();
        })
        .then((json) => {
          console.log(json);
        });
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

      const baseURL = `${this.protocol}://${this.url.host}${this.url.namespace}/${pathWithArgs}`;
      if (this.method === "GET") {
        return `${baseURL}?${new URLSearchParams(
          this.cleanValues(values)
        ).toString()}`;
      } else {
        return baseURL;
      }
    },
    cleanValues: function(values) {
      Object.keys(values).forEach((key) => {
        if (values[key] && typeof values[key] === "object") {
          cleanValues(values[key]);
        } else if (!values[key]) {
          delete values[key];
        }
      });
      return values;
    },
  },
};
</script>
