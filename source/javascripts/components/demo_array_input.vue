<template lang="pug">
  div.demo__argumentInput
    div.demo__arrayArgument(v-for="(val, index) in currentValues")
      input.input.demo__arrayInput(v-if="index === 0" :id="id" :value="val" v-on:input="valueInput($event, index)")
      input.input.demo__arrayInput(v-else :value="val" v-on:input="valueInput($event, index)")
      button.button__icon.demo__removeButton(v-if="index !== 0 || currentValues.length > 1" type="button" v-on:click="removeValue(index)")
    button.button.button__small(type="button" v-on:click="addValue") +
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
      currentValues: this.values ? this.values : [""],
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
    removeValue: function(index) {
      this.currentValues.splice(index, 1);
    },
  },
};
</script>
