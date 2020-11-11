<template>
  <div class="deploy">
    <Deploy></Deploy>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import Deploy from "@/components/Deploy.vue";
export default defineComponent({
  name: "DeployView",
  components: {
    Deploy
  }
});
</script>
