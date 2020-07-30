import Vue from "vue";
import Demo from "./demo.vue";

window.addEventListener("load", () => {
  const node = document.querySelector("#demo");

  if (node) {
    let props = {};

    node.querySelectorAll("property").forEach((propNode) => {
      if (propNode.getAttribute("type") === "json") {
        props[propNode.getAttribute("name")] = JSON.parse(propNode.textContent);
      } else {
        props[propNode.getAttribute("name")] = propNode.textContent;
      }
    });

    new Vue({
      el: node,
      render: (c) =>
        c(Demo, {
          props: props,
        }),
    });
  }
});
