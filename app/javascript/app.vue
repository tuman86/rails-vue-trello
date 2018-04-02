<template>
  <div id="app" class="row">
    <div v-for="list in original_lists" class="col-md-3">
      <h3>{{ list.name }}</h3>
      <hr/>

      <div v-for="(card, index) in list.cards" class="card card-body">
        <h3>{{ card.name }}</h3>
      </div>

    </div>
  </div>
</template>

<script>
export default {
  props: ["original_lists"],
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
