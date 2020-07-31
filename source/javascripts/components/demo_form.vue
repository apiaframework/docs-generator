<template lang="pug">
  form.demo__form(v-on:submit="submitForm")
    DemoArgument(v-bind:arg="{name: 'token'}" value="" v-on:change="argsChanged")
    DemoArgument(v-for="arg in args" v-bind:arg="arg" :value="values[arg.name]" v-on:change="argsChanged")
    input.demo__submitButton(v-bind:class="{ loading: loading }" type="submit" value="Send")
</template>
<script>
import DemoArgument from "./demo_argument";

export default {
  components: {
    DemoArgument: DemoArgument,
  },
  props: {
    args: {
      type: Array,
    },
    loading: {
      type: Boolean,
      default: false,
    },
  },
  data: function() {
    return {
      values: {},
    };
  },
  methods: {
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
