<template lang="pug">
div
  DemoForm(
    :loading="loading",
    v-bind:args="this.args",
    v-on:submit="formSubmitted"
  )
  DemoResponse(v-if="response", :response="response", :error="responseError")
</template>
<script>
import DemoForm from "./demo_form.vue";
import DemoResponse from "./demo_response.vue";
import cloneDeep from "lodash.clonedeep";

export default {
  components: {
    DemoForm: DemoForm,
    DemoResponse: DemoResponse,
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
  data: function () {
    return {
      response: null,
      responseError: false,
      loading: false,
    };
  },
  methods: {
    formSubmitted: function (formValues) {
      this.loading = true;
      let values = this.cleanValues(cloneDeep(formValues));
      if (Object.keys(values).length === 0) {
        this.loading = false;
        return;
      }
      const token = values.token;
      delete values.token;
      console.log(values);
      fetch(this.generateURL(values), {
        method: this.method,
        body: this.method === "GET" ? null : JSON.stringify(values),
        headers: {
          "Content-type": this.method === "GET" ? null : "application/json",
          Authorization: token ? `Bearer ${token}` : null,
        },
      })
        .then((response) => {
          if (!response.ok) {
            this.responseError = true;
          } else {
            this.responseError = false;
          }
          return response.json();
        })
        .then((json) => {
          this.response = json;
          this.loading = false;
        })
        .catch((error) => {
          console.error("Error:", error);
          this.response = "Error: Unable to perform API Query.";
          this.responseError = true;
          this.loading = false;
        });
    },
    generateURL: function (values) {
      let pathWithArgs = this.url.path;
      const matches = Array.from(
        this.url.path.matchAll(/\:(\w+)/g),
        (m) => m[0]
      );
      const urlArgs = matches.forEach((urlArg) => {
        const argName = urlArg.substr(1);
        let argValue = null;
        if (values[argName] && values[argName].id) {
          pathWithArgs = pathWithArgs.replace(urlArg, values[argName]["id"]);
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
    cleanValues: function (values) {
      Object.keys(values).forEach((key) => {
        if (values[key] && typeof values[key] === "object") {
          this.cleanValues(values[key]);
          if (Object.keys(values[key]).length === 0) {
            delete values[key];
          }
        } else if (!values[key]) {
          delete values[key];
        }
      });
      return values;
    },
  },
};
</script>
