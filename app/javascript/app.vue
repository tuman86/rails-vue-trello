<template>
  <draggable v-model="lists" :options="{group: 'lists'}" class="board dragArea" @end="listMoved">
    <list  v-for="(list, index) in lists" :list="list"></list>
  </draggable>
</template>

<script>
import draggable from 'vuedraggable'
import list from 'components/list'

export default {
  components: { draggable, list },

  props: ["original_lists"],

  data: function(){
    return {
      lists: this.original_lists
    }
  },

  methods: {
    listMoved: function(event) {
      var list_data = new FormData;
      list_data.append("list[position]", event.newIndex + 1)

      Rails.ajax({
        url: `lists/${this.lists[event.newIndex].id}/move`,
        type: "PATCH",
        dataType: "json",
        data: list_data,
        beforeSend: () => {
          return true
        },
      })
    }
  }
}
</script>

<style scoped>
.dragArea {
  min-height: 20px;
}

.board {
  white-space: nowrap;
  overflow-x: auto;
    display: inline-block;
}
</style>
