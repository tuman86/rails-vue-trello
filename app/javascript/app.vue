<template>
  <draggable v-model="lists" :options="{group: 'lists'}" class="board dragArea" @end="listMoved">
    <list  v-for="(list, index) in lists" :list="list"></list>
    <div class="list">
      <a v-if="!editing" v-on:click="startEditing">Add a List..</a>
      <textarea v-if="editing" ref="message" v-model="message" class="form-control mb-1"></textarea>
      <button v-if="editing" v-on:click="createList" class="btn btn-secondary">Add</button>
      <a v-if="editing" v-on:click="editing=false">Cancel</a>
    </div>
  </draggable>
</template>

<script>
import draggable from 'vuedraggable'
import list from 'components/list'

export default {
  components: { draggable, list },

  computed: {
    lists: function() {
      return this.$store.state.lists;
    }
  },

  data: function(){
    return {
      lists: this.$store.state.lists,
      editing: false,
      message: ""
    }
  },

  methods: {
    startEditing: function() {
      this.editing = true
      this.$nextTick(() => { this.$refs.message.focus()})
    },

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
    },

    createList: function(){
      var frm_data = new FormData();
      frm_data.append('list[name]', this.message);

      Rails.ajax({
        url: "/lists",
        data: frm_data,
        dataType: "json",
        type: 'post',
        beforeSend: () => {
          return true
        },
        success: (data) => {
          //this.$store.commit('addList', data)
          this.message = ""
          this.editing=false
        },
        error: function(jqXHR, textStatus, errorThrown){
          console.log(errorThrown)
        }
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


.list {
  background: #E2E4E6;
  border-radius: 3px;
  display: inline-block;
  vertical-align: top;
  padding: 10px;
  margin-right: 20px;
  width: 270px;
}
</style>
