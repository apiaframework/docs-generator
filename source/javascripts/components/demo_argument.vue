<template lang="pug">
  div.demo__argumentContainer
    div.demo__argument(v-if="!arg.arguments")
      label.demo__argumentLabel(:for="arg.name" v-if="arg.required") {{arg.name}} (required)
      label.demo__argumentLabel(:for="arg.name" v-else) {{arg.name}}
      select.demo__argumentInput(v-if="arg.boolean" :name="arg.name" v-on:change="booleanChanged")
        option(:value="0") No
        option(:value="1") Yes
      input.demo__argumentInput(v-else :name="arg.name" v-on:input="inputChanged")
    div(v-else)
      span.demo__argumentSetTitle(v-if="arg.required") {{arg.name}} (required)
      span.demo__argumentSetTitle(v-else) {{arg.name}}
      DemoArgument(v-for="subArg in arg.arguments" v-bind:arg="subArg" :value="value[subArg.name]" v-on:change="subArgChanged($event, subArg.name)")
</template>
<script>
export default {
  name: "DemoArgument",
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
