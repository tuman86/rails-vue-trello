<template>
  <draggable v-model="lists" :options="{group: 'lists'}" class="row dragArea" @end="listMoved">
    <div v-for="(list, index) in lists" class="col-md-3">
      <h3>{{ list.name }}</h3>
      <hr/>

      <div v-for="(card, index) in list.cards" class="card card-body mb-3">
        <h3>{{ card.name }}</h3>
      </div>

      <div class="card card-body">
        <textarea v-model="messages[list.id]" class="form-control"></textarea>
        <button v-on:click="submitMessages(list.id)" class="btn btn-secondary">Add</button>
      </div>

    </div>
  </draggable>
</template>

<script>
import draggable from 'vuedraggable'

export default {
  components: { draggable },

  props: ["original_lists"],

  data: function(){
    return {
      messages: {},
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
    },

    submitMessages: function(list_id){
      var frm_data = new FormData();
      frm_data.append('card[list_id]', list_id);
      frm_data.append('card[name]', this.messages[list_id]);

      Rails.ajax({
        url: "/cards",
        data: frm_data,
        dataType: "json",
        type: 'post',
        beforeSend: () => {
          return true
        },
        success: (data) => {
          const index = this.lists.findIndex(item => item.id == list_id)
          this.lists[index].cards.push(data)
          this.messages[list_id] = undefined

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
</style>
