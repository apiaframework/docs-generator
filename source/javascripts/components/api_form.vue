<template lang="pug">
  form(v-on:submit="submitForm")
    APIArgument(v-bind:arg="{name: 'token'}" value="" v-on:change="argsChanged")
    APIArgument(v-for="arg in args" v-bind:arg="arg" :value="values[arg.name]" v-on:change="argsChanged")
    div {{values}}
</template>
<script>
import APIArgument from "./api_argument";

export default {
  components: {
    APIArgument: APIArgument,
  },
  props: {
    args: {
      type: Array,
    },
  },
  data: function() {
    return {
      values: this.emptyValues(this.args),
    };
  },
  methods: {
    emptyValues: function(args) {
      let vals = { token: "" };
      args.forEach((arg) => {
        if (arg.arguments) {
          vals[arg.name] = this.emptyValues(arg.arguments);
        } else if (arg.array) {
          vals[arg.name] = [];
        } else {
          vals[arg.name] = "";
        }
      });
      return vals;
    },
    argsChanged: function(newValues) {
      this.values[newValues.name] = newValues.value;
    },
    submitForm: function(e) {
      e.preventDefault();
      e.stopPropagation();
      this.$emit("submit", this.values);
    },
  },
};
</script>
