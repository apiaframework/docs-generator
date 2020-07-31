<template lang="pug">
  div.demo__argumentInput
    div(v-for="(val, index) in currentValues")
      input.input.demo__arrayInput(v-if="index === 0" :id="id" :value="val" v-on:input="valueInput($event, index)")
      input.input.demo__arrayInput(v-else :value="val" v-on:input="valueInput($event, index)")
    button.demo__addButton(type="button" v-on:click="addValue") Add
</template>
<script>
export default {
  props: {
    name: {
      type: String,
    },
    values: {
      type: Array,
      default: () => [""],
    },
    id: {
      type: String,
      default: "",
    },
  },
  data: function() {
    return {
      currentValues: this.values.length > 0 ? this.values : [""],
    };
  },
  methods: {
    valueInput: function(event, index) {
      this.currentValues[index] = event.target.value;
      this.$emit("change", { name: this.name, value: this.currentValues });
    },
    addValue: function() {
      this.currentValues.push("");
    },
  },
};
</script>
