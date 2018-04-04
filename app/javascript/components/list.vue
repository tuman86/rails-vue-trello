<template>
  <div class=" list">
    <h3>{{ list.name }}</h3>
    <draggable v-model="list.cards" :options="{group: 'cards'}" class="dragArea" @change="cardMoved">
      <div v-for="(card, index) in list.cards" class="card card-body ">
          <h3>{{ card.name }}</h3>
      </div>
    </draggable>

      <a v-if="!editing" v-on:click="startEditing">Add a card..</a>
      <textarea v-if="editing" ref="message" v-model="message" class="form-control mb-1"></textarea>
      <button v-if="editing" v-on:click="submitMessage" class="btn btn-secondary">Add</button>
      <a v-if="editing" v-on:click="editing=false">Cancel</a>


  </div>
</template>

<script>
  import draggable from 'vuedraggable'

  export default {
    components: { draggable },

    props: ["list"],

    data: function() {
      return {
        editing: false,
        message: ""
      }
    },

    methods: {
      startEditing: function() {
        this.editing = true
        this.$nextTick(() => { this.$refs.message.focus()})
      },
      cardMoved: function(event) {
        const evt = event.added || event.moved
        if (evt == undefined) { return }
        const element = evt.element
        const list_index = window.store.lists.findIndex((list) => {
          return list.cards.find((card) => {
            return card.id === element.id
          })
        })
        var card_data = new FormData
        card_data.append("card[list_id]", window.store.lists[list_index].id)
        card_data.append("card[position]", evt.newIndex + 1)
        Rails.ajax({
          url: `/cards/${element.id}/move`,
          type: "PATCH",
          data: card_data,
          dataType: "json",
          beforeSend: () => {
            return true
          },
        })
      },

      submitMessage: function(){
        var frm_data = new FormData();
        frm_data.append('card[list_id]', this.list.id);
        frm_data.append('card[name]', this.message);

        Rails.ajax({
          url: "/cards",
          data: frm_data,
          dataType: "json",
          type: 'post',
          beforeSend: () => {
            return true
          },
          success: (data) => {
            const index = window.store.lists.findIndex(item => item.id == this.list.id)
            window.store.lists[index].cards.push(data)
            this.message = ""
            this.$nextTick(() => { this.$refs.message.focus()})

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


.list {
  background: #E2E4E6;
  border-radius: 3px;
  display: inline-block;
  vertical-align: top;
  padding: 10px;
  margin-right: 20px;
  width: 270px;
}

.card {
  background: #fff;
}
</style>
