<template lang="pug">
  div.apiDemo__argumentContainer
    div.apiDemo__argument(v-if="!arg.arguments")
      label.apiDemo__argumentLabel(:for="arg.name" v-if="arg.required") {{arg.name}} (required)
      label.apiDemo__argumentLabel(:for="arg.name" v-else) {{arg.name}}
      select.apiDemo__argumentInput(v-if="arg.boolean" :name="arg.name" v-on:change="booleanChanged")
        option(:value="0") No
        option(:value="1") Yes
      input.apiDemo__argumentInput(v-else :name="arg.name" v-on:input="inputChanged")
    div(v-else)
      span.apiDemo__argumentSetTitle(v-if="arg.required") {{arg.name}} (required)
      span.apiDemo__argumentSetTitle(v-else) {{arg.name}}
      APIArgument(v-for="subArg in arg.arguments" v-bind:arg="subArg" :value="value[subArg.name]" v-on:change="subArgChanged($event, subArg.name)")
</template>
<script>
export default {
  name: "APIArgument",
  props: {
    arg: {
      type: Object,
    },
    value: {
      type: [Object, String, Boolean, Array],
    },
  },
  methods: {
    booleanChanged: function(e) {
      this.$emit("change", {
        name: this.arg.name,
        value: e.target.value === "1" ? true : false,
      });
    },
    inputChanged: function(e) {
      this.$emit("change", { name: this.arg.name, value: e.target.value });
    },
    subArgChanged: function(e, argName) {
      let newVals = this.value;
      newVals[argName] = e.value;
      this.$emit("change", { name: this.arg.name, value: newVals });
    },
  },
};
</script>
